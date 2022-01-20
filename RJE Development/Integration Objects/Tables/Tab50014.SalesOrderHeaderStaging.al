table 50014 "Sales Order Header Staging"
{
    Caption = 'Sales Order Header Staging';
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.", "Sell-To Customer No.";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            ValidateTableRelation = false;
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Order Type"; Option)
        {
            Caption = 'Order Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sales + FOC","FOC";
        }
        field(6; "Sales Order Type"; Code[20])
        {
            Caption = 'Sales Order Type';
            DataClassification = ToBeClassified;
        }
        field(7; "Sales Channel Type"; Code[20])
        {
            Caption = 'Sales Channel Type';
            DataClassification = ToBeClassified;
        }
        field(8; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = false;
        }
        field(9; "Amount To Customer"; Decimal)
        {
            Caption = 'Amount To Customer';
            DataClassification = ToBeClassified;
        }
        field(10; "Invoice Discount"; Decimal)
        {
            Caption = 'Invoice Discount';
            DataClassification = ToBeClassified;
        }
        field(11; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Ready To Sync",Synced,Error;
        }
        field(12; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(13; "Error Remarks"; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
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
        Lines: Record "Sales Order Line Staging";
    begin
        Clear(Lines);
        Lines.SetRange("Sales Order Entry No.", Rec."Entry No.");
        if Lines.FindSet() then
            Lines.DeleteAll(true);
    end;
}
