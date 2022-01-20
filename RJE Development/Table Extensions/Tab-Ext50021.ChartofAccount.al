tableextension 50021 "Chart of Account" extends "G/L Account"
{
    fields
    {
        field(50000; "Name in Arabic"; Text[100])
        {
            Caption = 'Name in Arabic';
            DataClassification = ToBeClassified;
        }
    }
}
