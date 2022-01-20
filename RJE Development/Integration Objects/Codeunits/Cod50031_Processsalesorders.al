codeunit 50031 ProcessSalesOrders
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var

    begin
        Report.Run(Report::"Process Sales Orders");
    end;
}