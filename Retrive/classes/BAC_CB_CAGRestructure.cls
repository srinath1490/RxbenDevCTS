/**
*Purpose: Apex Batch Class for Fetching the CRD from CRD Builder and applying CAG Restructure Logic  
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Amit           25 June'2014       Apex Batch Class for CAG Restructure
*   1.1 -    Abhishek       Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
*======================================================================== 
**/
global class BAC_CB_CAGRestructure implements Database.Batchable < sObject > {
   // private String query;
   // public set<Id > cbonId;
    public string cbonids = '';
    public string query{get;private set;}
    public  set<Id >cbonId{get;private set;}
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
    /**
    * Method :- BAC_CB_CAGRestructure()
    * Description :- Contructor method to start the Batch Process
    **/
    global BAC_CB_CAGRestructure() {
        query = 'SELECT Account_Name__c,Age__c,Aicallout__c,AIRealtime__c,Audit_UI_Link__c,Build__c,builtRealTime__c,CAGRealtime__c,CAG__c,Carrier_ID__c,Case__c,completeChkRealTime__c,complete__c,Conga_Solution_URL__c,ConnectionReceivedId,ConnectionSentId,ControlPlanEffective__c,Control_Plan_Effective__c,Control__c,CRD_RxPlan_ID__c,crd__r.name,CRD__r.Effective_Start_Date__c,CRD__r.Partial_Control_Group__c,CRD__r.Account__c,CRD__r.control__c,CRD__r.Ignored__c,CRD__r.Plan__c,CRD_Salesforce_ID__c,CRD__c,CreatedById,CreatedDate,CurrentStatusCRD__c,CVS__c,Daysforcompletion__c,Description__c,DirectSuccess__c,Effective_date__c,CRD__r.Effective_Date__c,crd__r.PERS_timestamp__c,crd__r.RxPlanID__c,crd__r.status__c,crd__r.Full_Control_Group__c,ExistingRxplan__c,FalloutCase__c,FalloutCase__r.status,FalloutCase__r.Reason,FalloutCase__r.Review_Notes__c,Id,Ignored__c,Invalid__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,PDFRealtime__c,PDF__c,PERSTimeStamp__c,Pers_Full__c,Pers_Key__c,PERS_timestamp__c,PERS__c,Plan__c,Processed__c,Ready_to_Archive__c,Sent_AI_request__c,Sent_to_CVS_Date__c,Status__c,Subsegment__c,Success_Case__c,Success_Case__r.Status,SystemModstamp,validatedRealTime__c,valid__c,What_is_the_carrier__c,XMLRealtime__c,XML__c FROM CRDBuildOrder__c WHERE Build__c = true AND valid__c = true AND complete__c = true AND Aicallout__c = true AND Sent_AI_request__c = true AND PERS__c = false AND CAG__c = false AND XML__c = false AND PDF__c = false AND CVS__c = false  order by  PERSTimeStamp__c desc , createddate desc';
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
    *                It is calling cagRestructure Method from CB_CAGRestructure Class where further processing is done.
    **/
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        //CB_CAGRestructure cagInstance = new CB_CAGRestructure();
        //cagInstance.cagRestructure(scope);
        CB_MultidayProcessHandler processHandler = new CB_MultidayProcessHandler();
        processHandler.processCBONs(scope);
        
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
    
        if(system.label.CRDBuilder_FullAutoMode.equalsIgnoreCase('true')){
           // if(!(cbonId!=null && cbonId.size()>0)){
                CB_BatchOrchestration obj = new CB_BatchOrchestration();
                if(cbonId!=null && cbonId.size()>0){
                    obj.cbonId= cbonId;
                }
                //obj.callNext('Batch_XML');
                 obj.callNext('Batch_Seeds');
            //}
        }
    }
}