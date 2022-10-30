﻿page 344 Navigate
{
    AdditionalSearchTerms = 'find,search,analyze';
    ApplicationArea = Basic, Suite, FixedAssets, Service, CostAccounting;
    Caption = 'Find entries';
    DataCaptionExpression = GetCaptionText;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Find By';
    SaveValues = false;
    SourceTable = "Document Entry";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Document)
            {
                Caption = 'Document';
                Visible = DocumentVisible;
                field(DocNoFilter; DocNoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number of an entry that is used to find all documents that have the same document number. You can enter a new document number in this field to search for another set of documents.';

                    trigger OnValidate()
                    begin
                        SetDocNo(DocNoFilter);
                        ContactType := ContactType::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                        ClearTrackingInfo();
                        DocNoFilterOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
                field(PostingDateFilter; PostingDateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date for the document that you are searching for. You can insert a filter if you want to search for a certain interval of dates.';

                    trigger OnValidate()
                    begin
                        SetPostingDate(PostingDateFilter);
                        ContactType := ContactType::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                        ClearTrackingInfo();
                        PostingDateFilterOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
            }
            group("Business Contact")
            {
                Caption = 'Business Contact';
                Visible = BusinessContactVisible;
                field(ContactType; ContactType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Contact Type';
                    ToolTip = 'Specifies if you want to search for customers, vendors, or bank accounts. Your choice determines the list that you can access in the Business Contact No. field.';

                    trigger OnValidate()
                    begin
                        NavigateDeposit := (ContactType = ContactType::"Bank Account");
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ContactTypeOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
                field(ContactNo; ContactNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Contact No.';
                    ToolTip = 'Specifies the number of the customer, vendor, or bank account that you want to find entries for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vend: Record Vendor;
                        Cust: Record Customer;
                        BankAcc: Record "Bank Account";
                    begin
                        case ContactType of
                            ContactType::Vendor:
                                if PAGE.RunModal(0, Vend) = ACTION::LookupOK then begin
                                    Text := Vend."No.";
                                    exit(true);
                                end;
                            ContactType::Customer:
                                if PAGE.RunModal(0, Cust) = ACTION::LookupOK then begin
                                    Text := Cust."No.";
                                    exit(true);
                                end;
                            ContactType::"Bank Account":
                                if PAGE.RunModal(0, BankAcc) = ACTION::LookupOK then begin
                                    Text := BankAcc."No.";
                                    exit(true);
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ContactNoOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
                field(ExtDocNo; ExtDocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies the document number assigned by the vendor.';

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ExtDocNoOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
            }
            group("Item Reference")
            {
                Caption = 'Item Reference';
                Visible = ItemReferenceVisible;
                field(SerialNoFilter; SerialNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Serial No.';
                    ToolTip = 'Specifies the posting date of the document when you have opened the Navigate window from the document. The entry''s document number is shown in the Document No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SerialNoInformationList: Page "Serial No. Information List";
                    begin
                        Clear(SerialNoInformationList);
                        if SerialNoInformationList.RunModal = ACTION::LookupOK then begin
                            Text := SerialNoInformationList.GetSelectionFilter();
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ClearInfo();
                        SerialNoFilterOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
                field(LotNoFilter; LotNoFilter)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies the number that you want to find entries for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInformationList: Page "Lot No. Information List";
                    begin
                        Clear(LotNoInformationList);
                        if LotNoInformationList.RunModal = ACTION::LookupOK then begin
                            Text := LotNoInformationList.GetSelectionFilter();
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ClearInfo();
                        LotNoFilterOnAfterValidate();
                        FilterSelectionChanged();
                    end;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                InstructionalText = 'The filter has been changed. Choose Find to update the list of related entries.';
                Visible = FilterSelectionChangedTxtVisible;
            }
            repeater(Control16)
            {
                Editable = false;
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                    Visible = false;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the table that the entry is stored in.';
                    Visible = false;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Related Entries';
                    ToolTip = 'Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.';
                }
                field("No. of Records"; Rec."No. of Records")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Entries';
                    DrillDown = true;
                    ToolTip = 'Specifies the number of documents that the Navigate facility has found in the table with the selected entries.';

                    trigger OnDrillDown()
                    begin
                        ShowRecords();
                    end;
                }
            }
            group(Source)
            {
                Caption = 'Source';
                field(DocType; DocType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    Enabled = DocTypeEnable;
                    ToolTip = 'Specifies the type of the selected document. Leave the Document Type field blank if you want to search by posting date. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceType; SourceType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Type';
                    Editable = false;
                    Enabled = SourceTypeEnable;
                    ToolTip = 'Specifies the source type of the selected document or remains blank if you search by posting date. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceNo; SourceNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source No.';
                    Editable = false;
                    Enabled = SourceNoEnable;
                    ToolTip = 'Specifies the source number of the selected document. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceName; SourceName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Name';
                    Editable = false;
                    Enabled = SourceNameEnable;
                    ToolTip = 'Specifies the source name on the selected entry. The entry''s document number is shown in the Document No. field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(Show)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Show Related Entries';
                    Enabled = ShowEnable;
                    Image = ViewDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View the related entries of the type that you have chosen.';

                    trigger OnAction()
                    begin
                        ShowRecords();
                    end;
                }
                action(Find)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fi&nd';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Apply a filter to search on this page.';

                    trigger OnAction()
                    begin
                        FindPush();
                        FilterSelectionChangedTxtVisible := false;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Enabled = PrintEnable;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                    trigger OnAction()
                    var
                        ItemTrackingNavigate: Report "Item Tracking Navigate";
                        DocumentEntries: Report "Document Entries";
                    begin
                        if ItemTrackingSearch then begin
                            Clear(ItemTrackingNavigate);
                            ItemTrackingNavigate.TransferDocEntries(Rec);
                            ItemTrackingNavigate.TransferRecordBuffer(TempRecordBuffer);
                            ItemTrackingNavigate.SetTrackingFilters(ItemTrackingFilters);
                            ItemTrackingNavigate.Run();
                        end else begin
                            DocumentEntries.TransferDocEntries(Rec);
                            DocumentEntries.TransferFilters(DocNoFilter, PostingDateFilter);
                            if NavigateDeposit then
                                DocumentEntries.SetExternal();
                            DocumentEntries.Run();
                        end;
                    end;
                }
            }
            group(FindGroup)
            {
                Caption = 'Find by';
                action(FindByDocument)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find by Document';
                    Image = Documents;
                    ToolTip = 'View entries based on the specified document number.';

                    trigger OnAction()
                    begin
                        SearchBasedOn := SearchBasedOn::Document;
                        UpdateFindByGroupsVisibility();
                    end;
                }
                action(FindByBusinessContact)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find by Business Contact';
                    Image = ContactPerson;
                    ToolTip = 'Filter entries based on the specified contact or contact type.';

                    trigger OnAction()
                    begin
                        SearchBasedOn := SearchBasedOn::"Business Contact";
                        UpdateFindByGroupsVisibility();
                    end;
                }
                action(FindByItemReference)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find by Item Reference';
                    Image = ItemTracking;
                    ToolTip = 'Filter entries based on the specified serial number or lot number.';

                    trigger OnAction()
                    begin
                        SearchBasedOn := SearchBasedOn::"Item Reference";
                        UpdateFindByGroupsVisibility();
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        SourceNameEnable := true;
        SourceNoEnable := true;
        SourceTypeEnable := true;
        DocTypeEnable := true;
        PrintEnable := true;
        ShowEnable := true;
        DocumentVisible := true;
        SearchBasedOn := SearchBasedOn::Document;
    end;

    trigger OnOpenPage()
    begin
        UpdateForm := true;
        FindRecordsOnOpen();
    end;

    var
        Text000: Label 'The business contact type was not specified.';
        Text001: Label 'There are no posted records with this external document number.';
        Text002: Label 'Counting records...';
        Text011: Label 'The document number has been used more than once.';
        Text012: Label 'This combination of document number and posting date has been used more than once.';
        Text013: Label 'There are no posted records with this document number.';
        Text014: Label 'There are no posted records with this combination of document number and posting date.';
        Text015: Label 'The search results in too many external documents. Specify a business contact no.';
        Text016: Label 'The search results in too many external documents. Use Navigate from the relevant ledger entries.';
        PostedSalesInvoiceTxt: Label 'Posted Sales Invoice';
        PostedSalesCreditMemoTxt: Label 'Posted Sales Credit Memo';
        PostedSalesShipmentTxt: Label 'Posted Sales Shipment';
        IssuedReminderTxt: Label 'Issued Reminder';
        IssuedFinanceChargeMemoTxt: Label 'Issued Finance Charge Memo';
        PostedPurchaseInvoiceTxt: Label 'Posted Purchase Invoice';
        PostedPurchaseCreditMemoTxt: Label 'Posted Purchase Credit Memo';
        PostedPurchaseReceiptTxt: Label 'Posted Purchase Receipt';
        PostedReturnReceiptTxt: Label 'Posted Return Receipt';
        PostedReturnShipmentTxt: Label 'Posted Return Shipment';
        PostedTransferShipmentTxt: Label 'Posted Transfer Shipment';
        PostedTransferReceiptTxt: Label 'Posted Transfer Receipt';
        PostedDirectTransferTxt: Label 'Posted Direct Transfer';
        SalesQuoteTxt: Label 'Sales Quote';
        SalesOrderTxt: Label 'Sales Order';
        SalesInvoiceTxt: Label 'Sales Invoice';
        SalesReturnOrderTxt: Label 'Sales Return Order';
        SalesCreditMemoTxt: Label 'Sales Credit Memo';
        PostedAssemblyOrderTxt: Label 'Posted Assembly Order';
        PostedServiceInvoiceTxt: Label 'Posted Service Invoice';
        PostedServiceCreditMemoTxt: Label 'Posted Service Credit Memo';
        PostedServiceShipmentTxt: Label 'Posted Service Shipment';
        ServiceOrderTxt: Label 'Service Order';
        ServiceInvoiceTxt: Label 'Service Invoice';
        ServiceCreditMemoTxt: Label 'Service Credit Memo';
        ProductionOrderTxt: Label 'Production Order';
        PostedGenJournalLineTxt: Label 'Posted Gen. Journal Line';
        [SecurityFiltering(SecurityFilter::Filtered)]
        Cust: Record Customer;
        [SecurityFiltering(SecurityFilter::Filtered)]
        Vend: Record Vendor;
        [SecurityFiltering(SecurityFilter::Filtered)]
        Bank: Record "Bank Account";
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesShptHeader: Record "Sales Shipment Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesInvHeader: Record "Sales Invoice Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReturnRcptHeader: Record "Return Receipt Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServShptHeader: Record "Service Shipment Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServInvHeader: Record "Service Invoice Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        IssuedReminderHeader: Record "Issued Reminder Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchInvHeader: Record "Purch. Inv. Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReturnShptHeader: Record "Return Shipment Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ProductionOrderHeader: Record "Production Order";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedAssemblyHeader: Record "Posted Assembly Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        TransShptHeader: Record "Transfer Shipment Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        TransRcptHeader: Record "Transfer Receipt Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        DirectTransHeader: Record "Direct Trans. Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        GLEntry: Record "G/L Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        VATEntry: Record "VAT Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntry: Record "Cust. Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        VendLedgEntry: Record "Vendor Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        EmplLedgEntry: Record "Employee Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ItemLedgEntry: Record "Item Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ResLedgEntry: Record "Res. Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobLedgEntry: Record "Job Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobWIPEntry: Record "Job WIP Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobWIPGLEntry: Record "Job WIP G/L Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ValueEntry: Record "Value Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        CheckLedgEntry: Record "Check Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        FALedgEntry: Record "FA Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        InsuranceCovLedgEntry: Record "Ins. Coverage Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        CapacityLedgEntry: Record "Capacity Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServLedgerEntry: Record "Service Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        WarrantyLedgerEntry: Record "Warranty Ledger Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        WhseEntry: Record "Warehouse Entry";
        TempRecordBuffer: Record "Record Buffer" temporary;
        [SecurityFiltering(SecurityFilter::Filtered)]
        CostEntry: Record "Cost Entry";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedDepositHeader: Record "Posted Deposit Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedDepositLine: Record "Posted Deposit Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        IncomingDocument: Record "Incoming Document";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedGenJournalLine: Record "Posted Gen. Journal Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedInvtRcptHeader: Record "Invt. Receipt Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedInvtShptHeader: Record "Invt. Shipment Header";
        ItemTrackingFilters: Record Item;
        NewItemTrackingSetup: Record "Item Tracking Setup";
        FilterTokens: Codeunit "Filter Tokens";
        ItemTrackingNavigateMgt: Codeunit "Item Tracking Navigate Mgt.";
        Window: Dialog;
        DocType: Text[100];
        SourceType: Text[30];
        SourceNo: Code[20];
        SourceName: Text[100];
        DocExists: Boolean;
        NavigateDeposit: Boolean;
        USText001: Label 'Before you can navigate on a deposit, you must create and activate a key group called "NavDep". If you cannot do this yourself, ask your system administrator.';
        SerialNoFilter: Text;
        LotNoFilter: Text;
        PackageNoFilter: Text;
        [InDataSet]
        ShowEnable: Boolean;
        [InDataSet]
        PrintEnable: Boolean;
        [InDataSet]
        DocTypeEnable: Boolean;
        [InDataSet]
        SourceTypeEnable: Boolean;
        [InDataSet]
        SourceNoEnable: Boolean;
        [InDataSet]
        SourceNameEnable: Boolean;
        UpdateForm: Boolean;
        SearchBasedOn: Enum "Navigate Search Type";
        [InDataSet]
        DocumentVisible: Boolean;
        [InDataSet]
        BusinessContactVisible: Boolean;
        [InDataSet]
        ItemReferenceVisible: Boolean;
        [InDataSet]
        FilterSelectionChangedTxtVisible: Boolean;
        PageCaptionTxt: Label 'Selected - %1';

    protected var
        SQSalesHeader: Record "Sales Header";
        SOSalesHeader: Record "Sales Header";
        SISalesHeader: Record "Sales Header";
        SROSalesHeader: Record "Sales Header";
        SCMSalesHeader: Record "Sales Header";
        SOServHeader: Record "Service Header";
        SIServHeader: Record "Service Header";
        SCMServHeader: Record "Service Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        PstdPhysInvtOrderHdr: Record "Pstd. Phys. Invt. Order Hdr";
        ContactNo: Code[250];
        ContactType: Enum "Navigate Contact Type";
        DocNoFilter: Text;
        PostingDateFilter: Text;
        ExtDocNo: Code[250];
        NewDocNo: Code[20];
        NewPostingDate: Date;
        NewSourceRecVar: Variant;

    procedure SetDoc(PostingDate: Date; DocNo: Code[20])
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
    end;

    procedure SetRec(SourceRecVar: Variant)
    begin
        NewSourceRecVar := SourceRecVar;

        OnAfterSetRec(NewSourceRecVar);
    end;

    procedure FindExtRecords()
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        VendLedgEntry2: Record "Vendor Ledger Entry";
        FoundRecords: Boolean;
        DateFilter2: Text;
        DocNoFilter2: Text;
    begin
        FoundRecords := false;
        case ContactType of
            ContactType::Vendor:
                begin
                    VendLedgEntry2.SetCurrentKey("External Document No.");
                    VendLedgEntry2.SetFilter("External Document No.", ExtDocNo);
                    VendLedgEntry2.SetFilter("Vendor No.", ContactNo);
                    if VendLedgEntry2.FindSet() then begin
                        repeat
                            MakeExtFilter(
                              DateFilter2,
                              VendLedgEntry2."Posting Date",
                              DocNoFilter2,
                              VendLedgEntry2."Document No.");
                        until VendLedgEntry2.Next() = 0;
                        SetPostingDate(DateFilter2);
                        SetDocNo(DocNoFilter2);
                        FindRecords();
                        FoundRecords := true;
                    end;
                end;
            ContactType::Customer:
                begin
                    Rec.DeleteAll();
                    Rec."Entry No." := 0;
                    FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Quote, SalesQuoteTxt, SQSalesHeader);
                    FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Order, SalesOrderTxt, SOSalesHeader);
                    FindUnpostedSalesDocs(SISalesHeader."Document Type"::Invoice, SalesInvoiceTxt, SISalesHeader);
                    FindUnpostedSalesDocs(SROSalesHeader."Document Type"::"Return Order", SalesReturnOrderTxt, SROSalesHeader);
                    FindUnpostedSalesDocs(SCMSalesHeader."Document Type"::"Credit Memo", SalesCreditMemoTxt, SCMSalesHeader);
                    if SalesShptHeader.ReadPermission() then begin
                        SalesShptHeader.Reset();
                        SalesShptHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
                        SalesShptHeader.SetFilter("Sell-to Customer No.", ContactNo);
                        SalesShptHeader.SetFilter("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(Rec, DATABASE::"Sales Shipment Header", PostedSalesShipmentTxt, SalesShptHeader.Count);
                    end;
                    if SalesInvHeader.ReadPermission() then begin
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
                        SalesInvHeader.SetFilter("Sell-to Customer No.", ContactNo);
                        SalesInvHeader.SetFilter("External Document No.", ExtDocNo);
                        OnFindExtRecordsOnAfterSetSalesInvoiceFilter(SalesInvHeader);
                        InsertIntoDocEntry(Rec, DATABASE::"Sales Invoice Header", PostedSalesInvoiceTxt, SalesInvHeader.Count);
                    end;
                    if ReturnRcptHeader.ReadPermission() then begin
                        ReturnRcptHeader.Reset();
                        ReturnRcptHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
                        ReturnRcptHeader.SetFilter("Sell-to Customer No.", ContactNo);
                        ReturnRcptHeader.SetFilter("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(Rec, DATABASE::"Return Receipt Header", PostedReturnReceiptTxt, ReturnRcptHeader.Count);
                    end;
                    if SalesCrMemoHeader.ReadPermission() then begin
                        SalesCrMemoHeader.Reset();
                        SalesCrMemoHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
                        SalesCrMemoHeader.SetFilter("Sell-to Customer No.", ContactNo);
                        SalesCrMemoHeader.SetFilter("External Document No.", ExtDocNo);
                        OnFindExtRecordsOnAfterSetSalesCrMemoFilter(SalesCrMemoHeader);
                        InsertIntoDocEntry(Rec, DATABASE::"Sales Cr.Memo Header", PostedSalesCreditMemoTxt, SalesCrMemoHeader.Count);
                    end;
                    FindUnpostedServDocs(SOServHeader."Document Type"::Order, ServiceOrderTxt, SOServHeader);
                    FindUnpostedServDocs(SIServHeader."Document Type"::Invoice, ServiceInvoiceTxt, SIServHeader);
                    FindUnpostedServDocs(SCMServHeader."Document Type"::"Credit Memo", ServiceCreditMemoTxt, SCMServHeader);
                    if ServShptHeader.ReadPermission() then
                        if ExtDocNo = '' then begin
                            ServShptHeader.Reset();
                            ServShptHeader.SetCurrentKey("Customer No.");
                            ServShptHeader.SetFilter("Customer No.", ContactNo);
                            InsertIntoDocEntry(Rec, DATABASE::"Service Shipment Header", PostedServiceShipmentTxt, ServShptHeader.Count);
                        end;
                    if ServInvHeader.ReadPermission() then
                        if ExtDocNo = '' then begin
                            ServInvHeader.Reset();
                            ServInvHeader.SetCurrentKey("Customer No.");
                            ServInvHeader.SetFilter("Customer No.", ContactNo);
                            InsertIntoDocEntry(Rec, DATABASE::"Service Invoice Header", PostedServiceInvoiceTxt, ServInvHeader.Count);
                        end;
                    if ServCrMemoHeader.ReadPermission() then
                        if ExtDocNo = '' then begin
                            ServCrMemoHeader.Reset();
                            ServCrMemoHeader.SetCurrentKey("Customer No.");
                            ServCrMemoHeader.SetFilter("Customer No.", ContactNo);
                            InsertIntoDocEntry(Rec, DATABASE::"Service Cr.Memo Header", PostedServiceCreditMemoTxt, ServCrMemoHeader.Count);
                        end;

                    OnFindExtRecordsOnBeforeFormUpdate(Rec, SalesInvHeader, SalesCrMemoHeader);
                    UpdateFormAfterFindRecords();
                    FoundRecords := DocExists;
                end;
            else
                Error(Text000);
        end;

        OnAfterNavigateFindExtRecords(Rec, ContactType, ContactNo, ExtDocNo, FoundRecords);

        if not FoundRecords then begin
            SetSource(0D, '', '', 0, '');
            Message(Text001);
        end;
    end;

    local procedure FindRecords()
    var
        DocType2: Text[100];
        DocNo2: Code[20];
        SourceType2: Integer;
        SourceNo2: Code[20];
        PostingDate: Date;
        IsSourceUpdated: Boolean;
        HideDialog: Boolean;
    begin
        OnBeforeFindRecords(HideDialog);
        if not HideDialog then
            Window.Open(Text002);
        Rec.Reset;
        Rec.DeleteAll();
        Rec."Entry No." := 0;

        FindPostedDocuments();
        FindLedgerEntries();

        OnAfterNavigateFindRecords(Rec, DocNoFilter, PostingDateFilter, NewSourceRecVar);
        DocExists := Rec.FindFirst();

        SetSource(0D, '', '', 0, '');
        if DocExists then begin
            if (NoOfRecords(DATABASE::"Cust. Ledger Entry") + NoOfRecords(DATABASE::"Vendor Ledger Entry") <= 1) and
               (GetDocumentCount <= 1)
            then begin
                SetSourceForService();
                SetSourceForSales();
                SetSourceForPurchase();
                SetSourceForServiceDoc();

                IsSourceUpdated := false;
                OnFindRecordsOnAfterSetSource(
                  Rec, PostingDate, DocType2, DocNo2, SourceType2, SourceNo2, DocNoFilter, PostingDateFilter, IsSourceUpdated);
                if IsSourceUpdated then
                    SetSource(PostingDate, DocType2, DocNo2, SourceType2, SourceNo2);
            end else begin
                if DocNoFilter <> '' then
                    if PostingDateFilter = '' then
                        Message(Text011)
                    else
                        Message(Text012);
            end;
        end else
            if PostingDateFilter = '' then
                Message(Text013)
            else
                Message(Text014);

        OnAfterFindRecords(Rec, DocNoFilter, PostingDateFilter);

        if UpdateForm then
            UpdateFormAfterFindRecords();

        if not HideDialog then
            Window.Close();
    end;

    local procedure FindLedgerEntries()
    begin
        FindGLEntries();
        FindVATEntries();
        FindCustEntries();
        FindReminderEntries();
        FindVendEntries();
        FindInvtEntries();
        FindResEntries();
        FindJobEntries();
        FindBankEntries();
        FindFAEntries();
        FindCapEntries();
        FindWhseEntries();
        FindServEntries();
        FindCostEntries();
        FindPostedGenJournalLine();
    end;

    local procedure FindCustEntries()
    begin
        if CustLedgEntry.ReadPermission() then begin
            CustLedgEntry.Reset();
            CustLedgEntry.SetCurrentKey("Document No.");
            CustLedgEntry.SetFilter("Document No.", DocNoFilter);
            CustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Cust. Ledger Entry", CustLedgEntry.TableCaption, CustLedgEntry.Count);
        end;
        if DtldCustLedgEntry.ReadPermission() then begin
            DtldCustLedgEntry.Reset();
            DtldCustLedgEntry.SetCurrentKey("Document No.");
            DtldCustLedgEntry.SetFilter("Document No.", DocNoFilter);
            DtldCustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Detailed Cust. Ledg. Entry", DtldCustLedgEntry.TableCaption, DtldCustLedgEntry.Count);
        end;
    end;

    local procedure FindVendEntries()
    begin
        if VendLedgEntry.ReadPermission() then begin
            VendLedgEntry.Reset();
            VendLedgEntry.SetCurrentKey("Document No.");
            VendLedgEntry.SetFilter("Document No.", DocNoFilter);
            VendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Vendor Ledger Entry", VendLedgEntry.TableCaption, VendLedgEntry.Count);
        end;
        if DtldVendLedgEntry.ReadPermission() then begin
            DtldVendLedgEntry.Reset();
            DtldVendLedgEntry.SetCurrentKey("Document No.");
            DtldVendLedgEntry.SetFilter("Document No.", DocNoFilter);
            DtldVendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Detailed Vendor Ledg. Entry", DtldVendLedgEntry.TableCaption, DtldVendLedgEntry.Count);
        end;
    end;

    local procedure FindBankEntries()
    begin
        if BankAccLedgEntry.ReadPermission() then begin
            BankAccLedgEntry.Reset();
            BankAccLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            BankAccLedgEntry.SetFilter("Document No.", DocNoFilter);
            BankAccLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Bank Account Ledger Entry", BankAccLedgEntry.TableCaption, BankAccLedgEntry.Count);
        end;
        if CheckLedgEntry.ReadPermission() then begin
            CheckLedgEntry.Reset();
            CheckLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            CheckLedgEntry.SetFilter("Document No.", DocNoFilter);
            CheckLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Check Ledger Entry", CheckLedgEntry.TableCaption, CheckLedgEntry.Count);
        end;
    end;

    local procedure FindGLEntries()
    begin
        if GLEntry.ReadPermission() then begin
            GLEntry.Reset();
            GLEntry.SetCurrentKey("Document No.", "Posting Date");
            GLEntry.SetFilter("Document No.", DocNoFilter);
            GLEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"G/L Entry", GLEntry.TableCaption, GLEntry.Count);
        end;
    end;

    local procedure FindVATEntries()
    begin
        if VATEntry.ReadPermission() then begin
            VATEntry.Reset();
            VATEntry.SetCurrentKey("Document No.", "Posting Date");
            VATEntry.SetFilter("Document No.", DocNoFilter);
            VATEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"VAT Entry", VATEntry.TableCaption, VATEntry.Count);
        end;
    end;

    local procedure FindFAEntries()
    begin
        if FALedgEntry.ReadPermission() then begin
            FALedgEntry.Reset();
            FALedgEntry.SetCurrentKey("Document No.", "Posting Date");
            FALedgEntry.SetFilter("Document No.", DocNoFilter);
            FALedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"FA Ledger Entry", FALedgEntry.TableCaption, FALedgEntry.Count);
        end;
        if MaintenanceLedgEntry.ReadPermission() then begin
            MaintenanceLedgEntry.Reset();
            MaintenanceLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            MaintenanceLedgEntry.SetFilter("Document No.", DocNoFilter);
            MaintenanceLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Maintenance Ledger Entry", MaintenanceLedgEntry.TableCaption, MaintenanceLedgEntry.Count);
        end;
        if InsuranceCovLedgEntry.ReadPermission() then begin
            InsuranceCovLedgEntry.Reset();
            InsuranceCovLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            InsuranceCovLedgEntry.SetFilter("Document No.", DocNoFilter);
            InsuranceCovLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Ins. Coverage Ledger Entry", InsuranceCovLedgEntry.TableCaption, InsuranceCovLedgEntry.Count);
        end;
    end;

    local procedure FindInvtEntries()
    begin
        if ItemLedgEntry.ReadPermission() then begin
            ItemLedgEntry.Reset();
            ItemLedgEntry.SetCurrentKey("Document No.");
            ItemLedgEntry.SetFilter("Document No.", DocNoFilter);
            ItemLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Item Ledger Entry", ItemLedgEntry.TableCaption, ItemLedgEntry.Count);
        end;
        if ValueEntry.ReadPermission() then begin
            ValueEntry.Reset();
            ValueEntry.SetCurrentKey("Document No.");
            ValueEntry.SetFilter("Document No.", DocNoFilter);
            ValueEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Value Entry", ValueEntry.TableCaption, ValueEntry.Count);
        end;
        if PhysInvtLedgEntry.ReadPermission() then begin
            PhysInvtLedgEntry.Reset();
            PhysInvtLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            PhysInvtLedgEntry.SetFilter("Document No.", DocNoFilter);
            PhysInvtLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Phys. Inventory Ledger Entry", PhysInvtLedgEntry.TableCaption, PhysInvtLedgEntry.Count);
        end;
    end;

    local procedure FindReminderEntries()
    begin
        if ReminderEntry.ReadPermission() then begin
            ReminderEntry.Reset();
            ReminderEntry.SetCurrentKey(Type, "No.");
            ReminderEntry.SetFilter("No.", DocNoFilter);
            ReminderEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Reminder/Fin. Charge Entry", ReminderEntry.TableCaption, ReminderEntry.Count);
        end;
    end;

    local procedure FindResEntries()
    begin
        if ResLedgEntry.ReadPermission() then begin
            ResLedgEntry.Reset();
            ResLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            ResLedgEntry.SetFilter("Document No.", DocNoFilter);
            ResLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Res. Ledger Entry", ResLedgEntry.TableCaption, ResLedgEntry.Count);
        end;
    end;

    local procedure FindServEntries()
    begin
        if ServLedgerEntry.ReadPermission() then begin
            ServLedgerEntry.Reset();
            ServLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
            ServLedgerEntry.SetFilter("Document No.", DocNoFilter);
            ServLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Service Ledger Entry", ServLedgerEntry.TableCaption, ServLedgerEntry.Count);
        end;
        if WarrantyLedgerEntry.ReadPermission() then begin
            WarrantyLedgerEntry.Reset();
            WarrantyLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
            WarrantyLedgerEntry.SetFilter("Document No.", DocNoFilter);
            WarrantyLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Warranty Ledger Entry", WarrantyLedgerEntry.TableCaption, WarrantyLedgerEntry.Count);
        end;
    end;

    local procedure FindCapEntries()
    begin
        if CapacityLedgEntry.ReadPermission() then begin
            CapacityLedgEntry.Reset();
            CapacityLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            CapacityLedgEntry.SetFilter("Document No.", DocNoFilter);
            CapacityLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Capacity Ledger Entry", CapacityLedgEntry.TableCaption, CapacityLedgEntry.Count);
        end;
    end;

    local procedure FindCostEntries()
    begin
        if CostEntry.ReadPermission() then begin
            CostEntry.Reset();
            CostEntry.SetCurrentKey("Document No.", "Posting Date");
            CostEntry.SetFilter("Document No.", DocNoFilter);
            CostEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Cost Entry", CostEntry.TableCaption, CostEntry.Count);
        end;
    end;

    local procedure FindWhseEntries()
    begin
        if WhseEntry.ReadPermission() then begin
            WhseEntry.Reset();
            WhseEntry.SetCurrentKey("Reference No.", "Registering Date");
            WhseEntry.SetFilter("Reference No.", DocNoFilter);
            WhseEntry.SetFilter("Registering Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Warehouse Entry", WhseEntry.TableCaption, WhseEntry.Count);
        end;
    end;

    local procedure FindJobEntries()
    begin
        if JobLedgEntry.ReadPermission() then begin
            JobLedgEntry.Reset();
            JobLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            JobLedgEntry.SetFilter("Document No.", DocNoFilter);
            JobLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Job Ledger Entry", JobLedgEntry.TableCaption, JobLedgEntry.Count);
        end;
        if JobWIPEntry.ReadPermission() then begin
            JobWIPEntry.Reset();
            JobWIPEntry.SetFilter("Document No.", DocNoFilter);
            JobWIPEntry.SetFilter("WIP Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Job WIP Entry", JobWIPEntry.TableCaption, JobWIPEntry.Count);
        end;
        if JobWIPGLEntry.ReadPermission() then begin
            JobWIPGLEntry.Reset();
            JobWIPGLEntry.SetCurrentKey("Document No.", "Posting Date");
            JobWIPGLEntry.SetFilter("Document No.", DocNoFilter);
            JobWIPGLEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Job WIP G/L Entry", JobWIPGLEntry.TableCaption, JobWIPGLEntry.Count);
        end;
    end;

    local procedure FindPostedDocuments()
    begin
        FindIncomingDocumentRecords();
        FindEmployeeRecords();
        FindSalesShipmentHeader();
        FindSalesInvoiceHeader();
        FindReturnRcptHeader();
        FindSalesCrMemoHeader();
        FindServShipmentHeader();
        FindServInvoiceHeader();
        FindServCrMemoHeader();
        FindIssuedReminderHeader();
        FindIssuedFinChrgMemoHeader();
        FindPurchRcptHeader();
        FindPurchInvoiceHeader();
        FindReturnShptHeader();
        FindPurchCrMemoHeader();
        FindProdOrderHeader();
        FindPostedAssemblyHeader();
        FindTransShptHeader();
        FindTransRcptHeader();
        FindDirectTransHeader();
        FindPstdPhysInvtOrderHdr();
        FindPostedWhseShptLine();
        FindPostedWhseRcptLine();
        FindPostedInvtReceipt();
        FindPostedInvtShipment();
        FindPostedDepositHeader();
        FindPostedDepositLine();

        OnAfterFindPostedDocuments(DocNoFilter, PostingDateFilter);
    end;

    local procedure FindIncomingDocumentRecords()
    begin
        if IncomingDocument.ReadPermission() then begin
            IncomingDocument.Reset();
            IncomingDocument.SetFilter("Document No.", DocNoFilter);
            IncomingDocument.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Incoming Document", IncomingDocument.TableCaption, IncomingDocument.Count);
        end;
    end;

    local procedure FindSalesShipmentHeader()
    begin
        if SalesShptHeader.ReadPermission() then begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetFilter("No.", DocNoFilter);
            SalesShptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Sales Shipment Header", PostedSalesShipmentTxt, SalesShptHeader.Count);
        end;
    end;

    local procedure FindSalesInvoiceHeader()
    begin
        if SalesInvHeader.ReadPermission() then begin
            SalesInvHeader.Reset();
            SalesInvHeader.SetFilter("No.", DocNoFilter);
            SalesInvHeader.SetFilter("Posting Date", PostingDateFilter);
            OnFindSalesInvoiceHeaderOnAfterSetFilters(SalesInvHeader);
            InsertIntoDocEntry(Rec, DATABASE::"Sales Invoice Header", PostedSalesInvoiceTxt, SalesInvHeader.Count);
        end;
    end;

    local procedure FindSalesCrMemoHeader()
    begin
        if SalesCrMemoHeader.ReadPermission() then begin
            SalesCrMemoHeader.Reset();
            SalesCrMemoHeader.SetFilter("No.", DocNoFilter);
            SalesCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
            OnFindSalesCrMemoHeaderOnAfterSetFilters(SalesCrMemoHeader);
            InsertIntoDocEntry(Rec, DATABASE::"Sales Cr.Memo Header", PostedSalesCreditMemoTxt, SalesCrMemoHeader.Count);
        end;
    end;

    local procedure FindReturnRcptHeader()
    begin
        if ReturnRcptHeader.ReadPermission() then begin
            ReturnRcptHeader.Reset();
            ReturnRcptHeader.SetFilter("No.", DocNoFilter);
            ReturnRcptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Return Receipt Header", PostedReturnReceiptTxt, ReturnRcptHeader.Count);
        end;
    end;

    local procedure FindServShipmentHeader()
    begin
        if ServShptHeader.ReadPermission() then begin
            ServShptHeader.Reset();
            ServShptHeader.SetFilter("No.", DocNoFilter);
            ServShptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Service Shipment Header", PostedServiceShipmentTxt, ServShptHeader.Count);
        end;
    end;

    local procedure FindServInvoiceHeader()
    begin
        if ServInvHeader.ReadPermission() then begin
            ServInvHeader.Reset();
            ServInvHeader.SetFilter("No.", DocNoFilter);
            ServInvHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Service Invoice Header", PostedServiceInvoiceTxt, ServInvHeader.Count);
        end;
    end;

    local procedure FindServCrMemoHeader()
    begin
        if ServCrMemoHeader.ReadPermission() then begin
            ServCrMemoHeader.Reset();
            ServCrMemoHeader.SetFilter("No.", DocNoFilter);
            ServCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Service Cr.Memo Header", PostedServiceCreditMemoTxt, ServCrMemoHeader.Count);
        end;
    end;

    local procedure FindEmployeeRecords()
    begin
        if EmplLedgEntry.ReadPermission() then begin
            EmplLedgEntry.Reset();
            EmplLedgEntry.SetCurrentKey("Document No.");
            EmplLedgEntry.SetFilter("Document No.", DocNoFilter);
            EmplLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Employee Ledger Entry", EmplLedgEntry.TableCaption, EmplLedgEntry.Count);
        end;
        if DtldEmplLedgEntry.ReadPermission() then begin
            DtldEmplLedgEntry.Reset();
            DtldEmplLedgEntry.SetCurrentKey("Document No.");
            DtldEmplLedgEntry.SetFilter("Document No.", DocNoFilter);
            DtldEmplLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Detailed Employee Ledger Entry", DtldEmplLedgEntry.TableCaption, DtldEmplLedgEntry.Count);
        end;
    end;

    local procedure FindIssuedReminderHeader()
    begin
        if IssuedReminderHeader.ReadPermission() then begin
            IssuedReminderHeader.Reset();
            IssuedReminderHeader.SetFilter("No.", DocNoFilter);
            IssuedReminderHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Issued Reminder Header", IssuedReminderTxt, IssuedReminderHeader.Count);
        end;
    end;

    local procedure FindIssuedFinChrgMemoHeader()
    begin
        if IssuedFinChrgMemoHeader.ReadPermission() then begin
            IssuedFinChrgMemoHeader.Reset();
            IssuedFinChrgMemoHeader.SetFilter("No.", DocNoFilter);
            IssuedFinChrgMemoHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(
                Rec, DATABASE::"Issued Fin. Charge Memo Header", IssuedFinanceChargeMemoTxt, IssuedFinChrgMemoHeader.Count);
        end;
    end;

    local procedure FindPurchRcptHeader()
    begin
        if PurchRcptHeader.ReadPermission() then begin
            PurchRcptHeader.Reset();
            PurchRcptHeader.SetFilter("No.", DocNoFilter);
            PurchRcptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Purch. Rcpt. Header", PostedPurchaseReceiptTxt, PurchRcptHeader.Count);
        end;
    end;

    local procedure FindPurchInvoiceHeader()
    begin
        if PurchInvHeader.ReadPermission() then begin
            PurchInvHeader.Reset();
            PurchInvHeader.SetFilter("No.", DocNoFilter);
            PurchInvHeader.SetFilter("Posting Date", PostingDateFilter);
            OnFindPurchInvoiceHeaderOnAfterSetFilters(PurchInvHeader);
            InsertIntoDocEntry(Rec, DATABASE::"Purch. Inv. Header", PostedPurchaseInvoiceTxt, PurchInvHeader.Count);
        end;
    end;

    local procedure FindPurchCrMemoHeader()
    begin
        if PurchCrMemoHeader.ReadPermission() then begin
            PurchCrMemoHeader.Reset();
            PurchCrMemoHeader.SetFilter("No.", DocNoFilter);
            PurchCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
            OnFindPurchCrMemoHeaderOnAfterSetFilters(PurchCrMemoHeader);
            InsertIntoDocEntry(Rec, DATABASE::"Purch. Cr. Memo Hdr.", PostedPurchaseCreditMemoTxt, PurchCrMemoHeader.Count);
        end;
    end;

    local procedure FindReturnShptHeader()
    begin
        if ReturnShptHeader.ReadPermission() then begin
            ReturnShptHeader.Reset();
            ReturnShptHeader.SetFilter("No.", DocNoFilter);
            ReturnShptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Return Shipment Header", PostedReturnShipmentTxt, ReturnShptHeader.Count);
        end;
    end;

    local procedure FindProdOrderHeader()
    begin
        if ProductionOrderHeader.ReadPermission() then begin
            ProductionOrderHeader.Reset();
            ProductionOrderHeader.SetRange(
              Status,
              ProductionOrderHeader.Status::Released,
              ProductionOrderHeader.Status::Finished);
            ProductionOrderHeader.SetFilter("No.", DocNoFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Production Order", ProductionOrderTxt, ProductionOrderHeader.Count);
        end;
    end;

    local procedure FindPostedAssemblyHeader()
    begin
        if PostedAssemblyHeader.ReadPermission() then begin
            PostedAssemblyHeader.Reset();
            PostedAssemblyHeader.SetFilter("No.", DocNoFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Assembly Header", PostedAssemblyOrderTxt, PostedAssemblyHeader.Count);
        end;
    end;

    local procedure FindPostedWhseShptLine()
    begin
        if PostedWhseShptLine.ReadPermission() then begin
            PostedWhseShptLine.Reset();
            PostedWhseShptLine.SetCurrentKey("Posted Source No.", "Posting Date");
            PostedWhseShptLine.SetFilter("Posted Source No.", DocNoFilter);
            PostedWhseShptLine.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Whse. Shipment Line", PostedWhseShptLine.TableCaption, PostedWhseShptLine.Count);
        end;
    end;

    local procedure FindPostedWhseRcptLine()
    begin
        if PostedWhseRcptLine.ReadPermission() then begin
            PostedWhseRcptLine.Reset();
            PostedWhseRcptLine.SetCurrentKey("Posted Source No.", "Posting Date");
            PostedWhseRcptLine.SetFilter("Posted Source No.", DocNoFilter);
            PostedWhseRcptLine.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Whse. Receipt Line", PostedWhseRcptLine.TableCaption, PostedWhseRcptLine.Count);
        end;
    end;

    local procedure FindPstdPhysInvtOrderHdr()
    begin
        if PstdPhysInvtOrderHdr.ReadPermission() then begin
            PstdPhysInvtOrderHdr.Reset();
            PstdPhysInvtOrderHdr.SetFilter("No.", DocNoFilter);
            PstdPhysInvtOrderHdr.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Pstd. Phys. Invt. Order Hdr", PstdPhysInvtOrderHdr.TableCaption, PstdPhysInvtOrderHdr.Count);
        end;
    end;

    local procedure FindTransShptHeader()
    begin
        if TransShptHeader.ReadPermission() then begin
            TransShptHeader.Reset();
            TransShptHeader.SetFilter("No.", DocNoFilter);
            TransShptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Transfer Shipment Header", PostedTransferShipmentTxt, TransShptHeader.Count);
        end;
    end;

    local procedure FindTransRcptHeader()
    begin
        if TransRcptHeader.ReadPermission() then begin
            TransRcptHeader.Reset();
            TransRcptHeader.SetFilter("No.", DocNoFilter);
            TransRcptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Transfer Receipt Header", PostedTransferReceiptTxt, TransRcptHeader.Count);
        end;
    end;

    local procedure FindDirectTransHeader()
    begin
        if DirectTransHeader.ReadPermission() then begin
            DirectTransHeader.Reset();
            DirectTransHeader.SetFilter("No.", DocNoFilter);
            DirectTransHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Direct Trans. Header", PostedDirectTransferTxt, DirectTransHeader.Count);
        end;
    end;

    local procedure FindPostedInvtReceipt()
    begin
        if PostedInvtRcptHeader.ReadPermission() then begin
            PostedInvtRcptHeader.Reset();
            PostedInvtRcptHeader.SetFilter("No.", DocNoFilter);
            PostedInvtRcptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Invt. Receipt Header", PostedInvtRcptHeader.TableCaption, PostedInvtRcptHeader.Count);
        end;
    end;

    local procedure FindPostedInvtShipment()
    begin
        if PostedInvtShptHeader.ReadPermission() then begin
            PostedInvtShptHeader.Reset();
            PostedInvtShptHeader.SetFilter("No.", DocNoFilter);
            PostedInvtShptHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Invt. Shipment Header", PostedInvtShptHeader.TableCaption, PostedInvtShptHeader.Count);
        end;
    end;

    local procedure FindPostedDepositHeader()
    begin
        if PostedDepositHeader.ReadPermission then begin
            PostedDepositHeader.Reset();
            PostedDepositHeader.SetFilter("No.", DocNoFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Header", 0, PostedDepositHeader.TableCaption, PostedDepositHeader.Count);
        end;
    end;

    local procedure FindPostedDepositLine()
    begin
        if PostedDepositLine.ReadPermission then begin
            PostedDepositLine.Reset();
            PostedDepositLine.SetCurrentKey("Document No.", "Posting Date");
            PostedDepositLine.SetFilter("Document No.", DocNoFilter);
            PostedDepositLine.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Line", 0, PostedDepositLine.TableCaption, PostedDepositLine.Count);
        end;
    end;

    local procedure UpdateFormAfterFindRecords()
    begin
        OnBeforeUpdateFormAfterFindRecords();

        DocExists := Rec.FindFirst();
        ShowEnable := DocExists;
        PrintEnable := DocExists;
        CurrPage.Update(false);
    end;

    procedure InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        InsertIntoDocEntry(TempDocumentEntry, DocTableID, "Document Entry Document Type"::" ", DocTableName, DocNoOfRecords);
    end;

    procedure InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Enum "Document Entry Document Type"; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;

        TempDocumentEntry.Init();
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(Rec."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry.Insert();
    end;

    protected procedure NoOfRecords(TableID: Integer): Integer
    begin
        Rec.SetRange("Table ID", TableID);
        if not Rec.FindFirst() then
            Rec.Init();
        Rec.SetRange("Table ID");
        exit(Rec."No. of Records");
    end;

    procedure SetSource(PostingDate: Date; DocType2: Text[100]; DocNo: Text[50]; SourceType2: Integer; SourceNo2: Code[20])
    begin
        if SourceType2 = 0 then begin
            DocType := '';
            SourceType := '';
            SourceNo := '';
            SourceName := '';
        end else begin
            DocType := DocType2;
            SourceNo := SourceNo2;
            Rec.SetRange("Document No.", DocNo);
            Rec.SetRange("Posting Date", PostingDate);
            DocNoFilter := Rec.GetFilter("Document No.");
            PostingDateFilter := Rec.GetFilter("Posting Date");
            case SourceType2 of
                1:
                    begin
                        SourceType := CopyStr(Cust.TableCaption(), 1, MaxStrLen(SourceType));
                        if not Cust.Get(SourceNo) then
                            Cust.Init();
                        SourceName := Cust.Name;
                    end;
                2:
                    begin
                        SourceType := CopyStr(Vend.TableCaption(), 1, MaxStrLen(SourceType));
                        if not Vend.Get(SourceNo) then
                            Vend.Init();
                        SourceName := Vend.Name;
                    end;
                4:
                    begin
                        SourceType := Bank.TableCaption;
                        if not Bank.Get(SourceNo) then
                            Bank.Init();
                        SourceName := Bank.Name;
                    end;
            end;
        end;
        DocTypeEnable := SourceType2 <> 0;
        SourceTypeEnable := SourceType2 <> 0;
        SourceNoEnable := SourceType2 <> 0;
        SourceNameEnable := SourceType2 <> 0;

        OnAfterSetSource(SourceType2, SourceType, SourceNo, SourceName);
    end;

    local procedure SetSourceForPurchase()
    begin
        if NoOfRecords(DATABASE::"Vendor Ledger Entry") = 1 then begin
            VendLedgEntry.FindFirst();
            SetSource(
              VendLedgEntry."Posting Date", Format(VendLedgEntry."Document Type"), VendLedgEntry."Document No.",
              2, VendLedgEntry."Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Detailed Vendor Ledg. Entry") = 1 then begin
            DtldVendLedgEntry.FindFirst();
            SetSource(
              DtldVendLedgEntry."Posting Date", Format(DtldVendLedgEntry."Document Type"), DtldVendLedgEntry."Document No.",
              2, DtldVendLedgEntry."Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Purch. Inv. Header") = 1 then begin
            PurchInvHeader.FindFirst();
            SetSource(
              PurchInvHeader."Posting Date", Format("Table Name"), PurchInvHeader."No.",
              2, PurchInvHeader."Pay-to Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") = 1 then begin
            PurchCrMemoHeader.FindFirst();
            SetSource(
              PurchCrMemoHeader."Posting Date", Format("Table Name"), PurchCrMemoHeader."No.",
              2, PurchCrMemoHeader."Pay-to Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Return Shipment Header") = 1 then begin
            ReturnShptHeader.FindFirst();
            SetSource(
              ReturnShptHeader."Posting Date", Format("Table Name"), ReturnShptHeader."No.",
              2, ReturnShptHeader."Buy-from Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Purch. Rcpt. Header") = 1 then begin
            PurchRcptHeader.FindFirst();
            SetSource(
              PurchRcptHeader."Posting Date", Format("Table Name"), PurchRcptHeader."No.",
              2, PurchRcptHeader."Buy-from Vendor No.");
        end;
        if NoOfRecords(DATABASE::"Posted Whse. Receipt Line") = 1 then begin
            PostedWhseRcptLine.FindFirst();
            SetSource(
              PostedWhseRcptLine."Posting Date", Format("Table Name"), PostedWhseRcptLine."Posted Source No.",
              2, '');
        end;
        if NoOfRecords(DATABASE::"Pstd. Phys. Invt. Order Hdr") = 1 then begin
            PstdPhysInvtOrderHdr.FindFirst();
            SetSource(
              PstdPhysInvtOrderHdr."Posting Date", Format("Table Name"), PstdPhysInvtOrderHdr."No.",
              3, '');
        end;
        if NoOfRecords(DATABASE::"Posted Deposit Header") = 1 then begin
            PostedDepositHeader.FindFirst;
            SetSource(
                PostedDepositHeader."Posting Date", Format("Table Name"), PostedDepositHeader."No.",
                4, PostedDepositHeader."Bank Account No.");
        end;

        OnAfterSetSourceForPurchase();
    end;

    local procedure SetSourceForSales()
    begin
        if NoOfRecords(DATABASE::"Cust. Ledger Entry") = 1 then begin
            CustLedgEntry.FindFirst();
            SetSource(
              CustLedgEntry."Posting Date", Format(CustLedgEntry."Document Type"), CustLedgEntry."Document No.",
              1, CustLedgEntry."Customer No.");
        end;
        if NoOfRecords(DATABASE::"Detailed Cust. Ledg. Entry") = 1 then begin
            DtldCustLedgEntry.FindFirst();
            SetSource(
              DtldCustLedgEntry."Posting Date", Format(DtldCustLedgEntry."Document Type"), DtldCustLedgEntry."Document No.",
              1, DtldCustLedgEntry."Customer No.");
        end;
        if NoOfRecords(DATABASE::"Sales Invoice Header") = 1 then begin
            SalesInvHeader.FindFirst();
            SetSource(
              SalesInvHeader."Posting Date", Format("Table Name"), SalesInvHeader."No.",
              1, SalesInvHeader."Bill-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Sales Cr.Memo Header") = 1 then begin
            SalesCrMemoHeader.FindFirst();
            SetSource(
              SalesCrMemoHeader."Posting Date", Format("Table Name"), SalesCrMemoHeader."No.",
              1, SalesCrMemoHeader."Bill-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Return Receipt Header") = 1 then begin
            ReturnRcptHeader.FindFirst();
            SetSource(
              ReturnRcptHeader."Posting Date", Format("Table Name"), ReturnRcptHeader."No.",
              1, ReturnRcptHeader."Sell-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Sales Shipment Header") = 1 then begin
            SalesShptHeader.FindFirst();
            SetSource(
              SalesShptHeader."Posting Date", Format("Table Name"), SalesShptHeader."No.",
              1, SalesShptHeader."Sell-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Posted Whse. Shipment Line") = 1 then begin
            PostedWhseShptLine.FindFirst();
            SetSource(
              PostedWhseShptLine."Posting Date", Format("Table Name"), PostedWhseShptLine."Posted Source No.",
              1, PostedWhseShptLine."Destination No.");
        end;
        if NoOfRecords(DATABASE::"Issued Reminder Header") = 1 then begin
            IssuedReminderHeader.FindFirst();
            SetSource(
              IssuedReminderHeader."Posting Date", Format("Table Name"), IssuedReminderHeader."No.",
              1, IssuedReminderHeader."Customer No.");
        end;
        if NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") = 1 then begin
            IssuedFinChrgMemoHeader.FindFirst();
            SetSource(
              IssuedFinChrgMemoHeader."Posting Date", Format("Table Name"), IssuedFinChrgMemoHeader."No.",
              1, IssuedFinChrgMemoHeader."Customer No.");
        end;
    end;

    local procedure SetSourceForService()
    begin
        if NoOfRecords(DATABASE::"Service Ledger Entry") = 1 then begin
            ServLedgerEntry.FindFirst();
            if ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract" then
                SetSource(
                  ServLedgerEntry."Posting Date", Format(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
                  2, ServLedgerEntry."Service Contract No.")
            else
                SetSource(
                  ServLedgerEntry."Posting Date", Format(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
                  2, ServLedgerEntry."Service Order No.")
        end;
        if NoOfRecords(DATABASE::"Warranty Ledger Entry") = 1 then begin
            WarrantyLedgerEntry.FindFirst();
            SetSource(
              WarrantyLedgerEntry."Posting Date", '', WarrantyLedgerEntry."Document No.",
              2, WarrantyLedgerEntry."Service Order No.")
        end;
    end;

    local procedure SetSourceForServiceDoc()
    begin
        if NoOfRecords(DATABASE::"Service Invoice Header") = 1 then begin
            ServInvHeader.FindFirst();
            SetSource(
              ServInvHeader."Posting Date", Format(Rec."Table Name"), ServInvHeader."No.",
              1, ServInvHeader."Bill-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Service Cr.Memo Header") = 1 then begin
            ServCrMemoHeader.FindFirst();
            SetSource(
              ServCrMemoHeader."Posting Date", Format(Rec."Table Name"), ServCrMemoHeader."No.",
              1, ServCrMemoHeader."Bill-to Customer No.");
        end;
        if NoOfRecords(DATABASE::"Service Shipment Header") = 1 then begin
            ServShptHeader.FindFirst();
            SetSource(
              ServShptHeader."Posting Date", Format(Rec."Table Name"), ServShptHeader."No.",
              1, ServShptHeader."Customer No.");
        end;
    end;

    local procedure ShowRecords()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeNavigateShowRecords(
          Rec."Table ID", DocNoFilter, PostingDateFilter, ItemTrackingSearch, Rec, IsHandled,
          SalesInvHeader, SalesCrMemoHeader, PurchInvHeader, PurchCrMemoHeader, ServInvHeader, ServCrMemoHeader,
          SOSalesHeader, SISalesHeader, SCMSalesHeader, SROSalesHeader, GLEntry, VATEntry, VendLedgEntry, WarrantyLedgerEntry, NewSourceRecVar);
        if IsHandled then
            exit;

        if ItemTrackingSearch then
            ItemTrackingNavigateMgt.Show(Rec."Table ID")
        else
            case Rec."Table ID" of
                DATABASE::"Incoming Document":
                    PAGE.Run(PAGE::"Incoming Document", IncomingDocument);
                DATABASE::"Sales Header":
                    ShowSalesHeaderRecords;
                DATABASE::"Sales Invoice Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvHeader)
                    else
                        PAGE.Run(PAGE::"Posted Sales Invoices", SalesInvHeader);
                DATABASE::"Sales Cr.Memo Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader)
                    else
                        PAGE.Run(PAGE::"Posted Sales Credit Memos", SalesCrMemoHeader);
                DATABASE::"Return Receipt Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Return Receipt", ReturnRcptHeader)
                    else
                        PAGE.Run(0, ReturnRcptHeader);
                DATABASE::"Sales Shipment Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Sales Shipment", SalesShptHeader)
                    else
                        PAGE.Run(0, SalesShptHeader);
                DATABASE::"Issued Reminder Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Issued Reminder", IssuedReminderHeader)
                    else
                        PAGE.Run(0, IssuedReminderHeader);
                DATABASE::"Issued Fin. Charge Memo Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Issued Finance Charge Memo", IssuedFinChrgMemoHeader)
                    else
                        PAGE.Run(0, IssuedFinChrgMemoHeader);
                DATABASE::"Purch. Inv. Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader)
                    else
                        PAGE.Run(PAGE::"Posted Purchase Invoices", PurchInvHeader);
                DATABASE::"Purch. Cr. Memo Hdr.":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHeader)
                    else
                        PAGE.Run(PAGE::"Posted Purchase Credit Memos", PurchCrMemoHeader);
                DATABASE::"Return Shipment Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Return Shipment", ReturnShptHeader)
                    else
                        PAGE.Run(0, ReturnShptHeader);
                DATABASE::"Purch. Rcpt. Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
                    else
                        PAGE.Run(0, PurchRcptHeader);
                DATABASE::"Production Order":
                    PAGE.Run(0, ProductionOrderHeader);
                DATABASE::"Posted Assembly Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Assembly Order", PostedAssemblyHeader)
                    else
                        PAGE.Run(0, PostedAssemblyHeader);
                DATABASE::"Transfer Shipment Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Transfer Shipment", TransShptHeader)
                    else
                        PAGE.Run(0, TransShptHeader);
                DATABASE::"Transfer Receipt Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Transfer Receipt", TransRcptHeader)
                    else
                        PAGE.Run(0, TransRcptHeader);
                DATABASE::"Posted Whse. Shipment Line":
                    PAGE.Run(0, PostedWhseShptLine);
                DATABASE::"Posted Whse. Receipt Line":
                    PAGE.Run(0, PostedWhseRcptLine);
                DATABASE::"G/L Entry":
                    PAGE.Run(0, GLEntry);
                DATABASE::"VAT Entry":
                    PAGE.Run(0, VATEntry);
                DATABASE::"Detailed Cust. Ledg. Entry":
                    PAGE.Run(0, DtldCustLedgEntry);
                DATABASE::"Cust. Ledger Entry":
                    PAGE.Run(0, CustLedgEntry);
                DATABASE::"Reminder/Fin. Charge Entry":
                    PAGE.Run(0, ReminderEntry);
                DATABASE::"Vendor Ledger Entry":
                    PAGE.Run(0, VendLedgEntry);
                DATABASE::"Detailed Vendor Ledg. Entry":
                    PAGE.Run(0, DtldVendLedgEntry);
                DATABASE::"Employee Ledger Entry":
                    ShowEmployeeLedgerEntries;
                DATABASE::"Detailed Employee Ledger Entry":
                    ShowDetailedEmployeeLedgerEntries;
                DATABASE::"Item Ledger Entry":
                    PAGE.Run(0, ItemLedgEntry);
                DATABASE::"Value Entry":
                    PAGE.Run(0, ValueEntry);
                DATABASE::"Phys. Inventory Ledger Entry":
                    PAGE.Run(0, PhysInvtLedgEntry);
                DATABASE::"Res. Ledger Entry":
                    PAGE.Run(0, ResLedgEntry);
                DATABASE::"Job Ledger Entry":
                    PAGE.Run(0, JobLedgEntry);
                DATABASE::"Job WIP Entry":
                    PAGE.Run(0, JobWIPEntry);
                DATABASE::"Job WIP G/L Entry":
                    PAGE.Run(0, JobWIPGLEntry);
                DATABASE::"Bank Account Ledger Entry":
                    PAGE.Run(0, BankAccLedgEntry);
                DATABASE::"Check Ledger Entry":
                    PAGE.Run(0, CheckLedgEntry);
                DATABASE::"FA Ledger Entry":
                    PAGE.Run(0, FALedgEntry);
                DATABASE::"Maintenance Ledger Entry":
                    PAGE.Run(0, MaintenanceLedgEntry);
                DATABASE::"Ins. Coverage Ledger Entry":
                    PAGE.Run(0, InsuranceCovLedgEntry);
                DATABASE::"Capacity Ledger Entry":
                    PAGE.Run(0, CapacityLedgEntry);
                DATABASE::"Warehouse Entry":
                    PAGE.Run(0, WhseEntry);
                DATABASE::"Service Header":
                    ShowServiceHeaderRecords;
                DATABASE::"Service Invoice Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Service Invoice", ServInvHeader)
                    else
                        PAGE.Run(0, ServInvHeader);
                DATABASE::"Service Cr.Memo Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Service Credit Memo", ServCrMemoHeader)
                    else
                        PAGE.Run(0, ServCrMemoHeader);
                DATABASE::"Service Shipment Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Service Shipment", ServShptHeader)
                    else
                        PAGE.Run(0, ServShptHeader);
                DATABASE::"Service Ledger Entry":
                    PAGE.Run(0, ServLedgerEntry);
                DATABASE::"Warranty Ledger Entry":
                    PAGE.Run(0, WarrantyLedgerEntry);
                DATABASE::"Cost Entry":
                    PAGE.Run(0, CostEntry);
                DATABASE::"Pstd. Phys. Invt. Order Hdr":
                    PAGE.Run(0, PstdPhysInvtOrderHdr);
                Database::"Posted Gen. Journal Line":
                    Page.Run(0, PostedGenJournalLine);
                DATABASE::"Invt. Receipt Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Invt. Receipt", PostedInvtRcptHeader)
                    else
                        PAGE.Run(0, PostedInvtRcptHeader);
                DATABASE::"Invt. Shipment Header":
                    if Rec."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Invt. Shipment", PostedInvtShptHeader)
                    else
                        PAGE.Run(0, PostedInvtShptHeader);
                DATABASE::"Posted Deposit Header":
                    PAGE.Run(0, PostedDepositHeader);
                DATABASE::"Posted Deposit Line":
                    PAGE.Run(0, PostedDepositLine);
            end;

        OnAfterNavigateShowRecords(
          Rec."Table ID", DocNoFilter, PostingDateFilter, ItemTrackingSearch, Rec,
          SalesInvHeader, SalesCrMemoHeader, PurchInvHeader, PurchCrMemoHeader, ServInvHeader, ServCrMemoHeader,
          ContactType, ContactNo, ExtDocNo);
    end;

    local procedure ShowSalesHeaderRecords()
    begin
        Rec.TestField("Table ID", DATABASE::"Sales Header");

        case Rec."Document Type" of
            Rec."Document Type"::Quote:
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Sales Quote", SQSalesHeader)
                else
                    PAGE.Run(0, SQSalesHeader);
            Rec."Document Type"::Order:
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Sales Order", SOSalesHeader)
                else
                    PAGE.Run(0, SOSalesHeader);
            Rec."Document Type"::Invoice:
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Sales Invoice", SISalesHeader)
                else
                    PAGE.Run(0, SISalesHeader);
            Rec."Document Type"::"Return Order":
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Sales Return Order", SROSalesHeader)
                else
                    PAGE.Run(0, SROSalesHeader);
            Rec."Document Type"::"Credit Memo":
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Sales Credit Memo", SCMSalesHeader)
                else
                    PAGE.Run(0, SCMSalesHeader);
        end;
    end;

    local procedure ShowServiceHeaderRecords()
    begin
        Rec.TestField("Table ID", DATABASE::"Service Header");

        case Rec."Document Type" of
            Rec."Document Type"::Order:
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Service Order", SOServHeader)
                else
                    PAGE.Run(0, SOServHeader);
            Rec."Document Type"::Invoice:
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Service Invoice", SIServHeader)
                else
                    PAGE.Run(0, SIServHeader);
            Rec."Document Type"::"Credit Memo":
                if Rec."No. of Records" = 1 then
                    PAGE.Run(PAGE::"Service Credit Memo", SCMServHeader)
                else
                    PAGE.Run(0, SCMServHeader);
        end;
    end;

    local procedure ShowEmployeeLedgerEntries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowEmployeeLedgerEntries(EmplLedgEntry, IsHandled);
        if IsHandled then
            exit;

        PAGE.Run(PAGE::"Employee Ledger Entries", EmplLedgEntry);
    end;

    local procedure ShowDetailedEmployeeLedgerEntries()
    begin
        PAGE.Run(PAGE::"Detailed Empl. Ledger Entries", DtldEmplLedgEntry);
    end;

    protected procedure SetPostingDate(PostingDate: Text)
    begin
        FilterTokens.MakeDateFilter(PostingDate);
        Rec.SetFilter("Posting Date", PostingDate);
        PostingDateFilter := Rec.GetFilter("Posting Date");
    end;

    protected procedure SetDocNo(DocNo: Text)
    begin
        Rec.SetFilter("Document No.", DocNo);
        DocNoFilter := Rec.GetFilter("Document No.");
        PostingDateFilter := Rec.GetFilter("Posting Date");
    end;

    procedure SetExternal()
    begin
        NavigateDeposit := true;
    end;

    local procedure ClearSourceInfo()
    begin
        if DocExists then begin
            DocExists := false;
            DeleteAll();
            ShowEnable := false;
            SetSource(0D, '', '', 0, '');
            CurrPage.Update(false);
        end;
    end;

    local procedure MakeExtFilter(var DateFilter: Text; AddDate: Date; var DocNoFilter: Text; AddDocNo: Code[20])
    begin
        if DateFilter = '' then
            DateFilter := Format(AddDate)
        else
            if StrPos(DateFilter, Format(AddDate)) = 0 then
                if MaxStrLen(DateFilter) >= StrLen(DateFilter + '|' + Format(AddDate)) then
                    DateFilter := DateFilter + '|' + Format(AddDate)
                else
                    TooLongFilter();

        if DocNoFilter = '' then
            DocNoFilter := AddDocNo
        else
            if StrPos(DocNoFilter, AddDocNo) = 0 then
                if MaxStrLen(DocNoFilter) >= StrLen(DocNoFilter + '|' + AddDocNo) then
                    DocNoFilter := DocNoFilter + '|' + AddDocNo
                else
                    TooLongFilter();
    end;

    local procedure FindPush()
    begin
        if NavigateDeposit then begin
            FindDepositRecords();
            exit;
        end;

        if (DocNoFilter = '') and (PostingDateFilter = '') and
           (not ItemTrackingSearch) and
           ((ContactType <> ContactType::" ") or (ContactNo <> '') or (ExtDocNo <> ''))
        then
            FindExtRecords()
        else
            if ItemTrackingSearch and
               (DocNoFilter = '') and (PostingDateFilter = '') and
               (ContactType = ContactType::" ") and (ContactNo = '') and (ExtDocNo = '')
            then
                FindTrackingRecords()
            else
                FindRecords();
    end;

    local procedure TooLongFilter()
    begin
        if ContactNo = '' then
            Error(Text015);

        Error(Text016);
    end;

    local procedure FindUnpostedSalesDocs(DocType: Enum "Sales Document Type"; DocTableName: Text[100]; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."SecurityFiltering"(SECURITYFILTER::Filtered);
        if SalesHeader.ReadPermission() then begin
            SalesHeader.Reset();
            SalesHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
            SalesHeader.SetFilter("Sell-to Customer No.", ContactNo);
            SalesHeader.SetFilter("External Document No.", ExtDocNo);
            SalesHeader.SetRange("Document Type", DocType);
            InsertIntoDocEntry(Rec, DATABASE::"Sales Header", DocType, DocTableName, SalesHeader.Count);
        end;
    end;

    local procedure FindUnpostedServDocs(DocType: Enum "Service Document Type"; DocTableName: Text[100]; var ServHeader: Record "Service Header")
    begin
        ServHeader."SecurityFiltering"(SECURITYFILTER::Filtered);
        if ServHeader.ReadPermission() then
            if ExtDocNo = '' then begin
                ServHeader.Reset();
                ServHeader.SetCurrentKey("Customer No.");
                ServHeader.SetFilter("Customer No.", ContactNo);
                ServHeader.SetRange("Document Type", DocType);
                InsertIntoDocEntry(Rec, DATABASE::"Service Header", DocType, DocTableName, ServHeader.Count);
            end;
    end;

    local procedure FindTrackingRecords()
    var
        DocNoOfRecords: Integer;
    begin
        Window.Open(Text002);
        Rec.DeleteAll();
        Rec."Entry No." := 0;

        ItemTrackingFilters.SetFilter("Serial No. Filter", SerialNoFilter);
        ItemTrackingFilters.SetFilter("Lot No. Filter", LotNoFilter);
        ItemTrackingFilters.SetFilter("Package No. Filter", PackageNoFilter);

        Clear(ItemTrackingNavigateMgt);
        ItemTrackingNavigateMgt.FindTrackingRecords(ItemTrackingFilters);

        ItemTrackingNavigateMgt.Collect(TempRecordBuffer);
        OnFindTrackingRecordsOnAfterCollectTempRecordBuffer(TempRecordBuffer, SerialNoFilter, LotNoFilter);
        TempRecordBuffer.SetCurrentKey("Table No.", "Record Identifier");
        if TempRecordBuffer.Find('-') then
            repeat
                TempRecordBuffer.SetRange("Table No.", TempRecordBuffer."Table No.");

                DocNoOfRecords := 0;
                if TempRecordBuffer.Find('-') then
                    repeat
                        TempRecordBuffer.SetRange("Record Identifier", TempRecordBuffer."Record Identifier");
                        TempRecordBuffer.Find('+');
                        TempRecordBuffer.SetRange("Record Identifier");
                        DocNoOfRecords += 1;
                    until TempRecordBuffer.Next() = 0;

                InsertIntoDocEntry(Rec, TempRecordBuffer."Table No.", TempRecordBuffer."Table Name", DocNoOfRecords);

                TempRecordBuffer.SetRange("Table No.");
            until TempRecordBuffer.Next() = 0;

        OnAfterNavigateFindTrackingRecords(Rec, SerialNoFilter, LotNoFilter);

        DocExists := Rec.Find('-');

        UpdateFormAfterFindRecords();
        Window.Close();
    end;

    local procedure GetDocumentCount() DocCount: Integer
    begin
        DocCount :=
          NoOfRecords(DATABASE::"Sales Invoice Header") + NoOfRecords(DATABASE::"Sales Cr.Memo Header") +
          NoOfRecords(DATABASE::"Sales Shipment Header") + NoOfRecords(DATABASE::"Issued Reminder Header") +
          NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") + NoOfRecords(DATABASE::"Purch. Inv. Header") +
          NoOfRecords(DATABASE::"Return Shipment Header") + NoOfRecords(DATABASE::"Return Receipt Header") +
          NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") + NoOfRecords(DATABASE::"Purch. Rcpt. Header") +
          NoOfRecords(DATABASE::"Service Invoice Header") + NoOfRecords(DATABASE::"Service Cr.Memo Header") +
          NoOfRecords(DATABASE::"Service Shipment Header") +
          NoOfRecords(DATABASE::"Transfer Shipment Header") + NoOfRecords(DATABASE::"Transfer Receipt Header") +
          NoOfRecords(DATABASE::"Posted Deposit Header") + NoOfRecords(DATABASE::"Posted Deposit Header");

        OnAfterGetDocumentCount(DocCount);
    end;

    [Obsolete('Replaced by SetTracking with ItemTrackingSetup parameter.', '18.0')]
    procedure SetTracking(SerialNo: Code[50]; LotNo: Code[50])
    begin
        NewItemTrackingSetup."Serial No." := SerialNo;
        NewItemTrackingSetup."Lot No." := LotNo;
    end;

    procedure SetTracking(ItemTrackingSetup: Record "Item Tracking Setup")
    begin
        NewItemTrackingSetup := ItemTrackingSetup;
    end;

    local procedure ItemTrackingSearch(): Boolean
    begin
        exit((SerialNoFilter <> '') or (LotNoFilter <> '') or (PackageNoFilter <> ''));
    end;

    local procedure ClearTrackingInfo()
    begin
        SerialNoFilter := '';
        LotNoFilter := '';
        PackageNoFilter := '';
    end;

    local procedure ClearInfo()
    begin
        SetDocNo('');
        SetPostingDate('');
        ContactType := ContactType::" ";
        ContactNo := '';
        ExtDocNo := '';
    end;

    local procedure FindDepositRecords()
    begin
        Window.Open(Text002);
        DeleteAll();
        "Entry No." := 0;
        if GLEntry.ReadPermission then begin
            GLEntry.Reset();
            if not GLEntry.SetCurrentKey("External Document No.", "Posting Date") then
                Error(USText001);
            GLEntry.SetFilter("External Document No.", ExtDocNo);
            GLEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"G/L Entry", 0, GLEntry.TableCaption, GLEntry.Count);
        end;
        if CustLedgEntry.ReadPermission then begin
            CustLedgEntry.Reset();
            if not CustLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
                Error(USText001);
            CustLedgEntry.SetFilter("External Document No.", ExtDocNo);
            CustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Cust. Ledger Entry", 0, CustLedgEntry.TableCaption, CustLedgEntry.Count);
        end;
        if VendLedgEntry.ReadPermission then begin
            VendLedgEntry.Reset();
            if not VendLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
                Error(USText001);
            VendLedgEntry.SetFilter("External Document No.", ExtDocNo);
            VendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Vendor Ledger Entry", 0, VendLedgEntry.TableCaption, VendLedgEntry.Count);
        end;
        if BankAccLedgEntry.ReadPermission then begin
            BankAccLedgEntry.Reset();
            if not BankAccLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
                Error(USText001);
            BankAccLedgEntry.SetFilter("External Document No.", ExtDocNo);
            BankAccLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Bank Account Ledger Entry", 0, BankAccLedgEntry.TableCaption, BankAccLedgEntry.Count);
        end;
        if PostedDepositHeader.ReadPermission then begin
            PostedDepositHeader.Reset();
            PostedDepositHeader.SetFilter("No.", ExtDocNo);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Header", 0, PostedDepositHeader.TableCaption, PostedDepositHeader.Count);
        end;
        if PostedDepositLine.ReadPermission then begin
            PostedDepositLine.Reset();
            PostedDepositLine.SetCurrentKey("Deposit No.");
            PostedDepositLine.SetFilter("Deposit No.", ExtDocNo);
            PostedDepositLine.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Line", 0, PostedDepositLine.TableCaption, PostedDepositLine.Count);
        end;
        DocExists := FindFirst;

        SetSource(0D, '', '', 0, '');
        if DocExists then begin
            if NoOfRecords(DATABASE::"Posted Deposit Header") = 1 then begin
                PostedDepositHeader.FindFirst;
                SetSource(
                  PostedDepositHeader."Posting Date", Format("Table Name"), PostedDepositHeader."No.",
                  4, PostedDepositHeader."Bank Account No.");
            end else begin
                if ExtDocNo <> '' then
                    if PostingDateFilter = '' then
                        Message(Text011)
                    else
                        Message(Text012);
            end;
        end else
            if PostingDateFilter = '' then
                Message(Text013)
            else
                Message(Text014);

        UpdateFormAfterFindRecords;
        Window.Close;
    end;

    local procedure DocNoFilterOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure PostingDateFilterOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure ExtDocNoOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure ContactTypeOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure ContactNoOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure SerialNoFilterOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    local procedure LotNoFilterOnAfterValidate()
    begin
        ClearSourceInfo();
    end;

    procedure FindRecordsOnOpen()
    begin
        if (NewDocNo = '') and (NewPostingDate = 0D) and not NewItemTrackingSetup.TrackingExists() then begin
            Rec.DeleteAll();
            ShowEnable := false;
            PrintEnable := false;
            SetSource(0D, '', '', 0, '');
        end else
            if NewItemTrackingSetup.TrackingExists() then begin
                SetSource(0D, '', '', 0, '');
                Rec.SetTrackingFilterFromItemTrackingSetup(NewItemTrackingSetup);
                if NewItemTrackingSetup."Serial No." <> '' then
                    SerialNoFilter := Rec.GetFilter("Serial No. Filter");
                if NewItemTrackingSetup."Lot No." <> '' then
                    LotNoFilter := Rec.GetFilter("Lot No. Filter");
                if NewItemTrackingSetup."Package No." <> '' then
                    PackageNoFilter := Rec.GetFilter("Package No. Filter");
                ClearInfo();
                FindTrackingRecords();
            end else begin
                Rec.SetRange("Document No.", NewDocNo);
                Rec.SetRange("Posting Date", NewPostingDate);
                DocNoFilter := Rec.GetFilter("Document No.");
                PostingDateFilter := Rec.GetFilter("Posting Date");
                ContactType := ContactType::" ";
                ContactNo := '';
                ExtDocNo := '';
                ClearTrackingInfo();
                OnFindRecordsOnOpenOnAfterSetDocuentFilters(Rec, DocNoFilter, PostingDateFilter, ExtDocNo, NewSourceRecVar);
                DocNoFilter := '';
                if NavigateDeposit then begin
                    ExtDocNo := GetFilter("Document No.");
                    FindDepositRecords();
                end else begin
                    DocNoFilter := GetFilter("Document No.");
                    FindRecords();
                end;
            end;
    end;

    procedure UpdateNavigateForm(UpdateFormFrom: Boolean)
    begin
        UpdateForm := UpdateFormFrom;
    end;

    procedure ReturnDocumentEntry(var TempDocumentEntry: Record "Document Entry" temporary)
    begin
        Rec.SetRange("Table ID");  // Clear filter.
        Rec.FindSet();
        repeat
            TempDocumentEntry.Init();
            TempDocumentEntry := Rec;
            TempDocumentEntry.Insert();
        until Rec.Next() = 0;
    end;

    local procedure UpdateFindByGroupsVisibility()
    begin
        DocumentVisible := false;
        BusinessContactVisible := false;
        ItemReferenceVisible := false;

        case SearchBasedOn of
            SearchBasedOn::Document:
                DocumentVisible := true;
            SearchBasedOn::"Business Contact":
                BusinessContactVisible := true;
            SearchBasedOn::"Item Reference":
                ItemReferenceVisible := true;
        end;

        CurrPage.Update();
    end;

    local procedure FilterSelectionChanged()
    begin
        FilterSelectionChangedTxtVisible := true;
    end;

    local procedure GetCaptionText(): Text
    begin
        if Rec."Table Name" <> '' then
            exit(StrSubstNo(PageCaptionTxt, Rec."Table Name"));

        exit('');
    end;

    local procedure FindPostedGenJournalLine()
    begin
        if PostedGenJournalLine.ReadPermission() then begin
            PostedGenJournalLine.Reset();
            PostedGenJournalLine.SetFilter("Document No.", DocNoFilter);
            PostedGenJournalLine.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(Rec, Database::"Posted Gen. Journal Line", PostedGenJournalLineTxt, PostedGenJournalLine.Count);
        end;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterFindPostedDocuments(var DocNoFilter: Text; var PostingDateFilter: Text)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterGetDocumentCount(var DocCount: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterNavigateFindExtRecords(var DocumentEntry: Record "Document Entry"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250]; var FoundRecords: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; var NewSourceRecVar: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterNavigateFindTrackingRecords(var DocumentEntry: Record "Document Entry"; SerialNoFilter: Text; LotNoFilter: Text)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetRec(NewSourceRecVar: Variant)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetSourceForPurchase()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetSource(var SourceType2: Integer; var SourceType: Text[30]; SourceNo: Code[20]; var SourceName: Text[100])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindRecords(var HideDialog: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; var IsHandled: Boolean; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ServiceInvoiceHeader: Record "Service Invoice Header"; var ServiceCrMemoHeader: Record "Service Cr.Memo Header"; var SOSalesHeader: Record "Sales Header"; var SISalesHeader: Record "Sales Header"; var SCMSalesHeader: Record "Sales Header"; var SROSalesHeader: Record "Sales Header"; var GLEntry: Record "G/L Entry"; var VATEntry: Record "VAT Entry"; var VendLedgEntry: Record "Vendor Ledger Entry"; var WarrantyLedgerEntry: Record "Warranty Ledger Entry"; var NewSourceRecVar: Variant)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeShowEmployeeLedgerEntries(var EmplLedgEntry: Record "Employee Ledger Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUpdateFormAfterFindRecords()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnFindExtRecordsOnAfterSetSalesCrMemoFilter(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnFindExtRecordsOnAfterSetSalesInvoiceFilter(var SalesInvHeader: Record "Sales Invoice Header")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnFindExtRecordsOnBeforeFormUpdate(var Rec: Record "Document Entry"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindPurchCrMemoHeaderOnAfterSetFilters(var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindPurchInvoiceHeaderOnAfterSetFilters(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindSalesCrMemoHeaderOnAfterSetFilters(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindSalesInvoiceHeaderOnAfterSetFilters(var SalesInvHeader: Record "Sales Invoice Header")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnFindRecordsOnAfterSetSource(var DocumentEntry: Record "Document Entry"; var PostingDate: Date; var DocType2: Text[100]; var DocNo: Code[20]; var SourceType2: Integer; var SourceNo: Code[20]; var DocNoFilter: Text; var PostingDateFilter: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindRecordsOnOpenOnAfterSetDocuentFilters(var Rec: Record "Document Entry"; var DocNoFilter: Text; var PostingDateFilter: Text; ExtDocNo: Code[250]; NewSourceRecVar: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindTrackingRecordsOnAfterCollectTempRecordBuffer(var TempRecordBuffer: Record "Record Buffer" temporary; SerialNoFilter: Text; LotNoFilter: Text)
    begin
    end;
}
