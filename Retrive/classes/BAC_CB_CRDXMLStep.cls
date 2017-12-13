/*Purpose: Apex Batch Class for Generating XML For CRDs
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
1.0         Sushant         30 April'14         Apex Batch Class for Generating XML For CRDs
1.1         Joognu Rao      09 July'14          Implemented Case Enhancement process
1.2         Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
======================================================================== */

global class BAC_CB_CRDXMLStep implements Database.Batchable <sObject> {
 
// global string query;
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
 global BAC_CB_CRDXMLStep (){
   query = 'Select id,Success_Case__c,name,CRD__c,CAG__c,Case__c,CVS__c,ControlPlanEffective__c,PERSTimeStamp__c,FalloutCase__c,PDF__c,PERS__c,XML__c,crd__r.PERS_timestamp__c,crd__r.Account__c,crd__r.Effective_Date__c,crd__r.Status__c,crd__r.LastSent__c,crd__r.XMLDate_Time_Stamp__c from CRDBuildOrder__c where valid__c = true and Build__c = True and Complete__c = True and PERS__c = True AND CAG__c = TRUE AND XML__c = FALSE AND FalloutCase__c = Null and CRD__r.RxPlanID__c != Null';
 }

 global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(query);
 }
     
 global void execute(Database.BatchableCOntext BC,List <sObject> scope){
      CB_XmlGenerator  xmlGen = new CB_XmlGenerator ();
      xmlGen.xmlGenerator(scope);

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
 }         
  global void finish(Database.BatchableCOntext BC){

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    
      CB_BatchOrchestration obj = new CB_BatchOrchestration(); //Added by Ayushi as part of request 05996
           if(cbonId!=null && cbonId.size()>0){
                obj.cbonId= cbonId;
            }
            system.debug('Inside FIFO');
            obj.callnext('Batch_FIFO');   //Added by Ayushi as part of request 05996
  } 
}