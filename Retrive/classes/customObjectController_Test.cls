@isTest

public class customObjectController_Test{

	static testMethod void testcls(){
	
	CustomObjects__c cust = new CustomObjects__c();
	PageReference pageRef = Page.CustomObjectsPage;
	Test.setCurrentPageReference(pageRef);
	ApexPages.currentPage().getParameters().put('delRow', '1');
	ApexPages.StandardController sc = new ApexPages.StandardController(cust);
	customObjectController obj = new customObjectController(sc);
	customObjectController.CustomObjectWrapper wra = new customObjectController.CustomObjectWrapper();
	Test.startTest();
		obj.coList.add(wra);
		obj.getCoList();	
		obj.save();
		wra.getIndex();
		wra.getCustomObject();
		obj.add();
		obj.getCoList();
		obj.delRecords();
		obj.clear();
	Test.stopTest();
	}
	
	 static testmethod void testcls_ExcepAddFunc(){
        CustomObjects__c cust = new CustomObjects__c();
		PageReference pageRef = Page.CustomObjectsPage;
		Test.setCurrentPageReference(pageRef);
		ApexPages.currentPage().getParameters().put('delRow', cust+'1');
		ApexPages.StandardController sc = new ApexPages.StandardController(cust);
		customObjectController obj = new customObjectController(sc);
		customObjectController.CustomObjectWrapper wra = new customObjectController.CustomObjectWrapper();
		customObjectController.CustomObjectWrapper wra1 = new customObjectController.CustomObjectWrapper();
		Test.startTest();
		obj.coList.add(wra);
		obj.coList.add(wra1);  
          obj.save();  
		obj.delRecords();
            obj.coList = null;            
            obj.add();   
          
          Test.stopTest();
       }    
            
}