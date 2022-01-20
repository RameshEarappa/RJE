table 50006 "Sales Inv. Line Staging"
{
    Caption = 'Sales Inv. Line Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Inv. Entry No."; Integer)
        {
            Caption = 'Sales Inv. Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
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
        field(9; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Zone Code"; Code[20])
        {
            Caption = 'Zone Code';
            DataClassification = ToBeClassified;
        }
        field(11; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(12; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
        }
        field(13; "Amount Inc. VAT"; Decimal)
        {
            Caption = 'Amount Inc. VAT';
            DataClassification = ToBeClassified;
        }
        field(14; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210513 Vuse Device Discounting Price-
        field(16; "Line Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210513 Vuse Device Discounting Price+
    }
    keys
    {
        key(PK; "Sales Inv. Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
