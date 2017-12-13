/*Purpose: Apex Test Class to test CB_MassSendToAIRequest
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Nitish           2/3/2015           Apex Test Class to test CB_MassSendToAIRequest   

======================================================================== */
 @isTest
 private class Test_CB_MassSend2AIRequest{
   static testMethod void Test1(){  
       CRD__c testCrd = new CRD__c();
            testCrd.Retail_to_Mail__c =True; 
            insert testCrd;
       Case fallCase = new Case();
            fallCase.Status = 'New';
            fallCase.Aetna_Case_Type__c = 'GMF Case';
            fallCase.Origin = 'Web form';
            fallCase.CRD_GMF_Case_Status__c = 'New';
            fallCase.CRD_GMF_Case_Types__c = 'New GMF';
            insert fallCase;
       CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
            newCrdBuilder.valid__c = true;
            newCrdBuilder.Build__c = true;
            newCrdBuilder.Complete__c = true;
            newCrdBuilder.CRD__c = testCrd.id;
            newCrdBuilder.falloutcase__c = fallCase.ID;
            insert newCrdBuilder;
       List<AI_Request__c> aiRequestList =  new List<AI_Request__c>();
            AI_Request__c AI = new AI_Request__c();
            AI.CRD_ID__c = testCrd.ID;
            AI.Benefit__c = 'TestData';
            AI.Benefits_String_Extn__c = 'TestData';
            AI.Integration_1__c = 'TestData';
            AI.Pricing_Schedule__c ='T';
            AI.Risk_Indicator__c = 'TestData';
            AI.StateList_to_Remove__c = 'TestData';
            AI.Request_Type__c = 'Traditional_Non_Packaged';
            System.assertEquals('Traditional_Non_Packaged',AI.Request_Type__c);
            aiRequestList.add(AI);
       
            Test.StartTest(); 
       CB_MassSend2AIRequest obj = new CB_MassSend2AIRequest();
       obj.massSend2AIRequest(aiRequestList);
            Test.StopTest();
     }
}