@isTest
global class Test_Batch_Class implements database.Batchable<sObject>{
    global final string query;

    global Test_Batch_Class(){
        query='SELECT id FROM Account LIMIT 1';
    }

    global database.QueryLocator start(database.BatchableContext BC){
        return database.getQueryLocator(query);
    }

    global void execute(database.BatchableContext BC,list<sObject> scope){
        CB_CRDBMonitor CB = new CB_CRDBMonitor();
        CB.sendEmailmethod('Test_Batch_Class','Aborted');
        CB.sendEmailmethod('Test_Batch_Class','Failed');
        CB.sendEmailmethod('Test_Batch_Class','Delay');
        CB.sendEmailmethod('Test_Batch_Class','NA');
    }//END execute

    global void finish(database.BatchableContext BC){
        CB_CRDBMonitor.CalculateStatus(BC.getJobID());
    }//END finish 
}