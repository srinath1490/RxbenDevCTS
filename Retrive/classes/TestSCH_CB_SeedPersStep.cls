/*Purpose: Apex Test Class For schedule BAC_CB_SeedPersStep class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Nitish            29 Oct 2014          Apex Test Class For schedule BAC_CB_SeedPersStep class 

======================================================================== */
@isTest
private class TestSCH_CB_SeedPersStep {

    static testMethod void myTestMethod() {        
         test.starttest();
        SCH_CB_SeedPersStep myClass = new SCH_CB_SeedPersStep ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}