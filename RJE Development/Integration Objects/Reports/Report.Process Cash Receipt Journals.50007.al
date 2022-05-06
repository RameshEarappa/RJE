report 50007 "Process Cash Receipt Jnl"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Cash Receipt Journal Staging"; "Cash Receipt Journal Staging")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            var
                RecPostedSalesInvoiceHdr: Record "Sales Invoice Header";
            begin
                //if rowcount <= 1 then begin
                if not GuiAllowed then begin
                    "Cash Receipt Journal Staging".TestField("Applies-To Doc. No.");
                    Clear(RecPostedSalesInvoiceHdr);
                    RecPostedSalesInvoiceHdr.SetRange("No.", "Cash Receipt Journal Staging"."Applies-To Doc. No.");
                    if RecPostedSalesInvoiceHdr.IsEmpty then
                        CurrReport.Skip(); //Skipping if the sales invoice is not posted
                end;
                ClearLastError();
                Commit();
                if Codeunit.Run(Codeunit::"Process Cash Receipt Jnl", "Cash Receipt Journal Staging") then begin
                    "Cash Receipt Journal Staging".Status := "Cash Receipt Journal Staging".Status::Synced;
                    "Cash Receipt Journal Staging"."Error Remarks" := '';
                    "Cash Receipt Journal Staging".Modify();
                end else begin
                    "Cash Receipt Journal Staging".Status := "Cash Receipt Journal Staging".Status::Error;
                    "Cash Receipt Journal Staging"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                    "Cash Receipt Journal Staging".Modify();
                    SendNotification("Cash Receipt Journal Staging");
                end;
                RowCount += 1;
            end;
            //end;

            trigger OnPreDataItem()
            begin
                if not GuiAllowed then
                    SetFilter("Entry No.", '>%1', 2130);

                RowCount := 1;
            end;
        }
    }

    procedure ValidateRecord(var Header: Record "Cash Receipt Journal Staging")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure SendNotification(var StagingHdr: Record "Cash Receipt Journal Staging")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."Document No."), 'Collection', StagingHdr."Document No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Cash Receipt Journal Staging", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    var
        Subject: Label 'Mirnah - InBound - Collection - %1';
        RowCount: Integer;
}