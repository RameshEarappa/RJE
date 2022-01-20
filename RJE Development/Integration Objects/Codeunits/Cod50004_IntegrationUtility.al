codeunit 50004 "Integration Utility"
{
    Permissions = tabledata 6550 = RIMD;
    trigger OnRun()
    begin

    end;

    procedure InsertLog(IntegrationType: Enum "Integration Type"; IntegrationFn: Enum "Integration Function"; RequestData: Text; URL: Text): Integer
    var
        EntryNo: Integer;
        RecLog: Record "Integration Log Register";
    begin
        Clear(RecLog);
        if RecLog.FindLast() then
            EntryNo := RecLog."Entry No." + 1
        else
            EntryNo := 1;
        RecLog.Init();
        RecLog."Entry No." := EntryNo;
        RecLog."Integration Type" := IntegrationType;
        RecLog."Integration Function" := IntegrationFn;
        RecLog.SetRequestData(RequestData);
        RecLog."Request Time" := CurrentDateTime;
        RecLog.URL := URL;
        RecLog.Status := RecLog.Status::Failed;
        RecLog.Insert();
        exit(EntryNo);
    end;

    procedure ModifyLog(EntryNo: Integer; Status: Option " ",Success,Failed; ErrorText: Text; Response: Text)
    var
        RecLog: Record "Integration Log Register";
    begin
        If RecLog.GET(EntryNo) then begin
            RecLog.SetResponseData(Response);
            RecLog.Status := Status;
            RecLog."Error Text" := ErrorText;
            RecLog."Response Time" := CurrentDateTime;
            RecLog.Modify();
            if Status = Status::Failed then
                SendNotification(RecLog, FORMAT(RecLog."Integration Function"), GetSubject(RecLog."Integration Function"), Response);
        end;
    end;

    local procedure SendNotification(var StagingHdr: Record "Integration Log Register"; FunctionName: text; Subject: Text; ErrorText: Text)
    var
        SendNotification: Codeunit "Send Notification";
    begin
        SendNotification.InitializeValues(Subject, FunctionName, '', ErrorText, GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Integration Log Card", StagingHdr, false));
        Commit;
        if SendNotification.RUN then;
    end;

    local procedure GetSubject(IntegrationFn: Enum "Integration Function"): Text
    begin
        case IntegrationFn of
            IntegrationFn::"Export Customer Invoice":
                exit('Mirnah - OutBound - Open Invoices');
            IntegrationFn::"Export Customer Price List":
                exit('Mirnah - OutBound - Sales Price Master');
            IntegrationFn::"Export Customers":
                exit('Mirnah - OutBound - Customer Master');
            IntegrationFn::"Export Items":
                exit('Mirnah - OutBound - Item Master');
            IntegrationFn::"Export Salesperson":
                exit('Mirnah - OutBound - Salesperson Master');
            IntegrationFn::"Export Stock Inventory":
                exit('Mirnah - OutBound - Stock Inventory');
            IntegrationFn::"Export Transfer Order - Dispatch":
                exit('Mirnah - OutBound - Van Loading');
            IntegrationFn::"Export Warehouse Location":
                exit('Mirnah - OutBound - WH Master')
        end;
    end;

    procedure SendTransferOrderToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        RecIntgrationSetup.TestField("Load Master URL");
        RecIntgrationSetup.TestField("Access Key");
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Transfer Order - Dispatch", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Load Master URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Load Master URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Load has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure CreateItemTrackingLinesForWhseJln(var RecWhseJln: Record "Warehouse Journal Line")
    var
        RecWhseItemTrackingLine: Record "Whse. Item Tracking Line";
        EntryNo: Integer;
    begin
        Clear(RecWhseItemTrackingLine);
        RecWhseItemTrackingLine.SetCurrentKey("Entry No.");
        if RecWhseItemTrackingLine.FindLast() then
            EntryNo := RecWhseItemTrackingLine."Entry No."
        else
            EntryNo := 0;
        if RecWhseJln.FindSet() then begin
            repeat
                Clear(RecWhseItemTrackingLine);
                RecWhseItemTrackingLine.SetRange("Item No.", RecWhseJln."Item No.");
                RecWhseItemTrackingLine.SetRange("Source Ref. No.", RecWhseJln."Line No.");
                RecWhseItemTrackingLine.SetRange("Source ID", RecWhseJln."Journal Batch Name");
                RecWhseItemTrackingLine.SetRange("Source Batch Name", RecWhseJln."Journal Template Name");
                if RecWhseItemTrackingLine.FindFirst() then
                    Error('Tracking Line already exits for Item No. %1 , Line No. %2', RecWhseJln."Item No.", RecWhseJln."Line No.");
                Clear(RecWhseItemTrackingLine);
                RecWhseItemTrackingLine.Init();
                EntryNo += 1;
                RecWhseItemTrackingLine."Entry No." := EntryNo;
                RecWhseItemTrackingLine.Validate("Item No.", RecWhseJln."Item No.");
                RecWhseItemTrackingLine.Validate("Location Code", RecWhseJln."Location Code");
                RecWhseItemTrackingLine.Validate("Quantity (Base)", RecWhseJln.Quantity);
                RecWhseItemTrackingLine.Validate("Production Date", RecWhseJln."C Production Date");
                RecWhseItemTrackingLine.Validate("Lot No.", RecWhseJln."C Lot No.");
                RecWhseItemTrackingLine.Validate("Expiration Date", RecWhseJln."C Expiration Date");
                RecWhseItemTrackingLine.Validate("Source ID", RecWhseJln."Journal Batch Name");
                RecWhseItemTrackingLine.Validate("Source Batch Name", RecWhseJln."Journal Template Name");
                RecWhseItemTrackingLine.Validate("Source Type", Database::"Warehouse Journal Line");
                RecWhseItemTrackingLine.Validate("Source Ref. No.", RecWhseJln."Line No.");
                RecWhseItemTrackingLine.Insert(true);
            until RecWhseJln.Next() = 0;
            Message('Item Tracking Lines has been created.');
        end
    end;

    procedure ValidateCustomer(Var RecCust: Record Customer)
    begin
        if RecCust.FindSet() then begin
            repeat
                RecCust.TestField("Payment Terms Code");
                RecCust.TestField("Payment Method Code");
                RecCust.TestField("Customer Price Group");
            until RecCust.Next() = 0;
        end
        //Rec.TestField("Drop Size");

    end;

    procedure ValidateAssemblyOrderBeforeSendForApproval(Var RecAssemblyOrder: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        InvtSetup: Record "Inventory Setup";
        Text001: Label 'There is nothing to approve for %1 %2.', Comment = '%1 = Document Type, %2 = No.';
    begin
        AssemblyLine.SetRange("Document Type", RecAssemblyOrder."Document Type");
        AssemblyLine.SetRange("Document No.", RecAssemblyOrder."No.");
        AssemblyLine.SetFilter(Type, '<>%1', AssemblyLine.Type::" ");
        AssemblyLine.SetFilter(Quantity, '<>0');
        if not AssemblyLine.Find('-') then
            Error(Text001, RecAssemblyOrder."Document Type", RecAssemblyOrder."No.");

        CheckTrackingLinesForAssemblyOrder(RecAssemblyOrder);

    end;

    local procedure CheckTrackingLinesForAssemblyOrder(var Hdr: Record "Assembly Header")
    var
        RecReservationEntry: Record "Reservation Entry";
        Lines: Record "Assembly Line";
        InvtSetup: Record "Inventory Setup";
        MissingTrackingLinesErrorH: Label 'You must assign the Lot No. for Assembly Order %1, Item No. %2';
        MissingTrackingLinesErrorL: Label 'You must assign the Lot No. for Assembly Order %1, Item No. %2, Line No. %3.';
    begin
        Clear(RecReservationEntry);
        RecReservationEntry.SetRange("Source Type", Database::"Assembly Header");
        RecReservationEntry.SetRange("Source Subtype", RecReservationEntry."Source Subtype"::"1");
        RecReservationEntry.SetRange("Source ID", Hdr."No.");
        RecReservationEntry.SetRange(Positive, true);
        if not RecReservationEntry.FindFirst() then
            Error(StrSubstNo(MissingTrackingLinesErrorH, Hdr."No.", Hdr."Item No."));

        InvtSetup.Get();
        Clear(Lines);
        Lines.SetRange("Document No.", Hdr."No.");
        Lines.SetRange(Type, Lines.Type::Item);
        if Lines.FindSet() then begin
            repeat
                if Lines.IsInventoriableItem() then begin
                    if InvtSetup."Location Mandatory" then
                        Lines.TestField("Location Code");
                    Clear(RecReservationEntry);
                    RecReservationEntry.SetRange("Source Type", Database::"Assembly Line");
                    RecReservationEntry.SetRange("Source Subtype", RecReservationEntry."Source Subtype"::"1");
                    RecReservationEntry.SetRange("Source ID", Hdr."No.");
                    RecReservationEntry.SetRange("Source Ref. No.", Lines."Line No.");
                    RecReservationEntry.SetRange(Positive, false);
                    if not RecReservationEntry.FindFirst() then
                        Error(StrSubstNo(MissingTrackingLinesErrorL, Hdr."No.", Lines."No.", Lines."Line No."));
                end;
            until Lines.Next() = 0;
        end

    end;

    procedure SendWarehsoueStockToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        RecIntgrationSetup.TestField("Warehosue Stock URL");
        RecIntgrationSetup.TestField("Access Key");
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Stock Inventory", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Warehosue Stock URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Warehosue Stock URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Warehosue Stock has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure GetBinCodeFilter(): Text
    var
        RecBin: Record Bin;
        Bin: Record Bin;
        BinList: List of [Text];
        Bins: TextBuilder;
    begin
        Clear(RecBin);
        RecBin.SetRange("Good For Sales", true);
        if RecBin.FindSet() then begin
            repeat
                if not BinList.Contains(RecBin.Code) then begin
                    BinList.Add(RecBin.Code);
                    Bins.Append(RecBin.Code + '|');
                end;
            until RecBin.Next() = 0;
            Exit(CopyStr(Bins.ToText(), 1, Bins.Length - 1));
        end else
            exit('');
    end;

    procedure SendOpenInvoiceToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        RecIntgrationSetup.TestField("Open Invoices URL");
        RecIntgrationSetup.TestField("Access Key");
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Customer Invoice", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Open Invoices URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Open Invoices URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Open Invoice has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure SendCustomersToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Customers", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Customer Master URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Customer Master URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Customer has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure SendItemsToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Items", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Item Master URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Item Master URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Items has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure SendLocationsToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Warehouse Location", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Warehouse Master URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Warehouse Master URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Warehouse has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure SendSalespersonToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        Clear(LogEntryNo);
        LogEntryNo := InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Salesperson", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Salesman Master URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Salesman Master URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Salesman has been sent to SFA successfully.');
            end else begin
                ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    procedure SendSalesPriceToSFA(BodyText: Text; ShowMessage: Boolean): Text
    var
        RecIntgrationSetup: Record "Integration Setup";
        RecIntegrationLog: Record "Integration Log Register";
        Intgration: Codeunit "Invoke Service";
        FunctionEnum: Enum "Integration Function";
        TypeEnum: Enum "Integration Type";
        Utility: Codeunit "Integration Utility";
        LogEntryNo: Integer;
        Status: Option " ",Success,Failed;
        IsSuccess: Boolean;
        Response: Text;
    begin
        RecIntgrationSetup.Get;
        RecIntgrationSetup.TestField("Sales Price URL");
        RecIntgrationSetup.TestField("Access Key");
        Clear(LogEntryNo);
        LogEntryNo := Utility.InsertLog(TypeEnum::"BC To SFA", FunctionEnum::"Export Customer Price List", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText), RecIntgrationSetup."Sales Price URL");
        ClearLastError();
        Commit();
        Intgration.SetIntegrationFunction(FunctionEnum::"Invoke Webservice");
        Intgration.SetWebseriveProperties(RecIntgrationSetup."Sales Price URL", StrSubstNo(RecIntgrationSetup.GetSoapEnvelop(), RecIntgrationSetup."Access Key", BodyText));
        if Intgration.Run() then begin
            Intgration.GetResponse(IsSuccess, Response);
            if IsSuccess then begin
                Utility.ModifyLog(LogEntryNo, Status::Success, '', Response);
                if ShowMessage then
                    Message('Selected Price Group has been sent to SFA successfully.');
            end else begin
                Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(Response, 1, 250), Response);
                if ShowMessage then
                    Message('Something went wrong while connecting SFA. Please check Log Register.');
            end;
        end else begin
            Utility.ModifyLog(LogEntryNo, Status::Failed, CopyStr(GetLastErrorText, 1, 250), GetLastErrorText);
            if ShowMessage then
                Message('Something went wrong while connecting SFA. Please check Log Register.');
        end;
    end;

    var
        myInt: Integer;
}