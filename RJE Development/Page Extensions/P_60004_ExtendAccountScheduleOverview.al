pageextension 60004 "Ext. Account Schedule Overview" extends "Acc. Schedule Overview"
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