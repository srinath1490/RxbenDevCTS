public class CB_MassSend2AIRequest{
    public boolean fromContinueAutomation{get;set;}
    public void massSend2AIRequest(List < AI_Request__c> scope){
        List<AI_Request__c> aiRequestList = new List<AI_Request__c>();
        CRD__c crdList = new CRD__c();
        BAC_CB_ExceptionHandler errLog =  new BAC_CB_ExceptionHandler();
        case existingFalloutCase = new Case(); 
        List<CRDBuildOrder__c> crdBuilder = new List<CRDBuildOrder__c>();
        Set<Id> crdId = new set<Id>();
        Map<Id,Case> mapCrdIdToFalloutCase = new Map<Id,Case>();
        Map<Id,CRD_BuilderFallout__c> mapCrdIdToFalloutRecord = new Map<Id,CRD_BuilderFallout__c>();
        datetime persTimeStamp;
        //Map to hold CRD Id to CRD BuildOrder
        Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>(); 
        //do http Callouts here      
        for (sObject s: Scope) {
            aiRequestList.add((AI_Request__c)s);
            
        }
        for(AI_Request__c ai : aiRequestList){
            crdId.add(ai.CRD_ID__c);
        }
        crdBuilder = [Select 
                        id,PERS_timestamp__c, FalloutCase__c,crd__r.PERS_timestamp__c,Control_Plan_Effective__c,crd__r.Account__c,crd__r.Effective_Date__c,crd__c
                      from CRDBuildOrder__c where CRD__c IN :crdId];
        for(CRDBuildOrder__c builder : crdBuilder){
          mapCrdIdsToBuilder.put(builder.CRD__c, builder);
        }
        if(aiRequestList.size()>0){
            for (AI_Request__c aiRequest : aiRequestList){
                try{
                    //Send data to AI
                    WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
                    WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();  
                    crdDetail.requestId = aiRequest.Id;
                    crdDetail.crdId = aiRequest.CRD_ID__c;
                    crdDetail.requestType = aiRequest.Request_Type__c;
                    if (aiRequest.Plan_ID__c != null) {
                        crdDetail.planId = aiRequest.Plan_ID__c;
                    }
                    if (aiRequest.Benefit__c != null) {
                        crdDetail.benefitsString = aiRequest.Benefit__c;
                    }
                    if (aiRequest.Benefits_String_Extn__c != null) {
                        crdDetail.benefitsStringExtension = aiRequest.Benefits_String_Extn__c;
                    }
                    if (aiRequest.Integration_1__c != null) {
                        crdDetail.traditionalControlNumberPlanSummaryDetails = aiRequest.Integration_1__c;
                    }
                    if (aiRequest.Pricing_Schedule__c != null) {
                        crdDetail.pricingSchedule = aiRequest.Pricing_Schedule__c;
                    }
                    if (aiRequest.Risk_Indicator__c != null) {
                        crdDetail.riskIndicator = aiRequest.Risk_Indicator__c;
                    }
                    if (aiRequest.StateList_to_Remove__c != null) {
                        crdDetail.listOfStatesToRemoveFromPlan = aiRequest.StateList_to_Remove__c;
                    }
                    
                    if (aiRequest.Request_Type__c != null && aiRequest.Request_Type__c.contains(system.label.CL0000035)) {
                        crdDetail.benefitsApplyToAllStates = string.valueof(aiRequest.State_Mandates_Apply__c);
                        crdDetail.benefitsStateList = aiRequest.States_List_for_Mandate__c;
                    }
                    integrationClass.SessionId = Userinfo.getsessionId();
                    integrationClass.CRDDetails = crdDetail;
                    WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();
                    sendData.endpoint_x = system.label.CL0000034;
                    system.debug('**integrationClass**' + integrationClass);
                    Boolean result = sendData.createRxPlan(integrationClass);
                    system.debug(result);
                    if (result) {
                        system.debug('############');
                        aiRequest.Processed__c = true;
                        crdList = new CRD__c();
                        crdList.Id = aiRequest.CRD_ID__c;
                        crdList.Aicallout__c = true;
                        CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crdList.id);
                        builder.Sent_AI_request__c = true;
                        builder.Aicallout__c = true;
                        builder.AIRealtime__c = true;
                        update builder;
                        update crdList;
                        update aiRequest;
                    } else {
                        system.debug('no');
                        throw new BAC_CB_ExceptionHandler.MyException(system.label.ERR00127);
                    } 
                }catch(Exception e){
                    //TODO:- create falloutcase
                   // errLog.createException(e,crdList);
                    //added by abhishek
                     //Create fallout case for failed records
                      CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(aiRequest.CRD_ID__c);
                
                      Case falloutCase;
                      String falloutDescription = 'Send to AI fallout case, these will be assigned to Admin team, most likely reason: AI is not responding.' + e.getMessage();
                    
                    if(builder.FalloutCase__c!=null){
                    //initiate fallout record with existing record Id 
                    falloutCase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c
                                                            ,'CRD Builder fallout'
                                                            ,falloutDescription 
                                                            ,'CB_sendtoAI'
                                                            ,builder.PERS_timestamp__c
                                                            ,builder.Control_Plan_Effective__c
                                                            ,builder.crd__r.Account__c
                                                            ,builder.crd__r.Effective_Date__c
                                                            ,builder.crd__c);                 
                    }
                    else{
                    //Create new instance of fallout record case C13
                     
                    falloutCase = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                                            ,falloutDescription
                                                            ,'CB_sendtoAI'
                                                            ,builder.PERS_timestamp__c
                                                            ,builder.Control_Plan_Effective__c
                                                            ,builder.crd__r.Account__c
                                                            ,builder.crd__r.Effective_Date__c
                                                            ,builder.crd__c);
                    }
                    if (fromContinueAutomation==TRUE){
                    falloutCase.caseautomationreason__c = 'CRDA'; 
                    }
                    falloutCase.CRD_ID__c = aiRequest.CRD_ID__c;
                    mapCrdIdToFalloutCase.put(aiRequest.CRD_ID__c, falloutCase);
                    
                    //create CRD Builder Fallout Record
                    CRD_BuilderFallout__c falloutRecord;
                    falloutRecord = new CRD_BuilderFallout__c();
                    falloutRecord.Error_Description__c = falloutDescription;
                    falloutRecord.Type__c = 'Save Errors';
                    falloutRecord.CRD_Id__c = builder.crd__c;
                    falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
                    mapCrdIdToFalloutRecord.put(aiRequest.CRD_ID__c, falloutRecord);

                }
            }
             upsert mapCrdIdToFalloutCase.values();
             for(Id crdIds : mapCrdIdToFalloutCase.keyset()){
              CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crdIds);
              builder.FalloutCase__c = mapCrdIdToFalloutCase.get(crdIds).id;
              builder.Sent_AI_request__c = false;
              builder.Aicallout__c = false;
              builder.AIRealtime__c = false;
              update builder;
              mapCrdIdToFalloutRecord.get(crdIds).CaseId__c = mapCrdIdToFalloutCase.get(crdIds).id;
            }       
            upsert mapCrdIdToFalloutRecord.values();
            update mapCrdIdsToBuilder.values();
            }
            
    }
}