global without sharing class BAT_TradFallNotifProcessor implements Database.Batchable<sObject>{
     //=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement:8533b
   // Description:Scheduled class designed to call:TraditionalFalloutNotificationService.Process Traditional Fallout notifications
   // Called by:
  
   /*==================================================================================================
   Version     Author                           Date                    Reason
   1.0         Saraag                           09/28/2013              Created 
   2.0         Saraag                           10/22/2013              Added advanced error handling
   3.0         Saraag                           6/29/2014               Added filter for excluding non pricing errors. added for CRDB sep rel 
   4.0         Amit                             25 Nov, 2015            Added logic to Format control to 7 digit for Pers Seed, ST# 497
   ====================================================================================================*/
     //Class Variables
          //DataType                                                Name                             Description
            String                                                  QString;                        //Query string for start method
            Map<String,List<NotificationFallout__c>>                Notifmap;                       //Map for consolidating notification records at controlPlaneffectivedate level.
            Id                                                      eventNotifRecordId;             //Used to hold evennotification recordtypeId    
            Set<String>                                             FoundCtrlPlanEffinCase;         //ControlPlaneffectives for which there are existing 'open' cases.
          //Set<String>                                             NotfoundCtrlPlanEffinCase;      //ControlPlaneffectives for which there are NO existing 'open' cases.
          //Map<String,set<Id>>                                     CtrlPlanEffCaseIDMAP;           //ControlPlanEffectiveDate, case Id for the cases we found for controlplaneffectivedate in notification records.
            Map<String,List<NotificationFallout__c>>                NotifErrorMap;                  //Map of CPE+ErrorType+ErrorDescription, list of notificationfallouts.
            Map<String,List<NotificationFallout__c>>                RxplanNotifsMap;                    //Map of Rxplanid, and one sample NotificationFallout record with specific error message. 
    
   //============================
   // Constructor
   //============================
   global BAT_TradFallNotifProcessor(String Q){
        QString=Q;
        NotifMap=new Map<String,List<NotificationFallout__c>>();
        eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
        FoundCtrlPlanEffinCase=new Set<String>();
        NotifErrorMap=new Map<String,List<NotificationFallout__c>>();
        //NotFoundCtrlPlanEffinCase=new Set<String>();
        //CtrlPlanEffCaseIDMAP=new Map<String,Set<id>>();
   }//End constructor
      
   //============================
   // Interface Methods 
   //============================
   global Database.QueryLocator start (Database.BatchableContext BC){
         JobLogger.startBatch(NULL, 'Starting TradFallNotifProcess', userinfo.getUserId(), system.now(), true, 'BCTCaseAutomation');    
         return Database.getQueryLocator(QString);
   }//End execute Method.
   
   
   global void execute (Database.BatchableContext BC,List<NotificationFallout__c> scope){
        //Local variables
        
        //Set<Case> CaseSetLocal=new Set<case>();
        Map<String,NotificationError__c> upsertErrorMap=new Map<String,NotificationError__c>();
        List<Id> updateNFList=new List<Id>();
        List<Id> erroredNFList=new List<Id>();
        List<case> insertList_case=new List<case>();
        List<NotificationFallout__c> ignoredFallouts=new List<NotificationFallout__c>();
        RxplanNotifsMap=new Map<String,List<NotificationFallout__c>>();
        
        
        //-------STEP 1: Consolidating Notifications at ControlPlanEffective level.-----------------------
        for(NotificationFallout__c NF:scope){//Do for each notification record in scope
            if((NF.ErrorDescription__c!=null&&NF.ErrorDescription__c!=''&&NF.ErrorDescription__c.toLowerCase().startsWith('pricing'))||(NF.ErrorType__c!=NULL&&NF.ErrorType__c!=''&&NF.ErrorType__c.toLowerCase().startsWith('Pricing'))){ //only for pricing errors.
            if(NF.controlplaneffective__c!=null&&NF.controlplaneffective__c!=''){ //making sure there are no blanks.
                List<NotificationFallout__c> NFLocal=new List<NotificationFallout__c>();
                //check if it already exists
                 If(NotifMap.containsKey(NF.ControlPlanEffective__c)){
                   NFLocal=NotifMap.get(NF.ControlPlanEffective__c); //adding to list of notifications
                   NFLocal.add(NF);
                 }
                 else //Encountered controlplaneffective combination for the first time
                   NFLocal.add(NF);
                   
                NotifMap.put(NF.ControlPlanEffective__c,NFLocal);
               //Step1.b-----Consolidating  error 
              List<NotificationFallout__c> NFLocalError=new List<NotificationFallout__c>();
               If(NotifErrorMap.containsKey(NF.ControlPlanEffective__c+NF.ErrorType__c+NF.ErrorDescription__c)){
                    NFLocalError=NotifErrorMap.get(NF.ControlPlanEffective__c+NF.ErrorType__c+NF.ErrorDescription__c);
                    NFLocalError.add(NF);
               }
               else
                   NFLocalError.add(NF);
               
               NotifErrorMap.put(NF.ControlPlanEffective__c+NF.ErrorType__c+NF.ErrorDescription__c,NFLocalError);
            }
          }//end if filter
         /* else if((NF.ErrorDescription__c!=null&&NF.ErrorDescription__c!=''&&NF.ErrorDescription__c.equalsIgnoreCase('RxPlanID does not exist on AI Non-Pkg table'))||(NF.ErrorType__c!=NULL&&NF.ErrorType__c!=''&&NF.ErrorType__c.equalsIgnoreCase('RxPlanID does not exist on AI Non-Pkg table'))){ //For traditional like package plans. Added 8/21 Sep 27 Rel
                if(RxplanNotifsMap.containsKey(NF.Rxplanid__c)){
                    RxplanNotifsMap.get(NF.Rxplanid__c).add(NF);
                }
                else{
                    RxplanNotifsMap.put(NF.Rxplanid__c,new List<NotificationFallout__c> {NF});
                }
          }*/
          else{ //ignoring everything else
            NF.processed__c=true;
            ignoredFallouts.add(NF);
          }
           if(RxplanNotifsMap.containsKey(NF.Rxplanid__c)){
                RxplanNotifsMap.get(NF.Rxplanid__c).add(NF);
            }
            else{
                RxplanNotifsMap.put(NF.Rxplanid__c,new List<NotificationFallout__c> {NF});
            }
        }
        
        update ignoredFallouts;
        //Added 8/21 for Sep27 CRDB release. Traditional Like package plans
            RxplanNotifsMap.remove('');
            ProcessCAGandFutureState(RxplanNotifsMap);
        //End like package plan changes.
       //-------STEP 2: Find open cases for the controlplaneffectives in scope.-----------------------------
       //TODO: O(n^3). Can remove querymore approach?
        for(Case c:[SELECT Id,ControlPlanEffective__c FROM case WHERE RecordTypeId=:eventNotifRecordId AND ControlPlanEffective__c IN:NotifMap.keyset() AND Open__c=True AND CaseAutomationReason__c='AITradFallout']){//Filtering on Indexed fields.
              //Using QueryMore SOQL for Forloop pattern
                    /*If(CtrlPlanEffCaseIDMAP.containsKey(c.ControlPlanEffective__c))
                        caseSetLocal=CtrlPlanEffCaseIDMAP.get(c.ControlPlanEffective__c).add(c.Id); //if there is already an entry, adding this case to the list.   
                    else{//New controlPlaneffective combination. create new list.
                        caseSetLocal.add(c.Id);
                        
                    }
                        
                    CtrlPlanEffCaseIDMAP.put(c.controlPlanEffective__c,caseSetLocal);
                    */
                    FoundCtrlPlanEffinCase.add(c.controlPlanEffective__c);//add to set. eliminates dupes
                    for(NotificationFallout__c nfrec:notifMap.get(c.controlplaneffective__c)){
                        if(!upsertErrorMap.containsKey(nfrec.ErrorType__c+nfrec.ErrorDescription__c+c.Id))//only add if there isn't already an error record with the same details.
                          upsertErrorMap.put(nfrec.ErrorType__c+nfrec.ErrorDescription__c+c.Id,new NotificationError__c(NotificationTimeStamp__c=nfrec.CreatedDate,ErrorType__c=nfrec.ErrorType__c,ErrorDescription__c=nfrec.ErrorDescription__c,Case__c=c.Id,key__c=nfrec.ErrorType__c+nfrec.ErrorDescription__c+c.Id,NotificationFallout__c=nfrec.Id));
                    }
              
        }
        handleNotifErrorDML(upsertErrorMap);//there could be existing ones.
        upsertErrorMap.clear();
        //-------STEP 3: For controlplaneffective where there is no case-------------------------------
       /* for(String cpe:NotifMap.keyset()){
         if(!FoundCtrlPlanEffinCase.contains(cpe))//It's in not in the found set. Adding to set to remove dupes.
             NotfoundCtrlPlanEffinCase.add(cpe);
        }*/
       // List<Id> insertedCaseIds=new List<Id>();
        insertList_case.clear();
        for(String cpe:NotifMap.keyset()){
         if(!FoundCtrlPlanEffinCase.contains(cpe))//It's in not in the found set. Adding case
           insertList_case.add(createcase(NotifMap.get(cpe)[0]));
        }
         if(insertList_case!=NULL&&!insertList_case.isempty())
            insert insertList_case;
        /*for(case c:insertList_case){
            insertedCaseIds.add(c.Id);
        }*/
        // Now create NotificationError records for the newly created cases.
        for(case c:insertList_case){
            for(NotificationFallout__c nfre:notifMap.get(c.ControlPlanEffective__c)){//for each notification under that cpe
             if(!upsertErrorMap.containsKey(nfre.ErrorType__c+nfre.ErrorDescription__c+c.Id))
                upsertErrorMap.put(nfre.ErrorType__c+nfre.ErrorDescription__c+c.Id,new NotificationError__c(NotificationTimeStamp__c=nfre.CreatedDate,ErrorType__c=nfre.ErrorType__c,ErrorDescription__c=nfre.ErrorDescription__c,Case__c=c.Id,NotificationFallout__c=nfre.Id,key__c=nfre.ErrorType__c+nfre.ErrorDescription__c+c.Id));
            }
        
        }
        handleNotifErrorDML(upsertErrorMap);//these are new.
        
      /* //--------STEP 4: Adding new error records to cases with new information.
//       TODO: O(n^3) - rewrite to minimize for loop levels.
        upsertErrorMap.clear();
        for(String cpe:FoundCtrlPlanEffinCase){//for each controlplaneffective
          for(Id caseIdVal:CtrlPlanEffCaseIDMAP.get(cpe)){//for each open case found for the cpe.
            for(NotificationFallout__c nfre:notifMap.get(cpe)){
                upsertErrorMap.put(nfrec.ErrorType__c+nfre.ErrorDescription+nefrec.case__c,new NotificationError__c(ErrorType__c=nefrec.ErrorType__c,ErrorDescription__c=nefrec.ErrorType__c,Case__c=caseIdVal));
            }
          } 
        }
        
       */
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
      
   }//End execute Method.
   
   
   global void finish (Database.BatchableContext BC){
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
        AsyncApexJob a = [Select Id, CreatedDate, CreatedById, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob  WHERE Id =:BC.getJobId()];
        JobLogger.endBatch(System.now(),NULL,'Completed TradFallNotif process.',Userinfo.getUserId(),true,'CaseAutomation',a);
        CaseAuto_BatchLinker cab=new CaseAuto_BatchLinker();
        cab.callNext('BAT_TradFallNotifProcessor');

   }//End execute Method.
   
   //============================
   // Member variabels   
   //============================
   
  
   //=============================
   // Member Methods  
   //=============================
   
   // Method Name:
   // Arguments:
   // Return:
   // Description:
   private void handleNotifErrorDML(Map<string,NotificationError__c> ArgUpMap){
    List<Id> nfList=new List<Id>();
    List<Id> updateNFList=new List<Id>();
    List<NotificationFallout__c> updateNotificationList=new List<NotificationFallout__c>();
    List<Error_Log__c> errorList=new List<Error_Log__c>();
    Database.UpsertResult[] errorUpsertRes=Database.upsert(ArgUpMap.values(),NotificationError__c.Fields.key__c,False);
    integer j=0;
        for(Database.UpsertResult DMLresult:errorUpsertRes){
            if(DMLresult.isSuccess())//Adding records that were successful. For marking processed.
              updateNFList.add(DMLresult.getId());
            else{
                    j++;
                    if(j==1)
                        errorList.add(ErrorLogger.getRecord('Error inserting into NotificationError','5','BCTCaseAutomation','Failed to insert NotificationErrros.Look at notprocessed ones.UpsertResult:'+JSON.serialize(DMLresult),NULL,true,UserInfo.getUserId(),'Batch','BAT_PersPkgProcessor', 174,'solipurams@aetna.com'));
                    else
                        errorList.add(ErrorLogger.getRecord('Error inserting into NotificationError','5','BCTCaseAutomation','Failed to insert NotificationErrros.Look at notprocessed ones.UpsertResult:'+JSON.serialize(DMLresult),NULL,false,UserInfo.getUserId(),'Batch','BAT_PersPkgProcessor', 174,'solipurams@aetna.com'));
            }
        }
      
        for(NotificationError__c nfe:[SELECT NotificationFallout__c FROM NotificationError__c WHERE Id IN:updateNFList]){
            nfList.add(nfe.NotificationFallout__c);
        }
        for(NotificationFallout__c nfrecord:[select processed__c,ControlPlanEffective__c,ErrorType__c,ErrorDescription__c from NotificationFallout__c where Id IN:nfList]){
            //nfrecord.Processed__c=True;
            For(NotificationFallout__c nfallout:NotifErrorMap.get(nfrecord.ControlPlanEffective__c+nfrecord.ErrorType__c+nfrecord.ErrorDescription__c)){
                nfallout.Processed__c=True;
                updateNotificationList.add(nfallout);
                
            }
        }   
        insert errorList;
        update updateNotificationList; //TODO: implement error handling...
              
   }
   
   // Method Name:
   // Arguments:
   // Return:
   // Description:
   private case createCase(NotificationFallout__c NFList){
      CreateCase casecreator=new Createcase();
      return (casecreator.pullFallout(NFList));                  
   }
   
   //MethodName: ProcessCAGandFutureState
   //Arguments: RxplanId and sample NotificatioFallout record
   //Return:
   //Description: 
   //           Given that we are receiving the actual plan structure for a pre-defined CRD
   //           When SF receives a fallout notification from AI with error: RxPlanID does not exist on AI Non-Pkg table (need to process fallout records with this error)
   //           Then the system should search using RxPlan ID for a Traditional_LikePackage CRD (CRD with predefined=True)
   //           And
   //           add the Control plan as a PCG under the CRD
   //           And
   //           the system should insert a record into the "PERSseed" object 
   private void ProcessCAGandFutureState(Map<String,List<NotificationFallout__c>> rxPlanNotifs){
    If(!rxPlanNotifs.isEmpty()){
        set<string> Rxplanidset= new set<string>();
        Map<string,PERS_Seed__c> newperseed=new Map<string,PERS_Seed__c>();
        
        
        //get likepackage plan CRDs.
        for(CRD__c crd:[select Rxplanid__c from CRD__c where Rxplanid__c IN:rxPlanNotifs.keyset() and Archived__c=false and Predefined__c=true]){
            if(crd.RxPlanID__c!=''&&crd.rxplanid__c!=null){
                Rxplanidset.add(crd.Rxplanid__c);
            }           
        }
        
            
        for(string rxplan:rxPlanNotifs.keyset()){
            if(Rxplanidset.contains(rxplan)){ // we found a predefined CRD for this Rxplanid.
                for(NotificationFallout__c nfr:rxPlanNotifs.get(rxplan)){ //for each CPE under the rxplanid
                    //Amit added Formatted Control Logic for ST# 497 on 25 Nov, 2015
                    String formattedControl = GC_Utils_Method.calculateControl(nfr.Control__c);
                    string Keyc = nfr.RxplanID__c+ formattedControl +nfr.Plan_Summary__c+DateTime.newInstance(nfr.EffectiveDate__c, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy');
                    if(!newperseed.containsKey(Keyc))  // did not encounter before                                      
                        newperseed.put(Keyc,new PERS_Seed__c(RxPlanId__c=nfr.RxplanID__c,Control__c=formattedControl,Plan__c=nfr.Plan_Summary__c,EffectiveDate__c=nfr.effectiveDate__c,Yschedule__c=nfr.pricingSchedule__c,Fallout__c=false,SentToDS__c=false,Fallout_Counter__c=0,SenttoPCC__c=false,key__c=Keyc) );
                }
            }           
        }
 
        
        //inserting pers seeding
        
        upsert newperseed.values() key__c;
        
        //marking records as processed
        List<NotificationFallout__c> updateList=new List<NotificationFallout__c>();
        for(String rx:RxplanNotifsMap.keyset()){
            for(NotificationFallout__c nf:RxplanNotifsMap.get(rx)){
                nf.processed__c=true;
                updateList.add(nf);
            }
        }
        update updateList;
        
        //garbage cleaning
        updateList.clear();
        RxplanNotifsMap.clear();
        
    }
        
   }
   
    private string ctrlformat(string ctrl){
        if(ctrl==NULL)
            return '';
        else{
            integer len=ctrl.length();
            while(ctrl.length()<7){
                ctrl='0'+ctrl;
            }           
            return ctrl;
        }
        
   }  
}//End class BAT_TradFallNotifProcessor