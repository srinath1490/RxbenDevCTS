global class CB_CRDBuildOrder_Scheduler implements Schedulable {

// This test runs a scheduled job at midnight Sept. 3rd. 2022

    public static String CVSTHROTTLEJOB = 'CRD/CVS throttle';
    
    global void execute(SchedulableContext ctx) {
       if(!label.cb_cbontrigger_enable.equalsignorecase('true')){
            list<crdbuildorder__c> crdBuilderlst = [select id,Case__c,crd__r.Account__c,crd__r.Effective_Date__c,crd__c,ControlPlanEffective__c from crdbuildorder__c where pdf__c = true and cvs__c = false limit 1];
            if(crdBuilderlst.size() > 0){
                crdbuildorder__c crdBuilder = crdBuilderlst[0];
               // crdBuilder.cvs__C = true;
                Set<Id> crdBuildersForCVS = new Set<Id>();
                list<Id> listCaseID = new list<Id>();
                list<Case> caseStatusUpdate = new list<Case>(); 
                crdBuildersForCVS.add(crdBuilder.id);
        
                if(! crdBuildersForCVS.isEmpty()){
                    //Get Partner Network connection
                    List<PartnerNetworkConnection> connMap = [select 
                                                                    Id, ConnectionStatus, ConnectionName 
                                                              from
                                                                   PartnerNetworkConnection 
                                                              where 
                                                                ConnectionName =:Label.CB_Partner_Network_Connection AND ConnectionStatus = 'Accepted'];
                    //Push external cases to Partner Network
                    List<PartnerNetworkRecordConnection> sharedRecords = new List<PartnerNetworkRecordConnection>();
                    //Map: CaseId => CrdBuilder Record, this will help to retrieve CRD Builder records from External case pushed to Sharing
                    Map<Id,CRDBuildOrder__c> mapCaseIdCrdBuilderRecord = new Map<Id,CRDBuildOrder__c>();
                    for(Id crdBuilderRecordId : crdBuildersForCVS){
                        //Get CrdBuilder record from recordId               
                        mapCaseIdCrdBuilderRecord.put(crdBuilder.Case__c, crdBuilder);
                        //Loop over Network connection and create share record
                            sharedRecords.addAll(CB_CRDBuildOrder_TriggerHandler.partnerConnectionCreated(connMap,crdBuilder));
                      
                    }
                    
                    //Map : Crd builder Record Id => fallout caseId
                    Map<Id,Case> mapCrdBuilderIdToFalloutCase = new Map<Id,Case>();
                    //Map : Crd builder Record Id => Crd builder Fallout records
                    Map<Id,List<CRD_BuilderFallout__c>> mapCrdBuilderIdToFalloutRecord = new Map<Id,List<CRD_BuilderFallout__c>>();
                    
                    //Insert sharing records
                    List<Database.Saveresult> saveResults = Database.insert(sharedRecords, false);
                    List<CRD_BuilderFallout__c> crdBuilderFallouts = new List<CRD_BuilderFallout__c>();
                    Integer index = 0;
                    //Loop over save result and do -> 1. Set CRD Builder.CVS = true , Or 2. Create Fallout case
                    for(Database.Saveresult saveResult : saveResults){
                        PartnerNetworkRecordConnection shareRecord = sharedRecords[index];
                        CRDBuildOrder__c crdBuilderRecord = mapCaseIdCrdBuilderRecord.get(shareRecord.LocalRecordId);
                        //If sharing record is saved successfully set CVS flag true for related CRDBuilder record
                        if(saveResult.isSuccess()){
                            //set CRD Builder's CVS flag = true
                            crdBuilderRecord.cvs__c = true;
                            listCaseID.add(crdBuilderRecord.Success_Case__c);//Richa added for Req 5083
                            if(crdBuilderRecord.FalloutCase__c != null || crdBuilderRecord.FalloutCase__c != ''){
                                listCaseID.add(crdBuilderRecord.FalloutCase__c);
                        }
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
                                                                            ,'CB_CVS',crdbuilderrecord.PERSTimeStamp__c
                                                                            ,crdbuilderrecord.ControlPlanEffective__c
                                                                            ,crdbuilderrecord.crd__r.Account__c
                                                                            ,crdbuilderrecord.crd__r.Effective_Date__c
                                                                            ,crdbuilderrecord.crd__c);
                          }else{
                            //Create new instance of fallout record
                            falloutcase 
                                    = CB_CaseLogger.CreateCaseBuilder('CRD Builder fallout'
                                                                        ,falloutDescription
                                                                        ,'CB_CVS'
                                                                        ,crdbuilderrecord.PERSTimeStamp__c
                                                                        ,crdbuilderrecord.ControlPlanEffective__c
                                                                        ,crdbuilderrecord.crd__r.Account__c
                                                                        ,crdbuilderrecord.crd__r.Effective_Date__c
                                                                        ,crdbuilderrecord.crd__c);
                            
                          }
                          //listCaseID.add(falloutcase.id);
                          mapCrdBuilderIdToFalloutCase.put(crdBuilderRecord.id, falloutCase);
                            //saveResult.getErrors();
                          CRD_BuilderFallout__c falloutRecord;
                          for(DataBase.Error err : saveResult.getErrors()){
                            //populate fields of fallout case generated 
                            falloutRecord = new CRD_BuilderFallout__c();
                            falloutRecord.Error_Description__c = err.getMessage();
                            falloutRecord.Type__c = 'Save Errors';
                            falloutRecord.CRD_Id__c = crdBuilderRecord.crd__c;
                            falloutRecord.PERS_Timestamp__c = crdbuilderRecord.PERSTimeStamp__c;
                            crdBuilderFallouts.add(falloutRecord);
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
                    
                    upsert mapCrdBuilderIdToFalloutCase.values();
                    //iterate to fetch values for crd builder fallouts and populate value for fallout case and case id
                    for(Id crdBuilderRecordId : mapCrdBuilderIdToFalloutCase.keyset()){
        
                        crdBuilder.FalloutCase__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
                        for(CRD_BuilderFallout__c falloutRecord : mapCrdBuilderIdToFalloutRecord.get(crdBuilderRecordId)){
                            falloutRecord.CaseId__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
                        }
                    }
                    
                    insert crdBuilderFallouts;
                    //Richa added for Req 5083 point 8
                    if(!listCaseID.isempty()){
                        for(Case caseStatus : [Select Status from Case where Id IN :listCaseID]){
                                caseStatus.Status = 'Sent to CVS';
                                caseStatusUpdate.add(caseStatus);
                        }   
                        database.update (caseStatusUpdate);
                        
                    }//till here
                    update crdBuilder;
                  }
                }               
                          
                CB_CRDBuildOrder_Scheduler.unscheduleJob(ctx.getTriggerId(),CVSTHROTTLEJOB);    
        }
    } 
    
    
    @future
    public static void unscheduleJob(Id cronId,String strJobName)
    {   
    
            System.debug('cronId ' + cronId);
            
            DateTime dte = system.now();                
            dte.addMinutes(Integer.valueOf(label.CB_scheduletime));                
            String day = string.valueOf(dte.day());        
            String month = string.valueOf(dte.month());        
            String hour = string.valueOf(dte.hour());
            String year = string.valueOf(dte.year());
            String minute = string.valueOf(dte.minute());
            String second = string.valueOf(dte.second());                                
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            
            try{    
                CronTrigger t  = [SELECT Id FROM CronTrigger where Id =: cronId];
                System.abortJob(t.Id); //abort the job
            }
            catch(Exception e){
                system.debug('Abort Exception ' + e.getMessage());
            } 
               
            try{   
            //schedule the job
                System.schedule(strJobName, strSchedule, new CB_CRDBuildOrder_Scheduler());
            }
            catch (exception e){
                system.debug('Schedule Exception ' + e.getMessage());
            }   

    }  
    
    
    
    
}