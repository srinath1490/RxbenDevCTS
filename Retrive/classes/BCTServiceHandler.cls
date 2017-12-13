/*
*   Author :- Jooognu Rao 5/27/2014
*               Process Handler for BCT Notification Service
*   Revision:-  Chetan Garg - 08/15/2014
*       Hotfix - 1. For a BCT notification, if the Plan Type is not Traditional(In HMO),
*                   a.  If there is Error Code or Error Description , Create case.
*                   b.  If it is a success(No Error Code or Error Description) , then check the status in RxPlan Block (Rxplan Detail) , 
*                       if the status is N, then create a case. If its blank or have some other value, do nothing.
*/
public class BCTServiceHandler {
        
        /*
        *   Description :Main method to execute this handler
        */
        public static boolean execute(BCTNotificationService.ReturnData request){
            boolean hasSuccess = true; 
            Integration_log__c log = IntegrationLogger.createLog(request);
                try{
                    //Push all request data to integration log and save it 
                    if(String.isEmpty(request.crdId)){
                        //BCT Notification
                        processBCTNotification(request,log);
                    }else{
                        // for Non Medicare CRD
						system.debug('@@Richa = '+request.errortype);
                        if(request.crdId.startsWith(system.label.CL0000040)){                           
                            processCrd(request, log);
                        //Process for Medicare CRD
                        }else if (request.crdId.startsWith(system.label.CL0000041)){                            
                            processCrdMedicare(request,log);
                        }
                    }
                }catch(Exception ex){
                    hasSuccess = false;
                    //update integration log
                    system.debug('line'+ ex.getLineNumber());
                    log.Subject__c = ex.getMessage();
                }finally{ // Finally block to update Integration Log
                    update log;
              }
            return hasSuccess;
        }
        
        /*
        *   Description :Process standard CRD request.
        */
        private static void processCrd(BCTNotificationService.ReturnData request, Integration_log__c log){
            Crd__c sourceCrd;
            BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
            
            
            
            for(Crd__c crd : [SELECT 
                                    Id,OwnerId,Name,RxPlanID__c,TP_ID__c,Rx_PP_ID__c,RxPlan_ID_Status__c,Account__c,National__c,Sub_segment__c
                                    ,Tiering__c,Y_Schd__c,Pricing_Schedule__c,Risk_Indicator__c,Account_State__c,Insured_Type__c,Effective_Start_Date__c
                                    ,Platform_Information__c,CRD_Automated__c 
                            FROM 
                                CRD__c 
                            WHERE 
                                Id=:request.crdId]){
                sourceCrd = crd;
            }
            
            if(sourceCrd == null){
                dataProcessor.createCaseForData(request,'No CRD exists for the supplied DCN:'+dataProcessor.CreateDescriptionString(request),'','','','DCN error',log);
                IntegrationLogger.logme(log, true, 'Error in DCN for a Reply','An invalid DCN was supplied,look at arguments for Type. Identify case by TimeStamp','created a case');
                    
            }else{
                log.CRD__c = sourceCrd.id;
                if( ! String.isEmpty(request.errorType) || ! String.isEmpty(request.errorDescription)){ //Error element was filled
                     dataProcessor.createCaseForData(request,dataProcessor.CreateDescriptionString(request),'','','',request.errorDescription,log);
                     IntegrationLogger.logme(log, true, 'Error in reply','Error field was filled in for a reply','created a case');                                     
                  }/*else{ //no error element.
                    
                     //For Traditional non package,we create a CRD Build order record with CRD set to the CRDID in the callout.CAG, XML, PDF, CVS, PERS checkboxes to false. Case to NULL
                       
                       //Added by JR to implement Case Enhancement
                       
                       if(sourceCrd.CRD_Automated__c == true){
                            CRDBuildOrder__c existingBuilderRecord = new CRDBuildOrder__c();
                            for(CRDBuildOrder__c builder :  [select 
                                                            id,CRD__c,CRD__r.CRD_Automated__c,CAG__c,XML__c,PDF__c,CVS__c,PERS__c,Case__c 
                                                        from 
                                                            CRDBuildOrder__c 
                                                        where 
                                                            CRD__c=:sourceCrd.id]){
                            if(builder!=null){
                                existingBuilderRecord = builder;
                            }
                        }
                           existingBuilderRecord.CRD__c  = sourceCrd.Id;
                           existingBuilderRecord.Processed__c = false;
                           existingBuilderRecord.CAG__c = false;
                           existingBuilderRecord.XML__c = false;
                           existingBuilderRecord.PDF__c = false;
                           existingBuilderRecord.CVS__c = false;
                           existingBuilderRecord.PERS__c = false; 
                           existingBuilderRecord.Case__c = null;
                           upsert existingBuilderRecord;
                       }
                       
                     sourceCrd.Status__c='RxPlan Returned, Waiting to send to CVS';
                     update sourceCRD;
                 }*/
                 dataProcessor.processExistingData(log,request,sourceCRD);
            }
        }
        
        
        
        /*
        *   Description :Process Medicare CRD request.
        */
        private static void processCrdMedicare(BCTNotificationService.ReturnData request,Integration_log__c log){
            CRD_Medicare__c sourceMedCrd;
            //Instantiate BCTNotificationProcessor
            BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
            for(CRD_Medicare__c crd : [SELECT               
                                            Id,OwnerId,Name,Custom_BEN_ID__c,Do_mandates_apply_to_all_states__c,Funding_Type__c,Remove_States_List_for_Mandate__c,Request_Type__c,Risk_Indicator__c,RxPlan_ID__c,State_List_for_Mandate__c,Y_Schedule__c 
                                       FROM 
                                            CRD_Medicare__c
                                       WHERE 
                                            Id=:request.crdId]){
                            sourceMedCrd = crd;
            }
            //check if medicare crd is null
            if(sourceMedCrd == null){
                dataProcessor.createCaseForData(request,'No CRD exists for the supplied DCN:'+dataProcessor.CreateDescriptionString(request),'','','','DCN error',log);
                IntegrationLogger.logme(log, true, 'Error in DCN for a Reply','An invalid DCN was supplied,look at arguments for Type. Identify case by TimeStamp','created a case');
                          
            }else{ 
                if(request.rxPlanBlock!=null && request.rxPlanBlock.RxPlanDetail!=null && request.rxPlanBlock.RxPlanDetail.size()>0){
                   sourceMedCrd.RxPlan_ID__c=request.rxPlanBlock.RxPlanDetail[0].RxPlanID;
                }
                IntegrationLogger.logmedicareId(log, false, 'Valid BCT notificaiton','Medicare CRD updated','Created Success Log',sourceMedCrd.Id);
                update sourceMedCrd;
            }
        }
        
        
            /*
        *   Description :Process BCT Notification.
        */
        private static void processBCTNotification(BCTNotificationService.ReturnData request,Integration_log__c  log){
            Set<String> traditionalTypePlans = new Set<String>{'TraditionalInstate', 'TraditionalOutOfState', 'TraditionalConfigID', 'TraditionalNonPkg'};
            Set<String> pkgTypePlans = new Set<String>{'TraditionalInstate', 'TraditionalOutOfState', 'TraditionalConfigID'}; ///Non pck - TraditionalNonPkg
            
            Boolean Traditional =  traditionalTypePlans.contains(request.TypeofPlan);
            Boolean Pckge =  pkgTypePlans.contains(request.TypeofPlan); 
            
             //  case module implementation.
             BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
                        
            //For Traditional  Plan
            if(Traditional){
                //Packaged plan with either error type or Non Package plan with error description
                if( (Pckge &&  !String.isBlank(request.errorType) )  || ( ! Pckge && !String.isBlank(request.errorDescription))){
                    system.debug('requestdescr:'+request.errorDescription);
                    if(Pckge== true && request.errorDescription!=Null && request.errorDescription.startsWith('Multiple RxPlanIDs')){
                        dataProcessor.createCaseForData(request,dataProcessor.CreateDescriptionString(request),'','','',request.errorDescription,log);
                    }else{
                        // create notification fallout Record
                        BCTNotificationFallout falloutHandler = new BCTNotificationFallout ();
                        falloutHandler.BCTNotificationFallout (request,Traditional,Pckge,log );
                    }
                }else{//If this is not pcked plan
                    // create notification standard Record
                    BCTnotificationsuccess stndrdhandler = new BCTnotificationsuccess ();
                    BCTNotificationSuccess.ProcessBCTNotificationStandard(request,Traditional,Pckge,log );
                }
            }else{//IF Plan is not Traditional
                if(! String.isBlank(request.errorType)  || ! String.isBlank(request.errorDescription)){
                    // create notification fallout Record
                    BCTNotificationFallout falloutHandler = new BCTNotificationFallout ();
                    falloutHandler.BCTNotificationFallout (request,Traditional,Pckge,log );
                    //Create case if this is not traditional plan and has Error
                    dataProcessor.createCaseForData(request,dataProcessor.CreateDescriptionString(request),'','','',request.errorDescription,log);
                }else{
                    // create notification standard Record
                    BCTNotificationSuccess.ProcessBCTNotificationStandard(request,Traditional,Pckge,log );
                    //Create case if status in RxPlan Block (Rxplan Detail) is 'N'
                    if(request.rxPlanBlock != null && request.rxPlanBlock.RxPlanDetail != null){
                        boolean hasNStatus = false;
                        for(BCTNotificationService.RxPlanDetail rxDetail : request.rxPlanBlock.RxPlanDetail){
                            if(rxDetail.status == 'N'){
                                hasNStatus = true;
                            }
                        }
                        
                        if(hasNStatus){
                            dataProcessor.createCaseForData(request,dataProcessor.CreateDescriptionString(request),'','','',request.errorDescription,log);
                        }
                    }
                }
            }
            
        }
    }