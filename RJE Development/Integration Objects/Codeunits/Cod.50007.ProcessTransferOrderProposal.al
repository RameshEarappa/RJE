codeunit 50007 "Process Transfer Order"
{
    TableNo = "Transfer Order Proposal Header";

    trigger OnRun()
    var
        RecTransferHeader: Record "Transfer Header";
        IntegrationSetup: Record "Integration Setup";
        RecTransferLine: Record "Transfer Line";
        RectransferOrderProposalLine: Record "Transfer Order Porposal Line";
        RecLocation: Record Location;
        LineNo: Integer;
    begin
        //Mandatory Fields check
        Rec.TestField("No.");
        Rec.TestField("Transfer-To Code");
        //Creating Transfer Order
        Clear(RecTransferHeader);
        IntegrationSetup.GET;
        IntegrationSetup.TestField("In-Transit Code");
        RecTransferHeader.Init();
        RecTransferHeader.SetHideValidationDialog(true);
        if Rec."Transfer Order No." <> '' then
            RecTransferHeader.Validate("No.", Rec."Transfer Order No.")
        else
            RecTransferHeader.Validate("No.", Rec."No.");
        if Rec."Transfer-From Code" <> '' then
            RecTransferHeader.Validate("Transfer-from Code", Rec."Transfer-From Code")
        else begin
            Clear(RecLocation);
            RecLocation.Get(Rec."Transfer-To Code");
            RecTransferHeader.Validate("Transfer-from Code", RecLocation."Default Replenishment Whse.");
        end;
        RecTransferHeader.Validate("Transfer-to Code", Rec."Transfer-To Code");
        RecTransferHeader.Validate("In-Transit Code", IntegrationSetup."In-Transit Code");
        RecTransferHeader.Validate("Posting Date", Rec."Posting Date");
        RecTransferHeader.Validate("Workflow Status", RecTransferHeader."Workflow Status"::Open);
        RecTransferHeader."Created By API" := true;
        RecTransferHeader."Staging Entry No." := Rec."Entry No.";
        RecTransferHeader.Validate("Request Date", Rec."Request Date");
        RecTransferHeader.Validate("Salesperson Code", Rec."Salesperson Code");
        RecTransferHeader.Validate("Transfer-From Salesperson Code", Rec."Transfer-From Salesperson Code");
        RecTransferHeader.Validate("Transfer-From Salesperson Name", Rec."Transfer-From Salesperson Name");
        RecTransferHeader.Validate("Mirnah Reference No.", Rec."No.");
        RecTransferHeader.Insert(true);

        //Inserting Lines
        Clear(LineNo);
        Clear(RecTransferLine);
        RecTransferLine.SetCurrentKey("Document No.", "Line No.");
        if Rec."Transfer Order No." <> '' then
            RecTransferLine.SetRange("Document No.", Rec."Transfer Order No.")
        else
            RecTransferLine.SetRange("Document No.", Rec."No.");
        If RecTransferLine.FindLast() then
            LineNo := RecTransferLine."Line No."
        else
            LineNo := 0;
        Clear(RectransferOrderProposalLine);
        RectransferOrderProposalLine.SetRange("Transfer Order Entry No.", Rec."Entry No.");
        if RectransferOrderProposalLine.FindSet() then begin
            repeat
                LineNo += 10000;
                Clear(RecTransferLine);
                RecTransferLine.Init();
                if Rec."Transfer Order No." <> '' then
                    RecTransferLine.Validate("Document No.", Rec."Transfer Order No.")
                else
                    RecTransferLine.Validate("Document No.", Rec."No.");
                RecTransferLine.Validate("Line No.", LineNo);
                RecTransferLine.Validate("Item No.", RectransferOrderProposalLine."Item No.");
                //Unit of measure should come from Items Automatically
                RecTransferLine.Validate(Quantity, RectransferOrderProposalLine.Quantity);
                RecTransferLine.Validate("Shipment Date", Rec."Request Date");
                RecTransferLine.Validate("Receipt Date", Rec."Request Date");
                RecTransferLine.Validate("Mirnah Reference No.", Rec."No.");
                RecTransferLine.Insert(true);
            until RectransferOrderProposalLine.Next() = 0;
        end;
        RecTransferHeader.Validate("Shipment Date", Rec."Request Date");
        RecTransferHeader.Validate("Receipt Date", Rec."Request Date");
        RecTransferHeader.Modify();
    end;

    var
        myInt: Integer;
}