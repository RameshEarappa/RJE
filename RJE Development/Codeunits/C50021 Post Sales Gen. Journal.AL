/// <summary>
/// Codeunit Post Sales Gen. Journal (ID 50016).
/// </summary>
/*
codeunit 50021 "Post Sales Gen. Journal"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', true, true)]
    local procedure "Sales-Post_OnAfterFinalizePostingOnBeforeCommit"
    (
        var SalesHeader: Record "Sales Header";
        var SalesShipmentHeader: Record "Sales Shipment Header";
        var SalesInvoiceHeader: Record "Sales Invoice Header";
        var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        var ReturnReceiptHeader: Record "Return Receipt Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        CommitIsSuppressed: Boolean;
        PreviewMode: Boolean;
        WhseShip: Boolean;
        WhseReceive: Boolean
    )
    begin
        if not PreviewMode then begin
            TempSalesInvHeader := SalesInvoiceHeader;
            TempSalesInvHeader.Insert();
            if Customer.get(TempSalesInvHeader."Sell-to Customer No.") then;
            PostGneralJoyrnal_Sales_Order_Inv;
            TempSalesInvHeader.DeleteAll();
        end;
    end;

    local procedure PostGneralJoyrnal_Sales_Order_Inv()
    begin

        IntgrationSetup.Get();
        IntgrationSetup.TestField("Journal Templ. Name For Sales");
        IntgrationSetup.TestField("Journal Batch Name For Sales");
        IntgrationSetup.TestField("Cr. VAT Output % ");
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", IntgrationSetup."Journal Templ. Name For Sales");
        GenJournalLine.SetRange("Journal Batch Name", IntgrationSetup."Journal Batch Name For Sales");
        GenJournalLine.DeleteAll();
        SalesInvLine1.Reset();
        SalesInvLine1.SetRange("Document No.", TempSalesInvHeader."No.");
        SalesInvLine1.SetRange(Type, SalesInvLine1.Type::Item);
        SalesInvLine1.SetFilter("Line Discount Amount", '>%1', 0);
        if SalesInvLine1.FindFirst() then begin
            repeat
                TempSalesInvLine := SalesInvLine1;
                TempSalesInvLine.Insert();
            until SalesInvLine1.next = 0;
        end;
        if TempSalesInvLine.FindSet(true) then begin
            repeat
                Item.Reset();
                Item.SetRange("No.", TempSalesInvLine."No.");
                Item.SetRange(Discount, true);
                Item.setfilter("FOC Nominal Cost For VAT calc.", '>%1', 0);
                if Item.FindFirst() then begin
                    Insert_SalesCreditRevenueLine(TempSalesInvLine);
                    Insert_SalesCreditVATOutput(TempSalesInvLine);
                    Insert_SalesDebitVATAmount(TempSalesInvLine);
                    PostGenJournalLine;
                end;
            until TempSalesInvLine.next = 0;
        end;
        TempSalesInvLine.DeleteAll();
    end;

    local procedure Insert_SalesCreditRevenueLine(var TempSalesInvLine: Record "Sales Invoice Line")
    begin
        GeneralPostingSetup.get(Customer."Gen. Bus. Posting Group", Item."Gen. Prod. Posting Group");
        Clear(GenJournalLine);
        Clear(CreditRevenue);
        GenJournalLine.LockTable();
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := IntgrationSetup."Journal Templ. Name For Sales";
        GenJournalLine."Journal Batch Name" := IntgrationSetup."Journal Batch Name For Sales";
        GenJournalLine."Line No." := GetLastLineNo;
        GenJournalLine."Document No." := TempSalesInvLine."Document No." + '-D';
        GenJournalLine."External Document No." := TempSalesInvLine."No.";
        GenJournalLine."Posting Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.Validate("Account No.", GeneralPostingSetup."Sales Account");
        GenJournalLine."Due Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Document Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine.Validate("Shortcut Dimension 1 Code", TempSalesInvLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate("Shortcut Dimension 2 Code", TempSalesInvLine."Shortcut Dimension 2 Code");
        GenJournalLine.validate("Dimension Set ID", TempSalesInvLine."Dimension Set ID");
        GenJournalLine.Validate("Credit Amount", (TempSalesInvLine.Quantity * Item."FOC Nominal Cost For VAT calc."));
        CreditRevenue := GenJournalLine."Credit Amount";
        GenJournalLine.Insert(true);
    end;

    local procedure Insert_SalesCreditVATOutput(var TempSalesInvLine: Record "Sales Invoice Line")
    begin
        VATPostingSetup.Get(Customer."VAT Bus. Posting Group", Item."VAT Prod. Posting Group");
        clear(GenJournalLine);
        Clear(CrVATAmount);
        GenJournalLine.LockTable();
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := IntgrationSetup."Journal Templ. Name For Sales";
        GenJournalLine."Journal Batch Name" := IntgrationSetup."Journal Batch Name For Sales";
        GenJournalLine."Line No." := GetLastLineNo;
        GenJournalLine."Document No." := TempSalesInvLine."Document No." + '-D';
        GenJournalLine."External Document No." := TempSalesInvLine."No.";
        GenJournalLine."Posting Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.Validate("Account No.", VATPostingSetup."Sales VAT Account");
        GenJournalLine."Due Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Document Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine.Validate("Shortcut Dimension 1 Code", TempSalesInvLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate("Shortcut Dimension 2 Code", TempSalesInvLine."Shortcut Dimension 2 Code");
        GenJournalLine.validate("Dimension Set ID", TempSalesInvLine."Dimension Set ID");
        GenJournalLine.Validate("Credit Amount", ((TempSalesInvLine.Quantity * Item."FOC Nominal Cost For VAT calc.")
                                                   * IntgrationSetup."Cr. VAT Output % ") / 100);
        CrVATAmount := GenJournalLine."Credit Amount";
        GenJournalLine.Insert(true);

    end;

    local procedure Insert_SalesDebitVATAmount(var TempSalesInvLine: Record "Sales Invoice Line")
    begin
        GeneralPostingSetup.get(Customer."Gen. Bus. Posting Group", Item."Gen. Prod. Posting Group");
        clear(GenJournalLine);
        GenJournalLine.LockTable();
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := IntgrationSetup."Journal Templ. Name For Sales";
        GenJournalLine."Journal Batch Name" := IntgrationSetup."Journal Batch Name For Sales";
        GenJournalLine."Line No." := GetLastLineNo;
        GenJournalLine."Document No." := TempSalesInvLine."Document No." + '-D';
        GenJournalLine."External Document No." := TempSalesInvLine."No.";
        GenJournalLine."Posting Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.Validate("Account No.", GeneralPostingSetup."Sales Line Disc. Account");
        GenJournalLine."Due Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine."Document Date" := TempSalesInvHeader."Posting Date";
        GenJournalLine.Validate("Shortcut Dimension 1 Code", TempSalesInvLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate("Shortcut Dimension 2 Code", TempSalesInvLine."Shortcut Dimension 2 Code");
        GenJournalLine.validate("Dimension Set ID", TempSalesInvLine."Dimension Set ID");
        GenJournalLine.Validate("Debit Amount", CrVATAmount + CreditRevenue);
        GenJournalLine.Insert(true);
    end;

    local procedure PostGenJournalLine()
    var
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", IntgrationSetup."Journal Templ. Name For Sales");
        GenJournalLine.SetRange("Journal Batch Name", IntgrationSetup."Journal Batch Name For Sales");
        if GenJournalLine.FindSet() then
            GenJnlPostBatch.Run(GenJournalLine);
    end;

    local procedure GetLastLineNo() LineNo: Integer;
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", IntgrationSetup."Journal Templ. Name For Sales");
        GenJournalLine.SetRange("Journal Batch Name", IntgrationSetup."Journal Batch Name For Sales");
        if GenJournalLine.FindLast() then
            exit(GenJournalLine."Line No." + 10000)
        else
            exit(10000)
    end;

    var
        Item: Record Item;
        TempSalesInvHeader: Record "Sales Invoice Header" temporary;
        SalesInvLine1: Record "Sales Invoice Line";
        TempSalesInvLine: Record "Sales Invoice Line" temporary;
        IntgrationSetup: Record "Integration Setup";
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        Customer: Record Customer;
        GenJournalLine: Record "Gen. Journal Line";
        CreditRevenue: Decimal;
        CrVATAmount: Decimal;

}
*/