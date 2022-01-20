page 50001 "Country Sales Manager card"
{

    Caption = 'Country Sales Manager card';
    PageType = Card;
    SourceTable = "Country Sales Manager";

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
            action("Regional Sales Managers")
            {
                ApplicationArea = All;
                Image = Hierarchy;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                RunObject = page "Regional Sales Manager List";
                RunPageLink = "Country Sales Manager" = field(Code);
            }
        }
    }

    trigger OnNewRecord(BelowxRecord: Boolean)
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Country Sales Mng. No. Series");
        If Rec.Code = '' then begin
            Rec.Code := NoSeries.GetNextNo(RecGLSetup."Country Sales Mng. No. Series", WorkDate(), true);
        end
    end;
}
