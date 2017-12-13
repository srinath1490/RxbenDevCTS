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
private class ValidationRuleclass_Test {

    static testMethod void myUnitTestPostive() {
    try{
        CustomObjects__c co = new CustomObjects__c(Object_Name__c='test');
        insert co;
        Validation_Rule__c vr = new Validation_Rule__c(Rule_Name__c='Test Name',Error_Location__c = 'Top of Page',Custom_Object__c=co.id,Error_Message__c='test msg',Error_Condition_Formula__c='test condition');         
        insert vr;
        PageReference pageRef = Page.VL;
        Test.setCurrentPageReference(pageRef);

        ApexPages.currentPage().getParameters().put('delRow', '1');
        ApexPages.currentPage().getParameters().put('retURL', 'hi');
        ApexPages.StandardController controller = new ApexPages.StandardController(vr); 
        ValidationRuleclass obj= new ValidationRuleclass (controller);                       
        ValidationRuleclass.VLwrapper wrp = new ValidationRuleclass.VLwrapper();
        ValidationRuleclass.VLwrapper wrp1 = new ValidationRuleclass.VLwrapper();
        wrp.getVLsetting();
        wrp.getIndex();
        obj.VLlist.add(wrp);
        obj.VLlist.add(wrp1);
        obj.getVLlist();
        obj.addNewRecord();
        system.debug('\n Var value befor upsert-1-'+vr.Rule_Name__c);
        vr.Rule_Name__c = vr.Rule_Name__c.replace(' ', '_');
        vr.Rule_Name__c = vr.Rule_Name__c.replace('__', '_');
        upsert(vr);
        system.debug('\n Var value after upsert-1-'+vr.Rule_Name__c);
        obj.save();
        obj.clear();
        obj.deleteRow();
        }
        catch (exception ex){}
    }
    static testMethod void myUnitTestNegtiveForDelete() {
        CustomObjects__c co = new CustomObjects__c(Object_Name__c='test');
        insert co;
        Validation_Rule__c vr = new Validation_Rule__c(Rule_Name__c='Test Name',Error_Location__c = 'Top of Page',Custom_Object__c=co.id,Error_Message__c='test msg',Error_Condition_Formula__c='test condition');         
        insert vr;
        PageReference pageRef = Page.VL;
        Test.setCurrentPageReference(pageRef);

        ApexPages.currentPage().getParameters().put('delRow', 'hi'); //Creatin exception by passing 'hi'
        ApexPages.StandardController controller = new ApexPages.StandardController(vr); 
        ValidationRuleclass obj= new ValidationRuleclass (controller);                       
        ValidationRuleclass.VLwrapper wrp = new ValidationRuleclass.VLwrapper();
        wrp.getVLsetting();
        wrp.getIndex();
        obj.VLlist.add(wrp);
        obj.deleteRow();
    }    
    static testMethod void myUnitTestNegtiveForAddRow() {
    try{
        CustomObjects__c co = new CustomObjects__c(Object_Name__c='test');
        insert co;
        Validation_Rule__c vr = new Validation_Rule__c(Rule_Name__c='Test Name',Error_Location__c = 'Top of Page',Custom_Object__c=co.id,Error_Message__c='test msg',Error_Condition_Formula__c='test condition');         
        insert vr;
        PageReference pageRef = Page.VL;
        Test.setCurrentPageReference(pageRef);

        ApexPages.currentPage().getParameters().put('delRow', '1'); 
        ApexPages.StandardController controller = new ApexPages.StandardController(vr); 
        ValidationRuleclass obj= new ValidationRuleclass (controller);                       
        ValidationRuleclass.VLwrapper wrp = new ValidationRuleclass.VLwrapper();
        wrp.getVLsetting();
        wrp.getIndex();
        obj.VLlist.add(wrp);
        obj.VLlist=null;//Creatin exception by assigning null to list
        obj.getVLlist();
        obj.addNewRecord();
        obj.clear();
        }
        catch(exception ex){}
    }
}