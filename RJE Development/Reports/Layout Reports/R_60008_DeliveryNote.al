REPORT 60008 "Delivery Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'RJE Development\Reports\Layout Reports\Report-60008-DeliveryNote.rdl';
    DATASET
    {
        DATAITEM("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            COLUMN(CompanyLogo; CompanyInformationRecG.Picture) { }
            COLUMN(CompLogo; CompanyInformationRecG."Old Company Logo") { }
            COLUMN(Bool; Bool) { }
            COLUMN(CompanyName; CompanyInformationRecG.Name) { }
            COLUMN(CompanyAddress; CompanyInformationRecG.Address) { }
            COLUMN(CompanyAddress2; CompanyInformationRecG."Address 2") { }
            COLUMN(CompanyCity; CompanyInformationRecG.City) { }
            COLUMN(CompanyCountry; CompanyInformationRecG."Country/Region Code") { }
            COLUMN(CompanyPostCode; CompanyInformationRecG."Post Code") { }
            COLUMN(CompanyPhone; CompanyInformationRecG."Phone No.") { }
            COLUMN(CompanyVATReg; CompanyInformationRecG."VAT Registration No.") { }
            COLUMN(CompanyNameArabic; CompNameinArabic) { }
            COLUMN(CompName; CompName) { }
            COLUMN(CompanyAddressArabic; CompanyInformationRecG."Address In Arabic") { }
            COLUMN(CompanyAddress2Arabic; CompanyInformationRecG."Address 2 In Arabic") { }
            COLUMN(CompanyCityArabic; CompanyInformationRecG."City In Arabic") { }
            COLUMN(CompanyCountryArabic; CompanyInformationRecG."Country In Arabic") { }
            COLUMN(CompanyDate; CompanyInformationRecG."Date Validation - Company Name") { }
            COLUMN(CompanyPostCodeArabic; CompanyInformationRecG."Post Code In Arabic") { }
            COLUMN(DeliveryNoteSNo; "No.") { }
            COLUMN(ShipmentOrderNo; "No.") { }
            COLUMN(ShipmentDate; "Posting Date") { }
            COLUMN(DocumentDate; "Document Date") { }
            COLUMN(SalesOrderNo; "Order No.") { }
            COLUMN(DeliveryDate; "Shipment Date") { }
            COLUMN(CustomerName; Customer.Name) { }
            COLUMN(CustomerAddress; Customer.Address) { }
            COLUMN(CustomerAddress2; Customer."Address 2") { }
            COLUMN(CustomerCity; Customer.City) { }
            COLUMN(CustomerCountry; Customer.County) { }
            COLUMN(CustomerPostCode; Customer."Post Code") { }
            COLUMN(CustomerVATRegNo; Customer."VAT Registration No.") { }
            COLUMN(CustomerNameArabic; Customer."Name-Arabic") { }
            COLUMN(CustomerAddressArabic; Customer."Address 1 - Arabic") { }
            COLUMN(CustomerAddress2Arabic; Customer."Address 2 - Arabic") { }
            DATAITEM("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLinkReference = "Sales Shipment Header";
                DataItemLink = "Document No." = FIELD("No.");
                COLUMN(SrNo; SrNo) { }
                COLUMN(SKUNo; Item."No.") { }
                COLUMN(Description; Item.Description) { }
                COLUMN(Qty; Quantity) { }
                COLUMN(TotalOuter; TotalOuter) { }
                COLUMN(MasterCase; MasterCase) { }
                COLUMN(OuterQty; OuterQty) { }
                COLUMN(LoadingWarehouse; "Sales Shipment Line"."Location Code") { }
                //Sales Shipment Line
                TRIGGER OnPreDataItem()
                BEGIN
                    NoOfRecords := "Sales Shipment Line".COUNT;
                END;
                //Sales Shipment Line
                TRIGGER OnAfterGetRecord()
                BEGIN
                    CLEAR(Item);
                    IF Item.Get("No.") THEN;
                    SrNo += 1;
                    IF "Sales Shipment Line"."Unit of Measure Code" = 'OUTERS' THEN BEGIN
                        TotalOuter := "Sales Shipment Line".Quantity;
                        MasterCase := "Sales Shipment Line".Quantity DIV 50;
                        OuterQty := "Sales Shipment Line".Quantity MOD 50;
                    END;
                END;
                //Sales Shipment Line
                TRIGGER OnPostDataItem()
                BEGIN
                END;
            }
            DATAITEM(FixedLength; Integer)
            {
                DataItemLinkReference = "Sales Shipment Header";
                DataItemTableView = SORTING(Number);
                COLUMN(FixedLineNo; FixedLength.Number) { }
                //FixedLength
                TRIGGER OnPreDataItem()
                BEGIN
                    //Fixed Empty blank lines for page
                    IF NoOfRecords <= 15 THEN BEGIN
                        NoOfRows := 15;
                    END
                    ELSE
                        IF (NoOfRecords > 15) AND (NoOfRecords <= 30) THEN BEGIN
                            NoOfRows := 30;
                        END
                        ELSE
                            IF (NoOfRecords > 30) AND (NoOfRecords <= 45) THEN BEGIN
                                NoOfRows := 45;
                            END
                            ELSE
                                IF (NoOfRecords > 45) AND (NoOfRecords <= 60) THEN BEGIN
                                    NoOfRows := 60;
                                END;

                    SETRANGE(Number, 1, NoOfRows - NoOfRecords);
                END;
            }
            //Sales Shipment Header
            TRIGGER OnPreDataItem()
            VAR
            BEGIN
                CompanyInformationRecG.GET;
                CompanyInformationRecG.CALCFIELDS(Picture);
                CompanyInformationRecG.CALCFIELDS("Old Company Logo");
                CompanyInformationRecG.TESTFIELD("Date Validation - Company Name");
            END;

            //Sales Shipment Header
            TRIGGER OnAfterGetRecord()
            VAR
            BEGIN
                CLEAR(Customer);
                IF Customer.get("Sell-to Customer No.") THEN;
                SrNo := 0;

                //16-06-20214
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
            END;

            //Sales Shipment Header
            TRIGGER OnPostDataItem()
            VAR
            BEGIN
            END;
        }
    }
    TRIGGER OnPreReport()
    BEGIN
    END;

    VAR
        CompanyInformationRecG: Record "Company Information";
        Customer: Record Customer;
        Item: Record Item;
        SrNo: Integer;
        NoOfRecords: Integer;
        NoOfRows: Integer;
        TotalOuter: Decimal;
        MasterCase: Decimal;
        OuterQty: Decimal;
        RecievedQty: Decimal;
        DamagedQty: Decimal;
        ItemUOM: Record "Item Unit of Measure";
        CompNameinArabic: Text[250];
        CompName: TExt[250];
        Bool: Boolean;

}