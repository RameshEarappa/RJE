pageextension 50013 "Customer Price Group" extends "Customer Price Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Mirnah Id"; Rec."Mirnah Id")
            {
                ApplicationArea = All;
            }
        }
    }
}
