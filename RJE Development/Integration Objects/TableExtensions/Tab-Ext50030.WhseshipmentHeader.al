tableextension 50030 "Whse shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50000; "Created By API"; Boolean)
        {
            Caption = 'VAN Loading TO';
            DataClassification = ToBeClassified;
        }
        field(50001; "Staging Entry No."; Integer)
        {
            Caption = 'Staging Entry No.';
            DataClassification = ToBeClassified;
        }
        field(50002; "Confirmed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50006; "Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "VAN Unloading TO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Transfer-From Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Code';
        }
        field(50009; "Transfer-From Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Name';
        }
        field(50010; "Mirnah Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
