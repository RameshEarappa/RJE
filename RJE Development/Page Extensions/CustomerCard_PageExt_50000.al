pageextension 50000 "Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name-Arabic"; Rec."Name-Arabic")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

        }
        addafter(City)
        {
            field("City In Arabic"; Rec."City In Arabic")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        addafter(Blocked)
        {
            field("Returns Accepted"; Rec."Returns Accepted")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Customer Working Status"; Rec."Status")
            {
                ApplicationArea = All;
                Caption = 'Customer Working Status';
                Importance = Promoted;
            }
            field("Trans. Summary Customer Code"; Rec."Trans. Summary Customer Code")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Salesperson Name"; Rec."Sales Representative Name")
            {
                ApplicationArea = All;
                Importance = Additional;
                Caption = 'Salesperson Name';
            }
            field("Region"; Rec."Sub-Branch")
            {
                ApplicationArea = All;
                Caption = 'Region';
                Importance = Promoted;
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
            field(Territory; Rec.Territory)
            {
                ApplicationArea = All;
                //Caption = 'Consumer Profile Group';
                Importance = Promoted;
            }
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        addafter(Address)
        {
            field("Address 1 - Arabic"; Rec."Address 1 - Arabic")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
        addafter("Address 2")
        {
            field("Address 2 - Arabic"; Rec."Address 2 - Arabic")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
        addlast(General)
        {
            field("RCS Code For Cust. P&L"; Rec."RCS Code")
            {
                ApplicationArea = All;
                Caption = 'RCS Code For Cust. P&L';
                ToolTip = 'RCS Code For Cust. P&L';
                Importance = Promoted;

            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
            }
            field("SOA Group"; Rec."SOA Group")
            {
                ApplicationArea = All;
            }
            /*field("Price List Group"; Rec."Price List Group")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            field("KA Chain Code"; Rec."Key Account")
            {
                ApplicationArea = All;
                Caption = 'KA Chain Code';
                Importance = Additional;
            }
            field("Sales Channel Type"; Rec."Sales Channel Type")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
            field("Geo-code Latitude"; Rec."Geo-Code Latitude")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            //Modified on 11NOV2020
            field("Geo-code Longitude"; Rec."Geo-code Longitude")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Outlet barcode"; Rec."Outlet barcode")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Creation Request Date"; Rec."Creation Request Date")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            /*field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
            }*/
            field("Sales Potential"; Rec."Sales Potential")
            {
                ApplicationArea = All;
            }
            field("Drop Size"; Rec."Drop Size")
            {
                ApplicationArea = All;
            }

            field("Max QTY of Open Invoices"; Rec."Max QTY of Open Invoices")
            {
                ApplicationArea = All;
                Caption = 'Max QTY of Open Invoices';
            }
            /*field("Credit Limit"; Rec."Credit Limit")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            /* field("Payment Terms"; Rec."Payment Terms")
             {
                 ApplicationArea = All;
             }*/
            field("Credit Rating"; Rec."Credit Rating")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Maximum SO Quantity"; Rec."Maximum SO Quantity")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Maximum SO Value"; Rec."Maximum SO Value")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            /*field("Current Balance"; Rec."Current Balance")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            field(Risk; Rec.Risk)
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Due Dated Cheque"; Rec."Due Dated Cheque")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("DSO/DPO"; Rec."DSO/DPO")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            /* field("Promotion Group"; Rec."Promotion Group")
             {
                 ApplicationArea = All;
                 Visible = false;
                 Importance = Additional;
             }*/
            /* field("Sales Representative Code"; Rec."Sales Representative Code")
             {
                 ApplicationArea = All;
                 Visible = false;
             }*/
            /*field("Shipment Delivery Time"; Rec."Shipment Delivery Time")
            {
                ApplicationArea = All;
                Visible = false;
                Importance = Additional;
            }*/

            /*field("Geographic Cell"; Rec."Geographic Cell")
            {
                ApplicationArea = All;
                Visible = false;
            }*/
            /*field("Open for Sales"; Rec."Open for Sales")
            {
                ApplicationArea = All;
                Visible = false;
            }*/

            field("ISF Available"; Rec."ISF Available")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("ISF Free Text"; Rec."ISF Free Text")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            /* field("Default Warehouse"; Rec."Default Warehouse")
             {
                 ApplicationArea = All;
                 Visible = false;
             }*/
            /*field("Default Delivery Type"; Rec."Default Delivery Type")
            {
                ApplicationArea = All;
                Visible = false;
            }*/

            field("Visit/Call Frequency Per Month/Week"; Rec."Visit/Call Frequency Per Month")
            {
                ApplicationArea = All;
                Caption = 'Visit/Call Frequency Per Month/Week';
            }
            field("Best days to visit/call"; Rec."Best days to visit/call")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Best time to visit/call"; Rec."Best time to visit/call")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Size/Area"; Rec."Size/Area")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            //modified on 11NOV2020
            field("Consumer Profile Group"; Rec."Consumer Group")
            {
                ApplicationArea = All;
                Caption = 'Consumer Profile Group';
                Importance = Promoted;
            }
            field("Sales Price Position Group"; Rec."Sales Price Group")
            {
                ApplicationArea = All;
                Caption = 'Sales Price Position Group';
                Importance = Additional;
            }
            field("Sales Promotion Group"; Rec."Sales Promotion Group")
            {
                ApplicationArea = All;
            }

            field("Sales % Pptential Per Month"; Rec."Sales Per. Ptential Per Month")
            {
                ApplicationArea = All;
                Caption = 'Sales % Potential Per Month';
                Importance = Additional;
            }
            field("Sales Vol. Ptential Per Month"; Rec."Sales Vol. Ptential Per Month")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("DSO/DPO Last Update"; Rec."DSO/DPO Last Update")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Buying Activity Code"; Rec."Activity Code")
            {
                ApplicationArea = All;
                Caption = 'Buying Activity Code';
                Importance = Additional;
            }
            field("Block on Overdue"; Rec."Block on Overdue")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Registration No.")
        {
            field("VAT Registration No. In Arabic"; Rec."VAT Registration No. In Arabic")
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