/*Purpose: Apex Batch Class to pick the CBONs for FIFO Tagging  
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Ayushi           12 Aug 2015       Apex Batch Class to pick the CBONs for FIFO Tagging for Req 05996
   1.1 -    Richa            12 Oct 2015       Added Success Case field in the batch query for Req 6124
   1.2 -    Richa            27 Oct 2015       Added Membership Count field in the batch query for Req 6159
   1.3 -    Abhishek         9/7/ 2016         Added a "Has Custom Network" field in Query against ST1299.
=================================================================================================*/ 
global class BAC_FIFOTagging implements Database.Batchable<Sobject>, Schedulable{
    
    private static final string BLANK = '';
    private string cbonids = BLANK;
    public string query{get;private set;}
    public  set<Id >cbonId{get;private set;}
    
/* Method -- setQuery
   Function -- Sets the value of passed string to query string */
         public void setQuery(string s){
                if(s!=null && s!=BLANK){
                    query = s;
                }
            }
/* Method -- setcbonId
   Function -- Sets the value of id passed to cbonId */           
            public void setcbonId(set<id> id){
                if(id!=null && id.size()>0){
                    cbonId = id;
                }
            }
    //global final string query;
    //Set<id> caseSet = new Set<id>();
    //List<id> cBONId = new List<id>();
    private static final string QUERYSTR = 'Select id,Control__c,Plan__c,Subsegment__c,Effective_date__c,PERS_timestamp__c,Success_Case__c,Success_Case__r.FIFO_Tag__c,Success_Case__r.FIFO_record_name__c,Success_Case__r.Membership_Count__c,Success_Case__r.Transaction_Type__c,FalloutCase__c,Case__c,FalloutCase__r.FIFO_Tag__c,FalloutCase__r.Membership_Count__c,Case__r.Has_Custom_Network__c,Case__r.FIFO_Tag__c,CRD__c,CRD__r.National__c,FalloutCase__r.FIFO_record_name__c,Case__r.FIFO_record_name__c,FalloutCase__r.Transaction_Type__c,Case__r.Transaction_Type__c from CRDBuildOrder__c where CreatedDate=today';

/**
* Method :- BAC_FIFOTagging 
* Description :- This method acts as an constructor to form the query where all CBONs need to be fetched
**/      
    global BAC_FIFOTagging(){
        query = QUERYSTR;     
    }
    
/**
* Method :- start 
* Description :- This method passes the query and fetches the CBONs accordingly
**/    
    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
/**
* Method :- execute 
* Description :- This method sets the FIFO tag for the CBONs 
**/    
    global void execute (Database.BatchableContext BC, list<CRDBuildOrder__c> scope){
    CB_FIFO_Tag fIFOtag = new CB_FIFO_Tag();
    FIFOtag.FIFO_Flag_Execute(scope);
    
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
/**
* Method :- finish 
* Description :- This is the finish method
**/    
    global void finish(Database.BatchableContext BC){
                //call the next bactch
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
           }

/**
* Method :- execute 
* Description :- This method schedules the BAC_FIFOTagging class
**/    
     global void execute(SchedulableContext sc) {
        Database.executeBatch(new BAC_FIFOTagging(),200);
    }
    
}