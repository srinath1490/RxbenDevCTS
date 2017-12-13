/*
	Test class for CA_setAccount trigger. 
*/

@isTest
private class Test_CA_SetAccount {

    static testMethod void HIXTest() {
    	Test.startTest();
    	//data generation
    	CaseControlPlan__c ccpTestRec=prepareData();
    	ccpTestRec.Subsegment__c='HIX';
    	insert ccpTestRec;
    	Id IVLpublicExchangeAccId=[select id from Account where name='IVL Public Exchange' LIMIT 1][0].Id;
    	
    	//assertions
    	//case's HIXCount should have increased by 1
    	system.assert([select HIXControlPlanCount__c from case limit 1][0].HIXControlPlanCount__c==1);
    	//case ownerid should have changed.
    	system.assert([select AccountId from case limit 1][0].AccountId==IVLpublicExchangeAccId);
    	//insert one SGX
    	insert (new CaseControlPlan__c(Subsegment__c='SGX',case__c=ccpTestRec.case__c,key__c=string.valueof(math.random())+system.today(),NotificationTimeStamp__c=system.now()));
    	//this shouldn't have changed the accountId on the case
    	system.assert([select AccountId from case limit 1][0].AccountId==IVLpublicExchangeAccId);
    	Test.stopTest();
    }
    
    static testMethod void SGXTest() {
    	Test.startTest();
    	//data generation
    	CaseControlPlan__c ccpTestRec=prepareData();
    	ccpTestRec.Subsegment__c='SGX';
    	insert ccpTestRec;
		Id SGpublicExchangeAccId=[select id from Account where name='SG Public Exchange' LIMIT 1][0].Id;
    	
    	//view
    	system.debug('Case:'+[select id,accountid,caseautomationreason__c from case]);
    	system.debug('Account:'+[select id,name from account]);
    	system.debug('CaseControlPlan:'+[select subsegment__c,case__c,key__c,NotificationTimestamp__c from CaseControlPlan__c]);
    	system.debug('Case.accountId:'+[select accountid from case][0].accountid);
    	//assertions
    	//case's SGXCount should have increased by 1
    	system.assert([select SGXControlPlanCount__c from case limit 1][0].SGXControlPlanCount__c==1);
    	//case ownerid should have changed.
    	system.assert([select AccountId from case limit 1][0].AccountId==SGpublicExchangeAccId);
    	//insert one HIX
    	insert (new CaseControlPlan__c(Subsegment__c='HIX',case__c=ccpTestRec.case__c,key__c=string.valueof(math.random())+system.today(),NotificationTimeStamp__c=system.now()));
    	//this shouldn't have changed the accountId on the case
    	system.assert([select AccountId from case limit 1][0].AccountId==SGpublicExchangeAccId);
    	Test.stopTest();
    	//post assertion view
    	system.debug('Post Assertion-Case:'+[select id,accountid,caseautomationreason__c from case]);
    	system.debug('Post Assertion-Account:'+[select id,name from account]);
    	system.debug('Post Assertion-CaseControlPlan:'+[select subsegment__c,case__c,key__c,NotificationTimestamp__c from CaseControlPlan__c]);
    }
    
    static testMethod void negativeTest() {
    	Test.startTest();
    	//generating data
    	case c=new case(caseautomationreason__c='AIPkgNewRxplanid');
    	insert c;
    	insert (new CaseControlPlan__c(Subsegment__c='HIX',case__c=c.Id,key__c=string.valueof(math.random())+system.today(),NotificationTimeStamp__c=system.now()));
    	//assertions
    	//should have create error log records
    	system.debug('errorlog:'+[select id,subject__c from error_log__c]);
    	system.assert([select Id from Error_Log__c where subject__c='Account for IVL and or SG public exchange is missing. Cannot auto assign cases'].size()>0);
    	//account was not set yet
    	system.assert([select accountid from case limit 1][0].accountid==null);
    	Test.stopTest();
    	
    }
    static CaseControlPlan__c prepareData(){
    	//create account
    	 insert new account(name='IVL Public Exchange');
    	 insert new account(name='SG Public Exchange');
    	//create case
    	case c=new case(caseautomationreason__c='AIPkgNewRxplanid');
    	insert c;
    	//return casecontrolplan
    	return (new CaseControlPlan__c(case__c=c.Id,key__c=string.valueof(math.random())+system.today(),NotificationTimeStamp__c=system.now()));
    }
}