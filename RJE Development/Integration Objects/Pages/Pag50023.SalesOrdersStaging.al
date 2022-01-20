page 50023 "Sales Orders Staging"
{
    ApplicationArea = All;
    Caption = 'Sales Orders Staging';
    PageType = List;
    SourceTable = "Sales Order Header Staging";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    CardPageId = "Sales Order Staging Card";
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
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
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
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Added on"; Rec."Added on")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount"; Rec."Invoice Discount")
                {
                    ApplicationArea = All;
                }
                field("Amount To Customer"; Rec."Amount To Customer")
                {
                    ApplicationArea = All;
                }
                field("Sales Channel Type"; Rec."Sales Channel Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
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
            action("Create Sales Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = SalesInvoice;
                trigger OnAction()
                var
                    ProcessSalesOrders: Report "Process Sales Orders";
                    RecSalesHdrStaging: Record "Sales Order Header Staging";
                begin
                    Clear(RecSalesHdrStaging);
                    CurrPage.SetSelectionFilter(RecSalesHdrStaging);
                    if RecSalesHdrStaging.FindSet() then begin
                        ProcessSalesOrders.ValidateRecord(RecSalesHdrStaging);
                        if not Confirm('Do you want to create Sales Order?', false) then
                            exit;
                        Clear(ProcessSalesOrders);
                        ProcessSalesOrders.SetTableView(RecSalesHdrStaging);
                        ProcessSalesOrders.Run();
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
                    RecSalesHdrStaging: Record "Sales Order Header Staging";
                begin
                    Clear(RecSalesHdrStaging);
                    CurrPage.SetSelectionFilter(RecSalesHdrStaging);
                    if RecSalesHdrStaging.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecSalesHdrStaging.Status in [RecSalesHdrStaging.Status::Error, RecSalesHdrStaging.Status::" "]) then
                                RecSalesHdrStaging.TestField(Status, RecSalesHdrStaging.Status::Error);
                            RecSalesHdrStaging.Status := RecSalesHdrStaging.Status::"Ready To Sync";
                            RecSalesHdrStaging."Error Remarks" := '';
                            RecSalesHdrStaging.Modify();
                        until
                        RecSalesHdrStaging.Next() = 0;
                    end
                end;
            }
        }
    }
}
