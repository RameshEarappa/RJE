pageextension 50045 POstedWhseShipmentList extends "Posted Whse. Shipment List"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Mirnah Reference No."; Rec."Mirnah Reference No.")
            {
                ApplicationArea = All;
                Caption = 'VAN Loading TO';
                Editable = false;
            }
            field("VAN Unloading TO"; Rec."VAN Unloading TO")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
    }
}
