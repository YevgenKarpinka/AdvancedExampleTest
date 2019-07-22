tableextension 50100 "Customer Table Ext." extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(10000; RewardLevel; Text[20])
        {
            Editable = false;
        }
        field(10001; RewardPoints; Integer)
        {
            MinValue = 0;
        }
    }

    var
        myInt: Integer;
}