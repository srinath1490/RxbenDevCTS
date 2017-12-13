global without sharing class HVXMLCaller {

//=============================
// Author					Version					Date
// Saraag					1.0							04/04/2013
//=============================	 

//------------------------------
// Inner class: CustException
// Extends: Exception class
// Notes: For custom exceptions
//------------------------------
public class CustException extends Exception {} 

 //-------------------------------
 // Method:callDL
 // Arguments: Drug list record id
 // Notes: Call this method from custom button on DL pagelayout.
 //-------------------------------
	webservice static void callDL(String DLrecString){
		Id DLrecId=Id.valueOf(DLrecString);
		List<Drug_List__c> dlList=[SELECT Id FROM Drug_List__c WHERE Id=:DLrecId];
		if(dlList.size()==1)
		   Database.executeBatch(new HVXMLGeneratorDL(DlrecId));
		else 
			throw new CustException('Invalid Druglist record Id');   
	}// end Webservice method
	
 //-------------------------------
 // Method:callDLOthers
 // Arguments: Drug list record id
 // Notes: Call this method from custom button on Others pagelayout.
 //-------------------------------
	webservice static void callDLOthers(String DLrecString){
		Id DLrecId=Id.valueOf(DLrecString);
		List<Drug_List__c> dlList=[SELECT Id FROM Drug_List__c WHERE Id=:DLrecId];
		if(dlList.size()==1)
		   Database.executeBatch(new HVXMLGenerator(DlrecId));
		else 
			throw new CustException('Invalid Druglist record Id');   
	}// end Webservice method
	
 //-------------------------------
 // Method:callMailHandler
 // Arguments: Case record Id; UserId
 // Notes: Call this method from HVXML batch classes to send email to person who initiated mass XML generation.
 //-------------------------------
 
 public static void callMailHandler(Id caseId,String Uemail, String DLName){ 
	  Case c=[SELECT Id,CaseNumber FROM Case WHERE Id=:caseId];
	  Drug_list__c DLrec=[SELECT Drug_List_Name__c,id FROM Drug_List__c WHERE Name=:DLName][0];
	 	Messaging.reserveSingleEmailCapacity(1);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {Uemail}; 
		mail.setToAddresses(toAddresses); 
		mail.setReplyTo('solipurams@aetna.com');
		mail.setSenderDisplayName('XML Generator');
		mail.setSubject('XML generated for '+Dlrec.Drug_List_Name__c+'('+DLName+')');
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setHtmlBody('Hello, <br><br> I have generated XML for '+Dlrec.Drug_List_Name__c+'('+DLName+')'+' and attached it to Case-'+c.caseNumber+'.<br>To view your case <a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+c.Id+'>click here.</a><br><br> Thank you,<br> Rx SFDC');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 }// End callMailHandler
 
 //===== Test Methods =========
 @isTest(SeeAllData=true)
 private static void testCallDL(){
 	// selecting a DL record with Drug list recordtype
 	Test.startTest();
 	HVXMLCaller.callDL(Test_HVXMLGenerator_and_DL.prepareData('Drug_List'));
 	Test.stoptest();
 }
 
 @isTest(SeeAllData=true)
 private static void testCallDLOthers(){
 	Test.starttest();
 	HVXMLCaller.callDLOthers(Test_HVXMLGenerator_and_DL.prepareData('Quantity_Limit'));
 	Test.stoptest();
 }
 
 @isTest(SeeAllData=true)
 private static void testcallMailHandler(){
 	HVXMLCaller.callMailHandler([select Id,caseNumber from case LIMIT 1][0].Id,'solipurams@aetna.com',[select Id,Drug_List_Name__c,Name from Drug_List__c LIMIT 1][0].Name);
 }
}// End class