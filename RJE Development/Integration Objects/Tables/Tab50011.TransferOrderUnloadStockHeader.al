table 50011 "Transfer Order Unload Header"
{
    Caption = 'Transfer Order UnloadStock Header';
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.", "Transfer-From Code";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Transfer-To Code"; Code[20])
        {
            Caption = 'Transfer-To Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            ValidateTableRelation = false;
        }
        field(4; "Transfer-From Code"; Code[20])
        {
            Caption = 'Transfer-From Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            ValidateTableRelation = false;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Ready to Sync",Synced,"Error";
        }
        field(8; "Error Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        //Added on 8FRB2022 for Agility Automation
        field(10; "Day End Process Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Success,Failed;
        }
        field(11; "Day End Process Error"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PK2; "No.")
        {

        }
    }
    trigger OnDelete()
    var
        Lines: Record "Transfer Order Unload Line";
    begin
        Clear(Lines);
        Lines.SetRange("Transfer Order Entry No.", Rec."Entry No.");
        if Lines.FindSet() then
            Lines.DeleteAll(true);
    end;
}
