codeunit 50005 "Process Sales Order"
{
    TableNo = "Sales Order Header Staging";

    trigger OnRun()
    var
        RecSalesHeader: Record "Sales Header";
        IntegrationSetup: Record "Integration Setup";
        RecSalesperson: Record "Salesperson/Purchaser";
        RecSalesLine: Record "Sales Line";
        RecSalesLineStaging: Record "Sales Order Line Staging";
        RecLocation: Record Location;
        LineNo: Integer;
        SalesPriceL: Record "Sales Price";
        CustomerL: Record Customer;
    begin
        //Mandatory Fields check
        Rec.TestField("No.");
        Rec.TestField("Sell-To Customer No.");
        Clear(RecSalesHeader);
        RecSalesHeader.SetCurrentKey("Document Type", "No.");
        if RecSalesHeader.Get(RecSalesHeader."Document Type"::Order, Rec."No.") then
            Error('Record already exists in Sales Header No. %1', Rec."No.");
        //Creating Sales Order
        Clear(RecSalesHeader);
        IntegrationSetup.GET;
        RecSalesHeader.Init();
        RecSalesHeader.SetHideValidationDialog(true);
        RecSalesHeader.Validate("Document Type", RecSalesHeader."Document Type"::Order);
        RecSalesHeader.Validate("No.", Rec."No.");
        if IntegrationSetup."Customer Prefix Required" then
            RecSalesHeader.Validate("Sell-to Customer No.", IntegrationSetup."Customer Prefix" + Rec."Sell-To Customer No.")
        else
            RecSalesHeader.Validate("Sell-to Customer No.", Rec."Sell-To Customer No.");
        RecSalesHeader.Validate("Order Date", Rec."Order Date");
        RecSalesHeader.Validate("Posting Date", Rec."Order Date");
        if RecSalesperson.GET(Rec."Salesperson Code") then
            RecSalesHeader.Validate("Salesperson Code", Rec."Salesperson Code");
        RecSalesHeader.Validate("Order/Invoice Type", Rec."Order Type");
        //RecSalesHeader.Validate("Posting No.", Rec."No.");
        RecSalesHeader.Validate("External Document No.", Rec."No.");
        RecSalesHeader."Created by API" := true;
        RecSalesHeader."Staging Entry No." := Rec."Entry No.";
        RecSalesHeader.Insert(true);

        //Inserting Lines

        Clear(LineNo);
        Clear(RecSalesLine);
        RecSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
        RecSalesLine.SetRange("Document No.", Rec."No.");
        If RecSalesLine.FindLast() then
            LineNo := RecSalesLine."Line No."
        else
            LineNo := 0;
        Clear(RecSalesLineStaging);
        RecSalesLineStaging.SetRange("Sales Order Entry No.", Rec."Entry No.");
        if RecSalesLineStaging.FindSet() then begin
            repeat
                LineNo += 10000;
                Clear(RecSalesLine);
                //30.07.2021
                //Start Validating Unit price in sales price table before creating line
                //ValidateUnitprice(Rec, RecSalesInvLineStaging);
                Clear(CustomerL);
                Clear(SalesPriceL);
                if CustomerL.Get(Rec."Sell-To Customer No.") then;
                SalesPriceL.SetRange("Item No.", RecSalesLineStaging."Item No.");
                SalesPriceL.SetRange("Sales Code", CustomerL."Customer Price Group");
                SalesPriceL.SetFilter("Ending Date", '>%1', Rec."Order Date");
                SalesPriceL.SetRange("Unit Price", RecSalesLineStaging."Unit Price");
                SalesPriceL.FindFirst();
                //End Validating Unit price in sales price table before creating line
                //30.07.2021
                RecSalesLine.Init();
                RecSalesLine.SetHideValidationDialog(true);
                RecSalesLine.SetHasBeenShown();
                RecSalesLine.Validate("Document Type", RecSalesLine."Document Type"::Order);
                RecSalesLine.Validate("Document No.", Rec."No.");
                RecSalesLine.Validate("Line No.", LineNo);
                RecSalesLine.Validate(Type, RecSalesLine.Type::Item);
                RecSalesLine.Validate("No.", RecSalesLineStaging."Item No.");
                //Unit of measure should come from Items Automatically
                //Clear(RecLocation);
                //RecLocation.SetRange("Sales Person", RecSalesLineStaging."Location Code");
                //if RecLocation.FindFirst() then
                //sending direct location from staging table as requested by Akhil 
                RecSalesLine.Validate("Location Code", RecSalesLineStaging."Location Code");
                RecSalesLine.Validate(Quantity, RecSalesLineStaging.Quantity);
                RecSalesLine.Validate("Unit Price", RecSalesLineStaging."Unit Price");
                RecSalesLine.Validate("Free Sample Quantity", RecSalesLineStaging."Free Sample Quantity");
                RecSalesLine.Validate("VAT %", RecSalesLineStaging."VAT %");
                RecSalesLine.Validate("Line Discount Amount", RecSalesLineStaging."Line Discount Amount"); //TT-RS-20210513 Vuse Device Discounting Price-
                RecSalesLine.Insert(true);
            until RecSalesLineStaging.Next() = 0;
        end;
    end;

    var
        myInt: Integer;
}