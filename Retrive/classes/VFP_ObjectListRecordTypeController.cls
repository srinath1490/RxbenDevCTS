/*Purpose: Apex Class for VFP_ObjectListRecordType Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 10/20/2011       Apex Class for VFP_ObjectListRecordType Page.
======================================================================== 
*/
public with sharing  class VFP_ObjectListRecordTypeController {
	
    public list<Object_List__c> currentObjectList{get;set;}
    public list<Object_List_Item__c> currentObjectListItem{get;set;}
    public string currentObjectListId{get;set;}
    public string currentObjectListName{get;set;}
    public string currentObjectListRecordTypeName{get;set;}
    public string currentObjectListItemRecordTypeid{get;set;}   
    public String Url{get;set;}
    
    public VFP_ObjectListRecordTypeController(ApexPages.StandardController controller) { 
	     currentObjectListId= ApexPages.CurrentPage().getParameters().get('objectListId');
	     currentObjectList=[select id,Name ,recordTypeid,recordType.Name from Object_List__c where id =:currentObjectListId];     
	     currentObjectListRecordTypeName = currentObjectList.get(0).recordType.Name;
	     currentObjectListName = currentObjectList.get(0).Name;
	     currentObjectListItemRecordTypeid = getObjRecordType(currentObjectListRecordTypeName);
	     URL=system.label.CL0000029+currentObjectListItemRecordTypeid+system.label.CL0000030+currentObjectListName+system.label.CL0000031+currentObjectListId+system.label.CL0000032;        
    }
    
    public Id getObjRecordType(String recordTypeName){
	    Schema.DescribeSObjectResult d = Schema.SObjectType.Object_List_Item__c; 
	    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
	    Schema.RecordTypeInfo rtByName =  rtMapByName.get(recordTypeName);
	    return rtByName.getRecordTypeId(); 
     }
     
    public PageReference redirect() {
        Pagereference pageRef = new Pagereference(URL);
        pageRef.setredirect(true);
        return pageRef;
    }

}