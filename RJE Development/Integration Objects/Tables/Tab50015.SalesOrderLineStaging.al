table 50015 "Sales Order Line Staging"
{
    Caption = 'Sales Order Line Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order Entry No."; Integer)
        {
            Caption = 'Sales Order Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(6; "Free Sample Quantity"; Decimal)
        {
            Caption = 'Free Sample Quantity';
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(8; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(9; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
        }
        field(11; "Amount Inc. VAT"; Decimal)
        {
            Caption = 'Amount Inc. VAT';
            DataClassification = ToBeClassified;
        }
        field(12; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210513 Vuse Device Discounting Price-
        field(14; "Line Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210513 Vuse Device Discounting Price+
    }
    keys
    {
        key(PK; "Sales Order Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
