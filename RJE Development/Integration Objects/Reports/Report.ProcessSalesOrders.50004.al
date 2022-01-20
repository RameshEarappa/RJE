report 50004 "Process Sales Orders"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Sales Order Header Staging"; "Sales Order Header Staging")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Sync"));
            trigger OnAfterGetRecord()
            begin
                ClearLastError();
                Commit();
                if Codeunit.Run(Codeunit::"Process Sales Order", "Sales Order Header Staging") then begin
                    "Sales Order Header Staging".Status := "Sales Order Header Staging".Status::Synced;
                    "Sales Order Header Staging"."Sales Order No." := "Sales Order Header Staging"."No.";
                    "Sales Order Header Staging"."Error Remarks" := '';
                    "Sales Order Header Staging".Modify();
                    SendWarehouseStocksRequired := true;
                end else begin
                    "Sales Order Header Staging".Status := "Sales Order Header Staging".Status::Error;
                    "Sales Order Header Staging"."Sales Order No." := '';
                    "Sales Order Header Staging"."Error Remarks" := CopyStr(GetLastErrorText, 1, 250);
                    "Sales Order Header Staging".Modify();
                    SendNotification("Sales Order Header Staging");
                end;
            end;

            trigger OnPostDataItem()
            var
                SendWarehouseStocks: Codeunit SendWarehouseStocks;
            begin
                if SendWarehouseStocksRequired then begin
                    Commit;
                    if SendWarehouseStocks.Run() then;
                end

            end;
        }
    }
    procedure ValidateRecord(var Header: Record "Sales Order Header Staging")
    begin
        if Header.FindSet() then begin
            repeat
                Header.TestField(Status, Header.Status::"Ready To Sync");
            until Header.Next() = 0;
        end
    end;

    local procedure SendNotification(var StagingHdr: Record "Sales Order Header Staging")
    var
        SendNotification: Codeunit "Send Notification";
    begin
        Commit;
        SendNotification.InitializeValues(StrSubstNo(Subject, StagingHdr."No."), 'Sales Order', StagingHdr."No.", StagingHdr."Error Remarks", GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Sales Order Staging Card", StagingHdr, false));
        if SendNotification.RUN then;
    end;

    var
        SendWarehouseStocksRequired: Boolean;
        Subject: Label 'Mirnah - InBound - Sales Order - %1';
}