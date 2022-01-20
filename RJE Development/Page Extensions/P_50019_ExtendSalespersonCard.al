pageextension 50019 "Salesperson_Ext" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addlast(General)
        {
            field("Name-Arabic"; Rec."Name-Arabic")
            {
                ApplicationArea = All;
            }
            field("Mirnah Salesper. Active Status"; Rec."Mirnah Salesper. Active Status")
            {
                ApplicationArea = All;
                Caption = 'Mirnah Salesperson Active Status';
            }
            field("Bank Account"; Rec."Bank Account")
            {
                ApplicationArea = All;
            }
            field("G/L Account"; Rec."G/L Account")
            {
                ApplicationArea = All;
            }
        }
        addafter("Commission %")
        {
            field("Mirnah Desigination Code"; Rec."Mirnah Desigination Code")
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