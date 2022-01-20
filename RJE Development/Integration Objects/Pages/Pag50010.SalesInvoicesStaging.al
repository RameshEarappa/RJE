page 50010 "Sales Invoices Staging"
{

    ApplicationArea = All;
    Caption = 'Sales Invoices Staging';
    PageType = List;
    SourceTable = "Sales Invoice Header Staging";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    //Editable = false;
    CardPageId = "Sales Invoice Card Staging";
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
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = All;
                }
                field("External Doucment No."; Rec."External Doucment No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
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
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                }
                field("Added on"; Rec."Added on")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
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
                field("Sales Person Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

                field("Amount To Customer"; Rec."Amount To Customer")
                {
                    ApplicationArea = All;
                }
                field("Amount Inc. VAT"; Rec."Amount Inc. VAT")
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
            action("Create Sales Invoice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = SalesInvoice;
                trigger OnAction()
                var
                    ProcessSalesInvs: Report "Process Sales Invoice";
                    RecSalesInvHdrStaging: Record "Sales Invoice Header Staging";
                begin
                    Clear(RecSalesInvHdrStaging);
                    CurrPage.SetSelectionFilter(RecSalesInvHdrStaging);
                    if RecSalesInvHdrStaging.FindSet() then begin
                        ProcessSalesInvs.ValidateRecord(RecSalesInvHdrStaging);
                        if not Confirm('Do you want to create Sales Invoice?', false) then
                            exit;
                        Clear(ProcessSalesInvs);
                        ProcessSalesInvs.SetTableView(RecSalesInvHdrStaging);
                        ProcessSalesInvs.Run();
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
                    RecSalesInvHdrStaging: Record "Sales Invoice Header Staging";
                begin
                    Clear(RecSalesInvHdrStaging);
                    CurrPage.SetSelectionFilter(RecSalesInvHdrStaging);
                    if RecSalesInvHdrStaging.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecSalesInvHdrStaging.Status in [RecSalesInvHdrStaging.Status::Error, RecSalesInvHdrStaging.Status::" "]) then
                                RecSalesInvHdrStaging.TestField(Status, RecSalesInvHdrStaging.Status::Error);
                            if RecSalesInvHdrStaging."Sales Invoice No." <> '' then
                                RecSalesInvHdrStaging.TestField("Sales Invoice No.", '');
                            RecSalesInvHdrStaging.Status := RecSalesInvHdrStaging.Status::"Ready To Sync";
                            RecSalesInvHdrStaging."Error Remarks" := '';
                            RecSalesInvHdrStaging.Modify();
                        until
                        RecSalesInvHdrStaging.Next() = 0;
                    end
                end;
            }
            action("Delete & Reset Status")
            {
                ApplicationArea = All;
                Image = ResetStatus;
                trigger OnAction()
                var
                    ProcessSalesInvs: Report "Process Sales Invoice";
                    RecSalesInvHdrStaging: Record "Sales Invoice Header Staging";
                begin
                    Clear(RecSalesInvHdrStaging);
                    CurrPage.SetSelectionFilter(RecSalesInvHdrStaging);
                    if RecSalesInvHdrStaging.FindSet() then begin
                        ProcessSalesInvs.DeleteSalesInvoiceAndSetStatusToReady(RecSalesInvHdrStaging);
                    end;
                end;
            }
        }
    }
}
