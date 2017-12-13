/*Purpose: Test class for BAC_CaseStatusHistory 
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Richa          3/07/2014       Test class for BAC_CaseStatusHistory 
======================================================================== */
@isTest
private class Test_BAC_CaseStatusHistory{
    static testMethod void Test_BAC_CaseStatusHistory(){
        BAC_CaseStatusHistory obj = new BAC_CaseStatusHistory();
        database.executeBatch(obj,1);
     }
}