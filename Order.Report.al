report 405 "Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Order.rdlc';
    Caption = 'Order';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order';
            column(DocType_PurchaseHeader; "Document Type")
            {
            }
            column(No_PurchaseHeader; "No.")
            {
            }
            column(AmtCaption; AmtCaptionLbl)
            {
            }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
            {
            }
            column(BuyFromContactPhoneNoLbl; BuyFromContactPhoneNoLbl)
            {
            }
            column(BuyFromContactMobilePhoneNoLbl; BuyFromContactMobilePhoneNoLbl)
            {
            }
            column(BuyFromContactEmailLbl; BuyFromContactEmailLbl)
            {
            }
            column(PayToContactPhoneNoLbl; PayToContactPhoneNoLbl)
            {
            }
            column(PayToContactMobilePhoneNoLbl; PayToContactMobilePhoneNoLbl)
            {
            }
            column(PayToContactEmailLbl; PayToContactEmailLbl)
            {
            }
            column(BuyFromContactPhoneNo; BuyFromContact."Phone No.")
            {
            }
            column(BuyFromContactMobilePhoneNo; BuyFromContact."Mobile Phone No.")
            {
            }
            column(BuyFromContactEmail; BuyFromContact."E-Mail")
            {
            }
            column(PayToContactPhoneNo; PayToContact."Phone No.")
            {
            }
            column(PayToContactMobilePhoneNo; PayToContact."Mobile Phone No.")
            {
            }
            column(PayToContactEmail; PayToContact."E-Mail")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(ReportTitleCopyText; StrSubstNo(Text004, CopyText))
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(PaymentTermsComment; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodComment; ShipmentMethod.Description)
                    {
                    }
                    column(PrepmtPaymentTermsComment; PrepmtPaymentTerms.Description)
                    {
                    }
                    column(DocDate_PurchaseHeader; Format("Purchase Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_PurchaseHeader; "Purchase Header"."VAT Registration No.")
                    {
                    }
                    column(PurchaserTxt; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(PageLoopNo_PurchaseHeader; "Purchase Header"."No.")
                    {
                    }
                    column(ReferenceTxt; ReferenceText)
                    {
                    }
                    column(YourReference_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(BuyfrmVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyfrmVendNo_PurchaseHeaderCaption; "Purchase Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(BuyFromAddr1; BuyFromAddr[1])
                    {
                    }
                    column(BuyFromAddr2; BuyFromAddr[2])
                    {
                    }
                    column(BuyFromAddr3; BuyFromAddr[3])
                    {
                    }
                    column(BuyFromAddr4; BuyFromAddr[4])
                    {
                    }
                    column(BuyFromAddr5; BuyFromAddr[5])
                    {
                    }
                    column(BuyFromAddr6; BuyFromAddr[6])
                    {
                    }
                    column(BuyFromAddr7; BuyFromAddr[7])
                    {
                    }
                    column(BuyFromAddr8; BuyFromAddr[8])
                    {
                    }
                    column(PricesInclVAT_PurchaseHeader; "Purchase Header"."Prices Including VAT")
                    {
                    }
                    column(PricesInclVAT_PurchaseHeaderCaption; "Purchase Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(VATBaseDisc_PurchaseHeader; "Purchase Header"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVATTxt; PricesInclVATtxt)
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(VendTaxIdentType; Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(DimText; DimText)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
                    {
                    }
                    column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                    {
                    }
                    column(PaymentTermsDescCaption; PaymentTermsDescCaptionLbl)
                    {
                    }
                    column(ShipmentMethodDescCaption; ShipmentMethodDescCaptionLbl)
                    {
                    }
                    column(PrepmtPaymentTermsDescCaption; PrepmtPaymentTermsDescCaptionLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(PurchLineLineAmt; PurchLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Description_PurchaseLine; "Purchase Line".Description)
                        {
                        }
                        column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                        {
                        }
                        column(AllowInvDisctxt; AllowInvDisctxt)
                        {
                        }
                        column(Type_PurchaseLine; Format("Purchase Line".Type, 0, 2))
                        {
                        }
                        column(No_PurchaseLine; "Purchase Line"."No.")
                        {
                        }
                        column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                        {
                        }
                        column(UnitOfMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                        {
                        }
                        column(No_PurchaseLineCaption; "Purchase Line".FieldCaption("No."))
                        {
                        }
                        column(Description_PurchaseLineCaption; "Purchase Line".FieldCaption(Description))
                        {
                        }
                        column(Quantity_PurchaseLineCaption; "Purchase Line".FieldCaption(Quantity))
                        {
                        }
                        column(UnitOfMeasure_PurchaseLineCaption; "Purchase Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_PurchaseLine; "Purchase Line"."Line Discount %")
                        {
                        }
                        column(LineAmt_PurchaseLine; "Purchase Line"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_PurchaseLine; "Purchase Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdent_PurchaseLine; "Purchase Line"."VAT Identifier")
                        {
                        }
                        column(AllowInvDisc_PurchaseLineCaption; "Purchase Line".FieldCaption("Allow Invoice Disc."))
                        {
                        }
                        column(VATIdent_PurchaseLineCaption; "Purchase Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(NegPurchLineInvDiscAmt; -PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalTxt; TotalText)
                        {
                        }
                        column(PurchLineLineAmtInvDisctAmt; PurchLine."Line Amount" - PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATTxt_RoundLoop; TotalInclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtTxt; VATAmountLine.VATAmountText)
                        {
                        }
                        column(VATAmt; VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATTxt_RoundLoop; TotalExclVATText)
                        {
                        }
                        column(NegVATDiscAmt; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmt; VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmt; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmt; TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                        {
                        }
                        column(DiscPercentageCaption; DiscPercentageCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDiscOnVATCaption; PaymentDiscOnVATCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                PurchLine.Find('-')
                            else
                                PurchLine.Next;
                            "Purchase Line" := PurchLine;

                            if not "Purchase Header"."Prices Including VAT" and
                               (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
                            then
                                PurchLine."Line Amount" := 0;

                            if ("Purchase Line"."Item Reference No." <> '') and (not ShowInternalInfo) then
                                "Purchase Line"."No." :=
                                    CopyStr("Purchase Line"."Item Reference No.", 1, MaxStrLen("Purchase Line"."No."));
                            if (PurchLine.Type = PurchLine.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Purchase Line"."No." := '';
                            AllowInvDisctxt := Format("Purchase Line"."Allow Invoice Disc.");
                            TotalSubTotal += "Purchase Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line".Amount;
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.Find('+');
                            while MoreLines and (PurchLine.Description = '') and (PurchLine."Description 2" = '') and
                                  (PurchLine."No." = '') and (PurchLine.Quantity = 0) and
                                  (PurchLine.Amount = 0)
                            do
                                MoreLines := PurchLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            PurchLine.SetRange("Line No.", 0, PurchLine."Line No.");
                            SetRange(Number, 1, PurchLine.Count);
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounter; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdent_VATCounter; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentageCaption; VATPercentageCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecificationCaption; VATAmtSpecificationCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then
                                CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count);
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounterLCY; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdent_VATCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Purchase Header"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, VATAmountLine.Count);
                            Clear(VALVATBaseLCY);
                            Clear(VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(PaytoVendNo_PurchaseHeader; "Purchase Header"."Pay-to Vendor No.")
                        {
                        }
                        column(VendAddr8; VendAddr[8])
                        {
                        }
                        column(VendAddr7; VendAddr[7])
                        {
                        }
                        column(VendAddr6; VendAddr[6])
                        {
                        }
                        column(VendAddr5; VendAddr[5])
                        {
                        }
                        column(VendAddr4; VendAddr[4])
                        {
                        }
                        column(VendAddr3; VendAddr[3])
                        {
                        }
                        column(VendAddr2; VendAddr[2])
                        {
                        }
                        column(VendAddr1; VendAddr[1])
                        {
                        }
                        column(PaymentDetailsCaption; PaymentDetailsCaptionLbl)
                        {
                        }
                        column(VendNoCaption; VendNoCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." then
                                CurrReport.Break();
                        end;
                    }
                    dataitem(Total3; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(SelltoCustNo_PurchaseHeader; "Purchase Header"."Sell-to Customer No.")
                        {
                        }
                        column(SelltoCustNo_PurchaseHeaderCaption; "Purchase Header".FieldCaption("Sell-to Customer No."))
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if ("Purchase Header"."Sell-to Customer No." = '') and (ShipToAddr[1] = '') then
                                CurrReport.Break();
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(PrepmtLineAmt; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalPrepmtLineAmount; TotalPrepmtLineAmount)
                        {
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(PrepmtInvBufComment; PrepmtInvBuf.Description)
                        {
                        }
                        column(TotalExclVATTxt_PrepmtLoop; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtVATAmt; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATTxt_PrepmtLoop; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtTotalAmtInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtLoopNumber; Number)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccNoCaption; GLAccNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecificationCaption; PrepaymentSpecificationCaptionLbl)
                        {
                        }
                        column(PrepmtLoopLineNo; PrepmtLoopLineNo)
                        {
                        }
                        dataitem(PrepmtDimLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DummyColumn; 0)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not PrepmtDimSetEntry.FindSet then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until PrepmtDimSetEntry.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();

                                PrepmtDimSetEntry.SetRange("Dimension Set ID", PrepmtInvBuf."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not PrepmtInvBuf.Find('-') then
                                    CurrReport.Break();
                            end else
                                if PrepmtInvBuf.Next() = 0 then
                                    CurrReport.Break();

                            if "Purchase Header"."Prices Including VAT" then
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            else
                                PrepmtLineAmount := PrepmtInvBuf.Amount;

                            PrepmtLoopLineNo += 1;
                            TotalPrepmtLineAmount += PrepmtLineAmount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            PrepmtLoopLineNo := 0;
                            TotalPrepmtLineAmount := 0;
                        end;
                    }
                    dataitem(PrepmtVATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVAT; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATIdent; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepmtVATAmtSpecificationCaption; PrepmtVATAmtSpecificationCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, PrepmtVATAmountLine.Count);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "Purchase Line" temporary;
                    TempPurchLine: Record "Purchase Line" temporary;
                begin
                    Clear(PurchLine);
                    Clear(PurchPost);
                    PurchLine.DeleteAll();
                    VATAmountLine.DeleteAll();
                    PurchPost.GetPurchLines("Purchase Header", PurchLine, 0);
                    PurchLine.CalcVATAmountLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    PurchLine.UpdateVATOnLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DeleteAll();
                    PurchPostPrepmt.GetPurchLines("Purchase Header", 0, PrepmtPurchLine);
                    if not PrepmtPurchLine.IsEmpty() then begin
                        PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                        if not TempPurchLine.IsEmpty() then
                            PurchPostPrepmt.CalcVATAmountLines("Purchase Header", TempPurchLine, PrePmtVATAmountLineDeduct, 1);
                    end;
                    PurchPostPrepmt.CalcVATAmountLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrePmtVATAmountLineDeduct);
                    PurchPostPrepmt.UpdateVATOnLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    PurchPostPrepmt.BuildInvLineBuffer("Purchase Header", PrepmtPurchLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then
                        CopyText := FormatDocument.GetCOPYText;
                    OutputNo := OutputNo + 1;

                    TotalSubTotal := 0;
                    TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode then
                        CODEUNIT.Run(CODEUNIT::"Purch.Header-Printed", "Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Purchase Header");
                FormatDocumentFields("Purchase Header");
                if BuyFromContact.Get("Buy-from Contact No.") then;
                if PayToContact.Get("Pay-to Contact No.") then;
                PricesInclVATtxt := Format("Prices Including VAT");

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if not Vend.Get("Buy-from Vendor No.") then
                    Clear(Vend);

                if not IsReportInPreviewMode then
                    if ArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);
            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Purchase Header");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInformation; ShowInternalInfo)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies whether to archive the order.';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want the program to log this interaction.';

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocument := PurchSetup."Archive Orders";
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        PurchSetup.Get();

        OnAfterInitReport;
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode then
            if "Purchase Header".FindSet then
                repeat
                    "Purchase Header".CalcFields("No. of Archived Versions");
                    SegManagement.LogDocument(13, "Purchase Header"."No.", "Purchase Header"."Doc. No. Occurrence",
                      "Purchase Header"."No. of Archived Versions", DATABASE::Vendor, "Purchase Header"."Buy-from Vendor No.",
                      "Purchase Header"."Purchaser Code", '', "Purchase Header"."Posting Description", '');
                until "Purchase Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
    end;

    var
        Text004: Label 'Order %1', Comment = '%1 = Document No.';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrepmtDimSetEntry: Record "Dimension Set Entry";
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        BuyFromContact: Record Contact;
        PayToContact: Record Contact;
        Vend: Record Vendor;
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        PurchPost: Codeunit "Purch.-Post";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        BuyFromAddr: array[8] of Text[100];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Registration No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: Label 'Account No.';
        OrderNoCaptionLbl: Label 'Order No.';
        PageCaptionLbl: Label 'Page';
        TaxIdentTypeCaptionLbl: Label 'Tax Identification Type';
        CompanyInfoHomePageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'Email';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms';
        ShipmentMethodDescCaptionLbl: Label 'Shipment Method';
        PrepmtPaymentTermsDescCaptionLbl: Label 'Prepayment Payment Terms';
        DocumentDateCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        DiscPercentageCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        PaymentDiscOnVATCaptionLbl: Label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        VATPercentageCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATAmtSpecificationCaptionLbl: Label 'VAT Amount Specification';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        TotalCaptionLbl: Label 'Total';
        PaymentDetailsCaptionLbl: Label 'Payment Details';
        VendNoCaptionLbl: Label 'Vendor No.';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        DescriptionCaptionLbl: Label 'Description';
        GLAccNoCaptionLbl: Label 'G/L Account No.';
        PrepaymentSpecificationCaptionLbl: Label 'Prepayment Specification';
        PrepmtVATAmtSpecificationCaptionLbl: Label 'Prepayment VAT Amount Specification';
        BuyFromContactPhoneNoLbl: Label 'Buy-from Contact Phone No.';
        BuyFromContactMobilePhoneNoLbl: Label 'Buy-from Contact Mobile Phone No.';
        BuyFromContactEmailLbl: Label 'Buy-from Contact E-Mail';
        PayToContactPhoneNoLbl: Label 'Pay-to Contact Phone No.';
        PayToContactMobilePhoneNoLbl: Label 'Pay-to Contact Mobile Phone No.';
        PayToContactEmailLbl: Label 'Pay-to Contact E-Mail';
        PrepmtLoopLineNo: Integer;
        TotalPrepmtLineAmount: Decimal;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewArchiveDocument: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
    end;

    local procedure FormatAddressFields(var PurchaseHeader: Record "Purchase Header")
    begin
        FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, PurchaseHeader);
        if PurchaseHeader."Buy-from Vendor No." <> PurchaseHeader."Pay-to Vendor No." then
            FormatAddr.PurchHeaderPayTo(VendAddr, PurchaseHeader);
        FormatAddr.PurchHeaderShipTo(ShipToAddr, PurchaseHeader);
    end;

    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        with PurchaseHeader do begin
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetPurchaser(SalesPurchPerson, "Purchaser Code", PurchaserText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, "Prepmt. Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");

            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FieldCaption("Your Reference"));
            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FieldCaption("VAT Registration No."));
        end;
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterInitReport()
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPostDataItem(var PurchaseHeader: Record "Purchase Header")
    begin
    end;
}
