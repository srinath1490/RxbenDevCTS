/**
*Purpose: Apex Batch Class for Fetching the CRD from CRD Builder and applying CAG Restructure Logic  
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*1.0 -    Amit           25 April'14      CRD Builder- Step 3, creating PERSupdate records from CRD Build Order Object
*1.1 -    Joognu Rao     09 July'14       Implemented Case Enhancement process
*2.0      Amit          25 Nov, 2015            Added logic to Format control to 7 digit for Pers Seed, ST# 497
*3.0      Toshi          03 Oct, 2016        Added logic to close the success case of CBON, for which the RxPlanId exist.
*======================================================================== 
**/
public with sharing class CB_SeedPersStep {
    //Varible Declaration
    
    public List<CRD_BuilderFallout__c> failures;
    PRIVATE STATIC FINAL STRING EXISTINGRXPLANID = 'Existing RxPlanID';
    PRIVATE STATIC FINAL STRING SAVEERRORS = 'Save Errors';
    /**
* Method :- seedStep(List < CRDBuildOrder__c > scope)
* Description :- Method to create Pers Seed records and in case of error create Error Log Records
**/   
    public void seedStep(List < CRDBuildOrder__c > scope){
        //list < PERS_Seed__c > lstPersupdate = new list < PERS_Seed__c > ();
        map<string,PERS_Seed__c> mapPersUpdate = new map<String,PERS_Seed__c>();
        Set<String> rxPlan2CVS = new Set<String>();
        PERS_Seed__c newPERSRow = new PERS_Seed__c();
        //Iterate over Scope
        //Map: CaseId => CrdBuilder Record, this will help to retrieve CRD Builder records from External case pushed to Sharing
        Map<Id,CRDBuildOrder__c> mapCrdIdCrdBuilderRecord = new Map<Id,CRDBuildOrder__c>();
        for (CRDBuildOrder__c s: Scope) {
            CRDBuildOrder__c currentBuildOrder = (CRDBuildOrder__c) s;
            if (currentBuildOrder.CRD__c != null) {
                rxPlan2CVS.add(currentBuildOrder.CRD__r.RxPlanId__c);
                mapCrdIdCrdBuilderRecord.put(currentBuildOrder.CRD__c, currentBuildOrder);
                newPERSRow = new PERS_Seed__c();
                newPERSRow.crd__c = currentBuildOrder.CRD__c;
                newPERSRow.RxplanID__c = currentBuildOrder.CRD__r.RxPlanID__c;
                newPERSRow.Control__c =  GC_Utils_Method.calculateControl(currentBuildOrder.CRD__r.Control__c);//Modified by Amit for ST# 497              
                newPERSRow.Plan__c = currentBuildOrder.CRD__r.Plan__c;
                newPERSRow.EffectiveDate__c = currentBuildOrder.CRD__r.Effective_Date__c;
                newPERSRow.Yschedule__c = currentBuildOrder.CRD__r.Y_Schd__c;
                newPERSRow.SentToDS__c = false;
                newPERSRow.Fallout__c = false;
                //newPERSRow.cfo__c= currentBuildOrder.CRD__r.cfo;
                newPERSRow.Key__c = ( newPERSRow.RxplanID__c != null ? newPERSRow.RxplanID__c : '') 
                                    + (newPERSRow.Control__c != null ? newPERSRow.Control__c : '')
                                    + (newPERSRow.Plan__c != null ? newPERSRow.Plan__c : '')
                                    + (newPERSRow.EffectiveDate__c != null ? DateTime.newInstance(newPERSRow.EffectiveDate__c, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy') : '');
                //newPERSRow.cfo__c= currentBuildOrder.CRD__r.cfo;
                //lstPersupdate.add(newPERSRow);
                mapPersUpdate.put(newPERSRow.Key__c,newPERSRow);
            }
            currentBuildOrder.PERS__c = True;
        }           
        
        
        //Map : Crd builder Record Id => fallout caseId
        Map<Id,Case> mapCrdBuilderIdToFalloutCase = new Map<Id,Case>();
        //Map : Crd builder Record Id => Crd builder Fallout records
        Map<Id,List<CRD_BuilderFallout__c>> mapCrdBuilderIdToFalloutRecord = new Map<Id,List<CRD_BuilderFallout__c>>();
        Map<Id,CRDBuildOrder__c> mapCrdBuilderRecrods = new Map<Id,CRDBuildOrder__c>();
        
        //Upsert PERS Seed  records
        Database.UpsertResult[] srList = Database.upsert(mapPersUpdate.values(),PERS_Seed__c.fields.Key__c , false);
        failures = new List<CRD_BuilderFallout__c>();
        Integer index = 0;
        //Loop over save result and do -> 1. Set CRD Builder.CVS = true , Or 2. Create Fallout case
        for(Database.UpsertResult saveResult : srList){
            PERS_Seed__c persSeedRecord = mapPersUpdate.values()[index];
            CRDBuildOrder__c crdBuilderRecord = mapCrdIdCrdBuilderRecord.get(persSeedRecord.crd__c);
            mapCrdBuilderRecrods.put(crdBuilderRecord.id, crdBuilderRecord);
            crdBuilderRecord.PERS__c = false;
            crdBuilderRecord.Processed__c = false;
            //If sharing record is saved successfully set CVS flag true for related CRDBuilder record
            if(saveResult.isSuccess()){
                //set CRD Builder's CVS flag = true
                crdBuilderRecord.PERS__c = true;
            }else{
              //Create fallout case for failed record   
              Case falloutCase;
              String falloutDescription = 'Send to CVS failure, these will be assigned to BCT. ' 
                                         + ' Users will need navigate to the external case given on '
                                         + ' the fallout case and send it to CVS manually' ;
              if(crdBuilderRecord.FalloutCase__c != null){
                //initiate fallout record with existing record Id 
                falloutcase = CB_CaseLogger.CreateCaseBuilder(crdbuilderrecord.falloutcase__c
                                                                ,'CRD Builder fallout'
                                                                ,falloutDescription
                                                                ,'CB_PERSSEED'
                                                                ,crdbuilderrecord.PERSTimeStamp__c
                                                                ,crdbuilderrecord.ControlPlanEffective__c
                                                                ,crdbuilderrecord.crd__r.Account__c
                                                                ,crdbuilderrecord.crd__r.Effective_Date__c
                                                                ,crdbuilderrecord.crd__c);
              }else{
                //Create new instance of fallout record
                falloutcase 
                        = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                                            ,falloutDescription
                                                            ,'CB_PERSSEED'
                                                            ,crdbuilderrecord.PERSTimeStamp__c
                                                            ,crdbuilderrecord.ControlPlanEffective__c
                                                            ,crdbuilderrecord.crd__r.Account__c
                                                            ,crdbuilderrecord.crd__r.Effective_Date__c
                                                            ,crdbuilderrecord.crd__c);
                
              }
              mapCrdBuilderIdToFalloutCase.put(crdBuilderRecord.id, falloutCase);
                //saveResult.getErrors();
              CRD_BuilderFallout__c falloutRecord;
              for(DataBase.Error err : saveResult.getErrors()){
                //populate fields of fallout case generated 
                falloutRecord = new CRD_BuilderFallout__c();
                falloutRecord.Error_Description__c = err.getMessage();
                falloutRecord.Type__c = SAVEERRORS;
                falloutRecord.CRD_Id__c = crdBuilderRecord.crd__c;
                falloutRecord.PERS_Timestamp__c = crdbuilderRecord.PERSTimeStamp__c;
                failures.add(falloutRecord);
                //fetch values of crd builder fallout record on basis of crd builder record id
                if(mapCrdBuilderIdToFalloutRecord.containsKey(crdBuilderRecord.id)){
                    mapCrdBuilderIdToFalloutRecord.get(crdBuilderRecord.id).add(falloutRecord);
                }else{
                    mapCrdBuilderIdToFalloutRecord.put(crdBuilderRecord.id, new List<CRD_BuilderFallout__c>{falloutRecord} );
                }
              } 
            }
            index ++;
        }   
        
        database.upsert(mapCrdBuilderIdToFalloutCase.values());
        //iterate to fetch values for crd builder fallouts and populate value for fallout case and case id
        for(Id crdBuilderRecordId : mapCrdBuilderIdToFalloutCase.keyset()){
            CRDBuildOrder__c crdBuilderRecord = mapCrdBuilderRecrods.get(crdBuilderRecordId);
            crdBuilderRecord.FalloutCase__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
            for(CRD_BuilderFallout__c falloutRecord : mapCrdBuilderIdToFalloutRecord.get(crdBuilderRecordId)){
                falloutRecord.CaseId__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
            }
        }
        
        database.insert(failures);    
        
     existingRxPlanIdCheck(mapCrdIdCrdBuilderRecord,rxPlan2CVS);
        
        database.update(scope);
    }
    
    /*Method: existingRxPlanIdCheck*/
    public void existingRxPlanIdCheck(Map<Id,CRDBuildOrder__c> mapCrdIdCrdBuilderRecord, Set<String> rxPlan2CVS){
        Set<String> existingRxPlanIds = new Set<String>();
        List<CVSRxPlanId__c>  cvsRxPlanIdList = new List<CVSRxPlanId__c>();
        Set<ID> crdWithExistingRxPlan = new Set<ID>(); 
        List<CRD__c> listCRDStatusUpdate = new List<CRD__c>();
        Set<Id> setSucessCaseId = new Set<Id>();
        List<Case> listSuccessCaseToClosed = new List<Case>();


        //Fetch all the records from CVSRxPlanId object and put them in a map
         for(CVSRxPlanId__c currentCVS : [Select Id,Name, RxPlanId__c from CVSRxPlanId__c Where RxPlanId__c In: rxPlan2CVS LIMIT 10000]){ 
             existingRxPlanIds.add(currentCVS.RxPlanId__c);       
         }  
            
         for(CRDBuildOrder__c builder : mapCrdIdCrdBuilderRecord.Values()){                
                  if(existingRxPlanIds.contains(builder.CRD__r.RxPlanID__c)){
                      builder.PDF__c = True;
                      builder.XML__c = True;
                      builder.CVS__c = True;
                      builder.ExistingRxplan__c = True;
                      crdWithExistingRxPlan.add(builder.CRD__c);
                       // Added for 6696
                     if(builder.Success_Case__c!=NULL)
                      setSucessCaseId.add(builder.Success_Case__c);
                  }else{ 
                      //Add new CVSRxPlanId Record to the list                
                       cvsRxPlanIdList.add(new CVSRxPlanId__c(RxPlanId__c = builder.CRD__r.RxPlanID__c , CRD_Name__c = builder.CRD__r.Name ));            
                  }
                  existingRxPlanIds.add(builder.CRD__r.RxPlanID__c);
                  
                }
                
            // Added below code for story n0:06696, by toshi
            if(setSucessCaseId!=null && setSucessCaseId.size()>0){
            List<Case> sucessCaseList = [Select id,Status from case where Id IN:setSucessCaseId limit 49000];
                for(Case successCaseObj:sucessCaseList){
                    successCaseObj.Status = 'Closed';
                    listSuccessCaseToClosed.add(successCaseObj);
                }
            }
            
            if(listSuccessCaseToClosed!=null && listSuccessCaseToClosed.size()>0){
                database.update(listSuccessCaseToClosed);
            }
            
            if(cvsRxPlanIdList.size()>0)
            {database.insert(cvsRxPlanIdList); }
            if(crdWithExistingRxPlan.size()>0){
                for(CRD__c crdRecord: [Select Id,Name, Status__c from CRD__c where Id in: crdWithExistingRxPlan LIMIT 80000]){
                    crdRecord.status__c = EXISTINGRXPLANID;
                    listCRDStatusUpdate.add(crdRecord);
                }
            }   
                database.update(listCRDStatusUpdate); 
            return;       
        }
}