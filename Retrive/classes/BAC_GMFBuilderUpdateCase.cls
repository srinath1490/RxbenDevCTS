/*Purpose: Apex Batch Class to update the Internal Case status after the GMFs have been sent to CVS 
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           3 Aug 2015       Apex Batch Class to update the Internal Case status after the GMFs have been sent to CVS for Req 5919
=================================================================================================*/
global class BAC_GMFBuilderUpdateCase implements Database.Batchable<Sobject>, Schedulable {
    global final string query;
    private static final string SENTGMFCRS = 'sentGMFCRs';
    private static final string CASELABEL = 'Case__c';
    private static final string PROCESSERROR = 'Processing Error';
    private static final string SENTTOCVS = 'Sent To CVS';
    private static final string PARTIALLYSENT = 'Partially Sent';
    private static final string CASEQUERY = 'Select id, status, SentGMFCR__c from Case where status=\'Ready to Send\' and recordtype.name = \'Internal GMF Case\' LIMIT 50000';       
/**
* Method :- BAC_GMFBuilderUpdateCase
* Description :- This method acts as an constuctor to form the query where all cases need to be fetched for their status update
**/       
    global BAC_GMFBuilderUpdateCase(){
         query = CASEQUERY ;
    }
/**
* Method :- start 
* Description :- This method passes the query and fetches the cases accordingly
**/      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
/**
* Method :- execute 
* Description :- This method fetches the count of sent GMFCRs and updates the case status accordingly 
**/     
    global void execute(Database.BatchableContext BC, list<Case> scope){

        list<Case> caseToUpdate = new list<Case>(); // list of internal GMF Cases whose status is to be updated
        map<ID,integer>mapOfCase = new map<ID,integer>();
        map<ID,integer>mapOfCaseAll = new map<ID,integer>();
        
        for(AggregateResult gmfcrAll : [Select count(id) sentGMFCRs,case__c from GMF_Change_Request__c where case__c IN :scope GROUP BY case__c LIMIT 50000]){ 
            mapOfCaseAll.put((ID)gmfcrAll.get(CASELABEL),Integer.valueOf(gmfcrAll.get(SENTGMFCRS))); //creating a map with Case ID as key and SentGMFCR count as value
        }
        
        //aggregate query to fetch the count of successully sent GMFs attached to an internal GMF case
        for(AggregateResult gmfcr : [Select count(id) sentGMFCRs,case__c from GMF_Change_Request__c where CVS__c = true and case__c IN :scope GROUP BY case__c LIMIT 50000]){ 
            mapOfCase.put((ID)gmfcr.get(CASELABEL),Integer.valueOf(gmfcr.get(SENTGMFCRS))); //creating a map with Case ID as key and SentGMFCR count as value
        }

        for(Case caseObj : scope){ // loop on all the queried cases
            integer GMFCRsize = mapOfCaseAll.get(caseObj.id); // getting the count of total GMFCRs attached to an Internal GMF Case
            caseObj.SentGMFCR__c = mapOfCase.get(caseObj.id); // updating the SentGMFCR field with successfully sent GMFs to CVS
            if (!mapOfCase.containsKey(caseObj.id)) {    //updating the case status as per the count of sent GMFs
                caseObj.status = PROCESSERROR ;    //if no GMF is sent to CVS then case status should be Processing Error
                caseObj.SentGMFCR__c = 0;
            } else if(mapOfCase.get(caseObj.id) == GMFCRsize){ //if all the GMFs have been sent to CVS then case status should be Sent To CVS
                caseObj.status = SENTTOCVS;
            } else if (mapOfCase.get(caseObj.id) < GMFCRsize) { //if not all GMFs have been sent to CVS then case status should be Partially Sent
                caseObj.status = PARTIALLYSENT;    
            } else {}
        caseToUpdate.add(caseObj); // creating a list of all the cases that should be updated
        }
        if(caseToUpdate.size() > 0){ //if the case list is not empty, then update it
            Database.update (caseToUpdate,false);
        } else {}
    }
/**
* Method :- finish 
* Description :- No finish actions required
**/     
    global void finish(Database.BatchableContext BC){
    }
/**
* Method :- execute 
* Description :- This method schedules the BAC_GMFBuilderUpdateCase class
**/      
    global void execute(SchedulableContext sc){
        Database.executeBatch(new BAC_GMFBuilderUpdateCase(),50);
    }
}