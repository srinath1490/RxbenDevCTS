@isTest (SeeAllData=true)
private class TestGMF_XML_CRD_Controller {
    static testMethod void testXMLGeneration() {
        Map < String, Id > copayRT = new Map < String, Id > ();
        for (RecordType rt: [Select Id, Name from RecordType where sobjecttype = 'Copay_Tier__c'
        and isActive = true]) {
            copayRT.put(rt.Name, rt.Id);
        }

        Account a = new Account();
        a.Name = 'TestRecord';
        a.PS_State__c = 'AN';
        a.APM_MandatoryMOD__c = 'NO';
        a.APM_MandatoryASRx__c = 'No';
        a.APM_Reference__c = 'No';
        a.APM_ServiceIntensity__c = '3';
        insert a;

        Test.startTest();
       //commented by Nitish request No 4882         
       /* CRD_Pricing__c p = new CRD_Pricing__c();
        insert p;
       */
        GC_UtilityClassTestData testDataobj = new GC_UtilityClassTestData();
        Clinical_Program__c clinicalProg = new Clinical_Program__c();
        clinicalProg = testDataobj.createClinicalPrograme('Concurrent DUR');
        clinicalProg.Standard__c = true;
        insert clinicalProg;
        

        CRD__c testCrd = new CRD__c();
        testCrd.Plan_Type_Mail__c = true;
        testCrd.Plan_Type_Paper__c = true;
        testCrd.Account__c=a.id;
        testCrd.Plan_Type_Retail__c = true;
        testCrd.Plan_Type_Specialty__c = true;
        testCrd.CRD_Automated__c=true;
       // testCrd.CRD_Pricing__c = p.Id;---> //commented by Nitish request No 4882         
        testCrd.Concurrent_DUR_ID__c = clinicalProg.id;
        insert testCrd;

        /*Save_a_copay_junction__c SaveACopayJunction = new Save_a_copay_junction__c ();
        SaveACopayJunction.CRD_ID__c = testCrd.Id;
        SaveACopayJunction.Save_A_Copay_Drug_Class__c = 'test';
        insert SaveACopayJunction ; */
        
                
        Copay_Tier__c mailTier = new Copay_Tier__c();
        mailTier.CRD__c = testCrd.id;
        mailTier.Stepped_Copay__c = true;
        mailTier.recordtypeId = copayRT.get('Mail');
        insert mailTier;
        SteppedCopay__c steppedCopay1 = new SteppedCopay__c();
        steppedCopay1.Copay_Tier__c = mailTier.id;
        insert steppedCopay1;

        Copay_Tier__c paperTier = new Copay_Tier__c();
        paperTier.CRD__c = testCrd.id;
        paperTier.Stepped_Copay__c = true;
        paperTier.recordtypeId = copayRT.get('Paper');
        insert paperTier;
        SteppedCopay__c steppedCopay2 = new SteppedCopay__c();
        steppedCopay2.Copay_Tier__c = paperTier.id;
        insert steppedCopay2;

        Copay_Tier__c retailTier = new Copay_Tier__c();
        retailTier.CRD__c = testCrd.id;
        retailTier.Stepped_Copay__c = true;
        retailTier.recordtypeId = copayRT.get('Retail');
        insert retailTier;
        SteppedCopay__c steppedCopay3 = new SteppedCopay__c();
        steppedCopay3.Copay_Tier__c = retailTier.id;
        insert steppedCopay3;

        Copay_Tier__c specialityTier = new Copay_Tier__c();
        specialityTier.CRD__c = testCrd.id;
        specialityTier.Stepped_Copay__c = true;
        specialityTier.recordtypeId = copayRT.get('Specialty');
        insert specialityTier;
        SteppedCopay__c steppedCopay4 = new SteppedCopay__c();
        steppedCopay4.Copay_Tier__c = specialityTier.id;
        insert steppedCopay4;

        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c druglist = testdata.createDrugList();
        RecordType rt1 = [Select Id, Name from RecordType where sobjecttype = 'Drug_List__c'
        and Name = 'Drug List'
        limit 1];
        druglist.recordTypeid = rt1.id;
        druglist.Description__c='Test';
        druglist.CVS_Caremark_Drug_List_ID__c='CVS Caremark';
        insert druglist;

        Drug_Group__c druggroup = testdata.createDrugGroup();
        RecordType rectype1 = [Select Id, Name from RecordType where sobjecttype = 'Drug_Group__c' and Name = 'Step Therapy' limit 1];
        druggroup.recordTypeid = rectype1.id;
        insert druggroup;
        
        CRD_Standard_Safety_Edit_Junction__c Safetyeditjuncrec = new CRD_Standard_Safety_Edit_Junction__c();
        Safetyeditjuncrec.CRDID__c=testCrd.id;
        Safetyeditjuncrec.Select__c = TRUE;
        Safetyeditjuncrec.Drug_Group__c=druggroup.id;
        Safetyeditjuncrec.Drug_List__c=druglist.id;
        insert Safetyeditjuncrec;
        
        Drug_List_Junction__c objdljunc= new Drug_List_Junction__c();
        objdljunc.Drug_List__c=druglist.id;
        objdljunc.Parent_Drug_Group__c=druggroup.id;
        objdljunc.Inactive__c=false;
        insert objdljunc;

        Drug_Specific_Copay__c drug = new Drug_Specific_Copay__c();
        Recordtype rt = [select id from RecordType where SobjectType = 'Drug_Specific_Copay__c'
        and developername = 'Retail'];
        drug.recordTypeId = rt.Id;
        drug.CRD_ID__c = testCrd.Id;
        drug.Drug_Group__c = druggroup.Id;
        drug.Drug_List__c = druglist.Id;
        drug.Stepped_Copay__c = true;
        insert drug;

        Drug_Specific_Stepped_Copay__c drugsteppedcopay = new Drug_Specific_Stepped_Copay__c();
        drugsteppedcopay.Dollar_Amount__c = 100;
        drugsteppedcopay.Number_of_Steps__c = '1';
        drugsteppedcopay.Drug_Specific_Copay_ID__c = drug.Id;
        drugsteppedcopay.Beginning_Range__c = 1;
        drugsteppedcopay.End_Range__c = 2;
        drugsteppedcopay.Percent__c = 100;
        drugsteppedcopay.Copay_Calculation__c = '1. Lower of the Copay or precentage';
        insert drugsteppedcopay ;

        Network_Junction__c nj = new Network_Junction__c();
        nj.CRD_ID__c = testCrd.Id;
        insert nj;
        
         Test.stopTest();

        RecordType[] drugcoveragert = [Select Id, Name from RecordType where sobjecttype = 'Drug_Coverage__c'];
        Drug_Coverage__c[] drugCList = new List < Drug_Coverage__c > ();
        Drug_Coverage__c drugCoverateItem = new Drug_Coverage__c();
        for (RecordType dcrt: drugcoveragert) {
            drugCoverateItem = new Drug_Coverage__c();
            drugCoverateItem.CRD_ID__c = testCrd.id;
            drugCoverateItem.RecordTypeId = dcrt.id;
            drugCoverateItem.Do_you_have_Choose_Generic__c = 'Yes';
            drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c = 'Not elected';
            drugCoverateItem.Do_you_have_Specialty__c ='yes';
            drugCoverateItem.Aetna_Specialty_Care_Rx__c='Applies-Expanded List w/ Fertility';
            drugCoverateItem.Force_to_Specialty__c='No';
            drugCList.add(drugCoverateItem);
        }
        insert drugCList;
        /* Commented by Sushant Req 04937
        CVS_Web_Access_Users__c webaccessUser = new CVS_Web_Access_Users__c();
        webaccessUser.Web_Acces_User_Name__c = 'test';
        webaccessUser.Last_4_digits_of_SSN__c = '1234';
        webaccessUser.RxNav__c = 'test';
        webaccessUser.Client_Access__c = 'test';
        webaccessUser.Client_Acces_Security__c = 'test';
        webaccessUser.CRD_ID__c = testCrd.id;
        insert webaccessUSer;
        */        

        CRD_PriorAuth_Junction__c newobj = new CRD_PriorAuth_Junction__c();
        newobj.CRD_ID__c = testCrd.Id;
        insert newobj;

        Waiver_Of_Deductible__c objWOD = new Waiver_Of_Deductible__c();
        objWOD.CRD_ID__c = testCRD.id;
        insert objWOD;
        
        AHA_Junction__c objAHA = new AHA_Junction__c();
        objAHA.CRD_ID__c = testCRD.Id;
        objAHA.selected__c = true;
        insert objAHA;
        
        RecordType rectype= [Select Id,Name from RecordType where sobjecttype='Clinical_Program_Group__c' and name='Save-A-Copay'];  
        Clinical_Program_Group__c objCPG = new Clinical_Program_Group__c();
        objCPG.RecordTypeId=rectype.id;
        objCPG.Clinical_Program_Group_Description__c = 'test';
        objCPG.Clinical_Program_Group_Name__c = 'testing';
        objCPG.Effective_Date__c = system.today();
        objCPG.Termination_Date__c = system.today()+2;
        objCPG.LastSent__c=system.today()-2;
        insert objCPG;
        
        RxCheck_Junction__c objRXCJ = new RxCheck_Junction__c();
        objRXCJ.crd__c = testCRD.Id;
        insert objRXCJ;
        
        Clinical_Program_Group_Junction__c objCPGJ = new Clinical_Program_Group_Junction__c();
        objCPGJ.Record_Type__c = 'RxCheck';
        objCPGJ.Clinical_Program_Group_ID__c = objCPG.id;
        objCPGJ.Clinical_Program_Group_Name__c='Testing';
        objCPGJ.CRD_ID__c = testCRD.Id;
        objCPGJ.Selected__c = true;
        insert objCPGJ;
        
        Clinical_Program_Group_Junction__c objCPGJ1 = new Clinical_Program_Group_Junction__c();
        objCPGJ1.Record_Type__c = 'Prescription Savings Program';
        objCPGJ1.Clinical_Program_Group_ID__c = objCPG.id;
        objCPGJ1.Clinical_Program_Group_Name__c='Testing';
        objCPGJ1.CRD_ID__c = testCRD.Id;
        objCPGJ1.Selected__c = true;
        insert objCPGJ1;
        
        Clinical_Program_Group_Junction__c objCPGJ2 = new Clinical_Program_Group_Junction__c();
        objCPGJ2.Record_Type__c = 'Save-A-Copay';
        objCPGJ2.Clinical_Program_Group_ID__c = objCPG.id;
        objCPGJ2.Clinical_Program_Group_Name__c='Testing';
        objCPGJ2.CRD_ID__c = testCRD.Id;
        objCPGJ2.Selected__c = true;
        insert objCPGJ2;
        
        Clinical_Program__c objcprog = new Clinical_Program__c();
        objcprog.RecordTypeId= ([Select Id from RecordType where sobjecttype='Clinical_Program__c' and name='RxCheck'].id);  
        objcprog.Standard__c = true;
        objcprog.Description__c='Testing it out';
        objcprog.Clinical_Programs_Name__c='Testing it through test class';
        objcprog.Letter_Description__c='Test again';
        objcprog.SAC_Campaign_ID__c='Test it out';
        objcprog.of_months_for_Copay_Waiver__c=12;
        objcprog.CVS_Caremark_Drug_List_ID__c='CVS Marker';
        insert objcprog;
        
        Clinical_Program__c objcprog1 = new Clinical_Program__c();
        objcprog1.RecordTypeId= ([Select Id from RecordType where sobjecttype='Clinical_Program__c' and name='Save-A-Copay'].id);  
        objcprog1.Standard__c = true;
        objcprog1.Description__c='Testing it out';
        objcprog1.Clinical_Programs_Name__c='Testing it through test class';
        objcprog1.Letter_Description__c='Test again';
        objcprog1.SAC_Campaign_ID__c='Test it out';
        objcprog1.of_months_for_Copay_Waiver__c=12;
        objcprog1.CVS_Caremark_Drug_List_ID__c='CVS Marker';
        insert objcprog1;
        
        Save_a_copay_junction__c SaveACopayJunction = new Save_a_copay_junction__c ();
        SaveACopayJunction.CRD_ID__c = testCrd.Id;
        SaveACopayJunction.Save_A_Copay_Drug_Class__c = 'test';
        SaveACopayJunction.Save_A_Copay_ID__c= objcprog1.id;
        SaveACopayJunction.Selected__c = true;
        insert SaveACopayJunction ;
        
        RxCheck_Junction__c objrxcjunc = new RxCheck_Junction__c();
        objrxcjunc.Selected__c=true;
        objrxcjunc.RxCheck__c=objcprog.id;
        objrxcjunc.CRD__c=testCRD.Id;
        insert objrxcjunc;
        
        Accumulations__c acc = new Accumulations__c();
        RecordType accrt = [Select Id, Name from RecordType where sobjecttype = 'Accumulations__c'
        limit 1];
        acc.RecordTypeId = accrt.id;
        acc.CRD_ID__c = testCrd.Id;
        
        
        acc.Carry_Balance_when_member_moves__c = 'yes';
        acc.Deductible_Amount__c = 100.0;
        acc.Deuductible_Accumulation_from_4th_Qtr__c = 'Yes';
        acc.Deductible_Period__c = 'Month';
        acc.Are_there_any_drug_specific_deductibles__c = true;
        insert acc;
        
        Map < String, Id > accumulationRT = new Map < String, Id > ();
        for (RecordType rtAccuChangeCopay: [select id,Name from RecordType where SobjectType = 'Accumulation_Change_Copay__c'
        and isActive = true]) {
            accumulationRT.put(rtAccuChangeCopay.Name, rtAccuChangeCopay.Id);
        }
        
        Accumulation_Change_Copay__c objAccumulationChangeCopay =new Accumulation_Change_Copay__c();
        objAccumulationChangeCopay.Accumulation_ID__c=acc.Id;
        objAccumulationChangeCopay.Percent__c=10;
        objAccumulationChangeCopay.RecordTypeId=accumulationRT.get('MAB');
        insert objAccumulationChangeCopay;
        
        Accumulation_Change_Copay_Stepped__c objAccumulationChangeCopayStepped=new Accumulation_Change_Copay_Stepped__c();
        objAccumulationChangeCopayStepped.Accumulation_Change_Copay_ID__c=objAccumulationChangeCopay.Id;
        objAccumulationChangeCopayStepped.Dollar_Amount__c=100;
        insert objAccumulationChangeCopayStepped;
        
        Accumulation_Change_Copay__c objAccumulationChangeCopayMOOP =new Accumulation_Change_Copay__c();
        objAccumulationChangeCopayMOOP.Accumulation_ID__c=acc.Id;
        objAccumulationChangeCopayMOOP.Percent__c=10;
        objAccumulationChangeCopayMOOP.RecordTypeId=accumulationRT.get('MOOP');
        insert objAccumulationChangeCopayMOOP;
        
        Accumulation_Change_Copay_Stepped__c objAccumulationChangeCopaySteppedMOOP=new Accumulation_Change_Copay_Stepped__c();
        objAccumulationChangeCopaySteppedMOOP.Accumulation_Change_Copay_ID__c=objAccumulationChangeCopayMOOP.Id;
        objAccumulationChangeCopaySteppedMOOP.Dollar_Amount__c=100;
        insert objAccumulationChangeCopaySteppedMOOP;
        
        
        
        DC_Drug_List_Group__c DCDrugListGroup = new DC_Drug_List_Group__c();
        DCDrugListGroup.Drug_Group__c=druggroup.id;
        //DCDrugListGroup.Inclusion_Exclusion_Drug_Class__c = 'CRTS';
        DCDrugListGroup.Related_Drug_Coverage__c = drugCList[0].ID;
        insert DCDrugListGroup;
        
        /*
        DC_Copay__c objDCCopay=new DC_Copay__c();
        objDCCopay.DC_Drug_List_Group_ID__c=DCDrugListGroup.Id;
        objDCCopay.Dollar_Amount__c=10;
        insert objDCCopay;
        */
               
               
        AccumulationSpecificDrug__c accumDrug = new AccumulationSpecificDrug__c();
        accumDrug.Accumulations_ID__c = acc.Id;
        insert accumDrug;
        //Added Feb 1, 2012
        DAW_Specific_Copay__c dawrecord = new DAW_Specific_Copay__c();
        dawrecord.CRD_ID__c = testCrd.Id;
        insert dawrecord;
        DAW_Specific_Stepped_Copay__c dawStepped = new DAW_Specific_Stepped_Copay__c();
        dawStepped.DAW_Specific_Copay_ID__c = dawrecord.Id;
        insert dawStepped;
        Coordination_of_Benefits_Crosswalk__c cob = new Coordination_of_Benefits_Crosswalk__c();
        cob.Does_client_want_to_coordinate_benefits__c = 'Yes';
        cob.Line_Text__c = 'TestData';
        cob.MOB_or_COB__c = 'MOB';
        cob.Options__c = 'Y';
        insert cob;
        AHA_Junction__c AHA = new AHA_Junction__c();
        AHA.CRD_ID__c = testCrd.ID;
        Drug_List__c DLID = new Drug_List__c();
        DLID = [select id,name from Drug_List__c Limit 1 ];
        AHA.Drug_List_ID__c = DLID.id;
        insert AHA;
        Aetna_RxStep_Junction__c ARx = new Aetna_RxStep_Junction__c();
        ARx.CRD_ID__c = testCrd.ID;
        ARx.Selected__c = True;
        Drug_List__c DID = new Drug_List__c();
        DID = [select id,name from Drug_List__c Limit 1 ];
        ARx.Drug_List__c= DID.id;
        insert ARx;
        PSP_Junction__c PSP = new PSP_Junction__c();
        PSP.CRD_ID__c = testCrd.ID;
        PSP.Prescription_Savings_Program_Drug_Class__c = 'TestData';
        PSP.PSP_ID__c = clinicalProg.ID;
        PSP.selected__c = True;
        insert PSP;
        CRD_Step_Therapy_Junction__c CRDSTjunction = new CRD_Step_Therapy_Junction__c ();
        CRDSTjunction.CRD_ID__c = testCrd.ID;
        CRDSTjunction.IsAutoPopulated__c = True;
        Drug_List__c DrugID = new Drug_List__c();
        DrugID = [select id,name from Drug_List__c Limit 1 ];
        CRDSTjunction.Step_Therapy_DrugList_Class__c = DrugID.ID;
        insert CRDSTjunction ;
        CRD_Quantity_Limit_Junction__c QLJunction = new CRD_Quantity_Limit_Junction__c();
        QLJunction.CRD_ID__c = testCrd.ID;
        QLJunction.IsAutoPopulated__c = True;
        Drug_List__c QLDID = new Drug_List__c();
        QLDID = [select id,name from Drug_List__c Limit 1 ];
        QLJunction.QL_Class__c = QLDID.ID;
        insert QLJunction;
        
        CRD_NPL_Junction__c NPL = new CRD_NPL_Junction__c();
        NPL.CRD_ID__c = testCrd.ID;
        Drug_List__c NPLDrugID = new Drug_List__c();
        NPLDrugID = [select id,name from Drug_List__c Limit 1 ];
        NPL.Drug_List__c = NPLDrugID.id;
        NPL.IsStandard__c=true;
        insert NPL;
        //end Feb 1,2012
        
        CRD_NPL_Junction__c NPL1 = new CRD_NPL_Junction__c();
        NPL1.CRD_ID__c = testCrd.ID;
        Drug_List__c NPLDrugID1 = new Drug_List__c();
        NPLDrugID1 = [select id,name from Drug_List__c Limit 1 ];
        NPL1.Drug_List__c = NPLDrugID1.id;
        insert NPL1;
        
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.Carrier_ID__c='Test';
        fcg.Account_Name__c=a.id;
        fcg.CAG_Group_ID__c='Testing it';
        fcg.Contract_State__c='LA';
        insert fcg;
        
        CSAP_CGLP_Junction__c objcsapcglpjunc = new CSAP_CGLP_Junction__c();
        objcsapcglpjunc.CRD__c= testCrd.ID;
        objcsapcglpjunc.RecordTypeId= ([Select Id from RecordType where sobjecttype='CSAP_CGLP_Junction__c' and name='CRD to Full CG'].id); 
        objcsapcglpjunc.Full_Control_Group__c=fcg.id;
        insert objcsapcglpjunc ;
        
        Retail_Vaccine_Program__c rvpRecord = new Retail_Vaccine_Program__c();
        rvpRecord.crd__c = testCRD.ID;
        rvpRecord.CoPay_Calculation__c = 'test';
        rvpRecord.Dollar_Amount__c = 19;
        rvpRecord.Vaccine_Network__c = 'Broad Network';
        rvpRecord.Waiver_of_Deductible__c = 'Yes';
        insert rvpRecord;
        
        
        Drug_List_Criteria__c objdlc = new Drug_List_Criteria__c();
        objdlc.Drug_List__c=druglist.id;
        objdlc.Effective__c=system.today();
        objdlc.Term__c=system.today()+3;
        insert objdlc;
        
        ApexPages.StandardController cpsc = new ApexPages.StandardController(testCrd);
        GMF_XML_CRD_controller cprc = new GMF_XML_CRD_controller(cpsc);
        cprc.writeDrugListCriteria(objdlc);
        cprc.generateXML();
        
}
}