/*
Class for Notification Success Process
*/


Global class BCTNotificationSuccess{


    // Method to insert data in Notification Standard table based on given criteria.    
    public static void ProcessBCTNotificationStandard(BCTNotificationService.ReturnData requestData, Boolean traditional, Boolean packageType,Integration_log__c  log){
        //added by abhishek date on 4/15/2014  
        string typeofplanFallOut = '';
        if(requestData.typeofPlan != null)
            typeofplanFallOut = requestData.typeofPlan.toLowerCase();
       // try{

              BCTNotificationProcessor dataProcess = new BCTNotificationProcessor ();
              // to check if return data is traditional or not
                if(traditional == true){ 

                system.debug('data insertion');

                NotificationStandard__c objNotStandard = new NotificationStandard__c();
                system.debug('here traditiaonl');
        
               //field mapping
                objNotStandard.benefitsString__c = requestData.benefitsString;
                objNotStandard.benefitsStringExtension__c = requestData.benefitsStringExtension;
                objNotStandard.CarrierId__c = requestData.CarrierId;
                objNotStandard.Acquisition_Indicator__c = requestData.acquisitionCode;
                system.debug('@@@Acquisition_Indicator__c' + objNotStandard.Acquisition_Indicator__c);
                objNotStandard.CFO__c = requestData.CFO;
                
                objNotStandard.MarketSegment__c = requestData.MarketSegment;

                if(requestData.effectiveDate != null && requestData.effectiveDate != '' ){
                    objNotStandard.effectiveDate__c = date.valueof(requestData.effectiveDate);
                }

                objNotStandard.ERB__c = requestData.erb;
                objNotStandard.ErrorDescription__c = requestData.errorDescription;
                objNotStandard.ErrorType__c = requestData.errorType;
                objNotStandard.FundingType__c = requestData.fundingType;
                objNotStandard.OrgArrangementId__c = requestData.OrgArrangementId;
                objNotStandard.OrgId__c = requestData.OrgId;
                objNotStandard.OrgType__c = requestData.OrgType;                            
                //objNotStandard.rxPlanBlock__c = string.valueof(requestData.rxplanBlock);
                string tempRxplanblock ='';
                if(requestData.rxPlanBlock!=null){
                  if(requestData.rxPlanBlock.RxPlanDetail!=null && requestData.rxPlanBlock.RxPlanDetail.size()>0){
                        tempRxplanblock = tempRxplanblock+' rxPlanBlock:{ ';
                        tempRxplanblock = tempRxplanblock+ dataProcess.getRxPlanItems(requestData.rxPlanBlock.RxPlanDetail);
                        tempRxplanblock = tempRxplanblock+' } ';                    
                   }
                  objNotStandard.rxPlanBlock__c = tempRxplanblock;                                                   
                }

                //objNotStandard.tieredRxPlanBlock__c = string.valueof(requestData.tieredRxplanBlock);
                string tempTieredRxPlanBlock ='';
               if(requestData.tieredRxPlanBlock!=null){                
                  if(requestData.tieredRxPlanBlock.RxPlanDetail!=null && requestData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+' TieredRxPlanBlock:{ ';
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+ dataProcess.getRxPlanItems(requestData.tieredRxPlanBlock.RxPlanDetail);
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+' } ';                    
                   }
                    objNotStandard.tieredRxPlanBlock__c =tempTieredRxPlanBlock;
               }
               // objNotStandard.traditionalControlNumberPlanSummaryDetai__c = string.valueof(requestData.traditionalControlNumberPlanSummaryDetails);
               
               string temptraditionalControlNumberPlanSummaryDetails ='';
               if(requestData.traditionalControlNumberPlanSummaryDetails!=null){
                temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+ ' traditionalControlNumberPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:requestData.traditionalControlNumberPlanSummaryDetails){
                    temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+'{controlNumber: '+summary.controlNumber;
                    temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+'planSummary: '+summary.planSummary+' } ';
                }
                temptraditionalControlNumberPlanSummaryDetails = temptraditionalControlNumberPlanSummaryDetails+' } ';
                objNotStandard.traditionalControlNumberPlanSummaryDetai__c = temptraditionalControlNumberPlanSummaryDetails;
               
               }
               
                //objNotStandard.traditionalHierarchy__c = string.valueof(requestData.traditionalHierarchy);                         
                String description ='';
                if(requestData.traditionalHierarchy!=null){
                        description=description+ ' traditionalHierarchy:{ ';
                        description=description+'control: '+requestData.traditionalHierarchy.control;
                        description=description+',suffix: '+requestData.traditionalHierarchy.suffix;
                        description=description+',account: '+requestData.traditionalHierarchy.account;
                        description=description+',planSummary: '+requestData.traditionalHierarchy.planSummary;                           
                    description = description+' } ';
                    objNotStandard.traditionalHierarchy__c =description;  

               } 
                if(requestData.traditionalHierarchy!=null){
                    objNotStandard.Trad_AccountId__c=string.valueOf(requestData.traditionalHierarchy.account);
                }               
                objNotStandard.PlanId__c = requestData.planId;
                objNotStandard.pricingSchedule__c = requestData.pricingSchedule;
                objNotStandard.PSUID__c = requestData.PSUID;
                objNotStandard.RequestType__c = requestData.requestType;
                objNotStandard.riskIndicator__c = requestData.riskIndicator;                
                objNotStandard.Subsegment__c = requestData.subSegment;                          
                if(requestData.termDate != null && requestData.termDate != '' ){
                //Changed Saraag Oct18
                    objNotStandard.TermDate__c = requestData.termDate.split('T', 0)[0];
                }              
                objNotStandard.Traditional__c = true;                            
                objNotStandard.TypeOfPlan__c = requestData.TypeofPlan;
                system.debug('objNotStandard.TypeOfPlan__c'+objNotStandard.TypeOfPlan__c);
                if(requestData.rxplanBlock != null && requestData.rxplanBlock.RxplanDetail != null 
                            && requestData.rxplanBlock.RxplanDetail.size() > 0 && requestData.rxplanBlock.RxplanDetail[0].RxplanId != null){
                    objNotStandard.Rxplanid__c = requestData.rxplanBlock.RxplanDetail[0].RxplanId;
                     system.debug('objNotStandard.Rxplanid__c'+objNotStandard.Rxplanid__c);
                }
                if(requestData.traditionalHierarchy != null){
                    if(requestData.traditionalHierarchy.control!=null && requestData.traditionalHierarchy.planSummary!=null)
                    objNotStandard.ControlPlan__c = requestData.traditionalHierarchy.control + requestData.traditionalHierarchy.planSummary;
                    system.debug(' objNotStandard.ControlPlan__c '+ objNotStandard.ControlPlan__c);
                    if(requestData.effectiveDate != null && requestData.effectiveDate != ''){
                        objNotStandard.ControlPlanEffective__c = objNotStandard.ControlPlan__c + requestData.effectiveDate.split('T', 0)[0];
                        system.debug(' objNotStandard.ControlPlanEffective__c '+ objNotStandard.ControlPlanEffective__c);
                    }  
                    else{
                        objNotStandard.ControlPlanEffective__c = objNotStandard.ControlPlan__c ;
                        system.debug(' objNotStandard.ControlPlanEffective__c '+ objNotStandard.ControlPlanEffective__c);
                    } 
                    
                     if(requestData.traditionalHierarchy.suffix != null){
                        objNotStandard.suffix__c = string.valueOf(requestData.traditionalHierarchy.suffix);
                    }      
                    objNotStandard.Plan__c=requestData.traditionalHierarchy.planSummary ;
                    system.debug(' objNotStandard.Plan__c '+objNotStandard.Plan__c);
                    string tempControl='';
                    objNotStandard.control__c=tempControl +requestData.traditionalHierarchy.control ; 
                    system.debug(' objNotStandard.control__c '+objNotStandard.control__c);

                }else{
                  //objNotStandard.ControlPlanEffective__c = null;
                }
                objNotStandard.Package__c = packageType;
                //Added by Abhishek
                if(typeofplanFallOut.contains('trad') || typeofplanFallOut.contains('hmo')){ 
                    if(requestData.accountname!=null && requestData.accountname !=''){
                        objNotStandard.accountname__c = requestData.accountname; 
                    }     
                }     
                // insert into the table. 
                insert objNotStandard;
                IntegrationLogger logger=new IntegrationLogger();
                log.NotificationStandard__c =objNotStandard.id;
                system.debug('Hello'+objNotStandard.Id);
                } else {
                if(requestData.rxplanBlock!=null && requestData.rxplanBlock.RxplanDetail[0].status!=null && requestData.rxplanBlock.RxplanDetail[0].status!=''&& requestData.rxplanBlock.RxplanDetail[0].status=='N'){
                //case creation                                   
                BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
                IntegrationLogger logger=new IntegrationLogger();
                    if((requestData.errorType!=null && requestData.errorType!='') || (requestData.errorDescription!=null && requestData.errorDescription!='')){
                         System.debug('##########6##########');
                        dataProcessor.createCaseForData(requestData,dataProcessor.CreateDescriptionString(requestData),'','','',requestData.errorDescription,log);
                        Id loggerId =logger.logmecall(true,'Error in BCTnotification','Error field was filled in for a BCT notification',system.now(),Userinfo.getName(),'BCTnotification',dataProcessor.CreateDescriptionString(requestData),'created a case',log);
                    }else{
                     System.debug('##########7##########');
                      dataProcessor.createCaseForData(requestData,dataProcessor.CreateDescriptionString(requestData),'AI notification','Benefit Control Implementation Support','Other','Notification from Aetna Integrator',log);
                      // Added by Sourabh 07/16/2012
                      //Id loggerId =logger.logme(true,'Error in DCN for a Reply','An invalid DCN was supplied,look at arguments for Type. Identify case by TimeStamp',system.now(),Userinfo.getName(), 'Reply:InvalidDCN',dataProcessor.CreateDescriptionString(requestData),'created a case');
                      Id loggerId = logger.logmecall(false,'Valid BCT notificaiton','A new case was created for the BCT notification',system.now(),Userinfo.getName(),'BCTnotification',dataProcessor.CreateDescriptionString(requestData),'Created a Case',log);
                    }

                system.debug('case creation 2');

                }else{
                // ignore Record
                system.debug('record ignored');          
                }
            }
          


        //}  catch(Exception e) {
        //    IntegrationLogger logger=new IntegrationLogger(); 
         //   logger.logme(false,'Exception In call','There is an exception thrown on the request',system.now(),Userinfo.getName(),'BCTnotification','Exception details'+e,'Exception is:'+e);
        //}

    }
}