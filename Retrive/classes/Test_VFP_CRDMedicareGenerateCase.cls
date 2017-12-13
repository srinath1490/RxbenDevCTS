@isTest

Private class Test_VFP_CRDMedicareGenerateCase {
    static testmethod void myUnitTest(){
        CRD_Medicare__c CRDMedicare = new CRD_Medicare__c();
        CRDMedicare.Custom_BEN_ID__c = '123456';
        CRDMedicare.Funding_Type__c = 'Fully Insured';
        CRDMedicare.Request_Type__c = 'HMO';
        CRDMedicare.Risk_Indicator__c = 'R';
        CRDMedicare.RxPlan_ID__c = '654321';
        //CRDMedicare.Status__c='New';
        CRDMedicare.Y_Schedule__c = 'Y2';
        CRDMedicare.CMS_Contract_ID_Plan_PBP_ID__c='456789';
        CRDMedicare.RxPlan_ID__c='123456';
        insert CRDMedicare;

        
        test.starttest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CRDMedicare);
        VFP_CRDMedicareGenerateCase ext = new VFP_CRDMedicareGenerateCase(sc);
        ext .generatecase();
        Test.stopTest();
    }
}