pageextension 50018 SalesPriceExt extends "Sales Prices"
{
    layout
    {
        moveafter("Unit Price"; "VAT Bus. Posting Gr. (Price)")
        addlast(Control1)
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            //30.07.2021
            field("List Name"; Rec."List Name")
            {
                ApplicationArea = All;
            }
            //30.07.2021
        }
    }
    actions
    {
        addafter(CopyPrices)
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
                    exportxml: XmlPort "Export Sales Price";
                    RecSalesPrices: Record "Sales Price";
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecSalesPrices);
                    CurrPage.SetSelectionFilter(RecSalesPrices);
                    if RecSalesPrices.FindSet() then begin
                        if not Confirm('Do you want to send Sales Prices to SFA?', false) then exit;
                        Clear(Blob);
                        Clear(outstr);
                        exportxml.SetTableView(RecSalesPrices);
                        Blob.CreateOutStream(outstr);
                        exportxml.SetDestination(outstr);
                        exportxml.Export();
                        Blob.CreateInStream(InStream, TextEncoding::UTF8);
                        Utility.SendSalesPriceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), True);
                    end;
                end;
            }
        }
    }
}
tableextension 50017 salesprice extends "Sales Price"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        //30.07.2021
        field(50001; "List Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //30.07.2021
    }

    var
        myInt: Integer;
}
tableextension 50024 PurchasePrice extends "Purchase Price"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
pageextension 50024 PurchasePrice extends "Purchase Prices"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}