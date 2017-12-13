/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong     02-20-15            Test_AutoRelateNCPDP()
======================================================================== */

@isTest
private class Test_NCPDP_PharmacyDatabaseClass {

    static testMethod void Test_AutoRelateNCPDP (){
        NCPDP_Pharmacy_Database__c testNCPDP1 = new NCPDP_Pharmacy_Database__c(Name='--Test1234---');
        Pharmacy_Network_Request__c pnr1 = new Pharmacy_Network_Request__c(NCPDP__c='--Test1234---');
        Pharmacy_Network_Request__c pnr2 = new Pharmacy_Network_Request__c(NCPDP__c='--Test1234---');
  
        Test.startTest();
        
        try {
            insert pnr1; insert pnr2; insert testNCPDP1;         
                    List<NCPDP_Pharmacy_Database__c> testNCPDPids = [Select Id From NCPDP_Pharmacy_Database__c ];
                    System.assertEquals(1, testNCPDPids.size());
                    List<Pharmacy_Network_Request__c> testPNRs = new List<Pharmacy_Network_Request__C>([ Select Id, NCPDP__c, NCPDP_Pharmacy_Database__c 
                                                                                                From Pharmacy_Network_Request__c ]);
                    System.assertEquals(2, testPNRs.size());      
            
        } Catch (DmlException e) {
            System.debug('Error! No records inserted.');
        }
                           
        Test.stopTest();
        
    }
}