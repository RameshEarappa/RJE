xmlport 50013 "Export Open Invoices"
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
                tableelement(OpenInvoice; "Cust. Ledger Entry")
                {
                    XmlName = 'OpenInvoiceModel';
                    fieldelement(VoucherNumer; OpenInvoice."Document No.")
                    {
                        //Sending Document no as discussed with affan and Team
                    }
                    Fieldelement(CustomerNumber; OpenInvoice."Customer No.")
                    {
                    }
                    fieldelement(Salesmancode; OpenInvoice."Salesperson Code")
                    {
                    }
                    fieldelement(InvoiceNumber; OpenInvoice."Document No.")
                    {
                    }
                    textelement(InvoiceDate)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            InvoiceDate := FORMAT(OpenInvoice."Posting Date", 0, '<standard,9>');
                        end;
                    }
                    Textelement(TotalInvoiceAmount)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            OpenInvoice.CalcFields(Amount);
                            TotalInvoiceAmount := FORMAT(OpenInvoice.Amount, 0, 1);
                        end;
                    }
                    Textelement(InvoiceBalance)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            OpenInvoice.CalcFields("Remaining Amount");
                            InvoiceBalance := FORMAT(OpenInvoice."Remaining Amount", 0, 1);
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
                            if SalesInvHeader.get(OpenInvoice."Document No.") then
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