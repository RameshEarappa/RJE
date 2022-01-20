pageextension 50041 SalesLineDiscount_ext extends "Sales Line Discounts"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Promotion Code"; Rec."Promotion Code")
            {
                ApplicationArea = All;
            }
        }
    }
}