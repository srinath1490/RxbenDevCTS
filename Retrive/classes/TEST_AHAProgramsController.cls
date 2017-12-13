@isTest
private class TEST_AHAProgramsController{
    Static testMethod void ahatestmethod(){
        Test.startTest();
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        CRD__c testCrd=new CRD__c(); 
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Aetna_Healthy_Actions__c = 'Yes';
        testCrd.Plan_Platform__c ='Traditional/PPO';                   
        insert testCrd;
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c DrugList = testdata.createDrugList();
        DrugList.Account__c = testacc.id;
        DrugList.Special_Use__c = 'Aetna Healthy Actions';
        DrugList.Clinical_Edit_Code__c=null;
        DrugList.Standard__c= True;
        DrugList.Non_GPI_Non_NDC_Check__c= True;
        DrugList.Description__c = 'test druglist';
        DrugList.Drug_List_Name__c  = 'test record';
        insert DrugList;
        Drug_Group__c testdg = testdata.createDrugGroup();
        testdg.Account__c = testacc.id;
        insert testdg;
        testCrd.AHA_Drug_Group__c = testdg.id;
        update testCrd;
        AHA_Junction__c ahajunc=new AHA_Junction__c();
        ahajunc.CRD_ID__c= testCrd.id;
        ahajunc.Drug_List_ID__c = DrugList.id;
        ahajunc.Selected__c = True;
        insert ahajunc;
        
        Test.setCurrentPageReference(new PageReference('Page.VF_AHAPrograms')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_AHAProgramsController controller =new VFP_AHAProgramsController(stdcontroller);
        controller.nextbutton();
        controller.backbutton();  
        //controller.saveAHA();
        controller.searchAHA();
        controller.nextbutton();
        controller.backbutton();
        
        
        ApexPages.StandardController stdcontroller1 =new ApexPages.StandardController (testCrd);
        VFP_AHAProgramsController controller1 =new VFP_AHAProgramsController(stdcontroller1);     
       testCrd.Plan_Platform__c = 'Aetna Student Health';
        update testCrd;
        controller1.searchAHA();
        controller1.ahaList[0].Selected__c = true;
        controller1.isChanged = true;
        controller1.nextbutton();
        controller1.searchAHA();
        controller1.ahaList[0].Selected__c = true;
        controller1.backbutton();
        controller1.ahaList[0].Selected__c = False;
        controller1.isChanged = true;
        //controller.saveAHA();
        
        controller1.crd.Offering_Type__c = 'Split Fill';
        controller1.searchAHA();
        controller1.ahaList = null;
        controller1.nextbutton();
        controller1.backbutton();
        controller1.nextbutton2();
        controller1.backbutton2();
        Test.stopTest();
    }


}