global without sharing class BAT_TradStdPkgProcessor implements Database.Batchable<sObject>{
     //=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement:SFDC8533b
   // Description:Scheduled class designed to call
   // Called by: 
  
   /*==================================================================================
   Version                  Author      Date                                Reason
   1.0                      Saraag      Sep29,2013                          Created 
   2.0                      Saraag      Feb20,2013                          Feb23 Rel
   3.0                      Saraag      Feb27,2013                          March15 Rel
   4.0						Saraag		Dec 11,2014							Changing case record type to internal
   ====================================================================================*/
     //Class Variables
          //DataType                                                Name                             Description
            String                                                  QString;                        //Query string for start method
            Map<String,List<NotificationStandard__c>>               Notifmap;                       //Map for consolidating notification records at controlPlaneffectivedate level.
            Id                                                      InternalRecordId;             //Used to hold internal CRD GMF recordtypeId    
            Set<String>                                             FoundRxplanIds;                  //Set of RxplanIds that already exist
    		Id														EventRecordId;					//holds 	Event_Notifications recordtype ID 
 //============================
   // Constructor
   //============================
   global BAT_TradStdPkgProcessor(String Q){
        QString=Q;
        NotifMap=new Map<String,List<NotificationStandard__c>>();
        InternalRecordId=(Id)[select Id from recordtype where DeveloperName='Internal_CRD_GMF_Process' LIMIT 1][0].Id;
        EventRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
   }//End constructor
      
   //============================
   // Interface Methods 
   //============================
   global Database.QueryLocator start (Database.BatchableContext BC){
         JobLogger.startBatch(NULL, 'Starting TradStdPkgProcess', userinfo.getUserId(), system.now(), true, 'BCTCaseAutomation');               
         return Database.getQueryLocator(QString);
   }//End execute Method.
   
   
   global void execute (Database.BatchableContext BC,List<NotificationStandard__c> scope){
       FoundRxplanids=new Set<String>();
       Map<string,ControlPlanRxplan__c> upsertListCPRx=new Map<String,ControlPlanRxplan__c>();
       List<case> insertList_case=new List<case>();
       List<NotificationStandard__c> notifstdUpdateList=new List<NotificationStandard__c>();
       List<NotificationStandard__c> BatchScope;
       List<Id> BatchIds=new List<Id>();
       // Refresh records and order by createddate.
         //collect all Ids
         for(NotificationStandard__c n:scope){
            BatchIds.add(n.Id);
         }
       //-----------------STEP0:Refetching records now ordered by createdDate---------------------------
         Schema.DescribeSObjectResult  DescribeRec=NotificationStandard__c.sObjectType.getDescribe();
        //get all field names
        Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
        String qry='';
        for(String s:FieldsMap.keyset()){
           qry+=s+',';
        }
        qry=qry.left(qry.length()-1); //removing the extra comma
        if(BatchIds!=NULL&&BatchIds.size()>0)         
             Batchscope=Database.query('SELECT '+qry+' FROM NotificationStandard__c WHERE Id IN:BatchIds ORDER BY Name DESC');
        else
             Batchscope=new List<NotificationStandard__c>();
        //clearing out scope
        scope.clear(); 
      //-------------------STEP1: Consolidate at RXPLANID level.--------------------------------------
        for(NotificationStandard__c NS:Batchscope){//Do for each notification record in scope
            if(NS.Rxplanid__c!=null&&NS.Rxplanid__c!=''&&NS.ControlPlanEffective__c!=NULL&&NS.ControlPlanEffective__c!=''){
                 List<NotificationStandard__c> NSLocal=new List<NotificationStandard__c>();
                //check if it already exists
                If(NotifMap.containsKey(NS.RxplanId__c)){
                   NSLocal=NotifMap.get(NS.Rxplanid__c); //adding to list of notifications
                   NSLocal.add(NS);
                 }
                 else //Encountered controlplaneffective combination for the first time
                   NSLocal.add(NS);
                   
                NotifMap.put(NS.RxplanId__c,NSLocal);
            }
        }
        Batchscope.clear();
     //-------------------STEP2: Notifications with EXISTING RxplanIds.--------------------------------------
    
     //TODO: will there be multiple CRDs for an rxplanid? should we try and avoid them?
     for(CRD__c crdrec:[SELECT Id,RxplanId__c,Effective_Start_Date__c FROM CRD__c WHERE RxplanId__c IN:NotifMap.keySet() Order by Name]){
        string crdrxplan;
        crdrxplan=crdrec.Rxplanid__c;
                
        //for each found rxplanid and crdid combination, make sure there is a corresponding record in controlplanrxplan table.
        if(!FoundRxplanids.contains(crdrxplan)){//to avoid multiple crds
            for(NotificationStandard__c notifstd:NotifMap.get(crdrxplan)){ //if there are multiple records with same rxplanid and with different effective dates?.
                notifstd.Processed__c=True;
                notifstdUpdateList.add(notifstd); 
                //by adding to the map, we're trying to eliminate duplicate entries in upsert list, there by avoiding DML exceptions.
                String LocalKey=notifstd.PSUID__c+notifstd.ControlPlanEffective__c+notifstd.Rxplanid__c;
                if(!upsertListCPRx.containsKey(LocalKey))
                    upsertListCPRx.put(LocalKey,(new ControlPlanRxplan__c(TPID__c=notifstd.PlanId__c,PSUID__c=notifstd.PSUID__c,NotificationStandard__c=notifstd.Id,CRD__c=crdrec.Id,Control__c=notifstd.Control__c,EffectiveDate__c=notifstd.EffectiveDate__c,Key__c=LocalKey,Plan__c=notifstd.Plan__c,RxplanId__c=notifstd.Rxplanid__c,crdEffectiveDate__c=crdrec.Effective_Start_Date__c,NotificationTimeStamp__c=notifstd.CreatedDate,ControlPlanEffective__c=notifstd.ControlPlanEffective__c)));
            }
        }
       FoundRxplanids.add(crdrxplan);//adding all rxplanids, since this is a set we eliminate dupes
        
     }
     handleCPRxDML(upsertListCPRx);
     
     //Cleanup
       upsertListCPRX.clear();
     //End cleanup
    //-------------------STEP3: Notifications with NEW RxplanIds.--------------------------------------
    //TODO: Do we have to check all notificaitons for the rxplanid? or just check the last one?
    //TODO: do we check for existing cases?- May be with controlplaneffective and then same rxplanid?
    Map<Id,List<NotificationStandard__c>> casectrlplanInsertMap=new Map<Id,List<NotificationStandard__c>>();
    Set<String> ctrlplaneffVisited=new Set<String>();
    Set<String> NotFoundRxplanIds=new Set<String>();
    Set<String> NewRxplansWcases=new Set<String>();
     insertList_case.clear();
    
    //Finding Rxplanids without a CRD... 
    for(String rxplan:NotifMap.keyset()){
     if(!FoundRxplanIds.contains(rxplan))//It's in not in the found set. Adding case
       //insertList_case.add(createcase(NotifMap.get(rxplan)[0])); //Rxplan doesn't even exist, only picking the first one.
       NotFoundRxplanIds.add(rxplan);
    }
    //-------------------STEP 3.a: New Rxplands WITH existing NOT OPEN cases--------------------------------------
     //Added for Feb15,2014 release
     //these notifications are to be ignored. These cases are already created
     List<List<NotificationStandard__c>> notifwithNewRxplanNotOpenCases=new list<list<NotificationStandard__c>>();
     for(case c:[SELECT Rxplanid1__c FROM Case WHERE open__c=false AND (RecordTypeId=:InternalRecordId or RecordTypeId=:EventRecordId) AND Rxplanid1__c IN :NotFoundRxplanIds AND CaseAutomationReason__c='AIPkgNewRxplanid']){
        
        if(NotFoundRxplanIds.contains(c.Rxplanid1__c)){ //only need to do once per rxplanid, this handles instances where we have more than one case with same rxplanid.
        //Add to ControlPlanRxPlan.
             notifwithNewRxplanNotOpenCases.add(NotifMap.get(c.Rxplanid1__c));  
        //marking records as processed
             for(NotificationStandard__c nstd:NotifMap.get(c.rxplanid1__c)){
                nstd.Processed__c=true;
                notifstdUpdateList.add(nstd);
             }
            NotFoundRxplanIds.remove(c.Rxplanid1__c); //removing so Steps 3.b and greater will not read these notifications.             
        }
        
     }

     
    populatePkgControlPlanLookup2(notifwithNewRxplanNotOpenCases);//making into a list of lists for the method.
     
     
    //-------------------STEP 3.b: New Rxplands WITH existing cases--------------------------------------
    //get all cases with new rxplanids in notfound list. =>There are already cases saying that with new rxplanid message.
    For(case c:[SELECT Rxplanid1__c FROM Case WHERE open__c=True AND RecordTypeId=:InternalRecordId AND Rxplanid1__c IN :NotFoundRxplanIds AND CaseAutomationReason__c='AIPkgNewRxplanid']){
        NewRxplansWcases.add(c.Rxplanid1__c);
        //Insert Controlplans for existing case.
        for(NotificationStandard__c nstd:notifMap.get(c.rxplanid1__c)){ //For each rxpland inside existing cases loop.
            nstd.Processed__c=true;
            notifstdUpdateList.add(nstd);
            List<NotificationStandard__c> NSLocal3=new List<NotificationStandard__c>();
            if(!ctrlplaneffVisited.contains(c.rxplanid1__c+nstd.ControlPlanEffective__c)){ //Not yet added.
               ctrlplaneffVisited.add(c.rxplanid1__c+nstd.ControlPlanEffective__c); //if more than one rxplanid shares a controlplaneffective.this should handle it
               If(casectrlplanInsertMap.containsKey(c.Id))
                    NSLocal3=casectrlplanInsertMap.get(c.Id);
               NSLocal3.add(nstd);
               casectrlplanInsertMap.put(c.Id,NSLocal3); //Since we retrieved by createdDate DESC, we only need one-i.e latest for control plan.
            }
            else
              continue; //we only need one record for controlplaneffective combination.
        }
    }
    
    //-----------------STEP 3.c: New Rxplands WITHOUT existing cases.
    For(string rxplan:NotFoundRxplanIds){ //for each new rxplanid
        if(!NewRxplansWcases.contains(rxplan)) //is there an existing case?
           insertList_case.add(createcase(rxplan,NotifMap.get(rxplan)[0].Acquisition_Indicator__c)); //Rxplan doesn't even exist. Creating case.
        else //There is already a case for this. This was handled in 3.a
          continue;
          
    }
    insert insertList_case;
    //cleaning....
        NewRxplansWcases.clear();
        ctrlplaneffVisited.clear();
    //end cleaning...
    
    //mark notificationStandard records.
    for(case c:insertList_case){
        for(NotificationStandard__c nstd:notifMap.get(c.rxplanid1__c)){ //For each new case rxplanid
            nstd.Processed__c=True;
            notifstdUpdateList.add(nstd);
            List<NotificationStandard__c> NSLocal4=new List<NotificationStandard__c>();
            if(!ctrlplaneffVisited.contains(c.rxplanid1__c+nstd.ControlPlanEffective__c)){ //Not yet added.
               ctrlplaneffVisited.add(c.rxplanid1__c+nstd.ControlPlanEffective__c);
               If(casectrlplanInsertMap.containsKey(c.Id))
                    NSLocal4=casectrlplanInsertMap.get(c.Id);
               NSLocal4.add(nstd);
               casectrlplanInsertMap.put(c.Id,NSLocal4); //Since we retrieved by createdDate DESC, we only need one-i.e latest for control plan.
            }
            else
              continue; //we only need one record for controlplaneffective combination.
        }
    }
    
    //doing DML for both 3.b and 3.c
    handleCaseCtrlPlanDML(casectrlplanInsertMap);
    update notifstdUpdateList;
    
    //end execution garbage collection will initiate.
        
   }//End execute Method.
   
   
   global void finish (Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, CreatedDate, CreatedById, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob  WHERE Id =:BC.getJobId()];
        JobLogger.endBatch(System.now(),NULL,'Completed TradStdPkg process.',Userinfo.getUserId(),true,'CaseAutomation',a);
        CaseAuto_BatchLinker cab=new CaseAuto_BatchLinker();
        cab.callNext('BAT_TradStdPkgProcessor');
   }//End execute Method.
   
   //============================
   // Member variabels   
   //============================
   
  
   //=============================
   // Member Methods  
   //=============================
   
   // Method Name:handleCPRxDML
   // Arguments:
   // Return:
   // Description:
   private void handleCPRxDML(Map<string,ControlPlanRxplan__c> argupMap){
    List<Id> nsList=new List<Id>();
    List<Id> updateNsList=new List<Id>();
    List<NotificationStandard__c> updateNotificationList=new List<NotificationStandard__c>();
    Set<String> existingTradPkgLookupKeys=new Set<String>();
    List<Id> insertedTradPkgLookupIds=new List<id>();
    Set<string> uniqueErrorMessages=new set<String>();
    
    //---STEP1,2--------Find existing traditionalpkglookup table entries for this key and remove it.
    for(ControlPlanRxplan__c cpr:[SELECT Key__c FROM ControlPlanRxplan__c WHERE Key__c IN:argupMap.keyset()]){ //We don't need to insert if there is already an entry for it.
        argupMap.remove(cpr.key__c);
    }
    
   
    //---STEP3_1---------Doing  inserts
    if(System.Label.PerformanceMode.equalsIgnoreCase('False')){ //set to True to enable faster DMLs.
        //---step3_1.a
        Database.Saveresult[] CPRxInsertResults=Database.Insert(argupMap.values(),false);
        for(Database.SaveResult sr:CPRxInsertResults){
            if(sr.isSuccess()){
                insertedTradPkgLookupIds.add(sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()) {
                   uniqueErrorMessages.add(err.getMessage());
                }
            }
        }
        //---step3.b--Find records that did not succeed.
        for(ControlPlanRxplan__c c1:[SELECT key__c FROM ControlPlanRxplan__c WHERE Id IN:insertedTradPkgLookupIds]){
        //insert errorrecord with all the unique error messages.
        //Now we have both success inserts and unique error messages.
            argupMap.remove(c1.key__c); //at the end argupmap will only have failed ones.
        }
        
        List<Error_Log__c> errorList=new List<Error_Log__c>();
        for(ControlPlanRxPlan__c c2:argupMap.values()){
            //insert records errorlog records
            errorList.add(ErrorLogger.getRecord('Error inserting into TradPkgLookup','3','BCTCaseAutomation','Performance=false.This casecontrolplan record did not succeed:'+JSON.serialize(c2),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdPkgProcessor', 240,'solipurams@aetna.com'));
        }
        insert errorList;
    }
    else{//STEP3_2. Alternate flow: Performance Mode enabled. Doing inserts
           try{
                insert argupMap.values();
           }catch(exception e){
            //insert error record here.
               If(e.getTypeName()=='DmlException')
                 system.debug(logginglevel.error,'FATAL Exception: TradStdProcessing with PerformanceMode enabled.Msg:'+e.getMessage());
               else
                insert ErrorLogger.getRecord('Error inserting into TradPkgLookup','3','BCTCaseAutomation','Inserting case controlplans.Performance=true. Exception obj:'+JSON.serializePretty(e),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdPkgProcessor', 252,'solipurams@aetna.com');
           }
    }
    /*
    Database.UpsertResult[] errorUpsertRes=Database.upsert(ArgupMap.values(),controlplanRxplan__c.Fields.key__c,False);
        for(Database.UpsertResult DMLresult:errorUpsertRes){
            if(DMLresult.isSuccess())//Adding records that were successful. For marking processed.
              updateNsList.add(DMLresult.getId());
        }
        
        for(controlplanRxplan__c cpr:[SELECT NotificationStandard__c FROM controlplanRxplan__c WHERE Id IN:updateNsList AND isDeleted=False]){
            nsList.add(cpr.NotificationStandard__c);
        }
        for(NotificationStandard__c nsrecord:[select processed__c from NotificationStandard__c where Id IN:nsList]){
            nsrecord.Processed__c=True;
            updateNotificationList.add(nsrecord);
        }   
        
        update updateNotificationList; //TODO: implement error handling...
     */
        
   }
   
     // Method Name:createCase
   // Arguments:new rxplanid
   // Return:new case created for rxplanid
   // Description:this method calls createcase module
   private case createCase(String rxplanid,string AcqIndicator){
    //populate case with required information
       CreateCase casecreator=new CreateCase();
       Case c=casecreator.pullPackageplan(rxplanid);
       if(c.subject=='This is a new traditional rxplanid')  /* 06822   : 158685 :  ST#1825-Update FIFO Tags via case automation batch process   */
       {
           c.FIFO_Tag__c='General';
       }
       
       string acqInd='';
       if(AcqIndicator==NULL||AcqIndicator=='00'||AcqIndicator=='')
           acqInd='No';
       else
           acqInd='Yes';
       c.Acquisition_Indicator__c=acqInd;
       
       return c;         
   }
   
    // Method Name:handleCaseCtrlPlanDML
   // Arguments:
   // Return:
   // Description:
   private void handleCaseCtrlPlanDML(Map<ID,List<NotificationStandard__c>> ccpInsertMap){
    //TODO: add check for existing elements
    //Create casecontrolplan record from the first record for each key and insert them.
    CreateCase caseCreator=new CreateCase();
    Map<String,CaseControlPlan__c> InsertMap_cctrlplan=new Map<String,CaseControlPlan__c>();
    Set<String> uniqueErrorMessages=new Set<String>();
    List<Id> insertedCCPIds=new List<id>();
    //List<CaseControlPlan__c> existingccplan=[SELECT key__c,FROM WHERE]; 
    //Filter out records with casecontrolplan elements where timestamp on the record is greater than corresponding notificationfallout in this map values.(Have same Key)
        for(Id caseId:ccpInsertMap.keyset()){
            //For each controlplaneffective date, there would be only one record in this map but still doing map anyway.
            for(NotificationStandard__c nsRec:ccpInsertMap.get(caseId)){//do for each cpe combo under a caseId
                if(!InsertMap_cctrlplan.containsKey(nsRec.ControlPlanEffective__c+caseId)){ //making sure we only do one.
                    InsertMap_cctrlplan.put(nsRec.ControlPlanEffective__c+caseId,new CaseControlPlan__c(benefitsString__c=nsRec.benefitsString__c,
                                                                benefitsStringExtension__c=nsRec.benefitsStringExtension__c,
                                                                CarrierId__c=nsRec.CarrierId__c,
                                                                ControlPlan__c=caseCreator.cpformat(nsRec.ControlPlan__c),
                                                                ControlPlanEffective__c=nsRec.ControlPlanEffective__c,
                                                                effectiveDate__c=nsRec.effectiveDate__c,
                                                                ERB__c=nsRec.ERB__c,
                                                                ErrorDescription__c=nsRec.ErrorDescription__c,
                                                                FundingType__c=nsRec.FundingType__c,
                                                                PlanId__c=nsRec.PlanId__c,
                                                                pricingSchedule__c=nsRec.pricingSchedule__c,
                                                                PSUID__c=nsRec.PSUID__c,
                                                                riskIndicator__c=nsRec.riskIndicator__c,
                                                                rxPlanBlock__c=nsRec.rxPlanBlock__c,
                                                                Subsegment__c=nsRec.Subsegment__c,
                                                                TermDate__c=nsRec.TermDate__c,
                                                                tieredRxPlanBlock__c=nsRec.tieredRxPlanBlock__c,
                                                                traditionalHierarchy__c=nsRec.traditionalHierarchy__c,
                                                                TypeOfPlan__c=nsRec.TypeOfPlan__c,
                                                                Case__c=caseId,
                                                                NotificationTimeStamp__c=nsRec.CreatedDate,
                                                                key__c=nsRec.ControlPlanEffective__c+caseId
                                                                ));
                }
            }
                                                            
        } 
        
        //remove entries with existing casecontrolplanr records with timestamp
        for(CaseControlPlan__c c3:[SELECT Key__c,NotificationTimeStamp__c FROM CaseControlPlan__c WHERE Key__c IN :InsertMap_cctrlplan.keyset()]){
            if(c3.NotificationTimeStamp__c!=NULL&&c3.NotificationTimeStamp__c>=InsertMap_cctrlplan.get(c3.key__c).NotificationTimeStamp__c) //Timestamp on the controlplan record is greater. Ignore this record
                InsertMap_cctrlplan.remove(c3.key__c);
        }
      
      //-----DML Operation with choice of errorhandling.
      if(!System.Label.PerformanceMode.equalsIgnoreCase('False')){    
           Try{
                upsert InsertMap_cctrlplan.values() key__c;
           }Catch(Exception e){
               If(e.getTypeName()=='DmlException')
                 system.debug(logginglevel.error,'FATAL Exception: TradStdProcessing with PerformanceMode enabled.Msg:'+e.getMessage());
               else
                  insert ErrorLogger.getRecord('Error inserting into casecontrolplan','5','BCTCaseAutomation','Performance=true'+JSON.serializePretty(e),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdPkgProcessor', 343,'solipurams@aetna.com');
                  
           }
      }Else{//Performance mode disabled. Doing advanced error handling
              //Use Database.Insert
               Database.UpsertResult[] CaseControlPlanResult=Database.Upsert(InsertMap_cctrlplan.values(),CaseControlPlan__c.Fields.key__c,false);
                for(Database.UpsertResult sr:CaseControlPlanResult){
                    if(sr.isSuccess()){
                        insertedCCPIds.add(sr.getId());
                    }
                    else{
                        for(Database.Error err : sr.getErrors()) {
                           uniqueErrorMessages.add(err.getMessage());
                        }
                    }
                }
                //---step3.b--Find records that did not succeed.
                for(CaseControlPlan__c c4:[SELECT Key__c FROM CaseControlplan__c WHERE Id IN:insertedCCPIds]){
                //insert errorrecord with all the unique error messages.
                //Now we have both success inserts and unique error messages.
                    InsertMap_cctrlplan.remove(c4.key__c); //at the end argupmap will only have failed ones.
                }
                
                List<Error_Log__c> errorList=new List<Error_Log__c>();
                for(CaseControlPlan__c c5:InsertMap_cctrlplan.values()){
                    //insert records errorlog records
                    errorList.add(ErrorLogger.getRecord('Error inserting into casecontrolplan','4','BCTCaseAutomation','Performance=false.This casecontrolplan record failed:'+JSON.serializePretty(c5)+' Unique Errors-'+JSON.serializePretty(uniqueErrorMessages),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdPkgProcessor', 369,'solipurams@aetna.com'));
                }
                insert errorList;
      }
      populatePkgControlPlanLookup2(ccpInsertMap.values()); // add to Sr2 table.      
   }
   // Method Name:Sri2 table
   // Arguments:
   // Return: 
   // Description:
   private void populatePkgControlPlanLookup2(List<List<NotificationStandard__c>> NotifStandwNewccpInserts){
    //TODO: at what point of time do we move records on sri2 to sri1 table?
     Map<string,TradPkgControlPlanLookup2s__c> upsertListCPRx2=new Map<String,TradPkgControlPlanLookup2s__c>();
     for(List<NotificationStandard__c> nsList:notifStandwNewccpInserts){
      //for each notifstandard that has a ccp record inserted,prepare upsert list. 
          for(NotificationStandard__c notifstd:nsList){
            String Localkey=notifstd.PSUID__c+notifstd.ControlPlanEffective__c+notifstd.Rxplanid__c;
            if(!upsertListCPRx2.containsKey(LocalKey)) //only need the latest one.
                upsertListCPRx2.put(LocalKey,new TradPkgControlPlanLookup2s__c(TPID__c=notifstd.PlanId__c,PSUID__c=notifstd.PSUID__c,Control__c=notifstd.Control__c,EffectiveDate__c=notifstd.EffectiveDate__c,Key__c=LocalKey,Plan__c=notifstd.Plan__c,RxplanId__c=notifstd.Rxplanid__c,NotificationTimeStamp__c=notifstd.CreatedDate,ControlPlanEffective__c=notifstd.ControlPlanEffective__c) );
          }
     }
      //removing existing records.
      for(TradPkgControlPlanLookup2s__c tradlk2:[SELECT key__c FROM TradPkgControlPlanLookup2s__c where Key__c IN :upsertListCPRx2.keyset()]){
           upsertListCPRx2.remove(tradlk2.Key__c);
      }
      insert upsertListCPRx2.values(); //changed to insert checking for existing anyway.
   }
}//End class BAT_TradStdPkgProcessor