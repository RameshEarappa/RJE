tableextension 50015 SalespersonPurchaser_Ext extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Mirnah Desigination Code"; Enum SalesPerson_Purchaser)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mirnah Desigination Code';
        }
        field(50001; "Name-Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where(Blocked = const(false));
        }
        field(50003; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false));
        }
        field(50004; "Mirnah Salesperson Code"; Text[100])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50005; "Mirnah Salesper. Active Status"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mirnah Salesperson Active Status';
        }
    }

    var
        myInt: Integer;
}