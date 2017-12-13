@isTest
private class Test_CaseCreationFromGlobal {

    static testMethod void createCasePositive() {

        //test data setup
        Global_Issue_Tracker__c testSourceRec=testdatasetup(); //get test record
        insert testSourceRec; //insert test record
        ApexPages.StandardController sc = new ApexPages.StandardController(testSourceRec); //create a standardController since the code needs one to create object.

        //constructing 
        CaseCreationFromGlobal gcObj=new CaseCreationFromGlobal(sc);

        //invoking methods
        PageReference pr=gcObj.CreateCase();
        //Id caseRecordid=pr.getParameter('Id');
        
       //System.assertNotEquals(caseRecordid,NULL);
    }

    //Utility method used to create test data
    private static Global_Issue_Tracker__c testdatasetup(){
        
        Global_Issue_Tracker__c tg = new Global_Issue_Tracker__c();
        tg.Requester_s_Name__c = 'Test User';
        tg.Requester_s_Email__c = 'testuser@aetna.com';
        tg.Summary_of_Issue__c = 'test summary';
        tg.Issue_Description_Status__c = 'test description status';
        tg.Subject__c = 'test subject';
        tg.Member_ID__c = '123456789';
        return tg; //return the record without inserting.
    }
}