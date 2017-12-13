global without sharing class Batch_CRDBuildStep1public implements Database.Batchable < sObject > {
            //Class Variables
            //DataType 
            public string crdBuilderquery{get;set;}
             global void finish(Database.BatchableContext BC) {
                CB_BatchOrchestration obj = new CB_BatchOrchestration();
                obj.callNext('Batch_ValidateStep');         
             }

            global Batch_CRDBuildStep1public(string passedquery) {    
                crdBuilderquery = passedquery;
            }
            //Start method for the batch
            global Database.QueryLocator start(Database.BatchableContext bc) {
                //This is the custom iterator as we process all the Pers records based on Control Plan Effective
                
                return database.getQueryLocator(crdBuilderquery);
            }


            global void execute(Database.BatchableContext BC, List < sobject > scope) {
                CB_ContinueAutomation contAutomation = new CB_ContinueAutomation((CRDBuildOrder__c)scope[0]);
                //contAutomation.crdBuilder = (CRDBuildOrder__c)scope[0];
                CRDBuildOrder__c crdbudilder = (CRDBuildOrder__c)scope[0];
                contAutomation.executeProcess(new list<CRD_BuilderFallout__c>(),'',null);
            }
        }