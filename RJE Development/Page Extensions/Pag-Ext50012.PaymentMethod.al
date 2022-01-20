pageextension 50012 "Payment Method" extends "Payment Methods"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Direct Debit")
        {
            field("Mirnah Id"; Rec."Mirnah Id")
            {
                ApplicationArea = All;
            }
        }
    }
}

