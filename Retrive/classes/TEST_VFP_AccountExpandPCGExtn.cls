@isTest (seeAllData=True)
private class TEST_VFP_AccountExpandPCGExtn{
    static testMethod void test_AccountPCGExtn(){
        test.startTest();
        Account testacc = new Account();
        testacc.Name = 'test1';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        CRD__c testcrd = new CRD__c();
        testcrd.Account__c = testacc.id;
        testcrd.Plan_Type_Retail__c=True;
        insert testcrd;
        Full_Control_Group__c testfcg = new Full_Control_Group__c();
        testfcg.Account_Name__c= testacc.id;
        insert testfcg;
        CSAP_CGLP_Junction__c testjuncobj = new CSAP_CGLP_Junction__c();
        testjuncobj.CRD__c = testcrd.id;
        testjuncobj.Full_Control_Group__c = testfcg.id;
        insert testjuncobj;
        PageReference  VFPage= Page.VF_AccountExpandPCGs;               
        Test.setCurrentPage(VFPage);             
        ApexPages.StandardController s = new ApexPages.standardController(testacc);                   
        VFP_AccountExpandPCGExtn controllerClass = new VFP_AccountExpandPCGExtn(s);
        controllerClass.getBCTGroup(); 
        test.stopTest();
    }

}