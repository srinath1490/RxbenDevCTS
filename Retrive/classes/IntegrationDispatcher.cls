/*
Project: Aetna.8380
Team Lead: Josh Turnof; joshua.turnof@accenture.com
Developer: Saraag Reddy: rsaraag@gmail.com
Package: None
Dependencies: 8269c.Aetna Integrator; Lead by: Mike Bougie; bougiem@aetna.com
Requires: CRD__c, Task, Case,IntegrationLog__c, AIreplyHandler.cls,IntegrationLogger.cls
Description: Class is called by integrationService. All the arguments are simply passed from IntegrationService, this class decides if the data is valid/ where should it go etc. Class also handles BCTnotification.
*/

Public class IntegrationDispatcher{
public CRD__c sourceCRD;
List<CRD__c> CRDlist=new List<CRD__c>();
public Boolean flag;
public String description;
private String caseDescription;
IntegrationLogger logger=new IntegrationLogger();//might cause error
   Public void Run(String Arg_dcn,String Arg_RxPlanID,String Arg_TPID,String Arg_OwnerPPID,String Arg_Status,String Arg_Carrier,String Arg_Platform,String Arg_Account,String Arg_Segment,String Arg_SubSegment,String Arg_Tiering,String Arg_Pricing,String Arg_RiskIndicator,String Arg_State,String Arg_FundingType,String Arg_ERB,String Arg_EffectiveStartDate,String Arg_TermDates,String Arg_GroupInfo,String Arg_G_Company,String Arg_G_Group,String Arg_G_Location,String Arg_G_Plan,String Arg_G_Control,String Arg_G_Suffix,String Arg_G_Account,String Arg_G_PlanSummary,String Arg_InfoMessage,String Arg_RxPlanIDAdd,String Arg_TieringAdd,String Arg_StatusAdd,String Arg_ErrorCondition){
      //Variable Declaration
      AIreplyHandler handle=new AIreplyHandler();
      Map<String,String> args=new Map<String,String>();
           
      if(Arg_dcn==NULL||Arg_dcn==''){ //Logg it, nothing else to do. Error may be due to bug in AI.
 //~~~~~~this is a BCT notification~~~~~~~~~~
       system.debug('Inside BCTnotification');
       if(Arg_ErrorCondition!=NULL&&Arg_ErrorCondition!=''){
       //a BCT notification is used as ErrorNotification. Not intended use.
          system.debug('Inside BCTnotification. ErrorCondition filled');
          flag=true;
          description='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
          handle.errorHandler(Arg_errorcondition,description);
         // IntegrationLogger logger=new IntegrationLogger();
          logger.logme(true,'Error in BCTnotification','Error field was filled in for a BCT notification',system.now(),Userinfo.getName(),'BCTnotification','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a case');
       }
       else //A VALID BCT NOTIFICATION, create case assign to BCTManager Queue
       { 
         // String b=Arg_dcn+Arg_RxPlanID+Arg_TPID+Arg_OwnerPPID+Arg_Status+Arg_Carrier+Arg_Platform+Arg_Account+Arg_Segment+Arg_SubSegment+Arg_Tiering+Arg_Pricing+Arg_RiskIndicator+Arg_State+Arg_FundingType+Arg_ERB+Arg_EffectiveStartDate+Arg_TermDates+Arg_GroupInfo+Arg_G_Company+Arg_G_Group+Arg_G_Location+Arg_G_Plan+Arg_G_Control+Arg_G_Suffix+Arg_G_Account+Arg_G_PlanSummary+Arg_InfoMessage+Arg_RxPlanIDAdd+Arg_TieringAdd+Arg_StatusAdd+Arg_ErrorCondition;
              system.debug('Inside BCTnotification.ValidNotification');
              caseDescription='Following fields were included in the notification from Aetna Integrator:\n\n'+'RxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nOwner PPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub-Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTermination Dates:'+Arg_TermDates+'\nGroup Information:'+Arg_GroupInfo+'\nCompany:'+Arg_G_Company+'\nGroup:'+Arg_G_Group+'\nLocation:'+Arg_G_Location+'\nPlan:'+Arg_G_Plan+'\nControl:'+Arg_G_Control+'\nSuffix:'+Arg_G_Suffix+'\nAccount:'+Arg_G_Account+'\nPlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage;
              Case c=new Case();
              c.Description=caseDescription;
              c.Origin='AI Notification';
              c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Event_Notifications'].id;
              c.Case_Type__c='Benefit Control Implementation Support';
              c.Reason='AI notification';
              c.Subject='Notification from Aetna Integrator';
              //assigning to queue
               List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name='Case - BCT Managers' LIMIT 1];
               QueueSobject crdqueue;
                if(crdqueueList.size()>0)
                 crdqueue=crdqueueList[0]; // If the queue was valid and a record was found.
                if(crdqueue!=NULL){
                  c.OwnerId=crdqueue.QueueId;
                 }
              //end assigning to queue
              
              try{
              insert c;
              logger.logme(false,'Valid BCT notificaiton','A new case was created for the BCT notification',system.now(),Userinfo.getName(),'BCTnotification','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created case-'+c.CaseNumber);
              }catch(Exception e){
                system.debug(e.getMessage());
                logger.logme(true,'Exception','Exception was caught when trying to handle BCTnotification, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition);
              }
              system.debug(c.CaseNumber);
              system.debug(c);
              
         
       }
     }
// ### ~~~~~~REPLY~~~~~~~~~~~~~~###  //
      else{ //Usually we create Task for Existing , Note for New after updating CRD. Except for DCN error- we create case, since we can't assign Task or create note without CRD.
       //this is a reply with RxPlanId
       system.debug('Inside Reply');
       CRDlist=[SELECT Id,OwnerId,Name,RxPlanID__c,TP_ID__c,Rx_PP_ID__c,RxPlan_ID_Status__c,Account__c,National__c,Sub_segment__c,Tiering__c,Y_Schd__c,Pricing_Schedule__c,Risk_Indicator__c,Account_State__c,Insured_Type__c,Effective_Start_Date__c,Platform_Information__c FROM CRD__c WHERE Id=:Arg_DCN];
       if(CRDlist.size()>0)
        sourceCRD=CRDlist[0];
             
       //if(sourceCRD is not null, else raise error)
       if(sourceCRD==NULL){
         flag=true;
         description='No CRD exists for the supplied DCN:'+Arg_DCN+'\n\nArguments included:\n'+'RxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nOwner PPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub-Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTermination Dates:'+Arg_TermDates+'\nGroup Information:'+Arg_GroupInfo+'\nCompany:'+Arg_G_Company+'\nGroup:'+Arg_G_Group+'\nLocation:'+Arg_G_Location+'\nPlan:'+Arg_G_Plan+'\nControl:'+Arg_G_Control+'\nSuffix:'+Arg_G_Suffix+'\nAccount:'+Arg_G_Account+'\nPlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage;
         handle.ErrorHandler('DCN error',description);
         logger.logme(true,'Error in DCN for a Reply','An invalid DCN was supplied,look at arguments for Type. Identify case by TimeStamp',system.now(),Userinfo.getName(),'Reply:InvalidDCN','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a case');
       }
       else{
       //Updating sourceCRD's Status__c to "RxPlan Returned, Waiting to send to CVS"
       try{
           sourceCRD.Status__c='RxPlan Returned, Waiting to send to CVS';
           update sourceCRD;
       }catch(Exception e){
         system.debug('>>>>>'+e.getMessage());
         logger.logme(true,'Exception','Exception was caught when trying to update CRD.Status__c, look under arguments for details'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id);

       }
       //Moving on to processing the request...
       
       //Is it reply with Error condition indicating either we sent wrong data or they have issues with source systems.
       if(Arg_ErrorCondition!=NULL&&Arg_ErrorCondition!=''){
         system.debug('Inside Reply.ErrorConditionFilled');
         flag=true;
         string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
         description='Error returned from AI for'+String.valueOf(sourceCRD.get('Name')); 
         handle.errorHandler(Arg_errorcondition,description+'\n\n'+argument,sourceCRD);
         logger.logme(true,'Error for reply','AI replied with an error for a CRD submission',system.now(),Userinfo.getName(),'Reply','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a task',sourceCRD.Id);
       }
       else
       {
          system.debug('Inside Reply. Valid Reply');
          
          //check if it is a TPID reply or a PPID reply
          
 //~~~~~TPID PACKAGE~~~~~~
          if(Arg_TPID!=NULL&&Arg_TPID!=''&&(Arg_OwnerPPID==''||Arg_OwnerPPID==NULL)) 
          {
           system.debug('Inside Reply.TPID');
           //verfying TPID accompanying details
           if(Arg_Platform!=NULL&&Arg_Platform!=''&&Arg_Pricing!=NULL&&Arg_Pricing!=''&&Arg_Status!=NULL&&Arg_Status!=''&&Arg_RxPlanID!=NULL&&Arg_RxPlanID!=''&&Arg_Tiering!=''&&Arg_Tiering!=NULL)
           {
              system.debug('Inside Reply.TPID.Valid');
              //verify if they match values with whats already on the corresponding CRD record
              system.debug(String.valueOf(sourceCRD.get('Platform_Information__c'))+String.valueOf(sourceCRD.get('Pricing_Schedule__c'))+String.valueOf(sourceCRD.get('TP_ID__c')));
              system.debug(Arg_Platform==String.valueOf(sourceCRD.get('Platform_Information__c')));
              system.debug(Arg_Platform);
              system.debug(Arg_Pricing==String.valueOf(sourceCRD.get('Pricing_Schedule__c')));
              system.debug(Arg_Pricing);
              system.debug(Arg_TPID==String.valueOf(sourceCRD.get('TP_ID__c')));
              system.debug(Arg_TPID);
              if(Arg_Platform==String.valueOf(sourceCRD.get('Platform_Information__c'))&&Arg_Pricing==String.valueOf(sourceCRD.get('Pricing_Schedule__c'))&&Arg_TPID==String.valueOf(sourceCRD.get('TP_ID__c')))
              {
                   system.debug('Entering TPID reply');
                 //   tiering
                         if(Arg_Tiering=='TN') //Non Tiered TPID plan
                         {
                              system.debug('Inside Reply.TPID.Valid.TN');
                              System.debug('Has no Tiering'+Arg_Tiering);
                              if(Arg_Status=='Existing'){ //Update CRD, create Note
                                    system.debug('Inside Reply.TPID.Valid.TN.Existing');
                                   //change RxplanStatus to Existing
                                    system.debug('Existing TN TPID'+Arg_Status);
 
                                  args.put('RxPlan_ID_Status__c',Arg_Status);
                                  args.put('Tiering__c',Arg_Tiering);
                                  args.put('Risk_Indicator__c',Arg_RiskIndicator);
                                   try{ 
                                   
                                    //Inserting Note: to track updates
                                   Note n=new Note();
                                   n.Title='Updated: Aetna Integrator';
                                   n.Body='TPID was submitted to Aetna Integrator and an Existing status was returned.\n The CRD record was updated for RxPlanID, RxPlanID Status, Risk Indicator and Tiering';
                                   n.ParentId=sourceCRD.Id;
                                   n.isPrivate=false;
                                   n.OwnerId=sourceCRD.OwnerId;
                                   
                                   insert n;
                                   //Also creating a task
                                   handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                                   //end task creation
                                   
                                   logger.logme(false,'TPID reply: Existing','Got a Existing+TN reply for TPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and create a note',sourceCRD.Id);
                                   }catch(Exception e){
                                    system.debug(e.getMessage());
                                    logger.logme(true,'Exception','Exception was caught when trying to handle TPID TN reply.Existing/Create Note, look under arguments for details'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id);
                                  }
                                   
                                   //logger.logme(false,'TPID reply: Existing','Got a Existing+TN reply for TPID we sent, system has updated the record',system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and create a note',sourceCRD.Id);
                                }
                              else if(Arg_Status=='New'){ //Valid TPID ,non-tiered New status; Update CRD,create Task
                              system.debug('Inside Reply.TPID.Valid.TN.New');
                                  system.debug('New TN TPID'+Arg_Status);
                                  args.put('RxPlan_ID_Status__c',Arg_Status);
                                  args.put('Tiering__c',Arg_Tiering);
                                  args.put('Risk_Indicator__c',Arg_RiskIndicator);
                                  handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                                  logger.logme(false,'TPID reply:New','Got a New+TN reply for TPID we sent, upated record and created task: '+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and create a task',sourceCRD.Id);
                              }
                              else{ //Invalid Status
                               flag=true;
                               string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                               handle.errorHandler('Invalid Status','Invalid Status for a TPID based reply:'+Arg_Status+'\n\n'+argument,sourceCRD);
                               logger.logme(true,'TPID reply:Error','Got a Invalid Status+TN reply for TPID we sent, no modifications were done to record:'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
                              }
                          }
                          else if(Arg_StatusAdd!=NULL&&Arg_TieringAdd!=NULL&&Arg_Tiering!=NULL&&Arg_StatusAdd!=''&&Arg_TieringAdd!=''&&Arg_Tiering!=''&&Arg_RxPlanIDAdd!=''&&Arg_RxPlanIDAdd!=NULL) //has both TE and TF
                          {
                            system.debug('Inside Reply.TPID.Valid.Tiered');
                            if(Arg_Status=='Existing'){ //Existing for the first plan; Update CRD,create Note
 
                                  args.put('RxPlan_ID_Status__c',Arg_Status);
                                  args.put('Tiering__c',Arg_Tiering);
                                  args.put('Risk_Indicator__c',Arg_RiskIndicator);
                                   try{
                                   
                                    //Inserting Note: to track updates
                                    Note n=new Note();
                                   n.Title='Updated: Aetna Integrator';
                                   n.Body='TPID was submitted to Aetna Integrator and an Existing status was returned.\n The CRD record was updated for RxPlanID, RxPlanID Status, Risk Indicator and Tiering';
                                   n.ParentId=sourceCRD.Id;
                                   n.isPrivate=false;
                                   n.OwnerId=sourceCRD.OwnerId;
                                   
                                   insert n;
                                   //Also creating a task
                                     handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                                   //end task creation
                                   
                                   logger.logme(false,'TPID reply:Tiering+Existing','Got a Existing+Tiering reply for TPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and created a note',sourceCRD.Id);
                                   }catch(Exception e){
                                    system.debug(e.getMessage());
                                    logger.logme(true,'Exception','Exception was caught when trying to handle TPID tiering.Existing for Arg_Status/Insert Note, look under arguments for details'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id);
                                  }
                                   
                            }
                            else if(Arg_Status=='New'){ //New for the first plan,Update CRD create Task
                                args.put('RxPlan_ID_Status__c',Arg_Status);
                                args.put('Tiering__c',Arg_Tiering);
                                args.put('Risk_Indicator__c',Arg_RiskIndicator);
                                handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                                logger.logme(false,'TPID reply:Tiering+New','Got a New+Tiering reply for TPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and created a task',sourceCRD.Id);
                            }
                            else{
                              flag=true;
                              string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                              logger.logme(true,'TPID reply:Error','Got a Invalid status+Tiering reply for TPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
                              handle.errorHandler('Invalid Status','In a Tierd reply to TPID based request, an invalid status was sent for Tiering'+Arg_Status+'\n\n'+argument,sourceCRD);
                              
                            }
                            //Second plan details
                           if(Arg_StatusAdd=='Existing'||Arg_StatusAdd=='New'){ // Since there is no CRD for this, we create one regardless
                         
                                   args.clear(); //rebuilding map
                                   args.put('RxPlan_ID_Status__c',Arg_StatusAdd);
                                   args.put('Tiering__c',Arg_TieringAdd);
                                   args.put('Risk_Indicator__c',Arg_RiskIndicator);
                                   handle.BCTnotification(Arg_RxPlanIDAdd,args,true,sourceCRD.ownerId); //new CRD has to be created so no, DCN?-yes
                                   logger.logme(false,'TPID reply:Tiering- Additional RxPlanID','For a TPID we sent, we got back Tiered reply. This is the second task for the reply.'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created new CRD and created a task',sourceCRD.Id);
                                }
                           else{ //invalid status for second request
                              flag=true;
                              string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                              handle.errorHandler('Invalid Status','In a tierd reply to TPID based request, an invalid status was sent:'+Arg_StatusAdd+'\n\n'+argument,sourceCRD);
                              logger.logme(true,'TPID reply:Error','Got a Invalid status+Tiering reply for TPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a Task',sourceCRD.Id);
                           }
                         }
                
                      //Did not get TN or TE+TF together. Logging error
                      else{
                      flag=true;
                      string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                      handle.errorHandler('Invalid Tiering','In a tierd reply to TPID based request, system detected only one Tiering-'+Arg_TieringAdd+'but not both:'+Arg_StatusAdd+'\n\n'+argument,sourceCRD);
                      logger.logme(true,'TPID reply:Error','Got a Invalid Tiering reply for TPID we sent :'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a Task',sourceCRD.Id);
                      }
               
              }
              //Values mismatch logging errors. AI module incorrectly assigned DCN to junk data and sent it to me
              else{ 
                flag=true;
                string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                description='For TPID,values returned by Aetna Integrator does not match with values on record for'+String.valueOf(sourceCRD.get('Name'));
                logger.logme(true,'TPID reply:Error',description,system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a Task',sourceCRD.Id);
                handle.errorHandler('Error in Arguments',description+'\n\nArguments:\n'+argument,sourceCRD);
              } 
              
           }
           else //TPID needs more values in its reply. DCN,RxplanID,TPID,Platform,Pricing Schedule
           {
             flag=true;
             string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
             Description='One or more TPID accompanying arguments from AI were empty for'+String.valueOf(sourceCRD.get('Name'));
             logger.logme(true,'TPID reply:Error',Description,system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a task',sourceCRD.Id);
             handle.errorHandler('Error in Arguments',description+'\n\nArguments:\n'+argument,sourceCRD);
           }
          }
  //~~~~~~PPID PACKAGE~~~~~~
          else if(Arg_OwnerPPID!=NULL&&Arg_OwnerPPID!=''&&(Arg_TPID==''||Arg_TPID==NULL))
          {
            system.debug('Inside Reply.PPID');
            //verfying PPID accompanying details
           if(Arg_Platform!=NULL&&Arg_Platform!=''&&Arg_Pricing!=NULL&&Arg_Pricing!=''&&Arg_State!=NULL&&Arg_State!=''&&Arg_Status!=NULL&&Arg_Status!=''&&Arg_RiskIndicator!=NULL&&Arg_RiskIndicator!=''&&Arg_RxPlanID!=''&&Arg_RxPlanID!=NULL)
           {
            system.debug('Inside Reply.PPID.Valid');
              //verify if they match values with whats already on the corresponding CRD record
              if(Arg_Platform==String.valueOf(sourceCRD.get('Platform_Information__c'))&&Arg_Pricing==String.valueOf(sourceCRD.get('Pricing_Schedule__c'))&&Arg_OwnerPPID==String.valueOf(sourceCRD.get('Rx_PP_ID__c'))&&Arg_RiskIndicator==String.valueOf(sourceCRD.get('Risk_Indicator__c')))
              {
                //checking if status=Existing
                if(Arg_Status=='Existing'){ //Update CRD,create Note
                  system.debug(LoggingLevel.Finer,'PPID.Existing');
                       //args.clear();
                       //args.put('RxPlan_ID_Status__c',Arg_status);
                      // handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                    args.clear();
                    
                    args.put('RxPlan_ID_Status__c',Arg_status);
                  system.debug(sourceCRD.Name);
                  system.debug(sourceCRD.RxPlan_ID_Status__c);
                  try{
                 
                  system.debug(sourceCRD.RxPlan_ID_Status__c);
                  //Inserting Note: to track updates
                   Note n=new Note();
                   n.Title='Updated: Aetna Integrator';
                   n.Body='PPID was submitted to Aetna Integrator and an Existing status was returned.\n The CRD record was updated for RxPlanID, RxPlanID Status.';
                   n.ParentId=sourceCRD.Id;
                   n.isPrivate=false;
                   n.OwnerId=sourceCRD.OwnerId;
                
                   insert n;
                   //Also creating a task
                    handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                  //end task creation
                   logger.logme(false,'PPID reply:Existing','Got a Existing reply for PPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'PPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and created a note',sourceCRD.Id);
                   }catch(Exception e){
                    system.debug(e.getMessage());
                    logger.logme(true,'Exception','Exception was caught when trying to handle PPIDexisting.Note insert, look under arguments for details'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id);
                  }
                   
                  
                }
                else if(Arg_Status=='New'){ //New status for PPID;Update CRD and create Task
                    system.debug(LoggingLevel.Finer,'PPID.New');
                    args.clear();
                    
                    args.put('RxPlan_ID_Status__c',Arg_status);
                    handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                    logger.logme(false,'PPID reply:New','Got a New reply for PPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'PPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'updated record and created a task',sourceCRD.Id);
                }
                else{ //invalid Arg_Status
                    string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                  handle.errorHandler('Error in Arguments','Value passed for CRD__c.Status__c from AI was invalid'+'\n\n'+argument,sourceCRD);
                  logger.logme(true,'PPID reply:Error','Got a Invalid status reply for PPID we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'PPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a task',sourceCRD.Id);
                }
              }
              else{ //Values mismatch.
                flag=true;
                string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                description='For PPID, values returned by Aetna Integrator does not match with values on record for'+String.valueOf(sourceCRD.get('Name'));
                logger.logme(true,'PPID reply:Error',description,system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
                handle.errorHandler('Error in Arguments',description+'\n\n'+argument,sourceCRD);
              }    
           }
           else // A PPID needs more input from AI:PPID,DCN,RxplanID,RiskIndicator,Platform,PricingSchedule
           {
             flag=true;
             string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
             Description='PPID accompanying arguments from AI were empty for'+String.valueOf(sourceCRD.get('Name'));
             handle.errorHandler('Error in Arguments',description+'\n\n'+argument,sourceCRD);
             logger.logme(true,'PPID reply:Error','Got a Erroneous reply for PPID we sent, arguments required for PPID reply were absent'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'PPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'created a task',sourceCRD.Id);
           }
            
          }
//~~~~~~~NON_PACKAGE PLAN~~~~~~~ 
          else {
           
             if(Arg_Platform!=NULL&&Arg_Platform!=''&&Arg_RxPlanID!=''&&Arg_RxPlanID!=NULL&&Arg_Status!=NULL&&Arg_Status!=''&&Arg_Pricing!=NULL&&Arg_Pricing!=''){//Do we have all fields?
             
                if(Arg_Platform==String.valueOf(sourceCRD.get('Platform_Information__c'))&&Arg_Pricing==String.valueOf(sourceCRD.get('Pricing_Schedule__c')))
                {   
                   if(Arg_Status=='Existing'){ //Non-package and existing. We update CRD and insert Note
                     system.debug(LoggingLevel.Finer,'Non-Package.Existing');
                       //args.clear();
                       //args.put('RxPlan_ID_Status__c',Arg_status);
                      // handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                    args.clear();
                    
                    args.put('RxPlan_ID_Status__c',Arg_status);
                  system.debug(sourceCRD.Name);
                  system.debug(sourceCRD.RxPlan_ID_Status__c);
                  try{
                             
                  
                  system.debug(sourceCRD.RxPlan_ID_Status__c);
                   //Inserting Note: to track updates
                   Note n=new Note();
                   n.Title='Updated: Aetna Integrator';
                   n.Body='Non-package plan was submitted to Aetna Integrator and an Existing status was returned.\n The CRD record was updated for RxPlanID, RxPlanID Status';
                   n.ParentId=sourceCRD.Id;
                   n.isPrivate=false;
                   n.OwnerId=sourceCRD.OwnerId;
                   
                   insert n;
                   //Also creating a task
                    handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                  //end task creation

                   logger.logme(false,'Non-Package Reply:Existing','Got a Non-package+Existing reply for Non-package we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Non-Package','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Updated record and created a note',sourceCRD.Id);
                   }catch(Exception e){
                    system.debug(e.getMessage());
                    logger.logme(true,'Exception','Exception was caught when trying to handle Non-package existing.Note insert, look under arguments for details'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Warning',e.getMessage(),'',sourceCRD.Id);
                  }
                   
                  
                }
                //Non-package.New
                else if(Arg_Status=='New'){ //Update CRD and create Task
                    system.debug(LoggingLevel.Finer,'Non-Package.New');
                    args.clear();
                    
                    args.put('RxPlan_ID_Status__c',Arg_status);
                    handle.Rxreply(Arg_dcn,Arg_RxPlanID,args,sourceCRD);
                    logger.logme(false,'Non-Package:New','Got a Non-package+New reply for Non-package we sent, system has updated the record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Non-Package','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Updated record and created a task',sourceCRD.Id);
                    
                }
                else{ //invalid Arg_Status
                    string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                  handle.errorHandler('Error in Arguments','In non-packgae reply,value passed for CRD__c.Status__c from AI was invalid'+'\n\n'+argument,sourceCRD);
                  logger.logme(true,'Non-Package:Error','Got a Non-package+ Invalid status reply for Non-package we sent'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Non-Package','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
                }
                     
                }
                else{
                  //raise error: values on message do not match up against values on CRD record.
                  flag=true;
                  string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                  logger.logme(true,'NonPackage reply:Error','Arguments provided for Non-packgae reply by AI did not match up against values already on CRD record'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'TPID','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
                  handle.errorHandler('Error in Arguments','Arguments provided for Non-packgae reply by AI did not match up against values already on CRD record'+'\n\n'+argument,sourceCRD);
                }
             
             }
             else{
               //raise error: values expected for a non-package plan are absent.
               string argument='DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition;
                handle.errorHandler('Error in Arguments','In the reply sent by AI, system detected values expected for a non-package plan are absent.'+'\n\n'+argument,sourceCRD);
                logger.logme(true,'Non-Package:Error','Got a reply for Non-Package with one or more required fields absent.'+String.valueOf(sourceCRD.get('Name')),system.now(),Userinfo.getName(),'Non-Package','DCN:'+Arg_dcn+'\nRxPlanID:'+Arg_RxPlanID+'\nTPID:'+Arg_TPID+'\nPPID:'+Arg_OwnerPPID+'\nStatus:'+Arg_Status+'\nCarrier:'+Arg_Carrier+'\nPlatform:'+Arg_Platform+'\nAccount:'+Arg_Account+'\nSegment:'+Arg_Segment+'\nSub Segment:'+Arg_SubSegment+'\nTiering:'+Arg_Tiering+'\nPricing:'+Arg_Pricing+'\nRisk Indicator:'+Arg_RiskIndicator+'\nState:'+Arg_State+'\nFunding Type:'+Arg_FundingType+'\nERB:'+Arg_ERB+'\nEffective Start Date:'+Arg_EffectiveStartDate+'\nTerm Date:'+Arg_TermDates+'\nGroup Info:'+Arg_GroupInfo+'\nG_Company:'+Arg_G_Company+'\nG_Group:'+Arg_G_Group+'\nG_Location:'+Arg_G_Location+'\nG_Plan:'+Arg_G_Plan+'\nG_Control:'+Arg_G_Control+'\nG_Suffix:'+Arg_G_Suffix+'\nG_Account:'+Arg_G_Account+'\nG_PlanSummary:'+Arg_G_PlanSummary+'\nInfo Message:'+Arg_InfoMessage+'\nRxPlanIDAdd:'+Arg_RxPlanIDAdd+'\nTiering Add:'+Arg_TieringAdd+'\nStatus Add:'+Arg_StatusAdd+'\nError Condition:'+Arg_ErrorCondition,'Created a task',sourceCRD.Id);
             }      
       
            
          }  
          
       }
      }
     } //end reply
    } //end run method
} //end class