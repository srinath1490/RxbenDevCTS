/*Purpose: Apex Batch Class to for CAG restructure process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            10/14/2014      This class finds the PCG based on ControlPlan of CRD and creates CSAP junction with matching CRD criteria.
                                            Also, is it used for CRD archiving functionality.
                                            After the CAG process is complete it will create entry in RxplanId table if CRD is having a new RxPlanId
   2.0     Amit             23 Jan 2015     Modified for request 05472, the CRD status will be updated to 'Existing RxPlanID'
                                            when the CBON status is set to ExistingExPlan
                                            
   3.0     Joognu Rao       16 Jan 2015     Implemented request no 05549
   4.0     Abhishek Goel    5/1/2015        Implemented Ticket no 015.
   4.1     Amit Jain        25th Aug,2015   Added Rollback statement and Instant creation of record in CVS table when processing single CBON, ST# 277
   4.2     Amit Jain        11 Feb 2016     Modified to add logic to create CSAP Junction records for Plans with same effective Date in same batch, ST# 015
======================================================================== */
public class CB_CAGRestructure {
    /*
    private string csapCRD2FCG;
    private String csapCRD2PCG;
    Public String crdName;
    public set<id> caseToUpdate = new set<id>();
    public static list<case> caseUpdateList = new list<case>();
    public List<CRD_BuilderFallout__c> failureRecords;
    public boolean exceptionMessage;
    Set<String> rxPlan2CVS = new Set<String>();
    Map<Id,CRD_BuilderFallout__c> mapbuilderIdWithFallout = new Map<Id,CRD_BuilderFallout__c>();
    List<CVSRxPlanId__c> listCVS = new List<CVSRxPlanId__c>();
    Map<string,string>mapCrdTorxplanId = new Map<string,string>();
    public List<CRDBuildOrder__c> listCRDBuildOrder4CVS ;
    CVSRxPlanId__c newRecord = new CVSRxPlanId__c();
    Set<String> setRxplanid = new Set<String>();
    boolean hasError= False;
    List<Error_log__c> errList = new List<Error_log__c>();
    public void cagRestructure(List<CRDBuildOrder__c> listCRDBuildOrder){
    Savepoint sp = Database.setSavepoint(); 
    try{       
        failureRecords = new List<CRD_BuilderFallout__c>();
        listCRDBuildOrder4CVS = new List<CRDBuildOrder__c>();
        exceptionMessage = False;
        //Select Record Type where Name is Full CG to Partial CG
        for(RecordType rtName : [Select Id,Name from RecordType where SobjectType = 'CSAP_CGLP_Junction__c' ]){
            if(rtName.Name == 'CRD to Full CG'){
                csapCRD2FCG = rtName.Id;
            }else if (rtName.Name == 'CRD to Partial CG'){
                csapCRD2PCG = rtName.Id;
            }
        }
        
        Map<String, List<CRDBuildOrder__c>> mapControlPlansToBuilders = new Map<String, List<CRDBuildOrder__c>>();
        Map<Id,CRDBuildOrder__c> mapCrdIdToBuilder = new Map<Id,CRDBuildOrder__c>();
                    
      for(CRDBuildOrder__c builder : listCRDBuildOrder){
            listCRDBuildOrder4CVS.add(builder);
          
            String cpKey;
            if(builder.CRD__r.Control__c!= Null && builder.CRD__r.Control__c!= '' && builder.CRD__r.Plan__c!=Null && builder.CRD__r.Plan__c!=''){
                    cpKey = GC_Utils_Method.calculateControl(builder.CRD__r.Control__c) + builder.CRD__r.Plan__c;
            }          

            //Add RxPlan Id of CRDBuildOrder CRD in a set
            rxPlan2CVS.add(builder.CRD__r.RxPlanId__c);
            if(mapControlPlansToBuilders.containsKey(cpKey)){
                mapControlPlansToBuilders.get(cpKey).add(builder);
            }else{
                mapControlPlansToBuilders.put(cpKey, new List<CRDBuildOrder__c>{ builder});
            }
            mapCrdIdToBuilder.put(builder.crd__c, builder);
        }
        Map<Id,CRD__c> mapCRDs = new Map<Id,CRD__c>();
        Map<String,Partial_Control_Group__c> mapControlPlantoPCG = new Map<String,Partial_Control_Group__c>();
        //Find all the PCG based on Control and Plan
        for(Partial_Control_Group__c pcg : [Select 
                                                Id, Name,PCGKey__c 
                                            from 
                                                Partial_Control_Group__c 
                                            WHERE 
                                                PCGKey__c =: mapControlPlansToBuilders.keyset()]){
                 //Map of PCGKey and PCG Record                             
                 mapControlPlantoPCG.put(pcg.PCGKey__c,pcg);    
        }
        //Fallout for the CPs where PCG does not exists.
        Set<String> falloutControlPlan = new Set<String>();
        for(String controlPlan : mapControlPlansToBuilders.keySet()){
            if(! mapControlPlantoPCG.containsKey(controlPlan)){
                falloutControlPlan.add(controlPlan);
            }
        }
        if(! falloutControlPlan.isEmpty()){
            this.createFallout(mapControlPlansToBuilders, falloutControlPlan, 'PCG does not exist with the matching Control Plan');
        }
        Map<String,CSAP_CGLP_Junction__c> caspMap = new Map<String,CSAP_CGLP_Junction__c>(); 
        
        //TODO:- Delete CSAP for CRDs
        //Process Matched PCG record to find CSAP records
        List<CSAP_CGLP_Junction__c> csapToDeletes = new List<CSAP_CGLP_Junction__c>();
        Set<Id> crdIdsToArchive = new Set<Id>();
        Set<String> pcgsControlExists = new Set<String>();
        for(CSAP_CGLP_Junction__c csap : [Select 
                                                Id, Name, CRD__c,Full_Control_Group__c,Partial_Control_Group__c
                                                ,CSAP_Control_ID__c,CSAP_Plan_ID__c,GLP_Group_Number__c
                                                ,GLP_Plan_ID__c,CSAP_Detail__c,CRD_RxPlan_ID__c,CRD_Account__c
                                                ,CSAP_Control_Plan__c,Partial_Control_Group__r.PCGKey__c,CRD__r.Effective_Start_Date__c 
                                                ,Full_Control_Group__r.ControlPlan__c,CRD__r.Name
                                          From 
                                              CSAP_CGLP_Junction__c 
                                          where 
                                             Partial_Control_Group__r.PCGKey__c =: mapControlPlantoPCG.keySet()
                                             OR Full_Control_Group__r.ControlPlan__c = :mapControlPlantoPCG.keySet()
                                             ]){
               String csapKey =   csap.Partial_Control_Group__c != null ?  csap.Partial_Control_Group__r.PCGKey__c :  csap.Full_Control_Group__r.ControlPlan__c;                        
               if(mapControlPlansToBuilders.get(csapKey) != Null){                                  
                    for(CRDBuildOrder__c builder : mapControlPlansToBuilders.get(csapKey)){
                            System.debug('BuilderName' +builder.name);
                        //Case 1 - if this is CRD-PCG junction
                        if(csap.crd__c != null &&  csap.crd__c != builder.CRD__c 
                                                && csap.CRD__r.Effective_Start_Date__c == builder.CRD__r.Effective_Start_Date__c 
                                                && csap.Partial_Control_Group__c != null 
                                                && csap.Full_Control_Group__c == null){
                              System.debug('CSAPStep1' +csap.Name);                     
                            //TODO:- Delete this CSAP record, 2. remove this pcg from this crd
                            this.addToCSAP( caspMap, builder.CRD__c, csap.Partial_Control_Group__c, null);
                            csapToDeletes.add(csap);
                            crdIdsToArchive.add(csap.crd__c);
                            pcgsControlExists.add(csap.Partial_Control_Group__r.PCGKey__c);
                            if(! mapCRDs.containsKey(builder.CRD__c)){
                                mapCRDs.put(builder.CRD__c, new CRD__c(id = builder.CRD__c,Partial_Control_Group__c = csap.Partial_Control_Group__c ));
                            }else{
                                mapCRDs.get(builder.CRD__c).Partial_Control_Group__c = csap.Partial_Control_Group__c;
                            }
                        }else if(csap.Full_Control_Group__c != null && csap.Partial_Control_Group__c != null && csap.crd__c == null ){// IF this is PCG to FCG
                            //Case 2 - if this is PCG-FCG Junction
                            System.debug('CSAPStep2' +csap.Name);
                            this.addToCSAP(caspMap, builder.CRD__c, null, csap.Full_Control_Group__c);
                            if(! mapCRDs.containsKey(builder.CRD__c)){
                                mapCRDs.put(builder.CRD__c, new CRD__c(id = builder.CRD__c,Full_Control_Group__c = csap.Full_Control_Group__c ));
                            }else{
                                mapCRDs.get(builder.CRD__c).Full_Control_Group__c = csap.Full_Control_Group__c;
                            }
                        }else if(csap.crd__c != null &&  csap.crd__c != builder.CRD__c 
                                                      && csap.CRD__r.Effective_Start_Date__c == builder.CRD__r.Effective_Start_Date__c 
                                                      && csap.Full_Control_Group__c != null){//IF CRD to FCG
                            System.debug('CSAPStep3' +csap.Name);                           
                            csapToDeletes.add(csap);
                            crdIdsToArchive.add(csap.crd__c);
                            if(! mapCRDs.containsKey(builder.CRD__c)){
                                mapCRDs.put(builder.CRD__c, new CRD__c(id = builder.CRD__c,Full_Control_Group__c = csap.Full_Control_Group__c ));
                            }else{
                                mapCRDs.get(builder.CRD__c).Full_Control_Group__c = csap.Full_Control_Group__c;
                            }
                        }   
                                                   
                      } 
                    }
            
        }
        
        
        //For PCGs those are not added, due to missing CSAP with CRD
        for(String controlPlan : mapControlPlantoPCG.keyset()){
            if(! pcgsControlExists.contains(controlPlan)){
                for(CRDBuildOrder__c builder : mapControlPlansToBuilders.get(controlPlan)){
                    this.addToCSAP(caspMap, builder.CRD__c, mapControlPlantoPCG.get(controlPlan).id, null);
                }
            }//Added by Amit on 11 Feb 2016 for ST# 015
            else if(pcgsControlExists.contains(controlPlan)){
                for(CRDBuildOrder__c builder : mapControlPlansToBuilders.get(controlPlan)){
                    if(mapCRDs.get(builder.CRD__c).Partial_Control_Group__c== Null){
                        this.addToCSAP(caspMap, builder.CRD__c, mapControlPlantoPCG.get(controlPlan).id, null);
                    }
                }
                
            }
            //Ends
        }
        system.debug('--saveResults--'  + caspMap) ;
        //Insert CSAP records and process for the errors 
        //Delete duplicate records from caspList
        List<CSAP_CGLP_Junction__c> caspList = caspMap.values();
        List<Database.Saveresult> saveResults = Database.insert(caspList, false);
        this.ProcessSaveResults(saveResults, mapCrdIdToBuilder, caspList);        
        
        saveResults = Database.update(mapCRDs.values(), false);
        this.ProcessSaveResults(saveResults, mapCrdIdToBuilder, null);
        
        system.debug('--saveResults--'  + saveResults) ;
        System.debug('csapToDeletes' +csapToDeletes);
        delete  csapToDeletes;
        //CRD Archival functionality
        List<CRD__c> crdsToArchive = new List<CRD__c>();
        // Start ** done the changes in subquery because Rxplanid was not updating on the crd due to limit restriction
        for(CRD__c crd : [Select Id, name,Archived__c,Partial_Control_Group__c,Full_Control_Group__c,status__c 
                            ,(SELECT id, Partial_Control_Group__c, Full_Control_Group__c FROM CSAP_CGLP_Junction__r Order By Partial_Control_Group__c NULLS LAST, Full_Control_Group__c NULLS LAST Limit 100 )    
                          From 
                            CRD__c 
                          Where 
                            Id in :crdIdsToArchive OR Id in: mapCrdIdToBuilder.keyset()]){
             System.debug('CRDName' +crd.Name);
             System.debug('CSAPSize' +crd.CSAP_CGLP_Junction__r.size());                
        // *End***
            if(crd.CSAP_CGLP_Junction__r.isEmpty()){
                crd.Archived__c = true;
                //remove refereces from CRD. plan info
                crd.Partial_Control_Group__c = null;
                crd.Full_Control_Group__c = null;
                
            }else{
                for(CSAP_CGLP_Junction__c csapRecord: crd.CSAP_CGLP_Junction__r){
                    System.debug('CSAPID' +csapRecord.ID);
                    if(csapRecord.Partial_Control_Group__c != Null){
                        crd.Partial_Control_Group__c = csapRecord.Partial_Control_Group__c;
                    }
                    if(csapRecord.Full_Control_Group__c!= Null){
                         crd.Full_Control_Group__c = csapRecord.Full_Control_Group__c;
                    }
                }
            }  
            //Added by Amit to update CRD Status when ExistingRxplan is checked
            //Modified for request 05472
            if(mapCrdIdToBuilder.get(crd.id)!= Null && mapCrdIdToBuilder.get(crd.id).ExistingRxplan__c == True){
                crd.status__c = 'Existing RxPlanID';
            }
            //**Ends
            crdsToArchive.add(crd);
        }
        Database.update(crdsToArchive, false);
        
            //In Case there is error while making entry to CVS Table rollback the entire logic for both Batch and Continue Automation
            //ST# 277   
            if(hasError){
                Database.rollback( sp );
            }
        } catch(exception e){
            //To catch if any other kind of exception and rollback for both batch and Continue Automation
            //ST# 277
            Database.rollback( sp );
            exceptionMessage = True;   
            Error_log__c err = new Error_log__c();
            err.subject__c = 'CAG Failure';
            err.Error_Description__c = 'Message: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString();
            errList.add(err);
        }
        if(errList.size()>0){
            insert errList;
        }
    }
    
    private void ProcessSaveResults(List<Database.Saveresult> saveResults, Map<Id,CRDBuildOrder__c> mapCrdIdToBuilder, List<CSAP_CGLP_Junction__c> caspList){    
        Map<Id,Boolean> mapBuilderID2CAG = new Map<Id,Boolean>();    
        if(caspList == null){
            Integer index = 0;
            Map<Id,Case> mapCrdIdWithCase = new Map<Id,Case>();
            Map<Id,List<CRD_BuilderFallout__c>> mapCrdIdWithFallout = new Map<Id,List<CRD_BuilderFallout__c>>();
            List<CRD_BuilderFallout__c> fallouts = new List<CRD_BuilderFallout__c>();
            for(Database.Saveresult saveResult : saveResults){
                String mapCrdId = saveResult.getId();
                //Get CRD Builder record matched
                CRDBuildOrder__c builder = mapCrdIdToBuilder.get(mapCrdId);
                if(saveResult.isSuccess()){
                    //Mark record as succeed
                    mapBuilderID2CAG.put(builder.id,True);
                }else{
                    Case falloutCase;
                      if(builder.FalloutCase__c != null){
                        //initiate fallout record with existing record Id 
                        falloutcase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c, 'CAG Restructure Failure'
                                                                        , 'Error while Saving CSAP'
                                                                        ,'CB_CAG'
                                                                        ,builder.PERS_timestamp__c
                                                                        ,builder.ControlPlanEffective__c
                                                                        ,builder.crd__r.Account__c
                                                                        ,builder.crd__r.Effective_Start_Date__c
                                                                        ,builder.crd__c);
                      }else{
                        //Create new instance of fallout record
                        falloutcase = CB_CaseLogger.CreateCaseBuilder('CAG Restructure Failure'
                                                                        , 'Error while Saving CSAP'
                                                                        ,'CB_CAG'
                                                                        ,builder.PERS_timestamp__c
                                                                        ,builder.ControlPlanEffective__c
                                                                        ,builder.crd__r.Account__c
                                                                        ,builder.crd__r.Effective_Start_Date__c
                                                                        ,builder.crd__c);
                        
                      }
                      mapCrdIdWithCase.put(builder.crd__c, falloutCase);
                      CRD_BuilderFallout__c falloutRecord;
                      for(DataBase.Error err : saveResult.getErrors()){
                      //populate fields of fallout case generated 
                      falloutRecord = new CRD_BuilderFallout__c();
                      falloutRecord.Error_Description__c = err.getMessage();
                      falloutRecord.Type__c = 'Save Errors';
                      falloutRecord.CRD_Id__c = builder.crd__c;
                      falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
                      fallouts.add(falloutRecord);
                      failureRecords.add(falloutRecord);
                      //fetch values of crd builder fallout record on basis of crd builder record id
                          if(mapCrdIdWithFallout.containsKey(builder.crd__c)){
                                mapCrdIdWithFallout.get(builder.crd__c).add(falloutRecord);
                          }else{
                                mapCrdIdWithFallout.put(builder.crd__c, new List<CRD_BuilderFallout__c>{falloutRecord} );
                          }
                      } 
                }
                
                
                index++;
            }
            
            upsert mapCrdIdWithCase.values();

            for(Id crdId : mapCrdIdWithCase.KeySet()){
                CRDBuildOrder__c builder = mapCrdIdToBuilder.get(crdId);
                builder.FalloutCase__c = mapCrdIdWithCase.get(crdId).id;
                builder.CAG__c = false;
                builder.PDF__c = False;
                builder.XML__c = False;
                builder.CVS__c = False;
                builder.ExistingRxplan__c = False;
                setRxplanid.remove(builder.CRD__r.RxPlanID__c);
                for(CRD_BuilderFallout__c fallout : mapCrdIdWithFallout.get(crdId)){
                    fallout.CaseId__c = mapCrdIdWithCase.get(crdId).id;
                }
            }
            insert fallouts;
            update mapCrdIdToBuilder.values();
            
        }else{
            Integer index = 0;
            Boolean setCAG;
            Map<Id,Case> mapCrdIdWithCase = new Map<Id,Case>();
            Map<Id,List<CRD_BuilderFallout__c>> mapCrdIdWithFallout = new Map<Id,List<CRD_BuilderFallout__c>>();
            List<CRD_BuilderFallout__c> fallouts = new List<CRD_BuilderFallout__c>();         
            for(Database.Saveresult saveResult : saveResults){

                CSAP_CGLP_Junction__c csap = caspList[index];
                //Get CRD Builder record matched
                CRDBuildOrder__c builder = mapCrdIdToBuilder.get(csap.CRD__c);              
                if(saveResult.isSuccess()){
                    //Mark record as succeed
                    mapBuilderID2CAG.put(builder.id,True);
                }else{
                    setCAG = False;
                    Case falloutCase;
                      if(builder.FalloutCase__c != null){
                        //initiate fallout record with existing record Id 
                        falloutcase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c, 'CAG Restructure Failure'
                                                                , 'Error while Saving CSAP'
                                                                ,'CB_CAG'
                                                                ,builder.PERS_timestamp__c
                                                                ,builder.ControlPlanEffective__c
                                                                ,builder.crd__r.Account__c
                                                                ,builder.crd__r.Effective_Start_Date__c
                                                                ,builder.crd__c);
                      }else{
                            //Create new instance of fallout record
                            falloutcase = CB_CaseLogger.CreateCaseBuilder('CAG Restructure Failure'
                                                                    , 'Error while Saving CSAP'
                                                                    ,'CB_CAG'
                                                                    ,builder.PERS_timestamp__c
                                                                    ,builder.ControlPlanEffective__c
                                                                    ,builder.crd__r.Account__c
                                                                    ,builder.crd__r.Effective_Start_Date__c
                                                                    ,builder.crd__c);
                            
                          }
                          mapCrdIdWithCase.put(builder.crd__c, falloutCase);
                          CRD_BuilderFallout__c falloutRecord;
                          for(DataBase.Error err : saveResult.getErrors()){
                          //populate fields of fallout case generated 
                          falloutRecord = new CRD_BuilderFallout__c();
                          falloutRecord.Error_Description__c = err.getMessage();
                          falloutRecord.Type__c = 'Save Errors';
                          falloutRecord.CRD_Id__c = builder.crd__c;
                          falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
                          fallouts.add(falloutRecord);
                          failureRecords.add(falloutRecord);
                          //fetch values of crd builder fallout record on basis of crd builder record id
                              if(mapCrdIdWithFallout.containsKey(builder.crd__c)){
                                    mapCrdIdWithFallout.get(builder.crd__c).add(falloutRecord);
                              }else{
                                    mapCrdIdWithFallout.put(builder.crd__c, new List<CRD_BuilderFallout__c>{falloutRecord} );
                              }
                          } 
                }
                
                
                index++;
            }
            set<String> existingRxPlanIds = new Set<String>();
        
            //Fetch all the records from CVSRxPlanId object and put them in a map
            for(CVSRxPlanId__c currentCVS : [Select Id,Name, RxPlanId__c from CVSRxPlanId__c Where RxPlanId__c In: rxPlan2CVS LIMIT 10000]){ 
                 existingRxPlanIds.add(currentCVS.RxPlanId__c);       
            }  
            
            //Check if the Rxplanid of the CRD on CRD builder record matches the Rxplanid from CVSRxPlanId table, if not insert the RxplanID in CVSRxPlanId table                                        
            for(CRDBuildOrder__c builder : listCRDBuildOrder4CVS){
                if(listCRDBuildOrder4CVS.size() == 1){
                    crdName = builder.CRD__r.Name;
                }
                if(mapBuilderID2CAG.get(builder.ID)!= Null && mapBuilderID2CAG.get(builder.ID)){
                    setCAG = True;
                }else if(mapbuilderIdWithFallout.containskey(builder.id)){
                    setCAG = False;
                }
                if(setCAG){
                    builder.CAG__c = True;
                  if(existingRxPlanIds.contains(builder.CRD__r.RxPlanID__c)){
                      builder.PDF__c = True;
                      builder.XML__c = True;
                      builder.CVS__c = True;
                      builder.ExistingRxplan__c = True;
                      if(builder.Success_Case__c != NULL){
                      caseToUpdate.add(builder.Success_Case__c) ;// for Request 6217
                     }
                  }else{        
                          setRxplanid.add(builder.CRD__r.RxPlanID__c);                      
                          system.debug('#####Builder2'+builder);                     
                          mapCrdTorxplanId.put(builder.CRD__r.RxPlanID__c,builder.CRD__r.Name);
                      }
                  
                  existingRxPlanIds.add(builder.CRD__r.RxPlanID__c);
                  mapCrdIdToBuilder.put(builder.crd__c,builder);
                } 
               }
               if(!caseToUpdate.isempty()){
               for(id c : caseToUpdate){
                   case caseInstance = new case(id = c);
                     caseInstance.status = 'Closed';
                     caseUpdateList.add(caseInstance);
                }
                }
                upsert mapCrdIdWithCase.values();
                database.update(caseUpdateList);
                   
            
            for(Id crdId : mapCrdIdWithCase.KeySet()){
                //Amit set the PDF,XML,CVS,ExistingRxPlan to false and remove the RxPlanId from CVS list.
                //Modified on 2 Jan, 2014 to resolve issue where CAG was unchecked and rest flags were checked
                CRDBuildOrder__c builder = mapCrdIdToBuilder.get(crdId);
                builder.FalloutCase__c = mapCrdIdWithCase.get(crdId).id;
                builder.CAG__c = False;
                builder.PDF__c = False;
                builder.XML__c = False;
                builder.CVS__c = False;
                builder.ExistingRxplan__c = False;
                setRxplanid.remove(builder.CRD__r.RxPlanID__c);//This will remove any RxPlanId in case of fallouts, so that no entry will be made in CVSRxPlanID Table
                for(CRD_BuilderFallout__c fallout : mapCrdIdWithFallout.get(crdId)){
                    fallout.CaseId__c = mapCrdIdWithCase.get(crdId).id;
                }
            }
            insert fallouts;
            System.debug('fallouts' +fallouts);
            System.debug('setRxplanid' +setRxplanid);
            update mapCrdIdToBuilder.values();
            
            //Added logic to instantly make the entry in CVSRxPlanID Table instead of inserting after completion of process
                //ST# 277       
                if(setRxplanid != Null){
                    for(String rxplanidvalue : setRxplanid){
                        System.debug('rxplanidvalue' +rxplanidvalue);
                        newRecord = new CVSRxPlanId__c();
                        newRecord.RxPlanId__c = rxplanidvalue;
                        //Added by JR on 16/02/2015 to implement request no 05549
                        newRecord.CRD_Name__c = mapCrdTorxplanId.get(rxplanidvalue);
                        listCVS.add(newRecord);
                    }
                    try{
                    insert listCVS;
                    System.debug('listCVS' +listCVS.size());
                    }catch(Exception e){
                        hasError = True;
                        exceptionMessage = True;
                        Error_log__c err = new Error_log__c();
                        err.subject__c = 'CAG Failure';
                        err.CRD__c = crdName;
                        err.Error_Description__c = 'Message: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString();
                        errList.add(err);
                    }
               }
        }
    }       

    
    private void addToCSAP(Map<String,CSAP_CGLP_Junction__c> caspMap, Id crdId, Id pcgId, Id fcgId){
        CSAP_CGLP_Junction__c newCSAP;
        String key ;
        if(pcgId != null){
            newCSAP = new CSAP_CGLP_Junction__c();
            newCSAP.CRD__c = crdid;
            newCSAP.Partial_Control_Group__c = pcgId;
            newCSAP.RecordTypeId = csapCRD2PCG;
            key =  newCSAP.CRD__c+ '|' +  newCSAP.Partial_Control_Group__c;
        }else{
            newCSAP = new CSAP_CGLP_Junction__c();
            newCSAP.CRD__c = crdid;
            newCSAP.Full_Control_Group__c = fcgId;
            newCSAP.RecordTypeId = csapCRD2FCG;
             key =  newCSAP.CRD__c+ '|' +  newCSAP.Full_Control_Group__c;
        }
        caspMap.put(key, newCSAP);
    }
    
    
    
    private void createFallout(Map<String, List<CRDBuildOrder__c>> mapControlPlansToBuilders, Set<String> setOfControlPlan, String errorMessage){
        Map<Id,Case> mapbuilderIdWithCase = new Map<Id,Case>();
        Map<Id,CRDBuildOrder__c> mapCrdBuilder = new Map<Id,CRDBuildOrder__c>();
        for(String controlPlan : setOfControlPlan){
            for(CRDBuildOrder__c builder : mapControlPlansToBuilders.get(controlPlan)){
                  Case falloutCase;
                  if(builder.FalloutCase__c != null){
                    //initiate fallout record with existing record Id 
                    falloutcase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c, 'CAG Restructure Failure'
                                                                    , errorMessage
                                                                    ,'CB_CAG'
                                                                    ,builder.PERS_timestamp__c
                                                                    ,builder.ControlPlanEffective__c
                                                                    ,builder.crd__r.Account__c
                                                                    ,builder.crd__r.Effective_Start_Date__c
                                                                    ,builder.crd__c);
                  }else{
                    //Create new instance of fallout record
                    falloutcase = CB_CaseLogger.CreateCaseBuilder('CAG Restructure Failure'
                                                                    ,errorMessage
                                                                    ,'CB_CAG'
                                                                    ,builder.PERS_timestamp__c
                                                                    ,builder.ControlPlanEffective__c
                                                                    ,builder.crd__r.Account__c
                                                                    ,builder.crd__r.Effective_Start_Date__c
                                                                    ,builder.crd__c);
                    
                  }
                  mapbuilderIdWithCase.put(builder.id, falloutCase);
                  
                  CRD_BuilderFallout__c falloutRecord = new CRD_BuilderFallout__c();
                  falloutRecord.Error_Description__c = errorMessage;
                  falloutRecord.Type__c = 'Individual';
                  falloutRecord.CRD_Id__c = builder.crd__c;
                  falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
                  mapbuilderIdWithFallout.put(builder.id, falloutRecord);
                  failureRecords.add(falloutRecord);
                  mapCrdBuilder.put(builder.id, builder);
            }
            
        }
        
        upsert mapbuilderIdWithCase.values();
        for(String builderId : mapbuilderIdWithCase.keyset()){
            //Amit set the PDF,XML,CVS,ExistingRxPlan to false and remove the RxPlanId from CVS list.
            //Modified on 2 Jan, 2014 to resolve issue where CAG was unchecked and rest flags were checked
            CRDBuildOrder__c builder  = mapCrdBuilder.get(builderId);
            builder.CAG__c = False;
            builder.PDF__c = False;
            builder.XML__c = False;
            builder.CVS__c = False;
            builder.ExistingRxplan__c = False;
            setRxplanid.remove(builder.CRD__r.RxPlanID__c);
            builder.FalloutCase__c = mapbuilderIdWithCase.get(builderId).id;
            mapbuilderIdWithFallout.get(builderId).CaseId__c = mapbuilderIdWithCase.get(builderId).id;
            
        }
        insert mapbuilderIdWithFallout.values();
        update mapCrdBuilder.values();
        
        system.debug('--mapbuilderIdWithFallout -' + mapbuilderIdWithFallout);
    } 
*/
}