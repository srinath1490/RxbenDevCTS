/*Purpose: Apex Test Class to test Validation Suite
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            18Aug 2014       Apex Test class to test Validation Suite
======================================================================== */
@isTest(seeAllData = True)
private class TEST_CB_Validations{  
    
    

 static testMethod void TEST_CB_Validations(){  
     String dcMailRecordID;
     String dcRetailRecordID;
     String cTierMail;
     String cTierPaper;
     String cTierpaperOON;
     String cTierRetail;
     String cTierSpecialty;
     String cTierSpecialtyOON;
     String dSpecificMail;
     String dSpecificPaper;
     String dSpecificpaperOON;
     String dSpecificRetail;
     String dSpecificSpecialty;
     String dSpecificSpecialtyOON;
     String dawSpecificMail;
     String dawSpecificPaper;
     String dawSpecificpaperOON;
     String dawSpecificRetail;
     String dawSpecificSpecialty;
     String dawSpecificSpecialtyOON;
     String accumFamilyAll;
     String accumFamilyMail;
     String accumFamilyRetail;
     String accumFamilySpecialty;
     String accumIndividualAll;
     String accumIndividualMail;
     String accumIndividualRetail;
     String accumIndividualSpecialty;
     String asdFamilyDeductible;
     String asdFamilyMAB;
     String asdFamilyMOOP;
     String asdIndividualDeductible;
     String asdIndividualMAB;
     String asdIndividualMOOP;
     List<CRD__C> crdList = new List<CRD__C>();
     Formulary__c frmGrp = [select Group__c from Formulary__c where Group__c = 'LG Value' limit 1];
        for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Mail'){
             cTierMail = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper'){
             cTierPaper = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper Out of Network'){
             cTierpaperOON = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Retail'){
             cTierRetail = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty'){
             cTierSpecialty = RecType.ID;
         }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty OON'){
             cTierSpecialtyOON = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Mail'){
             dSpecificMail = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Paper'){
             dSpecificPaper = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Paper Out of Network'){
             dSpecificpaperOON = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Retail'){
             dSpecificRetail = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Specialty'){
             dSpecificSpecialty = RecType.ID;
         }else if(RecType.SobjectType =='Drug_Specific_Copay__c' && RecType.Name =='Specialty OON'){
             dSpecificSpecialtyOON = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Mail'){
             dawSpecificMail = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Paper'){
             dawSpecificPaper = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Paper Out of Network'){
             dawSpecificpaperOON = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Retail'){
             dawSpecificRetail = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Specialty'){
             dawSpecificSpecialty = RecType.ID;
         }else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Specialty OON'){
             dawSpecificSpecialtyOON = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Family - All'){
             accumFamilyAll = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Family - Mail'){
             accumFamilyMail = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Family - Retail'){
             accumFamilyRetail = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Family - Specialty'){
             accumFamilySpecialty = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Individual - All'){
             accumIndividualAll = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Individual - Mail'){
             accumIndividualMail = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Individual - Retail'){
             accumIndividualRetail = RecType.ID;
         }else if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Individual - Specialty'){
             accumIndividualSpecialty = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Family - Deductible'){
             asdFamilyDeductible = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Family - MAB'){
             asdFamilyMAB = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Family - MOOP'){
             asdFamilyMOOP = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Individual - Deductible'){
             asdIndividualDeductible = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Individual - MAB'){
             asdIndividualMAB = RecType.ID;
         }else if(RecType.SobjectType =='AccumulationSpecificDrug__c' && RecType.Name =='Individual - MOOP'){
             asdIndividualMOOP = RecType.ID;
         }
     }
      
        
    Account newAccount = new Account();
        newAccount.Name = 'Test Account';
        newAccount.APM_PSUID__c = '76745342';
        insert newAccount;
    //Invalid CRD and CRDBuild Record without fallout
    //1st Record
    
    Plan_Fallout__c PlanFall = new Plan_Fallout__c();
        PlanFall.Carrier_ID__c = 10;
        PlanFall.Control__c = 'ABC';
        PlanFall.Effective_Date__c = system.today();
        PlanFall.PSUID__c = 'xyz';
        PlanFall.Active__c = True;
        insert PlanFall;
    
    CRD__c newCRD1 = new CRD__c();
        newCRD1.CRD_Automated__c = True;
        newCRD1.Penalty_Type__c ='Percent';
        newCRD1.Apply_Penalty__c = 'Yes';
        newCRD1.Apply_Penalty_to_Specialty_OON__c = 'Yes';
        newCRD1.Penalty_Type_Specialty_OON__c ='Percent';
        newCRD1.Standard_or_Custom_Plan__c = 'Cloning a package plan from existing CRD';
        newCRD1.Plan_Type_Specialty_OON__c = true;
        newCRD1.Which_system_will_the_plan_be_installed__c ='HMO';
        newCRD1.Do_mandates_apply_to_all_states__c = 'N';
        newCRD1.Benefits_State_List__c = Null;
        newCRD1.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
        newCRD1.Aetna_Rx_Healthy_Outcomes__c = 'Yes';
        newCRD1.Tier_1_Rx_Reduction_Type__c = 'Dollar Amount';
        newCRD1.Tier_1_Rx_Reduction_Amount__c = 600;
        newCRD1.Tier_2_Rx_Reduction_Type__c = 'Dollar Amount';
        newCRD1.Tier_2_Rx_Reduction_Amount__c = 600;
        newCRD1.Tier_3_Rx_Reduction_Type__c = 'Dollar Amount';
        newCRD1.Tier_3_Rx_Reduction_Amount__c = 600;
        newCRD1.Tier_4_Rx_Reduction_Type__c = 'Dollar Amount';
        newCRD1.Tier_4_Rx_Reduction_Amount__c = 600;
        newCRD1.Tier_5_Rx_Reduction_Type__c = 'Dollar Amount';
        newCRD1.Tier_5_Rx_Reduction_Amount__c = 600;
        newcrd1.Disease_Management_Referral_Messaging__c = 'Yes';
        newCRD1.ARH_Offering_Type__c = null;
        newCRD1.Toll_Free_Number__c = 'Custom';
        newCRD1.POS_Rebate_for_Plan__c = 'Yes';
        newCRD1.In_Network_claims_are_reimbursed__c = True;
        newCRD1.Out_of_Network_claims_are_reimbused__c = True;
        newCRD1.Out_of_Network_Discount_Rate__c = Null;
        newCRD1.Does_the_client_want_to_do_COB__c = 'No';
        newCRD1.Process_Point_of_Sales_COB__c = True;
        newCRD1.Reimbursement_Levels__c = 'Test';
        newCRD1.In_Network_Discount_Rate__c = '12';
        newCRD1.Out_of_Network_Discount_Rate__c = '11';
        newCRD1.Retail_Number_of_Tiers__c ='1';
        newCRD1.Specialty_Number_of_Tiers__c ='1';
        insert newCRD1;
    CRDBuildOrder__c newCrdBuilder1 = new CRDBuildOrder__c();
        newCrdBuilder1.Build__c = true;
        newCrdBuilder1.CRD__c = newCRD1.id;
        insert newCrdBuilder1;
    map<integer,Pers_Full_Report__c> pfrMap = new map<integer,Pers_Full_Report__c>();
     
    Pers_Full_Report__c testpers = new Pers_Full_Report__c();
        testpers.WS_RISK_IND__c = 'R';
        testpers.WS_RISK_IND__c = 'S';
        testpers.WS_PSUID__c = '1';
        testpers.WS_RISK_IND__c = 'N';
        testpers.WS_PSUID__c = '0001';
        testpers.WS_ACQ_BUSS_CD__c  = '01';
        testpers.Carrier_ID__c  = 7760;
        testpers.WS_CUST_SUBSEG__c = 'AGB';
        testpers.CRD__c = newCRD1.id;
        testpers.ControlPlanEffective__c = '147258AA7/24/2017';
        testpers.WS_PROV_NUM__c = 137;
        testpers.WS_LV_NO__c = 100;
        testpers.PERStimestamp__c = System.now();
        insert testpers;
        pfrMap.put(integer.valueof(testpers.WS_PROV_NUM__c),testpers);
        map<integer,Pers_Full_Report__c> mapPFR = new Map<integer,Pers_Full_Report__c>();
        mapPFR.put(integer.valueof(testpers.WS_PROV_NUM__c) ,testpers);
        Provision__c pc = new Provision__c();
        pc.ProvisionNumber__c = 137;
        pc.Name = 'Provision 137';
        pc.active__c = True;
        pc.Provision_Text__c = 'test';
        insert pc;
        LineValue__c lv = new LineValue__c();
        lv.Active__c = True;
        lv.Name = 'P137L100';
        lv.Line_value__c = 100;
        lv.Line_value_text__c = 'test';
        lv.Provision_ID__c = pc.id;
        lv.key__c = '137-100';
        insert lv;
       
        Mapping__c mc = [select Field_API__c from Mapping__C where Field_API__c='Formulary_Group__c' AND Object__c = 'DC_Drug_List_Group__c' limit 1];
        Mapping_Values__c mv = new Mapping_Values__c();
        mv.MappingColumnID__c = mc.id;
        mv.FieldValue__c = 'LG Value;LG Value Plus;Commercial';
        mv.Line_ValueID__c = lv.id;
        insert mv;
        Map<string,List<Mapping_Values__c>> mvMap = new Map<string,List<Mapping_Values__c>>();
        mvMap.put('DC_Drug_List_Group__c',new List<Mapping_Values__c>{mv});
        drug_list__c dl = new drug_list__c();
        dl.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl.inactive__c = false;
        dl.Special_Use__c = 'Specialty List';
        insert dl;
        
    Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = newCRD1.Id;
        dCoverageMail.Formulary__c = frmGrp.id;
        dCoverageMail.Formulary_Open_Closed__c = 'Open';
        dCoverageMail.Do_you_have_Choose_Generic__c = Null;
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        dCoverageMail.fills_before_MMO_option_is_invoked__c = 1;
        dCoverageMail.Non_Pref_Brand_Penalty_Percent__c = 3;
        dCoverageMail.Non_Pref_Brand_Penalty_Dollar_Amount__c = 1;
        dCoverageMail.Non_Pref_Brand_Penalty_Type__c = Null;
        dCoverageMail.Non_Pref_Brand_Penalty_Maximum_Dollar__c = 5;
        dCoverageMail.Non_Pref_Brand_Penalty_Minimum_Dollar__c =3;
        dCoverageMail.Brand_Penalty_Maximum_Dollar__c = 10;
        dCoverageMail.Secondary_Aetna_Specialty_Care_Rx__c ='Custom';
        dCoverageMail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        //dCoverageMail.Secondary_Speciality_Drug_List__c = dl.id;
        insert dCoverageMail;
        system.debug('DDDCCC '+ dCoverageMail.CRD_ID__c);
        drug_list__c dl2 = new drug_list__c();
        dl2.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl2.inactive__c = false;
        dl2.Special_Use__c = 'Specialty List';
        insert dl2;
        
    Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = newCRD1.Id;
        dCoverageRetail.Formulary__c = frmGrp.id;
        dCoverageRetail.Formulary_Open_Closed__c = 'Open';
        dCoverageRetail.Do_you_have_Choose_Generic__c = Null;
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'Yes';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = 2;
        //dCoverageRetail.Secondary_Speciality_Drug_List__c = dl2.id;
        insert dCoverageRetail;
        system.debug('KKKFFF ' + dCoverageRetail.CRD_ID__c);
        crdList.add(newCRD1);
    Network_Junction__c njunction1 = new Network_Junction__c();
        njunction1.CRD_ID__c = newCRD1.id;
        njunction1.Network_Retail__c = 'Aetna National Network';
        njunction1.Does_client_have_suppression__c = 'Yes';
        insert njunction1;
        
        List<Copay_Tier__c> cTierList = new List<Copay_Tier__c>();
        List<SteppedCopay__c> steppedCopayList = new List<SteppedCopay__c>();
        
    Copay_Tier__c cTier1 = new Copay_Tier__c();
        cTier1.CRD__c = newCRD1.id;
        cTier1.RecordTypeId = cTierMail;
        cTier1.Dollar_Amount__c = 3;
        cTier1.Percent__c = 2;
        cTier1.Copay_Calc__c = 'Greatest of All';
        cTier1.Tier_Type__c =   'Brand (SSB & MSB)';
        cTier1.Stepped_Copay__c = True;
        cTierList.add(cTier1);
    
    Copay_Tier__c cTier2 = new Copay_Tier__c();
        cTier2.CRD__c = newCRD1.id;
        cTier2.RecordTypeId = cTierPaper;
        cTier2.Tier_Type__c = 'Specialty (Preferred & Non-Preferred)';
        cTierList.add(cTier2);
        
    Copay_Tier__c cTier3 = new Copay_Tier__c();
        cTier3.CRD__c = newCRD1.id;
        cTier3.RecordTypeId = cTierpaperOON;
        cTier3.Tier_Type__c = 'Generic (SSG & MSG)';
        cTierList.add(cTier3);
        
    Copay_Tier__c cTier4 = new Copay_Tier__c();
        cTier4.CRD__c = newCRD1.id;
        cTier4.RecordTypeId = cTierRetail;
        cTier4.Tier_Type__c = 'Single Source Brand (SSB)';
        cTierList.add(cTier4);
        
    Copay_Tier__c cTier5 = new Copay_Tier__c();
        cTier5.CRD__c = newCRD1.id;
        cTier5.RecordTypeId = cTierSpecialty;
        cTier5.Dollar_Amount__c = 3; 
        cTier5.Copay_Calc__c = 'Lower of the Copay or percentage';
        cTier5.Tier_Type__c = 'Preferred Specialty';
        cTierList.add(cTier5);
        
    Copay_Tier__c cTier6 = new Copay_Tier__c();
        cTier6.CRD__c = newCRD1.id;
        cTier6.RecordTypeId = cTierSpecialtyOON;
        cTier6.Stepped_Copay__c = True;
        cTier6.Dollar_Amount__c = 3;  
        cTier6.Tier_Type__c = 'Single Source Generic (SSG)';
        cTierList.add(cTier6);
        insert cTierList;
        
    List<Copay_Tier__c> CopayLIst = [select Id,Name from Copay_Tier__c where CRD__c =:newCRD1.ID Limit 1000];
    
    system.assertequals(6, CopayLIst.size());  
        
    SteppedCopay__c sc1 = new SteppedCopay__c();
        sc1.Copay_Tier__c = cTierList[0].Id;
        sc1.Min_Range__c = 5;
        sc1.Max_Range__c = 9;
        sc1.Dollar_Amount__c = 3;
        steppedCopayList.add(sc1);
    SteppedCopay__c sc2 = new SteppedCopay__c();
        sc2.Copay_Tier__c = cTierList[1].Id;
        sc2.Min_Range__c = 5;
        sc2.Max_Range__c = 3;
        sc2.Dollar_Amount__c = 3;
        sc2.Percent_Amount__c = 5;
        sc2.Copay_Calc__c = 'Lower of the Copay or percentage';
        steppedCopayList.add(sc2);
    SteppedCopay__c sc3 = new SteppedCopay__c();    
        sc3.Copay_Tier__c = cTierList[2].Id;
        sc3.Min_Range__c = 5;
        sc3.Max_Range__c = 10;
        sc3.Percent_Amount__c = 5;
        steppedCopayList.add(sc3);
    SteppedCopay__c sc4 = new SteppedCopay__c();    
        sc4.Copay_Tier__c = cTierList[3].Id;
        sc4.Min_Range__c = 5;
        sc4.Max_Range__c = 10;  
        steppedCopayList.add(sc4);
    SteppedCopay__c sc5 = new SteppedCopay__c();    
        sc5.Copay_Tier__c = cTierList[4].Id;
        sc5.Min_Range__c = 5;
        sc5.Max_Range__c = 10;
        steppedCopayList.add(sc5);
    SteppedCopay__c sc6 = new SteppedCopay__c();    
        sc6.Copay_Tier__c = cTierList[5].Id;
        sc6.Min_Range__c = 5;
        sc6.Max_Range__c = 10;
        steppedCopayList.add(sc6);
    
       insert steppedCopayList;
       
        List<SteppedCopay__c> stepCopayRecordLIst1 = [select 
                                                       Id,Name,Min_Range__c,Copay_Calc__c,Copay_Tier__c,Copay_Tier__r.CRD__c
                                                       From 
                                                       SteppedCopay__c 
                                                       where 
                                                       Copay_Tier__r.CRD__c = :newCRD1.Id];
     
     system.assertequals(6, stepCopayRecordLIst1.size());       
                                                              
    Drug_Specific_Copay__c sdMail = new Drug_Specific_Copay__c();
        sdMail.CRD_ID__c = newCRD1.id;
        sdMail.RecordTypeId =dSpecificMail; 
        insert sdMail;
    Drug_Specific_Stepped_Copay__c dssc1 = new Drug_Specific_Stepped_Copay__c();
        dssc1.Drug_Specific_Copay_ID__c = sdMail.Id;
        dssc1.Beginning_Range__c = 1;
        dssc1.End_Range__c = 2;
        insert dssc1;   
    Drug_Specific_Copay__c sdPaper = new Drug_Specific_Copay__c();
        sdPaper.CRD_ID__c = newCRD1.id;
        sdPaper.RecordTypeId =dSpecificPaper;
        sdPaper.Dollar_Amount__c = 3;
        sdPaper.Percent__c = 4;
        insert sdPaper;
    Drug_Specific_Stepped_Copay__c dssc2 = new Drug_Specific_Stepped_Copay__c();
        dssc2.Drug_Specific_Copay_ID__c = sdPaper.Id;
        dssc2.Beginning_Range__c = 3;
        dssc2.End_Range__c = 4;
        insert dssc2;   
    Drug_Specific_Copay__c sdPaperOON = new Drug_Specific_Copay__c();
        sdPaperOON.CRD_ID__c = newCRD1.id;
        sdPaperOON.RecordTypeId =dSpecificpaperOON;
        sdPaperOON.Stepped_Copay__c = True;
        sdPaperOON.Dollar_Amount__c = 3;
        insert sdPaperOON;
    Drug_Specific_Stepped_Copay__c dssc3 = new Drug_Specific_Stepped_Copay__c();
        dssc3.Drug_Specific_Copay_ID__c = sdPaperOON.Id;
        dssc3.Dollar_Amount__c= 5;
        dssc3.Percent__c = 5;
        dssc3.Beginning_Range__c = 5;
        dssc3.End_Range__c = 6;
        insert dssc3;   
    Drug_Specific_Copay__c sdRetail = new Drug_Specific_Copay__c();
        sdRetail.CRD_ID__c = newCRD1.id;
        sdRetail.RecordTypeId =dSpecificRetail;
        sdRetail.Stepped_Copay__c = True;
        sdRetail.Dollar_Amount__c = 3;
        sdRetail.Copay_Calculation__c = 'Lower of the Copay or percentage';
        insert sdRetail;
    Drug_Specific_Stepped_Copay__c dssc4 = new Drug_Specific_Stepped_Copay__c();
        dssc4.Drug_Specific_Copay_ID__c = sdRetail.Id;
        dssc4.Beginning_Range__c = 7;
        dssc4.End_Range__c = 8;
        insert dssc4;   
    Drug_Specific_Copay__c sdSpecialty = new Drug_Specific_Copay__c();
        sdSpecialty.CRD_ID__c = newCRD1.id;
        sdSpecialty.RecordTypeId =dSpecificSpecialty;
        insert sdSpecialty;
    Drug_Specific_Stepped_Copay__c dssc5 = new Drug_Specific_Stepped_Copay__c();
        dssc5.Drug_Specific_Copay_ID__c = sdSpecialty.Id;
        dssc5.Beginning_Range__c = 9;
        dssc5.End_Range__c = 10;
        insert dssc5;   
    Drug_Specific_Copay__c sdSpecialtyOON = new Drug_Specific_Copay__c();
        sdSpecialtyOON.CRD_ID__c = newCRD1.id;
        sdSpecialtyOON.RecordTypeId =dSpecificSpecialtyOON;
        insert sdSpecialtyOON;
    Drug_Specific_Stepped_Copay__c dssc6 = new Drug_Specific_Stepped_Copay__c();
        dssc6.Drug_Specific_Copay_ID__c = sdSpecialtyOON.Id;
        dssc6.Beginning_Range__c = 11;
        dssc6.End_Range__c = 12;
        insert dssc6;  
     List<Drug_Specific_Copay__c> listDrugSC = new List<Drug_Specific_Copay__c>();
     listDrugSC.add(sdMail);
     listDrugSC.add(sdPaper);
     listDrugSC.add(sdPaperOON);
     listDrugSC.add(sdRetail);
     listDrugSC.add(sdSpecialty);
     listDrugSC.add(sdSpecialtyOON);
     List<Drug_Specific_Stepped_Copay__c> listDrugSteppedC = new List<Drug_Specific_Stepped_Copay__c>();
     listDrugSteppedC.add(dssc1);
     listDrugSteppedC.add(dssc2);
     listDrugSteppedC.add(dssc3);
     listDrugSteppedC.add(dssc4);
     listDrugSteppedC.add(dssc5);
     listDrugSteppedC.add(dssc6);
    
    list<DAW_Specific_Copay__c> listdawSC= new List<DAW_Specific_Copay__c>(); 
    DAW_Specific_Copay__c dscMail = new DAW_Specific_Copay__c();
        dscMail.CRD_ID__c = newCRD1.id;
        dscMail.RecordTypeId =dawSpecificMail;
        listdawSC.add(dscMail);   
    DAW_Specific_Copay__c dscPaper = new DAW_Specific_Copay__c();
        dscPaper.CRD_ID__c = newCRD1.id;
        dscPaper.RecordTypeId =dawSpecificPaper;
        listdawSC.add(dscPaper);   
    DAW_Specific_Copay__c dscPaperOON = new DAW_Specific_Copay__c();
        dscPaperOON.CRD_ID__c = newCRD1.id;
        dscPaperOON.RecordTypeId =dawSpecificpaperOON;
        listdawSC.add(dscPaperOON);
    DAW_Specific_Copay__c dscRetail = new DAW_Specific_Copay__c();
        dscRetail.CRD_ID__c = newCRD1.id;
        dscRetail.RecordTypeId =dawSpecificRetail;
        listdawSC.add(dscRetail);
    DAW_Specific_Copay__c dscSpecialty = new DAW_Specific_Copay__c();
        dscSpecialty.CRD_ID__c = newCRD1.id;
        dscSpecialty.RecordTypeId =dawSpecificSpecialty;
        listdawSC.add(dscSpecialty);
    DAW_Specific_Copay__c dscSpecialtyOON = new DAW_Specific_Copay__c();
        dscSpecialtyOON.CRD_ID__c = newCRD1.id;
        dscSpecialtyOON.RecordTypeId =dawSpecificSpecialtyOON;
        listdawSC.add(dscSpecialtyOON);        
        insert listdawSC;
    
    list<DAW_Specific_Stepped_Copay__c> listdawSSC= new List<DAW_Specific_Stepped_Copay__c>();
    DAW_Specific_Stepped_Copay__c dssco1 = new  DAW_Specific_Stepped_Copay__c();
        dssco1.DAW_Specific_Copay_ID__c = dscMail.id;
        dssco1.Stepped_CoPay_Type__c = 'Day Supply';
        dssco1.Beginning_Range__c = 1;
        dssco1.End_Range__c = 2;
        listdawSSC.add(dssco1); 
    DAW_Specific_Stepped_Copay__c dssco2 = new  DAW_Specific_Stepped_Copay__c();
        dssco2.DAW_Specific_Copay_ID__c = dscPaper.id;
        dssco2.Beginning_Range__c = 3;
        dssco2.End_Range__c = 4;
        dssco2.Stepped_CoPay_Type__c = 'Day Supply';
        dssco2.Dollar_Amount__c = 5;
        dssco2.Percent__c = 10;
        dssco2.Minimum_Dollar__c = 10;
        dssco2.Maximum_Dollar__c = 5;
        dssco2.Beginning_Range__c = 10;
        dssco2.End_Range__c = 5;
        listdawSSC.add(dssco2);  
        insert listdawSSC;
    List<Waiver_Of_Deductible__c> listWOD = new List<Waiver_Of_Deductible__c>(); 
    Waiver_Of_Deductible__c wod1 = new Waiver_Of_Deductible__c();
        wod1.Standard__c = True;
        wod1.CRD_ID__c = newCRD1.id;
        insert wod1;
        listWOD.add(wod1);
    Waiver_Of_Deductible__c wod2 = new Waiver_Of_Deductible__c();
        wod2.Standard__c = True;
        wod2.CRD_ID__c = newCRD1.id;
        wod2.M__c = True;
        insert wod2;  
        listWOD.add(wod2);
    Accumulations__c accumFA = new Accumulations__c();
        accumFA.CRD_ID__c = newCRD1.id;
        accumFA.RecordTypeId =accumFamilyAll;
        accumFA.What_happens_when_MOOP_is_met__c = 'Change Copay';
        insert accumFA;
    Accumulations__c accumFM = new Accumulations__c();
        accumFM.CRD_ID__c = newCRD1.id;
        accumFM.RecordTypeId =accumFamilyMail;
        insert accumFM;
    Accumulations__c accumFR = new Accumulations__c();
        accumFR.CRD_ID__c = newCRD1.id;
        accumFR.RecordTypeId =accumFamilyRetail;
        accumFR.Is_there_a_Maximum_Allowable_Benefit__c = 'Yes';
        accumFR.Is_there_a_Maximum_Out_of_Pocket__c = 'Yes';
        accumFR.Family_Members_to_meet_Family_Deduct__c = '1';
        accumFR.What_is_the_In_Network_MOOP_Amount__c = 1;
        accumFR.What_is_the_OON_MOOP_Amount__c = 3;
        accumFR.MOOP_Period__c = 'Month';
        accumFR.DAW_Differential_Penalty_Applies_to_MOOP__c = 'No';
        accumFR.Deductible_Applies_towards_the_MOOP__c = 'No';
        insert accumFR;
    Accumulations__c accumFS = new Accumulations__c();
        accumFS.CRD_ID__c = newCRD1.id;
        accumFS.RecordTypeId =accumFamilySpecialty;
        accumFS.Is_there_a_Maximum_Allowable_Benefit__c = 'Yes';
        accumFS.MAB_Dedictible_Amount__c = 3;
        accumFS.MAB_Period__c = 'Month';
        insert accumFS;
    Accumulations__c accumIA = new Accumulations__c();
        accumIA.CRD_ID__c = newCRD1.id;
        accumIA.RecordTypeId =accumIndividualAll;
        insert accumIA;
    Accumulations__c accumIM = new Accumulations__c();
        accumIM.CRD_ID__c = newCRD1.id;
        accumIM.RecordTypeId =accumIndividualMail;
        insert accumIM;
    Accumulations__c accumIR = new Accumulations__c();
        accumIR.CRD_ID__c = newCRD1.id;
        accumIR.RecordTypeId =accumIndividualRetail;
        insert accumIR;
    Accumulations__c accumIS = new Accumulations__c();
        accumIS.CRD_ID__c = newCRD1.id;
        accumIS.RecordTypeId =accumIndividualSpecialty;
        insert accumIS;       
    List<AccumulationSpecificDrug__c> accumSpeList = new List<AccumulationSpecificDrug__c>();
    AccumulationSpecificDrug__c accumSpec = new AccumulationSpecificDrug__c();
        RecordType rtAccum = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - MAB'];
        accumSpec.Accumulations_ID__c = accumFR.Id;
        accumSpec.RecordTypeID = rtAccum.ID;
        insert accumSpec;
        accumSpeList.add(accumSpec);   
    AccumulationSpecificDrug__c accumSpec2 = new AccumulationSpecificDrug__c();
        RecordType rtAccum2 = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - Deductible'];
        accumSpec2.Accumulations_ID__c = accumFR.Id;
        accumSpec2.RecordTypeID = rtAccum2.ID;
        accumSpec2.Deductible_Amount__c = 10;
        accumSpec2.Deuductible_Accumulation_from_4th_Qtr__c = 'No';
        accumSpec2.Deductible_Period__c = 'Months';
        insert accumSpec2;
        accumSpeList.add(accumSpec2);                
    //2nd Record 
    CRD__c newCRD2 = new CRD__c();
        newCRD2.CRD_Automated__c = True;
        newCRD2.Standard_or_Custom_Plan__c = Null;
        newCRD2.Are_you_creating_a_Package_Plan__c = 'Yes';
        newCRD2.Which_system_will_the_plan_be_installed__c = null;
        newCRD2.Plan_Type_Specialty_OON__c = False;
        newCRD2.Plan_Type_Paper_Out_of_Network__c = True;
        newCRD2.Contract_State__c = 'IL';
        newCRD2.POS_Rebate_for_Plan__c = 'No';
        newCRD2.Insured_Type__c= 'Fully Insured';
        newCRD2.Enroll_in_RxCheck__c = Null;
        newCRD2.RTMD_Client_Share_Percent__c = 12;
        newCRD2.Does_the_client_want_to_do_COB__c = 'Yes';
        newCRD2.COB_or_MOB__c = 'COB';
        newCRD2.Process_Point_of_Sales_COB__c = True;
        newCRD2.In_Network__c = True;
        newCRD2.Out_of_Network__c = True;
        newCRD2.Reimbursement_Levels__c = 'Test';
        newCRD2.In_Network_Discount_Rate__c = '12';
        newCRD2.Out_of_Network_Discount_Rate__c = '11';
        newCRD2.In_Network_Reimbursement_Level__c = '1';
        newCRD2.Out_of_Network_Reimbursement_Level__c = '2';
        newCRD2.Benefits_State_List__c = 'AK;CT;ME';
        newCRD2.List_Of_states_to_remove_the_plan__c = 'AL;ME;MN';
        newCRD2.Plan_Platform__c = 'HMO';
        newCRD2.Apply_Penalty__c = 'Yes';
        newCRD2.Do_you_want_to_do_Step_Therapy__c = 'Yes';
        newCRD2.Standard_Program_or_Select_Classes__c = 'ST Drug List(s)';
        newCRD2.Do_you_want_to_do_Precert__c = 'Yes';
        newCRD2.Standard_Precert_List_or_Select_Classes__c = 'PA Drug List(s)';
        newCRD2.Are_there_Quantity_Limits__c = 'Yes';
        newCRD2.Standard_QL_List_or_Select_Classes__c ='QL Drug List(s)';
        newCRD2.Quantity_Limit_TOC_of_Days__c = 50;
        newCRD2.Precert_TOC_days__c = 90;
        newCRD2.Compound_Max_Pay__c = Null;
        insert newCRD2;
     CRD_Step_Therapy_Junction__c stJunc1 = new CRD_Step_Therapy_Junction__c();
        stJunc1.CRD_ID__c = newCRD2.id;
        insert stJunc1;
     CRD_PriorAuth_Junction__c paJunc1 = new CRD_PriorAuth_Junction__c();
        paJunc1.CRD_ID__c = newCRD2.id; 
        insert paJunc1;
     CRD_Quantity_Limit_Junction__c qlJunc1 = new CRD_Quantity_Limit_Junction__c(); 
        qlJunc1.CRD_ID__c = newCRD2.id;
        insert qlJunc1; 
     Network_Junction__c njunction2 = new Network_Junction__c();
        njunction2.CRD_ID__c = newCRD2.id;
        njunction2.Network_Mail__c = Null;
        njunction2.Network_Specialty__c = Null;
        njunction2.Network_Retail__c = Null;
        insert njunction2;
    CRDBuildOrder__c newCrdBuilder2 = new CRDBuildOrder__c();
        newCrdBuilder2.Build__c = true;
        newCrdBuilder2.CRD__c = newCRD1.id;
        insert newCrdBuilder2;

     
    //3rd Record 
    CRD__c newCRD3 = new CRD__c();
     newCRD3.CRD_Automated__c = True;
     newCRD3.Standard_or_Custom_Plan__c = 'Creating a custom plan';
     newCRD3.TP_ID__c = '1321';
     newCRD3.Does_the_client_want_to_do_COB__c = 'Yes';
     newCRD3.COB_or_MOB__c = 'MOB';
     newCRD3.Process_Point_of_Sales_COB__c = True;
     newCRD3.In_Network__c = True;
     newCRD3.Out_of_Network__c = True;
     newCRD3.Reimbursement_Levels__c = 'Test';
     newCRD3.In_Network_Discount_Rate__c = '12';
     newCRD3.Out_of_Network_Discount_Rate__c = '11';
     newCRD3.In_Network_Reimbursement_Level__c = '1';
     newCRD3.Out_of_Network_Reimbursement_Level__c = '2';
     newCRD3.Waive_Deductible_for_Tier_1_Drugs__c = 'Yes – Waive In Network';
     newCRD3.Integrate_with_Medical__c = 'No';
     newCRD3.Penalty_Type__c = 'Percent';
     newCRD3.Benefits_State_List__c = 'AK;CT;ME';
     newCRD3.List_Of_states_to_remove_the_plan__c = 'AK;CT;ME';
     newCRD3.Plan_Platform__c = 'HMO';
     newCRD3.Are_you_creating_a_Package_Plan__c = 'Yes';
     newCRD3.Enroll_in_RxCheck__c = Null;
     insert newCRD3;
    CRDBuildOrder__c newCrdBuilder3 = new CRDBuildOrder__c();
        newCrdBuilder3.Build__c = true;
        newCrdBuilder3.CRD__c = newCRD3.id;
        insert newCrdBuilder3; 
     
    //4th Record
    Max_Pay__c testinst = new Max_Pay__c();
    testinst.Record_Type__c = 'Compound Max Pay';
    testinst.End_Date__c = system.today();
    testinst.Begin_Date__c = system.today();    
    insert testinst;
    CRD__c newCRD4 = new CRD__c();
     newCRD4.CRD_Automated__c = True;
     newCRD4.Waive_Deductible_for_Tier_1_Drugs__c = 'Yes - Waive Out of Network';
     newCRD4.Integrate_with_Medical__c = 'No';
     newCRD4.Which_system_will_the_plan_be_installed__c = 'HMO';
     newCRD4.Do_mandates_apply_to_all_states__c = 'Y';
     newCRD4.Benefits_State_List__c = 'AK';
     newCRD4.Plan_Type_Paper_Out_of_Network__c = True;
     newCRD4.Contract_State__c = 'IL';
     newCRD4.Insured_Type__c = 'Fully Insured';
     newCRD4.Enroll_in_RxCheck__c = 'Yes';
     newCRD4.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
     newCRD4.SAC_Override_Option__c = 'No';
     newCRD4.Do_Prescription_Savings_Program__c = 'Yes';
     newCRD4.PSP_Override_Option__c = 'No';
     newCRD4.Rx_Override_Option__c = 'No';
     newCRD4.Override_Standard_Compound_Max_Pay__c = 'Yes';
     newCRD4.Compound_Max_Pay__c = testinst.id;
     insert newCRD4;
    Clinical_Program_Group_Junction__c cpj1 = new Clinical_Program_Group_Junction__c();
     cpj1.CRD_ID__c = newCRD4.Id;
     cpj1.Selected__c = true;
     cpj1.Record_Type__c = 'Save-A-Copay';
     insert cpj1;
    Clinical_Program_Group_Junction__c cpj2 = new Clinical_Program_Group_Junction__c();
     cpj2.CRD_ID__c = newCRD4.Id;
     cpj2.Selected__c = true;
     cpj2.Record_Type__c = 'Save-A-Copay';
     insert cpj2; 
    Clinical_Program_Group_Junction__c cpj3 = new Clinical_Program_Group_Junction__c();
     cpj3.CRD_ID__c = newCRD4.Id;
     cpj3.Selected__c = true;
     cpj3.Record_Type__c = 'Prescription Savings Program';
     insert cpj3;
    Clinical_Program_Group_Junction__c cpj4 = new Clinical_Program_Group_Junction__c();
     cpj4.CRD_ID__c = newCRD4.Id;
     cpj4.Selected__c = true;
     cpj4.Record_Type__c = 'Prescription Savings Program';
     insert cpj4;
   Clinical_Program_Group_Junction__c cpj5 = new Clinical_Program_Group_Junction__c();
     cpj5.CRD_ID__c = newCRD4.Id;
     cpj5.Selected__c = true;
     cpj5.Record_Type__c = 'RxCheck';
     insert cpj5;
    Clinical_Program_Group_Junction__c cpj6 = new Clinical_Program_Group_Junction__c();
     cpj6.CRD_ID__c = newCRD4.Id;
     cpj6.Selected__c = true;
     cpj6.Record_Type__c = 'RxCheck';
     insert cpj6;  
    CRDBuildOrder__c newCrdBuilder4 = new CRDBuildOrder__c();
     newCrdBuilder4.Build__c = true;
     newCrdBuilder4.CRD__c = newCRD4.id;
     insert newCrdBuilder4; 
    //Bhaskar
    DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
        dcdl.Related_Drug_Coverage__c = dCoverageMail.id;
        dcdl.Drug_List__c = System.Label.Drug_List_Fertility_Inj ;
        dcdl.Quantity_Over_Time_Time_Value__c=55;
        dcdl.Maximum_Days__c=365;
        dcdl.Inclusion_Exclusion__c = 'Exclude';
        insert dcdl;
          
        List <Retail_Vaccine_Program__C> lstRetailVaccine = new List<Retail_Vaccine_Program__C>();
        ID recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        ID recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
        ID recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
        Retail_Vaccine_Program__C retailVP = new Retail_Vaccine_Program__C();
        retailVP.recordtypeid = recordTypeSeasonal;
        retailVP.CRD__c = newCRD1.id;
        retailVP.Applies__c = 'True';
        retailVP.Vaccine_Network__c = 'Broad Network';
        retailVP.Dollar_Amount__C = 15;
        retailVP.Percent__c =12;
        lstRetailVaccine.add( retailVP);
        Retail_Vaccine_Program__C retailVP1 = new Retail_Vaccine_Program__C();
        retailVP1.recordtypeid = recordTypeSeasonal;
        retailVP1.CRD__c = newCRD1.id;
        retailVP1.Applies__c = 'True';
        retailVP1.Vaccine_Network__c = 'Broad Network';
        lstRetailVaccine.add(retailVP1) ;
        Retail_Vaccine_Program__C retailVP2 = new Retail_Vaccine_Program__C();
        retailVP2.recordtypeid = recordTypePreventive;
        retailVP2.CRD__c = newCRD1.id;
        retailVP2.Applies__c = 'True';
        retailVP2.Vaccine_Network__c = 'Broad Network';
        lstRetailVaccine.add( retailVP2);
        Retail_Vaccine_Program__C retailVP2a = new Retail_Vaccine_Program__C();
        retailVP2a.recordtypeid = recordTypePreventive;
        retailVP2a.CRD__c = newCRD1.id;
        retailVP2a.Applies__c = 'True';
        retailVP2a.Vaccine_Network__c = 'Broad Network';
        retailVP2a.Dollar_Amount__C = 15;
        retailVP2a.Percent__c =12;
        lstRetailVaccine.add( retailVP2a);
        Retail_Vaccine_Program__C retailVP3 = new Retail_Vaccine_Program__C();
        retailVP3.recordtypeid = recordTypeTravel;
        retailVP3.CRD__c = newCRD1.id;
        retailVP3.Applies__c = 'True';
        retailVP3.Vaccine_Network__c = 'Broad Network';
        lstRetailVaccine.add( retailVP3);
        Retail_Vaccine_Program__C retailVP3a = new Retail_Vaccine_Program__C();
        retailVP3a.recordtypeid = recordTypeTravel;
        retailVP3a.CRD__c = newCRD1.id;
        retailVP3a.Applies__c = 'True';
        retailVP3a.Vaccine_Network__c = 'Broad Network';
        retailVP3a.Dollar_Amount__C = 15;
        retailVP3a.Percent__c =12;
        lstRetailVaccine.add( retailVP3a);
        insert lstRetailVaccine;

    Test.StartTest();
        BAC_CB_Validations validationBatch = new BAC_CB_Validations();
        ID batchprocessid = Database.executeBatch(validationBatch);
        CB_Validations validationClass = new CB_Validations();
        validationClass.validate_CRD(newCRD1.ID, True);
        validationClass.validateCopay(cTierList);
        validationClass.checkTierType(cTierList);
        validationClass.validateSteppedCopay(steppedCopayList);
        validationClass.checkCopayRange(steppedCopayList);
        validationClass.validateDrugSpecificCopay(listDrugSC);
        validationClass.validateDrugSpecificSteppedCopay(listDrugSteppedC);
        validationClass.validateWaiverOfDeductible(listWOD);
        validationClass.validatedawSpecificSteppedCopay(listdawSSC);
        validationClass.validateAccumulationDrugListDeductible(accumSpeList,'Family - Deductible');
        validationClass.validateAccumulationDrugListMab(accumSpeList,'Family - Deductible');
        validationClass.validateAccumulationDrugListMoop(accumFM,accumSpeList,'Family - Deductible');
        validationClass.valiadte_DCDL(dCoverageMail);
        validationClass.validate_DrugCoverage(crdList);
        system.debug('CRDNAME ' + newCRD1.id);
        validationClass.matchDCDLFormulary(pfrMap,newCRD1,mvMap);
    Test.StopTest();
 }
    static testMethod void CB_ValidationsHandler(){
        Crd__c newCRD = new Crd__c();
        newCRD.POS_Rebate_for_Plan__c = 'No';
        newCRD.RTMD_Effective_Date__c = System.today();
        newCRD.In_Network_claims_are_reimbursed__c = True;
        newCRD.Out_of_Network_claims_are_reimbused__c = True;
        newCRD.Does_the_client_want_to_do_COB__c = 'No';
        newCRD.Out_of_Network_Reimbursement_Level__c = '100% submitted charges less copay';
        newCRD.Out_of_Network_Discount_Rate__c ='747';
        insert newCRD;
        
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
        newCrdBuilder.Build__c = true;
        newCrdBuilder.CRD__c = newCRD.id;
        insert newCrdBuilder;
        
        List<sObject> listsObject = new List<sObject>();
        listsObject.add(newCrdBuilder);
            
        CB_ValidationsHandler validhandler = new CB_ValidationsHandler();
        validhandler.executeValidation(listsObject);
        
        //Test Data for CB_Validations
        List<Crd__c> crdList = new List<Crd__c>();
        Crd__c newCRD1 = new Crd__c();
        newCRD1.Pharmacy_Advisor__c = True;
        newCRD1.Is_DM_vendor_the_same_for_each_condition__c = 'Yes';
        newCRD1.Implementation_Type__c ='Pharmacy Advisor All Conditions Complete Buy-Up Option';
        newCRD1.PA_Condition_7__c ='Test';  
        newCRD1.Does_the_client_want_to_do_COB__c = 'Yes';
        newCRD1.Out_of_Network_claims_are_reimbused__c = True;
        newCRD1.Out_of_Network_Discount_Rate__c = '747';
        insert newCRD1;
        
        crdList.add(newCRD1);
        CB_Validations validationClass = new CB_Validations();
        validationClass.validate_DrugCoverage(crdList);
        validationClass.programScreenValidation(newCRD1);
        validationClass.cRDThirdScreenValidations(newCRD1);
        newCRD1.Is_DM_vendor_the_same_for_each_condition__c = 'No';
        newCRD1.PA_DM_Vendor_Contract_End_Date_2__c = Null;
        newCRD1.PA_Condition_1__c ='Test';
        newCRD1.PA_Condition_2__c ='Test';
        newCRD1.PA_Condition_3__c ='Test';
        newCRD1.PA_Condition_4__c ='Test';
        newCRD1.PA_Condition_5__c ='Test';
        newCRD1.PA_Condition_6__c ='Test';
        newCRD1.COB_or_MOB__c = 'COB';
        newCRD1.In_Network__c = True;
        newCRD1.In_Network_Reimbursement_Level__c = '100% submitted less ZERO copay';
        newCRD1.Process_Point_of_Sales_COB__c = True;
        newCRD1.Reimbursement_Levels__c = 'Test';
        newCRD1.Out_of_Network__c = True;
        newCRD1.Out_of_Network_Reimbursement_Level__c = 'Test';
        
        update newCRD1;
        validationClass.programScreenValidation(newCRD1);
        validationClass.cRDThirdScreenValidations(newCRD);
        validationClass.cRDThirdScreenValidations(newCRD1);
    }
    
    
    static testMethod void CB_ValidationsTest(){
        
        CRD__c newCRD1 = new CRD__c();
        insert newCRD1;
        
        List<Crd__c> crdList = new List<Crd__c>();
        crdList.add(newCRD1);
        
        
        List<Waiver_Of_Deductible__c> listWOD = new List<Waiver_Of_Deductible__c>(); 
        
        Waiver_Of_Deductible__c wod1 = new Waiver_Of_Deductible__c();
        wod1.Standard__c = True;
        wod1.CRD_ID__c = newCRD1.id;
        wod1.M__c = True;
        wod1.N__c = True;
        wod1.O__c = True;
        wod1.Y__c = True;
        insert wod1;
        listWOD.add(wod1);
        
        Waiver_Of_Deductible__c wod2 = new Waiver_Of_Deductible__c();
        wod2.Standard__c = True;
        wod2.CRD_ID__c = newCRD1.id;
        wod2.M__c = True;
        wod2.N__c = True;
        wod2.O__c = True;
        wod2.Y__c = True;
        insert wod2;  
        listWOD.add(wod2);
        
        Accumulations__c accumFR = new Accumulations__c();
        accumFR.CRD_ID__c = newCRD1.id;
        insert accumFR;
        
        List<AccumulationSpecificDrug__c> accumSpeList = new List<AccumulationSpecificDrug__c>();
        
        AccumulationSpecificDrug__c accumSpec = new AccumulationSpecificDrug__c();
        RecordType rtAccum = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - MAB'];
        accumSpec.Accumulations_ID__c = accumFR.Id;
        accumSpec.RecordTypeID = rtAccum.ID;
        accumSpec.M__c = True;
        accumSpec.N__c = True;
        accumSpec.O__c = True;
        accumSpec.Y__c = True;
        accumSpec.Exclude_from_Accumulation__c= True;
        insert accumSpec;
        accumSpeList.add(accumSpec);  
         
        AccumulationSpecificDrug__c accumSpec2 = new AccumulationSpecificDrug__c();
        RecordType rtAccum2 = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - Deductible'];
        accumSpec2.Accumulations_ID__c = accumFR.Id;
        accumSpec2.RecordTypeID = rtAccum2.ID;
        accumSpec2.M__c = True;
        accumSpec2.N__c = True;
        accumSpec2.O__c = True;
        accumSpec2.Y__c = True;
        accumSpec2.Exclude_from_Accumulation__c= True;
        insert accumSpec2;
        accumSpeList.add(accumSpec2);
        
        CB_Validations validationClass = new CB_Validations();
        validationClass.validateWaiverOfDeductible(listWOD);
        validationClass.validateAccumulationDrugListMNOY(accumSpeList, accumSpec.RecordType.Name);
        
    }
    
            static testMethod void CB_unitTest(){
        
        List<Crd__c> crdList = new List<Crd__c>();
        Crd__c newCRD1 = new Crd__c();
        newCRD1.Do_you_want_to_do_Precert__c = 'No';
        newCRD1.Do_you_want_to_do_Step_Therapy__c = 'No' ;
        insert newCRD1;
        
        Account acc = new Account();
        acc.name = 'Test';
        insert acc;
        
        Formulary__c f = new Formulary__c();
        f.Account__c = acc.id;
        insert f;
        
        drug_list__c dl1 = new drug_list__c();
        dl1.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl1.inactive__c = false;
        dl1.Special_Use__c = 'Specialty List';
        dl1.Drug_List_Name__C = 'Test'; 
        dl1.Description__c = 'Test';
        insert dl1;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        RecordType RecType = [Select Id From RecordType where SobjectType ='Drug_Coverage__c' AND Name ='Mail'];
        dCoverageMail.RecordTypeId = RecType.ID;
        dCoverageMail.CRD_ID__c = newCRD1.Id;
        dCoverageMail.Formulary__c = f.id ;
        //dCoverageMail.Secondary_Speciality_Drug_List__c = dl1.id;
        insert dCoverageMail;
        
        Mid_Year_Formulary__c  myf = new Mid_Year_Formulary__c();
        myf.Formulary__c = f.id;
        insert myf;
        
        crdList.add(newCRD1);
        CB_Validations validationClass = new CB_Validations();
        validationClass.validate_DrugCoverage(crdList);
        
    }
    static testMethod void CB_ValidationsTest1(){
        
        CRD__c newCRD1 = new CRD__c();
        newCRD1.Retail_Number_of_Tiers__c = '1';
        newCRD1.Specialty_Number_of_Tiers__c = '1';
        Id CtId = Schema.SObjectType.Copay_Tier__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        insert newCRD1;
        
        Copay_Tier__c Ct = new Copay_Tier__c();
        Ct.RecordTypeId = CtId;
        Ct.CRD__c = newCRD1.id;
        Ct.Copay_Calc__c= 'Sum of Copay + percentage';
        Ct.CRDB_Copay_Logic__c='Standard';
        Ct.Tier__c='2';
        Ct.Tier_Type__c='All Drugs';
        insert Ct;
        
        List<Crd__c> crdList = new List<Crd__c>();
        crdList.add(newCRD1);
        
        
        List<Waiver_Of_Deductible__c> listWOD = new List<Waiver_Of_Deductible__c>(); 
        
        Waiver_Of_Deductible__c wod1 = new Waiver_Of_Deductible__c();
        wod1.Standard__c = True;
        wod1.CRD_ID__c = newCRD1.id;
        wod1.M__c = True;
        wod1.N__c = True;
        wod1.O__c = True;
        wod1.Y__c = True;
        insert wod1;
        listWOD.add(wod1);
        
        Waiver_Of_Deductible__c wod2 = new Waiver_Of_Deductible__c();
        wod2.Standard__c = True;
        wod2.CRD_ID__c = newCRD1.id;
        wod2.M__c = True;
        wod2.N__c = True;
        wod2.O__c = True;
        wod2.Y__c = True;
        insert wod2;  
        listWOD.add(wod2);
        
        Accumulations__c accumFR = new Accumulations__c();
        accumFR.CRD_ID__c = newCRD1.id;
        insert accumFR;
        
        List<AccumulationSpecificDrug__c> accumSpeList = new List<AccumulationSpecificDrug__c>();
        
        AccumulationSpecificDrug__c accumSpec = new AccumulationSpecificDrug__c();
        RecordType rtAccum = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - MAB'];
        accumSpec.Accumulations_ID__c = accumFR.Id;
        accumSpec.RecordTypeID = rtAccum.ID;
        accumSpec.M__c = True;
        accumSpec.N__c = True;
        accumSpec.O__c = True;
        accumSpec.Y__c = True;
        accumSpec.Exclude_from_Accumulation__c= True;
        insert accumSpec;
        accumSpeList.add(accumSpec);  
         
        AccumulationSpecificDrug__c accumSpec2 = new AccumulationSpecificDrug__c();
        RecordType rtAccum2 = [Select Id from RecordType where sObjectType = 'AccumulationSpecificDrug__c' AND Name = 'Family - Deductible'];
        accumSpec2.Accumulations_ID__c = accumFR.Id;
        accumSpec2.RecordTypeID = rtAccum2.ID;
        accumSpec2.M__c = True;
        accumSpec2.N__c = True;
        accumSpec2.O__c = True;
        accumSpec2.Y__c = True;
        insert accumSpec2;
        accumSpeList.add(accumSpec2);
        
        CB_Validations validationClass = new CB_Validations();
        validationClass.validateWaiverOfDeductible(listWOD);
        validationClass.validateAccumulationDrugListMNOY(accumSpeList, accumSpec.RecordType.Name);
        
    }
    static testMethod void validateRetailVaccine(){
        Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
        Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
        Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp1 = new Retail_Vaccine_Program__C();
        rvp1.RecordTypeId = recordTypeTravel;
        rvp1.CoPay_Calculation__c = 'test';
        rvp1.CRD__c = crdRec.id;
        rvp1.Dollar_Amount__c = 10;
        rvp1.Maximum_Dollar__c = 100;
        rvp1.Minimum_Dollar__c = 9;
        rvp1.Percent__c = 12;
        rvp1.Vaccine_Network__c = 'Broad Network';
        insert rvp1;
        crdRec.Disease_Management_Referral_Messaging__c = 'Yes';
        update crdRec;
        Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
        rvp2.RecordTypeId = recordTypeSeasonal;
        rvp2.CoPay_Calculation__c = 'test';
        rvp2.CRD__c = crdRec.id;
        rvp2.Dollar_Amount__c = 10;
        rvp2.Maximum_Dollar__c = 100;
        rvp2.Minimum_Dollar__c = 9;
        rvp2.Percent__c = 12;
        rvp2.Vaccine_Network__c = 'Broad Network';
        insert rvp2;
        update crdRec;
        Retail_Vaccine_Program__C rvp3 = new Retail_Vaccine_Program__C();
        rvp3.RecordTypeId = recordTypePreventive;
        rvp3.CoPay_Calculation__c = 'test';
        rvp3.CRD__c = crdRec.id;
        rvp3.Dollar_Amount__c = 10;
        rvp3.Maximum_Dollar__c = 100;
        rvp3.Minimum_Dollar__c = 9;
        rvp3.Percent__c = 12;
        rvp3.Vaccine_Network__c = 'Broad Network';
        rvp3.Waiver_of_Deductible__c = 'Yes';
        insert rvp3;
        update crdRec;    
    }
    
    static testMethod void CB_ValidationsTest2(){
        
        CRD__c newCRD1 = new CRD__c();
        newCRD1.CRD_Automated__c = True;
        newCRD1.Retail_Number_of_Tiers__c = '1';
        newCRD1.Specialty_Number_of_Tiers__c = '1';
        Id CtId = Schema.SObjectType.Copay_Tier__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        newCRD1.Benefits_State_List__c ='CT';
        newCRD1.List_Of_states_to_remove_the_plan__c ='CT';
        newCRD1.Apply_Penalty__c = 'Yes';
        newCRD1.Penalty_Type__c = null;
        newCRD1.Penalty_Amount__c=null;
        newCRD1.Are_you_creating_a_Package_Plan__c ='Yes';
        newCRD1.Which_system_will_the_plan_be_installed__c = Null;
        newCRD1.Override_Standard_Compound_Max_Pay__c = 'Yes';
        newCRD1.Is_there_Compound_Max_Pay__c = 'No';
        insert newCRD1;
        
        Network_Junction__c njunction2 = new Network_Junction__c();
        njunction2.CRD_ID__c = newCRD1.id;
        njunction2.Network_Mail__c = Null;
        njunction2.Network_Specialty__c = Null;
        njunction2.Network_Retail__c = Null;
        insert njunction2;
        
        drug_list__c dl = new drug_list__c();
        dl.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl.inactive__c = false;
        dl.Special_Use__c = 'Specialty List';
        insert dl;
        
        Drug_Group__C dg = new Drug_Group__C();
        dg.Drug_Group_Name__c = 'test';
        dg.Description__c = 'test';
        dg.Effective_Date__c = system.today();
        dg.Termination_Date__c = system.today() + 1;
        insert dg;
        
        Waiver_Of_Deductible__c wod1 = new Waiver_Of_Deductible__c();
        wod1.Drug_List__c = dl.id;
        wod1.Drug_Group__c = dg.id;
        wod1.CRD_ID__c = newCRD1.id;
        insert wod1;
        
        Waiver_Of_Deductible__c wod2 = new Waiver_Of_Deductible__c();
        wod2.Drug_List__c = dl.id;
        wod2.Drug_Group__c = null;
        wod2.CRD_ID__c = newCRD1.id;
        insert wod2;
        
       
        
        CB_Validations validationClass = new CB_Validations();
        validationClass.validate_CRD(newCRD1.ID, True);
    }
}