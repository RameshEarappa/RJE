tableextension 50007 "GLEntry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "Check No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Check Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Narration; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "MH_Applies-To Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-To Doc. No.';
        }
        field(50004; "MH_Applies-To Doc. Type"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-To Doc. Type';
        }
    }
}