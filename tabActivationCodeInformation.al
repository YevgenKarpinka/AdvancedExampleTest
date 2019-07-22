table 50101 "Activation Code Information"
{
    fields
    {
        field(1; ActivationCode; Text[4])
        {
            Description = 'Activation code used to activate Customer Rewards';
        }
        field(2; "Date Activated"; Date)
        {
            Description = 'Date Customer Rewards was activated';
        }
        field(3; "Expiration Date"; Date)
        {
            Description = 'Date Customer Rewards activation expires';
        }
    }

    keys
    {
        key(PK; ActivationCode)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}