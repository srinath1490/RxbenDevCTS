/*Purpose: Apex Class for Cloning the Max Pay                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Rashi                02/24/2012       Apex Class for Cloning the Max Pay
========================================================================
 */       
  @isTest             
  private class TEST_CloneMaxPayController{                 
     static testMethod void testCloneMaxPayController(){ 
         GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();   
                
              //Test data
              Max_Pay__c mp =  testdata.createMaxPay();                     
              insert mp;
              Max_Pay_Limitation__c mpl =  testdata.createmaxPayLimitation(mp.Id);           
              insert mpl;
              Exception__c e =  testdata.createexception(mp.Id);                          
              insert e;
                  
              // Instanciate  the VF page       
              PageReference  VFPage= Page.VF_CloneMaxPay;       
                  Test.setCurrentPage(VFPage);
                         
             //instanciate Apex Controller                 
             ApexPages.StandardController s = new ApexPages.standardController(mp);  
             VFP_CloneMaxPayController controllerClass = new VFP_CloneMaxPayController(s);    
                    controllerClass.redirect();   
                    controllerClass.previouspage();    
   }
  }