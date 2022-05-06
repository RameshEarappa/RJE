pageextension 50043 POstedTransferReceiptList extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field("Created By API"; Rec."Created By API")
            {
                ApplicationArea = All;
                Caption = 'VAN Loading TO';
                Editable = false;
            }
            field("VAN Unloading TO"; Rec."VAN Unloading TO")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
    }
}
