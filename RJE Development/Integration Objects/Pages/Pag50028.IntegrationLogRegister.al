page 50028 "Integration Log Register"
{

    ApplicationArea = All;
    Caption = 'Integration Log Register';
    PageType = List;
    SourceTable = "Integration Log Register";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    CardPageId = "Integration Log Card";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Integration Type"; Rec."Integration Type")
                {
                    ApplicationArea = All;
                }
                field("Integration Function"; Rec."Integration Function")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = All;
                    Style = Attention;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                }
                field("Request Data"; Rec."Request Data")
                {
                    ApplicationArea = All;
                }
                field("Response Data"; Rec."Response Data")
                {
                    ApplicationArea = All;
                }
                field("Request Time"; Rec."Request Time")
                {
                    ApplicationArea = All;
                }
                field("Response Time"; Rec."Response Time")
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

        }
    }
}
