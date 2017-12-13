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
private class timeTriggerController_Test {

    static testMethod void myUnitTestPostive() {
		Time_Trigger__c tto = new Time_Trigger__c(Action_Name__c = 'Test Assignment');         
		
			try{
			  insert tto;
			}
			catch(Exception ex){
			  system.debug('Exception 1--'+ex);
			}

        Test.startTest();
		PageReference pageRef = Page.Time_Trigger_Page;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1');
		ApexPages.currentPage().getParameters().put('retURL', 'hi');
		ApexPages.StandardController controller = new ApexPages.StandardController(tto); 
		timeTriggerController obj= new timeTriggerController (controller);                       
		timeTriggerController.TimeTriggerWrapper wrp = new timeTriggerController.TimeTriggerWrapper();
		timeTriggerController.TimeTriggerWrapper wrp1 = new timeTriggerController.TimeTriggerWrapper();
		wrp.getTimeTriggerObj();
		wrp.getIndex();
		obj.ttList.add(wrp);
		obj.ttList.add(wrp1);
		obj.getTTList();
		obj.add();
		obj.save();
		obj.clearRecord();
		obj.delRecords();
    }
    static testMethod void myUnitTestNegtiveForDelete() {
		Time_Trigger__c tto = new Time_Trigger__c(Action_Name__c = 'Test Assignment');         

			try{
			  insert tto;
			}
			catch(Exception ex){
			  system.debug('Exception 2--'+ex);
			}

        Test.startTest();
		PageReference pageRef = Page.Time_Trigger_Page;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', 'hi'); //Creatin exception by passing 'hi'
		ApexPages.StandardController controller = new ApexPages.StandardController(tto); 
		timeTriggerController obj= new timeTriggerController (controller);                       
		timeTriggerController.TimeTriggerWrapper wrp = new timeTriggerController.TimeTriggerWrapper();
		wrp.getTimeTriggerObj();
		wrp.getIndex();
		obj.ttList.add(wrp);
		obj.delRecords();
    }    
    static testMethod void myUnitTestNegtiveForAddRow() {
		Time_Trigger__c tto = new Time_Trigger__c(Action_Name__c = 'Test Assignment');         

			try{
			  insert tto;
			}
			catch(Exception ex){
			  system.debug('Exception 3--'+ex);
			}

        Test.startTest();
		PageReference pageRef = Page.Time_Trigger_Page;
		Test.setCurrentPageReference(pageRef);

		ApexPages.currentPage().getParameters().put('delRow', '1'); 
		ApexPages.StandardController controller = new ApexPages.StandardController(tto); 
		timeTriggerController obj= new timeTriggerController (controller);                       
		timeTriggerController.TimeTriggerWrapper wrp = new timeTriggerController.TimeTriggerWrapper();
		wrp.getTimeTriggerObj();
		wrp.getIndex();
		obj.ttList.add(wrp);
		obj.delRecords();
		obj.ttList=null;//Creatin exception by assigning null to list
		obj.add();
    }    
}