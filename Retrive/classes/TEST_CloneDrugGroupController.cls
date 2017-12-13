/*Purpose: Apex Class for Cloning the Drug Group                                      
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Drug Group
======================================================================== 
*/
@isTest
private class TEST_CloneDrugGroupController{
  static testMethod void testCloneDrugGroup(){ 
     GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();        

         //Test data
         Drug_Group__c dg = testdata.createDrugGroup();    
           dg.Standard__c = true;     
         insert dg;   
         Drug_List__c dl = testdata.createDrugList();
         insert dl;  
         Drug_List_Junction__c dlj = testdata.createDrugListJunction(dg.Id,dl.Id);
         insert dlj;
     
        // Instanciate  the VF page       
        PageReference  VFPage= Page.VF_CloneDrugGroup;       
          Test.setCurrentPage(VFPage);   
        
         //instanciate Apex Controller                 
          ApexPages.StandardController s = new ApexPages.standardController(dg); 
          VFP_CloneDrugGroupController controllerClass = new VFP_CloneDrugGroupController(s);   
                controllerClass.redirect();   
                controllerClass.previouspage();      
   }  
  }