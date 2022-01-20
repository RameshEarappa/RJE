pageextension 60002 "Ext Company Information" extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("Name In Arabic"; Rec."Name In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter(Address)
        {
            field("Address In Arabic"; Rec."Address In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter("Address 2")
        {
            field("Address 2 In Arabic"; Rec."Address 2 In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter(City)
        {
            field("City In Arabic"; Rec."City In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter(County)
        {
            field("Country In Arabic"; Rec."Country In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter("Post Code")
        {
            field("Post Code In Arabic"; Rec."Post Code In Arabic")
            {
                ApplicationArea = All;
            }
        }
        addafter("Country/Region Code")
        {
            field("Country/Region Code In Arabic"; Rec."Country/Region Code In Arabic")
            {
                ApplicationArea = All;
            }
            field("Date Validation - Company Name"; Rec."Date Validation - Company Name")
            {
                ApplicationArea = All;
            }
            field("Company Name"; Rec."Company Name")
            {
                ApplicationArea = All;
            }
            field("Company Name In Arabic"; Rec."Company Name in Arabic")
            {
                ApplicationArea = All;
            }

        }
        addafter(Picture)
        {
            field("old company Logo"; Rec."Old Company Logo")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}