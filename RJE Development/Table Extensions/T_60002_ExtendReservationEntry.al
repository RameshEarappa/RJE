tableextension 60002 "Ext. Reservation Entry" extends "Reservation Entry"
{
    fields
    {
        field(60000; "Production Date"; Date) { DataClassification = ToBeClassified; }
    }
    var
        myInt: Integer;
}