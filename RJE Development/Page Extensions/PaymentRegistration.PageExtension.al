pageextension 50010 "Payment Registration Ext" extends "Payment Registration"
{
    layout
    {
        addafter(ExternalDocumentNo)
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