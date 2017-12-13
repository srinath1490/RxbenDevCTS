/**
 Test class for Traditional Standard Package processor
 */
@isTest
private class Test_SS_BAT_TradStdPkgProcessor {
	
	static testMethod void fullTest(){
		
		//data setup
			insert Test_DataGen_CaseAutomation.CRDGenerator();
			insert Test_DataGen_CaseAutomation.CaseGenerator();
			insert Test_DataGen_CaseAutomation.StdPkgDataGen();
			//added Feb15,2014 release
			//Ignore notifications that has a case with rxplanid in notification even if the case is no longer open
			createcase casecreator=new createcase();
    		case c=casecreator.pullPackageplan('554556789');
    		c.Open__c=false;
    		insert c;
    	    NotificationStandard__c nsExistingRxplaninClosedCase=new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='554556789',controlplaneffective__c='3400567AA2013/11/02'); //existing rxplanid on closed cases but no CRD yet. 	
    		insert nsExistingRxplaninClosedCase;
		//Inserted data
			system.debug(logginglevel.error,'CRDs:'+[select Rxplanid__c from crd__c]);
			system.debug(logginglevel.error,'Cases:'+[select Rxplanid1__c from Case]);
			system.debug(logginglevel.error,'NotificationStandards:'+[select Name,CreatedDate,ControlPlanEffective__c,Rxplanid__c,Package__c,Processed__c,Traditional__c from NotificationStandard__c]);
		//invocation
			  Schema.DescribeSObjectResult  DescribeRec=NotificationStandard__c.sObjectType.getDescribe();
	        //get all field names
	        Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
	        String qry='';
	        for(String s:FieldsMap.keyset()){
	           qry+=s+',';
	        }
	        qry=qry.left(qry.length()-1); //removing the extra comma
	                
	        String s='SELECT '+qry+' FROM NotificationStandard__c where ControlPlanEffective__c!=NULL ORDER BY CREATEDDATE DESC';
	        BAT_TradStdPkgProcessor bch=new BAT_TradStdPkgProcessor(s);
	   		Test.StartTest();
	       	ID batchprocessid = Database.executeBatch(bch,200);
	   		Test.StopTest();
	        system.debug(logginglevel.error,'Job status:'+[SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ][0]);
			
		//assertions
			//cases
			system.assert([select Id from Case where rxplanid1__c='412456789']!=null);//we create a case for the new rxplanid.
			system.debug(logginglevel.error,'Cases in sysytem:'+[select Rxplanid1__c,open__c,RecordType.Name,CaseAutomationReason__c from Case]);
			
			system.assert(([select Id from Case where rxplanid1__c='312456789']!=null)&&([select Id from Case where rxplanid1__c='312456789'].size()==1));//we did NOT create a case for new rxplanid with case.
			system.assert([select Id from Case where rxplanid1__c='012456789'].isempty());//we did NOT create a case for existing rxplanid with CRD.
			
			
			system.assert([select Id from Case where rxplanid1__c='412456789'].size()==1);//even though there are 3 notif, we only create one.
			
			//Feb15 RELEASE. Rxplanid on notification that exists on closed case without a crd would be ignored.
			system.assert([select Id from Case where rxplanid1__c='554556789' AND Open__c=true].size()==0);//Make sure no additional cases are created.
			system.assert([select Id from TradPkgControlPlanLookup2s__c where rxplanid__c='554556789'].size()==1); //Make sure the entry is still made.
			system.debug(logginglevel.error,'NotificationStandard with existing Rxplanid on NOT OPEN case:'+[select id,processed__c,rxplanid__c from NotificationStandard__c where rxplanid__c='554556789']);
			system.assert([select processed__c from NotificationStandard__c where Id=:nsExistingRxplaninClosedCase.Id][0].Processed__c==true); //its still processed.
			
			
			//casecontrolplan
			system.debug(logginglevel.error,'Casecontrolplan:'+[select ERB__c,ControlPlanEffective__c,Id,case__c,key__c,NotificationTimeStamp__c from CaseControlPlan__c]);
			
			system.assert([select Id,case__c,key__c,NotificationTimeStamp__c from CaseControlPlan__c where controlplaneffective__c='1234567AA2013/11/02'].size()==1);
			
			Id caseId=[select Id from case where rxplanid1__c='412456789'][0].Id;
			system.assert([select Id,case__c,key__c,NotificationTimeStamp__c from CaseControlPlan__c where case__c=:caseId].size()==2);//there are two with same rxplanid, but different controlplaneffective combos
			system.assert([select Id,case__c,key__c,NotificationTimeStamp__c,ERB__c from CaseControlPlan__c where ControlPlanEffective__c='7234567AA2013/11/02'][0].ERB__c=='S'); //should have used the latest record
			
			//Tradlookup1
			system.debug(logginglevel.error,'TradLookup1:'+[select Id,CRD__c,key__c,NotificationTimeStamp__c,rxplanid__c from ControlPlanRxPlan__c]);			
			system.assert([select Id,CRD__c,key__c,NotificationTimeStamp__c,rxplanid__c from ControlPlanRxPlan__c where rxplanid__c='012456789'].size()==1);
			
			//Tradlookup2
			system.debug(logginglevel.error,'TradLookup2:'+[select Id,key__c,NotificationTimeStamp__c,rxplanid__c from TradPkgControlPlanLookup2s__c]);
			system.assert([select Id,key__c,NotificationTimeStamp__c,rxplanid__c from TradPkgControlPlanLookup2s__c where rxplanid__c='312456789'].size()==1);
			system.assert([select Id,key__c,NotificationTimeStamp__c,rxplanid__c from TradPkgControlPlanLookup2s__c where rxplanid__c='512456789'].size()==1);
			system.assert([select Id,key__c,NotificationTimeStamp__c,rxplanid__c from TradPkgControlPlanLookup2s__c where rxplanid__c='412456789'].size()==2);
			
	}

}