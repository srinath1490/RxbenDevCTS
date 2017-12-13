/*Purpose: Apex Test Class to test CB_FormularyPlusUpdate
========================================================================
History 
------- 
VERSION    AUTHOR    DATE        DETAIL 
1.0        Amit    8/27/2015   Apex Test Class to test CB_FormularyPlusUpdate
======================================================================== */

@isTest(SeeAllData=true)
private class TEST_CB_FormularyPlusUpdate{
    static testMethod void testFormularyPlus(){
        String dcMailRecordID;
        String dcRetailRecordID;
        Map<ID,String> DCwithRecordType = new Map<ID,String>();
        Map<Id,ID> mapDC2Formulary = new Map<Id,ID>();
        for(RecordType RecType : [Select Id,Name,SobjectType From RecordType where SobjectType = 'Drug_coverage__c' and (Name ='Mail' or Name ='Retail')]){
            if(RecType.Name =='Mail'){
                dcMailRecordID =  RecType.ID;
            }else{
                dcRetailRecordID =  RecType.ID;
            }
        }
        Account newAccount = new Account();
        newAccount.Name = 'Test Account';
        newAccount.APM_PSUID__c = '0000000000000001';
        insert newAccount;
        CRD__c newCRD1 = new CRD__c();
        newCRD1.crd_automated__c =True;
        newCRD1.Do_you_want_to_do_Precert__c = 'Yes';
        newCRD1.Do_you_want_to_do_Step_Therapy__c = 'Yes';
        newCRD1.Insured_Type__c = 'Self Insured';
        newCRD1.Contract_State__c = 'CT'; 
        newCRD1.Are_there_Quantity_Limits__c = 'Yes';
        insert newCRD1;
        
        
               
        Option_Code__c newrec = new Option_Code__c();
        newrec.Option_Code_Name__c ='AE';
        newrec.Option_Code_Description__c ='Open 4 tier Value with non-preferred generics';
        newrec.Effective_Date__c =System.today();
        newrec.Termination_Date__c =System.today() + 5;
        newrec.Primary_Secondary_Indicator__c = 'Primary';
        insert newrec;
        
        Formulary__c newFormulary = new Formulary__c();
        newFormulary.Formulary_Name__c ='AE';
        newFormulary.Formulary_Description__c ='Open 4 tier Value with non-preferred generics';
        newFormulary.Formulary_Open_Closed__c ='Open';
        newFormulary.Effective_Date__c =System.today();
        newFormulary.Termination_Date__c =System.today() +5;
        newFormulary.Option_Code__c =newrec.id;
        insert newFormulary;
        
        String recid;
        for(RecordType RecType : [Select Id,Name,SobjectType From RecordType where SobjectType = 'Drug_List__c' and Name= 'Drug List']){
            recid = RecType.id;
        }
        drug_List__c newdruglist = new drug_List__c();
        newdruglist.Drug_List_Name__c = 'NPLSGVLP';
        newdruglist.Description__c ='NPL SG Value Plus';
        newdruglist.recordtypeid = recid;
        newdruglist.Special_Use__c = 'Specialty List';
        insert newdruglist;
        
        String str = newdruglist.id;
        str = str.substring(0,15);
        
        FormularyXCustomDL_ERD__c newFormularyX = new FormularyXCustomDL_ERD__c();
        newFormularyX.Step_Therapy__c ='DL-0073802';
        newFormularyX.Precert__c ='DL-0076034;DL-0073798';
        newFormularyX.Quantity_Limit__c ='DL-0076035;DL-0073800;DL-0076025';
        newFormularyX.Formulary__c =newFormulary.id;
        newFormularyX.Secondary_Aetna_Specialty_Care_Rx__c = 'Custom';
        newFormularyX.Secondary_of_fills_before_Force_to_SPN__c = '2';
        newFormularyX.Secondary_Specialty_Drug_List_ID__c = str;
        insert newFormularyX;              
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = newCRD1.Id;
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = newCRD1.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Formulary__c = newFormulary.id;
        dCoverageRetail.Formulary_Open_Closed__c = 'Open';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c = 'Custom';
        dCoverageRetail.Secondary_Speciality_Drug_List__c = newdruglist.id;
        insert dCoverageRetail;
        
        DCwithRecordType.put(dCoverageRetail.id,dCoverageRetail.Recordtype.name);
        mapDC2Formulary.put(dCoverageRetail.id, newFormulary.id);
        CB_FormularyPlusUpdate currentInstance = new CB_FormularyPlusUpdate();
        currentInstance.formularyPlusUpdates(mapDC2Formulary, dCoverageMail, newCRD1, DCwithRecordType);
    }
}