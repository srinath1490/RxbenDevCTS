@isTest
public class TEST_IntegrationDispatcher{
 static testMethod void runTestCases() {
    CRD__c testdata=[SELECT ID FROM CRD__c LIMIT 1];
    IntegrationDispatcher handle=new IntegrationDispatcher();
   if(testdata!=NULL){ 
 //handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','Existing','H',NULL,NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*invalidDCN*/    
//handle.run('342323','1234',NULL,'samplePPID','Existing','H',NULL,NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
//TPID 
/*New*/   handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*NewTPID_Error    handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Error3');
/*Existing*/ handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Tiering New,New*/  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','New',NULL);
/*Tiering New,Existing*/  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','Existing',NULL);
/*Tiering Existing,New*/  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','New',NULL);
/*Tiering Existing,Existing*/  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','Existing',NULL);
/*Invalid Status*/  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Wrong',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Invalid arguments*/ handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,NULL,NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Tiering Wrong,New handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Wrong',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','New',NULL);    
/*Tiering New,wrong  handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TF','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9876','TE','Wrong',NULL);

//PPID
/*Existing+Error   handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','Existing',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ExistingPPID_Error');
/*Existing*/handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','Existing',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*New*/ handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
Test.startTest(); 
/*New+Error*/ handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'NewPPID_Error');
/*Invalid Status*/ handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','Wrong',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
   
//Non-Package Plan
/*New*/handle.run(String.valueOf(testdata.Id),'1234',NULL,NULL,'New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Existing*/handle.run(String.valueOf(testdata.Id),'1234',NULL,NULL,'Existing',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Invalid Status*/handle.run(String.valueOf(testdata.Id),'1234',NULL,NULL,'Wrong',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*Error*/handle.run(String.valueOf(testdata.Id),'1234',NULL,NULL,'New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'NewNonPkg_Error');
/*Invalid arguments*/handle.run(String.valueOf(testdata.Id),'1234',NULL,NULL,'New',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'NewNonPkg_Error');

//BCT notification
/*Error in all arguments*/handle.run(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*PPIDnotification*/handle.run(NULL,'5678',NULL,'PPIDnotif','New',NULL,'H',NULL,NULL,NULL,NULL,'samplePricing','NR','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    System.assert([SELECT count() FROM Case WHERE Subject='Notification from Aetna Integrator']>0);
/*BCTnotif error*/handle.run(NULL,'1234','TPIDnotif',NULL,'New',NULL,'H',NULL,'National',NULL,NULL,'samplePricing','NR','MN','Self Insured','Prospective','1986-12-26',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Sample Error');
    System.assert([SELECT count() FROM Case WHERE Subject='Notification from Aetna Integrator']>0);
   
  }//end IF 
  Test.stopTest(); 
 }
 static testmethod void test2(){
  CRD__c testdata=[SELECT ID FROM CRD__c LIMIT 1];
  Test.startTest();
  if(testdata!=NULL){
     IntegrationDispatcher handle=new IntegrationDispatcher();
     handle.run('342323','1234',NULL,'samplePPID','Existing','H',NULL,NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     /*invalid RiskIndicator*/handle.run(String.valueOf(testdata.Id),'1234',NULL,'samplePPID','New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','K','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     /*TPID.TN.Invalid RxPlanID*/handle.run(String.valueOf(testdata.Id),'1234567891011','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     /*Reply.Non-package.Notmatched */handle.run(String.valueOf(testdata.Id),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,NULL,'New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  }
  Test.stopTest();
 }
 
 static testmethod void test_exceptions(){
  CRD__c testdata=[SELECT ID FROM CRD__c LIMIT 1];
  Test.startTest();
  if(testdata!=NULL){
     IntegrationDispatcher handle=new IntegrationDispatcher();
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3214','TF','New',NULL);
     handle.run(String.valueOf(testdata.Id),'1234','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1234','TF','New',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1234','TF','New',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,'samplePPID','Existing',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','R','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
      
  }
 Test.stopTest();
 }
 
/**
 static testmethod void unitTest1(){
  
  
  CRD__c testdata = new CRD__c();
      testdata.Platform_Information__c = 'T';
      testdata.Pricing_Schedule__c = 'SamplePricing';
      testdata.TP_ID__c = 'sampleTPID';
      testdata.Rx_PP_ID__c = 'Test';
      testdata.Risk_Indicator__c = 'S';
      testdata.Acquisition_Indicator__c = 'Yes';
      system.debug('#####CRD#### ' + testdata);
      insert testdata ;
      
     
      system.debug('####CRD#### ' + testdata.name);
  Test.startTest();
  if(testdata!=NULL){
     IntegrationDispatcher handle=new IntegrationDispatcher();
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Old',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test','Test',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'New',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test','Test',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Old',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test','Test',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Old',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test','Existing',NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID',NULL,'Old',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID','Test','Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID','Test','New',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213','sampleTPID','Test','Old',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,'Test','Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,'Test','Existing',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S','Test',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,'Test','New',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S','Test',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     handle.run(String.valueOf(testdata.Id),'12345678910111213',NULL,'Test','Old',NULL,'T',NULL,NULL,NULL,'TE','SamplePricing','S','Test',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Test','Test',NULL,NULL);
     
  }
 Test.stopTest();
 }
 **/
}