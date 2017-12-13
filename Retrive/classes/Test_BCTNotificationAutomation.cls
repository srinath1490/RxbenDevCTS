/**
 * rData1 class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates rData1 class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_BCTNotificationAutomation {

    static testMethod void myUnitTest() {
        boolean result;
        BCTNotificationService.tradHierarchy tradHierarcy=new BCTNotificationService.tradHierarchy(0,0,0,'');
        BCTNotificationService.ReturnData rData1 = new BCTNotificationService.ReturnData();
        /* rData1.RequestId='';
        rData1.notificationCount=0;
        rData1.crdId='';
        rData1.requestType='';
        rData1.pricingSchedule='';
        rData1.riskIndicator='';
        rData1.fundingType='';           
        rData1.planId=null;  
        rData1.tieredRxPlanBlock=null;               
        rData1.rxPlanBlock=null;
        rData1.errorType='';
        rData1.errorDescription='';
        rData1.benefitsString='';
        rData1.benefitsStringExtension='';
        rData1.traditionalControlNumberPlanSummaryDetails=null;
        rData1.erb='';
        rData1.subSegment='';      
        rData1.benefitsApplyToAllStates=true;
        rData1.benefitsStateList='';
        rData1.listOfStatesToRemoveFromPlan='';
        rData1.hmoHierarchy=null;
        rData1.traditionalHierarchy=tradHierarcy;  
        rData1.OrgId='15832676';
        rData1.OrgArrangementId='80869880';
        rData1.OrgType='MEHUS';
        rData1.CarrierId='7700';
        rData1.changeLevelIndicator='83561937';
        rData1.acquisitionCode='';
        rData1.accountname = 'test';
        rData1.PSUID = '874243';
        rData1.effectivedate = String.valueof(system.Today());
        rData1.termdate = String.valueof(system.Today());
        rData1.TypeOfPlan= 'trad';
        rData1.Marketsegment = 'NS'; */
      
         BCTNotificationService.BctNotification(rData1);     
         List<Account> acc = new List<Account>();
         Account a = new Account();
         a.name = 'abhi';
         a.APM_PSUID__c = rData1.PSUID;
         acc.add(a);
         insert acc;
         
         Partial_Control_Group__c pCG = new Partial_Control_Group__c();
         pCG.PSUID__c = '83561937';
         pCG.CSAP_Control_ID__c = '810089';
         pCG.CSAP_Plan_ID__c = '22';
         pCG.Product_Indicator__c = 'PPO';
         pCG.Rating_ERB__c = '';
         pCG.Subsegment__c = '';
         pCG.Control_Group_Effective_Date__c = system.Today();
         pCG.Control_Group_Term_Date__c = system.Today();
         pCG.Account__c = a.id;
         insert pCG;
         
         BCTNotificationAutomation auto = new BCTNotificationAutomation();
         BCTNotificationAutomation.ProcessFCGAutomation(rData1,acc,pCG);
         
         OrgandArrangement__c orgArr = new OrgandArrangement__c();
         orgArr.ArrangmentName__c = 'AAA';
         orgArr.ArrangmentId__c = '22222';
         orgArr.JoinKey__c = '1111111';
         orgArr.OrgId__c='10';
         orgArr.OrgType__c = 'MEHUS';
         insert orgArr;
         
         Full_Control_Group__c insertFCG = new Full_Control_Group__c();
         insertFCG.Control_Group_Effective_Date__c = system.Today();
         insertFCG.Control_Group_Term_Date__c = system.Today();
         insert insertFCG;
         
         OrgStructure__c orgStructue = new OrgStructure__c();
         orgStructue.FullControlGroup__c = insertFCG.Id;
         orgStructue.OrgandArrangement__c = orgArr.Id;
         orgStructue.OrgArrangmentId__c = '22222';
         orgStructue.JoinKey__c = '1111111';
         orgStructue.OrgId__c='10';
         orgStructue.OrgType__c = 'MEHUS';
         insert orgStructue;
         
         
         BCTNotificationAutomation.orgborAutomation('15832676','80869880','MEHUS',insertFCG,pCG);
         OrgandArrangement__c orgArr1 = new OrgandArrangement__c();
         orgArr1.ArrangmentName__c = 'AAAc';
         orgArr1.ArrangmentId__c = '222221';
         orgArr1.JoinKey__c = '11111111';
         orgArr1.OrgId__c='101';
         orgArr1.OrgType__c = 'MEHUS1';
         insert orgArr1;
      
    }
}