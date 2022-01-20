pageextension 50042 POstedTransferShipmentList extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field("Created By API"; Rec."Created By API")
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
