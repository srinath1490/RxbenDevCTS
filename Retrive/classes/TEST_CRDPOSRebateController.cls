/*Purpose: Apex Test Class for VFP_CRDPOSRebateController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/28/2011       Apex Test Class for VFP_CRDPOSRebateController.
======================================================================== 
*/
@isTest
private class TEST_CRDPOSRebateController{    
    static testMethod void testPOSRebate(){
        GC_UtilityClassTestData testData = new GC_UtilityClassTestData();                             
        CRD__c testCrd = new CRD__c();
        insert testCrd;           
        /* Instanciate  Visualforce Page */                  
        PageReference newPOSRebate = Page.VF_CRDPOSRebate ;           
        Test.setCurrentPage(newPOSRebate);           
        newPOSRebate.getParameters().put('crdid',testCrd.id); 
                             
       ApexPages.StandardController s = new ApexPages.standardController(testCrd);           
       VFP_CRDPOSRebateController controller = new VFP_CRDPOSRebateController(s);      
       controller.redirectToReporting();
       controller.redirectToRxCheck();
       controller.showPanel();
       controller.crd.POS_Rebate_for_Plan__c='Yes';
       controller.crd.Plan_Type_Paper__c = true;
       controller.showPanel();
       controller.redirectToRxCheck();
       controller.redirectToReporting();
 
       
    }
}