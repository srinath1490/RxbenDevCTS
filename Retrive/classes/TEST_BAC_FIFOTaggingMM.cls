/*Purpose: Apex Test Class to test BAC_FIFOTagging
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi         1st September 2015       Apex Test class to test BAC_FIFOTagging for Req 5996
======================================================================== */
@isTest
private class TEST_BAC_FIFOTaggingMM{ 

    PRIVATE STATIC FINAL string CUSTOMSETTINGNAME = 'Trigger Configurations';
          
    static testMethod void TEST_BAC_FIFOTaggingMM(){
    
        Org_Trigger_Configurations__c triggerConfigSetting = new Org_Trigger_Configurations__c();
        triggerConfigSetting.Name = CUSTOMSETTINGNAME;
        triggerConfigSetting.TRG_FIFOControlParsing__c = True;
        
        Insert triggerConfigSetting ;
    
        //Testing the Middle Market logic
        CRD__c crd = new crd__c();
        crd.National__c = 'Key';
        insert crd;
        
        CRD__c crd2 = new crd__c();
        crd2.National__c = 'Key';
        insert crd2;
        
        CRD__c crd3 = new crd__c();
        crd3.National__c = 'Select';
        insert crd3;
        
        case falloutcasenew = new case();
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenew.RecordTypeId = rt.Id;
        falloutcasenew.status='New';
        falloutcasenew.FIFO_tag__c=null;
        falloutcasenew.FIFO_record_name__c=null;
        falloutcasenew.reason='Internal CRD';
        insert falloutcasenew;
        
        case falloutcasenew1 = new case();
        RecordType rtMM2= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenew1.RecordTypeId = rtMM2.Id;
        falloutcasenew1.status='New';
        falloutcasenew1.FIFO_tag__c='Rework';
        falloutcasenew1.FIFO_record_name__c= 'FR-000999';
        falloutcasenew1.reason='Internal CRD';
        insert falloutcasenew1;
        
        case externalcase = new case();
        RecordType rt1= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcase.RecordTypeId = rt1.Id;
        externalcase.status='New';
        externalcase.FIFO_tag__c=null;
        externalcase.FIFO_record_name__c=null;
        insert externalcase;
        
        FIFO_Report__c FIFOMM3 = new FIFO_Report__c();
        FIFOMM3.FIFO_Segment__c='MM';
        FIFOMM3.Control__c=808088;
        FIFOMM3.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMM3.Plan_Setup_Completed__c= date.newinstance(2015,4,4);
        FIFOMM3.Key__c='808080201511False';
        insert FIFOMM3;
        
        FIFO_Report__c FIFOMM = new FIFO_Report__c();
        FIFOMM.FIFO_Segment__c='MM';
        FIFOMM.Control__c=808088;
        FIFOMM.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMM.Plan_Setup_Completed__c= date.newinstance(2015,4,4);
        FIFOMM.Escalation__c = true;
        FIFOMM.Key__c='808080201511True';
        insert FIFOMM;
        
        FIFO_Report__c FIFOMMnew1 = new FIFO_Report__c();
        FIFOMMnew1.FIFO_Segment__c='MM';
        FIFOMMnew1.Control__c=808088;
        FIFOMMnew1.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMMnew1.Plan_Setup_Completed__c= date.newinstance(2015,5,5);
        FIFOMMnew1.Key__c='808080201555False1';
        insert FIFOMMnew1;
        
        FIFO_Report__c FIFOMMnew = new FIFO_Report__c();
        FIFOMMnew.FIFO_Segment__c='MM';
        FIFOMMnew.Control__c=808088;
        FIFOMMnew.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMMnew.Plan_Setup_Completed__c= date.newinstance(2015,5,5);
        FIFOMMnew.Transaction_type__c='Rework';
        FIFOMMnew.Key__c='808080201555True';
        insert FIFOMMnew;
        
        FIFO_Report__c FIFOMM1 = new FIFO_Report__c();
        FIFOMM1.FIFO_Segment__c='MM';
        FIFOMM1.Control__c=808088;
        FIFOMM1.Effective_Date__c=date.newinstance(2015,1,3);
        FIFOMM1.Plan_Setup_Completed__c= date.newinstance(2015,2,2);
        FIFOMM1.Transaction_Type__c = 'Rework';
        FIFOMM1.Key__c='808080201515True'; 
        insert FIFOMM1;
        
        FIFO_Report__c FIFOMM2 = new FIFO_Report__c();
        FIFOMM2.FIFO_Segment__c='MM';
        FIFOMM2.Control__c=808088;
        FIFOMM2.Effective_Date__c=date.newinstance(2015,1,3);
        FIFOMM2.Plan_Setup_Completed__c= date.newinstance(2015,9,9);
        FIFOMM2.Escalation__c = true;
        FIFOMM2.Key__c='808080201519True';
        insert FIFOMM2;
        
        CRDBuildOrder__c cbonRecord2 = new CRDBuildOrder__c();
        cbonRecord2.Build__c = true;
        cbonRecord2.crd__c = crd.id;
        cbonRecord2.Case__c=externalcase.id;          
        cbonRecord2.Control__c = 808088;
        cbonRecord2.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecord2.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord2;
        
        case externalcase1 = new case();
        RecordType rtMM3= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcase1.RecordTypeId = rtMM3.Id;
        externalcase1.status='New';
        externalcase1.FIFO_tag__c=null;
        externalcase1.FIFO_record_name__c=null;
        insert externalcase1;
        
        CRDBuildOrder__c cbonRecordnewgen = new CRDBuildOrder__c();
        cbonRecordnewgen.Build__c = true;
        cbonRecordnewgen.crd__c = crd2.id;
        cbonRecordnewgen.falloutcase__c= falloutcasenew.id;
        cbonRecordnewgen.Case__c=externalcase.id;           
        cbonRecordnewgen.Control__c = 808082;
        cbonRecordnewgen.Effective_date__c = date.newinstance(2015,1,3);
        cbonRecordnewgen.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecordnewgen;
        
        CRDBuildOrder__c cbonRecord6 = new CRDBuildOrder__c();
        cbonRecord6.Build__c = true;
        cbonRecord6.crd__c = crd3.id;
        cbonRecord6.falloutcase__c= falloutcasenew1.id;
        cbonRecord6.Case__c=externalcase1.id;          
        cbonRecord6.Control__c = 808081;
        cbonRecord6.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecord6.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord6;
        
        Database.executeBatch(new BAC_FIFOTagging(),200);
    }
}