pageextension 50021 "Sales Order Listpart" extends "Sales Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Free Sample Quantity"; Rec."Free Sample Quantity")
            {
                ApplicationArea = All;
            }
        }
        //30.07.2021
        addafter("Free Sample Quantity")
        {
            field("Price List Applied"; Rec."Price List Applied")
            {
                ApplicationArea = All;
            }
            field("Promotion Code Applied"; Rec."Promotion Code Applied")
            {
                ApplicationArea = All;
            }
        }
        modify("Unit Price")
        {
            Editable = SetEditable;
        }
        //10.08.2021
        modify("Line Discount Amount")
        {
            Editable = SetEditable;
        }
        modify("Line Discount %")
        {
            Editable = SetEditable;
        }
        //10.08.2021
        Modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec.Type = Rec.Type::Item then
                    SetEditable := false
                else
                    SetEditable := true;
            end;
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        if Rec.Type = Rec.Type::Item then
            SetEditable := false
        else
            SetEditable := true;
    end;
    //30.07.2021
    var
        SetEditable: Boolean;
}
