@isTest
private class Test_AMTrackers {

    static testMethod void Test_AssignTracker() {
    	
    	Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        QueueSObject AMQueue = [ SELECT QueueId FROM QueueSObject WHERE Queue.Name = 'AM Tracker Supervisor Queue' LIMIT 1 ];
        
        test.startTest();
        Account_Manager_Trackers__c t=new Account_Manager_Trackers__c ();
        t.Plan_Sponsor_Name__c = TestAccount.Id;
        t.OwnerId=AMQueue.QueueId;
        insert t;
        test.stopTest();
        
    }
}