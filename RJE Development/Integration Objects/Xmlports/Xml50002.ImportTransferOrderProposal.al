xmlport 50002 "Import Transfer Order Proposal"
{
    Direction = Import;
    UseDefaultNamespace = true;
    schema
    {
        textelement(TransferOrders)
        {
            tableelement(TransferOrderHeader; "Transfer Order Proposal Header")
            {
                fieldelement(No; TransferOrderHeader."No.")
                {
                }
                fieldelement(PostingDate; TransferOrderHeader."Posting Date")
                {
                }
                fieldelement(RequestDate; TransferOrderHeader."Request Date")
                {
                }
                /*fieldelement(TransferFromCode; TransferOrderHeader."Transfer-From Code")
                {//Replenishing Warehosue by default no need to get it from Mirnah
                }*/
                fieldelement(TransferToCode; TransferOrderHeader."Transfer-To Code")
                {
                }
                Textelement(SalespersonCode)
                {

                }
                tableelement(Lines; "Transfer Order Porposal Line")
                {
                    LinkTable = TransferOrderHeader;
                    LinkFields = "Transfer Order Entry No." = field("Entry No.");

                    fieldelement(ItemNo; Lines."Item No.")
                    {
                    }
                    fieldelement(Quantity; Lines.Quantity)
                    {
                    }
                    fieldelement(UnitOfMeasure; Lines."Unit of Measure")
                    {

                    }
                    /* not required by mirnah
                    fieldelement(Description; Lines.Description)
                    {
                    }
                    fieldelement(BinCode; Lines."Bin Code")
                    {
                    }
                    fieldelement(LotNo; Lines."Lot No.")
                    {
                    }*/
                    trigger OnBeforeInsertRecord()
                    var
                        RecLines: Record "Transfer Order Porposal Line";
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
                    RecHeader: Record "Transfer Order Proposal Header";
                begin
                    Clear(RecHeader);
                    RecHeader.SetCurrentKey("Entry No.");
                    if RecHeader.FindLast() then
                        TransferOrderHeader."Entry No." := RecHeader."Entry No." + 1
                    else
                        TransferOrderHeader."Entry No." := 1;
                    TransferOrderHeader."Transfer Order No." := 'LD-' + CopyStr(TransferOrderHeader."Transfer-To Code", StrLen(TransferOrderHeader."Transfer-To Code") - 4, StrLen(TransferOrderHeader."Transfer-To Code")) + '-' + FORMAT(TransferOrderHeader."Posting Date", 0, '<Year,2><Month,2><Day,2>') + '-1';
                    TransferOrderHeader.Status := TransferOrderHeader.Status::"Ready to Sync";
                    TransferOrderHeader."Added on" := CurrentDateTime;
                end;
            }

        }
    }

}
