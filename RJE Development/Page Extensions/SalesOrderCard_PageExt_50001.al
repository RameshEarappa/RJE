pageextension 50001 SalesOrder extends "Sales Order"
{
    layout
    {
        // Add changes to page layout hereadd
        addlast(General)
        {
            field("Sales Channel Type"; Rec."Sales Channel Type")
            {
                ApplicationArea = All;
            }
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
            }
            field("Order/Invoice Type"; Rec."Order/Invoice Type")
            {
                ApplicationArea = All;
                Caption = 'Order Type';
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