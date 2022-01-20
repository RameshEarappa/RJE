xmlport 50012 "Export Sales Price"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(PricingMasters)
        {
            XmlName = 'PricingMaster';
            textelement(PricingMaster_)
            {
                XmlName = 'PricingMaster';
                tableelement(PricingMaster; "Sales Price")
                {
                    XmlName = 'PricingMasterModel';
                    fieldelement(SpecialPricingKey; PricingMaster."Sales Code")
                    {
                        //Mirnah will modify it to accept Code - Need to send Salescode.
                    }
                    fieldelement(ItemCode; PricingMaster."Item No.")
                    {
                        //Mirhan will modify it to accept code- need to send Item code
                    }
                    Textelement(StartDate)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //31-12-2020
                            StartDate := Format(PricingMaster."Starting Date", 0, '<standard,9>');//FORMAT(CreateDateTime(PricingMaster."Starting Date", 0T));
                        end;
                    }
                    textelement(EndDate)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //31-12-2020
                            //EndDate := Format(PricingMaster."Ending Date", 0, '<standard,9>'); //Format(CreateDateTime(PricingMaster."Ending Date", 0T))
                            //If there is no date then send Today as default date
                            if PricingMaster."Ending Date" = 0D then
                                EndDate := Format(CALCDATE('1Y', PricingMaster."Starting Date"), 0, '<standard,9>')
                            else
                                EndDate := Format(PricingMaster."Ending Date", 0, '<standard,9>'); //Format(CreateDateTime(PricingMaster."Ending Date", 0T))
                        end;
                    }
                    fieldelement(SalesPrice; PricingMaster."Unit Price")
                    {

                    }
                    fieldelement(ReturnPrice; PricingMaster."Unit Price")
                    {
                    }
                    fieldelement(UnitofMeasure; PricingMaster."Unit of Measure Code")
                    {

                    }
                    Textelement(Description)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Description := CopyStr(PricingMaster.Description, 1, 30);
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



    var

}