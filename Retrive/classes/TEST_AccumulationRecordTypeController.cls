/*Purpose: Apex Test Class for VFP_AccumulationRecordTypeController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/7/2011       Apex Test Class for VFP_AccumulationRecordTypeController.
======================================================================== 
*/
@isTest
private class TEST_AccumulationRecordTypeController
{
    static testmethod void testAccumulationRecordTypeController()
    {
            CRD__c testCrd=new CRD__c();                    
            insert testCrd;
            Accumulations__c acc=new Accumulations__c();
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
            acc.RecordTypeId=rt.id;
            acc.CRD_ID__c=testCrd.Id;
            insert acc;
            
            Accumulations__c res=[select id,Name ,recordType.Name from Accumulations__c where id =:acc.id];
                      
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationSpecificDrugRecordTypes')); 
            System.currentPageReference().getParameters().put('accumId', acc.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (acc);
            VFP_AccumulationRecordTypeController controller =new VFP_AccumulationRecordTypeController(stdcontroller);
            controller.recordTypeValue=acc.RecordTypeId;
            controller.createNewRecord();
            
            rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' and Name='Family - Mail' limit 1];
            acc.RecordTypeId=rt.id;
            update acc;
            stdcontroller =new ApexPages.StandardController (acc);
            controller =new VFP_AccumulationRecordTypeController(stdcontroller);

    }
    
}