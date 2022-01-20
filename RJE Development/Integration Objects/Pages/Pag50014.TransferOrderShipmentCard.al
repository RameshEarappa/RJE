page 50014 "Transfer Order Shipment Card"
{

    Caption = 'Transfer Order Shipment Card';
    PageType = Document;
    SourceTable = "Transfer Order Shipment Header";
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
                field("Transfer-From Code"; Rec."Transfer-From Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-To Code"; Rec."Transfer-To Code")
                {
                    ApplicationArea = All;
                }
                field("Load Period No."; Rec."Load Period No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "Transfer Order Shipment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Transfer Order Entry No." = field("Entry No.");
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