pageextension 50033 TransferLineSubform extends "Transfer Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Lot No. Assigned"; Rec."Lot No. Assigned")
            {
                ApplicationArea = All;
            }
        }
    }
}
