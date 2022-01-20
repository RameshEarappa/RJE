codeunit 50014 SendWarehouseStocks
{
    trigger OnRun()
    var
        exportxml: XmlPort "Export Stock Invenoty";
        RecBinContents: Record "Bin Content";
        InStream: InStream;
        Blob: Codeunit "Temp Blob";
        outstr: OutStream;
        TypeHelper: Codeunit "Type Helper";
        IntegrationSetup: Record "Integration Setup";
        Utility: Codeunit "Integration Utility";
    begin
        Clear(exportxml);
        IntegrationSetup.GET;
        Clear(RecBinContents);
        RecBinContents.SetCurrentKey("Item No.", "Location Code");
        RecBinContents.SetAscending("Location Code", true);
        RecBinContents.SetFilter("Bin Code", Utility.GetBinCodeFilter);
        if RecBinContents.FindSet() then begin
            Clear(Blob);
            Clear(outstr);
            exportxml.SetTableView(RecBinContents);
            Blob.CreateOutStream(outstr);
            exportxml.SetDestination(outstr);
            exportxml.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendWarehsoueStockToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), false);
        end;
    end;
}
