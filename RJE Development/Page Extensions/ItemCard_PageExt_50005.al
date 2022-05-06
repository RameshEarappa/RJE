pageextension 50005 ItemCard extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Mirnah Description';
            }
            field("Description-Arabic"; Rec."Description-Arabic")
            {
                ApplicationArea = All;
            }
        }

        addlast(Item)
        {
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field("Brand Type"; Rec."Brand Type")
            {
                ApplicationArea = All;
            }
            field(Category; Rec.Category)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Flavor Type"; Rec."Flavor Type")
            {
                ApplicationArea = All;
            }
            field("Nicotine Color"; Rec."Nicotine Color")
            {
                ApplicationArea = All;
            }
            field("Nicotine Mg"; Rec."Nicotine Mg")
            {
                ApplicationArea = All;
            }
            field("Pack Size"; Rec."Pack Size")
            {
                ApplicationArea = All;
            }
            field(Portfolio; Rec.Portfolio)
            {
                ApplicationArea = All;
            }
            field("Product Reporting Group"; Rec."Product Reporting Group")
            {
                ApplicationArea = All;
            }
            field("SOA Group"; Rec."SOA Group")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Sales Pricing Group"; Rec."Sales Pricing Group")
            {
                ApplicationArea = All;
            }
            field("SKU Reporting Group"; Rec."SKU Reporting Group")
            {
                ApplicationArea = All;
            }
            field("Product Type"; Rec."Product Type")
            {
                ApplicationArea = All;
            }
            field(Size; Rec.Size)
            {
                ApplicationArea = All;
            }
            field(Special; Rec.Special)
            {
                ApplicationArea = All;
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = All;
                Caption = 'Active Listed';
            }
            field("Consumer Profile"; Rec."Consumer Profile")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            //Modified on 11NOV2020
            /* field("Open For Sales"; Rec."Open For Sales")
             {
                 ApplicationArea = All;
                 Visible = false;
             }*/
            /*field("Open For Purchase"; Rec."Open For Purchase")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            field("Master Barcode"; Rec."Master Barcode")
            {
                ApplicationArea = All;
            }
            field(Barcode; Rec.Barcode)
            {
                ApplicationArea = All;
            }
            field(Dimension; Rec.Dimension)
            {
                ApplicationArea = All;
            }
            /*field("Pack Dimension"; Rec."Pack Dimension")
            {
                ApplicationArea = All;
            }*/
            /*field("Active For Transfer"; Rec."Active For Transfer")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            field("SKU Obselete Status"; Rec."SKU Obselete Status")
            {
                ApplicationArea = All;
            }
            field("FOC Item"; Rec."FOC Item")
            {
                ApplicationArea = All;
            }
            field("FOC Nominal Cost For VAT calc."; Rec."FOC Nominal Cost For VAT calc.")
            {
                ApplicationArea = All;
                Caption = 'FOC/Disc Nominal Cost For VAT calc.';
            }
            /*
            //TT-RS-20210511-
            field(Discount; Rec."Discount")
            {
                ApplicationArea = All;
                Caption = 'Discount';
            }
            //TT-RS-20210511+
            */
            field("HS Code"; Rec."HS Code")
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