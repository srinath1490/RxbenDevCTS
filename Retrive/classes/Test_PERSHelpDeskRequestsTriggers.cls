@isTest
private class Test_PERSHelpDeskRequestsTriggers {
        
        static testMethod void Test_AutoRelatetoAccount() {
		//testing the auto relation of PERS Help Desk Requests to account records based on the PSU provided on webform
		
		Account TestAccount = new Account();
		TestAccount.name = 'Trigger Test Account';
		TestAccount.APM_PSUID__c = '11223344';
		insert TestAccount;
		
		test.startTest();
		Help_Desk_Requests__c TestReq = new Help_Desk_Requests__c ();
		TestReq.Requestor_s_Name__c = 'Becca Allen';
    	TestReq.Requestor_s_Email__c = 'allenr4@aetna.com';
    	TestReq.Requestor_s_Phone__c = '860-584-6503';
    	TestReq.Status__c = 'New';
    	TestReq.PS_Unique_ID__c = '11223344';
    	insert TestReq;
    	system.debug(logginglevel.ERROR,TestReq.PS_Unique_ID__c+TestReq.Help_Desk_Plan_Sponsor_Name__c);
		test.stopTest();
		
		system.assertEquals([select Help_Desk_Plan_Sponsor_Name__c from Help_Desk_Requests__c where Id=:TestReq.Id][0].Help_Desk_Plan_Sponsor_Name__c,TestAccount.Id);
	}

}