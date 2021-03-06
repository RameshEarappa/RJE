permissionset 50000 RJEDevelopments
{
    Assignable = true;
    Caption = 'RJEDevelopments', MaxLength = 30;
    Permissions =
        table "Sales Invoice Header Staging" = X,
        tabledata "Sales Invoice Header Staging" = RMID,
        table "Sales Inv. Line Staging" = X,
        tabledata "Sales Inv. Line Staging" = RMID,
        table "Transfer Order Shipment Header" = X,
        tabledata "Transfer Order Shipment Header" = RMID,
        table "Transfer Order Shipment Line" = X,
        tabledata "Transfer Order Shipment Line" = RMID,
        table "Transfer Order Proposal Header" = X,
        tabledata "Transfer Order Proposal Header" = RMID,
        table "Transfer Order Porposal Line" = X,
        tabledata "Transfer Order Porposal Line" = RMID,
        table "Transfer Order Unload Header" = X,
        tabledata "Transfer Order Unload Header" = RMID,
        table "Transfer Order Unload Line" = X,
        tabledata "Transfer Order Unload Line" = RMID,
        table "Transfer Receipt Confirmation" = X,
        tabledata "Transfer Receipt Confirmation" = RMID,
        table "Sales Order Header Staging" = X,
        tabledata "Sales Order Header Staging" = RMID,
        table "Sales Order Line Staging" = X,
        tabledata "Sales Order Line Staging" = RMID,
        table "Cash Receipt Journal Staging" = X,
        tabledata "Cash Receipt Journal Staging" = RMID,
        table "Integration Setup" = X,
        tabledata "Integration Setup" = RMID,
        table "Integration Log Register" = X,
        tabledata "Integration Log Register" = RMID,
        table "Transfer Receipt Line Staging" = X,
        tabledata "Transfer Receipt Line Staging" = RMID,
        table "Open Invoices Log Entries" = X,
        tabledata "Open Invoices Log Entries" = RMID,
        table "Area Sales Manager" = X,
        tabledata "Area Sales Manager" = RMID,
        table "Country Sales Manager" = X,
        tabledata "Country Sales Manager" = RMID,
        table "Delivery Representative" = X,
        tabledata "Delivery Representative" = RMID,
        table "Regional Sales Manager" = X,
        tabledata "Regional Sales Manager" = RMID,
        table Supervisor = X,
        tabledata Supervisor = RMID,
        codeunit "Event Subscriber Prod Date" = X,
        codeunit EventSubscriber = X,
        codeunit DimensionMgmt_LT = X,
        codeunit "Process Sales Order" = X,
        codeunit "Process Sales Invoice" = X,
        codeunit "Process Transfer Order" = X,
        codeunit "Process Cash Receipt Jnl" = X,
        codeunit "Process Transfer Receipt Conf." = X,
        codeunit "Process Unload Stock Req" = X,
        codeunit SendWarehouseStocks = X,
        codeunit "Integration Utility" = X,
        codeunit AssignLotNoToSalesLines = X,
        codeunit "Send Notification" = X,
        codeunit SendMasterDataFromBCToSFA = X,
        codeunit SendOpenInvoicesToMirnah = X,
        codeunit ResetStatusOfTransferRcptConf = X,
        codeunit ProcessTransferReceiptConf = X,
        codeunit ProcessSalesOrders = X,
        codeunit ProcessSalesInvoice = X,
        codeunit ProcessCashRcptJnl = X,
        codeunit ProcessUnloadStock = X,
        codeunit Integration = X,
        codeunit "Invoke Service" = X,
        codeunit UpdateFOCBoolean = X,
        codeunit "Reset Sales Invoice Status" = X,
        codeunit "Init Workflow" = X,
        codeunit "Customized Workflow" = X,
        page "Sales Invoices Staging" = X,
        page "Sales Invoice Card Staging" = X,
        page "Sales Inv. Line Staging" = X,
        page "Transfer Orders Shipment" = X,
        page "Transfer Order Shipment Card" = X,
        page "Transfer Order Shipment Lines" = X,
        page "Transfer Orders Proposal" = X,
        page "Transfer Order Proposal Card" = X,
        page "Transfer Order Proposal Lines" = X,
        page "Transfer Orders Unload Stock" = X,
        page "Transfer Order Unload Card" = X,
        page "Transfer Order Unload Lines" = X,
        page "Transfer Receipt Confirmation" = X,
        page "Sales Orders Staging" = X,
        page "Sales Order Lines Part" = X,
        page "Sales Order Staging Card" = X,
        page "Cash Receipt Journal Staging" = X,
        page "Integration Setup" = X,
        page "Integration Log Register" = X,
        page "Integration Log Card" = X,
        page "Transfer Rcpt. Conf.Line Part" = X,
        page "Transfer Receipt Card" = X,
        page "Open Invoices log Entries" = X,
        page "Reservation Entry" = X,
        page "Area Sales Manager Card" = X,
        page "Area Sales Manager List" = X,
        page "Country Sales Manager card" = X,
        page "Country Sales Manager List" = X,
        page "Delivery Representative Card" = X,
        page "Delivery Representative List" = X,
        page "Phys. Inventory Journal EOD" = X,
        page "Regional Sales Manager Card" = X,
        page "Regional Sales Manager List" = X,
        page "Supervisor Card" = X,
        page "Supervisor Lists" = X,
        report SendOpenInvoicesToMirnah = X,
        report "Inventory Inbound Transfer" = X,
        report "RJE Automation Process" = X,
        report SendWarehouseStocks = X,
        report SendMasterDataToSFA = X,
        report "Process Cash Receipt Jnl" = X,
        report "Process Sales Invoice" = X,
        report "Process Sales Orders" = X,
        report "Process Transfer Order" = X,
        report "Process Transfer Receipt Conf." = X,
        report "Process Unload Stock" = X,
        report "Sales Tax Invoice" = X,
        report "Sales Cr. Memo Tax Invoice" = X,
        report "Sales Order Tax Invoice" = X,
        report "Ext. Account Schedule" = X,
        report "Delivery Note" = X,
        report "Statement Customer" = X,
        report "Sales Tax Invoice FOC" = X,
        report "General Voucher" = X,
        report "Payment Voucher" = X,
        report "Receipt Voucher" = X,
        report "My Amount In Words" = X,
        report "Calculate Inventory EOD" = X,
        report "Stock Inventory" = X,
        report "Customer Oustanding Balance" = X,
        report "Sales Register Query" = X,
        xmlport "DMS Universal XMLport" = X,
        xmlport "Import Sales Invoice" = X,
        xmlport "Import Transfer Order Shipment" = X,
        xmlport "Import Transfer Order Proposal" = X,
        xmlport "Import Transfer Order Unload" = X,
        xmlport "Transfer Receipt Confrimation" = X,
        xmlport "Import Sales Order" = X,
        xmlport "Import Cash Receipt Journal" = X,
        xmlport "Export Customer" = X,
        xmlport "Export Item" = X,
        xmlport "Export Salesperson" = X,
        xmlport "Export Warehouse Location" = X,
        xmlport "Export Transfer Order" = X,
        xmlport "Export Sales Price" = X,
        xmlport "Export Open Invoices" = X,
        xmlport "Export Stock Invenoty" = X,
        xmlport "Export Open Invoices From Cust" = X;
}
