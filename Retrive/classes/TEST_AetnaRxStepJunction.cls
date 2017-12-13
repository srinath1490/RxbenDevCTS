@isTest
private class TEST_AetnaRxStepJunction{   
    Static testMethod void arstestmethod2(){
        CRD__c testCrd=new CRD__c(); 
        testCrd.Aetna_RxStep__c ='Yes';

        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';                   
        insert testCrd;
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c DrugList = testdata.createDrugList();
        //DrugList.Account__c = testacc.id;
        DrugList.Special_Use__c = 'Rx Step';
        DrugList.Clinical_Edit_Code__c=null;
        DrugList.Standard__c= True;
        DrugList.Non_GPI_Non_NDC_Check__c= True;
        DrugList.Description__c = 'test druglist';
        DrugList.Drug_List_Name__c  = 'test record';
        insert DrugList;
                
        Aetna_RxStep_Junction__c arsjunc=new Aetna_RxStep_Junction__c();
        arsjunc.CRD_Id__c= testCrd.id;
        arsjunc.Drug_List__c = DrugList.id;
        arsjunc.Selected__c = True;
        insert arsjunc;
                
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_AetnaRxStepJunction controller =new VFP_AetnaRxStepJunction(stdcontroller );  
        controller.lstRxStep = new list<Aetna_RxStep_Junction__c>();
        controller.lstRxStep.add(arsjunc);
        controller.clearFields();
        controller.lstRxStep  = null;
        controller.next2();
        controller.back2();
    }                                                        
    Static testMethod void arstestmethod(){
        Test.startTest();
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.Aetna_RxStep__c ='Yes';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';                   
        insert testCrd;
        
        
        
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c DrugList = testdata.createDrugList();
        DrugList.Account__c = testacc.id;
        DrugList.Special_Use__c = 'Rx Step';
        DrugList.Clinical_Edit_Code__c=null;
        DrugList.Standard__c= True;
        DrugList.Non_GPI_Non_NDC_Check__c= True;
        DrugList.Description__c = 'test druglist';
        DrugList.Drug_List_Name__c  = 'test record';
        insert DrugList;
       
        
        Aetna_RxStep_Junction__c arsjunc=new Aetna_RxStep_Junction__c();
        arsjunc.CRD_Id__c= testCrd.id;
        arsjunc.Drug_List__c = DrugList.id;
        arsjunc.Selected__c = True;
        insert arsjunc;
        
               
        Test.setCurrentPageReference(new PageReference('Page.VF_AetnaRxStepJunction')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_AetnaRxStepJunction controller =new VFP_AetnaRxStepJunction(stdcontroller);
        controller.next();
        controller.back();          
        controller.searchRxStep();      
        controller.next2();
        controller.back2();
                     
        ApexPages.StandardController stdcontroller1 =new ApexPages.StandardController (testCrd);
        VFP_AetnaRxStepJunction controller1 =new VFP_AetnaRxStepJunction(stdcontroller1);     
       testCrd.Plan_Platform__c = 'Aetna Student Health';
        update testCrd;
        controller1.searchRxStep();
        controller1.lstRxStep [0].Selected__c = true;
        controller1.isChanged = true;
        controller1.next();
        controller1.searchRxStep();
        controller1.lstRxStep [0].Selected__c = true;
        controller1.back();
        controller1.lstRxStep [0].Selected__c = False;
        controller1.isChanged = true;
        
        
        
        Test.stopTest();
    }


}