tableextension 50029 "Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50000; "Lot No. Assigned"; Boolean)
        {
            Caption = 'Lot No. Assigned';
            DataClassification = ToBeClassified;
        }
        field(50001; "Mirnah Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
