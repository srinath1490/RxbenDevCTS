/* Description: Test class for CaseTriggers
 *
 * LOG OF CHANGES *
 * 2/5/15 - Jenna Vuong - Changed TestCVSCSTIssuesVerifiedwithoutAM() to assign to 'RxPro Queue' instead of Michelle Rimes per Becca
 *
*/

@isTest
private class Test_CaseTriggers {
    
    /*static testMethod void Test_AutoRelatetoAccount() {
        //testing the auto relation of cases to account records based on the PSU provided on webform
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        Database.insert (TestAccount,false);
        
        test.startTest();
        Case TestCase = new Case();
        TestCase.Origin = 'Web Form';
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestCase.RecordTypeId = rt.Id;
        TestCase.Status = 'New';
        TestCase.Related_PSUnique__c = '11223344';
        insert TestCase;
        test.stopTest();
        
        //system.assertEquals([select AccountId from case where Id=:TestCase.Id][0].AccountId,TestAccount.Id);
    }*/
    
    /*static testMethod void Test_Positive_ExternalCRDCasesToAMs1() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
       
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        
        Case TestExtCase = new Case ();
        TestExtCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        TestExtCase.RecordTypeId=rt.id;
        TestExtCase.Aetna_Case_Type__c = 'CRD Case';
        TestExtCase.Status = 'New';
        TestExtCase.Origin = 'Web Form';
        TestExtCase.OwnerId = ua.Id;
        TestExtCase.CRD_GMF_Case_Types__c = 'New CRD for creating a new plan';
        TestExtCase.CRD_GMF_Case_Status__c = 'New';
        Database.insert (TestExtCase,false);
        
        
        test.startTest();
        TestExtCase.CRD_GMF_Case_Status__c='Submitted';
        Database.update (TestExtCase,false);
        test.stopTest();
 
    }*/
    
    /*static testMethod void Test_Positive_ExternalCRDCasesToAMs2() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        
        Case TestExtCase = new Case ();
        TestExtCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        TestExtCase.RecordTypeId=rt.id;
        TestExtCase.Aetna_Case_Type__c = 'CRD Case';
        TestExtCase.Status = 'New';
        TestExtCase.Origin = 'Web Form';
        TestExtCase.OwnerId = ua.Id;
        TestExtCase.CRD_GMF_Case_Types__c = 'New CRD for implementing a new business';
        TestExtCase.CRD_GMF_Case_Status__c = 'New';
        Database.insert (TestExtCase,false);
        
        
        test.startTest();
        TestExtCase.CRD_GMF_Case_Status__c='Submitted';
        Database.update (TestExtCase,false);
        test.stopTest();
 
    }
    
    static testMethod void Test_Positive_ExternalCRDCasesToAMs3() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        
        Case TestExtCase = new Case ();
        TestExtCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        TestExtCase.RecordTypeId=rt.id;
        TestExtCase.Aetna_Case_Type__c = 'CRD Case';
        TestExtCase.Status = 'New';
        TestExtCase.Origin = 'Web Form';
        TestExtCase.OwnerId = ua.Id;
        TestExtCase.CRD_GMF_Case_Types__c = 'Interim CRD';
        TestExtCase.CRD_GMF_Case_Status__c = 'New';
        Database.insert (TestExtCase,false);
        
        
        test.startTest();
        TestExtCase.CRD_GMF_Case_Status__c='Submitted';
        Database.update (TestExtCase,false);
        
        test.stopTest();
 
    }
    
    static testMethod void Test_Positive_ExternalCRDCasesToAMs4() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        
        Case TestExtCase = new Case ();
        TestExtCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        TestExtCase.RecordTypeId=rt.id;
        TestExtCase.Aetna_Case_Type__c = 'CRD Case';
        TestExtCase.Status = 'New';
        TestExtCase.Origin = 'Web Form';
        TestExtCase.OwnerId = ua.Id;
        TestExtCase.CRD_GMF_Case_Types__c = 'Maintenance CRD';
        TestExtCase.CRD_GMF_Case_Status__c = 'New';
        Database.insert (TestExtCase,false);
        
        
        test.startTest();
        TestExtCase.CRD_GMF_Case_Status__c='Submitted';
        Database.update (TestExtCase,false);
        test.stopTest();
 
    }
    
    static testMethod void Test_Neg_ExternalCRDCasesToAMs() {
        //testing where there is NOT an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestExtCase = new Case ();
        TestExtCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        TestExtCase.RecordTypeId=rt.id;
        TestExtCase.Aetna_Case_Type__c = 'CRD Case';
        TestExtCase.Status = 'New';
        TestExtCase.Origin = 'Web Form';
        TestExtCase.OwnerId = ua.Id;
        TestExtCase.CRD_GMF_Case_Types__c = 'New CRD for creating a new plan';
        TestExtCase.CRD_GMF_Case_Status__c = 'New';
        Database.insert (TestExtCase,false);
        
        
        test.startTest();
        TestExtCase.CRD_GMF_Case_Status__c='Submitted';
        Database.update (TestExtCase,false);
        test.stopTest();

    }
    
    static testMethod void Test_Positive_InternalCRDGMFCases_Audit() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount; 
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Auditor__c = ub.Id;
        insert TestIntCase;
        
        test.startTest();
        TestIntCase.Status='Ready for Audit';
        update TestIntCase;
        test.stopTest();
        //system.assertEquals([select Ownerid from case where Id=:TestIntCase.Id][0].OwnerId, ub.Id);
    }
    
    static testMethod void Test_Positive_InternalCRDGMFCases_ErrorsFound() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Auditor__c = ub.Id;
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='Errors Found - Returning';
        update TestIntCase;
        test.stopTest();
        //system.assertEquals([select Ownerid from case where Id=:TestIntCase.Id][0].OwnerId, ua.Id);
    }
    
    static testMethod void Test_Positive_InternalCRDGMFCases_2ndLevel() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Auditor__c = ub.Id;
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='2nd Level Audit – Errors Found';
        update TestIntCase;
        test.stopTest();
    }
    
    static testMethod void Test_Positive_InternalCRDGMFCases_Fallout() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Fallout_Reason__c = 'CB_Validation';
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='Ready for Audit';
        update TestIntCase;
        test.stopTest();
    }
    
    static testMethod void Test_EventNotification() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Event_Notifications' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Auditor__c = ub.Id;
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='Pending Audit by BCT Notif Team';
        update TestIntCase;
        test.stopTest();
    }
    
    static testMethod void Test_GMFError() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_GMF_Case' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='Ready for Audit';
        update TestIntCase;
        test.stopTest();
    }
    
    static testMethod void Test_GMFErrorReturning() {
        //when case has both an Assigned Team Member and an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_GMF_Case' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        TestIntCase.Auditor__c=ub.Id;
        insert TestIntCase;

        test.startTest();
        TestIntCase.Status='Ready for Audit';
        update TestIntCase;
        test.stopTest();
    }
    
    static testMethod void Test_Neg_InternalCRDGMFCases() {
        //when case does not have an Auditor
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntCase= new Case ();
        TestIntCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntCase.RecordTypeId = rt.Id;
        TestIntCase.Status = 'In Progress';
        TestIntCase.Reason = 'Internal CRD';
        TestIntCase.Origin = 'AI Notification';
        TestIntCase.OwnerId = ua.Id;
        TestIntCase.Assigned_Team_Member__c = ua.Id;
        insert TestIntCase;
        system.debug('Case Inserted with no Auditor Listed'+TestIntCase.Id);
        
        test.startTest();
        TestIntCase.Status='Ready for Audit';
        try {
            update TestIntCase;
        } catch (Exception e) {
            }
        test.stopTest();
        system.debug('No Auditor Listed'+TestIntCase.OwnerId);
    }
    
    static testMethod void TestInternalMigrationCRDGMFCases() {
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIntMigCase= new Case ();
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_Migration_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        TestIntMigCase.RecordTypeId = rt.Id;
        TestIntMigCase.Status = 'In Progress';
        TestIntMigCase.Reason = 'Internal CRD';
        TestIntMigCase.Origin = 'Web Form';
        TestIntMigCase.OwnerId = ua.Id;
        TestIntMigCase.Assigned_Team_Member__c = ub.Id;
        insert TestIntMigCase;
        
        test.startTest();
        TestIntMigCase.Status='Audit Complete, Case Pending';
        update TestIntMigCase;
        test.stopTest();
        //system.assertEquals([select Ownerid from case where Id=:TestIntMigCase.Id][0].OwnerId, ub.Id);
    }
    
    static testMethod void TestCreateIssueMODChildCases() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        Case TestIssueCase=new Case ();
        TestIssueCase.AccountId = TestAccount.Id;
        TestIssueCase.RecordTypeId = rt.Id;
        TestIssueCase.Aetna_Case_Type__c='Account Associate Case';
        TestIssueCase.Origin='Web Form';
        TestIssueCase.Status='In Progress';
        TestIssueCase.Member_ID__c='1122334455';
        TestIssueCase.Subject='Test Issue';
        TestIssueCase.Description='Test Description';
        TestIssueCase.Issue_Submitter_Dept__c='Field Sales/Service Team';
        TestIssueCase.OwnerId=ub.Id;
        Database.insert (TestIssueCase,false);
        
        CaseComment TestCC1 = new CaseComment ();
        TestCC1.ParentId = TestIssueCase.Id;
        TestCC1.CommentBody='Test Case Comment #1';
        Database.insert (TestCC1,false);
        
        CaseComment TestCC2 = new CaseComment ();
        TestCC2.ParentId = TestIssueCase.Id;
        TestCC2.CommentBody='Test Case Comment #2';
        Database.insert (TestCC2,false);
        
        test.startTest ();
        TestIssueCase.Status='Referred Out';
        TestIssueCase.Business_Owner__c='MOD';
        Database.update (TestIssueCase,false);
        test.stopTest ();
    }
    
    static testMethod void TestCreateIssueASRxChildCases() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIssueCase=new Case ();
        TestIssueCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestIssueCase.RecordTypeId = rt.Id;
        TestIssueCase.Aetna_Case_Type__c='Account Associate Case';
        TestIssueCase.Origin='Web Form';
        TestIssueCase.Status='In Progress';
        TestIssueCase.Member_ID__c='1122334455';
        TestIssueCase.Subject='Test Issue';
        TestIssueCase.Description='Test Description';
        TestIssueCase.Issue_Submitter_Dept__c='Field Sales/Service Team';
        TestIssueCase.OwnerId=ub.Id;
        Database.insert (TestIssueCase,false);
        
        CaseComment TestCC1 = new CaseComment ();
        TestCC1.ParentId = TestIssueCase.Id;
        TestCC1.CommentBody='Test Case Comment #1';
        Database.insert (TestCC1,false);
        
        test.startTest ();
        TestIssueCase.Status='Referred Out';
        TestIssueCase.Business_Owner__c='ASRx';
        Database.update(TestIssueCase,false);
        test.stopTest ();
    }
    
    static testMethod void TestCreateIssueAAChildCases() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIssueCase=new Case ();
        TestIssueCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Mail_Order_Case' and SobjectType='Case' LIMIT 1];
        TestIssueCase.RecordTypeId = rt.Id;
        TestIssueCase.Aetna_Case_Type__c='Mail Order Case';
        TestIssueCase.Origin='Web Form';
        TestIssueCase.Status='In Progress';
        TestIssueCase.Member_ID__c='1122334455';
        TestIssueCase.Subject='Test Issue';
        TestIssueCase.Description='Test Description';
        TestIssueCase.Issue_Submitter_Dept__c='Field Sales/Service Team';
        TestIssueCase.OwnerId=ub.Id;
        insert TestIssueCase;
        
        CaseComment TestCC1 = new CaseComment ();
        TestCC1.ParentId = TestIssueCase.Id;
        TestCC1.CommentBody='Test Case Comment #1';
        insert TestCC1;
        
        CaseComment TestCC2 = new CaseComment ();
        TestCC2.ParentId = TestIssueCase.Id;
        TestCC2.CommentBody='Test Case Comment #2';
        insert TestCC2;
        
        test.startTest ();
        TestIssueCase.Status='Referred Out';
        TestIssueCase.Business_Owner__c='Acct Associate Team';
        Database.update(TestIssueCase,false);
        test.stopTest ();
    }
    
    static testMethod void TestCreateIssueCCSTChildCases() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestIssueCase=new Case ();
        TestIssueCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestIssueCase.RecordTypeId = rt.Id;
        TestIssueCase.Aetna_Case_Type__c='Account Associate Case';
        TestIssueCase.Origin='Web Form';
        TestIssueCase.Status='In Progress';
        TestIssueCase.Member_ID__c='1122334455';
        TestIssueCase.Subject='Test Issue';
        TestIssueCase.Description='Test Description';
        TestIssueCase.Issue_Submitter_Dept__c='Field Sales/Service Team';
        TestIssueCase.OwnerId=ub.Id;
        Database.insert (TestIssueCase,false);
        
        CaseComment TestCC1 = new CaseComment ();
        TestCC1.ParentId = TestIssueCase.Id;
        TestCC1.CommentBody='Test Case Comment #1';
        Database.insert (TestCC1,false);
        
        CaseComment TestCC2 = new CaseComment ();
        TestCC2.ParentId = TestIssueCase.Id;
        TestCC2.CommentBody='Test Case Comment #2';
        Database.insert (TestCC2,false);
        
        test.startTest ();
        TestIssueCase.Status='Referred Out';
        TestIssueCase.Business_Owner__c='CCST';
        Database.update(TestIssueCase,false);
        test.stopTest ();
    }
    
    static testMethod void Test_Positive_TaskonClosedChildCases() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        RecordType mrt= [Select Id,Name from RecordType where DeveloperName='Mail_Order_Case' and SobjectType='Case' LIMIT 1];
        
        Case TestAACase=new Case ();
        TestAACase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestAACase.RecordTypeId = rt.Id;
        TestAACase.Aetna_Case_Type__c='Account Associate Case';
        TestAACase.Origin='Web Form';
        TestAACase.Status='In Progress';
        TestAACase.OwnerId=ua.Id;
        insert TestAACase;
        
        List<Case> cases = new List<Case>();
    
        for(Integer i=0; i<5; i++) {
            Case TestMODCase=new Case ();
            TestMODCase.AccountId = TestAccount.Id;
            TestMODCase.RecordTypeId = mrt.Id;
            TestMODCase.Aetna_Case_Type__c='Mail Order Case';
            TestMODCase.Case_Type_Category__c='Mail Order - Shared';
            TestMODCase.Origin='Internal SFDC Transfer';
            TestMODCase.Status='In Progress';
            TestMODCase.Reason='Duplicate';
            TestMODCase.OwnerId=ub.Id;
            TestMODCase.ParentId=TestAACase.Id;
            TestMODCase.Subject='test issue'+i;
            cases.add(TestMODCase);
        }
        insert cases;
        
        test.startTest();
        for(Case TestMODCase: cases){
        TestMODCase.Status='Closed';
        }
        update cases;
        test.stopTest();
    }
    
    static testMethod void Test_Neg_TaskonClosedChildCases() {
        //should error out as the parent case is owned by a queue so a task cannot be created
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;

        User ua = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        QueueSobject RTQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Research Team Queue' LIMIT 1];
        
        Case TestAACase=new Case ();
        TestAACase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestAACase.RecordTypeId = rt.Id;
        TestAACase.Aetna_Case_Type__c='Account Associate Case';
        TestAACase.Origin='Web Form';
        TestAACase.Status='In Progress';
        TestAACase.OwnerId=RTQueue.QueueId;
        insert TestAACase;
        
        Case TestMODCase=new Case ();
        TestMODCase.AccountId = TestAccount.Id;
        RecordType mrt= [Select Id,Name from RecordType where DeveloperName='Mail_Order_Case' and SobjectType='Case' LIMIT 1];
        TestMODCase.RecordTypeId = mrt.Id;
        TestMODCase.Aetna_Case_Type__c='Mail Order Case';
        TestMODCase.Case_Type_Category__c='Mail Order - Shared';
        TestMODCase.Origin='Web Form';
        TestMODCase.Status='In Progress';
        TestMODCase.Reason='Duplicate';
        TestMODCase.OwnerId=ua.Id;
        TestMODCase.ParentId=TestAACase.Id;
        insert TestMODCase;
        
        test.startTest();
        TestMODCase.Status='Closed';
        try {
            update TestMODCase;
        } catch (Exception e) {
        }
        test.stopTest();
    }
    
    static testMethod void TestResearchTeamReferrals() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        Case TestAACase=new Case ();
        TestAACase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestAACase.RecordTypeId = rt.Id;
        TestAACase.Aetna_Case_Type__c='Account Associate Case';
        TestAACase.Origin='Web Form';
        TestAACase.Status='In Progress';
        TestAACase.OwnerId=ub.Id;
        insert TestAACase;
        
        test.startTest();
        TestAACase.Status='Referred Out';
        TestAACase.Business_Owner__c='Research Team';
        Database.update(TestAACase,false);
        test.stopTest();
    }
    
    static testMethod void TestCVSCSTIssuesVerifiedwithAM() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        Case TestCSTCase=new Case ();
        TestCSTCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestCSTCase.RecordTypeId = rt.Id;
        TestCSTCase.Aetna_Case_Type__c='Account Manager Case';
        TestCSTCase.Status='New';
        QueueSobject CVSCSTQueue;
        CVSCSTQueue=[Select QueueId from QueueSobject WHERE Queue.Name='CVS CST Incoming Case Queue' LIMIT 1];
        TestCSTCase.OwnerId=CVSCSTQueue.QueueID;
        insert TestCSTCase;
        
        test.startTest();
        TestCSTCase.Origin='CVS CST Webform';
        TestCSTCase.Issue_Verified_Send_to_Aetna_AM__c=true;
        update TestCSTCase;
        test.stopTest();
        //system.assertEquals(ub.Id, [select Ownerid from case where Id=:TestCSTCase.Id][0].OwnerId);
    }
    
    static testMethod void TestCVSCSTIssuesVerifiedwithoutAM() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        //jenna-added 2/5/15 instead of going to Michelle Rimes should go to 'RxPro Queue' per Becca
        QueueSObject TestRxProQueue = [ SELECT QueueId FROM QueueSObject WHERE Queue.Name = 'RxPro Queue' LIMIT 1 ];

        Case TestCSTCase=new Case ();
        TestCSTCase.AccountId = TestAccount.Id;
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        TestCSTCase.RecordTypeId = rt.Id;
        TestCSTCase.Aetna_Case_Type__c='Account Manager Case';
        TestCSTCase.Status='New';
        QueueSobject CVSCSTQueue;
        CVSCSTQueue=[Select QueueId from QueueSobject WHERE Queue.Name='CVS CST Incoming Case Queue' LIMIT 1];
        TestCSTCase.OwnerId=CVSCSTQueue.QueueID;
        Database.insert (TestCSTCase,false);
        
        test.startTest();
        TestCSTCase.Origin='CVS CST Webform';
        TestCSTCase.Issue_Verified_Send_to_Aetna_AM__c=true;
        Database.update (TestCSTCase,false);
        test.stopTest();
        //jenna-added 2/5/15 instead of going to Michelle Rimes should go to 'RxPro Queue' per Becca
        //System.assertEquals(TestRxProQueue.QueueId, [select Ownerid from case where Id=:TestCSTCase.Id][0].OwnerId);
        //system.assertEquals('00550000001ncs3AAA', [select Ownerid from case where Id=:TestCSTCase.Id][0].OwnerId);
    }
    
    static testMethod void Test_RMTaskIssuesToAMs1() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        Database.insert (TestAccount,false);
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        Database.insert (TestTeamMember,false);
        
        List<Case> rmcases = new List<Case>();
        Case TestRMCase;
        for(Integer i=0; i<5; i++) {
            TestRMCase = new Case ();
            TestRMCase.AccountId = TestAccount.Id;
            TestRMCase.RecordTypeId=rt.id;
            TestRMCase.Origin = 'RM Task';
            TestRMCase.OwnerId = ua.Id;
            TestRMCase.Status = 'New';
            TestRMCase.RM_Indicator__c = 'RM Triage';
            rmcases.add(TestRMCase);
        }
        Database.insert (rmcases,false);
        //system.debug('RM Task Case Insert'+TestRMCase.Id+TestRMCase.OwnerId);
        
        test.startTest();
        for(Case TestRMCaseTemp: rmcases){
            TestRMCaseTemp.RM_Indicator__c='RM Aetna';
        }
        Database.update (rmcases,false);
        //system.debug(logginglevel.ERROR,TestRMCase.RM_Indicator__c+TestRMCase.OwnerId);
        test.stopTest();
        
        //system.assertEquals([select Ownerid from case where Id=:TestRMCase.Id][0].OwnerId,ub.Id); 
    }
    
    static testMethod void Test_RMTaskIssuesToAMs2() {
        //testing where there is an assigned Pharmacy Account Manager on the Account Team
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        List<Case> rmcases = new List<Case>();
        Case TestRMCase;
        for(Integer i=0; i<5; i++) {
            TestRMCase = new Case ();
            TestRMCase.AccountId = TestAccount.Id;
            TestRMCase.RecordTypeId=rt.id;
            TestRMCase.Origin = 'RM Task';
            TestRMCase.OwnerId = ua.Id;
            TestRMCase.Status = 'New';
            TestRMCase.RM_Indicator__c = 'RM Triage';
            rmcases.add(TestRMCase);
        }
        Database.insert (rmcases,false);
        //system.debug('RM Task Case Insert'+TestRMCase.Id+TestRMCase.OwnerId);
        
        test.startTest();
        for(Case TestRMCaseTemp: rmcases){
            TestRMCaseTemp.RM_Indicator__c='RM Aetna';
        }
        Database.update (rmcases,false);
        //system.debug(logginglevel.ERROR,TestRMCase.RM_Indicator__c+TestRMCase.OwnerId);
        test.stopTest();
        
        //system.assertEquals([select Ownerid from case where Id=:TestRMCase.Id][0].OwnerId,ub.Id); 
    }*/
    
    /*static testMethod void Test_CreateRemediationRecordInsert() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        List<Case> cases = new List<Case>();
        Case TestRemCase;
        for(Integer i=0; i<5; i++) {
            TestRemCase=new Case ();
            TestRemCase.AccountId = TestAccount.Id;
            TestRemCase.RecordTypeId = rt.Id;
            TestRemCase.Origin='Web Form';
            TestRemCase.Status='In Progress';
            TestRemCase.Subject='Test Issue +i';
            TestRemCase.Remediation_Needed__c=true;
            TestRemCase.OwnerId=ub.Id;
            cases.add(TestRemCase);
        }
        
        test.startTest ();
        Database.insert (cases,false);
        test.stopTest ();
    }
    
    static testMethod void Test_CreateRemediationRecordUpdate() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        List<Case> cases = new List<Case>();
        Case TestRemCase;
        for(Integer i=0; i<5; i++) {
            TestRemCase=new Case ();
            TestRemCase.AccountId = TestAccount.Id;
            TestRemCase.RecordTypeId = rt.Id;
            TestRemCase.Origin='Web Form';
            TestRemCase.Status='In Progress';
            TestRemCase.Subject='Test Issue +i';
            TestRemCase.OwnerId=ub.Id;
            cases.add(TestRemCase);
        }
        Database.insert (cases,false);
        
        test.startTest ();
        for(Case TestRemCaseTemp : cases){
        TestRemCaseTemp.Remediation_Needed__c=true;
        }
        Database.update (cases,false);
        test.stopTest ();
    }*/
    
    /*static testMethod void Test_CreateSMEHelpDeskRecordUpdate() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        
        List<Case> cases = new List<Case>();
        Case TestSMECase;
        for(Integer i=0; i<5; i++) {
            TestSMECase=new Case ();
            TestSMECase.AccountId = TestAccount.Id;
            TestSMECase.RecordTypeId = rt.Id;
            TestSMECase.Origin='Web Form';
            TestSMECase.Status='In Progress';
            TestSMECase.Subject='Test Issue +i';
            TestSMECase.OwnerId=ub.Id;
            cases.add(TestSMECase);
        }
        Database.insert (cases,false);
        
        test.startTest ();
        for(Case TestSMECaseTemp : cases){
        TestSMECaseTemp.Service_Request_Level__c='Level 2';
        }
        Database.update (cases,false);
        test.stopTest ();
    }*/
    
   /* static testMethod void Test_WebformAssignmenttoAM() {
        
        Account TestAccount = new Account();
        TestAccount.name = 'Trigger Test Account';
        insert TestAccount;
        
        User ua = [Select Id, Name from User where Name='Tracey Shobert' LIMIT 1];
        User ub = [Select Id, Name from User where Name='Becca Allen' LIMIT 1];
        
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Plan_Sponsor_Questions_or_Issues' and SobjectType='Case' LIMIT 1];
        QueueSobject RPQueue=[Select QueueId from QueueSobject WHERE Queue.Name='RxPro Queue' LIMIT 1];
        
        AccountTeamMember TestTeamMember= new AccountTeamMember ();
        TestTeamMember.TeamMemberRole = 'Pharmacy Account Manager';
        TestTeamMember.AccountId=TestAccount.Id;
        TestTeamMember.UserId=ub.Id;
        insert TestTeamMember;
        
        List<Case> cases = new List<Case>();
        Case TestAMCase;
        for(Integer i=0; i<5; i++) {
            TestAMCase=new Case ();
            TestAMCase.AccountId = TestAccount.Id;
            TestAMCase.RecordTypeId = rt.Id;
            TestAMCase.Origin='Web Form';
            TestAMCase.Status='In Progress';
            TestAMCase.Subject='Test Issue';
            TestAMCase.Workflow_Assignment__c='New';
            TestAMCase.OwnerId=RPQueue.QueueId;
            cases.add(TestAMCase);
        }
        Database.insert (cases,false);
        
        test.startTest ();
        for(Case TestAMCaseTemp: cases){
        TestAMCaseTemp.Workflow_Assignment__c='Not Assigned';
        }
        Database.update (cases,false);
        test.stopTest ();
    }*/
    
    static testMethod void mocktestMethod(){
    	CaseTriggers ctObj = new CaseTriggers();
    }
}