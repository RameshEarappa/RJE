pageextension 50027 "Bank Account card" extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
