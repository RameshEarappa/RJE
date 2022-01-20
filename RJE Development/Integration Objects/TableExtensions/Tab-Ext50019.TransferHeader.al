tableextension 50019 "Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Created By API"; Boolean)
        {
            Caption = 'Created By API';
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
        field(50003; "Workflow Status"; Option)
        {
            OptionMembers = Open,"Pending Approval","Approved";
        }
        field(50004; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-To Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                RecSalesperson: Record "Salesperson/Purchaser";
            begin
                if RecSalesperson.GET("Salesperson Code") then
                    "Salesperson Name" := RecSalesperson.Name
                else
                    "Salesperson Name" := '';
            end;
        }
        field(50006; "Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-To Salesperson Name';
            Editable = false;
        }
        modify("Transfer-to Code")
        {
            trigger OnAfterValidate()
            var
                IntegrationSetup: Record "Integration Setup";
            BEGIN
                IntegrationSetup.GET;
                IntegrationSetup.TestField("In-Transit Code");
                Rec.Validate("In-Transit Code", IntegrationSetup."In-Transit Code");
            END;
        }
        field(50007; "VAN Unloading TO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Transfer-From Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                RecSalesperson: Record "Salesperson/Purchaser";
            begin
                if RecSalesperson.GET("Transfer-From Salesperson Code") then
                    "Transfer-From Salesperson Name" := RecSalesperson.Name
                else
                    "Transfer-From Salesperson Name" := '';
            end;
        }
        field(50009; "Transfer-From Salesperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-From Salesperson Name';
            Editable = false;
        }
        field(50010; "Mirnah Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
