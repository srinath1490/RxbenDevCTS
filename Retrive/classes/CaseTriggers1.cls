/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong     01-29-15            case restructuring, refactor 5 triggers into 1
======================================================================== */

public class CaseTriggers1 { 
    
    @TestVisible private boolean isExecuting = false;
    @TestVisible private integer BatchSize = 0;
    
    @TestVisible private Static String STATUS_TEXT = 'Status';
    @TestVisible private Static String CVS_STATUS_TEXT = 'CVS Status';
    @TestVisible private Static String EXTERNAL_STATUS_TEXT = 'Externally Shared Case Status';
    @TestVisible private Static Map<String,String> recordTypes = Null; 
    @TestVisible private Static Map<String,Id> allQueuesMap = Null;
    @TestVisible private Map<String,String> atmMap = new Map<String,String>{};
     
    public CaseTriggers1(boolean isExecuting, integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
        if(recordTypes == Null){
            recordTypes = new Map<String,String>{};
            for (RecordType rt : [ SELECT Name, Id FROM RecordType WHERE isActive = true AND sObjectType = 'Case' ] ) {
                recordTypes.put(rt.Name,rt.Id);
            }
        }
        if(allQueuesMap == Null){
            allQueuesMap = new Map<String,Id>{};
            for (Group q : [ Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' ] ) {
                allQueuesMap.put(q.DeveloperName,q.Id);
            }
        }
    }
    
    @TestVisible private Map<String,String> getATMs (List<Case> newCases) {
        
        List<String> AccountIds = new List<String>(); 
        
        for (Case c : newCases) {
            AccountIds.add(c.AccountId);
        }
        
        for (AccountTeamMember atm : [ SELECT AccountId, UserId FROM AccountTeamMember WHERE TeamMemberRole = 'Pharmacy Account Manager' AND AccountId IN :AccountIds ] ) {
            atmMap.put(atm.AccountId,atm.UserId);
        }
        
        return atmMap;
    }
    
    // *** BEFORE INSERT *** AutoRelateAccount
    public void AutoRelateAccount (List<Case> cases) {

        System.debug(logginglevel.FINEST,'Inside Case Before Insert Trigger');
        
        List<Case> casesToAdd = new List<Case>(); //jenna-added
        Set<String> AccountSet = new Set<String>();
        List<String> AccountIds = new List<String>();
        
        for (Case c : cases) { AccountSet.add(c.Related_PSUnique__c); }
        
        AccountIds.addAll(AccountSet);
        
        // Query for Accounts
        List<Account> accts = [ SELECT Id, APM_PSUID__c FROM Account WHERE APM_PSUID__c != null AND APM_PSUID__c IN :AccountIds ];
        
        // Map Accounts
        Map<String,String> AcctIDs = new Map<String,String>{};
        
        for (Account a : accts) { AcctIDs.put(a.APM_PSUID__c, a.Id); }
        
        // Trigger for Relating Account to Case
        for (Case c : cases) { //jenna-used enhanced for loop
            
            if( (c.Related_PSUnique__c != null) && (c.AccountID == null) ) {
                
                System.debug(logginglevel.FINEST,'adding cases to relating acct list: ' + c);   
                casesToAdd.add(c);  
            }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Relating Cases to Accounts: ' + cases);
            
            for (Case c : casesToAdd) {
                
                if (c.Related_PSUnique__c != null && c.AccountID == null){
                    c.AccountId = AcctIDs.get(c.Related_PSUnique__c);
                }
            }
        }
    } // End
    
    // *** AFTER INSERT *** Trigger to automatically share CVS CSR webform cases with CVS
    public void CSTIssuesSharedwithCVS (List<Case> cases) {
        
        System.debug(logginglevel.FINEST,'Inside Case After Insert Trigger');
        
        List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>([ SELECT Id, ConnectionStatus, ConnectionName FROM PartnerNetworkConnection WHERE ConnectionStatus = 'Accepted' LIMIT 1 ]);
        List<PartnerNetworkRecordConnection> connectionInsertList = new List<PartnerNetworkRecordConnection>();
        List<Case> casesToAdd = new List<Case>(); //jenna-added new list, contains only cases w origin of 'CVS CST Webform'
        
        for (Case c : cases) {
                
                if ((c.Origin == 'CVS CST Webform')||((c.Origin == 'RM Task')&&(c.Aetna_Case_Type__c == 'Account Manager Case'))) {
                    
                    System.debug(logginglevel.FINEST,'adding cases to share list:' + c);
                    casesToAdd.add(c);
                }
            }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {

            for (Case c : casesToAdd) {
                
                System.debug(logginglevel.FINEST,'Sharing Cases: ' + c);
                
                for (PartnerNetworkConnection network : connmap) {
                    
                    PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
                    
                    newrecord.ConnectionId = network.Id;
                    newrecord.LocalRecordId = c.Id;
                    newrecord.SendClosedTasks = true;
                    newrecord.SendOpenTasks = true;
                    newrecord.SendEmails = true;
                    newrecord.RelatedRecords = 'Case, Attachment';
                    connectionInsertList.add(newrecord);
                }
            }
            insert connectionInsertList;
        }
    } // End
    
    // *** AFTER INSERT *** Creating Remediation Records for Issue Cases, 1 parameter
    public void CreateRemediationRecord (List<Case> cases) {
        
        List<Case> RemCases = new List<Case>(); //jenna-added
        List<Remediation__c> RemInsertList=new List<Remediation__c>();

        for (Case c : cases) {
                
            if ((c.Remediation_Needed__c == 'Automated R&R'||c.Remediation_Needed__c == 'Manual Remediation') && c.Remediation_Case__c == null) {
                    
                System.debug(logginglevel.FINEST,'adding cases for remediation: ' + c);
                RemCases.add(c);
             }
        }
        
        if (RemCases != null && RemCases.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding Remediation Records: ' + RemCases);
            
            for (Case c : RemCases) {
                
                Remediation__c rc = new Remediation__c();
                rc.Account_Name__c = c.AccountId;
                rc.OwnerId = c.OwnerId;
                rc.Subject__c = c.Subject;
                rc.PSUnique_ID__c = c.PSUnique_ID__c;
                rc.Carrier__c = c.CVS_Carrier_ID__c;
                rc.Medically_Integrated__c = c.Integrated_Non_Integrated__c;
                rc.Market_Segment__c = c.Account_Segment__c;
                rc.Region__c = c.Account_Region__c;
                rc.Sub_Segment__c = c.Account_Subsegment__c;
                rc.Issue_Case__c = c.Id;
                rc.Issue_Description_and_Resolution__c = c.Error_Description__c;
                rc.Shared_Comments__c = c.Aetna_CVS_Shared_Comments__c;
                rc.Status__c = 'Preliminary Impact Report';
                rc.Sub_Status__c = 'Requested';
                RemInsertList.add(rc);
            }

            insert  RemInsertList;
  
        }
    } // End
    
    // *** AFTER UPDATE *** Creating Remediation Records for Issue Cases, 2 parameters
    public void CreateRemediationRecord(Map<Id,Case> oldCasesMap, List<Case> newCases) {
        
        List<Case> RemCases = new List<Case>(); //jenna-added
        List<Remediation__c> RemInsertList = new List<Remediation__c>();

        for (Case c : newCases) {
                
            if ((c.Remediation_Needed__c == 'Automated R&R'||c.Remediation_Needed__c == 'Manual Remediation') && c.Remediation_Case__c == null ) {
                    
                System.debug(logginglevel.FINEST,'adding cases for remediation: ' + c);
                RemCases.add(c);
             }
        }
        
        if (RemCases != null && RemCases.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding Remediation Records: ' + RemCases);
            
            for (Case c : RemCases) {
                
                    Remediation__c rc = new Remediation__c();
                    rc.Account_Name__c = c.AccountId;
                    rc.OwnerId = c.OwnerId;
                    rc.Subject__c = c.Subject;
                    rc.PSUnique_ID__c = c.PSUnique_ID__c;
                    rc.Carrier__c = c.CVS_Carrier_ID__c;
                    rc.Medically_Integrated__c = c.Integrated_Non_Integrated__c;
                    rc.Market_Segment__c = c.Account_Segment__c;
                    rc.Region__c = c.Account_Region__c;
                    rc.Sub_Segment__c = c.Account_Subsegment__c;
                    rc.Issue_Case__c = c.Id;
                    rc.Issue_Description_and_Resolution__c = c.Error_Description__c;
                    rc.Shared_Comments__c = c.Aetna_CVS_Shared_Comments__c;
                    rc.Status__c = 'Preliminary Impact Report';
                    rc.Sub_Status__c = 'Requested';
                    RemInsertList.add(rc);
            }
            insert  RemInsertList;

        }
    } // End
  
    /**
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- Implmentation of After Insert Trigger on Case object
    **/
    // *** AFTER INSERT *** Part of CaseStatusHistory, diff parameters, renamed from CaseTriggers.onAfterInsert
    public void CreateCaseStatusHistory(Map<Id,Case> oldCasesMap, List<Case> newCases) {
    
        List<CaseStatusHistory__c> historyList = new List<CaseStatusHistory__c>();
        
        for (Case cs : newCases) {
            
            historyList.add(createCSHistoryRecord(cs.Id, STATUS_TEXT, cs.Status) );
            
            if (cs.CVS_Status__c != null) {
                historyList.add(createCSHistoryRecord(cs.Id, CVS_STATUS_TEXT, cs.CVS_Status__c) );
            }
            
            if (cs.CRD_GMF_Case_Status__c != null) {
                historyList.add(createCSHistoryRecord(cs.Id, EXTERNAL_STATUS_TEXT, cs.CRD_GMF_Case_Status__c) );
            }
        }
        
        System.debug(historyList);
        insert historyList;
    } // End
    
    // *** AFTER UPDATE *** Part of CaseStatusHistory, diff parameters
    public void CreateCaseStatusHistory(Map<Id,Case> oldCaseMap, Map<Id,Case> newCaseMap) {
        
        // from CaseTriggerHandler.OnAfterUpdate()
        //jenna-added, also made CaseTriggerHandler.createCaseHistory method public
        //CaseTriggerHandler handler = new CaseTriggerHandler();
        
        Map<Id,Set<String>> mapCaseIDsWithStatus = new Map<Id,Set<String>>();
        List<CaseStatusHistory__c> historyList = new List<CaseStatusHistory__c>(); 
        
        for (Case cs : newCaseMap.values()) {
            
            if(cs.Status != oldCaseMap.get(cs.Id).Status){
                
                historyList.add(createCSHistoryRecord(cs.Id,STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).Status)));
                this.addToStatusMap(mapCaseIDsWithStatus, STATUS_TEXT, cs.id);
            }
            if(cs.CVS_Status__c != oldCaseMap.get(cs.Id).CVS_Status__c){  
                 
                historyList.add(createCSHistoryRecord(cs.Id,CVS_STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).CVS_Status__c)));
                this.addToStatusMap(mapCaseIDsWithStatus, CVS_STATUS_TEXT, cs.id);
            }
            if(cs.CRD_GMF_Case_Status__c != oldCaseMap.get(cs.Id).CRD_GMF_Case_Status__c){   
                
                historyList.add(createCSHistoryRecord(cs.Id,EXTERNAL_STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).CRD_GMF_Case_Status__c)));
                this.addToStatusMap(mapCaseIDsWithStatus, EXTERNAL_STATUS_TEXT, cs.id);
            }
        }
        
        if (! mapCaseIDsWithStatus.isEmpty()) {
            
            //Get the default business hours (we might need it)
            //BusinessHours defaultHours = [ select Id from BusinessHours where IsDefault=true limit 1 ];
            // 6/25/15 - JV - Added per Rajit & Amit to remove extraneous query
            String defaultHours = System.Label.DCSRT52;
            for(CaseStatusHistory__c csh : [Select 
                                                id,to__c,from__c,Elapsed_Business_Hours__c,Field__c,Case__c 
                                            from 
                                                CaseStatusHistory__c 
                                            where 
                                                Case__c IN :mapCaseIDsWithStatus.keyset() and To__c = null]){
                if( mapCaseIDsWithStatus.get(csh.Case__c).contains(csh.Field__c)) {
                    csh.to__c = system.now();
                     //The diff method comes back in milliseconds, so we divide by 1000 to get seconds.
                    //csh.Elapsed_Business_Hours__c = BusinessHours.diff(defaultHours.id, csh.from__c, csh.to__c)/1000.0;
                    csh.Elapsed_Business_Hours__c = BusinessHours.diff(defaultHours, csh.from__c, csh.to__c)/1000.0; // 6/25/15 - JV - defaultHours is now String per Rajit & Amit
                    historyList.add(csh);
                }
            }
            upsert historyList;
        }
    }
    
    /** 
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- create Case Status History record 
    **/
    // *** PRIVATE METHOD *** Part of CaseStatusHistory
    private CaseStatusHistory__c createCSHistoryRecord(Id caseId, string field, string value) { 
        
        CaseStatusHistory__c history = new  CaseStatusHistory__c();            
        history.Case__c = caseId;
        history.Field__c = field;
        history.Value__c = Value;                       
        history.From__c = system.now();
        //history.ChangedBy__c = Userinfo.getUserId(); //jenna-this field no longer exists?
        
        return history;
    } // End
    
    /** PRIVATE METHOD *** Part of CaseStatusHistory
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- add Case Id and Status type for Map
    **/
    // *** PRIVATE METHOD *** Part of CaseStatusHistory
    private void addToStatusMap(Map<Id,Set<String>> mapCaseIDsWithStatus, String statusType, String caseId) {
            
        if(mapCaseIDsWithStatus.containsKey(caseId)){
            mapCaseIDsWithStatus.get(caseId).add(statusType);
        }else{
            mapCaseIDsWithStatus.put(caseId, new Set<String>{statusType});
        }
    } // End
    
    // *** BEFORE UPDATE *** Trigger for Internal & Internal Migration CRD/GMF Cases
    public void InternalMigrationCRDCaseOwners (Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
        
        System.debug(logginglevel.ERROR,'Inside Case Before Update Trigger');
        
        List<Case> internalCasesToAdd = new List<Case>(); //jenna-added
        
        for (Case c : newCases) {
            
            if (c.Status != oldCasesMap.get(c.Id).Status && c.Status != 'Closed') {
                
                system.debug(logginglevel.FINEST,'adding internal cases: ' + c);
                internalCasesToAdd.add(c);
            }
        }
        
        if (internalCasesToAdd != null && internalCasesToAdd.size() > 0) {
            
            system.debug(logginglevel.FINEST,'Sending Internal Cases: ' + internalCasesToAdd);
            
            for (Case c : internalCasesToAdd) {
                
                if (c.RecordTypeId == recordTypes.get('Internal Migration CRD/GMF Process') && c.Status == 'Audit Complete, Case Pending') {
                    c.OwnerId = c.Assigned_Team_Member__c;
                }
                else if ( (c.RecordTypeId == recordTypes.get('Internal CRD/GMF Process') || c.RecordTypeId == recordTypes.get('Internal GMF Case') || 
                    c.RecordTypeId == recordTypes.get('Event Notifications')) && c.Status == 'Errors Found - Returning' ) {
                        
                    c.OwnerId = c.Assigned_Team_Member__c;
                }
                else if ( c.RecordTypeId == recordTypes.get('Internal CRD/GMF Process') && c.Auditor__c == null && c.Status == 'Ready for Audit' && 
                    c.Fallout_Reason__c != 'CB_Success' ) {
                    
                    c.OwnerId = allQueuesMap.get('CaseBCTSupervisorCasesforApproval');
                }
                else if ( c.RecordTypeId == recordTypes.get('Internal CRD/GMF Process') && c.Auditor__c != null && c.Status == 'Ready for Audit') {
                    c.OwnerId = c.Auditor__c;
                }
                else if ( c.RecordTypeId == recordTypes.get('Internal CRD/GMF Process') && c.Auditor__c != null && c.Status == '2nd Level Audit - Errors Found') {
                    c.OwnerId = c.Auditor__c;
                }
                else if ( c.RecordTypeId == recordTypes.get('Event Notifications') && c.Status == 'Pending Audit by BCT Notif Team') {
                    c.OwnerId = c.Auditor__c;
                }
                else if ( c.RecordTypeId == recordTypes.get('Internal GMF Case') && c.Auditor__c == null && c.Status == 'Ready for Audit') {
                    c.OwnerId = allQueuesMap.get('Commercial_GMFs_Unassigned');
                }
                else if ( c.RecordTypeId == recordTypes.get('Internal GMF Case') && c.Auditor__c != null && c.Status == 'Ready for Audit') {
                    c.OwnerId = c.Auditor__c;
                }
            }
        }
    } // End
    
    
    // *** BEFORE UPDATE *** Trigger for External CRD/GMF Cases to change case owner
    public void ExternalCRDCasesToAMs(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
    
        List<Case> externalCases = new List<Case>(); //jenna-added

        for (Case c : newCases) {
            
            if (c.CRD_GMF_Case_Status__c == 'Submitted' && oldCasesMap.get(c.Id).CRD_GMF_Case_Status__c != 'Submitted') {
                
                system.debug(logginglevel.FINEST,'adding external cases: ' + c);
                
                externalCases.add(c);
            }
        }
        
        if (externalCases != null && externalCases.size() > 0) {
            
            system.debug(logginglevel.FINEST,'Sending external Cases: ' + externalCases);
            
            for (Case c : externalCases) {
                
                if (c.RecordTypeId == recordTypes.get('External CRD/GMF') && c.Aetna_Case_Type__c=='CRD Case' && c.CRD_GMF_Case_Status__c == 'Submitted' &&
                    ( c.CRD_GMF_Case_Types__c == 'New CRD for creating a new plan' || c.CRD_GMF_Case_Types__c == 'New CRD for implementing a new business' || 
                    c.CRD_GMF_Case_Types__c == 'Interim CRD' || c.CRD_GMF_Case_Types__c == 'Maintenance CRD' ) ) {
                        c.OwnerID = allQueuesMap.get('EZ_Test_Reviews_Queue');
                }
            }
        }
    } // End
        
    // *** BEFORE UPDATE *** Triggers for CVS CST Cases needing assignment to the Aetna AM
    public void CVSCSTIssuesVerified(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {

        Map<String,String> AcctTeams = new Map<String,String>{};
        List<String> AccountIds = new List<String>(); 
        List<Case> casesToAdd = new List<Case>(); //jenna-added
    
        AcctTeams = getATMs(newCases);
        
        for (Case c : newCases) {
            
            if (c.Issue_Verified_Send_to_Aetna_AM__c != oldCasesMap.get(c.Id).Issue_Verified_Send_to_Aetna_AM__c) {
                System.debug(logginglevel.FINEST,'adding transfer cases: ' + c);
                casesToAdd.add(c);
            }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            System.debug(logginglevel.error,'Transferring Cases to AM: ' + casesToAdd);
            
            for (Case c : casesToAdd) {
                
                if (c.Origin == 'CVS CST Webform' && c.Issue_Verified_Send_to_Aetna_AM__c == true) {
                    c.OwnerId = allQueuesMap.get('Triage_Team');// updated to Triage Team Queue BA 10-26-16
                    c.Service_Request_Type__c = 'Inquiry';
                    c.Aetna_Case_Type__c = 'Service Request';
                }
            }
        }
    } // End
    
    // *** BEFORE UPDATE *** Trigger for transferring RM Task Issues to Aetna AMs
    public void RMTaskIssuesToAMs(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
    
        Map<String,String> AcctTeams = new Map<String,String>{};
        List<String> AccountIds = new List<String>();  // jenna-consider combining w other query above. Shouldn't this be Set<Id>?
        List<Case> casesToAdd = new List<Case>(); //jenna-added
        
        AcctTeams = getATMs(newCases);
        
        for (Case c : newCases) {
            
            if (c.RM_Indicator__c == 'RM Aetna' && oldCasesMap.get(c.Id).RM_Indicator__c != 'RM Aetna') {
                
                System.debug(logginglevel.ERROR,'adding RM Task Issues: ' + c);
                casesToAdd.add(c);
            }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            
            System.debug(logginglevel.ERROR,'Sending RM Task Issues: ' + casesToAdd);
            
            for (Case c : casesToAdd) {
                    
                    if (c.Origin == 'RM Task' && c.RM_Indicator__c == 'RM Aetna') {
                        c.OwnerId = allQueuesMap.get('Triage_Team'); 
                        c.Service_Request_Type__c = 'Issue';
                    }
            }
        }
    } // End
    
    // *** BEFORE UPDATE *** Trigger for assigning webform cases to the AM
    /*public void WebformAssignmentsToAMs(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
        
        Map<String,String> AcctTeams = new Map<String,String>{};
        List<String> AccountIds = new List<String>();  // jenna-consider combining w other query above. Shouldn't this be Set<Id>?
        List<Case> casesToAdd = new List<Case>(); //jenna-added
        
        AcctTeams = getATMs(newCases);

        for (Case c : newCases) {
            
            if (c.Workflow_Assignment__c == 'Not Assigned' && oldCasesMap.get(c.Id).Workflow_Assignment__c != 'Not Assigned') {
                
                System.debug(logginglevel.ERROR,'adding RM Task Issues: ' + c);
                casesToAdd.add(c);
            }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            
            System.debug(logginglevel.ERROR,'Assigning AM Webform cases: ' + casesToAdd);
            
            for (Case c : casesToAdd) {
                
                if (AcctTeams.containsKey(c.AccountId) && c.Origin == 'Web Form' && c.OwnerId == allQueuesMap.get('RxPro_Queue')) {
                    c.OwnerId = AcctTeams.get(c.AccountId);
                    c.Workflow_Assignment__c = 'Assigned';
                }
            }
        }
        
        if (casesToAdd.size() > 1) {
            System.debug(logginglevel.FINEST,'cases owner: ' + casesToAdd[0].OwnerId);
            System.debug(logginglevel.FINEST,'cases owner ref: ' + [ select OwnerId from Case where Id = :casesToAdd[0].Id ][0].OwnerId);
        }
    } */
    // End
    
    // *** AFTER UPDATE *** Creating child cases for referred out issue cases  
    public void CreateIssueChildCases(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
        
        System.debug(logginglevel.FINEST,'Inside Case After Update Trigger');
        
        List<Case> casesToAdd = new List<Case>(); //jenna-added
        
        List<Case> CaseInsertList = new List<Case>();
        Map<Id,List<caseComment>> caseCommentMap = new Map<Id,List<caseComment>>();
        List<caseComment> caseCommentTempList = new List<CaseComment>();
        List<caseComment> caseCommentInsertList = new List<CaseComment>();
        Boolean errorFlag = false;

        for (Case c : newCases) {
            if (c.Status == 'Referred Out' && ((c.Business_Owner__c == 'MOD' || c.Business_Owner__c == 'ASRx' || c.Business_Owner__c == 'Acct Associate Team' || c.Business_Owner__c == 'CCST') 
                && oldCasesMap.get(c.Id).Status != 'Referred Out')) {
                
                System.debug(logginglevel.FINEST,'adding Referred Out cases: ' + c);
                casesToAdd.add(c);
            }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding Child Cases: ' + casesToAdd);
            
            //List<CaseComment> caseCommentList = [ SELECT Id,CommentBody,ParentId FROM CaseComment where ParentId IN :casesToAdd ];
            
            for (caseComment cc : [ SELECT Id,CommentBody,ParentId FROM CaseComment where ParentId IN :casesToAdd ]) {
                
                if (caseCommentMap.get(cc.ParentId) != null) {
                    
                    List<CaseComment> temp = caseCommentMap.get(cc.ParentId);
                    temp.add(cc);
                    caseCommentMap.put(cc.parentId,temp);
                } 
                else {
                    caseCommentMap.put(cc.ParentId,new List<CaseComment>{cc});
                }
            }
            
            for (Case c : casesToAdd) {
                
                if (c.Status == 'Referred Out' && c.Business_Owner__c == 'MOD'){
                    
                    String ERR_MSG = 'MOD Operations Cases queue is missing. Cannot auto assign case owners to this queue.';
                    Case mc = new Case ();
                    
                    mc.RecordTypeId = recordTypes.get('Mail Order Case');
                    mc.ParentId = c.Id;
                    mc.High_Tier_Escalation__c = c.High_Tier_Escalation__c;
                    mc.Origin = 'Internal SFDC Transfer';
                    mc.AccountId = c.AccountId;
                    mc.Member_ID__c = c.Member_ID__c;
                    mc.Subject = c.Subject;
                    mc.Description = c.Description;
                    mc.Aetna_Case_Type__c = 'Mail Order Case';
                    mc.Case_Type_Category__c = 'Mail Order - Shared';
                    mc.Status = 'New';
                    mc.Issue_Submitter_Dept__c = c.Issue_Submitter_Dept__c; //Jenna-is this needed? Field not on MOD Case Layout
                    mc.Urgent_Flag__c = c.Urgent_Flag__c;
                
                    //jenna-added
                    try {
                        if (allQueuesMap.get('MOD_Operations_Cases') == null) {
                            ErrorLogger.create(ERR_MSG);
                            errorFlag = true;
                        }
                    } Catch (System.QueryException noRecordError) {
                    
                        ErrorLogger.create(ERR_MSG);
                        errorFlag = true;
                    }
                    
                    if (!errorFlag) {
                        mc.OwnerId = allQueuesMap.get('MOD_Operations_Cases');
                    } else{
                        system.debug('Becca:assigning default user. system errror');
                        mc.OwnerId = Userinfo.getUserId();
                    }
                    
                    CaseInsertList.add(mc);
                
            }else if (c.Status == 'Referred Out' && c.Business_Owner__c == 'ASRx') {
                
                String ERR_MSG = 'Specialty Operations Cases queue is missing. Cannot auto assign case owners to this queue.';
                Case sc = new Case ();
                
                sc.RecordTypeId = recordTypes.get('Specialty Case');
                sc.ParentId = c.Id;
                sc.High_Tier_Escalation__c = c.High_Tier_Escalation__c;
                sc.Origin = 'Internal SFDC Transfer';
                sc.AccountId = c.AccountId;
                sc.Member_ID__c = c.Member_ID__c;
                sc.Subject = c.Subject;
                sc.Description = c.Description;
                sc.Aetna_Case_Type__c = 'Specialty Case';
                sc.Case_Type_Category__c = 'Specialty - Shared';
                sc.Status = 'New';
                sc.Urgent_Flag__c = c.Urgent_Flag__c;
                
                //jenna-added
                try {
                    if (allQueuesMap.get('Specialty_Operations_Cases') == null) {
                        
                        ErrorLogger.create(ERR_MSG);
                        errorFlag = true;
                    }
                } Catch (System.QueryException noRecordError) {
                    
                    ErrorLogger.create(ERR_MSG);
                    errorFlag = true;
                }
                if (!errorFlag) {
                    sc.OwnerId = allQueuesMap.get('Specialty_Operations_Cases');
                } else{
                    sc.OwnerId = Userinfo.getUserId();
                }

                CaseInsertList.add(sc);
                
            }else if (c.Status == 'Referred Out' && c.Business_Owner__c == 'CCST') {
                
                String ERR_MSG = 'CCST queue is missing. Cannot auto assign case owners to this queue.';
                Case cc = new Case ();
                
                cc.RecordTypeId = recordTypes.get('Plan Sponsor Questions or Issues');
                cc.ParentId = c.Id;
                cc.High_Tier_Escalation__c = c.High_Tier_Escalation__c;
                cc.Origin = 'Internal SFDC Transfer';
                cc.AccountId = c.AccountId;
                cc.Member_ID__c = c.Member_ID__c;
                cc.Member_Name__c = c.Member_Name__c;
                cc.Member_Date_of_Birth__c = c.Member_Date_of_Birth__c;
                cc.Triage_Category__c = c.Triage_Category__c;
                cc.Control_Group_Number__c = c.Control_Group_Number__c;
                cc.Product__c = c.Product__c;
                cc.Issue_Submitter_Dept__c = c.Issue_Submitter_Dept__c;
                cc.Service_Request_Type__c = c.Service_Request_Type__c;
                cc.Service_Request_Level__c = c.Service_Request_Level__c;
                cc.Exclude_from_Virtual_Hug_Emails__c = true; //jenna-don't think this field is used anymore, not on any case layouts
                cc.Do_Not_Send_Survey__c = true; //jenna-not sure if this field is used anymore, only viewable for like 2-3 profiles
                cc.Subject = c.Subject;
                cc.Description = c.Description;
                cc.Aetna_Case_Type__c = 'CCST Case';
                cc.Status = 'New';
                cc.Urgent_Flag__c = c.Urgent_Flag__c;
                
                //jenna-added
                try {
                    if (allQueuesMap.get('CCST_Queue') == null) {
                        
                        ErrorLogger.create(ERR_MSG);
                        errorFlag = true;
                    }
                } Catch (System.QueryException noRecordError) {
                    
                    ErrorLogger.create(ERR_MSG);
                    errorFlag = true;
                }
                if (!errorFlag) {
                    cc.OwnerId = allQueuesMap.get('CCST_Queue');
                } else{
                    cc.OwnerId = Userinfo.getUserId();
                }

                CaseInsertList.add(cc);
                
            }else if (c.Status == 'Referred Out' && c.Business_Owner__c == 'Acct Associate Team') {
                
                String ERR_MSG = 'Account Associates Team Queue is missing. Cannot auto assign case owners to this queue.';
                Case ac = new Case ();
                
                ac.RecordTypeId = recordTypes.get('Plan Sponsor Questions or Issues');
                ac.ParentId = c.Id;
                ac.High_Tier_Escalation__c = c.High_Tier_Escalation__c;
                ac.Origin = 'Internal SFDC Transfer';
                ac.AccountId = c.AccountId;
                ac.Member_ID__c = c.Member_ID__c;
                ac.Member_Name__c = c.Member_Name__c;
                ac.Member_Date_of_Birth__c = c.Member_Date_of_Birth__c;
                ac.Triage_Category__c = c.Triage_Category__c;
                ac.Control_Group_Number__c = c.Control_Group_Number__c;
                ac.Product__c = c.Product__c;
                ac.Issue_Submitter_Dept__c = c.Issue_Submitter_Dept__c;
                ac.Service_Request_Type__c = c.Service_Request_Type__c;
                ac.Service_Request_Level__c = c.Service_Request_Level__c;
                ac.Exclude_from_Virtual_Hug_Emails__c = true; //jenna-don't think this field is used anymore, not on any case layouts
                ac.Do_Not_Send_Survey__c = true; //jenna-not sure if this field is used anymore, only viewable for like 2-3 profiles
                ac.Subject = c.Subject;
                ac.Description = c.Description;
                ac.Aetna_Case_Type__c = 'Account Associate Case';
                ac.Status = 'New';
                ac.Urgent_Flag__c = c.Urgent_Flag__c;
                
                //jenna-added
                try {
                    if (allQueuesMap.get('Account_Associates_Issues_Queue') == null) {
                        
                        ErrorLogger.create(ERR_MSG);
                        errorFlag = true;
                    }
                } Catch (System.QueryException noRecordError) {
                    
                    ErrorLogger.create(ERR_MSG);
                    errorFlag = true;
                }
                if (!errorFlag) {
                    ac.OwnerId = allQueuesMap.get('Account_Associates_Issues_Queue');
                } else{
                    ac.OwnerId = Userinfo.getUserId();
                }
                
                CaseInsertList.add(ac);
            }
        }
        insert  CaseInsertList;
        CaseComment tempCaseComment;
            
        if (CaseCommentMap != NULL && (!caseCommentMap.isEmpty())){
            
            for (case c : caseInsertList){
            
                for (CaseComment ccRec : caseCommentMap.get(c.parentId)) {
                    
                  tempCaseComment = ccRec.clone(false,true,false,false);
                  tempCaseComment.ParentId = c.id;
                  CaseCommentInsertList.add(tempCaseComment);
                }
        
            }
        insert caseCommentInsertList; 
        }
      }
    } // End
    
    // *** AFTER UPDATE *** Creating task for closed child cases
    public void TaskonClosedChildCases(Map<Id,Case> oldCasesMap, List<Case> newCases, Map<Id,Case> newCasesMap) {
        
        List<Case> casesToAdd = new List<Case>(); //jenna-added
        //List<Id> caseParentList = new List<Id>(); //jenna-this seems empty?
        List<Task> taskInsertList = new List<Task>();
        Map<ID,ID> mapChild2ParentCase = new Map<ID,ID>();
        
        for (Case c : newCases) {
            
            if (c.Status == 'Closed' && c.ParentId != null && (c.Origin == 'Internal SFDC Transfer' && (c.Aetna_Case_Type__c == 'Mail Order Case' || c.Aetna_Case_Type__c == 'Specialty Case' 
                || c.Aetna_Case_Type__c == 'Account Associate Case') && oldCasesMap.get(c.Id).Status != 'Closed')) {
                    
                    System.debug(logginglevel.FINEST,'adding closed cases: ' + c);
                    casesToAdd.add(c);
                }
        }
        
        if (casesToAdd != null && casesToAdd.size() > 0) {
            System.debug(logginglevel.FINEST,'Adding tasks: ' + casesToAdd);
            
            // jenna-streamlined query
            for (Case c : [ SELECT Id, Origin, OwnerId, ParentID, Status FROM Case WHERE Id IN :casesToAdd ]) {
                //caseParentList.add(c.ParentId);
                mapChild2ParentCase.put(c.id,c.ParentId);
            }
            
            //Map<Id,Case> CaseMap = new Map<Id,Case>([ SELECT Id, OwnerID FROM Case WHERE Id IN :caseParentList ]); 
            Map<Id,Case> CaseMap = new Map<Id,Case>([ SELECT Id, OwnerID FROM Case WHERE Id IN :mapChild2ParentCase.values() ]);
            
            //for (Case c : [ SELECT Id, Origin, OwnerId, ParentID, Status FROM Case WHERE Id IN :casesToAdd ]) {
            for (ID childCaseID: mapChild2ParentCase.keyset()) {    
                Task tc = new Task ();
                tc.WhatId = mapChild2ParentCase.get(childCaseID);
                tc.OwnerId = caseMap.get(mapChild2ParentCase.get(childCaseID)).OwnerId;
                tc.Status = 'Not Started';
                tc.ActivityDate = System.Today()+1;
                tc.Subject = 'Referral case has been closed';
                tc.Description = 'Your referral case has been closed.  Please review the information provided and close your case as appropriate.';
                tc.Priority = 'High';
            
                taskInsertList.add(tc);
            }
            insert taskInsertList;
        }
      } // End
      
      // *** AFTER UPDATE *** Creating SME Help Desk Records for Service Requests
    /*public void CreateSMEHelpDeskRecord(Map<Id,Case> oldCasesMap, List<Case> newCases) {
        
        List<Case> SMECases = new List<Case>();
        List<SME_Help_Desk_Request__c> SMEInsertList = new List<SME_Help_Desk_Request__c>();

        for (Case c : newCases) {
                
            if (c.Service_Request_Level__c == 'Level 2' && oldCasesMap.get(c.Id).Service_Request_Level__c != 'Level 2') {
                    
                System.debug(logginglevel.FINEST,'adding cases for SME Help Desk: ' + c);
                SMECases.add(c);
             }
        }
        
        if (SMECases != null && SMECases.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding SME Help Desk Records: ' + SMECases);
            
            for (Case c : SMECases) {
                
                if (c.Service_Request_Level__c == 'Level 2') {
                    SME_Help_Desk_Request__c sr = new SME_Help_Desk_Request__c();
                    sr.Plan_Sponsor_Name__c = c.AccountId;
                    sr.OwnerId = allQueuesMap.get('SME_Help_Desk');
                    sr.Associated_Case__c = c.Id;
                    sr.Requestor_s_Name__c = c.SuppliedName;
                    sr.Product__c = c.Product__c;

                }
            }
            insert  SMEInsertList;
        }
    }*/ 
    // End
      
    //=============================
    // Meta Information
    //=============================  
    // Namespace or Enhancement:SFDC8533b/ Case Automation March 15/Phase 4 
    // Description:New rxplanid cases-used to set Account on case for HIX and SGX small groups. HIXControlPlanCount and SGXControlPlanCount are rollup summary fields on case records that count number
    // of case controlplan records with either HIX or SGX subsegment. Change the account the first time you see a HIX or SGX under the case.
    // Called by: NA
  
    /*========================================================
    Version      Author          Date            Reason
    1.0          Saraag          March11,2013    Created
    1.01         Amit            Dec 12,2013     Merged two queries into a single query.
    ==========================================================*/
      
      // *** BEFORE UPDATE *** Trigger to set the case account to 'IVL Public Exchange' or 'SG Public Exchange'
      public void CA_SetAccount(List<Case> newCases, Map<Id,Case> oldCaseMap) {
        
        Boolean errorflag=false;
        ID IVLpublicExchangeAccId;
        ID SGpublicExchangeAccId;
        String ERR_MSG = 'Account for IVL and or SG public exchange is missing. Cannot auto assign cases';
        
        //get accountids
        try{
            for(Account accRecord : [select id,Name from Account where name IN ('IVL Public Exchange','SG Public Exchange') LIMIT 2]){
                if(accRecord.Name == 'IVL Public Exchange'){
                    IVLpublicExchangeAccId = accRecord.id;
                }
                if(accRecord.Name == 'SG Public Exchange'){
                    SGpublicExchangeAccId = accRecord.id;
                }
            }        
            if(IVLpublicExchangeAccId == null && SGpublicExchangeAccId == Null){
                ErrorLogger.create(ERR_MSG);
                errorflag=true;
            } 
        
        }Catch(System.ListException noRecordError) {
            ErrorLogger.create('Account for IVL and or SG public exchange is missing. Cannot auto assign cases');
                /* Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new string[]{'solipurams@aetna.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Trigger on case:CA_setAccount- No account found');
                mail.setPlainTextBody('Autogenerated Message: Trigger on case:CA_setAccount failed to find SG and or IVL account and auto assing to cases. ');      
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                */
            errorflag=true;      
        }
            
        if(!errorflag){ //could determine account
            for(case c : newCases){  
        
                if(c.CaseAutomationReason__c=='AIPkgNewRxplanid') { //only for new rxplanid cases
                    system.debug(logginglevel.finest,'Inside new rxplanid case');
                    if( !(c.SGXControlPlanCount__c>0) && c.HIXControlPlanCount__c>0 && (oldCaseMap.get(c.Id).HIXControlPlanCount__c==0) && (c.AccountId!=IVLpublicExchangeAccId)) { //check if HIX>0 is this the first time this happend, and accountid is not already set correctly.
                        c.AccountId=IVLpublicExchangeAccId;
                    }else if( !(c.HIXControlPlanCount__c>0) && c.SGXControlPlanCount__c>0 && (oldCaseMap.get(c.Id).SGXControlPlanCount__c==0) && (c.AccountId!=SGpublicExchangeAccId)) { //check if SGX>0 and check if this is the first time it happend and if aacount is not already set.
                        c.AccountId=SGpublicExchangeAccId;
                    }
                }
            } //end trigger.new loop
        } //end no error if         
      } // End
      /** Method - assignCaseToAdminQueue() for 6804 by Nitish
      * Description - To assign cases corresponding to stated fallout reason to Admin Queue
    **/
    public void assignCaseToAdminQueue(List<case> caseList){
        group adminQueue = [select id,name from group where Name='CB_AdminQ' and Type = 'Queue' limit 1];
        for(case c:caseList){
            if(c.Fallout_Reason__c =='CB_ExecuteBuild' || c.Fallout_Reason__c =='CB_AIlogs' || c.Fallout_Reason__c =='CB_sendtoAI'){
                c.ownerId = adminQueue.id;
            }
        }
    }
    public boolean IsTriggerContext {
        get { return isExecuting; }
    }
    
    public boolean IsVisualforcePageContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsWebServiceContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsExecuteAnonymousContext {
        get { return !IsTriggerContext; }
    }
    
}