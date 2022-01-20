xmlport 50001 "Import Transfer Order Shipment"
{
    Direction = Import;
    UseDefaultNamespace = true;
    //Transfer Order - Transfer Order Creation from VAN WH to Other Warehouse								

    schema
    {
        textelement(TransferOrders)
        {
            tableelement(TransferOrderHeader; "Transfer Order Shipment Header")
            {
                fieldelement(No; TransferOrderHeader."No.")
                {
                }
                fieldelement(PostingDate; TransferOrderHeader."Posting Date")
                {
                }
                /*fieldelement(TransferFromCode; TransferOrderHeader."Transfer-From Code")
                {
                }*/
                fieldelement(TransferToCode; TransferOrderHeader."Transfer-To Code")
                {
                }
                fieldelement(LoadPeriodNo; TransferOrderHeader."Load Period No.")
                {
                }
                tableelement(Lines; "Transfer Order Shipment Line")
                {
                    LinkTable = TransferOrderHeader;
                    LinkFields = "Transfer Order Entry No." = field("Entry No.");

                    fieldelement(ItemNo; Lines."Item No.")
                    {
                    }
                    fieldelement(UnitOfMeasure; Lines."Unit of Measure")
                    {
                    }
                    fieldelement(Quantity; Lines.Quantity)
                    {
                    }
                    /*fieldelement(Description; Lines.Description)
                    {
                    }*/

                    /*fieldelement(BinCode; Lines."Bin Code")
                    {
                    }
                    fieldelement(LotNo; Lines."Lot No.")
                    {
                    }*/
                    trigger OnBeforeInsertRecord()
                    var
                        RecLines: Record "Transfer Order Shipment Line";
                    begin
                        Clear(RecLines);
                        RecLines.SetCurrentKey("Transfer Order Entry No.", "Line No.");
                        RecLines.SetRange("Transfer Order Entry No.", TransferOrderHeader."Entry No.");
                        if RecLines.FindLast() then
                            Lines."Line No." := RecLines."Line No." + 10000
                        else
                            Lines."Line No." := 10000;
                        Lines."Transfer Order No." := TransferOrderHeader."No.";
                        Lines."Transfer Order Entry No." := TransferOrderHeader."Entry No.";
                    end;
                }
                trigger OnBeforeInsertRecord()
                var
                    RecHeader: Record "Transfer Order Shipment Header";
                begin
                    Clear(RecHeader);
                    RecHeader.SetCurrentKey("Entry No.");
                    if RecHeader.FindLast() then
                        TransferOrderHeader."Entry No." := RecHeader."Entry No." + 1
                    else
                        TransferOrderHeader."Entry No." := 1;
                    TransferOrderHeader.Status := TransferOrderHeader.Status::"Ready to Sync";
                    TransferOrderHeader."Added on" := CurrentDateTime;
                end;
            }

        }
    }

}
