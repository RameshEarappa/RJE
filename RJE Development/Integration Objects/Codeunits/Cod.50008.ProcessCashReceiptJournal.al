codeunit 50008 "Process Cash Receipt Jnl"
{
    TableNo = "Cash Receipt Journal Staging";

    trigger OnRun()
    var
        RecGenJnlLine: Record "Gen. Journal Line";
        IntegrationSetup: Record "Integration Setup";
        RecLocation: Record Location;
        RecBankAccount: Record "Bank Account";
        RecCustLedEntry: Record "Cust. Ledger Entry";
        LineNo: Integer;
        GLEntryL: Record "G/L Entry";//02.08.2021
    begin
        //Mandatory Fields check
        Rec.TestField("Document No.");
        Rec.TestField("Posting Date");
        Rec.TestField("Account No.");
        Rec.TestField("Salesperson/Purchaser Code");
        Rec.TestField("Payment Method");
        //Creating cash receipt journal
        Clear(RecGenJnlLine);
        IntegrationSetup.GET;
        IntegrationSetup.TestField("Cash Receipt Jnl Template");
        IntegrationSetup.TestField("Cash Receipt Jnl. Batch");

        Clear(RecGenJnlLine);
        RecGenJnlLine.SetRange("Journal Template Name", IntegrationSetup."Cash Receipt Jnl Template");
        RecGenJnlLine.SetRange("Journal Batch Name", IntegrationSetup."Cash Receipt Jnl. Batch");
        RecGenJnlLine.SetRange("Document No.", Rec."Document No.");
        RecGenJnlLine.SetRange("Applies-to Doc. No.", Rec."Applies-To Doc. No.");//28.07.2021
        RecGenJnlLine.SetRange(Amount, Rec.Amount);//28.07.2021
        if not RecGenJnlLine.IsEmpty() then
            Error('Record already exists in the table %1 with Document No. %2', RecGenJnlLine.TableCaption, Rec."Document No.");
        //02.08.2021
        //Validating in GLEntry
        Clear(GLEntryL);
        GLEntryL.SetCurrentKey("Document No.", Amount, "MH_Applies-To Doc. No.");
        GLEntryL.SetRange("Document No.", Rec."Document No.");
        GLEntryL.SetRange(Amount, Rec.Amount);
        GLEntryL.SetRange("MH_Applies-To Doc. No.", Rec."Applies-To Doc. No.");
        if GLEntryL.FindFirst() then
            Error('Record already exists in the table %1 with Document No. %2,Applies-To Doc. No. %3, Amount %4', GLEntryL.TableCaption, GLEntryL."Document No.", GLEntryL."MH_Applies-To Doc. No.", GLEntryL.Amount);

        Clear(RecCustLedEntry);
        RecCustLedEntry.SetRange("Document No.", Rec."Document No.");
        if not RecCustLedEntry.IsEmpty then
            Error('Record already exists in the table %1 with Document No. %2', RecCustLedEntry.TableCaption, Rec."Document No.");

        Clear(RecGenJnlLine);
        RecGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        RecGenJnlLine.SetRange("Journal Template Name", IntegrationSetup."Cash Receipt Jnl Template");
        RecGenJnlLine.SetRange("Journal Batch Name", IntegrationSetup."Cash Receipt Jnl. Batch");
        if RecGenJnlLine.FindLast() then
            LineNo := RecGenJnlLine."Line No." + 10000
        else
            LineNo := 10000;
        RecGenJnlLine.Init();
        RecGenJnlLine.Validate("Journal Template Name", IntegrationSetup."Cash Receipt Jnl Template");
        RecGenJnlLine.Validate("Journal Batch Name", IntegrationSetup."Cash Receipt Jnl. Batch");
        RecGenJnlLine.Validate("Line No.", LineNo);
        RecGenJnlLine.Validate("Document No.", Rec."Document No.");
        RecGenJnlLine.Validate("Posting Date", Rec."Posting Date");
        RecGenJnlLine.Validate("Document Type", Rec."Document Type");
        RecGenJnlLine.Validate("Account Type", Rec."Account Type");
        RecGenJnlLine.Validate("Account No.", Rec."Account No.");
        RecGenJnlLine.Validate("Applies-To Doc. Type", Rec."Applies-To Doc. Type");
        RecGenJnlLine.Validate("Applies-To Doc. No.", Rec."Applies-To Doc. No.");
        /*if Rec."Bal. Account No." <> '' then begin
            RecGenJnlLine.Validate("Bal. Account Type", Rec."Bal. Account Type");
            RecGenJnlLine.Validate("Bal. Account No.", Rec."Bal. Account No.");
        end;*/
        RecGenJnlLine.Validate(Amount, Rec.Amount);
        RecGenJnlLine.Validate("Payment Method Code", Rec."Payment Method");
        Clear(RecBankAccount);
        RecBankAccount.SetRange("Salesperson Code", Rec."Salesperson/Purchaser Code");
        RecBankAccount.SetRange("Payment Method Code", Rec."Payment Method");
        RecBankAccount.FindFirst();
        RecGenJnlLine.Validate("Salespers./Purch. Code", Rec."Salesperson/Purchaser Code");
        RecGenJnlLine.Validate("Bal. Account Type", Rec."Bal. Account Type"::"Bank Account");
        RecGenJnlLine.Validate("Bal. Account No.", RecBankAccount."No.");
        RecGenJnlLine."Created by API" := true;
        RecGenJnlLine."Staging Entry No." := Rec."Entry No.";
        RecGenJnlLine."Subscriber Required" := true;

        //Moving warning in Narration
        Clear(RecCustLedEntry);
        RecCustLedEntry.SetRange("Document Type", RecCustLedEntry."Document Type"::Invoice);
        RecCustLedEntry.SetRange("Document No.", Rec."Applies-To Doc. No.");
        if RecCustLedEntry.FindFirst() then begin
            RecCustLedEntry.CalcFields("Remaining Amount");
            if not (RecCustLedEntry."Remaining Amount" >= ABS(Rec.Amount)) then
                RecGenJnlLine.Narration := StrSubstNo('Specfied Amount in Collection is Greater than Remaining Amount. Collection Amount %1 , Remaining Amount %2', ABS(Rec.Amount), RecCustLedEntry."Remaining Amount");
        end;

        RecGenJnlLine.Insert(true);
        //**************** Apply entries ******************
        ClearLastError();
        Commit();
        Codeunit.Run(Codeunit::"Gen. Jnl.-Apply", RecGenJnlLine);
        RecGenJnlLine."Subscriber Required" := False;
        RecGenJnlLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnBeforeSelectCustLedgEntry', '', false, false)]
    local procedure OnBeforeSelectCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var AccNo: Code[20]; var Selected: Boolean; var IsHandled: Boolean)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        Text000: Label 'You must specify %1 or %2.';
    begin
        if not GenJournalLine."Subscriber Required" then exit;
        IsHandled := false;
        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        if GenJournalLine."Applies-to ID" = '' then
            GenJournalLine."Applies-to ID" := GenJournalLine."Document No.";
        if GenJournalLine."Applies-to ID" = '' then
            Error(
              Text000,
              GenJournalLine.FieldCaption("Document No."), GenJournalLine.FieldCaption("Applies-to ID"));
        ApplyCustEntries.SetGenJnlLine(GenJournalLine, GenJournalLine.FieldNo("Applies-to ID"));
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.SetTableView(CustLedgEntry);
        //ApplyCustEntries.LookupMode(true);
        ApplyCustEntries.SetCustApplId(false);
        Selected := true;
        Clear(ApplyCustEntries);
        IsHandled := true;
    End;

    //28.07.2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnCodeOnAfterGenJnlPostBatchRun(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."MH Applies-To Doc. Type" := Format(GenJournalLine."Applies-to Doc. Type");
        GLEntry."MH_Applies-To Doc. No." := GenJournalLine."Applies-to Doc. No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeaderL: Record "Sales Header";
        SalesPriceL: Record "Sales Price";
        CustomerL: Record Customer;
        SalesLineDiscountL: Record "Sales Line Discount";
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::Order] then begin
            if SalesHeaderL.Get(Rec."Document Type", Rec."Document No.") then begin
                if Rec.Type = Rec.Type::Item then begin
                    if CustomerL.Get(SalesHeaderL."Sell-to Customer No.") then;
                    SalesPriceL.SetRange("Item No.", Rec."No.");
                    SalesPriceL.SetRange("Sales Code", CustomerL."Customer Price Group");
                    SalesPriceL.SetFilter("Ending Date", '>=%1', SalesHeaderL."Posting Date");
                    SalesPriceL.SetFilter("Starting Date", '<=%1', SalesHeaderL."Posting Date");
                    if SalesPriceL.FindFirst() then
                        Rec."Price List Applied" := StrSubstNo('%1,%2,%3,%4', SalesPriceL."Sales Type", SalesPriceL."Sales Code", Format(SalesPriceL."Starting Date"), Format(SalesPriceL."Ending Date"))
                    else
                        Error('There is no Sales Price within the filter. Filters: %1', SalesPriceL.GetFilters);
                end;
            end;
        end;
    end;
    //28.07.2021

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineLineDisc', '', false, false)]
    local procedure OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice(
        var SalesHeader: Record "Sales Header";
        var SalesLine: Record "Sales Line";
        var SalesLineDiscount: Record "Sales Line Discount")
    begin
        if SalesLineDiscount."Line Discount %" <> 0 then begin
            if SalesLineDiscount."Sales Code" <> '' then
                SalesLine."Promotion Code Applied" := StrSubstNo('%1,%2,%3,%4', SalesLineDiscount."Sales Type", SalesLineDiscount."Sales Code", Format(SalesLineDiscount."Starting Date"), Format(SalesLineDiscount."Ending Date"))
            else
                SalesLine."Promotion Code Applied" := StrSubstNo('%1,%2,%3', SalesLineDiscount."Sales Type", Format(SalesLineDiscount."Starting Date"), Format(SalesLineDiscount."Ending Date"));
        end;
    end;

    var
        RunEventSubscrber: Boolean;
}