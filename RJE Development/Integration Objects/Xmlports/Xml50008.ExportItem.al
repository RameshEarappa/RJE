xmlport 50008 "Export Item"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(ItemMaster)
        {
            textelement(Items)
            {
                XmlName = 'Item';
                tableelement(Item; Item)
                {
                    XmlName = 'ItemModel';
                    fieldelement(ItemCode; Item."No.")
                    {

                    }
                    Textelement(ItemDescription)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ItemDescription := CopyStr(Item.Description, 1, 50);
                        end;
                    }
                    textelement(ItemShortDescription)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ItemShortDescription := CopyStr(Item."Description 2", 1, 30);
                        end;
                    }

                    textelement(ArabicItemDescription)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ArabicItemDescription := CopyStr(Item."Description-Arabic", 1, 50);
                        end;
                    }

                    fieldelement(ItemSubCategoryCode; Item."Item Category Code")
                    {

                    }
                    fieldelement(ItemCategory; Item.Category)
                    {

                    }
                    fieldelement(UnitofMeasure; Item."Base Unit of Measure")
                    {

                    }
                    fieldelement(SecondUnitOfMeasure; Item."Sales Unit of Measure")
                    {

                    }
                    textelement(UnitsPerCase)
                    {
                        trigger OnBeforePassVariable()
                        var
                            myInt: Integer;
                        begin
                            UnitsPerCase := '1';//Format(Item."Unit Price", 0, 1);//Hardocded 
                        end;
                    }
                    textelement(VATPercent)
                    {
                        trigger OnBeforePassVariable()
                        var
                            IntegrationSetup: Record "Integration Setup";
                        begin
                            IntegrationSetup.GET;
                            VATPercent := Format(IntegrationSetup."Item VAT%");
                        end;
                    }
                    fieldelement(ItemBarcode; Item.Barcode)
                    {

                    }
                    fieldelement(CaseBarCode; Item."Master Barcode")
                    {

                    }
                    Textelement(FOCItem)
                    {
                        trigger OnBeforePassVariable()
                        var
                            myInt: Integer;
                        begin
                            if Item."FOC Item" then
                                FOCItem := '1'
                            else
                                FOCItem := '0';
                        end;
                    }
                    fieldelement(Brand; Item.Brand)
                    {

                    }
                    fieldelement(Category; Item.Category)
                    {

                    }
                    textelement(ActiveStatus)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if Item.Active then
                                ActiveStatus := '1'
                            else
                                ActiveStatus := '0';
                            //Other than Active in BC will considered as In-Active-WRITTEN IN FIELD MAPPING DOCUMENT
                        end;
                    }
                    //30-12-2020
                    textelement(Status)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Status := '0';
                        end;
                    }
                    fieldelement(HSCode; Item."HS Code")
                    {

                    }

                }
            }
        }
    }



    var

}