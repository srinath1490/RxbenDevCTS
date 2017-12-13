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
private class Triggerclass_Text {

    static testMethod void myUnitTestPostive() {
		Trigger__c tc = new Trigger__c();         
		PageReference pageRef = Page.Trigger;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1');
		ApexPages.currentPage().getParameters().put('retURL', 'hi');
		ApexPages.StandardController controller = new ApexPages.StandardController(tc); 
		Triggerclass obj= new Triggerclass (controller);                       
		Triggerclass.Triggerwapper wrp = new Triggerclass.Triggerwapper();
		Triggerclass.Triggerwapper wrp1 = new Triggerclass.Triggerwapper();
		wrp.getTriggersetting();
		wrp.getIndex();
		obj.Triggerlist.add(wrp);
		obj.Triggerlist.add(wrp1);
		obj.getTriggerlist();
		obj.addNewRecord();
		obj.save();
		obj.clear();
		obj.deleteRow();
    }
    static testMethod void myUnitTestNegtiveForDelete() {
		Trigger__c tc = new Trigger__c();         
		PageReference pageRef = Page.Trigger;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', 'hi'); //Creatin exception by passing 'hi'
		ApexPages.StandardController controller = new ApexPages.StandardController(tc); 
		Triggerclass obj= new Triggerclass (controller);                       
		Triggerclass.Triggerwapper wrp = new Triggerclass.Triggerwapper();
		wrp.getTriggersetting();
		wrp.getIndex();
		obj.Triggerlist.add(wrp);
		obj.deleteRow();
    }    
    static testMethod void myUnitTestNegtiveForAddRow() {
		Trigger__c tc = new Trigger__c();         
		PageReference pageRef = Page.Trigger;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1'); 
		ApexPages.StandardController controller = new ApexPages.StandardController(tc); 
		Triggerclass obj= new Triggerclass (controller);                       
		Triggerclass.Triggerwapper wrp = new Triggerclass.Triggerwapper();
		wrp.getTriggersetting();
		wrp.getIndex();
		obj.Triggerlist.add(wrp);
		obj.Triggerlist=null;//Creatin exception by assigning null to list
		obj.getTriggerlist();
		obj.addNewRecord();
    }
}