xmlport 50010 "Export Warehouse Location"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(WarehouseMaster)
        {

            textelement(WarehouseMaster_)
            {
                XmlName = 'WarehouseMaster';
                tableelement(Warehouse; Location)
                {
                    XmlName = 'WarehouseMasterModel';
                    fieldelement(WarehouseID; Warehouse.Code)
                    {
                        //Mirnah will modify the Warehosue Id then we have to send Location Code
                    }
                    fieldelement(WarehouseNameEnglish; Warehouse.Name)
                    {

                    }
                    fieldelement(WarehouseNameArabic; Warehouse."Name-Arabic")
                    {

                    }
                    textelement(VANWarehouse)
                    {
                        trigger OnBeforePassVariable()
                        var
                            myInt: Integer;
                        begin
                            if Warehouse."DR Location" then
                                VANWarehouse := '1'
                            else
                                VANWarehouse := '0';
                        end;
                    }
                    fieldelement(SalesmanCode; Warehouse."Sales Person")
                    {

                    }
                    textelement(ActiveStatus)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //30-12-2020
                            //ActiveStatus := '0';
                            ActiveStatus := '1';
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

                }
            }
        }
    }



    var

}