@isTest
public class TEST_GMF_XML_FormularyList_controller{

  static testmethod void runtest(){
  Forms__c testFormItem;
  Formulary_List__c testrecord=new Formulary_List__c();
  testrecord.Formulary_List_Description__c='test description';
  testrecord.Formulary_List_Name__c='test name';
  testrecord.Effective_Date__c=system.today();
  testrecord.Termination_Date__c=system.today().addDays(3);
  insert testrecord;
  
  Formulary_List_Entry__c testchild=new Formulary_List_Entry__c();
  testchild.GPI__c = '12*';
  testchild.Formulary_List__c=testrecord.Id;
  
  testchild.Effective_Date__c=system.today();
  testchild.Termination_Date__c=system.today().addDays(3);
  insert testchild;
  
  List<Forms__c> testForm=[SELECT Id FROM Forms__c WHERE RecordType.Name IN ('Medical Exceptions','CPB/Criteria Element Form','Formulary List Entry Criteria Form','Denial Reason Form')  LIMIT 1];
  if(testForm.size()>0)
   testFormItem=testForm[0];
  else{
   RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType='Forms__c' AND Name='Denial Reason Form' LIMIT 1];
   testFormItem=new Forms__c(Form_Name__c='testName',Form_Description__c='testdescription',RecordTypeId=rt.Id,Effective_Date__c=system.today(),Termination_Date__c=system.today().addDays(3));
   insert testFormItem;
  }
  Form_Junction__c testgrandchild=new Form_Junction__c(Formulary_List_Entry_ID__c=testchild.Id,Form_ID__c=testFormItem.Id);
  insert testgrandchild;
  
  ApexPages.standardController sc=new ApexPages.StandardController(testrecord);
  GMF_XML_FormularyList_controller handle=new GMF_XML_FormularyList_controller(sc);
  handle.generateXML();
  
  }


}