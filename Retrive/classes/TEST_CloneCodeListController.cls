/*Purpose: Apex Class for Cloning the Code List
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR                 DATE                    DETAIL                            
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Code List
======================================================================== 
*/
@isTest
 private class TEST_CloneCodeListController{
    static testMethod void testCloneCodeList(){
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();         
   
          //Test data
          Codes_List__c cl =  testdata.createCodeList();
              cl.Standard__c = true;
          insert cl;
          Codes__c c1= testdata.createCode(cl.Id);
          insert c1;
         
          // Instanciate  the VF page        
           PageReference  VFPage= Page.VF_CloneCodeList;       
              Test.setCurrentPage(VFPage);   
           
          //instanciate Apex Controller                  
             ApexPages.StandardController s = new ApexPages.standardController(cl); 
             VFP_CloneCodeListController controllerClass = new VFP_CloneCodeListController(s);
                  controllerClass.redirect();        
                  controllerClass.previouspage();         
   }  
 }