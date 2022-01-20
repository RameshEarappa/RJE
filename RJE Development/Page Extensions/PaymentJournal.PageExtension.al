pageextension 50011 "Extend Payment Voucher" extends "Payment Journal"
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
        }
    }
}