/*Purpose: Apex Batch Class to make Callout for AI Request created by batch process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            4/9/2013       Apex Batch Class to make Callout for AI Request created by batch process
======================================================================== */
global class BAC_Callout implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;

    global BAC_Callout() {
        query = 'SELECT Id, Batch_Logger_ID__c,Benefit__c, Benefits_String_Extn__c, CRD_ID__c,Integration_1__c, Plan_ID__c,Pricing_Schedule__c, Request_Type__c, Risk_Indicator__c,StateList_to_Remove__c, Created_by_Batch_Process__c, Processed__c,State_Mandates_Apply__c, States_List_for_Mandate__c FROM AI_Request__c WHERE Created_by_Batch_Process__c = true and Processed__c=False';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        try {
            for (SOBJECT s: Scope) {
                AI_Request__c CurrentAIInstance = (AI_Request__c) s;
                GC_Utils_Method.callout(CurrentAIInstance.Batch_Logger_ID__c, CurrentAIInstance);
                CurrentAIInstance.Processed__c = true;
            }
            update scope;
        } catch (exception e) {
            //Exception
        }
    }

    global void finish(Database.BatchableContext BC) {

    }
}