@isTest
private class TEST_RxHealthyOutcomes{
    Static testMethod void rxHealthyTest(){
        Test.startTest();
        
        Account testacc= new Account();
        testacc.Name= 'DC test account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Aetna_Healthy_Actions__c = 'yes';
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';
        testCrd.LastSent__c=system.now();                   
        insert testCrd;
        
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        Drug_Coverage__c testDrugCoverage = new Drug_Coverage__c();
        testDrugCoverage.CRD_ID__c= testCrd.ID;
        testDrugCoverage.Do_you_have_Choose_Generic__c='No';
        insert testDrugCoverage;
        
        Drug_Group__c testdg = testdata.createDrugGroup();
        testdg.Account__c = testacc.id;
        insert testdg;
        
        Drug_List__c testDList = testdata.createDrugList();
        insert testDList;
            
        
        Aetna_RxHealthy_Outcomes_Junction__c testRx = new Aetna_RxHealthy_Outcomes_Junction__c();
        testRx.CRD_ID__c=testCrd.id;
        insert testRx;
        testRx.Aetna_RxHealthy_Outcomes_Drug_List__c=testDList.id;
        update testRx;
        
        delete testRx;
        
        Test.stopTest();
    }
}