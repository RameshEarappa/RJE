report 50012 SendMasterDataToSFA
{
    trigger OnInitReport()
    begin
        if Codeunit.Run(Codeunit::SendMasterDataFromBCToSFA) then;
    end;
}
