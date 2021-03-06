REPORT 60003 "Sales Tax Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RJE Development\Reports\Layout Reports\Report-60003-PostedSalesTaxInvoice.rdl';
    DATASET
    {
        DATAITEM("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            CalcFields = Amount, "Amount Including VAT";
            COLUMN(CompanyLogo; CompanyInformationRecG.Picture) { }
            COLUMN(CompLogo; CompanyInformationRecG."Old Company Logo") { }
            COLUMN(Bool; Bool) { }
            COLUMN(SalesCode; "Salesperson Code") { }
            COLUMN(CompanyName; CompanyInformationRecG.Name) { }
            COLUMN(CompanyAddress; CompanyInformationRecG.Address) { }
            COLUMN(CompanyAddress2; CompanyInformationRecG."Address 2") { }
            COLUMN(CompanyCity; CompanyInformationRecG.City) { }
            COLUMN(CompanyCountry; CompanyInformationRecG."Country/Region Code") { }
            COLUMN(CompanyDate; CompanyInformationRecG."Date Validation - Company Name") { }
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
            COLUMN(DeliveryDate; "Sales Invoice Header"."Shipment Date") { }
            COLUMN(CustomerCode; Customer."No.") { }
            COLUMN(CustomerName; Customer.Name) { }
            COLUMN(CustomerAddress; Customer.Address) { }
            COLUMN(CustomerAddress2; Customer."Address 2") { }
            COLUMN(CustomerCity; Customer.City) { }
            COLUMN(CustomerCountry; Customer."Country/Region Code") { }
            COLUMN(CustomerPostCode; Customer."Post Code") { }
            COLUMN(CustomerVATRegNo; Customer."VAT Registration No.") { }
            COLUMN(CustomerNameArabic; Customer."Name-Arabic") { }
            COLUMN(CustomerAddress1Arabic; Customer."Address 1 - Arabic") { }
            COLUMN(CustomerAddress2Arabic; Customer."Address 2 - Arabic") { }
            COLUMN(CustomerCityArabic; Customer."City In Arabic") { }
            column(CustomerVatRegNoArabic; Customer."VAT Registration No. In Arabic") { }
            COLUMN(Branch; Branch) { }
            COLUMN(TotalAmountExclVATInWords; TotalAmountExclVATInWords) { }
            COLUMN(TotalVATAmountInWords; TotalVATAmountInWords) { }
            COLUMN(TotalAmountInclVATInWords; TotalAmountInclVATInWords) { }
            column(Invoice_Discount_Value; "Invoice Discount Amount") { }
            //23-02-2021
            COLUMN(Due_Date; "Due Date") { }
            column(Sales_Name; SalesPeople.Name) { }
            column(Shipdate; Shipdate) { }
            DATAITEM("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Line_No_; "Line No.") { }
                column(LineDisAmt; "Line Discount Amount") { }
                COLUMN(SrNo; SrNo) { }
                COLUMN(SKUNo; Item."No.") { }
                COLUMN(Description; Item.Description) { }
                COLUMN(DescriptionArabic; Item."Description-Arabic") { }
                COLUMN(ItemHscCode; Item."HS Code") { }
                COLUMN(Qty; "Sales Invoice Line".Quantity) { }
                COLUMN(UOM; "Sales Invoice Line"."Unit of Measure Code") { }
                COLUMN(Rate; "Sales Invoice Line"."Unit Price") { }
                COLUMN(Amount; AmountG) { }//"Sales Invoice Line".Amount) { }
                COLUMN(VATPerc; "Sales Invoice Line"."VAT %") { }
                //COLUMN(VATAmount; ("Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line"."VAT Base Amount")) { }
                column(VATAmount; VATAmount) { }
                COLUMN(TotalAmount; "Sales Invoice Line"."Amount Including VAT") { }

                TRIGGER OnPreDataItem()
                BEGIN
                    NoOfRecords := "Sales Invoice Line".COUNT * 3;
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
                DataItemLinkReference = "Sales Invoice Header";
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
                SalesInvoiceLineL: Record "Sales Invoice Line";
            BEGIN
                CLEAR(Customer);
                Clear(AmountG);
                //23-02-2021
                Clear(SalesPeople);
                if SalesPeople.Get("Salesperson Code") then;
                SrNo := 0;
                //23-02-2021

                IF Customer.get("Sell-to Customer No.") THEN;
                CLEAR(Branch);
                GLSetup.GET;
                IF DimSetEntry.GET("Sales Invoice Header"."Dimension Set ID", GLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                    Branch := DimSetEntry."Dimension Value Code";
                END;

                //23-02-2021
                Clear(SalesShipmentLine);
                SalesInvoiceLineL.SetRange("Document No.", "No.");
                if SalesInvoiceLineL.FindFirst() then begin
                    SalesShipmentLine.SetRange("Order No.", SalesInvoiceLineL."Order No.");
                    SalesShipmentLine.SetRange("Line No.", SalesInvoiceLineL."Line No.");
                    if SalesShipmentLine.FindFirst() then
                        Shipdate := SalesShipmentLine."Shipment Date";
                end;
                //23-02-2021
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
    TRIGGER OnPreReport()
    BEGIN
        CLEAR(TotalAmountExclVAT);
        CLEAR(TotalVATAmount);
        CLEAR(TotalAmountInclVAT);
    END;

    VAR
        CompanyInformationRecG: Record "Company Information";
        VATAmount: Decimal;
        Customer: Record Customer;
        Item: Record Item;
        SrNo: Integer;
        NoOfRecords: Integer;
        NoOfRows: Integer;
        MyAmountInWords: Report "My Amount In Words";
        TotalAmountExclVAT: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountExclVATWords: ARRAY[2] OF Text;
        TotalVATAmountWords: ARRAY[2] OF Text;
        TotalAmountInclVATWords: ARRAY[2] OF Text;
        DecimalValue: Decimal;
        DecimalValueInWords: ARRAY[2] OF Text;
        TotalAmountExclVATInWords: Text;
        TotalVATAmountInWords: Text;
        TotalAmountInclVATInWords: Text;
        Branch: Text;
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        SalesPeople: Record "Salesperson/Purchaser";
        SalesShipmentLine: Record "Sales Shipment Line";
        Shipdate: Date;
        OutputNo: Integer;
        CompNameinArabic: Text[250];
        CompName: text[250];
        Bool: Boolean;
        AmountG: Decimal;
}