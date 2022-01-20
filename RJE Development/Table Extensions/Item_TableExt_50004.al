tableextension 50004 Item extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50000; Dimension; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Pack Dimension"; Text[50])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Not Required as mentioned in Change Document.';
        }
        field(50002; Barcode; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Active For Transfer"; Boolean)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50004; "Open For Sales"; Boolean)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50005; "SKU Obselete Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //Dimensions
        field(50006; Brand; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 6 Code");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Shortcut Dimension 6 Code", Brand);
            end;
        }
        field(50007; "Portfolio"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(19));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField(Portfolio);
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup.Portfolio, Portfolio);
            end;
        }
        field(50008; Category; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(20));
            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField(Category);
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup.Category, Category);
            end;
        }
        field(50009; "Product Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(21));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Product Type");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Product Type", "Product Type");
            end;
        }
        field(50010; Size; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(22));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField(Size);
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup.Size, Size);
            end;
        }
        field(50012; "Pack Size"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(23));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Pack Size");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Pack Size", "Pack Size");
            end;
        }
        field(50013; "Consumer profile"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(24));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Consumer Profile");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Consumer Profile", "Consumer profile");
            end;
        }
        field(50014; "Sales Pricing Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(25));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Sales Pricing Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Sales Pricing Group", "Sales Pricing Group");
            end;
        }
        field(50015; "Flavor Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(26));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Flavor Type");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Flavor Type", "Flavor Type");
            end;
        }
        field(50016; "Nicotine Mg"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(27));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Nicotine Mg");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Nicotine Mg", "Nicotine Mg");
            end;
        }
        field(50017; "Nicotine Color"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(28));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Nicotine Color");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Nicotine Color", "Nicotine Color");
            end;

        }
        field(50018; Special; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(29));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField(Special);
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup.Special, Special);
            end;
        }
        field(50019; "SOA Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(30));
            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("SOA Group");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."SOA Group", "SOA Group");
            end;
        }
        field(50020; "Brand Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(31));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Brand Type");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Brand Type", "Brand Type");
            end;
        }
        field(50021; "Product Reporting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 7 Code");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Shortcut Dimension 7 Code", "Product Reporting Group");
            end;
        }
        field(50022; "SKU Reporting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                RecGLSetup.GET;
                RecGLSetup.TestField("Shortcut Dimension 8 Code");
                DimMgmt_LT.ValidateCustomShortcutDimCode(Database::Item, "No.", RecGLSetup."Shortcut Dimension 8 Code", "SKU Reporting Group");
            end;
        }
        //Modified on 11NOV2020
        field(50023; "Active"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Open For Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Feedback shared by Askin';
        }
        field(50025; "Description-Arabic"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Master Barcode"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "FOC Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "FOC Nominal Cost For VAT calc."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            Caption = 'FOC/Disc Nominal Cost For VAT calc.';
        }
        field(50029; "HS Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210511-
        field(50030; Discount; Boolean)
        {
            Caption = 'Discount';
            DataClassification = ToBeClassified;
        }
        //TT-RS-20210511+
    }






    var
        DimMgmt_LT: Codeunit DimensionMgmt_LT;
        RecGLSetup: Record "General Ledger Setup";
}