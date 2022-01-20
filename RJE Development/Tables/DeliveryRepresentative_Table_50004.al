table 50004 "Delivery Representative"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                NoSeries: Codeunit NoSeriesManagement;
                RecGLSetup: Record "General Ledger Setup";
            begin
                RecGLSetup.Get();
                RecGLSetup.TestField("Delivery Rep. No. Series");
                If Code = '' then begin
                    Code := NoSeries.GetNextNo(RecGLSetup."Delivery Rep. No. Series", WorkDate(), true);
                end

            end;
        }
        field(2; "Country Sales Manager"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country Sales Manager".Code;
        }
        field(3; "Regional Sales Managerr"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Regional Sales Manager".Code;
        }
        field(4; "Area Sales Manager"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Area Sales Manager".Code;
        }
        field(5; Supervisor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Supervisor.Code;
        }
        field(6; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Name - Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Address 1"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Contact No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Email; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Country/Region"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Name, "Country Sales Manager", "Regional Sales Managerr", "Area Sales Manager", Supervisor, Email) { }
    }


    var
        myInt: Integer;

    trigger OnInsert()
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Delivery Rep. No. Series");
        If Code = '' then begin
            Code := NoSeries.GetNextNo(RecGLSetup."Delivery Rep. No. Series", WorkDate(), true);
        end
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