xmlport 50006 "Import Cash Receipt Journal"
{
    Direction = Both;
    UseDefaultNamespace = true;
    schema
    {
        textelement(Collections)
        {
            tableelement(CashReceiptJournal; "Cash Receipt Journal Staging")
            {
                fieldelement(DocumentNo; CashReceiptJournal."Document No.")
                {
                }
                fieldelement(PostingDate; CashReceiptJournal."Posting Date")
                {
                }
                fieldelement(DocumentType; CashReceiptJournal."Document Type")
                {
                }
                fieldelement(AccountType; CashReceiptJournal."Account Type")
                {
                }
                fieldelement(AccountNo; CashReceiptJournal."Account No.")
                {
                }
                fieldelement(AppliesToDocType; CashReceiptJournal."Applies-To Doc. Type")
                {
                }
                fieldelement(AppliesToDocNo; CashReceiptJournal."Applies-To Doc. No.")
                {
                }
                fieldelement(BalAccountType; CashReceiptJournal."Bal. Account Type")
                {
                }
                fieldelement(BalAccountNo; CashReceiptJournal."Bal. Account No.")
                {
                }

                fieldelement(SalespersonPurchaserCode; CashReceiptJournal."Salesperson/Purchaser Code")
                {
                }
                fieldelement(LocationCode; CashReceiptJournal."Location Code")
                {
                }
                fieldelement(Amount; CashReceiptJournal.Amount)
                {
                }
                fieldelement(PaymentMethod; CashReceiptJournal."Payment Method")
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    RecCashReceiptStaging: Record "Cash Receipt Journal Staging";
                begin
                    Clear(RecCashReceiptStaging);
                    RecCashReceiptStaging.SetCurrentKey("Entry No.");
                    if RecCashReceiptStaging.FindLast() then
                        CashReceiptJournal."Entry No." := RecCashReceiptStaging."Entry No." + 1
                    else
                        CashReceiptJournal."Entry No." := 1;
                    CashReceiptJournal.Status := CashReceiptJournal.Status::"Ready To Sync";
                    CashReceiptJournal."Added on" := CurrentDateTime;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
