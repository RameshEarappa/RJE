report 50006 "Process Transfer Order"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Transfer Order Proposal Header"; "Transfer Order Proposal Header")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                ClearLastError();
                Commit();
                if Codeunit.Run(Codeunit::"Process Transfer Order", "Transfer Order Proposal Header") then begin
                    "Transfer Order Proposal Header".Status := "Transfer Order Proposal Header".Status::Synced;
                    if "Transfer Order Proposal Header"."Transfer Order No." <> '' then
                        "Transfer Order Proposal Header"."Transfer Order No." := "Transfer Order Proposal Header"."Transfer Order No."
                    else
                        "Transfer Order Proposal Header"."Transfer Order No." := "Transfer Order Proposal Header"."No.";
                    "Transfer Order Proposal Header"."Error Remarks" := '';
                    "Transfer Order Proposal Header".Modify();
                end else begin
                    "Transfer Order Proposal Header".Status := "Transfer Order Proposal Header".Status::Error;
                    "Transfer Order Proposal Header"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                    "Transfer Order Proposal Header".Modify();
                    SendNotification("Transfer Order Proposal Header");
                end;
            end;
        }
    }

    procedure ValidateRecord(var Header: Record "Transfer Order Proposal Header")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure SendNotification(var StagingHdr: Record "Transfer Order Proposal Header")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."No."), 'Transfer Order Proposal', StagingHdr."No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Transfer Order Proposal Card", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    var
        Subject: Label 'Mirnah - InBound - Load Request - %1';
}