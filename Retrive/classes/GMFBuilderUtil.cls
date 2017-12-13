/*Purpose: Apex Class acting as container of all the GMF Builder related methods   
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           14 Jul 2015       Apex Class acting as container of all the GMF Builder related methods
   1.1 -    Richa           21 Nov 2015       Req 6213
   1.2      Shubham         19th Dec 2016     159230 - ST#1743  As per new Picklist Values for request 'Annual Changes'
=================================================================================================*/ 
public without sharing class GMFBuilderUtil { 
    public static boolean batchContext = false;
    public static boolean byPassGMFValidation = false;
    PRIVATE STATIC FINAL string CUSTOMSETTINGNAME = 'Trigger Configurations';
    private static final string CHILDERROR = 'Parent GMF is locked because of Internal Case  ';
    private static final string PARENTERROR = 'GMF is locked because of Internal Case  ';
    private static final string QUERYPART1 = 'Select id,Case__r.CaseNumber from GMF_Change_Request__c where Case__r.Status = \'Ready To Send\' and ';
    private static final string QUERYPART2 = ' = \'';
    private static final string QUERYPART3 = '\' LIMIT 1';
    private static final string QUERYPART11 = 'Select id,Case__r.CaseNumber,Clinical_Program__c,Clinical_Program_Group__c,Drug_Group__c,Drug_list__c,Formulary__c,Formulary_List__c,Generic_Code_Conversion__c,Object_List__c,Option_Code__c from GMF_Change_Request__c where Case__r.Status = \'Ready To Send\' and ';
    private static final string QUERYPART22 =' in : recordIds ';
    private static final string XML = 'XML__c';
    private static final string PDF = 'PDF__c';
    private static final string CVS = 'CVS__c';
    private static final string PDFDATE = 'PDF_Date__c';
    private static final string LASTSENT = 'LastSent__c';
    private static final string SENTTOCVSDATE = 'Sent_To_CVS_Date__c';
    private static final string EXTERNALCASE = 'External_Case__c';
    private static final string ATTACHMENT = 'Attachment';
    private static final string SENDERROR = 'Send_Error__c';
    private static final string DRUGLIST = 'Drug List';
    private static final string HASHTAG = '#';
    private static final string ACCEPTED = 'Accepted';
    private static final string SENTTOCVS = 'Sent To CVS';
    private static final string NOTAPPLICABLE = 'NA';
    private static final string OTHERS = 'Others';
    private static final string SPCLUSE = 'Special_Use__c';
    private static final string RTID = 'RecordTypeid';
    private static final string NEWGMF = 'New GMF';
    private static final string MNTGMF = 'Maintenance GMF';
    private static final string NEWSTATUS = 'New';
    private static final string DRUGLISTOBJ = 'Drug_List__c';
    private static final set<String> SpecialUseDL = new set<String>{'Specialty List','Waiver of Deductible','Drug Specific Copay'};
    private static final set<String> SpecialUseDLmnt = new set<String>{'Specialty List','Waiver of Deductible'};
    private static final string INTERNALGMFCASELABEL = 'Internal GMF Case';
    private static final string CASELABEL = 'Case';
    private static final string READYTOSEND = 'Ready To Send';
    private static final string PROCESSINGERROR = 'Processing Error';
    private static final string PARTIALLYSENT = 'Partially Sent';
    private static final string HIGH = 'High';
    private static final string MEDIUM = 'Medium';
    private static final string LOW = 'Low';
    private static final string NAME = 'Name';
    private static final string ANOC = 'ANOC';
    private static final string MIDYEAR = 'Mid-Year';
    private static final string secondQuarter = '2nd Quarter'; /*159230 - ST#1743  As per new Picklist Values for request 'Annual Changes'*/
	private static final string fourthQuarter = '4th Quarter';/* 159230 - ST#1743 As per new Picklist Values for request 'Annual Changes'*/
	private static final string BookofRecord = 'Book of Record';/* 159230 - ST#1743 As per new Picklist Values for request 'Annual Changes'*/
    private static final string QUEUE = 'Queue';
    private static final string QUEUENAME = 'Commercial GMFs - Sent';
    private static final string PERCENTLABEL = '%';
/***
    Method -  lockGMF()
    Usage - Receives the object as parameter and checks if it is attached to any "Ready to Send" Internal Case, if yes, locks it from editing
    Input Parameters - Map of object with its new values,Map of object with its old values, Object name as string
    Output Parameters - no return statement
    ***/
    public static void lockGMF(map<id,Sobject> objToLockNew, map<id,Sobject> objToLockOld, String objName){
        /*Run lockGMF Method based on value of TRG_LockGMF__c in the Org Trigger Configurations Custom Setting*/
        Boolean TRGLockGMF;
        if(!Test.isRunningTest()){
            Org_Trigger_Configurations__c triggerConfigSetting = Org_Trigger_Configurations__c.getInstance(CUSTOMSETTINGNAME);
            TRGLockGMF=triggerConfigSetting.TRG_LockGMF__c;
        }
        else{
            TRGLockGMF=True;
        }
        /*Check value of TRG_LockGMF__c in Trigger Configurations Record of Org Trigger Configurations Custom Setting*/
        if(!byPassGMFValidation && TRGLockGMF && !batchContext){
            Map<String, set<String>> mapObject = new Map<String, set<string>>();
            Set<ID> recordIds = objToLockNew.keySet();
            String queryStrng = QUERYPART11 + objName + QUERYPART22 ;
            List<GMF_Change_Request__c> myList  = new List<GMF_Change_Request__c>();
            string parentRecId ;
            for(GMF_Change_Request__c GMF:Database.query(queryStrng)){
                parentRecId = string.valueof(GMF.get(objName));
                if(!mapObject.containsKey(parentRecId)){
                    mapObject.put(parentRecId, new Set<string>());
                }
                mapObject.get(parentRecId).add(GMF.Case__r.CaseNumber);
            }
            string CaseID;
            for(id obj : objToLockNew.keyset()){
                if(mapObject.containsKey(obj)){
                    CaseID = String.join(new List<String>(mapObject.get(obj)), ',');
                    if(!Test.isRunningTest()){
                    objToLockNew.get(obj).addError(PARENTERROR +CaseID);
                    }
                }
            }    
        }
     } 
    
    /*** Validation 1.0  #06596
        Method - lockChildGMF1()
        Usage - Receives the child object as parameter and checks if it's parent object is attached to any "Ready to Send" Internal Case, if yes, locks it from editing
        Input Parameters - Id of parent record,Sobject child, Parent Object name as string
        Output Parameters - boolean : yes, if the child is to be locked 
    ***/                                            
    public static Map<String, set<String>> lockChildGMF1(List<sObject>listDLC,String ParentObjName,String ParentObjNameOnChildObject){
        Map<String, set<String>> mapObject=new Map<String, set<String>>();
        /*Run lockGMF Method based on value of TRG_LockGMF__c in the Org Trigger Configurations Custom Setting*/
        Boolean TRGLockGMF;
        if(!Test.isRunningTest()){
            Org_Trigger_Configurations__c triggerConfigSetting = Org_Trigger_Configurations__c.getInstance(CUSTOMSETTINGNAME);
            TRGLockGMF=triggerConfigSetting.TRG_LockGMF__c;
        }
        else{
            TRGLockGMF=True;
        }
        /*Check value of TRG_LockGMF__c in Trigger Configurations Record of Org Trigger Configurations Custom Setting*/
        if(!byPassGMFValidation && TRGLockGMF && !batchContext){
                set<ID> recordIds=new set<ID>();
                for(sObject criteria : listDLC){
                    recordIds.add((ID)criteria.get(ParentObjNameOnChildObject));//To Create Set of Parent Object from Child
                }
                String queryStrng = QUERYPART11 + ParentObjName + QUERYPART22 ;
                String parentID ;
                for(GMF_Change_Request__c GMF:Database.query(queryStrng)){
                    parentID = string.valueof(GMF.get(ParentObjName));
                    if(!mapObject.containsKey(parentID)){
                        mapObject.put(parentID, new Set<String>());
                    }
                    mapObject.get(parentID).add(GMF.Case__r.CaseNumber);
                }
            }
        return mapObject;
    }
    
    // Needs to be commented after updating all the related triggers with above logic
    /*public static boolean lockChildGMF(id parentObjToLock, Sobject childObjId,String parentObjName){
        
        boolean ErrorReturned = false;
        String queryStrng = QUERYPART1 + parentObjName + QUERYPART2 + parentObjToLock + QUERYPART3;system.debug('--queryStrng------'+queryStrng);
        list<GMF_Change_Request__c> listObj = Database.query(queryStrng);
        if(listObj.size() > 0){
            if(byPassGMFValidation==false){
                childObjId.addError(CHILDERROR +' : '+ listObj[0].Case__r.CaseNumber);
                ErrorReturned = true;  
            }
        }  
        return ErrorReturned ;  
    }*/
    
/***
Method - lockGMFdeletion()
Usage - Receives the child object as parameter and checks if it's parent object is attached to any "Ready to Send" Internal Case, if yes, then cannot be deleted
Input Parameters - Id of parent record,Sobject child, Parent Object name as string
Output Parameters - boolean : yes, if the child is to be locked 
***/
    
    /*public static boolean lockGMFdeletion(id parentObjToLock, Sobject childObjId,String parentObjName){
        
        boolean ErrorReturned = false;
        if(parentObjToLock != null){
            String queryStrng = QUERYPART1 + parentObjName + QUERYPART2 + parentObjToLock + QUERYPART3;
            list<GMF_Change_Request__c> listObj = Database.query(queryStrng);
            if(listObj.size() > 0){
                    childObjId.addError(CHILDERROR + listObj[0].Case__r.CaseNumber);
                    ErrorReturned = true;  
            } 
        } else {
                String queryStrng = QUERYPART1 + parentObjName + QUERYPART2 + childObjId.id + QUERYPART3;
                list<GMF_Change_Request__c> listObj = Database.query(queryStrng);
                if(listObj.size() > 0){
                    childObjId.addError(PARENTERROR + listObj[0].Case__r.CaseNumber);
                    ErrorReturned = true;  
                }    
            }       
        return ErrorReturned ;     
    }*/
        
/***
Method - internalGMFCaseBeforeUpdate()
Usage - Called by the beforeUpdate Internal GMF Case trigger to update ReadyToSend Date field when status changes to "Ready To Send"
Input Parameters - Trigger.new , Trigger.old
Output Parameters - no return statement 
***/
    public static void internalGMFCaseBeforeUpdate(list<Case> newCases, list<Case> oldCases){
        ID internalGMFCase = [Select id from RecordType where name = :INTERNALGMFCASELABEL and SobjectType = :CASELABEL LIMIT 1][0].id;
        list<Case> GMFcasesNew = new List<Case>();
        list<Case> GMFcasesOld = new List<Case>();
        for(Integer i = 0; i < newCases.size(); i++){
            if (newCases[i].recordtypeid == internalGMFCase && READYTOSEND.equalsIgnoreCase(newCases[i].Status) && newCases[i].Status != oldCases[i].Status){
                GMFcasesNew.add(newCases[i]);
                GMFcasesOld.add(oldCases[i]);
            }
        }
        if(GMFcasesNew.size() > 0) {   
            list<GMF_Change_Request__c> GMFCRs = new list<GMF_Change_Request__c>([Select id,ReadyToSendDate__c from GMF_Change_Request__c where Case__c IN :GMFcasesNew LIMIT 10000]);
            list<GMF_Change_Request__c> GMFCRsToUpdate = new list<GMF_Change_Request__c>();
            for(Integer i = 0; i < GMFcasesNew.size(); i++){
                    GMFcasesNew[i].ReadyToSendDate__c = system.now();
                    if(!(PROCESSINGERROR.equalsIgnoreCase(GMFcasesOld[i].Status) || PARTIALLYSENT.equalsIgnoreCase(GMFcasesOld[i].Status))){//Richa added for Req 6020
                        for(GMF_Change_Request__c gmf : GMFCRs){
                            gmf.ReadyToSendDate__c = system.now();
                            GMFCRsToUpdate.add(gmf);
                        }
                    }
            }
            if(GMFCRsToUpdate.size() > 0){
                Database.update(GMFCRsToUpdate,false);
            }
        }    
    }

/***
Method - partnerConnectionCreated()
Usage - creates PartnerNetworkConnect with CVS of the received GMF object
Input Parameters - list of active PartnerNetworkConnect, GMF Object
Output Parameters - list of PartnerNetworkRecordConnection
***/
    public static List<PartnerNetworkRecordConnection> partnerConnectionCreated(List<PartnerNetworkConnection> con,Sobject gmfObj){
        List<PartnerNetworkRecordConnection> shareRecords = new List<PartnerNetworkRecordConnection>();
        try{
            PartnerNetworkRecordConnection newrecord;
            for(PartnerNetworkConnection network : con){
                newrecord = new PartnerNetworkRecordConnection();
                newrecord.ConnectionId = network.Id;
                newrecord.LocalRecordId = (ID)gmfObj.get(EXTERNALCASE);
                newrecord.RelatedRecords = ATTACHMENT;
                newrecord.SendClosedTasks = false;
                newrecord.SendOpenTasks = false;
                newrecord.SendEmails = true;
                shareRecords.add(newrecord);  
            }
            return shareRecords;
        } catch (Exception ex){
            return null;
            }
        }
    
/***
Method - sendToCVSBATCH()
Usage - Receives the set of GMF objects whose PDF flag is true and sends it to CVS 
Input Parameters - set of objects
Output Parameters - no return statement
***/
    public static void sendToCVSBATCH(set<Sobject> gmfForCVS){
        try{
            List<Sobject> updateGMF = new List<Sobject>();
            List<Case> externalCaseUpdate = new List<Case>();
            List<PartnerNetworkRecordConnection> sharedRecords = new List<PartnerNetworkRecordConnection>();
            Map<Id,Sobject> mapCaseIdGMF = new Map<Id,Sobject>();
            
            List<PartnerNetworkConnection> connMap = [select 
                                                            Id, ConnectionStatus, ConnectionName 
                                                      from
                                                           PartnerNetworkConnection 
                                                      where 
                                                        ConnectionName =:Label.CB_Partner_Network_Connection AND ConnectionStatus = :ACCEPTED LIMIT 1];
            for(Sobject gmf : gmfForCVS){
                sharedRecords.addAll(partnerConnectionCreated(connMap,gmf));
                mapCaseIdGMF.put((ID)gmf.get(EXTERNALCASE),gmf);
            } 
            ID newCaseOwner = [Select Id from Group where Name = :QUEUENAME and Type = :QUEUE LIMIT 1][0].id;
            List<Database.Saveresult> saveResults = Database.insert(sharedRecords, false);
            Integer index = 0; 
            for(Database.Saveresult saveResult : saveResults){
                PartnerNetworkRecordConnection shareRecord = sharedRecords[index];
                Sobject gmfObj = mapCaseIdGMF.get(shareRecord.LocalRecordId);
                if(saveResult.isSuccess()){
                    Case extCase = new Case(id=shareRecord.LocalRecordId);
                    gmfObj.put(CVS,true);
                    gmfObj.put(SENTTOCVSDATE,system.now());
                    gmfObj.put(XML,false);
                    gmfObj.put(PDF,false);
                    gmfObj.put(SENDERROR,null);
                    extCase.OwnerId = newCaseOwner;
                    externalCaseUpdate.add(extCase);
                } else {
                     for(Database.Error err : saveResult.getErrors()) {
                         gmfObj.put(SENDERROR,err.getMessage());  
                     } 
                    }
                updateGMF.add(gmfObj);    
                index ++;
            }
            if(updateGMF.size()>0){ 
                Database.update(updateGMF,false); 
            }
            if(externalCaseUpdate.size()>0){
                Database.update(externalCaseUpdate,false);//did not include case in the updateGMF list because max 9 object allowed for DML
            }
        } catch (Exception ex){
                
            }
    }
      
/***
Method - updateExternalCase()
Usage - Receives the external GMF Case and updates its field values as per the grid
Input Parameters - Case object
Output Parameters - case instance
***/
    public static void updateExternalCase (Case caseInst,SObject GMFobj){
       try{ 
            BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true LIMIT 1];
            map<id,recordtype> DLrecordType = new map<id,recordtype>([select name from recordtype where sobjecttype = :DRUGLISTOBJ LIMIT 20]);
            Schema.sObjectType GMFobjType = GMFobj.getSObjectType();
            Schema.DescribeSObjectResult GMF = GMFobj.getSObjectType().getDescribe(); // getDecribe of GMF object
            String GMFkey = GMF.getLabel() + HASHTAG;
            if(DRUGLIST.equals(GMF.getLabel())){
                GMFkey = GMFkey + DLrecordType.get((ID)GMFobj.get(RTID)).name + HASHTAG;
                if(DRUGLIST.equals(DLrecordType.get((ID)GMFobj.get(RTID)).name)){
                       if(GMFobj.get(SENTTOCVSDATE) == null){
                           if(SpecialUseDL.contains(String.valueOf(GMFobj.get(SPCLUSE)))){
                               GMFkey = GMFkey + GMFobj.get(SPCLUSE) + HASHTAG;
                           } else {
                                     GMFkey = GMFkey + OTHERS + HASHTAG;  
                                  }
                      } else {
                               if(SpecialUseDLmnt.contains(String.valueOf(GMFobj.get(SPCLUSE)))){
                                   GMFkey = GMFkey + GMFobj.get(SPCLUSE) + HASHTAG;
                               } else {
                                     GMFkey = GMFkey + OTHERS + HASHTAG;  
                                  }   
                              }
                } else {
                           GMFkey = GMFkey + NOTAPPLICABLE + HASHTAG ; 
                        }
            } else {
                        GMFkey = GMFkey + NOTAPPLICABLE + HASHTAG + NOTAPPLICABLE + HASHTAG;
                    }
            GMFkey = GMFkey + (GMFobj.get(SENTTOCVSDATE) == null? NEWGMF : MNTGMF);
            if(externalCaseMap.keyset().contains(GMFkey)){
                caseInst.Description = externalCaseMap.get(GMFkey).CaseDescription;
                caseInst.CRD_GMF_Case_Status__c = NEWSTATUS;
                caseInst.Effective_Date__c = BusinessHours.add(defaultHours.id, system.today(), externalCaseMap.get(GMFkey).BusinessDays).date();
                caseInst.CRD_GMF_Case_Types__c = externalCaseMap.get(GMFkey).GMFtype;
            }
            //Below if block added as part of Req 6213
            if(batchContext){
                string selectedGMF = PERCENTLABEL + String.valueOf(GMFobj.get(NAME)) + PERCENTLABEL ;
                //list<GMF_Change_Request__c> gmfcr = new list<GMF_Change_Request__c>([Select id, case__r.Priority, case__r.Annual_Changes__c, GMF_Name__c from GMF_Change_Request__c where GMF_Name__c LIKE :selectedGMF and case__r.Status = :READYTOSEND order by case__r.Priority asc LIMIT 10000]); 
                string tempPriority;
                string annualChanges;
                for(GMF_Change_Request__c gmftemp : [Select id, case__r.Priority, case__r.Annual_Changes__c, GMF_Name__c from GMF_Change_Request__c where GMF_Name__c LIKE :selectedGMF and case__r.Status = :READYTOSEND order by case__r.Priority asc LIMIT 10000]){
                    if(HIGH.equalsIgnoreCase(gmftemp.case__r.Priority)){
                        tempPriority = HIGH;
                    } else if(MEDIUM.equalsIgnoreCase(gmftemp.case__r.Priority) && !LOW.EqualsIgnoreCase(tempPriority)){
                            tempPriority = MEDIUM;
                        } else if(LOW.equalsIgnoreCase(gmftemp.case__r.Priority) && String.isBlank(tempPriority)){
                            tempPriority = LOW;
                          }
                    /* 159230 - ST#1743 As per new Picklist Values for request 'Annual Changes'  : secondQuarter,fourthQuarter,BookofRecord*/
                    if(ANOC.equalsIgnoreCase(gmftemp.case__r.Annual_Changes__c)){
                        annualChanges = ANOC;
                    } else if(MIDYEAR.equalsIgnoreCase(gmftemp.case__r.Annual_Changes__c) && String.isBlank(annualChanges)){
                        annualChanges = MIDYEAR;
                    } else if(secondQuarter.equalsIgnoreCase(gmftemp.case__r.Annual_Changes__c) && String.isBlank(annualChanges)){
                        annualChanges = secondQuarter;
                    } else if(fourthQuarter.equalsIgnoreCase(gmftemp.case__r.Annual_Changes__c) && String.isBlank(annualChanges)){
                        annualChanges = fourthQuarter;
                    } else if(BookofRecord.equalsIgnoreCase(gmftemp.case__r.Annual_Changes__c) && String.isBlank(annualChanges)){
                        annualChanges = BookofRecord;
                    }
                }
                caseInst.Priority = tempPriority;
                caseInst.Annual_Changes__c = annualChanges;
           }
        } catch (Exception ex) {
                caseInst.addError(ex);
            }  
    }

// a map created to contain the values of External GMF Case fields to be updated on the basis of their type    
    public static Map<String,wrapExtCaseFields> externalCaseMap = new Map<String,wrapExtCaseFields>{      
        //Map Entries as per the excel sheet provided          
        'Drug List#Drug List#Specialty List#New GMF'=>new wrapExtCaseFields('New Specialty list. This will need to be manually created.Please provide all documentation to support DL record type Drug List for Specialty including SRx module list for forced to specialty',15,'New GMF'),
        'Drug List#Drug List#Waiver of Deductible#New GMF'=>new wrapExtCaseFields('New Deductible waiver drug list to be built on RxClaim. Please provide all documentation to support DL record type Drug List. Status on GPI\'s should be \'c\'.',15,'New GMF'),
        'Drug List#Drug List#Drug Specific Copay#New GMF'=>new wrapExtCaseFields('New drug specific copay list to be built on RxClaim. Please provide all documentation to support a new DL record type drug list.Copay\'s will be specified per plan on their CRD.',15,'New GMF'),
        'Drug List#Drug List#Others#New GMF'=>new wrapExtCaseFields('New drug list to be built on RxClaim. Please provide all documentation to support a new DL record type drug list.',15,'New GMF'),
        'Drug List#Quantity Limit#NA#New GMF'=>new wrapExtCaseFields('New Quantity Limit (Clinical list) list. This will need to be manually created. Please provide all documentation to support DL record type Quantity Limit including clinical edit code on default GPI, and any restrict NDC\'s that exist on the GPI or a restrict NDC list, diagnosis lists, and anything else necessary to validate list.',15,'New GMF'),
        'Drug List#Step Therapy#NA#New GMF'=>new wrapExtCaseFields('New Step Therapy (Clinical list) list. This will need to be manually created. Please provide all documentation to support DL record type Step Therapy including clinical edit code on default GPI, and any restrict NDC\'s that exist on the GPI or a restrict NDC list, diagnosis lists, transition fill, and anything else necessary to validate list.',15,'New GMF'),
        'Drug List#Prior Authorization#NA#New GMF'=>new wrapExtCaseFields('New Prior Authorization (Clinical list) list. This will need to be manually created. Please provide all documentation to support DL record type Prior Authorization including clinical edit code on default GPI, and any restrict NDC\'s that exist on the GPI or a restrict NDC list, diagnosis lists, transition fill, and anything else necessary to validate list.',15,'New GMF'),
        'Drug List#Prior Authorization#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to DL. Please provide all documentation to support DL record type Prior Authorization.',7,'Maintenance GMF'),
        'Drug List#Quantity Limit#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to DL. Please provide all documentation to support DL record type Quantity limit.',7,'Maintenance GMF'),
        'Drug List#Step Therapy#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to DL. Please provide all documentation to support DL record type Step Therapy.',7,'Maintenance GMF'),
        'Drug List#Drug List#Specialty List#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to Specialty DL. Please provide all documentation to support DL record type drug list.  We will need to see benefit coding, force to specialty coding, and testing to support force to specialty.',7,'Maintenance GMF'),
        'Drug List#Drug List#Waiver of Deductible#Maintenance GMF'=>new wrapExtCaseFields('Deductible waiver Maintenance updates to DL. Please provide all documentation to support DL record type Drug List. Status on GPI\'s should be \'c\'.',7,'Maintenance GMF'),
        'Drug List#Drug List#Others#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to DL. Please provide all documentation to support DL record type Drug List.',7,'Maintenance GMF'),
        'Formulary#NA#NA#New GMF'=>new wrapExtCaseFields('New formlulary ID.  Please be aware of termination date of lists on the FRM.',15,'New GMF'),
        'Formulary#NA#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates to formlulary ID. Please be aware of termination date of lists on the FRM.',7,'Maintenance GMF'),
        'Formulary List#NA#NA#New GMF'=>new wrapExtCaseFields('New Formulary list. This will need to be manually created. We will need to see a screenshot of the option code for the list created as we have been told changing it after the list is created is difficult. Please provide back a query like report (plan drill or macro output) of the entire list including effective and term dates, MNOY codes, status code, and any restrict NDC\'s that exist on the GPI or a restrict NDC list.',15,'New GMF'),
        'Formulary List#NA#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintnenance formulary updates due to medispan and/or contractual changes.',7,'Maintenance GMF'),
        'Generic Code Conversion#NA#NA#Maintenance GMF'=>new wrapExtCaseFields('Commercial Generic Code Conversion updates.',7,'Maintenance GMF'),
        'Object List#NA#NA#New GMF'=>new wrapExtCaseFields('New list for Diagnosis, Lab test, Prescriber, Prescriber specialty, or Provider list needs created on RxClaim for use with clinical edit smart edit.Provide supporting documentation of list setup.',15,'New GMF'),
        'Object List#NA#NA#Maintenance GMF'=>new wrapExtCaseFields('Maintenance updates for Diagnosis, Lab test, Prescriber, Prescriber specialty, or Provider list needs created on RxClaim for use with clinical edit smart edit.  Provide supporting documentation of list changes.',7,'Maintenance GMF'),
        'Option Code#NA#NA#New GMF'=>new wrapExtCaseFields('New option code for Aetna formularies and formulary lists.',15,'New GMF')
    };

/***
Method - wrapExtCaseFields
Usage - Wrapper class to create a map to populate values in External GMF Case
Input Parameters - Case Description, number of Days added
Output Parameters - N/A
***/    
    public without sharing class wrapExtCaseFields {
        string CaseDescription;
        string GMFtype;
        long BusinessDays;
        wrapExtCaseFields(string cd, Integer bd, string gmft){
            CaseDescription = cd;
            //BusinessDays = bd*86400000; counting 1 day = 24 hrs
            BusinessDays = bd*36000000; //counting 1 day = 10 hrs
            GMFtype = gmft;
        } 
    }           
}