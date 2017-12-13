/*
Test class for PERSNonPackage processor
*/
@isTest
private class Test_SS_BAT_PERSNonPkgProcessor_ALT {

    static testMethod void myUnitTest() {
    	Test.startTest();	
    	prepareTest();
    	
    	ID batchprocessid =invokeBatch();
        Test.stopTest();
        //data
        system.debug(logginglevel.error,'Job status:'+[SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ][0]);
        system.debug(logginglevel.error,'PERSreports-POSTprocessing:'+[select Id,ROWID__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Pers_report__c order by Name DESC]);
        system.debug(logginglevel.error,'ProvLines-POSTprocessing:'+[select Key__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c,case__c,BNFT_STATUS_CD__c from Provisional_Lines__c]);
        system.debug('All- cases:'+[select Id,subject,controleffective__c,caseautomationreason__c,controlplaneffective__c,crd_name__c from Case]);//created one case
        
        //assertions
        //CRD-N, Case-N
        system.assert([select controlplaneffective__c from Case where controlplaneffective__c='6434567AA2013-11-02' AND caseAutomationReason__c='PERSnCRDnCase'].size()>0);
        //CRD-N, Case-Y
        system.assert([select controlplaneffective__c from Case where controlplaneffective__c='9934567AA2013-11-02' AND caseAutomationReason__c='PERSnCRDnCase'].size()==1);
        Id prevcases=[select Id,controlplaneffective__c from Case where controlplaneffective__c='9934567AA2013-11-02' AND caseAutomationReason__c='PERSnCRDnCase'][0].id;
        //for above case there should have been one pers record
        system.debug(logginglevel.error,'prevcases:'+prevcases);
        Id cId= [select case__c from Provisional_Lines__c where controlplaneffective__c='9934567AA2013-11-02'][0].case__c;
        system.debug(logginglevel.error,'casefromabove:'+[select controlplaneffective__c,caseautomationreason__c from case where id=:cid]);
        system.debug(logginglevel.error,[select case__c from Provisional_Lines__c where controlplaneffective__c='9934567AA2013-11-02']);
        system.assert([select case__c from Provisional_Lines__c where controlplaneffective__c='9934567AA2013-11-02'][0].case__c==prevcases);
        
        //Feb 15 release. Finding CRDs using CP
        Id crdId2=[select Id from CRD__c where rxplanid__c='112456789'][0].Id;
        //CRD- N for CPE, Y for CP
        system.assert([select id,CRD_name__c from Case where controleffective__c='72345672013-11-02' and CaseAutomationReason__c='PERSyCRDnCase'][0].CRD_Name__c==crdId2); //found the correct lkp2
        //CRD- N for CPE, N for CP
        system.assert([select id from Case where controlplaneffective__c='7234567AA1987-01-17' and CaseAutomationReason__c='PERSnCRDnCase'].size()==1); //created a case where there is no match
        
        
        //CRD-Y,Case-N
         Id crdId=[select Id from CRD__c where rxplanid__c='012456789'][0].Id;
         
         system.debug('CRDyCaseN- cases:'+[select Id,subject,controleffective__c,caseautomationreason__c,controlplaneffective__c from Case where CaseAutomationReason__c='PERSyCRDnCase']);//created one case
         
        system.assert([select Id from Case where controleffective__c='12345672013-11-02' AND CaseAutomationReason__c='PERSyCRDnCase'].size()==1);//created one case
        Id InternalCaseId=[select Id from Case where controleffective__c='12345672013-11-02' AND CaseAutomationReason__c='PERSyCRDnCase' AND CRD_ID__c=:crdId][0].Id;
        
        system.debug('Prov for Internal Case, CRDYCaseN:'+[select ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:InternalCaseId]);//two prov lines inserted for the case with Plan AA and Plan BB.
        
        system.assert([select ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:InternalCaseId].size()==5);//since these are matched ones, prov lines inserted at prov+line+plan level.
        
        //Feb15 release. Key and therefore the level PERS records are stored has changed to CaseId+ProvNumber for CRD-N and CaseId+ProvNumber+Plan for CRD-Y scenarion for nonpkg
        
        system.assert([select ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:InternalCaseId AND NEW_PROV_NUM__c=117].NEW_LINE_VAL_NO__c==947);//947 should have replaced 934 LV
        
        
        
    }
    
    private static void prepareTest(){
    	    //data setup
			insert Test_DataGen_CaseAutomation.CRDGenerator();
			insert Test_DataGen_CaseAutomation.TradNonPkgLookupGenerator();
			insert Test_DataGen_CaseAutomation.PERSreportGen(); //- (i)6434567AA2013-11-02 will have CRD-N,Case-N.(ii) CRD-Y,Case-N 3 pers records with case. 2 are dupes=> creates 2 pers if there and attaches to internal case. (ii)
		    List<TraditionalNonPkgLookup__c> Npkglookup=new List<TraditionalNonPkgLookup__c>();
		    Id crdId=[select Id from CRD__c where rxplanid__c='012456789'][0].Id;
    		Id crdId2=[select Id from CRD__c where rxplanid__c='112456789'][0].Id;
		    
			
			//Case Y, CRD- N
			ID eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
			ID internalCaseRecId=(Id)[select Id from recordtype where DeveloperName='Internal_CRD_GMF_Process' LIMIT 1][0].Id;

			insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='9934567AA2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123));//no entry in tradnlookup
			insert (new case(controlplaneffective__c='9934567AA2013-11-02',caseAutomationReason__c='PERSyCRDnCase',Open__c=true,RecordTypeId=internalCaseRecId));
			
			//CRD- Y, Case- N
			//datagenerator inserts three PERSreports with 1234567AA2013-11-02, sinc CRD-Y, and Case- N we create internal case at Control+Effective level. Inserting another PERS record with same controleffective but different plan
			//the internal case with controleffective=12345672013-11-02 should have two provision line records one with plan AA and another with Plan BB
			
    	    insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567BB2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	    insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567BB2013-11-02',NEW_PROV_NUM__c=2,NEW_LINE_VAL_NO__c=134,BNFT_STATUS_CD__c='BB',CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	    
			Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='1234567BB2013-11-02',key__c='11'+string.valueOf(system.now())));
    	    Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId2,ControlPlanEffective__c='1234567BB2013-11-02',key__c='21'));
    	    
    	    //Feb 15 release- removing provisional line from Key
    	    //check: when we insert two provline records with same cpe, provnumbe5r 
    	    insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567BB2013-11-02',NEW_PROV_NUM__c=117,NEW_LINE_VAL_NO__c=934,BNFT_STATUS_CD__c='BB',CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	    insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567BB2013-11-02',NEW_PROV_NUM__c=117,NEW_LINE_VAL_NO__c=947,BNFT_STATUS_CD__c='BB',CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	    
			//CRD-Y, Case- Y
    		    	
    	 	Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='8834567AA2013-11-02',key__c='3343'+string.valueOf(system.now())));
    		Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId2,ControlPlanEffective__c='8834567AA2013-11-02',key__c='45'));
    		insert Npkglookup;
			insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='8834567AA2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=8834567)); //this will find crd1,crd2-picks crd1
			
			account a=new account(Name='testaccount');
			insert a;
			createcase casecreator=new createcase();
			insert (casecreator.pullPERSNPkgCRDnoCase(Date.valueOf('2013-11-02'),'8834567',crdId,system.now(),a.id)); //there is an internal with the CPE, and there is a CRD record found via nonpkglookup table. 
			
			//CRD- N, CP cases
			  //Found using CP
			  //insert entries for 7234567AA2013-11-02's CP: 7234567AA but with a diff eff date into nonpkglkp
		    	//insert pers report with no direct CRD match from nonpkg table, but will find a match with CP
		    	insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='7234567AA2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=7234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
		    	
		    	
		    	date olderDate = date.newInstance(1987, 2, 17);
		    	date olderDate2 = date.newInstance(2000, 2, 17);
		    	date futureDate = date.newInstance(2087, 2, 17);
		    	List<TraditionalNonPkgLookup__c> NpklookupLocal=new List<TraditionalNonPkgLookup__c>();
		    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='7234567AA1987-02-17',key__c='3'+string.valueOf(system.now()),effectiveDate__c=olderDate,ControlPlan__c='7234567AA')); //lkp1
		    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId2,ControlPlanEffective__c='7234567AA2001-02-17',key__c='4'+string.valueOf(system.now()),effectiveDate__c=olderDate2,ControlPlan__c='7234567AA')); //lkp2 this will get picked
		    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='7234567AA2087-02-17',key__c='5'+string.valueOf(system.now()),effectiveDate__c=futureDate,ControlPlan__c='7234567AA')); //lkp3
		    	 insert NpklookupLocal;      
			  //Not found using CP
			  	//Not found because of eff date 1987-Jan vs 1987 Feb
			  	  insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='7234567AA1987-01-17',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=7234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('1987-01-17')));
			  	
			  	
			//inserted data
			system.debug(logginglevel.error,'TradNpklk:'+[select crd__c,controlplaneffective__c from TraditionalNonPkgLookup__c]);
			system.debug(logginglevel.error,'CRDs:'+[select Rxplanid__c from crd__c]);
			system.debug(logginglevel.error,'Cases:'+[select Rxplanid1__c from Case]);
        	system.debug(logginglevel.error,'PERSreports-preprocessing:'+[select Id,ROWID__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Pers_report__c]);
        	system.debug(logginglevel.error,'ProvLines-preprocessing:'+[select Key__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c,case__c,BNFT_STATUS_CD__c from Provisional_Lines__c]);
        	
        	//ALTERNATE FLOW TEST- ADDING EDITIMESTAMP TO RECORDS IN ORDER THEY WERE INSERTED.
        	datetime myDate = datetime.newInstance(2012,12,1);
        	List<PERS_report__c> upPersreportList=new List<PERS_report__c>();
        	for(PERS_report__c prec:[select id,EDITimeStamp__c from PERS_report__c order by Name ]){
        		prec.EDITimestamp__c=myDate;
        		upPersreportList.add(prec);
        		myDate=mydate.addDays(1);
        	}
        	update upPersreportList;
    }
    
    private static Id invokeBatch(){
    	 	
	        BAT_PERSNonPkgProcessor_ALT bch=new BAT_PERSNonPkgProcessor_ALT();
	       	ID batchprocessid= Database.executeBatch(bch,200);
	       	return batchprocessid;
    }
}