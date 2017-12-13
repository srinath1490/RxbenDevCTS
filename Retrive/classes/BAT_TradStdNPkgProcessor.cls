global without sharing class BAT_TradStdNPkgProcessor implements Database.Batchable<sObject>{
   //=============================
   // Meta Information
   //=============================	
   // Namespace or Enhancement:SFDC8533b
   // Description:Scheduled class designed to call
   // Called by:
  
   /*==================================================================================
   Version			Author							Date					Reason
   1.0				Saraag							Sep29,2013  			Created	
   ====================================================================================*/
	 //Class Variables
          //DataType                                                Name                             Description
 		    String 											        QString;                        //Query string for start method
 			Map<String,List<NotificationStandard__c>> 				Notifmap;						//Map for consolidating notification records at controlPlaneffectivedate level.
 			Id 														eventNotifRecordId;				//Used to hold evennotification recordtypeId	
 			Set<String> 											FoundCtrlPlanEffinCase;         //ControlPlaneffectives for which there are existing 'open' cases.
 			Map<Id,NotificationStandard__c>							UpdateMap_NotificationStd;		//update list for marking processed.
 			Map<string,TraditionalNonPkgLookup__c>				    LookuptableMap;					//Holds nonpackage lookup table map.
	 	
   //============================
   // Constructor
   //============================
   global BAT_TradStdNPkgProcessor(String Q){
		QString=Q;
   		NotifMap=new Map<String,List<NotificationStandard__c>>();
   		eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
   }//End constructor
      
   //============================
   // Interface Methods 
   //============================
   global Database.QueryLocator start (Database.BatchableContext BC){
   		 JobLogger.startBatch(NULL, 'Starting TradStdNpkgProcess', userinfo.getUserId(), system.now(), true, 'BCTCaseAutomation');   	  		
   		 return Database.getQueryLocator(QString);
   }//End execute Method.
   
   
   global void execute (Database.BatchableContext BC,List<NotificationStandard__c> scope){
   	Map<String,Set<TraditionalNonPkgLookup__c>> lkpCPMap=new Map<string,set<TraditionalNonPkgLookup__c>>();
   	Set<Id> crdIds=new Set<id>();
   	UpdateMap_NotificationStd=new Map<id,NotificationStandard__c>();
   	Set<String> NotifCPEwCRD=new set<string>();//Used to find ControlPlanEffective keys in Notifications that have a CRD.
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
   	//-------------------STEP1: Consolidate at CPE level.--------------------------------------
   		for(NotificationStandard__c NS:Batchscope){//Do for each notification record in scope
   			if(NS.ControlPlanEffective__c!=null&&NS.ControlPlanEffective__c!=''&&NS.Rxplanid__c!=null&&NS.Rxplanid__c!=''){
	   			List<NotificationStandard__c> NSLocal=new List<NotificationStandard__c>();
		   		//check if it already exists
		   		If(NotifMap.containsKey(NS.ControlPlanEffective__c)){
		   		   NSLocal=NotifMap.get(NS.ControlPlanEffective__c); //adding to list of notifications
		   		   NSLocal.add(NS);
		   		 }
		   		 else //Encountered controlplaneffective combination for the first time
		   		   NSLocal.add(NS);
		   		   
		   		NotifMap.put(NS.ControlPlanEffective__c,NSLocal);
   			}
	   	}
	   //	Batchscope.clear();
   	//-------------------STEP2: Find CRD at ControlPlan level.--------------------------------------
   /*for(CSAP_CGLP_Junction__c csapJuncrec:[SELECT Id,crd__c,ControlPlanEffective__c FROM CSAP_CGLP_Junction__c WHERE Partial_Control_Group__c!=NULL AND CRD__c!=NULL AND isDeleted=False AND ControlPlanEffective__c IN:NotifMap.keyset()]){
   	if(crdMap.containsKey(csapJuncrec.ControlPlanEffective__c)){
   		crdLocalset=crdMap.get(csapJuncrec.ControlPlanEffective__c);
   		crdLocalSet.add(csapJuncrec.crd__c);
   		crdIds.add(csapJuncrec.crd__c);
   	}
   	else{
   	   crdLocalSet.add(csapJuncrec.crd__c);
   	   crdIds.add(csapJuncrec.crd__c);
   	}
   	   
    crdMap.put(csapJuncrec.ControlPlanEffective__c,crdLocalSet);	
   }*/
   //Changed to finding using nonpackagelookuptable.
   for(TraditionalNonPkgLookup__c nplookup:[SELECT CRD__c,ControlPlanEffective__c FROM TraditionalNonPkgLookup__c WHERE CRD__c!=NULL  AND CRD__r.Effective_Start_Date__c!=NULL AND isDeleted=False AND ControlPlanEffective__c IN:NotifMap.keyset()]){ //if there is no CRD, do not look at it.
  /* 	 Set<Id> crdLocalSet=new Set<Id>();
   	
   	  if(crdMap.containsKey(nplookup.ControlPlanEffective__c)){
   		crdLocalset=crdMap.get(nplookup.ControlPlanEffective__c);
   		crdLocalSet.add(nplookup.crd__c);
   		crdIds.add(nplookup.crd__c);
   	}
   	else{
   	   crdLocalSet.add(nplookup.crd__c);
   	   crdIds.add(nplookup.crd__c);
   	}
   	*/
   	NotifCPEwCRD.add(nplookup.ControlPlanEffective__c);//add to the CRD found set.   
    //crdMap.put(nplookup.ControlPlanEffective__c,crdLocalSet);	
   }
   
   //FEB 15 TODO: Mark all notifications with a lookup table entry as processed. These notifications will not be processed further.
    Map<string,Set<String>> cpTocpeMap_NCRD= new Map<string,set<string>>();
    set<string> cpesunderCP;
   	for(string foundCPE:NotifCPEwCRD){
   		for(NotificationStandard__c nse:NotifMap.get(foundCPE)){ //mark all notifictions under this CPE as processed.
     			nse.processed__c=true;
     			UpdateMap_NotificationStd.put(nse.Id,nse);
     		}
     		
   	}
   
    //-------------------STEP3: Find CRDs based on Control+Plan---------------------------------
    
    // step 3.a: mark notifications and find CPs without CRD and build CP to CPE map
     set<String> noCRDCPE=new set<string>();
     for(String s1:NotifMap.keyset()){ //for each cpe in Notifications, check if we found a crd record.
     	if(!NotifCPEwCRD.contains(s1)){ //does not exist in found list, so this new CPE.
     		for(NotificationStandard__c nse:NotifMap.get(s1)){ //mark all notifictions under this CPE as processed.
     			nse.processed__c=true;
     			UpdateMap_NotificationStd.put(nse.Id,nse);
     		}
     		cpesunderCP=new set<string>();
     		string cpLocal=s1.substring(0,s1.length()-10);
     		If(cpTocpeMap_NCRD.containsKey(cpLocal)){
		   		   cpesunderCP=cpTocpeMap_NCRD.get(cpLocal); //adding to list of notifications
		   		   cpesunderCP.add(s1);
		   		 }
		   		 else //Encountered controlplaneffective combination for the first time
		   		   cpesunderCP.add(s1);
		   		   
     		cpTocpeMap_NCRD.put(cpLocal,cpesunderCP); //cp->cpe
     		noCRDCPE.add(s1);//set of CPEs without CRD.
     		//noCRDCPEcases.add(createcaseCPEmismatch(NotifMap.get(s1)[0]));   FEB 15 release. No more cases.
     	}
     }
     
     
    //Feb 15: Find rows based on controlplans,Find closest and  check if there are nonpkglookup entries for Notification using ControlPlanEffective, found row's CRD or insert.
     //--- step3.b: Find rows based off control+plan and create a map.
     for(TraditionalNonPkgLookup__c nplookup:[SELECT CRD__c,ControlPlanEffective__c,ControlPlan__c,effectiveDate__c FROM TraditionalNonPkgLookup__c WHERE CRD__c!=NULL  AND ControlPlan__c IN:cpTocpeMap_NCRD.keyset()]){ //getting rows based on cp without a crd.
     	
   	 	  Set<TraditionalNonPkgLookup__c> lkpLocalSet=new Set<TraditionalNonPkgLookup__c>();
   	
	   	  if(lkpCPMap.containsKey(nplookup.ControlPlan__c)){
	   		lkpLocalSet=lkpCPMap.get(nplookup.ControlPlan__c);
	   		lkpLocalSet.add(nplookup);
	   	  }
		   	else{
		   	   lkpLocalSet.add(nplookup);
		   	}
	   	
	     lkpCPMap.put(nplookup.ControlPlan__c,lkpLocalSet);	// set of rows found per controlplan.
   }
   //POPULATE LOOKUP TABLE PART- WITH CRD (Based off CP)
   //--- step 3.c: Find closest row based on effective date being smaller than NotifEffectiveDate and Max among the results. Do per CP
   
  Map<string,TraditionalNonPkgLookup__c> matchedCP_CRDID=new Map<string,TraditionalNonPkgLookup__c>(); //CPE->TraditionalNonPkg Lookup row with Max eff and less that (E) of CPE
  for(string cp:lkpCPMap.keyset()){ //for each controlplan
  	for(string cpe:cpTocpeMap_NCRD.get(cp)){//get all CPEs for CP.
  		for(TraditionalNonPkgLookup__c lkprec:lkpCPMap.get(cp)){//get all matched rows per controlplan.
   			if(matchedCP_CRDID.containsKey(cpe)){//There is already an entry, check the effective date
   				if((lkprec.effectiveDate__c<=Date.valueOf(cpe.substring(cpe.length()-10,cpe.length())))&(lkprec.effectiveDate__c>matchedCP_CRDID.get(cpe).effectiveDate__c)){
   				    //crdIdMaxEffectiveDate.put(s,crdMapDetail.get(crdId).Effective_Start_Date__c);//New Maxeffectivedate
   				    matchedCP_CRDID.put(cpe,lkprec); //lkp row has effectivedate greater than what's in the map right now. Replace.
   				}
   			}
   			else{ //This is the first entry for controlplaneffective. Check if less than effective date of notification
   			  if(lkprec.effectiveDate__c<=Date.valueOf(cpe.substring(cpe.length()-10,cpe.length()))){
   			  		matchedCP_CRDID.put(cpe,lkprec);
	   				noCRDCPE.remove(cpe);// they now have a CRD match. Removing...
   			  }
   			}
   			
   		}
  	} 
  }
   //--- step 3.d: Add entries to nonpkglookup table with CRD found above.
      LookuptableMap=new Map<string,TraditionalNonPkgLookup__c>();
     	for(string s:matchedCP_CRDID.keyset()){
     		for(NotificationStandard__c nse2:NotifMap.get(s)){
     			if(!LookuptableMap.containsKey(nse2.PSUID__c+nse2.controlplaneffective__c))//need only one entry.
     			    LookuptableMap.put(nse2.PSUID__c+nse2.controlplaneffective__c,new TraditionalNonPkgLookup__c(ControlPlan__c=nse2.ControlPlanEffective__c.substring(0,nse2.ControlPlanEffective__c.length()-10),Control__c=nse2.Control__c,ControlPlanEffective__c=nse2.ControlPlanEffective__c,effectiveDate__c=nse2.effectiveDate__c,Plan__c=nse2.Plan__c,PSUID__c=nse2.PSUID__c,key__c=nse2.PSUID__c+nse2.ControlPlanEffective__c,CRD__c=matchedCP_CRDID.get(s).CRD__c));
     		}
     	}
     	     	
     //------------------------STEP4: Create lookup table entries for CPEs without direct CPE->CRD match or CP->CRD match.
     //populating nonpackagelookup table
       //LookuptableMap=new Map<string,TraditionalNonPkgLookup__c>();
   // List<case> noCRDCPEcases=new List<case>();
     	for(string s:noCRDCPE){
     		for(NotificationStandard__c nse2:NotifMap.get(s)){
     			if(!LookuptableMap.containsKey(nse2.PSUID__c+nse2.controlplaneffective__c))//need only one entry.
     			    LookuptableMap.put(nse2.PSUID__c+nse2.controlplaneffective__c,new TraditionalNonPkgLookup__c(ControlPlan__c=nse2.ControlPlanEffective__c.substring(0,nse2.ControlPlanEffective__c.length()-10),Control__c=nse2.Control__c,ControlPlanEffective__c=nse2.ControlPlanEffective__c,effectiveDate__c=nse2.effectiveDate__c,Plan__c=nse2.Plan__c,PSUID__c=nse2.PSUID__c,key__c=nse2.PSUID__c+nse2.ControlPlanEffective__c));
     		}
     	}
     	//remove existing
     	for(TraditionalNonPkgLookup__c trl:[select key__c from TraditionalNonPkgLookup__c where key__c IN :LookuptableMap.keyset()]){
     		LookuptableMap.remove(trl.key__c);
     	}
     	
     	upsert LookuptableMap.values() key__c;
     //end populating nonpackage lookup table.
/*     
     //FEB15- release removed this part of the code.
      if(noCRDCPEcases!=NULL&&!noCRDCPEcases.isEmpty()){
	     if(System.Label.PerformanceMode.equalsIgnoreCase('False')){
	     	Set<String> insertedCPEcases=new Set<String>();
	     	set<string> uniqueErrorMessages=new Set<String>();
	     	//use database methods.
	     	//step i
	     	Database.Saveresult[] insertedNoCPERes=Database.Insert(noCRDCPEcases,false); //doing partial inserts
			for(Database.SaveResult sr:insertedNoCPERes){
		    	if(sr.isSuccess()){
		    		insertedCPEcases.add(sr.getId());
		    	}
		    	else{
		    		for(Database.Error err : sr.getErrors()) {
			           uniqueErrorMessages.add(err.getMessage());
		            }
		    	}
		    }
		    
		    //step ii- find ones that succeeded.
		    list<Id> NotifCPEwCRDFailedOnes=new List<Id>();
		    for(case c:[SELECT controlplaneffective__c,id FROM case WHERE Id IN:insertedCPEcases]){
		    	noCRDCPE.remove(c.controlplaneffective__c); //Removing success ones. In the end we will only have CPEs that have no CRD and failed inserts.
		    }
		    //step iii- remove notificaitonstandard that belonged to errored out cases.
		    for(string failednoCRD_CPEs:noCRDCPE){//noCRDCPE will now only have the failed ones.
				for(NotificationStandard__c nsii:NotifMap.get(failednoCRD_CPEs)){
			    		UpdateMap_NotificationStd.remove(nsii.id);//remove all notifications with failed CPE from the update list that marks them processed.
			    }
		    }
		    //step iv-- if there are errors, log an erro record.
		    if(uniqueErrorMessages.size()>0)
		  		 insert ErrorLogger.getRecord('Error inserting Cases','4','BCTCaseAutomation','Unique Error.Performance Mode=False.Inserting case where there was CRD for CPE failed. Look at unprocessed notification with NotifcationStandard table.Errors:'+JSON.serializePretty(uniqueErrorMessages),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdNPkgProcessor', 149,'solipurams@aetna.com');
		    
	     }
	     else{ //performance mode enabled.
		     Try{
		    		insert noCRDCPEcases;
		     }Catch(Exception e){
		           	//insert error record here.
		           	   If(e.getTypeName()=='DmlException')
		           	     system.debug(logginglevel.error,'FATAL DML Exception: TradStdNPkgProcessing while inserting cases. Performance Mode=True:'+e.getMessage());
		           	   else{
		           	    	insert ErrorLogger.getRecord('Error inserting Cases','4','BCTCaseAutomation','Performance Mode=True.Inserting case where there was CRD for CPE failed. Look at unprocessed notification with NotifcationStandard table.Exception object:'+JSON.serializePretty(e),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdNPkgProcessor', 127,'solipurams@aetna.com');
		           	    	//marking notifications as not processed.
		           	    	for(Case c:noCRDCPEcases){//for each failed one.
		           	    		for(NotificationStandard__c nsErrored:NotifMap.get(c.controlPlanEffective__c)){//mark all notifications under the failed Case at CPE level
		           	    			UpdateMap_NotificationStd.remove(nsErrored.Id); //remove this notificationstd record, so it will not be marked as processed.
		           	    		}
		           	    	}
		           	   }  
		     }   
	     }
      }
    //cleaning....
      noCRDCPEcases.clear();
      NotifCPEwCRD.clear();
      noCRDCPE.clear();
    //end cleanup...
    
   	//-------------------STEP4: Find CRD with closest effective date.--------------------------------------
   	//TODO: Confirm with Surya, if we need would find multiple CRDs
   	//TODO: Confirm with Kathy, which effective field to use?Effective_Start_Date__c?
   	//TODO: make sure you do data.valueof correctly.
   	Map<Id,CRD__c> crdMapDetail=new Map<Id,CRD__c>([SELECT Id,Effective_Start_Date__c,Rxplanid__c FROM Crd__c WHERE Id IN:crdIds and Effective_Start_Date__c!=NULL]);
   	Map<String,Id> crdMatchedMap=new Map<String,Id>(); //Holds controlplaneffectivedate,closes effective date crdid.
   	Map<string,Date> crdIdMaxEffectiveDate=new Map<string,Date>();
   	for(String s:crdMap.keyset()){// for each controlplaneffective where there was a CRD.
   		for(Id crdId:crdMap.get(s)){//in the crd list,do for each crd per CPE and then Find the closest match
   			if(crdMatchedMap.containsKey(s)){//There is already an entry, check the effective date
   				if((crdMapDetail.get(crdId).Effective_Start_Date__c<=Date.valueOf(s.substring(s.length()-10,s.length())))&(crdMapDetail.get(crdId).Effective_Start_Date__c>crdIdMaxEffectiveDate.get(s))){
   				    crdIdMaxEffectiveDate.put(s,crdMapDetail.get(crdId).Effective_Start_Date__c);//New Maxeffectivedate
   				    crdMatchedMap.put(s,crdid); //this crd has effective date greater than the last max crd. Put the new crdid.
   				}
   			}
   			else{ //This is the first entry for controlplaneffective. Just add.
   			  if(crdMapDetail.get(crdId).Effective_Start_Date__c<=Date.valueOf(s.substring(s.length()-10,s.length()))){
   			  		crdMatchedMap.put(s,crdid);
   			  		crdIdMaxEffectiveDate.put(s,crdMapDetail.get(crdId).Effective_Start_Date__c);
   			  }
   			}
   			
   		}
   	}
   	
   	//-------------------STEP5: Find notification.rxplanid that don't match the crd.rxplaind--------------------------------------

   	//List<case> insertcaseList=new List<case>();
    Set<string> NotifmisMatchOnes=new Set<string>();   	
   	Map<string,case> insertcaseMap=new Map<string,case>();
   	List<string> matchedNotifStd=new List<string>();
   	List<casecomment> insertcasecomment=new List<casecomment>();
   	List<case> updatecasecloselist=new list<case>();
   	Set<String> RxplanVisited=new Set<String>();
   	set<String> NewRxplansIds=new set<String>();
   	for(String controlplaneff:crdMatchedMap.keyset()){
   		for(NotificationStandard__c nstdr:NotifMap.get(controlplaneff)){ //checking all notifications under the CPE-to get all rxplanids
   			
   			nstdr.Processed__c=true; //markingtrue.
   			UpdateMap_NotificationStd.put(nstdr.id,nstdr);
   			
   			string crdrxplan=crdMapDetail.get(crdMatchedMap.get(controlplaneff)).Rxplanid__c; //get crdif for the CPE, then get the crd record for the rxplanid.
   			if(!RxplanVisited.contains(nstdr.controlplaneffective__c+nstdr.Rxplanid__c)){//we only need one case for one rxplanid+cpe mismatch- since we orderd by createddate, we will get the latest one.
		   		if(crdrxplan!=nstdr.Rxplanid__c){
					//mismach, create case record.
					NewRxplansIds.add(nstdr.Rxplanid__c);
				
					insertcaseMap.put(nstdr.controlplaneffective__c+nstdr.rxplanid__c,createcase(crdMatchedMap.get(controlplaneff),nstdr));//create case indicating the mismatch
		   		}
		   		else
		   		    matchedNotifStd.add(controlplaneff);
		   	 RxplanVisited.add(nstdr.controlplaneffective__c+nstdr.Rxplanid__c);//mark notification rxplanid as already seen.
   			}
   		}
   	}
   	
   	RxplanVisited.clear();//cleaning
   	
   	//Step 5.b---removing if there is already a case about the mismatch.
   	for(case c:[select rxplanid1__c,controlplaneffective__c from case where Rxplanid1__c IN:NewRxplansIds AND Open__c=True AND CaseAutomationReason__c='AITranNpkgRxplaidmismatch' AND RecordTypeId=:eventNotifRecordId AND ControlPlanEffective__c IN :NotifMap.keyset()] ){
   		//TODO: Ask Kathy if we need to check for CRDId as well.
   		//filter out cases that already exist
   		if(c.rxplanid1__c!=null&&c.rxplanid1__c!='')//moved this filter from SOQL to If clause
   		   insertcaseMap.remove(c.controlplaneffective__c+c.rxplanid1__c);
   		
   	}
   	
   	//TODO: Confirm if an rxplanid can be shared among controlplaneffectives.
    if(System.Label.PerformanceMode.equalsIgnoreCase('False')){ //performance mode disabled.
   		//TODO:implement panic mode.
   		//TODO: !!!! find out if an rxplanid is shared between CPE
   		Set<String> insertedmisMatchcases=new Set<String>();
     	set<string> uniqueErrorMessages=new Set<String>();
   		Map<string,List<NotificationStandard__c>> NotifMapRx=new Map<string,List<NotificationStandard__c>>();
   		//Step i- consolidate at rxplanid level.
   		for(NotificationStandard__c NS2:Batchscope){//Do for each notification record in scope
   		 if(NS2.ControlPlanEffective__c!=null&&NS2.ControlPlanEffective__c!=''&&NS2.Rxplanid__c!=null&&NS2.Rxplanid__c!=''){	   			
	   		 List<NotificationStandard__c> NSLocal2=new List<NotificationStandard__c>();
	            //check if it already exists
	            If(NotifMapRx.containsKey(NS2.ControlPlanEffective__c+NS2.RxplanId__c)){
	               NSLocal2=NotifMapRx.get(NS2.ControlPlanEffective__c+NS2.RxplanId__c); //adding to list of notifications
	               NSLocal2.add(NS2);
	             }
	             else //Encountered controlplaneffective combination for the first time
	               NSLocal2.add(NS2);
	               
	            NotifMapRx.put(NS2.ControlPlanEffective__c+NS2.RxplanId__c,NSLocal2);
   		 }
        }
        //step ii- insert
        
        Database.Saveresult[] insertedNoCPERes2=Database.Insert(insertcaseMap.values(),false); //doing partial inserts
		for(Database.SaveResult sr:insertedNoCPERes2){
	    	if(sr.isSuccess()){
	    		insertedmisMatchcases.add(sr.getId());
	    	}
	    	else{
	    		for(Database.Error err : sr.getErrors()) {
		           uniqueErrorMessages.add(err.getMessage());
	            }
	    	}
	    }
	    	NotifmisMatchOnes.addAll(insertcaseMap.keyset()); // making a copy of keyset that was supposed to be inserted
	    //step iii- get which notifications to remove from update i.e leave as false
 	    
	    for(case c:[SELECT controlplaneffective__c,id,Rxplanid1__c FROM case WHERE Id IN:insertedmisMatchcases]){
	    	//for(NotificationStandard__c nsii:NotifMapRx.get(c.Rxplanid1__c)){
	    		NotifmisMatchOnes.remove(c.controlplaneffective__c+c.Rxplanid1__c); //only ones left will be failed ones.
	    		//UpdateMap_NotificationStd.remove(nsii.id);
	    	//}
	    }
	    
	    List<string> NotifMisMatchFailedOnesList=new List<string>();
	    NotifMisMatchFailedOnesList.addAll(NotifmisMatchOnes);
	    for(String failcpes:NotifMisMatchFailedOnesList){
	    	for(NotificationStandard__c nsii:NotifMapRx.get(failcpes)){
	    		UpdateMap_NotificationStd.remove(nsii.id);
	    	}
	    }
		
	    //step iv-- if there are errors, log an erro record.
	    if(uniqueErrorMessages.size()>0)
	  		 insert ErrorLogger.getRecord('Error inserting Cases','4','BCTCaseAutomation','Performance Mode=False.Inserting case where there was rxmismatch failed. Look at unprocessed notification with NotifcationStandard table.Errors:'+JSON.serializePretty(uniqueErrorMessages),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdNPkgProcessor', 282,'solipurams@aetna.com');
	    

   	}
   	else{
	   	Try{
	   			insert insertcaseMap.values();
		     }Catch(Exception e){
		           	//insert error record here.
		           	   If(e.getTypeName()=='DmlException')
		           	     system.debug(logginglevel.error,'FATAL DML Exception: TradStdNPkgProcessing while inserting cases. Performance Mode=True:'+e.getMessage());
		           	   else{
		           	    	insert ErrorLogger.getRecord('Error inserting Cases','4','BCTCaseAutomation','Performance Mode=True.Inserting case for Rxplanid mismatch failed. Look at unprocessed notification with NotifcationStandard table.Exception object:'+JSON.serializePretty(e),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdNPkgProcessor',254,'solipurams@aetna.com');
		           	    	//marking notifications as not processed.
		           	    	for(Case c:insertcaseMap.values()){//for each failed one.
		           	    		for(NotificationStandard__c nsErrored:NotifMap.get(c.controlPlanEffective__c)){//mark all notifications under the failed Case at CPE level
		           	    			UpdateMap_NotificationStd.remove(nsErrored.Id); //remove this notificationstd record, so it will not be marked as processed.
		           	    		}
		           	    	}
		           	   }  
		     }   
   	}
   	//----------------STEP6: For Matched notifications, find if there are existing cases that are not closed and add success comments.--------------------------------------
   	//NO FILTER ON OPEN__c-> Looks at both working and non-working cases!!!
   	//Going ahead adding comments to cases with Fallout=true, controlplaneffective in matchednotifstd set. These error cases are no longer valid??? 
   	//these are being worked on. adding case comments.
   	for(case c:[select id,ControlPlanEffective__c,ErrorNotifMaxDate__c from case where CaseAutomationReason__c='AITradFallout' AND ControlPlanEffective__c IN:matchedNotifStd AND RecordTypeId=:eventNotifRecordId AND isClosed=False]){//for both open and close
   		if(c.ErrorNotifMaxDate__c!=NULL&&c.ErrorNotifMaxDate__c<NotifMap.get(c.ControlPlanEffective__c)[0].createdDate)//Success recieved after fallout. Since we retrieved records in createdorder the first one is the most recent.
   		   insertcasecomment.add(new casecomment(commentBody='Recieved a successnotification for this rxplanid at:'+NotifMap.get(c.ControlPlanEffective__c)[0].createdDate,parentid=c.id));
   	}
   	insert insertcasecomment;
   	insertcasecomment.clear();
   	
   	//These are not being worked yet. TODO: Find what to do from Kathy. Closing for now
   	//for(case c:[SELECT Id,status,reason FROM Case WHERE CaseAutomationReason__c='AITradFallout' AND ControlPlanEffective__c IN:matchedNotifStd AND Open__c=true]){
   	//	c.Status='Closed';
   	//	c.Reason='Success Notification Recieved';
   	//	updatecasecloselist.add(c);
   	//	insertcasecomment.add(new casecomment(commentBody='Recieved a successnotification for this rxplanid',parentid=c.id));
   	//	
   	//}
   //insert insertcasecomment;
   	//insertcasecomment.clear();
   	
  // 	update updatecasecloselist;
 */ 
    update UpdateMap_NotificationStd.values();
   }//End execute Method.
   
   
   global void finish (Database.BatchableContext BC){
   		AsyncApexJob a = [Select Id, CreatedDate, CreatedById, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob  WHERE Id =:BC.getJobId()];
   		JobLogger.endBatch(System.now(),NULL,'Completed TradStdNPkg process.',Userinfo.getUserId(),true,'CaseAutomation',a);
   		CaseAuto_BatchLinker cab=new CaseAuto_BatchLinker();
   		cab.callNext('BAT_TradStdNPkgProcessor');
   }//End execute Method.
   
   /* !!!!!FEB 15 release removed created cases
   //============================
   // Member variabels   
   //============================
   
  
   //=============================
   // Member Methods  
   //=============================
   
   // Method Name:createcase
   // Arguments:NotificationStandard,CRD
   // Return:case
   // Description:
   //private case createcase(Id crdId,NotificationStandard__c nsrecord){
   //	 CreateCase casecreator=new Createcase();
   //	 return (casecreator.pullNonPackageplans(new Map<id,NotificationStandard__c>{crdId=>nsrecord}));
   //}
   
   // Method Name:createcaseCPEmismatch
   // Arguments:NotificationStandard,CRD
   // Return:case
   // Description:
   private case createcaseCPEmismatch(NotificationStandard__c nstd){
   		createcase caseCreator=new createcase();
   		return casecreator.pullnonpackageCPE(nstd);
  		//return (new case(Subject = 'New CPE-NonPackage',CaseAutomationReason__c='AITradNpkgnewCPE',ControlPlanEffective__c=ctrlpleff));
   }
  */ 
  
}//End class BAT_TradStdNPkgProcessor