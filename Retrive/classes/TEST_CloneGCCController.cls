/*Purpose: Apex Class for Cloning the Generic Code Conversion
========================================================================
History                                                           
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
1.0 -    Anuj                 02/16/2012       Apex Class for Cloning the Generic Code Conversion
======================================================================== */                  
@isTest
private class TEST_CloneGCCController{
   static testMethod void testCloneGCCController(){ 
       GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();    
      
        //Test data
        Generic_Code_Conversion__c gc =  testdata.createGenericCode(); 
        insert gc;
        Generic_Code_Conversion_Entry__c gce =  testdata.createGenericCodeEntry(gc.Id) ;
        insert gce;
        
        // Instanciate  the VF page      
        PageReference  VFPage= Page.VF_CloneGCC;     
          Test.setCurrentPage(VFPage);     
       //instanciate Apex Controller      
       ApexPages.StandardController s = new ApexPages.standardController(gc); 
       VFP_CloneGCCController controllerClass = new VFP_CloneGCCController(s);      
            controllerClass.redirect();         
            controllerClass.previouspage();        
    }   
  }