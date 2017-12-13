/*Purpose: Apex Batch Class to make Create Crd's from Pers Reports
    /*Purpose: Apex Batch Class to make Create Crd's from Pers Reports
        ========================================================================
        History                                                            
        -------                                                            
        VERSION         AUTHOR                DATE                          DETAIL                                 
           1.0      Ankur Aggarwal           5/20/2014       Apex Batch Class to make Create Crd's from Pers Reports
           1.1 -    Abhishek       Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
        ======================================================================== */
        global without sharing class Batch_CRDBuildStep1 implements Database.Batchable < sObject > {
            //Class Variables
            //DataType 
             public string query{get;private set;}
             public  set<Id >cbonId{get;private set;}
             public string cbonids = '';
             global void finish(Database.BatchableContext BC) {

                if(system.label.CRDBuilder_FullAutoMode.equalsIgnoreCase('true')){
                   // if((cbonId!=null && cbonId.size()>0)){
                
                    // code for CRDB Monitoring starts - Sandeep Saklani
                        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
                    // code for CRDB Monitoring ends - Sandeep Saklani
                    
                        CB_BatchOrchestration obj = new CB_BatchOrchestration();
                        if(cbonId!=null && cbonId.size()>0){
                            obj.cbonId= cbonId;
                        }
                        obj.callNext('Batch_ValidateStep');  
                    //}
                }       
             }
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
            global Batch_CRDBuildStep1() {   
                 //This is the custom iterator as we process all the Pers records based on Control Plan Effective
                 query = 'select id, createddate,Aicallout__c,AIRealtime__c,Build__c,builtRealTime__c,CAG__c,Case__c,complete__c,completeChkRealTime__c,ControlPlanEffective__c,CRD__c,CurrentStatusCRD__c,CVS__c,ExistingRxplan__c,FalloutCase__c,PDF__c,PDFRealtime__c,PERS__c,Pers_Full__c,PERS_timestamp__c,Processed__c,Success_Case__c,valid__c,validatedRealTime__c,XML__c,XMLRealtime__c from CRDBuildOrder__c where Build__c = false and createddate = today   and FalloutCase__c = null and Processed__c = false and Carrier_ID__c!= Null';
            }
            
            //Start method for the batch
            global Database.QueryLocator start(Database.BatchableContext bc) {
                return database.getQueryLocator(query);
            }

            global void execute(Database.BatchableContext BC, List < sobject > scope) {
                CB_BuildStep processHandler = new CB_BuildStep();
                processHandler.execute(scope);          

            // code for CRDB Monitoring starts - Sandeep Saklani
                CB_CRDBMonitor.CalculateStatus(BC.getJobId());
            // code for CRDB Monitoring ends - Sandeep Saklani
            }
        }