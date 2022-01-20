table 50013 "Transfer Receipt Confirmation"
{
    Caption = 'Transfer Receipt Confirmation';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Load No.", "Transfer-From Code";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Load No."; Code[20])
        {
            Caption = 'Load No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(4; "LoadPeriod No."; Integer)
        {
            Caption = 'LoadPeriod No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Transfer-From Code"; Code[20])
        {
            //31-12-2020
            //Caption name changed
            Caption = 'Transfer-To Code';
            DataClassification = ToBeClassified;
        }
        field(6; "Load Status"; Option)
        {
            Caption = 'Load Status';
            DataClassification = ToBeClassified;
            OptionMembers = "Load Not Loaded","Load Loaded By Salesman";
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Ready To Sync",Synced,"Error";
        }
        field(8; "Error Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Added on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        /* field(10; "Item No."; Code[20])
         {
             DataClassification = ToBeClassified;
         }
         field(11; "Quantity To Ship"; Decimal)
         {
             DataClassification = ToBeClassified;
             //31-12-2020
             //Caption name changed
             Caption = 'Quantity To Receive';
         }*/
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
        Lines: Record "Transfer Receipt Line Staging";
    begin
        Clear(Lines);
        Lines.SetRange("Transfer Receipt Hdr Entry No.", Rec."Entry No.");
        if Lines.FindSet() then
            Lines.DeleteAll(true);
    end;
}
