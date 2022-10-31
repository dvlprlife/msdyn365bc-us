permissionset 242 "D365 JOURNALS, EDIT"
{
    Assignable = true;

    Caption = 'Dynamics 365 Edit journals';
    Permissions = tabledata "Bank Account" = R,
                  tabledata Bin = R,
                  tabledata "Check Ledger Entry" = Rimd,
                  tabledata "Cust. Ledger Entry" = Rm,
                  tabledata "Detailed Cust. Ledg. Entry" = Rm,
                  tabledata "Detailed Employee Ledger Entry" = Rm,
                  tabledata "Detailed Vendor Ledg. Entry" = Rm,
                  tabledata "Employee Ledger Entry" = Rm,
                  tabledata "G/L Register" = Rimd,
                  tabledata "Gen. Journal Line" = RIMD,
                  tabledata "Intrastat Jnl. Line" = RIMD,
                  tabledata "Item Entry Relation" = R,
                  tabledata "Item Journal Line" = RIMD,
                  tabledata "Item Tracing Buffer" = Rimd,
                  tabledata "Item Tracing History Buffer" = Rimd,
                  tabledata "Item Tracking Code" = R,
                  tabledata "Lot No. Information" = RIMD,
                  tabledata "Package No. Information" = RIMD,
                  tabledata "Phys. Invt. Counting Period" = RIMD,
                  tabledata "Phys. Invt. Item Selection" = RIMD,
                  tabledata "Planning Component" = Rm,
                  tabledata "Post Value Entry to G/L" = i,
                  tabledata "Record Buffer" = Rimd,
                  tabledata "Serial No. Information" = RIMD,
                  tabledata "Standard General Journal Line" = RIMD,
                  tabledata "Standard Item Journal" = RIMD,
                  tabledata "Standard Item Journal Line" = RIMD,
                  tabledata "Stockkeeping Unit" = R,
                  tabledata "Tracking Specification" = Rimd,
                  tabledata "Transaction Type" = R,
                  tabledata "Transport Method" = R,
                  tabledata "Value Entry Relation" = R,
                  tabledata "VAT Rate Change Conversion" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Registration No. Format" = R,
                  tabledata "Vendor Invoice Disc." = R,
                  tabledata "Vendor Ledger Entry" = Rm,
                  tabledata "Whse. Item Entry Relation" = R;
}