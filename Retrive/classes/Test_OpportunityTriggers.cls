/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
1.1 -       Jenna Vuong     03-25-15            removed code creating new case when Opportunity of 'Rx Clinical Program' rt is closed won. We
                                                only need to create new case when Rx_Clinical_Program_Opp__c is closed won.
======================================================================== */

@isTest
private class Test_OpportunityTriggers {

    /* 3/25/14 - JV - removed code, no longer need to create new case when opportunity of Rx Clinical Program rt is closed won
    static testMethod void Test_SaleofClinicalProgramNewCase_on_Insert() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        test.startTest();
        Opportunity TestOpp1 = new Opportunity ();
        TestOpp1.Name = 'Test Opp 1';
        RecordType rt1= [Select Id,Name from RecordType where DeveloperName='Rx_Clinical_Programs' LIMIT 1];
        TestOpp1.RecordTypeId = rt1.Id;
        TestOpp1.OwnerId=ua.Id;
        TestOpp1.AccountId = TestAccount.Id;
        TestOpp1.Effective_Date__c=date.today();
        TestOpp1.CloseDate=date.today();
        TestOpp1.StageName='Closed Won';
        insert TestOpp1;
        system.debug(logginglevel.ERROR,TestOpp1.Name+TestOpp1.StageName);
        test.stopTest();
        
    }
    
/* 3/25/14 - JV - removed code, no longer need to create new case when opportunity of Rx Clinical Program rt is closed won
    static testMethod void Test_SaleofClinicalProgramNewCase_on_Update() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        Opportunity TestOpp2 = new Opportunity ();
        TestOpp2.Name = 'Test Opp 2';
        RecordType rt1= [Select Id,Name from RecordType where DeveloperName='Rx_Clinical_Programs' LIMIT 1];
        TestOpp2.RecordTypeId = rt1.Id;
        TestOpp2.OwnerId=ua.Id;
        TestOpp2.AccountId = TestAccount.Id;
        TestOpp2.Effective_Date__c= date.today();
        TestOpp2.CloseDate=date.today();
        TestOpp2.StageName='Negotiation';
        insert TestOpp2;
        
        test.startTest();
        TestOpp2.StageName='Closed Won';
        system.debug(logginglevel.ERROR,TestOpp2.Name+TestOpp2.StageName);
        test.stopTest();
    } */
    
    static testMethod void Test_CreateSoldCaseWorksheet_on_Insert() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember1= new AccountTeamMember ();
        TestTeamMember1.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember1.AccountId=TestAccount.Id;
        TestTeamMember1.UserId=ub.Id;
        insert TestTeamMember1;
        
        AccountTeamMember TestTeamMember2= new AccountTeamMember ();
        TestTeamMember2.TeamMemberRole = 'Strategic Account Executive';
        TestTeamMember2.AccountId=TestAccount.Id;
        TestTeamMember2.UserId=ua.Id;
        insert TestTeamMember2;
        
        test.startTest();
        Opportunity TestOpp3 = new Opportunity ();
        TestOpp3.Name = 'Test Opp 3';
        RecordType rt2= [Select Id,Name from RecordType where DeveloperName='Pharmacy_Record' LIMIT 1];
        TestOpp3.RecordTypeId = rt2.Id;
        TestOpp3.OwnerId=ua.Id;
        TestOpp3.AccountId = TestAccount.Id;
        TestOpp3.APM_Membership_EffectiveDate__c= date.today();
        TestOpp3.CloseDate=date.today();
        TestOpp3.Sales_Activity_Type__c='New Business';
        TestOpp3.Total_Membership_Opportunity__c=4500;
        TestOpp3.APM_Consultant__c='Deloitte';
        TestOpp3.Current_PBM__c='Cigna';
        TestOpp3.APM_WonFrom__c='Cigna';
        TestOpp3.APM_WonReason__c='Medical/Integration';
        TestOpp3.Funding__c='ASC-SI';
        TestOpp3.StageName='Closed Won';
        TestOpp3.Sales_Strategy__c = 'Aetna One';//Richa added since the test class was failing on 12/18/2015
        TestOpp3.Value_Sold__c = true; //Ayushi added since the test class was failing 5/10/2016
        insert TestOpp3;
        system.debug(logginglevel.ERROR,TestOpp3.Name+TestOpp3.StageName);
        test.stopTest();
        
    }
    
    static testMethod void Test_CreateSoldCaseWorksheet_on_Update() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember1= new AccountTeamMember ();
        TestTeamMember1.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember1.AccountId=TestAccount.Id;
        TestTeamMember1.UserId=ub.Id;
        insert TestTeamMember1;
        
        AccountTeamMember TestTeamMember2= new AccountTeamMember ();
        TestTeamMember2.TeamMemberRole = 'Strategic Account Executive';
        TestTeamMember2.AccountId=TestAccount.Id;
        TestTeamMember2.UserId=ua.Id;
        insert TestTeamMember2;
        
        Opportunity TestOpp4 = new Opportunity ();
        TestOpp4.Name = 'Test Opp 4';
        RecordType rt2= [Select Id,Name from RecordType where DeveloperName='Pharmacy_Record' LIMIT 1];
        TestOpp4.RecordTypeId = rt2.Id;
        TestOpp4.OwnerId=ua.Id;
        TestOpp4.AccountId = TestAccount.Id;
        TestOpp4.APM_Membership_EffectiveDate__c=date.today();
        TestOpp4.CloseDate=date.today();
        TestOpp4.Sales_Activity_Type__c='New Business';
        TestOpp4.Total_Membership_Opportunity__c=4500;
        TestOpp4.APM_Consultant__c='Deloitte';
        TestOpp4.Current_PBM__c='Cigna';
        TestOpp4.Funding__c='ASC-SI';
        TestOpp4.StageName='Negotiation';
        insert TestOpp4;
        
        test.startTest();
        TestOpp4.StageName='Closed Won';
        TestOpp4.APM_WonFrom__c='Cigna';
        TestOpp4.APM_WonReason__c='Medical/Integration';
        TestOpp4.Sales_Strategy__c = 'Aetna One';//Richa added since the test class was failing on 12/18/2015
        TestOpp4.Value_Sold__c = true; //Ayushi added since the test class was failing 5/10/2016
        system.debug(logginglevel.ERROR,TestOpp4.Name+TestOpp4.StageName);
        test.stopTest();
        
    }
}