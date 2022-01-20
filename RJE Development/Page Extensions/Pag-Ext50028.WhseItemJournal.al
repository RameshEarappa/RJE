pageextension 50028 "Whse. Item Journal" extends "Whse. Item Journal"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("C Lot No."; Rec."C Lot No.")
            {
                ApplicationArea = All;
            }
            field("C Expiration Date"; Rec."C Expiration Date")
            {
                ApplicationArea = All;
            }
            field("C Production Date"; Rec."C Production Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Create Item Tracking Lines")
            {
                ApplicationArea = All;
                Image = ItemTracking;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    RecWhsejln: Record "Warehouse Journal Line";
                    Utility: Codeunit "Integration Utility";
                begin
                    Clear(RecWhsejln);
                    CurrPage.SetSelectionFilter(RecWhsejln);
                    if RecWhsejln.FindSet() then begin
                        if not Confirm('Do you want to create Item Tracking Lines?', false) then exit;
                        Utility.CreateItemTrackingLinesForWhseJln(RecWhsejln);
                    end
                end;
            }
        }
    }
    var
        abc: page "Item Journal";
}
