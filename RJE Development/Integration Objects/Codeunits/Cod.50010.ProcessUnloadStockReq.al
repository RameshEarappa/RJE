codeunit 50012 "Process Unload Stock Req"
{
    TableNo = "Transfer Order Unload Header";

    trigger OnRun()
    var
        CalcInventory: Report "Calculate Inventory EOD";
        IntegrationSetup: Record "Integration Setup";
        RecItemJnl: Record "Item Journal Line";
        RecItem: Record Item;
    begin
        //Mandatory Fields check
        Rec.TestField("No.");
        Rec.TestField("Posting Date");
        Rec.TestField("Transfer-From Code");
        IntegrationSetup.Get();
        IntegrationSetup.TestField("Item Journal Template");
        IntegrationSetup.TestField("Item Journal Batch");
        Clear(RecItemJnl);
        RecItemJnl.SetRange("Journal Template Name", IntegrationSetup."Item Journal Template");
        RecItemJnl.SetRange("Journal Batch Name", IntegrationSetup."Item Journal Batch");
        if RecItemJnl.FindSet() then;
        Clear(RecItem);
        RecItem.SetFilter("Location Filter", '=%1', Rec."Transfer-From Code");
        if RecItem.FindSet() then;
        Clear(CalcInventory);
        CalcInventory.SetHideValidationDialog(true);
        CalcInventory.SetUnloadStockFilters(Rec."Entry No.");
        CalcInventory.SetItemJnlLine(RecItemJnl);
        CalcInventory.InitializeRequest(Rec."Posting Date", Rec."No.", false, false);
        CalcInventory.SetTableView(RecItem);
        CalcInventory.UseRequestPage(false);
        CalcInventory.Run();
    end;

    var
        RunEventSubscrber: Boolean;
        abc:Record "Sales Header";
}