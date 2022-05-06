report 50009 "Process Unload Stock"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Transfer Order Unload Header"; "Transfer Order Unload Header")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            var
                RecSalesInvoiceHdrStaging: Record "Sales Invoice Header Staging";
            begin
                if rowcount <= 10 then begin
                    if not GuiAllowed then begin
                        Clear(RecSalesInvoiceHdrStaging);
                        RecSalesInvoiceHdrStaging.SetRange("Posting Date", "Transfer Order Unload Header"."Posting Date");
                        RecSalesInvoiceHdrStaging.SetRange("Location Code", "Transfer Order Unload Header"."Transfer-From Code");
                        RecSalesInvoiceHdrStaging.SetFilter(Status, '<>%1|%2', RecSalesInvoiceHdrStaging.Status::Posted, RecSalesInvoiceHdrStaging.Status::Synced);
                        if not RecSalesInvoiceHdrStaging.IsEmpty then
                            CurrReport.Skip();//Skipping if there is any pending invoices in Staging table or stuck due to error
                    end;

                    ClearLastError();
                    Commit();
                    if Codeunit.Run(Codeunit::"Process Unload Stock Req", "Transfer Order Unload Header") then begin
                        "Transfer Order Unload Header".Status := "Transfer Order Unload Header".Status::Synced;
                        "Transfer Order Unload Header"."Error Remarks" := '';
                        "Transfer Order Unload Header".Modify();
                    end else begin
                        "Transfer Order Unload Header".Status := "Transfer Order Unload Header".Status::Error;
                        "Transfer Order Unload Header"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                        "Transfer Order Unload Header".Modify();
                        SendNotification("Transfer Order Unload Header");
                    end;
                end;
            end;

            trigger onpredataitem()
            var
                myInt: Integer;
            begin
                RowCount := 1;
            end;
        }
    }

    procedure ValidateRecord(var Header: Record "Transfer Order Unload Header")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure SendNotification(var StagingHdr: Record "Transfer Order Unload Header")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."No."), 'Unload Request', StagingHdr."No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Transfer Order Unload Card", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    var
        Subject: Label 'Mirnah - InBound - Unload EndOfDay - %1';
        RowCount: Integer;
}