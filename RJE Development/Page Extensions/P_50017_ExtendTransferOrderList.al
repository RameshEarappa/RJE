pageextension 50017 TransferOrderlist extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter("Transfer-to Code")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Transfer-To Salesperson Code';
            }
            field("Salesperson Name"; Rec."Salesperson Name")
            {
                ApplicationArea = All;
                Caption = 'Transfer-To Salesperson Name';
                Editable = false;
            }
            field("Transfer-From Salesperson Code"; Rec."Transfer-From Salesperson Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Transfer-From Salesperson Name"; Rec."Transfer-From Salesperson Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Mirnah Reference No."; Rec."Mirnah Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

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
                    exportxml: XmlPort "Export Transfer Order";
                    RecTransferOrderHeader: Record "Transfer Header";
                    RecTransferLine: Record "Transfer Line";
                    InStream: InStream;
                    Blob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    TypeHelper: Codeunit "Type Helper";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(exportxml);
                    Clear(RecTransferOrderHeader);
                    CurrPage.SetSelectionFilter(RecTransferOrderHeader);
                    if RecTransferOrderHeader.FindSet() then begin
                        if not Confirm('Do you want to send Load to SFA?', false) then exit;
                        repeat
                            Clear(RecTransferLine);
                            RecTransferLine.SetRange("Document No.", RecTransferOrderHeader."No.");
                            RecTransferLine.SetRange("Derived From Line No.", 0);
                            if RecTransferLine.FindSet() then begin
                                Clear(Blob);
                                Clear(outstr);
                                exportxml.SetTableView(RecTransferLine);
                                Blob.CreateOutStream(outstr);
                                exportxml.SetDestination(outstr);
                                exportxml.Export();
                                Blob.CreateInStream(InStream, TextEncoding::UTF8);
                                Utility.SendTransferOrderToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), true);
                            end;
                        until RecTransferOrderHeader.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}