pageextension 50030 AssemblyHeader extends "Assembly Order"
{
    PromotedActionCategories = 'New,Process,Report,Release,Posting,Order,Documents,Print/Send,Navigate,Request Approval';
    layout
    {
        addafter(Status)
        {
            field("Workflow Status"; Rec."Workflow Status")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }
        modify(Control2)
        {
            Enabled = PageEditable;
        }
        modify(Lines)
        {
            Enabled = PageEditable;
        }
        modify(Posting)
        {
            Enabled = PageEditable;
        }
    }

    actions
    {
        addafter(Release)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Enabled = IsSendRequest;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WfInitCode: Codeunit "Init Workflow";
                        AdvanceWorkflowCUL: Codeunit "Customized Workflow";
                        Utility: Codeunit "Integration Utility";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        if WfInitCode.CheckWorkflowEnabled_AssemblyOrder(Rec) then begin
                            Utility.ValidateAssemblyOrderBeforeSendForApproval(Rec);
                            WfInitCode.OnSendApproval_AssemblyOrder(Rec);
                        end;
                        //SetControl();
                    end;
                }

                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = IsCancel;
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category10;

                    trigger OnAction()
                    var
                        InitWf: Codeunit "Init Workflow";
                    begin
                        InitWf.OnCancelApproval_AssemblyOrder(Rec);
                        //SetControl();
                    end;
                }
            }
        }

        modify("Re&lease")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Update Unit Cost")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Create Inventor&y Movement")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }

        modify("Create Warehouse Pick")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }

        modify("P&ost")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SetControl();
    end;

    TRIGGER OnOpenPage()
    BEGIN
        SetControl();
    END;

    TRIGGER OnNewRecord(BelowxRec: Boolean)
    BEGIN
        SetControl();
    END;

    local procedure IsWorkflowStatusOpen()
    begin
        Rec.TestField("Workflow Status", Rec."Workflow Status"::Open);
    end;

    local procedure IsWorkflowStatusApproved()
    begin
        Rec.TestField("Workflow Status", Rec."Workflow Status"::Approved);
    end;

    local procedure SetControl()
    var
        myInt: Integer;
    begin
        if Rec."Workflow Status" = Rec."Workflow Status"::Open then begin
            IsSendRequest := true;
            IsCancel := false;
            PageEditable := true;
        end else
            if Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval" then begin
                IsSendRequest := false;
                IsCancel := true;
                PageEditable := false;
            end else begin
                IsSendRequest := false;
                IsCancel := false;
                PageEditable := false;
            end;
        CurrPage.Update(false);
    end;

    var
        IsSendRequest: Boolean;
        PageEditable: Boolean;
        IsCancel: Boolean;
}
