pageextension 50032 BankAccounts extends "Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = ALl;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
}
