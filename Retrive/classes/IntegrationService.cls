/*
Project: Aetna.8380
Team Lead: Josh Turnof; joshua.turnof@accenture.com
Developer: Saraag Reddy: rsaraag@gmail.com
Package: None
Dependencies: 8269c.Aetna Integrator; Lead by: Mike Bougie; bougiem@aetna.com
Requires: CRD__c, Task, Case,IntegrationLog__c, IntegrationDispatcher.cls,AIreplyHandler.cls,IntegrationLogger.cls
Description: Class is called by AI. No validations are done here, class simply accepts the data and calls IntegrationDispatcher.
DO NOT MODIFY OR DELETE CLASS WITHOUT EXPLICIT PERMISSION FROM ADMINISTRATOR/ARCHITECT
*/
Global class IntegrationService{
 
     Global class ReturnData{
      Webservice String DCN;
      WebService String RxPlanID;
      WebService String TPID;
      WebService String OwnerPPID;
      WebService String Status;
      WebService String Carrier;
      WebService String Platform;
      WebService String Account;
      WebService String Segment;
      WebService String SubSegment;
      WebService String Tiering;
      WebService String Pricing;
      WebService String RiskIndicator;
      WebService String State;
      WebService String FundingType;
      WebService String ERB;
      WebService String EffectiveStartDate;
      WebService String TermDates;
      WebService String GroupInfo;
      WebService String G_Company;
      WebService String G_Group;
      WebService String G_Location;
      WebService String G_Plan;
      WebService String G_Control;
      WebService String G_Suffix;
      WebService String G_Account;
      WebService String G_PlanSummary;
      WebService String InfoMessage;
      WebService String RxPlanIDAdd;
      WebService String TieringAdd;
      WebService String StatusAdd;
      WebService String ErrorCondition;
      
      /*Private ReturnData(){
       }*/
       
       Public ReturnData(String Arg_dcn,String Arg_RxPlanID,String Arg_TPID,String Arg_OwnerPPID,String Arg_Status,String Arg_Carrier,String Arg_Platform,String Arg_Account,String Arg_Segment,String Arg_SubSegment,String Arg_Tiering,String Arg_Pricing,String Arg_RiskIndicator,String Arg_State,String Arg_FundingType,String Arg_ERB,String Arg_EffectiveStartDate,String Arg_TermDates,String Arg_GroupInfo,String Arg_G_Company,String Arg_G_Group,String Arg_G_Location,String Arg_G_Plan,String Arg_G_Control,String Arg_G_Suffix,String Arg_G_Account,String Arg_G_PlanSummary,String Arg_InfoMessage,String Arg_RxPlanIDAdd,String Arg_TieringAdd,String Arg_StatusAdd,String Arg_ErrorCondition){
          this.DCN=Arg_DCN;
          this.RxPlanID=Arg_RxPlanID;
          this.TPID=Arg_TPID;
          this.OwnerPPID=Arg_OwnerPPID;
          this.Status=Arg_Status;
          this.Carrier=Arg_Carrier;
          this.Platform=Arg_Platform;
          this.Account=Arg_Account;
          this.Segment=Arg_Segment;
          this.SubSegment=Arg_SubSegment;
          this.Tiering=Arg_Tiering;
          this.Pricing=Arg_Pricing;
          this.RiskIndicator=Arg_RiskIndicator;
          this.State=Arg_State;
          this.FundingType=Arg_FundingType;
          this.ERB=Arg_ERB;
          this.EffectiveStartDate=Arg_EffectiveStartDate;
          this.TermDates=Arg_TermDates;
          this.GroupInfo=Arg_GroupInfo;
          this.G_Company=Arg_G_Company;
          this.G_Group=Arg_G_Group;
          this.G_Location=Arg_G_Location;
          this.G_Plan=Arg_G_Plan;
          this.G_Control=Arg_G_Control;
          this.G_Suffix=Arg_G_Suffix;
          this.G_Account=Arg_G_Account;
          this.G_PlanSummary=Arg_G_PlanSummary;
          this.InfoMessage=Arg_InfoMessage;
          this.RxPlanIDAdd=Arg_RxPlanIDAdd;
          this.TieringAdd=Arg_TieringAdd;
          this.StatusAdd=Arg_StatusAdd;
          this.ErrorCondition=Arg_ErrorCondition;
         }
       }
       WebService Static Boolean AetnaNotification(ReturnData messageData){
          if(messageData!=NULL){
           DataExtractor(messageData);
           return true;
           }
           else
            return false;
        }
       Public Static void DataExtractor(IntegrationService.ReturnData payload){
          if(payload!=NULL){
           system.debug(payload);
              IntegrationDispatcher handle=new IntegrationDispatcher();
              
              if(payload.Status=='Not New')
                payload.Status='Existing';
              if(payload.StatusAdd=='Not New')
                payload.StatusAdd='Existing';                
              if(payload.RiskIndicator=='N')
                payload.RiskIndicator='NR';
                
              handle.Run(payload.DCN,payload.RxPlanID,payload.TPID,payload.OwnerPPID,payload.Status,payload.Carrier,payload.Platform,payload.Account,payload.Segment,payload.SubSegment,payload.Tiering,payload.Pricing,payload.RiskIndicator,payload.state,payload.FundingType,payload.ERB,payload.EffectiveStartDate,payload.TermDates,payload.GroupInfo,payload.G_Company,payload.G_Group,payload.G_Location,payload.G_Plan,payload.G_Control,payload.G_Suffix,payload.G_Account,payload.G_PlanSummary,payload.InfoMessage,payload.RxPlanIDAdd,payload.TieringAdd,payload.statusAdd,payload.ErrorCondition);
                         
           }
        }
 }