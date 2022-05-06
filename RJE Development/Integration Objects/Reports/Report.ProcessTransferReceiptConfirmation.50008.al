report 50008 "Process Transfer Receipt Conf."
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Transfer Receipt Confirmation"; "Transfer Receipt Confirmation")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            var
                integrationSetupL: Record "Integration Setup";
            begin
                integrationSetupL.Get();
                if rowcount <= integrationSetupL."Transfer Receipt Confirmation" then begin
                    ClearLastError();
                    Commit();
                    if Codeunit.Run(Codeunit::"Process Transfer Receipt Conf.", "Transfer Receipt Confirmation") then begin
                        "Transfer Receipt Confirmation".Status := "Transfer Receipt Confirmation".Status::Synced;
                        "Transfer Receipt Confirmation"."Error Remarks" := '';
                        "Transfer Receipt Confirmation".Modify();
                    end else begin
                        "Transfer Receipt Confirmation".Status := "Transfer Receipt Confirmation".Status::Error;
                        "Transfer Receipt Confirmation"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                        "Transfer Receipt Confirmation".Modify();
                        SendNotification("Transfer Receipt Confirmation");
                    end;
                    RowCount += 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                RowCount := 1;
            end;
        }

    }


    procedure ValidateRecord(var Header: Record "Transfer Receipt Confirmation")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure SendNotification(var StagingHdr: Record "Transfer Receipt Confirmation")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."Load No."), 'Transfer Receipt Confirmation', StagingHdr."Load No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Transfer Receipt Card", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    var
        Subject: Label 'Mirnah - InBound - Loading Confirmation - %1';
        RowCount: Integer;

}