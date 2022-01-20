tableextension 50028 UserSetup extends "User Setup"
{
    fields
    {
        field(50000; "Enable Error Notification"; Boolean)
        {
            Caption = 'Enable Error Notification';
            DataClassification = ToBeClassified;
        }
        field(50001; "Allow Transfer Order Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}