/*Purpose: Apex Batch Class to make Create Crd's from Pers Reports
    /*Purpose: Apex Batch Class to make Create Crd's from Pers Reports
        ========================================================================
        History                                                            
        -------                                                            
        VERSION         AUTHOR                DATE                          DETAIL                                 
           1.0      Ankur Aggarwal           5/20/2014       Apex Batch Class to make Create Crd's from Pers Reports
        ======================================================================== */
        global without sharing class Batch_CRDBuildStep_Simulation implements Database.Batchable < sObject > {
            //Class Variables
            //DataType 
            
             global void finish(Database.BatchableContext BC) {
             	//CB_BatchOrchestration obj = new CB_BatchOrchestration();
				//obj.callNext('Batch_ValidateStep');        	
             }

            global Batch_CRDBuildStep_Simulation() {
                

            }
            //Start method for the batch
            global Database.QueryLocator start(Database.BatchableContext bc) {
                //This is the custom iterator as we process all the Pers records based on Control Plan Effective
                string crdbuilderquery = 'select id, createddate,Aicallout__c,AIRealtime__c,Build__c,builtRealTime__c,CAG__c,Case__c,complete__c,completeChkRealTime__c,ControlPlanEffective__c,CRD__c,CurrentStatusCRD__c,CVS__c,ExistingRxplan__c,FalloutCase__c,PDF__c,PDFRealtime__c,PERS__c,Pers_Full__c,PERS_timestamp__c,Processed__c,Success_Case__c,valid__c,validatedRealTime__c,XML__c,XMLRealtime__c from CRDBuildOrder__c where CreatedDate = TODAY AND CreatedBy.Name like \'%Chetan%\' order by Name desc';
                return database.getQueryLocator(crdbuilderquery);
                //return new StringIterator(cpelist);

            }
            /*global Iterable<string> start() {
                list < string > cpelist = new
                list < string > ();
                return new StringIterator(cpelist);
            }*/

            global void execute(Database.BatchableContext BC, List < sobject > scope) {
            	CB_BuildStep processHandler = new CB_BuildStep();
            	processHandler.execute(scope);          
            	  
            }
        }