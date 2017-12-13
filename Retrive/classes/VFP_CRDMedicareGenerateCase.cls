/*Purpose: Apex Class for Generating Case Record for Medicare CRD
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Sushant                 04/11/2013       Apex Class for Generating Case Record for Medicare CRD
     1.1 - 	 Becca					 04/02/2014			Modified based on new requirements and changed from Java to VF Page
======================================================================== 
*/

public with sharing class VFP_CRDMedicareGenerateCase{
    
    CRD_Medicare__c cmRecord;
   	Id parentId;
    
    public VFP_CRDMedicareGenerateCase(ApexPages.StandardController Controller) {
        
		parentId=controller.getId();
        cmRecord=[Select c.RxPlan_ID__c, c.Name, c.OwnerId, c.Id From CRD_Medicare__c c where id=:parentId];
    }  
    public PageReference GenerateCase() {
        
        case c= new case();
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_Medicare_CRD' and SobjectType = 'Case'].id;
        c.OwnerId=cmRecord.OwnerId;
        c.Aetna_Case_Type__c='Medicare CRD';
        c.Subject='Medicare CRD Case_'+Date.today().format();
        c.CRD_Medicare__c=cmRecord.Id;
        c.CRD_GMF_Case_Status__c='New';
        c.CRD_Benefits__c=true;
        c.CRD_Integration__c=true;
        c.RxPlan_ID__c=cmRecord.RxPlan_ID__c;

        insert c;
        
        cmRecord.External_Medicare_CRD_Case__c=c.Id;
        update cmRecord;
        
        PageReference pageref = new PageReference('/' + c.Id);
        pageref.setRedirect(true);
        return pageref;
    }
            
}