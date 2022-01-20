table 50001 "Regional Sales Manager"
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
                RecGLSetup.TestField("Regional Sales Mng. No. Series");
                If Code = '' then begin
                    Code := NoSeries.GetNextNo(RecGLSetup."Regional Sales Mng. No. Series", WorkDate(), true);
                end

            end;
        }
        field(2; "Country Sales Manager"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country Sales Manager".Code;
        }
        field(3; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Name - Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Address 1"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Contact No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Email; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Country/Region"; code[10])
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
        fieldgroup(DropDown; Code, Name, "Country Sales Manager", Email) { }
    }


    var
        myInt: Integer;

    trigger OnInsert()
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Regional Sales Mng. No. Series");
        If Code = '' then begin
            Code := NoSeries.GetNextNo(RecGLSetup."Regional Sales Mng. No. Series", WorkDate(), true);
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