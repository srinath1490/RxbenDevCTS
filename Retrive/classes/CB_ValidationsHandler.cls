/**
*Purpose: Global apex class for common apex validation methods .                                         
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR                 DATE                    DETAIL                                 

*1.0 -   Joognu Rao            8th July          Global apex class for common apex validation methods and Continue Automation Process
*2.0     Amit                  07/29/15            #Request No 05966(Create a fallout case for CBONs identified with matching Control/ Effective date/Carrier/PSUID)
*======================================================================== 
**/
public with sharing class CB_ValidationsHandler{
    
    public List<CRD_BuilderFallout__c> lstBuilderFallout;
    
    public void executeValidation(List < sObject > scope){
    
        //Declaration of variables
        map<Id, List<CB_Validations.ErrorModel>> mapcrd2errorModel = new map<Id, List<CB_Validations.ErrorModel>>();
        Case existingFalloutCase = new Case(); 
        lstBuilderFallout = new List<CRD_BuilderFallout__c>();
        Map<Id,Case> mapCrdBuilderIdToFalloutCase = new Map<Id,Case>();      
        Map<Id,CRDBuildOrder__c> mapcrdid2CRDBO = new Map<Id,CRDBuildOrder__c>();
        Set<Id> setCRDID = new Set<Id>();
        List<CRD__c> listValidCRD = new List<CRD__c>();
        String CaseReason= Null;
        Boolean bypassPlanFallout = False;
        Boolean bpf = True;                //added by VP for ST 1715
        //Iterate over CRD Record to check for validations and in case of failure create fallout case and CRDBuild Fallout records
        for(SOBJECT s: Scope){
            CRDBuildOrder__c CurrentBOInstance = (CRDBuildOrder__c) s;
            CB_Validations validation = new CB_Validations();
            system.debug('JR***'+CurrentBOInstance+'******'+CurrentBOInstance.CRD__c );
            if(CurrentBOInstance.CRD__c != Null){
                if(validation.validate_CRD(CurrentBOInstance.CRD__c,bpf)){            //edited by VP for ST 1715 - added bpf
                    //Add the Valid CRD's in a set, and later update the Valid flag on these CRD's
                    setCRDID.add(CurrentBOInstance.CRD__c);
                    CurrentBOInstance.valid__c = true;
                }
                else {     
                                    
                    //Add the errors add in mapcrderrors
                    mapcrd2errorModel.put(CurrentBOInstance.CRD__c,validation.errordescription);
                    //Check for fallout Case
                    //Added by Amit on 8 August, 2015 for Support Ticket 195 to show different Case Reasons
                    CaseReason = 'CB_Validation';
                    /* Commented for Request 06329
                    for(CB_Validations.ErrorModel error : validation.errordescription){
                        if(error.errorcode == 'ERR0294'){
                            CaseReason = 'CRD Requires Fallout';
                        }                                           
                    }
                    //Ends
                    */
                      if(CurrentBOInstance.FalloutCase__c!=null){
                          //Update existing fallout case
                          bypassPlanFallout = true;
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
        }
            upsert mapCrdBuilderIdToFalloutCase.values();
            
        //Update the new created fallout cases to CRDBuild order records
        for(SOBJECT s: Scope){
            CRDBuildOrder__c crdBORecord = (CRDBuildOrder__c) s;
            if(mapCrdBuilderIdToFalloutCase.containsKey(crdBORecord.id)){
                crdBORecord.FalloutCase__c = mapCrdBuilderIdToFalloutCase.get(crdBORecord.Id).id;
            }
        }
            update Scope;
            
        //Create CRDBuild Fallout record for every error message 
        System.debug('########1' +CaseReason);
        System.debug('########2' +bypassPlanFallout);        
        for(Id validationFailedCRD : mapcrd2errorModel.keyset()){                          
            for(CB_Validations.ErrorModel err : mapcrd2errorModel.get(validationFailedCRD)){ 
                System.debug('########3' +err.errorcode); 
                if(bypassPlanFallout == True && err.errorcode !='ERR0294'){   
                     CRD_BuilderFallout__c builderFallout = new CRD_BuilderFallout__c(CaseId__c=mapcrdid2CRDBO.get(validationFailedCRD).FalloutCase__c
                                                                                 ,CRD_Id__c=validationFailedCRD
                                                                                 ,Error_Description__c=err.errormessage
                                                                                 ,Field__c= err.field
                                                                                 ,Error_Code__c = err.errorcode
                                                                                 ,PERS_Timestamp__c = mapcrdid2CRDBO.get(validationFailedCRD).crd__r.PERS_timestamp__c
                                                                                 ,Type__c ='Validation'
                                                                                );                                                                       
                    lstBuilderFallout.add(builderFallout);                        
                }else if(bypassPlanFallout == false){                    
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
        }  
            insert lstBuilderFallout;
        
        //Query the CRD's and update the valid filed on them
        for(CRD__c currentCRD : [Select Id,Name, Valid__c from CRD__C where id In: setCRDID]){
            currentCRD.valid__c = True;
            listValidCRD.add(currentCRD);
        }   
            update listValidCRD;
    }
}