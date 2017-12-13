public with sharing class VFP_ErrorDefectTracker {
     public Boolean refreshPage{get; set;}

    ApexPages.StandardController stdcontroller;
    case caseRecord;
    Id parentId;
    Error_Defect_Tracker__c d;
    
    public VFP_ErrorDefectTracker(ApexPages.StandardController Controller) {
        stdcontroller=controller;
                refreshPage=false;

        parentId=controller.getId();
       // caseRecord=[Select c.Id, c.Case_Type__c, c.Aetna_Case_Type__c, c.RecordTypeId, c.CaseNumber, c.AccountId From Case c where id=:parentId];
    }  
    public PageReference save() {
        
       // Error_Defect_Tracker__c d=new Error_Defect_Tracker__c();
        
        try{
            insert d;
        } catch (Dmlexception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new Error/Defect Record.'));
            return null;
        }
        
        //PageReference pageref = new PageReference('/' + parentId);
        //pageref.setRedirect(true);
        //return pageref;
        refreshPage=true;
        return null;
       // return null;
    }
    
    public Error_Defect_Tracker__c getErrorDefectTracker(){
    
         d=new Error_Defect_Tracker__c(related_case__c=parentId);
         return d;

    }

}