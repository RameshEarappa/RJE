tableextension 50002 GenLedSetup extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Customer Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Customer Type");
                UpdateDimValueGlobalDimNo(xRec."Customer Type", "Customer Type", 9);
            end;
        }
        field(50001; "Customer Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Consumer Group is already there';
            TableRelation = Dimension;
            /* trigger OnValidate()
             begin
                 ValidateDimension("Customer Group");
                 UpdateDimValueGlobalDimNo(xRec."Customer Group", "Customer Group", 10);
             end;*/
        }
        field(50002; "Key Account Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 5';
            ObsoleteState = Removed;
            /*trigger OnValidate()
            begin
                ValidateDimension("Key Account Code");
                UpdateDimValueGlobalDimNo(xRec."Key Account Code", "Key Account Code", 11);
            end;*/
        }
        field(50003; "Sales Channel"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 3';
            ObsoleteState = Removed;
            /*trigger OnValidate()
            begin
                ValidateDimension("Sales Channel");
                UpdateDimValueGlobalDimNo(xRec."Sales Channel", "Sales Channel", 12);
            end;*/
        }
        field(50004; "Sales Potential"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sales Potential");
                UpdateDimValueGlobalDimNo(xRec."Sales Potential", "Sales Potential", 13);
            end;
        }
        /*field(50005; "Drop Size"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Drop Size");
                UpdateDimValueGlobalDimNo(xRec."Drop Size", "Drop Size", 14);
            end;
        }*/
        field(50006; "Sales Order Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sales Order Type");
                UpdateDimValueGlobalDimNo(xRec."Sales Order Type", "Sales Order Type", 15);
            end;
        }
        field(50007; "Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Status);
                UpdateDimValueGlobalDimNo(xRec.Status, Status, 16);
            end;
        }
        field(50008; "Sub-Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sub-Branch");
                UpdateDimValueGlobalDimNo(xRec."Sub-Branch", "Sub-Branch", 17);
            end;
        }

        //No Series
        field(50009; "Country Sales Mng. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50010; "Regional Sales Mng. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50011; "Area Sales Mng. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50012; "Supervisor No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50013; "Delivery Rep. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        //Item Dimensions
        field(50014; Brand; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 6';
            ObsoleteState = Removed;
            /*trigger OnValidate()
            begin
                ValidateDimension(Brand);
                UpdateDimValueGlobalDimNo(xRec.Brand, Brand, 18);
            end;*/
        }
        field(50015; Portfolio; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Portfolio);
                UpdateDimValueGlobalDimNo(xRec.Portfolio, Portfolio, 19);
            end;
        }
        field(50016; Category; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Category);
                UpdateDimValueGlobalDimNo(xRec.Category, Category, 20);
            end;
        }
        field(50017; "Product Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Product Type");
                UpdateDimValueGlobalDimNo(xRec."Product Type", "Product Type", 21);
            end;
        }
        field(50018; Size; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Size);
                UpdateDimValueGlobalDimNo(xRec.Size, Size, 22);
            end;
        }
        field(50019; "Pack Size"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Pack Size");
                UpdateDimValueGlobalDimNo(xRec."Pack Size", "Pack Size", 23);
            end;
        }
        field(50020; "Consumer Profile"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Consumer Profile");
                UpdateDimValueGlobalDimNo(xRec."Consumer Profile", "Consumer Profile", 24);
            end;
        }
        field(50021; "Sales Pricing Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sales Pricing Group");
                UpdateDimValueGlobalDimNo(xRec."Sales Pricing Group", "Sales Pricing Group", 25);
            end;
        }
        field(50022; "Flavor Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Flavor Type");
                UpdateDimValueGlobalDimNo(xRec."Flavor Type", "Flavor Type", 26);
            end;
        }
        field(50023; "Nicotine Mg"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Nicotine Mg");
                UpdateDimValueGlobalDimNo(xRec."Nicotine Mg", "Nicotine Mg", 27);
            end;
        }
        field(50024; "Nicotine Color"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Nicotine Color");
                UpdateDimValueGlobalDimNo(xRec."Nicotine Color", "Nicotine Color", 28);
            end;
        }
        field(50025; Special; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Special);
                UpdateDimValueGlobalDimNo(xRec.Special, Special, 29);
            end;
        }
        field(50026; "SOA Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("SOA Group");
                UpdateDimValueGlobalDimNo(xRec."SOA Group", "SOA Group", 30);
            end;
        }
        field(50027; "Brand Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Brand Type");
                UpdateDimValueGlobalDimNo(xRec."Brand Type", "Brand Type", 31);
            end;
        }
        field(50028; "Product Reporting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 7';
            ObsoleteState = Removed;
            /*trigger OnValidate()
            begin
                ValidateDimension("Product Reporting Group");
                UpdateDimValueGlobalDimNo(xRec."Product Reporting Group", "Product Reporting Group", 32);
            end;*/
        }
        field(50029; "SKU Reporting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 8';
            ObsoleteState = Removed;
            /*trigger OnValidate()
            begin
                ValidateDimension("SKU Reporting Group");
                UpdateDimValueGlobalDimNo(xRec."SKU Reporting Group", "SKU Reporting Group", 33);
            end;*/
        }
        //Added on 11NOV2020
        field(50030; "Consumer Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Consumer Group");
                UpdateDimValueGlobalDimNo(xRec."Consumer Group", "Consumer Group", 34);
            end;
        }
        field(50031; "Sales Price Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sales Price Group");
                UpdateDimValueGlobalDimNo(xRec."Sales Price Group", "Sales Price Group", 35);
            end;
        }
        field(50032; "Sales Promotion Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension("Sales Promotion Group");
                UpdateDimValueGlobalDimNo(xRec."Sales Promotion Group", "Sales Promotion Group", 36);
            end;
        }
        field(50033; "Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 4';
            ObsoleteState = Removed;
            /* trigger OnValidate()
             begin
                 ValidateDimension(Branch);
                 UpdateDimValueGlobalDimNo(xRec.Branch, Branch, 37);
             end;*/
        }
        field(50034; "Territory"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                ValidateDimension(Territory);
                UpdateDimValueGlobalDimNo(xRec.Territory, Territory, 38);
            end;
        }
        field(50035; "RCS Code For Cust. P&L"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            ObsoleteReason = 'Using shortcut Dimension 2';
            ObsoleteState = Removed;
            trigger OnValidate()
            begin
                //ValidateDimension("RCS Code For Cust. P&L");
                //UpdateDimValueGlobalDimNo(xRec."RCS Code For Cust. P&L", "RCS Code For Cust. P&L", 2);
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 1 Code");
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 2 Code");
            end;
        }
        modify("Shortcut Dimension 3 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 3 Code");
            end;
        }
        modify("Shortcut Dimension 4 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 4 Code");
            end;
        }
        modify("Shortcut Dimension 5 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 5 Code");
            end;
        }
        modify("Shortcut Dimension 6 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 6 Code");
            end;
        }
        modify("Shortcut Dimension 7 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 7 Code");
            end;
        }
        modify("Shortcut Dimension 8 Code")
        {
            trigger OnBeforeValidate()
            begin
                ValidateDimension("Shortcut Dimension 8 Code");
            end;
        }
    }

    local procedure ValidateDimension(DimCode: code[20])
    Var
        RecGLSetup: Record "General Ledger Setup";
        ErrorText: Label 'You cannot use same dimension twice.';
    begin
        if DimCode = '' then exit;
        RecGLSetup.GET();
        case DimCode Of
            RecGLSetup."Global Dimension 1 Code":
                Error(ErrorText);
            RecGLSetup."Global Dimension 2 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 3 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 4 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 5 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 6 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 7 Code":
                Error(ErrorText);
            RecGLSetup."Shortcut Dimension 8 Code":
                Error(ErrorText);
            RecGLSetup."Customer Type":
                Error(ErrorText);
            RecGLSetup."Sales Potential":
                Error(ErrorText);
            RecGLSetup."Sales Order Type":
                Error(ErrorText);
            RecGLSetup.Status:
                Error(ErrorText);
            RecGLSetup."Sub-Branch":
                Error(ErrorText);
            //Modified on 11NOV2020
            RecGLSetup."Portfolio":
                Error(ErrorText);
            RecGLSetup."Category":
                Error(ErrorText);
            RecGLSetup."Product Type":
                Error(ErrorText);
            RecGLSetup.Size:
                Error(ErrorText);

            RecGLSetup."Pack Size":
                Error(ErrorText);

            RecGLSetup."Consumer Profile":
                Error(ErrorText);

            RecGLSetup."Consumer Group":
                Error(ErrorText);

            RecGLSetup."Sales Price Group":
                Error(ErrorText);

            RecGLSetup."Flavor Type":
                Error(ErrorText);

            RecGLSetup."Nicotine Color":
                Error(ErrorText);
            RecGLSetup."Nicotine Mg":
                Error(ErrorText);
            RecGLSetup."SOA Group":
                Error(ErrorText);

            RecGLSetup.Special:
                Error(ErrorText);
            RecGLSetup."Brand Type":
                Error(ErrorText);
            RecGLSetup."Sales Promotion Group":
                Error(ErrorText);
            RecGLSetup.Territory:
                Error(ErrorText);

        end;
    end;

    var
        myInt: Integer;
}