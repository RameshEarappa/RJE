pageextension 50008 "GenJnl Ext" extends "General Journal"
{
    layout
    {
        moveafter(Amount; "Debit Amount")
        moveafter("Amount (LCY)"; "Credit Amount")
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

            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}