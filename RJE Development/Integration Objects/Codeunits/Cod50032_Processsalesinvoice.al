codeunit 50032 ProcessSalesInvoice
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var

    begin
        Report.Run(Report::"Process Sales Invoice");
    end;
}