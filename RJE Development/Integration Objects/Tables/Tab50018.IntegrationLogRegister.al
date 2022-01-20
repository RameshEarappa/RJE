table 50018 "Integration Log Register"
{
    Caption = 'Integration Log Register';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Integration Type", "Integration Function";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Integration Type"; Enum "Integration Type")
        {
            Caption = 'Integration Type';
            DataClassification = ToBeClassified;
        }
        field(3; "Integration Function"; Enum "Integration Function")
        {
            Caption = 'Integration Function';
            DataClassification = ToBeClassified;
        }
        field(4; "Request Data"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Request Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Response Data"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Response Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Success,Failed;
        }
        field(10; "Error Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Integration Type", "Integration Function", "Integration Type", "Request Time") { }
    }

    procedure SetRequestData(NewRequestData: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Request Data");
        "Request Data".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewRequestData);
    end;

    procedure GetRequestData(): Text
    var
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        CalcFields("Request Data");
        "Request Data".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetResponseData(NewResponseData: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Response Data");
        "Response Data".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewResponseData);
    end;

    procedure GetResponseData(): Text
    var
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        CalcFields("Response Data");
        "Response Data".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}
