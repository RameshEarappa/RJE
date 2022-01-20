tableextension 50009 "BanK ACL Ext" extends "Bank Account Ledger Entry"
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
    }
}