/*Purpose: Apex Test Class for cloning ClinicalPrograme.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 2/24/2012       Apex Class for Cloning ClinicalPrograme.
======================================================================== 
*/
@isTest
    private class TEST_CloneClinicalProgrameController {
      static testMethod void testCloneClinicalPrograme() {
         GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();   
             //Test data
             Clinical_Program__c cp = testdata.createClinicalPrograme('Prescription Savings Program');
                cp.Standard__c = true;
             insert cp;
             Clinical_Program_Criteria__c cpc = testdata.createProgrameCriteria(cp.Id);
             insert cpc;
            
             // Instanciate  the VF page
             PageReference  VFPage= Page.VF_CloneClinicalPrograms;
                Test.setCurrentPage(VFPage); 
            
             //instanciate Apex Controller       
             ApexPages.StandardController s = new ApexPages.standardController(cp);           
             VFP_CloneClinicalProgrameController controllerClass = new VFP_CloneClinicalProgrameController(s);
               controllerClass.redirect();
               controllerClass.previouspage();
    
    }
}