page 50101 "Rewards Level List"
{
    PageType = List;
    ContextSensitiveHelpPage = 'sales-rewards';
    SourceTable = "Reward Level";
    SourceTableView = sorting ("Minimum Reward Points") order(ascending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Level; Level)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the level of reward that the customer has at this point.';
                }
                field("Minimum Reward Points"; "Minimum Reward Points")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of points that customer must have to reach this level.';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        if (not CustomerRewardsExtMgt.IsCustomerRewardsActivated()) then
            Error(NotActivatedTxt);
    end;

    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt.";
        NotActivatedTxt: Label 'Customer Rewards is not activated';
}