xmlport 50007 "Export Customer"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(CustomerMaster)
        {
            textelement(Customers)
            {
                XmlName = 'Customer';
                tableelement(Customer; Customer)
                {
                    XmlName = 'CustomerModel';
                    fieldelement(BATCustomerCode; Customer."No.")
                    {

                    }
                    textelement(CustomerName)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            CustomerName := CopyStr(Customer.Name, 1, 50);
                        end;
                    }
                    textelement(ArabicCustomerName)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ArabicCustomerName := CopyStr(Customer."Name-Arabic", 1, 50);
                        end;
                    }
                    textelement(Type)//Customer."Customer Type")
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Type := '1';
                        end;
                    }
                    fieldelement(HeadOfficeCode; Customer."Bill-to Customer No.")
                    {

                    }
                    textelement(CustomerAddress1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            CustomerAddress1 := CopyStr(Customer.Address, 1, 50);
                        end;
                    }
                    textelement(CustomerAddress2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            CustomerAddress2 := CopyStr(Customer."Address 2", 1, 50);
                        end;
                    }
                    textelement(ArabicCustomerAddress1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ArabicCustomerAddress1 := CopyStr(Customer."Address 1 - Arabic", 1, 50);
                        end;
                    }
                    textelement(ArabicCustomerAddress2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ArabicCustomerAddress2 := CopyStr(Customer."Address 2 - Arabic", 1, 50);
                        end;
                    }
                    fieldelement(ContactName; Customer.Contact)
                    {

                    }
                    fieldelement(Phone; Customer."Phone No.")
                    {

                    }
                    fieldelement(OutletBarcode; Customer."Outlet Barcode")
                    {

                    }
                    fieldelement(DropSize; Customer."Drop Size")
                    {

                    }
                    Textelement(OpenforSales)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if (Customer.Blocked = Customer.Blocked::" ") then
                                OpenforSales := '1'
                            else
                                OpenforSales := '0';
                        end;
                    }
                    Textelement(ReturnsAccepted)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if Customer."Returns Accepted" then
                                ReturnsAccepted := '1'
                            else
                                ReturnsAccepted := '0';
                        end;
                    }
                    Textelement(ISFAvailable)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if Customer."ISF Available" then
                                ISFAvailable := '1'
                            else
                                ISFAvailable := '0';
                        end;

                    }
                    fieldelement(ISFFreeText; Customer."ISF Free Text")
                    {

                    }
                    fieldelement(WarehouseLocation; Customer."Location Code")
                    {

                    }
                    fieldelement(CustomerType; Customer."Customer Type")
                    {
                        //doubt
                    }
                    fieldelement(KeyAccount; Customer."Key Account")
                    {

                    }
                    fieldelement(SalesChannelType; Customer."Sales Channel Type")
                    {

                    }
                    fieldelement(Branch; Customer.Branch)
                    {

                    }
                    textelement(InvoicePaymentTerms)// Customer."Payment Terms Code")
                    {
                        trigger OnBeforePassVariable()
                        var
                            RecPaymentMethod: Record "Payment Method";
                        begin
                            // InvoicePaymentTerms := CopyStr(Customer."Payment Method Code", StrLen(Customer."Payment Method Code") - 2, StrLen(Customer."Payment Method Code"));
                            If Customer."Payment Method Code" <> '' then begin
                                RecPaymentMethod.Get(Customer."Payment Method Code");
                                InvoicePaymentTerms := Format(RecPaymentMethod."Mirnah Id");
                            end;
                        end;
                    }
                    textelement(ARCustomerType)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ARCustomerType := '0';
                            //Hardcoded as discussed to send 0
                        end;
                    }
                    fieldelement(NoofInvoices; Customer."Max QTY of Open Invoices")
                    {
                        /*trigger OnBeforePassVariable()
                        begin
                            Customer.CalcFields("No. of Invoices");
                            NoofInvoices := Format(Customer."No. of Invoices");
                        end;*/
                        //flowfield
                    }
                    textelement(CreditLimitDays)
                    {
                        trigger OnBeforePassVariable()
                        var
                            RecPT: Record "Payment Terms";
                        begin
                            if Customer."Payment Terms Code" <> '' then begin
                                Clear(RecPT);
                                RecPT.get(Customer."Payment Terms Code");
                                CreditLimitDays := FORMAT(CalcDate(RecPT."Due Date Calculation", Today) - Today);
                            end;
                        end;
                    }
                    textelement(CreditLimit)
                    {
                        trigger OnBeforePassVariable()
                        var
                            myInt: Integer;
                        begin
                            CreditLimit := Format(Customer."Credit Limit (LCY)", 0, 1);
                        end;
                    }
                    fieldelement(VATNumber; Customer."VAT Registration No.")
                    {

                    }
                    Fieldelement(PricingKey; Customer."Customer Price Group")
                    {
                        /*trigger OnBeforePassVariable()
                        var
                            RecCPG: Record "Customer Price Group";
                        begin
                            if Customer."Customer Price Group" <> '' then begin
                                RecCPG.GET(Customer."Customer Price Group");
                                PricingKey := Format(RecCPG."Mirnah Id");
                                //Customer Price Group
                            end;
                        end;*/
                    }
                    textelement(ActiveStatus)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if Customer."Status" = 'ACTIVE' then
                                ActiveStatus := '1'
                            else
                                ActiveStatus := '0';
                            //Other than Active in BC will considered as In-Active-WRITTEN IN FIELD MAPPING DOCUMENT
                        end;

                    }
                    textelement(Status)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Status := '0';
                        end;
                    }
                    //TT-RS-20210609-
                    Fieldelement(CustomerPriceGroup; Customer."Customer Price Group")
                    {
                        XmlName = 'CustomerPriceGroup';
                    }
                    Fieldelement(CustomerPromotionGroup; Customer."Sales Promotion Group")
                    {
                        XmlName = 'CustomerPromotionGroup';
                    }
                    Fieldelement(CustomerDiscountGroup; Customer."Customer Disc. Group")
                    {
                        XmlName = 'CustomerDiscountGroup';
                    }
                    textelement(IssueInvoiceOnOverdue)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IssueInvoiceOnOverdue := '0';
                        end;
                    }
                    //TT-RS-20210609+

                }
            }

        }
    }



    var

}