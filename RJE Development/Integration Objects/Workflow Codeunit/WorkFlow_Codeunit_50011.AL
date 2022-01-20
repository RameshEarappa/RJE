codeunit 50011 "Customized Workflow"
{
    //Workflow demo created by Krishna Kumar 22 Oct 2020

    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";



    //**************************Send For Approval Event Start***************************
    procedure RunWorkflowOnSendApproval_TO(): Code[128]
    begin
        exit('RunWorkflowOnSendApproval_TO');
    end;

    procedure RunWorkflowOnSendApproval_AssemblyOrder(): Code[128]
    begin
        exit('RunWorkflowOnSendApproval_AssemblyOrder');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnSendApproval_TO', '', true, true)]
    procedure RunWorkflowOnSendApprovalForTO(var RecToStaging: Record "Transfer Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendApproval_TO, RecToStaging);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnSendApproval_AssemblyOrder', '', true, true)]
    procedure RunWorkflowOnSendApprovalForAssemblyOrder(var RecAssemblyHdr: Record "Assembly Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendApproval_AssemblyOrder(), RecAssemblyHdr);
    end;


    //************* To set status pending approval *************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure ChangeAssetStatus(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    VAR
        RecToStaging: Record "Transfer Header";
        RecAssemblyHdr: Record "Assembly Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Transfer Header":
                begin
                    RecRef.SetTable(RecToStaging);
                    RecToStaging.Validate("Workflow Status", RecToStaging."Workflow Status"::"Pending Approval");
                    RecToStaging.Modify(true);
                    Variant := RecToStaging;
                    IsHandled := true;
                end;
            DATABASE::"Assembly Header":
                begin
                    RecRef.SetTable(RecAssemblyHdr);
                    RecAssemblyHdr.Validate("Workflow Status", RecAssemblyHdr."Workflow Status"::"Pending Approval");
                    RecAssemblyHdr.Modify(true);
                    Variant := RecAssemblyHdr;
                    IsHandled := true;
                end;
        end;
    end;
    //****************************************** Send For Approval End ***********************


    //************ After approval *** Set status to Approved**************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    procedure OnReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        RecToStaging: Record "Transfer Header";
        Variant: Variant;
        RecAssemblyHdr: Record "Assembly Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SetTable(RecToStaging);
                    RecToStaging."Workflow Status" := RecToStaging."Workflow Status"::Approved;
                    RecToStaging.Modify(true);
                    Codeunit.Run(Codeunit::"Release Transfer Document", RecToStaging);
                    Variant := RecToStaging;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
            DATABASE::"Assembly Header":
                BEGIN
                    RecRef.SetTable(RecAssemblyHdr);
                    RecAssemblyHdr."Workflow Status" := RecAssemblyHdr."Workflow Status"::Approved;
                    RecAssemblyHdr.Modify(true);
                    Codeunit.Run(Codeunit::"Release Assembly Document", RecAssemblyHdr);
                    Variant := RecAssemblyHdr;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;
    end;


    //*******************On Populate Approval Entry *********************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecToStaging: Record "Transfer Header";
        RecAssemblyHdr: Record "Assembly Header";
    begin
        case RecRef.Number of
            database::"Transfer Header":
                begin
                    RecRef.SetTable(RecToStaging);
                    ApprovalEntryArgument."Table ID" := Database::"Transfer Header";
                    ApprovalEntryArgument."Document No." := RecToStaging."No.";
                    RecRef.GetTable(RecToStaging);
                end;
            database::"Assembly Header":
                begin
                    RecRef.SetTable(RecAssemblyHdr);
                    ApprovalEntryArgument."Table ID" := Database::"Assembly Header";
                    ApprovalEntryArgument."Document No." := RecAssemblyHdr."No.";
                    RecRef.GetTable(RecAssemblyHdr);
                end;
        end;
    end;





    //******************To cancel approval in case of 2nd level***************** 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Management", 'OnBeforeHandleEventWithxRec', '', false, false)]
    procedure OnBeforeHandleEventWithxRec(FunctionName: Code[128]; Variant: Variant; xVariant: Variant; VAR IsHandled: Boolean)
    Var
        RecToStaging: Record "Transfer Header";
        RecAssemblyHdr: Record "Assembly Header";
        RecRef: RecordRef;
        RecApprovalEntry: Record "Approval Entry";
        ActionableWorkflowStepInstance: Record "Workflow Step Instance";
        WorkFlowMgmt: Codeunit "Workflow Management";
    begin
        RecRef.GetTable(Variant);
        if (RecRef.Number = Database::"Transfer Header") AND (FunctionName = RunWorkflowOnCancelApproval_TO()) Then begin
            IF NOT WorkFlowMgmt.FindEventWorkflowStepInstance(ActionableWorkflowStepInstance, FunctionName, Variant, xVariant) THEN BEGIN
                RecToStaging := Variant;
                Clear(RecApprovalEntry);
                RecApprovalEntry.SetRange("Table ID", Database::"Transfer Header");
                RecApprovalEntry.SetRange("Document No.", RecToStaging."No.");
                RecApprovalEntry.SetRange("Record ID to Approve", RecToStaging.RecordId);
                RecApprovalEntry.SetFilter(Status, '%1|%2', RecApprovalEntry.Status::Created, RecApprovalEntry.Status::Open);
                if RecApprovalEntry.FindSet() then
                    RecApprovalEntry.ModifyAll(Status, RecApprovalEntry.Status::Canceled);
                RecToStaging.Validate("Workflow Status", RecToStaging."Workflow Status"::Open);
                RecToStaging.Modify();
                Variant := RecToStaging;
                Message('Transfer Order Approval Request has been cancelled.');
            END;
        end else
            if (RecRef.Number = Database::"Assembly Header") AND (FunctionName = RunWorkflowOnCancelApproval_AssemblyOrder()) Then begin
                IF NOT WorkFlowMgmt.FindEventWorkflowStepInstance(ActionableWorkflowStepInstance, FunctionName, Variant, xVariant) THEN BEGIN
                    RecAssemblyHdr := Variant;
                    Clear(RecApprovalEntry);
                    RecApprovalEntry.SetRange("Table ID", Database::"Assembly Header");
                    RecApprovalEntry.SetRange("Document No.", RecAssemblyHdr."No.");
                    RecApprovalEntry.SetRange("Record ID to Approve", RecAssemblyHdr.RecordId);
                    RecApprovalEntry.SetFilter(Status, '%1|%2', RecApprovalEntry.Status::Created, RecApprovalEntry.Status::Open);
                    if RecApprovalEntry.FindSet() then
                        RecApprovalEntry.ModifyAll(Status, RecApprovalEntry.Status::Canceled);
                    RecAssemblyHdr.Validate("Workflow Status", RecAssemblyHdr."Workflow Status"::Open);
                    RecAssemblyHdr.Modify();
                    Variant := RecAssemblyHdr;
                    Message('Assembly Order Approval Request has been cancelled.');
                END;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApproval_TO(), Database::"Transfer Header", 'Approval of Transfer Order is required.', 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApproval_TO(), Database::"Transfer Header", 'Cancel Transfer Order Approval request.', 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApproval_AssemblyOrder(), Database::"Assembly Header", 'Approval of Assembly Order is required.', 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApproval_AssemblyOrder(), Database::"Assembly Header", 'Cancel Assembly Order Approval request.', 0, false);

    end;

    //****************Reject***************
    procedure RunWorkflowOnReject_TO(): Code[128]
    begin
        exit('RunWorkflowOnReject_TO');
    end;

    procedure RunWorkflowOnReject_AssemblyOrder(): Code[128]
    begin
        exit('RunWorkflowOnReject_AssemblyOrder');
    end;
    //****************Reject End***************



    //***********************Cancel For Approval Event  Start******************
    procedure RunWorkflowOnCancelApproval_TO(): Code[128]
    begin
        exit('RunWorkflowOnCancelApproval_TO');
    end;

    procedure RunWorkflowOnCancelApproval_AssemblyOrder(): Code[128]
    begin
        exit('RunWorkflowOnCancelApproval_AssemblyOrder');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnCancelApproval_TO', '', true, true)]
    procedure RunWorkflow_OnCancelApproval_TO(var RecToStaging: Record "Transfer Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelApproval_TO, RecToStaging);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnCancelApproval_AssemblyOrder', '', true, true)]
    procedure RunWorkflow_OnCancelApproval_AssemblyOrder(var RecAssemblyHdr: Record "Assembly Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelApproval_AssemblyOrder, RecAssemblyHdr);
    end;
    //***********************End***********************************


    //****************In case of Reject and cancel Approval request***********
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    procedure OnOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    VAR
        RecCustStag: Record "Transfer Header";
        RecAssemblyHdr: Record "Assembly Header";
        Variant: Variant;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SetTable(RecCustStag);
                    RecCustStag."Workflow Status" := RecCustStag."Workflow Status"::Open;
                    RecCustStag.Modify(true);
                    Variant := RecCustStag;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
            DATABASE::"Assembly Header":
                BEGIN
                    RecRef.SetTable(RecAssemblyHdr);
                    RecAssemblyHdr."Workflow Status" := RecAssemblyHdr."Workflow Status"::Open;
                    RecAssemblyHdr.Modify(true);
                    Variant := RecAssemblyHdr;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;

    end;

    //Code to Open Record from Request to Appprove page//Krishna
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; VAR CardPageID: Integer)
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::"Transfer Header":
                CardPageID := Page::"Transfer Order";
            DATABASE::"Assembly Header":
                CardPageID := Page::"Assembly Order";
        end;
    end;
}