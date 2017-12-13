@isTest
private class TEST_AccumChangeCopay{
    Static testMethod void accChangeCopayTest(){
        Test.startTest();
        
        Account testacc= new Account();
        testacc.Name= 'DC test account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';
        testCrd.Aetna_Healthy_Actions__c = 'Yes';
        testCrd.CRD_Automated__c = TRUE;
        insert testCrd;
        
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        Drug_Coverage__c testDrugCoverage = new Drug_Coverage__c();
        testDrugCoverage.CRD_ID__c= testCrd.ID;
        testDrugCoverage.Do_you_have_Choose_Generic__c='No';
        insert testDrugCoverage;
        
        Drug_Group__c testdg = testdata.createDrugGroup();
        testdg.Account__c = testacc.id;
        insert testdg;
        
        DC_Drug_List_Group__c testDClist = new DC_Drug_List_Group__c();
        testDClist.Related_Drug_Coverage__c= testDrugCoverage.id;
        testDClist.Drug_Group__c= testdg.id;
        testDClist.Drug_Class_Name__c='test class';
        insert testDClist;
        
        DC_Drug_Class__c testDCdc = new DC_Drug_Class__c();
        testDCdc.Drug_Group__c=testdg.id;
        insert testDCdc;
        
        Accumulations__c testAccum = new Accumulations__c();
        testAccum.CRD_ID__c=testCrd.id;
        insert testAccum;
        
        Accumulation_Change_Copay__c testAccumChangeCopay = new Accumulation_Change_Copay__c();
        testAccumChangeCopay.Accumulation_ID__c=testAccum.id;
        insert testAccumChangeCopay;
        testAccumChangeCopay.Dollar_Amount__c=120;
        update testAccumChangeCopay;
        
        Accumulation_Change_Copay_Stepped__c testAccumChangeCopayStepped = new Accumulation_Change_Copay_Stepped__c();
        testAccumChangeCopayStepped.Accumulation_Change_Copay_ID__c=testAccumChangeCopay.id;
        insert testAccumChangeCopayStepped;
        testAccumChangeCopayStepped.Dollar_Amount__c=120;
        update testAccumChangeCopayStepped;
        
        delete testAccumChangeCopayStepped;
        
        delete testAccumChangeCopay;
        
        Test.stopTest();
    }
}