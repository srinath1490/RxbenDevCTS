/*
* Completion logic checker for CRD, it will check if all pers report has been processed for builing of the CRD
* and set flag into cRD Builder object
*Modified by Amit Jain for request 5305 on 2nd Dec, 2014
*/
public class CB_Completion {
  
  public boolean hasSucess = true;
  public List<CRD_BuilderFallout__c> failures;
  
  public void execute(List<CRDBuildOrder__c> crdBuilders){
    failures = new List<CRD_BuilderFallout__c>();
    //Map to hold CRD Id to CRD BuildOrder
    Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
    
    //public List<case>lstcasesToInsert = new List<case>();
    Map<Id,Case> mapCrdToSuccessCase = new Map<Id,Case>();
    
    //Populate mapCrdIdsToBuilder = >combination of CRD Id to builder record, this wil be used to identify builder record from crdid
    for(CRDBuildOrder__c builder : crdBuilders){
      mapCrdIdsToBuilder.put(builder.CRD__c, builder);
    }
    
    Set<Id> crdIdsintoError = new Set<Id>();
    
    if(mapCrdIdsToBuilder.size() > 0){
      
      for(CRD__c crd : [Select 
                  id, 
                (Select 
                  Processed__c 
                From 
                  PERSfullReports__r
                Where 
                  Processed__c = false limit 1) 
               From 
                 CRD__c c 
               Where 
                 id  in :mapCrdIdsToBuilder.keyset()]){
        if(crd.PERSfullReports__r.size() > 0){
          //has Error 
          hasSucess = false;
          crdIdsintoError.add(crd.id);
        }else{
          mapCrdIdsToBuilder.get(crd.id).Complete__c = true;
          CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crd.id);
          case successCase = CB_CaseLogger.CreateCaseBuilder('CRD Success'
                                                        ,' CRD has been successfully created'
                                                        ,'CB_Success'
                                                        ,builder.PERS_timestamp__c
                                                        ,builder.Control_Plan_Effective__c
                                                        ,builder.crd__r.Account__c
                                                        ,builder.crd__r.Effective_Date__c
                                                        ,builder.crd__c);
               successCase.status = 'New';//Added by Amit for request 5305                                       
               successCase.CRD_Id__c = crd.id;
               successCase.ControlPlanEffective__c = builder.Control_Plan_Effective__c;
               successCase.PERS_timestamp__c = builder.PERS_timestamp__c;            
          mapCrdToSuccessCase.put(crd.id, successCase);
        }
      }
      
    }
    if(mapCrdToSuccessCase.size() > 0){
        insert mapCrdToSuccessCase.values();
        for(Id crdId : mapCrdToSuccessCase.keyset()){
            mapCrdIdsToBuilder.get(crdid).Success_Case__c = mapCrdToSuccessCase.get(crdId).id;
        }   
    }
    
    update mapCrdIdsToBuilder.values();
    
    Map<Id,Case> mapCrdIdToFalloutCase = new Map<Id,Case>();
    Map<Id,CRD_BuilderFallout__c> mapCrdIdToFalloutRecord = new Map<Id,CRD_BuilderFallout__c>();
    
    //Create fallout case for failed records
    if(crdIdsintoError.size()>0){
      for(Id crdId : crdIdsintoError){
        CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crdid);
        Case falloutCase;
          String falloutDescription = 'CRD is not processed for all provisions ' ;
          if(builder.FalloutCase__c != null){
            //initiate fallout record with existing record Id 
            falloutcase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c
                                                    ,'CRD Builder fallout'
                                                    ,falloutDescription
                                                    ,'CB_Completion'
                                                    ,builder.PERS_timestamp__c
                                                    ,builder.Control_Plan_Effective__c
                                                    ,builder.crd__r.Account__c
                                                    ,builder.crd__r.Effective_Date__c
                                                    ,builder.crd__c);
         }else{
            //Create new instance of fallout record
             falloutcase 
                = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                            ,falloutDescription
                                            ,'CB_Completion'
                                            ,builder.PERS_timestamp__c
                                            ,builder.Control_Plan_Effective__c
                                            ,builder.crd__r.Account__c
                                            ,builder.crd__r.Effective_Date__c
                                            ,builder.crd__c);
          
         }
         falloutCase.CRD_ID__c = crdId;
         mapCrdIdToFalloutCase.put(crdId, falloutCase);
         CRD_BuilderFallout__c falloutRecord;
         falloutRecord = new CRD_BuilderFallout__c();
         falloutRecord.Error_Description__c = falloutDescription;
         falloutRecord.Type__c = 'Save Errors';
         falloutRecord.CRD_Id__c = builder.crd__c;
         falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
         mapCrdIdToFalloutRecord.put(crdId, falloutRecord);
         failures.add(falloutRecord);
      }
    }
    
    upsert mapCrdIdToFalloutCase.values();
    for(Id crdId : mapCrdIdToFalloutCase.keyset()){
      CRDBuildOrder__c builder = mapCrdIdsToBuilder.get(crdid);
      builder.FalloutCase__c = mapCrdIdToFalloutCase.get(crdId).id;
      mapCrdIdToFalloutRecord.get(crdId).CaseId__c = mapCrdIdToFalloutCase.get(crdId).id;
    }
    update crdBuilders;
    upsert mapCrdIdToFalloutRecord.values();
  }

}