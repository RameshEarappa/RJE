pageextension 60001 "Ext. Item Ledger Entries" extends "Item Ledger Entries"
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