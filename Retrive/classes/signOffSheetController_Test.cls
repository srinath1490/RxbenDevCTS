@isTest

private class  signOffSheetController_Test{ 


static testMethod void testcls(){
	
	Sign_off_sheet__c ccobj = new Sign_off_sheet__c();
	PageReference pageRef = Page.SignOffSheet;
	Test.setCurrentPageReference(pageRef);
	ApexPages.currentPage().getParameters().put('retURL', ccobj.Id); 
	ApexPages.currentPage().getParameters().put('delRow', '1');
	Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
	signOffSheetController cuscon = new signOffSheetController(sc);
	signOffSheetController.SignOffSheetWrapper wra = new signOffSheetController.SignOffSheetWrapper();
	Test.startTest();
	cuscon.soSheetList.add(wra);
	cuscon.saveRecords();
    cuscon.addRecord();   
    cuscon.getSoSheetList();
    wra.getIndex();
    wra.getSoSheet();
    cuscon.deleteRow();
    cuscon.clear();
	Test.stopTest();
	}
	
	 static testmethod void testcls_ExcepAddFunc(){
        Sign_off_sheet__c ccobj = new Sign_off_sheet__c();
		PageReference pageRef = Page.SignOffSheet;
		Test.setCurrentPageReference(pageRef);
		ApexPages.currentPage().getParameters().put('delRow', ccobj+'1');
		Apexpages.StandardController sc = new ApexPages.StandardController(ccobj);
		signOffSheetController cuscon = new signOffSheetController(sc);
		signOffSheetController.SignOffSheetWrapper wra = new signOffSheetController.SignOffSheetWrapper();
		signOffSheetController.SignOffSheetWrapper wra1 = new signOffSheetController.SignOffSheetWrapper();
		Test.startTest();
		cuscon.soSheetList.add(wra);
		cuscon.soSheetList.add(wra1);  
          cuscon.saveRecords();  
		cuscon.deleteRow();
               cuscon.soSheetList = null;            
            cuscon.addRecord();
          
          Test.stopTest();
       }  
}