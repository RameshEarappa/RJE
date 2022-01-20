REPORT 60000 "Stock Inventory"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;
    DATASET
    {
        DATAITEM(StockInventory; Item)
        {
            RequestFilterFields = "No.";
            TRIGGER OnPreDataItem()
            VAR
                Location: Record Location;
            BEGIN
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('H.S Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Unit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                Location.RESET;
                Location.SETRANGE("Use As In-Transit", FALSE);
                IF LocationFilter <> '' THEN
                    Location.SETRANGE(Code, LocationFilter);
                IF Location.FINDFIRST THEN
                    REPEAT
                        ExcelBuffer.AddColumn(Location.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    UNTIL Location.NEXT = 0;
            END;

            TRIGGER OnAfterGetRecord()
            VAR
                Location: Record Location;
                ILE: Record "Item Ledger Entry";
                ExcelQtyFormat: Text[30];
            BEGIN
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(StockInventory."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StockInventory."Tariff No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StockInventory.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(StockInventory."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                Location.RESET;
                Location.SETRANGE("Use As In-Transit", FALSE);
                IF LocationFilter <> '' THEN
                    Location.SETRANGE(Code, LocationFilter);
                IF Location.FINDFIRST THEN
                    REPEAT
                        ILE.RESET;
                        ILE.SetCurrentKey("Item No.", "Location Code");
                        ILE.SETRANGE("Item No.", StockInventory."No.");
                        ILE.SETRANGE("Location Code", Location.Code);
                        ILE.CalcSums(Quantity);
                        ExcelQtyFormat := '#,##0';
                        ExcelBuffer.AddColumn(FORMAT(ILE.Quantity), FALSE, '', FALSE, FALSE, FALSE, ExcelQtyFormat, ExcelBuffer."Cell Type"::Number);
                    UNTIL Location.NEXT = 0;
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
                    field(LocationFilter; LocationFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        TableRelation = Location;
                    }
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
        ExcelBuffer.CreateNewBook('Stock Inventory');
        ExcelBuffer.WriteSheet('Stock Inventory', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    END;

    VAR
        ExcelBuffer: Record "Excel Buffer" Temporary;
        LocationFilter: Code[20];
}