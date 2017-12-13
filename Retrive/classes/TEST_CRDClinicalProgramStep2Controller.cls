/*Purpose: Apex Test Class for VFP_CRDClinicalProgramStep2Controller.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/28/2011       Apex Test Class for VFP_CRDClinicalProgramStep2Controller.
======================================================================== 
*/
@isTest
private class TEST_CRDClinicalProgramStep2Controller {

    static testMethod void myUnitTest() {
        Account testacc= new Account();
        testacc.Name= 'test account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        
        CRD__c testCrd = new CRD__c();
        testCrd.crd_automated__c =True;
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';
        testCrd.PA_Condition_1__c = 'COPD';
        testCrd.PA_Condition_2__c = 'COPD';
        testCrd.PA_Condition_3__c = 'COPD';
        testCrd.PA_Condition_4__c = 'COPD';
        testCrd.PA_Condition_5__c = 'COPD';
        testCrd.PA_Condition_6__c = 'COPD';
        testCrd.PA_Condition_7__c = 'COPD';
        testCrd.Aetna_Healthy_Actions__c = 'Yes';
        insert testCrd;
        
        Drug_Coverage__c testDrugCoverage = new Drug_Coverage__c();
        RecordType rt=[Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c' AND Name='Mail' limit 1];
        testDrugCoverage.RecordTypeId=rt.id;
        testDrugCoverage.CRD_ID__c= testCrd.ID;
        testDrugCoverage.Do_you_have_Choose_Generic__c='No';
        insert testDrugCoverage;
        
        Save_A_Copay_Junction__c saveACopay= new Save_A_Copay_Junction__c();
        saveACopay.CRD_ID__c=testCrd.id;
        insert saveACopay;
        
         PageReference clincialProg = Page.VF_CRDClinicalProgStep2;
         clincialProg.getParameters().put('crdId',testCrd.id);
         Test.setCurrentPage(clincialProg);
         ApexPages.StandardController stCon1 = new ApexPages.standardController(testCrd);
         VFP_CRDClinicalProgramStep2Controller  controller = new VFP_CRDClinicalProgramStep2Controller(stCon1);
         
         controller.crd.Pharmacy_Advisor__c=true;
         controller.crd.Disease_Vendor__c='test';
         controller.crd.End_Date__c=system.today();
         controller.crd.Custom_call_center_phone_number__c='(999)-999-9999'; 
         controller.crd.Is_DM_vendor_the_same_for_each_condition__c='Yes';   
         controller.crd.Implementation_Type__c=null;  
         controller.crd.Disease_Management_Messaging_for__c =null;  
         controller.crd.Disease_Management_Referral_Messaging__c='Yes';  
         controller.redirectToNetwork();
         
         controller.crd.Is_DM_vendor_the_same_for_each_condition__c='No';        
         controller.crd.PA_Disease_Vendor_1__c =null;
         controller.crd.Implementation_Type__c='Pharmacy Advisor All Conditions Complete Buy-Up Option';
         controller.crd.PA_Condition_1__c = 'Test';
         controller.redirectToNetwork();                 
         
         controller.crd.Disease_Vendor__c=null;
         controller.redirectToNetwork();
          
         controller.crd.Plan_Platform__c ='Traditional/PPO';
         controller.redirectToRXCheck();            
         
         controller.crd.Plan_Platform__c='HNO';
         controller.redirectToRXCheck();
         
         controller.crd.Is_DM_vendor_the_same_for_each_condition__c = 'Yes';
         controller.crd.Implementation_Type__c =null;
         
         controller.crd.Plan_Platform__c='Aetna Student Health';
         controller.redirectToRXCheck();
         controller.upload();
         controller.logo=null;
         controller.upload();
         
         controller.redirectToNetwork();
         controller.crd.Pharmacy_Advisor__c=true;
         controller.crd.Disease_Vendor__c='yes';
         controller.crd.End_Date__c= system.today();
         controller.crd.Custom_call_center_phone_number__c='(999) 999 9999';
         controller.redirectToNetwork();
         controller.showpanel();
         controller.crd.ARH_Offering_Type__c = 'POST AMI';
         controller.aetnaRxAction();
         
         delete saveACopay;
         delete testDrugCoverage;
         delete testCrd;
         
         
    }
}