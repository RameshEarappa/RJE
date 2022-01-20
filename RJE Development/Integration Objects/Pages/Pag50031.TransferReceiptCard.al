page 50031 "Transfer Receipt Card"
{

    Caption = 'Transfer Receipt Card';
    PageType = Document;
    SourceTable = "Transfer Receipt Confirmation";
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                Enabled = FieldsEnable;
                field("Load No."; Rec."Load No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer-From Code"; Rec."Transfer-From Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
            }
            part("Lines"; "Transfer Rcpt. Conf.Line Part")
            {
                ApplicationArea = All;
                SubPageLink = "Transfer Receipt Hdr Entry No." = field("Entry No.");
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
