tableextension 60001 "Ext. Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(60000; "Production Date"; Date) { DataClassification = ToBeClassified; }
    }

    var
        myInt: Integer;
}