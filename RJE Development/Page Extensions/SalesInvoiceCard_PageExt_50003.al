pageextension 50003 SalesInvoiceCard extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
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
                Caption = 'Invoice Type';
            }
            //-------------FOC Implementation---------------------//
            field("FOC Item Exists"; Rec."FOC Item Exists")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}