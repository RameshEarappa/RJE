page 50016 "Transfer Orders Proposal"
{

    ApplicationArea = All;
    Caption = 'Transfer Orders Proposal';
    PageType = List;
    SourceTable = "Transfer Order Proposal Header";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    CardPageId = "Transfer Order Proposal Card";
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Transfer-From Code"; Rec."Transfer-From Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-To Code"; Rec."Transfer-To Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Transfer-To Salesperson Code';
                }
                field("Salesperson Name"; Rec."Salesperson Name")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer-To Salesperson Name';
                    Editable = false;
                }
                field("Transfer-From Salesperson Code"; Rec."Transfer-From Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-From Salesperson Name"; Rec."Transfer-From Salesperson Name")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
            action("Create Transfer Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = TransferOrder;
                trigger OnAction()
                var
                    ProcessTransferOrder: Report "Process Transfer Order";
                    RecTransferHdrStaging: Record "Transfer Order Proposal Header";
                begin
                    Clear(RecTransferHdrStaging);
                    CurrPage.SetSelectionFilter(RecTransferHdrStaging);
                    if RecTransferHdrStaging.FindSet() then begin
                        ProcessTransferOrder.ValidateRecord(RecTransferHdrStaging);
                        if not Confirm('Do you want to create Transfer Order?', false) then
                            exit;
                        Clear(ProcessTransferOrder);
                        ProcessTransferOrder.SetTableView(RecTransferHdrStaging);
                        ProcessTransferOrder.Run();
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
                    RecTransferOrderHdrStaging: Record "Transfer Order Proposal Header";
                begin
                    Clear(RecTransferOrderHdrStaging);
                    CurrPage.SetSelectionFilter(RecTransferOrderHdrStaging);
                    if RecTransferOrderHdrStaging.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecTransferOrderHdrStaging.Status in [RecTransferOrderHdrStaging.Status::Error, RecTransferOrderHdrStaging.Status::" "]) then
                                RecTransferOrderHdrStaging.TestField(Status, RecTransferOrderHdrStaging.Status::Error);
                            RecTransferOrderHdrStaging.Status := RecTransferOrderHdrStaging.Status::"Ready To Sync";
                            RecTransferOrderHdrStaging."Error Remarks" := '';
                            RecTransferOrderHdrStaging.Modify();
                        until
                        RecTransferOrderHdrStaging.Next() = 0;
                    end
                end;
            }
        }
    }
}
