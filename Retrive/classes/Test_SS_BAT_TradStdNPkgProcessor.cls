/**
Test class for traditional non package batch class.
 */
@isTest
private class Test_SS_BAT_TradStdNPkgProcessor {

    static testMethod void CRDcpeMatch() { 
    	//there is an entry for CPE on notification in the tradstdnonpkg lookup. Mark as processed and skip.
    	Test.startTest();	
    	prepareTest();
    	 
    	invokeBatch();
    	Test.stopTest();
    	
        //system.debug(logginglevel.error,'cases:'+[select Id from case where caseautomationreason__c='AITranNpkgRxplaidmismatch']);
        //mistmatch 
        //Feb 15: just checking if they were marked as processed.
        system.assert([select Id from Notificationstandard__c where package__c=false and processed__c=false].size()==0);//notifications with cpe=1234567AA2013-11-02 will find a crd and hence will be processed.
        //system.assert([select Id from case where CRD_ID__c=:crdId AND rxplanid1__c='512456789' AND caseautomationreason__c='AITranNpkgRxplaidmismatch'].size()==1);//make sure we did not add another case.
        //mismatch with existing case record.
        
    }
   
    static testMethod void CRDcpMatch() {
    	//sysytem could not find a match based on the CPE, tries to find a match based on cp, insert new entries into traditionalnonpkg lookup table. Mark as processed.
    	Test.startTest();	
    	prepareTest();
    	//insert entries for 7234567AA2013-11-02's CP: 7234567AA but with a diff eff date into nonpkglkp
    	Id crdId=[select Id from CRD__c where rxplanid__c='012456789'][0].Id;
    	Id crdId2=[select Id from CRD__c where rxplanid__c='112456789'][0].Id;
    	date olderDate = date.newInstance(1987, 2, 17);
    	date olderDate2 = date.newInstance(2000, 2, 17);
    	date futureDate = date.newInstance(2087, 2, 17);
    	List<TraditionalNonPkgLookup__c> NpklookupLocal=new List<TraditionalNonPkgLookup__c>();
    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='7234567AA1987-02-17',key__c='3'+string.valueOf(system.now()),effectiveDate__c=olderDate,ControlPlan__c='7234567AA')); //lkp1
    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId2,ControlPlanEffective__c='7234567AA2001-02-17',key__c='4'+string.valueOf(system.now()),effectiveDate__c=olderDate2,ControlPlan__c='7234567AA')); //lkp2 this will get picked
    	 NpklookupLocal.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='7234567AA2087-02-17',key__c='5'+string.valueOf(system.now()),effectiveDate__c=futureDate,ControlPlan__c='7234567AA')); //lkp3
    	 insert NpklookupLocal;      
        invokeBatch();
        Test.stopTest();
        //it should have picked up lkp1 based on the controlplan and record's effective date. Inserted a new record into the nonpkg lookup table.
        
        system.assert([select id from TraditionalNonPkgLookup__c where ControlPlanEffective__c='7234567AA2013-11-02' AND CRD__c=:crdid2].size()==1); //nonpkg lookup entries
        system.assert([select id from NotificationStandard__c where processed__c=false].size()==0); 
        
    }
    
    static testMethod void noCRDs() {
    	//no match on either CPE or CP found. Or if found using CP, the effective date on Notif is less than what we found using CP. Create a entry in 
    	//traditionalnonpkg lookup WITHOUT CRDID.
    	
    	Test.startTest();	
    	prepareTest(); //cpe: 3434567AA2013-11-02
    	//inserting another record that finds a cp match, but the effective date is greater.
    	Id crdId=[select Id from CRD__c where rxplanid__c='012456789'][0].Id;
    	date futureDate = date.newInstance(2087, 2, 17);
    	
    	insert (new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='7234567AA2087-02-17',key__c='4'+string.valueOf(system.now()),effectiveDate__c=futureDate,ControlPlan__c='7234567AA')); //lkp2 	
    	//inserting lookup entry without CRD, so it doesn't get created again.
    	insert (new TraditionalNonPkgLookup__c(ControlPlanEffective__c='3434567AA2013-11-02',key__c='null3434567AA2013-11-02')); //without crdid entry, a new entry should not be created.	
    	ID batchprocessid =invokeBatch();
        Test.stopTest();
        system.debug(logginglevel.error,'Job status:'+[SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ][0]);
        
       //2 new entries in nonpkg lookup table.
        system.assert([select id from TraditionalNonPkgLookup__c where ControlPlanEffective__c='7234567AA2013-11-02' AND CRD__c=NULL].size()==1); //nonpkg lookup entrie. CP found but effective date is greater 2087 vs 2013
        system.assert([select id from TraditionalNonPkgLookup__c where ControlPlanEffective__c='3434567AA2013-11-02' AND CRD__c=NULL].size()==1); //nonpkg lookup entrie
        system.assert([select id from NotificationStandard__c where processed__c=false].size()==0); //notifications are processed
    }
   
    private static void prepareTest(){
    	//data setup
			insert Test_DataGen_CaseAutomation.CRDGenerator();
			insert Test_DataGen_CaseAutomation.TradNonPkgLookupGenerator();
			insert Test_DataGen_CaseAutomation.CaseGenerator();
			insert Test_DataGen_CaseAutomation.StdNPkgDataGen();
			
		//Inserted data
			system.debug(logginglevel.error,'TradNpklk:'+[select crd__c,controlplaneffective__c from TraditionalNonPkgLookup__c]);
			system.debug(logginglevel.error,'CRDs:'+[select Rxplanid__c from crd__c]);
			system.debug(logginglevel.error,'Cases:'+[select Rxplanid1__c from Case]);
			system.debug(logginglevel.error,'NotificationStandards:'+[select Name,CreatedDate,ControlPlanEffective__c,Rxplanid__c,Package__c,Processed__c,Traditional__c from NotificationStandard__c]);
		
    }
    
    private static Id invokeBatch(){
    	//invocation
			  Schema.DescribeSObjectResult  DescribeRec=NotificationStandard__c.sObjectType.getDescribe();
	        //get all field names
	        Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
	        String qry='';
	        for(String s:FieldsMap.keyset()){
	           qry+=s+',';
	        }
	        qry=qry.left(qry.length()-1); //removing the extra comma
	                
	        String s='SELECT '+qry+' FROM NotificationStandard__c where Package__c=false AND ControlPlanEffective__c!=NULL ORDER BY Name DESC';
	        BAT_TradStdNPkgProcessor bch=new BAT_TradStdNPkgProcessor(s);
	       	return Database.executeBatch(bch,200);
			
    }
}