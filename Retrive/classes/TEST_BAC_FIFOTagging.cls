/*Purpose: Apex Test Class to test BAC_FIFOTagging and CB_FIFO_Tag
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi         1st September 2015       Apex Test class to test BAC_FIFOTagging for Middle Market, NAPL and Other CBON records
======================================================================== */
@isTest (SeeAllData=false)
private class TEST_BAC_FIFOTagging{  

    /* Setting the Custom Settings for the trigger TRG_FIFOControlParsing to work properly */
    PRIVATE STATIC FINAL string CUSTOMSETTINGNAME = 'Trigger Configurations';
       
    /*
        Method: TESTBAC_FIFOTaggingGeneral()
        Description: Method to test the tagging of the cases when there is no matching FIFO record for the CBON
    */ 
   static testmethod void TESTBAC_FIFOTaggingGeneral(){

        Org_Trigger_Configurations__c triggerConfigSetting = new Org_Trigger_Configurations__c();
        triggerConfigSetting.Name = CUSTOMSETTINGNAME;
        triggerConfigSetting.TRG_FIFOControlParsing__c = True;
        
        Insert triggerConfigSetting ;
        
        List<case> casetocreate = new list<case>();
        List<fifo_report__c> fiforecords = new list<fifo_report__c>();
        
        // CRD with different values for Segment are created
        CRD__c crd = new crd__c();
        crd.National__c = 'Small Group';
        insert crd;
        
        CRD__c crd2 = new crd__c();
        crd2.National__c = 'National';
        insert crd2;
        
        CRD__c crd3 = new crd__c();
        crd3.National__c = 'Small Group';
        insert crd3;
        
        //Creating fallout case
        case falloutcasenew = new case();
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenew.RecordTypeId = rt.Id;
        falloutcasenew.status='New';
        falloutcasenew.FIFO_tag__c=null;
        falloutcasenew.Transaction_Type__c=null;
        falloutcasenew.FIFO_record_name__c=null;
        falloutcasenew.reason='Internal CRD';
        casetocreate.add(falloutcasenew);
        
        //Creating fallout case with an existing FIFO Tag
        case falloutcasenew1 = new case();
        falloutcasenew1.RecordTypeId = rt.Id;
        falloutcasenew1.status='New';
        falloutcasenew1.FIFO_tag__c='Rework';
        falloutcasenew1.Transaction_Type__c='Rework';
        falloutcasenew1.FIFO_record_name__c= 'FR-000999';
        falloutcasenew1.reason='Internal CRD';
        casetocreate.add(falloutcasenew1);
        
        case successcase = new case();
        successcase.RecordTypeId = rt.Id;
        successcase.status='New';
        successcase.FIFO_tag__c=null;
        successcase.Transaction_Type__c=null;
        successcase.FIFO_record_name__c= null;
        successcase.reason='Internal CRD';
        casetocreate.add(successcase);
        
        //Creating external case
        case externalcase = new case();
        RecordType rt1= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcase.RecordTypeId = rt1.Id;
        externalcase.status='New';
        externalcase.FIFO_tag__c=null;
        externalcase.Transaction_Type__c=null;
        externalcase.FIFO_record_name__c=null;
        casetocreate.add(externalcase);
        
        case externalcase1 = new case();
        externalcase1.RecordTypeId = rt1.Id;
        externalcase1.status='New';
        externalcase1.FIFO_tag__c=null;
        externalcase1.Transaction_Type__c=null;
        externalcase1.FIFO_record_name__c=null;
        casetocreate.add(externalcase1);
        
        /* Inserting all the cases list */
        if(casetocreate.size() > 0){   
            insert casetocreate; 
        }
        
        //Creating FIFO records with different FIFO Tag, Control and Effective Date
        FIFO_Report__c FIFOMM = new FIFO_Report__c();
        FIFOMM.FIFO_Segment__c='MM';
        FIFOMM.Control__c=808080;
        FIFOMM.Effective_Date__c=date.newinstance(2015,1,1);
        FIFOMM.Plan_Setup_Completed__c= date.newinstance(2015,4,4);
        FIFOMM.Escalation__c = true;
        FIFOMM.Key__c='808080201511True';
        fiforecords.add(FIFOMM);
        
        FIFO_Report__c FIFOMM1 = new FIFO_Report__c();
        FIFOMM1.FIFO_Segment__c='MM';
        FIFOMM1.Control__c=808080;
        FIFOMM1.Effective_Date__c=date.newinstance(2015,1,1);
        FIFOMM1.Plan_Setup_Completed__c= date.newinstance(2015,5,5);
        FIFOMM1.Transaction_Type__c = 'Rework';
        FIFOMM1.Key__c='808080201512True'; 
        fiforecords.add(FIFOMM1);
        
        FIFO_Report__c FIFOMM2 = new FIFO_Report__c();
        FIFOMM2.FIFO_Segment__c='MM';
        FIFOMM2.Control__c=808080;
        FIFOMM2.Effective_Date__c=date.newinstance(2015,1,1);
        FIFOMM2.Plan_Setup_Completed__c= date.newinstance(2015,9,9);
        FIFOMM2.Escalation__c = true;
        FIFOMM2.Key__c='808080201515True';
        fiforecords.add(FIFOMM2);
        
        FIFO_Report__c FIFONAPL = new FIFO_Report__c();
        FIFONAPL.FIFO_Segment__c='NAPL';
        FIFONAPL.Control__c=808081;
        FIFONAPL.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL.Transaction_Type__c = 'Rx Rework';
        FIFONAPL.Plan_Setup_Completed__c=null;
        FIFONAPL.Key__c='808081201517True';
        fiforecords.add(FIFONAPL);
        
        FIFO_Report__c FIFONAPL1 = new FIFO_Report__c();
        FIFONAPL1.FIFO_Segment__c='NAPL';
        FIFONAPL1.Control__c=808081;
        FIFONAPL1.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL1.Transaction_Type__c = 'Renew';
        FIFONAPL1.Plan_Setup_Completed__c=null;
        FIFONAPL1.Key__c='808081201509True';
        fiforecords.add(FIFONAPL1);
        
        FIFO_Report__c FIFONAPL2 = new FIFO_Report__c();
        FIFONAPL2.FIFO_Segment__c='NAPL';
        FIFONAPL2.Control__c=808081;
        FIFONAPL2.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL2.Escalation__c=true;
        FIFONAPL2.Plan_Setup_Completed__c=null;
        FIFONAPL2.Key__c='808081201502True';
        fiforecords.add(FIFONAPL2);
        
        /* Inserting the FIFO records list */
        if(fiforecords.size() > 0){   
            insert fiforecords; 
        }
        
        //Creating CBON records for the CRD, FIFO Report and cases created previously
        CRDBuildOrder__c cbonRecord3 = new CRDBuildOrder__c();
        cbonRecord3.Build__c = true;
        cbonRecord3.crd__c = crd.id;
        cbonRecord3.falloutcase__c= falloutcasenew.id;
        cbonRecord3.success_case__c=successcase.id;
        cbonRecord3.Case__c=externalcase.id;          
        cbonRecord3.Control__c = 808082;
        cbonRecord3.Effective_date__c = date.newinstance(2015,1,3);
        cbonRecord3.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord3;
        system.debug('$$Richa='+cbonRecord3.crd__c+'$$'+cbonRecord3.falloutcase__c+'$$'+cbonRecord3.Case__c+'$$'+cbonRecord3.Effective_date__c);
        
        CRDBuildOrder__c cbonRecord4 = new CRDBuildOrder__c();
        cbonRecord4.Build__c = true;
        cbonRecord4.crd__c = crd2.id;
        cbonRecord4.Case__c=externalcase.id;          
        cbonRecord4.Control__c = 808082;
        cbonRecord4.Effective_date__c = date.newinstance(2015,1,3);
        cbonRecord4.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord4;
        
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
        
        Test.startTest();
        //Calling the FIFO Batch
        BAC_FIFOTagging FIFOTagBatch = new BAC_FIFOTagging();
        ID batchprocessid = database.executeBatch(FIFOTagBatch);
        Test.stopTest();
        
        /*  Getting the values of the FIFO Tag set for the external,fallout and success cases */
        string externaltag1 = [select id,fifo_tag__c from case where id =: externalcase1.id].fifo_tag__c;
        string fallouttag = [select id,fifo_tag__c from case where id =: falloutcasenew.id].fifo_tag__c;
        string fallouttag1 = [select id,fifo_tag__c from case where id =: falloutcasenew1.id].fifo_tag__c; 
        string externaltag = [select id,fifo_tag__c from case where id =: externalcase.id].fifo_tag__c;
        string successtag = [select id,fifo_tag__c from case where id =: successcase.id].fifo_tag__c;
        
        /* Checking the values for the FIFO Tag that is set on the cases */        
        system.assert(((fallouttag=='General')&&(fallouttag1=='Rework')&&(externaltag1=='Rework')&&(externaltag=='General')&&(successtag=='General')) , 'Wrong FIFO Tagging');
        
    }
    
    
    /*
        Method: TEST_BAC_FIFOTaggingMM()
        Description: Method to test the tagging of the cases when there are Middle Market matching FIFO record for the CBON
    */ 
    static testMethod void TEST_BAC_FIFOTaggingMM(){
    
        Org_Trigger_Configurations__c triggerConfigSetting = new Org_Trigger_Configurations__c();
        triggerConfigSetting.Name = CUSTOMSETTINGNAME;
        triggerConfigSetting.TRG_FIFOControlParsing__c = True;
        
        Insert triggerConfigSetting ;
    
        List<case> casetocreateMM = new list<case>();
        List<fifo_report__c> fiforecordsMM = new list<fifo_report__c>();
        
        // CRD with different values for Segment are created
        CRD__c crd = new crd__c();
        crd.National__c = 'Key';
        insert crd;
        
        CRD__c crd2 = new crd__c();
        crd2.National__c = 'Key';
        insert crd2;
        
        CRD__c crd3 = new crd__c();
        crd3.National__c = 'Select';
        insert crd3;
        
        //Creating fallout case
        case falloutcasenew = new case();
        RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenew.RecordTypeId = rt.Id;
        falloutcasenew.status='New';
        falloutcasenew.FIFO_tag__c=null;
        falloutcasenew.FIFO_record_name__c=null;
        falloutcasenew.reason='Internal CRD';
        casetocreateMM.add(falloutcasenew);
        
        //Creating fallout case with an existing FIFO Tag
        case falloutcasenew1 = new case();
        falloutcasenew1.RecordTypeId = rt.Id;
        falloutcasenew1.status='New';
        falloutcasenew1.FIFO_tag__c='Escalated';
        falloutcasenew1.FIFO_record_name__c= 'FR-000999';
        falloutcasenew1.reason='Internal CRD';
        casetocreateMM.add(falloutcasenew1);
        
        //Creating success case record
        case successcase = new case();
        successcase.RecordTypeId = rt.Id;
        successcase.status='New';
        successcase.FIFO_tag__c=null;
        successcase.Transaction_Type__c=null;
        successcase.FIFO_record_name__c= null;
        successcase.reason='Internal CRD';
        casetocreateMM.add(successcase);
        
        case successcase1 = new case();
        successcase1.RecordTypeId = rt.Id;
        successcase1.status='New';
        successcase1.FIFO_tag__c='Rework';
        successcase1.Transaction_Type__c='Rework';
        successcase1.FIFO_record_name__c= 'FR-000899';
        successcase1.reason='Internal CRD';
        casetocreateMM.add(successcase1);
        
        //Creating external case        
        case externalcase = new case();
        RecordType rt1= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcase.RecordTypeId = rt1.Id;
        externalcase.status='New';
        externalcase.FIFO_tag__c=null;
        externalcase.FIFO_record_name__c=null;
        casetocreateMM.add(externalcase);
        
        case externalcase1 = new case();
        externalcase1.RecordTypeId = rt1.Id;
        externalcase1.status='New';
        externalcase1.FIFO_tag__c=null;
        externalcase1.FIFO_record_name__c=null;
        casetocreateMM.add(externalcase1);
        
        //Creating external with existing FIFO Tag
        case externalcase2 = new case();
        externalcase2.RecordTypeId = rt1.Id;
        externalcase2.status='New';
        externalcase2.FIFO_tag__c='Escalated';
        externalcase2.FIFO_record_name__c='FR-000987';
        casetocreateMM.add(externalcase2);
        
        /* Inserting all the cases list */
        if(casetocreateMM.size() > 0){   
            insert casetocreateMM; 
        }
        
        //Creating FIFO records with different FIFO Tag, Control and Effective Date
        FIFO_Report__c FIFOMM3 = new FIFO_Report__c();
        FIFOMM3.FIFO_Segment__c='MM';
        FIFOMM3.Control__c=808088;
        FIFOMM3.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMM3.Plan_Setup_Completed__c= date.newinstance(2015,4,4);
        FIFOMM3.Key__c='808080201511False';
        fiforecordsMM.add(FIFOMM3);
        
        FIFO_Report__c FIFOMMnew1 = new FIFO_Report__c();
        FIFOMMnew1.FIFO_Segment__c='MM';
        FIFOMMnew1.Control__c=808088;
        FIFOMMnew1.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMMnew1.Plan_Setup_Completed__c= date.newinstance(2015,5,5);
        FIFOMMnew1.Key__c='808080201555False1';
        fiforecordsMM.add(FIFOMMnew1);
        
        FIFO_Report__c FIFOMMnew = new FIFO_Report__c();
        FIFOMMnew.FIFO_Segment__c='MM';
        FIFOMMnew.Control__c=808088;
        FIFOMMnew.Effective_Date__c=date.newinstance(2015,1,2);
        FIFOMMnew.Plan_Setup_Completed__c= date.newinstance(2015,5,5);
        FIFOMMnew.Transaction_type__c='Rework';
        FIFOMMnew.Key__c='808080201555True';
        fiforecordsMM.add(FIFOMMnew);
        
        FIFO_Report__c FIFOMM1 = new FIFO_Report__c();
        FIFOMM1.FIFO_Segment__c='MM';
        FIFOMM1.Control__c=808088;
        FIFOMM1.Effective_Date__c=date.newinstance(2015,1,3);
        FIFOMM1.Plan_Setup_Completed__c= date.newinstance(2015,2,2);
        FIFOMM1.Transaction_Type__c = 'Rework';
        FIFOMM1.Key__c='808080201515True'; 
        fiforecordsMM.add(FIFOMM1);
        
        FIFO_Report__c FIFOMM2 = new FIFO_Report__c();
        FIFOMM2.FIFO_Segment__c='MM';
        FIFOMM2.Control__c=808088;
        FIFOMM2.Effective_Date__c=date.newinstance(2015,1,3);
        FIFOMM2.Plan_Setup_Completed__c= date.newinstance(2015,9,9);
        FIFOMM2.Escalation__c = true;
        FIFOMM2.Key__c='808080201519True';
        fiforecordsMM.add(FIFOMM2);
        
        /* Inserting the FIFO report records list */
        if(fiforecordsMM.size() > 0){   
            insert fiforecordsMM; 
        }
        
        //Creating CBON records for the CRD, FIFO Report and cases created previously
        CRDBuildOrder__c cbonRecord2 = new CRDBuildOrder__c();
        cbonRecord2.Build__c = true;
        cbonRecord2.crd__c = crd.id;
        cbonRecord2.Case__c=externalcase.id;          
        cbonRecord2.Control__c = 808088;
        cbonRecord2.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecord2.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord2;
        
        CRDBuildOrder__c cbonRecordnewgen = new CRDBuildOrder__c();
        cbonRecordnewgen.Build__c = true;
        cbonRecordnewgen.crd__c = crd2.id;
        cbonRecordnewgen.falloutcase__c= falloutcasenew.id;
        cbonRecordnewgen.success_case__c=successcase.id;
        cbonRecordnewgen.Case__c=externalcase2.id;           
        cbonRecordnewgen.Control__c = 808082;
        cbonRecordnewgen.Effective_date__c = date.newinstance(2015,1,3);
        cbonRecordnewgen.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecordnewgen;
        
        CRDBuildOrder__c cbonRecord6 = new CRDBuildOrder__c();
        cbonRecord6.Build__c = true;
        cbonRecord6.crd__c = crd3.id;
        cbonRecord6.falloutcase__c= falloutcasenew1.id;
        cbonRecordnewgen.success_case__c=successcase1.id;
        cbonRecord6.Case__c=externalcase1.id;          
        cbonRecord6.Control__c = 808081;
        cbonRecord6.Effective_date__c = date.newinstance(2015,1,2);
        cbonRecord6.PERS_timestamp__c = date.newinstance(2015,5,5);
        insert cbonRecord6;
        
        Test.startTest();
        //Calling the FIFO Batch
        BAC_FIFOTagging FIFOTagBatch = new BAC_FIFOTagging();
        ID batchprocessid = database.executeBatch(FIFOTagBatch);
        Test.stopTest();
        
        /*  Getting the values of the FIFO Tag set for the external,fallout and success cases */
        string externaltag1 = [select id,fifo_tag__c from case where id =: externalcase1.id].fifo_tag__c;
        string externaltag2 = [select id,fifo_tag__c from case where id =: externalcase2.id].fifo_tag__c;
        string fallouttag = [select id,fifo_tag__c from case where id =: falloutcasenew.id].fifo_tag__c;
        string fallouttag1 = [select id,fifo_tag__c from case where id =: falloutcasenew1.id].fifo_tag__c; 
        string externaltag = [select id,fifo_tag__c from case where id =: externalcase.id].fifo_tag__c;
        string successtag = [select id,fifo_tag__c from case where id =: successcase.id].fifo_tag__c;
        string successtag1 = [select id,fifo_tag__c from case where id =: successcase1.id].fifo_tag__c;    
        
        /* Checking the values for the FIFO Tag that is set on the cases */    
        system.assert((( fallouttag=='General')&&(fallouttag1=='Escalated')&&(externaltag2=='Escalated')&&(externaltag1=='Escalated')),'Wrong FIFO Tagging');
        system.assert(((externaltag=='Rework')&&(successtag =='General')&&(successtag1=='Rework')), 'Wrong FIFO Tagging');
    }
    
    
    /*
        Method: TEST_BAC_FIFOTaggingNAPL()
        Description: Method to test the tagging of the cases when there are Middle Market matching FIFO record for the CBON
    */
    static testMethod void TEST_BAC_FIFOTaggingNAPL(){
    
        Org_Trigger_Configurations__c triggerConfigSetting = new Org_Trigger_Configurations__c();
        triggerConfigSetting.Name = CUSTOMSETTINGNAME;
        triggerConfigSetting.TRG_FIFOControlParsing__c = True;
        
        Insert triggerConfigSetting ;
    
        List<case> casetocreateNAPL = new list<case>();
        List<fifo_report__c> fiforecordsNAPL = new list<fifo_report__c>();
        
        //CRD with different values for Segment are created
        CRD__c crd = new crd__c();
        crd.National__c = 'National';
        insert crd;
        
        CRD__c crd5 = new crd__c();
        crd5.National__c = 'Government/Labor';
        insert crd5;
        
        //Creating fallout case
        case falloutcasenewNAPL = new case();
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        falloutcasenewNAPL.RecordTypeId = rtNAPL.Id;
        falloutcasenewNAPL.status='New';
        falloutcasenewNAPL.FIFO_tag__c=null;
        falloutcasenewNAPL.FIFO_record_name__c=null;
        falloutcasenewNAPL.reason='Internal CRD';
        casetocreateNAPL.add(falloutcasenewNAPL);
        
        //Creating fallout case with an existing FIFO Tag
        case falloutcasenewNAPL1 = new case();
        falloutcasenewNAPL1.RecordTypeId = rtNAPL.Id;
        falloutcasenewNAPL1.status='New';
        falloutcasenewNAPL1.FIFO_tag__c='Escalated';
        falloutcasenewNAPL1.FIFO_record_name__c= 'FR-000999';
        falloutcasenewNAPL1.reason='Internal CRD';
        casetocreateNAPL.add(falloutcasenewNAPL1);
        
        //Creating success case record
        case successcase = new case();
        successcase.RecordTypeId = rtNAPL.Id;
        successcase.status='New';
        successcase.FIFO_tag__c=null;
        successcase.Transaction_Type__c=null;
        successcase.FIFO_record_name__c= null;
        successcase.reason='Internal CRD';
        casetocreateNAPL.add(successcase);
        
        //Creating external case
        case externalcaseNAPL = new case();
        RecordType rtNAPL1= [Select Id,Name from RecordType where DeveloperName='External_CRD_GMF' and SobjectType='Case' LIMIT 1];
        externalcaseNAPL.RecordTypeId = rtNAPL1.Id;
        externalcaseNAPL.status='New';
        externalcaseNAPL.FIFO_tag__c=null;
        externalcaseNAPL.FIFO_record_name__c=null;
        casetocreateNAPL.add(externalcaseNAPL);
        
        case externalcaseNAPL1 = new case();
        externalcaseNAPL1.RecordTypeId = rtNAPL1.Id;
        externalcaseNAPL1.status='New';
        externalcaseNAPL1.FIFO_tag__c=null;
        externalcaseNAPL1.FIFO_record_name__c=null;
        casetocreateNAPL.add(externalcaseNAPL1);
        
        /* Inserting the cases list */
        if(casetocreateNAPL.size() > 0){   
            insert casetocreateNAPL; 
        }
        
        //Creating FIFO records with different FIFO Tag, Control and Effective Date
        FIFO_Report__c FIFONAPL = new FIFO_Report__c();
        FIFONAPL.FIFO_Segment__c='NAPL';
        FIFONAPL.Control__c=808081;
        FIFONAPL.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL.Transaction_Type__c = 'Rx Rework';
        FIFONAPL.Plan_Setup_Completed__c=null;
        FIFONAPL.Key__c='808081201513True';
        fiforecordsNAPL.add(FIFONAPL);
        
        FIFO_Report__c FIFONAPL1 = new FIFO_Report__c();
        FIFONAPL1.FIFO_Segment__c='NAPL';
        FIFONAPL1.Control__c=808081;
        FIFONAPL1.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL1.Transaction_Type__c = 'Renew';
        FIFONAPL1.Plan_Setup_Completed__c=null;
        FIFONAPL1.Key__c='808081201514True';
        fiforecordsNAPL.add(FIFONAPL1);
        
        FIFO_Report__c FIFONAPL2 = new FIFO_Report__c();
        FIFONAPL2.FIFO_Segment__c='NAPL';
        FIFONAPL2.Control__c=808081;
        FIFONAPL2.Effective_Date__c=date.newinstance(2015,1,2);
        FIFONAPL2.Escalation__c=true;
        FIFONAPL2.Plan_Setup_Completed__c=date.newinstance(2015,2,5);
        FIFONAPL2.Key__c='808081201515True';
        fiforecordsNAPL.add(FIFONAPL2);
        
        /* Inserting the FIFO report records list */
        if(fiforecordsNAPL.size() > 0){   
            insert fiforecordsNAPL; 
        }
        
        //Creating CBON records for the CRD, FIFO Report and cases created previously
        CRDBuildOrder__c cbonRecordnew = new CRDBuildOrder__c();
        cbonRecordnew.Build__c = true;
        cbonRecordnew.crd__c = crd.id;
        cbonRecordnew.falloutcase__c= falloutcasenewNAPL.id;
        cbonRecordnew.success_case__c=successcase.id;
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
        
        Test.startTest();
        //Calling the FIFO Batch
        BAC_FIFOTagging FIFOTagBatch = new BAC_FIFOTagging();
        ID batchprocessid = database.executeBatch(FIFOTagBatch);
        Test.stopTest();
        
        /*  Getting the values of the FIFO Tag set for the external,fallout and success cases */
        string externaltag = [select id,fifo_tag__c from case where id =: externalcaseNAPL.id].fifo_tag__c;
        string fallouttag = [select id,fifo_tag__c from case where id =: falloutcasenewNAPL.id].fifo_tag__c;
        string fallouttag1 = [select id,fifo_tag__c from case where id =: falloutcasenewNAPL1.id].fifo_tag__c; 
        string externaltag1 = [select id,fifo_tag__c from case where id =: externalcaseNAPL1.id].fifo_tag__c;
        string successtag = [select id,fifo_tag__c from case where id =: successcase.id].fifo_tag__c;
        
        /* Checking the values for the FIFO Tag that is set on the cases */
        system.assert(((fallouttag=='Rework')&&(fallouttag1=='Escalated')&&(externaltag1=='Escalated')&&(externaltag=='Rework')&&(successtag=='Rework')) , 'Wrong FIFO Tagging');
    }
}