/*Purpose: Apex Batch Class to make Callout for AI Request created by batch process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
1.0      Abhishek goel    5/2/2014       Apex Batch Class to make Callout for AI Request created by batch process
======================================================================== */
global class BAC_CB_MassSend2AIRequest implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;
    //global Id crdId;
    public Set<Id> idset;
    Public set<Id> cbonId;
    /*
* Constructor of class BAC_MassSend2AI 
*/ 
    global BAC_CB_MassSend2AIRequest(set<Id> idSetinput,set<Id> idcbon) {
        cbonId = idcbon;
        idset = idSetinput;
        query =  'SELECT Id, Batch_Logger_ID__c,Benefit__c, Benefits_String_Extn__c, CRD_ID__c,Integration_1__c, Plan_ID__c,Pricing_Schedule__c, Request_Type__c, Risk_Indicator__c,StateList_to_Remove__c, Created_by_Batch_Process__c, Processed__c,State_Mandates_Apply__c, States_List_for_Mandate__c FROM AI_Request__c WHERE Id IN :idset';        
   }
   
    /*
* Method :- start
* Description :- This method indicates the beignning of a batch
*/  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    /* 
* Method :- execute
* Description :- This method  gets current looged in user info  and generate AiRequest 
*/  
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        CB_MassSend2AIRequest massSendToAi = new CB_MassSend2AIRequest();
          massSendToAi.massSend2AIRequest(scope);

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    /* 
* Method :- finish
* Description :- This method indicates all batches are processed and also schedulde the next job
*/ 
    global void finish(Database.BatchableContext BC) {
    
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    
        if(system.label.CRDBuilder_FullAutoMode.equalsIgnoreCase('true')){
            CB_BatchOrchestration obj = new CB_BatchOrchestration();
            if(cbonId!=null && cbonId.size()>0){
                     obj.cbonId= cbonId;
                     obj.callNext('Batch_CAG');
             }
        }
    }
}