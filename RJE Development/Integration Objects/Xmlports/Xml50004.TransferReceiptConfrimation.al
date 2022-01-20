xmlport 50004 "Transfer Receipt Confrimation"
{
    Direction = Import;
    UseDefaultNamespace = true;
    schema
    {
        textelement(Root)
        {
            tableelement(TransferReceiptConfirmation; "Transfer Receipt Confirmation")
            {
                fieldelement(LoadNo; TransferReceiptConfirmation."Load No.")
                {
                }
                fieldelement(PostingDate; TransferReceiptConfirmation."Posting Date")
                {
                }
                fieldelement(TransferFromCode; TransferReceiptConfirmation."Transfer-From Code")
                {
                }
                fieldelement(LoadPeriodNo; TransferReceiptConfirmation."LoadPeriod No.")
                {
                }
                fieldelement(LoadStatus; TransferReceiptConfirmation."Load Status")
                {
                    //0 = Load not Loaded -- 1 = Load loaded by Salesman
                }
                tableelement(Lines; "Transfer Receipt Line Staging")
                {
                    LinkTable = TransferReceiptConfirmation;
                    LinkFields = "Transfer Receipt Hdr Entry No." = field("Entry No.");

                    fieldelement(ItemNo; Lines."Item No.")
                    {
                    }
                    fieldelement(Quantity; Lines.Quantity)
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    var
                        RecLines: Record "Transfer Receipt Line Staging";
                    begin
                        Clear(RecLines);
                        RecLines.SetCurrentKey("Transfer Receipt Hdr Entry No.", "Line No.");
                        RecLines.SetRange("Transfer Receipt Hdr Entry No.", TransferReceiptConfirmation."Entry No.");
                        if RecLines.FindLast() then
                            Lines."Line No." := RecLines."Line No." + 10000
                        else
                            Lines."Line No." := 10000;
                        Lines."Transfer Receipt Header No." := TransferReceiptConfirmation."Load No.";
                        Lines."Transfer Receipt Hdr Entry No." := TransferReceiptConfirmation."Entry No.";
                    end;
                }
                trigger OnBeforeInsertRecord()
                var
                    RecTransReceiptHdr: Record "Transfer Receipt Confirmation";
                begin
                    Clear(RecTransReceiptHdr);
                    RecTransReceiptHdr.SetCurrentKey("Entry No.");
                    if RecTransReceiptHdr.FindLast() then
                        TransferReceiptConfirmation."Entry No." := RecTransReceiptHdr."Entry No." + 1
                    else
                        TransferReceiptConfirmation."Entry No." := 1;
                    TransferReceiptConfirmation.Status := TransferReceiptConfirmation.Status::"Ready To Sync";
                    TransferReceiptConfirmation."Added on" := CurrentDateTime;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
