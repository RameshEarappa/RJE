codeunit 50013 AssignLotNoToSalesLines
{
    TableNo = "Sales Line";

    trigger OnRun()
    var
        SalesInvoiceLine: Record "Sales Line";
    begin
        SalesInvoiceLine.Copy(Rec);
        Code(SalesInvoiceLine);
        Rec := SalesInvoiceLine;
    end;


    procedure Code(var SalesInvoiceLine: Record "Sales Line")
    var
        CreateReservationEntry: Codeunit "Create Reserv. Entry";
        ReservationEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        ReseveStatus: Enum "Reservation Status";
        ILE, ILE2 : Record "Item Ledger Entry";
        AvailableQty, ItemTrackingQty, RequiredQty, TotalReservedQty, ReservedQty : Decimal;
        CheckList: List of [Text];
    begin
        Clear(AvailableQty);
        Clear(TotalReservedQty);
        IF SalesInvoiceLine.FINDFIRST THEN
            REPEAT
                if (SalesInvoiceLine."Lot No. Assigned" = false) AND (SalesInvoiceLine.IsInventoriableItem()) then begin
                    SalesInvoiceLine.TESTFIELD("Location Code");
                    clear(CheckList);
                    ILE.RESET;
                    ILE.SETRANGE("Item No.", SalesInvoiceLine."No.");
                    ILE.SETRANGE(Open, TRUE);
                    ILE.SETFILTER("Lot No.", '<>%1', '');
                    ILE.SETRANGE("Location Code", SalesInvoiceLine."Location Code");
                    IF ILE.FINDFIRST THEN
                        REPEAT
                            AvailableQty += ILE."Remaining Quantity"; //ILE.Quantity;
                            if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date")) then begin
                                TotalReservedQty += GetReservedQty(ILE."Item No.", ILE."Location Code", ILE."Lot No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Document No.", ILE."Expiration Date");
                                CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date"));
                            end;
                        UNTIL ILE.NEXT = 0;
                    IF (AvailableQty - TotalReservedQty) < SalesInvoiceLine.Quantity THEN
                        ERROR('There is no enough inventory available to assign Lot No. for Item No. %1', SalesInvoiceLine."No.");

                    CLEAR(AvailableQty);
                    CLEAR(ItemTrackingQty);
                    Clear(TotalReservedQty);
                    RequiredQty := SalesInvoiceLine.Quantity;
                    Clear(CheckList);
                    ILE.RESET;
                    ILE.SetCurrentKey("Item No.", "Expiration Date");
                    ILE.SetAscending("Expiration Date", true);
                    ILE.SETRANGE("Item No.", SalesInvoiceLine."No.");
                    ILE.SETRANGE(Open, TRUE);
                    ILE.SETFILTER("Lot No.", '<>%1', '');
                    ILE.SETRANGE("Location Code", SalesInvoiceLine."Location Code");
                    IF ILE.FINDFIRST THEN
                        REPEAT
                            if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date")) then begin
                                CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date"));
                                Clear(ILE2);
                                ILE2.SETRANGE("Item No.", SalesInvoiceLine."No.");
                                ILE2.SETRANGE(Open, TRUE);
                                ILE2.SetRange("Lot No.", ILE."Lot No.");
                                ILE2.SETRANGE("Location Code", SalesInvoiceLine."Location Code");
                                ILE2.SetRange("Expiration Date", ILE."Expiration Date");
                                if ILE2.FindSet() then
                                    ILE2.CalcSums("Remaining Quantity");

                                //AvailableQty += ILE2."Remaining Quantity";
                                //TotalReservedQty += GetReservedQty(ILE."Item No.", ILE."Location Code", ILE."Lot No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Document No.", ILE."Expiration Date");

                                ReservedQty := GetReservedQty(ILE."Item No.", ILE."Location Code", ILE."Lot No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Document No.", ILE."Expiration Date");

                                if (ILE2."Remaining Quantity" - ReservedQty) > 0 then begin
                                    IF RequiredQty >= (ILE2."Remaining Quantity" - ReservedQty) THEN BEGIN//ILE.Quantity THEN
                                        ItemTrackingQty := (ILE2."Remaining Quantity" - ReservedQty); //ILE.Quantity
                                        RequiredQty := RequiredQty - (ILE2."Remaining Quantity" - ReservedQty);
                                    END ELSE begin
                                        ItemTrackingQty := RequiredQty; //SalesInvoiceLine.Quantity;
                                        RequiredQty := 0;
                                    end;
                                    TempReservEntry.DeleteAll();
                                    TempReservEntry.Init();
                                    TempReservEntry."Entry No." := 1;
                                    TempReservEntry."Lot No." := ILE."Lot No.";
                                    TempReservEntry.Quantity := ItemTrackingQty;
                                    TempReservEntry."Expiration Date" := ILE."Expiration Date";
                                    TempReservEntry.INSERT;
                                    CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                                    CreateReservationEntry.CreateReservEntryFor(Database::"Sales Line", SalesInvoiceLine."Document Type".AsInteger(), SalesInvoiceLine."Document No.", '', 0, SalesInvoiceLine."Line No.", SalesInvoiceLine."Qty. per Unit of Measure",
                                    TempReservEntry.Quantity, TempReservEntry.Quantity * SalesInvoiceLine."Qty. per Unit of Measure", TempReservEntry);
                                    CreateReservationEntry.CreateEntry(
                                    SalesInvoiceLine."No.", SalesInvoiceLine."Variant Code", SalesInvoiceLine."Location Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);
                                end;
                            end;

                        /*AvailableQty += ILE."Remaining Quantity";//ILE.Quantity;
                        if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code") then begin
                            TotalReservedQty += GetReservedQty(ILE."Item No.", ILE."Location Code", ILE."Lot No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Document No.");
                            CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code");
                        end;
                        ReservedQty := GetReservedQty(ILE."Item No.", ILE."Location Code", ILE."Lot No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Document No.");
                        IF RequiredQty >= (ILE."Remaining Quantity" - ReservedQty) THEN BEGIN//ILE.Quantity THEN
                            ItemTrackingQty := (ILE."Remaining Quantity" - ReservedQty); //ILE.Quantity
                            RequiredQty := RequiredQty - (ILE."Remaining Quantity" - ReservedQty);
                        END ELSE begin
                            ItemTrackingQty := RequiredQty; //SalesInvoiceLine.Quantity;
                            RequiredQty := 0;
                        end;
                        TempReservEntry.DeleteAll();
                        TempReservEntry.Init();
                        TempReservEntry."Entry No." := 1;
                        TempReservEntry."Lot No." := ILE."Lot No.";
                        TempReservEntry.Quantity := ItemTrackingQty;
                        TempReservEntry."Expiration Date" := ILE."Expiration Date";
                        TempReservEntry.INSERT;
                        CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        CreateReservationEntry.CreateReservEntryFor(Database::"Sales Line", SalesInvoiceLine."Document Type".AsInteger(), SalesInvoiceLine."Document No.", '', 0, SalesInvoiceLine."Line No.", SalesInvoiceLine."Qty. per Unit of Measure",
                        TempReservEntry.Quantity, TempReservEntry.Quantity * SalesInvoiceLine."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservationEntry.CreateEntry(
                        SalesInvoiceLine."No.", SalesInvoiceLine."Variant Code", SalesInvoiceLine."Location Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);
                    //UNTIL (ILE.NEXT = 0) OR ((AvailableQty - TotalReservedQty) >= SalesInvoiceLine.Quantity);*/
                        UNTIL (ILE.NEXT = 0) OR (RequiredQty = 0);
                    SalesInvoiceLine."Lot No. Assigned" := true;
                    SalesInvoiceLine.Modify();
                end;
            UNTIL SalesInvoiceLine.NEXT = 0;
        if NOT HideDialogueBox then
            Message('Lot Nos Assigned');
    end;

    local procedure GetReservedQty(ItemNo: Code[20]; LocationCode: Code[20]; LotNo: code[50]; LineNo: Integer; InvoiceNo: Code[20]; expDate: Date): Decimal
    var
        RecResevEntry: Record "Reservation Entry";
    begin
        clear(RecResevEntry);
        RecResevEntry.SetRange("Item No.", ItemNo);
        RecResevEntry.SetRange("Location Code", LocationCode);
        RecResevEntry.SetRange("Lot No.", LotNo);
        RecResevEntry.SetRange("Reservation Status", RecResevEntry."Reservation Status"::Surplus);
        RecResevEntry.SetRange(Positive, false);
        RecResevEntry.SetRange("Expiration Date", expDate);
        //24FEB
        RecResevEntry.SetFilter("Source ID", '<>%1', InvoiceNo);
        RecResevEntry.SetFilter("Source Ref. No.", '<>%1', LineNo);
        if RecResevEntry.FindSet() then begin
            RecResevEntry.CalcSums(Quantity);
            exit(abs(RecResevEntry.Quantity));
        end else
            exit(0);
    end;

    procedure SetHideDialogueBox(DialogueBoxL: Boolean)
    begin
        HideDialogueBox := DialogueBoxL;
    end;


    procedure AssignLotNoForTransferOrder(var RecTransferHeader: Record "Transfer Header")
    var
        CreateReservationEntry: Codeunit "Create Reserv. Entry";
        ReservationEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        ReseveStatus: Enum "Reservation Status";
        RecTransferLine: Record "Transfer Line";
        ILE, ILE2 : Record "Item Ledger Entry";
        AvailableQty, ItemTrackingQty, RequiredQty, TotalReservedQty, ReservedQty : Decimal;
        CheckList: List of [Text];
    begin
        Clear(AvailableQty);
        Clear(TotalReservedQty);
        Clear(RecTransferLine);
        RecTransferLine.SetRange("Document No.", RecTransferHeader."No.");
        IF RecTransferLine.FINDFIRST THEN
            REPEAT
                if not RecTransferLine."Lot No. Assigned" then begin
                    Clear(CheckList);
                    ILE.RESET;
                    ILE.SETRANGE("Item No.", RecTransferLine."Item No.");
                    ILE.SETRANGE(Open, TRUE);
                    ILE.SETFILTER("Lot No.", '<>%1', '');
                    ILE.SETRANGE("Location Code", RecTransferHeader."Transfer-from Code");
                    IF ILE.FINDFIRST THEN
                        REPEAT
                            AvailableQty += ILE."Remaining Quantity"; //ILE.Quantity;
                            if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date")) then begin
                                TotalReservedQty += GetReservedQtyForTO(ILE."Item No.", ILE."Location Code", ILE."Lot No.", RecTransferLine."Line No.", RecTransferLine."Document No.", ILE."Expiration Date");
                                CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date"));
                            end;
                        UNTIL ILE.NEXT = 0;
                    IF (AvailableQty - TotalReservedQty) < RecTransferLine.Quantity THEN
                        ERROR('There is no enough inventory available to assign Lot No. for Item No. %1', RecTransferLine."Item No.");

                    CLEAR(AvailableQty);
                    CLEAR(ItemTrackingQty);
                    Clear(TotalReservedQty);
                    RequiredQty := RecTransferLine.Quantity;
                    Clear(CheckList);
                    ILE.RESET;
                    ILE.SetCurrentKey("Item No.", "Expiration Date");
                    ILE.SetAscending("Expiration Date", true);
                    ILE.SETRANGE("Item No.", RecTransferLine."Item No.");
                    ILE.SETRANGE(Open, TRUE);
                    ILE.SETFILTER("Lot No.", '<>%1', '');
                    ILE.SETRANGE("Location Code", RecTransferHeader."Transfer-from Code");
                    IF ILE.FINDFIRST THEN
                        REPEAT
                            if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date")) then begin
                                CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code" + Format(ILE."Expiration Date"));
                                Clear(ILE2);
                                ILE2.SETRANGE("Item No.", RecTransferLine."Item No.");
                                ILE2.SETRANGE(Open, TRUE);
                                ILE2.SETRANGE("Lot No.", ILE."Lot No.");
                                ILE2.SETRANGE("Location Code", RecTransferHeader."Transfer-from Code");
                                ILE2.SetRange("Expiration Date", ILE."Expiration Date");
                                if ILE2.FindSet() then
                                    ILE2.CalcSums("Remaining Quantity");


                                //AvailableQty += ILE2."Remaining Quantity";//ILE.Quantity;
                                //TotalReservedQty += GetReservedQtyForTO(ILE."Item No.", ILE."Location Code", ILE."Lot No.", RecTransferLine."Line No.", RecTransferLine."Document No.", ILE."Expiration Date");

                                ReservedQty := GetReservedQtyForTO(ILE."Item No.", ILE."Location Code", ILE."Lot No.", RecTransferLine."Line No.", RecTransferLine."Document No.", ILE."Expiration Date");
                                if (ILE2."Remaining Quantity" - ReservedQty) > 0 then begin
                                    IF RequiredQty >= (ILE2."Remaining Quantity" - ReservedQty) THEN BEGIN//ILE.Quantity THEN
                                        ItemTrackingQty := (ILE2."Remaining Quantity" - ReservedQty); //ILE.Quantity
                                        RequiredQty := RequiredQty - (ILE2."Remaining Quantity" - ReservedQty);
                                    END ELSE begin
                                        ItemTrackingQty := RequiredQty; //SalesInvoiceLine.Quantity;
                                        RequiredQty := 0;
                                    end;

                                    TempReservEntry.DeleteAll();
                                    TempReservEntry.Init();
                                    TempReservEntry."Entry No." := 1;
                                    TempReservEntry."Lot No." := ILE."Lot No.";
                                    TempReservEntry.Quantity := ItemTrackingQty;
                                    TempReservEntry."Expiration Date" := ILE."Expiration Date";
                                    TempReservEntry.INSERT;
                                    CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                                    CreateReservationEntry.CreateReservEntryFor(Database::"Transfer Line", 1, RecTransferLine."Document No.", '', 0, RecTransferLine."Line No.", RecTransferLine."Qty. per Unit of Measure",
                                    TempReservEntry.Quantity, TempReservEntry.Quantity * RecTransferLine."Qty. per Unit of Measure", TempReservEntry);
                                    CreateReservationEntry.CreateEntry(
                                    RecTransferLine."Item No.", RecTransferLine."Variant Code", RecTransferHeader."Transfer-to Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);

                                    CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                                    CreateReservationEntry.CreateReservEntryFor(Database::"Transfer Line", 0, RecTransferLine."Document No.", '', 0, RecTransferLine."Line No.", RecTransferLine."Qty. per Unit of Measure",
                                    TempReservEntry.Quantity, TempReservEntry.Quantity * RecTransferLine."Qty. per Unit of Measure", TempReservEntry);
                                    CreateReservationEntry.CreateEntry(
                                    RecTransferLine."Item No.", RecTransferLine."Variant Code", RecTransferHeader."Transfer-from Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);
                                end;
                            end;


                        /*AvailableQty += ILE."Remaining Quantity";//ILE.Quantity;
                        if not CheckList.Contains(ILE."Item No." + ILE."Lot No." + ILE."Location Code") then begin
                            TotalReservedQty += GetReservedQtyForTO(ILE."Item No.", ILE."Location Code", ILE."Lot No.", RecTransferLine."Line No.", RecTransferLine."Document No.");
                            CheckList.Add(ILE."Item No." + ILE."Lot No." + ILE."Location Code");
                        end;
                        ReservedQty := GetReservedQtyForTO(ILE."Item No.", ILE."Location Code", ILE."Lot No.", RecTransferLine."Line No.", RecTransferLine."Document No.");
                        IF RequiredQty >= (ILE."Remaining Quantity" - ReservedQty) THEN BEGIN//ILE.Quantity THEN
                            ItemTrackingQty := (ILE."Remaining Quantity" - ReservedQty); //ILE.Quantity
                            RequiredQty := RequiredQty - (ILE."Remaining Quantity" - ReservedQty);
                        END ELSE begin
                            ItemTrackingQty := RequiredQty; //SalesInvoiceLine.Quantity;
                            RequiredQty := 0;
                        end;
                        TempReservEntry.DeleteAll();
                        TempReservEntry.Init();
                        TempReservEntry."Entry No." := 1;
                        TempReservEntry."Lot No." := ILE."Lot No.";
                        TempReservEntry.Quantity := ItemTrackingQty;
                        TempReservEntry."Expiration Date" := ILE."Expiration Date";
                        TempReservEntry.INSERT;
                        CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        CreateReservationEntry.CreateReservEntryFor(Database::"Transfer Line", 1, RecTransferLine."Document No.", '', 0, RecTransferLine."Line No.", RecTransferLine."Qty. per Unit of Measure",
                        TempReservEntry.Quantity, TempReservEntry.Quantity * RecTransferLine."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservationEntry.CreateEntry(
                        RecTransferLine."Item No.", RecTransferLine."Variant Code", RecTransferHeader."Transfer-to Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);

                        CreateReservationEntry.SetDates(0D, TempReservEntry."Expiration Date");
                        CreateReservationEntry.CreateReservEntryFor(Database::"Transfer Line", 0, RecTransferLine."Document No.", '', 0, RecTransferLine."Line No.", RecTransferLine."Qty. per Unit of Measure",
                        TempReservEntry.Quantity, TempReservEntry.Quantity * RecTransferLine."Qty. per Unit of Measure", TempReservEntry);
                        CreateReservationEntry.CreateEntry(
                        RecTransferLine."Item No.", RecTransferLine."Variant Code", RecTransferHeader."Transfer-from Code", '', TempReservEntry."Expected Receipt Date", 0D, 0, ReseveStatus::Surplus);*/

                        //UNTIL (ILE.NEXT = 0) OR ((AvailableQty - TotalReservedQty) >= RecTransferLine.Quantity);
                        UNTIL (ILE.NEXT = 0) OR (RequiredQty = 0);
                    RecTransferLine."Lot No. Assigned" := true;
                    RecTransferLine.Modify();
                end;
            UNTIL RecTransferLine.NEXT = 0;
    end;

    local procedure GetReservedQtyForTO(ItemNo: Code[20]; LocationCode: Code[20]; LotNo: code[50]; LineNo: Integer; DocumentNo: Code[20]; expDate: Date): Decimal
    var
        RecResevEntry: Record "Reservation Entry";
    begin
        clear(RecResevEntry);
        RecResevEntry.SetRange("Item No.", ItemNo);
        RecResevEntry.SetRange("Location Code", LocationCode);
        RecResevEntry.SetRange("Lot No.", LotNo);
        RecResevEntry.SetRange("Reservation Status", RecResevEntry."Reservation Status"::Surplus);
        RecResevEntry.SetRange(Positive, false);
        RecResevEntry.SetRange("Expiration Date", expDate);
        //24FEB
        RecResevEntry.SetFilter("Source ID", '<>%1', DocumentNo);
        RecResevEntry.SetFilter("Source Ref. No.", '<>%1', LineNo);
        if RecResevEntry.FindSet() then begin
            RecResevEntry.CalcSums(Quantity);
            exit(abs(RecResevEntry.Quantity));
        end else
            exit(0);
    end;

    var
        HideDialogueBox: Boolean;
        abc: Page 6510;
        ab: page 6500;
}
