/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PageLayoutclass_Test {

    static testMethod void myUnitTestPostive() {
		Page_Layout__c pl = new Page_Layout__c();         
		PageReference pageRef = Page.PL;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1');
		ApexPages.currentPage().getParameters().put('retURL', 'hi');
		ApexPages.StandardController controller = new ApexPages.StandardController(pl); 
		PageLayoutclass obj= new PageLayoutclass (controller);                       
		PageLayoutclass.PLwrapper wrp = new PageLayoutclass.PLwrapper();
		PageLayoutclass.PLwrapper wrp1 = new PageLayoutclass.PLwrapper();
		wrp.getPLsetting();
		wrp.getIndex(); 
		obj.PLlist.add(wrp);
		obj.PLlist.add(wrp1);
		obj.getPLlist();
		obj.addNewRecord();
		obj.save();
		obj.clear();
		obj.deleteRow();
    }
    static testMethod void myUnitTestNegtiveForDelete() {
		Page_Layout__c pl = new Page_Layout__c();         
		PageReference pageRef = Page.PL;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', 'hi'); //Creatin exception by passing 'hi'
		ApexPages.StandardController controller = new ApexPages.StandardController(pl); 
		PageLayoutclass obj= new PageLayoutclass (controller);                       
		PageLayoutclass.PLwrapper wrp = new PageLayoutclass.PLwrapper();
		wrp.getPLsetting();
		wrp.getIndex();
		obj.PLlist.add(wrp);
		obj.deleteRow();
    }    
    static testMethod void myUnitTestNegtiveForAddRow() {
		Page_Layout__c pl = new Page_Layout__c();         
		PageReference pageRef = Page.PL;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1'); 
		ApexPages.StandardController controller = new ApexPages.StandardController(pl); 
		PageLayoutclass obj= new PageLayoutclass (controller);                       
		PageLayoutclass.PLwrapper wrp = new PageLayoutclass.PLwrapper();
		wrp.getPLsetting();
		wrp.getIndex();
		obj.PLlist.add(wrp);
		obj.PLlist=null;//Creatin exception by assigning null to list
		obj.getPLlist();
		obj.addNewRecord();
    }
}