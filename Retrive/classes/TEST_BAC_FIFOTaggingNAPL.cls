/*Purpose: Apex Test Class to test BAC_FIFOTagging
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi         1st September 2015       Apex Test class to test BAC_FIFOTagging for Req 5996
======================================================================== */
@isTest
private class TEST_BAC_FIFOTaggingNAPL{  
    
    PRIVATE STATIC FINAL string CUSTOMSETTINGNAME = 'Trigger Configurations';
     
    static testMethod void TEST_BAC_FIFOTaggingNAPL(){
        
        Org_Trigger_Configurations__c triggerConfigSetting = new Org_Trigger_Configurations__c();
        triggerConfigSetting.Name = CUSTOMSETTINGNAME;
        triggerConfigSetting.TRG_FIFOControlParsing__c = True;
        
        Insert triggerConfigSetting ;
    
        //Testing the National Labor logic
        CRD__c crd = new crd__c();
        crd.National__c = 'National';
        insert crd;
        
        CRD__c crd5 = new crd__c();
        crd5.National__c = 'National';
        insert crd5;
        
        case falloutcasenewNAPL = new case();
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenewNAPL.RecordTypeId = rtNAPL.Id;
        falloutcasenewNAPL.status='New';
        falloutcasenewNAPL.FIFO_tag__c=null;
        falloutcasenewNAPL.FIFO_record_name__c=null;
        falloutcasenewNAPL.reason='Internal CRD';
        insert falloutcasenewNAPL;
        
        case falloutcasenewNAPL1 = new case();
        RecordType rtNAPL2= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenewNAPL1.RecordTypeId = rtNAPL2.Id;
        falloutcasenewNAPL1.status='New';
        falloutcasenewNAPL1.FIFO_tag__c='Rework';
        falloutcasenewNAPL1.FIFO_record_name__c= 'FR-000999';
        falloutcasenewNAPL1.reason='Internal CRD';
        insert falloutcasenewNAPL1;
        
        case externalcaseNAPL = new case();
        RecordType rtNAPL1= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcaseNAPL.RecordTypeId = rtNAPL1.Id;
        externalcaseNAPL.status='New';
        externalcaseNAPL.FIFO_tag__c=null;
        externalcaseNAPL.FIFO_record_name__c=null;
        insert externalcaseNAPL;
        
        FIFO_Report__c FIFONAPL = new FIFO_Report__c();
        FIFONAPL.FIFO_Segment__c='NAPL';
        FIFONAPL.Control__c=808081;
        FIFONAPL.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL.Transaction_Type__c = 'Rework';
        FIFONAPL.Plan_Setup_Completed__c=null;
        FIFONAPL.Key__c='808081201513True';
        insert FIFONAPL;
        
        FIFO_Report__c FIFONAPL1 = new FIFO_Report__c();
        FIFONAPL1.FIFO_Segment__c='NAPL';
        FIFONAPL1.Control__c=808081;
        FIFONAPL1.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL1.Transaction_Type__c = 'Renew';
        FIFONAPL1.Plan_Setup_Completed__c=null;
        FIFONAPL1.Key__c='808081201514True';
        insert FIFONAPL1;
        
        FIFO_Report__c FIFONAPL2 = new FIFO_Report__c();
        FIFONAPL2.FIFO_Segment__c='NAPL';
        FIFONAPL2.Control__c=808081;
        FIFONAPL2.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL2.Escalation__c=true;
        FIFONAPL2.Plan_Setup_Completed__c=null;
        FIFONAPL2.Key__c='808081201515True';
        insert FIFONAPL2;
        
        case externalcaseNAPL1 = new case();
        RecordType rtNAPL3= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcaseNAPL1.RecordTypeId = rtNAPL3.Id;
        externalcaseNAPL1.status='New';
        externalcaseNAPL1.FIFO_tag__c=null;
        externalcaseNAPL1.FIFO_record_name__c=null;
        insert externalcaseNAPL1;
        
        CRDBuildOrder__c cbonRecordnew = new CRDBuildOrder__c();
        cbonRecordnew.Build__c = true;
        cbonRecordnew.crd__c = crd.id;
        cbonRecordnew.falloutcase__c= falloutcasenewNAPL.id;
        cbonRecordnew.Case__c=externalcaseNAPL.id;           
        cbonRecordnew.Control__c = 808081;
        cbonRecordnew.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecordnew.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecordnew;
        
        CRDBuildOrder__c cbonRecord6 = new CRDBuildOrder__c();
        cbonRecord6.Build__c = true;
        cbonRecord6.crd__c = crd5.id;
        cbonRecord6.falloutcase__c= falloutcasenewNAPL1.id;
        cbonRecord6.Case__c=externalcaseNAPL1.id;          
        cbonRecord6.Control__c = 808081;
        cbonRecord6.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecord6.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord6;
        
        Database.executeBatch(new BAC_FIFOTagging(),200);
    }
}