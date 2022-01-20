pageextension 50029 "Whse. Item Tracking Lines" extends "Whse. Item Tracking Lines"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("Production Date"; Rec."Production Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
