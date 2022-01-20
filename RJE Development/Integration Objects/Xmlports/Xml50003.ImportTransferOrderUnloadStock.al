xmlport 50003 "Import Transfer Order Unload"
{
    Caption = 'Import Transfer Order UnloadStock';
    Direction = Import;
    UseDefaultNamespace = true;
    schema
    {
        textelement(TransferOrders)
        {
            tableelement(TransferOrderHeader; "Transfer Order Unload Header")
            {
                fieldelement(No; TransferOrderHeader."No.")
                {
                }
                fieldelement(PostingDate; TransferOrderHeader."Posting Date")
                {
                }
                fieldelement(TransferFromCode; TransferOrderHeader."Transfer-From Code")
                {
                }
                fieldelement(SalespersonCode; TransferOrderHeader."Salesperson Code")
                {

                }
                /*fieldelement(TransferToCode; TransferOrderHeader."Transfer-To Code")
                { Not Required
                }*/
                tableelement(Lines; "Transfer Order Unload Line")
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
                        RecLines: Record "Transfer Order Unload Line";
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
                    RecHeader: Record "Transfer Order Unload Header";
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
