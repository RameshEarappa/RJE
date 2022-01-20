codeunit 50017 SendMasterDataFromBCToSFA
{
    //Customer
    trigger OnRun()
    var
        exportCustomers: XmlPort "Export Customer";
        exportItems: XmlPort "Export Item";
        exportLocations: XmlPort "Export Warehouse Location";
        exportSalesperson: XmlPort "Export Salesperson";
        exportSalesPrice: XmlPort "Export Sales Price";
        RecCustomer: Record Customer;
        TypeHelper: Codeunit "Type Helper";
        Utility: Codeunit "Integration Utility";
        InStream: InStream;
        Blob: Codeunit "Temp Blob";
        outstr: OutStream;
    begin
        //Customer Master
        Clear(exportCustomers);
        Clear(RecCustomer);
        RecCustomer.SetFilter("Payment Method Code", '<>%1', '');
        RecCustomer.SetFilter("Payment Terms Code", '<>%1', '');
        RecCustomer.SetFilter("Customer Price Group", '<>%1', '');
        if RecCustomer.FindSet() then begin
            Utility.ValidateCustomer(RecCustomer);
            Clear(Blob);
            Clear(outstr);
            exportCustomers.SetTableView(RecCustomer);
            Blob.CreateOutStream(outstr);
            exportCustomers.SetDestination(outstr);
            exportCustomers.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendCustomersToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), False);
        end;

        //ItemMaster
        Clear(exportItems);
        Clear(Blob);
        Clear(outstr);
        Blob.CreateOutStream(outstr, TextEncoding::UTF8);
        exportItems.SetDestination(outstr);
        exportItems.Export();
        Blob.CreateInStream(InStream, TextEncoding::UTF8);
        Utility.SendItemsToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), False);

        //LocationMaster
        Clear(exportLocations);
        Clear(Blob);
        Clear(outstr);
        Blob.CreateOutStream(outstr);
        exportLocations.SetDestination(outstr);
        exportLocations.Export();
        Blob.CreateInStream(InStream, TextEncoding::UTF8);
        Utility.SendLocationsToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), False);

        //Salesperson master
        Clear(exportSalesperson);
        Clear(Blob);
        Clear(outstr);
        Blob.CreateOutStream(outstr);
        exportSalesperson.SetDestination(outstr);
        exportSalesperson.Export();
        Blob.CreateInStream(InStream, TextEncoding::UTF8);
        Utility.SendSalespersonToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), False);

        //salesprice
        Clear(exportSalesPrice);
        Clear(Blob);
        Clear(outstr);
        Blob.CreateOutStream(outstr);
        exportSalesPrice.SetDestination(outstr);
        exportSalesPrice.Export();
        Blob.CreateInStream(InStream, TextEncoding::UTF8);
        Utility.SendSalesPriceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), False);
    end;
}
