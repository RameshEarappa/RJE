pageextension 50025 "GL card" extends "G/L Account Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name in Arabic"; Rec."Name in Arabic")
            {
                ApplicationArea = All;
            }
        }
    }
}
