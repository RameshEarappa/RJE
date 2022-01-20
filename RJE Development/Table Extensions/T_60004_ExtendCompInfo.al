tableextension 60004 "Ext Company Information" extends "Company Information"
{
    fields
    {
        field(60000; "Name In Arabic"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(60001; "Address In Arabic"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "Address 2 In Arabic"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(60003; "City In Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Country In Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60005; "Post Code In Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60006; "Country/Region Code In Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60007; "Date Validation - Company Name"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60008; "Company Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Old Company Name';
        }
        field(60009; "Company Name in Arabic"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Old Company Name in Arabic';
        }
        field(60010; "Old Company Logo"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
            //Caption = 'Old Company Name in Arabic';
        }
    }
}