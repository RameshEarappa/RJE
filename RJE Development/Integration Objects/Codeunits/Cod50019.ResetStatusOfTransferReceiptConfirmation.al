codeunit 50019 ResetStatusOfTransferRcptConf
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var
        Header: Record "Transfer Receipt Confirmation";
    begin
        Clear(Header);
        Header.SetCurrentKey("Entry No.");
        Header.SetAscending("Entry No.", false);
        Header.SetFilter(Status, '=%1', Header.Status::Error);
        Header.SetRange("Posting Date", WorkDate());
        Header.SetFilter("Error Remarks", '<>@*The Transfer Header does not exist*&<>@*Qty. to Receive must be equal to*&<>@*Load No. must have a value in Transfer Receipt*');
        if Header.FindSet() then begin
            repeat
                Header."Error Remarks" := '';
                Header.Status := Header.Status::"Ready To Sync";
                Header.Modify();
            until Header.Next() = 0;
        end;
    end;
}

