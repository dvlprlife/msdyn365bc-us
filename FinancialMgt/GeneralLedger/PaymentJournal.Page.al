page 256 "Payment Journal"
{
    AdditionalSearchTerms = 'print check,payment file export,electronic payment';
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Payment Journals';
    DataCaptionExpression = DataCaption();
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    SetControlAppearanceFromBatch();
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Invoice Received Date"; Rec."Invoice Received Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was received.';
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a document number for the journal line.';
                    ShowMandatory = true;
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the incoming document that this general journal line is created for.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Incoming Document Entry No." > 0 then
                            HyperLink(Rec.GetIncomingDocumentURL());
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        EnableApplyEntriesAction();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        CurrPage.SaveRecord();
                    end;
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = RecipientBankAccountMandatory;
                    ToolTip = 'Specifies the bank account that the amount will be transferred to after it has been exported from the payment journal.';
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the campaign that the journal line is linked to.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal() = ACTION::OK then
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of transaction.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = IsPostingGroupEditable;
                    ToolTip = 'Specifies the posting group that will be used in posting the journal line.The field is used only if the account type is either customer or vendor.';
                    Visible = IsPostingGroupEditable;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of.';
                    Visible = AmountVisible;

                    trigger OnValidate()
                    begin
                        CheckAmountMatchedToAppliedLines();
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckAmountMatchedToAppliedLines();
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                    Visible = DebitCreditVisible;

                    trigger OnValidate()
                    begin
                        CheckAmountMatchedToAppliedLines();
                    end;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                    Visible = DebitCreditVisible;

                    trigger OnValidate()
                    begin
                        CheckAmountMatchedToAppliedLines();
                    end;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of VAT that is included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount"; Rec."Bal. VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of Bal. VAT included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference"; Rec."Bal. VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';

                    trigger OnValidate()
                    begin
                        EnableApplyEntriesAction();
                    end;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group"; Rec."Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group"; Rec."Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Applied (Yes/No)"; IsApplied())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied (Yes/No)';
                    ToolTip = 'Specifies if the payment has been applied.';
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field(AppliesToDocNo; "Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                field(GetAppliesToDocDueDate; GetAppliesToDocDueDate())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applies-to Doc. Due Date';
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date from the Applies-to Doc. on the journal line.';
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the journal line.';
                }
                field("Foreign Exchange Indicator"; Rec."Foreign Exchange Indicator")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an exchange indicator for the journal line. This is a required field. You can edit this field in the Purchase Journal window.';
                    Visible = false;
                }
                field("Foreign Exchange Ref.Indicator"; Rec."Foreign Exchange Ref.Indicator")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an exchange reference indicator for the journal line. This is a required field. You can edit this field in the Purchase Journal and the Payment Journal window.';
                    Visible = false;
                }
                field("Foreign Exchange Reference"; Rec."Foreign Exchange Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a foreign exchange reference code. This is a required field. You can edit this field in the Purchase Journal window.';
                    Visible = false;
                }
                field("Origin. DFI ID Qualifier"; Rec."Origin. DFI ID Qualifier")
                {
                    ApplicationArea = BasicMX;
                    ToolTip = 'Specifies the financial institution that will initiate the payment transactions sent by the originator. Select an ID for the originator''s Designated Financial Institution (DFI). This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Receiv. DFI ID Qualifier"; Rec."Receiv. DFI ID Qualifier")
                {
                    ApplicationArea = BasicMX;
                    ToolTip = 'Specifies the financial institution that will receive the payment transactions. Select an ID for the receiver''s Designated Financial Institution (DFI). This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Transaction Type Code"; Rec."Transaction Type Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a transaction type code for the general journal line. This code identifies the transaction type for the Electronic Funds Transfer (EFT).';
                }
                field("Gateway Operator OFAC Scr.Inc"; Rec."Gateway Operator OFAC Scr.Inc")
                {
                    ApplicationArea = BasicUS;
                    ToolTip = 'Specifies an Office of Foreign Assets Control (OFAC) gateway operator screening indicator. This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Secondary OFAC Scr.Indicator"; Rec."Secondary OFAC Scr.Indicator")
                {
                    ApplicationArea = BasicUS;
                    ToolTip = 'Specifies a secondary Office of Foreign Assets Control (OFAC) gateway operator screening indicator. This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a transaction code for the general journal line. This code identifies the transaction type for the Electronic Funds Transfer (EFT).';
                    Visible = false;
                }
                field("Company Entry Description"; Rec."Company Entry Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a company description for the journal line.';
                    Visible = false;
                }
                field("Payment Related Information 1"; Rec."Payment Related Information 1")
                {
                    ToolTip = 'Specifies payment related information for the general journal line.';
                    Visible = false;
                }
                field("Payment Related Information 2"; Rec."Payment Related Information 2")
                {
                    ToolTip = 'Specifies additional payment related information for the general journal line.';
                    Visible = false;
                }
                field("Check Printed"; Rec."Check Printed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether a check has been printed for the amount on the payment journal line.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account type of the customer or vendor that the payment relates to.';
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer or vendor that the payment relates to.';
                    Visible = false;
                }
                field(CommentField; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a comment about the activity on the journal line. Note that the comment is not carried forward to posted entries.';
                    Visible = false;
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the payment journal line was exported to a payment file.';
                    Visible = false;
                }
                field(TotalExportedAmount; Rec.TotalExportedAmount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Exported Amount';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount for the payment journal line that has been exported to payment files that are not canceled.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownExportedAmount();
                    end;
                }
                field("Has Payment Export Error"; Rec."Has Payment Export Error")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that an error occurred when you used the Export Payments to File function in the Payment Journal window.';
                    Visible = false;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the status of a job queue entry or task that handles the posting of general journals.';
                    Visible = JobQueuesUsed;

                    trigger OnDrillDown()
                    var
                        JobQueueEntry: Record "Job Queue Entry";
                    begin
                        if Rec."Job Queue Status" = Rec."Job Queue Status"::" " then
                            exit;
                        JobQueueEntry.ShowStatusMsg(Rec."Job Queue Entry ID");
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 3);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 4);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 5);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 7);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);

                        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 8);
                    end;
                }
                field("Remit-to Code"; Rec."Remit-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address for the remit-to code.';
                    Visible = true;
                    TableRelation = "Remit Address".Code WHERE("Vendor No." = FIELD("Account No."));
                }
            }
            group(Control24)
            {
                ShowCaption = false;
                fixed(Control1903561801)
                {
                    ShowCaption = false;
                    group("Number of Lines")
                    {
                        Caption = 'Number of Lines';
                        field(NumberOfJournalRecords; NumberOfRecords)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            ShowCaption = false;
                            Editable = false;
                            ToolTip = 'Specifies the number of lines in the current journal batch.';
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        Visible = false;
                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        Visible = false;
                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Control1900545401)
                    {
                        Caption = 'Balance';
                        field(Balance; Balance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the payment journal on the line where the cursor is.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance; TotalBalance)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the payment journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(JournalErrorsFactBox; "Journal Errors FactBox")
            {
                ApplicationArea = Basic, Suite;
                Visible = BackgroundErrorCheck;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
            part(JournalLineDetails; "Journal Line Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            part("Payment File Errors"; "Payment Journal Errors Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment File Errors';
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Journal Line No." = FIELD("Line No.");
            }
            part(Control1900919607; "Dimension Set Entries FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                Visible = false;
            }
            part(WorkflowStatusBatch; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnBatch;
            }
            part(WorkflowStatusLine; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnLine;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Scope = Repeater;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId()));
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
                action(SuggestVendorPayments)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    ToolTip = 'Create payment suggestions as lines in the payment journal.';

                    trigger OnAction()
                    var
                        SuggestVendorPayments: Report "Suggest Vendor Payments";
                    begin
                        Clear(SuggestVendorPayments);
                        SuggestVendorPayments.SetGenJnlLine(Rec);
                        SuggestVendorPayments.RunModal();
                    end;
                }
                action(SuggestEmployeePayments)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Suggest Employee Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    ToolTip = 'Create payment suggestions as lines in the payment journal.';

                    trigger OnAction()
                    var
                        SuggestEmployeePayments: Report "Suggest Employee Payments";
                    begin
                        Clear(SuggestEmployeePayments);
                        SuggestEmployeePayments.SetGenJnlLine(Rec);
                        SuggestEmployeePayments.RunModal();
                    end;
                }
                action(PreviewCheck)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&review Check';
                    Image = ViewCheck;
                    RunObject = Page "Check Preview";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Line No." = FIELD("Line No.");
                    ToolTip = 'Preview the check before printing it.';
                }
                action(PrintCheck)
                {
                    AccessByPermission = TableData "Check Ledger Entry" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Check';
                    Ellipsis = true;
                    Image = PrintCheck;
                    ToolTip = 'Prepare to print the check.';

                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        DocumentPrint: Codeunit "Document-Print";
                    begin
                        GenJournalLine.Reset();
                        GenJournalLine.Copy(Rec);
                        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        DocumentPrint.PrintCheck(GenJournalLine);
                        CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                    end;
                }
                group("Electronic Payments")
                {
                    Caption = 'Electronic Payments';
                    Image = ElectronicPayment;
                    action(ExportPaymentsToFile)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'E&xport';
                        Ellipsis = true;
                        Image = ExportFile;
                        ToolTip = 'Export a file with the payment information on the journal lines.';

                        trigger OnAction()
                        var
                            BankExportImportSetup: Record "Bank Export/Import Setup";
                            BankAccount: Record "Bank Account";
                            CompanyInformation: Record "Company Information";
                            GenJournalBatch: Record "Gen. Journal Batch";
                            GenJournalLine: Record "Gen. Journal Line";
                            BulkVendorRemitReporting: Codeunit "Bulk Vendor Remit Reporting";
                            GenJnlLineRecordRef: RecordRef;
                            ExportNewLines: Boolean;
                        begin
                            FeatureTelemetry.LogUptake('0000H8H', ElectronicPaymentTok, Enum::"Feature Uptake Status"::Discovered);
                            Rec.CheckIfPrivacyBlocked();

                            GenJournalBatch.Get("Journal Template Name", CurrentJnlBatchName);
                            GenJournalBatch.TestField("Posting No. Series", '');
                            BankAccount.Get(GenJournalBatch."Bal. Account No.");

                            if (BankAccount."Export Format" = 0) or (BankAccount."Export Format" = BankAccount."Export Format"::Other) then begin
                                // Export Format is either empty or 'OTHER'
                                GenJournalLine.CopyFilters(Rec);
                                GenJournalLine.FindFirst();
                                GenJournalLine.ExportPaymentFile();
                                FeatureTelemetry.LogUptake('0000HC0', ElectronicPaymentTok, Enum::"Feature Uptake Status"::"Set up");
                            end else begin
                                CompanyInformation.Get();
                                CompanyInformation.TestField("Federal ID No.");
                                GenJournalLine.Reset();
                                GenJournalLine.Copy(Rec);
                                GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                                GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                                if GenJournalLine.FindSet() then begin
                                    // Clear all erorrs in the batch, all lines will be re-checked in the loop below
                                    GenJournalLine.DeletePaymentFileBatchErrors();
                                    repeat
                                        CheckPaymentLineBeforeExport(GenJournalLine, GenJournalBatch, BankAccount);
                                    until GenJournalLine.Next() = 0;
                                end;

                                if BankAccount."Last Remittance Advice No." = '' then
                                    Rec.InsertPaymentFileError(LastRemittanceErr);

                                GenJournalLine."Document No." := '';
                                if GenJournalLine.HasPaymentFileErrorsInBatch() then begin
                                    Commit();
                                    Error(HasErrorsErr);
                                end;

                                if "Bank Payment Type" = "Bank Payment Type"::"Electronic Payment" then
                                    BankExportImportSetup.Get(BankAccount."Payment Export Format")
                                else
                                    if "Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT" then
                                        BankExportImportSetup.Get(BankAccount."EFT Export Code");

                                if GenJournalLine.FindFirst() then begin
                                    repeat
                                        ExportNewLines := BulkVendorRemitReporting.ProcessLine(GenJournalLine);
                                    until (ExportNewLines = true) or (GenJournalLine.Next() = 0);
                                end;

                                if ExportNewLines then begin
                                    GenJnlLineRecordRef.GetTable(GenJournalLine);
                                    GenJnlLineRecordRef.SetView(GenJournalLine.GetView());
                                    BulkVendorRemitReporting.RunWithRecord(GenJournalLine)
                                end;
                                FeatureTelemetry.LogUptake('0000HC0', ElectronicPaymentTok, Enum::"Feature Uptake Status"::"Set up");
                            end;
                        end;
                    }
                    action(VoidPayments)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Void';
                        Ellipsis = true;
                        Image = VoidElectronicDocument;
                        ToolTip = 'Void the exported electronic payment file.';

                        trigger OnAction()
                        var
                            BankAccount: Record "Bank Account";
                            GenJournalLine: Record "Gen. Journal Line";
                            VoidTransmitElecPayments: Report "Void/Transmit Elec. Payments";
                        begin
                            if "Account Type" = "Account Type"::"Bank Account" then
                                BankAccount.Get("Account No.");
                            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
                                BankAccount.Get("Bal. Account No.");
                            if (BankAccount."Export Format" = 0) or (BankAccount."Export Format" = BankAccount."Export Format"::Other) then begin
                                GenJournalLine.CopyFilters(Rec);
                                if not EntriesToVoid(GenJournalLine, true) then
                                    Error(NoEntriesToVoidErr);
                                if GenJournalLine.FindFirst() then
                                    GenJournalLine.VoidPaymentFile;
                            end else begin
                                GenJournalLine.Reset();
                                GenJournalLine := Rec;
                                GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                                GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                                if not EntriesToVoid(GenJournalLine, false) then
                                    Error(NoEntriesToVoidErr);
                                Clear(VoidTransmitElecPayments);
                                VoidTransmitElecPayments.SetUsageType(1);   // Void
                                VoidTransmitElecPayments.SetTableView(GenJournalLine);
                                if "Account Type" = "Account Type"::"Bank Account" then
                                    VoidTransmitElecPayments.SetBankAccountNo("Account No.")
                                else
                                    if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
                                        VoidTransmitElecPayments.SetBankAccountNo("Bal. Account No.");
                                VoidTransmitElecPayments.RunModal();
                            end;
                        end;
                    }
                    action(TransmitPayments)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transmit';
                        Ellipsis = true;
                        Enabled = AMCFormat;
                        Image = TransmitElectronicDoc;
                        ToolTip = 'Create an electronic payment file for the bank.';

                        trigger OnAction()
                        var
                            BankAccount: Record "Bank Account";
                            GenJournalLine: Record "Gen. Journal Line";
                        begin
                            if "Account Type" = "Account Type"::"Bank Account" then
                                BankAccount.Get("Account No.");
                            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
                                BankAccount.Get("Bal. Account No.");
                            if (BankAccount."Export Format" = 0) or (BankAccount."Export Format" = BankAccount."Export Format"::Other) then begin
                                GenJournalLine.CopyFilters(Rec);
                                if GenJournalLine.FindFirst() then
                                    GenJournalLine.TransmitPaymentFile;
                            end;
                        end;
                    }
                }
                action("Void Check")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Void Check';
                    Image = VoidCheck;
                    ToolTip = 'Void the check if, for example, the check is not cashed by the bank.';

                    trigger OnAction()
                    var
                        ConfirmManagement: Codeunit "Confirm Management";
                    begin
                        Rec.TestField("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                        Rec.TestField("Check Printed", true);
                        if ConfirmManagement.GetResponseOrDefault(StrSubstNo(VoidCheckQst, Rec."Document No."), true) then
                            CheckManagement.VoidCheck(Rec);
                    end;
                }
                action("Void &All Checks")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Void &All Checks';
                    Image = VoidAllChecks;
                    ToolTip = 'Void all checks if, for example, the checks are not cashed by the bank.';

                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        GenJournalLine2: Record "Gen. Journal Line";
                        ConfirmManagement: Codeunit "Confirm Management";
                    begin
                        if ConfirmManagement.GetResponseOrDefault(VoidAllPrintedChecksQst, true) then begin
                            GenJournalLine.Reset();
                            GenJournalLine.Copy(Rec);
                            GenJournalLine.SetRange("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                            GenJournalLine.SetRange("Check Printed", true);
                            if GenJournalLine.Find('-') then
                                repeat
                                    GenJournalLine2 := GenJournalLine;
                                    CheckManagement.VoidCheck(GenJournalLine2);
                                until GenJournalLine.Next() = 0;
                        end;
                    end;
                }
                action(CreditTransferRegEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Credit Transfer Reg. Entries';
                    Enabled = AMCFormat;
                    Image = ExportReceipt;
                    RunObject = Codeunit "Gen. Jnl.-Show CT Entries";
                    ToolTip = 'View or edit the credit transfer entries that are related to file export for credit transfers.';
                }
                action(CreditTransferRegisters)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Credit Transfer Registers';
                    Enabled = AMCFormat;
                    Image = ExportElectronicDocument;
                    RunObject = Page "Credit Transfer Registers";
                    ToolTip = 'View or edit the payment files that have been exported in connection with credit transfers.';
                }
                action(NetCustomerVendorBalances)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Net Customer/Vendor Balances';
                    Image = Balance;
                    ToolTip = 'Create journal lines to consolidate customer and vendor balances as of a specified date. This is relevant when you do business with a company that is both a customer and a vendor. Depending on which is larger, the balance will be netted for either the payable or receivable amount.';

                    trigger OnAction()
                    var
                        NetCustomerVendorBalances: Report "Net Customer/Vendor Balances";
                    begin
                        NetCustomerVendorBalances.SetGenJnlLine(Rec);
                        NetCustomerVendorBalances.RunModal();
                    end;
                }
            }
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Renumber Document Numbers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';

                    trigger OnAction()
                    begin
                        Rec.RenumberDocumentNo();
                    end;
                }
                action(ApplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Enabled = ApplyEntriesActionEnabled;
                    Image = ApplyEntries;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
                }
                action(CalculatePostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate Posting Date';
                    Image = CalcWorkCenterCalendar;
                    ToolTip = 'Calculate the date that will appear as the posting date on the journal lines.';

                    trigger OnAction()
                    begin
                        Rec.CalculatePostingDate();
                    end;
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert Conv. LCY Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.';
                }
                action(PositivePayExport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Positive Pay Export';
                    Image = Export;
                    ToolTip = 'Export a Positive Pay file that contains vendor information, check number, and payment amount, which you send to the bank to make sure that your bank only clears validated checks and amounts when you process payments.';
                    Visible = false;

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        BankAcc: Record "Bank Account";
                    begin
                        GenJnlBatch.Get("Journal Template Name", CurrentJnlBatchName);
                        if GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"Bank Account" then begin
                            BankAcc."No." := GenJnlBatch."Bal. Account No.";
                            PAGE.Run(PAGE::"Positive Pay Export", BankAcc);
                        end;
                    end;
                }
                action(GenerateEFT)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Generate EFT File';
                    Enabled = NOT (AMCFormat = TRUE);
                    Image = ExportFile;
                    ToolTip = 'Generate a file based on the exported payment journal lines. A window showing the file content opens from where you complete the electronic funds transfer.';

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        GenerateEFTFiles: Page "Generate EFT Files";
                    begin
                        FeatureTelemetry.LogUptake('0000H8I', ElectronicPaymentTok, Enum::"Feature Uptake Status"::"Used");
                        GenJournalBatch.Get("Journal Template Name", CurrentJnlBatchName);
                        GenerateEFTFiles.SetBalanceAccount(GenJournalBatch."Bal. Account No.");
                        GenerateEFTFiles.Run();
                        FeatureTelemetry.LogUsage('0000H8J', ElectronicPaymentTok, 'EFT generated');
                    end;
                }
            }
            group(Errors)
            {
                Image = ErrorLog;
                Visible = BackgroundErrorCheck;
                action(ShowLinesWithErrors)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Lines with Issues';
                    Image = Error;
                    Visible = BackgroundErrorCheck and not ShowAllLinesEnabled;
                    Enabled = not ShowAllLinesEnabled;
                    ToolTip = 'View a list of journal lines that have issues before you post the journal.';

                    trigger OnAction()
                    begin
                        Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                    end;
                }
                action(ShowAllLines)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show All Lines';
                    Image = ExpandAll;
                    Visible = BackgroundErrorCheck and ShowAllLinesEnabled;
                    Enabled = ShowAllLinesEnabled;
                    ToolTip = 'View all journal lines, including lines with and without issues.';

                    trigger OnAction()
                    begin
                        Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.';

                    trigger OnAction()
                    var
                        GLReconciliation: Page Reconciliation;
                    begin
                        GLReconciliation.SetGenJnlLine(Rec);
                        GLReconciliation.Run();
                    end;
                }
                action(PreCheck)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Pre-Payment Journal';
                    Image = PreviewChecks;
                    ToolTip = 'View journal line entries, payment discounts, discount tolerance amounts, payment tolerance, and any errors associated with the entries. You can use the results of the report to review payment journal lines and to review the results of posting before you actually post.';

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Init();
                        GenJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                        REPORT.Run(REPORT::"Vendor Pre-Payment Journal", true, false, GenJournalBatch);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    var
                        TestReportPrint: Codeunit "Test Report-Print";
                    begin
                        TestReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Rec.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        SetJobQueueVisibility();
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Rec.SendToPosting(Codeunit::"Gen. Jnl.-Post+Print");
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        SetJobQueueVisibility();
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.';
                    Visible = JobQueueVisible;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting();
                        SetJobQueueVisibility();
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrAnyJnlLineExist AND CanRequestFlowApprovalForBatchAndAllLines;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearanceFromBatch();
                            SetControlAppearance();
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrCurrJnlLineExist AND CanRequestFlowApprovalForBatchAndCurrentLine;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch OR CanCancelFlowApprovalForBatch;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearanceFromBatch();
                            SetControlAppearance();
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = CanCancelApprovalForJnlLine OR CanCancelFlowApprovalForLine;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                customaction(CreateFlowFromTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create a Power Automate approval flow';
                    ToolTip = 'Create a new flow in Power Automate from a list of relevant flow templates.';
#if not CLEAN22
                    Visible = IsSaaS and PowerAutomateTemplatesEnabled;
#else
                    Visible = IsSaaS;
#endif
                    CustomActionType = FlowTemplateGallery;
                    FlowTemplateCategoryName = 'd365bc_approval_generalJournal';
                }
#if not CLEAN22
                action(CreateFlow)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create a Power Automate approval flow';
                    Image = Flow;
                    ToolTip = 'Create a new flow in Power Automate from a list of relevant flow templates.';
                    Visible = IsSaaS and not PowerAutomateTemplatesEnabled;
                    ObsoleteReason = 'This action will be handled by platform as part of the CreateFlowFromTemplate customaction';
                    ObsoleteState = Pending;
                    ObsoleteTag = '22.0';

                    trigger OnAction()
                    var
                        FlowServiceManagement: Codeunit "Flow Service Management";
                        FlowTemplateSelector: Page "Flow Template Selector";
                    begin
                        // Opens page 6400 where the user can use filtered templates to create new flows.
                        FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetJournalTemplateFilter());
                        FlowTemplateSelector.Run();
                    end;
                }
#endif
#if not CLEAN21
                action(SeeFlows)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'See my flows';
                    Image = Flow;
                    RunObject = Page "Flow Selector";
                    ToolTip = 'View and configure Power Automate flows that you created.';
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'This action has been moved to the tab dedicated to Power Automate';
                    ObsoleteTag = '21.0';
                }
#endif
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Approval Workflow';
                    Enabled = NOT EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for payment journal lines, by going through a few pages that will guide you.';

                    trigger OnAction()
                    var
                        TempApprovalWorkflowWizard: Record "Approval Workflow Wizard" temporary;
                    begin
                        TempApprovalWorkflowWizard."Journal Batch Name" := "Journal Batch Name";
                        TempApprovalWorkflowWizard."Journal Template Name" := "Journal Template Name";
                        TempApprovalWorkflowWizard."For All Batches" := false;
                        TempApprovalWorkflowWizard.Insert();

                        PAGE.RunModal(PAGE::"Pmt. App. Workflow Setup Wzrd.", TempApprovalWorkflowWizard);
                    end;
                }
                action(ManageApprovalWorkflows)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manage Approval Workflows';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for payment journal lines.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(DATABASE::"Gen. Journal Line", EventFilter);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if OpenApprovalEntriesOnJnlLineExist then
                            ApprovalsMgmt.GetApprovalComment(Rec)
                        else
                            if OpenApprovalEntriesOnJnlBatchExist then
                                if GenJournalBatch.Get("Journal Template Name", "Journal Batch Name") then
                                    ApprovalsMgmt.GetApprovalComment(GenJournalBatch);
                    end;
                }
            }
            group("Page")
            {
                Caption = 'Page';
                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    ToolTip = 'Send the data in the journal to an Excel file for analysis or editing.';
                    Visible = IsSaaSExcelAddinEnabled;
                    AccessByPermission = System "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        ODataUtility: Codeunit ODataUtility;
                    begin
                        ODataUtility.EditJournalWorksheetInExcel(CurrPage.Caption(), CurrPage.ObjectId(false), "Journal Batch Name", "Journal Template Name");
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category8)
                {
                    Caption = 'Post/Print', Comment = 'Generated from the PromotedActionCategories property index 7.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
                    {
                    }
                    actionref(Preview_Promoted; Preview)
                    {
                    }
                    actionref("Post and &Print_Promoted"; "Post and &Print")
                    {
                    }
                    actionref("Test Report_Promoted"; "Test Report")
                    {
                    }
                }
                actionref("Renumber Document Numbers_Promoted"; "Renumber Document Numbers")
                {
                }
                actionref(ApplyEntries_Promoted; ApplyEntries)
                {
                }
                actionref(Reconcile_Promoted; Reconcile)
                {
                }
                group(ShowLinesWithErrors_Group)
                {
                    ShowAs = SplitButton;
                    Caption = 'Filter lines with issues';

                    actionref(ShowLinesWithErrors_Promoted; ShowLinesWithErrors)
                    {
                    }
                    actionref(ShowAllLines_Promoted; ShowAllLines)
                    {
                    }
                }
#if not CLEAN21
                actionref("Remove From Job Queue_Promoted"; "Remove From Job Queue")
                {
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action is being demoted based on overall low usage.';
                    ObsoleteTag = '21.0';
                }
#endif
            }
            group(Category_Category5)
            {
                Caption = 'Prepare', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(SuggestVendorPayments_Promoted; SuggestVendorPayments)
                {
                }
                actionref(SuggestEmployeePayments_Promoted; SuggestEmployeePayments)
                {
                }
                actionref(NetCustomerVendorBalances_Promoted; NetCustomerVendorBalances)
                {
                }
                actionref(CalculatePostingDate_Promoted; CalculatePostingDate)
                {
                }
            }
            group(Category_Category11)
            {
                Caption = 'Check', Comment = 'Generated from the PromotedActionCategories property index 10.';

                actionref(PrintCheck_Promoted; PrintCheck)
                {
                }
                actionref("Void Check_Promoted"; "Void Check")
                {
                }
                actionref("Void &All Checks_Promoted"; "Void &All Checks")
                {
                }
                actionref(PreviewCheck_Promoted; PreviewCheck)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Approve', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
            }
            group("Category_Request Approval")
            {
                Caption = 'Request Approval';

                group("Category_Send Approval Request")
                {
                    Caption = 'Send Approval Request';

                    actionref(SendApprovalRequestJournalBatch_Promoted; SendApprovalRequestJournalBatch)
                    {
                    }
                    actionref(SendApprovalRequestJournalLine_Promoted; SendApprovalRequestJournalLine)
                    {
                    }
                }
                group("Category_Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';

                    actionref(CancelApprovalRequestJournalBatch_Promoted; CancelApprovalRequestJournalBatch)
                    {
                    }
                    actionref(CancelApprovalRequestJournalLine_Promoted; CancelApprovalRequestJournalLine)
                    {
                    }
                }
            }
            group(Category_Category4)
            {
                Caption = 'Bank', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(ExportPaymentsToFile_Promoted; ExportPaymentsToFile)
                {
                }
#if not CLEAN21
                actionref(TransmitPayments_Promoted; TransmitPayments)
                {
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action only related to NA local version';
                    ObsoleteTag = '21.0';
                }
#endif
                actionref(VoidPayments_Promoted; VoidPayments)
                {
                }
                actionref(CreditTransferRegEntries_Promoted; CreditTransferRegEntries)
                {
                }
                actionref(CreditTransferRegisters_Promoted; CreditTransferRegisters)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Line', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref(IncomingDoc_Promoted; IncomingDoc)
                {
                }
#if not CLEAN21
                actionref("Ledger E&ntries_Promoted"; "Ledger E&ntries")
                {
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action is being demoted based on overall low usage.';
                    ObsoleteTag = '21.0';
                }
#endif
            }
            group(Category_Category10)
            {
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 9.';

#if not CLEAN21
                actionref(Card_Promoted; Card)
                {
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action is being demoted based on overall low usage.';
                    ObsoleteTag = '21.0';
                }
#endif
            }
            group(Category_Category7)
            {
                Caption = 'Page', Comment = 'Generated from the PromotedActionCategories property index 6.';

                actionref(EditInExcel_Promoted; EditInExcel)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance();
        EnableApplyEntriesAction();
        SetControlAppearance();
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

        if GenJournalBatch.Get("Journal Template Name", "Journal Batch Name") then begin
            ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RecordId);
            IsAllowPaymentExport := GenJournalBatch."Allow Payment Export";
        end;
        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(RecordId);

        EventFilter := WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode();
        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Line", EventFilter);
        SetJobQueueVisibility();

        OnAfterOnAfterGetRecord(Rec, GenJnlManagement, AccName, BalAccName);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        HasPmtFileErr := HasPaymentFileErrors();
        RecipientBankAccountMandatory := IsAllowPaymentExport and
          (("Bal. Account Type" = "Bal. Account Type"::Vendor) or ("Bal. Account Type" = "Bal. Account Type"::Customer));
        SetAMCAppearance();
        CurrPage.IncomingDocAttachFactBox.PAGE.SetCurrentRecordID(RecordId);
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
        AmountVisible := true;
        GeneralLedgerSetup.Get();
        SetJobQueueVisibility();

#if not CLEAN22
        InitPowerAutomateTemplateVisibility();
#endif
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.IncomingDocAttachFactBox.PAGE.SetCurrentRecordID(RecordId);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CheckForPmtJnlErrors();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        HasPmtFileErr := false;
        UpdateBalance();
        EnableApplyEntriesAction();
        SetUpNewLine(xRec, Balance, BelowxRec);
        Clear(ShortcutDimCode);
        if not VoidWarningDisplayed then begin
            GenJnlTemplate.Get("Journal Template Name");
            if not GenJnlTemplate."Force Doc. Balance" then
                Message(CheckCannotVoidMsg);
            VoidWarningDisplayed := true;
        end;
        SetAMCAppearance();

        OnAfterOnNewRecord(Rec, xRec, GenJnlManagement, AccName, AccName);
    end;

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        ClientTypeManagement: Codeunit "Client Type Management";
        EnvironmentInformation: Codeunit "Environment Information";
        JnlSelected: Boolean;
    begin
        OnBeforeOnOpenPage(Rec);

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        IsSaaS := EnvironmentInformation.IsSaaS();
        if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::ODataV4 then
            exit;

        BalAccName := '';
        SetControlVisibility();
        SetDimensionsVisibility();

        if Rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := "Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            SetControlAppearanceFromBatch();
            exit;
        end;
        GenJnlManagement.TemplateSelection(PAGE::"Payment Journal", "Gen. Journal Template Type"::Payments, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
        VoidWarningDisplayed := false;

        OnAfterOnOpenPage(CurrentJnlBatchName);
    end;

    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        CheckManagement: Codeunit CheckManagement;
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
        BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
        FeatureTelemetry: Codeunit "Feature Telemetry";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CurrentJnlBatchName: Code[10];
        AccName: Text[100];
        BalAccName: Text[100];
        Balance: Decimal;
        TotalBalance: Decimal;
        NumberOfRecords: Integer;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        HasPmtFileErr: Boolean;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        [InDataSet]
        IsPostingGroupEditable: Boolean;
        StyleTxt: Text;
        OverdueWarningText: Text;
        EventFilter: Text;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExistForCurrUserBatch: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        IsAllowPaymentExport: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        RecipientBankAccountMandatory: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        AmountVisible: Boolean;
        IsSaaS: Boolean;
        DebitCreditVisible: Boolean;
        JobQueuesUsed: Boolean;
        JobQueueVisible: Boolean;
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        AMCFormat: Boolean;
        VoidWarningDisplayed: Boolean;

        VoidCheckQst: Label 'Void Check %1?', Comment = '%1 - check number';
        VoidAllPrintedChecksQst: Label 'Void all printed checks?';
        CheckCannotVoidMsg: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
        WrongBankPaymentTypeErr: Label '%1 type must be either %2 or %3.', Comment = '%1=Bank Payment Type field caption, %2=Electronic Payment bank payment type, %3=Electronic Payment-IAT bank payment type';
        HasErrorsErr: Label 'The file export has one or more errors.\\For each line to be exported, resolve the errors displayed to the right and then try to export again.';
        NoEntriesToVoidErr: Label 'There are no entries to void.';
        LastRemittanceErr: Label 'Last Remittance Advice No. must have a value in the bank account.';
        NoExportNegativeErr: Label 'You cannot export journal entries with negative amounts.';
        UseForElecPaymentCheckedErr: Label 'The Use for Electronic Payments check box must be selected on the vendor or customer bank account card.';
        NoExportDiffCurrencyErr: Label 'You cannot export journal entries if Currency Code is different in Gen. Journal Line and Bank Account.';
        RecipientBankAccountEmptyErr: Label 'Recipient Bank Account must be filled.';
        ElectronicPaymentTok: Label 'NA Electronic Payments', Locked = true;

    protected var
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        ApplyEntriesActionEnabled: Boolean;

    local procedure CheckForPmtJnlErrors()
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        if HasPmtFileErr then
            if (Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account") and BankAccount.Get(Rec."Bal. Account No.") then
                if BankExportImportSetup.Get(BankAccount."Payment Export Format") then
                    if BankExportImportSetup."Check Export Codeunit" > 0 then
                        CODEUNIT.Run(BankExportImportSetup."Check Export Codeunit", Rec);
    end;

    procedure UpdateBalance()
    begin
        OnBeforeUpdateBalance();

        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
        if ShowTotalBalance then
            NumberOfRecords := Count();

        OnAfterUpdateBalance(TotalBalanceVisible);
    end;

    local procedure EnableApplyEntriesAction()
    begin
        ApplyEntriesActionEnabled :=
          (Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor, Rec."Account Type"::Employee]) or
          (Rec."Bal. Account Type" in [Rec."Bal. Account Type"::Customer, Rec."Bal. Account Type"::Vendor, Rec."Bal. Account Type"::Employee]);

        OnAfterEnableApplyEntriesAction(Rec, ApplyEntriesActionEnabled);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
        CurrPage.Update(false);
    end;

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet());
    end;

    local procedure SetControlAppearanceFromBatch()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForAllLines: Boolean;
    begin
        if not GenJournalBatch.Get(Rec.GetRangeMax("Journal Template Name"), CurrentJnlBatchName) then
            exit;

        CheckOpenApprovalEntries(GenJournalBatch.RecordId);

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
          GenJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
        CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
        BackgroundErrorCheck := BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled();
        ShowAllLinesEnabled := true;
        Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
        JournalErrorsMgt.SetFullBatchCheck(true);
    end;

    local procedure CheckOpenApprovalEntries(BatchRecordId: RecordID)
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);

        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries("Journal Template Name", "Journal Batch Name");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;
    begin
        OpenApprovalEntriesExistForCurrUser :=
          OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure SetControlVisibility()
    begin
        GeneralLedgerSetup.GetRecordOnce();
        AmountVisible := not (GeneralLedgerSetup."Show Amounts" = GeneralLedgerSetup."Show Amounts"::"Debit/Credit Only");
        DebitCreditVisible := not (GeneralLedgerSetup."Show Amounts" = GeneralLedgerSetup."Show Amounts"::"Amount Only");

        PurchasesPayablesSetup.GetRecordOnce();
        IsPostingGroupEditable := PurchasesPayablesSetup."Allow Multiple Posting Groups";
    end;

    local procedure SetDimensionsVisibility()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimensionManagement.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimensionManagement);
    end;

    local procedure CheckPaymentLineBeforeExport(var GenJnlLine: Record "Gen. Journal Line"; GenJournalBatch: Record "Gen. Journal Batch"; BankAccount: Record "Bank Account")
    var
        PaymentExportGenJnlCheck: Codeunit "Payment Export Gen. Jnl Check";
    begin
        GenJnlLine.DeletePaymentFileErrors();
        if GenJnlLine."Currency Code" <> BankAccount."Currency Code" then
            GenJnlLine.InsertPaymentFileError(NoExportDiffCurrencyErr);
        if ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") or
            (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account")) and
           ((GenJnlLine."Bank Payment Type" <> GenJnlLine."Bank Payment Type"::"Electronic Payment") and
            (GenJnlLine."Bank Payment Type" <> GenJnlLine."Bank Payment Type"::"Electronic Payment-IAT"))
        then
            GenJnlLine.InsertPaymentFileError(StrSubstNo(WrongBankPaymentTypeErr, FieldCaption("Bank Payment Type"),
                "Bank Payment Type"::"Electronic Payment", "Bank Payment Type"::"Electronic Payment-IAT"));
        if not GenJournalBatch."Allow Payment Export" then
            PaymentExportGenJnlCheck.AddBatchEmptyError(GenJnlLine, GenJournalBatch.FieldCaption("Allow Payment Export"), '');
        if GenJnlLine.Amount < 0 then
            GenJnlLine.InsertPaymentFileError(NoExportNegativeErr);
        if GenJnlLine."Recipient Bank Account" = '' then
            GenJnlLine.InsertPaymentFileError(RecipientBankAccountEmptyErr)
        else
            if not UseForElecPaymentChecked(GenJnlLine) then
                GenJnlLine.InsertPaymentFileError(UseForElecPaymentCheckedErr);

        OnAfterCheckPaymentLineBeforeExport(GenJnlLine);
    end;

    local procedure SetAMCAppearance()
    var
        BankAccount: Record "Bank Account";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        AMCFormat := false;
        if GenJournalBatch.Get("Journal Template Name", CurrentJnlBatchName) then
            if BankAccount.Get(GenJournalBatch."Bal. Account No.") then
                if GenJournalBatch."Bal. Account Type" = GenJournalBatch."Bal. Account Type"::"Bank Account" then
                    if (BankAccount."Export Format" = 0) or (BankAccount."Export Format" = BankAccount."Export Format"::Other) then
                        AMCFormat := true;
    end;

    local procedure EntriesToVoid(GenJnlLine3: Record "Gen. Journal Line"; AMC: Boolean): Boolean
    begin
        GenJnlLine3.SetFilter("Document Type", 'Payment|Refund');
        GenJnlLine3.SetFilter("Bank Payment Type", 'Electronic Payment|Electronic Payment-IAT');
        if AMC then
            GenJnlLine3.SetRange("Exported to Payment File", true)
        else begin
            GenJnlLine3.SetRange("Check Printed", true);
            GenJnlLine3.SetRange("Check Exported", true);
        end;
        GenJnlLine3.SetRange("Check Transmitted", false);
        exit(GenJnlLine3.FindFirst())
    end;

    local procedure UseForElecPaymentChecked(GenJnlLine3: Record "Gen. Journal Line"): Boolean
    var
        CustomerBankAccount: Record "Customer Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if GenJnlLine3."Bal. Account Type" <> GenJnlLine3."Bal. Account Type"::"Bank Account" then
            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::Vendor then begin
                VendorBankAccount.SetRange("Vendor No.", GenJnlLine3."Bal. Account No.");
                VendorBankAccount.SetRange(Code, GenJnlLine3."Recipient Bank Account");
                if VendorBankAccount.FindFirst() then
                    exit(VendorBankAccount."Use for Electronic Payments")
            end else
                if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::Customer then begin
                    CustomerBankAccount.SetRange("Customer No.", GenJnlLine3."Bal. Account No.");
                    CustomerBankAccount.SetRange(Code, GenJnlLine3."Recipient Bank Account");
                    if CustomerBankAccount.FindFirst() then
                        exit(CustomerBankAccount."Use for Electronic Payments");
                end else
                    exit(true)
        else
            if GenJnlLine3."Account Type" <> GenJnlLine3."Account Type"::"Bank Account" then
                if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::Vendor then begin
                    VendorBankAccount.SetRange("Vendor No.", GenJnlLine3."Account No.");
                    VendorBankAccount.SetRange(Code, GenJnlLine3."Recipient Bank Account");
                    if VendorBankAccount.FindFirst() then
                        exit(VendorBankAccount."Use for Electronic Payments");
                end else
                    if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::Customer then begin
                        CustomerBankAccount.SetRange("Customer No.", GenJnlLine3."Account No.");
                        CustomerBankAccount.SetRange(Code, GenJnlLine3."Recipient Bank Account");
                        if CustomerBankAccount.FindFirst() then
                            exit(CustomerBankAccount."Use for Electronic Payments");
                    end else
                        exit(true);
    end;

    local procedure SetJobQueueVisibility()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        JobQueuesUsed := GeneralLedgerSetup.JobQueueActive();
    end;

    local procedure CheckAmountMatchedToAppliedLines()
    var
        VendorLedgerEntryMarkedToApply: Record "Vendor Ledger Entry";
        CustLedgEntryMarkedToApply: Record "Cust. Ledger Entry";
        CustEntrySetApplId: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplId: Codeunit "Vend. Entry-SetAppl.ID";
        SmallestLineAmountToApply: Decimal;
        JournalAmount: Decimal;
        AmountToApply: Decimal;
        AmountToApplyMissMatchMsg: Label 'Amount assigned on Apply Entries (%1) is bigger then the amount on the line (%2). System will remove all related Applies-to ID. Do you want to proceed?', Comment = '%1 - Amount to apply, %2 - Amount on the line';
    begin
        if Rec."Document Type" <> Rec."Document Type"::"Payment" then
            exit;

        if not (((xRec.Amount <> 0) and (xRec.Amount <> Rec.Amount) and (Rec.Amount <> 0))
            or ((xRec."Amount (LCY)" <> 0) and (xRec."Amount (LCY)" <> Rec."Amount (LCY)") and (Rec."Amount (LCY)" <> 0))) then
            exit;

        AmountToApply := 0;
        SmallestLineAmountToApply := 0;

        case Rec."Account Type" of
            Rec."Account Type"::Customer:
                begin
                    JournalAmount := -Rec.Amount;
                    CustLedgEntryMarkedToApply.Reset();
                    CustLedgEntryMarkedToApply.SetLoadFields("Applies-to ID", "Amount to Apply", "Accepted Pmt. Disc. Tolerance", "Accepted Payment Tolerance");
                    CustLedgEntryMarkedToApply.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                    CustLedgEntryMarkedToApply.SetRange("Customer No.", Rec."Account No.");
                    CustLedgEntryMarkedToApply.SetRange("Applies-to ID", Rec."Applies-to ID");
                    if CustLedgEntryMarkedToApply.FindSet() then
                        repeat
                            if SmallestLineAmountToApply = 0 then
                                SmallestLineAmountToApply := CustLedgEntryMarkedToApply."Amount to Apply"
                            else
                                if SmallestLineAmountToApply > CustLedgEntryMarkedToApply."Amount to Apply" then
                                    SmallestLineAmountToApply := CustLedgEntryMarkedToApply."Amount to Apply";
                            AmountToApply += CustLedgEntryMarkedToApply."Amount to Apply";
                        until CustLedgEntryMarkedToApply.Next() = 0;
                end;
            Rec."Account Type"::Vendor:
                begin
                    JournalAmount := Rec.Amount;
                    VendorLedgerEntryMarkedToApply.Reset();
                    VendorLedgerEntryMarkedToApply.SetLoadFields("Applies-to ID", "Amount to Apply");
                    VendorLedgerEntryMarkedToApply.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                    VendorLedgerEntryMarkedToApply.SetRange("Vendor No.", Rec."Account No.");
                    VendorLedgerEntryMarkedToApply.SetRange("Applies-to ID", Rec."Applies-to ID");
                    if VendorLedgerEntryMarkedToApply.FindSet() then
                        repeat
                            if SmallestLineAmountToApply = 0 then
                                SmallestLineAmountToApply := -VendorLedgerEntryMarkedToApply."Amount to Apply"
                            else
                                if SmallestLineAmountToApply > -VendorLedgerEntryMarkedToApply."Amount to Apply" then
                                    SmallestLineAmountToApply := -VendorLedgerEntryMarkedToApply."Amount to Apply";
                            AmountToApply -= VendorLedgerEntryMarkedToApply."Amount to Apply";
                        until VendorLedgerEntryMarkedToApply.Next() = 0;
                end;
        end;

        if AmountToApply = 0 then
            exit;

        if AmountToApply <= JournalAmount then
            exit;

        if (AmountToApply - JournalAmount) < SmallestLineAmountToApply then
            exit;

        if not Confirm(AmountToApplyMissMatchMsg, false, AmountToApply, JournalAmount) then
            Error('');

        case Rec."Account Type" of
            Rec."Account Type"::Customer:
                CustEntrySetApplId.RemoveApplId(CustLedgEntryMarkedToApply, Rec."Applies-to ID");
            Rec."Account Type"::Vendor:
                VendEntrySetApplId.RemoveApplId(VendorLedgerEntryMarkedToApply, Rec."Applies-to ID");
        end;
    end;

#if not CLEAN22
    var
        PowerAutomateTemplatesEnabled: Boolean;
        PowerAutomateTemplatesFeatureLbl: Label 'PowerAutomateTemplates', Locked = true;

    local procedure InitPowerAutomateTemplateVisibility()
    var
        FeatureKey: Record "Feature Key";
    begin
        PowerAutomateTemplatesEnabled := true;
        if FeatureKey.Get(PowerAutomateTemplatesFeatureLbl) then
            if FeatureKey.Enabled <> FeatureKey.Enabled::"All Users" then
                PowerAutomateTemplatesEnabled := false;
    end;
#endif

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnAfterGetRecord(var GenJournalLine: Record "Gen. Journal Line"; var GenJnlManagement: Codeunit GenJnlManagement; var AccName: Text[100]; var BalAccName: Text[100])
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnOpenPage(var CurrentJnlBatchName: Code[10])
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnNewRecord(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; var GenJnlManagement: Codeunit GenJnlManagement; var AccName: Text[100]; var BalAccName: Text[100])
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterUpdateBalance(var TotalBalanceVisible: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckPaymentLineBeforeExport(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var GenJournalLine: Record "Gen. Journal Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeOnOpenPage(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUpdateBalance()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterEnableApplyEntriesAction(GenJournalLine: Record "Gen. Journal Line"; var ApplyEntriesActionEnabled: Boolean)
    begin
    end;
}
