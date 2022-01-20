page 50024 "Sales Order Lines Part"
{
    PageType = ListPart;
    SourceTable = "Sales Order Line Staging";
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                }
                field("Free Sample Quantity"; Rec."Free Sample Quantity")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Amount Inc. VAT"; Rec."Amount Inc. VAT")
                {
                    ApplicationArea = All;
                }
                //TT-RS-20210513 Vuse Device Discounting Price-
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = all;
                }
                //TT-RS-20210513 Vuse Device Discounting Price+
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
