/*
Class for Notification Fallout Process
Last Modified by:Abhay Arora 28-06-2012:10.26AM
*/
public with sharing class BCTNotificationFallout {
    //This Method will be called by BCTNotification service to create Notification Fallouts
    public void BCTNotificationFallout (BCTNotificationService.ReturnData AIResponseData,Boolean Traditional,Boolean packageType,Integration_log__c log){
        //added by abhishek date on 4/15/2014
        string typeofplanFallOut = '';
        if(AIResponseData.typeofPlan != null)
            typeofplanFallOut = AIResponseData.typeofPlan.toLowerCase();
       // try{
            BCTNotificationProcessor dataProcess = new BCTNotificationProcessor ();
            NotificationFallout__c insertFallout = new NotificationFallout__c();
            // Check if the returndata is traditional or not.
            if(Traditional){

                system.debug('Traditional insertion');
                system.debug('here traditiaonl');

                //Create Fallout and map the xml to fields
                insertFallout.benefitsString__c = AIResponseData.benefitsString;
                insertFallout.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;
                insertFallout.CarrierId__c = AIResponseData.CarrierId;
                insertFallout.Acquisition_Indicator__c = AIResponseData.acquisitionCode;                
                system.debug('@@@Acquisition_Indicator__c' + insertFallout.Acquisition_Indicator__c);

                //insertFallout.ROWID__c = Decimal.valueof(AIResponseData.ROWID);
                if(AIResponseData.effectiveDate != null && AIResponseData.effectiveDate != '' ){
                    insertFallout.effectiveDate__c = date.valueof(AIResponseData.effectiveDate );
                }

                insertFallout.ERB__c = AIResponseData.erb;
                insertFallout.ErrorDescription__c = AIResponseData.errorDescription;
                insertFallout.ErrorType__c = AIResponseData.errorType;
                insertFallout.Fallout__c = true;
                insertFallout.FundingType__c = AIResponseData.fundingType;
                insertFallout.OrgArrangementId__c = AIResponseData.OrgArrangementId;
                insertFallout.OrgId__c = AIResponseData.OrgId;
                insertFallout.OrgType__c = AIResponseData.OrgType;
                insertFallout.CFO__c = AIResponseData.CFO;
                
                insertFallout.MarketSegment__c = AIResponseData.MarketSegment;
                

               /* if(AIResponseData.rxplanBlock!=null){
                    insertFallout.rxPlanBlock__c = string.valueof(AIResponseData.rxplanBlock);
                }*/
                
                string tempRxplanblock ='';
                if(AIResponseData.rxPlanBlock!=null){
                  if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                        tempRxplanblock = tempRxplanblock+' rxPlanBlock:{ ';
                        tempRxplanblock = tempRxplanblock+ dataProcess.getRxPlanItems(AIResponseData.rxPlanBlock.RxPlanDetail);
                        tempRxplanblock = tempRxplanblock+' } ';                    
                   }
                  insertFallout.rxPlanBlock__c = tempRxplanblock;                                                   
               }
               
                //insertFallout.tieredRxPlanBlock__c = string.valueof(AIResponseData.tieredRxplanBlock);
                string tempTieredRxPlanBlock ='';
               if(AIResponseData.tieredRxPlanBlock!=null){                
                  if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+' TieredRxPlanBlock:{ ';
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+ dataProcess.getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                        tempTieredRxPlanBlock = tempTieredRxPlanBlock+' } ';                    
                   }
                    insertFallout.tieredRxPlanBlock__c=tempTieredRxPlanBlock;
               }
                
                
                //insertFallout.traditionalControlNumberPlanSummaryDetai__c = string.valueof(AIResponseData.traditionalControlNumberPlanSummaryDetails);
                string temptraditionalControlNumberPlanSummaryDetails ='';
               if(AIResponseData.traditionalControlNumberPlanSummaryDetails!=null){
                temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+ ' traditionalControlNumberPlanSummary:{ ';
                for(BCTNotificationService.traditionalControlNumberPlanSummary summary:AIResponseData.traditionalControlNumberPlanSummaryDetails){
                    temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+'{controlNumber: '+summary.controlNumber;
                    temptraditionalControlNumberPlanSummaryDetails=temptraditionalControlNumberPlanSummaryDetails+'planSummary: '+summary.planSummary+' } ';
                }
                temptraditionalControlNumberPlanSummaryDetails = temptraditionalControlNumberPlanSummaryDetails+' } ';
                insertFallout.traditionalControlNumberPlanSummaryDetai__c = temptraditionalControlNumberPlanSummaryDetails;
               
               }
                
                
                //insertFallout.traditionalHierarchy__c = string.valueof(AIResponseData.traditionalHierarchy);
                 String description;
                 String FCGResponse;
                if(AIResponseData.traditionalHierarchy!=null){
                        description=description+ ' traditionalHierarchy:{ ';
                        description=description+'control: '+AIResponseData.traditionalHierarchy.control;
                        description=description+',suffix: '+AIResponseData.traditionalHierarchy.suffix;
                        description=description+',account: '+AIResponseData.traditionalHierarchy.account;
                        description=description+',planSummary: '+AIResponseData.traditionalHierarchy.planSummary;                           
                    description = description+' } ';
                    insertFallout.traditionalHierarchy__c = description ;
                    if(AIResponseData.traditionalHierarchy!=null){
                        insertFallout.Trad_AccountId__c = string.valueOf(AIResponseData.traditionalHierarchy.account);
                    }
                   // Field FCGResponse added 

                   //system.debug(AIResponseData.traditionalHierarchy.control+AIResponseData.traditionalHierarchy.suffix+AIResponseData.traditionalHierarchy.account+AIResponseData.traditionalHierarchy.planSummary);                                                                            
                    FCGResponse=String.valueof(AIResponseData.traditionalHierarchy.control)+String.valueof(AIResponseData.traditionalHierarchy.suffix)+String.valueof(AIResponseData.traditionalHierarchy.account)+String.valueof(AIResponseData.traditionalHierarchy.planSummary);
                    insertFallout.FCGResponse__c = FCGResponse ;
               } 
                
                
                insertFallout.PlanId__c = AIResponseData.planId;
                insertFallout.pricingSchedule__c = AIResponseData.pricingSchedule;
                insertFallout.PSUID__c = AIResponseData.PSUID;
                insertFallout.RequestType__c = AIResponseData.requestType;
                insertFallout.riskIndicator__c = AIResponseData.riskIndicator;


                insertFallout.Subsegment__c = AIResponseData.subSegment;

                if(AIResponseData.termDate != null && AIResponseData.termDate != '' ){
                    insertFallout.TermDate__c = AIResponseData.termDate.split('T', 0)[0];
                }

                insertFallout.Traditional__c = true;
                insertFallout.TypeOfPlan__c = AIResponseData.TypeofPlan;
                if(AIResponseData.rxplanBlock != null && AIResponseData.rxplanBlock.RxplanDetail != null 
                            && AIResponseData.rxplanBlock.RxplanDetail.size() > 0 && AIResponseData.rxplanBlock.RxplanDetail[0].RxplanId != null){
                    insertFallout.Rxplanid__c = AIResponseData.rxplanBlock.RxplanDetail[0].RxplanId;
                     system.debug('objfallout.Rxplanid__c'+insertFallout.Rxplanid__c);
                }
                if(AIResponseData.traditionalHierarchy != null){
                    insertFallout.ControlPlan__c = AIResponseData.traditionalHierarchy.control + AIResponseData.traditionalHierarchy.planSummary;
                    if(AIResponseData.effectiveDate != null && AIResponseData.effectiveDate != '')
                        insertFallout.ControlPlanEffective__c = insertFallout.ControlPlan__c + AIResponseData.effectiveDate.split('T', 0)[0];
                    else
                        insertFallout.ControlPlanEffective__c = insertFallout.ControlPlan__c ;
                    if(AIResponseData.traditionalHierarchy.suffix != null){
                        insertFallout.suffix__c = string.valueOf(AIResponseData.traditionalHierarchy.suffix);
                    }   
                    if(AIResponseData.traditionalHierarchy.control != null){
                        insertFallout.control__c = string.valueOf(AIResponseData.traditionalHierarchy.control);
                    }   
                    
                    if(AIResponseData.traditionalHierarchy.planSummary != null){
                        insertFallout.Plan_Summary__c = string.valueOf(AIResponseData.traditionalHierarchy.planSummary);
                    }
                    
                }

                insertFallout.Package__c = packageType; 
                insertfallout.accountname__c = AIResponseData.accountname; 
                           
                insert insertFallout;
                log.NotificationFallout__c =insertFallout.id; 
            }
            //Commented - as case has already been created
            /*
            else{
                // if the requestdata is not Traditional check if it is HMO. In  case it is HMO then create a case 
                if(AIResponseData.TypeofPlan == 'HMOCustom' || AIResponseData.TypeofPlan == 'HMOStandard'){
                //Create a case for HMO  after the case module is complete
                 BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
                  dataProcessor.createCaseForData(AIResponseData,dataProcessor.CreateDescriptionString(AIResponseData),'','','',AIResponseData.errorDescription);

                system.debug('case creation');

                }
                else{
                // Create a invlaid case

                BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
                 dataProcessor.createCaseForData(AIResponseData,dataProcessor.CreateDescriptionString(AIResponseData),'','','','Invalid case');

                system.debug('Invalid case');

                }


            }
            */
       // }
        //catch(exception ex){
         //   IntegrationLogger logger=new IntegrationLogger(); 
          //  logger.logme(false,'Exception In call','There is an exception thrown on the request',system.now(),Userinfo.getName(),'BCTnotification','Exception details'+ex,'Exception is:'+ex);


        //}     
    }
}