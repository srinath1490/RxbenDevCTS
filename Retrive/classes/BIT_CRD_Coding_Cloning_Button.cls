public with sharing class BIT_CRD_Coding_Cloning_Button {
  
  BIT_CRD_Coding_Instructions__c BCCIRecord;
  Id parentId;
    
    public BIT_CRD_Coding_Cloning_Button (ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        BCCIRecord=[Select p.Coding_Considerations__c, p.Coding_Instructions__c, p.Line_Value__c, p.Line_Value_Text__c, p.Provision_Name__c, p.ProvisionN2__c, p.Remarks__c, p.Known_Defects__c, p.Validation_Error_Code__c, p.Validation_Error__c From BIT_CRD_Coding_Instructions__c p where id=:parentId];
    }  
    public PageReference CreateClone() {
        
        BIT_CRD_Coding_Instructions__c p = new BIT_CRD_Coding_Instructions__c();
        p.Coding_Considerations__c=BCCIRecord.Coding_Considerations__c;
        p.Coding_Instructions__c=BCCIRecord.Coding_Instructions__c;
        p.Known_Defects__c=BCCIRecord.Known_Defects__c;
        p.Line_Value__c=BCCIRecord.Line_Value__c;
        p.Line_Value_Text__c=BCCIRecord.Line_Value_Text__c;
        p.Provision_Name__c=BCCIRecord.Provision_Name__c;
        p.ProvisionN2__c=BCCIRecord.ProvisionN2__c;
        p.Remarks__c=BCCIRecord.Remarks__c;
        p.Validation_Error_Code__c=BCCIRecord.Validation_Error_Code__c;
        p.Validation_Error__c=BCCIRecord.Validation_Error__c;
        p.Cloned_BCCI_Record_ID__c=BCCIRecord.Id;
        

        BCCIRecord.Active__c=false;
        BCCIRecord.Unique_Key__c=null;
        update BCCIRecord;
        
        insert p;
        
        BCCIRecord.Active__c=false;
        update BCCIRecord;
        
        PageReference pageref = new PageReference('/' + String.valueOf(p.Id));
        pageref.setRedirect(true);
        return pageref;
    }

}