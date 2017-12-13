/*Purpose: Apex Test Class to test CB_CaseLogger
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            9 Oct 2014       Apex Test class to test CB_CaseLogger
======================================================================== */
@isTest
private class TEST_CB_CaseLogger {
    static testmethod void TEST_CB_CaseLogger(){
		CB_CaseLogger caselog = new CB_CaseLogger();
        Crd__c newcrd = new Crd__c();
        insert newcrd;
        case newcase = new Case();
        insert newcase;
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        String crdid = newcrd.id;
        String parentid = newcase.id;
        String cpe = String.valueof(system.today());
        CB_CaseLogger.logCase('Test','Test Description',parentid,crdid,cpe);
        CB_CaseLogger.CreateCaseBuilder('Test','Test Description','Reason',System.Now(),'12313CB',acc.id,system.today(),crdid);
        CB_CaseLogger.CreateCaseBuilder(parentid,'Test','Test Description','Reason',System.Now(),'12313CB',acc.id,system.today(),crdid);
    }
}