report 50005 "Process Sales Invoice"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Sales Invoice Header Staging"; "Sales Invoice Header Staging")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            var
                RecTransferReceiptConfHdr: Record "Transfer Receipt Confirmation";
            begin
                if not GuiAllowed then begin
                    Clear(RecTransferReceiptConfHdr);
                    RecTransferReceiptConfHdr.SetRange("Transfer-From Code", "Sales Invoice Header Staging"."Location Code");
                    RecTransferReceiptConfHdr.SetRange("Posting Date", "Sales Invoice Header Staging"."Posting Date");
                    if not RecTransferReceiptConfHdr.FindFirst() then
                        CurrReport.Skip()
                    else
                        if not (RecTransferReceiptConfHdr.Status = RecTransferReceiptConfHdr.Status::Synced) then
                            CurrReport.Skip();
                end;

                ClearLastError();
                Commit();
                if Codeunit.Run(Codeunit::"Process Sales Invoice", "Sales Invoice Header Staging") then begin
                    "Sales Invoice Header Staging".Status := "Sales Invoice Header Staging".Status::Synced;
                    "Sales Invoice Header Staging"."Sales Invoice No." := "Sales Invoice Header Staging"."No.";
                    "Sales Invoice Header Staging"."Error Remarks" := '';
                    "Sales Invoice Header Staging".Modify();
                    AssignLotNumbers("Sales Invoice Header Staging", "Sales Invoice Header Staging"."No.");
                end else begin
                    "Sales Invoice Header Staging".Status := "Sales Invoice Header Staging".Status::Error;
                    "Sales Invoice Header Staging"."Sales Invoice No." := '';
                    "Sales Invoice Header Staging"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                    "Sales Invoice Header Staging".Modify();
                    SendNotification("Sales Invoice Header Staging");
                end;
            end;

            trigger OnPreDataItem()
            begin
                if not GuiAllowed then
                    SetRange("Posting Date", WorkDate());
            end;
        }
    }

    procedure ValidateRecord(var Header: Record "Sales Invoice Header Staging")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure AssignLotNumbers(var salesInvHdrStaging: Record "Sales Invoice Header Staging"; DocumentNo: Code[20])
    var
        RecSalesLine: Record "Sales Line";
        AssignLOT: Codeunit AssignLotNoToSalesLines;
        SalesHdr: Record "Sales Header";
    begin
        ClearLastError();
        Clear(RecSalesLine);
        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Invoice);
        RecSalesLine.SetRange("Document No.", DocumentNo);
        if RecSalesLine.FindSet() then begin
            ClearLastError();
            Commit();
            AssignLOT.SetHideDialogueBox(true);
            if AssignLOT.Run(RecSalesLine) then begin
                Clear(SalesHdr);
                SalesHdr.SetRange("Document Type", SalesHdr."Document Type"::Invoice);
                SalesHdr.SetRange("No.", DocumentNo);
                if SalesHdr.FindFirst() then begin
                    ClearLastError();
                    Commit();
                    if Codeunit.Run(Codeunit::"Sales-Post", SalesHdr) then begin
                        salesInvHdrStaging.Status := salesInvHdrStaging.Status::Posted;
                        salesInvHdrStaging."Error Remarks" := '';
                        salesInvHdrStaging.Modify();
                    end else begin
                        salesInvHdrStaging.Status := salesInvHdrStaging.Status::"Posting Error";
                        salesInvHdrStaging."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                        salesInvHdrStaging.Modify();
                        SendNotification(salesInvHdrStaging);
                    end;
                end else begin
                    salesInvHdrStaging.Status := salesInvHdrStaging.Status::Error;
                    salesInvHdrStaging."Error Remarks" := StrSubstNo('Sales Header %1 does not exists.', salesInvHdrStaging."Sales Invoice No.");
                    salesInvHdrStaging.Modify();
                    SendNotification(salesInvHdrStaging);
                end;
            end else begin
                salesInvHdrStaging.Status := salesInvHdrStaging.Status::Error;
                salesInvHdrStaging."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                salesInvHdrStaging.Modify();
                SendNotification(salesInvHdrStaging);
            end;
        end else begin
            salesInvHdrStaging.Status := salesInvHdrStaging.Status::Error;
            salesInvHdrStaging."Error Remarks" := StrSubstNo('Sales Line % does not exists.', salesInvHdrStaging."Sales Invoice No.");
            salesInvHdrStaging.Modify();
            SendNotification(salesInvHdrStaging);
        end;
    end;

    local procedure SendNotification(var StagingHdr: Record "Sales Invoice Header Staging")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."No."), 'Sales Invoice', StagingHdr."No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Sales Invoice Card Staging", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    procedure DeleteSalesInvoiceAndSetStatusToReady(var Header: Record "Sales Invoice Header Staging")
    var
        RecSalesHeader: Record "Sales Header";
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField("Sales Invoice No.");
                if (Header.Status = Header.Status::Posted) OR (Header.Status = Header.Status::Synced) then
                    Error('Status of the selected record must not be Posted or Synced.');
                Clear(RecSalesHeader);
                RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Invoice);
                RecSalesHeader.SetRange("No.", Header."Sales Invoice No.");
                if RecSalesHeader.FindFirst() then begin
                    RecSalesHeader.SetHideValidationDialog(true);
                    RecSalesHeader.Delete(True);
                    Header."Sales Invoice No." := '';
                    Header."Error Remarks" := '';
                    Header.Status := Header.Status::"Ready To Sync";
                    Header.Modify();
                end else
                    Error('Sales Invoice Does not exists in the Table Sales Header.');
            until Header.Next() = 0;
        end;
    end;

    var
        Subject: Label 'Mirnah - InBound - Sales Invoice - %1';
}