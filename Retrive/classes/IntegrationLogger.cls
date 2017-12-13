/*
Project: Aetna.8380
Team Lead: Josh Turnof; joshua.turnof@accenture.com
Developer: Saraag Reddy: rsaraag@gmail.com
Package: None

Dependencies: 8269c.Aetna Integrator; Lead by: Mike Bougie; bougiem@aetna.com
Requires: CRD__c, Task, Case,IntegrationLog__c, AIreplyHandler.cls,IntegrationLogger.cls
Description: Class used to create Integration_log__c records, this class is called by AIreplyHandler, IntegrationDispatcher whenver AI calls salesforce.com.
*/
Public class IntegrationLogger{
  Integration_log__c handle;
  
   public Id logme(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result){
     
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result);
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek 
   public Id logmecall(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Integration_log__c log){
     
     log.Error__c=isError;
     log.subject__c=subject;
     log.Description__c=description;
     log.Time_Stamp__c=timestamp;
     log.Who__c=who;
     log.Selection__c=selection;
     log.Arguments__c=arguments;
     log.Result__c=result;
     try{
     //insert handle;
     return log.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
    public Id logmedicare(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId){     
      
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result,CRD_Medicare__c=crdId);
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek
    public Id logmedicarecall(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId,Integration_log__c log){     
      
     log.Error__c=isError;
     log.subject__c=subject;
     log.Description__c=description;
     log.Time_Stamp__c=timestamp;
     log.Who__c=who;
     log.Selection__c=selection;
     log.Arguments__c=arguments;
     log.Result__c=result;
     log.CRD_Medicare__c=crdId;
     try{
     //insert handle;
     return log.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
    public Id logmedicare(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        string errtieredRxPlanBlockDescription;
        String controlPlanSummary;
        
        
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result,CRD_Medicare__c=crdId);
     if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             handle.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+handle.changeLevelIndicator__c);
        }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             handle.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+handle.acquisitionCode__c);
        }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
            handle.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            handle.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            handle.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            handle.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        handle.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            handle.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            handle.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            handle.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            handle.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            handle.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            handle.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            handle.riskIndicator__c = AIResponseData.riskIndicator;
        }
        system.debug('**AIResponseData.rxPlanBlock**'+AIResponseData.rxPlanBlock);
        
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                   
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
             
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
               }
        handle.controlPlanSummary__c= controlPlanSummary;              
        handle.rxPlanBlock__c = rxPlanBlockDescription;
        handle.rxplanblockerrors__c = errRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek
    public Id logmedicarecall(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId,Integration_log__c log){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        string errtieredRxPlanBlockDescription;
        String controlPlanSummary;
        
        
     log.Error__c=isError;
     log.subject__c=subject;
     log.Description__c=description;
     log.Time_Stamp__c=timestamp;
     log.Who__c=who;
     log.Selection__c=selection;
     log.Arguments__c=arguments;
     log.Result__c=result;
     log.CRD_Medicare__c=crdId;
     if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             log.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+handle.changeLevelIndicator__c);
        }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             log.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+handle.acquisitionCode__c);
        }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
            log.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            log.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            log.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            log.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        log.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            log.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            log.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            log.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            log.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            log.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            log.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            log.riskIndicator__c = AIResponseData.riskIndicator;
        }
        system.debug('**AIResponseData.rxPlanBlock**'+AIResponseData.rxPlanBlock);
        
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                   
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
             
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
               }
        log.controlPlanSummary__c= controlPlanSummary;              
        log.rxPlanBlock__c = rxPlanBlockDescription;
        log.rxplanblockerrors__c = errRxPlanBlockDescription;
        log.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        log.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        log.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
     try{
   //  insert handle;
     return log.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   public Id logme(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId){     
      
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result,CRD__c=crdId);
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek
    public Id logmecall(boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId,Integration_log__c log){     
     log.Error__c=isError;
     log.subject__c=subject;
     log.Description__c=description;
     log.Time_Stamp__c=timestamp;
     log.Who__c=who;
     log.Selection__c=selection;
     log.Arguments__c=arguments;
     log.Result__c=result;
     log.CRD__c=crdId;
     try{
    // insert handle;
     return log.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   
   public Id logme(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        string errtieredRxPlanBlockDescription;
        String controlPlanSummary;
        
        
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result);
     if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             handle.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+handle.changeLevelIndicator__c);
        }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             handle.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+handle.acquisitionCode__c);
        }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
            handle.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            handle.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            handle.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            handle.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        handle.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            handle.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            handle.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            handle.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            handle.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            handle.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            handle.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            handle.riskIndicator__c = AIResponseData.riskIndicator;
        }
        system.debug('**AIResponseData.rxPlanBlock**'+AIResponseData.rxPlanBlock);
        
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                   
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
             
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
               }
        handle.controlPlanSummary__c= controlPlanSummary;              
        handle.rxPlanBlock__c = rxPlanBlockDescription;
        handle.rxplanblockerrors__c = errRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek
      
   public Id logmecall(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Integration_log__c log){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        string errtieredRxPlanBlockDescription;
        String controlPlanSummary;
  
     log.Error__c=isError;
     log.subject__c=subject;
     log.Description__c=description;
     log.Time_Stamp__c=timestamp;
     log.Who__c=who;
     log.Selection__c=selection;
     log.Arguments__c=arguments;
     log.Result__c=result;
     if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             log.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+log.changeLevelIndicator__c);
        }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             log.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+log.acquisitionCode__c);
        }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
            log.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            log.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            log.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            log.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        log.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            log.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            log.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            log.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            log.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            log.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            log.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            log.riskIndicator__c = AIResponseData.riskIndicator;
        }
        system.debug('**AIResponseData.rxPlanBlock**'+AIResponseData.rxPlanBlock);
        
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                   
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
             
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
               }
        log.controlPlanSummary__c= controlPlanSummary;              
        log.rxPlanBlock__c = rxPlanBlockDescription;
        log.rxplanblockerrors__c = errRxPlanBlockDescription;
        log.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        log.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        log.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
     try{
    // insert handle;
     return log.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   
    public Id logme(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        string errtieredRxPlanBlockDescription;
        String controlPlanSummary;
        
        
     handle=new Integration_log__c(Error__c=isError,subject__c=subject,Description__c=description,Time_Stamp__c=timestamp,Who__c=who,Selection__c=selection,Arguments__c=arguments,Result__c=result);
     if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             handle.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+handle.changeLevelIndicator__c);
        }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             handle.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+handle.acquisitionCode__c);
        }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
            handle.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            handle.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            handle.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            handle.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        handle.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            handle.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            handle.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            handle.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            handle.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            handle.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            handle.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            handle.riskIndicator__c = AIResponseData.riskIndicator;
        }
        system.debug('**AIResponseData.rxPlanBlock**'+AIResponseData.rxPlanBlock);
        
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                   
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
             
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
               }
        handle.controlPlanSummary__c= controlPlanSummary;              
        handle.rxPlanBlock__c = rxPlanBlockDescription;
        handle.rxplanblockerrors__c = errRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
        
     try{
     insert handle;
     return handle.Id;
     }catch(Exception e){
       system.debug(e.getMessage());
       return null;
     }
   }
   //added by abhishek 
   public Id logmeCall(BCTNotificationService.ReturnData AIResponseData,boolean isError,String subject,String description,Datetime timestamp,string who,string selection,string arguments,string result,Id crdId,Integration_log__c log){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        String errtieredRxPlanBlockDescription;
        String controlPlanSummary;
         
         log.Error__c=isError;
         log.subject__c=subject;
         log.Description__c=description;
         log.Time_Stamp__c=timestamp;
         log.Who__c=who;
         log.Selection__c=selection;
         log.Arguments__c=arguments;
         log.Result__c=result;
         log.CRD__c=crdId;
         if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             log.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
             system.debug('handle.changeLevelIndicator__c'+log.changeLevelIndicator__c);
          }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             log.acquisitionCode__c = AIResponseData.acquisitionCode;
              system.debug('handle.acquisitionCode__c'+log.acquisitionCode__c);
         }
         if(AIResponseData.benefitsApplyToAllStates!=null){     
            log.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
         
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            log.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            log.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            log.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
         log.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            log.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            log.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            log.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            log.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            log.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            log.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            log.riskIndicator__c = AIResponseData.riskIndicator;
        }
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
                      if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
                      if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                            rxPlanBlockDescription =' rxPlanDetail:{ ';
                            rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                            rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                       }
        
                   }
                   
                   /*
                   if(AIResponseData.errRxPlanBlock!=null){                  
                      if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                            errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                            errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                            errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                       }
        
                   }*/
                    //for error on tiered block errors
                   if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
                      if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                            tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                            tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
                   
                   //for error on tiered block errors
                    if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
                      if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                            errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                            errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                       }
                  
                   }
         if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                controlPlanSummary=' controlPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                    controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
                }
                controlPlanSummary = controlPlanSummary+' } ';
          }
        log.controlPlanSummary__c= controlPlanSummary;                      
        log.rxPlanBlock__c = rxPlanBlockDescription;
        log.rxplanblockerrors__c = errRxPlanBlockDescription;
        log.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        log.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
                
        try{
          //  insert handle;
             return log.id;
         }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }   
   }
       public static string getRxPlanItems(list<BCTNotificationService.RxPlanDetail> lstRxPlan){
        string description;
        description=' ';
        for(BCTNotificationService.RxPlanDetail RxPlan:lstRxPlan){
               if(RxPlan.RxPlanID!=null && RxPlan.RxPlanID!=''){    
                description = description+' RxPlanID: '+RxPlan.RxPlanID;
               }
               if(RxPlan.status!=null && RxPlan.status!=''  ){
                description = description+' status: '+RxPlan.status;
               }
               if(RxPlan.tieringType!=null && RxPlan.tieringType!=''){
                description = description+' tieringType: '+RxPlan.tieringType;
               }
               if(RxPlan.states!=null && RxPlan.states!=''){
                description = description+' states: '+RxPlan.states;
               }
          
          }
          return description;
    }
    
   
    
    /*
   *    Create Integration log and return reference of integration log record
   */
   public static void logme(Integration_log__c log, boolean isError, string subject,string description,string result){
    log.Error__c =  isError;
    Log.subject__c =    subject;
    Log.description__c =    description;
    Log.result__c =     result; 
    //Log.CRD_Medicare__c = crdId;
   }
   
   
  /*
   *     added by abhishek
   *    Create Integration log and return reference of integration log record with medicate id.
   */
   public static void logmedicareId(Integration_log__c log, boolean isError, string subject,string description,string result,Id crdId){
    log.Error__c =  isError;
    Log.subject__c =    subject;
    Log.description__c =    description;
    Log.result__c =     result; 
    Log.CRD_Medicare__c = crdId;
   }
    
   /*
   *    Create Integration log and return reference of integration log record
   */
   public static Integration_log__c createLog(BCTNotificationService.ReturnData AIResponseData){
        String rxPlanBlockDescription;
        String errRxPlanBlockDescription;
        String tieredRxPlanBlockDescription;
        String errtieredRxPlanBlockDescription;
        String controlPlanSummary;
        Integration_log__c handle=new Integration_log__c(
                        Error__c=false
                        ,subject__c='Initial'
                        ,Time_Stamp__c = Datetime.now() 
                        ,Who__c= UserInfo.getuserId()
                    ); 
       /* Integration_log__c handle=new Integration_log__c();
        handle.Error__c=false;
        handle.subject__c='Initial';
        handle.Time_Stamp__c = Datetime.now();
        handle.Who__c= UserInfo.getuserId();       */    
         if(AIResponseData.MarketSegment!=null && AIResponseData.MarketSegment!=''){
            handle.MarketSegment__c = AIResponseData.MarketSegment;
            
         }
         if(AIResponseData.CFO!=null && AIResponseData.CFO!=''){
            handle.CFO__c = AIResponseData.CFO;
         }
         if(AIResponseData.changeLevelIndicator!=null && AIResponseData.changeLevelIndicator!=''){
             handle.changeLevelIndicator__c = AIResponseData.changeLevelIndicator;
          }
         if(AIResponseData.acquisitionCode!=null && AIResponseData.acquisitionCode!=''){
             handle.acquisitionCode__c = AIResponseData.acquisitionCode;
         }
         if(AIResponseData.benefitsApplyToAllStates!=null){     
            handle.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
         }
       
         if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
            handle.benefitsStateList__c = AIResponseData.benefitsStateList;
         }
         
         if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
            handle.benefitsString__c = AIResponseData.benefitsString;
         }
         
         if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
            handle.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
         }   
        handle.controlPlanSummary__c ='';
         if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
            handle.errorDescripton__c = AIResponseData.errorDescription;
         }
         
         if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
            handle.errorType__c = AIResponseData.errorType;
         }
        if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){       
            handle.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;  
        }
        if(AIResponseData.planId!=null && AIResponseData.planId!=''){  
            handle.planID__c = AIResponseData.planId;
        } 
        if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){ 
            handle.pricingSchedule__c = AIResponseData.pricingSchedule;  
        }
        if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){       
            handle.requestType__c = AIResponseData.requestType;
        }
        if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
            handle.riskIndicator__c = AIResponseData.riskIndicator;
        }
        if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails!=null){
          if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                errRxPlanBlockDescription =' ErrRxPlanBlock:{ ';
                errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
          }

        }
                   
        if(AIResponseData.rxPlanBlock!=null && AIResponseData.rxPlanBlock.rxPlanDetail!=null){
          if(AIResponseData.rxPlanBlock.rxPlanDetail!=null && AIResponseData.rxPlanBlock.rxPlanDetail.size()>0){
                rxPlanBlockDescription =' rxPlanDetail:{ ';
                rxPlanBlockDescription = rxPlanBlockDescription+ getRxPlanItems(AIResponseData.rxPlanBlock.rxPlanDetail);
                rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
           }

        }
       
       /*
           if(AIResponseData.errRxPlanBlock!=null){                  
              if(AIResponseData.errRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.errRxPlanBlock.errorRxPlanDetails.size()>0){
                    errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                    errRxPlanBlockDescription = errRxPlanBlockDescription+ getRxPlanItems(AIResponseData.errRxPlanBlock.errorRxPlanDetails);
                    errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
               }

           }*/
        //for error on tiered block errors
       if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails==null){                
          if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
           }
      
       }
       
       //for error on tiered block errors
        if(AIResponseData.tieredRxPlanBlock!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null){                
          if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                errtieredRxPlanBlockDescription= ' ErrorTieredRxPlanBlock:{ ';
                errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
           }
      
       }
       if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
            controlPlanSummary=' controlPlanSummary:{ ';
            for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                controlPlanSummary=controlPlanSummary+'{controlNumber: '+summary.controlNumber;
                controlPlanSummary=controlPlanSummary+'planSummary: '+summary.planSummary+' } ';
            }
            controlPlanSummary = controlPlanSummary+' } ';
        }
        handle.controlPlanSummary__c= controlPlanSummary;                      
        handle.rxPlanBlock__c = rxPlanBlockDescription;
        handle.rxplanblockerrors__c = errRxPlanBlockDescription;
        handle.tieredrxplanblock__c = tieredRxPlanBlockDescription;
        handle.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;
                
        try{
            insert handle;
         }catch(Exception e){
            system.debug(e.getMessage());
        } 
        return handle;  
   }
// added by Vikram for CMM Integration
    public void initialiseLogCMM(String subject, String checkpt, string arguments){
         
         handle = new Integration_log__c (); 
     
         handle.subject__c = subject;
         handle.Description__c = checkpt;
         handle.Arguments__c = arguments;
     
         return;
     }
   
     public void logCMMState( String checkpt){
         
         handle.Description__c = checkpt;
     
         return;
     }

     public void logCMMError( boolean isError, String subject, String errorDescripton, String errorType){
         
         handle.Error__c = isError;
         handle.subject__c = subject;
         handle.errorDescripton__c = errorDescripton;
         handle.errorType__c = errorType;
     
         return;
     } 
     
     public void finalLogCMM(String subject, String checkpt, string outputArguments){
         
         handle.subject__c = subject;
         handle.Description__c = checkpt;
         handle.CMMOutputArguments__c = outputArguments;
     
         return;
     }
   
     public void logCMMCommit(){
         
         insert handle;
     
         return;
     }
     // CMM Integration code ends
}