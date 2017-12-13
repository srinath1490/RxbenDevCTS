/*Purpose: Apex Test Class for VFP_CRDPlanInformationStep.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/5/2011       Apex Test Class for VFP_CRDPlanInformationStep.
======================================================================== 
*/

@isTest
private class TEST_CRDPlanInformationStep{
    static testMethod void testPlanInformation(){
       GC_UtilityClassTestData testData = new GC_UtilityClassTestData();
       CRD__c testCrd = new CRD__c();
       insert testCrd;
        PageReference newCrdPlanInformationStep0 = Page.VF_NewCRDPlan_Step0 ;
        Test.setCurrentPage(newCrdPlanInformationStep0); 
        newCrdPlanInformationStep0.getParameters().put('id',testCrd.id);    
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VF_CRDPlanInformationStep controller = new VF_CRDPlanInformationStep(s);
        controller.redirectToStep1();
        delete testCrd;
        controller.redirectToStep1();             

    }

}