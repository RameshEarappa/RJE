codeunit 50009 "Process Transfer Receipt Conf."
{
    TableNo = "Transfer Receipt Confirmation";

    trigger OnRun()
    var
        RecTransferLine: Record "Transfer Line";
        RecTransferHeader: Record "Transfer Header";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        RecTransferRcptline: Record "Transfer Receipt Line Staging";
    begin
        //Mandatory Fields check
        Rec.TestField("Load No.");
        Rec.TestField("Transfer-From Code");
        Clear(RecTransferHeader);
        RecTransferHeader.SetRange("Mirnah Reference No.", Rec."Load No.");
        if Not RecTransferHeader.FindFirst() then begin
            Clear(RecTransferHeader);
            RecTransferHeader.Get(Rec."Load No.");
        end;

        Clear(RecTransferRcptline);
        RecTransferRcptline.SetRange("Transfer Receipt Hdr Entry No.", Rec."Entry No.");
        if RecTransferRcptline.FindSet() then begin
            repeat
                Clear(RecTransferLine);
                RecTransferLine.SetCurrentKey("Document No.", "Line No.");
                RecTransferLine.SetRange("Document No.", RecTransferHeader."No.");
                RecTransferLine.SetRange("Item No.", RecTransferRcptline."Item No.");
                RecTransferLine.SetRange("Derived From Line No.", 0);
                RecTransferLine.FindSet();
                repeat
                    RecTransferLine.TestField("Qty. to Receive", RecTransferRcptline.Quantity);
                Until RecTransferLine.Next() = 0;
            until RecTransferRcptline.Next() = 0;
        end;
        RecTransferHeader.Validate(Confirmed, true);
        RecTransferHeader.Modify(true);

        //Posting Transfer receipt
        Commit();
        TransferPostReceipt.SetHideValidationDialog(true);
        TransferPostReceipt.Run(RecTransferHeader);
    end;

    var
        myInt: Integer;
}