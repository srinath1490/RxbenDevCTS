/*Purpose: Apex Test Class for VFP_AccumulationListController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/28/2011       Apex Test Class for VFP_AccumulationListController.
======================================================================== 
*/
@isTest
private class TEST_AccumulationListController {

    static testMethod void myUnitTest() {
         CRD__c testCrd = new CRD__c();
         insert testCrd;
         Accumulations__c acc=new Accumulations__c();
         acc.CRD_ID__c=testCrd.id;
         insert acc;
                     
         PageReference existingAccums = Page.VF_ExistingAccumulations;
         existingAccums.getParameters().put('crdId',testCrd.id);    
         Test.setCurrentPage(existingAccums);
         ApexPages.StandardController stCon1 = new ApexPages.standardController(testCrd);         
         VFP_AccumulationListController controller = new VFP_AccumulationListController (stCon1);
         controller.selectedAccumId=acc.id;
         controller.showDetail();     
         controller.crd=testCrd;
         controller.accumulation=acc;
         
    }
}