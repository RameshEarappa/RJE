codeunit 50018 SendOpenInvoicesToMirnah
{
    trigger OnRun()
    var
        exportxml: XmlPort "Export Open Invoices";
        exportxmlCust: XmlPort "Export Open Invoices From Cust";
        ReccustLedEntry: Record "Cust. Ledger Entry";
        InStream: InStream;
        Blob: Codeunit "Temp Blob";
        outstr: OutStream;
        TypeHelper: Codeunit "Type Helper";
        Customer: Record Customer;
        CLE2: Record "Cust. Ledger Entry";
        OpenInvoicesLogs: Record "Open Invoices Log Entries";
        PaymentEntriesExist: Boolean;
        Reccust: Record Customer;
        Utility: Codeunit "Integration Utility";
        IntegrationSetup: Record "Integration Setup";
    begin
        Clear(exportxml);
        Clear(ReccustLedEntry);
        Clear(Reccust);
        CLEAR(PaymentEntriesExist);
        IntegrationSetup.GET;
        Clear(Customer);
        Customer.SetFilter(Balance, IntegrationSetup."Open Inv. Cust. Balance Filter");
        IF Customer.FINDFIRST THEN
            REPEAT
                //ReccustLedEntry.RESET;
                CLE2.RESET;
                CLE2.SETRANGE("Customer No.", Customer."No.");
                CLE2.SetRange(Open, true);
                CLE2.SETFILTER("Document Type", '<>%1&<>%2', CLE2."Document Type"::Payment, CLE2."Document Type"::"Credit Memo");
                CLE2.SetFilter(Amount, '>%1', 0);
                CLE2.SetFilter("Remaining Amount", IntegrationSetup."Open Inv. Cust. Ledger Filter");
                IF CLE2.FINDSET THEN BEGIN
                    repeat
                        ReccustLedEntry.SetCurrentKey("Entry No.");
                        ReccustLedEntry.SetRange("Entry No.", CLE2."Entry No.");
                        IF ReccustLedEntry.FINDFIRST THEN begin
                            ReccustLedEntry.Mark(TRUE);
                        end;
                    until CLE2.Next() = 0;
                END
                ELSE BEGIN
                    OpenInvoicesLogs.INIT;
                    OpenInvoicesLogs."Entry No." := 0;
                    OpenInvoicesLogs.INSERT;
                    OpenInvoicesLogs."Customer No." := Customer."No.";
                    OpenInvoicesLogs."Creation Date" := Today;
                    OpenInvoicesLogs."Processed DateTime" := CurrentDateTime;
                    OpenInvoicesLogs.Modify();
                    PaymentEntriesExist := TRUE;
                END;
            UNTIL Customer.NEXT = 0;

        //ReccustLedEntry.SETRANGE("Customer No.");
        ReccustLedEntry.SETRANGE("Entry No.");
        ReccustLedEntry.MarkedOnly(TRUE);
        if ReccustLedEntry.Count() > 0 then begin
            Clear(Blob);
            Clear(outstr);
            Blob.CreateOutStream(outstr);
            exportxml.SetTableView(ReccustLedEntry);
            exportxml.SetDestination(outstr);
            exportxml.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendOpenInvoiceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), FALSE);
        end;

        Clear(Reccust);
        Reccust.SetFilter(Balance, IntegrationSetup."Dummy Invoice Balance Filter");
        if Reccust.Count() > 0 then begin
            Clear(Blob);
            Clear(outstr);
            Blob.CreateOutStream(outstr);
            exportxmlCust.SetTableView(Reccust);
            exportxmlCust.SetDestination(outstr);
            exportxmlCust.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendOpenInvoiceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), FALSE);
        end;
    end;
}



/*report 50001 SendOpenInvoicesToMirnah
{
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPostReport()
    var
        exportxml: XmlPort "Export Open Invoices";
        exportxmlCust: XmlPort "Export Open Invoices From Cust";
        ReccustLedEntry: Record "Cust. Ledger Entry";
        InStream: InStream;
        Blob: Codeunit "Temp Blob";
        outstr: OutStream;
        TypeHelper: Codeunit "Type Helper";
        Customer: Record Customer;
        CLE2: Record "Cust. Ledger Entry";
        OpenInvoicesLogs: Record "Open Invoices Log Entries";
        PaymentEntriesExist: Boolean;
        Reccust: Record Customer;
        Utility: Codeunit "Integration Utility";
    begin
        Clear(exportxml);
        Clear(ReccustLedEntry);
        Clear(Reccust);
        CLEAR(PaymentEntriesExist);
        Clear(Customer);
        Customer.SetFilter(Blocked, '<>%1', Customer.Blocked::All);
        IF Customer.FINDFIRST THEN
            REPEAT
                //ReccustLedEntry.RESET;
                CLE2.RESET;
                CLE2.SETRANGE("Customer No.", Customer."No.");
                CLE2.SetRange(Open, true);
                CLE2.SETRANGE("Document Type", CLE2."Document Type"::Payment);
                IF NOT CLE2.FINDFIRST THEN BEGIN
                    ReccustLedEntry.SetCurrentKey("Customer No.");
                    ReccustLedEntry.SetRange(Open, true);
                    ReccustLedEntry.SetRange("Customer No.", Customer."No.");
                    IF ReccustLedEntry.FINDFIRST THEN begin
                        REPEAT
                            ReccustLedEntry.Mark(TRUE);
                        UNTIL ReccustLedEntry.NEXT = 0;
                    end else begin
                        Reccust.SetCurrentKey("No.");
                        Reccust.SetRange("No.", Customer."No.");
                        if Reccust.FindFirst() then
                            Reccust.Mark(TRUE);
                    end;
                END
                ELSE BEGIN
                    OpenInvoicesLogs.INIT;
                    OpenInvoicesLogs."Entry No." := 0;
                    OpenInvoicesLogs.INSERT;
                    OpenInvoicesLogs."Customer No." := Customer."No.";
                    OpenInvoicesLogs."Creation Date" := Today;
                    OpenInvoicesLogs."Processed DateTime" := CurrentDateTime;
                    OpenInvoicesLogs.Modify();
                    PaymentEntriesExist := TRUE;
                END;
            UNTIL Customer.NEXT = 0;
        //ReccustLedEntry.SetCurrentKey("Customer No.");
        //ReccustLedEntry.SetRange("Customer No.", Rec."No.");
        ReccustLedEntry.SETRANGE("Customer No.");
        ReccustLedEntry.MarkedOnly(TRUE);
        if ReccustLedEntry.Count() > 0 then begin
            Clear(Blob);
            Clear(outstr);
            Blob.CreateOutStream(outstr);
            exportxml.SetTableView(ReccustLedEntry);
            exportxml.SetDestination(outstr);
            exportxml.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendOpenInvoiceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), FALSE);
        end;
        //IF NOT PaymentEntriesExist THEN
        //    Error('Records are not available in the table Customer Ledger Entry for selected Customer.');

        Reccust.SETRANGE("No.");
        Reccust.MarkedOnly(TRUE);
        if Reccust.Count() > 0 then begin
            Clear(Blob);
            Clear(outstr);
            Blob.CreateOutStream(outstr);
            exportxmlCust.SetTableView(Reccust);
            exportxmlCust.SetDestination(outstr);
            exportxmlCust.Export();
            Blob.CreateInStream(InStream, TextEncoding::UTF8);
            Utility.SendOpenInvoiceToSFA(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator).Replace('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', ''), FALSE);
        end
    end;
}

*/
