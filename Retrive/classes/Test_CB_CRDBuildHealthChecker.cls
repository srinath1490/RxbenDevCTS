/*Purpose: Apex Test Class to test CB_CRDBHealthChecker
========================================================================
History 
------- 
VERSION    AUTHOR    DATE        DETAIL 
1.0        Nitish    2/25/2015   Apex Test Class to test CB_CRDBHealthChecker
======================================================================== */

@isTest
private class Test_CB_CRDBuildHealthChecker{
    static testMethod void testHealthChecker(){  
        Test.startTest();
        Datetime sysTime = System.now().addSeconds( 300 );      
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        CB_CRDBHealthChecker Step = new CB_CRDBHealthChecker();
        String jobId = System.schedule('testBasicScheduledApex',chronExpression,new CB_CRDBHealthChecker());
        Batch_CRDBuildStep1 crdBuildStep = new Batch_CRDBuildStep1();
        ID batchprocessid1 = Database.executeBatch(crdBuildStep);        
        BAC_CB_Validations validations = new BAC_CB_Validations();
        ID batchprocessid2 = Database.executeBatch(validations);        
        BAC_CB_Completion completion = new BAC_CB_Completion();
        ID batchprocessid3 = Database.executeBatch(completion);        
        //BAC_CB_MassSend2AIRequest massSend2AIRequest = new BAC_CB_MassSend2AIRequest();
        //ID batchprocessid4 = Database.executeBatch(massSend2AIRequest);        
        BAC_CB_MassSend2AI massSend2AI = new BAC_CB_MassSend2AI(); 
        massSend2AI.setquery('select id, CRD__c from CRDBuildOrder__c where valid__c = true and Build__c = True and Complete__c = true AND Aicallout__c = false AND CRD__c <> null limit 1');
        ID batchprocessid5 = Database.executeBatch(massSend2AI); 
        Test.stopTest();                  
}
}