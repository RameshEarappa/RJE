page 50032 "Open Invoices log Entries"
{

    ApplicationArea = All;
    Caption = 'Open Invoices log Entries';
    PageType = List;
    SourceTable = "Open Invoices Log Entries";
    UsageCategory = Lists;

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
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Processed DateTime"; Rec."Processed DateTime")
                {
                    ApplicationArea = All;
                }
                field("Processed User"; Rec."Processed User")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
