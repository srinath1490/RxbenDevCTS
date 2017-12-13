/**
*Purpose: Apex Batch Class for Fetching the CRDBuildOrder records and create PersSeed Records  
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Amit       25 April'14       CRD Builder- Step 3, creating PERSupdate records from CRD Build Order Object 
*   1.1 -    Joognu Rao 09 July'14       Implemented Case Enhancement process 
*   1.2 -    Abhishek       Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
*============================================================================================== 
**/
global class BAC_CB_SeedPersStep implements Database.Batchable < sObject > {
    public string cbonids = ''; 
    public string query{get;private set;}
    public  set<Id >cbonId{get;private set;}
    PRIVATE STATIC FINAL STRING BLANK = '';
    PRIVATE STATIC FINAL STRING TRUELABEL = 'true' ;
    
    /*setQuery*/
          public void setQuery(string s){
                if(s!=null && s!=BLANK){
                    query = s;
                }
            }
    /*setcbonId*/
            public void setcbonId(set<id> id){
                if(id!=null && id.size()>0){
                    cbonId = id;
                }
            }
    /**
    * Method :- BAC_CB_SeedPersStep()
    * Description :- Contructor method to start the Batch Process
    **/
    global BAC_CB_SeedPersStep(){
    //Added Success_Case__c field to query for story no:06696
        query = 'select id,name,Success_Case__c,CAG__c,CVS__c,PDF__c,PERS__c,XML__c,CRD__r.Effective_Date__c,CRD__r.RxPlanID__c,CRD__r.Y_Schd__c,CRD__C,CRD__r.Plan__c,CRD__r.Control__c,crd__r.PERS_timestamp__c,FalloutCase__c,PERSTimeStamp__c,crd__r.Account__c from CRDBuildOrder__c where valid__c = true and Build__c = True and Complete__c = True  AND CAG__c = TRUE AND XML__c = False AND PDF__c = False AND CVS__c = False AND PERS__c = False and CRD__r.RxPlanID__c != Null and CreatedDate = Today AND FalloutCase__c = Null';
    } 

    /**
    * Method :- start(Database.BatchableContext BC)
    * Description :- Start Method for the Batch process
    **/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query); 
    }
    
    /**
    * Method :- execute(Database.BatchableContext BC, List < sObject > scope)
    * Description :- Execute method where the records are processed and code logic is performed.
    *                It is calling seedStep Method from CB_SeedPersStep Class where further processing is done.
    **/
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        CB_SeedPersStep sPersStep = new CB_SeedPersStep();
        sPersStep.seedStep(scope);
        

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
    /**
    * Method :- finish(Database.BatchableContext BC)
    * Description :- Finish Method for the batch Process
    **/ 
    global void finish(Database.BatchableContext BC) {

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    
        if(system.label.CRDBuilder_FullAutoMode.equalsIgnoreCase(TRUELABEL)){
            //if(!(cbonId!=null && cbonId.size()>0)){
    
                CB_BatchOrchestration obj = new CB_BatchOrchestration();
                 if(cbonId!=null && cbonId.size()>0){
                       obj.cbonId= cbonId;
                 }
                 obj.callNext('Batch_XML');

         //   }
        }
    }
}