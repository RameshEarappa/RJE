/*xmlport 50014 "Export Stock Invenoty"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(WarehouseStocks_)
        {
            XmlName = 'WarehouseStocks';
            textelement(WarehouseStocks__)
            {
                XmlName = 'WarehouseStocks';
                tableelement(WarehouseStocks; "Item Ledger Entry")
                {
                    XmlName = 'WarehouseStocksModel';
                    textelement(GRNID)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GRNID := '0.0';// Sending Default Value as Discussed with Affan and Team
                        end;
                    }
                    fieldelement(WarehouseID; WarehouseStocks."Location Code")
                    {
                        //Mirnah will modify the Warehosue Id then we have to send Location Code
                    }
                    fieldelement(WarehouseNameEnglish; WarehouseStocks."Location Code")
                    {
                    }
                    fieldelement(ItemCode; WarehouseStocks."Item No.")
                    {
                    }
                    textelement(HSCode)
                    {
                        trigger OnBeforePassVariable()
                        var
                            RecItem: Record Item;
                        begin
                            RecItem.Get(WarehouseStocks."Item No.");
                            HSCode := RecItem."Tariff No.";
                        end;
                    }
                    fieldelement(StocksQty; WarehouseStocks.Quantity)
                    {

                    }
                    fieldelement(UnitofMeasure; WarehouseStocks."Unit of Measure Code")
                    {
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

}*/
xmlport 50014 "Export Stock Invenoty"
{
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    InlineSchema = false;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://mtsbx.org/';

    schema
    {
        textelement(WarehouseStocks_)
        {
            XmlName = 'WarehouseStocks';
            textelement(WarehouseStocks__)
            {
                XmlName = 'WarehouseStocks';
                tableelement(WarehouseStocks; "Bin Content")
                {
                    XmlName = 'WarehouseStocksModel';
                    textelement(GRNID)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GRNID := '0.0';// Sending Default Value as Discussed with Affan and Team
                        end;
                    }
                    fieldelement(WarehouseID; WarehouseStocks."Location Code")
                    {
                        //Mirnah will modify the Warehosue Id then we have to send Location Code
                    }
                    fieldelement(WarehouseNameEnglish; WarehouseStocks."Location Code")
                    {
                    }
                    fieldelement(ItemCode; WarehouseStocks."Item No.")
                    {
                    }
                    textelement(HSCode)
                    {
                        trigger OnBeforePassVariable()
                        var
                            RecItem: Record Item;
                        begin
                            RecItem.Get(WarehouseStocks."Item No.");
                            HSCode := RecItem."HS Code";
                        end;
                    }
                    Textelement(StocksQty)
                    {
                        trigger OnBeforePassVariable()
                        var
                            RecSalesLine: Record "Sales Line";
                        begin
                            //LTV1.01
                            //WarehouseStocks.CalcFields(Quantity);
                            //StocksQty := Format(WarehouseStocks.Quantity, 0, 1);
                            WarehouseStocks.CalcFields("Quantity (Base)");
                            //StocksQty := Format(WarehouseStocks."Quantity (Base)", 0, 1);//commented on 22FEB2021
                            //LTV1.01

                            //Change - 22FEB2021-Krishna
                            Clear(RecSalesLine);
                            RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                            RecSalesLine.SetRange("No.", WarehouseStocks."Item No.");
                            RecSalesLine.SetRange("Location Code", WarehouseStocks."Location Code");
                            if RecSalesLine.FindSet() then
                                RecSalesLine.CalcSums("Outstanding Quantity");
                            StocksQty := Format(WarehouseStocks."Quantity (Base)" - RecSalesLine."Outstanding Quantity", 0, 1);
                        end;
                    }
                    fieldelement(UnitofMeasure; WarehouseStocks."Unit of Measure Code")
                    {
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