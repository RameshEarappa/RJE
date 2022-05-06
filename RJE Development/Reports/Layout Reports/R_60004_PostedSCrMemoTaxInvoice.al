REPORT 60004 "Sales Cr. Memo Tax Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RJE Development\Reports\Layout Reports\Report-60004-PostedSalesCrMemoTaxInvoice.rdl';
    DATASET
    {
        DATAITEM(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            CalcFields = Amount, "Amount Including VAT", "Invoice Discount Amount";
            COLUMN(CompanyLogo; CompanyInformationRecG.Picture) { }
            COLUMN(CompLogo; CompanyInformationRecG."Old Company Logo") { }
            COLUMN(Bool; Bool) { }
            COLUMN(CompanyName; CompanyInformationRecG.Name) { }
            COLUMN(CompanyAddress; CompanyInformationRecG.Address) { }
            COLUMN(CompanyAddress2; CompanyInformationRecG."Address 2") { }
            COLUMN(CompanyCity; CompanyInformationRecG.City) { }
            COLUMN(CompanyCountry; CompanyInformationRecG.County) { }
            COLUMN(CompanyPostCode; CompanyInformationRecG."Post Code") { }
            COLUMN(CompanyPhone; CompanyInformationRecG."Phone No.") { }
            COLUMN(CompanyVATReg; CompanyInformationRecG."VAT Registration No.") { }
            COLUMN(CompanyNameArabic; CompNameinArabic) { }
            COLUMN(CompName; CompName) { }
            COLUMN(CompanyAddressArabic; CompanyInformationRecG."Address In Arabic") { }
            COLUMN(CompanyAddress2Arabic; CompanyInformationRecG."Address 2 In Arabic") { }
            COLUMN(CompanyCityArabic; CompanyInformationRecG."City In Arabic") { }
            COLUMN(CompanyCountryArabic; CompanyInformationRecG."Country In Arabic") { }
            COLUMN(CompanyPostCodeArabic; CompanyInformationRecG."Post Code In Arabic") { }
            COLUMN(InvoiceNo; "No.") { }
            COLUMN(PostingDate; "Posting Date") { }
            COLUMN(DocumentDate; "Document Date") { }
            COLUMN(DeliveryDate; SalesCrMemoHeader."Shipment Date") { }
            COLUMN(CustomerCode; Customer."No.") { }
            COLUMN(CustomerName; Customer.Name) { }
            COLUMN(CustomerAddress; Customer.Address) { }
            COLUMN(CustomerAddress2; Customer."Address 2") { }
            COLUMN(CustomerCity; Customer.City) { }
            COLUMN(CustomerCountry; Customer.County) { }
            COLUMN(CustomerPostCode; Customer."Post Code") { }
            COLUMN(CustomerVATRegNo; Customer."VAT Registration No.") { }
            COLUMN(CustomerNameArabic; Customer."Name-Arabic") { }
            COLUMN(CustomerAddress1Arabic; Customer."Address 1 - Arabic") { }
            COLUMN(CustomerAddress2Arabic; Customer."Address 2 - Arabic") { }
            COLUMN(CustomerCityArabic; Customer."City In Arabic") { }
            column(CustomerVatRegNoArabic; Customer."VAT Registration No. In Arabic") { }
            COLUMN(Branch; Branch) { }
            COLUMN(Due_Date; "Due Date") { }
            COLUMN(TotalAmountExclVATInWords; TotalAmountExclVATInWords) { }
            COLUMN(TotalVATAmountInWords; TotalVATAmountInWords) { }
            COLUMN(TotalAmountInclVATInWords; TotalAmountInclVATInWords) { }
            column(Invoice_Discount_Amount; "Invoice Discount Amount") { }
            column(Sales_Name; SalesPeople.Name) { }
            COLUMN(SalesCode; "Salesperson Code") { }
            column(Shipdate; '') { }
            column(TotalFooterVataAmt; TotalFooterVataAmt) { }
            DATAITEM(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = SalesCrMemoHeader;
                DataItemLink = "Document No." = FIELD("No.");
                COLUMN(SrNo; SrNo) { }
                COLUMN(SKUNo; Item."No.") { }
                column(Comment; Description) { }
                COLUMN(Description; Item.Description) { }
                COLUMN(Qty; SalesCrMemoLine.Quantity) { }
                COLUMN(UOM; SalesCrMemoLine."Unit of Measure Code") { }
                COLUMN(Rate; SalesCrMemoLine."Unit Price") { }
                column(LineDisAmt; "Line Discount Amount") { }
                COLUMN(Amount; AmountG) { } //SalesCrMemoLine.Amount) { }
                COLUMN(VATPerc; SalesCrMemoLine."VAT %") { }
                //COLUMN(VATAmount; SalesCrMemoLine."VAT Base Amount") { }
                column(VATAmount; VATAmount) { }
                COLUMN(TotalAmount; SalesCrMemoLine."Amount Including VAT") { }
                TRIGGER OnPreDataItem()
                BEGIN
                    NoOfRecords := SalesCrMemoLine.COUNT * 6;
                END;

                TRIGGER OnAfterGetRecord()
                var
                    Amt: Decimal;
                BEGIN
                    CLEAR(Item);
                    IF Item.Get("No.") THEN;

                    SrNo += 1;
                    //23-08-21
                    AmountG := Quantity * "Unit Price";
                    //09-12-2021
                    if "Line Discount Amount" <> 0 then begin
                        Amt := AmountG - "Line Discount Amount";
                        VATAmount := (Amt * "VAT %") / 100;
                    end else
                        VATAmount := (AmountG * "VAT %") / 100;
                    //09-12-2021
                END;

                TRIGGER OnPostDataItem()
                BEGIN
                END;

            }
            DATAITEM(FixedLength; Integer)
            {
                DataItemLinkReference = SalesCrMemoHeader;
                DataItemTableView = SORTING(Number);
                COLUMN(FixedLineNo; FixedLength.Number) { }
                TRIGGER OnPreDataItem()
                BEGIN
                    //Fixed Empty blank lines for page
                    IF NoOfRecords <= 20 THEN BEGIN
                        NoOfRows := 20;
                    END
                    ELSE
                        IF (NoOfRecords > 20) AND (NoOfRecords <= 40) THEN BEGIN
                            NoOfRows := 40;
                        END
                        ELSE
                            IF (NoOfRecords > 40) AND (NoOfRecords <= 60) THEN BEGIN
                                NoOfRows := 60;
                            END
                            ELSE
                                IF (NoOfRecords > 60) AND (NoOfRecords <= 80) THEN BEGIN
                                    NoOfRows := 80;
                                END;

                    SETRANGE(Number, 1, NoOfRows - NoOfRecords);
                END;
            }
            TRIGGER OnPreDataItem()
            VAR
            BEGIN
                CompanyInformationRecG.GET;
                CompanyInformationRecG.CALCFIELDS(Picture);
                CompanyInformationRecG.CalcFields("Old Company Logo");
                CompanyInformationRecG.TESTFIELD("Date Validation - Company Name");
            END;

            TRIGGER OnAfterGetRecord()
            VAR
            BEGIN
                SrNo := 0;
                CLEAR(Customer);
                IF Customer.get("Sell-to Customer No.") THEN;

                Clear(SalesPeople);
                if SalesPeople.Get("Salesperson Code") then;

                IF Customer.get("Sell-to Customer No.") THEN;
                CLEAR(Branch);
                GLSetup.GET;
                IF DimSetEntry.GET(SalesCrMemoHeader."Dimension Set ID", GLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                    Branch := DimSetEntry."Dimension Value Code";
                END;

                Clear(TotalFooterVataAmt);
                TotalFooterVataAmt := "Amount Including VAT" - Amount;

                //16-06-2021
                Bool := False;
                if "Posting Date" < CompanyInformationRecG."Date Validation - Company Name" then begin
                    CompNameinArabic := CompanyInformationRecG."Company Name in Arabic";
                    CompName := CompanyInformationRecG."Company Name";
                    Bool := True;
                end else begin
                    CompNameinArabic := CompanyInformationRecG."Name in Arabic";
                    CompName := CompanyInformationRecG."Name";
                end;
                //16-06-2021


                TotalAmountExclVAT := 0;
                TotalVATAmount := 0;
                TotalAmountInclVAT := 0;
                TotalAmountExclVAT := Amount;
                TotalVATAmount := ("Amount Including VAT" - Amount);
                TotalAmountInclVAT := "Amount Including VAT";

                //Amount in Words
                IF TotalAmountExclVAT <> 0 THEN BEGIN
                    CLEAR(DecimalValue);
                    DecimalValue := ROUND(TotalAmountExclVAT) MOD 1 * 100;
                    MyAmountInWords.InitTextVariable();
                    MyAmountInWords.FormatNoText(DecimalValueInWords, DecimalValue, '');
                    IF DecimalValueInWords[1] = '' THEN
                        DecimalValueInWords[1] := 'ZERO';

                    MyAmountInWords.FormatNoText(TotalAmountExclVATWords, TotalAmountExclVAT, '');
                    TotalAmountExclVATInWords := TotalAmountExclVATWords[1] + ' SAUDI RIYALS AND ' + DecimalValueInWords[1] + ' HALALAS ONLY';
                END;
                //Amount in Words Excl VAT

                //Amount in Words VAT Amount
                IF TotalVATAmount <> 0 THEN BEGIN
                    CLEAR(DecimalValue);
                    CLEAR(DecimalValueInWords);
                    DecimalValue := ROUND(TotalVATAmount) MOD 1 * 100;
                    MyAmountInWords.InitTextVariable();
                    MyAmountInWords.FormatNoText(DecimalValueInWords, DecimalValue, '');
                    IF DecimalValueInWords[1] = '' THEN
                        DecimalValueInWords[1] := 'ZERO';

                    MyAmountInWords.FormatNoText(TotalVATAmountWords, TotalVATAmount, '');
                    TotalVATAmountInWords := TotalVATAmountWords[1] + ' SAUDI RIYALS AND ' + DecimalValueInWords[1] + ' HALALAS ONLY';
                END;
                //Amount in Words VAT Amount

                //Amount in Words VAT Amount
                IF TotalAmountInclVAT <> 0 THEN BEGIN
                    CLEAR(DecimalValue);
                    CLEAR(DecimalValueInWords);
                    DecimalValue := ROUND(TotalAmountInclVAT) MOD 1 * 100;
                    MyAmountInWords.InitTextVariable();
                    MyAmountInWords.FormatNoText(DecimalValueInWords, DecimalValue, '');
                    IF DecimalValueInWords[1] = '' THEN
                        DecimalValueInWords[1] := 'ZERO';

                    MyAmountInWords.FormatNoText(TotalAmountInclVATWords, TotalAmountInclVAT, '');
                    TotalAmountInclVATInWords := TotalAmountInclVATWords[1] + ' SAUDI RIYALS AND ' + DecimalValueInWords[1] + ' HALALAS ONLY';
                END;
                //Amount in Words VAT Amount
            END;

            TRIGGER OnPostDataItem()
            VAR
            BEGIN

            END;
        }
    }
    VAR
        CompanyInformationRecG: Record "Company Information";
        Customer: Record Customer;
        Item: Record Item;
        SrNo: Integer;
        NoOfRecords: Integer;
        NoOfRows: Integer;
        TotalAmountExclVAT: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        AmountG: Decimal;
        VATAmount: Decimal;
        TotalAmountExclVATWords: ARRAY[2] OF Text;
        SalesPeople: Record "Salesperson/Purchaser";

        TotalVATAmountWords: ARRAY[2] OF Text;
        TotalAmountInclVATWords: ARRAY[2] OF Text;
        DecimalValue: Decimal;
        DecimalValueInWords: ARRAY[2] OF Text;
        TotalAmountExclVATInWords: Text;
        TotalVATAmountInWords: Text;
        TotalAmountInclVATInWords: Text;
        MyAmountInWords: Report "My Amount In Words";
        Branch: Text;
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        TotalFooterVataAmt: Decimal;
        CompNameinArabic: Text[250];
        CompName: text[250];
        Bool: Boolean;
}