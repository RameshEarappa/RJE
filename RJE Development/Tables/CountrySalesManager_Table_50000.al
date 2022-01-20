table 50000 "Country Sales Manager"
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
                RecGLSetup.TestField("Country Sales Mng. No. Series");
                If Code = '' then begin
                    Code := NoSeries.GetNextNo(RecGLSetup."Country Sales Mng. No. Series", WorkDate(), true);
                end
            end;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Name - Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Address 1"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Contact No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Email; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Country/Region"; code[10])
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
        fieldgroup(DropDown; Code, Name, Email) { }
    }


    var
        myInt: Integer;

    trigger OnInsert()
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Country Sales Mng. No. Series");
        If Code = '' then begin
            Code := NoSeries.GetNextNo(RecGLSetup."Country Sales Mng. No. Series", WorkDate(), true);
        end
    end;

}