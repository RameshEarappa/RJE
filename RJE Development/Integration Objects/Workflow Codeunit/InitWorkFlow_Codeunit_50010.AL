codeunit 50010 "Init Workflow"
{
    trigger OnRun()
    begin
    end;
    //Events creation Start   Leave Req WF
    [IntegrationEvent(false, false)]

    procedure OnSendApproval_TO(var RecToStaging: Record "Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelApproval_TO(var RecToStaging: Record "Transfer Header")
    begin
    end;
    //Event Creation End

    local procedure IsWFEnabled_TO(Var RecToStaging: Record "Transfer Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Customized Workflow";
    begin
        exit(WFMngt.CanExecuteWorkflow(RecToStaging, WFCode.RunWorkflowOnSendApproval_TO))
    end;

    procedure CheckWorkflowEnabled(var RecToStaging: Record "Transfer Header"): Boolean
    var
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsWFEnabled_TO(RecToStaging) then
            Error(NoWorkflowEnb);
        exit(true);
    end;

    //****************Assembly Order workflow************************************* 
    [IntegrationEvent(false, false)]

    procedure OnSendApproval_AssemblyOrder(var RecAssemblyHdr: Record "Assembly Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelApproval_AssemblyOrder(var RecAssemblyHdr: Record "Assembly Header")
    begin
    end;
    //Event Creation End

    local procedure IsWFEnabled_AssemblyOrder(Var RecAssemblyHdr: Record "Assembly Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Customized Workflow";
    begin
        exit(WFMngt.CanExecuteWorkflow(RecAssemblyHdr, WFCode.RunWorkflowOnSendApproval_AssemblyOrder))
    end;

    procedure CheckWorkflowEnabled_AssemblyOrder(var RecAssemblyHdr: Record "Assembly Header"): Boolean
    var
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsWFEnabled_AssemblyOrder(RecAssemblyHdr) then
            Error(NoWorkflowEnb);
        exit(true);
    end;


    var
        WFMngt: Codeunit "Workflow Management";
        Text001: TextConst ENU = 'No Workflows Enabled';

}