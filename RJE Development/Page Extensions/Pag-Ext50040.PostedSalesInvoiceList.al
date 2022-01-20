pageextension 50040 PostedSalesInvoiceList extends "Posted Sales Invoices"
{
    PromotedActionCategories = 'New,Process,Report,Invoice,Navigate,Correct,Print/Send';
    layout
    {
        addafter("Document Date")
        {
            //-------------FOC Implementation---------------------//
            field("FOC Item Exists"; Rec."FOC Item Exists")
            {
                ApplicationArea = All;
            }
        }
    }

    //-------------FOC Implementation---------------------//
    actions
    {
        addafter(Print)
        {
            action("Print FOC Invoice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    FOCReport: Report "Sales Tax Invoice FOC";
                    RecSalesinvHdr: Record "Sales Invoice Header";
                begin
                    Rec.CalcFields("FOC Item Exists");
                    Rec.TestField("FOC Item Exists", true);
                    Clear(RecSalesinvHdr);
                    RecSalesinvHdr.SetRange("No.", Rec."No.");
                    if RecSalesinvHdr.FindFirst() then begin
                        Clear(FOCReport);
                        FOCReport.SetTableView(RecSalesinvHdr);
                        FOCReport.Run();
                    end
                end;
            }
            //TT-RS-20210511-
            action("Print Discount Invoice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    DiscountInvoic: Report "Sales Tax  Discount Invoice";
                    RecSalesinvHdr: Record "Sales Invoice Header";
                begin
                    Clear(RecSalesinvHdr);
                    RecSalesinvHdr.SetRange("No.", Rec."No.");
                    if RecSalesinvHdr.FindFirst() then begin
                        Clear(DiscountInvoic);
                        DiscountInvoic.SetTableView(RecSalesinvHdr);
                        DiscountInvoic.Run();
                    end
                end;
            }
            //TT-RS-20210511- 
        }
    }
}
