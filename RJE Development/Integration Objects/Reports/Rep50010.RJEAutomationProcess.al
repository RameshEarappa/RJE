report 50010 "RJE Automation Process"
{
    UseRequestPage = false;
    ProcessingOnly = true;
    //we have created a new RJE Job Automation report in separate extension having dependencies of Agility and base ext.
    //As it is not possible to add dependencies in base extension
    // SO once client will approve that Report then we will remove this report

    trigger OnInitReport()
    begin
        if Codeunit.Run(Codeunit::ResetStatusOfTransferRcptConf) then;
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::ProcessTransferReceiptConf) then;
        //Report.Run(Report::"Process Transfer Receipt Conf.");
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::ProcessSalesOrders) then;
        //Report.Run(Report::"Process sales orders");
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::"Reset Sales Invoice Status") then;
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::ProcessSalesInvoice) then;
        //Report.Run(Report::"Process sales invoice");
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::ProcessCashRcptJnl) then;
        //Report.Run(Report::"Process Cash Receipt Jnl");
        Commit();
        //Sleep(10000);
        if Codeunit.Run(Codeunit::ProcessUnloadStock) then;
        //Report.Run(Report::"Process Unload Stock");
        Commit();
        //Sleep(10000);
    end;
}
