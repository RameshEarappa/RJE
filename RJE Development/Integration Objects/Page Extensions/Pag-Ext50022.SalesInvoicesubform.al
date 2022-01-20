pageextension 50022 "Sales Invoice subform" extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Free Sample Quantity"; Rec."Free Sample Quantity")
            {
                ApplicationArea = All;
            }
            field("Lot No. Assigned"; Rec."Lot No. Assigned")
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
    //30.07.2021
    actions
    {
        addafter("Related Information")
        {
            action("Assign Lot Numbers")
            {
                ApplicationArea = All;
                Image = Lot;
                Promoted = true;
                PromotedCategory = Process;

                TRIGGER OnAction()
                VAR
                    AssignLotNoToSalesLines: Codeunit AssignLotNoToSalesLines;
                    SalesInvoiceLine: Record "Sales Line";
                BEGIN
                    IF NOT CONFIRM('Do you want to assign Lot No. ?', FALSE) THEN EXIT;
                    clear(SalesInvoiceLine);
                    CurrPage.SetSelectionFilter(SalesInvoiceLine);
                    AssignLotNoToSalesLines.Run(SalesInvoiceLine);
                END;
            }
        }
    }
    //30.07.2021
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
