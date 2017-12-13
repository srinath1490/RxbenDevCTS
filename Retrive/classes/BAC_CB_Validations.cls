/**
*Purpose: Apex Batch Class to check CRD completion
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*  1.0      Amit Jain      6/17/2014           Apex Batch Class to check CRD Validation completion
*  1.1      Joognu Rao      7/8/2014           Implemented case enhancement process
*  1.2 -    Abhishek       27 nov'14           #Request 05322 Create option for orchestration of selected module in system
*  1.3      Amit           07/29/15            #Request No 05966(Create a fallout case for CBONs identified with matching Control/ Effective date/Carrier/PSUID)
*========================================================================
**/
global class BAC_CB_Validations implements Database.Batchable <sObject>{   
    // private String query ;
    // public set<Id >cbonId;
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
    * Method :- BAC_CB_Validations()
    * Description :- Contructor method to start the Batch Process
    **/     
    global BAC_CB_Validations() {
          query = 'Select id, FalloutCase__c,CRD__c,crd__r.PERS_timestamp__c,crd__r.ControlPlanEffective__c,valid__c,Processed__c,Build__c,crd__r.Account__c,crd__r.Effective_Date__c From CRDBuildOrder__c where valid__c = False AND Processed__c = False AND Build__c = True AND FalloutCase__c= Null AND Createddate = Today';
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
    *                It is calling validate_CRD Method from CB_Validations Class where further processing is done.
    **/
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        //Declaration of variables
        map<Id, List<CB_Validations.ErrorModel>> mapcrd2errorModel = new map<Id, List<CB_Validations.ErrorModel>>();
        Case existingFalloutCase = new Case(); 
        List<CRD_BuilderFallout__c> lstBuilderFallout = new List<CRD_BuilderFallout__c>();
        Map<Id,Case> mapCrdBuilderIdToFalloutCase = new Map<Id,Case>();      
        Map<Id,CRDBuildOrder__c> mapcrdid2CRDBO = new Map<Id,CRDBuildOrder__c>();
        Set<Id> setCRDID = new Set<Id>();
        List<CRD__c> listValidCRD = new List<CRD__c>();
        String CaseReason;
        boolean bpf = false;                    //commented for reverting ST 1715 by Vatsal
        //Iterate over CRD Record to check for validations and in case of failure create fallout case and CRDBuild Fallout records
        for(SOBJECT s: Scope){
            CRDBuildOrder__c CurrentBOInstance = (CRDBuildOrder__c) s;
            CB_Validations validation = new CB_Validations();
            if(CurrentBOInstance.CRD__c != Null){
                if(validation.validate_CRD(CurrentBOInstance.CRD__c,bpf)){            //commented for reverting ST 1715 by Vatsal - added bpf
                    //Add the Valid CRD's in a set, and later update the Valid flag on these CRD's
                    setCRDID.add(CurrentBOInstance.CRD__c);
                    
                }
                else {                      
                    //Add the errors add in mapcrderrors
                    mapcrd2errorModel.put(CurrentBOInstance.CRD__c,validation.errordescription);                   
                    //Check for fallout Case
                    //Added by Amit on 8 August, 2015 for Support Ticket 195 to show different Case Reasons
                    CaseReason = 'CB_Validation';
                    /* Commented for Request 06923
                    for(CB_Validations.ErrorModel error : validation.errordescription){
                        if(error.errorcode == 'ERR0294'){
                            CaseReason = 'CRD Requires Fallout';
                        }                                           
                    }
                    */
                    //Ends
                      if(CurrentBOInstance.FalloutCase__c!=null){
                          //Update existing fallout case
                          existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CurrentBOInstance.FalloutCase__c
                                                                         ,'CRD Builder fallout'
                                                                         ,'Custom validation failure,could be because of mapping or PERS issues(i.e. for a CPE, pers sent us incomplete set of BPLVs)'
                                                                         ,CaseReason
                                                                         ,CurrentBOInstance.crd__r.PERS_timestamp__c
                                                                         ,CurrentBOInstance.crd__r.ControlPlanEffective__c
                                                                         ,CurrentBOInstance.crd__r.Account__c
                                                                         ,CurrentBOInstance.crd__r.Effective_Date__c
                                                                         ,CurrentBOInstance.crd__c);//Richa added on 15/07
                      }else{            
                          //create new fallout case                           
                          existingFalloutCase = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                                                         ,'Custom validation failure,could be because of mapping or PERS issues (i.e. for a CPE, pers sent us incomplete set of BPLVs)'
                                                                         ,CaseReason
                                                                         ,CurrentBOInstance.crd__r.PERS_timestamp__c
                                                                         ,CurrentBOInstance.crd__r.ControlPlanEffective__c
                                                                         ,CurrentBOInstance.crd__r.Account__c
                                                                         ,CurrentBOInstance.crd__r.Effective_Date__c
                                                                         ,CurrentBOInstance.crd__c);//Richa added on 15/07
                          
                      }
                      
                    
                      //Add the CRDbuilder Record Id and Fallout case to the map
                      mapCrdBuilderIdToFalloutCase.put(CurrentBOInstance.id,existingFalloutCase);
                      mapcrdid2CRDBO.put(CurrentBOInstance.CRD__c,CurrentBOInstance);                   
                }
            }
        // code for CRDB Monitoring starts - Sandeep Saklani
            CB_CRDBMonitor.CalculateStatus(BC.getJobId());
        // code for CRDB Monitoring ends - Sandeep Saklani
        }
            upsert mapCrdBuilderIdToFalloutCase.values();
            
        //Update the new created fallout cases to CRDBuild order records
        for(SOBJECT s: Scope){
            CRDBuildOrder__c crdBORecord = (CRDBuildOrder__c) s;
            if(mapCrdBuilderIdToFalloutCase.containsKey(crdBORecord.Id)){   
                crdBORecord.FalloutCase__c = mapCrdBuilderIdToFalloutCase.get(crdBORecord.Id).id;
                crdBORecord.valid__c = false;
            }else{
                crdBORecord.valid__c = true;
            }
        }
            update Scope;
            
        //Create CRDBuild Fallout record for every error message 
        for(Id validationFailedCRD : mapcrd2errorModel.keyset()){                 
            for(CB_Validations.ErrorModel err : mapcrd2errorModel.get(validationFailedCRD)){                    
                //create CRD Builder Fallout Record   
                    CRD_BuilderFallout__c builderFallout = new CRD_BuilderFallout__c(CaseId__c=mapcrdid2CRDBO.get(validationFailedCRD).FalloutCase__c
                                                                                     ,CRD_Id__c=validationFailedCRD
                                                                                     ,Error_Description__c=err.errormessage
                                                                                     ,Field__c= err.field
                                                                                     ,Error_Code__c = err.errorcode
                                                                                     ,PERS_Timestamp__c = mapcrdid2CRDBO.get(validationFailedCRD).crd__r.PERS_timestamp__c
                                                                                     ,Type__c ='Validation'
                                                                                    );                    
                    lstBuilderFallout.add(builderFallout);                
            }   
            
        }  
            insert lstBuilderFallout;
            
        //Query the CRD's and update the valid filed on them
        for(CRD__c currentCRD : [Select Id,Name, Valid__c from CRD__C where id In: setCRDID]){
            currentCRD.valid__c = True;
            listValidCRD.add(currentCRD);
        }   
            update listValidCRD;
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
            //if(!(cbonId!=null && cbonId.size()>0)){
                CB_BatchOrchestration obj = new CB_BatchOrchestration();
                if(cbonId!=null && cbonId.size()>0){
                       obj.cbonId= cbonId;
                }
                obj.callNext('Batch_CompleteStep');    
            //}
        }    
    }
}