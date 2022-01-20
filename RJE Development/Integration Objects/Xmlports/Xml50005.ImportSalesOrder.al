xmlport 50005 "Import Sales Order"
{
    Direction = Import;
    UseDefaultNamespace = true;
    schema
    {
        textelement(SalesOrders)
        {
            tableelement(SalesOrderHeader; "Sales Order Header Staging")
            {
                fieldelement(No; SalesOrderHeader."No.")
                {
                }
                fieldelement(SellToCustomerNo; SalesOrderHeader."Sell-To Customer No.")
                {
                }
                fieldelement(OrderDate; SalesOrderHeader."Order Date")
                {
                }
                fieldelement(SalespersonCode; SalesOrderHeader."Salesperson Code")
                {
                }
                fieldelement(SalesOrderType; SalesOrderHeader."Sales Order Type")
                {
                }
                fieldelement(SalesChannelType; SalesOrderHeader."Sales Channel Type")
                {
                }
                fieldelement(AmountToCustomer; SalesOrderHeader."Amount To Customer")
                {
                }
                fieldelement(InvoiceDiscount; SalesOrderHeader."Invoice Discount")
                {
                }
                fieldelement(VATAmount; SalesOrderHeader."VAT Amount")
                {

                }
                fieldelement(Amount; SalesOrderHeader.Amount)
                {
                }
                tableelement(Lines; "Sales Order Line Staging")
                {
                    LinkTable = SalesOrderHeader;
                    LinkFields = "Sales Order Entry No." = field("Entry No.");

                    fieldelement(ItemNo; Lines."Item No.")
                    {
                    }
                    /*fieldelement(Description; Lines.Description)
                    {//not required
                    }*/
                    fieldelement(Quantity; Lines.Quantity)
                    {
                    }
                    fieldelement(LocationCode; Lines."Location Code")
                    {
                    }
                    fieldelement(FreeSampleQuantity; Lines."Free Sample Quantity")
                    {
                    }
                    fieldelement(UnitPrice; Lines."Unit Price")
                    {
                    }
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
                        RecLines: Record "Sales Order Line Staging";
                    begin
                        Clear(RecLines);
                        RecLines.SetCurrentKey("Sales Order Entry No.", "Line No.");
                        RecLines.SetRange("Sales Order Entry No.", SalesOrderHeader."Entry No.");
                        if RecLines.FindLast() then
                            Lines."Line No." := RecLines."Line No." + 10000
                        else
                            Lines."Line No." := 10000;
                        Lines."Sales Order Entry No." := SalesOrderHeader."Entry No.";
                        Lines."Sales Order No." := SalesOrderHeader."No.";
                    end;
                }
                trigger OnBeforeInsertRecord()
                var
                    RecHeader: Record "Sales Order Header Staging";
                begin
                    Clear(RecHeader);
                    RecHeader.SetCurrentKey("Entry No.");
                    if RecHeader.FindLast() then
                        SalesOrderHeader."Entry No." := RecHeader."Entry No." + 1
                    else
                        SalesOrderHeader."Entry No." := 1;
                    SalesOrderHeader."Order Type" := SalesOrderHeader."Order Type"::"Sales + FOC";
                    SalesOrderHeader.Status := SalesOrderHeader.Status::"Ready To Sync";
                    SalesOrderHeader."Added on" := CurrentDateTime;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
