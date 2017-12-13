/*Purpose: Apex Test Class for VFP_CRDReportingController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/22/2011       Apex Test Class for VFP_CRDReportingController.
======================================================================== 
*/
@isTest
private class TEST_CRDReportingController{
    static testMethod void CRDReportingController()
    {
       CRD__c crdid=new CRD__c();
       insert crdid;
       PageReference newCRDReportingController = Page.VF_CRDReporting; 
       newCRDReportingController.getParameters().put('crdid',crdid.id);    
       Test.setCurrentPage(newCRDReportingController );        
       ApexPages.StandardController s = new ApexPages.standardController(crdid);
       VFP_CRDReportingController controller = new VFP_CRDReportingController(s);
       controller.showPanel();
       controller.redirectToCOB();
       controller.redirectToFinalStep();
       controller.crd=new CRD__c();
       controller.redirectToCOB();
       controller.redirectToFinalStep();
     }
}