/*Purpose: Apex Test Class to test Exception handler
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7 Oct 2014       Apex Test class to test Exception handler 
======================================================================== */
@isTest
private class Test_CB_ExceptionHandler {
    static testMethod void TEST_CB_Validations(){
		Account[] accts = new Account[]{new Account(billingcity = 'San Jose')};
        try {        
    	insert accts;
	  } catch (Exception ex) {  
          CRD__c newCRD = new CRD__c();
          insert newCRD;
        Test.StartTest();
    		BAC_CB_ExceptionHandler exceptionBatch = new BAC_CB_ExceptionHandler();
			exceptionBatch.createException(ex,newCRD);
    	Test.StopTest(); 
	  }        
       
    }
}