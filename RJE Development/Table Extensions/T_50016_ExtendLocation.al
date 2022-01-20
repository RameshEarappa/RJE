tableextension 50016 Location_Ext extends Location
{
    fields
    {
        field(50000; "Sales Person"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Person';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        //LT05012021
        FIELD(50002; "DR Location"; Boolean)
        {
            DataClassification = ToBeClassified;
            TRIGGER OnValidate()
            BEGIN
                IF Rec."DR Location" <> xRec."DR Location" THEN
                    "Default Replenishment Whse." := '';
            END;
        }
        FIELD(50003; "Default Replenishment Whse."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(50004; "Name-Arabic"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        //LT05012021
    }

    var
        myInt: Integer;
}