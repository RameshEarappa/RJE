codeunit 50034 ProcessUnloadStock
{
    //ProcessingOnly = true;
    //UseRequestPage = false;

    trigger OnRun()
    var

    begin
        Report.Run(Report::"Process Unload Stock");
    end;
}