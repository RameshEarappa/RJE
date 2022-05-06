pageextension 60020 "Extend Transfer Order" extends "Transfer Order"
{
    PromotedActionCategories = 'New,Process,Report,Release,Posting,Order,Documents,Print/Send,Navigate,Request Approval';
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Mirnah Reference No."; Rec."Mirnah Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
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
            }
            field("Transfer-From Salesperson Name"; Rec."Transfer-From Salesperson Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Created By API"; Rec."Created By API")
            {
                ApplicationArea = All;
                Caption = 'VAN Loading TO';
                Enabled = false;
            }
            field("VAN Unloading TO"; Rec."VAN Unloading TO")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field(Confirmed; Rec.Confirmed)
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }
        addafter("Posting Date")
        {
            field("Request Date"; Rec."Request Date")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Status)
        {
            field("Workflow Status"; Rec."Workflow Status")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }

        modify(General)
        {
            Enabled = PageEditable;
        }
        modify(Shipment)
        {
            Enabled = PageEditable;
        }
        modify("Transfer-from")
        {
            Enabled = PageEditable;
        }
        modify(Control19)
        {
            Enabled = PageEditable;
        }
        modify("Transfer-to")
        {
            Enabled = PageEditable;
        }
        modify(TransferLines)
        {
            Enabled = PageEditable;
        }
    }

    actions
    {
        addafter("Re&lease")
        {
            action("Auto GRN")
            {
                ApplicationArea = All;
                Image = PostApplication;
                Promoted = TRUE;
                PromotedCategory = Process;
                TRIGGER OnAction()
                VAR
                    TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
                    TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
                    WhseRqst: Record "Warehouse Request";
                    WarehouseReceiptHeader: Record "Warehouse Receipt Header";
                    WarehouseReceiptLine: Record "Warehouse Receipt Line";
                    WhseRcptLine: Record "Warehouse Receipt Line";
                    WhsePostReceipt: Codeunit "Whse.-Post Receipt";
                    WarehouseActivityHeader: Record "Warehouse Receipt Header";
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                    WhseActivityRegister: Codeunit "Whse.-Activity-Register";
                    WMSMgt: Codeunit "WMS Management";
                    TransferLine: Record "Transfer Line";
                    AssignLotNumber: Codeunit AssignLotNoToSalesLines;
                BEGIN
                    IsWorkflowStatusApproved();//Krishna_13JAN2021
                    Rec.TestField(Status, Rec.Status::Released);
                    AssignLotNumber.AssignLotNoForTransferOrder(Rec);//Krishna_2MARCH2021
                    TransferPostShipment.RUN(Rec);
                    FindWarehouseRequestForInbound(WhseRqst, Rec);
                    IF CreateWhseReceiptHeaderFromWhseRequest(WhseRqst) THEN BEGIN
                        GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
                        WarehouseReceiptLine.RESET;
                        WarehouseReceiptLine.SETRANGE("No.", WarehouseReceiptHeader."No.");
                        IF WarehouseReceiptLine.FINDFIRST THEN BEGIN
                            WhseRcptLine.COPY(WarehouseReceiptLine);
                            WhsePostReceipt.RUN(WhseRcptLine);
                            WhsePostReceipt.GetResultMessage();
                            //LT07012021
                            /*   
                            CLEAR(WhsePostReceipt);
                            WarehouseActivityLine.RESET;
                            WarehouseActivityLine.SETRANGE("Source No.", Rec."No.");
                            WarehouseActivityLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
                            WarehouseActivityLine.SETRANGE("Source Subtype", 1);
                            IF WarehouseActivityLine.FINDSET THEN BEGIN
                                WMSMgt.CheckBalanceQtyToHandle(WarehouseActivityLine);
                                WhseActivityRegister.RUN(WarehouseActivityLine);
                                CLEAR(WhseActivityRegister);
                            END;
                            */
                            //LT07012021
                        END;
                    END;
                    //TransferPostReceipt.RUN(Rec);
                END;
            }
        }
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
                        EventsubsriberL: Codeunit EventSubscriber;
                        IsHandled: Boolean;
                    begin
                        //11.08.2021
                        OnBeforeSendApprovalRequest(Rec, IsHandled);
                        if IsHandled then
                            exit;
                        //11.08.2021
                        Rec.TestField(Status, Rec.Status::Open);
                        EventsubsriberL.CheckMultipleItem(Rec);
                        if WfInitCode.CheckWorkflowEnabled(Rec) then begin
                            WfInitCode.OnSendApproval_TO(Rec);
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
                        InitWf.OnCancelApproval_TO(Rec);
                        //SetControl();
                    end;
                }
            }
        }
        //validate workflow Status
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Create &Whse. Receipt")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Create Whse. S&hipment")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify("Get Bin Content")
        {
            trigger OnBeforeAction()
            begin
                IsWorkflowStatusApproved();
            end;
        }
        modify(GetReceiptLines)
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
    var
        IntegrationSetup: Record "Integration Setup";
    BEGIN
        SetControl();
        IntegrationSetup.GET;
        IntegrationSetup.TestField("In-Transit Code");
        Rec.Validate("In-Transit Code", IntegrationSetup."In-Transit Code");
    END;

    local procedure IsWorkflowStatusOpen()
    begin
        Rec.TestField("Workflow Status", Rec."Workflow Status"::Open);
    end;

    local procedure IsWorkflowStatusApproved()
    begin
        Rec.TestField("Workflow Status", Rec."Workflow Status"::Approved);
    end;

    PROCEDURE FindWarehouseRequestForInbound(VAR WhseRqst: Record "Warehouse Request"; VAR TransHeader: Record "Transfer Header")
    BEGIN
        TransHeader.TESTFIELD(Status, TransHeader.Status::Released);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
        WhseRqst.SETRANGE("Source Subtype", 1);
        WhseRqst.SETRANGE("Source No.", TransHeader."No.");
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        GetRequireReceiveRqst(WhseRqst);
    END;

    PROCEDURE GetRequireReceiveRqst(VAR WhseRqst: Record "Warehouse Request")
    VAR
        Location: Record Location;
        LocationCode: Text;
    BEGIN
        IF WhseRqst.FINDSET THEN BEGIN
            REPEAT
                IF Location.RequireReceive(WhseRqst."Location Code") THEN
                    LocationCode += WhseRqst."Location Code" + '|';
            UNTIL WhseRqst.NEXT = 0;
            IF LocationCode <> '' THEN BEGIN
                LocationCode := COPYSTR(LocationCode, 1, STRLEN(LocationCode) - 1);
                IF LocationCode[1] = '|' THEN
                    LocationCode := '''''' + LocationCode;
            END;
            WhseRqst.SETFILTER("Location Code", LocationCode);
        END;
    END;

    PROCEDURE CreateWhseReceiptHeaderFromWhseRequest(VAR WarehouseRequest: Record "Warehouse Request"): Boolean
    BEGIN
        IF WarehouseRequest.ISEMPTY THEN
            EXIT(FALSE);
        CLEAR(GetSourceDocuments);
        GetSourceDocuments.USEREQUESTPAGE(FALSE);
        GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
        GetSourceDocuments.SetHideDialog(TRUE);
        GetSourceDocuments.RUNMODAL;
        EXIT(TRUE);
    END;


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

    //11.08.2021
    [IntegrationEvent(false, false)]
    procedure OnBeforeSendApprovalRequest(Var Rec: Record "Transfer Header"; Var IsHandled: Boolean)
    begin
    end;
    //11.08.2021

    VAR
        GetSourceDocuments: Report "Get Source Documents";
        IsSendRequest: Boolean;
        PageEditable: Boolean;
        IsCancel: Boolean;
}