codeunit 50006 "Process Sales Invoice"
{
    TableNo = "Sales Invoice Header Staging";

    trigger OnRun()
    var
        RecSalesInvHeader: Record "Sales Header";
        IntegrationSetup: Record "Integration Setup";
        RecSalesperson: Record "Salesperson/Purchaser";
        RecSalesLine: Record "Sales Line";
        RecSalesInvLineStaging: Record "Sales Inv. Line Staging";
        RecLocation: Record Location;
        LineNo: Integer;
        RecPostedSalesInvoiceHeader: Record "Sales Invoice Header";
        SalesPriceL: Record "Sales Price";
        CustomerL: Record Customer;
    begin
        //Mandatory Fields check
        Rec.TestField("No.");
        Rec.TestField("Sell-To Customer No.");
        Clear(RecPostedSalesInvoiceHeader);
        RecPostedSalesInvoiceHeader.SetCurrentKey("No.");
        if RecPostedSalesInvoiceHeader.Get(Rec."No.") then
            Error('Record already exists in the table %1, No. %2', RecPostedSalesInvoiceHeader.TableCaption, Rec."No.");
        ComparePrice(Rec);
        //Creating Sales Order
        Clear(RecSalesInvHeader);
        IntegrationSetup.GET;
        RecSalesInvHeader.Init();
        RecSalesInvHeader.SetHideValidationDialog(true);
        RecSalesInvHeader.Validate("Document Type", RecSalesInvHeader."Document Type"::Invoice);
        RecSalesInvHeader.Validate("No.", Rec."No.");
        if IntegrationSetup."Customer Prefix Required" then begin
            RecSalesInvHeader.Validate("Sell-to Customer No.", IntegrationSetup."Customer Prefix" + Rec."Sell-To Customer No.");
            Reccust.GET(IntegrationSetup."Customer Prefix" + Rec."Sell-To Customer No.");
            RecSalesInvHeader.Validate("Shipment Method Code", Reccust."Shipment Method Code");
        end else begin
            RecSalesInvHeader.Validate("Sell-to Customer No.", Rec."Sell-To Customer No.");
            Reccust.GET(Rec."Sell-To Customer No.");
            RecSalesInvHeader.Validate("Shipment Method Code", Reccust."Shipment Method Code");
        end;
        RecSalesInvHeader.Validate("Order Date", Rec."Posting Date");
        RecSalesInvHeader.Validate("Posting Date", Rec."Posting Date");
        RecSalesInvHeader.Validate("External Document No.", Rec."External Doucment No.");
        if RecLocation.GET(Rec."Location Code") then
            RecSalesInvHeader.Validate("Location Code", Rec."Location Code");
        if RecSalesperson.GET(Rec."Salesperson Code") then
            RecSalesInvHeader.Validate("Salesperson Code", Rec."Salesperson Code");
        RecSalesInvHeader.Validate("Order/Invoice Type", Rec."Invoice Type");
        RecSalesInvHeader."Created by API" := true;
        RecSalesInvHeader."Staging Entry No." := Rec."Entry No.";
        RecSalesInvHeader.Validate("Posting No.", Rec."No.");
        RecSalesInvHeader.Validate("External Document No.", Rec."No.");
        RecSalesInvHeader.Validate("Sales Order Type", Rec."Sales Order Type");
        RecSalesInvHeader.Validate("Sales Channel Type", Rec."Sales Channel Type");
        RecSalesInvHeader.Insert(true);
        //LT_V1.01
        if RecLocation.GET(Rec."Location Code") then
            RecSalesInvHeader.Validate("Location Code", Rec."Location Code");
        RecSalesInvHeader.MODIFY(TRUE);
        //LT_V1.01
        //Inserting Lines
        Clear(LineNo);
        Clear(RecSalesLine);
        RecSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Invoice);
        RecSalesLine.SetRange("Document No.", Rec."No.");
        If RecSalesLine.FindLast() then
            LineNo := RecSalesLine."Line No."
        else
            LineNo := 0;
        Clear(RecSalesInvLineStaging);
        RecSalesInvLineStaging.SetRange("Sales Inv. Entry No.", Rec."Entry No.");
        if RecSalesInvLineStaging.FindSet() then begin
            repeat
                ValidateVatPercentage(RecSalesInvLineStaging);
                LineNo += 10000;
                Clear(RecSalesLine);
                //30.07.2021
                //Start Validating Unit price in sales price table before creating line
                //ValidateUnitprice(Rec, RecSalesInvLineStaging);
                Clear(CustomerL);
                Clear(SalesPriceL);
                if CustomerL.Get(Rec."Sell-To Customer No.") then;
                SalesPriceL.SetRange("Item No.", RecSalesInvLineStaging."Item No.");
                SalesPriceL.SetRange("Sales Code", CustomerL."Customer Price Group");
                SalesPriceL.SetFilter("Ending Date", '>%1', Rec."Posting Date");
                SalesPriceL.SetRange("Unit Price", RecSalesInvLineStaging."Unit Price");
                SalesPriceL.FindFirst();
                //End Validating Unit price in sales price table before creating line
                //30.07.2021
                RecSalesLine.Init();
                RecSalesLine.SetHideValidationDialog(true);
                RecSalesLine.SetHasBeenShown();
                RecSalesLine.Validate("Document Type", RecSalesLine."Document Type"::Invoice);
                RecSalesLine.Validate("Document No.", Rec."No.");
                RecSalesLine.Validate("Line No.", LineNo);
                RecSalesLine.Validate(Type, RecSalesLine.Type::Item);
                RecSalesLine.Validate("No.", RecSalesInvLineStaging."Item No.");
                //Unit of measure should come from Items Automatically
                Clear(RecLocation);
                RecLocation.SetRange("Sales Person", Rec."Location Code");
                if RecLocation.FindFirst() then
                    RecSalesLine.Validate("Location Code", RecLocation.Code);
                RecSalesLine.Validate(Quantity, RecSalesInvLineStaging.Quantity);
                RecSalesLine.Validate("Unit Price", RecSalesInvLineStaging."Unit Price");
                RecSalesLine.Validate("Free Sample Quantity", RecSalesInvLineStaging."Free Sample Quantity");
                //RecSalesLine.Validate("VAT %", RecSalesInvLineStaging."VAT %");
                RecSalesLine.Validate("Line Discount Amount", RecSalesInvLineStaging."Line Discount Amount"); //TT-RS-20210513 Vuse Device Discounting Price
                if RecSalesLine.IsInventoriableItem() then
                    RecSalesLine.Validate("Bin Code", RecSalesInvLineStaging."Bin Code");
                RecSalesLine.Insert(true);
                //LT_V1.01
                Clear(RecLocation);
                RecLocation.SetRange("Sales Person", Rec."Location Code");
                if RecLocation.FindFirst() then
                    RecSalesLine.Validate("Location Code", RecLocation.Code);
                RecSalesLine.MODIFY(TRUE);
            //LT_V1.01
            until RecSalesInvLineStaging.Next() = 0;
        end;
    end;

    local procedure ComparePrice(var PSalesHeaderStaging: Record "Sales Invoice Header Staging")
    var
        PSalesInvLineStaging: Record "Sales Inv. Line Staging";
        TotalAmountL: Decimal;
    begin
        Clear(PSalesInvLineStaging);
        Clear(TotalAmountL);
        PSalesInvLineStaging.SetRange("Sales Inv. Entry No.", PSalesHeaderStaging."Entry No.");
        if PSalesInvLineStaging.FindSet() then begin
            repeat
                TotalAmountL += PSalesInvLineStaging."Amount Inc. VAT";
            until PSalesInvLineStaging.Next() = 0;
        end;
        if TotalAmountL <> PSalesHeaderStaging."Amount Inc. VAT" then
            Error('Sum of Line Amount Inc. Vat is not matching with Amount Inc. Vat in %1', PSalesHeaderStaging.TableCaption);
    end;

    local procedure ValidateVatPercentage(var PSalesInvLineStaging: Record "Sales Inv. Line Staging")
    var
        VatPostSetupL: Record "VAT Posting Setup";
        ItemL: Record Item;
    begin
        if PSalesInvLineStaging."VAT %" = 0 then
            exit;
        Clear(ItemL);
        Clear(VatPostSetupL);
        ItemL.SetRange("No.", PSalesInvLineStaging."Item No.");
        ItemL.SetRange("FOC Item", false);
        if ItemL.FindFirst() then begin
            VatPostSetupL.SetRange("VAT Bus. Posting Group", Reccust."VAT Bus. Posting Group");
            VatPostSetupL.SetRange("VAT Prod. Posting Group", ItemL."VAT Prod. Posting Group");
            if VatPostSetupL.FindFirst() then begin
                PSalesInvLineStaging.TestField("VAT %", VatPostSetupL."VAT %");
            end;
        end;
    end;

    var
        Reccust: Record Customer;
}