page 50007 "Delivery Representative Card"
{

    Caption = 'Delivery Representative Card';
    PageType = Card;
    SourceTable = "Delivery Representative";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Country Sales Manager"; Rec."Country Sales Manager")
                {
                    ApplicationArea = All;
                }
                field("Regional Sales Managerr"; Rec."Regional Sales Managerr")
                {
                    ApplicationArea = All;
                }
                field("Area Sales Manager"; Rec."Area Sales Manager")
                {
                    ApplicationArea = All;
                }
                field(Supervisor; Rec.Supervisor)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Name - Arabic"; Rec."Name - Arabic")
                {
                    ApplicationArea = All;
                }
                field("Address 1"; Rec."Address 1")
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRecord: Boolean)
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Delivery Rep. No. Series");
        If Rec.Code = '' then begin
            Rec.Code := NoSeries.GetNextNo(RecGLSetup."Delivery Rep. No. Series", WorkDate(), true);
            Rec."Country Sales Manager" := xRec."Country Sales Manager";
            Rec."Regional Sales Managerr" := xRec."Regional Sales Managerr";
            Rec."Area Sales Manager" := xRec."Area Sales Manager";
            Rec.Supervisor := xRec.Supervisor;
        end
    end;
}
