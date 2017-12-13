/*Purpose: Apex Class for Cloning the Object List                                      
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/23/2012       Apex Class for Cloning the Object List
   1.1 -    Rahul                08/28/2012       Hix field added as per Request 01100
======================================================================== */
public with sharing class VFP_CloneRefillTooSoonController {
    public Refill_Too_Soon__c originalRefill{get;set;}
    public string RefillId;
    Refill_Too_Soon__c cloneRefill;
    List<Refill_Too_Soon_Criteria__c> CriteriaList = new List<Refill_Too_Soon_Criteria__c>();
    
    public VFP_CloneRefillTooSoonController(ApexPages.StandardController controller) {
        originalRefill = (Refill_Too_Soon__c)controller.getRecord();
        RefillId = originalRefill.Id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalRefill = [Select r.Termination_Date__c, Hix__c,r.Standard__c, r.Search_Indication__c, r.Refill_too_Soon_Name__c, r.Refill_too_Soon_Description__c, 
                         r.RecordTypeId, r.Name, r.Message_returned_to_the_Provider__c, r.Mark_for_Deletion__c, r.LastModifiedDate, r.LastModifiedById, 
                         r.IsDeleted, r.Inactive__c, r.Id, r.Funding_Type__c, r.Exclusion_Drug_List__c, r.Effective_Date__c, r.Early_Refill_Option__c, 
                         r.Deletion_Requestor__c, r.Deletion_Reason__c, r.Date_Marked_for_Deletion__c, r.Cumulative_Search_Indication__c, 
                         r.Cumulative_Rx_Max_Days_Supply__c, r.Cumulative_Minimum_Percent__c, r.Cumulative_History_Days__c, r.Carrier__c, r.Bypass_History_Days_Supply__c, 
                         r.Begin_Refill_Logic_after_Fills__c, r.Account__c, (Select Id, OwnerId, IsDeleted, Name, LastModifiedDate, Rx_Min_Days_Supply__c, 
                         Rx_Max_Days_Supply__c, Minimum_Percent__c, Related_Refill_Too_Soon__c From Refill_Too_Soon_Criteria__r) From Refill_Too_Soon__c r where Id =:RefillId ];
       
        cloneRefill = new Refill_Too_Soon__c ();  
        cloneRefill = originalRefill.clone(false); 
        CriteriaList = originalRefill.Refill_Too_Soon_Criteria__r;
    }
    
    public pagereference redirect(){
        List<Refill_Too_Soon_Criteria__c> cloneCriteria = new List<Refill_Too_Soon_Criteria__c>();
        Savepoint sp = Database.setSavepoint();
        try{
            insert cloneRefill ;
            if(CriteriaList.size()>0){
                for(Refill_Too_Soon_Criteria__c exp: CriteriaList){
                    Refill_Too_Soon_Criteria__c cloneExp = new Refill_Too_Soon_Criteria__c();
                    cloneExp = exp.clone(false);
                    cloneExp.Related_Refill_Too_Soon__c = cloneRefill.Id;
                    cloneCriteria.add(cloneExp);
                }
            insert cloneCriteria;
            }
            Pagereference pageref= new Pagereference('/'+cloneRefill.Id+'/e?retURL='+cloneRefill.Id);
                return pageref ;   
         }catch(exception e){
                // roll everything back in case of error
                 Database.rollback(sp);
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
                 ApexPages.addMessage(myMsg);  
                 return null;
        }
    }
    
    public Pagereference previouspage(){
           Pagereference pageref= new Pagereference('/'+originalRefill.Id+'/d?retURL='+originalRefill.Id);
           return pageref; 
      }
}