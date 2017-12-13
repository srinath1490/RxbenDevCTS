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
private class RecordTypeclass_Test {

    static testMethod void myUnitTestPostive() {
		Record_Type__c rt = new Record_Type__c();         
		PageReference pageRef = Page.RT;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1');
		ApexPages.currentPage().getParameters().put('retURL', 'hi');
		ApexPages.StandardController controller = new ApexPages.StandardController(rt); 
		RecordTypeclass obj= new RecordTypeclass (controller);                       
		RecordTypeclass.RTwrapper wrp = new RecordTypeclass.RTwrapper();
		RecordTypeclass.RTwrapper wrp1 = new RecordTypeclass.RTwrapper();
		wrp.getRTsetting();
		wrp.getIndex();
		obj.RTlist.add(wrp);
		obj.RTlist.add(wrp1);
		obj.getRTlist();
		obj.addNewRecord();
		obj.save();
		obj.clear();
		obj.deleteRow();
    }
    static testMethod void myUnitTestNegtiveForDelete() {
		Record_Type__c rt = new Record_Type__c();         
		PageReference pageRef = Page.RT;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', 'hi'); //Creatin exception by passing 'hi'
		ApexPages.StandardController controller = new ApexPages.StandardController(rt); 
		RecordTypeclass obj= new RecordTypeclass (controller);                       
		RecordTypeclass.RTwrapper wrp = new RecordTypeclass.RTwrapper();
		wrp.getRTsetting();
		wrp.getIndex();
		obj.RTlist.add(wrp);
		obj.deleteRow();
    }    
    static testMethod void myUnitTestNegtiveForAddRow() {
		Record_Type__c rt = new Record_Type__c();         
		PageReference pageRef = Page.RT;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1'); 
		ApexPages.StandardController controller = new ApexPages.StandardController(rt); 
		RecordTypeclass obj= new RecordTypeclass (controller);                       
		RecordTypeclass.RTwrapper wrp = new RecordTypeclass.RTwrapper();
		wrp.getRTsetting();
		wrp.getIndex();
		obj.RTlist.add(wrp);
		obj.RTlist=null;//Creatin exception by assigning null to list
		obj.getRTlist();
		obj.addNewRecord();
    }
}