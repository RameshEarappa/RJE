page 50003 "Regional Sales Manager Card"
{

    Caption = 'Regional Sales Manager Card';
    PageType = Card;
    SourceTable = "Regional Sales Manager";

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
    actions
    {
        area(Processing)
        {
            action("Area Sales Managers")
            {
                ApplicationArea = All;
                Image = Hierarchy;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                RunObject = page "Area Sales Manager List";
                RunPageLink = "Country Sales Manager" = field("Country Sales Manager"), "Regional Sales Managerr" = field(Code);
            }
        }
    }

    trigger OnNewRecord(BelowxRecord: Boolean)
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Regional Sales Mng. No. Series");
        If Rec.Code = '' then begin
            Rec.Code := NoSeries.GetNextNo(RecGLSetup."Regional Sales Mng. No. Series", WorkDate(), true);
            Rec."Country Sales Manager" := xRec."Country Sales Manager";
        end
    end;
}
