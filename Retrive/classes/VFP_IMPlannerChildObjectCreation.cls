public with sharing class VFP_IMPlannerChildObjectCreation {
    
    Implementation_Planner__c imp;
    Id parentId;
    
    public VFP_IMPlannerChildObjectCreation(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        imp=[Select imp.Programs_Requiring_Lead_Time__c, imp.School_Client_Name__c, imp.Custom_Network__c, imp.Implementation_Type__c, imp.Id, imp.Effective_Date__c From Implementation_Planner__c imp where id=:parentId ];
    }  
    public PageReference CreateIMPlannerChild() {

        Implementation_Planner_Benefit_Plan__c ipc = new Implementation_Planner_Benefit_Plan__c();
        ipc.Implementation_Planner__c=imp.Id;
        ipc.School_Client_Name__c=imp.School_Client_Name__c;
        ipc.SSD_Approval_by_Plan_Sponsor_Target__c=imp.Effective_Date__c.addDays(-55);
        ipc.Programs_Requiring_Lead_Time__c=imp.Programs_Requiring_Lead_Time__c;
        ipc.Implementation_Type__c=imp.Implementation_Type__c;
        //ipc.PERS_Triggered_Target__c=imp.Effective_Date__c.addDays(-40);
        ipc.RX_Benefit_Intent_Review_Target__c=imp.Effective_Date__c.addDays(-38);
        ipc.CRD_Sent_to_CVS_Target__c=imp.Effective_Date__c.addDays(-34);
        //ipc.RxPlan_ID_in_PERS_Target__c=imp.Effective_Date__c.addDays(-25);
        ipc.CIF_Sent_Target__c=imp.Effective_Date__c.addDays(-15);
        ipc.EZ_Tests_Received_Target__c=imp.Effective_Date__c.addDays(-11);
        ipc.EZ_Tests_Approved_Target__c=imp.Effective_Date__c.addDays(-8);
        
        if(imp.Custom_Network__c=='Yes'){
        ipc.Custom_Network_Finalized_Target__c=imp.Effective_Date__c.addDays(-34);
        } 
        
        insert ipc;


        PageReference pageref = new PageReference('/' + String.valueOf(ipc.Id)+'/e?retURL='+String.valueOf(ipc.Id));
        pageref.setRedirect(true);
        return pageref;

    }

}