/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong		02-20-15			AutoRelateNCPDP()
======================================================================== */

public class NCPDP_PharmacyDatabaseClass {
    
    // recursion
	@TestVisible private boolean isExecuting = false;
    @TestVisible private integer BatchSize = 0;
    
    public NCPDP_PharmacyDatabaseClass (boolean isExecuting, integer size) {
		isExecuting = isExecuting;
		BatchSize = size;
    }
    
    // Auto relate NCPDPs to PNR records
    public void AutoRelateNCPDP (List<NCPDP_Pharmacy_Database__c> ncpdps) {
        
		// put incoming NCPDPs in map for retrieval
    	Map<String,Id> mapNCPDPs = new Map<String,Id>();
    
    	if (ncpdps != null) {
        
        	for (NCPDP_Pharmacy_Database__c n : ncpdps) {
            	mapNCPDPs.put(n.Name, n.Id);
        	}
    	}
    
    	// get all PNRs w same NCPDP
    	List<Pharmacy_Network_Request__c> PNRmatches = new List<Pharmacy_Network_Request__c>([ Select Id, Name, NCPDP__c From Pharmacy_Network_Request__c 
                                                                                              Where NCPDP__c = :mapNCPDPs.keySet() ]);
    
    	List<Pharmacy_Network_Request__c> requestsToUpdate = new List<Pharmacy_Network_Request__c>();
    
    	for (Pharmacy_Network_Request__c p : PNRmatches) {
        	p.NCPDP_Pharmacy_Database__c = mapNCPDPs.get(p.NCPDP__c);
        	requestsToUpdate.add(p);
    	}
		
        try {
            update requestsToUpdate;
            
        } catch (DmlException e) {
            System.debug('Error! PNR records were not updated w corresponding NCPDP Pharmacy Database records.');
        }
    }
}