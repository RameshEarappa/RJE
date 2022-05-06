codeunit 50035 UpdateFOCBoolean
{
    Permissions = tabledata "Sales Invoice Line" = rimd;
    trigger OnRun()
    begin
        SalesHeader.reset;
        //SalesHeader.setrange("Document Type",SalesHeader."Document Type"::Invoice);
        SalesHeader.SETFILTER("Posting Date", '%1..%2', 20210101D, 20210531D);
        if SalesHeader.findfirst then begin
            repeat
                Focitem := False;
                Salesline.reset;
                //Salesline.SetRange("Document Type",SalesHeader."Document Type");
                Salesline.setrange("Document No.", SalesHeader."No.");
                if Salesline.findfirst then begin
                    repeat
                        Recitem.Reset;
                        if recitem.get(Salesline."No.") then;

                        if recitem."FOC Item" then begin
                            Salesline."FOC Item" := True;
                            Salesline.modify(true);
                        end;
                    until Salesline.next = 0;
                end;
            until SalesHeader.next = 0;
        end;
    end;

    var
        myInt: Integer;
        SalesHeader: Record "Sales Invoice Header";
        Salesline: Record "Sales Invoice Line";
        Recitem: Record item;
        Focitem: Boolean;
}