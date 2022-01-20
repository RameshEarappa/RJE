page 50025 "Sales Order Staging Card"
{

    Caption = 'Sales Order Staging Card';
    PageType = Document;
    SourceTable = "Sales Order Header Staging";
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                Enabled = FieldsEnable;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
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
                field("Sales Channel Type"; Rec."Sales Channel Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount"; Rec."Invoice Discount")
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

            }
            part(Lines; "Sales Order Lines Part")
            {
                ApplicationArea = All;
                SubPageLink = "Sales Order Entry No." = field("Entry No.");
                UpdatePropagation = Both;
                Enabled = FieldsEnable;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Setcontrol();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Setcontrol();
    end;

    local procedure Setcontrol()
    var
        myInt: Integer;
    begin
        if Rec.Status IN [Rec.Status::"Ready To Sync", Rec.Status::" "] then
            FieldsEnable := true
        else
            FieldsEnable := false;
    end;

    var
        FieldsEnable: Boolean;
}
