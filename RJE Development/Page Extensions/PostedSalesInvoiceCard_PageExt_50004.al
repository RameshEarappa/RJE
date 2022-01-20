pageextension 50004 PostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Sales Channel Type"; Rec."Sales Channel Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //-------------FOC Implementation---------------------//
            field("FOC Item Exists"; Rec."FOC Item Exists")
            {
                ApplicationArea = All;
                Editable = false;
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