codeunit 50033 ProcessCashRcptJnl
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var

    begin
        Report.Run(Report::"Process Cash Receipt Jnl");
    end;
}