table 50009 "Transfer Order Proposal Header"
{
    Caption = 'Transfer Order Proposal Header';
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.", "Transfer-To Code";

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
            trigger OnValidate()
            var
                Reclocation: Record Location;
            begin
                if Reclocation.GET("Transfer-To Code") then begin
                    Validate("Salesperson Code", Reclocation."Sales Person");
                    Validate("Transfer-From Code", Reclocation."Default Replenishment Whse.");
                end;
            end;
        }
        field(4; "Transfer-From Code"; Code[20])
        {
            Caption = 'Transfer-From Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                Reclocation: Record Location;
            begin
                if Reclocation.GET("Transfer-From Code") then
                    Validate("Transfer-From Salesperson Code", Reclocation."Sales Person");

            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Salesperson Code"; Code[20])
        {
            Caption = 'Transfer-To Salesperson Code';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecSalesperson: Record "Salesperson/Purchaser";
            begin
                if RecSalesperson.GET("Salesperson Code") then
                    "Salesperson Name" := RecSalesperson.Name
                else
                    "Salesperson Name" := '';
            end;
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
        field(9; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-To Salesperson Name';
            Editable = false;
        }
        field(13; "Transfer-From Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Code';
            trigger OnValidate()
            var
                RecSalesperson: Record "Salesperson/Purchaser";
            begin
                if RecSalesperson.GET("Transfer-From Salesperson Code") then
                    "Transfer-From Salesperson Name" := RecSalesperson.Name
                else
                    "Transfer-From Salesperson Name" := '';
            end;
        }
        field(14; "Transfer-From Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Name';
            Editable = false;
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
        Lines: Record "Transfer Order Porposal Line";
    begin
        Clear(Lines);
        Lines.SetRange("Transfer Order Entry No.", Rec."Entry No.");
        if Lines.FindSet() then
            Lines.DeleteAll(true);
    end;
}
