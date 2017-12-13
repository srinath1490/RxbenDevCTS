@isTest
 
 public class TestCB_cloneCBONextension{
 static   Testmethod void test1(){
 Test.StartTest();
 PageReference PageRef = Page.CB_cloneCBON;
        test.setCurrentPage(PageRef);
        CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Pk';
          testCrd.Do_mandates_apply_to_all_states__c = 'Y';
          testCrd.RxPlanID__c = 'Rx';
          insert testCrd;
 CRDBuildOrder__c cbon = new CRDBuildOrder__c();
 
 cbon.CRD__c = testCrd.id;
 cbon.PERS_timestamp__c= system.Today();
 insert cbon;
 Pers_Full_Report__c pers = new Pers_Full_Report__c();
 pers.crd__c = null;
                pers.CRD_Build_Order__c = null;
                pers.processed__c = false;
                pers.Case__c = null;
                pers.WS_CNTRL_NO__c = cbon.Control__c;
                pers.WS_PLSM_CD__c = cbon.Plan__c;
                pers.WS_PSUID__c = 'test';
                pers.WS_NEW_INFRC_EFF_DT__c = cbon.Effective_date__c;
                pers.PERStimestamp__c = cbon.PERS_timestamp__c;
  insert pers;
  Test.StopTest();
  ApexPages.StandardController s = new ApexPages.standardController(cbon);                   
       CB_cloneCBONextension controllerClass = new CB_cloneCBONextension(s);                   
             controllerClass.cloneCBON();                        
                  
  
        
        
  
  
  }
  }