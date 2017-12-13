/*
    Class for AI->Case Module Implementation.
    Last Modified by:ankur Aggarwal 23-10-2013       
    This Class is used to create casees for Package and Non Package Plans
   
*/

public without sharing class CreateCase {
    
    Id eventrec;
    Id internrec;
    Id bctmangerQ;
    Id bctunassingQ;
    Id ASMAccountId;
     //BCTNotificationProcessor dataProcessor=new BCTNotificationProcessor();
     //IntegrationLogger logger=new IntegrationLogger();  
     
    // Default Constructor
    public CreateCase(){
        eventrec=Id.valueOf(System.Label.EventNotifRec);
        internrec=Id.valueOf(System.Label.InternalCaseRec);
        bctmangerQ=Id.valueOf(System.Label.BCTManagersQueue);
        bctunassingQ=Id.valueOf(System.Label.BCTunassignedQ);
        ASMAccountId=Id.valueOf(System.Label.CaseAuto_ASMAccountId);
    }
    
    //Method will be used for creation of case if we dont have crdid
    /*public void createCaseForData(BCTNotificationService.ReturnData AIResponseData,String caseDescription,String caseReason,String caseType,String caseOrigin,string caseSubject,String caseStatus){
                
            //we log a case with the details we recieved from AI since was not error detail we will create case accordingly
     String traditionalHierarchy;
     String HmoHirerachy;
     String rxPlanBlockDescription;
     String errRxPlanBlockDescription;
     String tieredRxPlanBlockDescription;
     String errtieredRxPlanBlockDescription;
     Case c=new Case();
     c.Description=caseDescription;//'Following fields were included in the notification from Aetna Integrator:\n\n'+caseDescription;
     c.Origin=caseOrigin;//'Other';
     c.Case_Type__c=caseType;//'Benefit Control Implementation Support';
     c.Reason=caseReason;//'AI notification';
     c.Subject=caseSubject;//'Notification from Aetna Integrator';
     c.Status = caseStatus;
                 //Adding New Fields
     c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Event_Notifications'].id;
    if(AIResponseData.notificationCount!=null){     
        c.Notification_Count__c = AIResponseData.notificationCount;
     }
     if(AIResponseData.benefitsApplyToAllStates!=null){     
        c.benefitsApplyToAllStates__c = AIResponseData.benefitsApplyToAllStates;
     }
     
     if(AIResponseData.benefitsStateList!=null && AIResponseData.benefitsStateList!=''){
        c.benefitsStateList__c = AIResponseData.benefitsStateList;
     }
     
     if(AIResponseData.benefitsString!=null && AIResponseData.benefitsString!=''){
        c.benefitsString__c = AIResponseData.benefitsString;
     }
     
     if(AIResponseData.benefitsStringExtension!=null && AIResponseData.benefitsStringExtension!=''){     
        c.benefitsStringExtension__c = AIResponseData.benefitsStringExtension;    
     }
     
     c.controlPlanSummary__c ='';
     
     
     if(AIResponseData.effectiveDate!=null && AIResponseData.effectiveDate!=''){
        c.effectiveDate__c =Date.valueOf(AIResponseData.effectiveDate);
     }
     
     if(AIResponseData.erb!=null && AIResponseData.erb!=''){
        c.erb__c = AIResponseData.erb;
     }
     
     if(AIResponseData.errorDescription!=null && AIResponseData.errorDescription!=''){
        c.errorDescripton__c = AIResponseData.errorDescription;
     }
     
     if(AIResponseData.errorType!=null && AIResponseData.errorType!=''){
        c.errorType__c = AIResponseData.errorType;
     }
     if(AIResponseData.fundingType!=null && AIResponseData.fundingType!=''){
        c.fundingType__c = AIResponseData.fundingType;
     }
    
     if(AIResponseData.hmoHierarchy!=null){
        
      HmoHirerachy=' hmoHierarchy:{ ';
      HmoHirerachy=HmoHirerachy+'Company: '+AIResponseData.hmoHierarchy.company;
      HmoHirerachy=HmoHirerachy+',groups: '+AIResponseData.hmoHierarchy.groups;
      HmoHirerachy=HmoHirerachy+',location: '+AIResponseData.hmoHierarchy.location;
      HmoHirerachy=HmoHirerachy+',plan: '+AIResponseData.hmoHierarchy.plan;       
      HmoHirerachy = HmoHirerachy+' } ';
    }       
     c.hmoHierarchy__c = HmoHirerachy;
     if(AIResponseData.listOfStatesToRemoveFromPlan!=null && AIResponseData.listOfStatesToRemoveFromPlan!=''){
        c.listOfStatesToRemoveFromPlan__c = AIResponseData.listOfStatesToRemoveFromPlan;
     }    
     
     if(AIResponseData.planId!=null && AIResponseData.planId!=''){
        c.planID__c = AIResponseData.planId;
     }
     
     if(AIResponseData.pricingSchedule!=null && AIResponseData.pricingSchedule!=''){
        c.pricingSchedule__c = AIResponseData.pricingSchedule;    
     }
     
     if(AIResponseData.requestType!=null && AIResponseData.requestType!=''){
        c.requestType__c = AIResponseData.requestType;
     }
     
     if(AIResponseData.riskIndicator!=null && AIResponseData.riskIndicator!=''){
        c.riskIndicator__c = AIResponseData.riskIndicator;
     }
  
              if(AIResponseData.rxPlanBlock!=null){
                  if(AIResponseData.rxPlanBlock.RxPlanDetail!=null && AIResponseData.rxPlanBlock.RxPlanDetail.size()>0){
                        rxPlanBlockDescription =' rxPlanBlock:{ ';
                        rxPlanBlockDescription = rxPlanBlockDescription+ dataProcessor.getRxPlanItems(AIResponseData.rxPlanBlock.RxPlanDetail);
                        rxPlanBlockDescription = rxPlanBlockDescription+' } ';                    
                   }
    
               }
               
               if(AIResponseData.rxPlanBlock!=null){                                                  
                  if(AIResponseData.rxPlanBlock.errorRxPlanDetails!=null && AIResponseData.rxPlanBlock.errorRxPlanDetails.size()>0){
                        errRxPlanBlockDescription = ' ErrRxPlanBlock:{ ';
                        errRxPlanBlockDescription = errRxPlanBlockDescription+ dataProcessor.getRxPlanItems(AIResponseData.rxPlanBlock.errorRxPlanDetails);
                        errRxPlanBlockDescription = errRxPlanBlockDescription+' } ';                    
                   }
    
               }
               
               if(AIResponseData.tieredRxPlanBlock!=null){                
                  if(AIResponseData.tieredRxPlanBlock.RxPlanDetail!=null && AIResponseData.tieredRxPlanBlock.RxPlanDetail.size()>0){
                        tieredRxPlanBlockDescription = ' TieredRxPlanBlock:{ ';
                        tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+ dataProcessor.getRxPlanItems(AIResponseData.tieredRxPlanBlock.RxPlanDetail);
                        tieredRxPlanBlockDescription = tieredRxPlanBlockDescription+' } ';                    
                   }
              
               }
               if(AIResponseData.tieredRxPlanBlock!=null){                
                  if(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails!=null && AIResponseData.tieredRxPlanBlock.errorRxPlanDetails.size()>0){
                        errtieredRxPlanBlockDescription= ' ErrTieredRxPlanBlock:{ ';
                        errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+ dataProcessor.getRxPlanItems(AIResponseData.tieredRxPlanBlock.errorRxPlanDetails);
                        errtieredRxPlanBlockDescription= errtieredRxPlanBlockDescription+' } ';                    
                   }
              
               }
     c.rxPlanBlock__c = rxPlanBlockDescription;
     c.rxplanblockerrors__c = errRxPlanBlockDescription;
     c.tieredrxplanblock__c = tieredRxPlanBlockDescription;
     c.tieredrxplanblockerror__c = errtieredRxPlanBlockDescription;

     if(AIResponseData.subSegment!=null && AIResponseData.subSegment!=''){
      c.subSegment__c = AIResponseData.subSegment;
     }
     
      if(AIResponseData.termDate!=null && AIResponseData.termDate!=''){
        c.termDate__c = AIResponseData.termDate;
      }
    
    
       if(AIResponseData.traditionalHierarchy!=null){
            traditionalHierarchy= ' traditionalHierarchy:{ ';
                traditionalHierarchy=traditionalHierarchy+'control: '+AIResponseData.traditionalHierarchy.control;
                traditionalHierarchy=traditionalHierarchy+',suffix: '+AIResponseData.traditionalHierarchy.suffix;
                traditionalHierarchy=traditionalHierarchy+',account: '+AIResponseData.traditionalHierarchy.account;
                traditionalHierarchy=traditionalHierarchy+',planSummary: '+AIResponseData.traditionalHierarchy.planSummary;                         
            traditionalHierarchy = traditionalHierarchy+' } ';
       }   
    
     c.traditionalHierarchy__c = traditionalHierarchy;
              //assigning to queue
               List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name='Case - BCT Managers' LIMIT 1];
               QueueSobject crdqueue;
                if(crdqueueList.size()>0)
                 crdqueue=crdqueueList[0]; // If the queue was valid and a record was found.
                if(crdqueue!=NULL){
                  c.OwnerId=crdqueue.QueueId;
                }
                       
              try{
                insert c;
              }catch(Exception e){
                logger.logme(AIResponseData,true,'Exception','Exception was caught when trying to handle BCTnotification, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'Error in Input Parameters');
              }
              }
    
    */
    
    // method to insert case for package plan and return case id
    public ID InsertPackageplan(String Rxplanid){
        
        //RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
        //Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        case c;
        
        if(Rxplanid!=null && Rxplanid!='' ){
             c = new case(Subject = 'This is a new traditional rxplanid',AccountId=ASMAccountId,RecordTypeId = internrec,ownerid =bctmangerQ,status = 'New',CaseAutomationReason__c='AIPkgNewRxplanid',RxPlanID1__c = Rxplanid,Open__c=true,Description='Refer to CaseControlPlan Record(s)',Event_Notification_Review_Results__c='New CRD Needed');
             database.Saveresult result = Database.insert(c);
             return c.id;
        }else{
             return null;
        }
        
        
        
        
            
        
    }
        
    // method to insert list of cases for package plan and return list of  map of RxPlanId and case.
    public List<Map<String,Id>> InsertPackageplans(List<String> Rxplanids){
        
        //RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
        //Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        
        case c;
        Map<String,Id> mapRxPlanId2Case ;
        List<Map<String,Id>> lstMapOfRxPlan2Case = new List<Map<String,Id>>();      
        List<case> lstCases = new List<case>();
        List<Id> lstSuccessInserts = new List<Id>();
        Map<String,id> mapRxplan2successCase ; 
        
        if(Rxplanids!=null && !Rxplanids.IsEmpty()){
            for(String rx : Rxplanids){
                c = new case(Subject = 'This is a new traditional rxplanid',AccountId=ASMAccountId,RecordTypeId = internrec,ownerid =bctmangerQ,status = 'New',CaseAutomationReason__c='AIPkgNewRxplanid',RxPlanID1__c = rx,Open__c=true,Description='Refer to CaseControlPlan Record(s)',Event_Notification_Review_Results__c='New CRD Needed');   
                lstCases.add(c);
            }
                
        Database.SaveResult[] results = database.insert(lstCases);  
    
            for(database.Saveresult res : results){
                if (!res.isSuccess()) {                 
                    lstSuccessInserts.add(res.getId());                 
                }               
            }
        
        
        if(lstSuccessInserts!=null &&!lstSuccessInserts.IsEmpty()){
            
            
            for(case obj :[select id,RxPlanID1__c from case where id IN :lstSuccessInserts]){
                mapRxplan2successCase=new Map<String,id>();
                mapRxplan2successCase.put(obj.RxPlanID1__c,obj.id);
                lstMapOfRxPlan2Case.add(mapRxplan2successCase);
            }
            
            for(String rxId : Rxplanids){
                
                if(mapRxplan2successCase.get(rxId)==null){
                    mapRxplan2successCase=new Map<String,id>();
                    mapRxplan2successCase.put(rxId,null);
                    lstMapOfRxPlan2Case.add(mapRxplan2successCase);
                }               
                
            }
            

        }
            return lstMapOfRxPlan2Case;             
        }else {
            return null;
        }
    }
    
    // method to create case for package plan but do not insert the case
    public case pullPackageplan(String Rxplanid){
        
        
       // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
        //Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        case c;
        
        if(Rxplanid!=null && Rxplanid!=''){           
             c = new case(Subject = 'This is a new traditional rxplanid',AccountId=ASMAccountId,RecordTypeId = internrec,ownerid =bctmangerQ,status = 'New',CaseAutomationReason__c='AIPkgNewRxplanid',RxPlanID1__c = Rxplanid,Open__c=true,Description='Refer to CaseControlPlan Record(s)',Event_Notification_Review_Results__c='New CRD Needed');
            return c;
        }else {
            return null;
        }
        
        
    }
    
    // method to create cases for list of RxPlanIds for package plan but do not insert the cases
    public List<case> pullPackageplans(List<String>RxPlanIds){
        
        List<case> lstCase=new List<case>();
        //RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
        //Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        case c;
        
        if(Rxplanids!=null && !Rxplanids.IsEmpty()){
            
            for(String rx : Rxplanids){
                c = new case(Subject = 'This is a new traditional rxplanid',AccountId=ASMAccountId,RecordTypeId = internrec,ownerid =bctmangerQ,status = 'New',CaseAutomationReason__c='AIPkgNewRxplanid',RxPlanID1__c = rx,Open__c=true,Description='Refer to CaseControlPlan Record(s)',Event_Notification_Review_Results__c='New CRD Needed');               
                lstCase.add(c);
            }       
            return  lstCase;    
        }else {
            return null;
        }
        
    }
    // method to take Notification fallout record as an argument to create a case and return case record
        public case pullFallout(NotificationFallout__c falloutRecord){
          //  RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
          //  Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
      		string acqInd='';
            if(falloutRecord!=null){
            	if(falloutrecord.Acquisition_Indicator__c==NULL||falloutrecord.Acquisition_Indicator__c=='00'||falloutrecord.Acquisition_Indicator__c=='')
            		acqInd='No';
            	else
            		acqInd='Yes';
                case c = new case(Subject='Traditional Fallout',RecordTypeId = eventrec,ownerid =bctmangerQ,Status='New',Description='Refer to Notifcation Error Record(s)',benefitsString__c=falloutRecord.benefitsString__c,
                                    benefitsStringExtension__c= falloutRecord.benefitsStringExtension__c,controlPlanSummary__c=cpformat(falloutRecord.ControlPlan__c),ControlPlanEffective__c=falloutRecord.ControlPlanEffective__c,
                                    CRD_Name__c=falloutRecord.CRD__c,effectiveDate__c=falloutRecord.effectiveDate__c,erb__c=falloutRecord.ERB__c,FalloutCase__c=falloutRecord.Fallout__c,fundingType__c=falloutRecord.FundingType__c,
                                    planID__c=falloutRecord.PlanId__c,pricingSchedule__c=falloutRecord.pricingSchedule__c,riskIndicator__c=falloutRecord.riskIndicator__c,rxPlanBlock__c=falloutRecord.rxPlanBlock__c,
                                    RxPlanID1__c=falloutRecord.Rxplanid__c,subSegment__c=falloutRecord.Subsegment__c,termDate__c=falloutRecord.TermDate__c,tieredrxplanblock__c=falloutRecord.tieredRxPlanBlock__c,
                                    traditionalHierarchy__c=falloutRecord.traditionalHierarchy__c,CarrierId__c=falloutRecord.CarrierId__c,Package__c=falloutRecord.Package__c,PSUID__c=falloutRecord.PSUID__c,
                                    Traditional__c=falloutRecord.Traditional__c,TypeOfPlan__c=falloutRecord.TypeOfPlan__c,Open__c=true,caseAutomationReason__C='AITradFallout',AutomationTimeStamp__c=falloutRecord.createdDate,Acquisition_Indicator__c=acqInd);
                return c;
            }else{
                return null;
            }
            
        }
        
        // method to take Notification standard record as an argument to create a case and return case record
        public case pullnonpackageCPE(NotificationStandard__c successRecord){
           // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
           // Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
      
            if(successRecord!=null){
                case c = new case(Subject='New Control Plan from AI-Non Package',RecordTypeId = eventrec,ownerid =bctmangerQ,Status='New',Description='For a ControlPlaneffective combination system could not determine the CRD. See AI section for latest details for this controlplan. ',benefitsString__c=successRecord.benefitsString__c,
                                    benefitsStringExtension__c= successRecord.benefitsStringExtension__c,controlPlanSummary__c=cpformat(successRecord.ControlPlan__c),ControlPlanEffective__c=successRecord.ControlPlanEffective__c,CaseAutomationReason__c='AITradNpkg_CPENotFound',
                                    CRD_Name__c=successRecord.CRD__c,effectiveDate__c=successRecord.effectiveDate__c,erb__c=successRecord.ERB__c,fundingType__c=successRecord.FundingType__c,Control__c=successRecord.Control__c,NotificationStandard__c=successRecord.Id,
                                    planID__c=successRecord.PlanId__c,pricingSchedule__c=successRecord.pricingSchedule__c,riskIndicator__c=successRecord.riskIndicator__c,rxPlanBlock__c=successRecord.rxPlanBlock__c,
                                    RxPlanID1__c=successRecord.Rxplanid__c,subSegment__c=successRecord.Subsegment__c,termDate__c=successRecord.TermDate__c,tieredrxplanblock__c=successRecord.tieredRxPlanBlock__c,
                                    traditionalHierarchy__c=successRecord.traditionalHierarchy__c,CarrierId__c=successRecord.CarrierId__c,Package__c=successRecord.Package__c,PSUID__c=successRecord.PSUID__c,
                                    Traditional__c=successRecord.Traditional__c,TypeOfPlan__c=successRecord.TypeOfPlan__c,Open__c=true,AutomationTimeStamp__c=successRecord.createdDate);
                return c;
            }else{
                return null;
            }
            
        }
    
    
        
        // method to take INFRC_EFF_DATE  as an argument to create a case and return case record
        public case pullPERSNPkgNoCRD(date INFRC_EFF_DATE,String cpe,datetime ats ){
           // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
           // Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
      
            if(INFRC_EFF_DATE!=null){
                case c = new case(Subject='PERS change-no CRD-no Case',controlPlanSummary__c=cpformat(cpe.substring(0,cpe.length()-10)),RecordTypeId = internrec,ownerid =bctmangerQ,Status='New',Description='Refer to Provision and Line Value Record(s)',CaseAutomationReason__c='PERSnCRDnCase',Benefit_Effective_Date__c=INFRC_EFF_DATE,Event_Notification_Review_Results__c='Plan Change',Open__c=true,ControlPlanEffective__c=cpe,AutomationTimeStamp__c=ats);
                return c;
            }else{
                return null;
            }
            
        }
    
    
    // method to take INFRC_EFF_DATE  as an argument to create a case and return case record
        public case pullPERSNPkgCRDnoCase(date INFRC_EFF_DATE,String ctrl,Id crdId,datetime ats,ID accId ){
           // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where DeveloperName='Internal_CRD_GMF_Process' AND SobjectType = 'case'];
           // Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Supervisor Unassigned Cases'];
      
            if(INFRC_EFF_DATE!=null){
                case c = new case(Subject='PERS change-CRD-no Case',control__c=ctrl,RecordTypeId = internrec,ownerid =bctunassingQ,Status='Send for Assignment',Description='Refer to Provision and Line Value Record(s)',CaseAutomationReason__c='PERSyCRDnCase',Benefit_Effective_Date__c=INFRC_EFF_DATE,Event_Notification_Review_Results__c='Plan Change',Open__c=true,CRD_ID__c=crdId,CRD_Name__c=crdId,AutomationTimeStamp__c=ats,AccountId=accid,CA_PERS_NonPkgKey__c=crdId+ctrl+string.valueof(INFRC_EFF_DATE),ControlEffective__c=ctrl+string.valueof(INFRC_EFF_DATE));
                return c;
            }else{
                return null;
            }
            
        }
    
    
    
    // method to insert list of cases for Non package plan and return list id of case created
    public id InsertNonPackageplan(Map<ID,NotificationStandard__c> MapCRDidNotificationStandard){
        try{
            list<Map<ID,NotificationStandard__c>> MapsCRDidNotificationStandard = new list<Map<ID,NotificationStandard__c>>();
            MapsCRDidNotificationStandard.add(MapCRDidNotificationStandard);
            Map<id,id> MapNotStandardCase = InsertNonPackageplans(MapsCRDidNotificationStandard);
            list<id> caseids = new list<id>();
            
            if(MapNotStandardCase != null)
                caseids = MapNotStandardCase.values();
            else
                return null;
                
            if(caseids !=null && caseids.size() > 0)
                return caseids[0];
            else
                return null;
        }
        catch(exception ex){
            return null;
        }
    }
    
    // method to insert list of cases for Non package plans and return Map of Notification id and case id.
    public Map<id,id> InsertNonPackageplans(list<Map<ID,NotificationStandard__c>>  MapsCRDidNotificationStandard){
        try{
            Map<ID,NotificationStandard__c> tempmapCRDidNotificationStandard = new Map<ID,NotificationStandard__c>();
            
           // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name Like '%Event Notification%' AND SobjectType = 'case'];
           // Group grp = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
            
            Map<id,id> MapNotStandardCase = new Map<id,id>();
            
            list<case> Caselist = new List<case>();
            	
            for(Map<ID,NotificationStandard__c> MapCRDidNotificationStandard : MapsCRDidNotificationStandard)
            {
                tempmapCRDidNotificationStandard.putall(MapCRDidNotificationStandard);
                for(id crdid : MapCRDidNotificationStandard.keyset()){
                    case caseitem;
                    string Rxplanid = MapCRDidNotificationStandard.get(crdid).Rxplanid__c ;
                    NotificationStandard__c currentNotificationStand = MapCRDidNotificationStandard.get(crdid);
                    if(Rxplanid!=null && Rxplanid!=''){
                        caseitem = new case(Subject = 'Control plan effective date mismatch (PERS-SFDC)',RxPlanID1__c = Rxplanid ,RecordTypeId = eventrec,ownerid =bctmangerQ,status = 'New',CaseAutomationReason__c='AITranNpkgRxplaidmismatch',CRD_ID__c = crdid);
                         caseitem.benefitsString__c = currentNotificationStand.benefitsString__c ;
                         caseitem.benefitsStringExtension__c = currentNotificationStand.benefitsStringExtension__c ;
                         caseitem.CarrierId__c = currentNotificationStand.CarrierId__c ;
                         caseitem.Control__c = currentNotificationStand.Control__c ;
                         caseitem.controlPlanSummary__c = cpformat(currentNotificationStand.ControlPlan__c);
                         caseitem.ControlPlanEffective__c = currentNotificationStand.ControlPlanEffective__c ;
                         caseitem.CRD_Name__c = crdid ;
                         caseitem.effectiveDate__c = currentNotificationStand.effectiveDate__c ;
                         caseitem.erb__c = currentNotificationStand.ERB__c ;
                         caseitem.FalloutCase__c = currentNotificationStand.Fallout__c ;
                         caseitem.fundingType__c = currentNotificationStand.FundingType__c ;
                         caseitem.Package__c = currentNotificationStand.Package__c ;
                         caseitem.planID__c = currentNotificationStand.PlanId__c ;
                         caseitem.pricingSchedule__c = currentNotificationStand.pricingSchedule__c ;
                         caseitem.PSUID__c = currentNotificationStand.PSUID__c ;
                         caseitem.riskIndicator__c = currentNotificationStand.riskIndicator__c ;
                         caseitem.rxPlanBlock__c = currentNotificationStand.rxPlanBlock__c ;
                         //caseitem.RxPlanID1__c = currentNotificationStand.Rxplanid__c ;
                         caseitem.subSegment__c = currentNotificationStand.Subsegment__c ;
                         caseitem.termDate__c = currentNotificationStand.TermDate__c ;
                         caseitem.tieredrxplanblock__c = currentNotificationStand.tieredRxPlanBlock__c ;
                         caseitem.Traditional__c = currentNotificationStand.Traditional__c ;
                         //caseitem.Look at controlplansummary__c = currentNotificationStand.traditionalControlNumberPlanSummaryDetai__c ;
                         caseitem.traditionalHierarchy__c = currentNotificationStand.traditionalHierarchy__c ;
                         caseitem.TypeofPlan__c = currentNotificationStand.TypeOfPlan__c ;
                         caseitem.NotificationStandard__c = currentNotificationStand.Id ;
						 caseitem.Open__c=true;
						 caseItem.Description='For a ControlPlaneffective combination system could not determine the CRD. Refer to CaseControlPlan Record(s). ';

                        Caselist.add(caseitem);
                    }
                }
            }

            LIST<Database.SaveResult> result = Database.insert(Caselist);
            
            list<id> Caseinserted = new list<id>();
            
            if(result == null){
                return null;
            }else{
                for(database.Saveresult res : result){
                    if (res.isSuccess()) {                 
                        Caseinserted.add(res.getid());
                        
                    }else{                  
                        for(Database.Error err : res.getErrors()) {                              
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());            
                        }                           
                    } 
                }
            }
            
            map<id,case> casemap = new map<id,case>([select id,CRD_id__c from case where id in :Caseinserted]);
            for(case caseitem : casemap.values())
                MapNotStandardCase.put((tempmapCRDidNotificationStandard.get(caseitem.CRD_id__c)).id,caseitem.id);
                
            return MapNotStandardCase;
        }
        catch(exception ex){
            return null;
        }
    }
    
    //This method will be used to get the cases for the list of notification standard and return list of Cases
    public List<case>  pullNonPackageplans(List< Map<ID,NotificationStandard__c> > MapsCRDidNotificationStandard){
        set<id> crdids = new set<id>();
        set<string> Rxplanids = new set<string>();
        list<case> returncases = new list<case>();
       // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
       // Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        
        for(Map<ID,NotificationStandard__c> MapCRDidNotificationStandard : MapsCRDidNotificationStandard){
            for(id crdid : MapCRDidNotificationStandard.keyset()){
                NotificationStandard__c currentNotificationStand = MapCRDidNotificationStandard.get(crdid);
                case retCase = new case(Subject = 'Control plan effective date mismatch (PERS-SFDC)',RecordTypeId = eventrec,ownerid =bctmangerQ,description = 'Compare PERS and CRD[to be completed by Kathy]' ,status = 'New',CaseAutomationReason__c='AITranNpkgRxplaidmismatch',RxPlanID1__c = MapCRDidNotificationStandard.get(crdid).RxPlanID__c , CRD_ID__c = crdid,open__c=true);
                 retcase.benefitsString__c = currentNotificationStand.benefitsString__c ;
                 retcase.benefitsStringExtension__c = currentNotificationStand.benefitsStringExtension__c ;
                 retcase.CarrierId__c = currentNotificationStand.CarrierId__c ;
                 retcase.Control__c = currentNotificationStand.Control__c ;
                 retcase.controlPlanSummary__c = cpformat(currentNotificationStand.ControlPlan__c);
                 retcase.ControlPlanEffective__c = currentNotificationStand.ControlPlanEffective__c ;
                 retcase.CRD_Name__c = currentNotificationStand.CRD__c ;
                 retcase.effectiveDate__c = currentNotificationStand.effectiveDate__c ;
                 retcase.erb__c = currentNotificationStand.ERB__c ;
                 retcase.FalloutCase__c = currentNotificationStand.Fallout__c ;
                 retcase.fundingType__c = currentNotificationStand.FundingType__c ;
                 retcase.Package__c = currentNotificationStand.Package__c ;
                 retcase.planID__c = currentNotificationStand.PlanId__c ;
                 retcase.pricingSchedule__c = currentNotificationStand.pricingSchedule__c ;
                 retcase.PSUID__c = currentNotificationStand.PSUID__c ;
                 retcase.riskIndicator__c = currentNotificationStand.riskIndicator__c ;
                 retcase.rxPlanBlock__c = currentNotificationStand.rxPlanBlock__c ;
                 //retcase.RxPlanID1__c = currentNotificationStand.Rxplanid__c ;
                 retcase.subSegment__c = currentNotificationStand.Subsegment__c ;
                 retcase.termDate__c = currentNotificationStand.TermDate__c ;
                 retcase.tieredrxplanblock__c = currentNotificationStand.tieredRxPlanBlock__c ;
                 retcase.Traditional__c = currentNotificationStand.Traditional__c ;
                 //retcase.Look at controlplansummary__c = currentNotificationStand.traditionalControlNumberPlanSummaryDetai__c ;
                 retcase.traditionalHierarchy__c = currentNotificationStand.traditionalHierarchy__c ;
                 retcase.TypeofPlan__c = currentNotificationStand.TypeOfPlan__c ;
                 retcase.NotificationStandard__c = currentNotificationStand.Id ;
                 retcase.AutomationTimeStamp__c=currentNotificationStand.createdDate;  
				 retcase.Description='For a ControlPlaneffective combination system could not determine the CRD. Refer to CaseControlPlan Record(s). ';
                returncases.add(retCase);
            }
        }

                
        return returncases;
    }
    
    //This method will be used to get the cases for the notification standard and return a case
    public case pullNonPackageplans(Map<ID,NotificationStandard__c> MapCRDidNotificationStandard){
        // RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Event Notifications' AND SobjectType = 'case'];
        // Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
        list<id> crdids = new list<id>();
        crdids.addall(MapCRDidNotificationStandard.keyset());
        //set<string> Rxplanids = MapCRDidNotificationStandard.values();
		Id crdId=(new list<Id>(MapCRDidNotificationStandard.keyset()) [0]) ;
        //list<case> returncases = [select id ,Subject,RecordTypeId,CaseAutomationReason__c,CRD_ID__c,RxPlanID1__c from case where CRD_ID__c = : crdids[0] and RxPlanID1__c = : MapCRDidNotificationStandard.values()[0].RxPlanID__c];
        NotificationStandard__c currentNotificationStand = MapCRDidNotificationStandard.values()[0];
        case retCase = new case(Subject = 'Control plan effective date mismatch (PERS-SFDC)',RecordTypeId = eventrec,ownerid =bctmangerQ,description = 'Compare PERS and CRD[to be completed by Kathy]' ,status = 'New',CaseAutomationReason__c='AITranNpkgRxplaidmismatch',RxPlanID1__c = MapCRDidNotificationStandard.values()[0].RxPlanID__c , CRD_ID__c = crdids[0],Open__c=true);
         retcase.benefitsString__c = currentNotificationStand.benefitsString__c ;
         retcase.benefitsStringExtension__c = currentNotificationStand.benefitsStringExtension__c ;
         retcase.CarrierId__c = currentNotificationStand.CarrierId__c ;
         retcase.Control__c = currentNotificationStand.Control__c ;
         retcase.controlPlanSummary__c = cpformat(currentNotificationStand.ControlPlan__c);
         retcase.ControlPlanEffective__c = currentNotificationStand.ControlPlanEffective__c ;
         retcase.CRD_Name__c = crdId;
         retcase.effectiveDate__c = currentNotificationStand.effectiveDate__c ;
         retcase.erb__c = currentNotificationStand.ERB__c ;
         retcase.FalloutCase__c = currentNotificationStand.Fallout__c ;
         retcase.fundingType__c = currentNotificationStand.FundingType__c ;
         retcase.Package__c = currentNotificationStand.Package__c ;
         retcase.planID__c = currentNotificationStand.PlanId__c ;
         retcase.pricingSchedule__c = currentNotificationStand.pricingSchedule__c ;
         retcase.PSUID__c = currentNotificationStand.PSUID__c ;
         retcase.riskIndicator__c = currentNotificationStand.riskIndicator__c ;
         retcase.rxPlanBlock__c = currentNotificationStand.rxPlanBlock__c ;
         //retcase.RxPlanID1__c = currentNotificationStand.Rxplanid__c ;
         retcase.subSegment__c = currentNotificationStand.Subsegment__c ;
         retcase.termDate__c = currentNotificationStand.TermDate__c ;
         retcase.tieredrxplanblock__c = currentNotificationStand.tieredRxPlanBlock__c ;
         retcase.Traditional__c = currentNotificationStand.Traditional__c ;
         //retcase.Look at controlplansummary__c = currentNotificationStand.traditionalControlNumberPlanSummaryDetai__c ;
         retcase.traditionalHierarchy__c = currentNotificationStand.traditionalHierarchy__c ;
         retcase.TypeofPlan__c = currentNotificationStand.TypeOfPlan__c ;
         retcase.NotificationStandard__c = currentNotificationStand.Id ; 
         retcase.AutomationTimeStamp__c=currentNotificationStand.createdDate; 
         retcase.Description='For a ControlPlaneffective combination system could not determine the CRD. Refer to CaseControlPlan Record(s). ';
         
        return retCase;
           
    }
    
    public string cpformat(string cp){
		if(cp==NULL)
			return '';
		else{
			integer len=cp.length();
			string ctrl=cp.substring(0,len-2); //since control is 7 characters.
			while(ctrl.length()<7){
				ctrl='0'+ctrl;
			}
			string pl=cp.substring(len-2,len).trim(); //plan is 2 characters
			
			return ctrl+'_'+pl;
		}
		
   }  
    
}