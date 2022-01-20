page 50012 "Sales Inv. Line Staging"
{
    PageType = ListPart;
    SourceTable = "Sales Inv. Line Staging";
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
                field("Lot No."; Rec."Lot No.")
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
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Free Sample Quantity"; Rec."Free Sample Quantity")
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
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
