/*Purpose: Apex Class for Cloning theGCC                                       
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -       Anuj                 02/23/2012       Apex Class for Cloning the GCC
1.1			rakesh				 11-Aug'12		  added fields GCC_Type, Carrier_List (Req. 780)
======================================================================== */
public with sharing class VFP_CloneGCCController {
    public Generic_Code_Conversion__c originalGCC{get;set;}
    public string gccId;
    Generic_Code_Conversion__c cloneGCC;
    List<Generic_Code_Conversion_Entry__c> entryList = new List<Generic_Code_Conversion_Entry__c>();
    
    public VFP_CloneGCCController(ApexPages.StandardController controller) {
        originalGCC = (Generic_Code_Conversion__c)controller.getRecord();
        gccId = originalGCC.Id;
        
        originalGCC = [Select g.Termination_Date__c, g.Mark_for_Deletion__c, g.IsDeleted, g.Inactive__c, g.Generic_Code_Conversion_Name__c, g.Generic_Code_Conversion_Description__c, 
                       g.Effective_Date__c, g.Deletion_Requestor__c, g.Deletion_Reason__c, g.Date_Marked_for_Deletion__c, g.GCC_Type__c, g.Carrier_List__c,
                       (Select Id, IsDeleted, Name, Generic_Code_Conversion__c, 
                        Description_of_GCC_Entry__c, GPI__c, NDC__c, Effective_Date__c, Termination_Date__c, Generic_Code__c, Brand_Name_Code__c, FDA_Application_Type__c,
                        New_Generic_Code__c, Notes__c From Generic_Code_Conversion_Entries__r) From Generic_Code_Conversion__c g where Id =:gccId ];
        
        cloneGCC = new Generic_Code_Conversion__c ();  
        cloneGCC = originalGCC.clone(false); 
        entryList = originalGCC.Generic_Code_Conversion_Entries__r;
    }
    public pagereference redirect(){
        List<Generic_Code_Conversion_Entry__c> cloneEntry = new List<Generic_Code_Conversion_Entry__c>();
        Savepoint sp = Database.setSavepoint();
        try{
            insert cloneGCC ;
            if(entryList.size()>0){
                for(Generic_Code_Conversion_Entry__c exp: entryList){
                    Generic_Code_Conversion_Entry__c cloneExp = new Generic_Code_Conversion_Entry__c();
                    cloneExp = exp.clone(false);
                    cloneExp.Generic_Code_Conversion__c = cloneGCC.Id;
                    cloneEntry.add(cloneExp);
                }
                insert cloneEntry;
            }
            Pagereference pageref= new Pagereference('/'+cloneGCC.Id+'/e?retURL='+cloneGCC.Id);
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
        Pagereference pageref= new Pagereference('/'+originalGCC.Id+'/d?retURL='+originalGCC.Id);
        return pageref; 
    }
}