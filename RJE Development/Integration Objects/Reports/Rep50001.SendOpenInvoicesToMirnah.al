report 50001 SendOpenInvoicesToMirnah
{
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnInitReport()
    begin
        if Codeunit.Run(Codeunit::SendOpenInvoicesToMirnah) then;
    end;
}