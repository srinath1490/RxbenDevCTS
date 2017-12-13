/*Purpose: Apex Test Class for VFP_AppMenuController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/28/2011       Apex Test Class for VFP_AppMenuController.
======================================================================== 
*/
@isTest
private class TEST_AppMenuController {

    static testMethod void myUnitTest() {
         VFP_AppMenuController ctrl=new  VFP_AppMenuController();
         ctrl.crdId='test';
         ctrl.currentPageName='test';
         ctrl.isIntegratedWithMedical='yes';
         ctrl.FundingType='test';
    }
}