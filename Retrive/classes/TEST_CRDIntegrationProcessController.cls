/*Purpose: Apex Test Class for VFP_CRDIntegrationProcessController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Ankur                 14/01/2014       Apex Test Class for VFP_CRDIntegrationProcessController.
======================================================================== 
*/
@isTest
private class TEST_CRDIntegrationProcessController{
     static testMethod void testCRDIntegrationProcessController(){  
         CRD__c testCrd=new CRD__c();     
         testCrd.Any_drug_specific_Specialty_copays__c=true;
         insert testCrd;  
         
         PageReference newCrdNewCopay = Page.VF_crdNewSteppedCoPay; 
        newCrdNewCopay.getParameters().put('id',testCrd.id);    
        Test.setCurrentPage(newCrdNewCopay); 
        
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
        VFP_CRDIntegrationProcessController controller = new VFP_CRDIntegrationProcessController(s);
        controller.choiceYesToRemoveCRD();
        controller.currentstatus = 'test';
     }      
     
}