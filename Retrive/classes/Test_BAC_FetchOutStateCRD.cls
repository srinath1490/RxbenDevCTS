/*Purpose: Apex Test Class to test Out State Flow
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7/10/2013       Apex Test class to test Out State Flow
======================================================================== */
@isTest
private class Test_BAC_FetchOutStateCRD{
//#######Test method for BAC_FetchOutStateCRD batch #######
 static testMethod void Test_BAC_FetchOutStateCRD(){
    list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where Name='Retail' and sobjecttype='Drug_Coverage__c' limit 1]);
    Crd__c newcrd = new Crd__c();       
        newcrd.RxPlanID__c='1231231234';
        newcrd.Retail_to_Mail__c =True; 
        newcrd.CRD_Automated__c = TRUE;
        insert newcrd;
     
    Migration_run_file__c mrfrec = new Migration_run_file__c();
        mrfrec.Rxplanid__c='1231231234';
        insert mrfrec;
     
    Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.TPID__c='00017242422';
        persinstance.Processed__c=false;
        persinstance.migration_run_file__c=mrfrec.id;
        persinstance.Rxplan_id__c='1231231234';
        insert persinstance;
     
     Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
        drugCoverateItem.CRD_ID__c = newcrd.id;
        drugCoverateItem.RecordTypeId=rt.get(0).id;
        drugCoverateItem.Do_you_have_Choose_Generic__c ='No';
        //drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='Not elected';
        drugCoverateItem.Do_you_have_Specialty__c ='Yes';
        drugCoverateItem.Aetna_Specialty_Care_Rx__c='Does not Apply (Insured/not state filed)';
        drugCoverateItem.Speciality_Drug_List__c = null;
        drugCoverateItem.Max_Specialty_Day_Supply__c = null;
        drugCoverateItem.Force_to_Specialty__c='No';
        system.debug('@@@@'+drugCoverateItem.Do_you_have_Specialty__c+'+'+drugCoverateItem.Force_to_Specialty__c+'+'+drugCoverateItem.Aetna_Specialty_Care_Rx__c+'+'+drugCoverateItem.Speciality_Drug_List__c+'+'+drugCoverateItem.of_fills_before_force_to_specialty__c+'+'+drugCoverateItem.Max_Specialty_Day_Supply__c);
        insert drugCoverateItem;
     
     Drug_List__c tempDrugList = new  Drug_List__c();
           tempDrugList.Drug_List_Name__c = 'Test2';
           tempDrugList.Description__c = 'description';
           tempDrugList.Special_Use__c = 'Save-A-Copay';
           tempDrugList.Standard__c = true;
           tempDrugList.LastSent__c = system.now();
           tempDrugList.Clinical_Edit_Code__c='1';
     insert tempDrugList;
     
     DC_Drug_List_Group__c drugList = new DC_Drug_List_Group__c();
        drugList.Related_Drug_Coverage__c=drugCoverateItem.id;
        drugList.Inclusion_Exclusion__c='Include';
       // drugList.Inclusion_Exclusion_Drug_Class__c='Fertility- inj';
        drugList.Drug_List__c=tempDrugList.id;
        insert drugList; 
    Test.StartTest();
        BAC_FetchOutStateCRDStep1 OutStatebatch1 = new BAC_FetchOutStateCRDStep1();
        ID batchprocessid1 = Database.executeBatch(OutStatebatch1);
    Test.StopTest();
 }
    
    //#######Test method for BAC_FetchOutStateCRD batch #######
 static testMethod void Test_BAC_FetchOutStateCRD1(){
    list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where Name='Retail' and sobjecttype='Drug_Coverage__c' limit 1]);
    Crd__c newcrd = new Crd__c();       
        newcrd.RxPlanID__c='1231231233';
        newcrd.Retail_to_Mail__c =True;
        newcrd.CRD_Automated__c = TRUE;
        insert newcrd;
     
    Case caserec = new Case();
        caserec.RxPlan_ID__c='1231231233';
        caserec.requestType__c = 'Traditional_Source_PERS';
        insert caserec;
     
    Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.TPID__c='00017242422';
        persinstance.Processed__c=false;
        persinstance.case__c=caserec.id;
        persinstance.Rxplan_id__c='1231231233';
        //persinstance.Full_CSAP__c=
        insert persinstance;
     
     Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
        drugCoverateItem.CRD_ID__c = newcrd.id;
        drugCoverateItem.RecordTypeId=rt.get(0).id;
        drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
        drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='Not elected';
        drugCoverateItem.Do_you_have_Specialty__c ='Yes';
        drugCoverateItem.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List w/ Fertility';
        drugCoverateItem.Force_to_Specialty__c ='Yes';
        drugCoverateItem.of_fills_before_force_to_specialty__c=1;
        
        insert drugCoverateItem;
     
     Drug_List__c tempDrugList = new  Drug_List__c();
           tempDrugList.Drug_List_Name__c = 'Test3';
           tempDrugList.Description__c = 'description';
           tempDrugList.Special_Use__c = 'Save-A-Copay';
           tempDrugList.Standard__c = true;
           tempDrugList.LastSent__c = system.now();
           tempDrugList.Clinical_Edit_Code__c='1';
     insert tempDrugList;
     
     DC_Drug_List_Group__c drugList = new DC_Drug_List_Group__c();
        drugList.Related_Drug_Coverage__c=drugCoverateItem.id;
        drugList.Inclusion_Exclusion__c='Exclude';
        //drugList.Inclusion_Exclusion_Drug_Class__c='Fertility- inj';
        drugList.Drug_List__c=tempDrugList.id;
        insert drugList; 
    Test.StartTest();
        BAC_FetchOutStateCRDStep1 OutStatebatch1 = new BAC_FetchOutStateCRDStep1();
        ID batchprocessid1 = Database.executeBatch(OutStatebatch1);
    Test.StopTest();
 }

}