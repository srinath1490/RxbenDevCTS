@isTest
Public class TEST_GMF_XML_GCC_controller{

  static testmethod void runtest(){
    Generic_Code_Conversion__c testrecord=new Generic_Code_Conversion__c();
    testrecord.Generic_Code_Conversion_Description__c='test description';
    testrecord.Generic_Code_Conversion_Name__c='test name';
    testrecord.Effective_Date__c=system.today();
    testrecord.Termination_Date__c=system.today().addDays(3);
    insert testrecord;
    
    Generic_Code_Conversion_Entry__c testChildRecord=new Generic_Code_Conversion_Entry__c();
    testChildRecord.Generic_Code_Conversion__c=testrecord.Id;
     insert testChildRecord;
    
    ApexPages.StandardController sc=new ApexPages.StandardController(testrecord);
    GMF_XML_GCC_controller handle=new GMF_XML_GCC_controller(sc);
    handle.generateXML();
    
  }

}