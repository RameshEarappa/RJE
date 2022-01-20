pageextension 50016 LoctionList_Ext extends "Location List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("VAN Warehouse"; Rec."DR Location")
            {
                ApplicationArea = All;
            }

            field("Sales Person"; Rec."Sales Person")
            {
                ApplicationArea = All;
            }
            field("Default Replenishment Whse."; Rec."Default Replenishment Whse.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Create Warehouse location")
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
                    exportxml: XmlPort "Export Warehouse Location";
                    RecLoction: Record Location;
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecLoction);
                    CurrPage.SetSelectionFilter(RecLoction);
                    if RecLoction.FindSet() then begin
                        if not Confirm('Do you want to send Warehouse to SFA?', false) then exit;
                        Clear(Blob);
                        Clear(outstr);
                        exportxml.SetTableView(RecLoction);
                        Blob.CreateOutStream(outstr);
                        exportxml.SetDestination(outstr);
                        exportxml.Export();
                        Blob.CreateInStream(InStream, TextEncoding::UTF8);
                        Utility.SendLocationsToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), True);
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}