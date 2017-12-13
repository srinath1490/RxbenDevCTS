/*Purpose: Apex Test Class for VFP_CRDPlanInformationStep1.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                9/6/2011       Apex Test Class for VFP_CRDPlanInformationStep1.
======================================================================== 
*/

@isTest
private class TEST_CRDPlanInformationStep1{
    static testMethod void testPlanInformationStep1(){
       GC_UtilityClassTestData testData = new GC_UtilityClassTestData();
       List<CRD__c> crdList = new List<CRD__c>();
       CRD__c testCrd = new CRD__c();
       testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
       testCrd.Which_system_will_the_plan_be_installed__c = 'HNO';
       testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
     //  insert testCrd;
       crdList.add(testCrd);
       
        CRD__c testCrd2 = new CRD__c();
        testCrd2.Are_you_creating_a_Package_Plan__c = 'no';
        testCrd2.Plan_Platform__c='HMO';
        testCrd2.Include_Kit_Logic__c=false;
      //  insert testCrd2;       
        crdList.add(testCrd2);

        
        
        CRD__c testCrd3 = new CRD__c();
        testCrd3.Are_you_creating_a_Package_Plan__c = 'no';
        testCrd3.Plan_Platform__c='Traditional/PPO';
        testCrd3.Insured_Type__c='Fully Insured';
        testCrd3.Do_you_want_to_do_Save_A_Copay__c ='Yes';
        testCrd3.Do_Prescription_Savings_Program__c='Yes';
        testCrd3.Rx_Will_you_be_Picking_Drug_Classes__c ='Yes';
        testCrd3.Sub_Segment__c = 'SG';
        testCrd3.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
        
      //  insert testCrd3;
        crdList.add(testCrd3);
         CRD__c testCrd4 = new CRD__c();
        testCrd4.Insured_Type__c='Fully Insured';
        testCrd4.Do_you_want_to_do_Save_A_Copay__c ='No';
        testCrd4.Do_Prescription_Savings_Program__c='No';
        testCrd4.Rx_Will_you_be_Picking_Drug_Classes__c ='No';
        testCrd4.Plan_Platform__c ='Aetna Student Health';
        testCrd4.plan_type_specialty_oon__c=true;
        testCrd4.plan_type_paper_out_of_network__c=false;
        testCrd4.Sub_Segment__c = 'IVL';
        testcrd4.Medical_Injectible_Claim_Denial_Process__c = '';
        testCrd4.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
        
        
       // insert testCrd4;
        
        crdList.add(testCrd4); 
        insert crdList;
        Network_Junction__c nj = new Network_Junction__c();
        nj.Network_Retail__c = 'Aetna Rx Choice Network';
        nj.CRD_ID__c = crdlist[0].id;
        insert nj;
        Account ac = new Account();
        ac.APM_PSUID__c = 'Test';
        ac.Name='Test ACC';
        ac.Predefined__c = TRUE;
        insert ac;
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.Account_Name__c= ac.id;
        insert fcg;
        
       // Instanciate  Visualforce Page
        PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
        Test.setCurrentPage(newCrdPlanInformationStep1); 
        newCrdPlanInformationStep1.getParameters().put('id',testCrd.id);    
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CRDPlanInformationStep1 controller = new VFP_CRDPlanInformationStep1(s);
        
        Test.startTest();
        controller.editMode = 'BCTME';
        controller.redirectToStep0();
        controller.redirectToStep2();
        controller.PredefAccountPCGFCG();
        controller.redirecttostep3();
        controller.editbutton();
        controller.redirecttostep02();
        controller.modifyCarrier();  
        

              
        ApexPages.StandardController s2 = new ApexPages.standardController(testCrd2);    
        VFP_CRDPlanInformationStep1 controller2 = new VFP_CRDPlanInformationStep1(s2);
        controller2.redirectToStep2();   
        controller2.updateKitLogic();  
        controller2.redirectToStep2();      
        
        
        ApexPages.StandardController s3 = new ApexPages.standardController(testCrd3);    
        VFP_CRDPlanInformationStep1 controller3 = new VFP_CRDPlanInformationStep1(s3);        
        controller3.updateCrd();        
        controller3.updateKitLogic(); 
       
         controller3.redirectToStep0();
         controller3.redirectToStep2();

        ApexPages.StandardController s4 = new ApexPages.standardController(testCrd4);    
        VFP_CRDPlanInformationStep1 controller4 = new VFP_CRDPlanInformationStep1(s4);
        controller4.redirectToStep2();
        controller4.redirectToStep0();
        controller4.clearFields();
        
        testCrd=new CRD__c();
        testCrd.Insured_Type__c='Fully Insured';
        insert testCrd;
        ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
        VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
        newcontroller.redirectToStep2();
        update testCrd;
        
        delete testCrd;
        testCrd=new CRD__c();
        testCrd.SAC_Override_Option__c='Yes';
        insert testCrd;
        newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
        stdController= new ApexPages.standardController(testCrd);
        newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
        newcontroller.redirectToStep2();
        testCrd.SAC_Override_Option__c='No';
        update testCrd;
        newcontroller.crd=testCrd;
        newcontroller.redirectToStep2();
        Test.stopTest();
       
        newcontroller.crd=testCrd;
        newcontroller.redirectToStep2();
        testCrd.Rx_Override_Option__c='No';
       // update testCrd;
        newcontroller.crd=testCrd;
        newcontroller.redirectToStep2();
        testCrd.PSP_Override_Option__c='Yes';
      //  update testCrd;
        newcontroller.crd=testCrd;
        newcontroller.redirectToStep2();
        testCrd.PSP_Override_Option__c='No';
      //  update testCrd;
        newcontroller.crd=testCrd;
        newcontroller.redirectToStep2();
        newcontroller.getCRDPricing();
        newcontroller.getHideForBCTC();
        newcontroller.getCrdPartialGroup();
        newcontroller.aiRequest = new AI_Request__c();
        //newcontroller.aiRequest.Benefit__c = 'abc';
         newcontroller.aiRequest.Benefits_String_Extn__c = 'abc';
          newcontroller.aiRequest.Integration_1__c = 'abc';
           newcontroller.aiRequest.Pricing_Schedule__c = 'abc';
            newcontroller.aiRequest.StateList_to_Remove__c = 'abc';
            newcontroller.callout();
       }
       
 
    
       static testMethod void testPlanInformationStep1test1()
       {
           CRD__c testCrd=new CRD__c();
          testCrd.Insured_Type__c='Fully Insured';
         
          testCrd.Rating__c='Prospective';
          testCrd.TP_ID__c='test';
          testCrd.Rx_PP_ID__c='test';
          testCrd.Y_Schd__c='test';
          testCrd.Platform_Information__c='H';
          testCrd.Which_system_will_the_plan_be_installed__c ='HMO';
          testCrd.Sub_Segment__c = 'SG';
          insert testCrd;
          Account ac = new Account();
            ac.APM_PSUID__c = 'Test';
            ac.Name='Test ACC';
            ac.Predefined__c = TRUE;
            insert ac;
            testcrd.account__c = ac.id;
         Partial_Control_Group__c pcg = new Partial_Control_Group__c();
            pcg.Account__c= ac.id;
            insert pcg;
          PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
          Test.setCurrentPage(newCrdPlanInformationStep1); 
          newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.managementUserID = 'test';
          newcontroller.managementgroupID = 'testing';
          newcontroller.CrdPartialGroup = true;
          newcontroller.predefBol = true;
          newcontroller.updateCarrier = true;
          newcontroller.FCGpredefinedName = 'test';
          newcontroller.PCGpredefinedName = 'test';
          newcontroller.ispcgfcgerror = true;
          newcontroller.crd.Client_Contact_Phone__c ='1234';
          newcontroller.sendPPID1(); 
          newcontroller.sendTPID1();
          newcontroller.sendBenId();
          newcontroller.redirectToStep0();
          newcontroller.redirectToStep2();   
          newcontroller.PredefAccountPCGFCG();
          newcontroller.updateKitLogic();
           Test.startTest();
         newcontroller.crd.Client_Contact_Phone__c ='(999) 999-9999'; 
       /*   newcontroller.sendTPID1();
          newcontroller.sendPPID1();
          newcontroller.sendBenId();*/
          testCrd.Rating__c='Prospective';
          testCrd.Which_system_will_the_plan_be_installed__c ='Traditional';
          testCrd.Benefits_State_List__c ='NA;BP';
          testCrd.Rx_PP_ID__c=null;
          testCrd.Sub_Segment__c = 'SG';
          testCrd.Plan_Platform__c ='Discount Card';
          testcrd.Plan_Type_Mail__c = true;
          testcrd.Plan_Type_Paper__c = true;
          testcrd.Medical_Injectible_Claim_Denial_Process__c = '';
          update testCrd;
          newcontroller.crd=testCrd;
          newcontroller.sendTPID1();
          newcontroller.callout();
        //  newcontroller.sendPPID1();
         // newcontroller.sendBenId();
          testCrd.Rx_PP_ID__c='test';
          testCrd.Which_system_will_the_plan_be_installed__c = system.label.CL0000035;
        //  testCrd.Chronic_and_or_Preventive_List__c = 'Both';
          testCrd.TP_ID__c=null;
          update testCrd;
          newcontroller.crd=testCrd;
         // newcontroller.sendTPID1();
          newcontroller.sendPPID1();
          newcontroller.callout();
          
          newcontroller.sendBenId();    
               test.stopTest();  
          
                      
       }
       
       
       static testMethod void testPlanInformationStep1test2()
       {
      CRD__c testCrd = new CRD__c();
        testCrd.Insured_Type__c='Fully Insured';
        insert testCrd;
        ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
        VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
         /*  newcontroller.crd.Do_you_want_to_do_Save_A_Copay__c ='Yes';  
           newcontroller.redirectToStep0();
           newcontroller.crd.Do_you_want_to_do_Save_A_Copay__c ='No';
           newcontroller.redirectToStep0();           
           newcontroller.crd.Do_Prescription_Savings_Program__c ='Yes';
           newcontroller.redirectToStep0();           
           newcontroller.crd.Do_Prescription_Savings_Program__c ='No';  
           newcontroller.redirectToStep0();           
           newcontroller.crd.Rx_Will_you_be_Picking_Drug_Classes__c ='Yes';
           newcontroller.redirectToStep0();
           newcontroller.crd.Rx_Will_you_be_Picking_Drug_Classes__c ='No';
           newcontroller.redirectToStep0();
           newcontroller.crd.Insured_Type__c='self Insured'; 
           newcontroller.redirectToStep0();
           newcontroller.crd.SAC_Override_Option__c='Yes';
           newcontroller.redirectToStep0();
           newcontroller.crd.SAC_Override_Option__c='No';
           newcontroller.redirectToStep0();
           newcontroller.crd.Rx_Override_Option__c='Yes';
           newcontroller.redirectToStep0();
           newcontroller.crd.Rx_Override_Option__c='No';
           newcontroller.redirectToStep0();
           newcontroller.crd.PSP_Override_Option__c='Yes';
           newcontroller.redirectToStep0(); */
          test.startTest();
           newcontroller.crd.PSP_Override_Option__c='No';
           newcontroller.redirectToStep0();
           newcontroller.crd.Plan_Platform__c ='Aetna Student Health';
           newcontroller.redirectToStep0();
           
           newcontroller.crd.Insured_Type__c ='Fully Insured';
           
           newcontroller.sendTPID1();
           newcontroller.sendPPID1();
           newcontroller.sendBenId();
           test.stopTest();     
         
             
           
          
      }
      
      static testMethod void testPlanInformationStep1test3(){

         CRD__c testCrd = new CRD__c();
        testCrd.Insured_Type__c='Fully Insured';
        testCrd.Override_Retail_Y_Schedule__c='No';
        insert testCrd;
        ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
        VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
            
           newcontroller.crd.Insured_Type__c ='self Insured';           
           newcontroller.sendTPID1();
           newcontroller.sendPPID1();
           newcontroller.sendBenId();
           Test.StartTest();
           newcontroller.crd.Insured_Type__c ='split funded';
           newcontroller.sendTPID1();
           newcontroller.sendPPID1();
           newcontroller.sendBenId(); 
           newcontroller.overideYscheduleValues();
           test.stoptest();  
      }
      
      static testMethod void testPlanInformationStep1test4(){
          //moved from testPlanInformationStep1test1
          
          test.startTest();
             CRD__c testCrd=new CRD__c();
          testCrd.Insured_Type__c='Fully Insured';
          testCrd.Rating__c='Prospective';
          testCrd.TP_ID__c='test';
          testCrd.Rx_PP_ID__c='test';
          testCrd.Y_Schd__c='test';
          testCrd.Platform_Information__c='H';
          testCrd.Which_system_will_the_plan_be_installed__c ='HMO';
          insert testCrd;
          
          PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
          Test.setCurrentPage(newCrdPlanInformationStep1); 
          newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          
          testCrd.Rx_PP_ID__c='test';
          testCrd.Which_system_will_the_plan_be_installed__c = system.label.CL0000035;
          testCrd.Custom_Ben_ID__c ='1234';
          testCrd.Rx_PP_ID__c=null;
          testCrd.Override_Retail_Y_Schedule__c='No';
          testCrd.Sub_Segment__c = 'SG';
          testCrd.Plan_Platform__c ='Discount Card';
         // testCrd.Chronic_and_or_Preventive_List__c = null;
          update testCrd;
          newcontroller.crd=testCrd;
          newcontroller.sendTPID1();
          newcontroller.sendPPID1();          
          newcontroller.callout();
          newcontroller.isElementCommon('ab;cd','dt;et'); 
          newcontroller.overrideYschedule();
          newcontroller.checkOverride('Test','Test1');
          newcontroller.sendBenId(); 
          newcontroller.manageHMOFields();
          test.stopTest();
       }
       static testmethod void testPlanInformationStep1test8(){
           test.starttest();
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
           testcrd.plan_platform__c = 'AGB';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'Traditional';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           insert testcrd;
           PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
          Test.setCurrentPage(newCrdPlanInformationStep1); 
          newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          
         newcontroller.redirecttostep0();
         newcontroller.redirectToStep2();
         newcontroller.updateOONPaperNW();
         newcontroller.overideYscheduleValues();
         newcontroller.manageHMOFields();
        
        testCrd.plan_platform__c = 'Aetna Student Help';
        testCrd.Which_system_will_the_plan_be_installed__c =null;
        update testCrd;
        newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
        newcontroller.redirecttostep0();
        test.stoptest();
           
       }
       static testMethod void testPlanInformationStep1test5(){
          //moved from testPlanInformationStep1test1
          test.startTest();
             CRD__c testCrd=new CRD__c();
          testCrd.Insured_Type__c='Self Insured';
         
          testCrd.Rating__c='Prospective';
          testCrd.TP_ID__c='test';
          testCrd.Rx_PP_ID__c='test';
          testCrd.Y_Schd__c='test';
          testCrd.Platform_Information__c='H';
          testCrd.Which_system_will_the_plan_be_installed__c ='HMO';
          testCrd.benefits_state_list__c = 'abc';
          testCrd.list_of_states_to_remove_the_plan__c = 'abc';
          testCrd.plan_platform__c = 'HMO';
          testCRD.contract_state__c = 'CA';
        
       
          insert testCrd;
      
          PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
          Test.setCurrentPage(newCrdPlanInformationStep1); 
          newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          
         newcontroller.redirecttostep0();
         newcontroller.redirectToStep2();
        
        testCrd.plan_platform__c = 'Aetna Student Help';
        testCrd.Which_system_will_the_plan_be_installed__c =null;
        update testCrd;
        newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
        newcontroller.redirecttostep0();
        test.stoptest();
       }   

       //added by JR
       static testMethod void testPlanInformationStep1test6(){
          //moved from testPlanInformationStep1test1
          
          test.startTest();
          CRD__c testCrd=new CRD__c();
          testCrd.Insured_Type__c='Self Insured';
          testCrd.National__c = 'National';
          testCrd.Plan_Platform__c = 'Aetna Student Health';
          testCrd.Integrate_with_Medical__c = '5-PLAN SETUP TO APPROVE';
          testCRD.contract_state__c = 'BR';
          testCrd.Rating__c='Prospective';
          testCrd.Standard_or_Custom_Plan__c='Creating a HIX plan';
          testCrd.TP_ID__c='test';
          testCrd.Risk_Indicator__c = null;
          testCrd.Rx_PP_ID__c='test';
          testCrd.Y_Schd__c='test';
          testCrd.Platform_Information__c='H';
          testCrd.Which_system_will_the_plan_be_installed__c ='HMO';
          testCrd.Do_mandates_apply_to_all_states__c = 'N';
          testCrd.benefits_state_list__c = null;
          testCrd.list_of_states_to_remove_the_plan__c = 'abc';
          testCrd.plan_platform__c = 'Aetna Global Benefits';
          testcrd.Acquisition_Indicator__c = 'Yes';
         // testCrd.Chronic_and_or_Preventive_List__c = 'Chronic';
          insert testCrd;
          
          PageReference newCrdPlanInformationStep1 = Page.VF_NewCRDPlan_Step1; 
          Test.setCurrentPage(newCrdPlanInformationStep1); 
          newCrdPlanInformationStep1.getParameters().put('id',testCrd.id); 
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          
        newcontroller.redirecttostep0();
        newcontroller.redirectToStep2();
        newcontroller.ManageHmoFields();
        testCrd.Which_system_will_the_plan_be_installed__c ='HMO';
         testCrd.Do_mandates_apply_to_all_states__c = 'Y';
        testCrd.benefits_state_list__c = 'abc';
       // testCrd.Chronic_and_or_Preventive_List__c = 'Preventive';
        update testCrd;
        newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
        newcontroller.redirecttostep0();
        newcontroller.redirectToStep2();
        //newcontroller.changelogic();// Commented as on August 16th 2016 Request 06600
        newcontroller.populateMAC();
        newcontroller.ManageHmoFields();
        newcontroller.sendBenId();
        test.stoptest();
       } 
       
       static testmethod void testPlanInformationStep1test9(){
        
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
           testcrd.plan_platform__c = 'AGB';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'Traditional';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           testcrd.Rx_PP_ID__c = null;
           testcrd.TP_ID__c = null;
           testcrd.Custom_Ben_ID__c = 'Test';
           testcrd.Y_Schd__c = 'Test';
           testcrd.Platform_Information__c = 'H';
           testcrd.Risk_Indicator__c = 'S';
           Boolean isValidAccum = True;
           Boolean isValidAI = True;
           Boolean isAccountMapped = True;
           testcrd.Benefits_State_List__c = 'AK';
           testcrd.Do_mandates_apply_to_all_states__c = 'Y';
           testcrd.List_Of_states_to_remove_the_plan__c = 'AL';
           insert testcrd;
           
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.sendBenId();
        
           
       }
       
       static testmethod void testPlanInformationStep1test10(){
        
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
           testcrd.plan_platform__c = 'AGB';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'Traditional';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           testcrd.Rx_PP_ID__c = null;
           testcrd.TP_ID__c = 'Test';
           testcrd.Custom_Ben_ID__c = 'Test';
           testcrd.Y_Schd__c = 'Test';
           testcrd.Platform_Information__c = 'H';
           testcrd.Risk_Indicator__c = 'S';
           Boolean isValidAccum = True;
           Boolean isValidAI = True;
           Boolean isAccountMapped = True;
           testcrd.Benefits_State_List__c = 'AK';
           testcrd.List_Of_states_to_remove_the_plan__c = 'AL';
           insert testcrd;
           
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.sendBenId();
        
           
       }
       
       static testmethod void testPlanInformationStep1test11(){
           Account ac = new Account();
           ac.Name = 'test1';
           insert ac;
           Full_Control_Group__c fcg = new Full_Control_Group__c();
           fcg.Account_Name__c = ac.id;
           insert fcg;
           
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
           testcrd.plan_platform__c = 'AGB';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'Traditional';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           testcrd.Rx_PP_ID__c = null;
           testcrd.TP_ID__c = 'Test';
           testcrd.Custom_Ben_ID__c = 'Test';
           testcrd.Y_Schd__c = 'Test';
           testcrd.Platform_Information__c = 'H';
           testcrd.Risk_Indicator__c = 'S';
           testcrd.Benefits_State_List__c = 'AK';
           testcrd.List_Of_states_to_remove_the_plan__c = 'AL';
           testcrd.Full_Control_Group__c = fcg.id;
           testcrd.Are_you_creating_a_Package_Plan__c = 'Yes';
           testcrd.Which_system_will_the_plan_be_installed__c = null;
           insert testcrd;
           
          
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.redirectToStep0();
           
       }
       
       /* added by Ayushi for 1/22 release 2016 */
       static testmethod void testPlanInformationStep1test12(){
        
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Creating a packaged consumer business plan';
           testcrd.plan_platform__c = 'AGBNAME';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'HRP';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           testcrd.Rx_PP_ID__c = null;
           testcrd.TP_ID__c = 'Test';
           testcrd.Custom_Ben_ID__c = 'Test';
           testcrd.Y_Schd__c = 'Test';
           testcrd.Platform_Information__c = 'H';
           testcrd.Risk_Indicator__c = 'S';
           Boolean isValidAccum = True;
           Boolean isValidAI = True;
           Boolean isAccountMapped = True;
           testcrd.Benefits_State_List__c = 'AK';
           testcrd.List_Of_states_to_remove_the_plan__c = 'AL';
           insert testcrd;
           
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.redirectToStep2();
          newcontroller.overrideYschedule();
        
           
       }
       
       static testmethod void testPlanInformationStep1testnext(){
        
           crd__c testcrd = new crd__C();
           testcrd.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
           testcrd.plan_platform__c = 'AGBNAME';
           testcrd.contract_state__c = 'BR';
           testcrd.which_system_will_the_plan_be_installed__c = 'HRP';
           testcrd.plan_type_paper_out_of_network__c = true;
           testcrd.Override_Retail_Y_Schedule__c = 'Yes';
           testcrd.sub_segment__c = 'AGB';
           testcrd.Rx_PP_ID__c = null;
           testcrd.TP_ID__c = 'Test';
           testcrd.Custom_Ben_ID__c = 'Test';
           testcrd.Y_Schd__c = 'Test';
           testcrd.Platform_Information__c = 'H';
           testcrd.Risk_Indicator__c = 'S';
           Boolean isValidAccum = True;
           Boolean isValidAI = True;
           Boolean isAccountMapped = True;
           testcrd.Benefits_State_List__c = 'AK';
           testcrd.List_Of_states_to_remove_the_plan__c = 'AL';
           insert testcrd;
           
          ApexPages.StandardController stdController= new ApexPages.standardController(testCrd);
          
          VFP_CRDPlanInformationStep1  newcontroller = new  VFP_CRDPlanInformationStep1(stdController);
          newcontroller.redirectToStep2();
          
          testcrd.Standard_or_Custom_Plan__c = null;
          testcrd.which_system_will_the_plan_be_installed__c = 'HIX';
          update testcrd;
          newcontroller.redirectToStep2();
        
           
       }
}