codeunit 50000 DimensionMgmt_LT
{
    trigger OnRun()
    begin

    end;

    procedure ValidateShortcutDimValues(DimensionCode: Code[20]; var DimValueCode: Code[20]; var DimSetID: Integer)
    var
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgmt: Codeunit DimensionManagement;
    begin
        ValidateDimValueCodeLT(DimensionCode, DimValueCode);
        DimVal."Dimension Code" := DimensionCode;
        if DimValueCode <> '' then begin
            DimVal.Get(DimVal."Dimension Code", DimValueCode);
            if not DimMgmt.CheckDim(DimVal."Dimension Code") then
                Error(DimMgmt.GetDimErr);
            if not DimMgmt.CheckDimValue(DimVal."Dimension Code", DimValueCode) then
                Error(DimMgmt.GetDimErr);
        end;
        DimMgmt.GetDimensionSet(TempDimSetEntry, DimSetID);
        if TempDimSetEntry.Get(TempDimSetEntry."Dimension Set ID", DimVal."Dimension Code") then
            if TempDimSetEntry."Dimension Value Code" <> DimValueCode then
                TempDimSetEntry.Delete();
        if DimValueCode <> '' then begin
            TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code" := DimVal.Code;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            if TempDimSetEntry.Insert() then;
        end;
        DimSetID := DimMgmt.GetDimensionSetID(TempDimSetEntry);

    end;

    local procedure ValidateDimValueCodeLT(DimensionCode: Code[20]; var DimValueCode: Code[20])
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        IsHandled: Boolean;
        Text002: Label 'This Shortcut Dimension is not defined in the %1.';
        Text003: Label '%1 is not an available %2 for that dimension.';
    begin
        GLSetup.Get();
        if (DimensionCode = '') and (DimValueCode <> '') then
            Error(Text002, GLSetup.TableCaption);
        DimVal.SetRange("Dimension Code", DimensionCode);
        if DimValueCode <> '' then begin
            DimVal.SetRange(Code, DimValueCode);
            if not DimVal.FindFirst then begin
                DimVal.SetFilter(Code, StrSubstNo('%1*', DimValueCode));
                if DimVal.FindFirst then
                    DimValueCode := DimVal.Code
                else
                    Error(
                      Text003,
                      DimValueCode, DimVal.FieldCaption(Code));
            end;
        end;
    end;


    procedure ValidateCustomShortcutDimCode(TableNo: Integer; PK: Code[20]; DimensionCode: Code[20]; DimensionValCode: Code[20])
    var
        DefaultDim: Record "Default Dimension";
        IsHandled: Boolean;
    begin
        if DimensionValCode <> '' then begin
            if DefaultDim.Get(TableNo, PK, DimensionCode) then begin
                DefaultDim.Validate("Dimension Value Code", DimensionValCode);
                DefaultDim.Modify();
            end else begin
                DefaultDim.Init();
                DefaultDim.Validate("Table ID", TableNo);
                DefaultDim.Validate("No.", PK);
                DefaultDim.Validate("Dimension Code", DimensionCode);
                DefaultDim.Validate("Dimension Value Code", DimensionValCode);
                DefaultDim.Insert();
            end;
        end else
            if DefaultDim.Get(TableNo, PK, DimensionCode) then
                DefaultDim.Delete();
    end;


    procedure UpdateCustomDimensionCode(DimensionCode: code[20]; TableNo: Integer; No: Code[20]; DimensionValCode: Code[20]);
    Var
    begin
        case TableNo of
            Database::Customer:
                UpdateCustomDimensionOfCustomer(No, DimensionCode, DimensionValCode);
            Database::Item:
                UpdateCustomDimensionOfItem(No, DimensionCode, DimensionValCode);
            else
                exit;
        End;

    end;

    local procedure UpdateCustomDimensionOfCustomer(No: code[20]; DimensionCode: code[20]; DimensionValueCode: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        RecCust: Record Customer;
    begin
        GLSetup.Get();
        RecCust.GET(No);
        case DimensionCode of
            GLSetup."Customer Type":
                RecCust."Customer Type" := DimensionValueCode;
            GLSetup."Shortcut Dimension 5 Code":
                RecCust."Key Account" := DimensionValueCode;
            GLSetup."Shortcut Dimension 3 Code":
                RecCust."Sales Channel Type" := DimensionValueCode;
            GLSetup."Sales Potential":
                RecCust."Sales Potential" := DimensionValueCode;
            GLSetup."Sales Order Type":
                RecCust."Sales Order Type" := DimensionValueCode;
            GLSetup.Status:
                RecCust."Status" := DimensionValueCode;
            GLSetup."Consumer Group":
                RecCust."Consumer Group" := DimensionValueCode;
            GLSetup."Sales Price Group":
                RecCust."Sales Price Group" := DimensionValueCode;
            GLSetup."Sales Promotion Group":
                RecCust."Sales Promotion Group" := DimensionValueCode;
            GLSetup."Shortcut Dimension 4 Code":
                RecCust.Branch := DimensionValueCode;
            GLSetup.Territory:
                RecCust.Territory := DimensionValueCode;
            GLSetup."Shortcut Dimension 2 Code":
                RecCust."RCS Code" := DimensionValueCode;
            GLSetup."Sub-Branch":
                RecCust."Sub-Branch" := DimensionValueCode;
        end;
        RecCust.Modify();
    end;

    local procedure UpdateCustomDimensionOfItem(No: code[20]; DimensionCode: code[20]; DimensionValueCode: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        RecItem: Record Item;
    begin
        GLSetup.Get();
        RecItem.GET(No);
        Case DimensionCode of
            GLSetup."Shortcut Dimension 6 Code":
                RecItem.Brand := DimensionValueCode;
            GLSetup.Portfolio:
                RecItem.Portfolio := DimensionValueCode;
            GLSetup.Category:
                RecItem.Category := DimensionValueCode;
            GLSetup."Product Type":
                RecItem."Product Type" := DimensionValueCode;
            GLSetup.Size:
                RecItem.Size := DimensionValueCode;
            GLSetup."Pack Size":
                RecItem."Pack Size" := DimensionValueCode;
            GLSetup."Consumer Profile":
                RecItem."Consumer profile" := DimensionValueCode;
            GLSetup."Sales Pricing Group":
                RecItem."Sales Pricing Group" := DimensionValueCode;
            GLSetup."Flavor Type":
                RecItem."Flavor Type" := DimensionValueCode;
            GLSetup."Nicotine Mg":
                RecItem."Nicotine Mg" := DimensionValueCode;
            GLSetup."Nicotine Color":
                RecItem."Nicotine Color" := DimensionValueCode;
            GLSetup.Special:
                RecItem.Special := DimensionValueCode;
            GLSetup."Brand Type":
                RecItem."Brand Type" := DimensionValueCode;
            GLSetup."SOA Group":
                RecItem."SOA Group" := DimensionValueCode;
            GLSetup."Shortcut Dimension 7 Code":
                RecItem."Product Reporting Group" := DimensionValueCode;
            GLSetup."Shortcut Dimension 8 Code":
                RecItem."SKU Reporting Group" := DimensionValueCode;
        end;
        RecItem.Modify();
    end;

    procedure GetGlobalDimensionNo_LT("Dimension Code": code[20]): Integer
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        case "Dimension Code" of
            GeneralLedgerSetup."Global Dimension 1 Code":
                exit(1);
            GeneralLedgerSetup."Global Dimension 2 Code":
                exit(2);
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                exit(3);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                exit(4);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                exit(5);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                exit(6);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                exit(7);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                exit(8);
            GeneralLedgerSetup."Customer Type":
                exit(9);
            GeneralLedgerSetup."Sales Potential":
                exit(13);
            GeneralLedgerSetup."Sales Order Type":
                exit(15);
            GeneralLedgerSetup.Status:
                exit(16);
            GeneralLedgerSetup."Sub-Branch":
                exit(17);
            //Item dimensions
            GeneralLedgerSetup.Portfolio:
                exit(19);
            GeneralLedgerSetup.Category:
                exit(20);
            GeneralLedgerSetup."Product Type":
                exit(21);
            GeneralLedgerSetup.Size:
                exit(22);
            GeneralLedgerSetup."Pack Size":
                exit(23);
            GeneralLedgerSetup."Consumer Profile":
                exit(24);
            GeneralLedgerSetup."Sales Pricing Group":
                exit(25);
            GeneralLedgerSetup."Flavor Type":
                exit(26);
            GeneralLedgerSetup."Nicotine Mg":
                exit(27);
            GeneralLedgerSetup."Nicotine Color":
                exit(28);
            GeneralLedgerSetup.Special:
                exit(29);
            GeneralLedgerSetup."SOA Group":
                exit(30);
            GeneralLedgerSetup."Brand Type":
                exit(31);
            //Modified on 11NOV2020
            GeneralLedgerSetup."Consumer Group":
                exit(34);
            GeneralLedgerSetup."Sales Price Group":
                exit(35);
            GeneralLedgerSetup."Sales Promotion Group":
                exit(36);
            GeneralLedgerSetup.Territory:
                exit(38);
            else
                exit(0);
        end;
    end;

    var
        myInt: Integer;
}