/*Purpose: Apex Test Class for VFP_CRDClinicalProgramStep1Controller.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/26/2011       Apex Test Class for VFP_CRDClinicalProgramStep1Controller.
======================================================================== 
*/
@isTest
private class TEST_CRDClinicalProgramStep1Controller
{
 static testmethod void testCRDClinicalProgramStep1Controller()
 {
         
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.Integrate_with_Medical__c='No';
         testcrd.is_there_compound_max_pay__c='No';
        // testcrd.pos_dose_optimization__c='Yes';
         testcrd.retail_to_mail__c=TRUE;       
         insert testCrd;
     
         List < Drug_Coverage__c > drugCoverageList = new List < Drug_Coverage__c > ([select id,Recordtypeid from Drug_Coverage__c where RecordType.Name = : 'Mail' limit 1]);
         
         drug_coverage__c drugcoverage = new drug_coverage__c();
         drugcoverage.CRD_ID__c= testcrd.id;
         drugcoverage.Do_you_have_Choose_Generic__c='No';
         drugcoverage.Mandatory_mail_order_option__c='Incentivized';
         drugcoverage.Incentivized_Mail_Generic_Penalty_Type__c= 'Dollar Amount';
         drugcoverage.Incentivized_Mail_Generic_Penalty_Amount__c=23;
         drugcoverage.Incentivized_Mail_Brand_Penalty_Type__c='Dollar Amount';
         drugcoverage.Incentivized_Mail_Brand_Penalty_Amount__c=231;
         drugcoverage.Incent_Mail_NonPref_Brand_Penalty_Type__c='Dollar Amount';
         drugcoverage.Incent_Mail_NonPref_Brand_Penalty_Amount__c=321;
         drugcoverage.recordtypeID=drugCoverageList[0].Recordtypeid;
         insert drugcoverage;
     
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgStep1')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDClinicalProgramStep1Controller controller =new VFP_CRDClinicalProgramStep1Controller(stdcontroller);
         controller.redirectToPaperOptions();
         controller.redirectToPharmacyNetwork();
         testCrd.Integrate_with_Medical__c='Yes';
         update testCrd;
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDClinicalProgramStep1Controller(stdcontroller);
         controller.redirectToPaperOptions();
         controller.crd=new CRD__c();
         controller.redirectToPaperOptions();
         controller.redirectToPharmacyNetwork();
         controller.attachWaiverDoc();
         controller.attachRxWaiverDoc();
         controller.redirectToPaperOptions2();
         controller.redirectToPharmacyNetwork2();
         controller.showmaxpay();
        
 
 }

}