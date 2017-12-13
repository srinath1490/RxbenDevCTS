/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Becca Allen     01-28-15            AutoRelateNCPDP()
   1.1 -    Jenna Vuong     02-12-15            Refactor 1 trigger per object,recursion,UpdateStageOfMatchingRequests(),getCVSRecordType(),getESIRecordType()
======================================================================== */

public with sharing class PharmacyNetworkRequestClass1 {

    // recursion
    @TestVisible private boolean isExecuting = false;
    @TestVisible private integer BatchSize = 0;
    @TestVisible private RecordType recordTypeCVS, recordTypeESI, recordTypeGEO, recordTypeNonGEO;
       
    public PharmacyNetworkRequestClass1 (boolean isExecuting, integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
        recordTypeCVS = [ Select Id, Name From RecordType Where Name = 'Inbound - CVS' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        //recordTypeESI = [ Select Id, Name From RecordType Where Name = 'Inbound - ESI' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        recordTypeGEO = [ Select Id, Name From RecordType Where Name = 'Outbound - GEO' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        recordTypeNonGEO = [ Select Id, Name From RecordType Where Name = 'Outbound - NonGEO' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
    }
    
    @TestVisible private Id getRecordTypeCVS () {   
        RecordType localCVSRecordType = [ Select Id From RecordType Where Name = 'Inbound - CVS' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];   
        return localCVSRecordType.Id;   
    }
    /*@TestVisible private Id getRecordTypeESI () {
        RecordType localESIRecordType = [ Select Id From RecordType Where Name = 'Inbound - ESI' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        return localESIRecordType.Id;
    } */
    @TestVisible private Id getRecordTypeGEO () {
        RecordType localGEORecordType = [ Select Id From RecordType Where Name = 'Outbound - GEO' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        return localGEORecordType.Id;
    }
    @TestVisible private Id getRecordTypeNonGEO () {
        RecordType localNonGEORecordType = [ Select Id From RecordType Where Name = 'Outbound - NonGEO' and sObjectType = 'Pharmacy_Network_Request__c' and isActive = true LIMIT 1 ];
        return localNonGEORecordType.Id;
    }
    
    // Update PNR stage
    public void UpdateStageOfMatchingRequests (List<Pharmacy_Network_Request__c> requests) {
      
        Id CVSRecordType = getRecordTypeCVS(), GEORecordType = getRecordTypeGEO(), NonGEORecordType = getRecordTypeNonGEO();
        System.debug('CVS Record Type Id: ' + CVSRecordType  + 'GEO Record Type Id: ' + GEORecordType + 'NonGEO Record Type Id: ' + NonGEORecordType);
        
        // get incoming NCPDPs
        Set<Id> NCPDPvalues = new Set<Id>();
        
        if (requests != null && requests.size() > 0) {
            
            for (Pharmacy_Network_Request__c r : requests) {
                if (r.NCPDP_Pharmacy_Database__c != null) {
                    NCPDPvalues.add(r.NCPDP_Pharmacy_Database__c);
                }
            }
        }
        System.debug('NCPDPvalues: ' + NCPDPvalues);
        
        // find matching PNRs
        List<Pharmacy_Network_Request__c> findMatches = new List<Pharmacy_Network_Request__c>();
        findMatches = [ Select Id, Closed__c, NCPDP_Pharmacy_Database__c, RecordTypeId From Pharmacy_Network_Request__c 
                                               Where NCPDP_Pharmacy_Database__c IN :NCPDPvalues and Closed__c = false ];
        System.debug('findMatches: ' + findMatches);
        
        List<Pharmacy_Network_Request__c> PNRmatchesCVS = new List<Pharmacy_Network_Request__c>();
        
        for ( Pharmacy_Network_Request__c p : findMatches) {
                                                   
                                                   if ((p.RecordTypeId == CVSRecordType)||(p.RecordTypeId == GEORecordType)||(p.RecordTypeId == NonGEORecordType)) {
                                                       PNRmatchesCVS.add(p);
                                                   }
                                               } 
        
        List<Pharmacy_Network_Request__c> PNRmatchesESI = new List<Pharmacy_Network_Request__c>();
        for ( Pharmacy_Network_Request__c p : [ Select Id, Closed__c, NCPDP_Pharmacy_Database__c, RecordTypeId From Pharmacy_Network_Request__c 
                                               Where NCPDP_Pharmacy_Database__c = :NCPDPvalues and Closed__c = false ]) {
                                                   
                                                  /* if (p.RecordTypeId == ESIRecordType) {
                                                       PNRmatchesESI.add(p);
                                                   }*/
                                               }
       
        if (PNRmatchesCVS != null && PNRmatchesCVS.size() > 0) {
 
            for (Pharmacy_Network_Request__c r : requests) {
                
                if ((r.RecordTypeId == CVSRecordType)||(r.RecordTypeId == GEORecordType)||(r.RecordTypeId == NonGEORecordType)) {
                    r.Stage__c = 'Duplicate Request';
                }
            }
        }
        
        if (PNRmatchesESI != null && PNRmatchesESI.size() > 0) {
            
            for (Pharmacy_Network_Request__c r : requests) {
                
               /* if (r.RecordTypeId == ESIRecordType) {
                    r.Stage__c = 'Duplicate Request';
                }*/
            }
        }
    }
    
    // Auto Relate records to NCPDP Database
    public void AutoRelateNCPDP (List<Pharmacy_Network_Request__c> requests) {
        //Called in before insert trigger
        
        List<Pharmacy_Network_Request__c> requestsToAdd = new List<Pharmacy_Network_Request__c>();
        Set<String> NCPDPSet = new Set<String>();
        
        for (Pharmacy_Network_Request__c r : requests) {
            NCPDPSet.add(r.NCPDP__c);
        }
        
        List<String> NCPDPDatabaseIDs = new List<String>();
        NCPDPDatabaseIDs.addAll(NCPDPSet);
        
        //Query for NCPDP Database
        List<NCPDP_Pharmacy_Database__c> NCPDPs = [ Select Id, Name From NCPDP_Pharmacy_Database__c where Name != null AND Name IN :NCPDPDatabaseIDs ];
        
        Map<String,String> NCPDPIDs = new Map<String,String>{};
        for (NCPDP_Pharmacy_Database__c p: NCPDPs)
            NCPDPIDs.put(p.Name,p.Id);
        
        //Auto Relating NCPDP Database to Network Requests
        for (Pharmacy_Network_Request__c r : requests) {
            
            if ( r.NCPDP__c != null && r.NCPDP_Pharmacy_Database__c == null ) {
                system.debug(logginglevel.FINEST,'adding requests to relating NCPDP list:' + r);

                requestsToAdd.add(r);
            }
        }
        if (requestsToAdd !=NULL && requestsToAdd.size()>0) {
            system.debug(logginglevel.FINEST,'Relating Requests to NCPDPs:'+requests);
            
            for (Pharmacy_Network_Request__c r : requestsToAdd) {
                
                if (r.NCPDP__c != null && r.NCPDP_Pharmacy_Database__c == null) {
                    r.NCPDP_Pharmacy_Database__c = NCPDPIDs.get(r.NCPDP__c);
                    //r.NCPDP_Pharmacy_Database__r.Pharmacy_Contract_Information__c=r.Id;
                }
            }
        }
       
    }

    public boolean IsTriggerContext {
        get { return isExecuting; }
    }
    
    public boolean IsVisualforcePageContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsWebServiceContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsExecuteAnonymousContext {
        get { return !IsTriggerContext; }
    }
    
}