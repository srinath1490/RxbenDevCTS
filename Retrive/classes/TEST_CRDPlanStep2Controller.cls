/*Purpose: Apex Test Class for VFP_CRDPlanStep2Controller.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/27/2011       Apex Test Class for VFP_CRDPlanStep2Controller.
======================================================================== 
*/
@isTest
private class TEST_CRDPlanStep2Controller {
 static testMethod void testPlanInformation(){
    CRD__c testCrd = new CRD__c();
    insert testCrd;
    PageReference newCrdPlanInformationStep2 = Page.VF_NewCRDPlan_Step2 ;
    Test.setCurrentPage(newCrdPlanInformationStep2);
    newCrdPlanInformationStep2.getParameters().put('id',testCrd.id);
    ApexPages.StandardController s = new ApexPages.standardController(testCrd);
    VFP_CRDPlanStep2Controller controller = new VFP_CRDPlanStep2Controller(s);
    controller.redirectToStep2();
    controller.redirectToStep1();                    
 }
}