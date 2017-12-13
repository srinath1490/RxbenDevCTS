/*Purpose: Apex Class for Cloning the Formulary List                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 01/06/2012       Apex Class for Cloning the Formulary List
======================================================================== */
public class VFP_CloneDrugGroupController{
    Public Drug_Group__c originalDrugGroup{get;set;}
    Drug_Group__c cloneDrugGroup;
    List<Drug_List_Junction__c> listOfConflicts;
    public string drugGroupId{get;set;}
    
    public VFP_CloneDrugGroupController(ApexPages.StandardController controller) {
        this.originalDrugGroup= (Drug_Group__c)controller.getRecord();
        listOfConflicts = new List<Drug_List_Junction__c>();
        drugGroupId = originalDrugGroup.Id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalDrugGroup= [Select d.Termination_Date__c, d.State__c, d.Standard__c, d.Segment__c, d.RecordType_Name__c, d.RecordTypeId, d.Platform__c, d.Name,
                           d.Maximum_Priority__c, d.Mark_for_Deletion__c, d.Inactive__c, d.Funding__c, d.Effective_Date__c, d.Drug_Group_Name__c, d.Description__c,
                           d.Deletion_Requestor__c, d.Deletion_Reason__c, d.Date_Marked_for_Deletion__c, d.Account__c,Hix__c,d.Allowable_Actions__c, (Select Id, IsDeleted, Name, Sequence__c, 
                           Parent_Drug_Group__c, Drug_List__c,Drug_List_Name__c, Drug_List_Description__c, 
                            Priority__c, Mark_for_Deletion__c, Deletion_Reason__c, Date_Marked_for_Deletion__c, 
                           Deletion_Requestor__c From Drug_List_Junction__r),GMF_Group_Identifier__c From Drug_Group__c d where Id =:drugGroupId];
        
        listOfConflicts = originalDrugGroup.Drug_List_Junction__r;
        cloneDrugGroup = new Drug_Group__c();
        cloneDrugGroup =  originalDrugGroup.clone(false);
        
    }
    Public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();  
        try{
            insert cloneDrugGroup;
            List<Drug_List_Junction__c> EntryList = new List<Drug_List_Junction__c>();
            if(listOfConflicts.size() >0){
                for(Drug_List_Junction__c  entry: listOfConflicts){
                    Drug_List_Junction__c cloneEntry = new Drug_List_Junction__c();
                    cloneEntry = entry.clone(false);
                    cloneEntry.Parent_Drug_Group__c= cloneDrugGroup.Id;
                    EntryList.add(cloneEntry);
                }
                insert EntryList;
             }
            Pagereference pageref= new Pagereference('/'+cloneDrugGroup.Id+'/e?retURL='+cloneDrugGroup.Id);
            return pageref ;
        } catch(exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
            ApexPages.addMessage(myMsg);  
           return null;    
        }
    }
    Public Pagereference previouspage(){
           Pagereference pageref= new Pagereference('/'+originalDrugGroup.Id+'/d?retURL='+originalDrugGroup.Id);
           return pageref; 
    }
}