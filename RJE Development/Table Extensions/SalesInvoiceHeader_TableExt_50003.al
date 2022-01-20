tableextension 50003 SalesInvHeader extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Sales Channel Type"; Code[20])
        {
            //Enum "Customer Sales Channel Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(12), Blocked = CONST(false));
        }
        field(50001; "Sales Order Type"; Code[20])
        {
            //Enum "Customer Sales Order Type")
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(15), Blocked = CONST(false));
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
        //-------------FOC Implementation---------------------//
        field(50005; "FOC Item Exists"; Boolean)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Sales Invoice Line" where("Document No." = field("No."), "FOC Item" = const(true)));
        }
    }

    var
        myInt: Integer;
}