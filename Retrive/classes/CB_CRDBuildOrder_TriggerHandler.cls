/*Purpose: Apex Class for handling CrdboShareCases Trigger  
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Sushant           10 July'2014       Apex Class for handling CrdboShareCases Trigger
======================================================================== */
public with sharing class CB_CRDBuildOrder_TriggerHandler {

        private static final String ARCHIVED = 'Archived';
        private static final String ATTACHMENT = 'Attachment';
        private static final String TRUEVALUE = 'true';
        private static final String ACCEPTED ='Accepted';
        private static final String FALLOUT_DESCRIPTION = 'Send to CVS failure, these will be assigned to BCT. ' 
                                                     + ' Users will need navigate to the external case given on '
                                                     + ' the fallout case and send it to CVS manually' ;
        private static final String CRD_BUILDER_FALLOUT = 'CRD Builder fallout';
        private static final String CB_CVS = 'CB_CVS';
        private static final String SAVE_ERRORS = 'Save Errors';
        private static final String SENT_TO_CVS = 'Sent to CVS';
        private static final string RT = 'CRD to Partial CG';
        public static list<crdbuildorder__c> cbonArchiveList = new list<crdbuildorder__c>();
        
        /*
         * 
         */
        public static List<PartnerNetworkRecordConnection> partnerConnectionCreated(List<PartnerNetworkConnection> con,CRDBuildOrder__c crdBuilder){
        List<PartnerNetworkRecordConnection> shareRecords = new List<PartnerNetworkRecordConnection>();
        PartnerNetworkRecordConnection newrecord = null;
              for(PartnerNetworkConnection network : con){
                newrecord = new PartnerNetworkRecordConnection();
                newrecord.ConnectionId = network.Id;
                newrecord.LocalRecordId = crdBuilder.Case__c;  
                newrecord.RelatedRecords = ATTACHMENT;
                newrecord.SendClosedTasks = false;
                newrecord.SendOpenTasks = false;
                newrecord.SendEmails = true;
                shareRecords.add(newrecord);  
            }
            return shareRecords;
        }
        
        /*
         * 
         */
        public static void onBeforeUpdate(Map<Id,crdbuildorder__c> oldMap,Map<Id,crdbuildorder__c> newMap){
            if(TRUEVALUE.equalsIgnoreCase(label.cb_cbontrigger_enable)){
                Set<Id> crdBuildersForCVS = new Set<Id>();
                list<Id> listCaseID = new list<Id>();
                list<Case> caseStatusUpdate = new list<Case>();
                //Loop over Trigger.New and identify records where PDF flag get true and CVs flag is still false
                for(crdbuildorder__c crdborecord: newMap.values()){
                    if(crdborecord.pdf__c != oldmap.get(crdborecord.id).pdf__c 
                                    && crdborecord.PDF__c == TRUE
                                    && crdborecord.XML__c == TRUE 
                                    && crdborecord.CVS__c == FALSE
                                    ){
                        crdBuildersForCVS.add(crdborecord.id);
                    }
                }
                
                //If any record match for CVS processing
                if(! crdBuildersForCVS.isEmpty()){
                    //Get Partner Network connection
                    List<PartnerNetworkConnection> connMap = [select 
                                                                    Id, ConnectionStatus, ConnectionName 
                                                              from
                                                                   PartnerNetworkConnection 
                                                              where 
                                                                ConnectionName =:Label.CB_Partner_Network_Connection AND ConnectionStatus =:ACCEPTED limit 10000];
                    //Push external cases to Partner Network
                    List<PartnerNetworkRecordConnection> sharedRecords = new List<PartnerNetworkRecordConnection>();
                    //Map: CaseId => CrdBuilder Record, this will help to retrieve CRD Builder records from External case pushed to Sharing
                    Map<Id,CRDBuildOrder__c> mapCaseIdCrdBuilderRecord = new Map<Id,CRDBuildOrder__c>();
                    for(Id crdBuilderRecordId : crdBuildersForCVS){
                        //Get CrdBuilder record from recordId
                        CRDBuildOrder__c crdBuilder = newMap.get(crdBuilderRecordId);
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
                            if(crdBuilderRecord.Archive_after_CVS__c != NULL && crdBuilderRecord.Archive_after_CVS__c == true){
                                 cbonArchiveList.add(crdBuilderRecord);                          //added for 6248
                              }
                            listCaseID.add(crdBuilderRecord.Success_Case__c);//Richa added for Req 5083
                            /*if(crdBuilderRecord.FalloutCase__c != null || crdBuilderRecord.FalloutCase__c != ''){
                                listCaseID.add(crdBuilderRecord.FalloutCase__c);
                              }Richa commented for D-00334*/
                        }else{
                          //Create fallout case for failed record   
                          Case falloutCase;                          
                          if(crdBuilderRecord.FalloutCase__c != null){
                            //initiate fallout record with existing record Id 
                            falloutcase = CB_CaseLogger.CreateCaseBuilder(crdbuilderrecord.falloutcase__c
                                                                            ,CRD_BUILDER_FALLOUT
                                                                            ,FALLOUT_DESCRIPTION
                                                                            ,CB_CVS,crdbuilderrecord.PERSTimeStamp__c
                                                                            ,crdbuilderrecord.ControlPlanEffective__c
                                                                            ,crdbuilderrecord.crd__r.Account__c
                                                                            ,crdbuilderrecord.crd__r.Effective_Date__c
                                                                            ,crdbuilderrecord.crd__c);
                          }else{
                            //Create new instance of fallout record
                            falloutcase 
                                    = CB_CaseLogger.CreateCaseBuilder(CRD_BUILDER_FALLOUT
                                                                        ,FALLOUT_DESCRIPTION
                                                                        ,CB_CVS
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
                          List<CRD_BuilderFallout__c> crdBuilderFalloutList = null; 
                          for(DataBase.Error err : saveResult.getErrors()){
                            //populate fields of fallout case generated 
                            falloutRecord = new CRD_BuilderFallout__c();
                            falloutRecord.Error_Description__c = err.getMessage();
                            falloutRecord.Type__c = SAVE_ERRORS;
                            falloutRecord.CRD_Id__c = crdBuilderRecord.crd__c;
                            falloutRecord.PERS_Timestamp__c = crdbuilderRecord.PERSTimeStamp__c;
                            crdBuilderFallouts.add(falloutRecord);
                            //fetch values of crd builder fallout record on basis of crd builder record id
                            if(mapCrdBuilderIdToFalloutRecord.containsKey(crdBuilderRecord.id)){
                                mapCrdBuilderIdToFalloutRecord.get(crdBuilderRecord.id).add(falloutRecord);
                            }else{
                            	crdBuilderFalloutList = new List<CRD_BuilderFallout__c>{falloutRecord};
                                mapCrdBuilderIdToFalloutRecord.put(crdBuilderRecord.id, crdBuilderFalloutList);
                            }
                          } 
                        }
                        index ++;
                    }
                    
                    upsert mapCrdBuilderIdToFalloutCase.values();
                    //iterate to fetch values for crd builder fallouts and populate value for fallout case and case id
                    for(Id crdBuilderRecordId : mapCrdBuilderIdToFalloutCase.keyset()){
                        CRDBuildOrder__c crdBuilderRecord = newMap.get(crdBuilderRecordId);
                        crdBuilderRecord.FalloutCase__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
                        for(CRD_BuilderFallout__c falloutRecord : mapCrdBuilderIdToFalloutRecord.get(crdBuilderRecordId)){
                            falloutRecord.CaseId__c = mapCrdBuilderIdToFalloutCase.get(crdBuilderRecordId).id;
                        }
                    }
                    
                    insert crdBuilderFallouts;
                    //Richa added for Req 5083 point 8
                    if(!listCaseID.isempty()){
                        for(Case caseStatus : [Select Status from Case where Id IN :listCaseID limit 10000]){
                                caseStatus.Status = SENT_TO_CVS;
                                caseStatusUpdate.add(caseStatus);
                        }   
                        database.update (caseStatusUpdate);
                        
                    }//till here
                }
            }
       
       handleArchiveAfterCVS(cbonArchiveList);
        }
   
    /* Added By Sushant for 06248 */
    /* 
     * Method handleArchiveAfterCVS to handle Archive After CVS case 
     */
	    public static void handleArchiveAfterCVS(list<crdbuildorder__c> cbonRecList){
	    	list<crd__c> crdList = new list<crd__c>();                                                    // list to hold CRDs to be updated
		    //list<crdbuildorder__c> cbonList = new list<crdbuildorder__c>();                               // list to hold CBONs to be updated
		    map<id,crdbuildorder__c> crdCBONMap = new map<id,crdbuildorder__c>();                         // map between crdid and CBONs
		    map<id,list<CSAP_CGLP_Junction__c>> crdCSAPMap = new map<id,list<CSAP_CGLP_Junction__c>>();   // map between crdid and CSAP CGLP Junction
		    //list<CSAP_CGLP_Junction__c> csapList = new list<CSAP_CGLP_Junction__c>();                     //list to hold CSAP CGLP Junctions
		    try{
			    //iterate over incoming CBON list to map with ids
			    for(crdbuildorder__c cbon : cbonRecList){
			        crdCBONMap.put(cbon.crd__c,cbon);
			    }
			    //query csap record type and add to below query
			    
			    // for loop to iterate over CSAP CGLP Junctions and add to map of crdid and csap records
			    List<CSAP_CGLP_Junction__c> csapJunctionList = null;
			    for(CSAP_CGLP_Junction__c ccjRec : [SELECT id,Partial_Control_Group__c ,RecordType.Name,Full_Control_Group__c,crd__c from CSAP_CGLP_Junction__c where CRD__c IN : crdCBONMap.keyset() AND recordtype.name =:RT AND Partial_Control_Group__c != NULL limit 10000]){
			        if(crdCSAPMap.containsKey(ccjRec.crd__c)){
			            crdCSAPMap.get(ccjRec.crd__c).add(ccjRec);
			        }else{
			        	csapJunctionList = new List<CSAP_CGLP_Junction__c>{ccjRec};
			            crdCSAPMap.put(ccjRec.crd__c,csapJunctionList);
			        }
			        
			    }
			    
			    //iterate over CRDs in scope from crdCBONMap and set CRD fields and associated CBON fields to handle Archive After CVS if crdCSAPMap entry does not have any PCG/FCG List attached
			    for(crd__c crdRec : [SELECT id,Partial_Control_Group__c,archived__c from crd__c where id IN: crdCBONMap.keyset() limit 10000]){
			        if(!crdCSAPMap.containsKey(crdRec.id)){
			                crdRec.archived__c = true;
			                crdRec.status__c = ARCHIVED ;
			                crdList.add(crdRec);
			                crdCBONMap.get(crdRec.id).Ready_to_Archive__c = true;      
			        }
			        
			           
			    }
			    // update CRD and CBON
			    update crdList;
	    	}
		    catch(exception e){
		    	throw e;
		    }
	    }
}