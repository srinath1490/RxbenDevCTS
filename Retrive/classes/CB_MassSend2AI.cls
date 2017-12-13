public class CB_MassSend2AI{
    
    
    //Added by JR *Starts*
    public boolean hasSucess = true;
    public List<CRD_BuilderFallout__c> failures;
    
    //Map to hold CRD Id to CRD BuildOrder
    Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>(); 
    //Added by JR *Ends*
    
    public set<Id> massSend2AI(List <CRD__c> scope){  
         //do http Callouts here
        set<Id> aiIdSet = new set<Id>();    
        GC_Utils_Method gcUtils = new GC_Utils_Method();
        List<AI_Request__c> aiRequestList = new List<AI_Request__c>();
        case existingFalloutCase ;
        List<CRDBuildOrder__c> crdBuilder = new List<CRDBuildOrder__c>();
        List<Id> crdId = new List<Id>();
        datetime persTimeStamp;
        Boolean isValidAccum = True;
        boolean isCriteriaSet = false;
        AI_Request__c aiRequest = new AI_Request__c();
        Map<Id,Case> mapCrdIdToFalloutCase = new Map<Id,Case>();
        Map<Id,CRD_BuilderFallout__c> mapCrdIdToFalloutRecord = new Map<Id,CRD_BuilderFallout__c>();
        boolean hasPCG = False;
        String controlPlan;
        String leadingChar = '0';
        //Added by JR
        failures = new List<CRD_BuilderFallout__c>();
        
        //added by abhishek date on 7/9/2014
        for(crd__c crd : (List<Crd__c>)scope){
            crdId.add(crd.Id);
        }
        crdBuilder = [Select id, CRD__c,FalloutCase__c,ControlPlanEffective__c,crd__r.PERS_timestamp__c,PERSTimeStamp__c,crd__r.Account__c,crd__r.Effective_Date__c from CRDBuildOrder__c where CRD__c IN:crdId ];
        //Populate mapCrdIdsToBuilder = >combination of CRD Id to builder record, this wil be used to identify builder record from crdid
        for(CRDBuildOrder__c builder : crdBuilder){
          mapCrdIdsToBuilder.put(builder.CRD__c, builder);
        }
        
        for (crd__c crd : (List<Crd__c>)scope){
            try{
                if(crd.Predefined__c == true){
                    crd.Partial_Control_Group__c = LABEL.CL0000052;
                    crd.Full_Control_Group__c = LABEL.CL0000051;
                }
                if (!checkChangeCopay(crd.id)){
                    System.debug('########step1');
                    isValidAccum = False;
                    throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR00147);
                    hasSucess = false;
                }
                gcUtils.overrideSubSegmentValue(crd);
                //Chetan , 8/20/2014 - Commented , at this step FCG and PCG record will not be available.
               // if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == 'No' && crd.Full_Control_Group__c == null) {
                 //   System.debug('########step2');
                   // throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR00134);
                    //hasSucess = false;
                //} else 
                if ((crd.Insured_Type__c == 'Split Funded' || crd.Insured_Type__c == 'Fully Insured') && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == 'Yes' && crd.Full_Control_Group__c != null) {
                    System.debug('########step3');
                    throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR00135);
                    hasSucess = false;
                } else {
                    System.debug('########step4');
                    VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
                    crd.Integrating_User__c = userinfo.getuserId();
                    System.debug('########step' +crd.Which_system_will_the_plan_be_installed__c);
                    if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                        System.debug('########step5');
                        crd.Platform_Information__c = 'H';
                    } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                        System.debug('########step6');
                        crd.Platform_Information__c = 'T';
                    }
                    Boolean hasError = false;
                    if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == 'Yes' && crd.Which_system_will_the_plan_be_installed__c == null) {
                        System.debug('########step7');
                        throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR00196);
                        hasSucess = false;
                    }
                    if(crd.Are_you_creating_a_Package_Plan__c == 'No' && crd.Plan_Platform__c != 'Discount Card' && crd.CRD_Automated__c == True){
                        System.debug('########stepaaa');
                        if(crd.Control__c!= Null && crd.Plan__c!= Null){
                            controlPlan = GC_Utils_Method.calculateControl(crd.Control__c) + crd.Plan__c;
                        }                    
                        System.debug('#####Control'+crd.Control__c);
                        System.debug('#####Plan'+crd.Plan__c);
                        if(controlPlan!= Null && controlPlan != ''){                    
                            for(Partial_Control_Group__c pcgRecord: [Select Id, name from Partial_Control_Group__c where PCGKey__c =: controlPlan limit 1]){
                                hasPCG = True; 
                            }
                        }
                        if(!hasPCG){
                            System.debug('########stepcccc');
                            throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR0282);
                            hasSucess = false;
                        }
                    }
                    System.debug('crd.Sub_segment__c' +crd.Sub_segment__c);
                    List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, crd.Sub_segment__c);
                    System.debug('########yScheduleList ' + crd);
                    System.debug('########yScheduleList ' + yScheduleList);
                    if(crd.Predefined__c == True){
                        System.debug('########step8');
                        crd.Y_Schd__c = 'Y4';
                        crd.Pricing_Schedule__c = 'Y4';
                        crd.Mail_Y_Schedule__c = 'Y6';  
                    }else{
                        if (yScheduleList != null) {
                            System.debug('########step9');
                            crd.Y_Schd__c = yScheduleList[0];
                            crd.Pricing_Schedule__c = yScheduleList[0];
                            crd.Mail_Y_Schedule__c = yScheduleList[1];
                        }else {
                            System.debug('########step10');
                            crd.Y_Schd__c = 'Y4';
                            crd.Pricing_Schedule__c = 'Y4';
                            crd.Mail_Y_Schedule__c = 'Y6'; 
                        }
                    } 
                    crd.Integration_1__c = crd.Control__c + ',' + crd.Plan__c;//IntegrationCtrlPlanExtractor.getString(crd.Id);  
                    if (isCriteriaSet){
                        System.debug('########step11');
                        throw new BAC_CB_ExceptionHandler.MyException(system.Label.ERR00100);
                        hasSucess = false;
                    }else if(crd.Platform_Information__c != Null && !(string.isblank(crd.Platform_Information__c)) && crd.TP_ID__c == Null 
                                                && crd.Rx_PP_ID__c == Null && !string.isblank(crd.Y_Schd__c) && isValidAccum){
                        System.debug('########step12');
                        
                        aiRequest = new AI_Request__c();
                        if(crd.Id!=null){
                            System.debug('########step13');
                            aiRequest.CRD_ID__c = crd.Id;
                            //aiRequest.Plan_ID__c = crd.Plan__c;
                            
                        }
                        If(crd.Predefined__c == True){
                            System.debug('########step14');
                            aiRequest.Request_Type__c = system.label.CL0000049;
                            aiRequest.Risk_Indicator__c = 'R';
                        }else{
                            System.debug('########step15');
                            aiRequest.Request_Type__c = system.label.CL0000033;
                            aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;    
                        }
                        aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c; 
                        //Modified by Amit for Request 5391                                  
                            aiRequest.Integration_1__c = GC_Utils_Method.calculateControl(crd.Control__c) + ',' + crd.Plan__c;//crd.Integration_1__c;
                        //Ends
                        List < string > RxPlanData = new list< string >() ;
                        RxPlanData = sendToAI.SendToAI(crd.Id);
                        crd.RxPlanData__c = RxPlanData[0];
                        if (RxPlanData.size() > 1) {
                            System.debug('########step16');
                            crd.RxPlanDataExp__c = RxPlanData[1];
                            aiRequest.Benefits_String_Extn__c = RxPlanData[1];
                        }
                        crd.Integration_Status__c = 'Send to AI';
                        aiRequest.Benefit__c = RxPlanData[0];
                        aiRequest.Created_by_Batch_Process__c = True;
                        aiRequestList.add(aiRequest);
                    }else{
                        system.debug('##### crd.Platform_Information__c ' + crd.Platform_Information__c);
                        system.debug('##### crd.Y_Schd__c ' + crd.Y_Schd__c);
                        system.debug('##### crd.isValidAccum ' + isValidAccum);
                        throw new BAC_CB_ExceptionHandler.MyException(' Plan Information is blank or Y Schedule is blank');
                    }
                }
                
            }catch(Exception e){
                System.debug('########step17');                         
                //added by JR
               
                //Create fallout case for failed records
              if(mapCrdIdsToBuilder.get(crd.id) != Null){
                CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crd.id);
                
                Case falloutCase;
                String falloutDescription = 'Error creating AI logs before sending to AI, will most likely be assigned to Admin team. The plan might be missing some data required by AI.';
                    
                    if(builder.FalloutCase__c!=null){
                    //initiate fallout record with existing record Id 
                    falloutCase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c
                                                            ,'CRD Builder fallout'
                                                            ,falloutDescription 
                                                            ,'CB_AIlogs'
                                                            ,builder.PERSTimeStamp__c
                                                            ,builder.ControlPlanEffective__c
                                                            ,builder.crd__r.Account__c
                                                            ,builder.crd__r.Effective_Date__c
                                                            ,builder.crd__c);                 
                    }
                    else{
                    //Create new instance of fallout record case C8
                     
                    falloutCase = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                                            ,falloutDescription
                                                            ,'CB_AIlogs'
                                                            ,builder.PERSTimeStamp__c
                                                            ,builder.ControlPlanEffective__c
                                                            ,builder.crd__r.Account__c
                                                            ,builder.crd__r.Effective_Date__c
                                                            ,builder.crd__c);
                    }
                    falloutCase.CRD_ID__c = crd.id;
                    mapCrdIdToFalloutCase.put(crd.id, falloutCase);
                    
                    //create CRD Builder Fallout Record
                    CRD_BuilderFallout__c falloutRecord;
                    falloutRecord = new CRD_BuilderFallout__c();
                    falloutRecord.Error_Description__c = falloutDescription + ' Error Message - ' + e.getMessage();
                    falloutRecord.Type__c = 'Save Errors';
                    falloutRecord.CRD_Id__c = builder.crd__c;
                    falloutRecord.PERS_Timestamp__c = builder.PERSTimeStamp__c;
                    mapCrdIdToFalloutRecord.put(crd.id, falloutRecord);
                    failures.add(falloutRecord);                  
            }
            }
        }
        
        upsert mapCrdIdToFalloutCase.values();
        
         for(Id crdIds : mapCrdIdToFalloutCase.keyset()){
          CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crdIds);
          builder.FalloutCase__c = mapCrdIdToFalloutCase.get(crdIds).id;
          mapCrdIdToFalloutRecord.get(crdIds).CaseId__c = mapCrdIdToFalloutCase.get(crdIds).id;
        }       
        upsert mapCrdIdToFalloutRecord.values();
        upsert mapCrdIdsToBuilder.values();
        system.debug('aiRequestList->'+aiRequestList);
        update scope;
        if(aiRequestList!=null){
            System.debug('########step18');
            insert aiRequestList;
        }
        for(AI_Request__c aiSet : aiRequestList){
            System.debug('########step19');
            aiIdSet.add(aiSet.Id);
        }
            return aiIdSet;
    }
    
/* 
 * Method :- checkChangeCopay
 * Description :- This method check for validation of Accumulation
 */     
   public boolean checkChangeCopay(Id CRDID){
        List<Accumulations__c> accumList = new List<Accumulations__c>([Select id, CRD_ID__c, What_happens_when_MOOP_is_met__c, 
        What_happens_when_the_MAB_is_met__c, Total_Change_Copays__c FROM Accumulations__c WHERE CRD_ID__c =: CRDID]);
        Boolean isValid = True;
        try{
            if( AccumList != Null && AccumList.size()>0){
                for(Accumulations__c accum : AccumList){
                   //  if(((accum.What_happens_when_MOOP_is_met__c != NULL && accum.What_happens_when_MOOP_is_met__c == 'Change Copay to $0') - Commented by Sourabh to modify the value
                     if(((accum.What_happens_when_MOOP_is_met__c != NULL && accum.What_happens_when_MOOP_is_met__c == 'Change Copay')
                     ||(accum.What_happens_when_the_MAB_is_met__c != NULL && accum.What_happens_when_the_MAB_is_met__c == 'Change Copay' ))
                     &&(accum.Total_Change_Copays__c == 0)){                                                    
                            isValid = False;                                                   
                    }
                }
            }
    }
    catch(exception ex){
        isValid = false;
    }
    return isValid;
}    
}