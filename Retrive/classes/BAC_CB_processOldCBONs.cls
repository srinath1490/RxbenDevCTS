/*Purpose: Apex Batch Class to process old CBONs  
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           26 Nov'2014       Apex Batch Class to process old CBONs for Req 5281
=================================================================================================*/ 
global class BAC_CB_processOldCBONs implements Database.Batchable <sObject>, Database.Stateful{
    String query;
    Datetime days = Datetime.now();
    set<string> existingCPE = new set <string>();
    list<CRDBuildOrder__c> ignoreCBONs = new list <CRDBuildOrder__c>();
    global set<Id> processCBONs = new set <Id>();
    global map<string,CRDBuildOrder__c> cpeWithPers = new map <string,CRDBuildOrder__c>();
    
    /**
    * Method :- BAC_CB_processOldCBONs 
    * Description :- This method acts as an constuctor to form the query where all unprocessed CBONs need to be fetched
    **/
    global BAC_CB_processOldCBONs(){
        days = days.addDays(-Integer.valueOf(System.label.CB_NoOfDays)); 
        //Query which fetches all the unprocessed CBONS in the last System.label.CB_NoOfDays days
        query = 'Select id,FalloutCase__c,Processed__c,PERS_timestamp__c,validatedRealTime__c,Success_Case__c,CRD__r.Name,CRD__r.CRD_Automated__c,CRD__r.PERS_timestamp__c,valid__c,builtRealTime__c ,Control_Plan_Effective__c,completeChkRealTime__c ,complete__c,AIRealtime__c ,CRD__r.ControlPlanEffective__c, CRD__r.Control__c,CAGRealtime__c,Aicallout__c,XML__c,XMLRealtime__c,PDF__c,PDFRealtime__c,Success_Case__r.Fallout_Reason__c, FalloutCase__r.Fallout_Reason__c, Build__c,PERS__c, CAG__c,Sent_AI_request__c,CRD__r.Plan__c,CRD__r.Effective_Date__c,crd__r.Effective_Start_Date__c,CRD__r.RxPlanID__c,CRD__r.Y_Schd__c,ControlPlanEffective__c,CRD__r.Account_Name__c,CRD__r.Account__c,case__c,case__r.casenumber,FalloutCase__r.CaseNumber,CVS__c,crd__c,FalloutCase__r.status,PERStimestamp__c,Ignored__c From CRDBuildOrder__c where Control_Plan_Effective__c <> null AND PERS_timestamp__c <> null AND Processed__c = false AND Build__c = false AND CreatedDate >= ' + days.format('yyyy-MM-dd')+'T'+ days.format('HH:mm')+':00.000Z' + ' order by Control_Plan_Effective__c,PERS_timestamp__c DESC' ;
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
    * Description :- This method processes all the CBONs whether they have to be processed or ignored
    **/
    global void execute (Database.BatchableContext BC, list<CRDBuildOrder__c> scope){
    
        
        for(CRDBuildOrder__c lstOfCBON : scope){
            existingCPE.add(lstOfCBON.Control_Plan_Effective__c); //Collection of all the CPEs which are to be processed
        }
        
        String tempCPE = 'null';
        //Querying processed CBONS in descending order of PERStimestamp
        for(CRDBuildOrder__c CBON : [Select id,Build__c,Control_Plan_Effective__c,PERS_timestamp__c,Processed__c 
                                        from 
                                    CRDBuildOrder__c 
                                        where 
                                    (Processed__c = true OR Build__c = true) 
                                            AND 
                                        Control_Plan_Effective__c IN :existingCPE 
                                        order by 
                                    Control_Plan_Effective__c,PERS_timestamp__c DESC]){
            if(!tempCPE.equals(CBON.Control_Plan_Effective__c)){
                cpeWithPers.put(CBON.Control_Plan_Effective__c,CBON); //Collection of the processed CBONs with their CPE as the key and CBON with the latest PERStimestamp as the value
                tempCPE = String.valueOf(CBON.Control_Plan_Effective__c);
            }    
        }
        
        tempCPE = 'null';
        //picking all the unprocessed CBONs and segregating them whether they should be processed or ignored
        for(CRDBuildOrder__c CBONtoBeProcessed : scope){
            if(!cpeWithPers.isEmpty() && cpeWithPers.containskey(CBONtoBeProcessed.Control_Plan_Effective__c)){//checks whether the unprocessed CBON has any processed CBON with same cpe
                //checks if the unproccesed CBON has the latest PERStimestamp or the processed one
                if(CBONtoBeProcessed.PERS_timestamp__c > (cpeWithPers.get(CBONtoBeProcessed.Control_Plan_Effective__c).PERS_timestamp__c) 
                        && !tempCPE.equals(String.valueOf(CBONtoBeProcessed.Control_Plan_Effective__c))){
                    processCBONs.add(CBONtoBeProcessed.id); //adding the CBONs which are to be processed
                    tempCPE = String.valueOf(CBONtoBeProcessed.Control_Plan_Effective__c);    
                } else { //unprocessed CBONs with older PERStimestamp
                           CBONtoBeProcessed.Ignored__c = true;
                           CBONtoBeProcessed.Build__c = true;
                           CBONtoBeProcessed.valid__c = true;
                           CBONtoBeProcessed.complete__c = true;
                           CBONtoBeProcessed.Aicallout__c = true;
                           CBONtoBeProcessed.Sent_AI_request__c = true;
                           CBONtoBeProcessed.PERS__c = true;
                           CBONtoBeProcessed.CAG__c = true;
                           CBONtoBeProcessed.XML__c = true;
                           CBONtoBeProcessed.PDF__c = true;
                           CBONtoBeProcessed.CVS__c = true;
                           ignoreCBONs.add(CBONtoBeProcessed);  //adding the CBONs which are to be ignored 
                       }    
            } else { //no CBON with the same cpe has been processed earlier
                       if(!tempCPE.equals(String.valueOf(CBONtoBeProcessed.Control_Plan_Effective__c))){ //latest PERStimestamp CBON added in the processCBON list
                           processCBONs.add(CBONtoBeProcessed.id); //adding the CBONs which are to be processed
                           tempCPE = String.valueOf(CBONtoBeProcessed.Control_Plan_Effective__c); 
                       } else { //unprocessed CBONs with older PERStimestamp
                                   CBONtoBeProcessed.Ignored__c = true;
                                   CBONtoBeProcessed.Build__c = true;
                                   CBONtoBeProcessed.valid__c = true;
                                   CBONtoBeProcessed.complete__c = true;
                                   CBONtoBeProcessed.Aicallout__c = true;
                                   CBONtoBeProcessed.Sent_AI_request__c = true;
                                   CBONtoBeProcessed.PERS__c = true;
                                   CBONtoBeProcessed.CAG__c = true;
                                   CBONtoBeProcessed.XML__c = true;
                                   CBONtoBeProcessed.PDF__c = true;
                                   CBONtoBeProcessed.CVS__c = true;
                                   ignoreCBONs.add(CBONtoBeProcessed);  //adding the CBONs which are to be ignored    
                               }   
                    }
        }
        if(!ignoreCBONs.isEmpty()){
            database.update (ignoreCBONs); //set the Ignored flag of the relevant CBONs to true
        }
    }
    
    /**
    * Method :- finish 
    * Description :- This method sends all the relevant CBONs for processing by calling the orchestration class
    **/
    global void finish (Database.BatchableContext BC){
        if(!processCBONs.isEmpty()){ //process the relevant CBONs by calling the CRD builder batches through orchestration class
            CB_BatchOrchestration orchBatch = new CB_BatchOrchestration();
            orchBatch.cbonid = processCBONs;
            orchBatch.callNext('Batch_CRDBuildStep');
        }
    }
}