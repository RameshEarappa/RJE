pageextension 50026 Bins extends Bins
{
    layout
    {
        addafter(Description)
        {
            field("Good For Sales"; Rec."Good For Sales")
            {
                ApplicationArea = All;
            }
        }
    }
}
