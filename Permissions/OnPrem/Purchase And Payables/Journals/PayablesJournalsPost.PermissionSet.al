permissionset 3602 "Payables Journals - Post"
{
    Access = Public;
    Assignable = false;
    Caption = 'Post journals (P&P)';

    Permissions = tabledata "Accounting Period" = r,
                  tabledata "ACH Cecoban Detail" = RIMD,
                  tabledata "ACH Cecoban Footer" = RIMD,
                  tabledata "ACH Cecoban Header" = RIMD,
                  tabledata "ACH RB Detail" = RIMD,
                  tabledata "ACH RB Footer" = RIMD,
                  tabledata "ACH RB Header" = RIMD,
                  tabledata "ACH US Detail" = RIMD,
                  tabledata "ACH US Footer" = RIMD,
                  tabledata "ACH US Header" = RIMD,
                  tabledata "Analysis View" = rimd,
                  tabledata "Analysis View Entry" = rim,
                  tabledata "Analysis View Filter" = r,
                  tabledata "Bank Account" = m,
                  tabledata "Bank Account Ledger Entry" = rim,
                  tabledata "Batch Processing Parameter" = Rimd,
                  tabledata "Batch Processing Session Map" = Rimd,
                  tabledata "Check Ledger Entry" = rim,
                  tabledata Currency = r,
                  tabledata "Currency Exchange Rate" = r,
                  tabledata "Date Compr. Register" = r,
                  tabledata "Detailed Vendor Ledg. Entry" = ri,
                  tabledata "Dimension Combination" = R,
                  tabledata "Dimension Value Combination" = R,
                  tabledata "Dynamic Request Page Entity" = R,
                  tabledata "Dynamic Request Page Field" = R,
                  tabledata "EFT Export" = RIMD,
                  tabledata "EFT Export Workset" = RIMD,
                  tabledata "Employee Ledger Entry" = rim,
                  tabledata "Employee Posting Group" = R,
                  tabledata "G/L Account" = R,
                  tabledata "G/L Entry - VAT Entry Link" = Ri,
                  tabledata "G/L Entry" = Ri,
                  tabledata "G/L Register" = Rim,
                  tabledata "Gen. Jnl. Allocation" = RIMD,
                  tabledata "Gen. Journal Batch" = RID,
                  tabledata "Gen. Journal Line" = RIMD,
                  tabledata "Gen. Journal Template" = RI,
                  tabledata "General Ledger Setup" = r,
                  tabledata "General Posting Setup" = r,
#if not CLEAN20
                  tabledata "Native - Payment" = RIMD,
#endif
                  tabledata "Notification Entry" = Rimd,
                  tabledata "Restricted Record" = Rimd,
                  tabledata "Reversal Entry" = RIMD,
                  tabledata "Sent Notification Entry" = Rimd,
                  tabledata "Source Code Setup" = R,
                  tabledata "Tax Area" = R,
                  tabledata "Tax Area Line" = R,
                  tabledata "Tax Detail" = R,
                  tabledata "Tax Group" = R,
                  tabledata "Tax Jurisdiction" = R,
                  tabledata "User Setup" = r,
                  tabledata "VAT Assisted Setup Bus. Grp." = R,
                  tabledata "VAT Assisted Setup Templates" = R,
                  tabledata "VAT Entry" = Ri,
                  tabledata "VAT Posting Setup" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Reporting Code" = R,
                  tabledata "VAT Setup Posting Groups" = R,
                  tabledata Vendor = r,
                  tabledata "Vendor Bank Account" = R,
                  tabledata "Vendor Ledger Entry" = rim,
                  tabledata "Vendor Posting Group" = R,
                  tabledata "Workflow - Record Change" = Rimd,
                  tabledata "Workflow - Table Relation" = R,
                  tabledata Workflow = R,
                  tabledata "Workflow Buffer" = RIMD,
                  tabledata "Workflow Category" = R,
                  tabledata "Workflow Event" = R,
                  tabledata "Workflow Event Queue" = Rimd,
                  tabledata "Workflow Record Change Archive" = Rimd,
                  tabledata "Workflow Response" = R,
                  tabledata "Workflow Rule" = Rimd,
                  tabledata "Workflow Step" = R,
                  tabledata "Workflow Step Argument" = Rimd,
                  tabledata "Workflow Step Argument Archive" = Rimd,
                  tabledata "Workflow Step Instance" = Rimd,
                  tabledata "Workflow Step Instance Archive" = Rimd,
                  tabledata "Workflow Table Relation Value" = Rimd,
                  tabledata "Workflow User Group" = R,
                  tabledata "Workflow User Group Member" = R;
}
