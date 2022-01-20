codeunit 50002 Integration
{
    
    //SFA to BC
    trigger OnRun()
    begin

    end;

    procedure InsertSalesInvoices(RequestData: XmlPort "Import Sales Invoice"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;

    /* ---------------Not in use--------------
     local procedure UpdateTransferOrderShipment(RequestData: xmlport "Import Transfer Order Shipment"): Text
     begin
         ClearLastError();
         if RequestData.Import() then
             exit('Success')
         else
             exit(GetLastErrorText);
     end;*/

    procedure TransferOrderUnloadStockRequest(RequestData: XmlPort "Import Transfer Order Unload"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;

    procedure TransferReceiptConfirmation(RequestData: XmlPort "Transfer Receipt Confrimation"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;

    procedure InsertTransferOrderProposals(RequestData: XmlPort "Import Transfer Order Proposal"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;

    procedure InsertSalesOrders(Requestdata: XmlPort "Import Sales Order"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;

    procedure InsertCollections(RequestData: XmlPort "Import Cash Receipt Journal"): Text
    begin
        ClearLastError();
        if RequestData.Import() then
            exit('Success')
        else
            exit(GetLastErrorText);
    end;


    var
        Utility: Codeunit "Integration Utility";
}