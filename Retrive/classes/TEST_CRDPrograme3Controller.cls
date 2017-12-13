Global class TEST_CRDPrograme3Controller{             
    static testmethod void testPrograme3(){ 

           
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
       
        Clinical_Program__c testPrograme =testdata.createClinicalPrograme('Prescription Savings Program');         
        testPrograme.Standard__c = true;
        testPrograme.Funding__c='Self Insured';
        testPrograme.Inactive__c =false;
        testPrograme.Available_to_be_Picked__c = true;
        testPrograme.Available_Date__c = system.today();
        testPrograme.PSP_Expiration_Date__c= system.today()+7;
        insert  testPrograme;
        update testPrograme;
        test.starttest();
        // Instanciate  Drug search Page        
        PageReference Programe3 = Page.VF_CRDPrograme3;        
        Test.setCurrentPage(Programe3); 
        CRD__c testCrd = new CRD__c();
        testCrd.Insured_Type__c ='Self Insured';        
        insert testCrd ;
        Programe3.getParameters().put('crdid',testCrd.id);
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CRDPrograme3Controller controller =new  VFP_CRDPrograme3Controller(s);
        controller.redirectToPrograme2();
        controller.redirectToRxCheck();
        controller.crd.Do_Prescription_Savings_Program__c ='yes';
        controller.searchPrescription();
        controller.redirectToPrograme2();
        controller.redirectToRxCheck();
        controller.crd.Insured_Type__c ='Split Funded';
        controller.searchPrescription(); 
        controller.redirectToPrograme2();
        controller.redirectToRxCheck();
        controller.crd.Plan_Platform__c ='Traditional/PPO';
        controller.searchPrescription(); 
        controller.redirectToRxCheck();  
        controller.redirectToPrograme2(); 
        controller.crd.Do_Prescription_Savings_Program__c ='No';
        controller.searchPrescription();
        controller.redirectToPrograme2();  
        controller.showDrugClass();              
        testCrd.Do_Prescription_Savings_Program__c ='yes';
        testCrd.Mailing_Templates__c='Yes';
        update testCrd;
        ApexPages.StandardController s1 = new ApexPages.standardController(testCrd);
        VFP_CRDPrograme3Controller controller1 =new  VFP_CRDPrograme3Controller(s1);


        testCrd.PSP_Override_Option__c='Yes';
        update testCrd;
        s = new ApexPages.standardController(testCrd);
        VFP_CRDPrograme3Controller newcontroller = new  VFP_CRDPrograme3Controller(s);
        newcontroller.searchPrescription();
        delete testCrd;
        testCrd=new CRD__c();
        insert testCrd;
        Programe3.getParameters().put('crdid',testCrd.id);                              
        s = new ApexPages.standardController(testCrd);
        newcontroller = new  VFP_CRDPrograme3Controller(s);
        

        delete testCrd;
        testCrd=new CRD__c();
        testCrd.PSP_Override_Option__c ='No';
        testCrd.Do_Prescription_Savings_Program__c ='Yes';
        testCrd.Insured_Type__c='Self Insured';
        testCrd.Mailing_Templates__c='Yes';
        insert testCrd;
        Programe3.getParameters().put('crdid',testCrd.id);                              
        s = new ApexPages.standardController(testCrd);
        newcontroller = new  VFP_CRDPrograme3Controller(s);
        newcontroller.searchPrescription();
        newcontroller.showDrugClass();
        newcontroller.redirectToRxCheck2();
        newcontroller.redirectToPrograme22();

        
        testCrd.Do_Prescription_Savings_Program__c ='Yes';
        testCrd.Insured_Type__c ='Insured';
        testCrd.Plan_Platform__c ='Traditional/PPO' ;
        testCrd.Plan_Platform__c='HMO';
        testCrd.Plan_Platform__c='HNO';
        update testCrd;
              
        s = new ApexPages.standardController(testCrd);
        newcontroller  = new  VFP_CRDPrograme3Controller(s);
        newcontroller.showDrugClass();
        Clinical_Program__c cp=new Clinical_Program__c();  
        cp = testdata.createClinicalPrograme('RxCheck');
        cp.Standard__c=true;  
        cp.Clinical_Programs_Name__c='test p';     
        cp.Description__c='test p';                    
        insert cp;
        newcontroller.searchPrescription();
        
        test.stoptest();
        
        }
        static testmethod void testmethod2(){
       GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
       
       test.starttest();
        CRD__c testCrd=new CRD__c();
        testCrd.PSP_Override_Option__c ='No';
        insert testCrd;
        PageReference Programe3 = Page.VF_CRDPrograme3;        
        Test.setCurrentPage(Programe3);
        Programe3.getParameters().put('crdid',testCrd.id); 
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CRDPrograme3Controller newcontroller  = new  VFP_CRDPrograme3Controller(s);

        Clinical_Program__c cp=new Clinical_Program__c();  
        cp = testdata.createClinicalPrograme('RxCheck');
        cp.Standard__c=true;  
        cp.Clinical_Programs_Name__c='test p';     
        cp.Description__c='test p';                    
        insert cp;
                Clinical_Program_Group__c cpg= new Clinical_Program_Group__c();  
        cpg= testdata.creteProgrameGroup('RxCheck','Self Insured');                
        cpg.Clinical_Program_Group_Description__c='test';               
        cpg.Clinical_Program_Group_Name__c='test';                             
        insert cpg;
                          
        Clinical_Program_Junction__c cpJunction=new Clinical_Program_Junction__c ();
        cpJunction.Clinical_Program_Group__c=cpg.id;
        cpJunction.Clinical_Program__c =cp.id;
        insert cpJunction;
        update cpJunction;
           
        Clinical_Program__c cp1=new Clinical_Program__c();  
        cp1 = testdata.createClinicalPrograme('RxCheck');
        cp1.Standard__c=true;  
        cp1.Clinical_Programs_Name__c='test p1';     
        cp1.Description__c='test p1';                    
        insert cp1; 
        newcontroller.searchPrescription();
           
        cpJunction.Clinical_Program__c =cp1.id;
        update cpJunction;
        
        test.stoptest();
        }
}