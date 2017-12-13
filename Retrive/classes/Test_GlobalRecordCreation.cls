@isTest
private class Test_GlobalRecordCreation {
	static testMethod void createGlobalPositive() {

        //test data setup
        Case testSourceRec=testdatasetup(); //get test record
        insert testSourceRec; //insert test record
        ApexPages.StandardController sc = new ApexPages.StandardController(testSourceRec); //create a standardController since the code needs one to create object.

        //constructing 
        GlobalRecordCreation grcObj=new GlobalRecordCreation(sc);

        //invoking methods
        PageReference pr=grcObj.CreateGlobal();
        //Id globalRecordid=pr.getParameter('Id');
        
       //System.assertNotEquals(globalRecordid,NULL);
    }

    //Utility method used to create test pers audit record.
    private static Case testdatasetup(){
        Account TestAccount = new Account();
        TestAccount.name = 'Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        Database.insert (TestAccount,false);
        
        Case TestCase = new Case();
        TestCase.Origin = 'Web Form';
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestCase.RecordTypeId = rt.Id;
        TestCase.Status = 'New';
        TestCase.Related_PSUnique__c = '11223344';
        TestCase.Aetna_Case_Type__c='Account Manager Case';
        return TestCase; //return the record without inserting.
    }
}