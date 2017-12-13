/*Purpose: Apex Class for Cloning the Conflict Code List
========================================================================
History                                                           
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                   
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Conflict Code List
========================================================================
 */ 
 @isTest
 private class TEST_CloneConflictCodeListController{
     static testMethod void testCloneConflictCodeList(){ 
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();                
           
            //Test data    
            Conflict_Code_List__c ccl =  testdata.createConflictCodeList();
               ccl.Standard__c = true;   
            insert ccl;   
            Conflict_Codes__c cc= testdata.createConflictCode(ccl.id);   
            insert cc;       
                 
            // Instanciate  the VF page         
            PageReference  VFPage= Page.VF_CloneConflictCodeList;         
              Test.setCurrentPage(VFPage); 
                        
            //instanciate Apex Controller           
            ApexPages.StandardController s = new ApexPages.standardController(ccl);     
            VFP_CloneConflictCodeListController controllerClass = new VFP_CloneConflictCodeListController(s);       
                controllerClass.redirect();                
                controllerClass.previouspage();                  
    }            
 }