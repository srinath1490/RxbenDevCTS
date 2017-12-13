/*Purpose: Apex Batch Class for creating/updating CIF records of all newly created CRDs  
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           25 Aug'2014      Apex Batch Class for creating/updating CIF records of all newly created CRDs
======================================================================== */
global class BAC_UpdateCIF implements Database.Batchable <sObject>{
    global String query;
    global set<Id> newCRDs = new set<Id>();
    
    global BAC_UpdateCIF(){
        for(CRD__c WizardCRD : [Select Id from CRD__c where LastSent__c = today])
            newCRDs.add(WizardCRD.id);
        for(CRDBuildOrder__c AutomaticCRD : [Select CRD__c,CRD__r.id from CRDBuildOrder__c where CreatedDate = today AND CVS__c = true] )       
            newCRDs.add(AutomaticCRD.CRD__r.id);
    
    query = 'Select Id, PSU__c, National__c, Account__c, Insured_Type__c, Carrier_Number__c, RxPlanID__c, Old_RxPlan_ID__c,controlplan__c, Plan_Type_Mail__c, Plan_Type_Retail__c, Plan_Type_Paper__c, Plan_Type_Specialty__c, Do_you_want_to_do_Step_Therapy__c, In_Network_claims_are_reimbursed__c, Out_of_Network_claims_are_reimbused__c, Does_the_client_want_to_do_COB__c, Prorate__c from CRD__c where Id IN :newCRDs';
    }
    
    global Database.Querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List <CRD__c> scope){
        CIF_Automation.CIFAutomation(scope);
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
    global void finish(Database.BatchableContext BC) {
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
}