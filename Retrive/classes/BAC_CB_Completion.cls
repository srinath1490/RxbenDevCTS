/*Purpose: Apex Batch Class to check CRD completion
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      6/9/2014           Apex Batch Class to check CRD completion
   1.1 -    Abhishek       Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
======================================================================== */
global class BAC_CB_Completion implements Database.Batchable <sObject>{
    public string query{get;private set;}
    public  set<Id >cbonId{get;private set;}
    public string cbonids = '';  
           public void setQuery(string s){
                if(s!=null && s!=''){
                    query = s;
                }
            }
            public void setcbonId(set<id> id){
                if(id!=null && id.size()>0){
                    cbonId = id;
                }
            }
    global BAC_CB_Completion() {
        query = 'select id,createddate, Control_Plan_Effective__c,PERS_timestamp__c,FalloutCase__c, CRD__c,crd__r.Account__c,crd__r.Effective_Date__c from CRDBuildOrder__c where valid__c = true and Build__c = True and Complete__c = false AND createdDate = today AND CRD__c <> null AND FalloutCase__c = null';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <CRDBuildOrder__c> scope) {
        CB_Completion objProcess = new CB_Completion();
        objProcess.execute(scope);
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }


    global void finish(Database.BatchableContext BC) {

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    
        //TODO:-If CRD_BUILD automation is true then invoke next batch (next process is to be determined)
        if(system.label.CRDBuilder_FullAutoMode.equalsIgnoreCase('true')){
           // if(!(cbonId!=null && cbonId.size()>0)){
                CB_BatchOrchestration obj = new CB_BatchOrchestration();
                if(cbonId!=null && cbonId.size()>0){
                    obj.cbonId= cbonId;
                }
                obj.callNext('Batch_AIlogs');  
        }   //}    
    }
}