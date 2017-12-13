@isTest (SeeAllData = true)
private class Test_CRDAuditTrackerTriggers {

    static testMethod void Test_CompleteInsert() {
    	
    	User ua = [Select Id, Profile.Name from User where Profile.Name ='BCT Supervisor' and IsActive = true LIMIT 1];
		
		CRD__c testCRD = [Select Id from CRD__c where IsDeleted = false LIMIT 1];
		
    	Case TestCase = new Case ();
		RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
		TestCase.RecordTypeId=rt.id;
		TestCase.Fallout_Reason__c = 'CB_Validation';
		TestCase.OwnerId = ua.Id;
		insert TestCase;
        
        CRD_Audit_Tracker__c TestCAT = new CRD_Audit_Tracker__c ();
        RecordType rtc = [Select Id, Name from RecordType where DeveloperName='Complete_Audit' and SobjectType = 'CRD_Audit_Tracker__c' LIMIT 1];
        TestCAT.RecordTypeId=rtc.Id;
        TestCAT.Person_being_audited__c = ua.Id;
        TestCAT.Case__c = TestCase.Id;
        TestCAT.CRD_ID__c = testCRD.Id;
        TestCAT.Auditor__c = ua.Id;
        TestCAT.Errors_Complete__c = 'Plan Types';
        
        test.startTest();
        insert TestCAT;
        test.stopTest();
    }
    
    static testMethod void Test_CompleteUpdate() {
    	
    	User ua = [Select Id, Profile.Name from User where Profile.Name ='BCT Supervisor' and IsActive = true LIMIT 1];
		
		CRD__c testCRD = [Select Id from CRD__c where IsDeleted = false LIMIT 1];
		
    	Case TestCase = new Case ();
		RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
		TestCase.RecordTypeId=rt.id;
		TestCase.Fallout_Reason__c = 'CB_Validation';
		TestCase.OwnerId = ua.Id;
		insert TestCase;
        
        CRD_Audit_Tracker__c TestCAT = new CRD_Audit_Tracker__c ();
        RecordType rtc = [Select Id, Name from RecordType where DeveloperName='Complete_Audit' and SobjectType = 'CRD_Audit_Tracker__c' LIMIT 1];
        TestCAT.RecordTypeId=rtc.Id;
        TestCAT.Person_being_audited__c = ua.Id;
        TestCAT.Case__c = TestCase.Id;
        TestCAT.CRD_ID__c = testCRD.Id;
        TestCAT.Auditor__c = ua.Id;
        TestCAT.Errors_Complete__c = 'Plan Types';
        insert TestCAT;
        
        test.startTest();
        TestCAT.Errors_Complete__c = 'Plan Types; Kit Logic';
        update TestCAT;
        test.stopTest();
    }
    static testMethod void Test_PartialInsert() {
    	
    	User ua = [Select Id, Profile.Name from User where Profile.Name ='BCT Supervisor' and IsActive = true LIMIT 1];
		
		CRD__c testCRD = [Select Id from CRD__c where IsDeleted = false LIMIT 1];
		
    	Case TestCase = new Case ();
		RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
		TestCase.RecordTypeId=rt.id;
		TestCase.Fallout_Reason__c = 'CB_Validation';
		TestCase.OwnerId = ua.Id;
		insert TestCase;
        
        CRD_Audit_Tracker__c TestCAT = new CRD_Audit_Tracker__c ();
        RecordType rtc = [Select Id, Name from RecordType where DeveloperName='Partial_Audit' and SobjectType = 'CRD_Audit_Tracker__c' LIMIT 1];
        TestCAT.RecordTypeId = rtc.Id;
        TestCAT.Person_being_audited__c = ua.Id;
        TestCAT.Case__c = TestCase.Id;
        TestCAT.CRD_ID__c = testCRD.Id;
        TestCAT.Auditor__c = ua.Id;
        TestCAT.Changes__c = 'Common Fallout #1; Conflicts #1';
        TestCAT.Errors_Partial__c = 'Common Fallout #1';
        
        test.startTest();
        insert TestCAT;
        test.stopTest();
    }
    
    static testMethod void Test_PartialUpdate() {
    	
    	User ua = [Select Id, Profile.Name from User where Profile.Name ='BCT Supervisor' and IsActive = true LIMIT 1];
		
		CRD__c testCRD = [Select Id from CRD__c where IsDeleted = false LIMIT 1];
		
    	Case TestCase = new Case ();
		RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
		TestCase.RecordTypeId=rt.id;
		TestCase.Fallout_Reason__c = 'CB_Validation';
		TestCase.OwnerId = ua.Id;
		insert TestCase;
        
        CRD_Audit_Tracker__c TestCAT = new CRD_Audit_Tracker__c ();
        RecordType rtc = [Select Id, Name from RecordType where  DeveloperName='Partial_Audit' and SobjectType = 'CRD_Audit_Tracker__c' LIMIT 1];
        TestCAT.RecordTypeId=rtc.Id;
        TestCAT.Person_being_audited__c = ua.Id;
        TestCAT.Case__c = TestCase.Id;
        TestCAT.CRD_ID__c = testCRD.Id;
        TestCAT.Auditor__c = ua.Id;
        TestCAT.Changes__c = 'Common Fallout #1; Conflicts #1';
        TestCAT.Errors_Partial__c = 'Common Fallout #1';
        insert TestCAT;
        
        test.startTest();
        TestCAT.Changes__c = 'Common Fallout #1; Conflicts #1; Invalid Provision';
        TestCAT.Errors_Partial__c = 'Common Fallout #2; Conflicts #1';
        update TestCAT;
        test.stopTest();
    }
}