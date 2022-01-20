pageextension 60003 "Ext. Account Schedule" extends "Account Schedule"
{
    layout
    {
        addafter(Description)
        {
            field("Description (Arabic)"; Rec."Description (Arabic)")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}