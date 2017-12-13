@istest

public with sharing class Test_GMF_XML_DrugList_Controller {

	public static testmethod void testDrugList(){
		Drug_List__c drugListRecord = new Drug_List__c();
		drugListRecord.Drug_List_Name__c = 'test';
		drugListRecord.Description__c = 'testDescription';
		insert drugListRecord;
		Drug_List_Criteria__c drugListCriteriaRecord = new Drug_List_Criteria__c();
		drugListCriteriaRecord.Drug_List__c = druglistrecord.id;
		drugListCriteriaRecord.Effective__c = system.today();
		drugListCriteriaRecord.Term__c = system.today() + 1;
		drugListCriteriaRecord.Drug_Type_Code__c = 'GPI';
		drugListCriteriaRecord.Drug_Code_Value__c = '1234*';
		insert drugListCriteriaRecord;
		test.starttest();
		ApexPages.standardcontroller sc = new ApexPages.standardcontroller(drugListRecord);
		GMF_XML_DrugList_controller xmlClass = new GMF_XML_DrugList_controller(sc);
		xmlClass.generateXML();
		test.stoptest();
	}

}