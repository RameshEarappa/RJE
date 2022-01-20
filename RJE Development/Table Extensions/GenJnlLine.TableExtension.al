tableextension 50006 "GenJnlLine Ext" extends "Gen. Journal Line"
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
        field(50003; "Created By API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Subscriber Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
}