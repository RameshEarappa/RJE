page 50019 "Transfer Orders Unload Stock"
{

    ApplicationArea = All;
    Caption = 'Transfer Orders UnloadStock';
    PageType = List;
    SourceTable = "Transfer Order Unload Header";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    CardPageId = "Transfer Order Unload Card";
    DataCaptionFields = "No.", "Transfer-From Code";
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
                field("Day End Process Status"; Rec."Day End Process Status")
                {
                    ApplicationArea = All;
                }
                field("Day End Process Error"; Rec."Day End Process Error")
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
            action("Process Unload Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Process;
                trigger OnAction()
                var
                    ProcessUnloadStock: Report "Process Unload Stock";
                    RecUnloadStock: Record "Transfer Order Unload Header";
                begin
                    Clear(RecUnloadStock);
                    CurrPage.SetSelectionFilter(RecUnloadStock);
                    if RecUnloadStock.FindSet() then begin
                        ProcessUnloadStock.ValidateRecord(RecUnloadStock);
                        if not Confirm('Do you want to Process Unload Stock Request?', false) then
                            exit;
                        Clear(ProcessUnloadStock);
                        ProcessUnloadStock.SetTableView(RecUnloadStock);
                        ProcessUnloadStock.Run();
                    end
                end;
            }
            action("Change Status")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Change;

                trigger OnAction()
                var
                    RecUnloadStock: Record "Transfer Order Unload Header";
                begin
                    Clear(RecUnloadStock);
                    CurrPage.SetSelectionFilter(RecUnloadStock);
                    if RecUnloadStock.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                        repeat
                            if not (RecUnloadStock.Status in [RecUnloadStock.Status::Error, RecUnloadStock.Status::" "]) then
                                RecUnloadStock.TestField(Status, RecUnloadStock.Status::Error);
                            RecUnloadStock.Status := RecUnloadStock.Status::"Ready To Sync";
                            RecUnloadStock."Error Remarks" := '';
                            RecUnloadStock.Modify();
                        until
                        RecUnloadStock.Next() = 0;
                    end
                end;
            }
        }
    }
}
