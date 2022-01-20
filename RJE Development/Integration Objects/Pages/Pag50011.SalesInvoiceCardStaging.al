page 50011 "Sales Invoice Card Staging"
{

    Caption = 'Sales Invoice Card';
    PageType = Document;
    SourceTable = "Sales Invoice Header Staging";
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("External Doucment No."; Rec."External Doucment No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = All;
                }
                field("Amount Inc. VAT"; Rec."Amount Inc. VAT")
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
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

            }
            part("Lines"; "Sales Inv. Line Staging")
            {
                ApplicationArea = All;
                SubPageLink = "Sales Inv. Entry No." = field("Entry No.");
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
