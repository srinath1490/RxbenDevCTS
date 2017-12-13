@isTest

private class  CustomizationController_Test{ 


static testMethod void testcls(){
	
	Customization__c ccobj = new Customization__c();
	PageReference pageRef = Page.CustomizationPage;
	Test.setCurrentPageReference(pageRef);
	ApexPages.currentPage().getParameters().put('retURL', ccobj.Id);
	ApexPages.currentPage().getParameters().put('delRow', '1');
	Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
CustomizationController cuscon = new CustomizationController(sc);
CustomizationController.CustomizationWrapper wra = new CustomizationController.CustomizationWrapper();
	Test.startTest();
	cuscon.customizationList.add(wra);
	cuscon.save();
    cuscon.addNewRecord();   
    cuscon.getCustomizationList();
    wra.getIndex();
    wra.getCustomization();
    cuscon.deleteRow();
    cuscon.clear();
	Test.stopTest();
	}
	
	 static testmethod void testcls_ExcepAddFunc(){
        Customization__c ccobj = new Customization__c();
		PageReference pageRef = Page.CustomizationPage;
		Test.setCurrentPageReference(pageRef);
		ApexPages.currentPage().getParameters().put('delRow', ccobj+'1');
		Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
		CustomizationController cuscon = new CustomizationController(sc);
		CustomizationController.CustomizationWrapper wra = new CustomizationController.CustomizationWrapper();
		CustomizationController.CustomizationWrapper wra1 = new CustomizationController.CustomizationWrapper();
		Test.startTest();
		cuscon.customizationList.add(wra);
		cuscon.customizationList.add(wra1);  
          cuscon.save();  
		cuscon.deleteRow();
               cuscon.customizationList = null;            
            cuscon.addNewRecord();
          
          Test.stopTest();
       }  
}