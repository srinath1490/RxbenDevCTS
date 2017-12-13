/*Purpose: Apex Batch Class for updating Business Hours of CaseStatusHistory object  
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           03 July'2014       Apex Batch Class for updating Business Hours of CaseStatusHistory object
======================================================================== */
global class BAC_CaseStatusHistory implements Database.Batchable <sObject>{
    global String query ;
    List<CaseStatusHistory__c> historyList = new List<CaseStatusHistory__c>();
    BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true limit 1];
    
    global BAC_CaseStatusHistory() {
        query = 'select Field__c,Value__c,From__c,To__c from CaseStatusHistory__c Where Elapsed_Business_Hours__c = null AND from__c <> null AND to__c <> null';
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <CaseStatusHistory__c> scope) {
        for(CaseStatusHistory__c csh : scope){
             csh.Elapsed_Business_Hours__c = BusinessHours.diff(defaultHours.id, csh.from__c, csh.to__c)/1000.0;
                    historyList.add(csh);
            }
            upsert historyList;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}