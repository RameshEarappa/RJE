pageextension 50006 "GenLedEntries_PageExt" extends "General Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Check No."; Rec."Check No.")
            {
                ApplicationArea = All;
            }
            field("Check Date"; Rec."Check Date")
            {
                ApplicationArea = All;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
            field("MH Applies-To Doc. Type"; Rec."MH Applies-To Doc. Type")
            {
                ApplicationArea = All;
            }
            field("MH_Applies-To Doc. No."; Rec."MH_Applies-To Doc. No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Ent&ry")
        {
            group(Print)
            {
                action("General Voucher")
                {
                    ApplicationArea = All;
                    Image = Voucher;
                    trigger OnAction()
                    VAR
                        RecGLEntry: Record "G/L Entry";
                        GeneralVoucherReport: Report "General Voucher";
                    begin
                        Clear(RecGLEntry);
                        RecGLEntry.SetRange("Document No.", Rec."Document No.");
                        RecGLEntry.SetRange("Posting Date", Rec."Posting Date");
                        if RecGLEntry.FindSet() then begin
                            GeneralVoucherReport.SetTableView(RecGLEntry);
                            GeneralVoucherReport.Run();
                        end
                    end;
                }
                action("Payment Voucher")
                {
                    ApplicationArea = All;
                    Image = PaymentJournal;
                    trigger OnAction()
                    VAR
                        RecGLEntry: Record "G/L Entry";
                        PaymentVoucherReport: Report "Payment Voucher";
                    begin
                        Clear(RecGLEntry);
                        RecGLEntry.SetRange("Document No.", Rec."Document No.");
                        RecGLEntry.SetRange("Posting Date", Rec."Posting Date");
                        if RecGLEntry.FindSet() then begin
                            PaymentVoucherReport.SetTableView(RecGLEntry);
                            PaymentVoucherReport.Run();
                        end
                    end;
                }
                action("Receipt Voucher")
                {
                    ApplicationArea = All;
                    Image = Voucher;
                    trigger OnAction()
                    VAR
                        RecGLEntry: Record "G/L Entry";
                        ReceiptVoucherReport: Report "Receipt Voucher";
                    begin
                        Clear(RecGLEntry);
                        RecGLEntry.SetRange("Document No.", Rec."Document No.");
                        if RecGLEntry.FindSet() then begin
                            ReceiptVoucherReport.SetTableView(RecGLEntry);
                            ReceiptVoucherReport.Run();
                        end
                    end;
                }
            }
        }
    }
}