global without sharing class BAT_PERSNonPkgProcessor_ALT implements Database.Batchable<sObject>{
 //=============================
   // Meta Information
   //=============================	
   // Namespace or Enhancement:SFDC8533b
   // ######################################################################################################################################
   //				ALTERNATE CODE TO CALL PROVLINEDOMAIN_ALT. USE WITH CAUTION.
   //#######################################################################################################################################
   // Called by:None
  
   /*==================================================================================
   Version				Author			Date			Reason
   1.0		            Saraag		    2/27/2014	    Created	

   ====================================================================================*/
	 //Class Variables
          //DataType                                                Name                             Description
 		    String 											        QString;                        //Query string for start method
 			Map<String,List<PERS_report__c>> 				        PERSmap;						//Map for consolidating notification records at controlPlaneffectivedate level.
 			Id 														eventNotifRecordId;				//Used to hold evennotification recordtypeId	
 			Set<String> 											FoundCtrlPlanEffinCase;         //ControlPlaneffectives for which there are existing 'open' cases.
 			Id													    internalCaseRecId;				//interncase recordtypeid
 			Map<string,Provisional_Lines__c> 						upsertMap_ProvLine;				//used to hold key,provline record for DML
 			Map<String,Id> 											crdMatchedMapcloned;
 			set<string> 											notfoundCRDCPEs;
 			Map<id,list<string>>                                    crdReverseMap;                 //once CRD is found for CPE, find a reverse map.
 			Map<Id,Id>												crdAccountMap;				   //map between matched CRD and it's accountId.
 			set<string>												CtrlEffSet;					   //Distinct ControlEffective cominations in scope.
 			set<string>												crdidce_exIntCaseSet;		  //crdid+ce- exising internal cases				
	//============================
   // Constructor
   //============================
   global BAT_PERSNonPkgProcessor_ALT(){
   		
   		//making sure we only retrieve records with EDITimestamp
   		
   		Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
			   	 		Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
			            String qry='';
			            for(String s:FieldsMap.keyset()){
			               qry+=s+',';
			            }
			            qry=qry.left(qry.length()-1); //removing the extra comma
			                    
			            string pv='false'; 
			            String s;
			            if(system.label.CaseAuto_sendIdOnly.equalsIgnoreCase('true'))
			             	s='SELECT Id FROM PERS_report__c where  Package__c=\'false\' AND Processed__c=False AND EDITimestamp__c!=NULL AND createddate=TODAY ORDER BY Name DESC';
			            else
			             	s='SELECT '+qry+' FROM PERS_report__c where  Package__c=\'false\' AND Processed__c=False AND EDITimestamp__c!=NULL AND createddate=TODAY ORDER BY Name DESC';
	        
   		QString=s;
   		
   		PERSMap=new Map<String,List<PERS_report__c>>();
   		eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
   		internalCaseRecId=(Id)[select Id from recordtype where DeveloperName='Internal_CRD_GMF_Process' LIMIT 1][0].Id;
   		upsertMap_ProvLine=new Map<string,Provisional_Lines__c>();
   		CtrlEffSet=new Set<string>();
   }//End constructor
      
   //============================
   // Interface Methods 
   //============================
   global Database.QueryLocator start (Database.BatchableContext BC){
   	     JobLogger.startBatch(NULL, 'Starting PERSNonPkg ALTERNATE FLOW!', userinfo.getUserId(), system.now(), true, 'BCTCaseAutomation');
   	        	
   		 return Database.getQueryLocator(QString);
   }//End execute Method.
   
   
   global void execute (Database.BatchableContext BC,List<PERS_report__c> scope){
   	Map<String,Set<Id>> crdMap=new Map<string,set<Id>>();
   	Set<Id> crdIds=new Set<id>();
   	Set<string> foundCRDCPEs=new Set<string>();
   	notfoundCRDCPEs=new set<string>();
   	List<PERS_report__c> updatePERSList=new List<PERS_report__c>();
   	crdAccountMap=new Map<id,id>();
   	crdidce_exIntCaseSet=new set<string>();
   	Map<String,Set<TraditionalNonPkgLookup__c>> lkpCPMap=new Map<string,set<TraditionalNonPkgLookup__c>>();
   	
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
       		 Batchscope=Database.query('SELECT '+qry+' FROM PERS_report__c WHERE Id IN:BatchIds ORDER BY Name DESC');
       	else
       		 Batchscope=new List<PERS_report__c>();
        //clearing out scope
        scope.clear(); 
   	
   	
   	//-------------------STEP1: Consolidate notifications at CPE level.--------------------------------------
   		for(PERS_report__c cprx:Batchscope){//Do for each notification record in scope
   		List<PERS_report__c> CPrxLocal=new List<PERS_report__c>();
   			cprx.Processed__c=true;
   			cprx.Processed_Alternate__c=true;
   			updatePERSList.add(cprx);
	   		//check if it already exists
	   		If(PERSMap.containsKey(cprx.ControlPlanEffective__c)){
	   		   CprxLocal=PERSMap.get(cprx.ControlPlanEffective__c); //adding to list of notifications
	   		   cprxLocal.add(cprx);
	   		 }
	   		 else //Encountered controlplaneffective combination for the first time
	   		   cprxLocal.add(cprx);
	   		   
	   		PERSMap.put(cprx.ControlPlanEffective__c,cprxLocal);
	   
	   
	   	}
	Batchscope.clear();
	
	notfoundCRDCPEs.addAll(PERSMap.keyset());
	
	//-------------------STEP2: Find CRD at ControlPlan level.--------------------------------------
    
   //SWITCHED to using NonPackage Lookup table.
	   for(TraditionalNonPkgLookup__c nplookup:[SELECT CRD__c,ControlPlanEffective__c FROM TraditionalNonPkgLookup__c WHERE CRD__c!=NULL AND isDeleted=False AND ControlPlanEffective__c IN:PERSMap.keyset() AND CRD__r.Effective_Start_Date__c!=NULL AND CRD__r.Account__c!=NULL]){ //if there is no CRD, do not look at it.
	   	   	Set<Id> crdLocalSet=new Set<Id>();
	   	
	   	  if(crdMap.containsKey(nplookup.ControlPlanEffective__c)){
	   		crdLocalset=crdMap.get(nplookup.ControlPlanEffective__c);
	   		crdLocalSet.add(nplookup.crd__c);
	   		crdIds.add(nplookup.crd__c);
	   	}
	   	else{
	   	   crdLocalSet.add(nplookup.crd__c);
	   	   crdIds.add(nplookup.crd__c);
	   	}
	   	//getting controleffectives
	   	CtrlEffSet.add(getCE(nplookup.ControlPlanEffective__c));
	   	
	   	notfoundCRDCPEs.remove(nplookup.ControlPlanEffective__c); //left will be CPEs where there is no CRD.
	   	foundCRDCPEs.add(nplookup.ControlPlanEffective__c); //adding to found list.
	    crdMap.put(nplookup.ControlPlanEffective__c,crdLocalSet);	
	   }
     //FEB 15: Find CRDs based off CP from TraditionalNonPackagelookup
     
     //step 2.b: Build cp to CPE Map
   		Map<string,Set<String>> cpTocpeMap_NCRD= new Map<string,set<string>>();
	    set<string> cpesunderCP;
	   	for(string foundCPE:notfoundCRDCPEs){
	   		cpesunderCP=new set<string>();
     		string cpLocal=foundCPE.substring(0,foundCPE.length()-10);
     		If(cpTocpeMap_NCRD.containsKey(cpLocal)){
		   		   cpesunderCP=cpTocpeMap_NCRD.get(cpLocal); //adding to list of notifications
		   		   cpesunderCP.add(foundCPE);
		   		 }
		   		 else //Encountered controlplaneffective combination for the first time
		   		   cpesunderCP.add(foundCPE);
		   		   
     		cpTocpeMap_NCRD.put(cpLocal,cpesunderCP); //cp->cpe
     		
	     		
	   	}
	   	
	   	//step 2.c: Find TradNonPkgLookup entries using controlplan
	   	for(TraditionalNonPkgLookup__c nplookup:[SELECT CRD__c,ControlPlanEffective__c,ControlPlan__c,effectiveDate__c FROM TraditionalNonPkgLookup__c WHERE CRD__c!=NULL  AND ControlPlan__c IN:cpTocpeMap_NCRD.keyset() AND CRD__r.Account__c!=NULL]){ //getting rows based on cp without a crd.
     	
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
   		system.debug(logginglevel.finer,'lkpCPMap:'+lkpCPMap);
   		 //--- step 2.d: Find closest row based on effective date being smaller than NotifEffectiveDate and Max among the results. Do per CP
   
		  Map<string,TraditionalNonPkgLookup__c> matchedCP_LkpRec=new Map<string,TraditionalNonPkgLookup__c>(); //CPE->TraditionalNonPkg Lookup row with Max eff and less that (E) of CPE
		  Map<string,Id> matchedCP_CRDID=new Map<string,Id>();
		  for(string cp:lkpCPMap.keyset()){ //for each controlplan
		  	for(string cpe:cpTocpeMap_NCRD.get(cp)){//get all CPEs for CP.
		  		for(TraditionalNonPkgLookup__c lkprec:lkpCPMap.get(cp)){//get all matched rows per controlplan.
		   			if(matchedCP_LkpRec.containsKey(cpe)){//There is already an entry, check the effective date
		   				if((lkprec.effectiveDate__c<=Date.valueOf(cpe.substring(cpe.length()-10,cpe.length())))&(lkprec.effectiveDate__c>matchedCP_LkpRec.get(cpe).effectiveDate__c)){
		   				    matchedCP_LkpRec.put(cpe,lkprec); //lkp row has effectivedate greater than what's in the map right now. Replace.
		   				}
		   			}
		   			else{ //This is the first entry for controlplaneffective. Check if less than effective date of notification
		   			  if(lkprec.effectiveDate__c<=Date.valueOf(cpe.substring(cpe.length()-10,cpe.length()))){
		   			  		matchedCP_LkpRec.put(cpe,lkprec);
		   			  }
		   			}
		   			
		   		}
		   		if(matchedCP_LkpRec.get(cpe)!=NULL){//a match was found i.e. atleast one entry with eff<notif eff
		   			CtrlEffSet.add(getCE(cpe)); //adding to controleffective set, will be later used to find cases.    
	     			notfoundCRDCPEs.remove(cpe); //left will be CPEs where there is no CRD.
			   		foundCRDCPEs.add(cpe); //adding to found list.
		   			matchedCP_CRDID.put(cpe,matchedCP_LkpRec.get(cpe).crd__c);//add cpe and the crd from the matched tradnonpkglookup record.		   		
	   				crdIds.add(matchedCP_LkpRec.get(cpe).crd__c); //adding to crds to get these crds as part of step3
		   		}
	   				   		
		  }
		 }
		 system.debug(logginglevel.finer,'CtrlEffSet:'+CtrlEffSet);
		 system.debug(logginglevel.finer,'notfoundCRDCPEs:'+notfoundCRDCPEs);
		 system.debug(logginglevel.finer,'FoundCRDCPEs:'+foundCRDCPEs);
		 system.debug(logginglevel.finer,'MatchedCP+CRDID:'+matchedCP_CRDID);
   	//-------------------STEP3: Find CRD with closest effective date.--------------------------------------

   	Map<Id,CRD__c> crdMapDetail=new Map<Id,CRD__c>([SELECT Id,Effective_Start_Date__c,Rxplanid__c,Account__c FROM Crd__c WHERE Id IN:crdIds and Effective_Start_Date__c!=NULL and Account__c!=NULL]);
   	Map<String,Id> crdMatchedMap=new Map<String,Id>(); //IMP:Holds controlplaneffectivedate,closes effective date crdid.
   	Map<string,Date> crdIdMaxEffectiveDate=new Map<string,Date>();
   	List<case> openCasesFound=new List<Case>();
   	for(String s:crdMap.keyset()){// for each controlplaneffective
   		for(Id crdId:crdMap.get(s)){//in the crd list. Find the closest match
   			if(crdMatchedMap.containsKey(s)){//There is already an entry, check the effective date
   				if((crdMapDetail.get(crdId).Effective_Start_Date__c<=Date.valueOf(s.substring(s.length()-10,s.length())))&(crdMapDetail.get(crdId).Effective_Start_Date__c>crdIdMaxEffectiveDate.get(s))){
   				    crdIdMaxEffectiveDate.put(s,crdMapDetail.get(crdId).Effective_Start_Date__c);//New Maxeffectivedate
   				    crdMatchedMap.put(s,crdid);
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
   
   	
   	  //Garbage cleaning...
   	   crdIdMaxEffectiveDate.clear();
   	   crdIds.clear();
   	   matchedCP_LkpRec.clear();
   	   
   	   //IMPORTANT: Combine both lists
   	   //Added feb15.
   	   crdMatchedMap.putAll(matchedCP_CRDID); //these two maps shouldn't have a common key. So its addAll.
   	   system.debug(logginglevel.debug,'crdMatchedMap-Final:'+crdMatchedMap);
 //==FOUND CRDS SECTION==================================================================================================================
   	//-------------------STEP4: For Matched CRDs find open internal cases and update provline records----------------------------------
    //Find cases for crdIds and controlplaneffective 
    	//creating CRD Matched reverse map
   	crdReverseMap=new Map<Id,List<string>>();
   	for(string s:crdMatchedMap.keyset()){
   			   		
	    //getting reverse map		
   		List<string> crdRevMapLocalList=new List<string>();
   		if(crdReverseMap.containsKey(crdMatchedMap.get(s))){
   			crdRevMapLocalList=crdReverseMap.get(crdMatchedMap.get(s));
   			crdRevMapLocalList.add(s);
   		}
   		else{
   			 crdRevMapLocalList.add(s);
   		}
   		crdReverseMap.put(crdMatchedMap.get(s),crdRevMapLocalList); //crdid,list of cpes for the Id from crdMatchedMap.
   	}
   	system.debug(logginglevel.finer,'crdReverseMap:'+crdReverseMap);
   	//Creating CRDID to AccountId map
   	 for(Id CrId:crdReverseMap.keyset()){
   	 	crdAccountMap.put(crId,crdMapDetail.get(crId).Account__c); //crdMapDetail should have the record even if its part of
   	 }
   	 
   	 
    system.debug('CRDMatchedMap:'+crdMatchedMap);
    crdMatchedMapcloned=crdMatchedMap.clone();
    openCasesFound=[SELECT Id,open__c,ControlPlanEffective__c,CRD_ID__c,ControlEffective__c FROM Case WHERE CRD_ID__c IN:crdMatchedMap.values() AND RecordTypeId=:internalCaseRecId AND ControlEffective__c IN:CtrlEffSet AND Open__c=True AND CaseAutomationReason__c='PERSyCRDnCase' AND createddate=today];
    system.debug(logginglevel.finer,'internalcasesfound:'+[SELECT Id,open__c,ControlPlanEffective__c,CRD_ID__c,ControlEffective__c FROM Case WHERE CRD_ID__c IN:crdMatchedMap.values() AND RecordTypeId=:internalCaseRecId AND ControlEffective__c IN:CtrlEffSet AND Open__c=True AND CaseAutomationReason__c='PERSyCRDnCase' AND createddate=today]);
    //set<string> foundInternalCaseCPE=new set<string>();
    createProvLines(openCasesFound,'step4');
   	
   	//Garbage cleaning...
   	openCasesFound.clear();
   	
   	//-------------------STEP5: For Matched CRDs without open internal cases, add cases and add provline records----------------------------------
   	
   	//----STEP 5.a
   		//-- Followup actions-dec release--
   	
   
   	 
   	 //garbage cleaning
   	   crdMapDetail.clear();
   	 
      Map<string,case> insertMap_NewInternalCases=new Map<string,case>();
 	
      //step 5.b-create cases for CRDs without internalcases.
      system.debug(logginglevel.finer,'crdidCE_existingINTCaseSet:'+crdidce_exIntCaseSet);
      
      for(Id crId:crdReverseMap.keyset()){
      	for(string cpestring:crdReverseMap.get(crId)){
      	 if(!crdidce_exIntCaseSet.contains(crId+getCE(cpestring))){//there wasn't an existing internal case under this CRD for this controleffective
      	    
      	   insertMap_NewInternalCases.put(crId+getCE(cpestring),createInternalcase(crdMatchedMap.get(cpestring),PERSMap.get(cpestring)[0],crdAccountMap.get(crId))); //one case for crd id+control effective
      	    system.debug(logginglevel.finer,'added rec'+insertMap_NewInternalCases.get(crId+getCE(cpestring)));
      	 }
      	}
      }
      system.debug(logginglevel.finer,'insertMap_NewInternalCases:'+insertMap_NewInternalCases);
      insert insertMap_NewInternalCases.values();
      system.debug(logginglevel.finer,'inserted cases crdycasen from BAT_PERSNonPkgProcessor_ALT:'+insertMap_NewInternalCases.values());
      //step 5.c- create provline records
      createProvLines(insertMap_NewInternalCases.values(),'step5.b');
      
	   	//Garbage cleaning...
	   	insertMap_NewInternalCases.clear();
	   	crdMatchedMapcloned.clear();

 //==CRD NOT FOUND SECTION======================================================================================================================
 	   	
 //-------------------STEP6: For without CRD but with Case--------------------------------------
    createProvLines([SELECT Id,controlplaneffective__c from case where createddate=today AND Open__c=True AND RecordTypeId=:internalCaseRecId AND CaseAutomationReason__c='PERSnCRDnCase'  AND ControlPlanEffective__c IN:notfoundCRDCPEs],'step6');
 //-------------------STEP7: For CPEs without CRD and without Existing case--------------------------------------
   	
   	//Step 7.a- creating cases.
	   	Map<string,case> insertEventCases=new Map<string,case>();
	   	for(string newCPEs:notfoundCRDCPEs){
	   		if(!insertEventCases.containsKey(newCPES))
	   		  insertEventCases.put(newCPES,createcase(PERSMap.get(newCPEs)[0]));
	   		
	   	}
	   /*	//remove existing- This is no longer needed after Feb 15 release.
	   	List<case> existingCRDnCasen_caseList=new List<case>();
	   	for(case c:[select id,controlplaneffective__c from case where RecordTypeId=:internalCaseRecId AND ControlPlanEffective__c IN:notfoundCRDCPEs AND CaseAutomationReason__c='PERSnCRDnCase' AND Open__c=True AND isClosed=False ]){
	   		insertEventCases.remove(c.controlplaneffective__c); //these are existing cases- no need to create them again.
	   		existingCRDnCasen_caseList.add(c); //there is no need to create these cases, but we still need to attach provline to them.
	   	}
	   	*/
	   	insert insertEventCases.values();
	   	
   	//Step7.b- For created cases: Insert Provisional Line records.--------------------------------------
   	// List<case> tempEventCaseList=new List<case>();
   	// tempEventCaseList.addAll(insertEventCases.values()); //converting into a list.
   //	 tempEventCaseList.addAll(existingCRDnCasen_caseList); //adding to the list so the provlines will get attached.
   	 // createProvLines(tempEventCaseList,'noaction');
   	  createProvLines(insertEventCases.values(),'noaction');
   	
   	update updatePERSList;   
   }//End execute Method.
   
   	
   global void finish (Database.BatchableContext BC){
   		   AsyncApexJob a = [Select Id, CreatedDate, CreatedById, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob  WHERE Id =:BC.getJobId()];
   		  JobLogger.endBatch(System.now(),NULL,'Completed PERSNonPkgPorcessing.',Userinfo.getUserId(),true,'CaseAutomation',a);
   		  sendConfirmation();
   }//End finish.
   

   //========================================================================================================
   // Private Member Methods  
   //========================================================================================================
   
   
   // <><><><><><>Method Name:sendConfirmation<><><><><><>
   // Arguments:asyncapexJob
   // Return:List of pv line records
   // Description:
 
   private void sendConfirmation(){

   	      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   String[] toAddresses = System.Label.CaseAuto_confirmationEmailList.split(',',0);
		   mail.setToAddresses(toAddresses);
		   mail.setSubject('NoReply:Case Automation- PERS NonPkg ALTERNATE flow detected');
		   mail.setPlainTextBody('Autogenerated Message: Case automation-PERS NonPkg ALTERNATE FLOW was requested by user:'+Userinfo.getUserId()+' .If you do not recognize this request or if this was done in error, please look for provision and line values with \"Created using EDI timestamp\"=true. Processing complete.');
		   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

   }

   // <><><><><><>Method Name:PVLineCreator<><><><><><>
   // Arguments:List of pers records, case Id
   // Return:List of pv line records
   // Description:
 
   private Provisional_Lines__c PVLineCreator(PERS_report__c persrec,Id caseId,string plan){
   	     	 return ProvLineDomain_ALT.getRecord(persrec,caseid,plan);

   }
   
   
   // <><><><><><>Method Name:casecreate<><><><><><>
   // Arguments:PERS report list,crdid,case record
   // Return:case
   // Description:
   private case createcase(PERS_report__c persRecord){
   	  string s=persRecord.ControlPlanEffective__c;
   	  Date dt=Date.valueOf(s.substring(s.length()-10,s.length()));
   	  CreateCase casecreator=new Createcase();
   	 return (casecreator.pullPERSNPkgNoCRD(dt,s,persRecord.EDITimeStamp__c));
   
   }
   
   
   // <><><><><><>Method Name:casecreate<><><><><><>
   // Arguments:PERS report list,crdid,case record
   // Return:case
   // Description:
   private case createInternalcase(Id crdid,PERS_report__c persRecord,Id accId){
   	 string s=persRecord.ControlPlanEffective__c;
   	 Date dt=Date.valueOf(s.substring(s.length()-10,s.length()));
   	 CreateCase casecreator=new Createcase(); 	 
   	 return (casecreator.pullPERSNPkgCRDnoCase(dt,string.valueof(persRecord.CONTROL_NO__c),crdId,persRecord.EDITimeStamp__c,accId));
   }
	
   // <><><><><><>Method Name:createProvLines<><><><><>
   // Arguments:List of Provisional Line records
   // Return:None
   // Description:
   private void createProvLines(list<case> caseList,string instruction){
			   	for(case c:caseList){
				   		if(instruction=='step4'){
							crdidce_exIntCaseSet.add(c.crd_id__c+c.controleffective__c);				   		   
				   		}
				   else if(instruction=='step6')
				   		    notfoundCRDCPEs.remove(c.ControlPlanEffective__c);
				   	
				   if(instruction!='step4'&&instruction!='step5.b'){//these are not internal cases	    
					   	for(PERS_report__c perRec:PERSMap.get(c.controlplaneffective__c)){
									if(!upsertMap_ProvLine.containsKey(c.Id+string.valueof(perRec.NEW_PROV_NUM__c)))//ordered by createddate, we only need the latest one.
							   				upsertMap_ProvLine.put(c.Id+string.valueof(perRec.NEW_PROV_NUM__c),PVLineCreator(perRec,c.Id,''));
					   	}
				   }
				   else{ //internal cases 
				   	  for(string cpeunderCRD:crdReverseMap.get(c.CRD_ID__c)){//find the ones that match with this 
				   	  	  if(c.ControlEffective__c!=NULL&&ceMatchesCpe(c.ControlEffective__c,cpeUnderCRD)){ //does it match? TODO:what happens if it doesn't match? 
					   	  	  	for(PERS_report__c perRec:PERSMap.get(cpeunderCRD)){
					   	  	  		string plan=cpeunderCRD.substring(cpeunderCRD.length()-12,cpeunderCRD.length()-10);
										if(!upsertMap_ProvLine.containsKey(c.Id+string.valueof(perRec.NEW_PROV_NUM__c)+plan))//ordered by createddate, we only need the latest one.
								   				upsertMap_ProvLine.put(c.Id+string.valueof(perRec.NEW_PROV_NUM__c)+plan,PVLineCreator(perRec,c.Id,plan));
						     	}
				   	  	  }
				   	  } 
				   }
			    
					   	
			   	}
		
		system.debug(logginglevel.finer,'created provlines:'+upsertMap_ProvLine);	   	
      	ProvLineDomain_ALT.handleProvLineDML(upsertMap_ProvLine);
        upsertMap_ProvLine.clear();
   }
  
  public boolean ceMatchesCpe(string ce,string cpe){
  	if(ce==NULL||cpe==NULL||ce==''||cpe=='')
  	  return false;
  	else{
	  	string cpe_cepart=getCE(cpe);
	  	return cpe_cepart.equals(ce);
  	}
  }
  
  private string getCE(string cpe){
  	 return cpe.substring(0,cpe.length()-12)+cpe.substring(cpe.length()-10,cpe.length());
  }   
}//End class BAT_PERSNonPkgProcessor_ALT