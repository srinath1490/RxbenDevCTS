/*Purpose: Apex Test Class For schedule BAC_CB_CAGRestructure class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Nitish           10 June 2016          Apex Test Class For schedule BAC_CB_CAGRestructure class 

======================================================================== */
@isTest
private class TestSCH_CB_CAGRestructure {

    static testMethod void myTestMethod() {        
         test.starttest();
        SCH_CB_CAGRestructure myClass = new SCH_CB_CAGRestructure ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}