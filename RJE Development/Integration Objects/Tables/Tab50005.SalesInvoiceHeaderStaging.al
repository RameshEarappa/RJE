table 50005 "Sales Invoice Header Staging"
{
    Caption = 'Sales Invoice Header Staging';
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.", "Sell-To Customer No.";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
            DataClassification = ToBeClassified;
        }
        field(5; "External Doucment No."; Text[50])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sales + FOC","FOC";
        }
        field(7; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(8; "Salesperson Code"; Code[20])
        {
            Caption = 'Sales Person Code';
            DataClassification = ToBeClassified;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(11; "Invoice Discount Amount"; Decimal)
        {
            Caption = 'Invoice Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(12; "Amount Inc. VAT"; Decimal)
        {
            Caption = 'Amount Inc. VAT';
            DataClassification = ToBeClassified;
        }
        field(13; "Amount To Customer"; Decimal)
        {
            Caption = 'Amount To Customer';
            DataClassification = ToBeClassified;
        }
        field(14; "Sales Channel Type"; Code[20])
        {
            Caption = 'Sales Channel Type';
            DataClassification = ToBeClassified;
        }
        field(15; "Sales Order Type"; Code[20])
        {
            Caption = 'Sales Order Type';
            DataClassification = ToBeClassified;
        }
        field(16; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Ready To Sync","Synced","Error",Posted,"Posting Error";
        }
        field(17; "Error Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Sales Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Invoice));
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        Lines: Record "Sales Inv. Line Staging";
    begin
        Clear(Lines);
        Lines.SetRange("Sales Inv. Entry No.", Rec."Entry No.");
        if Lines.FindSet() then
            Lines.DeleteAll(true);
    end;
}
