/*Purpose: Apex Batch Class to share case records
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      5/21/2014           Apex Batch Class to share case records
  
======================================================================== */
global class BAC_CB_ShareCases implements Database.Batchable < sObject >{
    
    global String query ;
     
     
    global BAC_CB_ShareCases() {
         query = 'select id, XML__c, PDF__c, Case__c, CRD__c ,CVS__c from CRDBuildOrder__c where XML__c = true AND PDF__c=true AND CVS__c=false';
        //query = Passedquery;
       
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < CRDBuildOrder__c > crdBuildOrder) {
           List<PartnerNetworkRecordConnection> sharedRecords = new List<PartnerNetworkRecordConnection>();
           List<CRDBuildOrder__c> lstCrdBuilderToUpdate = new List<CRDBuildOrder__c>();
           List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>();
           connMap = [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionName =: 'Aetna'];
           
           
           
            for(CRDBuildOrder__c objCrdBuild : crdBuildOrder){
               system.debug('CRDbuilder records'+ objCrdBuild); 
                
                for(PartnerNetworkConnection network : connMap){
                    PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
                    newrecord.ConnectionId = network.Id;
                    newrecord.LocalRecordId = objCrdBuild.Case__c;  
                    newrecord.RelatedRecords = 'Attachment';
                    newrecord.SendClosedTasks = false;
                    newrecord.SendOpenTasks = false;
                    newrecord.SendEmails = true;
                    sharedRecords.add(newrecord);  
                }    
                objCrdBuild.CVS__c = true;
                lstCrdBuilderToUpdate.add(objCrdBuild);
                
                
            }
            try{
                system.debug('CRDbuildertoBeUpdated records'+ lstCrdBuilderToUpdate);
                update lstCrdBuilderToUpdate;
                insert sharedRecords;
            }catch(Exception ex){
                case c = new case();               
                c.Status='New';
                c.RecordTypeID = [Select c.id from RecordType c where isActive = true and DeveloperName = 'Internal_CRD_GMF_Process' and sobjecttype = 'Case'].id;
                 
                insert c;
                
            }
    }


    global void finish(Database.BatchableContext BC) {
     
    }
}