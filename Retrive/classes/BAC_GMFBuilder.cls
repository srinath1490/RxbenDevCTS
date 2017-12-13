/*Purpose: Apex Batch Class to pick GMFCR records to be sent to CVS  
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           14 Jul 2015       Apex Batch Class to pick GMFCR records to be sent to CVS for Req 5919
=================================================================================================*/ 
global class BAC_GMFBuilder implements Database.Batchable<Sobject>, Database.Stateful, Schedulable{
    
    global final string query;
    Map<String,set<id>> GMFdeduped = new Map<String,set<id>>();
    private static final string CPG = 'Clinical Program Group';
    private static final string CP = 'Clinical Programs';
    private static final string DG = 'Drug Group';
    private static final string FORMULARY = 'Formulary';
    private static final string FL = 'Formulary List';
    private static final string GCC = 'Generic Code Conversion';
    private static final string OL = 'Object Lists';
    private static final string OC = 'Option Codes';
    set<sObject> unprocessedObjects = new set<sObject>();
    set<sObject> newObjects = new set<sObject>();
    private static final string BUILDERQUERY = 'Select id,recordType.name,Clinical_Program_Group__r.name,Clinical_Program_Group__r.LastModifiedDate,Clinical_Program_Group__r.Sent_To_CVS_Date__c,Clinical_Program_Group__r.Send_Error__c,'+
            'Clinical_Program__r.name,Clinical_Program__r.LastModifiedDate,Clinical_Program__r.Sent_To_CVS_Date__c,Clinical_Program__r.Send_Error__c,Drug_Group__r.name,Drug_Group__r.LastModifiedDate,Drug_Group__r.Send_Error__c,'+
            'Drug_Group__r.Sent_To_CVS_Date__c,Formulary__r.name,Formulary__r.LastModifiedDate,Formulary__r.Sent_To_CVS_Date__c,Formulary__r.Send_Error__c,Formulary_List__r.name,Formulary_List__r.Send_Error__c,'+
            'Formulary_List__r.LastModifiedDate,Formulary_List__r.Sent_To_CVS_Date__c,Generic_Code_Conversion__r.name,Generic_Code_Conversion__r.LastModifiedDate,Generic_Code_Conversion__r.Send_Error__c,'+
            'Generic_Code_Conversion__r.Sent_To_CVS_Date__c,Object_List__r.name,Object_List__r.Send_Error__c,Object_List__r.LastModifiedDate,Object_List__r.Sent_To_CVS_Date__c,Option_Code__r.name,Option_Code__r.Send_Error__c,'+
            'Option_Code__r.LastModifiedDate,Option_Code__r.Sent_To_CVS_Date__c,Drug_List__r.name,Drug_List__r.LastModifiedDate,Drug_List__r.Sent_To_CVS_Date__c,Drug_List__r.Send_Error__c,XML__c'+
            ' from GMF_Change_Request__c where Case__r.Status=\'Ready To Send\' and Case__r.recordType.name = \'Internal GMF Case\' and PDF__c = false order by recordType.name ';

/**
* Method :- BAC_GMFBuilder 
* Description :- This method acts as an constructor to form the query where all GMFCRs need to be fetched
**/      
    global BAC_GMFBuilder(){
        query = BUILDERQUERY ;    
    }
    
/**
* Method :- start 
* Description :- This method passes the query and fetches the GMFCRs accordingly
**/    
    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
/**
* Method :- execute 
* Description :- This method dedups the GMFs 
**/    
    global void execute (Database.BatchableContext BC, list<GMF_Change_Request__c> scope){
        DedupedMap(scope); //Dedupe the GMFs received from multiple GMFCRs
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
/**
* Method :- finish 
* Description :- This method calls the GMF_GenerateXML class to generate XML of the deduped GMFs
**/    
    global void finish(Database.BatchableContext BC){
        GMFBuilderUtil.batchContext = true;    //set the batchContext variable to true
        unprocessedObjects.removeAll(newObjects); //remove failed GMFs from the list, incase new GMFCRs have been created for them 
        if(unprocessedObjects.size() > 0){ //Added as per Request 06020 - Ability to Manually Reprocess Failed GMF Internal Cases
            list<sobject> updateObjects = new list<sobject>(unprocessedObjects);
            Database.update(updateObjects,false); // need to reset the Send Error Description to null so that it can be picked by XML/PDF/CVS batches
        } else {}
        if(!GMFdeduped.isEmpty()){ // if records are found for XML generation
            GMF_XMLWrapperUtil XMLUtil = new GMF_XMLWrapperUtil(GMFdeduped); // send the eligible records for XML generation
            BAC_GMF_XMLGenerator XMLBatch = new BAC_GMF_XMLGenerator();
            XMLBatch.passedids = XMLUtil.GMF_XMLWrapperlist;
            Database.executeBatch(XMLBatch,1);
        } else {}

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }

/**
* Method :- execute 
* Description :- This method schedules the BAC_GMFBuilder class
**/    
     global void execute(SchedulableContext sc) {
        Database.executeBatch(new BAC_GMFBuilder(),2);
    }

/**
* Method :- DedupedMap 
* Description :- This method dedupes the GMFs from the list of GMFCRs
**/     
    global void DedupedMap(List<GMF_Change_Request__c> GMFCRtoprocess){
             
        for(GMF_Change_Request__c gmfcr : GMFCRtoprocess){ //find out the type of GMF object attached to the GMFCR
           String GMFname;
           if(CPG.equals(gmfcr.recordtype.name)){   //if GMF object is Clinical Program Group
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Clinical_Program_Group__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Clinical_Program_Group__r);
               } else {
                   GMFname = gmfcr.Clinical_Program_Group__r.id;        //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Clinical_Program_Group__r);
                 }  
           }else if(CP.equals(gmfcr.recordtype.name)){    //if GMF object is Clinical Program
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Clinical_Program__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Clinical_Program__r);
               } else {
                   GMFname = gmfcr.Clinical_Program__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Clinical_Program__r);
                 }
           }else if(DG.equals(gmfcr.recordtype.name)){    //if GMF object is Drug Group
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Drug_Group__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Drug_Group__r);
               } else {
                   GMFname = gmfcr.Drug_Group__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Drug_Group__r);
                 }  
           }else if(FORMULARY.equals(gmfcr.recordtype.name)){    //if GMF object is Formulary
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Formulary__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Formulary__r);
               } else {
                   GMFname = gmfcr.Formulary__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Formulary__r);
                 }
           }else if(FL.equals(gmfcr.recordtype.name)){    //if GMF object is Formulary List
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Formulary_List__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Formulary_List__r);
               } else {
                   GMFname = gmfcr.Formulary_List__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Formulary_List__r);
                 }  
           }else if(GCC.equals(gmfcr.recordtype.name)){    //if GMF object is Generic Code Conversion
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Generic_Code_Conversion__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Generic_Code_Conversion__r);
               } else {
                   GMFname = gmfcr.Generic_Code_Conversion__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Generic_Code_Conversion__r);
                 }  
           }else if(OL.equals(gmfcr.recordtype.name)){    //if GMF object is Drug List
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Object_List__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Object_List__r);
               } else {
                   GMFname = gmfcr.Object_List__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Object_List__r);
                 }  
           }else if(OC.equals(gmfcr.recordtype.name)){    //if GMF object is Option Code
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Option_Code__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Option_Code__r);
               } else {
                   GMFname = gmfcr.Option_Code__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Option_Code__r);    
                 }  
           }else {    //if GMF object is Drug List
               if(gmfcr.XML__c) {    //in case it failed earlier, reset the Send Error Description field
                   gmfcr.Drug_List__r.Send_Error__c = null;
                   unprocessedObjects.add(gmfcr.Drug_List__r);
               } else {
                   GMFname = gmfcr.Drug_List__r.id;    //in case a new GMFCR has been created for the GMF
                   newObjects.add(gmfcr.Drug_List__r); 
                 }   
           }     
            
           if(GMFname != Null){    //create a map with key as GMF object name and values as list of all the GMFs of similar type
               if(GMFdeduped.containsKey(gmfcr.recordtype.name)){
                   GMFdeduped.get(gmfcr.recordtype.name).add(GMFname);    
               }else{
                   GMFdeduped.put(gmfcr.recordtype.name, new set<id>{GMFname} );
                 }
           }  else {}    
         } 
    }
}