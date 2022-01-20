xmlport 50009 "Export Salesperson"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(SalesmanMaster)
        {
            textelement(Salesman_)
            {
                XmlName = 'Salesman';
                tableelement("Salesman"; "Salesperson/Purchaser")
                {
                    XmlName = 'SalesmanModel';
                    fieldelement(SalesmanCode; "Salesman".Code)
                    {

                    }
                    fieldelement(SalesmanName; "Salesman".Name)
                    {

                    }
                    fieldelement(ArabicSalesmanName; "Salesman"."Name-Arabic")
                    {

                    }
                    Textelement(SalesmanDesignation)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //30-12-2020
                            //SalesmanDesignation := '1';
                            //SalesmanDesignation := '8';
                            //4FEB2021
                            SalesmanDesignation := FORMAT(Salesman."Mirnah Desigination Code".AsInteger());
                        end;
                    }

                    textelement(ActiveStatus)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if Salesman."Mirnah Salesper. Active Status" then
                                ActiveStatus := '1'
                            else
                                ActiveStatus := '0';
                        end;
                    }
                    textelement(Status)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Status := '0';
                        end;
                    }
                }
            }
        }
    }
}