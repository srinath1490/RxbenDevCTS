/*Purpose: Apex Test Class to test share cases 
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7 Oct 2014       Apex Test class to test share cases
======================================================================== */
@isTest
private class TEST_CB_ShareCases {
	static testMethod void TEST_CB_ShareCases(){
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
 		newCrdBuilder.XML__c = true;
        newCrdBuilder.PDF__c = True;
 		insert newCrdBuilder;     
    Test.StartTest();
    	BAC_CB_ShareCases sharecasesBatch = new BAC_CB_ShareCases();
    	ID batchprocessid = Database.executeBatch(sharecasesBatch);
    Test.StopTest();
    }
}