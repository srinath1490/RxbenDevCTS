/*Purpose: Apex Test Class for VFP_CRDPaperOptionsController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/28/2011       Apex Test Class for VFP_CRDPaperOptionsController.
======================================================================== 
*/
@isTest
private class TEST_CRDPaperOptionsController {

    static testMethod void myUnitTest() {
        CRD__c testCrd = new CRD__c();
        insert testCrd;
          PageReference paperOptions = Page.VF_CRDPaperOptions;
          paperOptions.getParameters().put('crdid',testCrd.id);    
          Test.setCurrentPage(paperOptions); 
                   
         ApexPages.StandardController stCon = new ApexPages.standardController(testCrd);
         VFP_CRDPaperOptionsController controller = new VFP_CRDPaperOptionsController(stCon);
         
         controller.crd.Plan_Type_Paper__c=true;
         controller.crd.No_of_Days_to_file_a_claim__c=null;
         controller.redirectToPOSRebate();
         controller.redirectToCOB();
         controller.crd.Plan_Type_Paper__c=false;
         controller.crd.No_of_Days_to_file_a_claim__c=null;
         controller.redirectToPOSRebate();
         controller.redirectToCOB();
         controller.crd.In_Network_claims_are_reimbursed__c=true;
         controller.Updatedays();
         
         delete testCrd;
         controller.redirectToPOSRebate();
         controller.redirectToCOB();
         controller.showPanel();
         controller.crd.Out_of_Network_Cost_Sharing__c='Yes';
         controller.showPanel();
    }
}