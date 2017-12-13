/*Purpose: Apex Class for create a new internal CRD record Type case taking the information from the AI Notification Case.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Becca               06/16/2011       Apex Class for create a new internal CRD record Type case taking the information from the AI Notification Case. 
   1.1 -    Sourabh             06/21/2012       Modified the class to fix issues.
   1.2 -    Becca               06/22/2012       Modified with additional fields 
   1.3 -    Becca               10/01/2012       Modified to update Case Reason and to close event notification case when sent for processing. 
   1.4 -    Becca               10/12/2012       Modified to update controlplan summary and run number on internal case generated
   1.5 -    Becca               11/16/2012       Added CRD Pricing Needed and PCG/FCG Needed Checkboxes
   1.6 -    Becca               02/21/2013       Updated to include RxPlan ID 1 and RxPlan ID 2
   1.7 -    Becca               05/13/2013       Added new fields (Refresh Needed, Add to AI Non-Pkg Table, RxID Needed, Seed PERS)
   1.8 -    Becca               06/24/2013       Added new field "Control Plan List" per request #1029
   1.9 -    Becca               09/24/2013       Adding new 'Adding Clinical Programs' field per request #01162
   2.0 -    Becca               12/02/2013       Added "Control_Plans_to_Unlink" and "Unlink_to_CRD" fields
   2.1 -    Becca               01/28/2014       Added 'Seed PERS' checkbox
   2.2 -    Becca               02/18/2014       Added 'CRD Name to Clone' and 'RxPlan ID to Clone' fields
   2.3 -    Becca               02/19/2014       Added 'Base CRD to Clone' field
======================================================================== */


public with sharing class Event_Notification_Case_Creation{
    
    case caseRecord;
    Id parentId;
    
    public Event_Notification_Case_Creation(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        caseRecord=[Select c.Type, c.Subject, c.Claims_Enhancement_Date__c, c.Control_Plans_to_Unlink__c, c.Unlink_to_CRD__c, c.Base_CRD_to_Clone__c,c.Auditor__c, c.HCR_Update__c, c.Urgent_Flag__c, c.CRD_Pricing_Needed__c, c.PCG_FCG_Needed__c, c.controlPlanSummary__C, c.Status, c.Source_Type__c, c.Run_Number__c, c.Review_Notes__c, c.Related_Internal_CRD_Case__c, c.RecordTypeId, c.CRD_Name_to_Clone__c, c.RxPlan_ID_to_Clone__c, c.Priority, c.PSUnique_ID__c, c.Refresh_Needed__c, c.Add_to_AI_Non_Pkg_Table__c, c.RxID_Update_Needed__c, c.Seed_PERS__c, c.OwnerId, c.Origin, c.LastModifiedDate, c.LastModifiedById, c.IsEscalated, c.IsDeleted, c.IsClosed, c.Id, c.Event_Notification_Review_Results__c, c.Event_Notification_Case__c, c.Description, c.Date_Sent_for_Processing__c, c.CreatedDate, c.CreatedById, c.Case_Type__c, c.Case_Type_Category__c, c.CaseNumber, c.CRD_Name__c, c.CRD_ID__c, c.Benefit_Effective_Date__c, c.Control_Plan_List__c, c.RxPlanID1__c, c.RxPlanID2__c, c.Adding_Clinical_Program__c, c.Account_Name_Text__c, c.AccountId, c.Acquisition_Indicator__c From Case c where id=:parentId];
    }  
    public PageReference EventNotification() {
        
        case c= new case();
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Internal_CRD_GMF_Process'].id;
        c.CRD_Name__c=caseRecord.CRD_Name__c;
        c.AccountId=caseRecord.AccountId;
        c.Origin='AI Notification';
        c.Review_Notes__c=caseRecord.Review_Notes__c;
        c.HCR_Update__c=string.valueOf(caseRecord.HCR_Update__c);
        c.Benefit_Effective_Date__c=caseRecord.Benefit_Effective_Date__c;
        c.Run_Number__c=caseRecord.Run_Number__c;        
        c.controlPlanSummary__c=caseRecord.controlPlanSummary__c;
        c.Description=caseRecord.Description;
        c.CRD_Pricing_Needed__c=caseRecord.CRD_Pricing_Needed__c;
        c.PCG_FCG_Needed__c=caseRecord.PCG_FCG_Needed__c;
        c.RxPlanID1__c=caseRecord.RxPlanID1__c;
        c.RxPlanID2__c=caseRecord.RxPlanID2__c;
        c.Control_Plan_List__c=caseRecord.Control_Plan_List__c;
        c.Refresh_Needed__c=caseRecord.Refresh_Needed__c;
        c.Add_to_AI_Non_Pkg_Table__c=caseRecord.Add_to_AI_Non_Pkg_Table__c;
        c.RxID_Update_Needed__c=caseRecord.RxID_Update_Needed__c;
        c.Adding_Clinical_Program__c=caseRecord.Adding_Clinical_Program__c;
        c.Urgent_Flag__c=caseRecord.Urgent_Flag__c;
        c.Subject='Event Notification Processing Needed';
        c.Status='Pending Audit by BCT Notif Team';
        c.Event_Notification_Case__c=caseRecord.Id;
        c.Event_Notification_Review_Results__c=caseRecord.Event_Notification_Review_Results__c;
        c.Control_Plans_to_Unlink__c=caseRecord.Control_Plans_to_Unlink__c;
        c.Unlink_to_CRD__c=caseRecord.Unlink_to_CRD__c;
        c.CRD_Name_to_Clone__c=caseRecord.CRD_Name_to_Clone__c;
        c.RxPlan_ID_to_Clone__c=caseRecord.RxPlan_ID_to_Clone__c;
        c.Base_CRD_to_Clone__c=caseRecord.Base_CRD_to_Clone__c;
        c.Seed_PERS__c=caseRecord.Seed_PERS__c;
        c.Acquisition_Indicator__c=caseRecord.Acquisition_Indicator__c;
        QueueSobject SFDCqueue;
        QueueSobject BCTqueue;
        SFDCQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Case - SFDC Team' LIMIT 1];
        BCTQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Case - BCT Supervisor Unassigned Cases' LIMIT 1];
        if(caseRecord.Event_Notification_Review_Results__c=='Attach New CSAPs to Existing CRD') {
            c.OwnerId=SFDCQueue.QueueId;
         } else {
            c.OwnerId=BCTQueue.QueueId;
         }

        insert c;
        
        caseRecord.Date_Sent_for_Processing__c=system.now();
        caseRecord.Related_Internal_CRD_Case__c=c.ID;
        caseRecord.Reason='Int CRD/GMF Case Created for Processing';
        caseRecord.Status='Pending Audit by BCT Notif Team';
        update caseRecord;
        
        PageReference pageref = new PageReference('/' + parentId);
        pageref.setRedirect(true);
        return pageref;
    }
            
}