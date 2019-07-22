codeunit 50100 "Customer Rewards Install Logic"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    begin
        SetDefaultCustomerRewardsExtMgtCodeunit();
    end;

    procedure SetDefaultCustomerRewardsExtMgtCodeunit();
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
    begin
        CustomerRewardsExtMgtSetup.DeleteAll();
        CustomerRewardsExtMgtSetup.Init();
        CustomerRewardsExtMgtSetup."Cust. Rewards Ext.Mgt.Cod. ID" := Codeunit::"Customer Rewards Ext. Mgt.";
        CustomerRewardsExtMgtSetup.Insert();
    end;
}