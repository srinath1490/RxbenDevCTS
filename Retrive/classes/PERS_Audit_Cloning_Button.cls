public with sharing class PERS_Audit_Cloning_Button {
    
    PERS_Audit__c PARRecord;
    Id parentId;
    
    public PERS_Audit_Cloning_Button(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        PARRecord=[Select p.Release_Date__c, p.Product__c, p.Plan_Sponsor_Name_2__c, p.Plan_Letter__c, p.PSU_Completed_Date__c, p.PSU_Comments__c, p.PERSAUDIT_Plan_Sponsor_Unique_ID__c, p.PERSAUDIT_Control_Group_Number__c, p.OwnerId, p.New_Existing_Customer__c, p.Funding__c, p.Employee_Number_del__c, p.Effective_Date__c, p.Audit_Plan_Sponsor_Name_New_Customer__c, p.Opportunity_Reason__c, CTT_Number__c From PERS_Audit__c p where id=:parentId];
    }  
    public PageReference CreateClone() {
        
        PERS_Audit__c p = new PERS_Audit__c();
        p.Employee_Number_del__c=PARRecord.Employee_Number_del__c;
        p.Plan_Sponsor_Name_2__c=PARRecord.Plan_Sponsor_Name_2__c;
        p.Audit_Plan_Sponsor_Name_New_Customer__c=PARRecord.Audit_Plan_Sponsor_Name_New_Customer__c;
        p.Funding__c=PARRecord.Funding__c;
        p.Product__c=PARRecord.Product__c;
        p.New_Existing_Customer__c=PARRecord.New_Existing_Customer__c;
        p.PERSAUDIT_Plan_Sponsor_Unique_ID__c=PARRecord.PERSAUDIT_Plan_Sponsor_Unique_ID__c;
        p.PERSAUDIT_Control_Group_Number__c=PARRecord.PERSAUDIT_Control_Group_Number__c;
        p.Release_Date__c=PARRecord.Release_Date__c;
        p.Effective_Date__c=PARRecord.Effective_Date__c;
        p.PSU_Completed_Date__c=PARRecord.PSU_Completed_Date__c;
        p.PERSAUDIT_Status__c='Benefit Compare in Process';
        p.OwnerId=PARRecord.OwnerId;
        p.Original_Request_Cloned_From__c=PARRecord.Id;
        p.CTT_Number__c=PARRecord.CTT_Number__c;
        p.Opportunity_Reason__c=PARRecord.Opportunity_Reason__c;
        
        

        insert p;
        
        PageReference pageref = new PageReference('/' + String.valueOf(p.Id));
        pageref.setRedirect(true);
        return pageref;
    }

}