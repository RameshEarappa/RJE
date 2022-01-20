page 50026 "Cash Receipt Journal Staging"
{

    ApplicationArea = All;
    Caption = 'Cash Receipt Journal Staging';
    PageType = List;
    SourceTable = "Cash Receipt Journal Staging";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    //InsertAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Applies-To Doc. Type"; Rec."Applies-To Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Applies-To Doc. No."; Rec."Applies-To Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Salesperson/Purchaser Code"; Rec."Salesperson/Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ApplicationArea = All;
                    Style = Attention;
                }
                field("Added on"; Rec."Added on")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Journals")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Journal;
                trigger OnAction()
                var
                    ProcessJournals: Report "Process Cash Receipt Jnl";
                    Reccashreceiptjnl: Record "Cash Receipt Journal Staging";
                begin
                    Clear(Reccashreceiptjnl);
                    CurrPage.SetSelectionFilter(Reccashreceiptjnl);
                    if Reccashreceiptjnl.FindSet() then begin
                        ProcessJournals.ValidateRecord(Reccashreceiptjnl);
                        if not Confirm('Do you want to create Journals?', false) then
                            exit;
                        Clear(ProcessJournals);
                        ProcessJournals.SetTableView(Reccashreceiptjnl);
                        ProcessJournals.Run();
                    end
                end;
            }
            action("Change Status")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Change;

                trigger OnAction()
                var
                    RecCashreceiptJnl: Record "Cash Receipt Journal Staging";
                begin
                    Clear(RecCashreceiptJnl);
                    CurrPage.SetSelectionFilter(RecCashreceiptJnl);
                    if RecCashreceiptJnl.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecCashreceiptJnl.Status in [RecCashreceiptJnl.Status::Error, RecCashreceiptJnl.Status::" "]) then
                                RecCashreceiptJnl.TestField(Status, RecCashreceiptJnl.Status::Error);
                            RecCashreceiptJnl.Status := RecCashreceiptJnl.Status::"Ready To Sync";
                            RecCashreceiptJnl."Error Remarks" := '';
                            RecCashreceiptJnl.Modify();
                        until
                        RecCashreceiptJnl.Next() = 0;
                    end
                end;
            }
        }
    }
}
