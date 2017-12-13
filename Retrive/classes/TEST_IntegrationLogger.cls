@isTest
public class TEST_IntegrationLogger{
  static testmethod void runtest(){
        test.starttest();
        CRD__c testrecord=new CRD__c();
        insert testrecord;
        IntegrationLogger handle=new IntegrationLogger();
        handle.logme(true,'subject','description',system.now(),Userinfo.getName(),'selection','arguments','result');
        handle.logme(NULL,NULL,'description',system.now(),Userinfo.getName(),NULL,'arguments','result');
        system.debug(handle);
        
        List<BCTNotificationService.traditionalControlNumberPlanSummary> lstcps = new List<BCTNotificationService.traditionalControlNumberPlanSummary>();
        list<BCTNotificationService.RxPlanDetail> lstRxPlan = new list<BCTNotificationService.RxPlanDetail>();
        BCTNotificationService.RxPlanBlock rxPlan = new BCTNotificationService.RxPlanBlock(lstRxPlan,lstRxPlan);
        BCTNotificationService.ReturnData AIResponseData = new BCTNotificationService.ReturnData();
        AIResponseData.benefitsApplyToAllStates = True;
        AIResponseData.benefitsStateList = 'All States';
        AIResponseData.benefitsString = 'Test String';
        AIResponseData.MarketSegment = 'CA';
        AIResponseData.CFO = '01';
        AIResponseData.changeLevelIndicator = '01';
        AIResponseData.acquisitionCode = '11';
        AIResponseData.benefitsStringExtension = 'Test String Extension';
        AIResponseData.errorDescription = 'Error';
        AIResponseData.errorType = 'Test Error';
        AIResponseData.listOfStatesToRemoveFromPlan = 'States';
        AIResponseData.planId = '12333232';
        AIResponseData.pricingSchedule = 'ABC';
        AIResponseData.requestType = 'Traditional_Non_Packaged';
        AIResponseData.riskIndicator = 'R';
        AIResponseData.traditionalControlNumberPlanSummaryDetails = lstcps;
        AIResponseData.rxPlanBlock = rxPlan;
        IntegrationLogger.createLog(AIResponseData);  
        //testing the CRD record log
        handle.logme(true,'subject','description',system.now(),Userinfo.getName(),'selection','arguments','result',testrecord.Id);
        handle.logme(NULL,NULL,'description',system.now(),Userinfo.getName(),NULL,'arguments','result',testrecord.Id);
        handle.logmedicare(True,'Test Subject','Test',system.now(),Userinfo.getName(),'selection','arguments','result',testrecord.Id);
        handle.logmedicare(AIResponseData,True,'Test Subject','Test',system.now(),Userinfo.getName(),'selection','arguments','result',testrecord.Id);
        handle.logme(AIResponseData,True,'Test Subject','Test',system.now(),Userinfo.getName(),'selection','arguments','result');
        handle.logme(AIResponseData,True,'Test Subject','Test',system.now(),Userinfo.getName(),'selection','arguments','result',testrecord.Id);
        IntegrationLogger.getRxPlanItems(lstRxPlan );
        system.debug(handle);
        test.stoptest();
  }

}