pageextension 50014 "ItemList_Ext" extends "Item List"
{
    actions
    {
        // Add changes to page actions here
        addlast(Service)
        {
            action("Send to SFA")
            {
                ApplicationArea = All;
                Image = SendTo;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    exportxml: XmlPort "Export Item";
                    RecItem: Record Item;
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecItem);
                    CurrPage.SetSelectionFilter(RecItem);
                    if RecItem.FindSet() then begin
                        if not Confirm('Do you want to send Items to SFA?', false) then exit;
                        Clear(Blob);
                        Clear(outstr);
                        exportxml.SetTableView(RecItem);
                        Blob.CreateOutStream(outstr, TextEncoding::UTF8);
                        exportxml.SetDestination(outstr);
                        exportxml.Export();
                        Blob.CreateInStream(InStream, TextEncoding::UTF8);
                        Utility.SendItemsToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), true);
                    end;
                end;
            }


            action("Send Warehouse Stock To SFA")
            {
                ApplicationArea = All;
                Image = SendTo;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    exportxml: XmlPort "Export Stock Invenoty";
                    RecBinContents: Record "Bin Content";
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    RecItem: Record Item;
                    IntegrationSetup: Record "Integration Setup";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecItem);
                    CurrPage.SetSelectionFilter(RecItem);
                    if RecItem.FindSet() then begin
                        IntegrationSetup.GET;
                        Clear(RecBinContents);
                        RecBinContents.SetCurrentKey("Item No.", "Location Code");
                        RecBinContents.SetAscending("Location Code", true);
                        //if IntegrationSetup."Enable Stocks for selected Bin" then
                        RecBinContents.SetRange("Bin Code", 'GOOD2SELL');
                        RecBinContents.SetFilter("Item No.", RecItem.GetFilter("No."));
                        if RecBinContents.FindSet() then begin
                            if not Confirm('Do you want to send Warehosue Stocks to SFA?', false) then exit;
                            Clear(Blob);
                            Clear(outstr);
                            exportxml.SetTableView(RecBinContents);
                            Blob.CreateOutStream(outstr);
                            exportxml.SetDestination(outstr);
                            exportxml.Export();
                            Blob.CreateInStream(InStream, TextEncoding::UTF8);
                            Utility.SendWarehsoueStockToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), true);
                        end else
                            Error('Records are not available in the table Bin Content for selected Item.');
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
