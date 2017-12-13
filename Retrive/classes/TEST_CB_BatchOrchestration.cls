/*Purpose: Apex Test Class to test Orchestration class
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Richa           8th Sep 2014       Apex Test Class to test Orchestration class
======================================================================== */
@isTest
private class TEST_CB_BatchOrchestration{
    
 static testMethod void TEST_CB_BatchOrchestration1(){
    
     CB_BatchOrchestration newBatchOrchestration = new CB_BatchOrchestration();
     newBatchOrchestration.callNext('Batch_CRDBuildStep');
     Test.startTest();
     Id testId = newBatchOrchestration.callBatch_CRDBuildStep();
     Id testId2 = newBatchOrchestration.callBatch_customValidation();
     Test.stopTest();
 }
 static testMethod void TEST_CB_BatchOrchestration2(){
     CB_BatchOrchestration newBatchOrchestration = new CB_BatchOrchestration();
     newBatchOrchestration.callNext('Batch_CompleteStep');
     Test.startTest();
     Id testId3 = newBatchOrchestration.callBatch_CompletionStep();
     Id testId4 = newBatchOrchestration.callBatch_sendtoAI();
     Test.stopTest();
 }    
 static testMethod void TEST_CB_BatchOrchestration3(){
     CB_BatchOrchestration newBatchOrchestration = new CB_BatchOrchestration();
     Test.startTest();
     Id testId7 = newBatchOrchestration.callBatch_CRDXMLStep();
     Id testId8 = newBatchOrchestration.callBatch_CRDPDFStep();
     Id testId9 = newBatchOrchestration.callBatch_CRDCVSStep();
     Test.stopTest();
 }
  static testMethod void TEST_CB_BatchOrchestration4(){
     CB_BatchOrchestration newBatchOrchestration = new CB_BatchOrchestration();
     Test.startTest();
     Id testId5 = newBatchOrchestration.callBatch_SeedPERSstep();
     Id testId6 = newBatchOrchestration.callBatch_CAGRestructure();
     Test.stopTest();
 }  
 }