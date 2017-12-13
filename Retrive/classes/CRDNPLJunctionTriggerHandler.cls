/*Purpose: Trigger to populate custom history object for CRD NPL Junction                                      
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Sushant               06 Aug 2014         Trigger to populate custom history object for CRD NPL Junction
                                                
======================================================================== */

public class CRDNPLJunctionTriggerHandler{
    public static void onAfterInsert(Map<Id,CRD_NPL_Junction__c> newList){
     list<crd_history__c> historyList = new List<crd_history__c>();
     CRD_History__c history;
     for(CRD_NPL_Junction__c npl:newList.values()){
         if(npl.lastsent__c!= null){
                history = new CRD_History__c();
                history.crd_id__c = npl.crd_id__c;
                history.Field_Name__c = npl.name;
                history.Modified_By__c = system.Userinfo.getName();
                history.New_Value__c = 'Created';
                history.Old_Value__c = '';  
                historyList.add(history);                
         }               
     }
     if(!historylist.isempty()){
         insert historyList;
     }  
}
        public static void onbeforeDelete(list<CRD_NPL_Junction__c> oldList){
            list<crd_history__c> historyList = new List<crd_history__c>();
            CRD_History__c history;
             for(CRD_NPL_Junction__c npl:oldList){
                if(npl.lastsent__c!= null){
                history = new  CRD_History__c();
                history.crd_id__c = npl.crd_id__c;
                history.Field_Name__c = npl.name;
                history.Modified_By__c = system.Userinfo.getName();
                history.New_Value__c = 'Deleted';
                history.Old_Value__c = '';  
                historyList.add(history);                
                }               
                }
                 if(!historylist.isempty()){
                   insert historyList;
                    }                
        }       
}