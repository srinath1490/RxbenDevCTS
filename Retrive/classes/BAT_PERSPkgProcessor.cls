global without sharing class BAT_PERSPkgProcessor implements Database.Batchable<sObject>{
//=============================
   // Meta Information
   //=============================	
   // Namespace or Enhancement:SFDC8533b
   // Description:Scheduled class designed to call: Part of PERS report processing. PACKAGE.
   // Called by:BAT_TradNPkgProcessor
  
   /*==================================================================================
   Version				Author			Date			Reason
   1.0					Saraag			Sep30,2013		Created	
   2.0					Saraag          Mar27,2013      If a controlplan is not found under a case, look at pers package plan and mark those processed. Going live 5/30
   ====================================================================================*/
	 //Class Variables
          //DataType                                                Name                             Description
 		    String 											        QString;                        //Query string for start method
 			Map<String,List<PERS_report__c>> 				        PERSmap;						//Map for consolidating notification records at controlPlaneffectivedate level.
 			Id 														eventNotifRecordId;				//Used to hold evennotification recordtypeId
 			Map<string,set<string>>									cp_cpeMap;						//map between controlplan and controlplaneffective	
 			Map<string,Set<string>>									cp_cpeNonFormattedMap;			//Map between controlplan and controlplaneffective without leading zeros or underscores.
 		 	Id                                                      InternalRecordId;             //Used to hold internal CRD GMF recordtypeId
	//============================
   // Constructor
   //============================
   global BAT_PERSPkgProcessor(String Q){
   		QString=Q;
   		PERSMap=new Map<String,List<PERS_report__c>>();
   		eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
		InternalRecordId=(Id)[select Id from recordtype where DeveloperName='Internal_CRD_GMF_Process' LIMIT 1][0].Id;
   }//End constructor
      
   //============================
   // Interface Methods 
   //============================
   global Database.QueryLocator start (Database.BatchableContext BC){
        JobLogger.startBatch(NULL, 'Starting PERSPkg', userinfo.getUserId(), system.now(), true, 'BCTCaseAutomation');	   	
   		 return Database.getQueryLocator(QString);
   }//End execute Method.
   
   
   global void execute (Database.BatchableContext BC,List<PERS_report__c> scope){
   	cp_cpeNonFormattedMap=new Map<string,set<string>>();
   	List<PERS_report__c> PersUpdateList=new List<PERS_report__c>();
   	cp_cpeMap=new Map<string,set<string>>();
   	//-------------------STEP0: Refetch records order by createddate.--------------------------------------
       List<PERS_report__c> BatchScope;
       List<Id> BatchIds=new List<Id>();
       // Refresh records and order by createddate.
         //collect all Ids
         for(PERS_report__c n:scope){
            BatchIds.add(n.Id);
         }
         Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
        //get all field names
        Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
        String qry='';
        for(String s:FieldsMap.keyset()){
           qry+=s+',';
        }
        qry=qry.left(qry.length()-1); //removing the extra comma
        if(BatchIds!=NULL&&BatchIds.size()>0)         
       		 Batchscope=Database.query('SELECT '+qry+' FROM PERS_report__c WHERE Id IN:BatchIds ORDER BY NAME DESC');
       	else
       		 Batchscope=new List<PERS_report__c>();
        //clearing out scope
        scope.clear(); 
   	
   	//-------------------STEP1: Consolidate notifications at ControlPlaneffective level.--------------------------------------
   		for(PERS_report__c cprx:Batchscope){//Do for each notification record in scope
	   			List<PERS_report__c> CPrxLocal=new List<PERS_report__c>();
	   			Set<string> cpeLocalSet=new Set<string>();
	   			
	   		//populating cp_cpeMap
	   		if(cp_cpeMap.containskey(cprx.CA_controlplan__c)){
	   			cpeLocalSet=cp_cpeMap.get(cprx.CA_controlplan__c);
	   			cpeLocalSet.add(cprx.ControlPlanEffective__c);
	   		}
	   		else
	   		  cpeLocalSet.add(cprx.ControlPlanEffective__c);
	   		  
	   		 cp_cpeMap.put(cprx.CA_controlplan__c,cpeLocalSet); 
	   		//end populating cp_cpeMap
	   		
	   		//populating cp_cpeNonFormattedMap
	   		set<string> cpeNoFormat=new set<string>();
	   			string ctrlpl=cprx.ControlPlanEffective__c.substring(0,cprx.controlplaneffective__c.length()-10);
	   			if(cp_cpeNonFormattedMap.containskey(ctrlpl)){
	   			cpeNoFormat=cp_cpeNonFormattedMap.get(ctrlpl);
	   			cpeNoFormat.add(cprx.ControlPlanEffective__c);
	   			}
	   			else
	   		 	 cpeNoFormat.add(cprx.ControlPlanEffective__c);
	   		  
	   			 cp_cpeNonFormattedMap.put(ctrlpl,cpeNoFormat); 
	   		//end populating
	   		
	   		//check if it already exists
	   		If(PERSMap.containsKey(cprx.ControlPlanEffective__c)){
	   		   CprxLocal=PERSMap.get(cprx.ControlPlanEffective__c); //adding to list of notifications
	   		   cprxLocal.add(cprx);
	   		 }
	   		 else //Encountered controlplaneffective combination for the first time
	   		   cprxLocal.add(cprx);
	   		   
	   		PERSMap.put(cprx.ControlPlanEffective__c,cprxLocal);
	   		
	   	}
	   	
	   	//cleanup...
	   	    Batchscope.clear();
	   	//end cleanup...
   	//-------------------STEP2: Finding Open cases.--------------------------------------
   	Map<string,Id> caseMap=new Map<string,Id>();
   	Set<string> foundControlPlans=new Set<String>();
   	List<Id> caseLocalId=new List<Id>();
   	Map<string,Provisional_Lines__c> upsertMap_PovLine=new Map<string,Provisional_Lines__c>();
   	//Find all opencases created by Fallout processor.
   
   		//for all open cases. Build cases at controlplaneffective level and also a list of controlplaneffective in report with a case.
   	Map<String,set<id>> cpeCaseId=new Map<String,set<Id>>();
   	for(CaseControlPlan__c cctrlpl:[select ControlPlanEffective__c,case__c,controlplan__c from CaseControlPlan__c where controlplan__c IN:cp_cpeMap.keyset() AND Case__r.CaseAutomationReason__c='AIPkgNewRxplanid' AND Case__r.Open__c=true AND (Case__r.RecordTypeId=:eventNotifRecordId OR Case__r.RecordTypeId=:InternalRecordId)])	{
   		set<id> caseLocalSet=new set<id>();
   		if(cpeCaseId.containsKey(cctrlpl.controlplan__c)){
   			caselocalset=cpecaseId.get(cctrlpl.controlplan__c);
   			caseLocalset.add(cctrlpl.case__c);
   		}
   		else
   		  caseLocalset.add(cctrlpl.case__c);
   		
   		cpeCaseId.put(cctrlpl.controlplan__c,caseLocalset); //getting cp,caseid
   		
   	}
   	
   	for(string s:cpeCaseId.keyset()){ //s here is control_plan. 
   		foundControlPlans.add(s);
   		for(string cpe:cp_cpeMap.get(s)){//get all controlplaneffective values for a controlplan value
	   		for(PERS_report__c pvL:PERSmap.get(cpe)){
	   			     pvL.Processed__c=true;
	   			     PersUpdateList.add(pvL);
	   			     for(Id caseId:cpeCaseId.get(s)){ //do for each case record for the controlplan
		   			     if(!upsertMap_PovLine.containsKey(caseId+String.valueOf(pvL.NEW_PROV_NUM__c)))//ordered by createddate. Lastest record has the new value.
		   			   		upsertMap_PovLine.put(caseId+String.valueOf(pvL.NEW_PROV_NUM__c),PVLineCreator(pvL,caseId));
	   			     }
	   		}
   		}
   	}
   	
   	
    handleProvLineDML(upsertMap_PovLine);
    upsertMap_PovLine.clear();
    
    //If a controlplan is not found under a case, look at pers package plan lookup table 1 and table 2 and mark those processed. Going live 5/30
      //get all traditional package lookup table entries for both lookup1 and lookup[2]
      
      //Collect controlplans with either a traditional pkg lkp1 or traditional pkg lkp2 entries.
      set<string> controlplansEffWlkp=new set<string>();
      for(ControlPlanRxPlan__c tradpkglkp1:[SELECT ControlPlan__c FROM ControlPlanRxPlan__c WHERE ControlPlan__c IN:cp_cpeNonFormattedMap.keyset()]){
      	controlplansEffWlkp.addall(cp_cpeNonFormattedMap.get(tradpkglkp1.controlplan__c)); //collecting CPEs that have a lookup entry.
      }
      
      for(TradPkgControlPlanLookup2s__c tradpkglookup2:[SELECT ControlPlan__c FROM TradPkgControlPlanLookup2s__c WHERE ControlPlan__c IN:cp_cpeNonFormattedMap.keyset()]){
      	controlplansEffWlkp.addall(cp_cpeNonFormattedMap.get(tradpkglookup2.controlplan__c)); //collecting CPEs that have a lookup entry.
      }
      //Mark persreport with CPE under CP that has a traditional pkg lkp1 or lkp2 entries as processed.
      for(string cpe:controlplansEffWlkp){//get all controlplaneffective values for a controlplan value
	   		for(PERS_report__c pvL:PERSmap.get(cpe)){
	   			     pvL.Processed__c=true;
	   			     PersUpdateList.add(pvL);
	   			     
	   		}
      	
   	  }
    //end 5-30 change
    
    
    set<pers_report__c> dedupeset=new set<pers_report__c>();
    dedupeset.addall(PersUpdateList);
    PersUpdateList.clear();
    PersUpdateList.addAll(dedupeset);
    
    update PersUpdateList; //markign them as processed.  	
   }//End execute Method.
   
   
   global void finish (Database.BatchableContext BC){
   		  AsyncApexJob a = [Select Id, CreatedDate, CreatedById, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob  WHERE Id =:BC.getJobId()];
   		  JobLogger.endBatch(System.now(),NULL,'Completed PERSPkgPorcessing.',Userinfo.getUserId(),true,'CaseAutomation',a);
   		  CaseAuto_BatchLinker cab=new CaseAuto_BatchLinker();
   		  cab.callNext('BAT_PERSPkgProcessor');
   }//End execute Method.
     
  
   //=============================
   // Member Methods  
   //=============================
  
   
    // Method Name:handleProvLineDML
   // Arguments:List of Provisional Line records
   // Return:None
   // Description:
   private void handleProvLineDML(Map<string,Provisional_Lines__c> upsertMap_pvl){
   		ProvLineDomain.handleProvLineDML(upsertMap_pvl);
   }
   
    // Method Name:PVLineCreator
   // Arguments:1 pers record, case Id
   // Return:1pv line record
   // Description:
   //TODO:implement
   
   private Provisional_Lines__c PVLineCreator(PERS_report__c persrec,Id caseId){
   	  return ProvLineDomain.getRecord(persrec,caseid);
   	  
   }
   
}//End class BAT_PERSPkgProcessor