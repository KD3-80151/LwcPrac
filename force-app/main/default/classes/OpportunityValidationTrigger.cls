public with sharing class OpportunityValidationTrigger {
    public static void opportunityValidation(List<Opportunity> oppList, Map<Id,Opportunity> oldMap) {
        
      for (Opportunity opp : oppList) {
        Opportunity oldOpp = oldMap.get(opp.Id);
        if (opp.CloseDate < Date.today()) {
            String message = 'Opportunity cannot have a Close Date in the past.';
            opp.CloseDate.addError(message);
        }

        if (oldOpp.StageName =='Prospecting'  && opp.StageName == 'Closed Won') {
            opp.StageName.addError('Opportunity cannot transition directly from Prospecting to Closed Won');
        }

        if (opp.StageName =='Closed Won'  && opp.Amount < 10000) {
            opp.Amount.addError('Opportunity Amount must be graeter than 10000');
        }
      }

    }
}

    public static docwrpperClass generateCostSheetDocument(String recordId, String selectedCostSheet){
        try{
            if(recordId != null){
                List<Opportunity> oppList = [SELECT Id,Name,Unit__r.Unit_No__c,Cost_Sheet_Template__c,Unit__r.Base_Price_per_sqft__c, Outstanding_Balance__c, Unit__r.Floor__r.Tower__r.Tower_Code__c,Unit__r.Floor__r.Floor_Name__c, Unit__r.Floor__r.Floor_No__c, Unit__r.Unit_Name__c,Unit__r.Facing__c,Project__r.Name, Cost_Sheet_Issue_Date__c, (SELECT Id,Token_Amount__c,Amount__c from Receipts__r WHERE Token_Amount__c = true LIMIT 1),
                                             Unit__r.Unit_Type__c,Agreement_Value__c,Booking_Date__c,Unit__r.Super_Built_Up_Area_sq_ft__c,Unit__r.Start_Date__c,Unit__r.End_Date__c,(SELECT Id,Name,Document_Id__c from Documents__r where Name = 'Sales') from Opportunity where Id =: recordId LIMIT 1];
                System.debug('oppList ===> ' + oppList);
                List<Payment_Schedule__c> paymentScheduleList = [SELECT Id,Type__c,Total_Amount_Inclusive_Of_Tax__c,Description__c,TDS_Amount__c,Name,Tax_Amount__c,Other_Tax_Amount__c,Installment__c,Agreement_Value__c,Due_Date__c,Other_Charges__c from Payment_Schedule__c where Opportunity__c =: recordId AND Name != 'Token Advance'];
                List<Pricing_Element__c> pricingElementList;
                String subDocUrl = '';
                String parentId = '';
                String docId = '';
                Digio_Integration__c customData = Digio_Integration__c.getValues('Digio');
                docwrpperClass wrapperRec = new docwrpperClass();
                if(!oppList.isEmpty() && customData.Authorization__c != null && customData.Endpoint_URL__c != null && customData.Cost_Sheet_Template_Key__c != null){
                    String endpoint = customData.Endpoint_URL__c + '/v2/client/template/multi_templates/create_sign_request';
                    System.debug('endpoint ===> ' + endpoint);
                    
                    List<Document__c> documentList = oppList[0].Documents__r.isEmpty() ? null : oppList[0].Documents__r;
                    if(!documentList.isEmpty() && documentList[0].Document_Id__c != null){
                        parentId = documentList[0].Document_Id__c;
                        docId = documentList[0].Id;
                    }
                    
                    List<Cost_Sheet__c> costSheetList;
                    if(oppList[0] != null){
                        //List<Cost_Sheet__c> costSheetList;
                        if(String.isNotBlank(selectedCostSheet)){
                            costSheetList = [SELECT Id, Opportunity__c,Unit__r.Start_Date__c,Unit__r.End_Date__c, Total_Pricing_Value_Excluding_Tax__c  from Cost_Sheet__c where Id =: selectedCostSheet LIMIT 1];
                        }else{
                            costSheetList = [SELECT Id, Opportunity__c,Unit__r.Start_Date__c,Unit__r.End_Date__c, Total_Pricing_Value_Excluding_Tax__c  from Cost_Sheet__c where Opportunity__c =: oppList[0].Id and finalize_CostSheet__c = true order by createddate desc LIMIT 1];
                        }
                        System.debug('costSheetList ===> ' + costSheetList);
                        if(costSheetList != null && costSheetList[0].Unit__r.End_Date__c < System.Today() ){
                            wrapperRec.message = 'changeDate';
                            return wrapperRec;
                        }
                        if(costSheetList[0] != null){
                            pricingElementList = [SELECT Id,Cost_Sheet__c,Total_Amount_Excluding_Tax__c,Amount__c,Actual_Amount__c,Quantity__c,Rate__c,Tax_Amount__c,Unit__c,PE_Type__c,Pricing_Element_Master__c,Pricing_Element_Master__r.Name, Sequence__c  from Pricing_Element__c where Cost_Sheet__c =: costSheetList[0].Id AND Type__c = 'Agreement' ORDER BY Sequence__c ASC];
                        }
                    }
                    
                    DigioWrapperClass.costSheetWrapper generateDoc = new DigioWrapperClass.costSheetWrapper();
                    String fileName = oppList[0].Name + ' - Cost Sheet ' + String.valueOf(System.now());
                    generateDoc.file_name = fileName;
                    
                    DigioWrapperClass.signersList signer = new DigioWrapperClass.signersList();
                    signer.identifier = 'tridasarealty@gmail.com';
                    signer.signer_tag = 'Signer 1';
                    signer.name = 'Tridasa';
                    signer.sign_type = 'document_review';
                    
                    generateDoc.signers = new List<DigioWrapperClass.signersList>{signer};
                        
                        DigioWrapperClass.costSheetTemplateList tempList = new DigioWrapperClass.costSheetTemplateList();
                    tempList.template_key = customData.Cost_Sheet_Template_Key__c;
                    
                    DigioWrapperClass.costSheetTemplateValues templateVariables = new DigioWrapperClass.costSheetTemplateValues();
                    templateVariables.ProjectName           = oppList[0].Project__r.Name != null ? oppList[0].Project__r.Name : '';
                    templateVariables.BookingDate           = NumbersToWordsConversionClass.formattedDate(System.today()); //oppList[0].Booking_Date__c != null ? NumbersToWordsConversionClass.formattedDate(oppList[0].Booking_Date__c) : '';
                    templateVariables.TowerName             = oppList[0].Unit__r.Floor__r.Tower__r.Tower_Code__c != null ? oppList[0].Unit__r.Floor__r.Tower__r.Tower_Code__c : '';
                    // templateVariables.FloorName             = oppList[0].Unit__r.Floor__r.Floor_Name__c != null ? oppList[0].Unit__r.Floor__r.Floor_Name__c : ''; Floor_No__c
                    templateVariables.FloorName             = oppList[0].Unit__r.Floor__r.Floor_No__c != null ? String.valueOf(oppList[0].Unit__r.Floor__r.Floor_No__c) : '';
                    templateVariables.UnitSeries            = oppList[0].Unit__r.Unit_No__c != null ? String.valueOf(oppList[0].Unit__r.Unit_No__c) : '';
                    templateVariables.SaleableArea          = oppList[0].Unit__r.Super_Built_Up_Area_sq_ft__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(oppList[0].Unit__r.Super_Built_Up_Area_sq_ft__c) : '';
                    templateVariables.UnitFacing            = oppList[0].Unit__r.Facing__c != null ? oppList[0].Unit__r.Facing__c : '';
                    templateVariables.UnitName              = oppList[0].Unit__r.Unit_Name__c != null ? oppList[0].Unit__r.Unit_Name__c : '';
                    templateVariables.UnitNumber            = oppList[0].Unit__r.Unit_Name__c != null ? oppList[0].Unit__r.Unit_Name__c : '';
                    templateVariables.UnitType              = oppList[0].Unit__r.Unit_Type__c != null ? oppList[0].Unit__r.Unit_Type__c : '';
                    //templateVariables.agreementValue        = oppList[0].Agreement_Value__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(oppList[0].Agreement_Value__c) : '';
                    templateVariables.agreementValue        = costSheetList[0].Total_Pricing_Value_Excluding_Tax__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(costSheetList[0].Total_Pricing_Value_Excluding_Tax__c) : '';
                    templateVariables.tokenAmount           = oppList[0].Receipts__r.size() > 0 && oppList[0].Receipts__r[0].Amount__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(oppList[0].Receipts__r[0].Amount__c) : '';
                    
                    DigioWrapperClass.costSheetDynamicTable tableValues = new DigioWrapperClass.costSheetDynamicTable();
                    // List<DigioWrapperClass.CPATableList> pricingTableList = new List<DigioWrapperClass.CPATableList>();
                    // if(!pricingElementList.isEmpty()){
                    //     for(Pricing_Element__c pricing : pricingElementList){
                    //         DigioWrapperClass.CPATableList costPricingTable = new DigioWrapperClass.CPATableList();
                    //         costPricingTable.PricingName    = pricing.Pricing_Element_Master__r.Name != null ? pricing.Pricing_Element_Master__r.Name : '';
                    //         costPricingTable.Amt            = pricing.Pricing_Element_Master__r.Name.contains('Car Parking') ? '' : pricing.Rate__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(pricing.Rate__c) : '';
                    //         costPricingTable.NewAmt         = NumbersToWordsConversionClass.formatIndianCurrency(pricing.Total_Amount_Excluding_Tax__c);
                    //         pricingTableList.add(costPricingTable);
                    //     }
                    // }
                    // tableValues.CPA = pricingTableList.isEmpty() ? null : pricingTableList;
                    List<DigioWrapperClass.CPATableList> normalItems = new List<DigioWrapperClass.CPATableList>();
                    List<DigioWrapperClass.CPATableList> carParkingItems = new List<DigioWrapperClass.CPATableList>();
                    
                    if (!pricingElementList.isEmpty()) {
                        for (Pricing_Element__c pricing : pricingElementList) {
                            DigioWrapperClass.CPATableList costPricingTable = new DigioWrapperClass.CPATableList();
                            String peName = pricing.Pricing_Element_Master__r.Name != null ? pricing.Pricing_Element_Master__r.Name : '';
                            String unitType = pricing.Unit__c;
                            
                            costPricingTable.PricingName = peName;
                            
                            if (unitType == 'LS' || peName.contains('Car Parking')) {
                                costPricingTable.Amt = '';
                            } else {
                                costPricingTable.Amt = pricing.Rate__c != null
                                    ? NumbersToWordsConversionClass.formatIndianCurrency(pricing.Rate__c)
                                    : '';
                            }
                            
                            costPricingTable.NewAmt = NumbersToWordsConversionClass.formatIndianCurrency(pricing.Total_Amount_Excluding_Tax__c);
                            
                            if (peName.contains('Car Parking')) {
                                carParkingItems.add(costPricingTable);
                            } else {
                                normalItems.add(costPricingTable);
                            }
                        }
                    }
                    
                    List<DigioWrapperClass.CPATableList> finalPricingList = new List<DigioWrapperClass.CPATableList>();
                    finalPricingList.addAll(normalItems);
                    finalPricingList.addAll(carParkingItems);
                    
                    tableValues.CPA = finalPricingList.isEmpty() ? null : finalPricingList;
                    
                    
                    
                    List<DigioWrapperClass.paymentScheduleTableList> paymentScheduleTableList = new List<DigioWrapperClass.paymentScheduleTableList>();
                    List<DigioWrapperClass.paymentScheduleAmnTableList> paymentScheduleAmnTableList = new List<DigioWrapperClass.paymentScheduleAmnTableList>();
                    if(!paymentScheduleList.isEmpty()){
                        Decimal TotPercent = 0;
                        Decimal TotAmount = 0;
                        Decimal TotGst = 0;
                        Decimal FinalAmount = 0;
                        Decimal TotTds = 0;
                        Decimal TotNet = 0;
                        Decimal ammenitiesTotal = 0;
                        
                        for(Payment_Schedule__c payment : paymentScheduleList){
                            if(payment.Type__c == 'Agreement'){
                                DigioWrapperClass.paymentScheduleTableList paymentSchedule = new DigioWrapperClass.paymentScheduleTableList();
                                paymentSchedule.Name        = payment.Name != null ? payment.Name : '';
                                paymentSchedule.Percent     = payment.Installment__c != null ? payment.Installment__c : 0;
                                paymentSchedule.Amount      = payment.Agreement_Value__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(payment.Agreement_Value__c) : '';
                                paymentSchedule.Gst         = payment.Tax_Amount__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(payment.Tax_Amount__c) : '';
                                paymentSchedule.AmtInclTax  = NumbersToWordsConversionClass.formatIndianCurrency(payment.Total_Amount_Inclusive_Of_Tax__c);
                                paymentSchedule.TDS         = payment.TDS_Amount__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(payment.TDS_Amount__c) : '';
                                // System.debug('payment.Agreement_Value__c ===> ' + payment.Agreement_Value__c + ' payment.TDS_Amount__c ===> ' + payment.TDS_Amount__c + 'net payable ===> ' + (payment.Agreement_Value__c - payment.TDS_Amount__c));
                                paymentSchedule.netPayable  = NumbersToWordsConversionClass.formatIndianCurrency(payment.Total_Amount_Inclusive_Of_Tax__c - payment.TDS_Amount__c);
                                
                                TotPercent  += paymentSchedule.Percent;
                                TotAmount   += payment.Agreement_Value__c;
                                TotGst      += payment.Tax_Amount__c;
                                FinalAmount += payment.Total_Amount_Inclusive_Of_Tax__c;
                                TotTds      += payment.TDS_Amount__c;
                                TotNet      += payment.Total_Amount_Inclusive_Of_Tax__c - payment.TDS_Amount__c;
                                paymentScheduleTableList.add(paymentSchedule);
                            }else if(payment.Type__c == 'Ammenities'){
                                DigioWrapperClass.paymentScheduleAmnTableList paymentScheduleAmn = new DigioWrapperClass.paymentScheduleAmnTableList();
                                paymentScheduleAmn.Name        = payment.Name != null ? payment.Name : '';
                                paymentScheduleAmn.Description = payment.Description__c != null ? payment.Description__c : '';
                                paymentScheduleAmn.Amount      = payment.Total_Amount_Inclusive_Of_Tax__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(payment.Total_Amount_Inclusive_Of_Tax__c) : '';
                                ammenitiesTotal += payment.Total_Amount_Inclusive_Of_Tax__c;
                                paymentScheduleAmnTableList.add(paymentScheduleAmn);
                            }
                        }
                        
                        templateVariables.TotPercent    = TotPercent;
                        templateVariables.TotAmount     = NumbersToWordsConversionClass.formatIndianCurrency(TotAmount);
                        templateVariables.TotGst        = NumbersToWordsConversionClass.formatIndianCurrency(TotGst);
                        templateVariables.FinalAmount   = NumbersToWordsConversionClass.formatIndianCurrency(FinalAmount);
                        templateVariables.TotTds        = NumbersToWordsConversionClass.formatIndianCurrency(TotTds);
                        templateVariables.TotNet        = NumbersToWordsConversionClass.formatIndianCurrency(TotNet);
                        //templateVariables.grandTotal    = NumbersToWordsConversionClass.formatIndianCurrency(TotNet + ammenitiesTotal);
                        templateVariables.grandTotal    = oppList[0].Outstanding_Balance__c != null ? NumbersToWordsConversionClass.formatIndianCurrency(oppList[0].Outstanding_Balance__c) : '';
                        
                    }
                    tableValues.paySch = paymentScheduleTableList.isEmpty() ? null : paymentScheduleTableList;
                    tableValues.paySchAmenities = paymentScheduleAmnTableList.isEmpty() ? null : paymentScheduleAmnTableList;
                    
                    tempList.template_table_values = tableValues;
                    tempList.template_values = templateVariables;
                    generateDoc.templates = new List<DigioWrapperClass.costSheetTemplateList>{tempList};
                        
                        system.debug('generateDoc ===> ' + generateDoc);
                    system.debug('serialize json ===> ' + Json.serialize(generateDoc));
                    
                    String jsonBody = Json.serialize(generateDoc);
                    String digiDocId = digioCalloutUtility.sendHttpRequest('POST', endpoint, customData.Authorization__c, jsonBody);
                    wrapperRec.digiDocId = digiDocId;
                    if(digiDocId != null && fileName != null && parentId != null && docId != null){
                        subDocUrl = digioCalloutUtility.downloadDocument(digiDocId, fileName, parentId, docId);
                        wrapperRec.subDocUrl = subDocUrl;
                    }
                    
                    if(!oppList.isEmpty() && digiDocId != null){
                        Opportunity oppToUpdate = oppList[0];
                        oppToUpdate.Cost_Sheet_Issue_Date__c = Date.today();
                        update oppToUpdate;
                    }
                }
                return wrapperRec;
            }
            return null;
        }catch(Exception e){
            system.debug('Error in generateAllotmentLetterDocument===> ' + e.getMessage());
            system.debug('Error line ===> ' + e.getLineNumber());
            return null;
        }
    }