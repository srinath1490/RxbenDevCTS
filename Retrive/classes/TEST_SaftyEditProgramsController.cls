@isTest
private class TEST_SaftyEditProgramsController{
    Static testMethod void seCas51testmethod(){
                CRD__c testCrd=new CRD__c(); 
        testCrd.Insured_Type__c='Split Funded';
        //testCrd.Account_New_Value__c = testacc.id;
        //testCrd.Account__c = testacc.id;
        testCrd.Custom_Safety_Edits__c = 'No';
        testCrd.Plan_Type_Mail__c = True;

        testCrd.Plan_Platform__c ='Aetna Student Health';                   
        insert testCrd;
                System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_SaftyEditProgramsController  controller =new VFP_SaftyEditProgramsController(stdcontroller);   
       controller.waverForm = null;    
       controller.crd = null;
        controller.uploadWaverForm();
        controller.crd = testcrd;
        testCrd.Opt_out_of_Safety_Edits__c = 'No';        
        controller.validateOptOutEdits();
         controller.lstWrapperItems.add(new VFP_SaftyEditProgramsController.saftyEditWrapper());
         controller.validateOptOutEdits();
         
        //Drug_list__c dl =new Drug_list__c();
    }
    Static testMethod void seCase1testmethod(){
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        CRD__c testCrd=new CRD__c(); 
        testCrd.Insured_Type__c='Self Insured';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Custom_Safety_Edits__c = 'No';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Aetna Student Health';                   
        insert testCrd;
        GC_UtilityClassTestData testData= new GC_UtilityClassTestData();
        Drug_Group__c dg= new Drug_Group__c();
        dg = testData.createDrugGroup();
        dg.Platform__c='Aetna Student Health';
        dg.Standard__c=true;
        dg.Funding__c='Self Insured';
        dg.Special_Use__c='Safety Edit';
        insert dg;                   
        Drug_List__c dl1= new Drug_List__c();
        dl1= testData.createDrugList();
        insert dl1;
        CRD_Standard_Safety_Edit_Junction__c seJunctionRecord= new CRD_Standard_Safety_Edit_Junction__c();
        seJunctionRecord.Drug_List__c=dl1.id;
        seJunctionRecord.CRDID__c=testCrd.id;
        insert seJunctionRecord;
       
        Drug_List__c dl23= new Drug_List__c();
        dl23= testData.createDrugList();
        insert dl23; 
        seJunctionRecord.Drug_List__c=dl23.id;
        seJunctionRecord.Is_Standard__c=false; 
        update seJunctionRecord;


        CRD_Standard_Safety_Edit_Junction__c seJunctionRecord1 = new CRD_Standard_Safety_Edit_Junction__c();
        seJunctionRecord1.Drug_Group__c=dg.id;
        seJunctionRecord1.CRDID__c=testCrd.id;
        insert seJunctionRecord1;
        
        Test.setCurrentPageReference(new PageReference('Page.SafetyEditPrograms')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_SaftyEditProgramsController  controller =new VFP_SaftyEditProgramsController(stdcontroller);       
        Drug_list__c dl =new Drug_list__c();
        dl = testData.createDrugList();
        
        VFP_SaftyEditProgramsController.saftyEditWrapper sew = new VFP_SaftyEditProgramsController.saftyEditWrapper();
        sew.SaftyEditItem.Drug_List__c = dl1.Id;
        controller.lstDrugGroupForSFE.add(new VFP_SaftyEditProgramsController.saftyEditWrapper());
        controller.lstDrugGroupForSFE.add(new VFP_SaftyEditProgramsController.saftyEditWrapper());
        
        controller.lstWrapperItems.add(new VFP_SaftyEditProgramsController.saftyEditWrapper());
        controller.lstWrapperItems.add(new VFP_SaftyEditProgramsController.saftyEditWrapper());
        controller.displayDrugGroups();  
        controller.addNewItem();
        controller.lstWrapperItems[0].SaftyEditItem.Drug_List__c=dl.id;
        controller.populateDrugListData();
        controller.lstWrapperItems[0].selected=true;
        controller.deleteJunctionObjetRecords();
        controller.addNewItem();
        controller.lstWrapperItems[0].SaftyEditItem.Drug_List__c=dl.id;
        controller.populateDrugListData();
        controller.lstWrapperItems[0].selected=true;
        controller.waverForm=new attachment();
        controller.uploadWaverForm();
        controller.crd.Custom_Safety_Edits__c = 'Yes';
        controller.validateNonOptEdits();
        controller.validateOptOutEdits();
        controller.nextbutton(); 
        

     }
 
      
       Static testMethod void seCase2testmethod(){
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        CRD__c testCrd=new CRD__c(); 
        testCrd.Insured_Type__c='Split Funded';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Custom_Safety_Edits__c = 'No';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Aetna Global BenHealth';                   
        insert testCrd;
        GC_UtilityClassTestData testData= new GC_UtilityClassTestData();
        Drug_Group__c dg= new Drug_Group__c();
        dg = testData.createDrugGroup();
        dg.Platform__c='Aetna Student Health';
        dg.Standard__c=true;
        dg.Funding__c='Fully Insured';
        dg.Special_Use__c='Safety Edit';
        insert dg;
        Test.setCurrentPageReference(new PageReference('Page.SafetyEditPrograms')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_SaftyEditProgramsController  controller =new VFP_SaftyEditProgramsController(stdcontroller);
        controller.displayDrugGroups();  
        controller.backbutton();    
        controller.backbutton2();
        controller.nextbutton2();   

     }  
     Static testMethod void seCase3testmethod(){
        Account testacc= new Account();
        testacc.Name= 'druglist account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        CRD__c testCrd=new CRD__c(); 
        testCrd.Insured_Type__c='Split Funded';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Custom_Safety_Edits__c = 'No';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Aetna Student Health';                   
        insert testCrd;
        GC_UtilityClassTestData testData= new GC_UtilityClassTestData();
        Drug_Group__c dg= new Drug_Group__c();
        dg = testData.createDrugGroup();
        dg.Platform__c='Aetna Student Health';
        dg.Standard__c=true;
        dg.Funding__c='Fully Insured';
        dg.Special_Use__c='Safety Edit';
        insert dg;
        Test.setCurrentPageReference(new PageReference('Page.SafetyEditPrograms')); 
        System.currentPageReference().getParameters().put('crdid', testCrd.id);
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_SaftyEditProgramsController  controller =new VFP_SaftyEditProgramsController(stdcontroller);       
        Drug_list__c dl =new Drug_list__c();
        dl = testData.createDrugList();        
        controller.addNewItem();
        controller.lstWrapperItems[0].SaftyEditItem.Drug_List__c=dl.id;
        controller.populateDrugListData();
        controller.lstWrapperItems[0].selected=true;
        controller.deleteJunctionObjetRecords();
        controller.addNewItem();
        controller.lstWrapperItems[0].SaftyEditItem.Drug_List__c=dl.id;
        controller.populateDrugListData();
        controller.lstWrapperItems[0].selected=true;
         controller.waverForm=new attachment();
        controller.uploadWaverForm();
        controller.backbutton(); 
       

     }     
Static testMethod void seCase4testmethod(){
            Account testacc= new Account();
            testacc.Name= 'druglist account';
            testacc.A_c_Email__c='a@a.com';
            insert testacc;
            CRD__c testCrd=new CRD__c(); 
            testCrd.Insured_Type__c='Split Funded';
            testCrd.Account_New_Value__c = testacc.id;
            testCrd.Account__c = testacc.id;
            testCrd.Custom_Safety_Edits__c = 'No';
            testCrd.Plan_Type_Mail__c = True;
            testCrd.Plan_Platform__c ='Aetna Student Health';                   
            insert testCrd;
            GC_UtilityClassTestData testData= new GC_UtilityClassTestData();
            Drug_List__c dl= new Drug_List__c();
            dl = testData.createDrugList();
            insert dl;
            CRD_Standard_Safety_Edit_Junction__c seJunctionRecord= new CRD_Standard_Safety_Edit_Junction__c();
            seJunctionRecord.Drug_List__c=dl.id;
            seJunctionRecord.CRDID__c=testCrd.id;
            insert seJunctionRecord;

            
            Test.setCurrentPageReference(new PageReference('Page.SafetyEditPrograms')); 
            System.currentPageReference().getParameters().put('crdid', testCrd.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_SaftyEditProgramsController  controller =new VFP_SaftyEditProgramsController(stdcontroller);
            controller.addNewItem();
            controller.nextbutton();

            }         
    
}