pageextension 50002 GenLedSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'RCS Code For Cust. P&L';
        }
        modify("Shortcut Dimension 3 Code")
        {
            Caption = 'Sales Channel';
        }
        modify("Shortcut Dimension 4 Code")
        {
            Caption = 'Branch';
        }
        modify("Shortcut Dimension 5 Code")
        {
            Caption = 'KA Chain Code';
        }
        modify("Shortcut Dimension 6 Code")
        {
            Caption = 'Brand';
        }
        modify("Shortcut Dimension 7 Code")
        {
            Caption = 'Product Reporting Group';
        }
        modify("Shortcut Dimension 8 Code")
        {
            Caption = 'SKU Reporting Group';
        }

        addafter(Application)
        {
            group("Customer Dimensions")
            {
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Sales Potential"; Rec."Sales Potential")
                {
                    ApplicationArea = All;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = All;
                }
                field("Sub-Branch"; Rec."Sub-Branch")
                {
                    ApplicationArea = All;
                }
                field("Consumer Group"; Rec."Consumer Group")
                {
                    ApplicationArea = All;
                }
                field("Sales Price Group"; Rec."Sales Price Group")
                {
                    ApplicationArea = All;
                }
                field("Sales Promotion Group"; Rec."Sales Promotion Group")
                {
                    ApplicationArea = All;
                }
                field(Territory; Rec.Territory)
                {
                    ApplicationArea = All;
                }

            }

            group("Administration Structure Series")
            {
                field("Country Sales Mng. No. Series"; Rec."Country Sales Mng. No. Series")
                {
                    ApplicationArea = All;
                }
                field("Regional Sales Mng. No. Series"; Rec."Regional Sales Mng. No. Series")
                {
                    ApplicationArea = All;
                }
                field("Area Sales Mng. No. Series"; Rec."Area Sales Mng. No. Series")
                {
                    ApplicationArea = All;
                }
                field("Supervisor No. Series"; Rec."Supervisor No. Series")
                {
                    ApplicationArea = All;
                }
                field("Delivery Representative"; Rec."Delivery Rep. No. Series")
                {
                    ApplicationArea = All;
                }
            }
            group("Item Dimensions")
            {
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
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
                field("SOA Group"; Rec."SOA Group")
                {
                    ApplicationArea = All;
                }
                field("Sales Pricing Group"; Rec."Sales Pricing Group")
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
                //modified on 11NOV2020
                field("Brand Type"; Rec."Brand Type")
                {
                    ApplicationArea = All;
                }
                field("Consumer Profile"; Rec."Consumer Profile")
                {
                    ApplicationArea = All;
                }

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