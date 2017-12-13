@isTest

public with sharing class Test_GMF_XML_FML_Controller {
	public static testmethod void testXMLFML(){
		Follow_Me_Logic__c fmlRecord = new Follow_Me_Logic__c();
		Follow_Me_Logic__c fmlRecord2 = new Follow_Me_Logic__c();
		fmlRecord.Name = 'test';
		fmlRecord.Follow_Me_Logic_Description__c = 'description';
		insert fmlRecord;
		test.starttest();
		ApexPages.standardcontroller sc = new ApexPages.standardcontroller(fmlRecord);
		GMF_XML_FML_Controller xmlClass = new GMF_XML_FML_Controller(sc);
		xmlClass.generateXML();
		sc = new ApexPages.standardcontroller(fmlRecord2);
		xmlClass = new GMF_XML_FML_Controller(sc);
		xmlClass.generateXML();
		test.stoptest();
	}

}