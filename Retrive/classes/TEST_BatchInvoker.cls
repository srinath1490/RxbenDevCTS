/*Purpose: Apex Test Class to test BatchInvoker
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            8 Oct 2014       Apex Test class to test BatchInvoker
======================================================================== */
@isTest
private class TEST_BatchInvoker {
    static testmethod void TEST_BatchInvoker(){
        BatchInvoker batchInstance = new BatchInvoker();
    	batchInstance.loadExistingBatch();
        batchInstance.executeBatch();
    }
	
}