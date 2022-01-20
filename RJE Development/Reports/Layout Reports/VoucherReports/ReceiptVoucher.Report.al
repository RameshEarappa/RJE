report 50002 "Receipt Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'VoucherReportsRDL\ReceiptVoucher.rdl';
    Caption = 'Receipt Voucher';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
            //WHERE("Credit Amount" = FILTER(<> 0));
            RequestFilterFields = "Document No.";
            column(PaymentMethodDesc; PaymentMethodDesc)
            {

            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Entry_No_GL; "Entry No.")
            {

            }
            column(CompanyInfo_Name2; CompanyInfo."Name 2")
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(UserName; UserName)
            {
            }
            column(G_L_Account_No_; AccountNo)
            {

            }
            column(G_L_Account_Name; AccountName)
            {

            }
            column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyAddress; CompanyAddress)
            {

            }
            column(IsFCY; IsFCY)
            {

            }
            column(FCYAmount; FCYAmount)
            {

            }
            column(CompanyTelAndFax; CompanyTelAndFax)
            {

            }
            column(CompanyInfo_Country; CompanyInfo."Country/Region Code")
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)//CompanyInfo."Header Image")
            {
            }
            column(footerimage; '')//companyinfo."Footer Image")
            {

            }
            column(CompanyInfo_vatRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfo_PhoneNol; CompanyInfo."Phone No.")
            {
            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(CompanyDisplayName; CompanyInfo."Ship-to Name")
            { }
            column(CompanyInfo_Email; 'E. ' + CompanyInfo."E-Mail")
            { }
            column(CompanyInfo_WebSite; CompanyInfo."Home Page")
            { }
            column(CompanyInfoHomPage; CompanyInfo."Home Page")
            {
            }
            column(CurrencyCode_GenJournalLine; CurrCode)
            {
            }
            column(No; No)
            {
            }
            column(Name; Name)
            {
            }
            column(Narration_GLEntry; NarrationText)//"G/L Entry".Narration)
            {
            }
            column(AmountText1; AmountText1)
            {
            }
            column(DocumentNo2_GLEntry; '')//"G/L Entry"."Document No2")
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)//"Credit Amount")
            {
            }
            column(PostingDate_GLEntry; FORMAT("G/L Entry"."Posting Date"))
            {
            }
            column(ChequeNo_GLEntry; CheckNo)//"G/L Entry"."Check No.")
            {
            }
            column(checkDate; checkDate)
            {

            }
            //21.12.2020
            // column(TotalAmt; NewAmount)
            // {

            // }
            column(TotalAmt; TotalAmt)
            {
            }
            //21.12.2020
            column(Description; Description)
            {

            }
            column(cash_bank; cash_bank)
            {

            }
            column(NewAmount; NewAmount)
            {

            }
            column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
            {
            }
            column(DocumentType; DocumentType)
            {

            }
            column(Dimesnion1Code; Dimm1Code)
            {

            }

            column(OrgAmount; Amount)
            {
            }

            dataitem(DetailedCustomerLedgEntry1; "Detailed Cust. Ledg. Entry")
            {
                DataItemTableView = SORTING("Applied Cust. Ledger Entry No.", "Entry Type") WHERE(Unapplied = CONST(false), "Entry Type" = CONST(Application), "Initial Document Type" = CONST(Payment));
                //DataItemTableView = SORTING("Applied Vend. Ledger Entry No.", "Entry Type") WHERE(Unapplied = CONST(false), "Entry Type" = CONST(Application), "Initial Document Type" = CONST(Invoice));
                column(Entry_No_DVLE; "Entry No.")
                {

                }
                column(Document_No_DVLE; CustLedgerEntry."External Document No.")
                {

                }
                column(Document_Type_DVLE; "Document Type")
                {

                }
                column(Initial_Entry_Global_Dim__1_DVLE; "Initial Entry Global Dim. 1")
                {

                }
                column(Posting_Date__DVLE; "Posting Date")//Document Date
                {
                }
                column(Amount_DVLE; Amount)
                {
                }
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    DetailedCustomerLedgEntry1.SETRANGE("Document No.", "G/L Entry"."Document No.");
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(CustLedgerEntry);
                    CustLedgerEntry.SETRANGE("Entry No.", DetailedCustomerLedgEntry1."Cust. Ledger Entry No.");
                    IF CustLedgerEntry.FINDFIRST THEN;
                end;
            }



            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                RecPaymentMethod: Record "Payment Method";
                RecGLAccount: Record "G/L Account";
                RecGLSetup: Record "General Ledger Setup";
                RecCustPostingGroup: Record "Customer Posting Group";
            begin

                // Clear(RecGLAccount);
                // RecGLAccount.SetRange("No.", "G/L Entry"."G/L Account No.");
                // RecGLAccount.SetRange("Account Subcategory Entry No.", GlSubCatId);
                // if RecGLAccount.FindFirst() then begin
                //     CurrReport.Skip();
                // end;
                Clear(RecCustPostingGroup);
                if RecCustPostingGroup.GET('DOMESTIC') THEN begin
                end;

                Clear(GLEntry);
                GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                GLEntry.SetRange("Source Type", "Source Type"::Customer);
                if GLEntry.FindFirst() then begin
                    Clear(Customer_Rec);
                    Customer_Rec.SETRANGE("No.", GLEntry."Source No.");
                    IF Customer_Rec.FINDFIRST THEN BEGIN
                        Name := Customer_Rec.Name;
                    END;
                end else
                    Name := '';

                Clear(AccountName);
                if "Source Type" = "Source Type"::" " then begin
                    CalcFields("G/L Account Name");
                    AccountName := "G/L Account Name";
                    AccountNo := "G/L Account No.";
                end else begin
                    AccountNo := "Source No.";
                    if "Source Type" = "Source Type"::"Bank Account" then begin
                        Clear(RecBankAccount);
                        RecBankAccount.GET("Source No.");
                        AccountName := RecBankAccount.Name;
                    end else
                        if "Source Type" = "Source Type"::Customer then begin
                            Clear(RecCustomer);
                            RecCustomer.GET("Source No.");
                            AccountName := RecCustomer.Name;
                        end else
                            if "Source Type" = "Source Type"::Vendor then begin
                                Clear(RecVendor);
                                RecVendor.GET("Source No.");
                                AccountName := RecVendor.Name;
                            end else
                                if "Source Type" = "Source Type"::Vendor then begin
                                    Clear(RecVendor);
                                    RecVendor.GET("Source No.");
                                    AccountName := RecVendor.Name;
                                end else
                                    if "Source Type" = "Source Type"::"Fixed Asset" then begin
                                        Clear(RecFixedAsset);
                                        RecFixedAsset.GET("Source No.");
                                        AccountName := RecFixedAsset.Description;
                                    end else
                                        if "Source Type" = "Source Type"::Employee then begin
                                            Clear(RecEmployee);
                                            RecEmployee.GET("Source No.");
                                            AccountName := RecEmployee."First Name";
                                        end;
                end;
                Clear(FCYAmount);
                IF "Source Type" = "Source Type"::Customer THEN BEGIN
                    Clear(Custledentry_Rec);
                    Custledentry_Rec.SetRange("Document Type", "Document Type"::Payment);
                    Custledentry_Rec.SETRANGE("Document No.", "Document No.");
                    IF Custledentry_Rec.FIND('-') THEN begin
                        CurrCode := Custledentry_Rec."Currency Code";
                        Clear(RecPaymentMethod);
                        if RecPaymentMethod.GET(Custledentry_Rec."Payment Method Code") then
                            PaymentMethodDesc := RecPaymentMethod.Description;

                        GLSetup.GET;
                        if CurrCode <> GLSetup."LCY Code" then
                            IsFCY := true
                        else
                            IsFCY := false;

                        Custledentry_Rec.CalcFields(Amount);
                        FCYAmount := Custledentry_Rec.Amount;
                        if FCYAmount < 0 then
                            FCYAmount := FCYAmount * -1;
                    end;
                END;
                Clear(GLEntry);
                GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                if GLEntry.FindSet() then begin
                    repeat
                        if GLEntry."Check Date" <> 0D then
                            checkDate := GLEntry."Check Date";
                        if GLEntry."Check No." <> '' then
                            CheckNo := GLEntry."Check No.";
                        if GLEntry."External Document No." <> '' then
                            ExternalDocNO := GLEntry."External Document No.";
                        if GLEntry.Narration <> '' then
                            NarrationText := GLEntry.Narration;
                    until GLEntry.Next() = 0;
                end;

                Clear(GLEntry);
                GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                if GLEntry.FindSet() then begin
                    repeat
                        NewAmount += GLEntry.Amount;
                        Clear(RecGLAccount);
                        RecGLAccount.SetRange("No.", GLEntry."G/L Account No.");
                        RecGLAccount.SetFilter("Account Subcategory Entry No.", '=%1', GlSubCatId);// 'Cash And Bank Balances');
                        if RecGLAccount.FIND('-') then begin
                            GLEntry.CalcFields("G/L Account Name");
                            if RecGLAccount.Name <> '' then begin
                                cash_bank := GLEntry."G/L Account Name";
                                NewAmount := NewAmount - GLEntry.Amount;
                            end;
                        end else begin
                            RecGLSetup.GET;
                        end;
                    until GLEntry.Next() = 0;
                end;

                IF CurrCode = '' THEN
                    CurrCode := GLSetup."LCY Code";

                Currency_Rec.RESET;
                IF Currency_Rec.GET(GLSetup."LCY Code") then
                    DecimalDec := '';

                TotalAmt += "G/L Entry".Amount;
                if TotalAmt < 0 then begin
                    tvar := (ROUND(TotalAmt * -1) MOD 1 * 100);
                    MyAmountInWords.InitTextVariable;
                    MyAmountInWords.FormatNoText(AmtInwrd11, tvar, '');
                    AmtInwrd12 := AmtInwrd11[1];
                    IF AmtInwrd12 = '' THEN
                        AmtInwrd12 := 'ZERO';
                    MyAmountInWords.InitTextVariable;
                    MyAmountInWords.FormatNoText(Amount_Words, TotalAmt * -1, '');
                    Text := Amount_Words[1];
                    AmountText1 := Text + ' ' + GLSetup."LCY Code" + ' AND ' + AmtInwrd12 + ' ' + DecimalDec + ' ONLY';
                end else begin
                    tvar := (ROUND(TotalAmt) MOD 1 * 100);
                    MyAmountInWords.InitTextVariable;
                    MyAmountInWords.FormatNoText(AmtInwrd11, tvar, '');
                    AmtInwrd12 := AmtInwrd11[1];
                    IF AmtInwrd12 = '' THEN
                        AmtInwrd12 := 'ZERO';
                    MyAmountInWords.InitTextVariable;
                    MyAmountInWords.FormatNoText(Amount_Words, TotalAmt, '');
                    Text := Amount_Words[1];
                    AmountText1 := Text + ' ' + GLSetup."LCY Code" + ' AND ' + AmtInwrd12 + ' ' + DecimalDec + ' ONLY';
                end;

                Clear(Users);
                Clear(UserName);
                Users.SetCurrentKey("User Name");
                Users.SetRange("User Name", "User ID");
                IF Users.FindFirst() then begin
                    if Users."Full Name" <> '' then
                        UserName := Users."Full Name"
                    else
                        UserName := UserId;
                end;
            end;

            trigger OnPreDataItem()
            var
                RecGlSubCat: Record "G/L Account Category";
            begin
                GLSetup.GET;
                CLEAR(No);
                CLEAR(Name);
                CLEAR(CurrCode);
                CLEAR(TotalAmt);
                GLSetup.GET;
                Clear(RecGlSubCat);
                "G/L Entry".SetRange("Source Type", "Source Type"::Customer);
                RecGlSubCat.SetRange(Description, 'Cash And Bank Balances');
                if RecGlSubCat.FindFirst() then
                    GlSubCatId := RecGlSubCat."Entry No.";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        Clear(CompanyAddress);
        Clear(CompanyTelAndFax);
        if CompanyInfo.Address <> '' then
            CompanyAddress := CompanyInfo.Address + ', ';

        if CompanyInfo."Address 2" <> '' then
            CompanyAddress += CompanyInfo."Address 2" + ', ';

        if CompanyInfo."Post Code" <> '' then
            CompanyAddress += 'P.O. Box ' + CompanyInfo."Post Code" + ', ';

        if CompanyInfo.City <> '' then
            CompanyAddress += CompanyInfo.City + ' - ';

        if CompanyInfo."Country/Region Code" <> '' then
            CompanyAddress += CompanyInfo."Country/Region Code";
        if CompanyInfo."Phone No." <> '' then
            CompanyTelAndFax := 'T. ' + CompanyInfo."Phone No." + ', ';
        if CompanyInfo."Fax No." <> '' then
            CompanyTelAndFax += 'F. ' + CompanyInfo."Fax No.";
    end;

    var
        CompanyInfo: Record 79;
        MyAmountInWords: Report "My Amount In Words";
        IsFCY: Boolean;
        FCYAmount: Decimal;
        CheckNo: Text;
        PaymentMethodDesc: Text;
        NewAmount: Decimal;
        AccountNo: Text;
        AccountNoTest: Text;
        AccountName: Text;
        GlSubCatId: Integer;
        cash_bank: Text;
        checkDate: Date;
        NarrationText: Text;
        Customer_Rec: Record 18;
        No: Code[20];
        Name: Text;
        CheckRep: Report 1401;
        GLSetup: Record 98;
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        GenJnlLine: Record 81;
        TotalAmt: Decimal;
        RecBankAccount: Record "Bank Account";
        RecVendor: Record Vendor;
        RecCustomer: Record Customer;
        RecFixedAsset: Record "Fixed Asset";
        RecEmployee: Record Employee;
        tvar: Decimal;
        AmtInwrd11: array[2] of Text;
        AmtInwrd12: Text;
        ExternalDocNO: Text;
        Amount_Words: array[2] of Text;
        Text: Text;
        AmountText1: Text;
        CurrCode: Code[20];
        Currency_Rec: Record Currency;
        DecimalDec: Text;
        CompanyAddress: Text;
        CompanyTelAndFax: Text;
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text065: Label 'Subtotal';
        CheckNoTextCaptionLbl: Label 'Check No.';
        LineAmountCaptionLbl: Label 'Net Amount';
        LineDiscountCaptionLbl: Label 'Discount';
        AmountCaptionLbl: Label 'Amount';
        DocNoCaptionLbl: Label 'Document No.';
        DocDateCaptionLbl: Label 'Document Date';
        CurrencyCodeCaptionLbl: Label 'Currency Code';
        YourDocNoCaptionLbl: Label 'Your Doc. No.';
        TransportCaptionLbl: Label 'Transport';
        Custledentry_Rec: Record 21;
        VendorLedEntry_Rec: Record 25;

        CustLedEntry1: Record 21;
        Users: Record User;
        UserName: Text;
        DtlCustLedEntry: Record "Detailed Cust. Ledg. Entry";
        DocumentType: Text;
        Dimm1Code: Text;
        CustLedgerEntry: Record "Cust. Ledger Entry";





    local procedure GetAmtDecimalPosition(): Decimal
    var
        Currency: Record 4;
    begin
        IF GenJnlLine."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(GenJnlLine."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        EXIT(1 / Currency."Amount Rounding Precision");
    end;
}

