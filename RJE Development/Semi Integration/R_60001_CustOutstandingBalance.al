REPORT 60001 "Customer Oustanding Balance"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;
    DATASET
    {
        DATAITEM(Customer; Customer)
        {
            RequestFilterFields = "No.";
            DATAITEM(CLE; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemTableView = SORTING("Customer No.");
                DataItemLink = "Customer No." = field("No.");
                TRIGGER OnAfterGetRecord()
                VAR
                    ExcelQtyFormat: Text[30];
                BEGIN
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    //11.11.2020
                    ExcelBuffer.AddColumn(Customer."RCS Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Customer."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Customer."Credit Limit (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Customer.Branch, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Customer."Sales Channel Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CLE."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(CLE."Payment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    IF CLE."Due Date" < WorkDate() THEN BEGIN
                        CLEAR(DueDays);
                        DueDays := WorkDate - CLE."Due Date";
                        ExcelBuffer.AddColumn('Overdue', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn((WorkDate - CLE."Due Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        IF (DueDays > 1) AND (DueDays <= 6) THEN
                            ExcelBuffer.AddColumn('1-6', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                        ELSE
                            IF (DueDays > 6) AND (DueDays <= 13) THEN
                                ExcelBuffer.AddColumn('7-13', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                            ELSE
                                IF (DueDays > 13) AND (DueDays <= 20) THEN
                                    ExcelBuffer.AddColumn('14-20', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    IF (DueDays > 20) AND (DueDays <= 30) THEN
                                        ExcelBuffer.AddColumn('21-30', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        IF DueDays > 30 THEN
                                            ExcelBuffer.AddColumn('Over 30 Days', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    END
                    ELSE BEGIN
                        ExcelBuffer.AddColumn('Due', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    END;
                    //11.11.2020
                    ExcelBuffer.AddColumn(Customer."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CLE."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CLE."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelQtyFormat := '#,##0';
                    ExcelBuffer.AddColumn(CLE.Amount, FALSE, '', FALSE, FALSE, FALSE, ExcelQtyFormat, ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CLE."Remaining Amount", FALSE, '', FALSE, FALSE, FALSE, ExcelQtyFormat, ExcelBuffer."Cell Type"::Number);
                END;

            }
            TRIGGER OnPreDataItem()
            VAR
            BEGIN
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //11.11.2020
                ExcelBuffer.AddColumn('Customer RCS Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Payment Terms (Days)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Credit Limit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Sales Channel', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Payment Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Payment Terms (Days)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Payment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Overdue (Days)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //11.11.2020
                ExcelBuffer.AddColumn('Salesman Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Balance', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            END;
        }
    }

    REQUESTPAGE
    {
        LAYOUT
        {
            AREA(Content)
            {
                GROUP(Options)
                {
                }
            }
        }
    }
    TRIGGER OnInitReport()
    BEGIN
        ExcelBuffer.DeleteAll();
    END;

    TRIGGER OnPostReport()
    BEGIN
        ExcelBuffer.CreateNewBook('Customer Outstanding');
        ExcelBuffer.WriteSheet('Customer Outstanding', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    END;

    VAR
        ExcelBuffer: Record "Excel Buffer" Temporary;
        DueDays: Integer;
}