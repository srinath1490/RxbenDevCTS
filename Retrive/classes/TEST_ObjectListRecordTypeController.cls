/*Purpose: Apex Test Class for VFP_ObjectListRecordTypeController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/22/2011       Apex Test Class for VFP_ObjectListRecordTypeController.
======================================================================== 
*/
@isTest
private class TEST_ObjectListRecordTypeController{
    static testMethod void ObjectListRecordTypeController(){
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();     
        Object_List__c objectListId= testdata.createObjectList();
        insert objectListId;
        Object_List_Item__c objectListItem = testdata.createObjectListItem(objectListId.Id);  
        insert objectListItem;

        update objectListId;
        
        PageReference newObjectListRecordTypeController = Page.VF_ObjectListRecordType; 
        newObjectListRecordTypeController .getParameters().put('objectListId',objectListId.id);    
        Test.setCurrentPage(newObjectListRecordTypeController );        
        ApexPages.StandardController s = new ApexPages.standardController(objectListId);
        VFP_ObjectListRecordTypeController controller = new VFP_ObjectListRecordTypeController(s);
        controller.redirect();
      
       RecordType rt = [select id from RecordType where SobjectType='Object_List__c'  and name ='Provider'limit 1]; 
       objectListId.RecordtypeId = rt.Id;
       update objectListId;
       RecordType rt1 = [select id from RecordType where SobjectType='Object_List_Item__c'  and name ='Provider'limit 1];       
       objectListItem.RecordTypeId = rt1.Id;
       update objectListItem;
       
       }
}