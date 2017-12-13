@isTest

private class  standardObjectFieldClass_Test{ 


static testMethod void testcls(){
	
	StandardObjectField__c ccobj = new StandardObjectField__c();
	PageReference pageRef = Page.StandardObjectFieldsPage;
	Test.setCurrentPageReference(pageRef);
	ApexPages.currentPage().getParameters().put('retURL', ccobj.Id); 
	ApexPages.currentPage().getParameters().put('delRow', '1');
	Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
	standardObjectFieldClass cuscon = new standardObjectFieldClass(sc);
	standardObjectFieldClass.StandardObjectFieldWrapper wra = new standardObjectFieldClass.StandardObjectFieldWrapper();
	Test.startTest();
	cuscon.stdFieldList.add(wra);
	cuscon.save();
    cuscon.add();   
    cuscon.getStdFieldList();
    wra.getIndex();
    wra.getStdField();
    wra.setStdField(ccobj);
    cuscon.deleteRow();
    cuscon.clear();
	Test.stopTest();
	}
	
	 static testmethod void testcls_ExcepAddFunc(){
        StandardObjectField__c ccobj = new StandardObjectField__c();
		PageReference pageRef = Page.StandardObjectFieldsPage;
		Test.setCurrentPageReference(pageRef);
		ApexPages.currentPage().getParameters().put('delRow', ccobj+'1');
		Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
		standardObjectFieldClass cuscon = new standardObjectFieldClass(sc);
		standardObjectFieldClass.StandardObjectFieldWrapper wra = new standardObjectFieldClass.StandardObjectFieldWrapper();
		standardObjectFieldClass.StandardObjectFieldWrapper wra1 = new standardObjectFieldClass.StandardObjectFieldWrapper();
		Test.startTest();
		cuscon.stdFieldList.add(wra);
		cuscon.stdFieldList.add(wra1);  
          cuscon.save();  
		cuscon.deleteRow();
               cuscon.stdFieldList = null;            
            cuscon.add();
          
          Test.stopTest();
       }  
}