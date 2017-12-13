@isTest
public class TEST_GMF_XML_Formulary_controller{

  static testmethod void runtest(){
  Formulary__c testrecord=new Formulary__c();
  testrecord.Standard__c=true;
  testrecord.Formulary_Name__c='test name';
  testrecord.Formulary_Description__c='test description';
  testrecord.Effective_Date__c=system.today();
  testrecord.Termination_Date__c=system.today().addDays(3);
  
  insert testrecord;
  Formulary_Junction__c testchild=new Formulary_Junction__c();
  testchild.Formulary__c=testrecord.Id;
  testchild.Priority__c=1;
  testchild.Effective_Date__c=system.TODAY();
  testchild.Termination_Date__c=system.TODAY();
  insert testchild;
  ApexPages.standardController sc=new ApexPages.StandardController(testrecord);
  GMF_XML_Formulary_controller handle=new GMF_XML_Formulary_controller(sc);
  handle.generateXML();
   
  
  }

}