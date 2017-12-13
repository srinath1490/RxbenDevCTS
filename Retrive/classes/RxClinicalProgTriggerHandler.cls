/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong     03-25-15        CreateNewCaseProgramClosedWon(), create new case when Rx Clinical Program is closed won
   1.1 -    Jenna Vuong     06-03-15        sendClosedWonEmail(), send email when Rx Clinical Program (Opp) is closed won
   1.2 -    George da Silva 08/28/15        Deactivated sendClosedWonEmail(), send email when Rx Clinical Program (Opp) is closed won 
   1.2 -    George da Silva 08/28/15        Added more output text to lines 74 and 130.
   1.3 - 	Becca Allen		09/28/16		converted code to creating a new Account Manager Tracker record instead of a case
======================================================================== */

// 6/11/15 - JV - This is without sharing bc some profiles do not have access to 'Plan Sponsor or Questions' Case record type therefore new case does not get created when program sold
public without sharing class RxClinicalProgTriggerHandler { 

    @TestVisible private boolean isExecuting = false;
    @TestVisible private Integer BatchSize = 0;
    @TestVisible Map<String, Id> mapRTs = new Map<String, Id>();
    @TestVisible List<AccountTeamMember> listATMs = new List<AccountTeamMember>();
    @TestVisible String ERR_MSG = 'Error! There are no Pharmacy Account Manager assigned to this account. As a result, a new case has not been created.';
    
    public RxClinicalProgTriggerHandler(boolean isExecuting, Integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
        
        // get case record type
        List<RecordType> caseRTs = new List<RecordType>([ Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Plan_Sponsor_Questions_or_Issues' 
                                                         and isActive = true and sObjectType = 'Case' ]); 
        if (caseRTs != null && caseRTs.size() >0) {
            for (RecordType r : caseRTs) {
                mapRTs.put(r.Name, r.Id);
            }
        }
    }
    
    public void CreateNewCaseProgramClosedWon(Map<Id, Rx_Clinical_Program_Opp__c> oldProgramMap, List<Rx_Clinical_Program_Opp__c> newPrograms) {
        
        System.debug('Inside After Update RxClinicalProgTriggerHandler: ');
        
        Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        //List<Case> caseInsertList = new List<Case>();  Becca - changed from creating a case 
        List<Account_Manager_Trackers__c> AMTrackers = new List<Account_Manager_Trackers__c>();
        QueueSobject AMQueue=[Select QueueId from QueueSobject WHERE Queue.Name='AM Tracker Supervisor Queue' LIMIT 1];

        // get all Pharmacy Account Managers
    for (Rx_Clinical_Program_Opp__c r : newPrograms) {
      oppIds.add(r.Opportunity__c);
    }

        // get account ids for opportunities
        for (Opportunity o : [ Select Id, Name, AccountId From Opportunity Where Id In :oppIds ]) {
      acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
    }
  
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];
        
        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }

    for (Rx_Clinical_Program_Opp__c r : newPrograms) {
            
            if (oldProgramMap.get(r.Id).Stage__c != 'Closed Won' && r.Stage__c == 'Closed Won') {
                
                Account_Manager_Trackers__c am = new Account_Manager_Trackers__c();
                am.Associated_Opportunity__c = r.Opportunity__c;
                am.Plan_Sponsor_Name__c = mapOpps.get(r.Opportunity__c).AccountId;
                am.Project_Name__c = 'New Rx Clinical Program Sold - '+ r.Name;
                am.Summary_of_Project_Request__c = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated. \n\n' + 'Program Details: \n\n' + 'Opportunity Owner:' + '  ' + r.Rx_Clinical_Program_Opp_Owner__c + ', \n' + 'Program Name:' + '  ' + r.Name + ' , \n' + 'Program Start Date' + '  ' + r.Program_Start_Date__c + ' , \n'+ 'Comments:' + '  ' + r.Comments__c;
                //Case c = new Case();
                //c.RecordTypeId = mapRTs.get('Plan Sponsor Questions or Issues');
                //c.Opportunity__c = r.Opportunity__c;
                //c.Aetna_Case_Type__c = 'Account Manager Case';
                //c.AccountId = mapOpps.get(r.Opportunity__c).AccountId;
                //c.Subject = 'New Rx Clinical Program Sold - '+ r.Name;
                //c.Description = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated. \n\n' + 'Program Details: \n\n' + 'Opportunity Owner:' + '  ' + r.Rx_Clinical_Program_Opp_Owner__c + ', \n' + 'Program Name:' + '  ' + r.Name + ' , \n' + 'Program Start Date' + '  ' + r.Program_Start_Date__c + ' , \n'+ 'Comments:' + '  ' + r.Comments__c;
                if (mapAMs.get('Pharmacy Account Manager') != null) {
                    am.OwnerId = mapAMs.get('Pharmacy Account Manager');
                }
                else {
                    am.OwnerId = AMQueue.QueueId;
                }
        AMTrackers.add(am);
            }
    }
        
        try {
            insert AMTrackers;
        } catch (DmlException e) {
            System.debug('ERROR! The following exception has occurred: ' + e.getMessage());
        }   
    }
    
    public void CreateNewCaseProgramClosedWonInsert(List<Rx_Clinical_Program_Opp__c> newPrograms) {
        
        Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        //List<Case> caseInsertList = new List<Case>();
        List<Account_Manager_Trackers__c> AMTrackers = new List<Account_Manager_Trackers__c>();
        QueueSobject AMQueue=[Select QueueId from QueueSobject WHERE Queue.Name='AM Tracker Supervisor Queue' LIMIT 1];

        // get all Pharmacy Account Managers
    for (Rx_Clinical_Program_Opp__c r : newPrograms) {
      oppIds.add(r.Opportunity__c);
    }

        // get account ids for opportunities
        for (Opportunity o : [ Select Id, Name, AccountId From Opportunity Where Id In :oppIds ]) {
      acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
    }
  
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];
        
        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }

    for (Rx_Clinical_Program_Opp__c r : newPrograms) {
            
            if (r.Stage__c == 'Closed Won') {
                
                Account_Manager_Trackers__c am = new Account_Manager_Trackers__c();
                am.Associated_Opportunity__c = r.Opportunity__c;
                am.Plan_Sponsor_Name__c = mapOpps.get(r.Opportunity__c).AccountId;
                am.Project_Name__c = 'New Rx Clinical Program Sold - '+ r.Name;
                am.Summary_of_Project_Request__c = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated. \n\n' + 'Program Details: \n\n' + 'Opportunity Owner:' + '  ' + r.Rx_Clinical_Program_Opp_Owner__c + ', \n' + 'Program Name:' + '  ' + r.Name + ' , \n' + 'Program Start Date' + '  ' + r.Program_Start_Date__c + ' , \n'+ 'Comments:' + '  ' + r.Comments__c;
                //Case c = new Case();
                //c.RecordTypeId = mapRTs.get('Plan Sponsor Questions or Issues');
                //c.Opportunity__c = r.Opportunity__c;
                //c.Aetna_Case_Type__c = 'Account Manager Case';
                //c.AccountId = mapOpps.get(r.Opportunity__c).AccountId;
                //c.Subject = 'New Rx Clinical Program Sold - '+ r.Name;
                //c.Description = 'Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated. \n\n' + 'Program Details: \n\n' + 'Opportunity Owner:' + '  ' + r.Rx_Clinical_Program_Opp_Owner__c + ', \n' + 'Program Name:' + '  ' + r.Name + ' , \n' + 'Program Start Date' + '  ' + r.Program_Start_Date__c + ' , \n'+ 'Comments:' + '  ' + r.Comments__c;
        if (mapAMs.get('Pharmacy Account Manager') != null) {
                    am.OwnerId = mapAMs.get('Pharmacy Account Manager');
                }
                else {
                    am.OwnerId = AMQueue.QueueId;
                }
        AMTrackers.add(am);
            }
    }
        
        try {
            insert AMTrackers;
        } catch (DmlException e) {
            System.debug('ERROR! The following exception has occurred: ' + e.getMessage());
        }   
    }
    
    // JV - 5/26/15 - after insert, send email to rx account manager when closed won
    /* public void sendClosedWonEmail(List<Rx_Clinical_Program_Opp__c> newPrograms) {
        
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds =  new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<String> programIds = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>(); // list of email addresses to send to
        List<Contact> tempContactList = new List<Contact>();
        Map<User,Contact> tempContactMap = new Map<User,Contact>{};
        
        // add all opp ids
        for (Rx_Clinical_Program_Opp__c p : newPrograms) {
            
            if (p.Stage__c == 'Closed Won' && p.Opportunity__c != null) {
                
                oppIds.add(p.Opportunity__c);
                programIds.add(p.Id);
            }
        }
        
        // add all acct ids
        if (oppIds != null && oppIds.size() > 0) {
            
            for (Opportunity o : [ Select Id, AccountId From Opportunity Where Id In :oppIds] ) {
                acctIds.add(o.AccountId);
            }
        }
        
        // add all rx account managers
        if (acctIds != null && acctIds.size() > 0) {
            
            for (AccountTeamMember a : [ Select Id, AccountId, UserId, TeamMemberRole From AccountTeamMember Where AccountId In :acctIds and TeamMemberRole = 'Pharmacy Account Manager' Limit 1 ]) {                
                userIds.add(a.UserId);
            }
        }

        // get email template id
        EmailTemplate templateId = [ Select Id, isActive, DeveloperName From EmailTemplate Where DeveloperName = 'Sold_Rx_Clinical_Program_Opps' and isActive = true LIMIT 1 ];
        
        // need a Map<Id,Opportunity> give user id, get program details
        Map<User,String> mapUserProgram = new Map<User,String>();
        
        for (User u : [ Select Id, FirstName, LastName, Email, isActive From User Where Id In :userIds and isActive = true ]) {
            
            if (programIds != null) {
                
                for (String i : programIds) {
                    mapUserProgram.put(u,i);
                }
            }
        }

        if (userIds != null) {
            
            for (User u : mapUserProgram.keySet()) {
             
                Contact tempContact = new Contact(email = u.email, firstName = u.firstName, lastName = u.lastName);
                tempContactList.add(tempContact);
                tempContactMap.put(u,tempContact);
            }
            
            try {
                insert tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! insert tempContactList failed, here is the error message: ' + e.getMessage());
            }

            for (User u : mapUserProgram.keySet()) {
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
        mail.setTemplateId(templateId.id);
                for (Contact c : tempContactList) {
                    mail.setTargetObjectId(tempContactMap.get(u).Id);
                }
        mail.setSaveAsActivity(false);
        mail.setWhatId(mapUserProgram.get(u));
                
        allmsg.add(mail);
       }
            
      if (allmsg != null) {
              Messaging.sendEmail(allmsg);
          }
            
            try {
                delete tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! delete tempContactList failed, here is the error: ' + e.getMessage());
            }
            
    }
  }
    
    // JV - 6/9/15 - after update, send email to rx account manager when closed won
    public void sendClosedWonEmail(Map<Id, Rx_Clinical_Program_Opp__c> oldProgramMap, List<Rx_Clinical_Program_Opp__c> newPrograms) {
        
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds =  new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<String> programIds = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>(); // list of email addresses to send to
        List<Contact> tempContactList = new List<Contact>();
        Map<User,Contact> tempContactMap = new Map<User,Contact>{};
        
        // add all opp ids
        for (Rx_Clinical_Program_Opp__c p : newPrograms) {
            
            if (oldProgramMap.get(p.Id).Stage__c != 'Closed Won' && p.Stage__c == 'Closed Won' && p.Opportunity__c != null) {
                
                oppIds.add(p.Opportunity__c);
                programIds.add(p.Id);
            }
        }
        
        // add all acct ids
        if (oppIds != null && oppIds.size() > 0) {
            
            for (Opportunity o : [ Select Id, AccountId From Opportunity Where Id In :oppIds] ) {
                acctIds.add(o.AccountId);
            }
        }
        
        // add all rx account managers
        if (acctIds != null && acctIds.size() > 0) {
            
            for (AccountTeamMember a : [ Select Id, AccountId, UserId, TeamMemberRole From AccountTeamMember Where AccountId In :acctIds and TeamMemberRole = 'Pharmacy Account Manager' Limit 1 ]) {                
                userIds.add(a.UserId);
            }
        }

        // get email template id
        EmailTemplate templateId = [ Select Id, isActive, DeveloperName From EmailTemplate Where DeveloperName = 'Sold_Rx_Clinical_Program_Opps' and isActive = true LIMIT 1 ];
        
        // need a Map<Id,Opportunity> give user id, get program details
        Map<User,String> mapUserProgram = new Map<User,String>();
        
        for (User u : [ Select Id, FirstName, LastName, Email, isActive From User Where Id In :userIds and isActive = true ]) {
            
            if (programIds != null) {
                
                for (String i : programIds) {
                    mapUserProgram.put(u,i);
                }
            }
        }

        if (userIds != null) {
            
            for (User u : mapUserProgram.keySet()) {
             
                Contact tempContact = new Contact(email = u.email, firstName = u.firstName, lastName = u.lastName);
                tempContactList.add(tempContact);
                tempContactMap.put(u,tempContact);
            }
            
            try {
                insert tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! insert tempContactList failed, here is the error: ' + e.getMessage());
            }

            for (User u : mapUserProgram.keySet()) {
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
        mail.setTemplateId(templateId.id);
                for (Contact c : tempContactList) {
                    mail.setTargetObjectId(tempContactMap.get(u).Id);
                }
        mail.setSaveAsActivity(false);
        mail.setWhatId(mapUserProgram.get(u));
                
        allmsg.add(mail);
       }
            
      if (allmsg != null) {
              Messaging.sendEmail(allmsg);
          }
            
            try {
                delete tempContactList;
            }
            catch (DmlException e) {
                System.debug('An ERROR occurred! delete tempContactList failed, here is the error: ' + e.getMessage());
            }
            
    } 
  } */
    
}