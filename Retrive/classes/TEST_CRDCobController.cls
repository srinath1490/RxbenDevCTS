/*Purpose: Apex Test Class for VFP_CRDCobController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/27/2011       Apex Test Class for VFP_CRDCobController.
======================================================================== 
*/
@isTest
private class TEST_CRDCobController{
    static testMethod void testPlanInformation(){
           GC_UtilityClassTestData testData = new GC_UtilityClassTestData();       
           
           CRD__c testCrd = new CRD__c(); 
           testCrd.Does_the_client_want_to_do_COB__c='Yes';
           testCrd.COB_or_MOB__c ='COB';
           testCrd.Process_Point_of_Sales_COB__c = true;
           testCrd.Reimbursement_Levels__c='Contracted';     
           insert testCrd;
           /* Instanciate  Visualforce Page */       
           PageReference newCobOption = Page.VF_NewCobOptions ;
           Test.setCurrentPage(newCobOption);

           newCobOption.getParameters().put('crdid',testCrd.id);   
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);
           VFP_CRDCobController controller = new VFP_CRDCobController(s);
           controller.crd.COB_or_MOB__c='MOB';           
           controller.showCobFields();
           controller.crd.COB_or_MOB__c='COB';
           controller.showCobFields();
           controller.showCOBorMOB();
           controller.outofNetwork();
           controller.redirectToPos();
           controller.redirectToRDS();
           controller.crd.Does_the_client_want_to_do_COB__c='No';
           controller.showCobFields();
           controller.showCOBorMOB();
           controller.redirectToPos();
           controller.redirectToRDS();
           controller.crd.Plan_Type_Paper__c =true;           
           controller.redirectToPos();
           controller.crd.Does_the_client_want_to_do_COB__c='Yes';
           controller.crd.COB_or_MOB__c='COB';
           controller.crd.Process_Point_of_Sales_COB__c=false; 
           controller.crd.In_Network__c=false;
           controller.crd.Out_of_Network__c=false;
           controller.redirectToRDS();
          
       }
}