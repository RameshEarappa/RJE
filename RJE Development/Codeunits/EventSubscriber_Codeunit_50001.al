codeunit 50001 EventSubscriber
{
    trigger OnRun()
    begin

    end;



    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterInsertEvent', '', false, false)]
    procedure UpdateGDNumber(var Rec: Record "Dimension Value"; RunTrigger: Boolean)
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        Rec."Global Dimension No." := DimMgt.GetGlobalDimensionNo_LT(Rec."Dimension Code");
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterModifyEvent', '', false, false)]
    procedure UpdateGDNumber2(var xRec: Record "Dimension Value"; var Rec: Record "Dimension Value"; RunTrigger: Boolean)
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        Rec."Global Dimension No." := DimMgt.GetGlobalDimensionNo_LT(Rec."Dimension Code");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnShowDocDimOnBeforeUpdateSalesLines', '', false, false)]
    procedure UpdateCustomDimensions(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    Var
        RecDimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesHeader."Dimension Set ID" <> xSalesHeader."Dimension Set ID" then begin
            GLSetup.Get();
            Clear(RecDimSetEntry);
            If RecDimSetEntry.Get(SalesHeader."Dimension Set ID", GLSetup."Shortcut Dimension 3 Code") then
                SalesHeader."Sales Channel Type" := RecDimSetEntry."Dimension Value Code"
            Else
                SalesHeader."Sales Channel Type" := '';
            Clear(RecDimSetEntry);
            if RecDimSetEntry.Get(SalesHeader."Dimension Set ID", GLSetup."Sales Order Type") then
                SalesHeader."Sales Order Type" := RecDimSetEntry."Dimension Value Code"
            else
                SalesHeader."Sales Order Type" := '';
        end
    end;

    /* [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterInsertEvent', '', false, false)]
     procedure UpdatedCustomDimenionFields(var Rec: Record "Default Dimension"; RunTrigger: Boolean)
     Var
         DimMgt: Codeunit DimensionMgmt_LT;
     begin
         DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", Rec."Dimension Value Code");
     end;*/

    /// instead of Table using Page event
    [EventSubscriber(ObjectType::Page, Page::"Default Dimensions", 'OnInsertRecordEvent', '', false, false)]
    procedure UpdatedCustomDimenionFields(var Rec: Record "Default Dimension")
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", Rec."Dimension Value Code");
    end;

    /*[EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterModifyEvent', '', false, false)]
    procedure ModifyCustomDimenionFields(var xRec: Record "Default Dimension"; var Rec: Record "Default Dimension"; RunTrigger: Boolean)
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        if Rec."Dimension Value Code" <> xRec."Dimension Value Code" then
            DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", Rec."Dimension Value Code");
    end;*/

    [EventSubscriber(ObjectType::Page, Page::"Default Dimensions", 'OnModifyRecordEvent', '', false, false)]
    procedure ModifyCustomDimenionFields(var xRec: Record "Default Dimension"; var Rec: Record "Default Dimension")
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        if Rec."Dimension Value Code" <> xRec."Dimension Value Code" then
            DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", Rec."Dimension Value Code");
    end;

    /*[EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterDeleteEvent', '', false, false)]
    procedure DeleteCustomDimenionFields(var Rec: Record "Default Dimension"; RunTrigger: Boolean)
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", '');
    end;*/
    [EventSubscriber(ObjectType::Page, Page::"Default Dimensions", 'OnDeleteRecordEvent', '', false, false)]
    procedure DeleteCustomDimenionFields(var Rec: Record "Default Dimension")
    Var
        DimMgt: Codeunit DimensionMgmt_LT;
    begin
        DimMgt.UpdateCustomDimensionCode(Rec."Dimension Code", Rec."Table ID", Rec."No.", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line");

    begin
        GLEntry."Check No." := GenJournalLine."Check No.";
        GLEntry."Check Date" := GenJournalLine."Check Date";
        GLEntry.Narration := GenJournalLine.Narration;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', FALSE, FALSE)]
    procedure OnAfterInitCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."Check No." := GenJournalLine."Check No.";
        CustLedgerEntry."Check Date" := GenJournalLine."Check Date";
        CustLedgerEntry.Narration := GenJournalLine.Narration;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', FALSE, FALSE)]
    procedure OnAfterInitVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."Check No." := GenJournalLine."Check No.";
        VendorLedgerEntry."Check Date" := GenJournalLine."Check Date";
        VendorLedgerEntry.Narration := GenJournalLine.Narration;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', FALSE, FALSE)]
    procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        BankAccountLedgerEntry."Check No." := GenJournalLine."Check No.";
        BankAccountLedgerEntry."Check Date" := GenJournalLine."Check Date";
        BankAccountLedgerEntry.Narration := GenJournalLine.Narration;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Check Ledger Entry", 'OnAfterCopyFromBankAccLedgEntry', '', FALSE, FALSE)]
    procedure OnAfterCopyFromBankAccLedgEntry(BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                                             var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry."Ref Check No." := BankAccountLedgerEntry."Check No.";
        CheckLedgerEntry."Ref Check Date" := BankAccountLedgerEntry."Check Date";
        CheckLedgerEntry.Narration := BankAccountLedgerEntry.Narration;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Payment Registration Buffer", 'OnAfterInsertEvent', '', FALSE, FALSE)]
    procedure OnAfterInsertPaymentRegBufferEvent(var Rec: Record "Payment Registration Buffer")
    VAR
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        IF CustLedgerEntry.GET(Rec."Ledger Entry No.") THEN BEGIN
            Rec."Check No." := CustLedgerEntry."Check No.";
            Rec."Check Date" := CustLedgerEntry."Check Date";
            Rec.Narration := CustLedgerEntry.Narration;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Registration Mgt.", 'OnBeforeGenJnlLineInsert', '', FALSE, FALSE)]
    procedure OnBeforeGenJnlLineInsert(TempPaymentRegistrationBuffer: Record "Payment Registration Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    VAR

    begin
        GenJournalLine."Check No." := TempPaymentRegistrationBuffer."Check No.";
        GenJournalLine."Check Date" := TempPaymentRegistrationBuffer."Check Date";
        GenJournalLine.Narration := TempPaymentRegistrationBuffer.Narration;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Create Payment", 'OnUpdateTempBufferFromVendorLedgerEntry', '', FALSE, FALSE)]
    procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        IF VendorLedgerEntry."On Hold" <> '' THEN
            Error('The Entry with Document No. %1 is on Hold. You cannot apply this entry', VendorLedgerEntry."Document No.");
        TempPaymentBuffer."Check No." := VendorLedgerEntry."Check No.";
        TempPaymentBuffer."Check Date" := VendorLedgerEntry."Check Date";
        TempPaymentBuffer.Narration := VendorLedgerEntry.Narration;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Create Payment", 'OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer', '', FALSE, FALSE)]
    procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(TempPaymentBuffer: Record "Payment Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Check No." := TempPaymentBuffer."Check No.";
        GenJournalLine."Check Date" := TempPaymentBuffer."Check Date";
        GenJournalLine.Narration := TempPaymentBuffer.Narration;
    end;


    //to export Transfer order after posting transfer shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        exportxml: XmlPort "Export Transfer Order";
        RecTransferLine: Record "Transfer Line";
        InStream: InStream;
        Blob: Codeunit "Temp Blob";
        outstr: OutStream;
        TypeHelper: Codeunit "Type Helper";
        Utility: Codeunit "Integration Utility";
        Integrationsetup: Record "Integration Setup";
    begin
        Integrationsetup.Get();
        if not Integrationsetup."Send Transfer Order To SFA" then exit;
        if not TransferHeader."Created By API" then exit;
        Clear(exportxml);
        Clear(Blob);
        Clear(outstr);
        Clear(RecTransferLine);
        RecTransferLine.SetRange("Document No.", TransferHeader."No.");
        RecTransferLine.SetRange("Derived From Line No.", 0);
        if RecTransferLine.FindSet() then begin
            exportxml.SetTableView(RecTransferLine);
            Blob.CreateOutStream(outstr);
            exportxml.SetDestination(outstr);
            exportxml.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendTransferOrderToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnAfterReopenTransferDoc', '', false, false)]
    local procedure OnAfterReopenTransferDoc(var TransferHeader: Record "Transfer Header")
    begin
        TransferHeader.Validate("Workflow Status", TransferHeader."Workflow Status"::Open);
        TransferHeader.Modify();
    end;
    //local procedure OnAfterReopenAssemblyDoc(var AssemblyHeader: Record "Assembly Header")
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Assembly Document", 'OnAfterReopenAssemblyDoc', '', false, false)]
    local procedure OnAfterReopenAssemblyDoc(var AssemblyHeader: Record "Assembly Header")
    begin
        AssemblyHeader.Validate("Workflow Status", AssemblyHeader."Workflow Status"::Open);
        AssemblyHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", 'OnBeforeTempHandlingSpecificationInsert', '', false, false)]
    local procedure OnBeforeTempHandlingSpecificationInsert(var TempHandlingTrackingSpecification: Record "Tracking Specification" temporary; WhseItemTrackingLine: Record "Whse. Item Tracking Line")
    begin
        TempHandlingTrackingSpecification."Production Date" := WhseItemTrackingLine."Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeReleaseTransferDoc', '', false, false)]
    local procedure OnBeforeReleaseTransferDoc(var TransferHeader: Record "Transfer Header")
    begin
        TransferHeader.TestField("Workflow Status", TransferHeader."Workflow Status"::Approved);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptHeader', '', false, false)]
    local procedure OnAfterInsertTransShptHeader(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        TransferShipmentHeader."Created By API" := TransferHeader."Created By API";
        TransferShipmentHeader."Staging Entry No." := TransferHeader."Staging Entry No.";
        TransferShipmentHeader.Confirmed := TransferHeader.Confirmed;
        TransferShipmentHeader."Request Date" := TransferHeader."Request Date";
        TransferShipmentHeader."Salesperson Code" := TransferHeader."Salesperson Code";
        TransferShipmentHeader."Salesperson Name" := TransferHeader."Salesperson Name";
        TransferShipmentHeader."VAN Unloading TO" := TransferHeader."VAN Unloading TO";
        TransferShipmentHeader."Transfer-From Salesperson Code" := TransferHeader."Transfer-From Salesperson Code";
        TransferShipmentHeader."Transfer-From Salesperson Name" := TransferHeader."Transfer-From Salesperson Name";
        TransferShipmentHeader."Mirnah Reference No." := TransferHeader."Mirnah Reference No.";
        TransferShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptHeader', '', false, false)]
    local procedure OnAfterInsertTransRcptHeader(var TransRcptHeader: Record "Transfer Receipt Header"; TransHeader: Record "Transfer Header")
    begin
        TransRcptHeader."Created By API" := TransHeader."Created By API";
        TransRcptHeader."Staging Entry No." := TransHeader."Staging Entry No.";
        TransRcptHeader.Confirmed := TransHeader.Confirmed;
        TransRcptHeader."Request Date" := TransHeader."Request Date";
        TransRcptHeader."Salesperson Code" := TransHeader."Salesperson Code";
        TransRcptHeader."Salesperson Name" := TransHeader."Salesperson Name";
        TransRcptHeader."VAN Unloading TO" := TransHeader."VAN Unloading TO";
        TransRcptHeader."Transfer-From Salesperson Code" := TransHeader."Transfer-From Salesperson Code";
        TransRcptHeader."Transfer-From Salesperson Name" := TransHeader."Transfer-From Salesperson Name";
        TransRcptHeader."Mirnah Reference No." := TransHeader."Mirnah Reference No.";
        TransRcptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnTransferLineOnAfterCreateShptHeader', '', false, false)]
    local procedure OnTransferLineOnAfterCreateShptHeader(var WhseShptHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean; TransferHeader: Record "Transfer Header"; TransferLine: Record "Transfer Line")
    begin
        WhseShptHeader."Created By API" := TransferHeader."Created By API";
        WhseShptHeader."Staging Entry No." := TransferHeader."Staging Entry No.";
        WhseShptHeader.Confirmed := TransferHeader.Confirmed;
        WhseShptHeader."Request Date" := TransferHeader."Request Date";
        WhseShptHeader."Salesperson Code" := TransferHeader."Salesperson Code";
        WhseShptHeader."Salesperson Name" := TransferHeader."Salesperson Name";
        WhseShptHeader."VAN Unloading TO" := TransferHeader."VAN Unloading TO";
        WhseShptHeader.Validate("Shipment Date", TransferHeader."Shipment Date");
        WhseShptHeader."Transfer-From Salesperson Code" := TransferHeader."Transfer-From Salesperson Code";
        WhseShptHeader."Transfer-From Salesperson Name" := TransferHeader."Transfer-From Salesperson Name";
        WhseShptHeader."Mirnah Reference No." := TransferHeader."Mirnah Reference No.";
        WhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnTransferLineOnAfterCreateRcptHeader', '', false, false)]
    local procedure OnTransferLineOnAfterCreateRcptHeader(var WhseReceiptHeader: Record "Warehouse Receipt Header"; WhseHeaderCreated: Boolean; TransferHeader: Record "Transfer Header"; TransferLine: Record "Transfer Line"; WarehouseRequest: Record "Warehouse Request")
    begin
        WhseReceiptHeader."Created By API" := TransferHeader."Created By API";
        WhseReceiptHeader."Staging Entry No." := TransferHeader."Staging Entry No.";
        WhseReceiptHeader.Confirmed := TransferHeader.Confirmed;
        WhseReceiptHeader."Request Date" := TransferHeader."Request Date";
        WhseReceiptHeader."Salesperson Code" := TransferHeader."Salesperson Code";
        WhseReceiptHeader."Salesperson Name" := TransferHeader."Salesperson Name";
        WhseReceiptHeader."VAN Unloading TO" := TransferHeader."VAN Unloading TO";
        WhseReceiptHeader."Transfer-From Salesperson Code" := TransferHeader."Transfer-From Salesperson Code";
        WhseReceiptHeader."Transfer-From Salesperson Name" := TransferHeader."Transfer-From Salesperson Name";
        WhseReceiptHeader."Mirnah Reference No." := TransferHeader."Mirnah Reference No.";
        WhseReceiptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', false, false)]
    local procedure OnAfterCreatePostedShptHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader."Created By API" := WarehouseShipmentHeader."Created By API";
        PostedWhseShptHeader."Staging Entry No." := WarehouseShipmentHeader."Staging Entry No.";
        PostedWhseShptHeader.Confirmed := WarehouseShipmentHeader.Confirmed;
        PostedWhseShptHeader."Request Date" := WarehouseShipmentHeader."Request Date";
        PostedWhseShptHeader."Salesperson Code" := WarehouseShipmentHeader."Salesperson Code";
        PostedWhseShptHeader."Salesperson Name" := WarehouseShipmentHeader."Salesperson Name";
        PostedWhseShptHeader."VAN Unloading TO" := WarehouseShipmentHeader."VAN Unloading TO";
        PostedWhseShptHeader."Transfer-From Salesperson Code" := WarehouseShipmentHeader."Transfer-From Salesperson Code";
        PostedWhseShptHeader."Transfer-From Salesperson Name" := WarehouseShipmentHeader."Transfer-From Salesperson Name";
        PostedWhseShptHeader."Mirnah Reference No." := WarehouseShipmentHeader."Mirnah Reference No.";
        PostedWhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterPostedWhseRcptHeaderInsert', '', false, false)]
    local procedure OnAfterPostedWhseRcptHeaderInsert(var PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        PostedWhseReceiptHeader."Created By API" := WarehouseReceiptHeader."Created By API";
        PostedWhseReceiptHeader."Staging Entry No." := WarehouseReceiptHeader."Staging Entry No.";
        PostedWhseReceiptHeader.Confirmed := WarehouseReceiptHeader.Confirmed;
        PostedWhseReceiptHeader."Request Date" := WarehouseReceiptHeader."Request Date";
        PostedWhseReceiptHeader."Salesperson Code" := WarehouseReceiptHeader."Salesperson Code";
        PostedWhseReceiptHeader."Salesperson Name" := WarehouseReceiptHeader."Salesperson Name";
        PostedWhseReceiptHeader."VAN Unloading TO" := WarehouseReceiptHeader."VAN Unloading TO";
        PostedWhseReceiptHeader."Transfer-From Salesperson Code" := WarehouseReceiptHeader."Transfer-From Salesperson Code";
        PostedWhseReceiptHeader."Transfer-From Salesperson Name" := WarehouseReceiptHeader."Transfer-From Salesperson Name";
        PostedWhseReceiptHeader."Mirnah Reference No." := WarehouseReceiptHeader."Mirnah Reference No.";
        PostedWhseReceiptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]
    local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
        if ((TransHeader."Created By API") AND (IsTransferOrderPostingAllowed = false)) then
            Error('You cannot post VAN Loading Transfer Order directly.');
    end;

    local procedure IsTransferOrderPostingAllowed(): Boolean
    var
        RecUserSetup: Record "User Setup";
    begin
        if RecUserSetup.GET(UserId) then begin
            exit(RecUserSetup."Allow Transfer Order Posting");
        end else
            exit(false);
    end;

    //-------------FOC Implementation---------------------//
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoInSalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
    var
        RecItem: Record Item;
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice] then begin
            if Rec.Type = Rec.Type::Item then begin
                if Rec."No." <> '' then begin
                    If RecItem.GET(Rec."No.") then
                        Rec."FOC Item" := RecItem."FOC Item"
                    else
                        Rec."FOC Item" := FALSE;
                end else
                    Rec."FOC Item" := FALSE;
            end else
                Rec."FOC Item" := FALSE;
        end else
            Rec."FOC Item" := FALSE;
    end;

    //-------------FOC Implementation---------------------//
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean);
    Var
        RecSalesLine: Record "Sales Line";
        IntegrationSetup: Record "Integration Setup";
        RecGenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        VATAmount, Amount, AmountIncVAT : Decimal;
        RecItem: Record Item;
    begin
        if SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then begin
            SalesHeader.CalcFields("FOC Item Exists");
            if not SalesHeader."FOC Item Exists" then exit;
            IntegrationSetup.GET;
            IntegrationSetup.TestFOCFields();
            LineNo := GetLastLineNumberOfJournal();
            Clear(RecSalesLine);
            RecSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            RecSalesLine.SetRange("Document No.", SalesHeader."No.");
            RecSalesLine.SetRange(Type, RecSalesLine.Type::Item);
            RecSalesLine.SetRange("FOC Item", true);
            if RecSalesLine.FindSet() then begin
                repeat
                    RecItem.GET(RecSalesLine."No.");
                    VATAmount := (RecItem."FOC Nominal Cost For VAT calc." * RecSalesLine.Quantity) * IntegrationSetup."Nominal Cost % For VAT Calc." / 100;
                    Amount := RecItem."FOC Nominal Cost For VAT calc." * RecSalesLine.Quantity;
                    AmountIncVAT := VATAmount + Amount;
                    LineNo += 10000;
                    RecGenJnlLine.Init();
                    RecGenJnlLine.Validate("Journal Template Name", IntegrationSetup."Journal Template Name");
                    RecGenJnlLine.Validate("Journal Batch Name", IntegrationSetup."Journal Batch Name");
                    RecGenJnlLine.Validate("Line No.", LineNo);
                    RecGenJnlLine.Validate("Posting Date", SalesHeader."Posting Date");
                    RecGenJnlLine.Validate("Document No.", SalesInvoiceHeader."No." + '-F');
                    RecGenJnlLine.Validate("Account Type", RecGenJnlLine."Account Type"::"G/L Account");
                    RecGenJnlLine.Validate("Account No.", GetVATAccountBasedonCustomerAndItem(SalesHeader."Sell-to Customer No.", RecSalesLine."No."));
                    RecGenJnlLine.Validate("External Document No.", RecSalesLine."No.");
                    RecGenJnlLine.Validate(Amount, -VATAmount);
                    RecGenJnlLine.Validate("Shortcut Dimension 1 Code", RecSalesLine."Shortcut Dimension 1 Code");
                    REcGEnjnlline.VALIDATE("Shortcut Dimension 2 Code", RecSalesLine."Shortcut Dimension 2 Code");
                    REcGEnjnlline.VALIDATE("Dimension Set ID", RecSalesLine."Dimension Set ID");
                    RecGenJnlLine.Insert(true);

                    //Second Line
                    LineNo += 10000;
                    RecGenJnlLine.Init();
                    RecGenJnlLine.Validate("Journal Template Name", IntegrationSetup."Journal Template Name");
                    RecGenJnlLine.Validate("Journal Batch Name", IntegrationSetup."Journal Batch Name");
                    RecGenJnlLine.Validate("Line No.", LineNo);
                    RecGenJnlLine.Validate("Posting Date", SalesHeader."Posting Date");
                    RecGenJnlLine.Validate("Document No.", SalesInvoiceHeader."No." + '-F');
                    RecGenJnlLine.Validate("Account Type", RecGenJnlLine."Account Type"::"G/L Account");
                    RecGenJnlLine.Validate("Account No.", GetSalesGLAccountBasedonCustomerAndItem(SalesHeader."Sell-to Customer No.", RecSalesLine."No."));
                    RecGenJnlLine.Validate("External Document No.", RecSalesLine."No.");
                    RecGenJnlLine.Validate(Amount, -Amount);
                    RecGenJnlLine.Validate("Shortcut Dimension 1 Code", RecSalesLine."Shortcut Dimension 1 Code");
                    REcGEnjnlline.VALIDATE("Shortcut Dimension 2 Code", RecSalesLine."Shortcut Dimension 2 Code");
                    REcGEnjnlline.VALIDATE("Dimension Set ID", RecSalesLine."Dimension Set ID");
                    RecGenJnlLine.Insert(true);

                    //Third Line
                    LineNo += 10000;
                    RecGenJnlLine.Init();
                    RecGenJnlLine.Validate("Journal Template Name", IntegrationSetup."Journal Template Name");
                    RecGenJnlLine.Validate("Journal Batch Name", IntegrationSetup."Journal Batch Name");
                    RecGenJnlLine.Validate("Line No.", LineNo);
                    RecGenJnlLine.Validate("Posting Date", SalesHeader."Posting Date");
                    RecGenJnlLine.Validate("Document No.", SalesInvoiceHeader."No." + '-F');
                    RecGenJnlLine.Validate("Account Type", RecGenJnlLine."Account Type"::"G/L Account");
                    RecGenJnlLine.Validate("Account No.", IntegrationSetup."G/L Account For FOC Jorunal");
                    RecGenJnlLine.Validate("External Document No.", RecSalesLine."No.");
                    RecGenJnlLine.Validate(Amount, AmountIncVAT);
                    RecGenJnlLine.Validate("Shortcut Dimension 1 Code", RecSalesLine."Shortcut Dimension 1 Code");
                    REcGEnjnlline.VALIDATE("Shortcut Dimension 2 Code", RecSalesLine."Shortcut Dimension 2 Code");
                    REcGEnjnlline.VALIDATE("Dimension Set ID", RecSalesLine."Dimension Set ID");
                    RecGenJnlLine.Insert(true);
                until RecSalesLine.Next() = 0;
            end;
            PostGeneralJournal(RecGenJnlLine);
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure PopulateMirnahReferenceNumber(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    var
        RecTransferHdr: Record "Transfer Header";
    begin
        if RecTransferHdr.GET(Rec."Document No.") then
            Rec.Validate("Mirnah Reference No.", RecTransferHdr."Mirnah Reference No.");
    end;

    local procedure GetLastLineNumberOfJournal(): Integer
    var
        RecgenjnlLine: Record "Gen. Journal Line";
        IntegrationSetup: Record "Integration Setup";
    begin
        IntegrationSetup.GET;
        RecgenjnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        RecgenjnlLine.SetRange("Journal Template Name", IntegrationSetup."Journal Template Name");
        RecgenjnlLine.SetRange("Journal Batch Name", IntegrationSetup."Journal Batch Name");
        if RecgenjnlLine.FindLast() then
            exit(RecgenjnlLine."Line No.")
        else
            exit(0);

    end;

    local procedure GetVATAccountBasedonCustomerAndItem(CustNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        RecVATPostingSetup: Record "VAT Posting Setup";
        RecCust: Record Customer;
        RecItem: Record Item;
    begin
        RecCust.GET(CustNo);
        RecCust.TestField("VAT Bus. Posting Group");
        RecItem.GET(ItemNo);
        RecItem.TestField("VAT Prod. Posting Group");
        Clear(RecVATPostingSetup);
        RecVATPostingSetup.SetRange("VAT Bus. Posting Group", RecCust."VAT Bus. Posting Group");
        RecVATPostingSetup.SetRange("VAT Prod. Posting Group", RecItem."VAT Prod. Posting Group");
        RecVATPostingSetup.FindFirst();
        RecVATPostingSetup.TestField("Sales VAT Account");
        exit(RecVATPostingSetup."Sales VAT Account");
    end;

    local procedure GetSalesGLAccountBasedonCustomerAndItem(CustNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        RecGenPostingSetup: Record "General Posting Setup";
        RecCust: Record Customer;
        RecItem: Record Item;
    begin
        RecCust.GET(CustNo);
        RecCust.TestField("Gen. Bus. Posting Group");
        RecItem.GET(ItemNo);
        RecItem.TestField("Gen. Prod. Posting Group");
        Clear(RecGenPostingSetup);
        RecGenPostingSetup.SetRange("Gen. Bus. Posting Group", RecCust."Gen. Bus. Posting Group");
        RecGenPostingSetup.SetRange("Gen. Prod. Posting Group", RecItem."Gen. Prod. Posting Group");
        RecGenPostingSetup.FindFirst();
        RecGenPostingSetup.TestField("Sales Account");
        exit(RecGenPostingSetup."Sales Account");
    end;

    local procedure GETAmountForJournal(Qty: Decimal; ItemNo: Code[20]; VATPercentage: Decimal): Decimal
    var
        RecItem: Record Item;
    begin
        RecItem.GET(ItemNo);
        exit((RecItem."FOC Nominal Cost For VAT calc." * Qty) * VATPercentage / 100)
    end;

    local procedure PostGeneralJournal(var RecGenjlnLine: Record "Gen. Journal Line")
    begin
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", RecGenjlnLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PostSales-Delete", 'OnBeforeDeleteHeader', '', false, false)]
    local procedure OnBeforeDeleteHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesInvoiceHeaderPrepmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Created by API" then begin
            IsHandled := true;
        end
    end;

    //28.07.2021
    procedure CheckMultipleItem(TransferHeader: Record "Transfer Header")
    var
        TransferLineL: Record "Transfer Line";
        PreviousItemNo: Code[20];
        CheckItem: List of [Text];
    begin
        Clear(CheckItem);
        TransferLineL.SetCurrentKey("Document No.", "Item No.");
        TransferLineL.SetRange("Document No.", TransferHeader."No.");
        TransferLineL.SetRange("Derived From Line No.", 0);//21.10.2021
        if TransferLineL.FindSet() then
            repeat
                TransferLineL.TestField("Item No.");
                TransferLineL.TestField(Quantity);
                if not CheckItem.Contains(TransferLineL."Item No.") then begin
                    CheckItem.Add(TransferLineL."Item No.")
                end else
                    Error('There are multiple line for an item, You cannot send approval request');
            until TransferLineL.Next() = 0;
    end;
    //28.07.2021

    var
        myInt: Integer;
}