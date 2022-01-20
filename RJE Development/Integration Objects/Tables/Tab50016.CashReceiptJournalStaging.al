table 50016 "Cash Receipt Journal Staging"
{
    Caption = 'Cash Receipt Journal Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(5; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
        }
        field(6; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(8; "Salesperson/Purchaser Code"; Code[20])
        {
            Caption = 'Salesperson/Purchaser Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = false;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(10; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
        }
        field(11; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
        }
        field(12; "Applies-To Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-To Doc. Type';
            DataClassification = ToBeClassified;
        }
        field(13; "Applies-To Doc. No."; Code[20])
        {
            Caption = 'Applies-To Doc. No.';
            DataClassification = ToBeClassified;
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Ready To Sync",Synced,Error;
        }
        field(15; "Error Remarks"; Text[250])
        {
            Caption = 'Error Remarks';
            DataClassification = ToBeClassified;
        }
        field(16; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Payment Method"; Code[20])
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
    }

    var
        avc: Record "Gen. Journal Line";
}
