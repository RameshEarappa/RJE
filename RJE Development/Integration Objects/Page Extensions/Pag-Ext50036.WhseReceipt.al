pageextension 50036 "Whse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        addafter("Assignment Time")
        {
            field("Mirnah Reference No."; Rec."Mirnah Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Created By API"; Rec."Created By API")
            {
                ApplicationArea = All;
                Caption = 'VAN Loading TO';
                Editable = false;
            }
            field(Confirmed; Rec.Confirmed)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Request Date"; Rec."Request Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
                Caption = 'Transfer-To Salesperson Code';
                Editable = false;
            }
            field("Salesperson Name"; Rec."Salesperson Name")
            {
                ApplicationArea = All;
                Caption = 'Transfer-To Salesperson Name';
                Editable = false;
            }
            field("Transfer-From Salesperson Code"; Rec."Transfer-From Salesperson Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Transfer-From Salesperson Name"; Rec."Transfer-From Salesperson Name")
            {
                ApplicationArea = All;
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
