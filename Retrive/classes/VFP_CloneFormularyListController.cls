/*Purpose: Apex Class for Cloning the Formulary List                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 01/06/2012       Apex Class for Cloning the Formulary List
   1.1 -    Rishabh              04/09/2012       Status code & Status code description added
   1.2 -    Sushant              07/29/2013       Formulary List Tier Added
   2.0      Sushant              02/25/2014       comments added.
   2.1 -    Nitish               06/27/2014       Request No- 4923
   2.2 -    Nitish               09/11/2015       Request No - 06007
======================================================================== */
public with sharing class VFP_CloneFormularyListController {
    Public Formulary_List__c originalFormularyList{get;set;}
    Formulary_List__c cloneFormularyList;
    List<Formulary_List_Entry__c> listOfEntry;
    List<Form_Junction__c> junctionList;
    List<Restricted_NDC_List__c> ndcList;
    set<Id> listEntryId = new set<Id>();
    public string formularyListId{get;set;}
/**
* Method :- VFP_CloneFormularyListController
* Description :- Method for Cloning the Formulary List
**/
    
    public VFP_CloneFormularyListController(ApexPages.StandardController controller) {
        this.originalFormularyList = (Formulary_List__c)controller.getRecord();
        listOfEntry = new List<Formulary_List_Entry__c>();
        junctionList = new List<Form_Junction__c>();
        formularyListId = originalFormularyList.Id;
        ndcList = new List<Restricted_NDC_List__c>();
        

        //Hix field added as per Request 01100, By Rahul Nasa
        originalFormularyList = [Select  f.OptionCode__c, f.Mark_for_Deletion__c,f.Termination_Date__c, f.Id, f.Formulary_List_Name__c, f.Formulary_List_Description__c,
                                 f.Effective_Date__c, f.Deletion_Requestor__c, f.Deletion_Reason__c,f.Date_Marked_for_Deletion__c,Hix__c, (Select Id, Name, Effective_Date__c,
                                Termination_Date__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Action__c, Message__c,Member_Message__c, Formulary_List__c, GPI__c, NDC__c, 
                                Description_of_Formulary_List_Entry__c,Allow_Transition_Fill__c,OTC__c,Rx__c From Formulary_List_Entries__r),Status_Code__c,Status_Code_Description__c ,Aetna_Internal_Notes__c, Formulary_List_Tier__c,GMF_Group_Identifier__c From Formulary_List__c f where Id =:formularyListId];
        
        listOfEntry = originalFormularyList.Formulary_List_Entries__r;  
        for(Formulary_List_Entry__c entry :listOfEntry){
            listEntryId.add(entry.Id);
        }
                
        cloneFormularyList = new Formulary_List__c();
        cloneFormularyList =  originalFormularyList.clone(false);
        junctionList =[Select f.Record_Type__c, f.Name, f.Id, f.Formulary_List_Entry_ID__c, f.Form_Name__c, f.Form_ID__c, f.Form_Description__c From 
                        Form_Junction__c f where Formulary_List_Entry_ID__c IN: listEntryId];
        ndcList = [Select f.Related_Formulary_List_Entry__c, f.Name, f.Id, f.Restrict_NDC__c, f.Effective_Date__c, f.MS_Code_M__c, f.MS_Code_N__c,f.MS_Code_O__c,f.MS_Code_Y__c,f.OTC__c,f.Related_DLC_Drug_Code_Value__c,f.Related_Drug_List_Criteria__c,f.Related_Formulary_List_Entry_GPI__c,f.Related_Step_Therapy_Pre_Requisite_Drug__c,f.Related_ST_pre_requisite_Drug_Code_Value__c,f.Rx__c,f.Termination_Date__c From 
                        Restricted_NDC_List__c f where Related_Formulary_List_Entry__c IN: listEntryId];
        
    }
/**
* Method :- redirect
* Description :- Method for inserting the cloned records.
**/
    
    Public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();  
        try{
            insert cloneFormularyList;
            Map<Id,Formulary_List_Entry__c> EntryListMap = new Map<Id,Formulary_List_Entry__c>();
            List<Form_Junction__c>  cloneJunctionList= new List<Form_Junction__c>();
            List<Restricted_NDC_List__c>  cloneNDCList= new List<Restricted_NDC_List__c>();
            if(listOfEntry.size() >0){
                for(Formulary_List_Entry__c  entry: listOfEntry){
                    Formulary_List_Entry__c cloneEntry = new Formulary_List_Entry__c();
                        cloneEntry = entry.clone(false);
                        cloneEntry.Formulary_List__c = cloneFormularyList.Id;
                    EntryListMap.put(entry.Id,cloneEntry);
                }
                insert EntryListMap.Values();
            }
            if(junctionList.size()>0){
                for(Form_Junction__c junction :junctionList){
                    Form_Junction__c cloneJunction = new Form_Junction__c();
                        cloneJunction = junction.clone(false);
                        cloneJunction.Formulary_List_Entry_ID__c = EntryListMap.get(junction.Formulary_List_Entry_ID__c).Id;
                    cloneJunctionList.add(cloneJunction);
                }
                insert cloneJunctionList;
            }
            //Added by Nitish for request 6007
            if(ndcList.size()>0){
                for(Restricted_NDC_List__c ndc :ndcList){
                    Restricted_NDC_List__c cloneNDC = new Restricted_NDC_List__c();
                        cloneNDC = ndc.clone(false);
                        cloneNDC.Related_Formulary_List_Entry__c= EntryListMap.get(ndc.Related_Formulary_List_Entry__c).Id;
                    cloneNDCList.add(cloneNDC);
                }
                insert cloneNDCList;
            }
        Pagereference pageref= new Pagereference('/'+cloneFormularyList.Id+'/e?retURL='+cloneFormularyList.Id);
           return pageref ;
        }catch(exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
            ApexPages.addMessage(myMsg);  
            return null;    
        }

    }
/**
* Method :- previouspage
* Description :- Method to redirect to previous page
**/
   
    Public Pagereference previouspage(){
           Pagereference pageref= new Pagereference('/'+originalFormularyList.Id+'/e?retURL='+originalFormularyList.Id);
           return pageref; 
    }
}