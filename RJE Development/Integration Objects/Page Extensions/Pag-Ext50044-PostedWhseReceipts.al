pageextension 50044 POstedWhseReceiptList extends "Posted Whse. Receipt List"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Mirnah Reference No."; Rec."Mirnah Reference No.")
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

        }
    }
}
