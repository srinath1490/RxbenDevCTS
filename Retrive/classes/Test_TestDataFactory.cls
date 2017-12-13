/*Purpose: Apex Class to create Drug List and Drug Group Test Data for Test Classes
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi        21st Jan 2016     Apex Class to create Drug List and Drug Group Test Data for Test Classes
======================================================================== */
@isTest (SeeAllData=False)

public class Test_TestDataFactory
{    
  
  /* String defining the values for the Allowable Actions field on Drug List and Drug Group */
  static String picklistval = 'Inclusion; Exclusion; Prior Auth; Drug Specific Copay; Waiver of Deductible; Drug Specific Accum; Apply limitations on CRD; Allow Rule to be overridden';
  
  /* Method to create and return a Drug List record */
  public Drug_List__c TestDataFactoryDrugList() 
  {     
       
        drug_list__c dl = new drug_list__c();
        dl.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl.inactive__c = false;
        dl.Special_Use__c = 'Specialty List';
        dl.Allowable_Actions__c= picklistval ;
        insert dl;
        return dl;   
  }
   
  /* Method to create and return a Drug Group record */      
  public Drug_Group__c TestDataFactoryDrugGroup() 
  {
            Drug_Group__c dg = new Drug_Group__c();
            dg.Drug_Group_Name__c = 'Acne- all- PR 36 y/o';
            dg.Effective_Date__c = system.today();
            dg.Description__c = 'Acne- all- PR 36 y/o';
            dg.Termination_Date__c = system.today()+7;
            dg.Allowable_Actions__c= picklistval ;
            insert dg;
            return dg;
  }
      
}