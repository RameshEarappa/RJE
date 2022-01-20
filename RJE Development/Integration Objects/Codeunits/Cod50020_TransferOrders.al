codeunit 50020 ProcessTransferReceiptConf
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var

    begin
        Report.Run(Report::"Process Transfer Receipt Conf.");
    end;
}