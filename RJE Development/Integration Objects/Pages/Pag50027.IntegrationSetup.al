page 50027 "Integration Setup"
{

    Caption = 'Integration Setup';
    PageType = Card;
    SourceTable = "Integration Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer Master URL"; Rec."Customer Master URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Item Master URL"; Rec."Item Master URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Salesman Master URL"; Rec."Salesman Master URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Warehouse Master URL"; Rec."Warehouse Master URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Load Master URL"; Rec."Load Master URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Sales Price URL"; Rec."Sales Price URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Open Invoices URL"; Rec."Open Invoices URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Warehosue Stock URL"; Rec."Warehosue Stock URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Access Key"; Rec."Access Key")
                {
                    ApplicationArea = All;
                }
                field("Soap Envelop"; SoapEnvelop)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.SetSoapEnvelopData(SoapEnvelop);
                    end;
                }
            }
            group("Sales Order Configuration")
            {
                field("Customer Prefix Required"; Rec."Customer Prefix Required")
                {
                    ApplicationArea = All;
                }
                field("Customer Prefix"; Rec."Customer Prefix")
                {
                    ApplicationArea = All;
                }
            }
            group("Export Item Setup")
            {
                field("Item VAT%"; Rec."Item VAT%")
                {
                    ApplicationArea = All;
                }
            }
            group("Transfer Order Configuration")
            {
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = All;
                }
            }
            group("Cash Receipt Journal Configuration")
            {
                field("Cash Receipt Jnl Template"; Rec."Cash Receipt Jnl Template")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt Jnl. Batch"; Rec."Cash Receipt Jnl. Batch")
                {
                    ApplicationArea = All;
                }
            }
            group("Unload Stock Configuration")
            {
                field("Item Journal Template"; Rec."Item Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                    ApplicationArea = All;
                }
            }
            group("Automated Functionalities")
            {
                field("Send Transfer Order To SFA"; Rec."Send Transfer Order To SFA")
                {
                    ApplicationArea = All;
                }
            }
            group("FOC Item Invoice Posting Configuration")
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Nominal Cost % For VAT Calc."; Rec."Nominal Cost % For VAT Calc.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account For FOC Jorunal"; Rec."G/L Account For FOC Jorunal")
                {
                    ApplicationArea = All;
                }
            }
            group("Open Invoice Filters")
            {
                field("Open Inv. Cust. Balance Filter"; Rec."Open Inv. Cust. Balance Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Open Invoice Customer Balance Filter';
                    ToolTip = 'Open Invoice Customer Balance Filter';
                }
                field("Dummy Invoice Balance Filter"; Rec."Dummy Invoice Balance Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Dummy Invoice Customer Balance Filter';
                    ToolTip = 'Dummy Invoice Customer Balance Filter';
                }
                field("Open Inv. Cust. Ledger Filter"; Rec."Open Inv. Cust. Ledger Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Open Invoice Customer Ledger Remaining Amount Filter';
                    ToolTip = 'Open Invoice Customer Ledger Remaining Amount Filter';
                }
            }
            group("Device Sales Line Discount Configuration")
            {
                field("Journal Templ. Name For Sales"; Rec."Journal Templ. Name For Sales")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name For Sales"; Rec."Journal Batch Name For Sales")
                {
                    ApplicationArea = All;
                }
                field("Cr. VAT Output % "; Rec."Cr. VAT Output % ")
                {
                    ApplicationArea = All;
                }
            }
            group("RJE Automation Count Setup")
            {
                field("Transfer Receipt Confirmation"; Rec."Transfer Receipt Confirmation")
                {
                    ApplicationArea = All;
                }
                field("Sales invoice Staging Count"; Rec."Sales invoice Staging Count")
                {
                    ApplicationArea = All;
                }
            }
            //RJE Job Automation-10FEB2022
            group("RJE Job Automation Setup")
            {
                field("Execute Auto GRN After (Hrs)"; Rec."Execute Auto GRN After (Hrs)")
                {
                    ApplicationArea = All;
                }
                field("Execute TO Staging After (Hrs)"; Rec."Execute TO Staging After (Hrs)")
                {
                    ApplicationArea = All;
                    Caption = 'Execute Trans. Order Staging After (Hrs)';
                }
                field("Process Sales Order Staging"; Rec."Process Sales Order Staging")
                {
                    ToolTip = 'Specifies the value of the Process Sales Order Staging field.';
                    ApplicationArea = All;
                }
                field("Process Trans. Rec. Conf."; Rec."Process Trans. Rec. Conf.")
                {
                    ToolTip = 'Specifies the value of the Transfer Receipt Confirmation field.';
                    Caption = 'Process Transfer Receipt Confirmation';
                    ApplicationArea = All;
                }
                field("Process Sales Invoice Staging"; Rec."Process Sales Invoice Staging")
                {
                    ToolTip = 'Specifies the value of the Process Sales Invoice Staging field.';
                    ApplicationArea = All;
                }
                field("Process Cash Receipt Journal"; Rec."Process Cash Receipt Journal")
                {
                    ToolTip = 'Specifies the value of the Process Cash Receipt Journal field.';
                    ApplicationArea = All;
                }
                field("Process TO Unload Stock"; Rec."Process TO Unload Stock")
                {
                    ToolTip = 'Specifies the value of the Process TO Unload Stock field.';
                    ApplicationArea = All;
                }
                field("Process Day End Journal"; Rec."Process Day End Journal")
                {
                    ToolTip = 'Specifies the value of the Process Day End Journal field.';
                    ApplicationArea = All;
                }
                field("Process Whs Receipt Staging"; Rec."Process Whs Receipt Staging")
                {
                    ToolTip = 'Specifies the value of the Process Warehouse Receipt Staging field.';
                    Caption = 'Process Warehouse Receipt Staging';
                    ApplicationArea = All;
                }
                field("Process Transfer Order Staging"; Rec."Process Transfer Order Staging")
                {
                    ToolTip = 'Specifies the value of the Process Transfer Order Staging field.';
                    ApplicationArea = All;
                }
                field("Process Warehouse Pick Staging"; Rec."Process Warehouse Pick Staging")
                {
                    ToolTip = 'Specifies the value of the Process Warehouse Pick Staging field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SoapEnvelop := Rec.GetSoapEnvelop();
    end;

    trigger OnOpenPage()
    var
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

    var
        SoapEnvelop: Text;
}
