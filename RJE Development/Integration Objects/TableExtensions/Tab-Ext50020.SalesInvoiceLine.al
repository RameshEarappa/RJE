tableextension 50020 "Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Free Sample Quantity"; Decimal)
        {
            Caption = 'Free Sample Quantity';
            DataClassification = ToBeClassified;
        }
        field(50002; "FOC Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Price List Applied"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Promotion Code Applied"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
