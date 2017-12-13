/*Purpose: Apex Class for creating an Implementation Planner record from the Sold Case Worksheet.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Becca               05/23/2014       	Created 
   2.0 - 	Becca				05/28/2015			Changes from team for version 2.0

======================================================================== */

public with sharing class VFP_ImplementationPlannerCreation {
    
    Sold_Case_Worksheet__c scw;
    Id parentId;
    List<Contact> contactList = new List<Contact>();
    
    public VFP_ImplementationPlannerCreation(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        scw=[Select scw.VPCM_Name__c, scw.PG_Description__c, scw.Formulary_type__c, scw.Special_Files_Needed__c, scw.Segment__c, scw.SMU_Requests_Approval_Required__c, scw.SMU_Request_Approval_Details__c, scw.SAE_Name__c, scw.Rx_AM_Name__c, scw.Region__c, scw.Programs_Sold_Requiring_Lead_Time__c, scw.Product__c, scw.Prior_Carrier__c, scw.Population_Demographics__c, scw.OwnerId, scw.Membership__c, scw.Existing_Aetna_Benefits_in_Place__c, scw.School_Client_Name__c, scw.Custom_Network_Pricing__c, scw.Integration_with_Accumulators__c, scw.Implementation_Type__c, scw.Implementation_Planner_Created__c, scw.Implementation_Performance_Guarantee__c, scw.Id, scw.Funding__c, scw.Formulary_Disruption_Done__c, /*scw.Existing_RX_Benefits_in_Place__c,*/ scw.Effective_Date__c, scw.Date_Time_Implementation_Planner_Created__c, scw.Custom_TFN__c, scw.Custom_Network__c, scw.Custom_Network_Type__c, scw.Custom_Network_Descrition__c, scw.Consultant_Name__c, scw.Clinical_Account_Executive__c, scw.Client_Nuances_Unique_Benefit_Needs__c, scw.Aetna_Medical_Contact__c, scw.Account__c From Sold_Case_Worksheet__c scw where id=:parentId ];
        contactList = [Select c.Sold_Case_Worksheet__c, c.Implementation_Planner__c, c.Id From Contact c WHERE c.Sold_Case_Worksheet__c=:parentId];
    }  
    public PageReference CreateImplementationPlanner() {
        
        QueueSobject IMPQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Unassigned Implementations' LIMIT 1];
        if(scw.Implementation_Planner_Created__c==null){
        Implementation_Planner__c imp = new Implementation_Planner__c();
        if(scw.Implementation_Type__c=='Rx Standalone'){
        	imp.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Rx_Standalone'].id;
        } else {
        	imp.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Integrated'].id;
        }
        imp.Account_Name__c=scw.Account__c;
        imp.Sold_Case_Worksheet__c=scw.Id;
        imp.Effective_Date__c=scw.Effective_Date__c;
        imp.Segment__c=scw.Segment__c;
        imp.Region__c=scw.Region__c;
        imp.Membership__c=scw.Membership__c;
        imp.Product__c=scw.Product__c;
        imp.Prior_Carrier__c=scw.Prior_Carrier__c;
        imp.Consultant_Name__c=scw.Consultant_Name__c;
        imp.Funding__c=scw.Funding__c;
        imp.Population_Demographics__c=scw.Population_Demographics__c;
        imp.Existing_Aetna_Benefits_in_Place__c=scw.Existing_Aetna_Benefits_in_Place__c;
        imp.Custom_TFN__c=scw.Custom_TFN__c;
        imp.Custom_Network__c=scw.Custom_Network__c;
        imp.Custom_Network_Type__c=scw.Custom_Network_Type__c;
        imp.Custom_Network_Pricing__c=scw.Custom_Network_Pricing__c;
        imp.SMU_Requests_Approval_Required__c=scw.SMU_Requests_Approval_Required__c;
        imp.SMU_Request_Description__c=scw.SMU_Request_Approval_Details__c;
        imp.Implementation_Performance_Guarantee__c=scw.Implementation_Performance_Guarantee__c;
        imp.PG_Description__c=scw.PG_Description__c;
        imp.Implementation_Type__c=scw.Implementation_Type__c;
        imp.Integration_with_Accumulators__c=scw.Integration_with_Accumulators__c;
        imp.ORFT_Files_Needed__c=scw.Special_Files_Needed__c;
        imp.Formulary_Disruption_Done__c=scw.Formulary_Disruption_Done__c;
        imp.Formulary_type__c=scw.Formulary_type__c;
        imp.Client_Nuances_Unique_Benefit_Needs__c=scw.Client_Nuances_Unique_Benefit_Needs__c;
        imp.OwnerId=IMPQueue.QueueId;
        imp.Rx_Account_Manager__c=scw.Rx_AM_Name__c;
        imp.Rx_VPCM__c=scw.VPCM_Name__c;
        imp.Strategic_Account_Executive__c=scw.SAE_Name__c;
        imp.Aetna_Medical_Contact__c=scw.Aetna_Medical_Contact__c;
        imp.Clinical_Account_Executive__c=scw.Clinical_Account_Executive__c;
        imp.Programs_Requiring_Lead_Time__c=scw.Programs_Sold_Requiring_Lead_Time__c;
        imp.School_Client_Name__c=scw.School_Client_Name__c;
        //imp.SSD_Approval_by_Plan_Sponsor_Target__c=scw.Effective_Date__c.addDays(-55);
        imp.Verify_Eligibility_Target__c=scw.Effective_Date__c.addDays(-22);
        imp.ID_Cards_Sent_Target__c=scw.Effective_Date__c.addDays(-15);
        if(scw.Programs_Sold_Requiring_Lead_Time__c.contains('MC')){
        	imp.MC_POP_Form_Sent_Target__c=scw.Effective_Date__c.addDays(-120);
        }
        if(scw.Programs_Sold_Requiring_Lead_Time__c.contains('ECHC')){
        	imp.ECHC_POP_Form_Sent_Target__c=scw.Effective_Date__c.addDays(-60);
        }
        if(scw.Programs_Sold_Requiring_Lead_Time__c.contains('Pharmacy Advisor')){
        	imp.Pharmacy_Advisor_POP_Form_Sent_Target__c=scw.Effective_Date__c.addDays(-60);
        }
        if(scw.Special_Files_Needed__c.contains('MOD')){
        	imp.MOD_Test_File_Target__c=scw.Effective_Date__c.addDays(-16);
        	imp.MOD_Production_File_Target__c=scw.Effective_Date__c;
        	imp.MOD_Lag_File_Target__c=scw.Effective_Date__c.addDays(10);
        }
        if(scw.Special_Files_Needed__c.contains('Specialty')){
        	imp.ASRx_Test_File_Target__c=scw.Effective_Date__c.addDays(-30);
        	imp.ASRx_Production_File_Target__c=scw.Effective_Date__c;
        	imp.ASRx_Lag_File_Target__c=scw.Effective_Date__c.addDays(10);
        }
        if(scw.Special_Files_Needed__c.contains('Prior Auth')){
        	imp.Prior_Auth_Test_File_Target__c=scw.Effective_Date__c.addDays(-16);
        	imp.Prior_Auth_Production_File_Target__c=scw.Effective_Date__c;
        	imp.Prior_Auth_Lag_File_Target__c=scw.Effective_Date__c.addDays(10);
        }
        if(scw.Special_Files_Needed__c.contains('Accums')){
        	imp.Accums_Production_File_Target__c=scw.Effective_Date__c.addDays(-30);
        	imp.Accums_Lag_File_Target__c=scw.Effective_Date__c.addDays(10);
        }
        if(scw.Special_Files_Needed__c== 'Not Applicable'){
        	imp.ORFT_Meeting_with_Prior_Carrier__c= 'Not Applicable';
        } else {
        	imp.ORFT_Meeting_with_Prior_Carrier__c='Applicable';
        }

        insert imp;

        
        scw.Date_Time_Implementation_Planner_Created__c=system.now();
        scw.Implementation_Planner_Created__c=imp.Id;
        update scw;
        
        for(Contact cts :contactList){
        	cts.Implementation_Planner__c=imp.Id;
        }
        update contactList;

        PageReference pageref = new PageReference('/' + parentId);
        pageref.setRedirect(true);
        return pageref;
        }else{
        	PageReference pageref = new PageReference('/' + parentId);
        	pageref.setRedirect(true);
        	return pageref;
        }
    }
          
}