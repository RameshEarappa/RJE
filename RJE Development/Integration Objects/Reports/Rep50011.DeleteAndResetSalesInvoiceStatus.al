codeunit 50016 "Reset Sales Invoice Status"
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var
        RecSalesHeader: Record "Sales Header";
        Header: Record "Sales Invoice Header Staging";
    begin
        Clear(RecSalesHeader);
        RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Invoice);
        RecSalesHeader.SetRange("Created by API", true);
        RecSalesHeader.SetRange("Posting Date", WorkDate());
        if RecSalesHeader.IsEmpty then
            exit;//added check so that code will not take much time when there is nothing to do.
        Clear(Header);
        Header.SetCurrentKey("Entry No.");
        Header.SetAscending("Entry No.", false);
        Header.SetFilter(Status, '%1|%2', Header.Status::Error, Header.Status::"Posting Error");
        Header.SetRange("Posting Date", WorkDate());
        Header.SetFilter("Error Remarks", '<>@*There is no enough Inventory*&<>@*You must assign a lot number*');
        Header.SetFilter("Sales Invoice No.", '<>%1', '');
        if Header.FindSet() then begin
            repeat
                Clear(RecSalesHeader);
                RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Invoice);
                RecSalesHeader.SetRange("Created by API", true);
                RecSalesHeader.SetRange("No.", Header."Sales Invoice No.");
                if RecSalesHeader.FindFirst() then begin
                    RecSalesHeader.SetHideValidationDialog(true);
                    RecSalesHeader.Delete(True);
                    Header."Sales Invoice No." := '';
                    Header."Error Remarks" := '';
                    Header.Status := Header.Status::"Ready To Sync";
                    Header.Modify();
                end;
            until Header.Next() = 0;
        end;
    end;
}
