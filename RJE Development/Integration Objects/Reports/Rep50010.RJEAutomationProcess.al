report 50010 "RJE Automation Process"
{
    UseRequestPage = false;
    ProcessingOnly = true;

    trigger OnInitReport()
    begin
        if Codeunit.Run(Codeunit::ResetStatusOfTransferRcptConf) then;
        Commit();
        if Codeunit.Run(Codeunit::ProcessTransferReceiptConf) then;
        //Report.Run(Report::"Process Transfer Receipt Conf.");
        Commit();
        if Codeunit.Run(Codeunit::ProcessSalesOrders) then;
        //Report.Run(Report::"Process sales orders");
        Commit();
        if Codeunit.Run(Codeunit::"Reset Sales Invoice Status") then;
        Commit();
        if Codeunit.Run(Codeunit::ProcessSalesInvoice) then;
        //Report.Run(Report::"Process sales invoice");
        Commit();
        if Codeunit.Run(Codeunit::ProcessCashRcptJnl) then;
        //Report.Run(Report::"Process Cash Receipt Jnl");
        Commit();
        if Codeunit.Run(Codeunit::ProcessUnloadStock) then;
        //Report.Run(Report::"Process Unload Stock");
        Commit();
    end;
}
