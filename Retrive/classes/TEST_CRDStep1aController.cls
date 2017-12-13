/*Purpose: Apex Test Class for VFP_CRDStep1aController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/6/2011       Apex Test Class for VFP_CRDStep1aController.
======================================================================== 
*/
@isTest
private class TEST_CRDStep1aController{
    static testMethod void testPlanInformationStep1a(){
       
        CRD__c testCrdToClone=new CRD__c();
        testCrdToClone.crd_automated__c=True;
        insert testCrdToClone;
        
        CRD__c testDummyCrdToClone=new CRD__c();
        testDummyCrdToClone.crd_automated__c=True;
        insert testDummyCrdToClone;

        Copay_Tier__c copayTier = new Copay_Tier__c();       
        copayTier.CRD__c = testDummyCrdToClone.id;
        copayTier.Percent__c=10;
        insert  copayTier;  
        
        SteppedCopay__c steppedCopay = new SteppedCopay__c();
        steppedCopay.Copay_Tier__c = copayTier.id;
        steppedCopay.Dollar_Amount__c=10;
        insert SteppedCopay;
        
        Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
        drugSCopay.CRD_ID__c =  testDummyCrdToClone.id;  
        insert drugSCopay; 
        
        Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
        drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
        drugSSteppedCopay.Dollar_Amount__c=10;
        insert drugSSteppedCopay; 
        
        PSP_Junction__c pspJunction=new PSP_Junction__c();
        pspJunction.CRD_ID__c=testDummyCrdToClone.id;  
        insert pspJunction;
        
        Save_A_Copay_Junction__c saveACopay=new Save_A_Copay_Junction__c();
        saveACopay.CRD_ID__c=testDummyCrdToClone.id;  
        insert saveACopay;
        
        CRD_Step_Therapy_Junction__c stepTherepyJunction = new CRD_Step_Therapy_Junction__c();
        stepTherepyJunction.CRD_ID__c=testDummyCrdToClone.id;  
        insert stepTherepyJunction;
        
        
        Network_Junction__c netWorkJunction = new Network_Junction__c();
        netWorkJunction.CRD_ID__c=testDummyCrdToClone.id;
        netWorkJunction.Network_Mail__c='test';  
        insert netWorkJunction;          
        
        Pricing__c pricing = new Pricing__c();
        pricing.CRD__c=testDummyCrdToClone.id;  
        insert pricing;

        /* Commented by Sushant: Req 04937
        CVS_Web_Access_Users__c webUsers = new CVS_Web_Access_Users__c();
        webUsers.Last_4_digits_of_SSN__c='1234';
        webUsers.CRD_ID__c=testDummyCrdToClone.id;  
        insert webUsers;
        */
        
        RxCheck_Junction__c rxJunction = new RxCheck_Junction__c();
        rxJunction.CRD__c=testDummyCrdToClone.id;  
        insert rxJunction;
  
        Drug_Coverage__c drugCoverage = new Drug_Coverage__c();
        drugCoverage.CRD_ID__c=testDummyCrdToClone.id;  
        drugCoverage.Do_you_have_Choose_Generic__c='Yes';
        drugCoverage.Choose_Generic_Copay_Diff_Exclusion__c='Not elected';
        insert drugCoverage;
        
        Accumulations__c acum=new Accumulations__c();
        acum.CRD_ID__c=testDummyCrdToClone.id;  
        insert acum;     
        
        AccumulationSpecificDrug__c accumDrug=new AccumulationSpecificDrug__c();
        accumDrug.Accumulations_ID__c= acum.id;
        insert  accumDrug;
              
         
                
               
               
              
        
        
        CRD__c testCrd=new CRD__c();
        testCrd.crd_automated__c=True;
        testCrd.Standard_Plan_Selection__c = testDummyCrdToClone.id;
        insert testCrd;
               
       // Instanciate  Visualforce Page
        PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1a; 
        Test.setCurrentPage(newCrdPlanInformationStep1); 
        newCrdPlanInformationStep1.getParameters().put('id',testCrd.id);    
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CRDStep1aController  controller = new VFP_CRDStep1aController (s);
        
        testCrd.Are_you_creating_a_Package_Plan__c ='Yes';
        controller.getPlanType();
        testCrd.Are_you_creating_a_Package_Plan__c ='no';
        
        controller.getPlanType();        
        //controller.redirectToStep2();
        testCrd.Are_you_creating_a_Package_Plan__c ='Yes';
        controller.existingStandardPlan = null;//testCrd.Standard_Plan_Selection__c;        
        testCrd.Standard_Plan_Selection__c = testCrdToClone.Id; 
                
        controller.redirectToStep2();

        
        controller.crd=testCrd;
       
        controller.redirectToStep1();     
        
                        
        controller.crd.Standard_or_Custom_Plan__c = 'Creating a custom plan';
         
        controller.showPanel();
          /*   delete accumDrug;
            delete acum;
            delete drugCoverage;
            delete rxJunction;
            delete webUsers;
            delete pricing;
            delete netWorkJunction;
            delete drugSSteppedCopay;
            delete drugSCopay;
            delete SteppedCopay;
            delete copayTier;
            delete stepTherepyJunction;
            delete saveACopay;
            delete pspJunction;
            delete testCrdToClone;  */
       // delete testCrd;
        controller.redirectToStep1(); 
controller.crd.Standard_or_Custom_Plan__c = 'Cloning a package plan from existing CRD';
controller.existingStandardPlan = testCrdToClone.Id;       
        controller.redirectToStep2(); 
  
    }
    

}