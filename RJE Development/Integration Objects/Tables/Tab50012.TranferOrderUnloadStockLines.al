table 50012 "Transfer Order Unload Line"
{
    Caption = 'Transfer Order UnloadStock Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transfer Order Entry No."; Integer)
        {
            Caption = 'Transfer Order Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(5; Description; Code[20])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(7; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(8; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(9; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Transfer Order Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
