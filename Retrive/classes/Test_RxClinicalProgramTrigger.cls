/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong     03-25-15    		Test_RxClinicalProgTriggerHandler(), create new case when Rx Clinical Program is closed won
   2.0 -    Bhaskar Arora   09-25-16            Updated Rx_Clinical_Program_Opp__c insertion to include Formulary__c to bypass Validation rule (Formulary_required_when_opp_Closed_won).
												We have a Deployment in Production for September 26th 2016.
======================================================================== */

@isTest
private class Test_RxClinicalProgramTrigger {

    static testMethod void Test_RxClinicalProgTriggerHandler() {
        
        List<RecordType> rt = new List<RecordType>([ Select Id, Name, DeveloperName From RecordType Where sObjectType = 'Case' and isActive = true and
                                       DeveloperName = 'Plan_Sponsor_Questions_or_Issues' LIMIT 1 ]);
        List<Profile> profile = new List<profile>([ Select Id, Name From Profile Where Name = 'Implementation Managers' LIMIT 1 ]);
        
        // create test data
        User testUser = new User(FirstName = 'Jenna', LastName = 'Vuong', Email = 'jenna@aetna.com', Alias = 'jenna', Username = 'jenna@aetna.com', LocaleSidKey = 'en_US',
                                TimeZoneSidKey = 'GMT', ProfileID = profile[0].Id, LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert testUser;
        
        Account testAcct = new Account(Name = 'Test Acct');
        insert testAcct;
        
        AccountTeamMember atm = new AccountTeamMember(AccountId = testAcct.Id, TeamMemberRole = 'Pharmacy Account Manager', UserId = testUser.Id);
        insert atm;
        
        Opportunity testOpp = new Opportunity(AccountId = testAcct.Id, Name = 'Test Acct - Rx Clinical Program', StageName = 'Negotiation', CloseDate = System.today());
        insert testOpp;
        
        
        // Test after insert closed won program, with ATM
        Rx_Clinical_Program_Opp__c testProg = new Rx_Clinical_Program_Opp__c(Formulary__c='Value based program',Opportunity__c = testOpp.Id, Name = 'Save A Copay Drug Classes', Stage__c = 'Closed Won', Program_Start_Date__c = System.today());
        insert testProg;
        
        // Test after update closed won program, with ATM
        Rx_Clinical_Program_Opp__c testProg2 = new Rx_Clinical_Program_Opp__c(Formulary__c='Premier based program',Opportunity__c = testOpp.Id, Name = 'Save A Copay Drug Classes', Stage__c = 'Negotiation', Program_Start_Date__c = System.today());
        insert testProg2;
        
        Test.startTest();
        
        testProg2.Stage__c = 'Closed Won';
        update testProg2;
        
        List<Rx_Clinical_Program_Opp__c> programs = new List<Rx_Clinical_Program_Opp__c>([ Select Id, Opportunity__c, Name, Stage__c from Rx_Clinical_Program_Opp__c ]);
        List<Case> cases = new List<Case>([ Select Id, Subject, Description, OwnerId, RecordTypeId, Aetna_Case_Type__c, AccountId From Case ]);
		
        Test.stopTest();
        
        //System.assertEquals(2, programs.size());
        //System.assertEquals(2, cases.size());
        //System.assertEquals('Closed Won', programs[0].Stage__c);
        //System.assertEquals('Closed Won', programs[1].Stage__c);
        /*System.assertEquals(testUser.Id, cases[0].OwnerId);
        System.assertEquals(testUser.Id, cases[1].ownerId);*/

    }
    
}