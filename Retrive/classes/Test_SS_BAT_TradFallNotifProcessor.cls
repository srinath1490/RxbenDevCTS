/**
 * Test class for BAT_TradFallNotifProcessor.cls
 */
@isTest
private class Test_SS_BAT_TradFallNotifProcessor {

    static testMethod void myUnitTest() {
    	Test.startTest();	
    	prepareTest();
    	
    	ID batchprocessid =invokeBatch();
        Test.stopTest();
        system.debug(logginglevel.error,'Job status:'+[SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ][0]);
        
       	system.debug(logginglevel.error,'Cases in sysytem:'+[select controlplaneffective__c,open__c,RecordType.Name,CaseAutomationReason__c from Case]);
        
        //asserts
         //case
        system.assert([select Id from case where controlplaneffective__c='7234567AA2013-11-02' AND caseautomationreason__c='AITradFallout'].size()==1);//this is a new case
        system.assert([select Id from case where controlplaneffective__c='1234567AA2013-11-02' AND caseautomationreason__c='AITradFallout'].size()==1);//we did not create a new case.
         //notificaitonerror
          system.debug(logginglevel.error,'NotificationErrors:'+[select Id,ErrorType__c,ErrorDescription__c,case__c from NotificationError__c]);//even there are two dupes, the end result should only have 1 for errtype+errodesc
         
        system.assert([select Id from NotificationError__c where ErrorType__c='121' AND ErrorDescription__c='Pricing' AND case__r.controlplaneffective__c='7234567AA2013-11-02'].size()==1);//Only pricing ones were processed
        system.assert([select Id from NotificationError__c where case__r.controlplaneffective__c='1234567AA2013-11-02'].size()==1);//only pricing error was considered.
        //Oct 9- for like packge plans, checking to make sure pers seed record is inserted.
        system.assert([select Id from PERS_seed__c where Key__c='1124567891234567AA11/02/2013' and Yschedule__c='Y4' and Fallout__c=false and SentToDS__c=false and Fallout_Counter__c=0 and SenttoPCC__c=false].size()==1);
        system.assert([select Id from PERS_seed__c where Key__c='9999567891234567AA11/02/2013' and Yschedule__c='Y4' and Fallout__c=false and SentToDS__c=false and Fallout_Counter__c=0 and SenttoPCC__c=false].size()==0); //rxplanid does not match like package CRD.
        
    }
    
    
    private static void prepareTest(){
    	//data setup
			//insert Test_DataGen_CaseAutomation.NotifErrorGenerator();
			insert Test_DataGen_CaseAutomation.FalloutDataGen();
			insert Test_DataGen_CaseAutomation.FallCaseGenerator();
			insert Test_DataGen_CaseAutomation.CRDGenerator();
		//Inserted data
       	    system.debug(logginglevel.error,'Cases in sysytem:'+[select Rxplanid1__c,open__c,RecordType.Name,CaseAutomationReason__c from Case]);
			system.debug(logginglevel.error,'NotificationError__c:'+[select Name,CreatedDate,errortype__c,errordescription__c from NotificationError__c]);
		
    }
    
    private static Id invokeBatch(){
    	//Query to be passed to BAT_TradFallNotifProcessor class
        String qry='';   
        Schema.DescribeSObjectResult  DescribeRec=NotificationFallout__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> parentFieldsMap= DescribeRec.fields.getMap();
            for (String s:parentFieldsMap.keyset()){
               qry+=s+',';
            }
        qry=qry.left(qry.length()-1); 
        String query = 'SELECT '+qry+ ' FROM NotificationFallout__c WHERE Processed__c=False AND ControlPlanEffective__c!=NULL';
        
        //Storing the Batch ID and calling the BAT_TradFallNotifProcessor(String) class
        return database.executeBatch(new BAT_TradFallNotifProcessor(query) );
        
    }
}