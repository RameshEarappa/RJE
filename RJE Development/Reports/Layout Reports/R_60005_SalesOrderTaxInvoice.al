REPORT 60005 "Sales Order Tax Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RJE Development\Reports\Layout Reports\Report-60005-SalesOrderTaxInvoice.rdl';
    DATASET
    {
        DATAITEM(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            CalcFields = Amount, "Amount Including VAT";
            COLUMN(CompanyLogo; CompanyInformationRecG.Picture) { }
            COLUMN(CompanyName; CompanyInformationRecG.Name) { }
            COLUMN(CompanyAddress; CompanyInformationRecG.Address) { }
            COLUMN(CompanyAddress2; CompanyInformationRecG."Address 2") { }
            COLUMN(CompanyCity; CompanyInformationRecG.City) { }
            COLUMN(CompanyCountry; CompanyInformationRecG.County) { }
            COLUMN(CompanyPostCode; CompanyInformationRecG."Post Code") { }
            COLUMN(CompanyPhone; CompanyInformationRecG."Phone No.") { }
            COLUMN(CompanyVATReg; CompanyInformationRecG."VAT Registration No.") { }
            COLUMN(CompanyNameArabic; CompanyInformationRecG."Name In Arabic") { }
            COLUMN(CompanyAddressArabic; CompanyInformationRecG."Address In Arabic") { }
            COLUMN(CompanyAddress2Arabic; CompanyInformationRecG."Address 2 In Arabic") { }
            COLUMN(CompanyCityArabic; CompanyInformationRecG."City In Arabic") { }
            COLUMN(CompanyCountryArabic; CompanyInformationRecG."Country In Arabic") { }
            COLUMN(CompanyPostCodeArabic; CompanyInformationRecG."Post Code In Arabic") { }
            COLUMN(InvoiceNo; "No.") { }
            COLUMN(PostingDate; "Posting Date") { }
            COLUMN(DocumentDate; "Document Date") { }
            COLUMN(DeliveryDate; SalesHeader."Shipment Date") { }
            COLUMN(CustomerName; Customer.Name) { }
            COLUMN(CustomerAddress; Customer.Address) { }
            COLUMN(CustomerAddress2; Customer."Address 2") { }
            COLUMN(CustomerCity; Customer.City) { }
            COLUMN(CustomerCountry; Customer.County) { }
            COLUMN(CustomerPostCode; Customer."Post Code") { }
            COLUMN(CustomerVATRegNo; Customer."VAT Registration No.") { }
            COLUMN(Branch; "Shortcut Dimension 1 Code") { }
            DATAITEM(SalesLine; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document No." = FIELD("No.");
                COLUMN(SrNo; SrNo) { }
                COLUMN(SKUNo; Item."No.") { }
                COLUMN(Description; Item.Description) { }
                COLUMN(Qty; SalesLine.Quantity) { }
                COLUMN(UOM; SalesLine."Unit of Measure Code") { }
                COLUMN(Rate; SalesLine."Unit Price") { }
                COLUMN(Amount; SalesLine.Amount) { }
                COLUMN(VATPerc; SalesLine."VAT %") { }
                COLUMN(VATAmount; (SalesLine."Amount Including VAT" - SalesLine."VAT Base Amount")) { }
                COLUMN(TotalAmount; SalesLine."Amount Including VAT") { }
                TRIGGER OnPreDataItem()
                BEGIN
                    NoOfRecords := SalesLine.COUNT;
                END;

                TRIGGER OnAfterGetRecord()
                BEGIN
                    CLEAR(Item);
                    IF Item.Get("No.") THEN;
                    SrNo += 1;
                END;

            }
            DATAITEM(FixedLength; Integer)
            {
                DataItemLinkReference = SalesHeader;
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
            END;

            TRIGGER OnAfterGetRecord()
            VAR
            BEGIN
                CLEAR(Customer);
                IF Customer.get("Sell-to Customer No.") THEN;
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
}