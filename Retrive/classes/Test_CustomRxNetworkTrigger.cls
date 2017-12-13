/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong		06-01-15			PopulateRxAcctMgr() - Auto-populate Rx Account Manager on Custom Network Notification object
======================================================================== */

@isTest
public class Test_CustomRxNetworkTrigger {

    static testMethod void testATMs() {
        
        List<Profile> admin = new List<Profile>();
        admin = [ Select Id, Name From Profile Where Name = 'System Administrator' LIMIT 1 ];
        
        // create test user
        User u = new User(FirstName = 'Jenna', LastName = 'Vuong', Email = 'vuongj@aetna.com', Username = 'hellotest@test.com', Alias = 'yo', ProfileId = admin[0].Id,
                         TimeZoneSidKey = 'America/Denver', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        insert u;
        
        // create test account w atm
        Account a = new Account(Name = 'Test Account', APM_PSUID__c = '11223344');
		insert a;
        
        // create test account w/o atm
        Account b = new Account(Name = 'Test Acct without ATM', APM_PSUID__c = '2222222');
        insert b;

        // create test pharmacy account manager
        AccountTeamMember atm = new AccountTeamMember(AccountId = a.Id, TeamMemberRole = 'Pharmacy Account Manager', UserId = u.Id);
        insert atm;
        
        // create 1st test CNN record 
        Custom_Rx_Network__c n1 = new Custom_Rx_Network__c(Account_Name__c = b.Id, Plan_Sponsor_Funding_Type__c = 'Fully Insured', Custom_Rates_at_Retail__c = 'No',
                                                          Control_Group_Number__c = '12345');
        insert n1;
   
        Test.startTest();
        
        // create 2nd test CNN record
        Custom_Rx_Network__c n2 = new Custom_Rx_Network__c(Account_Name__c = a.Id, Plan_Sponsor_Funding_Type__c = 'Fully Insured', Custom_Rates_at_Retail__c = 'No',
                                                          Control_Group_Number__c = '123456');
        insert n2;
        
        // update n1
        n1.Account_Name__c = a.Id;
        update n1;
        
        Test.stopTest();
        
        List<Custom_Rx_Network__c> query = new List<Custom_Rx_Network__c>();
        query = [ Select Id, Account_Name__c, Rx_Account_Manager__c From Custom_Rx_Network__c ];
        
        System.assertEquals(2, query.size());
        System.assertEquals(u.Id, query[0].RX_Account_Manager__c);
        System.assertEquals(u.Id, query[1].RX_Account_Manager__c);
        System.assertEquals(a.Id, query[0].Account_Name__c);
        System.assertEquals(a.Id, query[1].Account_Name__c);
        
    }
}