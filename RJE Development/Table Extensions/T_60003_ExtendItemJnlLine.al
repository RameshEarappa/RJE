tableextension 60003 "Ext. Item Jnl. Line" extends "Item Journal Line"
{
    fields
    {
        //15APR2021
        field(50000; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Transfer Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //15APR2021
        field(60000; "Production Date"; Date) { DataClassification = ToBeClassified; }
        FIELD(60001; "Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Reconciled"; Boolean) { DataClassification = ToBeClassified; }
        modify("Qty. (Phys. Inventory)")
        {
            TRIGGER OnAfterValidate()
            BEGIN
                IF CurrFieldNo = FieldNo("Qty. (Phys. Inventory)") THEN BEGIN
                    IF "Qty. (Calculated)" = "Qty. (Phys. Inventory)" THEN
                        Reconciled := TRUE
                    ELSE
                        Reconciled := FALSE;
                END;
            END;
        }
    }

    var
        myInt: Integer;
}