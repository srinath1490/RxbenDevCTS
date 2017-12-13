@isTest

public with sharing class Test_Batch_CRDXMLStep {
    public static testmethod void testBatchCRDXMLSTep(){
        /* CRD_Pricing__c p = new CRD_Pricing__c();
        insert p; */
       
        CRD__c testCrd = new CRD__c();
        testCrd.Plan_Type_Mail__c = true;
        testCrd.Plan_Type_Paper__c = true;
        testCrd.Plan_Type_Retail__c = true;
        testCrd.Plan_Type_Specialty__c = true;
        // testCrd.CRD_Pricing__c = p.Id;
        insert testCrd;
        
        CRDBuildOrder__c crdbo = new CRDBuildOrder__c();
        crdbo.CAG__c = True;
        crdbo.XML__c = False;
        crdbo.PERS__c = True;
        crdbo.PDF__c = False;
        crdbo.CVS__c = False;
        crdbo.crd__c = testcrd.id;  
        insert crdbo;
        
        Test.StartTest();
        Batch_CRDXMLStep xmlBatch = new Batch_CRDXMLStep();
        Database.executeBatch(xmlBatch);   
        Test.StopTest();     
    }   

}