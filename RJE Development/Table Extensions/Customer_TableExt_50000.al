tableextension 50000 Customer extends Customer
{
    fields
    {
        field(50000; "Size/Area"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'To capture the Customer Store Size/Area';
        }
        field(50001; "Customer Type"; code[20])
        {
            //Enum "Customer Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Customer Type");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Customer Type", "Customer Type");
            end;
        }
        field(50002; "SOA Group"; Enum "Customer SOA Group")
        {
            DataClassification = ToBeClassified;
            //doubt in SOA Group Items-enum values can be edited
        }
        field(50003; "Price List Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Price Group";
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50004; "Key Account"; code[20])
        {
            Caption = 'KA Chain Code';
            //Enum "Customer Key Account")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 5 Code");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Shortcut Dimension 5 Code", "Key Account");
            end;
        }
        field(50005; "Sales Channel Type"; code[20])
        {
            //Enum "Customer Sales Channel Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 3 Code");//
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Shortcut Dimension 3 Code", "Sales Channel Type");
            end;
        }
        field(50006; "Sales Order Type"; code[20])
        {
            //Enum "Customer Sales Order Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(15));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sales Order Type");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Sales Order Type", "Sales Order Type");
            end;
        }
        field(50007; "Geo-code Longitude"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Outlet Barcode"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Creation Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Customer Group"; code[20])
        {//Enum "Customer Group")
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            /*TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(10));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Customer Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Customer Group", "Customer Group");
            end;*/
        }
        field(50011; "Sales Potential"; code[20])
        {
            //Enum "Customer Sales Potential")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(13));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sales Potential");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Sales Potential", "Sales Potential");
            end;
        }
        field(50012; "Drop Size"; Integer)//Text[100])// code[20])
        {//Decimal)
            DataClassification = ToBeClassified;
            /*TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(14));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Drop Size");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Drop Size", "Drop Size");
            end;*/
        }
        field(50013; "Status"; code[20])
        {
            Description = 'Customer Working Status';
            //Enum "Customer Status")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(16));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Status");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup.Status, "Status");
            end;
        }
        field(50014; "Credit Condition"; Text[100])
        {
            Caption = 'Max QTY of Open Invoices';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50015; "Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        /*field(50016; "Payment Terms"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
            Description = 'Credit limit zero, but payment term >0 means Bill To Bill If the current risk is 0-zero, then issue an invoice with max limit defined for Customer';
        }*/
        field(50017; "Credit Rating"; Enum "Customer Credit Rating")
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Maximum SO Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Maximum SO Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Current Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Customer balance as on replication date';
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50021; "Risk"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Amount Due from Customer (Open invoices + Due Dated checks)';
        }
        field(50022; "Due Dated Cheque"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Due dated check balance';
        }
        field(50023; "DSO/DPO"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Amount of Day sales Outstanding, Days payment Outstanding and generation Date';
        }
        field(50024; "Promotion Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Special Promotion group, can be updated to apply specific promotions';
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        //Modified on 11NOV2020
        field(50025; "Sales Representative Code"; code[20])//Enum "Customer Sales Representative Code")
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
            /* trigger OnValidate()
             var
                 RecSP: Record "Salesperson/Purchaser";
             begin
                 if RecSP.get("Sales Representative Code") then begin
                     "Salesperson Name" := RecSP.Name;
                     Validate("Salesperson Code", RecSP.Code);
                 end else begin
                     "Salesperson Name" := '';
                     "Sales Representative Code" := '';
                     Validate("Salesperson Code", '');
                 end;
             end;*/
        }
        modify("Salesperson Code")
        {
            trigger OnAfterValidate()
            var
                RecSP: Record "Salesperson/Purchaser";
            begin
                if RecSP.get("Salesperson Code") then begin
                    "Sales Representative Name" := RecSP.Name;
                    //"Sales Representative Code" := RecSP.Code;
                end else begin
                    "Sales Representative Name" := '';
                    // "Sales Representative Code" := '';
                end;
            end;
        }
        field(50026; "Shipment Delivery Time"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Description = 'In days. Will be used for calculating sales cutoff date, if system will see that shipment will not be delivered within the same period, it will prevent to ship items';
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50027; "Sub-Branch"; Code[20])
        {
            Caption = 'Region';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(17));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sub-Branch");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Sub-Branch", "Sub-Branch");
            end;
        }
        field(50028; "Geographic Cell"; Text[100])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50029; "Open for Sales"; Boolean)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50030; "Returns Accepted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "ISF Available"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "ISF Free Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Default Warehouse"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50034; "Default Delivery Type"; Enum "Customer Default Delivery Type")
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50035; "Trans. Summary Customer Code"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50036; "Visit/Call frequency Per month"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Description = 'Visit/Call Frequency Per Month/Week';
        }
        field(50037; "Best days to visit/call"; Enum "Recurrence - Day of Week")
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Best time to visit/call"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "RCS Code"; Text[100])
        {
            Caption = 'RCS Code For Cust. P&L';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Validate("Global Dimension 2 Code", "RCS Code");
                /* RecGLSetup.GET;
                 RecGLSetup.TestField("RCS Code For Cust. P&L");
                 DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."RCS Code For Cust. P&L", "RCS Code");
                */
            end;
        }
        field(50040; "Name-Arabic"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Address 1 - Arabic"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Address 2 - Arabic"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //Added on 11NOV2020
        field(50043; "Consumer Group"; Code[20])//
        {
            Caption = 'Consumer Profile Group';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(34));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Consumer Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Consumer Group", "Consumer Group");
            end;
        }
        field(50044; "Sales Price Group"; Code[20])//
        {
            Caption = 'Sales Price Position Group';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(35));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sales Price Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Sales Price Group", "Sales Price Group");
            end;
        }
        field(50045; "Branch"; Code[20])//
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 4 Code");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Shortcut Dimension 4 Code", Branch);
            end;
        }
        field(50046; "Territory"; Code[20])//
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(38));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField(Territory);
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup.Territory, Territory);
            end;
        }
        field(50047; "Sales Representative Name"; Text[50])
        {
            Caption = 'Salesperson Name';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                RecSP: Record "Salesperson/Purchaser";
            begin
                if RecSP.get("Sales Representative Name") then begin
                    "Sales Representative Name" := RecSP.Name;
                    // "Sales Representative Code" := RecSP.Code;
                    Validate("Salesperson Code", RecSP.Code);
                end else begin
                    "Sales Representative Name" := '';
                    //"Sales Representative Code" := '';
                    Validate("Salesperson Code", '');
                end;
            end;
        }
        field(50048; "Geo-Code Latitude"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Sales Vol. Ptential Per Month"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Sales Per. Ptential Per Month"; Text[100])
        {
            Caption = 'Sales % Potential Per Month';
            DataClassification = ToBeClassified;
        }
        field(50051; "DSO/DPO Last Update"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Activity Code"; Option)
        {
            Caption = 'Buying Activity Code';
            DataClassification = ToBeClassified;
            OptionMembers = "",Potential,"Active Working",Dormant,Lost;
        }
        field(50053; "Sales Promotion Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(36));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sales Promotion Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Customer, "No.", RecGLSetup."Sales Promotion Group", "Sales Promotion Group");
            end;
        }
        field(50054; "City In Arabic"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        //-----------
        field(50056; "Max QTY of Open Invoices"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Block on Overdue"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


    VAR
        DimMgmt_LT: Codeunit DimensionMgmt_LT;
        RecGLSetup: Record "General Ledger Setup";
}