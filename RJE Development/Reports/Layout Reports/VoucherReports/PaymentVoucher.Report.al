report 50118 "Payment Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'VoucherReportsRDL\PaymentVoucher.rdl';
    Caption = 'Payment Voucher';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Document No.", "Source Type";
            DataItemTableView = SORTING("Entry No.");
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
            column(UserName; UserName)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(Check_Date; checkDate)
            {

            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyDisplayName; CompanyInfo."Ship-to Name")
            { }
            column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Country; CompanyInfo."Country/Region Code")
            {
            }
            column(CompanyAddress; CompanyAddress)
            {

            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyTelAndFax; CompanyTelAndFax)
            {

            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)//CompanyInfo."Header Image")
            {
            }
            column(footerImage; '')//CompanyInfo."Footer Image")
            {

            }
            column(CompanyInfo_vatRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfo_PhoneNol; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_WebSite; CompanyInfo."Home Page")
            { }
            column(CompanyInfo_Email; 'E. ' + CompanyInfo."E-Mail")
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
            column(AmountText1; AmountText1)
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(ChequeNo_GLEntry; CheckNo)
            {
            }
            column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
            {
            }
            column(DocumentNo2_GLEntry; '')//"G/L Entry"."Document No2")
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)//"G/L Entry"."Debit Amount")
            {
            }
            //21.12.2020
            // column(TotalAmt; Abs(NewAmount))
            // {

            // }
            column(TotalAmt; TotalAmt)
            {
            }
            //21.12.2020
            column(Narration_GLEntry; NarrationText)
            {
            }
            column(PaymentDesc; PaymentDesc)
            {
            }
            column(SourceNo; SourceNo)
            {
            }
            column(LCYCode; GLSetup."LCY Code")
            {
            }

            column(vendorNo; vendorNo)
            {

            }
            column(External_Document_No_; ExternalDocNO)
            {

            }
            column(G_L_Account_No_; AccountNo)
            {

            }
            column(IsFCY; IsFCY)
            {

            }
            column(FCYAmount; FCYAmount)
            {

            }
            column(G_L_Account_Name; AccountName)
            {

            }
            column(Description; Description)
            {

            }
            column(cash_bank; cash_bank)
            {

            }
            dataitem(DetailedVendorLedgEntry1; "Detailed Vendor Ledg. Entry")
            {
                DataItemTableView = SORTING("Applied Vend. Ledger Entry No.", "Entry Type") WHERE(Unapplied = CONST(false), "Entry Type" = CONST(Application), "Initial Document Type" = CONST(Invoice));
                column(Entry_No_DVLE; "Entry No.")
                {

                }
                column(Document_No_DVLE; VendorLedgerEntry."External Document No.")
                {

                }
                column(Document_Type_DVLE; "Initial Document Type")
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
                    DetailedVendorLedgEntry1.SETRANGE("Document No.", "G/L Entry"."Document No.");
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Entry No.", DetailedVendorLedgEntry1."Vendor Ledger Entry No.");
                    IF VendorLedgerEntry.FINDFIRST THEN;
                end;
            }

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                RecGLAccount: Record "G/L Account";
                RecPaymentMethod: Record "Payment Method";
                RecGLSetup: Record "General Ledger Setup";
                RecVendorPostingGroup: Record "Vendor Posting Group";
            begin
                // Clear(RecGLAccount);
                // RecGLAccount.SetRange("No.", "G/L Entry"."G/L Account No.");
                // RecGLAccount.SetRange("Account Subcategory Entry No.", GlSubCatId);
                // if RecGLAccount.FindFirst() then begin
                //     CurrReport.Skip();
                // end;

                Clear(RecVendorPostingGroup);
                if RecVendorPostingGroup.GET('DOMESTIC') THEN begin
                end;

                Clear(GLEntry);
                GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                GLEntry.SetRange("Source Type", "Source Type"::Vendor);
                if GLEntry.FindFirst() then begin
                    Clear(Vendor_Rec);
                    Vendor_Rec.SETRANGE("No.", GLEntry."Source No.");
                    IF Vendor_Rec.FINDFIRST THEN BEGIN
                        vendorNo := Vendor_Rec."No.";
                        Name := Vendor_Rec.Name;
                    END;
                end else
                    Name := '';//"Payee Name";

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
                IF "Source Type" = "Source Type"::Vendor THEN BEGIN
                    Clear(VendorLedEntry_Rec);
                    VendorLedEntry_Rec.SetRange("Document Type", VendorLedEntry_Rec."Document Type"::Payment);
                    VendorLedEntry_Rec.SETRANGE("Document No.", "Document No.");
                    IF VendorLedEntry_Rec.FIND('-') THEN begin
                        CurrCode := VendorLedEntry_Rec."Currency Code";
                        GLSetup.GET;
                        if GLSetup."LCY Code" <> CurrCode then
                            IsFCY := true
                        else
                            IsFCY := false;

                        VendorLedEntry_Rec.CalcFields(Amount);
                        FCYAmount := VendorLedEntry_Rec.Amount;
                        if FCYAmount < 0 then
                            FCYAmount := FCYAmount * -1;
                        Clear(RecPaymentMethod);
                        if RecPaymentMethod.GET(VendorLedEntry_Rec."Payment Method Code") then
                            PaymentMethodDesc := RecPaymentMethod.Description;
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

                Clear(NewAmount);
                Clear(GLEntry);
                GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                if GLEntry.FindSet() then begin
                    repeat
                        NewAmount += GLEntry.Amount;//"Debit Amount";
                        Clear(RecGLAccount);
                        RecGLAccount.SetRange("No.", GLEntry."G/L Account No.");
                        RecGLAccount.SetFilter("Account Subcategory Entry No.", '=%1', GlSubCatId);// 'Cash And Bank Balances');
                        if RecGLAccount.FIND('-') then begin
                            GLEntry.CalcFields("G/L Account Name");
                            if RecGLAccount.Name <> '' then begin
                                cash_bank := GLEntry."G/L Account Name"; //Description;    
                                NewAmount := NewAmount - GLEntry.Amount;
                            end;
                        end else begin
                            // NewAmount += GLEntry.Amount;//"Debit Amount";
                            RecGLSetup.GET;
                        end;

                    until GLEntry.Next() = 0;
                end;
                IF "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::Vendor THEN BEGIN
                    Clear(Vendor_Rec);
                    Vendor_Rec.SETRANGE("No.", "G/L Entry"."Source No.");
                    IF Vendor_Rec.FINDFIRST THEN BEGIN
                        No := Vendor_Rec."No.";
                    END
                END;

                IF CurrCode = '' THEN
                    CurrCode := GLSetup."LCY Code";
                //END;            


                Currency_Rec.RESET;
                IF Currency_Rec.GET(GLSetup."LCY Code") then
                    DecimalDec := '';
                TotalAmt += "G/L Entry".Amount;//"Debit Amount";

                tvar := (ROUND(TotalAmt) MOD 1 * 100);
                MyAmountInWords.InitTextVariable;
                MyAmountInWords.FormatNoText(AmtInwrd11, tvar, '');
                AmtInwrd12 := AmtInwrd11[1];
                IF AmtInwrd12 = '' THEN
                    AmtInwrd12 := 'ZERO';
                MyAmountInWords.InitTextVariable;
                MyAmountInWords.FormatNoText(Amount_Words, TotalAmt, '');
                Text := Amount_Words[1];
                // AmountText1 := Text + ' ' + CurrCode + ' AND ' + AmtInwrd12 + ' ' + DecimalDec + ' ONLY';
                AmountText1 := UpperCase(Text + ' ' + GLSetup."LCY Code" + ' AND ' + AmtInwrd12 + ' ' + DecimalDec + ' ONLY');


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
                CLEAR(No);
                CLEAR(Name);
                CLEAR(CurrCode);
                CLEAR(TotalAmt);
                Clear(RecGlSubCat);
                "G/L Entry".SetRange("Source Type", "Source Type"::Vendor);
                RecGlSubCat.SetRange(Description, 'Cash And Bank Balances');
                if RecGlSubCat.FindFirst() then
                    GlSubCatId := RecGlSubCat."Entry No.";
                GLSetup.GET;
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin

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
        checkDate: Date;
        NewAmount: Decimal;
        AccountNo: Text;
        AccountNoTest: Text;
        AccountName: Text;
        GlSubCatId: Integer;
        RecBankAccount: Record "Bank Account";
        RecVendor: Record Vendor;
        FCYAmount: Decimal;
        IsFCY: Boolean;
        RecCustomer: Record Customer;
        RecFixedAsset: Record "Fixed Asset";
        RecEmployee: Record Employee;
        ExternalDocNO: Text;
        NarrationText: Text;
        DtlVendorLedEntry: Record "Detailed Vendor Ledg. Entry";
        MyAmountInWords: Report "My Amount In Words";
        PaymentMethodDesc: Text;
        CheckNo: Text;
        Vendor_Rec: Record 23;
        No: Code[20];
        Name: Text;
        CheckRep: Report 1401;
        GLSetup: Record 98;
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        vendorNo: Text;
        ExponentText: array[5] of Text[30];
        GenJnlLine: Record 81;
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
        TotalAmt: Decimal;
        tvar: Decimal;
        AmtInwrd11: array[2] of Text;
        AmtInwrd12: Text;
        Amount_Words: array[2] of Text;
        Text: Text;
        AmountText1: Text;
        CurrCode: Code[20];
        FixedAssetRec: Record 5600;
        CustomerRec: Record 18;
        VendorRec: Record 23;
        cash_bank: Text;
        GLAcctRec: Record 15;
        Employee: Record 5200;
        SourceNo: Code[20];
        PaymentDesc: Text[100];
        Custledentry_Rec: Record 21;
        VendorLedEntry_Rec: Record 25;
        Amount: Decimal;
        VendorLedEntry_Rec1: Record 25;
        Currency_Rec: Record 4;
        DecimalDesc: Text[20];
        Currcode1: Code[250];
        Users: Record User;
        UserName: Text;
        VendorLedgerEntry: Record "Vendor Ledger Entry";



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

