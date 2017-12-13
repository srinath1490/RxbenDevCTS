/*Purpose: Apex Test Class for VFP_CRDCompleteProcessController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/27/2011       Apex Test Class for VFP_CRDCompleteProcessController.
======================================================================== 
*/
@isTest
private class TEST_CRDCompleteProcessController{   
    static testMethod void testPlanInformation4(){ 
           Test.StartTest();
           GC_UtilityClassTestData testData = new GC_UtilityClassTestData();       
           CRD__c testCrd = new CRD__c();       
               testCRD.Rx_PP_ID__c='test';
               testCRD.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
               testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';
               testCRD.Sub_segment__c ='AB';
               testCRD.Override_Retail_Y_Schedule__c='Yes';
               testCRD.predefined__c = TRUE;
               testCrd.CRD_Automated__c = TRUE;
               testCrd.RxPlanID__c = '01234Test';
               testCrd.CRD_Automated__c = True;
               insert testCrd;
           CRDBuildOrder__c cbon = new CRDBuildOrder__c();
               cbon.CRD__c = testCrd.id;
               insert cbon;
           CVSRxPlanId__c cvsRx = new CVSRxPlanId__c();
               cvsRx.CRD_Name__c = testCrd.Name;
               cvsRx.RxPlanId__c = testCrd.RxPlanID__c;
               insert cvsRx;
           Account ac = new account();
               ac.name = 'test';
               insert ac;
           Accumulations__c acc = new Accumulations__c();
               id accrtId = Schema.SObjectType.Accumulations__c.getRecordTypeInfosByName().get('Family - All').getRecordTypeId();
               acc.RecordTypeId = accrtId;
               acc.CRD_ID__c = testCrd.id;
               acc.Carry_Balance_when_member_moves__c = 'No';
               insert acc;
           Clinical_Program__c cp = new Clinical_Program__c();
               cp.Description__c = 'test';
               cp.standard__c = true;
               cp.Account__c = ac.id;
               cp.Clinical_Programs_Name__c = 'test';
               id rtId = Schema.SObjectType.Clinical_Program__c.getRecordTypeInfosByName().get('Save-A-Copay').getRecordTypeId();
               cp.Recordtypeid = rtid;
               cp.Inactive__c = false;
               insert cp;
           Save_A_Copay_Junction__c sac = new Save_A_Copay_Junction__c();
               sac.CRD_ID__c = testCrd.id;
               sac.Save_A_Copay_ID__c = cp.id;
               insert sac;
           Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
               id recordtypeId = Schema.SObjectType.Clinical_Program_Group__c.getRecordTypeInfosByName().get('Save-A-Copay').getRecordTypeId();
               cpg.RecordTypeId = recordtypeId;
               cpg.Clinical_Program_Group_Name__c = 'test1';
               cpg.Clinical_Program_Group_Description__c = 'This is a test class desc';
               cpg.Funding__c = 'Fully Insured';
               cpg.Effective_Date__c = system.today();
               cpg.Termination_Date__c = system.today()+10;
               insert cpg;
           Clinical_Program_Junction__c cpj = new Clinical_Program_Junction__c();
               cpj.Clinical_Program_Group__c = cpg.id;
               cpj.Clinical_Program__c = cp.id;
               insert cpj;
           Drug_List__c dl = new Drug_List__c();
               id dlrtId = Schema.SObjectType.Drug_List__c .getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
               dl.RecordTypeId = dlrtId;
               dl.Drug_List_Name__c = 'test';
               dl.Description__c = 'this is a test dl';
               insert dl;
           Drug_Specific_copay__c dsc = new Drug_Specific_Copay__c();
               id rtId2 = Schema.SObjectType.Drug_Specific_copay__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
               dsc.RecordTypeId = rtId2;
               dsc.Drug_List__c = dl.id;
               dsc.CRD_ID__c =testCrd.id;
               dsc.M__c = True;
               dsc.N__c = True;
               dsc.O__c = True;
               dsc.Y__c = True;
               insert dsc;
           Drug_Specific_Stepped_Copay__c dssc = new Drug_Specific_Stepped_Copay__c();
               dssc.Drug_Specific_Copay_ID__c= dsc.id;
               insert dssc;
           Drug_Coverage__c dc = new Drug_Coverage__c();
               id rtId3 = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
               dc.RecordtypeId = rtId3;
               dc.CRD_ID__c = testCrd.id;
               insert dc;
           copay_tier__c ct = new copay_tier__c();
               id rtId4 = Schema.SObjectType.copay_tier__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
               ct.RecordTypeId = rtId4;
               ct.CRD__c = testCrd.id;
               ct.Tier__c = '1';
               insert ct;
           SteppedCopay__c stcopay = new SteppedCopay__c();
               stcopay.Copay_Tier__c = ct.id;
               insert stcopay;
           Waiver_Of_Deductible__c wod = new Waiver_Of_Deductible__c();
               wod.CRD_ID__c = testCrd.id;
               wod.Drug_Class__c = 'DED EXCLUDE GENERIC DRUGS';
               wod.M__c = True;
               wod.N__c = True;
               wod.O__c = True;
               wod.Y__c = True;
               insert wod;
            CRD_PriorAuth_Junction__c cpaj = new CRD_PriorAuth_Junction__c();
                cpaj.CRD_ID__c = testCrd.id;
                insert cpaj;
            CRD_Quantity_Limit_Junction__c cql = new CRD_Quantity_Limit_Junction__c();
                cql.CRD_ID__c = testCrd.id;
                insert cql;
            CRD_Step_Therapy_Junction__c cst = new CRD_Step_Therapy_Junction__c();
                cst.CRD_ID__c = testCrd.id;
                insert cst;
           PageReference newCrdCompleteProcess = Page.VF_CRDCompleteProcess;        
           Test.setCurrentPage(newCrdCompleteProcess); 
           newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_CRDCompleteProcessController controller = new VFP_CRDCompleteProcessController(s); 
              controller.aiRequest = new AI_Request__c();
              controller.aiRequest.Plan_ID__c = 'abc'; 
              controller.aiRequest.Benefit__c = 'abc'; 
              controller.aiRequest.Benefits_String_Extn__c = 'abc'; 
              controller.aiRequest.Integration_1__c = 'abc'; 
              controller.aiRequest.Pricing_Schedule__c = 'abc'; 
              controller.aiRequest.Risk_Indicator__c = 'abc'; 
              controller.aiRequest.StateList_to_Remove__c = 'abc'; 
              controller.aiRequest.Request_Type__c= system.label.CL0000035;
              controller.sessionId = 'abc';
              controller.callout();
              controller.chkExtCase();
              controller.updateCRDstatus();
           Test.StopTest();    
    }
    static testMethod void testPlanInformation(){
           Test.StartTest();
           GC_UtilityClassTestData testData = new GC_UtilityClassTestData();       
           CRD__c testCrd = new CRD__c();       
           testCRD.Rx_PP_ID__c='test';
           testCRD.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
           testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';
           testCRD.Override_Retail_Y_Schedule__c='Yes';
           testCRD.predefined__c = TRUE;
           testCRD.Sub_segment__c ='AB';
           testCrd.CRD_Automated__c = TRUE;
           insert testCrd;
           PageReference newCrdCompleteProcess = Page.VF_CRDCompleteProcess;        
           Test.setCurrentPage(newCrdCompleteProcess); 
           //newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
          // ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
          // VFP_CRDCompleteProcessController controller = new VFP_CRDCompleteProcessController(s);
          
           newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
           ApexPages.StandardController s1 = new ApexPages.standardController(testCrd);
           VFP_CRDCompleteProcessController controller1 = new VFP_CRDCompleteProcessController(s1);
           controller1.completeAndSend();
           controller1.errorMessages = new List<String>();
           //controller1.sendToAi1(); 
           
           controller1.approveCRD();
           controller1.redirectToReporting();
           controller1.saveAndCompleteLater();
           controller1.rejectCRD();
           controller1.lstWorkItemDetails=null;
           controller1.approveCRD();
           controller1.rejectCRD();
           controller1.generateXML();
           controller1.getHideForBCTC();
           controller1.checkMandatoryFields();
           controller1.overideYscheduleValues();
           controller1.getcongaCRDAuditComposer();
           controller1.updateOnHoldStatus();
           testCrd=new CRD__c();
           testCrd.Insured_Type__c='Fully Insured';
           testCrd.Rating__c='Prospective';
           testCrd.CRD_Automated__c = TRUE;  
           insert testCrd;  
           controller1.crd=testCrd;          
           controller1.sendToAi1();
           controller1.callout(); 

           
            
           testCrd.Platform_Information__c='H';
           testCrd.TP_ID__c=null;
           testCrd.Rx_PP_ID__c=null;
           testCrd.Risk_Indicator__c=null;
           update testCrd;
           controller1.crd=testCrd;
          
           list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
           Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
           drugCoverateItem.CRD_ID__c = testCrd.id;
           drugCoverateItem.RecordTypeId=rt.get(0).id;
           drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
           drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='no';
           insert drugCoverateItem;
       
           Network_Junction__c newnetwork=new Network_Junction__c();
           newnetwork.CRD_ID__c = testCrd.id;
           insert newnetwork;
           controller1.crd=testCrd;
       
           testCrd.Are_you_creating_a_Package_Plan__c='Yes';
           testCrd.Integrate_with_Medical__c='Yes';
           update testCrd;
           controller1.crd=testCrd;
           // controller1.sendToAi1();
           testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';update testCRD;
           controller1.saveAndCompleteLater();
           controller1.redirectToReporting2();
           controller1.predefinedupdate();
           test.stoptest();

     }
  static testMethod void testApprovalMethods(){     
  test.starttest();
     GC_UtilityClassTestData testData = new GC_UtilityClassTestData();       
           CRD__c testCrd = new CRD__c();       
           testCRD.Rx_PP_ID__c='test';
           testCRD.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
           testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';
           testCRD.LastSent__c=system.now();
           testCRD.Override_Retail_Y_Schedule__c='Yes';
           testCRD.predefined__c = TRUE;
           testCrd.CRD_Automated__c = TRUE;
           insert testCrd;
           
           PageReference newCrdCompleteProcess = Page.VF_CRDCompleteProcess;        
           Test.setCurrentPage(newCrdCompleteProcess); 
           newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_CRDCompleteProcessController controller = new VFP_CRDCompleteProcessController(s);
           controller.completeAndSend();
          // newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
        //   ApexPages.StandardController s1 = new ApexPages.standardController(testCrd);
         // VFP_CRDCompleteProcessController controller1 = new VFP_CRDCompleteProcessController(s1);
           controller.completeAndSend();
           controller.approveCRD(); 
           test.stoptest(); 
  }
  
    static testMethod void testApprovalrejection(){ 
    test.starttest();    
     GC_UtilityClassTestData testData = new GC_UtilityClassTestData();       
           CRD__c testCrd = new CRD__c();       
           testCRD.Rx_PP_ID__c='test';
           testCRD.LastSent__c=system.now();
           testCRD.Override_Retail_Y_Schedule__c='Yes';
           testCRD.predefined__c = TRUE;
           testCRD.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
           testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';
           testCrd.CRD_Automated__c = TRUE;
           insert testCrd;
           
           PageReference newCrdCompleteProcess = Page.VF_CRDCompleteProcess;        
           Test.setCurrentPage(newCrdCompleteProcess); 
          // newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
          // ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
         //  VFP_CRDCompleteProcessController controller = new VFP_CRDCompleteProcessController(s);
           
           newCrdCompleteProcess.getParameters().put('crdid',testCrd.id);            
           ApexPages.StandardController s1 = new ApexPages.standardController(testCrd);
           VFP_CRDCompleteProcessController controller1 = new VFP_CRDCompleteProcessController(s1);
           controller1.completeAndSend();
           controller1.completeAndSend();
           controller1.rejectCRD();  
           testCrd.Are_you_creating_a_Package_Plan__c=null;
           testCrd.Account__c=null;
           testCrd.Effective_Start_Date__c=null;
           testCrd.Client_Effective_Date__c=null;
           //testcrd.autocompleteprocess__c=true;
           testcrd.archived__c=true;
           testCRD.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
           testCRD.Which_system_will_the_plan_be_installed__c = 'Traditional';
           // testCrd.Implementations_Date__c=null;
           testCrd.Do_you_want_to_do_Step_Therapy__c=null;
           testCrd.Enrolled_in_PA_for_other_condition__c=null;
           testCrd.Do_you_want_to_do_Save_A_Copay__c=null;
           testCrd.Out_of_Network_Cost_Sharing__c=null;
           testCrd.Does_the_client_want_to_do_COB__c=null;
           testCRD.Override_Retail_Y_Schedule__c='Yes';
           testCRD.predefined__c = TRUE;
           controller1.crd.Integrate_with_Medical__c='No';
           controller1.crd.Platform_Information__c='H';
           controller1.crd.TP_ID__c=null;
           controller1.crd.Rx_PP_ID__c=null;
           controller1.crd.Y_Schd__c='Y4';
           
           controller1.errorMessages = new List<String>();
           //controller1.sendToAi1();
           Accumulations__c acc=new Accumulations__c();
           RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
           acc.RecordTypeId=rt.id;
           acc.CRD_ID__c=testCrd.Id;
           acc.Carry_Balance_when_member_moves__c='yes';
           acc.Deductible_Amount__c=100.0;
           acc.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
           //acc.Is_this_an_HDHP_plan__c='No';
           acc.Deductible_Period__c='Month';
           acc.Are_there_any_drug_specific_deductibles__c=true;
           insert acc;
           controller1.aiRequest=new AI_Request__c();
           controller1.sendToAi1();
           controller1.callout();            
           controller1.sendToAIandCVS();
           controller1.generateRxPlanID();
           controller1.getHideConsumerPlan();
           controller1.RXchk();
           //controller1.autoCompleteProcess();
             //Conga Composer
            List<APXT_CMQR__Conga_Merge_Query__c> congaQueryList = new List<APXT_CMQR__Conga_Merge_Query__c>();
            
            APXT_CMQR__Conga_Merge_Query__c cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Network Junction';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Copays Tier';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Stepped Copay';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Drug Specific Copay';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Drug Specific Stepped Copays';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Drug Coverage';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Accumulations';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Accumulations Specific Drug';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Pricing';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD RxCheck';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD PSP';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Save A Copay';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Step Therapy Junction';
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Prior Auth Junc / Precert';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD Quantity Limit';
            congaQueryList.add(cq);
            cq = new APXT_CMQR__Conga_Merge_Query__c();
                cq.APXT_CMQR__Name__c = 'CRD CVS Web Access Users';
            congaQueryList.add(cq);
            
            insert congaQueryList;
            
            APXTConga4__Conga_Template__c congaTemplate = new APXTConga4__Conga_Template__c();
            congaTemplate.APXTConga4__Name__c = 'CRD Template';
            insert congaTemplate;
            
            controller1.getcongaComposer();
            controller1.getcongaComposerPDF1() ;
            controller1.getcongaComposerPDF2() ; 
            controller1.getcongaComposerCombo();
            string testString = controller1.getcongaComposerHistory();
            string testString1 = controller1.getcongaComposerNewRecord();
            test.stoptest();
  }
  
}