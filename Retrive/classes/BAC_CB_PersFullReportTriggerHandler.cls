/*Purpose: Apex Batch Class to set PersTimeStamp at the time of new Pers Report
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Nitish        11/28/2014          Apex Batch Class to set PersTimeStamp at the time of new Pers Report
   2.0      Abhishek       09/25/2014          Apex Batch Class to set PersTimeStamp at the time of new Pers Report
======================================================================== */
global class BAC_CB_PersFullReportTriggerHandler implements Schedulable , Database.Batchable <sObject>{
    
    global String query ;
        
    global BAC_CB_PersFullReportTriggerHandler() {
        query = 'select id,PERStimestamp__c,ControlPlanEffective__c,WS_CNTRL_NO__c,WS_PLSM_CD__c,WS_NEW_INFRC_EFF_DT__c,Carrier_ID__c,What_is_the_carrier__c,WS_CUST_SUBSEG__c from  Pers_Full_Report__c where CRD_Build_Order__c=null AND CreatedDate = Today';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <Pers_Full_Report__c> scope) {
    
        Map<String,List<Pers_Full_Report__c>> mapCpEPtoPersFullreports = new Map<String, List<Pers_Full_Report__c>>();
        for(Pers_Full_Report__c persRecord : scope){
            String crdBuilderKey = persRecord.ControlPlanEffective__c + '|' + persRecord.PERStimestamp__c.format();
            if(mapCpEPtoPersFullreports.containsKey(crdBuilderKey)){
                mapCpEPtoPersFullreports.get(crdBuilderKey).add(persRecord);
            }
            else{
                mapCpEPtoPersFullreports.put(crdBuilderKey, new List<Pers_Full_Report__c>{persRecord});
            }
        }
        CB_PersFullReportTriggerHandler.populateCarrierIDBatchHandler(scope);
        CB_PersFullReportTriggerHandler.TRIGGER_CONTEXT = False;       
        CB_PersFullReportTriggerHandler.populateCrdBuilder(mapCpEPtoPersFullreports);
    
        // code for CRDB Monitoring starts - Sandeep Saklani
            CB_CRDBMonitor.CalculateStatus(BC.getJobId());
        // code for CRDB Monitoring ends - Sandeep Saklani  
    }


    global void finish(Database.BatchableContext BC) {
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani  
    }
    
    global void execute(SchedulableContext sc){
        ID batchprocessid = database.executeBatch(this);
    }
}