pageextension 50020 "LocationCard_Ext" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("Name-Arabic"; Rec."Name-Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter("Use As In-Transit")
        {
            field("Sales Person"; Rec."Sales Person")
            {
                ApplicationArea = All;
            }
            //LT05012021
            field("DR Location"; Rec."DR Location")
            {
                ApplicationArea = All;
            }
            field("Default Replenishment Whse."; Rec."Default Replenishment Whse.")
            {
                ApplicationArea = All;
                Enabled = Rec."DR Location" = TRUE;
            }
            //LT05012021
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}