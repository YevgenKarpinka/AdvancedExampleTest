table 50102 "Customer Rewards Mgt. Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(2; "Cust. Rewards Ext.Mgt.Cod. ID"; Integer)
        {
            TableRelation = "CodeUnit Metadata".ID;
        }
    }

    keys
    {
        key(PK; "Primary Key")
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