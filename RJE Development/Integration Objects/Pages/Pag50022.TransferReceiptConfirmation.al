page 50022 "Transfer Receipt Confirmation"
{

    ApplicationArea = All;
    Caption = 'Transfer Receipt Confirmation';
    PageType = List;
    SourceTable = "Transfer Receipt Confirmation";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    CardPageId = "Transfer Receipt Card";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Load No."; Rec."Load No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Transfer-From Code"; Rec."Transfer-From Code")
                {
                    ApplicationArea = All;
                }
                field("Load Status"; Rec."Load Status")
                {
                    ApplicationArea = All;
                }
                field("LoadPeriod No."; Rec."LoadPeriod No.")
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
            action("Sync with Transfer Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Refresh;
                trigger OnAction()
                var
                    ProcessTransferReceiptConf: Report "Process Transfer Receipt Conf.";
                    RecTransferReceiptConf: Record "Transfer Receipt Confirmation";
                begin
                    Clear(RecTransferReceiptConf);
                    CurrPage.SetSelectionFilter(RecTransferReceiptConf);
                    if RecTransferReceiptConf.FindSet() then begin
                        ProcessTransferReceiptConf.ValidateRecord(RecTransferReceiptConf);
                        if not Confirm('Do you want to Synchronize Transfer Order?', false) then
                            exit;
                        Clear(ProcessTransferReceiptConf);
                        ProcessTransferReceiptConf.SetTableView(RecTransferReceiptConf);
                        ProcessTransferReceiptConf.Run();
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
                    RecTransferReceiptConf: Record "Transfer Receipt Confirmation";
                begin
                    Clear(RecTransferReceiptConf);
                    CurrPage.SetSelectionFilter(RecTransferReceiptConf);
                    if RecTransferReceiptConf.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecTransferReceiptConf.Status in [RecTransferReceiptConf.Status::Error, RecTransferReceiptConf.Status::" "]) then
                                RecTransferReceiptConf.TestField(Status, RecTransferReceiptConf.Status::Error);
                            RecTransferReceiptConf.Status := RecTransferReceiptConf.Status::"Ready To Sync";
                            RecTransferReceiptConf."Error Remarks" := '';
                            RecTransferReceiptConf.Modify();
                        until
                        RecTransferReceiptConf.Next() = 0;
                    end
                end;
            }
        }
    }
}
