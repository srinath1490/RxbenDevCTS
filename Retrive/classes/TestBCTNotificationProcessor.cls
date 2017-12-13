/*Purpose: Apex Test Class to test ChangeHistoryController
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Nitish          3/18/2015          Apex Test Class to test BCTNotificationProcessor
======================================================================== */

    @isTest
    Public class TestBCTNotificationProcessor{
    static Testmethod Void Test1(){
    boolean result;
    Test.StartTest();
    CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Pk';
          testCrd.Do_mandates_apply_to_all_states__c = 'Y';
          testCrd.RxPlanID__c = 'Rx';
          insert testCrd;
          BCTNotificationService.RxPlanDetail rxDetail2=new BCTNotificationService.RxPlanDetail('rxPlanId','E','TN','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail2=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail2.add(rxDetail2);
          system.debug('List SIze'+lstDetail2.size());
          BCTNotificationService.RxPlanDetail rxDetail3=new BCTNotificationService.RxPlanDetail('rxPlanId','K','TN','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail3=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail3.add(rxDetail3);
          BCTNotificationService.RxPlanBlock rxBlock2=new BCTNotificationService.RxPlanBlock(lstDetail2,lstDetail3);
          BCTNotificationService.RxPlanBlock rxBlock3=new BCTNotificationService.RxPlanBlock(lstDetail2,lstDetail3);
          system.debug('No Value'+rxBlock2);
         
          BCTNotificationService.traditionalControlNumberPlanSummary tradPlanSummary=new BCTNotificationService.traditionalControlNumberPlanSummary(0,'');
          list<BCTNotificationService.traditionalControlNumberPlanSummary> lstControlPlanSummary=new list<BCTNotificationService.traditionalControlNumberPlanSummary>();
          lstControlPlanSummary.add(tradPlanSummary);
          BCTNotificationService.tradHierarchy tradhier =new BCTNotificationService.tradHierarchy(0,1,2,'');
          BCTNotificationService.custmoHierarchy customhier =new BCTNotificationService.custmoHierarchy('a','v','c','d');
          BCTNotificationService.ReturnData rData13= new BCTNotificationService.ReturnData();
              rData13.CRDID = testCrd.ID;
              rData13.PlanID = 'testTPId';
              rData13.RequestId = 'RequestId';
              rData13.notificationCount = 12;
              rData13.requestType = 'HMO_Custom';
              rData13.pricingSchedule = 'Pk';
              rData13.riskIndicator = 'rl';
              rData13.fundingType = 'V';
              rData13.planId = 'planId';
              rData13.traditionalControlNumberPlanSummaryDetails = lstControlPlanSummary;
              rData13.errorType = 'errorType';
              rData13.errorDescription = 'errorDescription';
              rData13.benefitsString = 'benefitsString';
              rData13.rxPlanBlock = rxBlock2;
              rData13.hmoHierarchy = customhier ;
              rData13.traditionalHierarchy = tradhier ;
              rData13.tieredRxPlanBlock = rxBlock3;
              rData13.AcquisitionIndicator = 'AcquisitionIndicator';
              rData13.benefitsStringExtension = 'benefitsStringExtension';
              rData13.effectiveDate = string.valueof(system.Today());
              rData13.termDate = string.valueof(system.Today());
              rData13.erb= 'erb';
              rData13.subSegment = 'subSegment';
              rData13.benefitsApplyToAllStates = True;
              rData13.benefitsStateList = 'benefitsStateList';
              rData13.listOfStatesToRemoveFromPlan = 'listOfStatesToRemoveFromPlan';
              rData13.OrgId = 'OrgId';
              rData13.OrgArrangementId = 'OrgArrangementId';
              rData13.OrgType = 'OrgType';
              rData13.CarrierId = 'CarrierId';
              rData13.PSUID = 'PSUID';
              rData13.TypeofPlan = 'TypeofPlan';
              rData13.changeLevelIndicator = 'changeLevelIndicator';
              rData13.acquisitionCode = 'acquisitionCode';
              rData13.Marketsegment = 'Marketsegment';
              rData13.CFO = 'CFO';
              result = BCTNotificationService.BctNotification(rData13);    
        BCTNotificationProcessor bct = new BCTNotificationProcessor ();
        BCTNotificationService.ReturnData rData14= new BCTNotificationService.ReturnData();
        rData14.requestType = 'Traditional_Packaged';
        BCTNotificationService.ReturnData rData15= new BCTNotificationService.ReturnData();
        rData15.requestType = 'Traditional_Source_PERS';
        BCTNotificationService.ReturnData rData16= new BCTNotificationService.ReturnData();
        rData16.requestType = 'HMO_Packaged';
        BCTNotificationService.ReturnData rData17= new BCTNotificationService.ReturnData();
        rData17.requestType = 'Traditional_Non_Packaged';
        BCTNotificationService.ReturnData rData18= new BCTNotificationService.ReturnData();
        rData18.requestType = 'HMO_Source_HMO';
        BCTNotificationService.ReturnData rData19= new BCTNotificationService.ReturnData();
        rData19.requestType = 'Traditional_LikePackage';
        //bct.processTradNonPackagePackagedData(rData13, testCrd);
         //bct.processTradNonPackagePackagedData(rData14, testCrd);
        bct.checkBenefitStateList(testCrd, false);
        Crd__c testcrd2 = new Crd__c();
        testcrd2.Do_mandates_apply_to_all_states__c = 'N';
        testcrd2.Benefits_State_List__c = 'Statistics';
        insert testcrd2;
        bct.checkBenefitStateList(testcrd2, true);
        bct.compareMultiSelectPicklist(testcrd2, 'statistics');
        //bct.processHMOPackagedData(rData13,testCrd);
        //bct.processTradionalPackageData(rData13,testCrd);
        Integration_log__c log = new Integration_log__c();
        log.Time_Stamp__c = system.today();
        insert log;
        bct.processExistingData(log,rData13,testCrd);
        bct.processExistingData(log,rData14,testCrd);
        bct.processExistingData(log,rData15,testCrd);
        bct.processExistingData(log,rData16,testCrd);
        bct.processExistingData(log,rData17,testCrd);
        bct.processExistingData(log,rData18,testCrd);
        bct.processExistingData(log,rData19,testCrd);
        bct.createTaskForData(rData13,testCrd,'a','b','c');
        bct.sendEmailForTask('00550000003BTal','taskid','crdname');
        bct.getRxPlanItems(lstDetail2);
        bct.CreateDescriptionString(rData13);
        //bct.createCaseForData(rData13,'Casedes','caseReason','caseType','caseOrigin','caseSubject');
        BCTNotificationService.RxPlanDetail rxDetail5=new BCTNotificationService.RxPlanDetail('rxPlanId','N','TN','states');
        //bct.AireplyBlock(rData13,rxDetail2,testCrd,'TN');
        //bct.AireplyBlock(rData13,rxDetail5,testCrd,'TN');
        bct.processTradLikePackagePackagedData(log,rData13,testCrd);
        Map<string,string> arguments = new Map<string,string>();
        //bct.BCTnotification(rData13,'Rx',arguments,True,testCrd.ID);
        Test.StopTest();
    }
    }