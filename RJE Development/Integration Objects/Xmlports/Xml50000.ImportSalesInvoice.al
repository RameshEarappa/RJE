xmlport 50000 "Import Sales Invoice"
{
    Direction = Import;
    UseDefaultNamespace = true;
    schema
    {
        textelement(SalesInvoices)
        {
            tableelement(SalesInvoiceHeaderStaging; "Sales Invoice Header Staging")
            {
                fieldelement(No; SalesInvoiceHeaderStaging."No.")
                {
                }
                fieldelement(SellToCustomerNo; SalesInvoiceHeaderStaging."Sell-To Customer No.")
                {
                }
                fieldelement(PostingDate; SalesInvoiceHeaderStaging."Posting Date")
                {
                }
                fieldelement(ExternalDoucmentNo; SalesInvoiceHeaderStaging."External Doucment No.")
                {
                }
                fieldelement(SalesChannelType; SalesInvoiceHeaderStaging."Sales Channel Type")
                {
                }
                fieldelement(SalesOrderType; SalesInvoiceHeaderStaging."Sales Order Type")
                {
                }
                fieldelement(LocationCode; SalesInvoiceHeaderStaging."Location Code")
                {
                }
                fieldelement(SalesPersonCode; SalesInvoiceHeaderStaging."Salesperson Code")
                {
                }
                fieldelement(Amount; SalesInvoiceHeaderStaging.Amount)
                {
                }
                fieldelement(AmountIncVAT; SalesInvoiceHeaderStaging."Amount Inc. VAT")
                {
                }
                fieldelement(AmountToCustomer; SalesInvoiceHeaderStaging."Amount To Customer")
                {
                }
                fieldelement(InvoiceDiscountAmount; SalesInvoiceHeaderStaging."Invoice Discount Amount")
                {
                }
                fieldelement(VATAmount; SalesInvoiceHeaderStaging."VAT Amount")
                {
                }
                tableelement(Lines; "Sales Inv. Line Staging")
                {
                    LinkTable = SalesInvoiceHeaderStaging;
                    LinkFields = "Sales Inv. Entry No." = field("Entry No.");

                    fieldelement(ItemNo; Lines."Item No.")
                    {
                    }
                    fieldelement(Quantity; Lines.Quantity)
                    {
                    }
                    fieldelement(FreeSampleQuantity; Lines."Free Sample Quantity")
                    {
                    }
                    fieldelement(UnitPrice; Lines."Unit Price")
                    {
                    }
                    /*fieldelement(BinCode; Lines."Bin Code")
                    {
                    }
                    fieldelement(ZoneCode; Lines."Zone Code")
                    {
                    }
                    fieldelement(LotNo; Lines."Lot No.")
                    {
                    }*/
                    fieldelement(UnitofMeasure; Lines."Unit of Measure")
                    {
                    }
                    fieldelement(VATPercentage; Lines."VAT %")
                    {
                    }
                    fieldelement(VATAmount; Lines."VAT Amount")
                    {

                    }
                    fieldelement(AmountIncVAT; Lines."Amount Inc. VAT")
                    {
                    }
                    fieldelement(SalesDiscount; Lines."Line Discount Amount")
                    {
                    }
                    trigger OnBeforeInsertRecord()
                    var
                        RecLine: Record "Sales Inv. Line Staging";
                    begin
                        Clear(RecLine);
                        RecLine.SetCurrentKey("Sales Inv. Entry No.", "Line No.");
                        RecLine.SetRange("Sales Inv. Entry No.", SalesInvoiceHeaderStaging."Entry No.");
                        if RecLine.FindLast() then
                            Lines."Line No." := RecLine."Line No." + 10000
                        else
                            Lines."Line No." := 10000;
                        Lines."Sales Invoice No." := SalesInvoiceHeaderStaging."No.";
                        Lines."Sales Inv. Entry No." := SalesInvoiceHeaderStaging."Entry No.";
                    end;
                }
                trigger OnBeforeInsertRecord()
                var
                    RecHeader: Record "Sales Invoice Header Staging";
                begin
                    Clear(RecHeader);
                    RecHeader.SetCurrentKey("Entry No.");
                    if RecHeader.FindLast() then
                        SalesInvoiceHeaderStaging."Entry No." := RecHeader."Entry No." + 1
                    else
                        SalesInvoiceHeaderStaging."Entry No." := 1;
                    SalesInvoiceHeaderStaging."Invoice Type" := SalesInvoiceHeaderStaging."Invoice Type"::"Sales + FOC";
                    SalesInvoiceHeaderStaging.Status := SalesInvoiceHeaderStaging.Status::"Ready To Sync";
                    SalesInvoiceHeaderStaging."Added on" := CurrentDateTime;
                end;
            }
        }
    }
}
