pageextension 50015 "SalesPersonPurchaser_Ext" extends "Salespersons/Purchasers"
{
    actions
    {
        // Add changes to page actions here
        addlast(Creation)
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
                    exportxml: XmlPort "Export Salesperson";
                    RecSalesPersonPurchaser: Record "Salesperson/Purchaser";
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecSalesPersonPurchaser);
                    CurrPage.SetSelectionFilter(RecSalesPersonPurchaser);
                    if RecSalesPersonPurchaser.FindSet() then begin
                        if not Confirm('Do you want to send Salesman to SFA?', false) then exit;
                        Clear(Blob);
                        Clear(outstr);
                        exportxml.SetTableView(RecSalesPersonPurchaser);
                        Blob.CreateOutStream(outstr);
                        exportxml.SetDestination(outstr);
                        exportxml.Export();
                        Blob.CreateInStream(InStream, TextEncoding::UTF8);
                        Utility.SendSalespersonToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), True);
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}