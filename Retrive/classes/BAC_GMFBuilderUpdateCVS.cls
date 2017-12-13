/*Purpose: Apex Batch Class to pick GMFCR records to be sent to CVS  
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           14 Jul 2015       Apex Batch Class to pick GMFCR records to be sent to CVS for Req 5919
=================================================================================================*/ 
global class BAC_GMFBuilderUpdateCVS implements Database.Batchable<Sobject>,Database.Stateful, Schedulable{
    
    global final string query;
    private static final string CPG = 'Clinical Program Group';
    private static final string CP = 'Clinical Programs';
    private static final string DG = 'Drug Group';
    private static final string FORMULARY = 'Formulary';
    private static final string FL = 'Formulary List';
    private static final string GCC = 'Generic Code Conversion';
    private static final string OL = 'Object Lists';
    private static final string OC = 'Option Codes';
    private static final string CONGAFAILURE = 'Conga Failure';
    set<Sobject> gmfs = new set<Sobject>();
    set<Sobject> updateGMFs = new set<Sobject>();
    private static final string CVSQUERY = 'Select id,recordType.name,Clinical_Program_Group__r.name,Clinical_Program_Group__r.External_Case__r.id,Clinical_Program_Group__r.LastModifiedDate,'+
        'Clinical_Program_Group__r.Sent_To_CVS_Date__c,Clinical_Program__r.name,Clinical_Program__r.External_Case__r.id,Clinical_Program__r.LastModifiedDate,'+
        'Clinical_Program__r.Sent_To_CVS_Date__c,Drug_Group__r.name,Drug_Group__r.External_case__r.id,Drug_Group__r.LastModifiedDate,Drug_Group__r.Sent_To_CVS_Date__c,'+
        'Formulary__r.name,Formulary__r.External_Case__r.id,Formulary__r.LastModifiedDate,Formulary__r.Sent_To_CVS_Date__c,Formulary_List__r.name,'+
        'Formulary_List__r.External_case__r.id,Formulary_List__r.LastModifiedDate,Formulary_List__r.Sent_To_CVS_Date__c,Generic_Code_Conversion__r.name,Generic_Code_Conversion__r.LastModifiedDate,'+
        'Generic_Code_Conversion__r.External_Case__r.id,Generic_Code_Conversion__r.Sent_To_CVS_Date__c,Object_List__r.name,Object_List__r.LastModifiedDate,Object_List__r.Sent_To_CVS_Date__c,Option_Code__r.name,'+
        'Object_List__r.External_Case__r.id,Option_Code__r.External_Case__r.id,Option_Code__r.LastModifiedDate,Option_Code__r.Sent_To_CVS_Date__c,Drug_List__r.name,Drug_List__r.LastModifiedDate,Drug_List__r.Sent_To_CVS_Date__c,'+
        'Clinical_Program_Group__r.PDF__c,Clinical_Program__r.PDF__c,Drug_Group__r.PDF__c,Formulary__r.PDF__c,Formulary_List__r.PDF__c,Generic_Code_Conversion__r.PDF__c,Object_List__r.PDF__c,Option_Code__r.PDF__c,Drug_List__r.PDF__c,Clinical_Program_Group__r.Send_Error__c,Clinical_Program__r.Send_Error__c,Drug_Group__r.Send_Error__c,Formulary__r.Send_Error__c,Formulary_List__r.Send_Error__c,Generic_Code_Conversion__r.Send_Error__c,Object_List__r.Send_Error__c,Option_Code__r.Send_Error__c,Drug_List__r.Send_Error__c,'+
        'Drug_List__r.External_Case__r.id from GMF_Change_Request__c where XML__c = TRUE and CVS__c = FALSE and Case__r.Status = \'Ready To Send\' and case__r.recordtype.name = \'Internal GMF Case\' order by recordType.name LIMIT 80000';
    
/**
* Method :- BAC_GMFBuilderUpdateCVS 
* Description :- This method acts as an constuctor to form the query where all GMFCRs need to be fetched
**/      
    global BAC_GMFBuilderUpdateCVS(){
        query = CVSQUERY ;
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
* Description :- This method calls the sendToCVSBATCH method of GMFBuilderUtil class to send the GMFs to CVS 
**/    
    global void execute (Database.BatchableContext BC, list<GMF_Change_Request__c> scope){

        for(GMF_Change_Request__c gmfcr : scope){ //Identifying which GMF is received in the GMFCR
           if(CPG.equals(gmfcr.recordtype.name)){    //GMF received is Clinical Pogram Group
               if(gmfcr.Clinical_Program_Group__r.PDF__c){
                   gmfs.add(gmfcr.Clinical_Program_Group__r);
               }else{
                   gmfcr.Clinical_Program_Group__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Clinical_Program_Group__r);
               }
           }else if(CP.equals(gmfcr.recordtype.name)){    //GMF received is Clinical Pogram
               if(gmfcr.Clinical_Program__r.PDF__c){
                   gmfs.add(gmfcr.Clinical_Program__r);
               }else{
                   gmfcr.Clinical_Program__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Clinical_Program__r);
               }
           }else if(DG.equals(gmfcr.recordtype.name)){    //GMF received is Drug Group
               if(gmfcr.Drug_Group__r.PDF__c){
                   gmfs.add(gmfcr.Drug_Group__r);
               }else{
                   gmfcr.Drug_Group__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Drug_Group__r);
               }
           }else if(FORMULARY.equals(gmfcr.recordtype.name)){    //GMF received is Formulary
               if(gmfcr.Formulary__r.PDF__c){
                   gmfs.add(gmfcr.Formulary__r);
               }else{
                   gmfcr.Formulary__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Formulary__r);
               }
           }else if(FL.equals(gmfcr.recordtype.name)){    //GMF received is Formulary List
               if(gmfcr.Formulary_List__r.PDF__c){
                   gmfs.add(gmfcr.Formulary_List__r);
               }else{
                   gmfcr.Formulary_List__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Formulary_List__r);
               }
           }else if(GCC.equals(gmfcr.recordtype.name)){    //GMF received is Generic Code Conversion
               if(gmfcr.Generic_Code_Conversion__r.PDF__c){
                   gmfs.add(gmfcr.Generic_Code_Conversion__r);
               }else{
                   gmfcr.Generic_Code_Conversion__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Generic_Code_Conversion__r);
               }
           }else if(OL.equals(gmfcr.recordtype.name)){    //GMF received is Object List
               if(gmfcr.Object_List__r.PDF__c){
                   gmfs.add(gmfcr.Object_List__r);
               }else{
                   gmfcr.Object_List__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Object_List__r);
               }
           }else if(OC.equals(gmfcr.recordtype.name)){    //GMF received is Option Code
               if(gmfcr.Option_Code__r.PDF__c){
                   gmfs.add(gmfcr.Option_Code__r);
               }else{
                   gmfcr.Option_Code__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Option_Code__r);
               }
           }else {    //GMF received is Drug List
               if(gmfcr.Drug_List__r.PDF__c){
                   gmfs.add(gmfcr.Drug_List__r);
               }else{
                   gmfcr.Drug_List__r.Send_Error__c = CONGAFAILURE;
                   updateGMFs.add(gmfcr.Drug_List__r);
               }     
           }
        }
        for(integer i=0;i<1000000;i++) { 
        system.debug(i);
        }
    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani  
    }
    
/**
* Method :- finish 
* Description :- send the eligible GMFs to CVS and then call the BAC_GMFBuilderUpdateCase batch
**/    
    global void finish(Database.BatchableContext BC){
        if(gmfs.size() > 0){
            GMFBuilderUtil.sendToCVSBATCH(gmfs); //send the eligible GMFs to CVS
        } else {}
        if(updateGMFs.size() > 0){
            list<sobject> updateObjects = new list<sobject>(updateGMFs);
            Database.update(updateObjects,false);
        } else {}
        Database.executeBatch(new BAC_GMFBuilderUpdateCase(),50);

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
/**
* Method :- execute 
* Description :- This method schedules the BAC_GMFBuilderUpdateCVS class
**/    
     global void execute(SchedulableContext sc) {
        Database.executeBatch(new BAC_GMFBuilderUpdateCVS(),1);
    }
        
}