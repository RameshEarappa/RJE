pageextension 50009 "Cash Recpt Jnl ext" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Check No."; Rec."Check No.")
            {
                ApplicationArea = All;
            }
            field("Check Date"; Rec."Check Date")
            {
                ApplicationArea = All;
            }
            field(Narration; Rec.Narration)
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