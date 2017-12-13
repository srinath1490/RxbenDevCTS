/*Purpose:  Class for AI->SFDC integration   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Abhay              28-06-2012:10.26AM     Class for AI->SFDC integration 
======================================================================== */
 
public class Integration_customHMOHandler{
//VARIABLE DECLARATION=
    IntegrationLogger logger=new IntegrationLogger();
    BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
    String RxPlanIDString;
    public CRD__c sourceCRD;
    List<CRD__c> CRDlist=new List<CRD__c>();
    public Boolean flag;
    public String description;
    private String caseDescription;
    Map<String,String> args=new Map<String,String>();
  
     
   public void Custom_HMO_reply(BCTNotificationService.ReturnData AIResponseData,Integration_log__c log){
    CRDlist=[SELECT Id,OwnerId,Name,Custom_Ben_ID__c,RxPlanID__c,TP_ID__c,Rx_PP_ID__c,RxPlan_ID_Status__c,Account__c,National__c,Sub_segment__c,Tiering__c,Y_Schd__c,Pricing_Schedule__c,Risk_Indicator__c,Account_State__c,Insured_Type__c,Effective_Start_Date__c,Platform_Information__c FROM CRD__c WHERE Id=:AIResponseData.crdId];
    if(CRDlist.size()>0)
    sourceCRD=CRDlist[0];
    system.debug('################AIResponseData1###################'+AIResponseData);
   if(sourceCRD==NULL){
   system.debug('################sourceCRD1###################'+sourceCRD);
     flag=true;
     dataProcessor.createCaseForData(AIResponseData,'No CRD exists for the supplied DCN:'+dataProcessor.CreateDescriptionString(AIResponseData),'','','','DCN error',log);
     Id loggerId= logger.logmecall(true,'Error in DCN for a Reply','An invalid DCN was supplied,look at arguments for Type. Identify case by TimeStamp. No records were updated',system.now(),Userinfo.getName(), 'Reply:InvalidDCN',dataProcessor.CreateDescriptionString(AIResponseData),'created a case',log);
     
    }
   else{ //Begin: reply with Valid DCN
               //Updating sourceCRD's Status__c to "RxPlan Returned, Waiting to send to CVS"
               try{
                   sourceCRD.Status__c='RxPlan Returned, Waiting to send to CVS';
                   if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){
                    String states=AIResponseData.listOfStatesToRemoveFromPlan.replaceAll(',',';');
                    sourceCRD.List_Of_states_to_remove_the_plan__c=states;  
                   }
                   update sourceCRD;
                   system.debug('################sourceCRD2###################'+sourceCRD);
               }catch(Exception e){
                id loggerId = logger.logmecall(true,'Exception','Exception was caught when trying to update CRD.Status__c, look under arguments for details. Record was not updated'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id,log);
           }
           //Moving on to processing the request...
           system.debug('################AIResponseData before if###################'+AIResponseData);
           //Is it reply with Error condition indicating either we sent wrong data or they have issues with source systems.
           if(AIResponseData.errorDescription!=NULL&&AIResponseData.errorDescription!=''){
             flag=true; //Error flag set true
            system.debug('################AIResponseData2a###################'+AIResponseData);
             String argument=dataProcessor.CreateDescriptionString(AIResponseData);
             system.debug('################AIResponseData2b###################'+AIResponseData);
             description='Error returned from AI for'+String.valueOf(sourceCRD.get('Name')); 
             id loggerId =logger.logmecall(AIResponseData,true,'Error for reply','AI replied with an error for a CRD submission. Record not updated',system.now(),Userinfo.getName(),'Reply',argument,'created a task',sourceCRD.Id,log);
             dataProcessor.createTaskForData(AIResponseData, sourceCrd, AIResponseData.errorDescription, Description,loggerId );
            
           }
           
           else // Begin:A valid reply without any errors. Processing...
           {
           system.debug('################AIResponseData inside else###################'+AIResponseData);
                  //Verifying if the required fields for customHMO.reply are not NULL or''. Field values are compared to values sent by AI.
                  if(AIResponseData.rxPlanBlock!=null){
                   system.debug('################AIResponseData inside if 1###################'+AIResponseData);
                           if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail[0].status!=NULL && AIResponseData.benefitsString!=NULL && AIResponseData.benefitsString!='' && AIResponseData.rxPlanBlock.RxPlanDetail[0].RxPlanID!=NULL){
                            system.debug('################AIResponseData inside if 2###################'+AIResponseData +'AND'+sourceCrd);
                            if(AIResponseData.benefitsString.contains(sourceCRD.Custom_Ben_ID__c) && dataProcessor.compareMultiSelectPicklist(sourceCrd,AIResponseData.benefitsStateList) && dataProcessor.checkBenefitStateList(sourceCrd,AIResponseData.benefitsApplyToAllStates)){
                                if(AIResponseData.rxPlanBlock.RxPlanDetail[0].status=='N'||AIResponseData.rxPlanBlock.RxPlanDetail[0].status=='E'){// comparing values on CRD vs sent by AI
                                      system.debug('################AIResponseData before data###################'+AIResponseData);
                                      dataProcessor.Rxreply(AIResponseData,AIResponseData.crdId, AIResponseData.rxPlanBlock.RxPlanDetail[0].RxPlanID, NULL, sourceCRD,log);
                                                                    
                                        system.debug('################AIResponseData3###################'+AIResponseData);
                                     Id loggerId = logger.logmecall(AIResponseData,false,'customHMO reply','Got a New+TN reply for Custom Ben Id we sent, upated record and created task: '+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'customHMO',dataProcessor.CreateDescriptionString(AIResponseData),'updated record and create a task',sourceCRD.Id,log);
                                }
                                else{//Invalid status neither new nor existing- Creating Task and logs
                                 
                                     string argument=dataProcessor.CreateDescriptionString(AIResponseData);//'DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID[0]+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nCustom BenID:'+Arg_InfoMessage[0]+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                                     //handle.errorHandler('Error in Arguments','Value passed for CRD__c.Status__c from AI was invalid'+'\n\n'+argument,sourceCRD);
                                     system.debug('################AIResponseData4###################'+AIResponseData);
                                     id loggerId =logger.logmecall(AIResponseData,true,'customHMO reply:Error','Got a Invalid status reply for custom HMO we sent. Record was not updated.'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'customHMO',dataProcessor.CreateDescriptionString(AIResponseData),'created a task',sourceCRD.Id,log);
                                      dataProcessor.createTaskForData(AIResponseData, sourceCrd, 'Error in Arguments', 'Value passed for CRD__c.Status__c from AI was invalid'+'\n\n'+argument,loggerId);

                               }
                            }
                            else{// values mismatch. Creating Task and logs
                                 flag=true;
                                 string argument=dataProcessor.CreateDescriptionString(AIResponseData);//'DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID[0]+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nCustom BenID:'+Arg_InfoMessage[0]+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                                 Description='customHMO accompanying arguments from AI did not match values on CRD record'+String.valueOf(sourceCRD.get('Name'));
                                id loggerId = logger.logmecall(AIResponseData,true,'customHMO reply:Error','Values mismatch , arguments sent by AI did not match with values on CRD. Record was not updated'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'customHMO',dataProcessor.CreateDescriptionString(AIResponseData),'created a task',sourceCRD.Id,log);
                                dataProcessor.createTaskForData(AIResponseData, sourceCrd, 'Error in Arguments', Description,loggerId );
                                system.debug('################AIResponseData5###################'+AIResponseData);
                             }
                          }
                          else{ // Required fields for customHMO.reply are either empty or were absent. Creating Task and log
                             flag=true;
                             string argument=dataProcessor.CreateDescriptionString(AIResponseData);//'DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID[0]+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nCustom BenID:'+Arg_InfoMessage[0]+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                             Description='some of customHMO accompanying arguments from AI were empty for'+String.valueOf(sourceCRD.get('Name'));
                            id loggerId= logger.logmecall(AIResponseData,true,'customHMO reply:Error','Got a Erroneous reply for custom HMO we sent, arguments required for custom HMO reply were absent. Record was not updated'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'customHMO',dataProcessor.CreateDescriptionString(AIResponseData),'created a task',sourceCRD.Id,log);
                            dataProcessor.createTaskForData(AIResponseData, sourceCrd, 'Error in Arguments', Description,loggerId);
                            system.debug('################AIResponseData6###################'+AIResponseData);
                          } 
                  }

           }//End: valid reply
    }//End:reply with a valid DCN
     
    
  }
//~~End:Custom_HMO_reply~~

}//End:class