pageextension 50031 "User Setup" extends "User Setup"
{
    layout
    {
        addbefore("Time Sheet Admin.")
        {
            field("Enable Error Notification"; Rec."Enable Error Notification")
            {
                ApplicationArea = All;
            }
            field("Allow Transfer Order Posting"; Rec."Allow Transfer Order Posting")
            {
                ApplicationArea = All;
            }
        }
    }
}
