xmlport 50011 "Export Transfer Order"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(LoadMaster)
        {
            XmlName = 'Load';
            textelement(Loads)
            {
                XmlName = 'Load';
                tableelement(Load; "Transfer Line")
                {
                    XmlName = 'LoadModel';
                    Textelement(LoadID)
                    {
                        // Mirnah will modify it to accept Code 20 - Need to TO No.
                        trigger OnBeforePassVariable()
                        begin
                            if Load."Mirnah Reference No." <> '' then
                                LoadID := Load."Mirnah Reference No."
                            else
                                LoadID := Load."Document No.";
                        end;
                    }
                    fieldelement(RouteCode; Load."Transfer-to Code")
                    {

                    }
                    fieldelement(FromWarehouse; Load."Transfer-from Code")
                    {

                    }
                    //30-12-2020
                    Textelement(LoadDate)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //LoadDate := FORMAT(CreateDateTime(Load."Posting Date", 0T));
                            LoadDate := Format(Load."Shipment Date", 0, '<standard,9>'); //FORMAT(Load."Posting Date", 10, '<Year4>/<Month,2>/<Day,2>');
                        end;
                    }
                    textelement(LoadPeriodNumber)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            LoadPeriodNumber := '1';// Default value 1 as discussed with Affan
                        end;
                    }
                    fieldelement(ItemCode; Load."Item No.")
                    {
                    }
                    fieldelement(UnitofMeasure; Load."Unit of Measure")
                    {
                        //31-12-2020
                    }

                    textelement(LoadQty)//Load.Quantity)
                    {
                        //31-12-2020
                        trigger OnBeforePassVariable()
                        begin
                            LoadQty := Format(Load."Quantity Shipped", 0, 1);
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