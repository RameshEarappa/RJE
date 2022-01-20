page 50013 "Transfer Orders Shipment"
{

    ApplicationArea = All;
    Caption = 'Transfer Orders Shipment';
    PageType = List;
    SourceTable = "Transfer Order Shipment Header";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    CardPageId = "Transfer Order Shipment Card";
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Transfer-From Code"; Rec."Transfer-From Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-To Code"; Rec."Transfer-To Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ApplicationArea = All;
                    Style = Attention;
                }
                field("Added on"; Rec."Added on")
                {
                    ApplicationArea = All;
                }
                field("Load Period No."; Rec."Load Period No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Change Status")
            {
                ApplicationArea = All;
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RecHeader: Record "Transfer Order Shipment Header";
                begin
                    Clear(RecHeader);
                    CurrPage.SetSelectionFilter(RecHeader);
                    if RecHeader.FindSet() then begin
                        repeat
                            if (RecHeader.Status = RecHeader.Status::Error) OR (RecHeader.Status = RecHeader.Status::" ") then
                                RecHeader.Status := RecHeader.Status::"Ready to Sync"
                            else
                                RecHeader.TestField(Status, RecHeader.Status::Error);
                            RecHeader.Modify()
                        until RecHeader.Next() = 0;
                    end
                end;
            }
        }
    }
}
