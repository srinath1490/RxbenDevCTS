@isTest

public class DataLoaderController_Test{
	static testMethod void dLCTest(){
	
	DataLoader__c dlclass = new  DataLoader__c();
	 PageReference pageRef = Page.DataLoader;
     Test.setCurrentPageReference(pageRef);
     ApexPages.currentPage().getParameters().put('delRow', '1');
	ApexPages.StandardController sc = new ApexPages.StandardController(dlclass);
	DataLoaderController obj = new DataLoaderController(sc);
	DataLoaderController.DataLoaderWrapper wra = new DataLoaderController.DataLoaderWrapper();
	Test.startTest();
		obj.dataLoaderList.add(wra);
		obj.addRecord();	
		obj.save();
		wra.getIndex();
		wra.getDataLoader();
		obj.getDataLoaderList();
		obj.deleteRow();
		obj.clear();
	Test.stopTest();
	}
	
	 static testmethod void dLCTest_ExcepAddFunc(){
        DataLoader__c dlclass = new  DataLoader__c();
	 PageReference pageRef = Page.DataLoader;
     Test.setCurrentPageReference(pageRef);
     ApexPages.currentPage().getParameters().put('delRow', dlclass+'1');
	ApexPages.StandardController sc = new ApexPages.StandardController(dlclass);
	DataLoaderController obj = new DataLoaderController(sc);
	DataLoaderController.DataLoaderWrapper wra = new DataLoaderController.DataLoaderWrapper();
	Test.startTest();
	obj.dataLoaderList.add(wra);
	obj.deleteRow();
            obj.dataLoaderList = null;            
            obj.addRecord();        }     
}