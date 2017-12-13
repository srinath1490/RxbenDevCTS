@isTest(SeeAllData=true)
public class Test_HVXMLGenerator_and_DL {
  
  public static Id prepareData(String recTypeDevName){
    //create DL
    Id recTyID=[select Id from recordType where SobjectType='Drug_List__c' AND DeveloperName=:recTypeDevName][0].Id;
    Id DLCrecId=[select Id from RecordType where SObjectType='Drug_List_Criteria__c' AND DeveloperName=:recTypeDevName][0].Id;
    Drug_List__c DLrec=new Drug_List__c(Drug_List_Name__c='Tester',Description__c='HVXMLGenerator test record',RecordTypeId=recTyID);
    insert DLrec;
    //create DLC
    Drug_List_Criteria__c DLCrec=new Drug_List_Criteria__c(RecordTypeId=DLCrecId,Drug_List__c=DLrec.Id,Drug_Type_Code__c='GPI',Effective__c=Date.valueOf('2011-07-08'),Term__c=Date.valueOf('2039-12-31'),Drug_Code_Value__c='03530025000320',Status__c='Approved');
    insert DLCrec;
    Step_Therapy_PreRequisite_Drug__c step1 = new Step_Therapy_PreRequisite_Drug__c();
      step1.Step_Therapy_Pre_Requisite_Drug_Name__c = 'Test';
      step1.Description_of_Pre_Requisite_Drug__c = 'Test1';
      step1.Drug_Type_Code__c = 'GPI';
      step1.Drug_Code_Value__c = '12*';
      step1.Mandatory__c = 'No';
      step1.Lookback__c = 10;
      step1.Lookback_Period__c = 'Days';
      step1.Modifier__c = 'A';
      step1.Priority__c = 'Low';
      step1.Related_Drug_List_Criteria__c = DLCrec.Id;
      step1.Effective_Date__c = Date.valueOf('2011-07-09');
      step1.Termination_Date__c = Date.valueOf('2015-07-08');
      step1.Minimum_Day_Supply__c = 10;
      step1.Days_Remaining__c = 12;
      step1.Remaining__c = 5;
      insert step1;
     Step_Therapy_PreRequisite_Drug__c step2 = new Step_Therapy_PreRequisite_Drug__c();
      step2.Step_Therapy_Pre_Requisite_Drug_Name__c = 'Test';
      step2.Description_of_Pre_Requisite_Drug__c = 'Test1';
      step2.Drug_Type_Code__c = 'GPI';
      step2.Drug_Code_Value__c = '12*';
      step2.Mandatory__c = 'No';
      step2.Lookback__c = 10;
      step2.Lookback_Period__c = 'Days';
      step2.Modifier__c = 'A';
      step2.Priority__c = 'Low';
      step2.Related_Drug_List_Criteria__c = DLCrec.Id;
      step2.Effective_Date__c = Date.valueOf('2011-07-09');
      step2.Termination_Date__c = Date.valueOf('2015-07-08');
      step2.Minimum_Day_Supply__c = 10;
      step2.Days_Remaining__c = 12;
      step2.Remaining__c = 5;
      step2.Step_Therapy_Pre_Requisite_Drug_Parent__c = step1.id;
      insert step2;
     Forms__c form1 = new Forms__c();
      form1.Form_Name__c = 'test';
      form1.Form_Description__c = 'test2';
      form1.Effective_Date__c = Date.valueOf('2011-07-09');
      form1.Termination_Date__c = Date.valueOf('2015-07-08');
      form1.Location_of_Form__c = 'longtext';
      form1.Form_Text__c = 'longtext1';
      insert form1;
     Denial_Letter_Junction__c formjunc = new Denial_Letter_Junction__c();
      formjunc.Denial_Letter_ID__c = form1.id;
      insert formjunc;
     Stepped_Over_Time__c stepOver = new Stepped_Over_Time__c();
     stepOver.Related_Drug_List_Criteria__c = DLCrec.Id;
     insert stepOver;
      
      return DLrec.Id;
  }
  //== Testing HVXMLGenerator
  private testmethod static void HVXMLGeneratorTest(){
    HVXMLGenerator obj=new HVXMLGenerator([SELECT Id FROM Drug_List__c WHERE RecordType.DeveloperName='Drug_List' LIMIT 1][0].Id);
    system.assert(obj!=NULL);
    Database.executeBatch(new HVXMLGenerator(prepareData('Quantity_Limit')));  
  }
  
  //== Testing HVXMLGeneratorDL
  private testmethod static void HVXMLGeneratorDLTest(){
    HVXMLGenerator obj=new HVXMLGenerator([SELECT Id FROM Drug_List__c WHERE RecordType.DeveloperName='Quantity_Limit' LIMIT 1][0].Id);
    system.assert(obj!=NULL);
    Database.executeBatch(new HVXMLGeneratorDL(prepareData('Drug_List')));  
    
  }
}