/*Purpose:  Class for AI->SFDC integration   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -    Abhay              28-06-2012:10.26AM     Class for AI->SFDC integration 
2.0 -    Ankur              30-03-2015		       modified to set default as per request 5621
======================================================================== */
public with sharing class BCTNotificationProcessor {
    QueueSobject crdqueue;
    Map<String,String> args=new Map<String,String>();
    public Static String fieldsfilled='';//$NON-NLS-1$
    IntegrationLogger logger=new IntegrationLogger();   
    public BCTNotificationProcessor(){
        
        
        
    }
    public void processTradNonPackagePackagedData(BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd, Integration_log__c log){
        String Description;
        Description = CreateDescriptionString(AIResponseData);      
        if(AIResponseData.rxPlanBlock!=null){
            //we got the rxplan detail
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                //Assuming i will get only one RxPlanDetail To Be changed after call comment added on 6/25/2012 12.14                           
                BCTNotificationService.RxPlanDetail RxPlan = AIResponseData.rxPlanBlock.RxPlanDetail[0];
                //CheckArgument Condition Passed now do Match Argument with Source CRD
                
                //Commented By Sourabh on 29th May 2013
                //if((RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING) && (RxPlan.status!=null && RxPlan.status!=BLANKSTRING) && (AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING) && (AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=BLANKSTRING) && (AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=BLANKSTRING)&& RxPlan.tieringType==TNLABEL){// as per mail tiering type should always be TN
                //Commnet ended
                
                if((RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING) && (RxPlan.status!=null && RxPlan.status!=BLANKSTRING) && (AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING) && (AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=BLANKSTRING) && RxPlan.tieringType==TNLABEL){// as per mail tiering type should always be TN 
                    //Below is match argument ppid,pricingSchedule,state,riskindigator
                    if((sourceCrd.Pricing_Schedule__c!=null && sourceCrd.Pricing_Schedule__c==AIResponseData.pricingSchedule)){
                        this.AireplyBlock(AIResponseData,RxPlan,sourceCrd,TNLABEL,log);
                    }else{
                        Id loggerId = logger.logmeCall(AIResponseData,true,ARGUMENTMISMATCHLABEL,Description,system.now(),Userinfo.getName(),NONPACKAGELABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                        this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISMATCHWthoutcolLABEL,Description,loggerId);
                    }
                }else{
                    Id loggerId = logger.logmeCall(AIResponseData,true,ARGUMENTMISSINGLABEL + COLLANSTRING,Description,system.now(),Userinfo.getName(),NONPACKAGELABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                    this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISSINGLABEL,Description,loggerId);                                  
                }
            }                       
        }                         
    }
    
    //Compares the BenefitStateList  sent from Ai to the list available on CRD
    public boolean checkBenefitStateList(CRD__c sourceCrd,boolean benefitsApplyToAllStates){
        boolean isListSame=true;
        if(sourceCrd.Do_mandates_apply_to_all_states__c!=null){
            if(benefitsApplyToAllStates==false && sourceCrd.Do_mandates_apply_to_all_states__c!=NSTRING){
                isListSame=false;
            }
            if(benefitsApplyToAllStates==true && sourceCrd.Do_mandates_apply_to_all_states__c!=YSTRING){
                isListSame=false;
            }               
        }   
        return isListSame;
    }
    
    //Compares the benefitsStateList sent from Ai to the list available on CRD
    public boolean compareMultiSelectPicklist(CRD__c sourceCrd,string ValueTobeCompared){
        boolean isListSame=true;
        
        if((ValueTobeCompared!=null && ValueTobeCompared!=BLANKSTRING) && sourceCrd.Benefits_State_List__c!=null){
            String currentCrdStates =sourceCrd.Benefits_State_List__c;
            list<String> lstCurrentStates = currentCrdStates.split(SEMICOLLANSTRING);        
            list<String> lstCurrentStatesFromAi = ValueTobeCompared.split(COMMASTRING);
            
            set<String>setCurrentStates=new set<String>();
            set<String>setCurrentStatesFromAi=new set<String>();
            
            for(String state:lstCurrentStatesFromAi){
                setCurrentStates.add(state);
            }
            
            for(String state:lstCurrentStatesFromAi){
                setCurrentStatesFromAi.add(state);
            }
            
            for(String state:setCurrentStates){
                if(setCurrentStatesFromAi.contains(state)==false){
                    isListSame=false;
                }
            }
        }
        return isListSame;
    }
    //Method to process the non traditional package data    
    public void processHMOPackagedData(BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd,Integration_log__c log){
        String Description;
        Description = CreateDescriptionString(AIResponseData);      
        if(AIResponseData.rxPlanBlock!=null){
            //we got the rx plan detail
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                //Assuming i will get only one RxPlanDetail To Be changed after call comment added on 6/25/2012 12.14                           
                BCTNotificationService.RxPlanDetail RxPlan = AIResponseData.rxPlanBlock.RxPlanDetail[0];
                //CheckArgument Condition Passed now do Match Argument with Source CRD
                if((RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING) && (RxPlan.status!=null && RxPlan.status!=BLANKSTRING) && (RxPlan.states!=null && RxPlan.states!=BLANKSTRING) && (AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING)){
                    //Below is match argument ppid,pricingSchedule,state,riskindigator
                    if((sourceCrd.Rx_PP_ID__c!=null && sourceCrd.Rx_PP_ID__c==AIResponseData.planId) && (sourceCrd.Pricing_Schedule__c!=null && sourceCrd.Pricing_Schedule__c==AIResponseData.pricingSchedule) && (sourceCrd.State_associated_with_this_plan__c!=null && sourceCrd.State_associated_with_this_plan__c==RxPlan.states) && (sourceCrd.Risk_Indicator__c!=null && sourceCrd.Risk_Indicator__c==AIResponseData.riskIndicator) && compareMultiSelectPicklist(sourceCrd,AIResponseData.benefitsStateList) &&  checkBenefitStateList(sourceCrd,AIResponseData.benefitsApplyToAllStates)){                                                                         
                        //change the parameter by abhishek
                        this.AireplyBlock(AIResponseData,RxPlan,sourceCrd,RxPlan.tieringType,log);
                    }else{
                        Id loggerId = logger.logmecall(AIResponseData,true,ARGUMENTMISMATCHLABEL,Description,system.now(),Userinfo.getName(),PPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                        this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISMATCHWthoutcolLABEL,Description,loggerId);
                    }
                }else{
                    Id loggerId = logger.logmecall(AIResponseData,true,ARGUMENTMISSINGLABEL + COLLANSTRING,Description,system.now(),Userinfo.getName(),PPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                    this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISSINGLABEL,Description,loggerId);                                  
                }
            }                       
        }
       
        
    }
    
    //Method to process the traditional package data
    public void processTradionalPackageData(BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd,Integration_log__c log){
        String Description;
        Description = CreateDescriptionString(AIResponseData);      
        if(AIResponseData.rxPlanBlock!=null){
            
            //we got the rxplan detail
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                
                //Assuming i will get only one RxPlanDetail To Be changed after call comment added on 6/25/2012 12.14                           
                BCTNotificationService.RxPlanDetail RxPlan = AIResponseData.rxPlanBlock.RxPlanDetail[0];
                //CheckArgument Condition Passed now do Match Argument with Source CRD
                if((RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING) && (RxPlan.status!=null && RxPlan.status!=BLANKSTRING) && (RxPlan.tieringType!=null && RxPlan.tieringType!=BLANKSTRING) && (AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING)){
                    
                    //Below is match argument 
                    if((sourceCrd.TP_ID__c!=null && sourceCrd.TP_ID__c==AIResponseData.planId) && AIResponseData.pricingSchedule!=null && (sourceCrd.Pricing_Schedule__c==AIResponseData.pricingSchedule)){
                        
                        if(RxPlan.tieringType==TNLABEL){
                            
                            //REPLY BLOCK AS PER THE VSD    
                            this.AireplyBlock(AIResponseData,RxPlan,sourceCrd,RxPlan.tieringType,log);  
                        }else{
                            if(AIResponseData.tieredRxPlanBlock!=null){
                                BCTNotificationService.RxPlanDetail TieredBlock = AIResponseData.tieredRxPlanBlock.RxPlanDetail[0];
                                if(TieredBlock.RxPlanID!=null && TieredBlock.status!=null && TieredBlock.tieringType!=null){
                                    //REPLY BLOCK AS PER THE VSD    
                                    this.AireplyBlock(AIResponseData,TieredBlock,sourceCrd,NALABEL,log);//Added this NA to differentiate the process in the AireplyBlock    line 280
                                }else{
                                    Id loggerId = logger.logmecall(AIResponseData,true,INVALIDTIERINGLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                                    this.createTaskForData(AIResponseData,sourceCrd,INVALIDTIERINGLABEL,Description,loggerId );
                                }  
                            }else{
                                createCaseForData(AIResponseData,NOTIERDBLOCKLABEL+CreateDescriptionString(AIResponseData),BLANKSTRING,BLANKSTRING,BLANKSTRING,TieringblockerrorLABEL,log);                         
                                
                                Id loggerId =logger.logmecall(true,TIERINGBLOCKFOUNDERRORLABEL,TIERINGBLOCKSUPPLIEDERRORLABEL,system.now(),Userinfo.getName(), REPLYINVALIDDCNLABEL,CreateDescriptionString(AIResponseData),CREATEDACASELABEL,log);
                                
                            }                                                                                     
                        }
                        
                    }else{
                        
                        Id loggerId =logger.logmecall(AIResponseData,true,ARGUMENTMISMATCHLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
                        this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISMATCHWthoutcolLABEL,Description,loggerId);
                        
                    }
                }else{
                    Id loggerId = logger.logmecall(AIResponseData,true,ARGUMENTMISSINGLABEL + COLLANSTRING,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);                       
                    this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISSINGLABEL,Description,loggerId);        
                    
                }
            }                       
        }else{
            Description=TPIDACCOMPAI+String.valueOf(sourceCRD.get(NAMESTRING));
            Id loggerId = logger.logmecall(AIResponseData,true,TPIDREPLYERRORGOTAINVALIDSTATUSLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log);
            
            this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTERRORLABEL+CreateDescriptionString(AIResponseData),Description,loggerId);          
            
        }
        
        
    }
    //we will handle all TPID,PPID,HMO procesing here   
    public void processExistingData(Integration_log__c log, BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd){
        String Description;
        Description = CreateDescriptionString(AIResponseData);
        //Case1 we have crdid in response with error data we create a task here
        if(AIResponseData.errorType!=null && AIResponseData.errorDescription!=null){                            
            //Id loggerId = logger.logme(AIResponseData,true,"Error in reply:",Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
            IntegrationLogger.logme(log, true, REPLYERRORLABEL,Description,CREATEDACASELABEL);
            //Request -  Commented by Chetan as per Gabe"s Email (01/17/2014)
            //this.createTaskForData(AIResponseData,sourceCrd,"Error in reply: "+AIResponseData.errorType,Description,loggerId );
            
        }else{
            if(AIResponseData.requestType!=null){//moved the condition of AIResponseData.planId in inner condition as per discussion with sourabh
                if(AIResponseData.requestType==Traditional_PackagedLABEL && AIResponseData.planId!=null){
                    
                    this.processTradionalPackageData(AIResponseData, sourceCrd,log);//d
                    
                }else if(AIResponseData.requestType==HMO_PackagedLABEL && AIResponseData.planId!=null){
                    
                    this.processHMOPackagedData(AIResponseData, sourceCrd,log);//d                  
                    
                }else if(AIResponseData.requestType==Traditional_Source_PERSLABEL){                    
                    //Already handeld in the initial step case created 
                }else if(AIResponseData.requestType==HMO_CustomLABEL){                 
                    Integration_customHMOHandler customHMO=new Integration_customHMOHandler();
                    //if we have crdid in request we will process it otherwise we will create a case
                    //~~~~~~Begin:Custom HMO~~~~~~~       
                    system.debug('HMO Inside');
                    //Added March 15- Custom HMO PCR1644
                    if(AIResponseData.benefitsString!=NULL && AIResponseData.benefitsString!=BLANKSTRING){//Custom BenID detected. Moving to Alternate flow:Custom HMO
                        // It is a reply
                        
                        customHMO.Custom_HMO_reply(AIResponseData,log); 
                        
                        
                    }else{                              
                        //Id loggerId =  logger.logme(AIResponseData,true,INVALIDDATACRDLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
                        IntegrationLogger.logme(log, true, INVALIDDATACRDLABEL,Description,CREATEDACASELABEL);
                        this.createTaskForData(AIResponseData, sourceCrd,INVALIDDATACRDLABEL, Description,log.id);
                    }
                    //~~~~~~End:Custom HMO~~~~~~~~~~ 
                }else if(AIResponseData.requestType==Traditional_Non_PackagedLABEL){
                    this.processTradNonPackagePackagedData(AIResponseData, sourceCrd,log);//d
                    
                }else if(AIResponseData.requestType==HMO_Source_HMOLABEL){
                    //Already handeld in the initial step case created
                }else if(AIResponseData.requestType==Traditional_LikePackageLABEL){//Added by Amit on 14th April"14, for CVH Release, Request 4702. For request type Traditional_LikePackage 
                    this.processTradLikePackagePackagedData(log, AIResponseData, sourceCrd);
                    
                    //**ends Request 4702   
                }else { 
                    //Id loggerId =  logger.logme(AIResponseData,true,INVALIDDATACRDLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
                    IntegrationLogger.logme(log, true, INVALIDDATACRDLABEL,Description,CREATEDACASELABEL);
                    this.createTaskForData(AIResponseData, sourceCrd,INVALIDDATACRDLABEL, Description,log.id);
                    
                }
            }else{
               // Id loggerId =  logger.logme(AIResponseData,true,INVALIDDATACRDLABEL,Description,system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
                IntegrationLogger.logme(log, true, INVALIDDATACRDLABEL,Description,CREATEDACASELABEL);
                this.createTaskForData(AIResponseData, sourceCrd,INVALIDDATACRDLABEL, Description,log.id);
                
            }
        }
    }
    
    //Method to create a task for if we get crdid and error details in response
    public void createTaskForData(BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd,String taskSubject,String Description,string logger){
        try{
            Task newCRDtask=new Task();
            newCRDtask.WhatId=sourceCrd.id;
            newCRDtask.OwnerId=sourceCrd.OwnerId;
            newCRDtask.Subject=taskSubject;
            newCRDtask.Description=Description;
            if(logger != BLANKSTRING){
                newCRDtask.Integration_Log__c = system.label.CL0000044+logger;
            }
            insert newCRDtask;   
            this.sendEmailForTask(sourceCrd.OwnerId,newCRDtask.id,sourceCrd.Name);
        }catch(Exception e){
            
            
            
        }       
    }
    public void sendEmailForTask(string userId,string taskId,String CrdName){
        User taskOwner=new User();    
        taskOwner= [SELECT ID, email FROM User Where ID =:userId];
        if(taskOwner!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {taskOwner.email};
                mail.setToAddresses(toAddresses); 
            mail.setSubject(NEWTASKCREATEDLABEL + taskId);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            //String emailBody=system.label.CL0000041+CrdName+system.label.CL0000042+"To View task please <a href="+system.label.CL0000040+taskId+">click here</a>.";    
            String emailBody=system.label.CL0000045 +SPACESTRING+CrdName+system.label.CL0000046+VIEWTASK+system.label.CL0000044+taskId+CLICKHERE;             //$NON-NLS-1$ //$NON-NLS-2$
            mail.setHtmlBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    public string getRxPlanItems(list<BCTNotificationService.RxPlanDetail> lstRxPlan){
        string description;
        description=SPACESTRING;
        for(BCTNotificationService.RxPlanDetail RxPlan:lstRxPlan){
            if(RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING){    
                description = description+RXPLANIDLABEL+RxPlan.RxPlanID;
            }
            if(RxPlan.status!=null && RxPlan.status!=BLANKSTRING  ){
                description = description+STATUSLABEL+RxPlan.status;
            }
            if(RxPlan.tieringType!=null && RxPlan.tieringType!=BLANKSTRING){
                description = description+TIERINGTYPELABEL+RxPlan.tieringType;
            }
            if(RxPlan.states!=null && RxPlan.states!=BLANKSTRING){
                description = description+STATESLABEL+RxPlan.states+BRACKETCLOSE; //$NON-NLS-1$
            }
            
        }
        return description;
    }
    /*Method to create the description on case with the response from Ai*/
    public string CreateDescriptionString(BCTNotificationService.ReturnData AIResponseData){
        String description;
        description='  '; //$NON-NLS-1$
        
        
        if(AIResponseData.RequestId!=null && AIResponseData.RequestId!=BLANKSTRING){
            description = description+RequestIdlabel+AIResponseData.RequestId;
        }           
        if(AIResponseData.crdId!=null && AIResponseData.crdId!=BLANKSTRING){
            description = description+crdIdlabel+AIResponseData.crdId;
        }
        
        
        if(AIResponseData.fundingType!=null && AIResponseData.fundingType!=BLANKSTRING){
            description =  description+fundingTypelabel+AIResponseData.fundingType;             
        }
        
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=BLANKSTRING){
            description =  description+requestTypelabel+AIResponseData.requestType;             
        }
        
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING){
            description = description+pricingSchedulelabel+AIResponseData.pricingSchedule;    
        }     
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=BLANKSTRING){
            description = description+riskIndicatorlabel+AIResponseData.riskIndicator;
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=BLANKSTRING){
            description = description+planIdlabel+AIResponseData.planId;              
        }
        
        if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=BLANKSTRING && AIResponseData.requestType == HMO_CustomLABEL){
            description = description+Customlabel+AIResponseData.benefitsString;
        }
        
        if(AIResponseData.effectiveDate!=null && AIResponseData.effectiveDate!=BLANKSTRING){
            description = description+effectiveDatelabel+AIResponseData.effectiveDate;
        }
        
        if(AIResponseData.termDate!=null && AIResponseData.termDate!=BLANKSTRING){
            description = description+termDatelabel+AIResponseData.termDate;
        }
        
        if(AIResponseData.erb!=null && AIResponseData.erb!=BLANKSTRING){
            description = description+erblabel+AIResponseData.erb;
        }
        
        if(AIResponseData.subSegment!=null && AIResponseData.subSegment!=BLANKSTRING){
            description = description+subSegmentlabel+AIResponseData.subSegment;
        }
        if(AIResponseData.benefitsApplyToAllStates!=null){
            description = description+benefitsApplyToAllStateslabel+AIResponseData.benefitsApplyToAllStates;
        }       
        if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=BLANKSTRING){
            description = description+ benefitsStateListlabel+AIResponseData.benefitsStateList;
        }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=BLANKSTRING){
            description = description+listOfStatesToRemoveFromPlanlabel+AIResponseData.listOfStatesToRemoveFromPlan;
        }
        
        list<BCTNotificationService.RxPlanDetail> lstRxPlan = new list<BCTNotificationService.RxPlanDetail>();
        
        //Change this funcionality if we get multiple response from any of below.
        if(AIResponseData.rxPlanBlock!=null){
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                description = description+rxPlanBlocklabel;
                description = description+ getRxPlanItems(AIResponseData.rxPlanBlock.RxPlanDetail);
                description = description+bracketCloselabel;                    
            }
            
        }
        
        
        
        if(AIResponseData.rxPlanBlock!=null){
            if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                description = description+ErrRxPlanBlocklabel;
                description = description+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                description = description+bracketCloselabel;                    
            }
            
        }
        
        
        if(AIResponseData.tieredRxPlanBlock!=null){                
            if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                description = description+TieredRxPlanBlocklabel;
                description = description+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                description = description+bracketCloselabel;                    
            }
            
        }
        
        if(AIResponseData.tieredRxPlanBlock!=null){                
            if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){                    
                description = description+TieredRxPlanBlockErrorplanlabel;
                description = description+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                description = description+bracketCloselabel;                    
            }
            
        }
        
        if(AIResponseData.hmoHierarchy!=null){
            description= description+hmoHierarchylabel;
            description=description+Companylabel+AIResponseData.hmoHierarchy.company;
            description=description+groupslabel+AIResponseData.hmoHierarchy.groups;
            description=description+locationlabel+AIResponseData.hmoHierarchy.location;
            description=description+planlabel+AIResponseData.hmoHierarchy.plan;
            description = description+bracketCloselabel;
        }
        
        if(AIResponseData.traditionalHierarchy!=null){
            description=description+ traditionalHierarchylabel;
            description=description+controllabel+AIResponseData.traditionalHierarchy.control;
            description=description+suffixlabel+AIResponseData.traditionalHierarchy.suffix;
            description=description+accountlabel+AIResponseData.traditionalHierarchy.account;
            description=description+planSummarylabel+AIResponseData.traditionalHierarchy.planSummary;                           
            description = description+bracketCloselabel;
        }   
        if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
            description=description+ traditionalControlNumberPlanSummarylabel;
            for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                description=description+controlNumberlabel+summary.controlNumber;
                description=description+planSummarywithoutcommalabel+summary.planSummary+bracketCloselabel;
            }
            description = description+bracketCloselabel;
        }
        
        
        
        
        return description;
    }
    //Method will be used for creation of case if we dont have crdid
    public void createCaseForData(BCTNotificationService.ReturnData AIResponseData,String caseDescription,String caseReason,String caseType,String caseOrigin,string caseSubject,Integration_log__c log){
        
        //we log a case with the details we recieved from AI since was not error detail we will create case accordingly
        String traditionalHierarchy;
        String HmoHirerachy;
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        String errtieredRxPlanBlockDescription;
        Case c=new Case();
        c.Description=caseDescription;//"Following fields were included in the notification from Aetna Integrator:\n\n"+caseDescription;
        c.Origin=caseOrigin;//"Other";
        c.Case_Type__c=caseType;//"Benefit Control Implementation Support";
        c.Reason=caseReason;//"AI notification";
        c.Subject=caseSubject;//"Notification from Aetna Integrator";
        //Adding New Fields
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = :EVENT_NOTIFICATIONSLABEL].id;
		//Added for 5621 by ankur - Starts
        list<account> acclist = [select id from account where name = :ASMSMALLGROUPMASTERLABEL];
        if(AIResponseData.requestType==HMO_PackagedLABEL || AIResponseData.requestType==HMO_CustomLABEL  || AIResponseData.requestType==HMO_Source_HMOLABEL){     
            if(acclist !=null && acclist.size() > 0)
                c.accountid = acclist[0].id;
        }
		//Added for 5621 by ankur - Ends
        if(AIResponseData.notificationCount!=null){     
            c.Notification_Count__c = AIResponseData.notificationCount;
        }
        if(AIResponseData.benefitsApplyToAllStates!=null){     
            c.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
        }
        
        if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=BLANKSTRING){
            c.benefitsStateList__c = AIResponseData.benefitsStateList;
        }
        
        if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=BLANKSTRING){
            c.benefitsString__c = AIResponseData.benefitsString;
        }
        
        if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=BLANKSTRING){     
            c.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
        }
        
        c.controlPlanSummary__c =BLANKSTRING;
        
        
        if(AIResponseData.effectiveDate!=null && AIResponseData.effectiveDate!=BLANKSTRING){
            c.effectiveDate__c =Date.valueOf(AIResponseData.effectiveDate);
        }
        
        if(AIResponseData.erb!=null && AIResponseData.erb!=BLANKSTRING){
            c.erb__c = AIResponseData.erb;
        }
        
        if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=BLANKSTRING){
            c.errorDescripton__c = AIResponseData.errorDescription;
        }
        
        if(AIResponseData.errorType!=null && AIResponseData.errorType!=BLANKSTRING){
            c.errorType__c = AIResponseData.errorType;
        }
        if(AIResponseData.fundingType!=null && AIResponseData.fundingType!=BLANKSTRING){
            c.fundingType__c = AIResponseData.fundingType;
        }
        
        if(AIResponseData.hmoHierarchy!=null){
            
            HmoHirerachy=hmoHierarchylabel;
            HmoHirerachy=HmoHirerachy+Companylabel+AIResponseData.hmoHierarchy.company;
            HmoHirerachy=HmoHirerachy+groupslabel+AIResponseData.hmoHierarchy.groups;
            HmoHirerachy=HmoHirerachy+locationlabel+AIResponseData.hmoHierarchy.location;
            HmoHirerachy=HmoHirerachy+planlabel+AIResponseData.hmoHierarchy.plan;       
            HmoHirerachy = HmoHirerachy+bracketCloselabel;
        }       
        c.hmoHierarchy__c = HmoHirerachy;
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=BLANKSTRING){
            c.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;
        }    
        
        if(AIResponseData.planId!=null && AIResponseData.planId!=BLANKSTRING){
            c.planID__c = AIResponseData.planId;
        }
        
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING){
            c.pricingSchedule__c = AIResponseData.pricingSchedule;    
        }
        
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=BLANKSTRING){
            c.requestType__c = AIResponseData.requestType;
        }
        
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=BLANKSTRING){
            c.riskIndicator__c = AIResponseData.riskIndicator;
        }
        
        if(AIResponseData.rxPlanBlock!=null){
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                rxPlanBlockDescription =rxPlanBlocklabel;
                rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.RxPlanDetail);
                rxPlanBlockDescription = rxPlanBlockDescription+bracketCloselabel;                    
            }
            
        }
        
        if(AIResponseData.rxPlanBlock!=null){                                                  
            if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                errRxPlanBlockDescription = ErrRxPlanBlocklabel;
                errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                errRxPlanBlockDescription = errRxPlanBlockDescription+bracketCloselabel;                    
            }
            
        }
        
        if(AIResponseData.tieredRxPlanBlock!=null){                
            if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                tieredRxPlanBlockDescription = TieredRxPlanBlocklabel;
                tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+bracketCloselabel;                    
            }
            
        }
        if(AIResponseData.tieredRxPlanBlock!=null){                
            if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                errtieredRxPlanBlockDescription= ERRTIEREDRXPLANBLOCKLABEL;
                errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+bracketCloselabel;                    
            }
            
        }
        c.rxPlanBlock__c = rxPlanBlockDescription;
        c.rxplanblockerrors__c = errRxPlanBlockDescription;
        c.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        c.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
        if(AIResponseData.subSegment!=null && AIResponseData.subSegment!=BLANKSTRING){
            c.subSegment__c = AIResponseData.subSegment;
        }
        
        if(AIResponseData.CarrierId!=null && AIResponseData.CarrierId!=BLANKSTRING){
            c.CarrierId__c = AIResponseData.CarrierId;
        }
        
        if(AIResponseData.termDate!=null && AIResponseData.termDate!=BLANKSTRING){
            c.termDate__c = AIResponseData.termDate;
        }
        
        
        if(AIResponseData.traditionalHierarchy!=null){
            traditionalHierarchy= traditionalHierarchylabel;
            traditionalHierarchy=traditionalHierarchy+controllabel+AIResponseData.traditionalHierarchy.control;
            traditionalHierarchy=traditionalHierarchy+suffixlabel+AIResponseData.traditionalHierarchy.suffix;
            traditionalHierarchy=traditionalHierarchy+accountlabel+AIResponseData.traditionalHierarchy.account;
            traditionalHierarchy=traditionalHierarchy+planSummarylabel+AIResponseData.traditionalHierarchy.planSummary;                         
            traditionalHierarchy = traditionalHierarchy+bracketCloselabel;
        }   
        //added new field by abhishek goel date on 21/03/2014
        if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=BLANKSTRING){
            c.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
        }
        if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=BLANKSTRING){
            c.acquisitionCode__c = AIResponseData.acquisitionCode;
        }
        
        c.traditionalHierarchy__c = traditionalHierarchy;
        
        //assigning to queue
        List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name=:CASE_BCTMANAGERSLABEL LIMIT 1];
        QueueSobject crdqueue;
        if(crdqueueList.size()>0)
            crdqueue=crdqueueList[0]; // If the queue was valid and a record was found.
        if(crdqueue!=NULL){
            c.OwnerId=crdqueue.QueueId;
        }
        //added by abhishek date on 8/20/2014
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = :CASELABEL and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        c.setOptions(dmlOpts);
        try{
            insert c;
        }catch(Exception e){
            logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLEBCTNOTIFICATIONARGUMENTSLABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),ERRORININPUTPARAMETERSLABEL,log);
        }
    }
    
    public void AireplyBlock(BCTNotificationService.ReturnData AIResponseData,BCTNotificationService.RxPlanDetail RxPlanInformation,CRD__c sourceCRD,String TieringType,Integration_log__c log){
        if(TieringType==TNLABEL){ 
            if(RxPlanInformation.status==ELABEL){ //Update CRD, create Note
                args.clear(); //rebuilding map
                args.put(RXPLAN_ID_STATUSLABEL,RxPlanInformation.status);
                args.put(TIERINGLABEL,RxPlanInformation.tieringType);
                args.put(RISK_INDICATORLABEL,AIResponseData.riskIndicator);
                try{
                    //Inserting Note: to track updates
                    Note n=new Note();
                    n.Title=UPDATEDAETNAINTEGRATORLABEL;
                    n.Body=TPIDWASSUBMITTEDTOAETNAINTEGRATORLABEL;
                    n.ParentId=sourceCRD.Id;
                    n.isPrivate=false;
                    n.OwnerId=sourceCRD.OwnerId;
                    
                    insert n;
                    //Also creating a task
                    this.Rxreply(AIResponseData,AIResponseData.crdId,RxPlanInformation.RxPlanID,args,sourceCRD,log);
                    //end task creation
                    
                    
                    Id loggerId = logger.logmecall(AIResponseData,false,TPIDREPLYEXISTINGGOTAEXISTINGLABEL,GOTANEXISTING+String.valueOf(sourceCRD.Name),system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),UPDATEDRECORDANDCREATEANOTELABEL,sourceCRD.Id,log); //$NON-NLS-1$
                }catch(Exception e){
                    
                    
                    Id loggerId = logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLETPIDLABEL+String.valueOf(sourceCRD.Name),system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,sourceCRD.Id,log);
                }
                
                
            }
            else if(RxPlanInformation.status==NSTRING){ //Valid TPID ,non-tiered New status; Update CRD,create Task
                args.clear(); //rebuilding map
                args.put(RXPLAN_ID_STATUSLABEL,RxPlanInformation.status);
                args.put(TIERINGLABEL,RxPlanInformation.tieringType);
                args.put(RISK_INDICATORLABEL,AIResponseData.riskIndicator);
                this.Rxreply(AIResponseData,AIResponseData.crdId,RxPlanInformation.RxPlanID,args,sourceCRD,log);
                Id loggerId = logger.logmecall(AIResponseData,false,TPIDREPLYNEWGOTANEWLABEL,GOTANEW+String.valueOf(sourceCRD.Name),system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),UPDATEDRECORDANDCREATEATASKLABEL,sourceCRD.Id,log); //$NON-NLS-1$
            }
            else{ //Invalid Status
                Id loggerId = logger.logmecall(AIResponseData,true,TPIDREPLYERRORGOTAINVALIDSTATUSLABEL,GOTANINVALID+String.valueOf(sourceCRD.get(NAMESTRING)),system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id,log); //$NON-NLS-1$
                this.createTaskForData(AIResponseData,sourceCrd,INVALIDSTATUSLABEL,INVALIDSTATUSFORATPIDBASEDREPLYLABEL+RxPlanInformation.status,loggerId);
                
            }
            
        }else{//Tiering type TN ends here
            if(RxPlanInformation.status==ELABEL || RxPlanInformation.status==NSTRING){
                args.clear(); //rebuilding map
                args.put(RXPLAN_ID_STATUSLABEL,RxPlanInformation.status);
                args.put(TIERINGLABEL,RxPlanInformation.tieringType);
                args.put(RISK_INDICATORLABEL,AIResponseData.riskIndicator);
                this.BCTnotification(AIResponseData,RxPlanInformation.RxPlanID,args,true,sourceCRD.ownerId,log); //new CRD has to be created so no, DCN?-yes
                Id loggerId =logger.logmecall(AIResponseData,false,TPIDREPLYTIERING_ADDITIONALRXPLANIDFORATPIDLABEL,FORTPIGOTBACKREPLY+String.valueOf(sourceCRD.get(NAMESTRING)),system.now(),Userinfo.getName(),TPIDLABEL,CreateDescriptionString(AIResponseData),CREATEDNEWCRDANDCREATEDATASKLABEL,sourceCRD.Id,log);     //$NON-NLS-1$
                
            }
        }  
        
    }                               
    
    public void Rxreply(BCTNotificationService.ReturnData AIResponseData,String Arg_dcn,String Arg_RxPlanID,Map<String,String> arguments,CRD__c sourceCRD,Integration_log__c log){
        //SOQL on DCN, find the CRD_record and update it with the reply, make task with lookup to CRD record and assign to owner of CRD
        
        Set<String> notificationKeys=new Set<String>();
        if(arguments!=null){
            notificationKeys=arguments.keyset();
        }
        try{
            
            for(String s:notificationKeys){
                sourceCRD.put(s,arguments.get(s));
                
            }//assign field values from Aetna Integrator
            
            // ~~~~~ REMOVE COMMENT ~~~~    //added by Rishabh Kushagra Bansal on 10thJan"13
            if(sourceCRD.RxPlanID__c!=Arg_RxPlanID){
                sourceCRD.Old_RxPlan_ID__c=sourceCRD.RxPlanID__c;
            }
            sourceCRD.RxPlanID__c=Arg_RxPlanID;
            
            update sourceCRD;
        }catch(Exception e){
            
            Id loggerId = logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLERXREPLYUPDATINGCRDRECORDSLABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,log);
        }
        try{    
            Task newCRDtask=new Task();
            newCRDtask.WhatId=sourceCRD.Id;
            newCRDtask.OwnerId=sourceCRD.OwnerId;
            newCRDtask.Subject=REPLYRECIEVEDFROMAI; //$NON-NLS-1$
            newCRDtask.Description=AETNAINTEGRATORSENTBACKREPLYFORYOURSUBMISSIONLABEL;
            newCRDtask.type=INTEGRATIONREPLYLABEL;
            
            insert newCRDtask;
        }catch(Exception e){
            Id loggerId =logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLERXREPLYLABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,log);
        }
    }
    
    public void BCTnotification(BCTNotificationService.ReturnData AIResponseData,String Arg_RxPlanID,Map<string,string> arguments, Boolean flag,Id sourceId,Integration_log__c log){
        //create new CRD with details and create a task with the lookup to CRD. Have the detail__c filled as finish CRD, assign to BCTQueue
        CRD__c newBCTrecord=new CRD__c();
        Set<String> notificationKeys=new Set<String>();
        notificationKeys=arguments.keyset();
        fieldsfilled=BLANKSTRING;
        for(String s:notificationKeys){
            if(s.contains(DATELABEL))
                newBCTrecord.put(s,Date.valueOf(arguments.get(s)));
            else
                newBCTrecord.put(s,arguments.get(s));
            fieldsfilled+=s+COMMASTRING; 
        }//assign field values from Aetna Integrator
        // ~~~~~ REMOVE COMMENT ~~~~
        newBCTrecord.RxPlanID__c=Arg_RxPlanID;
        try{
            insert newBCTrecord;
        }catch(exception e){
            Id loggerId = logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLEBCTNOTIFICATIONARGUMENTSLABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,log);
        }
        //create case and assign it to Queue.
        if(flag){ // Tiering TPID reply
            newBCTrecord.OwnerId=sourceId;
            Task newCRDtask=new Task();
            newCRDtask.WhatId=newBCTrecord.Id;
            newCRDtask.OwnerId=newBCTrecord.OwnerId;
            newCRDtask.Subject=REPLYRECEIVEDFROMAI_TIERINGLABEL;
            newCRDtask.Description=AETNAINTEGRATORSENTBACKREPLYLABEL;
            newCRDtask.type=INTEGRATIONREPLYLABEL;
            try{
                insert newCRDtask;
                update newBCTrecord;
            }catch(exception e){
                Id loggerId = logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLEBCTLABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,log);
            }
        }
        
        else{ //BCTnotification, we are currently not doing this.
            Case c=new Case();
            //Hardcoded BCT Managers queue name, change if needed.
            List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name=:CASE_BCTMANAGERSLABEL LIMIT 1];
            //crdqueue=new QueueSobject();
            if(crdqueueList.size()>0)
                crdqueue=crdqueueList[0]; // If the queue was valid and a record was found.
            if(crdqueue!=NULL){
                c.OwnerId=crdqueue.QueueId; //may cause problems
                c.Description=ONNOTIFICATIONFROMAETNAINTEGRATORLABEL+fieldsfilled+ PLEASEGOAHEAD; //$NON-NLS-1$
                try{
                    insert c;
                }catch(Exception e){
                    Id loggerId = logger.logmecall(AIResponseData,true,EXCEPTIONLABEL,EXCEPTIONLOOKINARGUMENTSlABEL,system.now(),Userinfo.getName(),WARNINGLABEL,e.getMessage(),BLANKSTRING,log);
                }
            }//end IF CRDqueue NULL
        }
        
    }
    
    //Added by Amit on 14th April"14, for CVH Release, Request 4702. For request type Traditional_LikePackage
    //Method to process the Traditional_LikePackage data    
    public void processTradLikePackagePackagedData(Integration_log__c log, BCTNotificationService.ReturnData AIResponseData,CRD__c sourceCrd){
        String Description;
        Description = CreateDescriptionString(AIResponseData);      
        if(AIResponseData.rxPlanBlock!=null){
            //we got the rxplan detail
            if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                //Assuming i will get only one RxPlanDetail To Be changed after call comment added on 6/25/2012 12.14                           
                BCTNotificationService.RxPlanDetail RxPlan = AIResponseData.rxPlanBlock.RxPlanDetail[0];
                //CheckArgument Condition Passed now do Match Argument with Source CRD                
                if((RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=BLANKSTRING) && (RxPlan.status!=null && RxPlan.status!=BLANKSTRING) && (AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=BLANKSTRING) && (AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=BLANKSTRING) && RxPlan.tieringType==TNLABEL){// as per mail tiering type should always be TN 
                    //Below is match argument ppid,pricingSchedule,state,riskindigator
                    if((sourceCrd.Pricing_Schedule__c!=null && sourceCrd.Pricing_Schedule__c==AIResponseData.pricingSchedule)){
                        this.AireplyBlock(AIResponseData,RxPlan,sourceCrd,TNLABEL,log);
                    }else{
                       // Id loggerId = logger.logme(AIResponseData,true,ARGUMENTMISMATCHLABEL,Description,system.now(),Userinfo.getName(),NONPACKAGELABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
                        IntegrationLogger.logme(log, true, ARGUMENTMISMATCHLABEL,Description,CREATEDACASELABEL);
                        this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISMATCHWthoutcolLABEL,Description,log.id);
                    }
                }else{
                   // Id loggerId = logger.logme(AIResponseData,true,ARGUMENTMISSINGLABEL + COLLANSTRING,Description,system.now(),Userinfo.getName(),NONPACKAGELABEL,CreateDescriptionString(AIResponseData),CRETEADTASKLABEL,sourceCRD.Id);
                    IntegrationLogger.logme(log, true,ARGUMENTMISMATCHLABEL,Description,CREATEDACASELABEL);
                    this.createTaskForData(AIResponseData,sourceCrd,ARGUMENTMISSINGLABEL,Description,log.id);                                  
                }
            }                       
        }       
    }
    Private static final string  COMPANYLABEL = 'Company: ';
    Private static final string  GROUPSLABEL = ',groups: ';
    Private static final string  LOCATIONLABEL = ',location: ';
    Private static final string  PLANLABEL = ',plan: ';
    Private static final string  CONTROLLABEL = 'control: ';
    Private static final string  SUFFIXLABEL = ',suffix: ';
    Private static final string  ACCOUNTLABEL = ',account: ';
    Private static final string  PLANSUMMARYLABEL = ',planSummary: ';
    Private static final string  PLANSUMMARYWITHOUTCOMMALABEL = 'planSummary: ';
    //Private static final STRING  label = bracketCloselabel;
    Private static final string  RXPLANBLOCKLABEL = ' rxPlanBlock:{ ';
    Private static final string  ERRRXPLANBLOCKLABEL = ' ErrRxPlanBlock:{ ';
    Private static final string  TIEREDRXPLANBLOCKLABEL = ' TieredRxPlanBlock:{ ';
    Private static final string  TIEREDRXPLANBLOCKERRORPLANLABEL = ' TieredRxPlanBlock.ErrorRxPlanDetails:{ ';
    Private static final string  HMOHIERARCHYLABEL = ' hmoHierarchy:{ ';
    Private static final string  TRADITIONALHIERARCHYLABEL = ' traditionalHierarchy:{ ';
    Private static final string  TRADITIONALCONTROLNUMBERPLANSUMMARYLABEL = ' traditionalControlNumberPlanSummary:{ ';
    Private static final string  CONTROLNUMBERLABEL = '{controlNumber: ';
    Private static final string  BRACKETCLOSELABEL = ' } ';


    Private static final STRING  REQUESTIDLABEL = ' RequestId: ';
    Private static final string  CRDIDLABEL = ' crdId: ';
    Private static final string  FUNDINGTYPELABEL = ' fundingType: ';
    Private static final string  REQUESTTYPELABEL = ' requestType: ';
    Private static final string  PRICINGSCHEDULELABEL = ' pricingSchedule :';
    Private static final string  RISKINDICATORLABEL = ' riskIndicator: ';
    Private static final string  PLANIDLABEL = ' planId: ';
    Private static final string  CUSTOMLABEL = ' Custom Ben Id: ';
    Private static final string  EFFECTIVEDATELABEL = ' effectiveDate: ';
    Private static final string  TERMDATELABEL = ' termDate: ';
    Private static final string  ERBLABEL = ' erb: ';
    Private static final string  SUBSEGMENTLABEL = ' subSegment: ';
    Private static final string  BENEFITSAPPLYTOALLSTATESLABEL = ' benefitsApplyToAllStates: ';
    Private static final string  BENEFITSSTATELISTLABEL = ' benefitsStateList: ';
    Private static final string  LISTOFSTATESTOREMOVEFROMPLANLABEL = ' listOfStatesToRemoveFromPlan: ';
    
    Private static final STRING  TRADITIONAL_NON_PACKAGEDLABEL = 'Traditional_Non_Packaged';
    Private static final string  SPACESTRING = ' ';
    Private static final string HMO_SOURCE_HMOLABEL = 'HMO_Source_HMO';
    Private static final string TRADITIONAL_LIKEPACKAGELABEL = 'Traditional_LikePackage';   
    Private static final string  NALABEL = 'NA'; 
    Private static final string  BLANKSTRING = '';  
    Private static final string  COLLANSTRING = ':';
    Private static final string  COMMASTRING = ',';
    Private static final string  SEMICOLLANSTRING = ';';
    Private static final string  NSTRING = 'N';
    Private static final string  YSTRING = 'Y'; 
    Private static final string  NAMESTRING = 'Name';   
    Private static final string  PPIDLABEL = 'PPID';
    Private static final string  TPIDLABEL = 'TPID';
    Private static final string  TRADITIONAL_PACKAGEDLABEL = 'Traditional_Packaged';
    Private static final string  NEWTASKCREATEDLABEL = 'New Task Created : ';
    Private static final string  HMO_PACKAGEDLABEL = 'HMO_Packaged';
    Private static final string  TRADITIONAL_SOURCE_PERSLABEL = 'Traditional_Source_PERS';
    Private static final string  HMO_CUSTOMLABEL = 'HMO_Custom';
    Private static final string  NOTIERDBLOCKLABEL = 'No TieredBlock With tieringType:';
    Private static final string  INVALIDDATACRDLABEL = 'Invalid Data for CRD provided';
    Private static final string TPIDACCOMPAI = 'One or more TPID accompanying arguments from AI were empty for';
    Private static final string  REPLYINVALIDDCNLABEL = 'Reply:InvalidDCN';
   // Private static final string  TPIDREPLYERRORGOTAINVALIDSTATUSLABEL = TPIDREPLYERRORGOTAINVALIDSTATUSLABEL;
    Private static final string  ARGUMENTERRORLABEL = 'Error in Arguments';
    Private static final string  REPLYERRORLABEL ='Error in reply';
    Private static final string  TIERINGBLOCKERRORLABEL = 'TieredBlock error';
    Private static final string  TIERINGBLOCKFOUNDERRORLABEL = 'No TieredBlock Block Found';
    Private static final string  TIERINGBLOCKSUPPLIEDERRORLABEL = 'No TieredBlock was supplied,look at arguments for Type. Identify case by TimeStamp';
    Private static final string  INVALIDTIERINGLABEL = 'Invalid Tiering:';
    Private static final string  ARGUMENTMISMATCHLABEL = 'Argument Mismatch:';
    Private static final string  ARGUMENTMISMATCHWTHOUTCOLLABEL = 'Argument Mismatch';
    Private static final string  CREATEDACASELABEL = 'created a case';
    Private static final string  ARGUMENTMISSINGLABEL = 'Argument Missing';
    Private static final string TNLABEL = 'TN';
    Private static final string EXCEPTIONLOOKINARGUMENTSlABEL = 'Exception was caught when trying to handle BCTnotification/ Else New case:Ln61, look under arguments for details';
    Private static final string EXCEPTIONLABEL = 'Exception';
    Private static final string WARNINGLABEL = 'Warning';
    Private static final string INTEGRATIONREPLYLABEL = 'Integration Reply';
    Private static final string NONPACKAGELABEL = 'Non-Package';
    Private static final string CRETEADTASKLABEL = 'created a task';
    Private static final string RXPLANIDLABEL = '{ RxPlanID: ';
    Private static final string STATUSLABEL = ', status: ';
    Private static final string TIERINGTYPELABEL = ', tieringType: ';
    Private static final string STATESLABEL = ', states: ';
	
	//Added for 5621 by ankur
    Private static final string ASMSMALLGROUPMASTERLABEL = 'ASM Small Group Master';
    Private static final string EVENT_NOTIFICATIONSLABEL = 'Event_Notifications';
    Private static final string ERRTIEREDRXPLANBLOCKLABEL = ' ErrTieredRxPlanBlock:{ ';
    Private static final string CASE_BCTMANAGERSLABEL = 'Case - BCT Managers';
    Private static final string CASELABEL = 'Case';
    Private static final string EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLEBCTNOTIFICATIONARGUMENTSLABEL = 'Exception was caught when trying to handle BCTnotification, look under arguments for details';
    Private static final string ERRORININPUTPARAMETERSLABEL = 'Error in Input Parameters';
    Private static final string ELABEL = 'E';
    Private static final string RXPLAN_ID_STATUSLABEL = 'RxPlan_ID_Status__c';
    Private static final string TIERINGLABEL = 'Tiering__c';
    Private static final string RISK_INDICATORLABEL = 'Risk_Indicator__c';
    Private static final string UPDATEDAETNAINTEGRATORLABEL = 'Updated: Aetna Integrator';
    Private static final string TPIDWASSUBMITTEDTOAETNAINTEGRATORLABEL = 'TPID was submitted to Aetna Integrator and an Existing status was returned.\n The CRD record was updated for RxPlanID, RxPlanID Status, Risk Indicator and Tiering';
    Private static final string TPIDREPLYEXISTINGGOTAEXISTINGLABEL = 'TPID reply: Existing';
    Private static final string UPDATEDRECORDANDCREATEANOTELABEL = 'updated record and create a note';
    Private static final string EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLETPIDLABEL = 'Exception was caught when trying to handle TPID TN reply.Existing/Create Note, look under arguments for details';
    Private static final string TPIDREPLYNEWGOTANEWLABEL = 'TPID reply:New';
    Private static final string UPDATEDRECORDANDCREATEATASKLABEL = 'updated record and create a task';
    Private static final string TPIDREPLYERRORGOTAINVALIDSTATUSLABEL = 'TPID reply:Error';

    Private static final string INVALIDSTATUSLABEL = 'Invalid Status: ';
    Private static final string INVALIDSTATUSFORATPIDBASEDREPLYLABEL = 'Invalid Status for a TPID based reply:';
    Private static final string TPIDREPLYTIERING_ADDITIONALRXPLANIDFORATPIDLABEL = 'TPID reply:Tiering- Additional RxPlanID';
    Private static final string CREATEDNEWCRDANDCREATEDATASKLABEL = 'Created new CRD and created a task';
    Private static final string EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLERXREPLYUPDATINGCRDRECORDSLABEL = 'Exception was caught when trying to handle Rxreply/Updating CRD record, look under arguments for details';
    Private static final string AETNAINTEGRATORSENTBACKREPLYFORYOURSUBMISSIONLABEL = 'Aetna integrator sent back reply for your submission, the CRD record has been updated. Please click on the CRD to review or complete the wizard';
    Private static final string EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLERXREPLYLABEL = 'Exception was caught when trying to handle Rxreply/Insert Task:Ln99, look under arguments for details';
    Private static final string DATELABEL = 'Date';
    Private static final string REPLYRECEIVEDFROMAI_TIERINGLABEL = 'Reply received from AI- Tiering';
    Private static final string AETNAINTEGRATORSENTBACKREPLYLABEL = 'Aetna integrator sent back reply for your TPID, system detected Tiering. The original record was updated and a new record was created for the additional tier';
    Private static final string EXCEPTIONWASCAUGHTWHENTRYINGTOHANDLEBCTLABEL = 'Exception was caught when trying to handle BCTnotification/new Task FLAG :Ln41, look under arguments for details';
    Private static final string PLEASEGOAHEADANDCOMPLETELABEL = ' Please go ahead and complete creating the CRD.';
    Private static final string ONNOTIFICATIONFROMAETNAINTEGRATORLABEL = 'On notification from Aetna Integrator, a new CRD was created and was filled with the values supplied:';
Private static final string VIEWTASK = 'To View task please <a href=';
Private static final string CLICKHERE = '>click here</a>.';
Private static final string BRACKETCLOSE = ' }';
Private static final string GOTANEXISTING = 'Got a Existing+TN reply for TPID we sent, system has updated the record';
Private static final string GOTANEW = 'Got a New+TN reply for TPID we sent, upated record and created task: ';
Private static final string GOTANINVALID = 'Got a Invalid Status+TN reply for TPID we sent, no modifications were done to record:';
Private static final string FORTPIGOTBACKREPLY = 'For a TPID we sent, we got back Tiered reply. This is the second task for the reply.';
Private static final string  REPLYRECIEVEDFROMAI= 'Reply received from AI ';
Private static final string PLEASEGOAHEAD = '  Please go ahead and complete creating the CRD.';
   
 
    //**Ends Request 4702   
}