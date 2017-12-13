@isTest
private class TEST_AHOProgramsController{
    Static testMethod void ahotestmethod(){
        Test.startTest();
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c = 'a@a.com';
        insert testacc;
        CRD__c testCrd=new CRD__c(); 
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';
        testCrd.Aetna_Healthy_Actions__c = 'Yes';
        insert testCrd;
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c DrugList = testdata.createDrugList();
        DrugList.Account__c = testacc.id;
        DrugList.Special_Use__c = 'Aetna Healthy Outcomes';
        DrugList.Clinical_Edit_Code__c=null;
        DrugList.Standard__c= True;
        DrugList.Non_GPI_Non_NDC_Check__c= True;
        DrugList.Description__c = 'test druglist';
        DrugList.Drug_List_Name__c  = 'test record';
        insert DrugList;
        Drug_Group__c testdg = testdata.createDrugGroup();
        testdg.Account__c = testacc.id;
        insert testdg;
        testCrd.Aetna_RxHealthy_Outcomes_Drug_Group__c = testdg.id;
        update testCrd;
        Aetna_RxHealthy_Outcomes_Junction__c ahojunc=new Aetna_RxHealthy_Outcomes_Junction__c();
        ahojunc.CRD_ID__c= testCrd.id;
        ahojunc.Aetna_RxHealthy_Outcomes_Drug_List__c = DrugList.id;
        ahojunc.Selected__c = False;
        insert ahojunc;
        testCrd.Aetna_Rx_Healthy_Outcomes__c ='Yes';
        testCrd.Tier_1_Rx_Reduction_Type__c = 'Percent';
        testCrd.Tier_1_Rx_Reduction_Amount__c = 11;
        testCrd.Tier_2_Rx_Reduction_Type__c = 'Percent';
        testCrd.Tier_2_Rx_Reduction_Amount__c = 22;
        testCrd.Tier_3_Rx_Reduction_Type__c = 'Percent';
        testCrd.Tier_3_Rx_Reduction_Amount__c = 33;
        testCrd.Tier_4_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_4_Rx_Reduction_Amount__c = 44.00;
        testCrd.Tier_5_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_5_Rx_Reduction_Amount__c = 555.00;
        update testCrd;
        
        Test.setCurrentPageReference(new PageReference('Page.VF_AHOPrograms')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController(testCrd);
        VFP_AHOProgramsController controller =new VFP_AHOProgramsController(stdcontroller);
        controller.nextbutton();
        controller.backbutton();  
        controller.nextbutton();
        controller.backbutton();
        
        testCrd.Plan_Platform__c = 'Aetna Student Health';
        testCrd.Tier_1_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_1_Rx_Reduction_Amount__c = 666;
        testCrd.Tier_2_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_2_Rx_Reduction_Amount__c = 777;
        testCrd.Tier_3_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_3_Rx_Reduction_Amount__c = 888;
        testCrd.Tier_4_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_4_Rx_Reduction_Amount__c = 999;
        testCrd.Tier_5_Rx_Reduction_Type__c = 'Dollar Amount';
        testCrd.Tier_5_Rx_Reduction_Amount__c = 555;
        testCrd.ARH_Offering_Type__c='POST AMI';
        update testCrd;
        ApexPages.StandardController stdcontroller1 =new ApexPages.StandardController(testCrd);
        VFP_AHOProgramsController controller1 =new VFP_AHOProgramsController(stdcontroller1);     
        controller1.ahoList[0].Selected__c = true;
        controller1.isChanged = true;
        controller1.nextbutton();
        controller1.backbutton();
        controller1.ahoList[0].Selected__c = False;
        controller1.isChanged = true;
        controller1.backbutton();
        controller1.nextbutton();
        controller1.backbutton2();
        controller1.nextbutton2();
        
        Test.stopTest();
    }


}