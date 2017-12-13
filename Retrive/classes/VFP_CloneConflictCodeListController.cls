/*Purpose: Apex Class for Cloning the Formulary List                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 01/06/2012       Apex Class for Cloning the Formulary List
======================================================================== */
public  class VFP_CloneConflictCodeListController {
    Public Conflict_Code_List__c originalConlictList{get;set;}
    Conflict_Code_List__c cloneConlictList;
    List<Conflict_Codes__c> listOfConflicts;
    public string conflictCodeId{get;set;}
    
 	public VFP_CloneConflictCodeListController(ApexPages.StandardController controller) {
        this.originalConlictList = (Conflict_Code_List__c)controller.getRecord();
        listOfConflicts = new List<Conflict_Codes__c>();
        conflictCodeId = originalConlictList.Id;
       //Hix field added as per Request 01100, By Rahul Nasa
       	originalConlictList = [Select c.Termination_Date__c,c.Hix__c,c.Standard__c, c.RecordTypeId, c.Name, c.Mark_for_Deletion__c, c.Inactive__c, c.Funding_Type__c, c.Effective_Date__c,
                               c.Deletion_Requestor__c, c.Deletion_Reason__c, c.Date_Marked_for_Deletion__c, c.Conflict_Code_List_Name__c, c.Conflict_Code_List_Description__c,
                               c.Account__c, (Select Id, Name, RecordTypeId, Conflict_Codes__c, GPI__c, Related_GPI__c, Days_to_Review__c, DUR_Message__c, Daily_Dose__c, 
                               Diagnosis_Code__c, Value__c, Operator__c, Age__c, Clinical_Program__c, Overlap_Percent__c, Related_Conflict_Code_List__c, Effective_Date__c,
                               Termination_Date__c From Conflict_Codes__r) From Conflict_Code_List__c c where Id =:conflictCodeId];
                                                  
        listOfConflicts = originalConlictList.Conflict_Codes__r;        
        cloneConlictList = new Conflict_Code_List__c();
        cloneConlictList =  originalConlictList.clone(false);       
    }
    
    Public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();  
        try{
            insert cloneConlictList;
           List<Conflict_Codes__c> EntryList = new List<Conflict_Codes__c>();
            if(listOfConflicts.size() >0){
                for(Conflict_Codes__c  entry: listOfConflicts){
                    Conflict_Codes__c cloneEntry = new Conflict_Codes__c();
	                    cloneEntry = entry.clone(false);
	                    cloneEntry.Related_Conflict_Code_List__c= cloneConlictList.Id;
	                    EntryList.add(cloneEntry);
                }
                insert EntryList;
            }
           Pagereference pageref= new Pagereference('/'+cloneConlictList.Id+'/e?retURL='+cloneConlictList.Id);
           return pageref ;
        }catch(exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
            ApexPages.addMessage(myMsg);  
           return null;    
        }
    }
    
    Public Pagereference previouspage(){
            Pagereference pageref= new Pagereference('/'+originalConlictList.Id+'/d?retURL='+originalConlictList.Id);
           return pageref; 
    }
}