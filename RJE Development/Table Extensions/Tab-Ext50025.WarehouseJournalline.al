tableextension 50025 "Warehouse Journal line" extends "Warehouse Journal Line"
{
    fields
    {
        field(50000; "C Lot No."; Code[20])
        {
            Caption = 'C Lot No.';
            DataClassification = ToBeClassified;
        }
        field(60000; "C Production Date"; Date)
        {
            Caption = 'C Production Date';
            DataClassification = ToBeClassified;
        }
        field(50002; "C Expiration Date"; Date)
        {
            Caption = 'C Expiration Date';
            DataClassification = ToBeClassified;
        }
    }
}
