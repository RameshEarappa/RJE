page 50017 "Transfer Order Proposal Card"
{
    Caption = 'Transfer Order Proposal Card';
    PageType = Document;
    SourceTable = "Transfer Order Proposal Header";
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
                    Caption = 'Transfer-To Salesperson Code';
                    Editable = false;
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
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
            }
            part(Lines; "Transfer Order Proposal Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Transfer Order Entry No." = field("Entry No.");
                UpdatePropagation = Both;
                Enabled = FieldsEnable;
            }
        }
    }
    actions
    {
        area(Processing)
        {

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
