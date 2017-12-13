/*Purpose: Apex Test Class to test TEST_CaseTriggers1
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            28 Aug,2015       Apex Test class to test TEST_CaseTriggers1
======================================================================== */
@isTest
private class TEST_CaseTriggers1 {
    static testMethod void TEST_CaseTriggers1(){
        Account newAccount = new Account();
        newAccount.Name = 'IVL Public Exchange';
        newAccount.APM_PSUID__c = '84745151';
        insert newAccount;
        
        Account newAccount1 = new Account();
        newAccount1.Name = 'SG Public Exchange';
        newAccount1.APM_PSUID__c = '84225151';
        insert newAccount1;
        
        List<Case> caselist = new List<Case>();
        Map<Id,Case> oldCasesMap = new Map<Id,Case>();
        Case caserec = new Case();
        caserec.Related_PSUnique__c = '122331';
        //caserec.Remediation_Needed__c = 'Automated R&R';
        caserec.ownerid = Userinfo.getuserid();
        caserec.Origin = 'CVS CST Webform';
        Insert caserec;
        
        Case caserec1 = new Case();
        caserec1.ownerid = Userinfo.getuserid();
        caserec1.CVS_Status__c = 'Test';
        caserec1.CRD_GMF_Case_Status__c = 'Test';
        
        Insert caserec1;
        //caserec1.Remediation_Needed__c = 'Automated R&R';
        caserec1.Status ='In Progress';
        caserec1.CVS_Status__c = 'In Progress';
        caserec1.CRD_GMF_Case_Status__c= 'In Progress'; 
        caserec1.Issue_Verified_Send_to_Aetna_AM__c = True;
        caserec1.RM_Indicator__c = 'RM Aetna';
        caserec1.Workflow_Assignment__c = 'Not Assigned';
        
        update caserec1;
        caserec1.CRD_GMF_Case_Status__c = 'Submitted';
        caserec1.Status = 'Referred Out';
        caserec1.Business_Owner__c = 'MOD';
        update caserec1;
        caserec1.Business_Owner__c = 'ASRx';
        update caserec1;
        caserec1.Business_Owner__c = 'Acct Associate Team';
        update caserec1;
        caserec1.Business_Owner__c = 'CCST';
        update caserec1; 
        
        oldCasesMap.put(caserec1.id,caserec1 );
        caselist.add(caserec);
        

        CaseTriggers1 ctrl = new CaseTriggers1(true,1);
        ctrl.getATMs(caselist);
        ctrl.AutoRelateAccount(caselist);
        ctrl.CSTIssuesSharedwithCVS(caselist);
        //ctrl.CreateRemediationRecord(caselist);
    }
    static testMethod void TEST_CaseTriggers2(){
        Case caserec = new Case();
        caserec.Related_PSUnique__c = '122331';
        caserec.Origin = 'CVS CST Webform';
        //caserec.Remediation_Needed__c = 'Automated R&R';
        caserec.ownerid = Userinfo.getuserid();
        Insert caserec;
        
        Case caserec1 = new Case();
        caserec1.ownerid = Userinfo.getuserid();
        caserec1.CVS_Status__c = 'Test';
        caserec1.CRD_GMF_Case_Status__c = 'Test';
        Insert caserec1;
        
        caserec1.Status = 'Closed';
        //caserec1.ParentId =caserec.id;
        caserec1.Origin = 'Internal SFDC Transfer';
        caserec1.Aetna_Case_Type__c = 'Mail Order Case';
        //update caserec1;
    }
    
    
    static testMethod void TEST_CaseTriggers3(){
        Account newAccount = new Account();
        newAccount.Name = 'IVL Public Exchange';
        newAccount.APM_PSUID__c = '84745151';
        insert newAccount;
        
        Account newAccount1 = new Account();
        newAccount1.Name = 'SG Public Exchange';
        newAccount1.APM_PSUID__c = '84225151';
        insert newAccount1;
        
        List<Case> caselist = new List<Case>();
        Map<Id,Case> oldCasesMap = new Map<Id,Case>();
        Case caserec = new Case();
        caserec.Related_PSUnique__c = '122331';
        //caserec.Remediation_Needed__c = 'Automated R&R';
        caserec.ownerid = Userinfo.getuserid();
        caserec.Origin = 'CVS CST Webform';
        Insert caserec;
        
        Case caserec1 = new Case();
        caserec1.ownerid = Userinfo.getuserid();
        caserec1.CVS_Status__c = 'Test';
        caserec1.CRD_GMF_Case_Status__c = 'Test';
        
        Insert caserec1;
        //caserec1.Remediation_Needed__c = 'Automated R&R';
        caserec1.Status ='In Progress';
        caserec1.CVS_Status__c = 'In Progress';
        caserec1.CRD_GMF_Case_Status__c= 'In Progress'; 
        caserec1.Issue_Verified_Send_to_Aetna_AM__c = True;
        caserec1.RM_Indicator__c = 'RM Aetna';
        caserec1.Workflow_Assignment__c = 'Not Assigned';
        
        update caserec1;
        caserec1.CRD_GMF_Case_Status__c = 'Submitted';
        caserec1.Status = 'Referred Out';
        caserec1.Business_Owner__c = 'ASRx';
        update caserec1;
        
        oldCasesMap.put(caserec1.id,caserec1 );
        caselist.add(caserec);
        

        CaseTriggers1 ctrl = new CaseTriggers1(true,1);
        ctrl.getATMs(caselist);
        ctrl.AutoRelateAccount(caselist);
        ctrl.CSTIssuesSharedwithCVS(caselist);
        //ctrl.CreateRemediationRecord(caselist);
    }
    
    
    static testMethod void TEST_CaseTriggers4(){
        Account newAccount = new Account();
        newAccount.Name = 'IVL Public Exchange';
        newAccount.APM_PSUID__c = '84745151';
        insert newAccount;
        
        Account newAccount1 = new Account();
        newAccount1.Name = 'SG Public Exchange';
        newAccount1.APM_PSUID__c = '84225151';
        insert newAccount1;
        
        List<Case> caselist = new List<Case>();
        Map<Id,Case> oldCasesMap = new Map<Id,Case>();
        Case caserec = new Case();
        caserec.Related_PSUnique__c = '122331';
        //caserec.Remediation_Needed__c = 'Automated R&R';
        caserec.ownerid = Userinfo.getuserid();
        caserec.Origin = 'CVS CST Webform';
        Insert caserec;
        
        Case caserec1 = new Case();
        caserec1.ownerid = Userinfo.getuserid();
        caserec1.CVS_Status__c = 'Test';
        caserec1.CRD_GMF_Case_Status__c = 'Test';
        
        Insert caserec1;
        //caserec1.Remediation_Needed__c = 'Automated R&R';
        caserec1.Status ='In Progress';
        caserec1.CVS_Status__c = 'In Progress';
        caserec1.CRD_GMF_Case_Status__c= 'In Progress'; 
        caserec1.Issue_Verified_Send_to_Aetna_AM__c = True;
        caserec1.RM_Indicator__c = 'RM Aetna';
        caserec1.Workflow_Assignment__c = 'Not Assigned';
        
        update caserec1;
        caserec1.CRD_GMF_Case_Status__c = 'Submitted';
        caserec1.Status = 'Referred Out';
        caserec1.Business_Owner__c = 'Acct Associate Team';
        update caserec1;
        
        oldCasesMap.put(caserec1.id,caserec1 );
        caselist.add(caserec);
        

        CaseTriggers1 ctrl = new CaseTriggers1(true,1);
        ctrl.getATMs(caselist);
        ctrl.AutoRelateAccount(caselist);
        ctrl.CSTIssuesSharedwithCVS(caselist);
        //ctrl.CreateRemediationRecord(caselist);
    }
    
    static testMethod void TEST_CaseTriggers5(){
        Case caserec = new Case();
        caserec.Related_PSUnique__c = '122331';
        caserec.Origin = 'Webform';
        caserec.Status = 'In Progress';
        caserec.ownerid = Userinfo.getuserid();
        Insert caserec;

        
        caserec.Remediation_Needed__c = 'Automated R&R';
        caserec.Status = 'Referred Out';
        caserec.Business_Owner__c = 'CCST';
        update caserec;
        
        Case caserec1 = new Case();
        caserec1.Related_PSUnique__c = '122331';
        caserec1.Origin = 'Webform';
        caserec1.Remediation_Needed__c = 'Automated R&R';
        caserec1.ownerid = Userinfo.getuserid();
        Insert caserec1;

    }
    
     static testMethod void testCoverageOnly(){
            CaseTriggers1 ctrl = new CaseTriggers1(true,1);
            boolean f1=ctrl.IsVisualforcePageContext;
            f1=ctrl.IsTriggerContext;
            f1=ctrl.IsWebServiceContext;
            f1=ctrl.IsExecuteAnonymousContext;
    }
    
}