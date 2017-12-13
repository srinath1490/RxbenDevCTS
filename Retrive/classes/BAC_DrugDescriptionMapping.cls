/*Purpose: Apex Batch Class for populating the Drug List Criteria Description    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj               1/10/2012      Apex Batch Class for populating the Drug List Criteria Description  
======================================================================== */

global class BAC_DrugDescriptionMapping implements database.Batchable<SOBJECT>,schedulable{
 
    global String query;
    
    //constructor of class
    global BAC_DrugDescriptionMapping(){
        Query='Select Id,Name,Drug_Type_Code__c,Drug_Code_Value__c,NDC__c,Drug_List_Criteria_Description__c,Description_of_NDC_Drug_List_Criteria__c from Drug_List_Criteria__c where Drug_List_Criteria_Description__c = null LIMIT 100';
    }
    
    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //Batch execute method
    global void execute(Database.BatchableContext BC,List<SOBJECT> Scope){
        TRG_DrugDescriptionMapping  drugDescription = new TRG_DrugDescriptionMapping();
        List<Drug_List_Criteria__c> criteriaList = new List<Drug_List_Criteria__c>();   
        for(SOBJECT s :Scope){
            string description = '';
            string ndcDescription = '';
            
            Drug_List_Criteria__c criteria = (Drug_List_Criteria__c)s;
            string drugTypeCode = criteria.Drug_Type_Code__c;
            string drugCodeValue = criteria.Drug_Code_Value__c;
            description = drugDescription.selectDrug(drugTypeCode,drugCodeValue);           
            if(drugTypeCode == system.Label.CL0000004 && criteria.NDC__c != null && criteria.NDC__c !=''){
                ndcDescription = drugDescription.drugNDC(criteria.NDC__c);
            }
            
            criteria.Drug_List_Criteria_Description__c = description; 
            criteria.Description_of_NDC_Drug_List_Criteria__c = ndcDescription;
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
        database.executeBatch(new BAC_DrugDescriptionMapping(), 40);
    }
         
}