/*Purpose: Apex Class for Cloning the Object List                                      
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/23/2012       Apex Class for Cloning the Object List
======================================================================== */
public with sharing class VFP_CloneObjectListController {
	public Object_List__c originalObjectList{get;set;}
    public string objectListId;
    Object_List__c cloneObjectList;
    List<Object_List_Item__c> itemList = new List<Object_List_Item__c>();
    
    public VFP_CloneObjectListController(ApexPages.StandardController controller) {
        originalObjectList = (Object_List__c)controller.getRecord();
        objectListId = originalObjectList.Id;
        
        originalObjectList = [Select o.Termination_Date__c, o.State__c, o.Standard__c, o.Segment__c, o.RecordTypeId, o.Platform__c, o.OwnerId, o.Object_List_Name__c,
        					  o.Object_List_Description__c, o.Name, o.Mark_for_Deletion__c, o.IsDeleted, o.Inactive__c, o.Id, o.Funding__c, o.Effective_Date__c, 
        					  o.Deletion_Requestor__c, o.Deletion_Reason__c, o.Date_Marked_for_Deletion__c, o.Account__c, (Select Id, IsDeleted, Name, RecordTypeId, 
        					  Effective_Date__c, Termination_date__c, Sequence__c, Status__c, Value__c, Qualifiers__c, Object_List__c, Object_List_Name__c, 
        					  Object_List_Description__c, Object_List_ID__c, Test_Type__c, Gender__c, Lower_Age__c, Upper_Age__c, Operator__c, Lower_Range__c, 
        					  Upper_Range__c, Lookback_Number_of_Periods__c, Period__c, Lab_Test_Result_Value__c, Units__c, Test_Performed__c, 
        					  Standard_Text_Selection__c, Lower_Age_Type__c, Upper_Age_Type__c From Object_List_Items__r) From Object_List__c o where Id =:objectListId ];
        
        cloneObjectList = new Object_List__c ();  
        cloneObjectList = originalObjectList.clone(false); 
        itemList = originalObjectList.Object_List_Items__r;
    }
    
    public pagereference redirect(){
    	List<Object_List_Item__c> cloneEntry = new List<Object_List_Item__c>();
        Savepoint sp = Database.setSavepoint();
		try{
	        insert cloneObjectList ;
	        if(itemList.size()>0){
	        	for(Object_List_Item__c exp: itemList){
	        		Object_List_Item__c cloneExp = new Object_List_Item__c();
		        		cloneExp = exp.clone(false);
		        		cloneExp.Object_List__c = cloneObjectList.Id;
	        		cloneEntry.add(cloneExp);
	        	}
	        	insert cloneEntry;
	        }
	     	Pagereference pageref= new Pagereference('/'+cloneObjectList.Id+'/e?retURL='+cloneObjectList.Id);
            return pageref ;   
		 }catch(exception e){
		        // roll everything back in case of error
		         Database.rollback(sp);
		         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
		         ApexPages.addMessage(myMsg);  
		         return null;
		}
    }
	public Pagereference previouspage(){
	            Pagereference pageref= new Pagereference('/'+originalObjectList.Id+'/d?retURL='+originalObjectList.Id);
	           return pageref; 
	  }
}