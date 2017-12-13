/*Purpose: Apex Class to Auto Populate CRD Data From the Pers Reports
========================================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE                          DETAIL                                 
1.0      Abhishek Goel          7/17/2014       Apex Class to Auto Populate CRD Data From the Pers Reports
1.1      Joognu Rao             08/28/2014      Implemented Formulary coding logic
2.1      Nitish                 10/28/2014      Request No 05091
2.2      Nitish                 1/30/2015       Request no 5464
2.3      Ankur                 1/29/2015       Request no 5463
2.4      Sushant                2/20/2015       Request No. 05552
3.0      Amit jain              19 Feb, 2015    Added logic for formulary mapping and DCDL Creation, Request 5460
3.1      Richa                  26 Feb, 2015    Added a null check to delete blank records in Clinical Program Group Junction object for Req 5548
3.2      Nitish                03/11/2015       Request No 05584(Implemented Functionality If What is Carrier? on CRD = Aetna Global Benefits then Contract State on CRD is set to BR irrespective of its Value on PFR)
3.3      Joognu Rao              19/03/2015      condition updated for 'Retail To Mail' field.
3.4      Amit jain           6th April, 2015    Modified for request 5590, added logic to update NPL Drug List based on Formulary
3.5      Richa               14th May, 2015     Modified for Req 5766
3.6      Amit                18 may 2015        Added Formulary extension logic for request 5755
3.7      Sushant             2 Sept 2015         Request 06016 for Accumulations delete
3.8      Amit                16 Sep, 2015       Modified condition to delete and create precert junction records as per Request 6037, ST# 312
3.9      Amit                29 Sep, 2015       Modified ST/PA/QL junction record deletion based on FormularyXERD Table for ST# 373
4.0      Amit                24 Nov, 2015       Added logic to have different Formularies if Retail/Mail Coapay count is different, ST# 484
4.1      Richa               10 Jan, 2016       Added logic for ST#513
4.2      Vikram               01/11/2016         Request 06293: ST 637 : Remove AGB contract State rule
4.3     Nitish                06/13/2016        Request no 6452
4.4      Amit                 06/13/2016        Amit added null check on Drug Coverage fields for Request 6509
5.0     Nitish                01/17/2017        Nitish implemented Request 06819
======================================================================== */
public without sharing class CB_CrdBuilderUtil{
/*
* Method :- commonaction
* Description :- It's used Populate CRD data fields automatically. 
*/
    private static final String MAILLABEL = 'Mail';
    private static final String RETAILLABEL = 'Retail';
    private static final String PAPERLABEL = 'Paper';
    private static final String BLANK = '';
    private static final String SPECIALITY = 'Specialty';
    private static final String SPECIALITYOON = 'Specialty OON';
    private static final String PAPEROON = 'Paper Out of Network';
    private static final String NONFORMULARY = 'Non-Formulary';
    String retailTier1 = BLANK;
    String retailTier3 = BLANK;
    String mailTier1 = BLANK;
    String mailTier3 = BLANK;
    private static final String RXCHECK = 'RxCheck';
    private static final String MANDATORYWTOPTOUT = 'Mandatory w / Opt Out';
    private static final String SI2012 = 'Self Insured 2012';
    private static final String AGB = 'Aetna Global Benefits';
    private static final String ASRX1 = 'Applies-SG Value with Fertility';
    private static final String ASRX2 = 'Applies-SG Value no Fertility';
    private static final String ASRX3 = 'Applies-SG Value Plus with Fertility';
    private static final String ASRX4 = 'Applies-SG Value Plus no Fertility';
    private static final String ASRX5 = 'Applies-LG Value with Fertility';
    private static final String ASRX6 = 'Applies-LG Value no Fertility';
    private static final String ASRX7 = 'Applies-LG Value Plus with Fertility';
    private static final String ASRX8 = 'Applies-LG Value Plus no Fertility';
    private static final String ASRX9 = 'Applies-LG Premier with Fertility';
    private static final String ASRX10 = 'Applies-LG Premier no Fertility';
    private static final String ASRX11 = 'Applies-LG Premier Plus with Fertility';
    private static final String ASRX12 = 'Applies-LG Premier Plus no Fertility';
    private static final string LGPREMIERPLUS = 'LG Premier Plus';
    private static final string SHPREMIERPLUS = 'Student Health Premier Plus';
    private static final string ASRX13 = 'Applies-SH Value Plus with Fertility';
    private static final string ASRX14 = 'Applies-SH Value Plus no Fertility';
    private static final string ASRX15 = 'Applies-SH Value with Fertility';
    private static final string ASRX16 = 'Applies-SH Value no Fertility';
    private static final string ASRX17 = 'Applies-SH Premier with Fertility';
    private static final string ASRX18 = 'Applies-SH Premier no Fertility';
    private static final string ASRX19 = 'Applies- SH Premier Plus with Fertility';
    private static final string ASRX20 = 'Applies- SH Premier Plus no Fertility';
    private static final String BR = 'BR'; 
    private static final String FULLYINSURED = 'Fully Insured';
    private static final String ZERO = '0';
    private static final String R = 'R';
    private static final String S = 'S';
    private static final String NO = 'No';
    private static final String YES = 'Yes';
    private static final String N = 'N';
    private static final String SPLITFUNDED = 'Split Funded';
    private static final String SELFINSURED = 'Self Insured';
    private static final String TRADITIONAL = 'Traditional';
    private static final String CREATECUSTOMPLAN = 'Creating a custom plan';
    private static final String PSP = 'Prescription Savings Program';
    private static final String SPLIT = ';';
    private static final String REIMBURSEMENTLEVEL = '100% of submitted charges less ZERO copay';
    private static final String INNETWORKREIMBURSEMENTLEVEL = '100% submitted less ZERO copay';
    private static final String NONRISK = 'Non-Risk';
    private static final String RISK = 'Risk';
    private static final String APPLIES = 'Applies';
    private static final String DOESNOTAPPLY = 'Does not Apply';
    private static final String STANDARD = 'Standard';
    private static final String DL = 'DL-0000848';
    private static final String LABEL1 = '00';
    private static final String LABEL2 = '01';
    private static final String COB = 'COB';
    private static final string FI = 'FI 2012';
    private static final String LABEL3 = 'Erectile Dysfunction- oral';
    private static final String LABEL4 = 'Mandatory';
    private static final String NA = 'Not Applicable';
    private static final string INCLUDE = 'Include';
    private static final String DL1 = 'DL-0000852';
    private static final String SAC = 'Save-A-Copay';
    private static final String ASH = 'Aetna Student Health';
    private static final String LABEL5 = '6238';
    private static final string LABEL6 = '66962';
    private static final String LABEL7 = 'PSP Fully Insured All Drug Classes';
    private static final String IL = 'IL';
    private static final String PAR = 'Prior Authorization required';
    private static final string PREFERREDGENERICS = 'Preferred Generics';
    private static final string LABEL8 = 'Non-preferred brand and Non-preferred generics';
    private static final string LABEL9 = 'Brand (SSB & MSB)';
    private static final string ONELABEL = '1';
    private static final string TWOLABEL = '2';
    private static final string LABEL10 = 'All Drugs';
    private static final string LABEL11 = 'Specialty (Preferred & Non-Preferred)';
    private static final String LABEL12 = 'Preferred Specialty';
    private static final String LABEL13 = 'Non-Preferred Specialty';
    private static final String PrecertTOCDL = 'DL-0076037';
    private static Integer CARRIERID = 7710;
    PRIVATE STATIC FINAL STRING FEDSLABEL1 = 'Applies-FEHB no Fertility';
    PRIVATE STATIC FINAL STRING FEDSLABEL2 = 'Applies-FEHB with Fertility';
    PRIVATE STATIC FINAL STRING FEDSLABEL3 = 'Custom';
    Private Static Final String ALL = 'ALL';
    Private Static Final String COMMERCIAL = 'Commercial';
    Private Static Final String DSCAPI = 'Drug_Specific_Copay__c';
    Private Static Final String FORMULARGROUPAPI = 'Formulary_Group__c';
    Private Static Final String DCA0000705 = 'DCA-0000705';
    Private Static Final String DCA0028610 = 'DCA-0028610';
    private static boolean checkDiabeticPlan2 = false ; //Request 6819 by Nitish
    private static boolean byPassRetailCopay = false; //Request 6819 by Nitish
    private static final string ASD = 'AccumulationSpecificDrug__c';//Added by Nitish for 7094
    public set<string> asdRecType;//Added By Nitish for 7094
    public Map<Integer, Pers_Full_Report__c> provFormullaryMap;
    public List<DC_Drug_List_Group__c> diabeticDCDLToInsert = new List<DC_Drug_List_Group__c>();//6819
    public Map<String,List<copay_tier__c>> copayTierRecordTypeMap = new map<string,List<Copay_tier__c>>();
    public static boolean  dscFalloutChk = false;
    public set<string> dcformulaygroup;
    set<Id> dscId = new set<id>();
    public Map<integer,Pers_Full_Report__c> pfrMap;//Added By Nitish ST#2515
    public Map<string,List<Mapping_Values__c>> mapVal;// Added By Nitish ST#2515(for optimisation of code)
    public set<String> WODdrugclasses;//added By Nitish for ST#2515
    public list<Drug_Specific_Copay__c> dsclist = new list<Drug_Specific_Copay__c>();
    public CRD__c commonAction(Pers_Full_Report__c pers) {
        crd__c crd = new crd__c();
        crd.Standard_or_Custom_Plan__c = CREATECUSTOMPLAN;
        crd.CRD_Automated__c = true;
        
        crd.Control__c = String.valueof(pers.WS_CNTRL_NO__c);
        //Find following fields on pers report
        crd.Plan__c =  pers.WS_PLSM_CD__c;
        crd.Effective_Date__c = pers.WS_NEW_INFRC_EFF_DT__c;
        crd.OBOR_ORG_TYPE__c = pers.OBOR_ORG_TYPE__c;
        crd.ORG_NAME__c = pers.ORG_NAME__c;
        crd.ARRNG_NAME__c = pers.ARRNG_NAME__c;
        crd.PERS_timestamp__c =  pers.PERStimestamp__c;
        //Added By Nitish Request No 05091
        crd.Plan_Description__c = pers.WS_CNTRL_NM__c;
        //Richa added for 4974
        if(pers.WS_RISK_IND__c == R){
            crd.Insured_Type__c = FULLYINSURED;
        }else if(pers.WS_RISK_IND__c == S){
            crd.Insured_Type__c = SPLITFUNDED;
        }else if(pers.WS_RISK_IND__c == N){
            crd.Insured_Type__c = SELFINSURED;
        }
        List<Account>listAccount = new List<Account>();
        if(!(Pers.WS_PSUID__c == null || Pers.WS_PSUID__c == BLANK)){
            //Code to remove leading zeroes from PSUID
            if (Pers.WS_PSUID__c.startsWith(ZERO) && Pers.WS_PSUID__c.length() > 1) {
                boolean zeroPresent = true;                  
                while (zeroPresent) {                        
                    if (Pers.WS_PSUID__c.startsWith(ZERO) && Pers.WS_PSUID__c.length() > 1) {                            
                        Pers.WS_PSUID__c = Pers.WS_PSUID__c.substring(1);                        
                    } 
                    else {                            
                        zeroPresent = false;                        
                    }                   
                }           
            }    
            listAccount = [Select id, APM_PSUID__c, Name from Account where APM_PSUID__c = :Pers.WS_PSUID__c];
            if(listAccount.size() > 0 )
                crd.Account__c = listAccount[0].id; 
        }
        if(pers.WS_ACQ_BUSS_CD__c == NULL || pers.WS_ACQ_BUSS_CD__c == BLANK || pers.WS_ACQ_BUSS_CD__c == LABEL1 || pers.WS_ACQ_BUSS_CD__c == ZERO){
            crd.Acquisition_Indicator__c = NO;
        }else if(pers.WS_ACQ_BUSS_CD__c == LABEL2){
            crd.Acquisition_Indicator__c = YES;
        }
        
        if(pers.Carrier_ID__c == 7760 || pers.Carrier_ID__c == 7762 || pers.Carrier_ID__c == 7763 ){
            crd.Contract_State__c = pers.WS_MLR_CONTRACT_SITUS_ST__c;
        } else {    
            crd.Contract_State__c = pers.WS_CNTRCT_ST__c;
        }
        if(crd.Insured_Type__c == SELFINSURED){
            crd.Concurrent_DUR_ID__c = System.Label.CP_0000558;
        }else if(crd.Insured_Type__c == FULLYINSURED){
            crd.Concurrent_DUR_ID__c = System.Label.CP_0000299;
        }else if(crd.Insured_Type__c == SPLITFUNDED){
            crd.Concurrent_DUR_ID__c = System.Label.CP_0000559;
        }
        List<Subsegment_Crosswalk__c>listSubsegment = new List<Subsegment_Crosswalk__c>();
        listSubsegment = [Select Segment__c, Sub_segment__c from Subsegment_Crosswalk__c where Sub_segment__c =:Pers.WS_CUST_SUBSEG__c];
        if(listSubsegment.size() > 0){
            crd.National__c = listSubsegment[0].Segment__c; 
        } 
        crd.Sub_segment__c =  Pers.WS_CUST_SUBSEG__c;
        
        List<Coordination_of_Benefits_Crosswalk__c>listCOB = new List<Coordination_of_Benefits_Crosswalk__c>();
        listCOB = [Select Does_client_want_to_coordinate_benefits__c, Line_Text__c, MOB_or_COB__c, Options__c from Coordination_of_Benefits_Crosswalk__c where Options__c = :Pers.WS_COB_CD__c];
        if(listCOB.size() > 0){
            crd.Does_the_client_want_to_do_COB__c = listCOB[0].Does_client_want_to_coordinate_benefits__c;  
            crd.Cob_or_mob__c = listCOB[0].MOB_or_COB__c;
            if(crd.COB_or_MOB__c == COB){                        
                crd.Process_Point_of_Sales_COB__c = true;                        
                crd.In_Network__c = true;                        
                //crd.Out_of_Network__c = true;//commented this line based for Defect #D-190                        
                crd.Reimbursement_Levels__c = REIMBURSEMENTLEVEL;                        
                crd.In_Network_Reimbursement_Level__c = INNETWORKREIMBURSEMENTLEVEL;                        
                // crd.Out_of_Network_Reimbursement_Level__c = INNETWORKREIMBURSEMENTLEVEL; Commented for Request 5103 by Sushant. Logic now implemented in Post-Build Section.
            }  
        }       
        crd.High_Value_Client__c = pers.High_Value_Client__c;
        crd.Plan_Platform__c = pers.What_is_the_Carrier__c;
        crd.Carrier_ID__c = pers.Carrier_ID__c;
        //till here
        // Request No 05584 By Nitish
        /*  if(crd.Carrier_ID__c == CARRIERID){
crd.Contract_State__c = BR;
} // Commented for request 06293 - ST 637 */
        crd.CFO__c = pers.WS_CFO_CD__c;        
        crd.Which_system_will_the_plan_be_installed__c = TRADITIONAL;
        //check for the following field in pers full object
        crd.Effective_Start_Date__c = pers.WS_NEW_INFRC_EFF_DT__c;
        //crd.Plan_Type_Specialty__c = True; Commented by nitish for Story 6452
        return CRD;
    }
    public void sample(){}
    /*
* Method :- CommonPostBuildActivities
* Description :- It's used Populate CRD data fields automaticallya after post build activities. 
*/
    public void CommonPostBuildActivities(Id CRDRecordID, Id crdBuilderId){
        boolean isretaildayperfill = false;
        boolean ismaildayperfill = false;
        decimal retaildayperfill ;
        decimal maildayperfill ;
        List<CRD__C> listCRD = new List<CRD__c>();
        List<CRD__C> crdListUpdate = new List<CRD__C>();
        list<Drug_Coverage__c> dCoverage = new list<Drug_Coverage__c>();
        List < CRD_Standard_Safety_Edit_Junction__c > lstSafety = new List < CRD_Standard_Safety_Edit_Junction__c > ();
        List < Waiver_Of_Deductible__c > lstWod = new List < Waiver_Of_Deductible__c > ();
        List < Network_Junction__c > lstJunction = new List < Network_Junction__c > ();
        List < Network_Junction__c > lstJunctUpdate = new List < Network_Junction__c > ();
        List<Clinical_Program_Group_Junction__c> lstGroupJ = new  List<Clinical_Program_Group_Junction__c>();
        List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c >();
        List<Drug_Group__c> lstDrugGroup = new List<Drug_Group__c>();
        List<Pers_Full_Report__c> lstPerReport = new List<Pers_Full_Report__c>();
        List<Drug_Specific_Copay__c> lstDSCopay2delete = new List<Drug_Specific_Copay__c>();
        list<accumulations__c> accumsToDelete = new list<accumulations__c>();
        list<Drug_Coverage__c> dCoverage2Delete = new list<Drug_Coverage__c>();
        list<DC_Drug_List_Group__c> dcdl2Delete = new list<DC_Drug_List_Group__c>();
        list<CRD_PriorAuth_Junction__c> lstDelete = new list<CRD_PriorAuth_Junction__c>();
        set<string> clinicalProgramname = new set<string>();
        list<Clinical_Program_Group_Junction__c> clPrgmgrpjnctns = new list<Clinical_Program_Group_Junction__c>();
        list<Clinical_Program_Group__c> lstcpGrpJunc = new list<Clinical_Program_Group__c>();
        map < id, drug_list__c > DL848 = new map < id, drug_list__c > ([select id,Name from drug_list__c where name = 'DL-0000848']);
        String cpGroup2newCPJunc;
        boolean checkCPgroupfullyinsd = false;
        String cpGroup2newCPJuncdelete;
        String retailSpecialty = null;
        String mailSpecialty = null;
        Boolean IsPrecert = False;
        Boolean IsStepTherapy = False;
        //added by JR 
        Set<Id> specialityDrugListIds = new Set<Id>();
        List<Copay_Tier__c>lstCopayTier = new List<Copay_Tier__c>();
        
        
        
        Integer copayTierMail = 0;
        Integer copayTierRetail = 0;
        Integer copayTierSpeciality = 0;
        Integer copayTierSpecialityOON = 0;
        Integer copayTierPaperOON = 0;
        Integer copayTierPaper = 0;
        provFormullaryMap = new Map<Integer, Pers_Full_Report__c>();
        pfrMap = new Map<integer,Pers_Full_Report__c>();//Added By Nitish for 2515
        mapVal = new Map<string,List<Mapping_Values__c>>();
        set<string> lvKey = new set<string>();
        set<id> lvId = new set<id>();
        for(Pers_Full_Report__c pfr:[select WS_LV_NO__c,WS_PROV_NUM__c from Pers_Full_Report__c where CRD_Build_Order__c=:crdBuilderId limit 1000]){
            pfrMap.put(integer.valueof(pfr.WS_PROV_NUM__c),pfr);
            string key = 'P'+pfr.WS_PROV_NUM__c+'L'+pfr.WS_LV_NO__c;
            lvKey.add(key);
        }
        for(LineValue__c lv:[select Name,id from LineValue__c where Name IN:lvKey]){
            lvId.add(lv.id);
        }
        for(Mapping_Values__c mv : [Select Object_API__c,Field_API__c,FieldValue__c,Line_value__c,Provision__c,Line_ValueID__r.Name,RecordTypeId__c,Creates_Record__c,ParentMappingValue__r.RecordTypeId__c from Mapping_Values__c where Line_ValueID__c IN:lvId]){
            if(!mapVal.containsKey(string.valueof(mv.Object_API__c))){
                mapVal.put(mv.Object_API__c,new List<Mapping_Values__c  >{mv});
            }
            else if(mapVal.containsKey(string.valueof(mv.Object_API__c))){
                mapVal.get(mv.Object_API__c).add(mv);
            }
            
        }
         
        //throw new CB_BuildStep.MerchandiseException (String.valueof(prv.size()));
        for(Pers_Full_Report__c lv : pfrMap.values()){
            if(lv.WS_PROV_NUM__c == 134){
                provFormullaryMap.put(Integer.valueof(lv.WS_LV_NO__c), lv);
            }
        }
        //added by JR ends 
        
        listCRD = [Select
                   National__c,Do_you_want_to_do_Save_A_Copay__c,SAC_Override_Option__c, Effective_Date__c, Id, Name
                   ,Benefits_State_List__c,PSP_Override_Option__c,PSU__c,Enroll_in_RxCheck__c,CRD_Risk_Indicator__c
                   ,Standard_Fully_Insured_Pricing__c,List_Of_states_to_remove_the_plan__c,Plan_Platform__c,Waive_Deductible_for_Tier_1_Drugs__c
                   ,Plan_Type_Paper__c,Bypass_DMR__c
                   ,Integrate_with_Medical__c,Penalty_Type__c,Percentage_Applied__c,Apply_Penalty__c,Penalty_Amount__c
                   ,Apply_Penalty_to_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Penalty_Amount_Specialty_OON__c
                   ,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Standard_or_Custom_Plan__c
                   ,Plan_Type_Paper_Out_of_Network__c,Are_there_Quantity_Limits__c,Quantity_Limit_TOC_of_Days__c,Precert_TOC_days__c
                   ,Override_Standard_Compound_Max_Pay__c,Do_mandates_apply_to_all_states__c
                   ,Compound_Max_Pay__c,Retail_to_Mail__c,Insured_Type__c,Pharmacy_Advisor__c,Adherence_to_Drug_Therapy__c,Aetna_Autofill__c
                   ,Are_you_creating_a_Package_Plan__c,Contract_State__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c
                   ,Toll_Free_Number__c
                   ,POS_Rebate_for_Plan__c,RTMD_Effective_Date__c,RTMD_Client_Share_Percent__c
                   ,In_Network_claims_are_reimbursed__c,In_Network_Discount_Rate__c,Out_of_Network_claims_are_reimbused__c
                   ,Out_of_Network_Discount_Rate__c,Does_the_client_want_to_do_COB__c,COB_or_MOB__c
                   ,Process_Point_of_Sales_COB__c,Reimbursement_Levels__c,In_Network__c
                   ,In_Network_Reimbursement_Level__c,Out_of_Network__c,Out_of_Network_Reimbursement_Level__c,Plan_Type_Retail__c,Plan_Type_Mail__c
                   ,Plan_Type_Specialty__c
                   ,Brands_DAW_5_take_a_gen_copay_Retail__c,Brands_DAW_5_take_a_gen_copay_Mail__c,Brands_DAW_5_take_a_gen_copay_Speciality__c
                   ,Brands_w_DAW_5_take_a_generic_copay_spec__c,Brands_DAW_5_take_a_gen_copay_Paper__c,Brands_w_DAW_5_take_a_generic_copay__c
                   ,Include_Kit_Logic__c,Do_you_want_to_do_Step_Therapy__c,Do_you_want_to_do_Precert__c
                   ,NPL_Applies__c,NPL_Drug_List__c
                   ,(Select 
                     Id,Name,Aetna_Specialty_Care_Rx__c,formulary_group__c, Specialty_Drug_List_ID_From_Mapping__c, Speciality_Drug_List__c,Use_Medispan_Indicator__c,Mandatory_Mail_Order_Option__c
                     ,recordType.Name,Do_you_have_Choose_Generic__c,Maximum_days_supply__c,Max_Specialty_Day_Supply__c
                     ,Maintenance_Choice__c,Generic_Penalty_Type__c,Non_Pref_Brand_Penalty_Type__c,Generic_Penalty_Dollar_Amount__c
                     ,Non_Pref_Brand_Penalty_Dollar_Amount__c,Generic_Penalty_Percent__c,Non_Pref_Brand_Penalty_Percent__c
                     ,Gen_Penalty_Based_Retail_Mail_AWP__c
                     ,Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c,Generic_Penalty_Minimum_Dollar__c,Non_Pref_Brand_Penalty_Minimum_Dollar__c
                     ,Generic_Penalty_Maximum_Dollar__c,Brand_Penalty_Type__c,Brand_Penalty_Dollar_Amount__c,Days_Per_Fill__c,Brand_Penalty_Percent__c
                     ,Standard_Refill_too_Soon__c,Period_Type__c,Incentivized_Mail_Brand_Penalty_Type__c,fills_before_MMO_option_is_invoked__c,Number_of_Periods__c
                     ,Incent_Mail_Gen_Penalty_Max__c,Incent_Mail_Gen_Penalty_Min__c,Incent_Mail_Gen_Penalty_Percent__c,Incentivized_Mail_Generic_Penalty_Amount__c
                     ,Incent_Mail_NonPref_Brand_Penalty_Amount__c,Incent_Mail_NP_Brand_Penalty_Max__c,Incent_Mail_NP_Brand_Penalty_Min__c
                     ,Incent_Mail_NP_Brand_Penalty_Percent__c,Incentivized_Mail_Brand_Penalty_Amount__c,Incent_Mail_NonPref_Brand_Penalty_Type__c
                     ,Incentivized_Mail_Generic_Penalty_Type__c,Incent_Mail_Brand_Penalty_Max__c,Incent_Mail_Brand_Penalty_Min__c
                     ,Incent_Mail_Brand_Penalty_Percent__c,Custom_MMOD_VMOD_Drug_List__c,Formulary__c,Formulary_Open_Closed__c,Formulary__r.group__c
                     From 
                     Drug_Coverage__r),
                   (Select id,Are_there_any_drug_specifc_MOOP__c,Are_there_any_drug_specific_deductibles__c,Are_there_any_drug_specific_MAB__c,RecordTypeId from Accumulations__r),
                   (select id,Clinical_Program_Group_Name__c,Name,Record_Type__c from Clinical_Program_Group_Junction__r),
                   (select id,Drug_Class__c from Waiver_Of_Deductibles__r),
                   (select id,CRD_ID__c,Network_Mail__c From Network_Junctions__r)
                   ,(Select 
                     Id,Name, RecordType.Name,RecordType.DeveloperName,Copay_Calc__c,CRD__c,Days_Per_Fill__c,Dollar_Amount__c,LastSent__c
                     ,Max_Dollar__c,Min_Dollar__c, CRDB_Copay_logic__c,non_formulary_string__c, Number_Of_Steps__c
                     ,Percent__c,Stepped_Copay__c,SteppedCopayCount__c,Tier__c,Tier_Name__c,Tier_Type__c
                     From 
                     Copay_Tiers__r order by tier__c Limit 1000)  
                   ,(Select 
                     Id,Name,RecordTypeId, RecordType.Name,RecordType.DeveloperName,Copay_Calculation__c,CRD_ID__c,Dollar_Amount__c
                     ,Drug_Group__c,Drug_List__c,LastSent__c,M__c,Maximum_Dollar__c,Minimum_Dollar__c,N__c,O__c,Percent__c
                     ,Reverse_Copay__c,Stepped_Copay__c,SteppedCopayCount__c,TierName__c,TierNo__c,Y__c,formulary_group__c
                     From 
                     Drug_Specific_Copay_s__r Limit 1000) ,
                   (select id from CRD_PriorAuth_Junction__r where Precert_Class__c =: BLANK),
                   (select id from Save_A_Copay_Junction__r where Selected__c = false)
                   From 
                   CRD__c where ID =: CRDRecordID];
        
        
        lstCopayTier = listCRD[0].Copay_Tiers__r;
        list<copay_tier__c> updatecopaylist = new list<copay_tier__C>();
        //Added this to set values for days per fill
        dcformulaygroup = new set<string>();
        
        map<string,id> dcdlDGMap = new Map<string,id>();
        for(Drug_Group__c dg:[select id,name from Drug_Group__c where Name IN ('DCA-0000705','DCA-0028610')]){
            dcdlDGMap.put(dg.Name,dg.id);
        }
        for(Drug_Coverage__c dcRecord : listCRD[0].Drug_Coverage__r){
            
            if(dcRecord.recordtype.name == RETAILLABEL){
                if(dcRecord.Days_Per_Fill__c != null){
                    isretaildayperfill = true;
                    retaildayperfill = dcRecord.Days_Per_Fill__c;
                }
                if(dcRecord.Speciality_Drug_List__c!= null){
                    retailSpecialty = dcRecord.Speciality_Drug_List__c;
                }
                //Added By Nitish 6819
                if(checkDiabeticPlan2){
                    DC_Drug_List_Group__c dcdlRec1 = new DC_Drug_List_Group__c();
                        dcdlRec1.Related_Drug_Coverage__c = dcRecord.id;
                        dcdlRec1.Inclusion_Exclusion__c = INCLUDE;
                        dcdlRec1.Drug_Group__c = dcdlDGMap.get(DCA0000705);
                        diabeticDCDLToInsert.add(dcdlRec1);
                    DC_Drug_List_Group__c dcdlRec2 = new DC_Drug_List_Group__c();
                        dcdlRec2.Related_Drug_Coverage__c = dcRecord.id;
                        dcdlRec2.Inclusion_Exclusion__c = INCLUDE;
                        dcdlRec2.Drug_Group__c = dcdlDGMap.get(DCA0028610);
                        diabeticDCDLToInsert.add(dcdlRec2);
                }
            
            }
            if(dcRecord.recordtype.name == MAILLABEL){
                if(dcRecord.Days_Per_Fill__c != null){
                    maildayperfill = dcRecord.Days_Per_Fill__c;
                    ismaildayperfill = true;
                }
                if(dcRecord.Speciality_Drug_List__c!= null){
                    mailSpecialty = dcRecord.Speciality_Drug_List__c;
                }
                //Added By Nitish 6819
                if(checkDiabeticPlan2){
                    DC_Drug_List_Group__c dcdlRec3 = new DC_Drug_List_Group__c();
                        dcdlRec3.Related_Drug_Coverage__c = dcRecord.id;
                        dcdlRec3.Inclusion_Exclusion__c = INCLUDE;
                        dcdlRec3.Drug_Group__c = dcdlDGMap.get(DCA0000705);
                        diabeticDCDLToInsert.add(dcdlRec3);
                    DC_Drug_List_Group__c dcdlRec4 = new DC_Drug_List_Group__c();
                        dcdlRec4.Related_Drug_Coverage__c = dcRecord.id;
                        dcdlRec4.Inclusion_Exclusion__c = INCLUDE;
                        dcdlRec4.Drug_Group__c = dcdlDGMap.get(DCA0028610);
                        diabeticDCDLToInsert.add(dcdlRec4); 
                }
                            
            }
            dcformulaygroup.add(dcRecord.Formulary_Group__c);
        }
    
        //set copay tiers for days per fill value
        for(Copay_Tier__c copay:lstCopayTier){
            
            if(copayTierRecordTypeMap.containsKey(copay.RecordType.Name))
            {
                copayTierRecordTypeMap.get(copay.RecordType.Name).add(copay);
            }
            else{
                copayTierRecordTypeMap.put(copay.RecordType.Name, new List<Copay_Tier__c>{copay});
            }
            
            if(copay.recordtype.Name ==MAILLABEL){
                if(ismaildayperfill){
                    copay.Days_Per_Fill__c = maildayperfill;
                }             
                copayTierMail++;
                updatecopaylist.add(copay);
                
            }else if(copay.recordtype.Name ==RETAILLABEL){
                copayTierRetail++;
                if(isretaildayperfill){
                    copay.Days_Per_Fill__c = retaildayperfill;
                } 
                updatecopaylist.add(copay);    
            }else if(copay.recordtype.Name ==SPECIALITY){
                copayTierSpeciality ++;
            }
            else if(copay.recordtype.Name ==SPECIALITYOON){
                copayTierSpecialityOON ++;
            }
            else if(copay.recordtype.Name ==PAPEROON){
                copayTierPaperOON ++;
            }
            else if(copay.recordtype.Name ==PAPERLABEL){
                if(isretaildayperfill){
                    copay.Days_Per_Fill__c = retaildayperfill;
                }
                copayTierPaper ++;
                updatecopaylist.add(copay);
            }
        }
        // Following code added for Request 05552 ** Starts**
        
        if(copayTierRecordTypeMap.containsKey(Maillabel))
        {
            list<copay_tier__c> copayTierList = new list<copay_tier__c>();
            
            copayTierList = copayTierRecordTypeMap.get(Maillabel); // Check for Copay Tier Records with Mail record type
            
            if(!copayTierList.IsEmpty() && copayTierList.size()!=0){
                changeTierNonFormulary(copayTierList);
            }
            
        }
        if(copayTierRecordTypeMap.containsKey(Retaillabel))
        {
            list<copay_tier__c> copayTierList = new list<copay_tier__c>();
            copayTierList = copayTierRecordTypeMap.get(Retaillabel); // Check for Copay Tier Records with Retail record type
            if(!copayTierList.IsEmpty() && copayTierList.size()!=0){
                changeTierNonFormulary(copayTierList);
            }
        }
        if(copayTierRecordTypeMap.containsKey(Paperlabel))
        {
            list<copay_tier__c> copayTierList = new list<copay_tier__c>();
            copayTierList = copayTierRecordTypeMap.get(Paperlabel); // Check for Copay Tier Records with Paper record type
            if(!copayTierList.IsEmpty() && copayTierList.size()!=0){
                changeTierNonFormulary(copayTierList);
            }
        }          
        // Above code added for Request 05552 ** Ends**
        listCRD[0].Mail_Number_of_Tiers__c = String.valueof(copayTierMail);
        listCRD[0].Retail_Number_of_Tiers__c = String.valueof(copayTierRetail);
        listCRD[0].Specialty_Number_of_Tiers__c = String.valueof(copayTierSpeciality);
        listCRD[0].Specialty_OON_Number_of_Tiers__c = String.valueof(copayTierSpecialityOON);
        listCRD[0].Paper_Out_of_Network_Number_of_Tiers__c = String.valueof(copayTierPaperOON);
        listCRD[0].Paper_Number_of_Tiers__c = String.valueof(copayTierPaper);
        
        lstcpGrpJunc = [select id,Clinical_Program_Group_Description__c,Name,RecordTypeId,RecordType.Name,Clinical_Program_Group_Name__c
                        ,Date_Marked_for_Deletion__c,Deletion_Reason__c,Deletion_Requestor__c,Effective_Date__c,Funding__c,HIX__c,Inactive__c
                        ,LastSent__c,Mark_for_Deletion__c,RecordTypeName__c,Termination_Date__c 
                        from 
                        Clinical_Program_Group__c
                        Where
                        RecordType.Name =: RXCHECK];
        for(Clinical_Program_Group__c currentRecord: lstcpGrpJunc){
            if(currentRecord.Clinical_Program_Group_Name__c== FI && (currentRecord.Funding__c==FULLYINSURED || currentRecord.Funding__c==SPLITFUNDED)){
                cpGroup2newCPJunc = currentRecord.id;
            }else if(currentRecord.Clinical_Program_Group_Name__c== SI2012 && currentRecord.Funding__c==SELFINSURED){
                cpGroup2newCPJuncdelete = currentRecord.id;
            }
        }    
        Id PSPGroupRtId;
        map<id,set<string>> crdWOD = new map<id,set<string>>();
        WODdrugclasses = new set<string>();
        map<string,list<Waiver_Of_Deductible_Drug_Class__c>> WodClassmap = new map<string,list<Waiver_Of_Deductible_Drug_Class__c>>();
        
        list<Waiver_Of_Deductible__c> delWODs = new list<Waiver_Of_Deductible__c>();
        for(crd__C crdrec : listCRD){
            set<String> tempWODdrugclasses = new set<String>();
            for(Waiver_Of_Deductible__c WOD : crdrec.Waiver_Of_Deductibles__r){
                tempWODdrugclasses.add(WOD.Drug_Class__c);
            }
            crdWOD.put(crdrec.id,tempWODdrugclasses);
            WODdrugclasses.addall(tempWODdrugclasses);
            delWODs.addall(crdrec.Waiver_Of_Deductibles__r);
            
            //Added by Amit
            if(crdrec.Do_you_want_to_do_Precert__c == 'Yes'){
                IsPrecert= True;
            }
            if(crdrec.Do_you_want_to_do_Step_Therapy__c == 'Yes'){
                IsStepTherapy = True;
            }
            //Ends
        }
       
        
        //           map<id,list<DC_Drug_List_Group__c>> DrugCoverageDCdrugList = new map<id,list<DC_Drug_List_Group__c>>();
        set<id> drugcoverageids = new set<id>();
        for(Drug_Coverage__c dcRecord : listCRD[0].Drug_Coverage__r){
            drugcoverageids.add(dcRecord.id);
            specialityDrugListIds.add(dcRecord.Speciality_Drug_List__c);
        }
        map<id,Drug_Coverage__c> druglst_dcdl = new map<id,Drug_Coverage__c>();
        druglst_dcdl = new map<id,Drug_Coverage__c>([select id,name,Maximum_days_supply__c,(select id,name,Drug_List__c,Drug_List__r.name,Drug_Group__r.Name,Related_Drug_Coverage__c,Inclusion_Exclusion__c,Inclusion_Exclusion_Drug_Class__c, Apply_Limitations__c, Maximum_Days__c from DC_Drug_List__r ) from Drug_Coverage__c where id in :drugcoverageids]);
       
        //list<DC_Drug_List_Group__c> lstDcdruglistgroup = [select id,Drug_List__c,Related_Drug_Coverage__c from DC_Drug_List_Group__c where Related_Drug_Coverage__c in :drugcoverageids];
        
        /*for(DC_Drug_List_Group__c tempdcdruglistgroup : lstDcdruglistgroup){
list<DC_Drug_List_Group__c> tempdcdruglistgrouplist = new list<DC_Drug_List_Group__c>();
if(DrugCoverageDCdrugList.containskey(tempdcdruglistgroup.Related_Drug_Coverage__c))
tempdcdruglistgrouplist = DrugCoverageDCdrugList.get(tempdcdruglistgroup.Related_Drug_Coverage__c);

tempdcdruglistgrouplist.add(tempdcdruglistgroup);
DrugCoverageDCdrugList.put(tempdcdruglistgroup.Related_Drug_Coverage__c,tempdcdruglistgrouplist);
}*/
        //Change by Vatsal for ST 1702 start
        list<Waiver_Of_Deductible_Drug_Class__c> WODClassLst= [Select id, Drug_Class__c, Delivery_System__c, Drug_Group__c, Drug_List__c, Drug_Class_Desc__c,M__c, N__c, O__c, Y__c,Formulary_Group__c,Network__c
                                                               from Waiver_Of_Deductible_Drug_Class__c
                                                               Where Drug_Class__c in :WODdrugclasses ];// Removed "and Formulary_Group__c = Null" from query filter for Obs#7 August 2017 release
        //Change by Vatsal for ST 1702 end
        
        for(Waiver_Of_Deductible_Drug_Class__c tempWODclass : WODClassLst){
            list<Waiver_Of_Deductible_Drug_Class__c> tempWodclasslst = new list<Waiver_Of_Deductible_Drug_Class__c>();
            if(WodClassmap.containskey(tempWODclass.Drug_Class__c))
                tempWodclasslst = WodClassmap.get(tempWODclass.Drug_Class__c);
            
            tempWodclasslst.add(tempWODclass);
            WodClassmap.put(tempWODclass.Drug_Class__c,tempWodclasslst);
            
        }
        
        List < Schema.RecordTypeInfo > RtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
        for (Schema.Recordtypeinfo thisInfo: RtInfos) {
            if (thisInfo.Name == PSP) {
                PSPGroupRtId = thisInfo.getRecordTypeId();
            }
        }
        clinicalProgrameGroup = [select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c from Clinical_Program_Group__c where RecordTypeId = : PSPGroupRtId and Inactive__c = false and Funding__c =: FULLYINSURED];
        String query = 'select id,Name,Drug_Group_Name__c,Description__c ,Platform__c,Standard__c,Special_Use__c,Funding__c from Drug_Group__c where Special_Use__c=\'Safety Edit\' and Standard__c=true';
        list<drug_group__C> druggroups = Database.query(query);
        if(listCRD != Null && listCRD.size() > 0){
            for(Crd__c crd : listCRD){
                for(String Drugclass : crdWOD.get(crd.id)){
                    if(WodClassmap.containskey(Drugclass)){
                        for(Waiver_Of_Deductible_Drug_Class__c tempWOD : WodClassmap.get(Drugclass)){
                            lstWod.add(new Waiver_Of_Deductible__c(
                                crd_id__c = crd.Id
                                ,Drug_Class__c = tempWOD.Drug_Class__c
                                ,Drug_Class_Desc__c = tempWOD.Drug_Class_Desc__c
                                , Delivery_System__c = tempWOD.Delivery_System__c
                                , Standard__c = true
                                , Drug_Group__c = tempWOD.Drug_Group__c
                                , Drug_List__c = tempWOD.Drug_List__c
                                , M__c = tempWOD.M__c
                                , N__c = tempWOD.N__c
                                , O__c = tempWOD.O__c
                                , Y__c = tempWOD.Y__c 
                                ,Network__c = tempWOD.Network__c)); 
                        }
                    }
                }
                
                
                if(crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED){
                    crd.CRD_Risk_Indicator__c = RISK;
                }else if(crd.Insured_Type__c == SELFINSURED){
                    crd.CRD_Risk_Indicator__c = NONRISK;
                }
                
                
                for (Drug_Group__c dg: druggroups) {
                    CRD_Standard_Safety_Edit_Junction__c safety = new CRD_Standard_Safety_Edit_Junction__c();
                    safety.CRDID__c = crd.Id;
                    safety.Drug_Group__c = dg.id;
                    if(dg.id== Label.DCA_0035068){
                        safety.Select__c = true;
                    }else if(dg.id == Label.DCA_0035071){
                        safety.Select__c = true;
                    }
                    if(safety.Select__c && crd.Plan_Platform__c != 'Aetna Global Benefits'){//Richa added the Select condition to rectify the RxPlan ID issue on 21st Nov
                        if (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) {
                            if(dg.Funding__c==FULLYINSURED || dg.Funding__c==SPLITFUNDED)
                                lstSafety.add(safety);
                        }
                        if (crd.Insured_Type__c == SELFINSURED) {
                            if(dg.Funding__c==SELFINSURED)
                                lstSafety.add(safety);
                        }
                    }else {
                        if(safety.Select__c && crd.Plan_Platform__c == 'Aetna Global Benefits'){//Richa added the Select condition to rectify the RxPlan ID issue on 21st Nov
                            if(dg.Funding__c==SELFINSURED)
                                lstSafety.add(safety);
                        }   
                    }
                    
                }
                if(crd.Insured_Type__c == SELFINSURED){
                    crd.Enroll_in_RxCheck__c = NO;
                    
                } 
                if(crd.Do_you_want_to_do_Save_A_Copay__c == NO){
                    crd.SAC_Override_Option__c = null; // D-600
                }
                //Below code is commented for request #05194
                /*  if(crd.Plan_Platform__c == 'Traditional/PPO'){
crd.Include_Kit_Logic__c = True;
}else{
crd.Include_Kit_Logic__c = False;
}*/
                for(Drug_Coverage__c dcRecord : crd.Drug_Coverage__r){
                    if(dcRecord.Mandatory_Mail_Order_Option__c == LABEL4){
                        dcRecord.Use_Medispan_Indicator__c = YES;
                    }
                    /*if(dcRecord.recordType.Name == RETAILLABEL){
                        dcRecord.Max_Specialty_Day_Supply__c = 30;
                    }*/
                    // Added by toshi for 6877
                    if(dcRecord.recordType.Name == RETAILLABEL){
                        if(dcRecord.Max_Specialty_Day_Supply__c!= null && dcRecord.Max_Specialty_Day_Supply__c != 90){
                            dcRecord.Max_Specialty_Day_Supply__c = 30;
                        }
                    }
                    
                    if (( (String) dcRecord.get('Aetna_Specialty_Care_Rx__c') == 'Applies-Expanded List' || (String) dcRecord.get('Aetna_Specialty_Care_Rx__c') == 'Applies -Self Injectables List Only')) {
                        for (DC_Drug_List_Group__c ChildobjectRecord: druglst_dcdl.get(dcRecord.id).DC_Drug_List__r) {
                            if((String) ChildobjectRecord.get('Inclusion_Exclusion__c') == 'Prior Authorization required'){
                                if (DL848.containskey((String) ChildobjectRecord.get('Drug_List__c')) && DL848.get((String) ChildobjectRecord.get('Drug_List__c')).Name == 'DL-0000848') {
                                    if ((String) dcRecord.get('Aetna_Specialty_Care_Rx__c') == 'Applies-Expanded List'){
                                        dcRecord.put('Aetna_Specialty_Care_Rx__c', 'Applies-Expanded List w/ Fertility');
                                        dcRecord.Speciality_Drug_List__c = System.label.DCSRT05;
                                    }else {
                                        dcRecord.put('Aetna_Specialty_Care_Rx__c', 'Applies -Self Injectables List Only w/ Fertility');
                                        dcRecord.Speciality_Drug_List__c = System.label.DCSRT07;
                                    }
                                }
                            }    
                        }
                    }
                    
                    //Update RxCheck, Override Option and create Clinical Junction Record in case of Funding Type = 'Fully Insured'
                    /* if((crd.Insured_Type__c == 'Fully Insured' || crd.Insured_Type__c == 'Split Funded')
&& dcRecord.recordType.Name == 'Mail' 
&& dcRecord.Mandatory_Mail_Order_Option__c == 'Not Applicable' 
&& dcRecord.Maintenance_Choice__c == 'Not Applicable'){
crd.Enroll_in_RxCheck__c = 'Yes';
crd.Rx_Override_Option__c = 'No';
checkCPgroupfullyinsd = true;
//Create Clinical program group Junction Record for FI 2012
Clinical_Program_Group_Junction__c cpJunction = new Clinical_Program_Group_Junction__c();
cpJunction.Record_Type__c = 'RxCheck';
cpJunction.crd_id__C = crd.id;
cpJunction.Clinical_Program_Group_ID__c = cpGroup2newCPJunc;
cpJunction.Clinical_Program_Group_Name__c = 'FI 2012';
cpJunction.Selected__c = TRUE;
lstGroupJ.add(cpJunction);
}
*/  
                    
                    //Included condition for split funded plan type as discussed with Rajit on 19/03/2015- JR
                    if(dcRecord.Mandatory_Mail_Order_Option__c == NA && dcRecord.Maintenance_Choice__c == NA 
                       && (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) && crd.Plan_Type_Mail__c == true){
                           crd.Retail_to_Mail__c = true;
                       }    
                    
                    //Added the below if section as per Req 5766
                    if(dcRecord.Mandatory_Mail_Order_Option__c == MANDATORYWTOPTOUT && dcRecord.recordType.Name == MAILLABEL){
                        dcRecord.Use_Medispan_Indicator__c = null;
                        dcRecord.Period_Type__c = null;
                        dcRecord.Incentivized_Mail_Brand_Penalty_Type__c = null;
                        //dcRecord.fills_before_MMO_option_is_invoked__c = null;
                        dcRecord.Number_of_Periods__c = null;
                        dcRecord.Incent_Mail_Gen_Penalty_Max__c = null;
                        dcRecord.Incent_Mail_Gen_Penalty_Min__c = null;
                        dcRecord.Incent_Mail_Gen_Penalty_Percent__c = null;
                        dcRecord.Incentivized_Mail_Generic_Penalty_Amount__c = null;
                        dcRecord.Incent_Mail_NonPref_Brand_Penalty_Amount__c = null;
                        dcRecord.Incent_Mail_NP_Brand_Penalty_Max__c = null;
                        dcRecord.Incent_Mail_NP_Brand_Penalty_Min__c = null;
                        dcRecord.Incent_Mail_NP_Brand_Penalty_Percent__c = null;
                        dcRecord.Incentivized_Mail_Brand_Penalty_Amount__c = null;
                        dcRecord.Incent_Mail_NonPref_Brand_Penalty_Type__c = null;
                        dcRecord.Incentivized_Mail_Generic_Penalty_Type__c = null;
                        dcRecord.Incent_Mail_Brand_Penalty_Max__c = null;
                        dcRecord.Incent_Mail_Brand_Penalty_Min__c = null;
                        dcRecord.Incent_Mail_Brand_Penalty_Percent__c = null;
                        dcRecord.Custom_MMOD_VMOD_Drug_List__c = null;
                    }
                    
                    dCoverage.add(dcRecord);
                    //Delete Drug Coverage Record and their respective Drug List records when Plan Type Mail/Plan Type Retail is False
                    if(!crd.Plan_Type_Mail__c && dcRecord.recordType.Name == MAILLABEL){
                        
                        if(druglst_dcdl.get(dcRecord.id).DC_Drug_List__r != Null){
                            
                            dcdl2Delete.addall(druglst_dcdl.get(dcRecord.id).DC_Drug_List__r);
                        }
                        dCoverage2Delete.add(dcRecord);
                    }
                    if(!crd.Plan_Type_Retail__c && dcRecord.recordType.Name == RETAILLABEL){
                        
                        if(druglst_dcdl.get(dcRecord.id).DC_Drug_List__r != Null){
                            
                            dcdl2Delete.addall(druglst_dcdl.get(dcRecord.id).DC_Drug_List__r);
                        }
                        dCoverage2Delete.add(dcRecord);
                    }                        
                    // Request no 5464 Updating Maximum Day field on DCDL by Using Maximum Days Supply of DC
                    if(dcRecord.recordType.Name == RETAILLABEL || dcRecord.recordType.Name == MAILLABEL){
                        
                        List<DC_Drug_List_Group__c> dcdruglist = new List<DC_Drug_List_Group__c>();
                        DC_Drug_List_Group__c dcdlItem;
                        for (DC_Drug_List_Group__c item: druglst_dcdl.get(dcRecord.id).DC_Drug_List__r) {
                            
                            if(item.Inclusion_Exclusion__c == INCLUDE && item.Inclusion_Exclusion_Drug_Class__c ==LABEL3 && item.Apply_Limitations__c == YES && item.Drug_List__r.Name == DL1){
                                item.Maximum_Days__c = druglst_dcdl.get(dcRecord.id).Maximum_days_supply__c;
                                dcdlItem = new DC_Drug_List_Group__c(id = item.Id, Maximum_Days__c = item.Maximum_Days__c);
                                dcdruglist.add(dcdlItem);
                            }   
                            
                        }
                        update dcdruglist;
                    }
                    //Added By Nitish Request - 06819
                    
                    if(checkDiabeticPlan2){
                        for(DC_Drug_List_Group__c dcdl :druglst_dcdl.get(dcRecord.id).DC_Drug_List__r){
                            if(dcdl.Drug_Group__r.Name!= DCA0000705 && dcdl.Drug_Group__r.Name!= DCA0028610 || dcdl.Drug_Group__c == Null){
                                dcdl2Delete.add(dcdl);
                                
                             }
                         }
                    }
                   
                }
                for(Clinical_Program_Group_Junction__c tempCPjunction : listCRD[0].Clinical_Program_Group_Junction__r){
                    if(CRD.Do_you_want_to_do_Save_A_Copay__c == NO && (tempCPjunction.Record_Type__c == SAC || tempCPjunction.Record_Type__c == null)){//Richa added the null check condition to delete blank records
                        clPrgmgrpjnctns.add(tempCPjunction);
                    }else if(clinicalProgramname.contains(tempCPjunction.Clinical_Program_Group_Name__c)){
                        clPrgmgrpjnctns.add(tempCPjunction);
                        
                    }
                    else{
                        
                        if(checkCPgroupfullyinsd && tempCPjunction.Record_Type__c == RXCHECK) {                 
                            
                            clPrgmgrpjnctns.add(tempCPjunction);
                        }
                        clinicalProgramname.add(tempCPjunction.Clinical_Program_Group_Name__c);
                    }
                } 
             
            /** Delete the Accumulations Records in case CRD-Integrate With Medical is Yes, Plan Platform is Non ASH; and in Accumulations either of the 3 fields 
"Are there any drug specific deductibles?"  or “Are there any drug specific MAB?” or "Are there any drug specific MOOP?" is not checked **/
                //Added By Nitish for 7094
                if(mapval.ContainsKey(ASD)){
                    asdRecType = new set<string>();
                    for(Mapping_Values__c mv : mapval.get(ASD)){
                        if(mv.Creates_Record__c){
                            asdRecType.add(mv.ParentMappingValue__r.RecordTypeId__c);
                        }
                    }
                }
                for(accumulations__c accumRec : crd.accumulations__r){
                    if((crd.integrate_with_medical__c != NULL && crd.integrate_with_medical__c == 'Yes') && (crd.plan_platform__c != NULL && crd.plan_platform__c != 'Aetna Student Health') && (!mapVal.containsKey(ASD) || (mapVal.containsKey(ASD) && asdRecType.size()>0 && !asdRecType.contains(null) && !asdRecType.contains(string.valueof(accumRec.RecordTypeId))))){
                        if ((accumRec.Are_there_any_drug_specifc_MOOP__c != TRUE) && (accumRec.Are_there_any_drug_specific_deductibles__c != TRUE) && (accumRec.Are_there_any_drug_specific_MAB__c != TRUE) ){
                            accumsToDelete.add(accumRec);
                        }
                    }
                }   
              
                
                //Delete the Drug Specific Copay Records in case Mail/Retail/paper/papr OOn/Specialty/Specialty OON is false
                
                for(Drug_Specific_Copay__c dsCopay: crd.Drug_Specific_Copay_s__r){
                    dsclist.add(dsCopay);
                    if(!crd.Plan_Type_Mail__c && dsCopay.RecordType.Name == MAILLABEL){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                    if(!crd.Plan_Type_Paper__c && dsCopay.RecordType.Name == PAPERLABEL){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                    if(!crd.Plan_Type_Paper_Out_of_Network__c && dsCopay.RecordType.Name == PAPEROON){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                    if(!crd.Plan_Type_Retail__c && dsCopay.RecordType.Name == RETAILLABEL){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                    if(!crd.Plan_Type_Specialty__c && dsCopay.RecordType.Name == SPECIALITY){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                    if(!crd.Plan_Type_Specialty_OON__c && dsCopay.RecordType.Name == SPECIALITYOON){
                        lstDSCopay2delete.add(dsCopay);
                        dscId.add(dsCopay.id);
                    }
                }
                
                for(Network_Junction__c njunct : crd.Network_Junctions__r){
                    if(crd.Plan_Type_Mail__c == true){
                        njunct.CRD_ID__c = crd.id;
                        njunct.Network_Mail__c = STANDARD;
                    }
                    lstJunctUpdate.add(njunct); 
                }
                for(CRD_PriorAuth_Junction__c lstPrior : crd.CRD_PriorAuth_Junction__r){
                    lstDelete.add(lstPrior);
                }
                
                if(lstJunctUpdate.size()== 0){
                    if(crd.Plan_Type_Mail__c == true){
                        Network_Junction__c netJunction = new  Network_Junction__c();
                        netJunction.CRD_ID__c = crd.id;
                        netJunction.Network_Mail__c = STANDARD;
                        lstJunction.add(netJunction);
                        
                    }
                }
                if(crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED){
                    if((crd.Plan_Platform__c == ASH || crd.Plan_Platform__c == 'Aetna Global Benefits') || (crd.PSU__c == LABEL5 || crd.PSU__c == LABEL6)){
                        crd.Do_Prescription_Savings_Program__c = NO;
                    }else{
                        crd.Do_Prescription_Savings_Program__c = YES;
                        crd.PSP_Override_Option__c = NO;
                        for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                            Clinical_Program_Group_Junction__c cpGroupJunction = new Clinical_Program_Group_Junction__c();
                            cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                            cpGroupJunction.CRD_ID__c = crd.Id;
                            cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                            cpGroupJunction.Record_Type__c = PSP;
                            if(cpGroup.Clinical_Program_Group_Name__c == LABEL7){
                                cpGroupJunction.Selected__c = true;
                            }
                            lstGroupJ.add(cpGroupJunction);
                        }
                    }
                }else if(crd.Insured_Type__c == SELFINSURED){
                    crd.Do_Prescription_Savings_Program__c = NO;
                }                   
                if(crd.Contract_State__c == IL && (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) && crd.Plan_Type_Paper_Out_of_Network__c){
                    crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = APPLIES;
                }else{
                    crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
                }
                //crd.Retail_Source_AWP__c =true;Richa commented on 5/8 as this would be done by Mapping Values 
                if(crd.Plan_Type_Paper__c == true){
                    crd.Bypass_DMR__c = 15;
                }
                if(crd.COB_or_MOB__c == COB && crd.Plan_Type_Paper_Out_of_Network__c){
                    crd.Out_of_Network__c = true;
                    crd.Out_of_Network_Reimbursement_Level__c = INNETWORKREIMBURSEMENTLEVEL; // Implemented Request 05103 by Sushant
                }
                
                if(crd.Plan_Type_Retail__c == true){
                    crd.Brands_DAW_5_take_a_gen_copay_Retail__c = true;
                }
                if(crd.Plan_Type_Mail__c == true){
                    crd.Brands_DAW_5_take_a_gen_copay_Mail__c = true;
                }
                if(crd.Plan_Type_Specialty__c == true ){
                    crd.Brands_DAW_5_take_a_gen_copay_Speciality__c = true;
                }
                if(crd.Plan_Type_Specialty_OON__c == true){
                    crd.Brands_w_DAW_5_take_a_generic_copay_spec__c = true;
                }
                if(crd.Plan_Type_Paper__c == true){
                    crd.Brands_DAW_5_take_a_gen_copay_Paper__c = true;
                } 
                if(crd.Plan_Type_Paper_Out_of_Network__c == true){
                    crd.Brands_w_DAW_5_take_a_generic_copay__c = true;
                }
                crdListUpdate.add(crd);
            }   
        }  
        list<sobject> objectUpdate = new list<sobject>();
        list<sobject> objectinsert = new list<sobject>();
        list<sobject> objectdelete = new list<sobject>();
        if(crdListUpdate.size()>0){
            for(sobject tempobj : crdListUpdate)
                objectUpdate.add(tempobj);
        }
        //updatecopaylist.add(copay);
       
        if(accumsToDelete.size()>0){
            for(sObject tempobj : accumsToDelete){
                objectdelete.add(tempobj);
            }
        }
        
        if(updatecopaylist.size()>0){
            for(sobject tempobj : updatecopaylist)
                objectUpdate.add(tempobj);
        }
        if(dCoverage.size()>0){
            for(sobject tempobj : dCoverage)
                objectUpdate.add(tempobj);
        }
        if(lstJunctUpdate.size()>0){
            for(sobject tempobj : lstJunctUpdate)
                objectUpdate.add(tempobj);
        }
        if(lstSafety.size()>0){
            for(sobject tempobj : lstSafety)
                objectinsert.add(tempobj);
        }
        if(lstJunction.size()>0){
            for(sobject tempobj : lstJunction)
                objectinsert.add(tempobj);
        }
        if(lstGroupJ.size()>0){
            for(sobject tempobj : lstGroupJ)
                objectinsert.add(tempobj);
        }
        if(lstWod.size() > 0){
            for(sobject tempobj : lstWod)
                objectinsert.add(tempobj);
        }
        if(diabeticDCDLToInsert.size()>0){
            for(sobject tempobj : diabeticDCDLToInsert){
                  objectinsert.add(tempobj);
            }
        }
        if(lstDSCopay2delete.size() > 0){
            for(sobject tempobj : lstDSCopay2delete)
                objectdelete.add(tempobj);
              
        }
        if(delWODs.size() > 0){
            for(sobject tempobj : delWODs)
                objectdelete.add(tempobj);
        }
        if(dcdl2Delete.size() > 0){               
            for(sobject tempobj : dcdl2Delete)
                objectdelete.add(tempobj);
        }
        if(dCoverage2Delete.size() > 0){
            for(sobject tempobj : dCoverage2Delete)
                objectdelete.add(tempobj);
        }
        if(listCRD[0].Save_A_Copay_Junction__r.size() > 0)
            for(sobject tempobj : listCRD[0].Save_A_Copay_Junction__r)
            objectdelete.add(tempobj);
        
        if(objectUpdate.size() > 0){
            update objectUpdate;
        }
        if(objectinsert.size() > 0){
            Database.insert (objectinsert,false);
        }
        
        if(clPrgmgrpjnctns.size() > 0){
            for(sobject tempobj : clPrgmgrpjnctns){
                objectdelete.add(tempobj);
            }
        }
        if(lstDelete.size()>0){
            for(sobject tempobj : lstDelete){
                objectdelete.add(tempobj);
            }
        }
        if(objectdelete.size()  > 0 ){
            delete objectdelete;
        }
        
        
        
        
        ///Chetan, 08/20/2014 - Accum Delete Logic
        //If "ALL" have value in any of the field (Start Month, Start Date, When will the Accumulations renew?, Accumulation End date, Carry Balance when member moves ), 
        //Then delete rest others , -------> 
        //ELSE ----> keep "ALL" , delete others if any of have not null in (Start Month, Start Date, When will the Accumulations renew?,
        // Accumulation End date, Carry Balance when member moves ) 
        /*   Map<String,Accumulations__c> mapRtToAccum = new Map<String,Accumulations__c>();
for(Accumulations__c accum : [Select
Id, Start_Day__c, Start_Month_New__c, When_will_the_Accumulations_renew__c, Accumulation_End_Date__c
, Carry_Balance_when_member_moves__c, RecordType.Name
From
Accumulations__c
Where
CRD_ID__c =: CRDRecordID]){
mapRtToAccum.put(accum.recordType.Name, accum);
}
//for Req-5003 to update the MAC At Mail Applies field on CRD
GC_Utils_Method gcMethodCall = new GC_Utils_Method();
gcMethodCall.setMACatMailApplies(listCRD[0],listCRD[0].Copay_Tiers__r,mapRtToAccum.values());

List<Accumulations__c> accumsToDelete  = new List<Accumulations__c>();
if(! mapRtToAccum.isEmpty()){
//Logic - 1 if "ALL" has any of the field populated then delete rest
boolean metIndividualLogic = false;
boolean metFamilyLogic = false;
List<String> otherIndividuals = new List<String>{'Individual - Mail', 'Individual - Retail', 'Individual - Specialty'};
if(mapRtToAccum.containsKey('Individual - All')){
Accumulations__c accum = mapRtToAccum.get('Individual - All');
if(accum.Start_Day__c != null || accum.Start_Month_New__c != null 
|| accum.When_will_the_Accumulations_renew__c != null ||accum.Accumulation_End_Date__c != null
|| accum.Carry_Balance_when_member_moves__c != null ){
for(String rt : otherIndividuals){
if(mapRtToAccum.containsKey(rt)){
accumsToDelete.add(mapRtToAccum.get(rt));
}
}
metIndividualLogic = true;
}else{
accumsToDelete.add(accum);
}

}

List<String> otherFamilies = new List<String>{'Family - Mail', 'Family - Retail', 'Family - Specialty'};
if(mapRtToAccum.containsKey('Family - All')){
Accumulations__c accum = mapRtToAccum.get('Family - All');
if(accum.Start_Day__c != null || accum.Start_Month_New__c != null 
|| accum.When_will_the_Accumulations_renew__c != null ||accum.Accumulation_End_Date__c != null
|| accum.Carry_Balance_when_member_moves__c != null ){
for(String rt : otherFamilies){
if(mapRtToAccum.containsKey(rt)){
accumsToDelete.add(mapRtToAccum.get(rt));
}
}
metFamilyLogic = true;
}else{
accumsToDelete.add(accum);
}
}

//Logic - 2 , if '1' does not met then validate every record type and delete if any of null
if(! metIndividualLogic){
for(String rt : otherIndividuals){
if(mapRtToAccum.containsKey(rt)){
Accumulations__c accum = mapRtToAccum.get(rt);
if(accum.Start_Day__c == null || accum.Start_Month_New__c == null 
|| accum.When_will_the_Accumulations_renew__c == null ||accum.Accumulation_End_Date__c == null
|| accum.Carry_Balance_when_member_moves__c == null ){
accumsToDelete.add(accum);
}
}
}
}

if(! metFamilyLogic){
for(String rt : otherFamilies){
if(mapRtToAccum.containsKey(rt)){
Accumulations__c accum = mapRtToAccum.get(rt);
if(accum.Start_Day__c == null || accum.Start_Month_New__c == null 
|| accum.When_will_the_Accumulations_renew__c == null ||accum.Accumulation_End_Date__c == null
|| accum.Carry_Balance_when_member_moves__c == null ){
accumsToDelete.add(accum);
}
}
}
}

}

delete accumsToDelete; */
        
        
        /*              
//Added by JR to implement Formulary code logic
if(!provFormullaryMap.isEmpty() && ! specialityDrugListIds.isEmpty()){

String formularyId, formularyStatus;
List<Drug_Coverage__c>lstToUpdateDC = new List<Drug_Coverage__c>();
for(Formulary_Cross_Walk__c fc : [select Specialty_Drug_List__c,Formulary__c,Formulary_Open_Closed__c, Provision_134_Line_Value_Number__c 
from Formulary_Cross_Walk__c 
where Segment__c Includes (:listCRD[0].National__c) AND Contract_State__c Includes (:listCRD[0].Contract_State__c) 
AND Funding__c Includes (:listCRD[0].Insured_Type__c) AND Carrier__c Includes (:listCRD[0].Plan_Platform__c) 
AND Retail_Copay_Tiers_unless_Mail_Only_Pl__c =:copayTierunlessMail AND Specialty_Copay_Tiers__c =:copayTierSpeciality 
AND Provision_134_Line_Value_Number__c IN :provFormullaryMap.keyset() AND Specialty_Drug_List__c IN :specialityDrugListIds]
){
formularyId = fc.Formulary__c;
formularyStatus = fc.Formulary_Open_Closed__c;


if(provFormullaryMap.containsKey(Integer.valueOf(fc.Provision_134_Line_Value_Number__c))){
provFormullaryMap.get(Integer.valueOf(fc.Provision_134_Line_Value_Number__c)).processed__c = true;
}                      
}

for(Drug_Coverage__c dc : listCRD[0].Drug_Coverage__r){
dc.Formulary__c = formularyId;
dc.Formulary_Open_Closed__c = formularyStatus;
lstToUpdateDC.add(dc);
}  
Database.update(lstToUpdateDC, false);
update provFormullaryMap.values();

}*/
        
        //Logic to Cleanup junction records and create new ST/PA/QL junctions
        Boolean ProcessJunctionRecords = False;
        set<Id> setformularyName = new set<Id>();
        List<CRD_PriorAuth_Junction__c> paJuncDel = new  List<CRD_PriorAuth_Junction__c>();
        List<CRD_Quantity_Limit_Junction__c> qlJuncDel = new  List<CRD_Quantity_Limit_Junction__c>();
        List<CRD_Step_Therapy_Junction__c> stJuncDel = new  List<CRD_Step_Therapy_Junction__c>();
        List<Drug_coverage__c> drugCoverageList = new List<Drug_coverage__c>();
        //Added by JR
        List<Clinical_Program_Group_Junction__c> sacJuncDel = new  List<Clinical_Program_Group_Junction__c>();
        Set<String> dlPrecert = new Set<String>();
        Set<String> dlQuantityLimit = new Set<String>();
        Set<String> dlStepTherapy = new Set<String>();
        //Added by JR
        List<String> CGsaveAcopay = new List<String>();
        Set<ID> DrugCwithDL0000848 = new Set<ID>();
        Set<String> formularyGroup = new set<String>();
        //Select the Formularies from Drug Coverage
        List<Drug_Coverage__c> listDCRecords = new List<Drug_Coverage__c>();
        map<ID,String> mapDC2Formulary = new map<ID,String>();
        Map<Id,Drug_Coverage__c> mapid2DrugCoverage = new Map<Id,Drug_Coverage__c>();
        for(Drug_Coverage__c dcRecord : [Select Id, name, Formulary__c,Formulary__r.group__c,Formulary_Group__c, Formulary_ID__c, Formulary_Open_Closed__c,RecordTypeID,recordtype.name,Standard_Refill_too_Soon__c
                                         ,Custom_Refill_too_Soon__c,Formulary__r.Name,Aetna_Specialty_Care_Rx__c,Specialty_Drug_List_ID_From_Mapping__c,Secondary_Aetna_Specialty_Care_Rx__c
                                         ,Secondary_of_fills_before_Force_to_SPN__c,Speciality_Drug_List__c
                                         ,(Select Id,Name,Drug_List_Name__c,Related_Drug_Coverage__c,Inclusion_Exclusion__c,Drug_List__r.name 
                                           From 
                                           DC_Drug_List__r 
                                           where 
                                           Drug_List__r.name = 'DL-0000848')
                                         From 
                                         Drug_Coverage__c 
                                         where 
                                         crd_id__c =: CRDRecordID]){   
                                             //setformularyName.add(dcRecord.Formulary__c);
                                             listDCRecords.add(dcRecord);
                                             //formularyGroup.add(dcRecord.Formulary__r.group__c);
                                             for(DC_Drug_List_Group__c currentDCDL : dcRecord.DC_Drug_List__r){
                                                 if(currentDCDL.Inclusion_Exclusion__c != PAR){
                                                     DrugCwithDL0000848.add(dcRecord.id);
                                                 }
                                             }
                                         }
        for(Drug_Coverage__c currentRecord: listDCRecords){
            //Sushant: Added below section for ST#1057 to make Aetna_Specialty_Care_Rx__c and Speciality_Drug_List__c follow mapping logic **start**
            string AetnaSpecialtyCareRxMapping = BLANK;
            list<string> AetnaSpecialtyCareRxSplitArray = new list<string>();
            string SpecialtyDrugListMapping = BLANK;
            list<string> SpecialtyDrigListArray = new list<string>();
            if(currentRecord.recordtype.name == RETAILLABEL){
                
                //Derrive value of Aetna_Specialty_Care_Rx__c and Speciality_Drug_List__c from mapping values
                if(currentRecord.Aetna_Specialty_Care_Rx__c != NULL){
                    AetnaSpecialtyCareRxMapping = string.valueOf(currentRecord.Aetna_Specialty_Care_Rx__c);
                    AetnaSpecialtyCareRxSplitArray = AetnaSpecialtyCareRxMapping.split('\\|\\|');
                    
                }
                if(currentRecord.Specialty_Drug_List_ID_From_Mapping__c != NULL){
                    SpecialtyDrugListMapping = string.valueOf(currentRecord.Specialty_Drug_List_ID_From_Mapping__c);
                    SpecialtyDrigListArray = SpecialtyDrugListMapping.split('\\|\\|');
                    
                }
                
                //Check if DCDL has Inclusion_Exclusion__c != Prior Authorization Required
                if(DrugCwithDL0000848.contains(currentRecord.id)){
                    //Set value of Aetna_Specialty_Care_Rx__c
                    if(AetnaSpecialtyCareRxSplitArray.size() > 0 ){
                        if(AetnaSpecialtyCareRxSplitArray.size() > 1){
                            currentRecord.Aetna_Specialty_Care_Rx__c = AetnaSpecialtyCareRxSplitArray[1];
                            
                        }else if(AetnaSpecialtyCareRxSplitArray.size() == 1){
                            currentRecord.Aetna_Specialty_Care_Rx__c = AetnaSpecialtyCareRxSplitArray[0];
                            
                        }
                        
                    }
                    //Set Value of Speciality_Drug_List__c
                    if(SpecialtyDrigListArray.size() > 0){
                        if(SpecialtyDrigListArray.size() > 1){
                            currentRecord.Speciality_Drug_List__c = SpecialtyDrigListArray[1];
                            retailSpecialty = SpecialtyDrigListArray[1];
                            
                        }else if(SpecialtyDrigListArray.size() == 1){
                            currentRecord.Speciality_Drug_List__c = SpecialtyDrigListArray[0];
                            retailSpecialty = SpecialtyDrigListArray[0];
                            
                        }
                        
                    }
                    
                }else{
                    if(AetnaSpecialtyCareRxSplitArray.size() > 0){
                        currentRecord.Aetna_Specialty_Care_Rx__c = AetnaSpecialtyCareRxSplitArray[0];
                    }
                    if(SpecialtyDrigListArray.size() > 0){
                        currentRecord.Speciality_Drug_List__c = SpecialtyDrigListArray[0].trim();
                        retailSpecialty = SpecialtyDrigListArray[0].trim();
                        
                    }
                    
                }
            }
            mapid2DrugCoverage.put(currentRecord.id,currentRecord);
            //listDCRecords.add(currentRecord);
        }   
        //Sushant: Added above section for ST#1057 to make Aetna_Specialty_Care_Rx__c and Speciality_Drug_List__c follow mapping logic **end**
        integer  copayTierunlessMail = copayTierRetail == 0 ? copayTierMail : copayTierRetail;
        //Added by Amit for Requesr 5460
        //Logic to map Formulary for mail and Retail Drug Coverage Record
        if(!provFormullaryMap.isEmpty()){ 
            String mailformularyId, mailformularyStatus,retailformularyId,retailformularyStatus;
            List<Drug_Coverage__c>lstToUpdateDC = new List<Drug_Coverage__c>();
            map<String,String> mapFormulary2Group = new map<String,String>();
            //Added By Nitish for ST#2577 Story 2
            if(string.isEmpty(string.valueof(listCRD[0].Plan_Platform__c))){
                 for(Formulary_Cross_Walk__c fc : [select Id,name,Specialty_Drug_List__c,Formulary__c,Formulary_Open_Closed__c, Provision_134_Line_Value_Number__c 
                                              ,Tier_1__c,Tier_3__c,Retail_Copay_Tiers_unless_Mail_Only_Pl__c,Formulary__r.group__c,Formulary__r.Formulary_Description__c
                                              from Formulary_Cross_Walk__c 
                                              where Segment__c Includes (:listCRD[0].National__c) AND Contract_State__c Includes (:listCRD[0].Contract_State__c) 
                                              AND Funding__c Includes (:listCRD[0].Insured_Type__c) AND Carrier__c Includes (:ALL)
                                              AND (Retail_Copay_Tiers_unless_Mail_Only_Pl__c =:copayTierMail OR Retail_Copay_Tiers_unless_Mail_Only_Pl__c =:copayTierRetail)
                                              AND Specialty_Copay_Tiers__c =:copayTierSpeciality 
                                              AND Provision_134_Line_Value_Number__c IN :provFormullaryMap.keyset()]
               ){  
                   mapFormulary2Group.put(fc.Formulary__c,fc.Formulary__r.group__c); 
                   
                   if(/*fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierunlessMail &&*/ fc.Specialty_Drug_List__c!= Null && fc.Specialty_Drug_List__c == retailSpecialty ){
                       if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail && fc.Tier_1__c== Null && fc.Tier_3__c== Null){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail && fc.Tier_1__c== Null && fc.Tier_3__c== Null){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }else if(((retailSpecialty!= '' && retailSpecialty !=fc.Specialty_Drug_List__c) || fc.Specialty_Drug_List__c== Null)&& fc.Tier_1__c!= Null && fc.Tier_3__c!= Null){
                       if(fc.Tier_1__c == mailTier1 && fc.Tier_3__c == mailTier3 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Tier_1__c == retailTier1 && fc.Tier_3__c == retailTier3 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }else if(((retailSpecialty!= '' && retailSpecialty !=fc.Specialty_Drug_List__c) || fc.Specialty_Drug_List__c== Null) && fc.Tier_1__c!= Null && fc.Tier_3__c== Null){
                       if(fc.Tier_1__c == mailTier1 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Tier_1__c == retailTier1 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }
                   else if((fc.Specialty_Drug_List__c== Null)&& fc.Tier_1__c== Null && fc.Tier_3__c== Null 
                            && provFormullaryMap.containsKey(Integer.valueOf(fc.Provision_134_Line_Value_Number__c))){
                                if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                                    mailformularyId = fc.Formulary__c;
                                    mailformularyStatus = fc.Formulary_Open_Closed__c;
                                }if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                                    retailformularyId = fc.Formulary__c;
                                    retailformularyStatus = fc.Formulary_Open_Closed__c;
                                }
                            }
                   //Update the processed Flag on PFR's
                   if(provFormullaryMap.containsKey(Integer.valueOf(fc.Provision_134_Line_Value_Number__c))){
                       provFormullaryMap.get(Integer.valueOf(fc.Provision_134_Line_Value_Number__c)).processed__c = true;
                   }                      
                }
            }
            else{
            
            
            
            
            
            for(Formulary_Cross_Walk__c fc : [select Id,name,Specialty_Drug_List__c,Formulary__c,Formulary_Open_Closed__c, Provision_134_Line_Value_Number__c 
                                              ,Tier_1__c,Tier_3__c,Retail_Copay_Tiers_unless_Mail_Only_Pl__c,Formulary__r.group__c,Formulary__r.Formulary_Description__c
                                              from Formulary_Cross_Walk__c 
                                              where Segment__c Includes (:listCRD[0].National__c) AND Contract_State__c Includes (:listCRD[0].Contract_State__c) 
                                              AND Funding__c Includes (:listCRD[0].Insured_Type__c) AND Carrier__c Includes (:listCRD[0].Plan_Platform__c)
                                              AND (Retail_Copay_Tiers_unless_Mail_Only_Pl__c =:copayTierMail OR Retail_Copay_Tiers_unless_Mail_Only_Pl__c =:copayTierRetail)
                                              AND Specialty_Copay_Tiers__c =:copayTierSpeciality 
                                              AND Provision_134_Line_Value_Number__c IN :provFormullaryMap.keyset()]
               ){  
                   mapFormulary2Group.put(fc.Formulary__c,fc.Formulary__r.group__c); 
                   if(/*fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierunlessMail &&*/ fc.Specialty_Drug_List__c!= Null && fc.Specialty_Drug_List__c == retailSpecialty ){
                       if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail && fc.Tier_1__c== Null && fc.Tier_3__c== Null){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail && fc.Tier_1__c== Null && fc.Tier_3__c== Null){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }else if(((retailSpecialty!= '' && retailSpecialty !=fc.Specialty_Drug_List__c) || fc.Specialty_Drug_List__c== Null)&& fc.Tier_1__c!= Null && fc.Tier_3__c!= Null){
                       if(fc.Tier_1__c == mailTier1 && fc.Tier_3__c == mailTier3 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Tier_1__c == retailTier1 && fc.Tier_3__c == retailTier3 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }else if(((retailSpecialty!= '' && retailSpecialty !=fc.Specialty_Drug_List__c) || fc.Specialty_Drug_List__c== Null) && fc.Tier_1__c!= Null && fc.Tier_3__c== Null){
                       if(fc.Tier_1__c == mailTier1 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                           mailformularyId = fc.Formulary__c;
                           mailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                       if(fc.Tier_1__c == retailTier1 && fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                           retailformularyId = fc.Formulary__c;
                           retailformularyStatus = fc.Formulary_Open_Closed__c;
                       }
                   }
                   else if((fc.Specialty_Drug_List__c== Null)&& fc.Tier_1__c== Null && fc.Tier_3__c== Null 
                            && provFormullaryMap.containsKey(Integer.valueOf(fc.Provision_134_Line_Value_Number__c))){
                                if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierMail){
                                    mailformularyId = fc.Formulary__c;
                                    mailformularyStatus = fc.Formulary_Open_Closed__c;
                                }if(fc.Retail_Copay_Tiers_unless_Mail_Only_Pl__c == copayTierRetail){
                                    retailformularyId = fc.Formulary__c;
                                    retailformularyStatus = fc.Formulary_Open_Closed__c;
                                }
                            }
                   //Update the processed Flag on PFR's
                   
                   if(provFormullaryMap.containsKey(Integer.valueOf(fc.Provision_134_Line_Value_Number__c))){
                       provFormullaryMap.get(Integer.valueOf(fc.Provision_134_Line_Value_Number__c)).processed__c = true;
                   }                      
               }
            }
            //Update the matching Formularies on Drug Coverage records
            for(Drug_Coverage__c dc : listCRD[0].Drug_Coverage__r){
                if(dc.recordtype.name == MAILLABEL && mailformularyId!= BLANK && mailformularyId!=null){
                    dc.Formulary__c = mailformularyId;
                    dc.Formulary_Open_Closed__c = mailformularyStatus;
                    setformularyName.add(mailformularyId);//Added by Amit for ST# 1057 on 1 June, 2016
                    formularyGroup.add(mapFormulary2Group.get(mailformularyId));//Added by Amit for ST# 1057 on 1 June, 2016
                    mapDC2Formulary.put(dc.id,mailformularyId);//Added by Amit for ST# 1057 on 1 June, 2016
                }else if(dc.recordtype.name == RETAILLABEL && retailformularyId!= BLANK && retailformularyId!=null){
                    dc.Formulary__c = retailformularyId;
                    dc.Formulary_Open_Closed__c = retailformularyStatus;
                    setformularyName.add(retailformularyId);//Added by Amit for ST# 1057 on 1 June, 2016
                    formularyGroup.add(mapFormulary2Group.get(retailformularyId));//Added by Amit for ST# 1057 on 1 June, 2016
                    mapDC2Formulary.put(dc.id,retailformularyId);//Added by Amit for ST# 1057 on 1 June, 2016
                }
                //Added By Nitish 6821
                else if (dc.recordtype.name == RETAILLABEL && (retailformularyId == BLANK || retailformularyId ==null) && (retailformularyStatus != BLANK || retailformularyStatus != null)){
                    dc.Formulary_Open_Closed__c = retailformularyStatus;
                    if(checkDiabeticPlan2){
                        dc.Aetna_Specialty_Care_Rx__c = DOESNOTAPPLY;
                    }
                    setformularyName.add(retailformularyId);
                    formularyGroup.add(mapFormulary2Group.get(retailformularyId));
                    mapDC2Formulary.put(dc.id,retailformularyId);
                }
                else if (dc.recordtype.name == MAILLABEL && (mailformularyId == BLANK || mailformularyId ==null) && (mailformularyStatus != BLANK || mailformularyStatus != null)){
                    dc.Formulary_Open_Closed__c = mailformularyStatus;
                    setformularyName.add(mailformularyId);
                    formularyGroup.add(mapFormulary2Group.get(retailformularyId));
                    mapDC2Formulary.put(dc.id,retailformularyId);
                }
                // Added changes for 06877
                if(dc.recordtype.name == RETAILLABEL){
                    if(dc.Formulary__c!=null && dc.Max_Specialty_Day_Supply__c!=null && dc.Max_Specialty_Day_Supply__c == 90){
                        dc.Max_Specialty_Day_Supply__c = 90;
                    }
                    else{
                        dc.Max_Specialty_Day_Supply__c = 30;
                    }
                }
                lstToUpdateDC.add(dc);
            }
            
            Database.update(lstToUpdateDC, false);
            
            
            update provFormullaryMap.values();
            
        }

         
        //Ends
        //Added by Amit for request 05728
        // Logic to create CRD NPL Junction record for in case of commercial formulary based on Funding Type
        List<CRD_NPL_Junction__c> listNPL = new List<CRD_NPL_Junction__c>();
        CRD_NPL_Junction__c newNPLRecord;
       
        if(formularyGroup.contains(null) && (listCRD[0].Insured_Type__c == FULLYINSURED || listCRD[0].Insured_Type__c== SPLITFUNDED)){
            newNPLRecord = new CRD_NPL_Junction__c();
            newNPLRecord.CRD_ID__c = CRDRecordID;
            newNPLRecord.Drug_List__c = System.label.DCSRT50;
            newNPLRecord.IsStandard__c = True;
            newNPLRecord.Select__c = True;
            listNPL.add(newNPLRecord);
        }else if( formularyGroup.contains(null) && listCRD[0].Insured_Type__c == SELFINSURED){
            newNPLRecord = new CRD_NPL_Junction__c();
            newNPLRecord.CRD_ID__c = CRDRecordID;
            newNPLRecord.Drug_List__c = System.label.DCSRT51;
            newNPLRecord.IsStandard__c = True;
            newNPLRecord.Select__c = True;
            listNPL.add(newNPLRecord);
        }
        if(listNPL.size() > 0 ){
            insert listNPL;
        }
        //05728 Ends
        //Query on FormularyXCustomDL (ERD) Object
        
        Boolean deletePrecertList = False;
        Boolean deleteQuantityList = False;
        Boolean deleteSTList = False;
        Set<String> PRsafetyEdit = new Set<String>();
        Set<String> QLsafetyEdit = new Set<String>();
        
        id DLID  = [select id from drug_list__c where name = 'DL-0096566'].id;
        
        
        id DLID1 = [select id from drug_list__c where name = 'DL-0096567'].id;
        for(FormularyXCustomDL_ERD__c formulayCustom: [Select Id, name,Aetna_Specialty_Care_Rx__c, Formulary__c, Precert__c
                                                       , Quantity_Limit__c,Secondary_of_fills_before_Force_to_SPN__c, Secondary_Aetna_Specialty_Care_Rx__c 
                                                       , Secondary_Specialty_Drug_List__c,Specialty_Drug_List__c, Step_Therapy__c,Secondary_Specialty_Drug_List_ID__c,Save_A_Copay__c
                                                       , NPL_List__c,Refill_Too_Soon__c,Override_Refill_Too_Soon__c,PR_Safety_Edits__r.name,QL_Safety_Edits__r.name,Formulary__r.Name
                                                       ,QL_Safety_Edits__c,PR_Safety_Edits__c,Formulary__r.group__c
                                                       From 
                                                       FormularyXCustomDL_ERD__c
                                                       Where 
                                                       Formulary__c In: setformularyName]){
                                                        map<ID,String> mapFormulary2Group = new map<ID,String>();
                                                           mapFormulary2Group.put(formulayCustom.Formulary__c,formulayCustom.Formulary__r.group__c );
                                                           if(formulayCustom.Precert__c != Null && !(formularyGroup.contains('LG Premier Plus') && IsPrecert)){
                                                               //if(!(formularyGroup.contains('LG Premier Plus') && IsPrecert)){
                                                               deletePrecertList = True;
                                                               //}  
                                                               String[] precertDrugLists = formulayCustom.Precert__c.split(SPLIT);
                                                               for(String drugListprecert : precertDrugLists){
                                                                   dlPrecert.add(drugListprecert);
                                                               }
                                                           }
                                                           if(formulayCustom.PR_Safety_Edits__r.name != Null){
                                                               PRsafetyEdit.add(formulayCustom.PR_Safety_Edits__r.name);
                                                           }
                                                           if(formulayCustom.Quantity_Limit__c != Null){
                                                               deleteQuantityList = True;
                                                               String[] qlDrugLists = formulayCustom.Quantity_Limit__c.split(SPLIT);
                                                               for(String drugListQL : qlDrugLists){
                                                                   dlQuantityLimit.add(drugListQL);
                                                               }
                                                           }
                                                           
                                                           if(formulayCustom.QL_Safety_Edits__r.name != Null){
                                                               QLsafetyEdit.add(formulayCustom.QL_Safety_Edits__r.name);
                                                           }
                                                           if(formulayCustom.Step_Therapy__c != Null){
                                                               deleteSTList = True;
                                                               String[] stDrugLists = formulayCustom.Step_Therapy__c.split(SPLIT);
                                                               for(String drugListST : stDrugLists){
                                                                   dlStepTherapy.add(drugListST);
                                                               }
                                                           }
                                                           
                                                           //Added by JR
                                                           if(formulayCustom.Save_A_Copay__c != Null){
                                                               String sacClinicalGroup = formulayCustom.Save_A_Copay__c;
                                                               CGsaveAcopay.add(sacClinicalGroup);                    
                                                           }
                                                           
                                                           for(Drug_Coverage__c currentRecord: mapid2DrugCoverage.values()){
                                                            boolean testFlag = False;
                                                           if(currentRecord.recordtype.name == RETAILLABEL && mapDC2Formulary.get(currentRecord.id) == formulayCustom.Formulary__c){
                                                                    
                                                                   if((currentRecord.Aetna_Specialty_Care_Rx__c == FEDSLABEL1) || (currentRecord.Aetna_Specialty_Care_Rx__c == FEDSLABEL2) ){
                                                                         currentRecord.Aetna_Specialty_Care_Rx__c = FEDSLABEL3;
                                                                         currentRecord.Speciality_Drug_List__c = DLID;
                                                                         testFlag = true;
                                                                        }
                                                                    if(mapFormulary2Group.get(mapDC2Formulary.get(currentRecord.id))!= LGPREMIERPLUS ||
                                                                       mapFormulary2Group.get(mapDC2Formulary.get(currentRecord.id))!= SHPREMIERPLUS){                                                                       
                                                                   
                                                                       if(formulayCustom.Aetna_Specialty_Care_Rx__c!= Null && formulayCustom.Aetna_Specialty_Care_Rx__c!= BLANK && testFlag == false){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = formulayCustom.Aetna_Specialty_Care_Rx__c;
                                                                        }
                                                                    }
                                                                   
                                                                   if(mapFormulary2Group.get( mapDC2Formulary.get(currentRecord.id))!= LGPREMIERPLUS ||
                                                                      mapFormulary2Group.get(mapDC2Formulary.get(currentRecord.id))!= SHPREMIERPLUS){                                                                      
                                                                       if(formulayCustom.Secondary_of_fills_before_Force_to_SPN__c!= Null && formulayCustom.Secondary_of_fills_before_Force_to_SPN__c!= BLANK){
                                                                           currentRecord.Secondary_of_fills_before_force_to_SPN__c = Integer.ValueOF(formulayCustom.Secondary_of_fills_before_Force_to_SPN__c);
                                                                       }
                                                                       if(formulayCustom.Secondary_Aetna_Specialty_Care_Rx__c!= Null && formulayCustom.Secondary_Aetna_Specialty_Care_Rx__c!= BLANK){
                                                                           currentRecord.Secondary_Aetna_Specialty_Care_Rx__c = formulayCustom.Secondary_Aetna_Specialty_Care_Rx__c;
                                                                       }
                                                                       
                                                                       if(formulayCustom.Secondary_Specialty_Drug_List_ID__c != Null && formulayCustom.Secondary_Specialty_Drug_List_ID__c != BLANK){
                                                                           currentRecord.Secondary_Speciality_Drug_List__c = formulayCustom.Secondary_Specialty_Drug_List_ID__c ;
                                                                       }
                                                                       //currentRecord.Standard_Refill_too_Soon__c = formulayCustom.Override_Refill_Too_Soon__c;//Richa added for Req 5867                        
                                                                       //currentRecord.Custom_Refill_too_Soon__c = formulayCustom.Refill_Too_Soon__c;//Richa added for Req 5867
                                                                       if(currentRecord.Secondary_Aetna_Specialty_Care_Rx__c!= Null && currentRecord.Secondary_Aetna_Specialty_Care_Rx__c!= BLANK){
                                                                           currentRecord.Secondary_Force_to_Specialty__c = YES;
                                                                       }
                                                                   
                                                                   }
                                                                        
                                                                   //Check for DL and update Aetna Specialty Care Rx
                                                                   if(DrugCwithDL0000848.contains(currentRecord.id)){
                                                                       if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX1){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX2;
                                                                       }else if( currentRecord.Aetna_Specialty_Care_Rx__c == ASRX3){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c =  ASRX4;
                                                                       }else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX5){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX6;
                                                                       }else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX7){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX8;
                                                                       }else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX9){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX10;
                                                                       }else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX11){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX12;
                                                                       }
                                                                       else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX13){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX14;
                                                                       }
                                                                        else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX15){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX16;
                                                                       }
                                                                        else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX17){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX18;
                                                                       }
                                                                        else if(currentRecord.Aetna_Specialty_Care_Rx__c == ASRX19){
                                                                           currentRecord.Aetna_Specialty_Care_Rx__c = ASRX20;
                                                                       }
                                                                       else if(currentRecord.Aetna_Specialty_Care_Rx__c == FEDSLABEL3){
                                                                           currentRecord.Speciality_Drug_List__c = DLID1;
                                                                        }
                                                                        
                                                                   }
                                                                        
                                                                   //Added by Amit for request 5590 on 6 April, 2015
                                                                   if(formulayCustom.NPL_List__c!= Null){
                                                                       crdListUpdate[0].NPL_Drug_List__c = formulayCustom.NPL_List__c;
                                                                       crdListUpdate[0].NPL_Applies__c = YES;
                                                                   }
                                                                   //Ends
                                                                   //Added by Amit for ST# 465 on 19 Nov, 2015 - Also Req 6257 + ST 513 by Richa
                                                                   //crdListUpdate[0].PR_Safety_Edits_Drug_List__c = formulayCustom.PR_Safety_Edits__c; //Req 6257 + ST 513
                                                                   //crdListUpdate[0].QL_Safety_Edits_Drug_List__c = formulayCustom.QL_Safety_Edits__c; //Req 6257 + ST 513
                                                                   List<CRD_Standard_Safety_Edit_Junction__c> listSafetyEditJunc = new List<CRD_Standard_Safety_Edit_Junction__c>();
                                                                   for(CRD_Standard_Safety_Edit_Junction__c currentJuncRecord : lstSafety){
                                                                       currentJuncRecord.Select__c = False;
                                                                       listSafetyEditJunc.add(currentJuncRecord);
                                                                   }
                                                                   Database.update (listSafetyEditJunc,false);
                                                                   //Ends
                                                               }                    
                                                               if(currentRecord.recordtype.name != null && mapDC2Formulary.get(currentRecord.id) == formulayCustom.Formulary__c){
                                                                   currentRecord.Standard_Refill_too_Soon__c = formulayCustom.Override_Refill_Too_Soon__c;//Richa added for Req 5866                        
                                                                   currentRecord.Custom_Refill_too_Soon__c = formulayCustom.Refill_Too_Soon__c;//Richa added for Req 5866
                                                               }                    
                                                               mapid2DrugCoverage.put(currentRecord.id,currentRecord);
                                                           }
                                                           //Set flag to Process junction records
                                                           ProcessJunctionRecords = True;
                                                       }
        update mapid2DrugCoverage.values();
        update crdListUpdate; //Updated the CRD to update NPL Drug List, Added by Amit on 6th April, 2015
        set<string> setToAvoidDup = new set<string>();
        Set<String> settoAvoidDupQL=new Set<String>();//Added by Raj
        //Delete all the ST/PA/QL junction records with related CRD
        //updated by ankur to remove multiple soqls
        crd__C crdPLQAST = [select id,Precert_TOC_days__c,Standard_QL_List_or_Select_Classes__c,Standard_Precert_List_or_Select_Classes__c, (Select id,Precert_Class__c from CRD_PriorAuth_Junction__r )
                            ,(Select id,QL_Class__c from CRD_Quantity_Limit_Jucntion__r)
                            ,(Select id from CRD_Step_Therapy_Junction__r)
                            ,(Select id from Clinical_Program_Group_Junction__r)
                            ,(Select id,formulary_group__c from Drug_coverage__r)
                            From crd__C where id = :crdrecordid];
        //Commented for D-00607 (|| formularyGroup.contains(null))
        paJuncDel = crdPLQAST.CRD_PriorAuth_Junction__r;
        for(CRD_PriorAuth_Junction__c temp : crdPLQAST.CRD_PriorAuth_Junction__r){setToAvoidDup.add(temp.Precert_Class__c);}
        qlJuncDel = crdPLQAST.CRD_Quantity_Limit_Jucntion__r;
        //added by Raj Start
        for(CRD_Quantity_Limit_Junction__c temp : crdPLQAST.CRD_Quantity_Limit_Jucntion__r)
        {
            settoAvoidDupQL.add(temp.QL_Class__c);
        }
        //End
        stJuncDel = crdPLQAST.CRD_Step_Therapy_Junction__r ;
        if(ProcessJunctionRecords){
            
            if(paJuncDel!= Null && paJuncDel.size()>0 && deletePrecertList){                   
                delete paJuncDel;setToAvoidDup.clear();
            }
            
            if(qlJuncDel!= Null && qlJuncDel.size()>0 && deleteQuantityList){                     
                delete qlJuncDel;
                settoAvoidDupQL.clear();//Added by Raj
            }
            
            /* Below Condition was added for LG Formulary Plus Update, now commented : Sushant
drugCoverageList = crdPLQAST.Drug_Coverage__r ;
Boolean deleteST = False;
for(drug_coverage__c dc : drugCoverageList){
if(dc.formulary_group__c != 'LG Premier Plus'){
deleteST = TRUE;
break;
}
}
*/               
            if(stJuncDel!= Null && stJuncDel.size()>0 && deleteSTList){             
                Database.delete (stJuncDel,false);
            }
        }
        CRD_PriorAuth_Junction__c newPriorAuthRecord;
        CRD_Quantity_Limit_Junction__c newQuantityLimitRecord;
        CRD_Step_Therapy_Junction__c newStepTherapyRecord;
        List<CRD_PriorAuth_Junction__c> createPrecertRecords = new List<CRD_PriorAuth_Junction__c>();
        List<CRD_Quantity_Limit_Junction__c> createQLRecords = new List<CRD_Quantity_Limit_Junction__c>();
        List<CRD_Step_Therapy_Junction__c> createSTRecords = new List<CRD_Step_Therapy_Junction__c>();
        if(ProcessJunctionRecords){
            //Logic to create New Junction Records for ST/PA/QL
            Map<String,ID> mapdlName2Id = new map<String,ID>();
            //Added by Amit for Request 6037, ST# 312 on 16 Sep, 2015           
            if(formularyGroup.contains('LG Premier') && crdPLQAST.Precert_TOC_days__c > 0){            
                dlPrecert.add(PrecertTOCDL);
            }
            //Ends    
            for(Drug_List__c dlrecord: [Select Id,Name from Drug_List__c where Name =: dlPrecert OR Name =: dlStepTherapy OR Name =: dlQuantityLimit OR Name =:PRsafetyEdit OR Name = :QLsafetyEdit]){
                mapdlName2Id.put(dlrecord.Name, dlrecord.id );
            }
            
            //Create PriorAuth Records only if Is There Precert is 'Yes'
            if(IsPrecert && !formularyGroup.contains('LG Premier Plus') && !formularyGroup.contains(SHPREMIERPLUS)){
                for(String PrecertRecord : dlPrecert){
                    newPriorAuthRecord = new CRD_PriorAuth_Junction__c();
                    newPriorAuthRecord.CRD_ID__c = CRDRecordID;
                    newPriorAuthRecord.IsAutoPopulated__c = True;
                    newPriorAuthRecord.Precert_Class__c = mapdlName2Id.get(PrecertRecord);
                    if(!setToAvoidDup.contains(mapdlName2Id.get(PrecertRecord))){
                        createPrecertRecords.add(newPriorAuthRecord);
                        setToAvoidDup.add(mapdlName2Id.get(PrecertRecord));
                    }
                }
            }
            
            for(String PrecertRecord : PRsafetyEdit){
                newPriorAuthRecord = new CRD_PriorAuth_Junction__c();
                newPriorAuthRecord.CRD_ID__c = CRDRecordID;
                newPriorAuthRecord.IsAutoPopulated__c = True;
                newPriorAuthRecord.Precert_Class__c = mapdlName2Id.get(PrecertRecord);
                if(!setToAvoidDup.contains(mapdlName2Id.get(PrecertRecord))){
                    createPrecertRecords.add(newPriorAuthRecord);
                    setToAvoidDup.add(mapdlName2Id.get(PrecertRecord));
                }
            }
            //Create QuantityLimit Records only if Is There Precert is 'Yes' and not checking Are there quanity Limits?. This is as per the design template provided
            if(IsPrecert && !formularyGroup.contains('LG Premier Plus') && !formularyGroup.contains(SHPREMIERPLUS)){
                for(String QLRecord : dlQuantityLimit){
                    newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c();
                    newQuantityLimitRecord.CRD_ID__c = CRDRecordID;
                    newQuantityLimitRecord.IsAutoPopulated__c = True;
                    newQuantityLimitRecord.QL_Class__c = mapdlName2Id.get(QLRecord);
                    //createQLRecords.add(newQuantityLimitRecord);
                    //Added by Raj Start
                    if(!setToAvoidDupQL.contains(mapdlName2Id.get(QLRecord)))
                    {
                        createQLRecords.add(newQuantityLimitRecord);
                        setToAvoidDupQL.add(mapdlName2Id.get(QLRecord));
                    }
                    //End
                    
                }
            }
            if(!(formularyGroup.contains('LG Premier Plus') && !formularyGroup.contains(SHPREMIERPLUS) && IsPrecert)){
                for(String QLRecord : QLsafetyEdit){
                    newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c();
                    newQuantityLimitRecord.CRD_ID__c = CRDRecordID;
                    newQuantityLimitRecord.IsAutoPopulated__c = True;
                    newQuantityLimitRecord.QL_Class__c = mapdlName2Id.get(QLRecord);
                    //createQLRecords.add(newQuantityLimitRecord);
                    //Added code by Raj Start
                    if(!setToAvoidDupQL.contains(mapdlName2Id.get(QLRecord)))
                    {
                        createQLRecords.add(newQuantityLimitRecord);
                        setToAvoidDupQL.add(mapdlName2Id.get(QLRecord));
                    }
                    //End
                }
            }
            //Create Step Therapy Records only if Is there Step Therapy is 'Yes'
            if(IsStepTherapy){
                for(String STRecord : dlStepTherapy){
                    newStepTherapyRecord = new CRD_Step_Therapy_Junction__c();
                    newStepTherapyRecord.CRD_ID__c = CRDRecordID;
                    newStepTherapyRecord.IsAutoPopulated__c = True;
                    newStepTherapyRecord.Step_Therapy_DrugList_Class__c = mapdlName2Id.get(STRecord);
                    createSTRecords.add(newStepTherapyRecord);
                }
            }
        }
        //Modified by Amit on 18 May 2015
        //Added Formulary extension logic for request 5755
        if(formularyGroup.contains(null)){
            for(ST_PA_QL_Auto_Populate__c stObjList: [Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,
                                                      Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c 
                                                      From ST_PA_QL_Auto_Populate__c ]){  
                                                          if(stJuncDel.size() == 0){                                                   
                                                              if(IsStepTherapy && stObjList.Record_Type__c=='Step Therapy' && stObjList.What_is_the_Funding_Type__c.CONTAINS(crdListUpdate[0].Insured_Type__c) && stObjList.Contract_State__c.CONTAINS(crdListUpdate[0].Contract_State__c)){
                                                                  newStepTherapyRecord = new CRD_Step_Therapy_Junction__c();
                                                                  newStepTherapyRecord.Isautopopulated__c = True;
                                                                  newStepTherapyRecord.CRD_ID__c =crdListUpdate[0].id;
                                                                  newStepTherapyRecord.Step_Therapy_DrugList_Class__c = stObjList.Drug_List__c;
                                                                  createSTRecords.add(newStepTherapyRecord);
                                                              }
                                                          }
                                                          if(paJuncDel.size() == 0){
                                                              if(IsPrecert && stObjList.Record_Type__c=='Precert' && stObjList.What_is_the_Funding_Type__c.CONTAINS(crdListUpdate[0].Insured_Type__c) && stObjList.Contract_State__c.CONTAINS(crdListUpdate[0].Contract_State__c)){
                                                                  newPriorAuthRecord = new CRD_PriorAuth_Junction__c ();
                                                                  newPriorAuthRecord.Isautopopulated__c = True;
                                                                  newPriorAuthRecord.CRD_ID__c =crdListUpdate[0].id;
                                                                  newPriorAuthRecord.Precert_Class__c= stObjList.Drug_List__c;
                                                                  createPrecertRecords.add(newPriorAuthRecord );
                                                              }
                                                          }
                                                          if(qlJuncDel.size() == 0){
                                                              if(IsPrecert && stObjList.Record_Type__c=='Quantity Limit' && stObjList.What_is_the_Funding_Type__c.CONTAINS(crdListUpdate[0].Insured_Type__c) && stObjList.Contract_State__c.CONTAINS(crdListUpdate[0].Contract_State__c)){
                                                                  newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c ();
                                                                  newQuantityLimitRecord.Isautopopulated__c = True;
                                                                  newQuantityLimitRecord.CRD_ID__c =crdListUpdate[0].id;
                                                                  newQuantityLimitRecord.QL_Class__c= stObjList.Drug_List__c;
                                                                  createQLRecords.add(newQuantityLimitRecord);
                                                              }
                                                          }
                                                          
                                                      }
        }
        //Ends
        if(createPrecertRecords!= Null && createPrecertRecords.size() >0){
            crdPLQAST.Standard_Precert_List_or_Select_Classes__c = 'PA Drug List(s)';
            Database.insert (createPrecertRecords,false);
        }
        if(createQLRecords!= Null && createQLRecords.size() >0){
            crdPLQAST.Standard_QL_List_or_Select_Classes__c = 'QL Drug List(s)';
            Database.insert (createQLRecords,false);
        }
        if(createSTRecords!= Null && createSTRecords.size() >0){
            Database.insert (createSTRecords,false);
        }
        Database.update (crdPLQAST);
       
        //Ends                                 
    }
    public void changeTierNonFormulary(list<copay_tier__c> copayTierList){
        // logic checking value of CRDB Copay Logic Field of Tier 1 Record type
        if(!copayTierList.IsEmpty() && copayTierList.size()!=0){
            // Update fields of Tier 1 and Tier 3 for CRDB Copay Logic being NONFORMULARY
            if(copayTierList[0].CRDB_Copay_Logic__c != NULL && copayTierList[0].CRDB_Copay_Logic__c == NONFORMULARY){ 
                copaytierList[0].Tier_Type__c = PREFERREDGENERICS;
                
                if(copayTierList.size() == 3){
                    copaytierList[2].Tier_Type__c = LABEL8;
                    if(copaytierList[2].RecordType.name == MAILLABEL){
                        mailTier3 = copaytierList[2].Tier_Type__c;
                    }else if(copaytierList[2].RecordType.name == RETAILLABEL){
                        retailTier3 = copaytierList[2].Tier_Type__c;
                    }
                    
                }
            }  
            if(copaytierList[0].RecordType.name == MAILLABEL){
                mailTier1 = copaytierList[0].Tier_Type__c;
            }else if(copaytierList[0].RecordType.name == RETAILLABEL){
                retailTier1 = copaytierList[0].Tier_Type__c;
            }
            if(copayTierList.size() == 3){
                if(copaytierList[2].RecordType.name == MAILLABEL){
                    mailTier3 = copaytierList[2].Tier_Type__c;
                }else if(copaytierList[2].RecordType.name == RETAILLABEL){
                    retailTier3 = copaytierList[2].Tier_Type__c;
                }
                
            }
        }         
    } 
    /* Method :- validateDSC()
     * Description - To delete mismatch DSC and unprocess line value
     */
    public void validateDSC(map<decimal,Pers_Full_Report__c> persMap,Set<String> formularyGroupString,set<id> formularId){
        
        set<integer> provNum = new Set<integer>();
        set<integer> lineNum = new set<integer>();
        set<integer> lineToUnprocessed = new set<integer>();
        map<id,Drug_Specific_Copay__c> dscdeleteList = new map<id,Drug_Specific_Copay__c>();
        List<Pers_Full_Report__c> pfrUpdate = new List<Pers_Full_Report__c>();
        map<id,Drug_Specific_Copay__c> fulldscListMap = new map<id,Drug_Specific_Copay__c>();
        set<string> provLineString = new set<string>();
        boolean blankFormularyFall =false;
        for(Pers_Full_Report__c pers:persMap.values()){
            string provStr = 'P'+pers.WS_PROV_NUM__c+'L'+pers.WS_LV_NO__c;
            provLineString.add(provStr);
        }
        List<String> dscFormularyStringList = new List<string>();
            set<String> dscFormularyGroupSet = new set<String>();
            boolean deleteConfirm = FALSE;
            for(Drug_Specific_Copay__c dsc : dsclist){
                fulldscListMap.put(dsc.id,dsc);
                if(dsc.Formulary_Group__c!=null){
                        dscFormularyStringList = dsc.Formulary_Group__c.split(SPLIT);
                        dscFormularyGroupSet.addall(dscFormularyStringList);
                }
            
                  if(formularyGroupString.size()> 0){
                            for(String fgstr : formularyGroupString){
                                
                                if(formularyGroupString.size()>0 && dscFormularyGroupSet.size()>0 && dsc.Formulary_Group__c!=null && fgstr!= Null
                                    && /*!dscFormularyGroupSet.contains(ALL) && !dscFormularyGroupSet.contains(fgstr)*/
                                      !compareWithMultiSelect(dsc.Formulary_Group__c,ALL) && !compareWithMultiSelect(dsc.Formulary_Group__c,fgstr)){
                                  
                                        dscdeleteList.put(dsc.id,dsc);
                                        deleteConfirm = TRUE;
                                }
                            }
                    }
                    if(formularId.size()>0 && formularyGroupString.size()==0 && dscFormularyGroupSet.size()>0 
                      && /*!dscFormularyGroupSet.contains(ALL) && !dscFormularyGroupSet.contains(COMMERCIAL)*/
                        !compareWithMultiSelect(dsc.Formulary_Group__c,ALL) && !compareWithMultiSelect(dsc.Formulary_Group__c,COMMERCIAL)){
                        dscdeleteList.put(dsc.id,dsc);
                        deleteConfirm = TRUE;
                    }
                    //Added By Nitish 6957
                    if(formularId.size() == 0 && formularyGroupString.size()==0 && dscFormularyGroupSet.size()>0
                        && !compareWithMultiSelect(dsc.Formulary_Group__c,ALL)){
                        dscdeleteList.put(dsc.id,dsc);
                        deleteConfirm = TRUE;
                        blankFormularyFall = TRUE;
                    }
                    //Removed a logic for deletion of DSC when formulary is null Request 6957 by Nitish
                    dscFormularyGroupSet.clear();
                    
            }
            for(id dscremoveid:dscdeleteList.keyset()){
                    fulldscListMap.remove(dscremoveid);
            }
        try{
            if(dscdeleteList.values().size()>0){
                database.delete(dscdeleteList.values(),false);
            }
        }
        catch(exception e){
            system.debug('eMessage ' + e.getMessage());
        }
        
        if((fulldscListMap.keyset().size()==0 && deleteConfirm) || blankFormularyFall){
            for(Mapping_Values__c mv : mapVal.get(DSCAPI)){                    
                if(string.isNotBlank(mv.Field_API__c) && mv.Field_API__c.equalsIgnoreCase(FORMULARGROUPAPI)){
                    lineToUnprocessed.add(integer.valueof(mv.Provision__c));
                }
            }
            
        }
        
        
        Pers_Full_Report__c pfr = new Pers_Full_Report__c();
        for(Integer lineInt : lineToUnprocessed){
            pfr = persMap.get(lineInt);
            pfr.Processed__c = FALSE;
            pfrUpdate.add(pfr);
        }
        try{
            if(pfrUpdate.size()>0){
                database.Update(pfrUpdate,false);
            }
        }
        catch(Exception e){
            system.debug('ExceptionMessage ' + e.getMessage());
        }
        
        
        
    }
    
    public boolean compareWithMultiSelect(string multiSelectField,string tempField){ 
            boolean matchFound = false;
            String[] multiValues = multiSelectField.split(';');
            for(string val : multiValues){
                if(val.equals(tempField) && matchFound != true){
                    matchFound = true;
                    break;
                }
            }
            return matchFound; 
        }
    /** Method : checkForDiabeticPlan()
     * Description : This method check for diabetic plan
     * Request : 06819
    **/
    public void checkForDiabeticPlan(List<Pers_Full_Report__c> pfrList){
       for(Pers_Full_Report__c pfr : pfrList){
           if(pfr.WS_PROV_NUM__c == 134 && pfr.WS_LV_NO__c ==84){
               checkDiabeticPlan2 = true;
           }
          
        }
       
    }
    /** Method : ValidateWOD()
      * Description :  This method validate WOD record based on formulary group
      * ST#2515
    **/
    public void validateWOD(map<decimal,Pers_Full_Report__c> persMap, Set<String> formGroup,Id crdId,set<id> formularyId)
    {
        boolean noAction = false;
        integer provNum = 0;
        string drugclassName = '';
       
        for(Waiver_Of_Deductible_Drug_Class__c wdc : [select Drug_Class__c,Formulary_Group__c from Waiver_Of_Deductible_Drug_Class__c where Drug_Class__c IN:WODdrugclasses  limit 1000]){
            
            if(formGroup.size()>0){
                for(string frmStr : formGroup){
                    if(frmStr.equalsIgnoreCase(wdc.Formulary_Group__c)){
                        noAction = TRUE;
                    }
                }
            }
            //For Commercial Formulary
            else if(formGroup.size() == 0 && wdc.Formulary_Group__c == null && formularyId.size()>0){
                noAction = TRUE;
            }
        }
        if(!noAction){
            if(mapVal.ContainsKey('Waiver_Of_Deductible__c')){
                for(Mapping_Values__c mv : mapVal.get('Waiver_Of_Deductible__c')){
                    if(string.isNotBlank(mv.Field_API__c) && mv.Field_API__c.equalsIgnoreCase('Drug_Class__c') && string.isNotBlank(mv.FieldValue__c)){
                        drugclassName = mv.FieldValue__c;
                        provNum = integer.valueof(mv.Provision__c);
                    }
                }
               List<Waiver_Of_Deductible__c> wodDel = [select id from Waiver_Of_Deductible__c where Drug_Class__c =:drugclassName AND CRD_ID__c =:crdId];
               if(wodDel.size()>0){
                   Database.delete(wodDel);
               }
               if(persMap.containsKey(provNum)){
                    persMap.get(provNum).Processed__c = False;
                    Database.update(persMap.get(provNum));
                }
                
            }
        }
    }
}