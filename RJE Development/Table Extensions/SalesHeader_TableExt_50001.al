tableextension 50001 SalesHeader extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Sales Channel Type"; Code[20])
        {
            //Enum "Customer Sales Channel Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(false));

            trigger OnValidate()
            begin
                RecGLSetup.Get();
                RecGLSetup.TestField("Shortcut Dimension 3 Code");
                ValidateShortcutDimCodeLT(RecGLSetup."Shortcut Dimension 3 Code", "Sales Channel Type");
            end;
        }
        field(50001; "Sales Order Type"; Code[20])
        {
            //Enum "Customer Sales Order Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(15), Blocked = CONST(false));

            trigger OnValidate()
            begin
                RecGLSetup.Get();
                RecGLSetup.TestField("Sales Order Type");
                ValidateShortcutDimCodeLT(RecGLSetup."Sales Order Type", "Sales Order Type");
            end;
        }
        field(50002; "Created by API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Order/Invoice Type"; Option)
        {
            Caption = 'Order/Invoice Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sales + FOC","FOC";
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                RecCust: Record Customer;
            begin
                if NOT (Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice]) then exit;

                If (Rec."Sell-to Customer No." <> '') AND (Rec."Sell-to Customer No." <> xRec."Sell-to Customer No.") then begin
                    Clear(RecCust);
                    RecCust.GET(Rec."Sell-to Customer No.");
                    Rec.Validate("Sales Channel Type", RecCust."Sales Channel Type");
                    Rec.Validate("Sales Order Type", RecCust."Sales Order Type");
                end else
                    if Rec."Sell-to Customer No." = '' then begin
                        Rec.Validate("Sales Channel Type", '');
                        Rec.Validate("Sales Order Type", '');
                    end;
            end;
        }
        //-------------FOC Implementation---------------------//
        field(50005; "FOC Item Exists"; Boolean)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "FOC Item" = const(true)));
        }
    }

    procedure ValidateShortcutDimCodeLT(DimensionCode: code[20]; var DimValueCode: Code[20])
    var
        OldDimSetID: Integer;
        LTDimMgt: Codeunit DimensionMgmt_LT;
    begin
        OldDimSetID := "Dimension Set ID";
        LTDimMgt.ValidateShortcutDimValues(DimensionCode, DimValueCode, "Dimension Set ID");
        /*if "No." <> '' then
            Modify;*/

        if OldDimSetID <> "Dimension Set ID" then begin
            // Modify;//24FEB2021
            if SalesLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    var
        RecGLSetup: Record "General Ledger Setup";
        abc: page "Sales Orders";
}