@isTest
private class Test_PERSAuditRequestTriggers {

    static testMethod void Test_AutoRelatetoAccount() {
        //testing the auto relation of PERS Audit Requests to account records based on the PSU provided on webform
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        insert TestAccount;
        
        test.startTest();
        PERS_Audit__c TestReq = new PERS_Audit__c ();
        TestReq.PERSAUDIT_Requestor_s_Name__c = 'Becca Allen';
        TestReq.PERSAUDIT_Requestor_s_Email__c = 'allenr4@aetna.com';
        TestReq.PERSAUDIT_Requestor_s_Phone__c = '860-584-6503';
        TestReq.PERSAUDIT_Status__c = 'New';
        TestReq.Rx_Revisions_Renewals__c = '900 Remarks';
        TestReq.New_Existing_Customer__c = 'Existing';
        TestReq.PERSAUDIT_Plan_Sponsor_Unique_ID__c = '11223344';
        insert TestReq;
        system.debug(logginglevel.ERROR,TestReq.PERSAUDIT_Plan_Sponsor_Unique_ID__c+TestReq.Plan_Sponsor_Name_2__c);
        test.stopTest();
        
        system.assertEquals([select Plan_Sponsor_Name_2__c from PERS_Audit__c where Id=:TestReq.Id][0].Plan_Sponsor_Name_2__c,TestAccount.Id);
    }
    
    static testMethod void Test_NewBusinessImplementations() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        TestAccount.NB_Implementation__c = true;
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Implementation Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
         PERS_Audit__c TestReq = new PERS_Audit__c ();
        system.runas(ub){
            test.startTest();
           
            TestReq.PERSAUDIT_Requestor_s_Name__c = 'Becca Allen';
            TestReq.PERSAUDIT_Requestor_s_Email__c = 'allenr4@aetna.com';
            TestReq.PERSAUDIT_Requestor_s_Phone__c = '860-584-6503';
            TestReq.PERSAUDIT_Status__c = 'New';
            TestReq.Rx_Revisions_Renewals__c = '900 Remarks';
            TestReq.New_Existing_Customer__c = 'Existing';
            TestReq.Plan_Sponsor_Name_2__c = TestAccount.Id;
            TestReq.PERSAUDIT_Plan_Sponsor_Unique_ID__c = '11223344';
            insert TestReq;
            system.debug(logginglevel.ERROR,TestReq.PERSAUDIT_Plan_Sponsor_Unique_ID__c+TestReq.Plan_Sponsor_Name_2__c);
            test.stopTest();
        }
        system.assertEquals(ub.Id, [select Ownerid from PERS_Audit__c where Id=:TestReq.Id][0].OwnerId);
    }
}