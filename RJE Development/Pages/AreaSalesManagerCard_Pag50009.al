page 50009 "Area Sales Manager Card"
{

    Caption = 'Area Sales Manager Card';
    PageType = Card;
    SourceTable = "Area Sales Manager";
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
            action("Supervisors")
            {
                ApplicationArea = All;
                Image = Hierarchy;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                RunObject = page "Supervisor Lists";
                RunPageLink = "Country Sales Manager" = field("Country Sales Manager"), "Regional Sales Managerr" = field("Regional Sales Managerr"), "Area Sales Manager" = field(Code);
            }
        }
    }

    trigger OnNewRecord(BelowxRecord: Boolean)
    var
        NoSeries: Codeunit NoSeriesManagement;
        RecGLSetup: Record "General Ledger Setup";
    begin
        RecGLSetup.Get();
        RecGLSetup.TestField("Area Sales Mng. No. Series");
        If Rec.Code = '' then begin
            Rec.Code := NoSeries.GetNextNo(RecGLSetup."Area Sales Mng. No. Series", WorkDate(), true);
            Rec."Country Sales Manager" := xRec."Country Sales Manager";
            Rec."Regional Sales Managerr" := xRec."Regional Sales Managerr";
        end


    end;
}