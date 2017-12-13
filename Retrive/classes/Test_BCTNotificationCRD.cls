/*Purpose: Apex Test Class to test BCTNotificationCRD
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            10/10/2013           Apex Test Class to test BCTNotificationCRD    

======================================================================== */
@isTest
private class Test_BCTNotificationCRD{
    static testMethod void Test_BAC_BCTNotification(){
        Account accrec = new Account();
        accrec.Name ='ABC Account';
        insert accrec;
        
        Crd__c newcrd = new Crd__c();
        newcrd.account__c = accrec.id;
        newcrd.Plan_Type_Paper__c = true;
        newcrd.Platform_Information__c = 'H';
        newcrd.TP_ID__c = null;
        newcrd.Rx_PP_ID__c = null;
        newcrd.Y_Schd__c = 'Y4';
        newcrd.Effective_Start_Date__c= system.today();
        insert newcrd;        
        
        BCT_Notification_CRD__c bctrec = new BCT_Notification_CRD__c();
        bctrec.Account__c = accrec.id;
        bctrec.CRD_ID__c = newcrd.id;
        bctrec.Plan_Description__c = 'TX';
        insert bctrec;
        
        Test.StartTest();
        BAC_BCTNotificationCRD bctBatch = new BAC_BCTNotificationCRD();
        ID batchprocessid = Database.executeBatch(bctBatch);   
        Test.StopTest();
    }
    
    static testMethod void Test_BCTNotificationCallout(){
        Crd__c newcrd = new Crd__c();
        //Values for Testing if Integration log is created
        newcrd.Platform_Information__c = 'H';
        newcrd.TP_ID__c = null;
        newcrd.Rx_PP_ID__c = null;
        newcrd.Y_Schd__c = 'Y4';
        newcrd.Effective_Start_Date__c= system.today();
        insert newcrd;
        
        AI_Request__c AIRec = new AI_Request__c(); 
        AIRec.CRD_ID__c=newcrd.id;
        AIRec.Created_by_BCT_Mass_Cloning__c=True;
        AIRec.Request_Type__c='Traditional_Non_Packaged';
        insert AIRec;         
        
        Test.StartTest();
        BAC_BCTNotificationCallout bctBatch1 = new BAC_BCTNotificationCallout();
        ID batchprocessid = Database.executeBatch(bctBatch1);   
        Test.StopTest();
    }
    
    static testMethod void Test_GC_Utils_BCT(){
        Account accrec = new Account();
        accrec.Name ='ABC Account';
        insert accrec;
        
        Crd__c newcrd = new Crd__c();
        newcrd.account__c = accrec.id;
        newcrd.Plan_Type_Paper__c = true;
        newcrd.Platform_Information__c = 'H';
        newcrd.TP_ID__c = null;
        newcrd.Rx_PP_ID__c = null;
        newcrd.Y_Schd__c = 'Y4';
        newcrd.Effective_Start_Date__c= system.today();
        insert newcrd;
        
        Test.StartTest();
        GC_Utils_BCT gcUtils = new GC_Utils_BCT();
        gcUtils.overideYscheduleValues(newcrd);
        Test.StopTest();
    }
}