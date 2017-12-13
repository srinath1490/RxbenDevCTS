@isTest

private class Test_VFP_CRDSearchController
{
    static testmethod void TestVFPCRDSearchController()
    {
        PageReference PageRef = Page.VF_CRDSearch;
        test.setCurrentPage(PageRef);
        
            
        Account TestAccount = new Account();
        TestAccount.name = 'Test';
        insert TestAccount;
        
        CRD__c TestCRD = new CRD__c();
        TestCRD.Account__c = TestAccount.ID;
        TestCRD.Are_you_creating_a_Package_Plan__c = 'No';
        TestCRD.Plan_Type_Mail__c = true;
        insert TestCRD;
        
         
        Partial_Control_Group__c pCG = new Partial_Control_Group__c();
         pCG.CSAP_Control_ID__c = '810089';
         pCG.CSAP_Plan_ID__c = '22';
         pCG.Product_Indicator__c = 'PPO';
         pCG.Rating_ERB__c = '';
         pCG.Subsegment__c = '';
         pCG.Control_Group_Effective_Date__c = system.Today();
         pCG.Control_Group_Term_Date__c = system.Today();
         pCG.Account__c = TestAccount.id;
         insert pCG;
        
        CSAP_CGLP_Junction__c ccj = new CSAP_CGLP_Junction__c();
        ccj.CRD__c = testcrd.id;
        ccj.Partial_Control_Group__c = pCG.Id;
        ccj.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'CRD to Partial CG' limit 1].Id;
        insert ccj;
        
        ApexPages.StandardController SC = new ApexPages.standardController(TestCRD);
        
        VFP_CRDSearchController controller = new VFP_CRDSearchController(sc);
        
        test.starttest();
        controller.showCSAPListData();
        controller.ShowSearchresults();
        test.stoptest();
        controller.FCGName = 'abc';
        controller.CRDName = 'abc'; 
        controller.ShowSearchresults();       
    }
}