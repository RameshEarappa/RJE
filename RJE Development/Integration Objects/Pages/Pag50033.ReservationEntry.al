page 50033 "Reservation Entry"
{

    ApplicationArea = All;
    Caption = 'Reservation Entry';
    PageType = List;
    SourceTable = "Reservation Entry";
    UsageCategory = Administration;
    ModifyAllowed = false;
    DeleteAllowed = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Source ID"; Rec."Source ID")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Quantity Invoiced (Base)"; Rec."Quantity Invoiced (Base)")
                {
                    ApplicationArea = All;
                }
                field("Reservation Status"; Rec."Reservation Status")
                {
                    ApplicationArea = All;
                }
                field("Production Date"; Rec."Production Date")
                {
                    ApplicationArea = All;
                }

                field("Source Batch Name"; Rec."Source Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                    ApplicationArea = All;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = All;
                }
                field("Item Tracking"; Rec."Item Tracking")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }

                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

}
