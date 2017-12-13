/*Purpose: Trigger to populate custom history object for Waiver Of Deductible                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Richa                08/05/2014         Trigger to pouplate custom history object for Waiver Of Deductible
                                                
======================================================================== */
public class WaiverOfDeductibleTriggerHandler {
    
    public static void onAfterInsert(Map<Id,Waiver_Of_Deductible__c> newMap){
        GC_Utils_Method utils = new GC_Utils_Method();
        List<Waiver_Of_Deductible_History__c> historyList = new List<Waiver_Of_Deductible_History__c>();
        Waiver_Of_Deductible_History__c history;
        for(Waiver_Of_Deductible__c waiver :newMap.values()){
            if(waiver.LastSent__c != null){
               history = new Waiver_Of_Deductible_History__c();
               history =  (Waiver_Of_Deductible_History__c)utils.historyData(history, waiver.Id
                                                                                , string.valueof(waiver.Name)
                                                                                , system.Userinfo.getName()
                                                                                , ''
                                                                                , 'Created');        
               historyList.add(history);
               }
        }
        
        insert historyList;
    }
    
    public static void onAfterUpdate(Map<Id,Waiver_Of_Deductible__c> oldMap, Map<Id,Waiver_Of_Deductible__c> newMap){
        GC_Utils_Method utils = new GC_Utils_Method();
        List<History_Fields__c> fieldsList 
                = new List<History_Fields__c>([select
                                                Id,Name,Field_name__c,Field_Label__c,object_Name__c 
                                              from 
                                                History_Fields__c 
                                              where 
                                                object_Name__c =: Schema.SObjectType.Waiver_Of_Deductible__c.getName()]);
        List<Waiver_Of_Deductible_History__c> historyList = new List<Waiver_Of_Deductible_History__c>();
        Waiver_Of_Deductible_History__c history;
        for(Waiver_Of_Deductible__c waiver :newMap.values()){
            if(waiver.LastSent__c != null){
               history = new Waiver_Of_Deductible_History__c();
                 for(History_Fields__c field : fieldsList){ 
                    history = new  Waiver_Of_Deductible_History__c();
                   if(waiver.get(field.Field_name__c)!= oldMap.get(waiver.Id).get(field.Field_name__c)){
                         history =  (Waiver_Of_Deductible_History__c) utils.historyData(history,waiver.Id
                                                                                    ,field.Field_Label__c
                                                                                    ,system.Userinfo.getName()
                                                                                    ,   oldMap.get(waiver.Id).get(field.Field_name__c) != null 
                                                                                                                ?   string.valueof(oldMap.get(waiver.Id).get(field.Field_name__c))
                                                                                                                : ''
                                                                                    , waiver.get(field.Field_name__c) != null 
                                                                                                                ? string.valueof(waiver.get(field.Field_name__c))
                                                                                                                : ''
                                                                                ); 
                         historyList.add(history);
                    }
                }
            }  
        }
        
        if(! historyList.isEmpty()){
            insert historyList;
        }
        
            
    }
    
    public static void onBeforeDelete(List<Waiver_Of_Deductible__c> oldList){
        List<CRD_History__c > historyList = new List<CRD_History__c >();
        CRD_History__c history;
        for(Waiver_Of_Deductible__c waiver :oldList){
            if(waiver.LastSent__c != null){
                  history = new  CRD_History__c();
                  history.CRD_ID__c = waiver.CRD_ID__c;
                  history.Field_Name__c = waiver.Name;
                  history.Modified_By__c = system.Userinfo.getName();
                  history.New_Value__c = 'Deleted';
                  history.Old_Value__c = '';  
                  historyList.add(history);
               }
        }
        
        if(! historyList.isEmpty()){
            insert historyList;
        }
    }
}