tableextension 50018 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "Free Sample Quantity"; Decimal)
        {
            Caption = 'Free Sample Quantity';
            DataClassification = ToBeClassified;
        }
        field(50001; "Lot No. Assigned"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //-------------FOC Implementation---------------------//
        field(50002; "FOC Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        //30.07.2021
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