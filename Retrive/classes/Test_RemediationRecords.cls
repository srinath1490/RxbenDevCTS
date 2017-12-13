@isTest
private class Test_RemediationRecords {

    static testMethod void Test_AutoRelateIssueCase() {
        // testing the auto-relating of the Remediation Records to the issue cases
        
        Account TestAccount = new Account();
		TestAccount.name = 'Trigger Test Account';
		insert TestAccount;
		
		User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
		List<Remediation__c> remeds = new List<Remediation__c>();
		Remediation__c remObj = new Remediation__c();
		
		Case TestRemCase = new Case ();
		TestRemCase.AccountId = TestAccount.Id;
		RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' LIMIT 1];
		TestRemCase.RecordTypeId=rt.id;
		TestRemCase.Origin = 'Webform';
		TestRemCase.OwnerId = ua.Id;
		TestRemCase.Status = 'In Progress';
		insert TestRemCase;
		system.debug('Remediation Issue Case Insert'+TestRemCase.Id+TestRemCase.OwnerId);
		
		/*remeds.add(remObj);
		test.startTest();
		TestRemCase.Remediation_Needed__c=false;
		update TestRemCase;
		insert remeds;
		system.debug(logginglevel.ERROR,TestRemCase.CaseNumber+TestRemCase.Remediation_Case__c);
		test.stopTest();*/	
    }
    
    static testMethod void Test_AutoRelateGlobal() {
        // testing the auto-relating of the Remediation Records to the issue cases
        
        Account TestAccount = new Account();
		TestAccount.name = 'Trigger Test Account';
		insert TestAccount;
		
		User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
		List<Remediation__c> remeds = new List<Remediation__c>();
		Remediation__c remObj = new Remediation__c();
		
		Global_Issue_Tracker__c TestRemGlo = new Global_Issue_Tracker__c ();
		TestRemGlo.Requester_s_Name__c = 'Becca Allen';
		TestRemGlo.Requester_s_Email__c='allenr4@aetna.com';
		TestRemGlo.Issue_Description_Status__c = 'test description';
		TestRemGlo.OwnerId = ua.Id;
		insert TestRemGlo;
		system.debug('Remediation Global Insert'+TestRemGlo.Id+TestRemGlo.OwnerId);
	}

}