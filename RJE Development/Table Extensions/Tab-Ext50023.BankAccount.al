tableextension 50023 "Bank Account" extends "Bank Account"
{
    fields
    {
        field(50000; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                RecBankAcc: Record "Bank Account";
            begin
                if ("Salesperson Code" <> '') AND ("Payment Method Code" <> '') then begin
                    Clear(RecBankAcc);
                    RecBankAcc.SetRange("Salesperson Code", Rec."Salesperson Code");
                    RecBankAcc.SetRange("Payment Method Code", Rec."Payment Method Code");
                    if RecBankAcc.FindFirst() then
                        Error('Record already exists with the same Bank Acc. No. and Payment Method Code.');
                end;
            end;
        }
        field(50001; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
            trigger OnValidate()
            var
                RecBankAcc: Record "Bank Account";
            begin
                if ("Salesperson Code" <> '') AND ("Payment Method Code" <> '') then begin
                    Clear(RecBankAcc);
                    RecBankAcc.SetRange("Salesperson Code", Rec."Salesperson Code");
                    RecBankAcc.SetRange("Payment Method Code", Rec."Payment Method Code");
                    if RecBankAcc.FindFirst() then
                        Error('Record already exists with the same Bank Acc. No. and Payment Method Code.');
                end;
            end;
        }
    }
}
