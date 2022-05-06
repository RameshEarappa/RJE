page 60025 "Phys. Inventory Journal EOD"
{
    AdditionalSearchTerms = 'physical count journal,inventory cycle journal';
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Phy. Inv. Jnl. Day End Process';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Post/Print,Prepare,Line,Item,Item Availability by';
    SaveValues = true;
    SourceTable = "Item Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            //LTRJE080120211827
            GROUP(Filters)
            {
                field("Posting Date Filter"; PostingDateFilter)
                {
                    ApplicationArea = All;
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                    BEGIN
                        IF PostingDateFilter <> 0D THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 24;
                            Rec.SETFILTER("Posting Date", '%1', PostingDateFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 24;
                            Rec.SETRANGE("Posting Date");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    END;
                }
                field("Location Code Filter"; LocationCodeFilter)
                {
                    ApplicationArea = All;
                    TableRelation = Location WHERE("DR Location" = const(true));//Added on 14APR2021-Krishna asper new CR
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                        RecSalesperson: Record "Salesperson/Purchaser";
                        RecLOC: Record Location;
                    BEGIN
                        IF LocationCodeFilter <> '' THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 25;
                            Rec.SETFILTER("Location Code", LocationCodeFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                            //15APR2021
                            Clear(RecLOC);
                            RecLOC.GET(LocationCodeFilter);
                            if RecLOC."Sales Person" <> '' then begin
                                Clear(RecSalesperson);
                                if RecSalesperson.GET(RecLOC."Sales Person") then begin
                                    SalesPersonCode := RecLOC."Sales Person";
                                    SalesPersonName := RecSalesperson.Name;
                                end;
                            end else begin
                                SalesPersonCode := '';
                                SalesPersonName := '';
                            end;
                            //15APR2021
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 25;
                            Rec.SETRANGE("Location Code");
                            Rec.FilterGroup := OriginalFilterGroup;
                            SalesPersonCode := ''; //15APR2021
                            SalesPersonName := ''; //15APR2021
                        END;

                        CurrPage.Update();
                    END;
                }
                Group("Doc Filter")
                {
                    field("Document No Filter"; DocumentNoFilter)
                    {
                        ApplicationArea = All;
                        TRIGGER OnValidate()
                        VAR
                            OriginalFilterGroup: Integer;
                        BEGIN
                            IF DocumentNoFilter <> '' THEN BEGIN
                                OriginalFilterGroup := Rec.FilterGroup;
                                Rec.FilterGroup := 26;
                                Rec.SETFILTER("Document No.", DocumentNoFilter);
                                Rec.FilterGroup := OriginalFilterGroup;
                            END
                            ELSE BEGIN
                                OriginalFilterGroup := Rec.FilterGroup;
                                Rec.FilterGroup := 26;
                                Rec.SETRANGE("Document No.");
                                Rec.FilterGroup := OriginalFilterGroup;
                            END;
                            CurrPage.Update();
                        END;
                    }
                }
            }
            //15APR2021
            group("Salesperson")
            {
                field("Salesperson Code"; SalesPersonCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salesperson Name"; SalesPersonName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            //LTRJE080120211827

            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                //LT05012021
                field(Time; Rec.Time)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                //LT05012021
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;

                    ToolTip = 'Specifies the type of transaction that will be posted from the item journal line.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                    ShowMandatory = true;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item on the journal line.';

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem(Rec."Item No.", ItemDescription);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the item on the journal line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
                    Visible = true;

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    end;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                    Visible = false;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Qty. (Calculated)"; Rec."Qty. (Calculated)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity on hand of the item.';
                }
                field("Qty. (Phys. Inventory)"; Rec."Qty. (Phys. Inventory)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity on hand of the item as determined from a physical count.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of units of the item to be included on the journal line.';
                }
                //LT05012021
                field(Reconciled; Rec.Reconciled)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    ToolTip = 'Specified whether Record is Reconciled If Qty. (Calculated) is equal to Qty. (Phys. Inventory)';
                }
                //LT05012021
                //15APR2021
                field("Transfer Order Created"; Rec."Transfer Order Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Spcifies whether transfer order is created or not.';
                }
                //15APR2021
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the price of one unit of the item on the journal line.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line''s net amount.';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 3);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 4);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 5);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 7);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 8);
                    end;
                }
            }
            group(Control22)
            {
                ShowCaption = false;
                fixed(Control1900669001)
                {
                    ShowCaption = false;
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription; ItemDescription)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the item.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category6;
                    Scope = Repeater;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines(false);
                    end;
                }
                action("Bin Contents")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Bin Contents';
                    Image = BinContent;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code" = FIELD("Location Code"),
                                  "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code");
                    RunPageView = SORTING("Location Code", "Item No.", "Variant Code");
                    Scope = Repeater;
                    ToolTip = 'View items in the bin if the selected line contains a bin code.';
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("Item No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("Phys. In&ventory Ledger Entries")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Phys. In&ventory Ledger Entries';
                    Image = PhysicalInventoryLedger;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Phys. Inventory Ledger Entries";
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.");
                    Scope = Repeater;
                    ToolTip = 'Show the ledger entries for the current journal line.';
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Event';
                        Image = "Event";
                        Promoted = true;
                        PromotedCategory = Category8;
                        Scope = Repeater;
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period';
                        Image = Period;
                        Promoted = true;
                        PromotedCategory = Category8;
                        Scope = Repeater;
                        ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        Promoted = true;
                        PromotedCategory = Category8;
                        Scope = Repeater;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location = R;
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        Promoted = true;
                        PromotedCategory = Category8;
                        Scope = Repeater;
                        ToolTip = 'View the actual and projected quantity of the item per location.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        Promoted = true;
                        PromotedCategory = Category8;
                        Scope = Repeater;
                        ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateInventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate &Inventory';
                    Ellipsis = true;
                    Image = CalculateInventory;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'Start the process of counting inventory by filling the journal with known quantities.';

                    trigger OnAction()
                    begin
                        CalcQtyOnHand.SetItemJnlLine(Rec);
                        CalcQtyOnHand.RunModal;
                        Clear(CalcQtyOnHand);
                    end;
                }
                action(CalculateCountingPeriod)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Calculate Counting Period';
                    Ellipsis = true;
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Scope = Repeater;
                    ToolTip = 'Show all items that a counting period has been assigned to, according to the counting period, the last counting period update, and the current work date.';

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.InitFromItemJnl(Rec);
                        PhysInvtCountMgt.Run;
                        Clear(PhysInvtCountMgt);
                    end;
                }
            }
            //LT05012021
            ACTION("Create Transfer Order")
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = TRUE;
                Image = CreateDocument;
                Promoted = TRUE;
                PromotedCategory = Process;
                ToolTip = 'Creates Transfer Order from VAN to Replenishment Whse. for all the reconciled Physical Inventory Journal at EOD ';
                TRIGGER OnAction()
                VAR
                    ItemJnlLine: Record "Item Journal Line";
                    Location: Record Location;
                    Location2: Record Location;
                    RecLoc: Record location;
                    RecSP: Record "Salesperson/Purchaser";
                    RecSP1: Record "Salesperson/Purchaser";
                    InvtSetup: Record "Inventory Setup";
                    TransferHeader: Record "Transfer Header";
                    TransferLine: Record "Transfer Line";
                    NoSeriesMngnt: Codeunit NoSeriesManagement;
                    WfInitCode: Codeunit "Init Workflow";
                    LineNo: Integer;
                    Text00001: TextConst ENU = 'Transfer Order is Created as %1,Do you want to open the Transfer Order?';
                    IsHandled: Boolean;
                BEGIN
                    if (PostingDateFilter = 0D) OR (LocationCodeFilter = '') then
                        Error('Posting Date and Location Code Filter should not be blank.');
                    ItemJnlLine.RESET;
                    ItemJnlLine.CopyFilters(Rec);
                    ItemJnlLine.SETRANGE(Reconciled, FALSE);
                    IF ItemJnlLine.FINDFIRST THEN
                        ERROR('The Item No. %1 is not reconciled', ItemJnlLine."Item No.");
                    CLEAR(ItemJnlLine);
                    ItemJnlLine.COPYFILTERS(Rec);
                    IF NOT ItemJnlLine.FINDSET THEN
                        EXIT;

                    //15APR2021
                    CLEAR(ItemJnlLine);
                    ItemJnlLine.COPYFILTERS(Rec);
                    ItemJnlLine.SetRange("Transfer Order Created", true);
                    if ItemJnlLine.FindFirst() then
                        if not Confirm('Transfer Order already created. Do you want to create it again?', false) then
                            exit;
                    //15APR2021   
                    CLEAR(ItemJnlLine);
                    ItemJnlLine.COPYFILTERS(Rec);
                    IF ItemJnlLine.FINDSET THEN;

                    Location.RESET;
                    Location.SETRANGE(Code, ItemJnlLine."Location Code");
                    Location.SETRANGE("DR Location", TRUE);
                    Location.SETFILTER("Default Replenishment Whse.", '<>%1', '');
                    IF NOT Location.FINDFIRST THEN
                        ERROR('Define DR Location and Default Replenishment Whse.');
                    Location2.RESET;
                    Location2.SETRANGE("Use As In-Transit", TRUE);
                    IF NOT Location2.FINDFIRST THEN
                        ERROR('There is no In-Transit location defined.');
                    Location.RESET;
                    Location.SETRANGE(Code, ItemJnlLine."Location Code");
                    Location.SETRANGE("DR Location", TRUE);
                    Location.SETFILTER("Default Replenishment Whse.", '<>%1', '');
                    IF Location.FINDFIRST THEN BEGIN
                        InvtSetup.GET;
                        InvtSetup.TESTFIELD("Transfer Order Nos.");
                        CLEAR(ItemJnlLine);
                        ItemJnlLine.COPYFILTERS(Rec);
                        IF ItemJnlLine.FINDSET THEN BEGIN
                            Location2.RESET;
                            Location2.SETRANGE("Use As In-Transit", TRUE);
                            IF Location2.FINDFIRST THEN;

                            RecLoc.Reset;
                            RecLoc.setrange(Code, Location."Default Replenishment Whse.");
                            if RecLoc.findfirst then;

                            TransferHeader.INIT;
                            //TransferHeader."No." := NoSeriesMngnt.GetNextNo(InvtSetup."Transfer Order Nos.", TODAY, TRUE);
                            TransferHeader."No." := 'UL-' + CopyStr(Location."code", StrLen(Location."code") - 4, StrLen(Location.Code)) + '-' + FORMAT(Rec."Posting Date", 0, '<Year,2><Month,2><Day,2>') + '-1';
                            TransferHeader.INSERT(TRUE);
                            TransferHeader.VALIDATE("Transfer-from Code", Location.Code);
                            TransferHeader.VALIDATE("Transfer-to Code", Location."Default Replenishment Whse.");
                            TransferHeader.VALIDATE("In-Transit Code", Location2.Code);
                            TransferHeader.VALIDATE("Posting Date", Rec."Posting Date");
                            TransferHeader.Validate("Shipment Date", Rec."Posting Date");
                            TransferHeader.Validate("Receipt Date", Rec."Posting Date");
                            TransferHeader.Validate("VAN Unloading TO", true);//Added on 10MARCH2021-Krishna
                            TransferHeader.Validate("Workflow Status", TransferHeader."Workflow Status"::Open);//15APR2021
                            TransferHeader.validate("Transfer-From Salesperson Code", Location."Sales Person");
                            RecSp.Reset;
                            if RecSP.get(Location."Sales Person") then;
                            TransferHeader.VALIDATE("Transfer-From Salesperson Name", RecSP.Name);
                            TransferHeader.validate("Salesperson Code", RecLoc."Sales Person");
                            RecSp1.Reset;
                            if RecSP1.get(RecLoc."Sales Person") then;
                            TransferHeader.VALIDATE("Salesperson Name", RecSP1.Name);
                            TransferHeader.MODIFY;
                            REPEAT
                                LineNo += 10000;
                                TransferLine.INIT;
                                TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                                TransferLine.VALIDATE("Line No.", LineNo);
                                TransferLine.INSERT(TRUE);
                                TransferLine.VALIDATE("Item No.", ItemJnlLine."Item No.");
                                TransferLine.VALIDATE(Quantity, ItemJnlLine."Qty. (Phys. Inventory)");
                                TransferLine.MODIFY;
                                //15APR2021
                                ItemJnlLine.Validate("Transfer Order No.", TransferHeader."No.");
                                ItemJnlLine.Validate("Transfer Order Created", true);
                                ItemJnlLine.Modify();
                            //15APR2021 
                            UNTIL ItemJnlLine.NEXT = 0;
                            //IF NOT CONFIRM(Text00001, FALSE, TransferHeader."No.") THEN//15APR2021
                            //  EXIT;//15APR2021
                            //COMMIT;//15APR2021
                            //15APR2021
                            OnBeforeSendApprovalRequest(Rec, TransferHeader, IsHandled);
                            if not IsHandled then begin
                                if WfInitCode.CheckWorkflowEnabled(TransferHeader) then begin
                                    WfInitCode.OnSendApproval_TO(TransferHeader);
                                end;
                            end;
                            IF NOT CONFIRM(Text00001, FALSE, TransferHeader."No.") THEN//15APR2021
                                EXIT;
                            Commit();
                            PAGE.RunModal(5740, TransferHeader);
                            //  SAME CODE IS WRITTEN IN "RJE JOB AUTOMATION" EXTENSION TO AUTOMATE THIS FUNCTIONALITY
                        END
                    END;
                END;
            }
            //LT05012021
            /*
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                Scope = Repeater;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    ItemJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                    REPORT.RunModal(REPORT::"Phys. Inventory List", true, false, ItemJournalBatch);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    Scope = Repeater;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            */
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ItemJnlMgt.GetItem(Rec."Item No.", ItemDescription);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin
        Commit();
        if not ReserveItemJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
        RecLocation: Record Location;
        RecSalesperson: Record "Salesperson/Purchaser";
        OriginalFilterGroup: Integer;
    begin
        SetDimensionsVisibility;

        if Rec.IsOpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ItemJnlMgt.TemplateSelection(PAGE::"Phys. Inventory Journal", 2, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
        //LTRJE08012021
        CLEAR(DocumentNoFilter);
        CLEAR(PostingDateFilter);
        CLEAR(LocationCodeFilter);
        Clear(SalesPersonCode);
        Clear(SalesPersonName);
        //LTRJE08012021
        //15APR2021
        PostingDateFilter := WorkDate();
        OriginalFilterGroup := Rec.FilterGroup;
        Rec.FilterGroup := 24;
        Rec.SETFILTER("Posting Date", '%1', PostingDateFilter);
        Rec.FilterGroup := OriginalFilterGroup;

        Clear(RecLocation);
        RecLocation.SetRange("DR Location", true);
        if RecLocation.FindFirst() then begin
            LocationCodeFilter := RecLocation.Code;
            Clear(RecSalesperson);
            if RecSalesperson.GET(RecLocation."Sales Person") then begin
                SalesPersonCode := RecLocation."Sales Person";
                SalesPersonName := RecSalesperson.Name;
            end;
            OriginalFilterGroup := Rec.FilterGroup;
            Rec.FilterGroup := 25;
            Rec.SETFILTER("Location Code", LocationCodeFilter);
            Rec.FilterGroup := OriginalFilterGroup;
        end;
        //15APR2021
    end;

    var
        ItemJournalBatch: Record "Item Journal Batch";
        CalcQtyOnHand: Report "Calculate Inventory EOD";
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[100];
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        PostingDateFilter: Date;
        DocumentNoFilter: Code[20];
        LocationCodeFilter: Code[20];
        //15APR2021
        SalesPersonCode: Code[20];
        SalesPersonName: Text[50];


    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var ItemJournalLine: Record "Item Journal Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeSendApprovalRequest(Var Rec: Record "Item Journal Line"; Var Transferheader: Record "Transfer Header"; Var IsHandled: Boolean)
    begin
    end;
}

