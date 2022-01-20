pageextension 60000 "Ext. Item Track Line" extends "Item Tracking Lines"
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

    actions
    {
    }

    var
        myInt: Integer;
}