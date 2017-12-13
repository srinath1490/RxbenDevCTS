@isTest
Private class TEST_IntegrationService{
   static testMethod void runTestCases() {
      IntegrationService ISObject=new IntegrationService();
      CRD__c testdata=[SELECT ID FROM CRD__c LIMIT 1];
      IntegrationService.ReturnData RDObject1=new IntegrationService.ReturnData(NULL,'','TPIDnotif',NULL,'New',NULL,'T',NULL,NULL,NULL,'TN','SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL);
      IntegrationService.ReturnData RDObject2=new IntegrationService.ReturnData(NULL,'5000001586','TPIDnotif',NULL,'New',NULL,'T',NULL,NULL,'TN',NULL,'SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
      IntegrationService.ReturnData RDObject3=new IntegrationService.ReturnData(NULL,'5000001586','TPIDnotif',NULL,'Not New',NULL,'T',NULL,NULL,'TE',NULL,'SamplePricing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TF','Not New',NULL);
      IntegrationService.ReturnData RDObject4=new IntegrationService.ReturnData(String.valueOf(testdata.Id),'1234',NULL,NULL,'New',NULL,'H',NULL,NULL,NULL,NULL,'SamplePricing','N','MN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
      System.assertEquals(IntegrationService.AetnaNotification(NULL),false);
      system.assertEquals(IntegrationService.AetnaNotification(RDObject1),true);
      system.assertEquals(IntegrationService.AetnaNotification(RDObject2),true);
      system.assertEquals(IntegrationService.AetnaNotification(RDObject3),true);
      system.assertEquals(IntegrationService.AetnaNotification(RDObject4),true);

    }
 }