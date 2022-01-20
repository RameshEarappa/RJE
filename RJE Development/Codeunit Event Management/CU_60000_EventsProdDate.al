CODEUNIT 60000 "Event Subscriber Prod Date"
{
    TRIGGER OnRun()
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    LOCAL PROCEDURE ItemTrackingLinesOnRegisterChangeOnAfterCreateReservEntry(VAR ReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification")
    BEGIN
        ReservEntry."Production Date" := OldTrackingSpecification."Production Date";
        ReservEntry.Modify();
    END;

    [EventSubscriber(ObjectType::table, database::"Tracking Specification", 'OnAfterValidateEvent', 'Lot No.', false, false)]
    LOCAL PROCEDURE TrackingSpecificationLotNoOnAfterValidateEvent(VAR Rec: Record "Tracking Specification")
    VAR
        ItemLedgerEntry: Record "Item Ledger Entry";
    BEGIN
        IF Rec.GetLotSNDataSet(Rec."Item No.",
                                         Rec."variant Code",
                                         Rec."Lot No.",
                                         Rec."Serial No.",
                                         ItemLedgerEntry) THEN
            Rec."Production Date" := ItemLedgerEntry."Production Date";
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry";
                                         ReservEntry2: Record "Reservation Entry";
                                         VAR IdenticalArray: array[2] of Boolean);
    BEGIN
        IdenticalArray[2] := IdenticalArray[2] AND (ReservEntry1."Production Date" = ReservEntry2."Production Date");
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCreateReservEntryFor', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterCreateReservEntryFor(VAR OldTrackingSpecification: Record "Tracking Specification";
                                          VAR NewTrackingSpecification: Record "Tracking Specification");
    BEGIN
        OldTrackingSpecification."Production Date" := NewTrackingSpecification."Production Date";
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterCopyTrackingSpec(VAR DestTrkgSpec: Record "Tracking Specification";
                                      VAR SourceTrackingSpec: Record "Tracking Specification");
    BEGIN
        DestTrkgSpec."Production Date" := SourceTrackingSpec."Production Date";
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    LOCAL PROCEDURE ItemJnlPostLineOnBeforeInsertSetupTempSplitItemJnlLine(VAR TempTrackingSpecification: Record "Tracking Specification"; VAR TempItemJournalLine: Record "Item Journal Line")
    BEGIN
        TempItemJournalLine."Production Date" := TempTrackingSpecification."Production Date";
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterClearTrackingSpec', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterClearTrackingSpec(VAR OldTrkgSpec: Record "Tracking Specification");
    BEGIN
        OldTrkgSpec."Production Date" := 0D;
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterMoveFields(VAR TrkgSpec: Record "Tracking Specification";
                                VAR ReservEntry: Record "Reservation Entry");
    BEGIN
        ReservEntry."Production Date" := TrkgSpec."Production Date";
    END;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeAddToGlobalRecordSet', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnBeforeAddToGlobalRecordSet(VAR TrackingSpecification: Record "Tracking Specification");
    VAR
        ItemLedgerEntry: Record "Item Ledger Entry";
    BEGIN
        IF TrackingSpecification.GetLotSNDataSet(TrackingSpecification."Item No.",
                                                 TrackingSpecification."VARiant Code",
                                                 TrackingSpecification."Lot No.",
                                                 TrackingSpecification."Serial No.",
                                                 ItemLedgerEntry) THEN
            TrackingSpecification."Production Date" := ItemLedgerEntry."Production Date";
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record "Item Ledger Entry";
                                       ItemJournalLine: Record "Item Journal Line";
                                       VAR ItemLedgEntryNo: Integer);
    BEGIN
        NewItemLedgEntry."Production Date" := ItemJournalLine."Production Date";
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', FALSE, FALSE)]
    LOCAL PROCEDURE OnBeforeInsertSetupTempSplitItemJnlLine(VAR TempTrackingSpecification: Record "Tracking Specification";
                                       VAR TempItemJournalLine: Record "Item Journal Line";
                                       VAR ItemJournalLine2: Record "Item Journal Line";
                                       VAR PostItemJnlLine: Boolean);
    BEGIN
        TempItemJournalLine."Production Date" := TempTrackingSpecification."Production Date";
    END;


    var
        myInt: Integer;
}