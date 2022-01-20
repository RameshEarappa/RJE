tableextension 60000 "Ext. Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        field(60000; "Production Date"; Date)
        {
            DataClassification = ToBeClassified;
            TRIGGER ONVALIDATE()
            BEGIN
            END;
        }

        modify("Lot No.")
        {
            TRIGGER OnAfterValidate()
            BEGIN
                InitProdDate();
            END;
        }

    }

    procedure InitProdDate()
    VAR
        ItemTrackingMgt: Codeunit "Item Tracing Mgt.";
        ProdDate: Date;
        ItemLedgEntry: Record "Item Ledger Entry";
    BEGIN
        IF ("Serial No." = xRec."Serial No.") AND ("Lot No." = xRec."Lot No.") THEN
            EXIT;
        "Production Date" := 0D;
        IF GetLotSNDataSet("Item No.", "Variant Code", "Lot No.", "Serial No.", ItemLedgEntry) THEN
            "Production Date" := ItemLedgEntry."Production Date";
    END;

    procedure GetLotSNDataSet(ItemNo: Code[20];
                              Variant: Code[20];
                              LotNo: Code[50];
                              SerialNo: Code[50];
                              VAR ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    BEGIN

        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.");

        ItemLedgEntry.SETRANGE("Item No.", ItemNo);
        ItemLedgEntry.SETRANGE(Open, TRUE);
        ItemLedgEntry.SETRANGE("Variant Code", Variant);
        IF LotNo <> '' THEN
            ItemLedgEntry.SETRANGE("Lot No.", LotNo)
        ELSE
            IF SerialNo <> '' THEN
                ItemLedgEntry.SETRANGE("Serial No.", SerialNo);
        ItemLedgEntry.SETRANGE(Positive, TRUE);

        IF ItemLedgEntry.FINDLAST THEN
            EXIT(TRUE);

        ItemLedgEntry.SETRANGE(Open);
        EXIT(ItemLedgEntry.FINDLAST);

    END;

    var
        myInt: Integer;
}