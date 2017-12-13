/*Purpose: Apex Batch Class for Generating XML For CRDs
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
1.0         Sushant         30 April'14         Apex Batch Class for Generating XML For CRDs
======================================================================== */

global class Batch_CRDXMLStep implements Database.Batchable <sObject> {
 
 global string query;

 
 global Batch_CRDXMLStep(){
   query = 'Select id,name,CRD__c,CAG__c,Case__c,CVS__c,FalloutCase__c,PDF__c,PERS__c,XML__c from CRDBuildOrder__c where CAG__c = TRUE AND XML__c = FALSE';
   }
   
 global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(query);
     }
     
 global void execute(Database.BatchableCOntext BC,List <CRDBuildOrder__c> crdBuilder){
       String CaseID;
       Map<String,Case> mapcrdBuilderToCase = new Map<String,Case>();
     for(CRDBuildOrder__c crdBO : crdBuilder){
        try{
            ApexPages.StandardController sc = new ApexPages.StandardController(new crd__c(id=crdbo.crd__c));
            GMF_XML_CRD_Controller gmf = new GMF_XML_CRD_Controller(sc); 
            CaseID = gmf.generateCaseAndXML();
            crdbo.case__c = CaseID;
            crdbo.XML__c = TRUE;
            }                
    catch(exception e){
        
        mapcrdBuilderToCase.put(
                        crdBo.id
                        ,CB_CaseLogger.logCase('Batch_CRDXMLStep - FAILED'
                                        ,'PROCESS- Batch_CRDXMLStep , STATUS - FAILED,  XML NOT CREATED'
                                        ,CaseID
                                        ,crdbo.crd__c
                                        ,crdbo.controlplaneffective__c)
                    );
        //crdbo.FalloutCase__c = c.id;
    }   
    
 }  
    insert mapcrdBuilderToCase.values();
    for(CRDBuildOrder__c crdBO : crdBuilder){
        if(mapcrdBuilderToCase.containsKey(crdBo.id)){
            crdbo.FalloutCase__c = mapcrdBuilderToCase.get(crdBo.id).id;
        }
    } 
   update crdbuilder;
}         
  global void finish(Database.BatchableCOntext BC){
  
  } 
}