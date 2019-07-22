codeunit 50101 "Customer Rewards Ext. Mgt."
{
    var
        DummySuccessResponseTxt: Label '{"ActivationResponse": "Success"}', Locked = true;
        NoRewardLevelTxt: TextConst ENU = 'NONE';

    procedure IsCustomerRewardsActivated(): Boolean;
    var
        ActivationCodeInfo: Record "Activation Code Information";
    begin
        if not ActivationCodeInfo.FindFirst() then
            exit(false);
        if (ActivationCodeInfo."Date Activated" <= Today) and (Today <= ActivationCodeInfo."Expiration Date") then
            exit(true);
        exit(false);
    end;

    procedure OpenCustomerRewardsWizard();
    var
        CustomerRewardsWizard: Page "Customer Rewards Wizard";
    begin
        CustomerRewardsWizard.RunModal();
    end;

    procedure OpenRewardsLevelPage()
    var
        RewardsLevelPage: Page "Rewards Level List";
    begin
        RewardsLevelPage.Run();
    end;

    procedure GetRewardLevel(RewardPoints: Integer) RewardLevelTxt: Text;
    var
        RewardLevelRec: Record "Reward Level";
        MinRewardLevelPoints: Integer;
    begin
        RewardLevelTxt := NoRewardLevelTxt;
        if RewardLevelRec.IsEmpty then
            exit;
        RewardLevelRec.SetRange("Minimum Reward Points", 0, RewardPoints);
        RewardLevelRec.SetCurrentKey("Minimum Reward Points");
        if RewardPoints >= MinRewardLevelPoints then begin
            RewardLevelRec.Reset();
            RewardLevelRec.SetRange("Minimum Reward Points", MinRewardLevelPoints, RewardPoints);
            RewardLevelRec.SetCurrentKey("Minimum Reward Points");
            RewardLevelRec.FindLast();
            RewardLevelTxt := RewardLevelRec.Level;
        end;
    end;

    procedure ActivateCustomerRewards(ActivationCode: Text): Boolean;
    var
        ActivationCodeInfo: Record "Activation Code Information";
    begin
        OnGetActivationCodeStatusFromServer(ActivationCode);
        exit(ActivationCodeInfo.Get(ActivationCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetActivationCodeStatusFromServer(ActivationCode: Text);
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Customer Rewards Ext. Mgt.", 'OnGetActivationCodeStatusFromServer', '', false, false)]
    local procedure OnGetActivationCodeStatusFromServerSubscriber(ActivationCode: Text);
    var
        ActivationCodeInfo: Record "Activation Code Information";
        ResponseText: Text;
        Result: JsonToken;
        JsonResponse: JsonToken;
    begin
        if not CanHandle() then exit;
        if (GetHttpResponse(ActivationCode, ResponseText)) then begin
            JsonResponse.ReadFrom(ResponseText);
            if JsonResponse.SelectToken('ActivationResponse', Result) then begin
                if (Result.AsValue().AsText() = 'Success') then begin
                    if (ActivationCodeInfo.FindFirst()) then
                        ActivationCodeInfo.Delete();
                    ActivationCodeInfo.Init();
                    ActivationCodeInfo.ActivationCode := ActivationCode;
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CalcDate('<1Y>', Today);
                    ActivationCodeInfo.Insert();
                end;
            end;
        end;
    end;

    local procedure GetHttpResponse(ActivationCode: Text; var ResponseText: Text): Boolean;
    begin
        if ActivationCode = '' then exit(false);
        ResponseText := DummySuccessResponseTxt;
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocSubscriber(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean);
    var
        Customer: Record Customer;
    begin
        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;
        Customer.get(SalesHeader."Sell-to Customer No.");
        Customer.RewardPoints += 1;
        Customer.Modify();
    end;

    local procedure CanHandle(): Boolean;
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
    begin
        if CustomerRewardsExtMgtSetup.Get() then
            exit(CustomerRewardsExtMgtSetup."Cust. Rewards Ext.Mgt.Cod. ID" = codeunit::"Customer Rewards Ext. Mgt.");
    end;
}