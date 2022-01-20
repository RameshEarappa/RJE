xmlport 50015 "Export Open Invoices From Cust"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(OpenInvoices)
        {
            XmlName = 'OpenInvoice';
            textelement(OpenInvoice_)
            {
                XmlName = 'OpenInvoice';
                tableelement(OpenInvoice; Customer)
                {
                    XmlName = 'OpenInvoiceModel';
                    Textelement(VoucherNumer)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            VoucherNumer := 'BCTEST0001';
                        end;
                        //Sending Document no as discussed with affan and Team
                    }
                    Fieldelement(CustomerNumber; OpenInvoice."No.")
                    {
                    }
                    fieldelement(Salesmancode; OpenInvoice."Salesperson Code")
                    {
                    }
                    Textelement(InvoiceNumber)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            InvoiceNumber := 'BCTEST0001';
                        end;
                    }
                    textelement(InvoiceDate)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            InvoiceDate := FORMAT(CALCDATE('<-CY>', Today), 0, '<standard,9>');
                        end;
                    }
                    Textelement(TotalInvoiceAmount)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            // OpenInvoice.CalcFields(Amount);
                            TotalInvoiceAmount := '0.0';//FORMAT(OpenInvoice.Amount, 0, 1);
                        end;
                    }
                    Textelement(InvoiceBalance)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //OpenInvoice.CalcFields("Remaining Amount");
                            InvoiceBalance := '0.0'; //FORMAT(OpenInvoice."Remaining Amount", 0, 1);
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
                    textelement(DueDate)
                    {
                        trigger OnBeforePassVariable()
                        var
                            SalesInvHeader: Record "Sales Invoice Header";
                        begin
                            Clear(SalesInvHeader);
                            if SalesInvHeader.get(InvoiceNumber) then
                                DueDate := Format(SalesInvHeader."Due Date", 0, '<standard,9>')
                            else
                                DueDate := InvoiceDate;
                        end;
                    }
                    //TT-RS-20210609-

                }
            }
        }
    }



    var

}