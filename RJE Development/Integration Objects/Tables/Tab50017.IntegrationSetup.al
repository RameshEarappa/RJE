table 50017 "Integration Setup"
{
    Caption = 'Integration Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Customer Master URL"; Text[250])
        {
            Caption = 'Customer Master URL';
            DataClassification = ToBeClassified;
        }
        field(3; "Access Key"; Text[250])
        {
            Caption = 'Access Key';
            DataClassification = ToBeClassified;
        }
        field(4; "Soap Envelop"; Blob)
        {
            Caption = 'Soap Envelop';
            DataClassification = ToBeClassified;
        }
        field(5; "Item Master URL"; Text[250])
        {
            Caption = 'Item Master URL';
            DataClassification = ToBeClassified;
        }
        field(6; "Salesman Master URL"; Text[250])
        {
            Caption = 'Salesman Master URL';
            DataClassification = ToBeClassified;
        }
        field(7; "Warehouse Master URL"; Text[250])
        {
            Caption = 'Warehouse Master URL';
            DataClassification = ToBeClassified;
        }
        field(8; "Load Master URL"; Text[250])
        {
            Caption = 'Load Master URL';
            DataClassification = ToBeClassified;
        }
        field(9; "Sales Price URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Open Invoices URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Warehosue Stock URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Customer Prefix Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Customer Prefix"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
        field(16; "Cash Receipt Jnl Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(17; "Cash Receipt Jnl. Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Cash Receipt Jnl Template"));
        }
        field(18; "Send Transfer Order To SFA"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Item Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template";
        }
        field(20; "Item Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Template"));
        }
        field(21; "Item VAT%"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Journal Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(23; "Journal Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(24; "Nominal Cost % For VAT Calc."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "G/L Account For FOC Jorunal"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
        }
        field(26; "Open Inv. Cust. Balance Filter"; Text[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Open Invoice Customer Balance Filter';
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                Clear(Customer);
                Customer.SetFilter("No.", '<>%1', '');
                Customer.SetFilter(Balance, "Open Inv. Cust. Balance Filter");
                If Customer.FindSet() then
                    Message('Record Count based on Filter: %1', Customer.Count);
            end;
        }
        field(27; "Dummy Invoice Balance Filter"; Text[15])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Reccust: Record Customer;
            begin
                Clear(Reccust);
                Reccust.SetFilter(Balance, "Dummy Invoice Balance Filter");
                if Reccust.FindSet() then begin
                    Message('Record Count Based on Filter :%1', Reccust.Count);
                end;
            end;
        }
        field(28; "Open Inv. Cust. Ledger Filter"; Text[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Open Invoice Customer Ledger Remaining Amount Filter';
            trigger OnValidate()
            var
                CLE2: Record "Cust. Ledger Entry";
            begin
                Clear(CLE2);
                CLE2.SetRange(Open, true);
                CLE2.SETFILTER("Document Type", '<>%1&<>%2', CLE2."Document Type"::Payment, CLE2."Document Type"::"Credit Memo");
                CLE2.SetFilter(Amount, '>%1', 0);
                CLE2.SetFilter("Remaining Amount", "Open Inv. Cust. Ledger Filter");
                If CLE2.FindSet() then
                    Message('Record Count based on Filter: %1', CLE2.Count);
            end;
        }
        //TT-RS-20210511-
        field(29; "Journal Templ. Name For Sales"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
            Caption = 'Journal Template Name';
        }
        field(30; "Journal Batch Name For Sales"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Templ. Name For Sales"));
            Caption = 'Journal Batch Name';
        }
        field(31; "Cr. VAT Output % "; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //TT-RS=20210511+
        //11.08.2021
        field(32; "Transfer Receipt Confirmation"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer Receipt Confirmation Count';
        }
        field(33; "Sales invoice Staging Count"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Invoice Staging Count';
        }
        //11.08.2021
        //RJE Job Automation-10FEB2022
        field(34; "Execute Auto GRN After (Hrs)"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Execute TO Staging After (Hrs)"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Execute Trans. Order Staging After (Hrs)';
        }
        field(36; "Process Sales Order Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Process Trans. Rec. Conf."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process Transfer Receipt Confirmation';
        }
        field(38; "Process Sales Invoice Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Process Cash Receipt Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Process TO Unload Stock"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Process Day End Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Process Whs Receipt Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process Warehouse Receipt Staging';
        }
        field(43; "Process Transfer Order Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Process Warehouse Pick Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure SetSoapEnvelopData(NewData: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Soap Envelop");
        "Soap Envelop".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewData);
    end;

    procedure GetSoapEnvelop(): Text
    var
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        CalcFields("Soap Envelop");
        "Soap Envelop".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure TestFOCFields()
    begin
        Rec.TestField("Journal Template Name");
        Rec.TestField("Journal Batch Name");
        Rec.TestField("Nominal Cost % For VAT Calc.");
        Rec.TestField("G/L Account For FOC Jorunal");
    end;
}
