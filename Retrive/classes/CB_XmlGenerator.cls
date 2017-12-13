/*Purpose: Apex  Class for XML generation of the CRD
======================================================================== */
public with sharing class CB_XmlGenerator {

    public List<CRD_BuilderFallout__c> failures;
    private static FINAL String CRDSTATUS = 'XML & Case Generated. CRD Complete.';
    private static FINAL String FALLOUTDESC = 'XML failure:  ';
    private static FINAL String CRDFALLOUT = 'CRD Builder fallout';
    private static FINAL String CBXML = 'CB_XML';
    private static FINAL String FALLOUTRECORDTYPE = 'Save Errors';
    private static FINAL String CRDSTATUS2 ='Pending PDF and CVS';
    
    /* Method to generate the XML for the CRD and to set the status of the CRD accordingly */ 
    public void xmlGenerator(List < CRDBuildOrder__c > crdBuilder){
        String CaseID;
        Map<String,Case> mapcrdBuilderToCase = new Map<String,Case>();
        case existingFalloutCase = new Case(); 
        datetime persTimeStamp ;
        Map<Id,Case> mapCrdIdToFalloutCase = new Map<Id,Case>();
        Map<Id,CRD_BuilderFallout__c> mapCrdIdToFalloutRecord = new Map<Id,CRD_BuilderFallout__c>();
        failures = new List<CRD_BuilderFallout__c>();
        list<Id> listCaseID = new list<Id>();
        list<Case> caseStatusUpdate = new list<Case>();
        CRD__c crdRecord;
        ApexPages.StandardController sc;
        GMF_XML_CRD_Controller gmf;
        CRD_BuilderFallout__c falloutRecord;
        map<Id,Case> updateParentCase = new map<Id,Case>();//Richa added for Req 5094
        list<Id> attachParentCase = new list<Id>();//Richa added for Req 5094
        
         
         for(CRDBuildOrder__c crdBO : crdBuilder){
            Savepoint savepointtorollback = Database.setSavepoint(); //Added by Ayushi for Request 06326 (ST# 900)
            try{system.debug('GENERATEDCASEID=======&&&&&' );
                  crdRecord = new crd__c(id=crdbo.crd__c);
                 crdRecord.LastSent__c = system.Now();
                 database.update(crdRecord); 
                sc = new ApexPages.StandardController(new crd__c(id=crdbo.crd__c));
                gmf = new GMF_XML_CRD_Controller(sc); 
                system.debug('GENERATEDCASEID=======1HERE' );
                CaseID = gmf.generateCaseAndXML();
                system.debug('GENERATEDCASEID=======2'+CaseID );
                attachParentCase.add(CaseID);//Richa added for Req 5094
                updateParentCase.put(CaseID,new Case (id = crdbo.Success_Case__c));//Richa added for Req 5094
              
                crdRecord.Status__c = CRDSTATUS;
              //updating the record for custom history tracking.
              crdRecord.LastSent__c = system.Now();
              crdRecord.XMLDate_Time_Stamp__c = system.now();
              database.update(crdRecord);
                crdbo.case__c = CaseID;
                crdbo.XML__c = TRUE;
                //crdbo.Success_Case__r.status ='Pending PDF and CVS';
                listCaseID.add(crdbo.Success_Case__c);//Richa added for Req 5083
                if(crdbo.FalloutCase__c != null){
                    listCaseID.add(crdbo.FalloutCase__c);//Richa added for Req 5083
                }
                database.update(crdbo);
            }                
            catch(exception e){
                Database.rollback(savepointtorollback); //Added by Ayushi for Request 06326 (ST# 900)
                //Added by JR
                 Case falloutCase;
                 String falloutDescription = FALLOUTDESC + e.getMessage();
                
                if(crdBO.FalloutCase__c!=null){
                    //initiate fallout record with existing record Id
                    falloutCase = CB_CaseLogger.CreateCaseBuilder(crdBO.FalloutCase__c
                                                                ,CRDFALLOUT
                                                                ,falloutDescription
                                                                ,CBXML
                                                                ,crdBO.PERSTimeStamp__c
                                                                ,crdBO.ControlPlanEffective__c
                                                                ,crdBO.crd__r.Account__c
                                                                ,crdBO.crd__r.Effective_Date__c
                                                                ,crdBO.crd__c);
                 }else{
                     falloutCase = CB_CaseLogger.CreateCaseBuilder(CRDFALLOUT
                                                                    ,falloutDescription
                                                                    ,CBXML
                                                                    ,crdBO.PERSTimeStamp__c
                                                                    ,crdBO.ControlPlanEffective__c
                                                                    ,crdBO.crd__r.Account__c
                                                                    ,crdBO.crd__r.Effective_Date__c
                                                                    ,crdBO.crd__c);
                 }
                 falloutCase.CRD_ID__c = crdBO.crd__c;
                 mapCrdIdToFalloutCase.put(crdBO.crd__c, falloutCase);
                 falloutRecord = new CRD_BuilderFallout__c();
                 falloutRecord.Error_Description__c = falloutDescription;
                 falloutRecord.Type__c = FALLOUTRECORDTYPE;
                 falloutRecord.CRD_Id__c = crdBO.crd__c;
                 falloutRecord.PERS_Timestamp__c = crdBO.PERSTimeStamp__c;
                 mapCrdIdToFalloutRecord.put(crdBO.crd__c, falloutRecord);
                 failures.add(falloutRecord);                                            
                
                //listCaseID.add(falloutCase.id);//Richa added for Req 5083
                database.upsert(mapCrdIdToFalloutCase.values());
                
             for(CRDBuildOrder__c builder : crdBuilder){             
                  builder.FalloutCase__c = mapCrdIdToFalloutCase.get(builder.crd__c).id;
                  mapCrdIdToFalloutRecord.get(builder.crd__c).CaseId__c = mapCrdIdToFalloutCase.get(builder.crd__c).id;
            }       
            database.upsert(mapCrdIdToFalloutRecord.values());      
            }
               
        }  
        
        database.update(crdBuilder);
        //Richa added for Req 5083 point 6
                if(!listCaseID.isempty()){
                  for(Case caseStatus : updateParentCase.values()){
                      caseStatus.Status = CRDSTATUS2;
                      caseStatusUpdate.add(caseStatus);
                  } 
                }
                if(!attachParentCase.isempty()){
                    for(Case externalCase : [Select id, Parentid from Case where Id IN :attachParentCase LIMIT 90000]){
                        if(updateParentCase.get(externalCase.id)!= Null){
                            externalCase.Parentid = updateParentCase.get(externalCase.id).id;
                            updateParentCase.get(externalCase.id).Related_External_Case__c = externalCase.id;
                            externalCase.Related_Internal_CRD_Case__c =  externalCase.Parentid;
                            caseStatusUpdate.add(externalCase);
                        }                                           
                    }   
                }
                database.update (caseStatusUpdate); //Richa added for Req 5094
                
        }
}