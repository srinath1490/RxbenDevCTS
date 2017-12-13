/*Purpose: Apex Batch Class for populating the Step Thereapy Prerequiste Description    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj               1/10/2012      Apex Batch Class for populating the Step Thereapy Prerequiste Description      
======================================================================== */

global class BAC_StepTherapyDescriptionMapping implements database.Batchable<SOBJECT>,schedulable{
 
    global String query;
    
    //constructor of class    
    global BAC_StepTherapyDescriptionMapping(){
        Query='Select Id,Name,Description_of_Pre_Requisite_Drug__c,Drug_Code_Value__c,Drug_Type_Code__c FROM Step_Therapy_PreRequisite_Drug__c where Description_of_Pre_Requisite_Drug__c = null';
    }
    
    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //Batch execute method    
    global void execute(Database.BatchableContext BC,List<SOBJECT> Scope){
    TRG_DrugDescriptionMapping  drugDescription = new TRG_DrugDescriptionMapping();
    List<Step_Therapy_PreRequisite_Drug__c> criteriaList = new List<Step_Therapy_PreRequisite_Drug__c>();   
        for(SOBJECT s :Scope){
            string description = '';
            
            Step_Therapy_PreRequisite_Drug__c criteria = (Step_Therapy_PreRequisite_Drug__c)s;
            string drugTypeCode = criteria.Drug_Type_Code__c;
            string drugCodeValue = criteria.Drug_Code_Value__c;
            description = drugDescription.selectDrug(drugTypeCode,drugCodeValue);          
            
            criteria.Description_of_Pre_Requisite_Drug__c = description; 
            criteriaList.add(criteria);
        }
        try{
          update criteriaList;          
        }catch(exception e){
            
        }
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    } 
     //Batch finsh method    
    global void finish(Database.BatchableContext BC){
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    } 
 
     // Batch schedule method   
    global void execute(schedulableContext MC){
        database.executeBatch(new BAC_StepTherapyDescriptionMapping(), 80);
    }     
}