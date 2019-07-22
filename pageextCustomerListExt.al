pageextension 50101 "Customer List Ext." extends "Customer List"
{
    actions
    {
        // Add changes to page actions here
        addfirst("&Customer")
        {
            action("Reward Level")
            {
                ApplicationArea = All;
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the list of reward levels.';

                trigger OnAction();
                begin
                    if CustomerRewardsExtMgt.IsCustomerRewardsActivated() then
                        CustomerRewardsExtMgt.OpenRewardsLevelPage()
                    else
                        CustomerRewardsExtMgt.OpenCustomerRewardsWizard();
                end;
            }
        }
    }

    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt.";
}