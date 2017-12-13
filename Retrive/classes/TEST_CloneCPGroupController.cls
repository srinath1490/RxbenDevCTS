/*Purpose: Apex Class for Cloning the Clinical Program Group.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Clinical Program Group.
======================================================================== 
*/
@isTest
    private class TEST_CloneCPGroupController{
     static testMethod void testCloneClinicalProgrameGroup(){
      GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();  
       
        //Test data
        Clinical_Program_Group__c cpg =  testdata.creteProgrameGroup('Prescription Savings Program','self insured');
        insert cpg;
        Clinical_Program__c cp =  testdata.createClinicalPrograme('Prescription Savings Program');
           cp.Standard__c = true;
        insert cp;
        Clinical_Program_Junction__c cpj= testdata.createClinicalprgmJunction(cp.id,cpg.id);
        insert cpj;
  
        // Instanciate  the VF page      
        PageReference  VFPage= Page.VF_CloneClinicalPrograms;      
              Test.setCurrentPage(VFPage); 
  
       //instanciate Apex Controller             
        ApexPages.StandardController s = new ApexPages.standardController(cpg);
        VFP_CloneClinicalProgrameGroupController controllerClass = new VFP_CloneClinicalProgrameGroupController(s);
          controllerClass.redirect();      
          controllerClass.previouspage();        
   }
  }