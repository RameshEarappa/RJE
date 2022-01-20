tableextension 50012 "Ext. Check Ledger Entry" extends "Check Ledger Entry"
{
    fields
    {
        field(50150; "Ref Check No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50151; "Ref Check Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50152; Narration; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}