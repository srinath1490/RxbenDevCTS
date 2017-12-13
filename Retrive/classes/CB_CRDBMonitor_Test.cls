@isTest

public class CB_CRDBMonitor_Test{

    static testMethod void BatchNotifTest(){
        
        List<AsyncApexJob> apexjob = new List<AsyncApexJob>();
        
        Account acc = new Account();
        acc.name = 'Batch Test Acc';
        Insert acc;
        
        Test.startTest();
        ID batchprocessid = database.executeBatch(new Test_Batch_Class(), 1);
        Test.stopTest();
    }
}