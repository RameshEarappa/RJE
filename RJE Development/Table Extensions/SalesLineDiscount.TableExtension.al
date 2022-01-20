tableextension 50036 SalesLineDiscount_Ext extends "Sales Line Discount"
{
    fields
    {
        field(50000; "Promotion Code"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}