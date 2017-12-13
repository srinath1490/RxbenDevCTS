global class BAC_Full_Control_Group implements Database.Batchable < Sobject > {
    global String query;

    global BAC_Full_Control_Group() {
        query = 'SELECT Id,lastmodifieddate from Full_Control_Group__c';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < Full_Control_Group__c > scope) {
        try {
            for (Full_Control_Group__c s: Scope) {
               s.Last_Synced_Date__c = s.lastmodifieddate ;
            }
            update scope;
        } catch (exception e) {
            //Exception
        }
    }

    global void finish(Database.BatchableContext BC) {

    }
}