pageextension 50023 "Posted sales invoice subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Free Sample Quantity"; Rec."Free Sample Quantity")
            {
                ApplicationArea = All;
            }
            field("Price List Applied"; Rec."Price List Applied")
            {
                ApplicationArea = All;
            }
            field("Promotion Code Applied"; Rec."Promotion Code Applied")
            {
                ApplicationArea = All;
            }
        }
    }
}