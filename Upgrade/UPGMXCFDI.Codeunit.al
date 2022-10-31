codeunit 104151 "UPG. MX CFDI"
{
    Subtype = Upgrade;

    trigger OnRun()
    begin
    end;

    trigger OnUpgradePerCompany()
    begin
        UpdateSATCatalogs;
        UpdateCFDIFields;
        UpdateCFDIEnabled();
    end;

    local procedure UpdateSATCatalogs()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefCountry: Codeunit "Upgrade Tag Def - Country";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefCountry.GetSATPaymentCatalogsSwapTag()) then
            exit;

        Codeunit.Run(Codeunit::"Update SAT Payment Catalogs");

        UpgradeTag.SetUpgradeTag(UpgradeTagDefCountry.GetSATPaymentCatalogsSwapTag());
    end;

    local procedure UpdateCFDIFields()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefCountry: Codeunit "Upgrade Tag Def - Country";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefCountry.GetCFDIPurposeRelationFieldsDocUpdateTag()) then
            exit;

        Codeunit.Run(Codeunit::"Update CFDI Fields Sales Doc");

        UpgradeTag.SetUpgradeTag(UpgradeTagDefCountry.GetCFDIPurposeRelationFieldsDocUpdateTag());
    end;

    local procedure UpdateCFDIEnabled()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefCountry: Codeunit "Upgrade Tag Def - Country";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefCountry.GetCFDIEnableOptionUpgradeTag()) then
            exit;

        if GeneralLedgerSetup.Get() then begin
            GeneralLedgerSetup."CFDI Enabled" :=
                GeneralLedgerSetup."PAC Environment" in [GeneralLedgerSetup."PAC Environment"::Test, GeneralLedgerSetup."PAC Environment"::Production];
            GeneralLedgerSetup.Modify();
        end;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefCountry.GetCFDIEnableOptionUpgradeTag());
    end;
}
