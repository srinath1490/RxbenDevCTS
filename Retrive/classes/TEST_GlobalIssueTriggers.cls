@isTest
private class TEST_GlobalIssueTriggers {

    static testMethod void InsertGlobalwithRemediation() {
    	
        User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
		List<Global_Issue_Tracker__c> issues = new List<Global_Issue_Tracker__c>();
		Global_Issue_Tracker__c globalissues = new Global_Issue_Tracker__c();
		
		Global_Issue_Tracker__c TestIssue = new Global_Issue_Tracker__c ();
		TestIssue.Requester_s_Name__c = 'Becca Allen';
		TestIssue.Requester_s_Email__c = 'allenr4@aetna.com';
		TestIssue.Subject__c = 'test subject';
		TestIssue.Issue_Description_Status__c = 'test';
		TestIssue.Remediation_Needed__C = 'Automated R&R';
		insert TestIssue;
		system.debug('Global Issue Insert'+TestIssue.Id+TestIssue.OwnerId);
    }
    
    static testMethod void UpdateGlobalwithRemediation() {
    	
        User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
		List<Global_Issue_Tracker__c> issues = new List<Global_Issue_Tracker__c>();
		Global_Issue_Tracker__c globalissues = new Global_Issue_Tracker__c();
		
		Global_Issue_Tracker__c TestIssue = new Global_Issue_Tracker__c ();
		TestIssue.Requester_s_Name__c = 'Becca Allen';
		TestIssue.Requester_s_Email__c = 'allenr4@aetna.com';
		TestIssue.Subject__c = 'test subject';
		TestIssue.Issue_Description_Status__c = 'test';
		TestIssue.Remediation_Needed__C = 'None';
		insert TestIssue;
		system.debug('Global Issue Insert'+TestIssue.Id+TestIssue.OwnerId);
		
		TestIssue.Remediation_Needed__c = 'Automated R&R';
		update TestIssue;
    }
}