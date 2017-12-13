/*Purpose: Apex Class for Cloning the Refill Too Soon
 ========================================================================
 History                                                            
 -------                                                            
 VERSION     AUTHOR                 DATE                    DETAIL                                    
     1.0 -    Rashi                 02/16/2012       Apex Class for Cloning the Refill Too Soon
 ======================================================================== 
*/
@isTest 
private class TEST_CloneRefillTooSoonController{   
  static testMethod void testCloneRefillTooSoonController(){      
    GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();             

       //Test data
       Refill_Too_Soon__c rts = testdata.createRefillTooSoon();
           rts.Standard__c = true;            
       insert rts;       
       Refill_Too_Soon_Criteria__c rtsc = testdata.createRefillSoonCriteria(rts.Id);                     
       insert rtsc;
          
       // Instanciate  the VF page            
       PageReference  VFPage= Page.VF_CloneRefillTooSoon;               
          Test.setCurrentPage(VFPage);             
       //instanciate Apex Controller                   
       ApexPages.StandardController s = new ApexPages.standardController(rts);                   
       VFP_CloneRefillTooSoonController controllerClass = new VFP_CloneRefillTooSoonController(s);                   
             controllerClass.redirect();                        
             controllerClass.previouspage();       
     } 
  }