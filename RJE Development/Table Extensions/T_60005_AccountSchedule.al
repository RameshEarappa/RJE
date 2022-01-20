tableextension 60005 "Ext. Account Schedule" extends "Acc. Schedule Line"
{
    fields
    {
        field(60000; "Description (Arabic)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}