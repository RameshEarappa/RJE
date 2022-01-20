report 50011 SendWarehouseStocks
{
    trigger OnInitReport()
    begin
        if Codeunit.Run(Codeunit::SendWarehouseStocks) then;
    end;
}
