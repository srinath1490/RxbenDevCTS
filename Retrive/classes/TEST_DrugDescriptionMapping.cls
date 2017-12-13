/*Purpose: Apex Test Class for VFO_DrugDescriptionMapping.
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ               7/12/2011       Apex Test Class for VFP_DrugDescriptionMapping
   1.1 -    ANUJ               6/01/2012       New methods to cover other History trekking triggers.
======================================================================== */

@isTest
private class TEST_DrugDescriptionMapping{
    
   static testmethod void testDrugDescriptionMapping() {
       test.starttest();
       // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        GC_UtilityClassTestData.isTestCall=true;
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        List<Schema.RecordTypeInfo> criteriaRtInfo = Drug_List_Criteria__c.sObjectType.getDescribe().getRecordTypeInfos();
        List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
        List<Schema.RecordTypeInfo> formsRtInfo = Forms__c.sObjectType.getDescribe().getRecordTypeInfos();
      //  List<Step_Therapy_Restricted_Drug__c> steptherapyList = new List<Step_Therapy_Restricted_Drug__c>();
        List<Step_Therapy_PreRequisite_Drug__c> PreRequisiteList = new List<Step_Therapy_PreRequisite_Drug__c>();
        List<Formulary_List_Entry__c> formularyEntryList = new List<Formulary_List_Entry__c>();
        List<Drug_List_Criteria__c> drugCriteriaList = new List<Drug_List_Criteria__c>();
        List<Forms__c> criteriaformList = new List<Forms__c>();
        Id formsRtid;
        Id formsRtid1;
        
        for(Schema.Recordtypeinfo thisInfo : formsRtInfo ){
            if(thisInfo.Name == 'Prior Authorization Criteria Form'){
                formsRtid= thisInfo.getRecordTypeId();
                
            }else if(thisInfo.Name == 'Formulary List Entry Criteria Form'){
                formsRtid1 = thisInfo.getRecordTypeId();
            }
        }
        Id DrugListid;
        for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Prior Authorization'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
        Id priorAuthid;
        for(Schema.Recordtypeinfo thisInfo : criteriaRtInfo){
            if(thisInfo.Name == 'Prior Authorization'){
                priorAuthid= thisInfo.getRecordTypeId();
            }
        }
        
        Drug_List__c testDrugList = testdata.createDrugList();
        testDrugList.RecordTypeId=DrugListid;
        testDrugList.LastSent__c = system.now();
        insert testDrugList;
        
        Drug__c testDrug = testdata.createDrug();
        insert testDrug;
        
        TCRF_File__c testTCRF = testdata.TCRF();
        
        Forms__c criteriaForm = testdata.CriteriaForm();
        criteriaForm.recordTypeId= formsRtid;   
        system.debug('***formsRtid***'+criteriaForm.recordTypeId);
        criteriaformList.add(criteriaForm);
        
        Forms__c criteriaForm1 = testdata.CriteriaForm();
        criteriaForm1.recordTypeId= formsRtid1;   
        criteriaformList.add(criteriaForm1);       
 
        Forms__c criteriaForm2 = testdata.CriteriaForm();
        criteriaForm2.recordTypeId= formsRtid1;   
        criteriaformList.add(criteriaForm2); 
        
        Forms__c criteriaForm3 = testdata.CriteriaForm();
        criteriaForm3.recordTypeId= formsRtid;   
        criteriaformList.add(criteriaForm3);       
        insert criteriaformList;
        
        
        
        M25VAL__c M25VAL1 = testdata.M25VAL();
        M25VAL1.Field_Identifier__c='A068';
        M25VAL1.Field_Value__c= '1234';
        M25VAL1.M25VAL_ID__c='000';

        insert M25VAL1;

        M25VAL__c M25VAL2 = testdata.M25VAL();
        M25VAL2.Field_Identifier__c='A039';
        M25VAL2.Field_Value__c= '1234';
        M25VAL2.M25VAL_ID__c='001';
        insert M25VAL2;
        
        M25VAL__c M25VAL3 = testdata.M25VAL();
        M25VAL3.Field_Identifier__c='A040';
        M25VAL3.Field_Value__c= '1234';
        M25VAL3.M25VAL_ID__c='002';
        insert M25VAL3;

        M25VAL__c M25VAL4 = testdata.M25VAL();
        M25VAL4.Field_Identifier__c='L072';
        M25VAL4.Field_Value__c= '1234';
        M25VAL4.M25VAL_ID__c='003';
        insert M25VAL4; 

        M25VAL__c M25VAL5 = testdata.M25VAL();
        M25VAL5.Field_Identifier__c='A069';
        M25VAL5.Field_Value__c= '1234';
        M25VAL5.M25VAL_ID__c='004';
        insert M25VAL5;
                                
       /* Step_Therapy_Restricted_Drug__c  restrictedDrug1 = testdata.restrictedDrug();
        restrictedDrug1.NDC__c='12345*';
        restrictedDrug1.GPI__c='1234*';
        steptherapyList.add(restrictedDrug1);
        
        Step_Therapy_Restricted_Drug__c  restrictedDrug2 = testdata.restrictedDrug();
        restrictedDrug2.NDC__c=null;
        restrictedDrug2.GPI__c='1234*';
        steptherapyList.add(restrictedDrug2);
    
        Step_Therapy_Restricted_Drug__c  restrictedDrug3 = testdata.restrictedDrug();
        restrictedDrug3.NDC__c='123456789*';
        steptherapyList.add(restrictedDrug3);
        
        Step_Therapy_Restricted_Drug__c  restrictedDrug4 = testdata.restrictedDrug();
        restrictedDrug4.NDC__c='12345*';
        restrictedDrug4.GPI__c='123456789012*';
        steptherapyList.add(restrictedDrug4);
    
        Step_Therapy_Restricted_Drug__c  restrictedDrug5 = testdata.restrictedDrug();
        restrictedDrug5.NDC__c='12345*';
        restrictedDrug5.GPI__c='1234567890*';
        steptherapyList.add(restrictedDrug5);
    
        Step_Therapy_Restricted_Drug__c  restrictedDrug6 = testdata.restrictedDrug();
        restrictedDrug6.NDC__c='12345*';
        restrictedDrug6.GPI__c='12345678*';
        steptherapyList.add(restrictedDrug6);
    
        Step_Therapy_Restricted_Drug__c  restrictedDrug7 = testdata.restrictedDrug();
        restrictedDrug7.NDC__c='12345*';
        restrictedDrug7.GPI__c='123456*';
        steptherapyList.add(restrictedDrug7);
        insert steptherapyList;*/
        
        Option_Code__c newoptionCode =testdata.newoptionCode();
        insert newoptionCode;
        Formulary_List__c tempFormularyList = testdata.newFormularyList(newoptionCode.Id);
        insert tempFormularyList;
 
        
        Formulary_List_Entry__c testformularyEntry =  testdata.newFormularyListEntry(1,tempFormularyList.id);
        testformularyEntry.GPI__c = '1234*';
        testformularyEntry.NDC__c ='123456789*';
        testformularyEntry.Formulary_List__c = tempFormularyList.Id;
        formularyEntryList.add(testformularyEntry);

        Formulary_List_Entry__c testformularyEntry1 =  testdata.newFormularyListEntry(2,tempFormularyList.id);
        testformularyEntry1.GPI__c = '123456*';
        testformularyEntry1.NDC__c ='12345*';
        formularyEntryList.add(testformularyEntry1);

        Formulary_List_Entry__c testformularyEntry2 =  testdata.newFormularyListEntry(3,tempFormularyList.id);
        testformularyEntry2.GPI__c = '123456*';
        formularyEntryList.add(testformularyEntry2);

        insert formularyEntryList;
         
        
        /*Drug_List_Criteria__c drugListCriteria1 = testdata.newDrugListcriteria(testDrugList.id,1);
        drugListCriteria1.recordtypeId =priorAuthid;
        drugListCriteria1.Drug_Type_Code__c =system.Label.CL0000003;
        drugListCriteria1.Drug_Code_Value__c ='12345*';
        drugCriteriaList.add(drugListCriteria1);

        
        Drug_List_Criteria__c drugListCriteria2 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria2.recordtypeId =priorAuthid;
        drugListCriteria2.Drug_Type_Code__c =system.Label.CL0000004;
        drugListCriteria2.Drug_Code_Value__c ='12*';
        drugCriteriaList.add(drugListCriteria2);
        
        Drug_List_Criteria__c drugListCriteria3 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria3.recordtypeId =priorAuthid;
        drugListCriteria3.Drug_Type_Code__c ='Third Party Restriction';
        drugListCriteria3.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria3);
        
        Drug_List_Criteria__c drugListCriteria4 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria4.recordtypeId =priorAuthid;
        drugListCriteria4.Drug_Type_Code__c ='DEA Class Code';
        drugListCriteria4.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria4);
        
        Drug_List_Criteria__c drugListCriteria5 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria5.recordtypeId =priorAuthid;
        drugListCriteria5.Drug_Type_Code__c ='Dosage Form';
        drugListCriteria5.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria5);
        
        Drug_List_Criteria__c drugListCriteria6 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria6.recordtypeId =priorAuthid;
        drugListCriteria6.Drug_Type_Code__c ='Labeler Code';
        drugListCriteria6.Drug_Code_Value__c ='12';
        drugCriteriaList.add(drugListCriteria6);*/
        
        Drug_List_Criteria__c drugListCriteria7 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria7.recordtypeId =priorAuthid;
        drugListCriteria7.Drug_Type_Code__c ='AHFS Therapeutic Class Code';
        drugListCriteria7.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria7);
        
        /*Drug_List_Criteria__c drugListCriteria8 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria8.recordtypeId =priorAuthid;
        drugListCriteria8.Drug_Type_Code__c ='Repack Code';
        drugListCriteria8.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria8);*/
        
        Drug_List_Criteria__c drugListCriteria9 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria9.recordtypeId =priorAuthid;
        drugListCriteria9.Drug_Type_Code__c ='DESI Code';
        drugListCriteria9.Drug_Code_Value__c ='D';
        
        drugCriteriaList.add(drugListCriteria9);
          
        /*Drug_List_Criteria__c drugListCriteria10 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria10.recordtypeId =priorAuthid;
        drugListCriteria10.Drug_Type_Code__c ='Maintenance drug code';
        drugListCriteria10.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria10);
        
        Drug_List_Criteria__c drugListCriteria11 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria11.recordtypeId =priorAuthid;
        drugListCriteria11.Drug_Type_Code__c =system.Label.CL0000003;
        drugListCriteria11.Drug_Code_Value__c ='12345678901';
        drugCriteriaList.add(drugListCriteria11);
        
        Drug_List_Criteria__c drugListCriteria12 = testdata.newDrugListcriteria(testDrugList.id,3);
        drugListCriteria12.recordtypeId =priorAuthid;
        drugListCriteria12.Drug_Type_Code__c =system.Label.CL0000004;
        drugListCriteria12.NDC__c ='12345678909';
        drugListCriteria12.Drug_Code_Value__c ='12345678909876';
        drugCriteriaList.add(drugListCriteria12);

        Drug_List_Criteria__c drugListCriteria13 = testdata.newDrugListcriteria(testDrugList.id,4);
        drugListCriteria13.recordtypeId =priorAuthid;
        drugListCriteria13.Drug_Type_Code__c =system.Label.CL0000004;
        drugListCriteria13.Drug_Code_Value__c ='123456789098*';        
        drugCriteriaList.add(drugListCriteria13);
        
        Drug_List_Criteria__c drugListCriteria14 = testdata.newDrugListcriteria(testDrugList.id,5);
        drugListCriteria14.recordtypeId =priorAuthid;
        drugListCriteria14.Drug_Type_Code__c =system.Label.CL0000004;
        drugListCriteria14.Drug_Code_Value__c ='1234567890*';
        drugCriteriaList.add(drugListCriteria14);
        
        Drug_List_Criteria__c drugListCriteria15 = testdata.newDrugListcriteria(testDrugList.id,6);
        drugListCriteria15.recordtypeId =priorAuthid;
        drugListCriteria15.Drug_Type_Code__c =system.Label.CL0000004;
        drugListCriteria15.Drug_Code_Value__c ='12345678*';
        drugCriteriaList.add(drugListCriteria15); 
               
        Drug_List_Criteria__c drugListCriteria16 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria16.recordtypeId =priorAuthid;
        drugListCriteria16.Drug_Type_Code__c ='Rx/OTC';
        drugListCriteria16.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria16);

        Drug_List_Criteria__c drugListCriteria17 = testdata.newDrugListcriteria(testDrugList.id,2);
        drugListCriteria17.recordtypeId =priorAuthid;
        drugListCriteria17.Drug_Type_Code__c ='Route of Administration';
        drugListCriteria17.Drug_Code_Value__c ='1234';
        drugCriteriaList.add(drugListCriteria17); */   
                            
        insert drugCriteriaList;
        
         Step_Therapy_PreRequisite_Drug__c preRequisitedrug1 =testdata.preRequisite();
        preRequisitedrug1.NDC__c='12345*';
        preRequisitedrug1.GPI__c='1234*';
        preRequisitedrug1.Step_Therapy_Pre_Requisite_Drug_Name__c='test';
        preRequisitedrug1.Related_Drug_List_Criteria__c=drugListCriteria7.Id;
        
        PreRequisiteList.add(preRequisitedrug1);
        
        Step_Therapy_PreRequisite_Drug__c preRequisitedrug2 =testdata.preRequisite();
        preRequisitedrug2.NDC__c=Null;
        preRequisitedrug2.GPI__c='1234*';
        preRequisitedrug2.Step_Therapy_Pre_Requisite_Drug_Name__c='test1';
        PreRequisiteList.add(preRequisitedrug2);
        Insert PreRequisiteList;
        for(Drug_List_Criteria__c criteria:drugCriteriaList){
            criteria.Drug_Type_Code__c ='DESI Code';
        }
        update drugCriteriaList;
        for(Formulary_List_Entry__c formularyEntry:formularyEntryList){
            formularyEntry.NDC__c ='10000*';
        }
        update formularyEntryList; 
        for(Formulary_List_Entry__c formularyEntry:formularyEntryList){
            formularyEntry.NDC__c ='100000000*';
        }
        update formularyEntryList;
        for(Formulary_List_Entry__c formularyEntry:formularyEntryList){
            formularyEntry.NDC__c =Null;
        }
        update formularyEntryList;
        //object removed(Anuj :31/01/2012)
      /*  for(Step_Therapy_Restricted_Drug__c restrictedDrug:steptherapyList){
            restrictedDrug.NDC__c ='10000*';
        }
        update steptherapyList;
        for(Step_Therapy_Restricted_Drug__c restrictedDrug:steptherapyList){
            restrictedDrug.NDC__c ='100000000*';
        }
        update steptherapyList;
        for(Step_Therapy_Restricted_Drug__c restrictedDrug:steptherapyList){
            restrictedDrug.NDC__c =Null;
        }
        update steptherapyList;*/
        for(Step_Therapy_PreRequisite_Drug__c PreRequisiteDrug:PreRequisiteList){
            PreRequisiteDrug.NDC__c ='10000*';
            
        }        
        update PreRequisiteList;
        for(Step_Therapy_PreRequisite_Drug__c PreRequisiteDrug:PreRequisiteList){
            PreRequisiteDrug.NDC__c =Null;
        }        
        update PreRequisiteList;
        for(Step_Therapy_PreRequisite_Drug__c PreRequisiteDrug:PreRequisiteList){
            PreRequisiteDrug.NDC__c ='100000000*';
            PreRequisiteDrug.Related_Drug_List_Criteria__c=drugListCriteria9.Id;
        }        
        update PreRequisiteList;  
        List<Schema.RecordTypeInfo> RtInfo =  Drug_Group__c.sObjectType.getDescribe().getRecordTypeInfos(); 
        Id drugrt0 = RtInfo[0].getRecordTypeId();
        Id drugrt1 = RtInfo[1].getRecordTypeId();
        Drug_Group__c testDrugGroup =    testdata.createDrugGroup()  ; 
        testDrugGroup.RecordTypeId   =drugrt0;    
        insert   testDrugGroup; 
        testDrugGroup.RecordTypeId   =drugrt1; 
        update  testDrugGroup;  
        
        Generic_Code_Conversion__c gcc = testdata.createGenericCode();
        insert gcc;
        Generic_Code_Conversion_Entry__c gcce = testdata.createGenericCodeEntry(gcc.Id);
        insert gcce;
        gcce.Termination_Date__c = system.today() +15;
        update gcce;
        Form_Junction__c formJunction = new Form_Junction__c();
        formJunction.Formulary_List_Entry_ID__c = testformularyEntry.Id;
        formJunction.Form_ID__c = criteriaForm1.Id;
        insert formJunction;
        formJunction.Form_ID__c = criteriaForm2.Id;
        update formJunction;
       // CRD_Pricing__c crdPricing = testdata.createCRDPricing();--> commented by Nitish Request No- 4882
       // insert crdPricing;
      //  update crdPricing;
        
        Codes_List__c  codeList =testdata.createCodeList();
        insert codeList;
        Codes__c testCode = testdata.createCode(codeList.Id);
        insert testCode;
        testCode.Professional__c='M0 Prescriber Consulted';
        update testCode;
        Denial_Letter_Junction__c testLetter = testdata.createdenialLetter(criteriaForm.Id,drugListCriteria7.Id);
        insert testLetter;
        testLetter.Denial_Letter_ID__c =  criteriaForm3.Id;
        update testLetter;
   test.stoptest();
   
   }
}