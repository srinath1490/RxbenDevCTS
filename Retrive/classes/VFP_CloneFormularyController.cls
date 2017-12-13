/*Purpose: Apex Class for Cloning the Formulary                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 01/06/2012       Apex Class for Cloning the Formulary 
   1.1 -    Sushant              07/18/2013       Added field Aetna Internal Notes as per Request 1086
   2.1 -    Nitish               08/07/2014       Implemented Request No 04692
======================================================================== */
public with sharing class VFP_CloneFormularyController{
    
    Public Formulary__c originalFormulary{get;set;}
    Formulary__c cloneFormulary;
    List<Formulary_Junction__c> listOfJunction;
    public string formularyId{get;set;}
    
    public VFP_CloneFormularyController(ApexPages.StandardController controller) {
        this.originalFormulary = (Formulary__c)controller.getRecord();
        listOfJunction = new List<Formulary_Junction__c>();
        formularyId = originalFormulary.Id;
       //Hix field added as per Request 01100, By Rahul Nasa
        originalFormulary = [Select f.Termination_Date__c, f.State__c, f.Standard__c, f.Segment__c, f.Platform__c, f.Option_Code__c, f.Option_Code_Open_Closed__c
                          /*, f.Option_Code_Number_of_Tiers__c*/, f.Notes__c, f.Name, f.Inactive__c, f.Id, f.Funding__c, f.Formulary_Name__c, f.Formulary_Description__c, f.Effective_Date__c,
                           f.CVS_Caremark_Formulary_ID__c, f.Account__c,f.Hix__c,f.Formulary_Open_Closed__c, (Select Id, Name, Priority__c,Effective_Date__c, Termination_Date__c, Formulary_List__c, 
                           Formulary__c, Formulary_List_Description__c, Formulary_Name__c, Option_Code__c,Formulary_List_Name__c,/* Option_Code_Number_of_Tiers__c,*/
                           Option_Code_Open_Closed__c From Formulary_Junction__r),Aetna_Internal_Notes__c,GMF_Group_Identifier__c From Formulary__c f where Id =:formularyId];
      
        listOfJunction = originalFormulary.Formulary_Junction__r;        
        cloneFormulary = new Formulary__c();
        cloneFormulary =  originalFormulary.clone(false);       
    }
    
    Public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();  
        try{
            insert cloneFormulary;
            List<Formulary_Junction__c> EntryList = new List<Formulary_Junction__c>();
            if(listOfJunction.size() >0){
                for(Formulary_Junction__c  entry: listOfJunction){
                    Formulary_Junction__c cloneEntry = new Formulary_Junction__c();
                        cloneEntry = entry.clone(false);
                        cloneEntry.Formulary__c = cloneFormulary.Id;
                    EntryList.add(cloneEntry);
                }
              insert EntryList;
            }
           Pagereference pageref= new Pagereference('/'+cloneFormulary.Id+'/e?retURL='+cloneFormulary.Id);
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
          Pagereference pageref= new Pagereference('/'+originalFormulary.Id+'/d?retURL='+originalFormulary.Id);
          return pageref; 
    }
}