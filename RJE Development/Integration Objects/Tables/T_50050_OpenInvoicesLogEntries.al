//LT_V1.01
table 50050 "Open Invoices Log Entries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = TRUE;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Processed DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Processed User"; Code[20])
        {

        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
//LT_V1.01