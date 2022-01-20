table 50019 "Transfer Receipt Line Staging"
{
    Caption = 'Transfer Receipt Line Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transfer Receipt Hdr Entry No."; Integer)
        {
            Caption = 'Transfer Receipt Header Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Transfer Receipt Header No."; Code[20])
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
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Transfer Receipt Hdr Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
