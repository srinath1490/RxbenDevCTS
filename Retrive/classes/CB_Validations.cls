/**
*Purpose: Global apex class for common apex validation methods .                                         
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR                 DATE                    DETAIL                                 
*1.0 -    Amit Jain            13th June2014       Global apex class for common apex validation methods. For Objects CRD, Drug Coverage, Copay Tier, Stepped Copay, Drug Specific Copay,
*                                                 Drug Specific Stepped Copay, DAW Specific Copay, DAW Specific Stepped Copay
*
*1.1 -   Joognu Rao            8th July          Implemented Case enhancement process
*1.2 -   Sushant               1/14/2015         Commented fields as per request 05310
*2.0     Amit                  29 jan 2015       Modified for request 5460, removed formulary validation 'Number of Retail copay tiers are not equal to Number of Mail copay tiers. Formulary might be incorrect.'
*2.1 -   Richa                 18/2/2015         Richa added Prod correction on 18/2/2015 for Fallout Case-03448080
*2.2     Amit                  17th Feb, 2014    Removed Validation Bypass Formulary Logic for request 5460
*2.3 -   Abhishek              02/19/2015      added a reverse__c field in the query for request 05557
*2.4 -   Sushant               2/20/2015       Request No. 05552
*3.0      Nitish                03/11/2015       Request No 05584(Implemented a Validation Rule If What is Carrier on CRD != Aetna Global Benefit then Contract State on CRD cannot BR)
*4.0      Abhishek             07/29/2015       Request No 05966(Create a fallout case for CBONs identified with matching Control/ Effective date/Carrier/PSUID)
*5.0     Abhishek              08/13/2015       ST#276: Validation Rule needed Specialty Rule
*6.0     Abhishek              08/28/2015       ST#217/RRC 97613, specialty validation logic change
*6.1    Richa                  11/23/2015       Request 6212 - GMF Allowable Action - Story 3
*7.0    Amit                   11/24/2015       ST# 484, added logic to create fallout if Retail/mail copay tier count is differnt.
*8.0     Vikram                12/01/2015       Modified to implement request 06211
*8.1    Richa                  12/04/2015       Commented a section of validation as per Req 6258
*9.0    Amit                   05 Aug,2016      Modifield validation 'Aetna Specialty Care Rx' is always required to required only when Formulary Group is not equal to LGPREMIERPLUS
*10.1    Toshi                 28/09.2016       Added valiadtion for story no 6669.
*11.0   Bhaskar Arora          09/21/2016         Request 06664: 146052:ST#1459-Remove 50% logic from IL HMO OON
*12.0   Bhaskar Arora          10/04/2017        ST#2380- PROD ISSUE: Cannot resolve validation error
-*======================================================================== 
**/
public with sharing class CB_Validations {
    String Maillabel = 'Mail';
    String Retaillabel = 'Retail';
    String Specialtylabel = 'Specialty';
    String Paperlabel = 'Paper';
    String ThreeNumberTier = '3';
    String OneNumberTier = '1';
    String NonForumularyLabel = 'Non-Formulary';
    //Declaration of the Variables
    public list<ErrorModel> errordescription = new List<ErrorModel>();
    private set<ErrorModel> setErrorModel = new set<ErrorModel>();
    public Integer retailCopayTierCount =0;
    public Integer mailCopayTierCount = 0;
    public boolean retailFormulary = False;
    public boolean mailFormulary= False;
    public boolean bypassFormularyValidation = False;
    private static String ERR00024 = 'ERR00024';
    //private static String ERR0290 = 'ERR0290'; Commented for ST# 301
    private static String CRDACCOUNT = 'CRD-Account';
    private static String AGB = 'Aetna Global Benefits';
    private static String BR = 'BR';
    private static String CRDCARRIER = 'CRD- What is Carrier?';
    private static Integer CARRIERID = 7710;
    private static String RetailTier1 = '1';
    private static String SpecialtyTier1 = '1';
    private static String RetailTier2 = '2';
    private static String SpecialtyTier2 = '2';
    private static final string ALLOWOVERRIDE = 'Allow Rule to be overridden';
    PRIVATE STATIC FINAL STRING DRUGSPECIFICACCUM = 'Drug Specific Accum';
    PRIVATE STATIC FINAL STRING DRUGSPECIFICCOPAY = 'Drug Specific Copay';
    PRIVATE STATIC FINAL STRING WAIVEROFDEDUCTIBLE= 'Waiver of Deductible';
    private static final string YES = 'Yes';
    private static final string NO = 'No';
    private static final string PLUSLABEL = '+';
    private static final string ANDLABEL = '&';
    //private static final string DCMAIL = '01250000000UHnq';
    //private static final string DCRETAIL = '01250000000UHnr';
    public boolean chkDiabeticPlan = False;//Added By Nitish 6819
    private static final string LGPREMIERPLUS = 'LG Premier Plus';
    private static final string ALL = 'ALL';
    Private Static Final String COMMERCIAL= 'Commercial';
    Private Static Final String FORMULARGROUPAPI = 'Formulary_Group__c';
    private Id DCMAIL = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
    private Id DCRETAIL = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
    public boolean byPassFalloutForDrugCoverage = False; /* Added for ST 2380*/
    public Map<string,List<Mapping_Values__c>> mapVal;// Added By Nitish ST#2515(for optimisation of code)
    public Map<integer,Pers_Full_Report__c> pfrMap;//Added By Nitish Requet 7029
    public map<string,List<DC_Drug_List_Group__c>> mapDCDL = new map<string,List<DC_Drug_List_Group__c>>();// added by Nitish for Request 7029
    private static final String DCDLAPI = 'DC_Drug_List_Group__c';
    private static final String FORMULARYAPI = 'Formulary_Group__c';
    public boolean bypassDiabeticPlan = false; // Added By Nitish
    public List<DC_Drug_List_Group__c> listDCDL;//Added By Nitish for formulary Exclusion
    public static Map<String,String> allowableActionsMap = new Map<String,String>{    
        //Map Entries as per the excel sheet provided          
        'Include'=>'Inclusion',
        'Exclude'=>'Exclusion',
        'Prior Authorization required'=>'Prior Auth',
        'Yes'=>'Apply limitations on CRD',
        'No'=>'Apply limitations on CRD'
        };
    /**
* Method :- validate_CRD
* Description :- Validation method to Validate data on CRD and its child objects. It will return an error string and Isvalid flag as False in case of validataion failure    
**/     
    static boolean bpf;                                                    //added for ST 1715 by Vatsal

    public boolean validate_CRD(Id CRDRecordID,boolean bpf1){            //added bpf1 ST 1715 by Vatsal
        bpf=bpf1;                                                         //added for ST 1715 by Vatsal       
        List<CRD__C> listCRD = new List<CRD__c>();
        Map<String,List<Copay_Tier__c>> mapRecType2Copay = new Map<String,List<Copay_Tier__c>>();
        Map<String,List<SteppedCopay__c>> mapRecType2StepCopay = new Map<String,List<SteppedCopay__c>>();
        Map<String,List<Drug_Specific_Copay__c>> mapRecType2DrugCopay = new Map<String,List<Drug_Specific_Copay__c>>();
        Map<String,List<Drug_Specific_Stepped_Copay__c>> mapRecType2DrugStepCopay = new Map<String,List<Drug_Specific_Stepped_Copay__c>>();
        Map<String,List<DAW_Specific_Copay__c>> mapRecType2DAWCopay = new Map<String,List<DAW_Specific_Copay__c>>();
        Map<String,List<DAW_Specific_Stepped_Copay__c>> mapRecType2DAWStepCopay = new Map<String,List<DAW_Specific_Stepped_Copay__c>>();
        Map<String,Integer> mapRecordType2Count = new Map<String,Integer>();
        Map<Id,List<AccumulationSpecificDrug__c>> mapaccum2AccumDrug = new Map<Id,List<AccumulationSpecificDrug__c>>();
        Map<String,Copay_Tier__c> mapRetailCopay = new Map<String,Copay_Tier__c>();
        Map<String,Copay_Tier__c> mapSpecialtyCopay = new Map<String,Copay_Tier__c>();
        List<AccumulationSpecificDrug__c> listaccumdeductible = new List<AccumulationSpecificDrug__c>();
        List<AccumulationSpecificDrug__c> listaccumMAB = new List<AccumulationSpecificDrug__c>();
        List<AccumulationSpecificDrug__c> listaccumMOOP = new List<AccumulationSpecificDrug__c>();
        Set<String> setFalloutKey = new Set<String>();
        Set<Integer> RProv = new Set<Integer>{1, 17, 135, 9,151};//Added By Nitish Request #06857 // Added Provision 151 by Nitish for 6988
        Set<Integer> MProv = new Set<Integer>{12, 25, 136, 13, 147};// Added By Bhaskar #06858
        set<string> lvKey = new set<string>();//Added By Nitish ST#2515
        set<id> lvId = new set<id>();//Added By Nitish ST#2515
        mapVal = new Map<string,List<Mapping_Values__c>>();//Added By Nitish ST#2515
        pfrMap = new Map<integer,Pers_Full_Report__c>();//Added By Nitish for Request 7029
        Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
        Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId(); 
            
        // added by Vikram for request 06211        
        set<String> restrictedProfiles = new set<String>();
        for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
        }
        // 06211 ends 
        Integer count = 1;
        Integer familyAccumCount = 0;
        Integer familyAllAccumCount = 0;
        Integer individualAccumCount = 0;
        Integer individualAllAccumCount = 0;
        errordescription.clear();
        boolean isValid = true;
        boolean bypassFormularyExclusion = false;//Added By Nitish for 7086
        Integer selectedSAC = 0;
        Integer selectedPSP = 0;
        Integer selectedRXC = 0;
        try{               
            listCRD = [Select 
                       Id, Effective_Start_Date__c,PSU__c,SAC_Override_Option__c,PERS_timestamp__c,Name,Benefits_State_List__c,List_Of_states_to_remove_the_plan__c,Plan_Platform__c
                       ,Waive_Deductible_for_Tier_1_Drugs__c,Control__c,Plan__c,Plan_Type_Retail__c,Plan_Type_Mail__c,Plan_Type_Paper__c
                       ,Integrate_with_Medical__c,Penalty_Type__c,Percentage_Applied__c,Apply_Penalty__c,Penalty_Amount__c
                       ,Apply_Penalty_to_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Penalty_Amount_Specialty_OON__c
                       ,Do_you_want_to_do_Step_Therapy__c,Standard_Program_or_Select_Classes__c,Do_you_want_to_do_Precert__c
                       ,Standard_Precert_List_or_Select_Classes__c,Standard_QL_List_or_Select_Classes__c
                       ,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Standard_or_Custom_Plan__c
                       ,Plan_Type_Paper_Out_of_Network__c,Are_there_Quantity_Limits__c,Quantity_Limit_TOC_of_Days__c,Precert_TOC_days__c
                       ,Override_Standard_Compound_Max_Pay__c,Do_mandates_apply_to_all_states__c
                       ,Compound_Max_Pay__c,Retail_to_Mail__c,Insured_Type__c,Pharmacy_Advisor__c,Adherence_to_Drug_Therapy__c,Aetna_Autofill__c
                       ,Is_DM_vendor_the_same_for_each_condition__c,Implementation_Type__c,Disease_Management_Referral_Messaging__c
                       ,Disease_Management_Messaging_for__c,Which_system_will_the_plan_be_installed__c
                       ,Enrolled_in_PA_for_other_condition__c,Participate_in_CVS_mail_pharmacy_service__c,PA_Disease_Vendor_1__c
                       ,PA_Condition_1__c,clone_from_which_crd__c,Integration_1__c,Pricing_Schedule__c,Predefined__c,Risk_Indicator__c
                       ,PA_Custom_Disease_Vendor_Phone_1__c,PA_DM_Vendor_Contract_End_Date_1__c,PA_Disease_Vendor_2__c,PA_Condition_2__c
                       ,PA_Custom_Disease_Vendor_Phone_2__c,PA_DM_Vendor_Contract_End_Date_2__c,PA_Condition_3__c,PA_Condition_4__c
                       ,PA_Condition_5__c,PA_Condition_6__c,PA_Condition_7__c,Platform_Information__c
                       ,Clone_TPID__c,Clone_Owner_PPID__c,Clone_Ben_ID__c,Clone_Account__c,Y_Schd__c
                       ,Are_you_creating_a_Package_Plan__c,Contract_State__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c
                       ,Toll_Free_Number__c,Carrier_ID__c
                       ,POS_Rebate_for_Plan__c,RTMD_Effective_Date__c,RTMD_Client_Share_Percent__c
                       ,In_Network_claims_are_reimbursed__c,In_Network_Discount_Rate__c,Out_of_Network_claims_are_reimbused__c
                       ,Out_of_Network_Discount_Rate__c,Does_the_client_want_to_do_COB__c,COB_or_MOB__c
                       ,Process_Point_of_Sales_COB__c,Reimbursement_Levels__c,In_Network__c
                       ,In_Network_Reimbursement_Level__c,Out_of_Network__c,Out_of_Network_Reimbursement_Level__c
                       ,Aetna_Rx_Healthy_Outcomes__c,ARH_Offering_Type__c,Tier_1_Rx_Reduction_Type__c,Tier_1_Rx_Reduction_Amount__c
                       ,Tier_2_Rx_Reduction_Type__c,Tier_2_Rx_Reduction_Amount__c,Tier_3_Rx_Reduction_Type__c
                       ,Tier_3_Rx_Reduction_Amount__c,Tier_4_Rx_Reduction_Type__c,Tier_4_Rx_Reduction_Amount__c
                       ,Tier_5_Rx_Reduction_Type__c,Tier_5_Rx_Reduction_Amount__c,Sub_segment__c,PSP_Override_Option__c
                       ,Full_Control_Group__c,TP_ID__c,Rx_PP_ID__c,Do_you_want_to_do_Save_A_Copay__c
                       ,Do_Prescription_Savings_Program__c,Enroll_in_RxCheck__c,Rx_Override_Option__c,Account__c,Effective_Date__c,Retail_Number_of_Tiers__c,Specialty_Number_of_Tiers__c
                       ,(Select 
                         Id,Name,Days_Per_Fill__c, Use_Medispan_Indicator__c, No_of_fills_allowed_at_retail__c,Custom_MMOD_VMOD_Drug_List__c
                         ,Use_Standard_MMOD_VMOD_Drug_List__c
                         ,Formulary_Open_Closed__c, Standard_Refill_too_Soon__c, Custom_Refill_too_Soon__c, Formulary__c
                         ,Compounds_with_1_Federal_Legend_Drug__c, Smoking_Cessation_Aids__c
                         ,Norplan__c,Nutritional_Dietary_Supplies_PKU__c, Cost_Amount__c, Cost_Type__c, Apply_difference_of_cost__c
                         ,recordType.Name,Choose_Generic_Copay_Diff_Exclusion__c, Custom_Inclusion_Drug_Group__c
                         ,Custom_Exclusion_Drug_Group__c,Non_Pref_Brand_Penalty_Maximum_Dollar__c
                         ,Incentivized_Mail_Brand_Penalty_Amount__c,Incentivized_Mail_Brand_Penalty_Type__c
                         ,Incentivized_Mail_Generic_Penalty_Amount__c,Incentivized_Mail_Generic_Penalty_Type__c
                         ,Incent_Mail_NonPref_Brand_Penalty_Amount__c, Incent_Mail_NonPref_Brand_Penalty_Type__c
                         ,Exception_Drug_Group__c,Minimum_days_supply__c,Do_you_have_Choose_Generic__c,Maximum_days_supply__c
                         ,Minimum_quantity__c,Maximum_quantity__c,What_is_the_Penalty__c
                         ,Rule_for_supply_quantity__c,fills_before_MMO_option_is_invoked__c,Number_of_Periods__c,Period_Type__c
                         ,Restart_Fills__c,Incent_Mail_Gen_Penalty_Percent__c,Incent_Mail_NP_Brand_Penalty_Percent__c
                         ,Incent_Mail_Gen_Penalty_Min__c
                         ,Incent_Mail_NP_Brand_Penalty_Min__c,Incent_Mail_Gen_Penalty_Max__c,Incent_Mail_NP_Brand_Penalty_Max__c
                         ,Incent_Mail_Brand_Penalty_Percent__c,Incent_Mail_Brand_Penalty_Min__c,Incent_Mail_Brand_Penalty_Max__c
                         ,Allow_Transition_Fill__c,Retail_Refill_Allowance_No_of_days__c,Transition_Fill_Number_of_Days__c
                         ,RRA_Drug_List__c,RSO_Drug_List__c,Does_Dose_Limit_apply__c,Dose_Limit__c,Higher_Lower_than__c
                         ,Dose_Limit_Exception_Drug_List__c,Number_of_fills__c
                         ,Maintenance_Choice__c,Generic_Penalty_Type__c,Non_Pref_Brand_Penalty_Type__c,Generic_Penalty_Dollar_Amount__c
                         ,Non_Pref_Brand_Penalty_Dollar_Amount__c,Generic_Penalty_Percent__c,Non_Pref_Brand_Penalty_Percent__c
                         ,Gen_Penalty_Based_Retail_Mail_AWP__c
                         ,Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c,Generic_Penalty_Minimum_Dollar__c,Non_Pref_Brand_Penalty_Minimum_Dollar__c
                         ,Generic_Penalty_Maximum_Dollar__c,Brand_Penalty_Type__c,Brand_Penalty_Dollar_Amount__c,Brand_Penalty_Percent__c
                         ,Brand_Penalty_Based_Retail_Mail_AWP__c
                         ,Brand_Penalty_Minimum_Dollar__c,Brand_Penalty_Maximum_Dollar__c,Mandatory_Mail_Order_Option__c
                         ,Aetna_Specialty_Care_Rx__c,Force_to_Specialty__c
                         ,Speciality_Drug_List__c,of_fills_before_force_to_specialty__c,Secondary_Aetna_Specialty_Care_Rx__c
                         ,Secondary_of_Fills_before_Force_to_MOD__c
                         ,Secondary_Force_to_Specialty__c,Secondary_Speciality_Drug_List__c,Secondary_of_fills_before_force_to_SPN__c
                         ,Do_you_have_Specialty__c,Bypass_Formulary_Validation__c,Formulary_Group__c,Max_Specialty_Day_Supply__c
                         From 
                         Drug_Coverage__r Limit 1000)
                       ,(Select 
                         Id,Name, RecordType.Name,RecordType.DeveloperName,Copay_Calc__c,CRD__c,Days_Per_Fill__c,Dollar_Amount__c,LastSent__c
                         ,Max_Dollar__c,Min_Dollar__c,Number_Of_Steps__c
                         ,Percent__c,Reverse_Copay__c,Stepped_Copay__c,SteppedCopayCount__c,CRDB_Copay_logic__c,non_formulary_string__c,Tier__c,Tier_Name__c,Tier_Type__c
                         From 
                         Copay_Tiers__r order by tier__c Limit 1000)
                       ,(Select 
                         Id,Name,RecordTypeId, RecordType.Name,RecordType.DeveloperName,Copay_Calculation__c,CRD_ID__c,Dollar_Amount__c
                         ,Drug_Group__c,Drug_Group__r.Allowable_Actions__c,Drug_List__c,Drug_List__r.Allowable_Actions__c,LastSent__c,M__c,Maximum_Dollar__c,Minimum_Dollar__c,N__c,O__c,Percent__c
                         ,Stepped_Copay__c,Reverse_Copay__c,SteppedCopayCount__c,TierName__c,TierNo__c,Y__c,Formulary_Group__c
                         From 
                         Drug_Specific_Copay_s__r Limit 1000)
                       ,(SELECT 
                         Id,Name,Reverse__c,RecordTypeId, RecordType.Name,RecordType.DeveloperName,Cloned_From__c,Copay_Calculation__c,CRD_ID__c
                         ,DAW_Code__c,Dollar_Amount__c,LastSent__c,Maximum_Dollar__c,Minimum_Dollar__c,MS_Code_M__c,MS_Code_N__c
                         ,MS_Code_O__c,MS_Code_Y__c,Percent__c,Stepped__c,SteppedCopayCount__c
                         FROM 
                         DAW_Specific_Copays__r Limit 1000)
                       ,(Select 
                         Id,Name,CRD_ID__c,Drug_Class__c,Drug_List__c,Drug_List__r.Allowable_Actions__c,Drug_Group__c,Drug_Group__r.Allowable_Actions__c,Delivery_System__c,M__c,N__c,O__c,Y__c,Standard__c
                         ,Drug_Class_Desc__c,LastSent__c,Drug_List_Name__c,Drug_Group_Name__c
                         From 
                         Waiver_Of_Deductibles__r Limit 1000)
                       ,(Select 
                         Id,OwnerId,IsDeleted,Name,RecordTypeId,RecordType.Name,CreatedDate,Family_Members_to_meet_Family_Deduct__c
                         ,CRD_ID__c,Carry_Balance_when_member_moves__c,Deductible_Amount__c,Deductible_Applies_towards_the_MOOP__c,Accum_No__c
                         ,Deductible_Period__c,Accum_Name__c,Is_there_a_Maximum_Out_of_Pocket__c,Noof_Family_Members_to_Meet_Family_MOOP__c
                         ,MAB_Dedictible_Amount__c,When_will_the_Accumulations_renew__c,MAB_Period__c,Deductible_In_Network__c
                         ,Deductible_Out_of_Network__c,MOOP_Dedictible_Amount__c,Deductible_Generic_Drugs__c,Deductible_Brand_Drugs_Generics__c
                         ,MOOP_Period__c,Deductible_Brand_Drugs_no_Generics__c,Deductible_Maintenance_Drugs__c,MAB_In_Network__c
                         ,MAB_Out_of_Network__c,MAB_Generic_Drugs__c,What_happens_when_the_MAB_is_met__c,MAB_Brand_Drugs_Generics__c
                         ,MAB_Brand_Drugs_no_Generics__c,MAB_Maintenance_Drugs__c,MOOP_In_Network__c,Deuductible_Accumulation_from_4th_Qtr__c
                         ,MOOP_Out_of_Network__c,MOOP_Generic_Drugs__c,Are_there_any_drug_specific_deductibles__c,Are_there_any_drug_specific_MAB__c
                         ,Are_there_any_drug_specifc_MOOP__c,CRD_Name__c,Do_not_apply_penalty_to_OOP__c,Do_not_apply_flat_fee_to_OOP__c
                         ,What_is_the_In_Network_Deductible_Amount__c,MOOP_Brand_Drugs_Generics__c,Start_Month__c,MOOP_Brand_Drugs_no_Generics__c
                         ,MOOP_Maintenance_Drugs__c,What_is_the_OON_Deductible_Amount__c,LastSent__c,Start_Month_New__c,Start_Day__c
                         ,What_happens_when_MOOP_is_met__c,DAW_Differential_Penalty_Applies_to_MOOP__c,Cross_Accumulation__c,Accum_Code_Deductible__c
                         ,Accum_Code_Maximum_Out_Of_Pocket__c,Accum_Code_Maximum_Allowable_Benefit__c,Total_Change_Copays__c
                         ,What_is_the_In_Network_MOOP_Amount__c,Accumulation_End_Date__c,What_is_the_OON_MOOP_Amount__c
                         ,Is_there_a_Maximum_Allowable_Benefit__c 
                         From 
                         Accumulations__r Limit 1000)
                       ,(Select 
                         Id,OwnerId,IsDeleted,Name,CRD_ID__c,Step_Therapy_Drug_Class__c,Step_Therapy_DrugList_Class__c
                         ,Step_Therapy_Class_ID__c,IsAutoPopulated__c 
                         From 
                         CRD_Step_Therapy_Junction__r Limit 1000)
                       ,(Select 
                         Id, OwnerId, IsDeleted, Name, CRD_ID__c, Precert_Class__c, Precert_Class_ID__c, IsAutoPopulated__c 
                         From 
                         CRD_PriorAuth_Junction__r Limit 1000)
                       ,(Select 
                         Id, OwnerId, IsDeleted, Name,CRD_ID__c, QL_Class__c, QL_Class_ID__c, IsAutoPopulated__c 
                         From 
                         CRD_Quantity_Limit_Jucntion__r Limit 1000)
                       ,(Select 
                         Id, CRD_ID__c, Does_client_have_suppression__c, Mail_Custom__c, Retail_Custom__c
                         ,Specialty_Custom__c, Network_Mail__c, Network_Retail__c, Network_Specialty__c
                         ,Enroll_in_Medvantix__c, Medvantix_Copay_Dollar_Amount__c 
                         From 
                         Network_Junctions__r Limit 1 )
                       ,(Select 
                         Id, OwnerId,Name, CRD_ID__c, Clinical_Program_Group_ID__c, Clinical_Program_Group_Name__c
                         , Record_Type__c, Selected__c, LastSent__c, RxPlan_ID__c
                         From 
                         Clinical_Program_Group_Junction__r Limit 1000)
                       ,(Select Id,Name,WS_PROV_NUM__c,WS_LV_NO__c,processed__C from PERSfullReports__r) 
                       ,(Select ID,Error_code__c From CRD_BuilderFallouts__r)
                       ,(Select
                         Id,Applies__c,CoPay_Calculation__c,Dollar_Amount__c,Maximum_Dollar__c,Minimum_Dollar__c
                         ,Percent__c,Vaccine_Network__c,Waiver_of_Deductible__c,RecordTypeId From Retail_Vaccine_Programs__r Limit 1000)
                       From 
                       CRD__c where ID =: CRDRecordID Limit 1]; 
/* commented for Request 06329
                //Added by Amit for ST# 195 fetch all data with matching Control/ Effective date/Carrier/PSUID
                for(Plan_Fallout__c pFallout : [Select id,Carrier_ID__c,Control__c,Effective_Date__c,PSUID__c FROM Plan_Fallout__c WHERE Active__c = true]){
                    String Key;
                    String Control ='';
                    String EffectiveDate='';
                    String Carrier='';
                    String PSUID='';                
                    if(pFallout.Control__c!= Null){
                        Control= pFallout.Control__c;
                    }
                    if(pFallout.Effective_Date__c!= Null){
                        EffectiveDate = String.valueof(pFallout.Effective_Date__c);
                    }
                    if(pFallout.Carrier_ID__c!= Null){
                        Carrier = String.valueof(pFallout.Carrier_ID__c);
                    }
                    if(pFallout.PSUID__c!= Null){
                        PSUID = pFallout.PSUID__c;
                    }
                    Key = Control +';' + EffectiveDate +';' + Carrier +';' + PSUID;
                    System.debug('#########Key' +Key);
                    setFalloutKey.add(Key);     
                }
               //Ends 
*/
            //Validate CRD's Child Objects
            //Check If there is a CRD in the list, If yes proceed with the validation
            if(listCRD != Null && listCRD.size() > 0){                    
                for(CRD__c crdRec: listCRD){
                    //Validation for CRD Fields
                    if(crdRec.Benefits_State_List__c != Null && crdRec.List_Of_states_to_remove_the_plan__c != Null){
                        if (isElementCommon((string)crdRec.Benefits_State_List__c
                                            ,(string)crdRec.List_Of_states_to_remove_the_plan__c)
                            && 'HMO'.equals(crdRec.Plan_Platform__c)) {
                                setErrorModel.add(new ErrorModel(' CRD- Benefits State List','ERR00136',  system.label.ERR00136));
                                isValid=false;
                            }   
                    }
                    
                    else {
                        if(crdRec.Waive_Deductible_for_Tier_1_Drugs__c != Null 
                           && ('Yes ? Waive In Network and Out of Network'.equals(crdRec.Waive_Deductible_for_Tier_1_Drugs__c) 
                               || 'Yes ? Waive In Network'.equals(crdRec.Waive_Deductible_for_Tier_1_Drugs__c) 
                               || 'Yes - Waive Out of Network'.equals(crdRec.Waive_Deductible_for_Tier_1_Drugs__c) )
                           && 'No'.equals(crdRec.Integrate_with_Medical__c)){ 
                               setErrorModel.add(new ErrorModel(' CRD- Waive Deductible for Tier 1 Drugs','ERR0234',  system.label.ERR0234));                              
                               isValid=false;  
                           }
                    }     
                    //Added By Nitish for Request 7031
                    if(crdRec.Plan_Platform__c == null){
                        setErrorModel.add(new ErrorModel(' CRD- What is the Carrier?','ERR308',  system.label.ERR308));
                        isValid=false; 
                    }
                    
                    if(crdRec.Penalty_Type__c!=null 
                       && 'Percent'.equals(crdRec.Penalty_Type__c) 
                       && crdRec.Percentage_Applied__c==null){
                           setErrorModel.add(new ErrorModel(' CRD- Penalty Type','ERR00052',  system.label.ERR00052));
                           isValid=false;
                       }
                       // Request No 05584 By Nitish
                    /*Commented for ST# 301
                    if(crdRec.Carrier_ID__c != CARRIERID && crdRec.Contract_State__c == BR){
                          setErrorModel.add(new ErrorModel(CRDCARRIER,ERR0290,  system.label.ERR0290));
                           isValid=false;
                       } 
                    */    
                    if(crdRec.Apply_Penalty__c!=null && 'Yes'.equals(crdRec.Apply_Penalty__c)){
                        if(crdRec.Penalty_Type__c==null || crdRec.Penalty_Amount__c==null){
                            setErrorModel.add(new ErrorModel(' CRD- Apply Penalty','ERR00027',  system.label.ERR00027));
                            isValid=false;                             
                        }
                    }
                    if(crdRec.Apply_Penalty_to_Specialty_OON__c!=null 
                       && 'Yes'.equals(crdRec.Apply_Penalty_to_Specialty_OON__c)){
                           if(crdRec.Penalty_Type_Specialty_OON__c==null || crdRec.Penalty_Amount_Specialty_OON__c==null){ 
                               setErrorModel.add(new ErrorModel(' CRD- Apply Penalty to Specialty OON','ERR0230',  system.label.ERR0230));
                               isValid=false;                           
                           }
                       }
                    if(crdRec.Penalty_Type_Specialty_OON__c!=null 
                       && 'Percent'.equals(crdRec.Penalty_Type_Specialty_OON__c) 
                       && crdRec.Percentage_Applied_Specialty_OON__c==null){
                           setErrorModel.add(new ErrorModel(' CRD- Penalty Type Specialty OON','ERR0231',  system.label.ERR0231));
                           isValid=false;
                       }
                    
                    //First Screen Validation
                    if (crdRec.Standard_or_Custom_Plan__c != null) {
                        if('Cloning a custom plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c)
                           || 'Cloning a package plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c) 
                           || 'Cloning a HIX plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c)){
                               if(crdRec.clone_from_which_crd__c ==  NULL){
                                   setErrorModel.add(new ErrorModel(' CRD- What are you doing?','ERR0211',  system.label.ERR0211));
                                   isValid=false;
                               }
                           }  
                    }                
                    if('Cloning a custom plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c)  
                       || 'Cloning a package plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c) 
                       || 'Cloning a HIX plan from existing CRD'.equals(crdRec.Standard_or_Custom_Plan__c)){             
                           if(crdRec.Clone_TPID__c == NULL 
                              || crdRec.Clone_Owner_PPID__c == NULL 
                              || crdRec.Clone_Ben_ID__c == NULL 
                              || crdRec.Clone_Account__c == NULL){
                                  setErrorModel.add(new ErrorModel(' CRD- What are you doing?','ERR00227',  system.label.ERR00227));
                                  isValid=false;             
                              }
                       }
                    if(crdRec.Standard_or_Custom_Plan__c == Null){
                        setErrorModel.add(new ErrorModel(' CRD- What are you doing?','ERR0249',  system.label.ERR0249));
                        isValid=false;
                    }
                    //** First Screen Validation Ends
                    //2nd Screen Validations
                    if (crdRec.Plan_Type_Specialty_OON__c 
                        && crdRec.Plan_Type_Paper_Out_of_Network__c==false) {
                            setErrorModel.add(new ErrorModel(' CRD- Plan Type: Specialty OON','ERR0244',  system.label.ERR0244));
                            isValid=false;
                        }else if (crdRec.Benefits_State_List__c!= Null && crdRec.List_Of_states_to_remove_the_plan__c!= Null){
                            if(isElementCommon(crdRec.Benefits_State_List__c, crdRec.List_Of_states_to_remove_the_plan__c) 
                               && 'HMO'.equalsignorecase(crdRec.Plan_Platform__c)) {
                                   setErrorModel.add(new ErrorModel(' CRD- Benefits State List','ERR00136',  system.label.ERR00136));
                                   isValid=false;                           
                               }
                        }
                    if ('HMO'.equals(crdRec.Which_system_will_the_plan_be_installed__c) 
                        && 'N'.equals(crdRec.Do_mandates_apply_to_all_states__c)
                        && crdRec.Benefits_State_List__c == null) {
                            setErrorModel.add(new ErrorModel(' CRD- Which medical platform to install plan?','ERR00180',  system.label.ERR00180));
                            isValid=false;
                        }             
                    if ('HMO'.equalsignorecase(crdRec.Which_system_will_the_plan_be_installed__c)
                        && 'Y'.equalsignorecase(crdRec.Do_mandates_apply_to_all_states__c)
                        && crdRec.Benefits_State_List__c != null) {
                            setErrorModel.add(new ErrorModel(' CRD- Which medical platform to install plan?','ERR00181',  system.label.ERR00181));
                            isValid=false;
                        }
                    if ('Yes'.equalsignorecase(crdRec.Are_you_creating_a_Package_Plan__c)
                        && crdRec.Which_system_will_the_plan_be_installed__c == null) {
                            setErrorModel.add(new ErrorModel(' CRD- Are you creating a Package Plan?','ERR00196',  system.label.ERR00196));
                            isValid=false;
                        }
                    //Commented as per request 06664 : 146052:ST#1459-Remove 50% logic from IL HMO OON
                    /*if(crdRec.Plan_Type_Paper_Out_of_Network__c 
                       && 'IL'.equals(crdRec.Contract_State__c)
                       && (crdRec.Insured_Type__c != NULL 
                           && ('Fully Insured'.equalsignorecase(crdRec.Insured_Type__c) || 'Split Funded'.equalsignorecase(crdRec.Insured_Type__c)) 
                           && crdRec.OON_Cost_Share_Not_Greater_50_Drug_Cost__c != 'Applies' )
                      ){
                          setErrorModel.add(new ErrorModel(' CRD- Plan Type: Paper Out of Network','ERR00232',  system.label.ERR00232));
                          isValid=false;
                      }*/
                      if (crdRec.Account__c == Null){
                            setErrorModel.add(new ErrorModel(CRDACCOUNT,ERR00024,  system.label.ERR00024));
                            isValid=false;
                        }
                    //** 2nd Screen Validations End
                    
                    //3rd Screen Validation
                    if(!cRDThirdScreenValidations(crdRec)){
                        isValid = False;   
                    }
                    //** 3rd Screen Validation Ends
                    
                    //Validation for SAC Screen and PSP Screen and RxCheck Screen
                        if ('yes'.equalsignorecase(crdRec.Do_you_want_to_do_Save_A_Copay__c) 
                        && crdRec.Insured_Type__c != 'Self Insured' 
                        && string.isEmpty(crdRec.SAC_Override_Option__c)){
                            setErrorModel.add(new ErrorModel(' CRD- Override Option?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                        if(crdRec.Do_you_want_to_do_Save_A_Copay__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Enroll in Save-A-Copay?','ERR0258',  system.label.ERR0258));
                            isValid=false;
                        }
                        if(crdRec.Do_Prescription_Savings_Program__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Enroll in Prescription Savings Program?','ERR0259',  system.label.ERR0259));
                            isValid=false;
                        }
                        if(crdRec.Enroll_in_RxCheck__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Enroll in RxCheck','ERR0260',  system.label.ERR0260));
                            isValid=false;
                        }
                        if(crdRec.Integrate_with_Medical__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Type of Medical Integration from Provision 32','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                        if(crdRec.Does_the_client_want_to_do_COB__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Does client want to coordinate benefits?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                        if(crdRec.Do_you_want_to_do_Step_Therapy__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Is there Step Therapy?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                        if(crdRec.Do_you_want_to_do_Precert__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Is there Precert?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                        if(crdRec.Are_there_Quantity_Limits__c == Null){
                            setErrorModel.add(new ErrorModel(' CRD- Are there Quantity Limits?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                        }
                    for(Clinical_Program_Group_Junction__c clinicalJunction : crdRec.Clinical_Program_Group_Junction__r){
                        if ('Save-A-Copay'.equalsignorecase(clinicalJunction.Record_Type__c) == True && clinicalJunction.Selected__c) {
                            selectedSAC = selectedSAC + 1;
                        }else if('Prescription Savings Program'.equalsignorecase(clinicalJunction.Record_Type__c) == True && clinicalJunction.Selected__c) {
                            selectedPSP = selectedPSP + 1;
                        }else if('RxCheck'.equalsignorecase(clinicalJunction.Record_Type__c) == True && clinicalJunction.Selected__c) {
                            selectedRXC = selectedRXC + 1;  
                        }
                    }
                    if(crdRec.Clinical_Program_Group_Junction__r!= Null){
                        //SAC Screen
                        if (selectedSAC != 1 && crdRec.Do_you_want_to_do_Save_A_Copay__c == 'Yes' && crdRec.SAC_Override_Option__c == 'No') {
                            setErrorModel.add(new ErrorModel(' CRD-  Save-A-Copay group','ERR00113',  system.label.ERR00113));
                            isValid=false;
                        }
                        //PSP Screen
                        if (selectedPSP != 1 && crdRec.Do_Prescription_Savings_Program__c == 'Yes' && crdRec.PSP_Override_Option__c == 'No') {
                            setErrorModel.add(new ErrorModel(' CRD-Prescription Saving Program group','ERR00108',  system.label.ERR00108));
                            isValid=false;
                        }
                        //RxCheck Screen
                        //PSP Screen
                        if (selectedRXC != 1 && crdRec.Enroll_in_RxCheck__c == 'Yes' && crdRec.Rx_Override_Option__c == 'No') {
                            setErrorModel.add(new ErrorModel(' CRD-RxCheck group','ERR00111',  system.label.ERR00111));
                            isValid=false;
                        }
                    }
                    //**Validation for SAC Screen and PSP Screen Ends
                    
                    //Validation for AHO Screen
                    if ('Yes'.equalsignorecase(crdRec.Aetna_Rx_Healthy_Outcomes__c) && crdRec.ARH_Offering_Type__c == null) {
                        setErrorModel.add(new ErrorModel(' CRD-Offering Type','ERR00146',  system.label.ERR00146));
                        isValid=false;
                    }   
                    if ('Dollar Amount'.equalsignorecase(crdRec.Tier_1_Rx_Reduction_Type__c) && crdRec.Tier_1_Rx_Reduction_Amount__c > 500.00) {
                        setErrorModel.add(new ErrorModel(' CRD-Tier 1 Rx Reduction Amount','ERR00153',  system.label.ERR00153));
                        isValid=false;
                    }
                    if ('Dollar Amount'.equalsignorecase(crdRec.Tier_2_Rx_Reduction_Type__c) && crdRec.Tier_2_Rx_Reduction_Amount__c > 500.00) {
                        setErrorModel.add(new ErrorModel(' CRD-Tier 2 Rx Reduction Amount','ERR00154',  system.label.ERR00154));
                        isValid=false;
                    }
                    if ('Dollar Amount'.equalsignorecase(crdRec.Tier_3_Rx_Reduction_Type__c) && crdRec.Tier_3_Rx_Reduction_Amount__c > 500.00) {
                        setErrorModel.add(new ErrorModel(' CRD-Tier 3 Rx Reduction Amount','ERR00155',  system.label.ERR00155));
                        isValid=false;
                    }
                    if ('Dollar Amount'.equalsignorecase(crdRec.Tier_4_Rx_Reduction_Type__c) && crdRec.Tier_4_Rx_Reduction_Amount__c > 500.00) {
                        setErrorModel.add(new ErrorModel(' CRD-Tier 4 Rx Reduction Amount','ERR00156',  system.label.ERR00156));
                        isValid=false;
                    }
                    if ('Dollar Amount'.equalsignorecase(crdRec.Tier_5_Rx_Reduction_Type__c) && crdRec.Tier_5_Rx_Reduction_Amount__c > 500.00) {
                        setErrorModel.add(new ErrorModel(' CRD-Tier 5 Rx Reduction Amount','ERR00157',  system.label.ERR00157));
                        isValid=false;
                    }
                    //**Validation for AHO Screen Ends
                    
                    //** Validation for CRD Fields Ends
                    
                    //Validation for Network Junction Record
                    for(Network_Junction__c networkJunction : crdRec.Network_Junctions__r){
                        if(networkJunction.Network_Retail__c != null && networkJunction.Network_Retail__c != 'Custom'){
                            if(networkJunction.Does_client_have_suppression__c!=null){
                                setErrorModel.add(new ErrorModel('Network Junction: Retail','ERR0213',  system.label.ERR0213));
                                isValid=false;
                            }
                        }
                        if (networkJunction.Network_Mail__c == null 
                            && networkJunction.Network_Specialty__c == null 
                            && networkJunction.Network_Retail__c == null) {
                                setErrorModel.add(new ErrorModel('Network Junction','ERR00103',  system.label.ERR00103));
                                isValid=false;
                            }
                        if((networkJunction.Network_Retail__c== 'Custom' && networkJunction.Retail_Custom__c == NULL) 
                            || (networkJunction.Network_Mail__c=='Custom' && networkJunction.Mail_Custom__c == NULL) 
                            ||(networkJunction.Network_Specialty__c=='Custom' && networkJunction.Specialty_Custom__c == NULL)){ 
                                setErrorModel.add(new ErrorModel('Network Junction','ERR00104',  system.label.ERR00104));
                                isValid=false;
                        }
                    //Commented following Validation Rule for Request 07056, ST #2638 by Sushant
                    /* if((networkJunction.Network_Retail__c != 'Custom' && networkJunction.Network_Retail__c != Null && networkJunction.Retail_Custom__c != NULL) 
                            ||(networkJunction.Network_Mail__c !='Custom' && networkJunction.Network_Mail__c != Null && networkJunction.Mail_Custom__c != NULL) 
                            ||(networkJunction.Network_Specialty__c !='Custom' && networkJunction.Network_Specialty__c != Null && networkJunction.Specialty_Custom__c != NULL)){
                                setErrorModel.add(new ErrorModel('Network Junction','ERR0283',  system.label.ERR0283));
                                isValid=false;
                        } 
                    */
                    }
                    //**Validation for Network Junction Record Ends
                    //Validation for Copay Tier Records
                    for(Copay_Tier__c copayRecord : crdRec.Copay_Tiers__r){
                        if(mapRecType2Copay.containsKey(copayRecord.RecordType.Name)){
                            mapRecType2Copay.get(copayRecord.RecordType.Name).add(copayRecord);
                        }else{
                            mapRecType2Copay.put(copayRecord.RecordType.Name, new List<Copay_Tier__c>{copayRecord});
                        }
                        //added by abhishek for ST#217
                        if(crdRec.Retail_Number_of_Tiers__c!='' && crdRec.Retail_Number_of_Tiers__c!=Null && crdRec.Specialty_Number_of_Tiers__c !='' && crdRec.Specialty_Number_of_Tiers__c !=null){
                            if(crdRec.Retail_Number_of_Tiers__c == RetailTier1 && copayRecord.RecordType.Name == Retaillabel){
                                Copay_Tier__c retailCopay = new Copay_Tier__c();
                                retailCopay.Dollar_Amount__c = copayRecord.Dollar_Amount__c;
                                retailCopay.Percent__c = copayRecord.Percent__c;
                                retailCopay.Copay_Calc__c = copayRecord.Copay_Calc__c;
                                retailCopay.Min_Dollar__c = copayRecord.Min_Dollar__c;
                                retailCopay.Max_Dollar__c = copayRecord.Max_Dollar__c;
                                retailCopay.Reverse_Copay__c = copayRecord.Reverse_Copay__c;
                                retailCopay.Days_Per_Fill__c = copayRecord.Days_Per_Fill__c;
                                mapRetailCopay.put(copayRecord.Tier__c,retailCopay);
                                
                                
                            }
                            if(crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier1 && copayRecord.RecordType.Name == Specialtylabel){
                                Copay_Tier__c specialCopay = new Copay_Tier__c();
                                specialCopay.Dollar_Amount__c = copayRecord.Dollar_Amount__c;
                                specialCopay.Percent__c = copayRecord.Percent__c;
                                specialCopay.Copay_Calc__c = copayRecord.Copay_Calc__c;
                                specialCopay.Min_Dollar__c = copayRecord.Min_Dollar__c;
                                specialCopay.Max_Dollar__c = copayRecord.Max_Dollar__c;
                                specialCopay.Reverse_Copay__c = copayRecord.Reverse_Copay__c;
                                specialCopay.Days_Per_Fill__c = copayRecord.Days_Per_Fill__c;
                                mapSpecialtyCopay.put(copayRecord.Tier__c,specialCopay);
                               
                            }
                        }
                    }
                    if(mapRecType2Copay.get('Mail') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Mail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2Copay.get('Paper') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Paper'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2Copay.get('Paper Out of Network') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Paper Out of Network'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2Copay.get('Retail') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Retail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2Copay.get('Specialty') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Specialty'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2Copay.get('Specialty OON') != Null){
                        If(!validateCopay(mapRecType2Copay.get('Specialty OON'))){
                            isValid = False;   
                        }
                    }
                    //** Validation for Copey Tier Ends
                    
                    //Validation for Drug Specific Copay Starts
                    for(Drug_Specific_Copay__c DrugcopayRecord : crdRec.Drug_Specific_Copay_s__r){
                        if(mapRecType2DrugCopay.containsKey(DrugcopayRecord.RecordType.Name)){
                            mapRecType2DrugCopay.get(DrugcopayRecord.RecordType.Name).add(DrugcopayRecord);
                        }else{
                            mapRecType2DrugCopay.put(DrugcopayRecord.RecordType.Name, new List<Drug_Specific_Copay__c>{DrugcopayRecord});
                        }
                    }
                    if(mapRecType2DrugCopay.get('Mail') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Mail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DrugCopay.get('Paper') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Paper'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DrugCopay.get('Paper Out of Network') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Paper Out of Network'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DrugCopay.get('Retail') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Retail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DrugCopay.get('Specialty') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Specialty'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DrugCopay.get('Specialty OON') != Null){
                        If(!validateDrugSpecificCopay(mapRecType2DrugCopay.get('Specialty OON'))){
                            isValid = False;   
                        }
                    }
                    //** Validation for Drug Specific Copay Ends
                    
                    //Validation for DAW Specific Copays Begins
                    for(DAW_Specific_Copay__c DAWcopayRecord : crdRec.DAW_Specific_Copays__r){
                        if(mapRecType2DAWCopay.containsKey(DAWcopayRecord.RecordType.Name)){
                            mapRecType2DAWCopay.get(DAWcopayRecord.RecordType.Name).add(DAWcopayRecord);
                        }else{
                            mapRecType2DAWCopay.put(DAWcopayRecord.RecordType.Name, new List<DAW_Specific_Copay__c>{DAWcopayRecord});
                        }
                    }
                    if(mapRecType2DAWCopay.get('Mail') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Mail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DAWCopay.get('Paper') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Paper'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DAWCopay.get('Paper Out of Network') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Paper Out of Network'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DAWCopay.get('Retail') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Retail'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DAWCopay.get('Specialty') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Specialty'))){
                            isValid = False;   
                        }
                    }
                    if(mapRecType2DAWCopay.get('Specialty OON') != Null){
                        If(!validatedawSpecificCopay(mapRecType2DAWCopay.get('Specialty OON'))){
                            isValid = False;   
                        }
                    }
                    //** Validation for DAW Specific Copay Ends
                    
                    //Validation for Waiver of Deductible
                    //Validate Waiver Of Deductible Fields while Iterating on each record
                    for(Waiver_Of_Deductible__c WODRecord : crdRec.Waiver_Of_Deductibles__r){
                        
                        if(WODRecord.Standard__c && WODRecord.Drug_Class__c == Null){
                            setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Class','ERR0247',  system.label.ERR0247));
                            isValid=false;
                        }
                        if(WODRecord.Drug_List__c!=null && WODRecord.Drug_Group__c!=null){
                            setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group,Drug List','ERR00069',  system.label.ERR00069));
                            isValid=false;
                        }
                        
                        // added by Vikram for request 06211
                        if (WODRecord.Drug_Group__c!=null){
                            String alact = WODRecord.Drug_Group__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(WODRecord.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(WODRecord.Drug_Group__r.Allowable_Actions__c) || !alact.contains(WAIVEROFDEDUCTIBLE)){
                                    setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group,Drug List','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                            }
                        }else if(WODRecord.Drug_List__c!=null){
                            String alact1 = WODRecord.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(WODRecord.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(WODRecord.Drug_List__r.Allowable_Actions__c) || !alact1.contains(WAIVEROFDEDUCTIBLE)){
                                    setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group,Drug List','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                 }
                            }
                         }
                       // 06211 ends 
                    }
                    //Validate M,N,O,Y for all the Waiver Of Deductible records
                    If(!validateWaiverOfDeductible(crdRec.Waiver_Of_Deductibles__r)){
                        isValid = False;   
                    }
                    //Added by Nitish ST#2515
                    for(Pers_Full_Report__c pfr :  crdRec.PERSfullReports__r){
                        string key = 'P'+pfr.WS_PROV_NUM__c+'L'+pfr.WS_LV_NO__c;
                        lvKey.add(key);
                      pfrMap.put(integer.valueof(pfr.WS_PROV_NUM__c),pfr);//Added Nitish for 7029
                    }
                    for(LineValue__c lv:[select Name,id from LineValue__c where Name IN:lvKey]){
                        lvId.add(lv.id);
                    }
                    for(Mapping_Values__c mv : [Select Object_API__c,Field_API__c,FieldValue__c,Line_value__c,Provision__c,Line_ValueID__r.Name,ParentMappingValue__c from Mapping_Values__c where Line_ValueID__c IN:lvId limit 50000]){
                        if(string.isNotBlank(String.Valueof(mv.Object_API__c)) && !mapVal.containsKey(string.valueof(mv.Object_API__c))){
                            mapVal.put(mv.Object_API__c,new List<Mapping_Values__c  > {mv});
                        }
                        else if(mapVal.containsKey(mv.Object_API__c)){
                            mapVal.get(mv.Object_API__c).add(mv);
                        }
                    }
                    //Added By Nitish ST#2515
                    boolean bypassFalloutWOD = False;
                    for(CRD_BuilderFallout__c cf:crdRec.CRD_BuilderFallouts__r){
                        if(cf.Error_Code__c == 'ERR307'){
                                bypassFalloutWOD = True;
                            }
                        //Added for Spring 10 2017 regression Fix Obs1
                        if(cf.Error_Code__c == 'ERR304'){
                            bypassDiabeticPlan = True;
                        }
                       
                        if(cf.Error_Code__c == 'ERR309'){
                            bypassFormularyExclusion = True;
                        }
                        
                    }
                    
                    for(Pers_Full_Report__c pfr :  crdRec.PERSfullReports__r){
                        if(!bypassFalloutWOD && crdRec.Waiver_Of_Deductibles__r.size()==0 && mapVal.ContainsKey('Waiver_Of_Deductible__c') &&  mapVal.get('Waiver_Of_Deductible__c').size()>0 && pfr.WS_PROV_NUM__c == 28 && (pfr.WS_LV_NO__c!=0 || pfr.WS_LV_NO__c!=999) && pfr.Processed__c == false){
                                setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Formulary Group Mismatch','ERR307',  system.label.ERR307));
                                isValid = False;
                        }
                    }
                    
                             
                    //**Validation for Waiver Of Deductible Ends
                    
                    //Validation for Accumulations Begins
                    //Iterate on Accumulation Specific Drug to fetch all the child records of all accumulation records
                    for(AccumulationSpecificDrug__c accumSpecRecord: [Select 
                                                                      Id, name,RecordTypeId,RecordType.Name,Accumulations_ID__c,Accumulatoins_Type__c,CRDID__c,CRD_ID__c
                                                                      ,DAW_Differential_Penalty_Applies_to_MOOP__c,Deductible_Amount__c,Deductible_Applies_towards_the_MOOP__c
                                                                      ,Deductible_Period__c,Deuductible_Accumulation_from_4th_Qtr__c,Drug_Group__c,Drug_Group__r.Allowable_Actions__c,Drug_Group_ID__c
                                                                      ,Drug_List__c,Drug_List__r.Allowable_Actions__c,Drug_List_ID__c,Exclude_from_Accumulation__c,LastSent__c,M__c,MAB_Dedictible_Amount__c
                                                                      ,MAB_Period__c,MOOP_Dedictible_Amount__c,MOOP_Period__c,N__c,O__c
                                                                      ,Pay_the_DAW_difference_after_deductible__c,SortOrder__c,What_happens_when_MAB_is_met__c
                                                                      ,What_happens_when_MOOP_is_met__c,Y__c
                                                                      From 
                                                                      AccumulationSpecificDrug__c 
                                                                      where 
                                                                      Accumulations_ID__c =:crdRec.Accumulations__r Limit 1000]){
                                                                          if(mapaccum2AccumDrug.containsKey(accumSpecRecord.Accumulations_ID__c)){
                                                                              mapaccum2AccumDrug.get(accumSpecRecord.Accumulations_ID__c).add(accumSpecRecord);
                                                                          }else{
                                                                              mapaccum2AccumDrug.put(accumSpecRecord.Accumulations_ID__c, new List<AccumulationSpecificDrug__c>{accumSpecRecord});
                                                                          }
                                                                      }
                    //Iterate on Each accumulation record for validation
                    for(Accumulations__c accumulation : crdRec.Accumulations__r){
                        listaccumdeductible = new List<AccumulationSpecificDrug__c>();//Richa added Prod correction on 18/2/2015 for Fallout Case-03448080  
                        listaccumMAB = new List<AccumulationSpecificDrug__c>();//Richa added Prod correction on 18/2/2015 for Fallout Case-03448080
                        listaccumMOOP = new List<AccumulationSpecificDrug__c>();//Richa added Prod correction on 18/2/2015 for Fallout Case-03448080
                        //Validate for AI Request
                        if(((accumulation.What_happens_when_MOOP_is_met__c != NULL 
                                && accumulation.What_happens_when_MOOP_is_met__c == 'Change Copay')
                            ||(accumulation.What_happens_when_the_MAB_is_met__c != NULL && accumulation.What_happens_when_the_MAB_is_met__c == 'Change Copay' ))
                            &&(accumulation.Total_Change_Copays__c == 0)){
                                setErrorModel.add(new ErrorModel(' Accumulation - What happens when MOOP is met','ERR00147',  system.label.ERR00147));                                                       
                                isValid = False;                              
                        }
                        //Ends

                        If(!validateFamilyFields(accumulation,accumulation.RecordType.Name)){
                            isValid = False;
                        }
                        //Iterate on Accumulation Specific Drug Records to get the deductible,MAP,MOOP records for current Accumulation records
                        if(mapaccum2AccumDrug.get(accumulation.id) != Null){
                            for(AccumulationSpecificDrug__c currentrecord : mapaccum2AccumDrug.get(accumulation.id)){
                                if('Family - Deductible'.equalsIgnoreCase(currentrecord.Recordtype.Name) 
                                   || 'Individual - Deductible'.equalsIgnoreCase(currentrecord.Recordtype.Name)){
                                       listaccumdeductible.add(currentrecord);
                                   }
                                if('Family - MAB'.equalsIgnoreCase(currentrecord.Recordtype.Name) 
                                   || 'Individual - MAB'.equalsIgnoreCase(currentrecord.Recordtype.Name)){
                                       listaccumMAB.add(currentrecord);
                                   }
                                if('Family - MOOP'.equalsIgnoreCase(currentrecord.Recordtype.Name) 
                                   || 'Individual - MOOP'.equalsIgnoreCase(currentrecord.Recordtype.Name)){
                                       listaccumMOOP.add(currentrecord);
                                   }
                            }
                        }
                        //Validation for Deductible records
                        if(listaccumdeductible != Null && listaccumdeductible.size()>0){
                            If(!validateAccumulationDrugListMNOY(listaccumdeductible,accumulation.RecordType.Name)){
                                isValid = False;
                            }
                            if (accumulation.Are_there_any_drug_specific_deductibles__c != null 
                                && accumulation.Are_there_any_drug_specific_deductibles__c) {
                                    if(!validateAccumulationDrugListDeductible(listaccumdeductible,accumulation.RecordType.Name)){
                                        isValid = False;
                                    }
                                }
                        }
                        //Validation for MAB Records
                        if(listaccumMAB != Null && listaccumMAB.size()>0){
                            If(!validateAccumulationDrugListMNOY(listaccumMAB,accumulation.RecordType.Name)){
                                isValid = False;
                            }
                            /*if (accumulation.Is_there_a_Maximum_Allowable_Benefit__c != null 
                                && 'Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Allowable_Benefit__c)) {Richa added Prod correction on 18/2/2015 for Fallout Case-03448080*/
                                    if (accumulation.Are_there_any_drug_specific_MAB__c != null 
                                        && accumulation.Are_there_any_drug_specific_MAB__c) {
                                            if(!validateAccumulationDrugListMab(listaccumMAB, accumulation.RecordType.Name)){
                                                isValid = False;
                                            }
                                        }
                                //}
                        }
                        //Validation for MOOP Records
                        if(listaccumMOOP != Null && listaccumMOOP.size()>0){
                            If(!validateAccumulationDrugListMNOY(listaccumMOOP,accumulation.RecordType.Name)){
                                isValid = False;
                            }
                            /*if (accumulation.Is_there_a_Maximum_Out_of_Pocket__c != null 
                                && 'Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Out_of_Pocket__c)) {
                                    if (accumulation.Are_there_any_drug_specifc_MOOP__c != null 
                                        && accumulation.Are_there_any_drug_specifc_MOOP__c) {
                                            if(!validateAccumulationDrugListMoop(accumulation, listaccumMOOP, accumulation.RecordType.Name)){
                                                
                                            }
                                        }
                                }Richa added Prod correction on 18/2/2015 for Fallout Case-03448080*/                   
                            if (accumulation.Are_there_any_drug_specifc_MOOP__c != null 
                                && accumulation.Are_there_any_drug_specifc_MOOP__c) {
                                    if(!validateAccumulationDrugListMoop(accumulation, listaccumMOOP, accumulation.RecordType.Name)){
                                        isValid = False;    //Richa added Prod correction on 18/2/2015 for Fallout Case-03448080
                                    }
                                }                         
                        }
                        //Create a map and add the RecordType and count to validate if there is no duplicate of same record type                        
                        if(mapRecordType2Count.containsKey(accumulation.RecordType.Name)){
                            count = mapRecordType2Count.get(accumulation.RecordType.Name) + 1;                     
                        }
                        mapRecordType2Count.put(accumulation.RecordType.Name, count);
                        
                        If(accumulation.Deductible_Amount__c != NULL){
                            If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL 
                               || accumulation.What_is_the_OON_Deductible_Amount__c != NULL){
                                   setErrorModel.add(new ErrorModel(' Accumulation - What is the In Network Deductible Amount','ERR00200'
                                                                    ,system.label.ERR00200));
                                   isValid = False;
                               }
                        }
                        If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL 
                           && accumulation.What_is_the_OON_Deductible_Amount__c != NULL ){
                               If(accumulation.Deductible_Amount__c != NULL){
                                   setErrorModel.add(new ErrorModel(' Accumulation - Deductible Amount','ERR00201',  system.label.ERR00201));
                                   isValid = False;
                               }
                           }                                             
                        IF(accumulation.MOOP_Dedictible_Amount__c != NULL){
                            If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL 
                               || accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                                   setErrorModel.add(new ErrorModel(' Accumulation - What is the In Network MOOP Amount','ERR00205',  system.label.ERR00205));
                                   isValid = False;
                               }
                        }
                        If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL 
                           && accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                               If(accumulation.MOOP_Dedictible_Amount__c != NULL){
                                   setErrorModel.add(new ErrorModel(' Accumulation - MOOP Dedictible Amount','ERR00206',system.label.ERR00206)); 
                                   isValid = False;
                               }
                           }   
                    }
                    if((mapRecordType2Count.get('Family - All')!= Null && mapRecordType2Count.get('Family - All') > 1)
                       || (mapRecordType2Count.get('Family - Mail')!= Null && mapRecordType2Count.get('Family - Mail') > 1)
                       || (mapRecordType2Count.get('Family - Retail')!= Null && mapRecordType2Count.get('Family - Retail') > 1)
                       || (mapRecordType2Count.get('Family - Specialty')!= Null && mapRecordType2Count.get('Family - Specialty') > 1)
                       || (mapRecordType2Count.get('Individual - All')!= Null && mapRecordType2Count.get('Individual - All') > 1)
                       || (mapRecordType2Count.get('Individual - Mail')!= Null && mapRecordType2Count.get('Individual - Mail') > 1)
                       || (mapRecordType2Count.get('Individual - Retail')!= Null && mapRecordType2Count.get('Individual - Retail') > 1)
                       || (mapRecordType2Count.get('Individual - Specialty')!= Null && mapRecordType2Count.get('Individual - Specialty') > 1)
                      ){
                          setErrorModel.add(new ErrorModel(' Accumulation - Record Type','ERR00056',system.label.ERR00056));
                          isValid = False;
                      }
                    // Validate if there are More than 1 Family type Recordtype
                    if(mapRecordType2Count.containskey('Family - All')) {
                        familyAllAccumCount =mapRecordType2Count.get('Family - All');
                    }
                    if(mapRecordType2Count.containskey('Family - Mail')) {
                        familyAccumCount = familyAccumCount + mapRecordType2Count.get('Family - Mail');
                    }
                    if(mapRecordType2Count.containskey('Family - Retail')) {
                        familyAccumCount =familyAccumCount + mapRecordType2Count.get('Family - Retail');
                    }
                    if(mapRecordType2Count.containskey('Family - Specialty')) {
                        familyAccumCount =familyAccumCount + mapRecordType2Count.get('Family - Specialty');
                    }
                    if(familyAllAccumCount > 0 && familyAccumCount > 1){
                        setErrorModel.add(new ErrorModel(' Accumulation - Family Record Type','ERR0280',system.label.ERR0280));
                        isValid = False;
                    }
                    
                    //Validate if there are more than 1 Individual type RecordType
                    if(mapRecordType2Count.containskey('Individual - All')) {
                        individualAllAccumCount = mapRecordType2Count.get('Individual - All');      
                    }
                    if(mapRecordType2Count.containskey('Individual - Mail')) {
                        individualAccumCount = individualAccumCount + mapRecordType2Count.get('Individual - Mail');
                    }
                    if(mapRecordType2Count.containskey('Individual - Retail')) {
                        individualAccumCount =individualAccumCount + mapRecordType2Count.get('Individual - Retail');
                    }
                    if(mapRecordType2Count.containskey('Individual - Specialty')) {
                        individualAccumCount =individualAccumCount + mapRecordType2Count.get('Individual - Specialty');
                    }
                    if(individualAccumCount > 0 && individualAllAccumCount > 0){
                        setErrorModel.add(new ErrorModel(' Accumulation - Individual Record Type','ERR0281',system.label.ERR0281));
                        isValid = False;
                    }
                    if(familyAllAccumCount > 0 && individualAccumCount > 0){
                        setErrorModel.add(new ErrorModel(' Accumulation - Individual Record Type','ERR0278',system.label.ERR0278));
                        isValid = False;
                    }
                    if(individualAllAccumCount > 0 && familyAccumCount > 0){
                        setErrorModel.add(new ErrorModel(' Accumulation - Individual Record Type','ERR0279',system.label.ERR0279));
                        isValid = False;
                    }
                    //** Validation for Accumulation Ends
                    
                    //Validation for Step Therapy Junction Records Begins
                    if(crdRec.Do_you_want_to_do_Step_Therapy__c == 'Yes' && crdRec.Standard_Program_or_Select_Classes__c == 'ST Drug List(s)'){//Richa added on 20/8
                        for(CRD_Step_Therapy_Junction__c stRecord: crdRec.CRD_Step_Therapy_Junction__r){
                            if (stRecord.Step_Therapy_DrugList_Class__c == null){
                                setErrorModel.add(new ErrorModel(' Step Therapy - Step Therapy DrugList Class','ERR00228',system.label.ERR00228));
                                isValid = False;
                            }              
                        }
                    }
                    //**Validation for Step Therapy Junction Records Ends
                    
                    //Vaidation for Prior Auth Junction Records Begins
                    if(crdRec.Do_you_want_to_do_Precert__c == 'Yes' && crdRec.Standard_Precert_List_or_Select_Classes__c == 'PA Drug List(s)'){//Richa added on 20/8
                        for(CRD_PriorAuth_Junction__c paRecord: crdRec.CRD_PriorAuth_Junction__r){
                            if (paRecord.Precert_Class__c == null){
                                setErrorModel.add(new ErrorModel('Prior Auth Junction - Precert Class','ERR00229',system.label.ERR00229));
                                isValid = False;
                            }              
                        }
                    }
                    //Validation for Prior Auth Junction Records Ends
                    
                    //Validation for Quantity Limit Junction Records Begins
                    if (crdRec.Are_there_Quantity_Limits__c != null 
                        && crdRec.Are_there_Quantity_Limits__c != 'No' 
                        && crdRec.Quantity_Limit_TOC_of_Days__c != crdRec.Precert_TOC_days__c) {
                            setErrorModel.add(new ErrorModel('Quantity Limit Junction - Are there Quantity Limits'
                                                             ,'ERR00142'
                                                             ,system.label.ERR00142+ ' ' + crdRec.Precert_TOC_days__c + '. ' + system.Label.ERR00143));
                            isValid = False;
                        }
                    if(crdRec.Are_there_Quantity_Limits__c == 'Yes' && crdRec.Standard_QL_List_or_Select_Classes__c == 'QL Drug List(s)'){//Richa added on 20/8    
                        for(CRD_Quantity_Limit_Junction__c qlimitRecord: crdRec.CRD_Quantity_Limit_Jucntion__r){
                            if (qlimitRecord.QL_Class__c == null){
                                setErrorModel.add(new ErrorModel('Quantity Limit Junction - QL Class','ERR00230',system.label.ERR00230));
                                isValid = False;
                            }              
                        }
                    }
                    //**Validation for Quantity Limit Junction Records Ends
                    
                    //Validation for Program Screen Begins
                    if (crdRec.Compound_Max_Pay__c == Null
                        && 'Yes'.equalsIgnoreCase(crdRec.Override_Standard_Compound_Max_Pay__c)) {             
                            setErrorModel.add(new ErrorModel(' CRD - Compound Max Pay','ERR00139',system.label.ERR00139));
                            isValid = False;
                        }
                    if(!programScreenValidation(crdRec)){
                        isValid = False;
                    }
                    //**Validation for Program Screen Ends
                               
                    //Validate the CRD fields for AI Request
                    if(crdRec.Sub_segment__c == Null){
                        setErrorModel.add(new ErrorModel(' CRD-SubSegment','ERR0254',  system.label.ERR0254));
                        isValid=false;
                    }
                    if(crdRec.Which_system_will_the_plan_be_installed__c == Null){
                        setErrorModel.add(new ErrorModel(' CRD-Which medical platform to install plan?','ERR0253',  system.label.ERR0253));
                        isValid=false;
                    }
                    if(crdRec.Standard_or_Custom_Plan__c == 'Creating a custom plan' && (crdRec.TP_ID__c != Null || crdRec.Rx_PP_ID__c != Null)){
                        setErrorModel.add(new ErrorModel(' CRD-TPID,PPID','ERR00101',  system.label.ERR00101));
                        isValid=false;
                    }
                    if(crdRec.Control__c == Null || crdRec.Plan__c == Null){
                        setErrorModel.add(new ErrorModel('CRD - Integration 1','ERR0252',system.label.ERR0252));
                        isValid = False;
                    }
                    //**Validate the CRD fields for AI Request Ends
 /*Commented for Request 06329                   
                    //Added By Amit for request validation for crd creation with matching Control/ Effective date/Carrier/PSUID    
                    for(String errFallout : setFalloutKey){ 
                        String crdKey;
                        String Control ='';
                        String EffectiveDate='';
                        String Carrier='';
                        String PSUID='';                    
                        String[] strFallout = errFallout.split(';');                    
                        if(strFallout.size()>=1 && strFallout[0] != Null &&  strFallout[0] != ''){
                            Control = crdRec.Control__c;
                        }
                        if(strFallout.size()>=2 && strFallout[1] != Null &&  strFallout[1] != ''){
                            EffectiveDate = String.valueof(crdRec.Effective_Start_Date__c);
                        }
                        if(strFallout.size()>=3 && strFallout[2] != Null &&  strFallout[2] != ''){
                            Carrier = String.valueof(crdRec.Carrier_ID__c);
                        }
                        if(strFallout.size()==4 && strFallout[3] != Null &&  strFallout[3] != ''){
                            PSUID = crdRec.PSU__c;
                        }
                        crdKey = Control + ';' + EffectiveDate + ';' + Carrier + ';' + PSUID;
                        System.debug('#########crdKey' +crdKey);
                        if(!setFalloutKey.isempty() && setFalloutKey.contains(crdKey)){
                            setErrorModel.add(new ErrorModel('CRD Requires Fallout','ERR0294',  system.label.ERR0294));
                            isValid=false;
                            break;                      
                        }
                    }
*/
                    //validation Copay ST#217
                    if((crdRec.Retail_Number_of_Tiers__c == RetailTier1 && crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier1)){
                          Boolean mapCompare = mapRetailCopay.equals(mapSpecialtyCopay);
                            if(mapCompare){
                                setErrorModel.add(new ErrorModel('CRD Copay ','ERR0296',system.label.ERR0296));
                                isValid = False;
                            }
                    }
                    //validation Copay ST#276
                     //Commented below code as per Req 6258/ST 672
                    /*for(Drug_Coverage__c drugCoverage : crdRec.drug_Coverage__r){
                        if(drugCoverage.Formulary_Group__c!='' && drugCoverage.Formulary_Group__c!=null){
                                if(crdRec.Retail_Number_of_Tiers__c!='' && crdRec.Retail_Number_of_Tiers__c!=Null && crdRec.Specialty_Number_of_Tiers__c !='' && crdRec.Specialty_Number_of_Tiers__c !=null){
                                    if((crdRec.Retail_Number_of_Tiers__c == RetailTier1 && crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier1)){
                                     setErrorModel.add(new ErrorModel('CRD Copay ','ERR0295',system.label.ERR0295));
                                     isValid = False;
                                     break;
                                    }else if((crdRec.Retail_Number_of_Tiers__c == RetailTier1 && crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier2)){
                                         setErrorModel.add(new ErrorModel('CRD Copay','ERR0295',system.label.ERR0295));
                                         isValid = False;
                                         break;
                                    }
                                    else if((crdRec.Retail_Number_of_Tiers__c == RetailTier2 && crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier1)){
                                        setErrorModel.add(new ErrorModel('CRD Copay','ERR0295',system.label.ERR0295));
                                         isValid = False;
                                         break;
                                    }
                                    else if((crdRec.Retail_Number_of_Tiers__c == RetailTier2 && crdRec.Specialty_Number_of_Tiers__c == SpecialtyTier2)){
                                        setErrorModel.add(new ErrorModel('CRD Copay ','ERR0295',system.label.ERR0295));
                                         isValid = False;
                                         break;
                                    }
                                }      
                        }
                    
                    }*/   
                    //Request 6635 - Retail Vaccine Validation By Nitish
                    
                    for(Retail_Vaccine_Program__C rt : crdRec.Retail_Vaccine_Programs__r){
                        If(rt.RecordTypeId == recordTypeSeasonal && rt.Applies__c == 'TRUE' && rt.Waiver_of_Deductible__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0307',system.label.ERR0307));
                            isValid = False;
                        }
                        If(rt.RecordTypeId == recordTypePreventive && rt.Applies__c == 'TRUE' && rt.Waiver_of_Deductible__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0308',system.label.ERR0308));
                            isValid = False;
                        }
                        If(rt.RecordTypeId == recordTypeTravel && rt.Applies__c == 'TRUE' && rt.Waiver_of_Deductible__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0309',system.label.ERR0309));
                            isValid = False;
                        }
                        If(rt.RecordTypeId == recordTypeSeasonal && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C== null && rt.Percent__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0310',system.label.ERR0310));
                            isValid = False;
                        }
                        If(rt.RecordTypeId == recordTypePreventive && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C== null && rt.Percent__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0311',system.label.ERR0311));
                            isValid = False;
                        }
                        If(rt.RecordTypeId == recordTypeTravel && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C== null && rt.Percent__c == null){
                           setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0312',system.label.ERR0312));
                            isValid = False;
                        }
                        if(rt.RecordTypeId == recordTypeSeasonal && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C != null && rt.Percent__c != null && rt.CoPay_Calculation__c == null){
                            setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0313',system.label.ERR0313));
                            isValid = False;
                        }
                        if(rt.RecordTypeId == recordTypePreventive && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C != null && rt.Percent__c != null && rt.CoPay_Calculation__c == null){
                            setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0314',system.label.ERR0314));
                            isValid = False;
                        }
                        if(rt.RecordTypeId == recordTypeTravel && rt.Applies__c == 'TRUE' && rt.Dollar_Amount__C != null && rt.Percent__c != null && rt.CoPay_Calculation__c == null){
                            setErrorModel.add(new ErrorModel('CRD Retail Vaccine Program ','ERR0315',system.label.ERR0315));
                            isValid = False;
                        }
                    }
                    
                    //Ends
                    // Method called to validate DC on formulary as per 06597 By Nitish
                    
                    
                    //Added By Nitish 6819 && for 6857-6858
                    boolean retailFallout = false;// Added By Nitish for 6857
                    boolean mailFallout = false;// Added By Nitish for 6858
                    for(Pers_Full_Report__c pfr :crdRec.PERSfullReports__r){
                        if(pfr.WS_PROV_NUM__c == 134 && pfr.WS_LV_NO__c == 84){
                            chkDiabeticPlan = TRUE;
                        }
                        if(!crdRec.Plan_Type_Retail__c && RProv.contains(integer.valueof(pfr.WS_PROV_NUM__c)) && pfr.Processed__c == False){
                            retailFallout = TRUE;
                        }
                        if(!crdRec.Plan_Type_Mail__c && MProv.contains(integer.valueof(pfr.WS_PROV_NUM__c)) && pfr.Processed__c == False){
                            mailFallout = TRUE;
                        }
                    }
                    if(retailFallout || mailFallout ){
                        setErrorModel.add(new ErrorModel('CRD Retail/Mail Provision ','ERR0320',system.label.ERR0320));
                        isValid = False;
                    }
                    if(!validateDSCFormulary(crdRec,crdRec.PERSfullReports__r,crdRec.CRD_BuilderFallouts__r)){
                        isValid = False;
                    }
                }    
                
                //Validate Drug Coverage Records
                If(!validate_DrugCoverage(listCRD)){
                    isValid = False;   
                }
                
                //Added By Nitish for 7029
                    if(!bypassFormularyExclusion && !matchDCDLFormulary(pfrMap,listCRD[0],mapVal)){
                       setErrorModel.add(new ErrorModel('DCDL Formulary MisMatch ','ERR309',system.label.ERR309));
                        isValid = False;
                    }
                   
                //** Validation for Drug Coverage Ends      
                
                //Validation for Stepped Copay Tier Starts      
                for(SteppedCopay__c stepCopayRecord : [select 
                                                       Id,Reverse__c,Name,Min_Range__c,Copay_Calc__c,Copay_Tier__c,CRD_ID__c,Dollar_Amount__c
                                                       ,Max_Range__c,LastSent__c,Max_Dollar__c,Min_Dollar__c,Number_of_Ranges__c
                                                       ,Percent_Amount__c,Related_Copay_Record__c,Related_Copay_Record_Type__c
                                                       ,Stepped_CoPay_Types__c,Tier_Type__c 
                                                       From 
                                                       SteppedCopay__c 
                                                       where 
                                                       CRD_ID__c =:CRDRecordID Limit 1000]){
                                                           if(mapRecType2StepCopay.containsKey(stepCopayRecord.Related_Copay_Record__c)){
                                                               mapRecType2StepCopay.get(stepCopayRecord.Related_Copay_Record__c).add(stepCopayRecord);
                                                           }else{
                                                               mapRecType2StepCopay.put(stepCopayRecord.Related_Copay_Record__c, new List<SteppedCopay__c>{stepCopayRecord});
                                                           }
                                                       }
                if(mapRecType2StepCopay.get('Mail') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Mail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2StepCopay.get('Paper') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Paper'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2StepCopay.get('Paper Out of Network') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Paper Out of Network'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2StepCopay.get('Retail') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Retail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2StepCopay.get('Specialty') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Specialty'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2StepCopay.get('Specialty OON') != Null){
                    If(!validateSteppedCopay(mapRecType2StepCopay.get('Specialty OON'))){
                        isValid = False;   
                    }
                }
                //** Validation for Stepped Copay Tier Ends
                
                //Validation for Drug Specific Stepped Copay
                for(Drug_Specific_Stepped_Copay__c drugStepCopayRecord : [Select 
                                                                          Name,Drug_Specific_Copay_ID__c,Stepped_CoPay_Type__c,Number_of_Steps__c
                                                                          ,Beginning_Range__c, End_Range__c,Dollar_Amount__c,Percent__c,Reverse__c
                                                                          ,Copay_Calculation__c,Maximum_Dollar__c,Minimum_Dollar__c
                                                                          ,Related_Copay_Record_Type__c 
                                                                          From 
                                                                          Drug_Specific_Stepped_Copay__c 
                                                                          where 
                                                                          CRD_ID__c =:CRDRecordID Limit 1000]){
                                                                              if(mapRecType2DrugStepCopay.containsKey(drugStepCopayRecord.Related_Copay_Record_Type__c)){
                                                                                  mapRecType2DrugStepCopay.get(drugStepCopayRecord.Related_Copay_Record_Type__c).add(drugStepCopayRecord);
                                                                              }else{
                                                                                  mapRecType2DrugStepCopay.put(drugStepCopayRecord.Related_Copay_Record_Type__c
                                                                                                               ,new List<Drug_Specific_Stepped_Copay__c>{drugStepCopayRecord});
                                                                              }
                                                                          }
                if(mapRecType2DrugStepCopay.get('Mail') != Null){                                                          
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Mail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DrugStepCopay.get('Paper') != Null){
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Paper'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DrugStepCopay.get('Paper Out of Network') != Null){
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Paper Out of Network'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DrugStepCopay.get('Retail') != Null){
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Retail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DrugStepCopay.get('Specialty') != Null){
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Specialty'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DrugStepCopay.get('Specialty OON') != Null){
                    If(!validateDrugSpecificSteppedCopay(mapRecType2DrugStepCopay.get('Specialty OON'))){
                        isValid = False;   
                    }
                }
                
                //** Validation for Drug Specific Stepped Copay Ends
                
                //Validation for DAW Specific Stepped Copay
                for(DAW_Specific_Stepped_Copay__c dawStepCopayRecord : [SELECT 
                                                                        Beginning_Range__c,Reverse__c,Copay_Calculation__c,Stepped_CoPay_Type__c,CRD_ID__c
                                                                        ,DAW_Specific_Copay_ID__c, Dollar_Amount__c, End_Range__c, Id
                                                                        ,Number_of_Steps__c,Maximum_Dollar__c,Minimum_Dollar__c,Name,Percent__c
                                                                       
                                                                        FROM 
                                                                        DAW_Specific_Stepped_Copay__c 
                                                                        where 
                                                                        CRD_ID__c =:CRDRecordID Limit 1000]){
                                                                            if(mapRecType2DAWStepCopay.containsKey(dawStepCopayRecord.Related_Copay_Record_Type__c)){
                                                                                mapRecType2DAWStepCopay.get(dawStepCopayRecord.Related_Copay_Record_Type__c).add(dawStepCopayRecord);
                                                                            }else{
                                                                                mapRecType2DAWStepCopay.put(dawStepCopayRecord.Related_Copay_Record_Type__c
                                                                                                            ,new List<DAW_Specific_Stepped_Copay__c>{dawStepCopayRecord});
                                                                            }
                                                                        }
                if(mapRecType2DAWStepCopay.get('Mail') != Null){                                                        
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Mail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DAWStepCopay.get('Paper') != Null){
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Paper'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DAWStepCopay.get('Paper Out of Network') != Null){
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Paper Out of Network'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DAWStepCopay.get('Retail') != Null){
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Retail'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DAWStepCopay.get('Specialty') != Null){
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Specialty'))){
                        isValid = False;   
                    }
                }
                if(mapRecType2DAWStepCopay.get('Specialty OON') != Null){
                    If(!validatedawSpecificSteppedCopay(mapRecType2DAWStepCopay.get('Specialty OON'))){
                        isValid = False;   
                    }
                }
                //** Validation for DAW Specific Stepped Copay Ends
                
               //Validation for both Retail and Mail Formulary
                if(retailFormulary && mailFormulary && mailCopayTierCount!= 0 && mailCopayTierCount!= Null && retailCopayTierCount!=0 && retailCopayTierCount!= Null && (mailCopayTierCount != retailCopayTierCount) && !bypassFormularyValidation){
                    //check if there are equal number of retail and mail copay tiers
                    setErrorModel.add(new ErrorModel(' Drug Coverage- Formulary','ERR0277',system.label.ERR0277));
                    isValid=false;
                }                         
            }             
        }
        catch(exception ex){
        system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$richa='+ex.getLineNumber());
            setErrorModel.add(new ErrorModel(' Exception','ExceptionMessage',  ex.getmessage()));
            isValid=false;
        }
        errordescription.addall(setErrorModel);
        return isValid;
        
    }
    
    /**
* Method :- validate_DrugCoverage
* Description :- This method is used to validate DrugCoverage Records. 
**/ 
    public boolean validate_DrugCoverage(List<CRD__c> listCRD) {
        boolean isValid = true;
        List<Id> listFormulary = new List<Id>();
        set<id> lstignoreformulary = new set<Id>();
        for(Mid_Year_Formulary__c tempmidyearformulary : [select id,Formulary__c from Mid_Year_Formulary__c]){
            lstignoreformulary.add(tempmidyearformulary.Formulary__c);
        
        }
        for(Crd__c crd : listCRD){
            for(Drug_Coverage__c drugCoverage : crd.drug_Coverage__r){
                //Validate Drug Coverage List/Group
               if('No'.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c) && 'No'.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c) && lstignoreformulary.contains(drugCoverage.Formulary__c)){
                   setErrorModel.add(new ErrorModel('Drug Coverage- Formulary : '+drugCoverage.recordtype.name,'ERR00284',  system.label.ERR00284));
                   isValid = False;
               }
               if(!valiadte_DCDL(drugCoverage)){
                     isValid = False;   
               }
               
                if(drugCoverage.Do_you_have_Choose_Generic__c == Null){
                            setErrorModel.add(new ErrorModel('Drug Coverage- Do you have Choose Generic?','ERR00024',  system.label.ERR00024));
                            isValid=false;
                }
                //Commented for request 5460
                if(drugCoverage.Bypass_Formulary_Validation__c){
                    bypassFormularyValidation = True;
                }    
                if ('Mail'.equalsIgnoreCase(drugCoverage.recordType.Name)) {
                    if(('Mandatory'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) 
                        || 'Not Applicable'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) 
                        || 'Voluntary'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c))
                       &&(drugCoverage.Generic_Penalty_Type__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Type__c != null 
                          || drugCoverage.Generic_Penalty_Dollar_Amount__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != null 
                          || drugCoverage.Generic_Penalty_Percent__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != null 
                          || drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c != null 
                          || drugCoverage.Generic_Penalty_Minimum_Dollar__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null 
                          || drugCoverage.Generic_Penalty_Maximum_Dollar__c !=null 
                          || drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c !=null 
                          || drugCoverage.Brand_Penalty_Type__c !=null 
                          || drugCoverage.Brand_Penalty_Dollar_Amount__c !=null 
                          || drugCoverage.Brand_Penalty_Percent__c !=null 
                          || drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c !=null 
                          || drugCoverage.Brand_Penalty_Minimum_Dollar__c !=null 
                          || drugCoverage.Brand_Penalty_Maximum_Dollar__c !=null )
                      )
                    {
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR0212',  system.label.ERR0212));
                        isValid=false;
                    }    
                    if (drugCoverage.Formulary_Open_Closed__c == NULL) {  
                            setErrorModel.add(new ErrorModel('Drug Coverage-Mail- Formulary Open/Closed','ERR00207',  system.label.ERR00207));
                            isValid=false;
                    }  
                    if(DrugCoverage.Formulary__c != null){
                        String DCfield;
                        List<Formulary__c> lstFRM = new List<Formulary__c>([Select Formulary_Open_Closed__c from Formulary__c where Id = :drugCoverage.Formulary__c AND Formulary_Open_Closed__c != null limit 1]);
                        if(!lstFRM.isempty()){
                             DCfield =  lstFRM[0].Formulary_Open_Closed__c;
                            if(!DCfield.contains(DrugCoverage.Formulary_Open_Closed__c)){
                               setErrorModel.add(new ErrorModel('Drug Coverage- Formulary','ERR0261',  system.label.ERR0261));
                               isValid=false;
                            }
                        }else{
                           setErrorModel.add(new ErrorModel('Drug Coverage- Formulary','ERR0262',  system.label.ERR0262));
                           isValid=false;
                        }
                    }
                    if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL || drugCoverage.Brand_Penalty_Percent__c != NULL) {
                        if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Brand Penalty Type','ERR00158',  system.label.ERR00158));
                            isValid=false;
                        }
                    }
                    if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL || drugCoverage.Generic_Penalty_Percent__c != NULL) {
                        if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Generic Penalty Dollar Amount','ERR00159',  system.label.ERR00159));
                            isValid=false;
                        }
                    }         
                    if (crd.Retail_to_Mail__c) {
                        if ((drugCoverage.Mandatory_Mail_Order_Option__c != NULL && drugCoverage.Mandatory_Mail_Order_Option__c != 'Not Applicable')
                            || (drugCoverage.Maintenance_Choice__c != NULL && drugCoverage.Maintenance_Choice__c != 'Not Applicable')) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Mandatory Mail Order Option','ERR00161',  system.label.ERR00161));
                            isValid=false;
                        }
                    }
                    if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL && drugCoverage.Generic_Penalty_Percent__c != NULL) {
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Generic Penalty Dollar Amount','ERR00162',  system.label.ERR00162));
                        isValid=false;
                    }
                    if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL && drugCoverage.Brand_Penalty_Percent__c != NULL) {
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Brand Penalty Dollar Amount','ERR00163',  system.label.ERR00163));
                        isValid=false;
                    }
                    if (drugCoverage.Generic_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Generic_Penalty_Minimum_Dollar__c != NULL) {
                        if (drugCoverage.Generic_Penalty_Maximum_Dollar__c <= drugCoverage.Generic_Penalty_Minimum_Dollar__c) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Generic Penalty Maximum Dollar','ERR00165',  system.label.ERR00165));
                            isValid=false;
                        }
                    }
                    if (drugCoverage.Brand_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Brand_Penalty_Minimum_Dollar__c != NULL) {
                        if (drugCoverage.Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Brand_Penalty_Minimum_Dollar__c) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Brand Penalty Maximum Dollar','ERR00166',  system.label.ERR00166));
                            isValid=false;
                        }
                    }
                    if (drugCoverage.Maintenance_Choice__c != NULL && 'Incentivized'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if (drugCoverage.Generic_Penalty_Type__c != NULL) {
                            if (drugCoverage.Generic_Penalty_Dollar_Amount__c == NULL 
                                && drugCoverage.Generic_Penalty_Minimum_Dollar__c == NULL 
                                && drugCoverage.Generic_Penalty_Percent__c == NULL 
                                && drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                                    setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR00167',  system.label.ERR00167));
                                    isValid=false;
                                }
                        }
                        if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Generic Penalty Type','ERR00167',  system.label.ERR00167));
                            isValid=false;
                        }
                    }
                    //VR_MaintenanceChoice
                    if (drugCoverage.Maintenance_Choice__c != NULL && 'Not Applicable'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if(drugCoverage.No_of_fills_allowed_at_retail__c != Null 
                            || drugCoverage.Restart_Fills__c  != Null){
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR0251',  system.label.ERR0251));
                                isValid=false;
                        }
                    }
                    //VR_MandatoryMailOrderOption
                    if (drugCoverage.Mandatory_Mail_Order_Option__c  != NULL && 'Not Applicable'.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c )) {
                        if(drugCoverage.fills_before_MMO_option_is_invoked__c != Null 
                            || drugCoverage.Number_of_Periods__c  != Null
                            || drugCoverage.Use_Medispan_Indicator__c  != Null
                            || drugCoverage.Period_Type__c != Null
                            || drugCoverage.Custom_MMOD_VMOD_Drug_List__c != Null){
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Mandatory Mail Order Option','ERR0271',  system.label.ERR0271));
                                isValid=false;
                        }
                    }
                    if (drugcoverage.Maintenance_Choice__c != NULL 
                        && 'Incentivized'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                            if (drugCoverage.Brand_Penalty_Type__c != NULL) {
                                if (drugCoverage.Brand_Penalty_Dollar_Amount__c == NULL 
                                    && drugCoverage.Brand_Penalty_Minimum_Dollar__c == NULL 
                                    && drugCoverage.Brand_Penalty_Percent__c == NULL 
                                    && drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                                        setErrorModel.add(new ErrorModel(' Drug Coverage- Brand Penalty Type','ERR00168',  system.label.ERR00168));
                                        isValid=false;
                                    }
                            }
                            if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Brand Penalty Type','ERR00168',  system.label.ERR00168));
                                isValid=false;
                            }
                        }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL 
                        || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL) {
                            if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Non Pref Brand Penalty Dollar Amount','ERR00173',  system.label.ERR00173));
                                isValid=false;
                            }
                        }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL 
                        && drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Non Pref Brand Penalty Percent','ERR00174',  system.label.ERR00174));
                            isValid=false;
                        }
                    if ('Incentivized'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if (drugCoverage.Non_Pref_Brand_Penalty_Type__c != NULL) {
                            if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c == NULL 
                                && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c == NULL 
                                && drugCoverage.Non_Pref_Brand_Penalty_Percent__c == NULL 
                                && drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c == NULL) {
                                    setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR00175',  system.label.ERR00175));
                                    isValid=false;
                                }
                        }
                        if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Non Pref Brand Penalty Type','ERR00175',  system.label.ERR00175));
                            isValid=false;
                        }
                    }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c != NULL 
                        && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != NULL) {
                            if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c) {
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Non Pref Brand Penalty Maximum Dollar','ERR00176',  system.label.ERR00176));
                                isValid=false;
                            }
                        }
                    if (('Mandatory'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) 
                         || 'Incentivized'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) 
                         || 'Voluntary'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c))  
                        && 'Self Insured'.equalsIgnoreCase(crd.Insured_Type__c)) {
                            if (drugCoverage.Mandatory_Mail_Order_Option__c == NULL 
                                || drugCoverage.Mandatory_Mail_Order_Option__c !=  'Not Applicable') {
                                    setErrorModel.add(new ErrorModel(' Drug Coverage- Mandatory Mail Order Option','ERR00177',  system.label.ERR00177));
                                    isValid=false;
                                }
                        }
                    if (('Mandatory'.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) 
                         || 'Incentivized'.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c)) 
                        && 'Self Insured'.equalsIgnoreCase(crd.Insured_Type__c)) {
                            if (drugCoverage.Maintenance_Choice__c == NULL 
                                || drugCoverage.Maintenance_Choice__c !=  'Not Applicable') {
                                    setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR00178',  system.label.ERR00178));
                                    isValid=false;
                                }
                        }
                    //This validation is from Program Screen
                    if ('Mandatory'.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) 
                        || 'Incentivized'.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) 
                        || 'Mandatory'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) 
                        || 'Incentivized'.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                            if (crd.Retail_to_Mail__c) {                     
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Maintenance Choice','ERR00160',  system.label.ERR00160));
                                isValid=false;
                            }
                        }
                        
                    //set mailFormulary 
                    //Commented for request 5460
                    if(drugCoverage.Formulary__c != Null){
                        mailFormulary = True;
                    }                   
                }
                //Validate if the Drug Coverage recordtype is Retail
                if ('Retail'.equalsIgnoreCase(drugCoverage.recordType.Name)) {
                     // Changes By Toshi for 06877
                     /* ST#2380- added  byPassFalloutForDrugCoverage to run this validation only once */
                     if(!byPassFalloutForDrugCoverage && !string.isBlank(drugCoverage.Formulary__c) && string.isBlank(drugCoverage.Formulary_Group__c) && drugCoverage.Max_Specialty_Day_Supply__c == 90){
                            setErrorModel.add(new ErrorModel(' Drug Coverage- (Commercial)Formulary','ERR0322',  system.label.ERR0322));
                            isValid=false;
                     }
                    //VR_Do_You_Have_Speciality
                    if(drugCoverage.Do_you_have_Specialty__c == 'Yes' && (drugCoverage.Aetna_Specialty_Care_Rx__c == Null || drugCoverage.Force_to_Specialty__c == Null)){
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Do you have specialty','ERR0272',  system.label.ERR0272));
                        isValid=false;
                    }
                    if (drugCoverage.Formulary_Open_Closed__c == NULL) {  
                            setErrorModel.add(new ErrorModel('Drug Coverage-Retail- Formulary Open/Closed','ERR00207',  system.label.ERR00207));
                            isValid=false;
                    }  
                    if(DrugCoverage.Formulary__c != null){
                        String DCfield;
                        List<Formulary__c> lstFRM = new List<Formulary__c>([Select Formulary_Open_Closed__c from Formulary__c where Id = :drugCoverage.Formulary__c AND Formulary_Open_Closed__c != null limit 1]);
                        if(!lstFRM.isempty()){
                             DCfield =  lstFRM[0].Formulary_Open_Closed__c;
                            if(!DCfield.contains(DrugCoverage.Formulary_Open_Closed__c)){
                               setErrorModel.add(new ErrorModel('Drug Coverage- Formulary','ERR0261',  system.label.ERR0261));
                               isValid=false;
                            }
                        }else{
                           setErrorModel.add(new ErrorModel('Drug Coverage- Formulary','ERR0262',  system.label.ERR0262));
                           isValid=false;
                        }
                    }
                    //VR_DoYouHaveSpecialtyNoSpecialtySection
                    if(drugCoverage.Do_you_have_Specialty__c == 'No' 
                        && (drugCoverage.Aetna_Specialty_Care_Rx__c != Null 
                            || drugCoverage.of_fills_before_force_to_specialty__c != Null
                            || drugCoverage.Speciality_Drug_List__c != Null
                            || drugCoverage.Max_Specialty_Day_Supply__c != Null)){
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Do you have specialty','ERR0273',  system.label.ERR0273));
                                isValid=false;
                    }
                    //VR_DoYouHaveSpecialityasNo
                    if(drugCoverage.Do_you_have_Specialty__c == 'No' && drugCoverage.Force_to_Specialty__c != 'No' && drugCoverage.Formulary_group__c != LGPREMIERPLUS){
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Do you have specialty','ERR0274',  system.label.ERR0274));
                        isValid=false;
                    }
                    //VR_MaxDays_AetnaSpecialty
                    if (drugCoverage.Aetna_Specialty_Care_Rx__c == 'Does not Apply (Insured/not state filed)' && drugCoverage.Max_Specialty_Day_Supply__c != Null) {                        
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Aetna Specialty Care Rx','ERR0275',  system.label.ERR0275));
                        isValid=false;
                    }
                    //VR_RetailRefillAllowanceNoofdays,VR_SecondarofFillsbeforeForcetoMOD
                    if(drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c  == 'RRA' 
                        && (drugCoverage.Retail_Refill_Allowance_No_of_days__c== Null || drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c == Null)){
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary Aetna Specialty Care Rx','ERR0276',  system.label.ERR0276));
                        isValid=false;
                    }
                    //Updated by Amit to fire only when Formulary Group is not LG Premier Plus
                    
                    if (!chkDiabeticPlan && drugCoverage.Aetna_Specialty_Care_Rx__c == NULL && drugCoverage.Formulary_group__c != LGPREMIERPLUS) {                        
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Aetna Specialty Care Rx','ERR00207',  system.label.ERR00207));
                        isValid=false;
                    }
                    if (drugCoverage.Force_to_Specialty__c == NULL) {                        
                        setErrorModel.add(new ErrorModel(' Drug Coverage- Force to Specialty','ERR00207',  system.label.ERR00207));
                        isValid=false;
                    }
                    if ('Custom'.equalsIgnoreCase(drugCoverage.Aetna_Specialty_Care_Rx__c) 
                        && drugCoverage.Speciality_Drug_List__c == NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Speciality Drug List','ERR00208',  system.label.ERR00208));
                            isValid=false;
                        }
                    if ('Yes'.equalsIgnoreCase(drugCoverage.Force_to_Specialty__c) 
                        && drugCoverage.of_fills_before_force_to_specialty__c == NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- of fills before force to specialty','ERR00209',  system.label.ERR00209));
                            isValid=false;
                        }
                    if ('No'.equalsIgnoreCase(drugCoverage.Force_to_Specialty__c) 
                        && drugCoverage.of_fills_before_force_to_specialty__c != NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- of fills before force to specialty','ERR00210',  system.label.ERR00210));
                            isValid=false;
                        }                   
                    if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == null 
                        && (drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c != NULL 
                            || drugCoverage.Secondary_Force_to_Specialty__c!=Null 
                            || drugCoverage.Secondary_Speciality_Drug_List__c!=Null 
                            || drugCoverage.Secondary_of_fills_before_force_to_SPN__c!=Null)) {                        
                                setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary of Fills before Force to MOD'
                                                                 ,'ERR00250'
                                                                 ,system.label.ERR00250));
                                isValid=false;
                            }                    
                    if ('RRA'.equalsIgnoreCase(drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c) 
                        && drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c == NULL) {                        
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary of Fills before Force to MOD'
                                                             ,'ERR00245'
                                                             ,system.label.ERR00245));
                            isValid=false;
                        }                    
                    if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c != NULL 
                        && drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c !='RRA' && drugCoverage.Secondary_Force_to_Specialty__c == NULL) {                        
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary Force to Specialty','ERR00245',  system.label.ERR00245));
                            isValid=false;
                        }
                    if ('Custom'.equalsIgnoreCase(drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c) 
                        && drugCoverage.Secondary_Speciality_Drug_List__c == NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary Speciality Drug List','ERR00246',  system.label.ERR00246));
                            isValid=false;
                        }
                    if ('Yes'.equalsIgnoreCase(drugCoverage.Secondary_Force_to_Specialty__c) 
                        && drugCoverage.Secondary_of_fills_before_force_to_SPN__c == NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary of fills before force to SPN'
                                                             ,'ERR00247'
                                                             ,system.label.ERR00247));
                            isValid=false;
                        }
                    if ('No'.equalsIgnoreCase(drugCoverage.Secondary_Force_to_Specialty__c) 
                        && drugCoverage.Secondary_of_fills_before_force_to_SPN__c != NULL) {                       
                            setErrorModel.add(new ErrorModel(' Drug Coverage- Secondary of fills before force to SPN'
                                                             ,'ERR00248'
                                                             ,system.label.ERR00248));
                            isValid=false;
                        }
                    //set retailFormulary 
                    //Coomented for request 5460
                    if(drugCoverage.Formulary__c != Null){
                        retailFormulary = True;
                    }                        
                }
                
                              
            }  
        }       
        return isValid;     
    }
    
    /**
* Method :- validateCopay
* Description :- This Method check for the validate copay
**/        
    public boolean validateCopay(List<Copay_Tier__c> wrappedList){  
        Integer retailCopayTier = 0;
        Integer mailCopayTier = 0;
        Integer paperCopayTier = 0;
        boolean isValid = true;
        string tier1RetailNonFormularyString;
        string tier3RetailNonFormularyString;
        string tier1MailNonFormularyString;
        string tier3MailNonFormularyString;
        string tier1PaperNonFormularyString;
        string tier3PaperNonFormularyString;
        boolean retailgiveerrormessage = False;  
        boolean mailgiveerrormessage = False;       
        boolean Papergiveerrormessage = False;          

        if(wrappedList != Null && wrappedList.Size()>0){
            isValid =  checkTierType(wrappedList);
        }
        for(Copay_Tier__c ct:wrappedList){
            //Commented for request 5460
            if(ct.Recordtype.name == 'Retail'){
                retailCopayTierCount = retailCopayTierCount + 1;
            }else if(ct.Recordtype.name == 'Mail'){
                mailCopayTierCount = mailCopayTierCount +1;               
            }
            // Added by Sushant for Request 05552 ** starts
            if(ct.Recordtype.name == Retaillabel){
            if(ct.Tier__c == OneNumberTier && ct.CRDB_Copay_Logic__c == NonForumularyLabel)
                    {
                        tier1RetailNonFormularyString = ct.Non_Formulary_String__c;
                        tier1RetailNonFormularyString = tier1RetailNonFormularyString.toLowerCase();
                        retailgiveerrormessage = True;
                    }
            if(ct.Tier__c == ThreeNumberTier)
                {
                    //tier3RetailNonFormularyString = ((ct.Dollar_Amount__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Dollar_Amount__c)))) + ',' + ((ct.Percent__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Percent__c)))) + ',' + ((ct.Min_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Min_Dollar__c)))) + ',' + ((ct.Max_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Max_Dollar__c)))) + ',' + ((ct.Copay_Calc__c == null) ? '' : ct.Copay_Calc__c);
                    tier3RetailNonFormularyString = ct.Non_Formulary_String__c;
                    if(tier3RetailNonFormularyString != null){//Richa added for testing
                    tier3RetailNonFormularyString = tier3RetailNonFormularyString.toLowerCase();}
                }
                retailCopayTier = retailCopayTier + 1;
            }
                    
            else if(ct.Recordtype.name == Maillabel){
            if(ct.Tier__c == OneNumberTier && ct.CRDB_Copay_Logic__c == NonForumularyLabel)
                    {
                        tier1MailNonFormularyString = ct.Non_Formulary_String__c;
                        tier1MailNonFormularyString = tier1MailNonFormularyString.toLowerCase();
                        mailgiveerrormessage = True;
                    }
            if(ct.Tier__c == ThreeNumberTier)
                {
                    //tier3MailNonFormularyString = ((ct.Dollar_Amount__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Dollar_Amount__c)))) + ',' + ((ct.Percent__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Percent__c)))) + ',' + ((ct.Min_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Min_Dollar__c)))) + ',' + ((ct.Max_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Max_Dollar__c)))) + ',' + ((ct.Copay_Calc__c == null) ? '' : ct.Copay_Calc__c);
                    //tier3RetailNonFormularyString = tier3RetailNonFormularyString.toLowerCase();
                    tier3MailNonFormularyString = ct.non_formulary_string__c;
                    if(tier3MailNonFormularyString != null){//Richa added for testing
                    tier3MailNonFormularyString = tier3MailNonFormularyString.toLowerCase();}
                }
                    mailCopayTier = mailCopayTier +1;               
            }
            else if(ct.Recordtype.name == Paperlabel){
            if(ct.Tier__c == OneNumberTier && ct.CRDB_Copay_Logic__c == NonForumularyLabel)
                    {
                        tier1PaperNonFormularyString = ct.Non_Formulary_String__c;
                        tier1PaperNonFormularyString = tier1PaperNonFormularyString.toLowerCase();
                        Papergiveerrormessage = True;
                    }
            if(ct.Tier__c == ThreeNumberTier)
                {
                    //tier3PaperNonFormularyString = ((ct.Dollar_Amount__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Dollar_Amount__c)))) + ',' + ((ct.Percent__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Percent__c)))) + ',' + ((ct.Min_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Min_Dollar__c)))) + ',' + ((ct.Max_Dollar__c == null) ? '' : String.valueof(Decimal.valueof(string.valueof(ct.Max_Dollar__c)))) + ',' + ((ct.Copay_Calc__c == null) ? '' : ct.Copay_Calc__c);
                    //tier3RetailNonFormularyString = tier3RetailNonFormularyString.toLowerCase();
                    tier3PaperNonFormularyString = ct.non_formulary_string__c;
                    if(tier3PaperNonFormularyString != null){//Richa added for testing
                    tier3PaperNonFormularyString = tier3PaperNonFormularyString.toLowerCase();}
                }
                PaperCopayTier = PaperCopayTier +1;               
            }
            
            //  Ends **
            if(!ct.Stepped_Copay__c){
                if(ct.Tier_Type__c==null){ 
                    setErrorModel.add(new ErrorModel(' Copay Tier- Tier Type','ERR00012',  system.label.ERR00012));
                    isValid=false;
                }
                if(ct.Dollar_Amount__c==null && ct.Percent__c==null){
                    setErrorModel.add(new ErrorModel(' Copay Tier- Dollar Amount','ERR00051',  system.label.ERR00051));
                    isValid=false;
                }
                if(ct.Dollar_Amount__c!=null && ct.Percent__c!=null){
                    if(ct.Copay_Calc__c==null){
                        setErrorModel.add(new ErrorModel(' Copay Tier- Copay Calc','ERR00011',  system.label.ERR00011));
                        isValid=false;
                    }
                }  
            }else{
                if(ct.Dollar_Amount__c!=null || ct.Percent__c!=null){
                    if(ct.Copay_Calc__c==null){
                        setErrorModel.add(new ErrorModel(' Copay Tier- Copay Calc','ERR00063',  system.label.ERR00063));
                        isValid=false;
                    }
                    if(ct.Copay_Calc__c!=null && ct.Copay_Calc__c!='Greatest of All' && ct.Copay_Calc__c!='Least of All'){
                        setErrorModel.add(new ErrorModel(' Copay Tier- Copay Calc','ERR00064',  system.label.ERR00064));
                        isValid=false;                        
                    }
                }
                if(ct.Tier_Type__c==null){
                    setErrorModel.add(new ErrorModel(' Copay Tier- Tier Type','ERR00012',  system.label.ERR00012));
                    isValid=false;
                }
            }
        }  
        
         if(retailgiveerrormessage && retailCopayTier<3)
        {
            setErrorModel.add(new ErrorModel(' Copay Tier- CRDB Copay Logic','ERR00256',  system.label.ERR00256));
            isValid=false;
        }   else if(retailgiveerrormessage && retailCopayTier == 3)
                   {
                       
                        if(tier1RetailNonFormularyString != tier3RetailNonFormularyString)
                        {
                            setErrorModel.add(new ErrorModel(' Copay Tier- Non Formulary String','ERR00259',  system.label.ERR00259));
                            isValid=false;
                        }
                   }
                    
    if(mailgiveerrormessage && mailCopayTier<3)
        {
        
            setErrorModel.add(new ErrorModel(' Copay Tier- CRDB Copay Logic','ERR00257',  system.label.ERR00257));
            isValid=false;
        }   else if(mailgiveerrormessage && mailCopayTier == 3)
                   {
                       
                        if(tier1MailNonFormularyString != tier3MailNonFormularyString)
                        {
                          
                            setErrorModel.add(new ErrorModel(' Copay Tier- Non Formulary String','ERR00260',  system.label.ERR00260));
                            isValid=false;
                        }
                   }
    if(papergiveerrormessage && PaperCopayTier<3)
        {
            setErrorModel.add(new ErrorModel(' Copay Tier- CRDB Copay Logic','ERR00258',  system.label.ERR00258));
            isValid=false;
        }   else if(papergiveerrormessage && PaperCopayTier == 3)
                   {
                       
                        if(tier1PaperNonFormularyString != tier3PaperNonFormularyString)
                        {
                            setErrorModel.add(new ErrorModel(' Copay Tier- Non Formulary String','ERR00261',  system.label.ERR00261));
                            isValid=false;
                        }
                   }      
        return isValid;
    }
    
    /**
* Method :- checkTierType
* Description :- This Method check for the validation of copay tier type
**/        
    public boolean checkTierType(List<Copay_Tier__c> wrappedList){
        boolean isBrandAvailable=false;
        boolean isBrandChileAvailable=false;
        boolean isgenericAvailable=false;
        boolean isgenericSpecialAvailable=false;
        boolean isSpecialAvailable=false;
        boolean isSpecialChileAvailable=false;        
        boolean isValid = true;
        for(Copay_Tier__c ct:wrappedList){
            if(ct.Tier_Type__c!=null){
                if('Brand (SSB & MSB)'.equalsIgnoreCase(ct.Tier_Type__c)){
                    isBrandAvailable=true;
                }
                if('Specialty (Preferred & Non-Preferred)'.equalsIgnoreCase(ct.Tier_Type__c)){
                    isSpecialAvailable=true;
                }
                if('Generic (SSG & MSG)'.equalsIgnoreCase(ct.Tier_Type__c)){
                    isgenericAvailable=true;
                }
            }
        }
        
            
        if(isBrandAvailable){
            for(Copay_Tier__c ct:wrappedList){
                if('Single Source Brand (SSB)'.equalsIgnoreCase(ct.Tier_Type__c) 
                   || 'Multi Source Brand (MSB)'.equalsIgnoreCase(ct.Tier_Type__c)){
                       setErrorModel.add(new ErrorModel(' Copay Tier- Tier Type','ERR00028',  system.label.ERR00028));
                       isBrandChileAvailable = true;
                       break;
                   }
            }
        }
        if(isSpecialAvailable){
            for(Copay_Tier__c ct:wrappedList){
                if('Preferred Specialty'.equalsIgnoreCase(ct.Tier_Type__c) || 'Non-Preferred Specialty'.equalsIgnoreCase(ct.Tier_Type__c)){
                    setErrorModel.add(new ErrorModel(' Copay Tier- Tier Type','ERR00030',  system.label.ERR00030));
                    isSpecialChileAvailable= true;
                    break;
                }
            }
        }
        
        if(isgenericAvailable){
            for(Copay_Tier__c ct:wrappedList){
                if('Single Source Generic (SSG)'.equalsIgnoreCase(ct.Tier_Type__c) 
                   || 'Multi Source Generic (MSG)'.equalsIgnoreCase(ct.Tier_Type__c)){
                       setErrorModel.add(new ErrorModel(' Copay Tier- Tier Type','ERR00029',  system.label.ERR00029));
                       isgenericSpecialAvailable= true;
                       break;
                   }
            }
        }
        if(isBrandChileAvailable || isSpecialChileAvailable || isgenericSpecialAvailable){
            isValid =false;
        }
        return isValid;
    }  
    /**
* Method :- validateSteppedCopay
* Description :- This Method check for the validation of SteppedCopay__c
**/                      
    public boolean validateSteppedCopay(LIST<SteppedCopay__c > wrappedList){          
        boolean isValid = true;             
        if (wrappedList == null || wrappedList.size() == 0) {
            setErrorModel.add(new ErrorModel(' Stepped Copay','ERR00126',  system.label.ERR00126));
            isValid=false;
        }         
        if(wrappedList!= null && wrappedList.size()>0){
            isValid = checkCopayRange(wrappedList);
            if(!isvalid){
                setErrorModel.add(new ErrorModel(' Stepped Copay- Range','ERR00059',  system.label.ERR00059));                               
            }
            for(SteppedCopay__c ct:wrappedList){                          
                if(ct.Min_Range__c==null){
                    setErrorModel.add(new ErrorModel(' Stepped Copay- Min Range','ERR00077',  system.label.ERR00077));
                    isValid=false;
                }
                if(ct.Max_Range__c==null){
                    setErrorModel.add(new ErrorModel(' Stepped Copay- Max Range','ERR00046',  system.label.ERR00046));
                    isValid=false;
                }
                if(ct.Min_Range__c!=null && ct.Max_Range__c!=null){
                    if(ct.Min_Range__c > ct.Max_Range__c){
                        setErrorModel.add(new ErrorModel(' Stepped Copay- Min Range','ERR00008',  system.label.ERR00008));
                        isValid=false;
                    }
                }
                if(ct.Dollar_Amount__c==null && ct.Percent_Amount__c==null){                 
                    setErrorModel.add(new ErrorModel(' Stepped Copay- Dollar Amount','ERR00074',  system.label.ERR00074));
                    isValid=false;
                }
                if(ct.Dollar_Amount__c!=null && ct.Percent_Amount__c!=null){
                    if(ct.Copay_Calc__c==null){
                        setErrorModel.add(new ErrorModel(' Stepped Copay- Copay Calc','ERR00071',  system.label.ERR00071)); 
                        isValid=false;
                    }
                }
            }
        }
        return isValid;
    }
    /**
* Method :- checkCopayRange
* Description :- This Method check for the validation of stepped Copay Range
**/                    
    public boolean checkCopayRange(list<SteppedCopay__c>steppedCopayItemList){
        boolean isValid = true;
        Decimal previousMaxRange=0.00; 
        if(steppedCopayItemList.size()>1){
            for(integer i=0;i<steppedCopayItemList.size();i++){
                if(steppedCopayItemList.get(i).Max_Range__c!=null && i==0){                         
                    previousMaxRange=steppedCopayItemList.get(i).Max_Range__c;
                }else{                        
                    previousMaxRange=steppedCopayItemList.get(i-1).Max_Range__c;                         
                }
                if(i!=0 && steppedCopayItemList.get(i).Min_Range__c!=null && previousMaxRange >= steppedCopayItemList.get(i).Min_Range__c){
                    isValid=false;                       
                }
                if(!isValid){
                    break;
                }
            }
        }
        
        return isValid; 
    }
    /**
* Method :- validateDrugSpecificCopay
* Description :- This Method check for the validation of drug specific copay
**/            
    public boolean validateDrugSpecificCopay(list<Drug_Specific_Copay__c> wrappedList){
        boolean isValid = true;
        set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            } 
        set<Id> setMsCodeM=new set<Id>();
        set<Id> setMsCodeN=new set<Id>();
        set<Id> setMsCodeO=new set<Id>();
        set<Id> setMsCodeY=new set<Id>();
        
        for(Drug_Specific_Copay__c wrap:wrappedList){
            if(!wrap.Stepped_Copay__c){
                if(wrap.Dollar_Amount__c==null && wrap.Percent__c==null){
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Copay Calc','ERR00051',  system.label.ERR00051));
                    isValid=false;
                }
                if(wrap.Dollar_Amount__c!=null && wrap.Percent__c!=null){
                    if(wrap.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' Drug Specific Copay- Copay Calculation','ERR00011',  system.label.ERR00011));
                        isValid=false;
                    }
                }
                // added by Vikram for request 06211
                    if (wrap.Drug_Group__c!=null){
                        String alact = wrap.Drug_Group__r.Allowable_Actions__c;
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                        }else{
                            if(String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) || !alact.contains(DRUGSPECIFICCOPAY)){
                                setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                        }
                    }else if(wrap.Drug_List__c!=null){
                            String alact1 = wrap.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) || !alact1.contains(DRUGSPECIFICCOPAY)){
                                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                            }
                          }
                     // 06211 ends 
            }else{
                if(wrap.Dollar_Amount__c!=null || wrap.Percent__c!=null){
                    if(wrap.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' Drug Specific Copay- Copay Calculation','ERR00063',  system.label.ERR00063));
                        isValid=false;
                    }
                    if(wrap.Copay_Calculation__c!=null && wrap.Copay_Calculation__c!='Greatest of All' 
                       && wrap.Copay_Calculation__c!='Least of All'){
                           setErrorModel.add(new ErrorModel(' Drug Specific Copay- Copay Calculation','ERR00064',  system.label.ERR00064));
                           isValid=false;                         
                       }
                }
                if(wrap.Drug_Group__c==null && wrap.Drug_List__c==null) {
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR00022',  system.label.ERR00022));
                    isValid=false;                    
                }
                if(wrap.Drug_Group__c!=null && wrap.Drug_List__c!=null) {
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR00022',  system.label.ERR00022));
                    isValid=false;                    
                }
                
                // added by Vikram for request 06211
                    if (wrap.Drug_Group__c!=null){
                        String alact = wrap.Drug_Group__r.Allowable_Actions__c;
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                        }else{
                            if(String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) || !alact.contains(DRUGSPECIFICCOPAY)){
                                setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                        }
                    }else if(wrap.Drug_List__c!=null){
                            String alact1 = wrap.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) || !alact1.contains(DRUGSPECIFICCOPAY)){
                                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Drug Group','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                            }
                          }
                     // 06211 ends 
            }
            
            if(!wrap.M__c && !wrap.N__c && !wrap.O__c && !wrap.Y__c){
                setErrorModel.add(new ErrorModel(' Drug Specific Copay- M,N,O,Y','ERR00006',  system.label.ERR00006));
                isValid=false;
            }         
            if(wrap.M__c!=null && wrap.M__c){
                if(setMsCodeM!=null && wrap.Drug_List__c!=Null && setMsCodeM.contains(wrap.Drug_List__c)){
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- M','ERR00065',  system.label.ERR00065));
                    isValid=false;
                }else{                          
                    setMsCodeM.add(wrap.Drug_List__c);
                }
            }
            if(wrap.N__c!=null &&wrap.N__c){
                if(setMsCodeN!=null && wrap.Drug_List__c!=Null && setMsCodeN.contains(wrap.Drug_List__c)){
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- N','ERR00065',  system.label.ERR00065));
                    isValid=false;
                }else{                          
                    setMsCodeN.add(wrap.Drug_List__c);
                }
            }
            if(wrap.O__c!=null &&wrap.O__c){
                if(setMsCodeO!=null && wrap.Drug_List__c!=Null && setMsCodeO.contains(wrap.Drug_List__c)){
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- O','ERR00065',  system.label.ERR00065));
                    isValid=false;
                }else{                          
                    setMsCodeO.add(wrap.Drug_List__c);
                }
            }
            if(wrap.Y__c!=null &&wrap.Y__c){
                if(setMsCodeY!=null && wrap.Drug_List__c!=Null && setMsCodeY.contains(wrap.Drug_List__c)){
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay- Y','ERR00065',  system.label.ERR00065));
                    isValid=false;
                }else{                          
                    setMsCodeY.add(wrap.Drug_List__c);
                }
            }
        }
        return isValid;
    }
    /**
* Method :- validateDrugSpecificSteppedCopay
* Description :- This Method check for the validation of Drug_Specific_Stepped_Copay__c
**/           
    public boolean validateDrugSpecificSteppedCopay(LIST<Drug_Specific_Stepped_Copay__c> wrappedList){
        boolean isValid = true;         

        if(wrappedList!= null && wrappedList.size()>0){
            isValid = checkDrugSpecificCopayRange(wrappedList);
            if(!isvalid){
                setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay','ERR00059',  system.label.ERR00059));                               
            }      
            for(Drug_Specific_Stepped_Copay__c ct:wrappedList){  
                //loop starts
                if(ct.Beginning_Range__c==null){
                    setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay- Beginning Range','ERR00077',  system.label.ERR00077));
                    isValid=false;
                }
                if(ct.End_Range__c==null){
                    setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay- End Range','ERR00046',  system.label.ERR00046));
                    isValid=false;
                }
                if(ct.Beginning_Range__c!=null && ct.End_Range__c!=null){
                    if(ct.Beginning_Range__c > ct.End_Range__c){
                        setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay- Beginning Range','ERR00008',  system.label.ERR00008));
                        isValid=false;
                    }
                }
                if(ct.Dollar_Amount__c==null && ct.Percent__c==null){                 
                    setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay- Dollar Amount','ERR00074',  system.label.ERR00074));
                    isValid=false;
                }
                if(ct.Dollar_Amount__c!=null && ct.Percent__c!=null){
                    if(ct.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' Drug Specific Stepped Copay- Copay Calculation','ERR00071',  system.label.ERR00071));
                        isValid=false;
                    }
                }
                //loop ends  
            }
        } 

        return  isValid;          
    }
    /**
* Method :- checkDrugSpecificCopayRange
* Description :- This Method check for the validation of Drug_Specific_Stepped_Copay__c's Copay Range
**/                    
    public boolean checkDrugSpecificCopayRange(list<Drug_Specific_Stepped_Copay__c>steppedCopayItemList){
        boolean isValid = true;
        Decimal previousMaxRange=0.00;  
        //previousMaxRange=0.00;
        if(steppedCopayItemList.size()>1){
            for(integer i=0;i<steppedCopayItemList.size();i++){
                if(steppedCopayItemList.get(i).End_Range__c!=null && i==0){                         
                    previousMaxRange=steppedCopayItemList.get(i).End_Range__c;
                }else{                        
                    previousMaxRange=steppedCopayItemList.get(i-1).End_Range__c;                         
                }
                if(i!=0 && steppedCopayItemList.get(i).Beginning_Range__c!=null 
                   && previousMaxRange >= steppedCopayItemList.get(i).Beginning_Range__c){
                       isValid=false;                       
                   }
                if(!isValid){
                    break;
                }
            }
        }   
        return  isValid; 
    } 
    /* 
* Method :- validatedawSpecificCopay
* Description :- This Method check for validation of new DAW specific copay
*/   
    public boolean validatedawSpecificCopay(list<DAW_Specific_Copay__c> wrappedList){
        boolean isValid = true; 
        
        for(DAW_Specific_Copay__c wrap:wrappedList){
            if(!wrap.Stepped__c){
                if(wrap.Dollar_Amount__c==null && wrap.Percent__c==null){
                    setErrorModel.add(new ErrorModel(' DAW Specific Copay- Dollar Amount, Percent','ERR00051',  system.label.ERR00051));
                    isValid=false;
                }
                if(wrap.Dollar_Amount__c!=null && wrap.Percent__c!=null){
                    if(wrap.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' DAW Specific Copay- Copay Calculation','ERR00011',  system.label.ERR00011));
                        isValid=false;
                    }
                }
                if(wrap.Maximum_Dollar__c!=null && wrap.Minimum_Dollar__c!=null){
                    if(wrap.Minimum_Dollar__c > wrap.Maximum_Dollar__c){
                        setErrorModel.add(new ErrorModel(' DAW Specific Copay- Minimum Dollar','ERR00060',  system.label.ERR00060));
                        isValid=false;
                    }
                }   
            }else{
                if(wrap.Dollar_Amount__c!=null || wrap.Percent__c!=null){
                    if(wrap.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' DAW Specific Copay- Copay Calculation','ERR00011',  system.label.ERR00011));
                        isValid=false;
                    }
                    if(wrap.Copay_Calculation__c!=null && wrap.Copay_Calculation__c!='Greatest of All' 
                       && wrap.Copay_Calculation__c!='Least of All'){
                           setErrorModel.add(new ErrorModel(' DAW Specific Copay- Copay Calculation','ERR00064',  system.label.ERR00064));
                           isValid=false;                        
                       }
                }
            }
        }
        if(wrappedList != Null && wrappedList.size() >0){
            isValid = checkUniqueMNOY(wrappedList);
        }
        return isValid;
    }
    /* 
* Method :- checkUniqueMNOY
* Description :- This Method check for validation unique DAW specific Copay
*/ 
    public boolean checkUniqueMNOY(list<DAW_Specific_Copay__c> wrappedList){
        boolean isValid = true; 
        set<String> setMsCodeM=new set<String>();
        set<String> setMsCodeN=new set<String>();
        set<String> setMsCodeO=new set<String>();
        set<String> setMsCodeY=new set<String>();
        
        for(DAW_Specific_Copay__c wrap:wrappedList){
            //for unique MNOY and Daw code combination              
            if(wrap.MS_Code_M__c!=null && wrap.MS_Code_M__c){
                if(setMsCodeM!=null && setMsCodeM.contains(wrap.DAW_Code__c)){
                    setErrorModel.add(new ErrorModel(' DAW Specific Copay- M','ERR00066',  system.label.ERR00066));
                    isValid=false;
                }else{
                    setMsCodeM.add(wrap.DAW_Code__c);
                }
            }
            if(wrap.MS_Code_N__c!=null &&wrap.MS_Code_N__c){
                if(setMsCodeN!=null && setMsCodeN.contains(wrap.DAW_Code__c)){
                    setErrorModel.add(new ErrorModel(' DAW Specific Copay- N','ERR00066',  system.label.ERR00066));
                    isValid=false;
                }else{                      
                    setMsCodeN.add(wrap.DAW_Code__c);
                }
            }
            if(wrap.MS_Code_O__c!=null &&wrap.MS_Code_O__c){
                if(setMsCodeO!=null && setMsCodeO.contains(wrap.DAW_Code__c)){
                    setErrorModel.add(new ErrorModel(' DAW Specific Copay- O','ERR00066',  system.label.ERR00066));
                    isValid=false;
                }else{                      
                    setMsCodeO.add(wrap.DAW_Code__c);
                }
            }
            if(wrap.MS_Code_Y__c!=null &&wrap.MS_Code_Y__c){
                if(setMsCodeY!=null && setMsCodeY.contains(wrap.DAW_Code__c)){
                    setErrorModel.add(new ErrorModel(' DAW Specific Copay- Y','ERR00066',  system.label.ERR00066));
                    isValid=false;
                }else{                          
                    setMsCodeY.add(wrap.DAW_Code__c);
                }
            }
            if(!wrap.MS_Code_M__c && !wrap.MS_Code_N__c && !wrap.MS_Code_O__c && !wrap.MS_Code_Y__c){
                setErrorModel.add(new ErrorModel(' DAW Specific Copay- M,N,O,Y','ERR00006',  system.label.ERR00006));
                isValid=false;
            }                        
        }
        return isValid;
    }
    /* 
* Method :- validatedawSpecificSteppedCopay
* Description :- This method check for the validation of CRDDAWSpecificSteppedCopay and display error message accordingly
*/   
    public boolean validatedawSpecificSteppedCopay(list<DAW_Specific_Stepped_Copay__c> wrappedList){
        boolean isValid = true;
        
        if(wrappedList!=null && wrappedList.size()>0){
            isValid = checkDawCopayRange(wrappedList);
            if(!isvalid){
                setErrorModel.add(new ErrorModel(' DAW Specific stepped Copay','ERR00059',  system.label.ERR00059));                             
            }                
            for(DAW_Specific_Stepped_Copay__c steppedCopay:wrappedList){
                if(steppedCopay.Dollar_Amount__c==null && steppedCopay.Percent__c==null){
                    setErrorModel.add(new ErrorModel(' DAW Specific stepped Copay- Dollar Amount','ERR00074',  system.label.ERR00074));
                    isValid=false;
                }                      
                if(steppedCopay.Dollar_Amount__c!=null && steppedCopay.Percent__c!=null){
                    if(steppedCopay.Copay_Calculation__c==null){
                        setErrorModel.add(new ErrorModel(' DAW Specific stepped Copay- Copay Calculation','ERR00011',  system.label.ERR00011));
                        isValid=false;
                    }
                }
                if(steppedCopay.Maximum_Dollar__c!=null && steppedCopay.Minimum_Dollar__c!=null){
                    if(steppedCopay.Minimum_Dollar__c > steppedCopay.Maximum_Dollar__c){
                        setErrorModel.add(new ErrorModel(' DAW Specific stepped Copay- Minimum Dollar','ERR00060',  system.label.ERR00060));
                        isValid=false;
                    }
                }                      
                if(steppedCopay.Beginning_Range__c!=null && steppedCopay.End_Range__c!=null){
                    if(steppedCopay.Beginning_Range__c > steppedCopay.End_Range__c){
                        setErrorModel.add(new ErrorModel(' DAW Specific stepped Copay- Beginning Range','ERR00008',  system.label.ERR00008));
                        isValid=false;
                    }
                }                                   
            }
        }
        return isValid;     
    } 
    /* 
* Method :- checkDawCopayRange
* Description :- This method check for validation of range of CRD DAW specific stepped Copay
*/      
    public boolean checkDawCopayRange(list<DAW_Specific_Stepped_Copay__c>steppedCopayItemList){
        boolean isValid = true;
        Decimal previousMaxRange=0.00;  
        if(steppedCopayItemList.size()>1){
            for(integer i=0;i<steppedCopayItemList.size();i++){
                if(steppedCopayItemList.get(i).End_Range__c!=null && i==0){                         
                    previousMaxRange=steppedCopayItemList.get(i).End_Range__c;
                }else{                        
                    previousMaxRange=steppedCopayItemList.get(i-1).End_Range__c;                         
                }
                if(i!=0 && steppedCopayItemList.get(i).Beginning_Range__c!=null 
                   && previousMaxRange >= steppedCopayItemList.get(i).Beginning_Range__c){
                       isValid=false;                       
                   }
                if(!isValid){
                    break;
                }
            }
        }
        return  isValid; 
    }
    
    /**
* Method :- validateWaiverOfDeductible
* Description :- This Method check for the uniqueness of MNOY in Waiver of Deductible object
**/    
    public boolean validateWaiverOfDeductible(LIST< Waiver_Of_Deductible__c > wrappedList){   
        boolean isValid = true;       
        set<string> setMsCodeM=new set<string>();
        set<string> setMsCodeN=new set<string>();
        set<string> setMsCodeO=new set<string>();
        set<string> setMsCodeY=new set<string>();
       
        set<string> setMsCodeMdG=new set<string>();
        set<string> setMsCodeNdG=new set<string>();
        set<string> setMsCodeOdG=new set<string>();
        set<string> setMsCodeYdG=new set<string>();
        
        if(wrappedList!=null && wrappedList.size()>0){          
            for(Waiver_Of_Deductible__c wrap : wrappedList){
                if(!wrap.M__c && !wrap.N__c && !wrap.O__c && !wrap.Y__c){
                    setErrorModel.add(new ErrorModel(' Waiver Of Deductible - M,N,O,Y','ERR00006',  system.label.ERR00006));
                    isValid=false;
                    break;
                }
                if(wrap.M__c!=null && wrap.M__c){
                    if(setMsCodeM!=null && wrap.Drug_List__c!=Null && setMsCodeM.contains(wrap.Drug_List__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeM.add(wrap.Drug_List__c+wrap.Delivery_System__c);
                    }
                    
                    if(setMsCodeMdG!=null && wrap.Drug_Group__c!=Null && setMsCodeMdG.contains(wrap.Drug_Group__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeMdG.add(wrap.Drug_Group__c+wrap.Delivery_System__c);
                    }
                }
                if(wrap.N__c!=null && wrap.N__c){
                    if(setMsCodeN!=null && wrap.Drug_List__c!=Null && setMsCodeN.contains(wrap.Drug_List__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeN.add(wrap.Drug_List__c+wrap.Delivery_System__c);
                    }
                    
                    if(setMsCodeNdG!=null && wrap.Drug_Group__c!=Null && setMsCodeNdG.contains(wrap.Drug_Group__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeNdG.add(wrap.Drug_Group__c+wrap.Delivery_System__c);
                    }
                }
                if(wrap.O__c!=null && wrap.O__c){
                    if(setMsCodeO!=null && wrap.Drug_List__c!=Null && setMsCodeO.contains(wrap.Drug_List__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeO.add(wrap.Drug_List__c+wrap.Delivery_System__c);
                    }
                    if(setMsCodeOdG!=null && wrap.Drug_Group__c!=Null && setMsCodeOdG.contains(wrap.Drug_Group__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeOdG.add(wrap.Drug_Group__c+wrap.Delivery_System__c);
                    }
                }
                if(wrap.Y__c!=null && wrap.Y__c){
                    if(setMsCodeY!=null && wrap.Drug_List__c!=Null && setMsCodeY.contains(wrap.Drug_List__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeY.add(wrap.Drug_List__c+wrap.Delivery_System__c);
                    }
                    if(setMsCodeYdG!=null && wrap.Drug_Group__c!=Null && setMsCodeYdG.contains(wrap.Drug_Group__c+wrap.Delivery_System__c)){
                        setErrorModel.add(new ErrorModel(' Waiver Of Deductible - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                        break;
                    }else{                          
                        setMsCodeYdG.add(wrap.Drug_Group__c+wrap.Delivery_System__c);
                    }
                }               
            }
        }
        return isValid;
        
    }
    
    /* 
* Method :- validateFamilyFields
* Description :- This method check for the validation of fields of Accumulation
*/  
    public Boolean validateFamilyFields(Accumulations__c accumulation,String userSelectionRecordTypeName){
        boolean isValid = true;         
        if(accumulation.Carry_Balance_when_member_moves__c==null){
            setErrorModel.add(new ErrorModel(' Accumulation - Carry Balance when member moves','ERR00024',  system.label.ERR00024));
            isValid=false;
        }
        if(accumulation.Start_Month_New__c==null){ 
            setErrorModel.add(new ErrorModel(' Accumulation - Start Month New','ERR00024',  system.label.ERR00024));
            isValid=false;
        }
        if(accumulation.Start_Day__c==null){
            setErrorModel.add(new ErrorModel(' Accumulation - Start Day','ERR00024',  system.label.ERR00024));
            isValid=false;
        }
        if(accumulation.Is_there_a_Maximum_Allowable_Benefit__c==null){
            setErrorModel.add(new ErrorModel(' Accumulation - Is there a Maximum Allowable Benefit','ERR00024',  system.label.ERR00024));
            isValid=false;
        }
        if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c==null){
            setErrorModel.add(new ErrorModel(' Accumulation - Is there a Maximum Out of Pocket','ERR00024',  system.label.ERR00024));
            isValid=false;
        }
        if('Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Allowable_Benefit__c) 
           && accumulation.MAB_Dedictible_Amount__c==null){
               setErrorModel.add(new ErrorModel(' Accumulation - MAB Dedictible Amount','ERR00024',  system.label.ERR00024));
               isValid=false;
           }                
        if('Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Allowable_Benefit__c) 
           && accumulation.What_happens_when_the_MAB_is_met__c==null){
               setErrorModel.add(new ErrorModel(' Accumulation - What happens when the MAB is met','ERR00024',  system.label.ERR00024));
               isValid=false;
           }         
        if('Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Out_of_Pocket__c) 
           && accumulation.Deductible_Applies_towards_the_MOOP__c==null){
               setErrorModel.add(new ErrorModel(' Accumulation - Deductible Applies towards the MOOP','ERR00024',  system.label.ERR00024));
               isValid=false;
           } 
        if('Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Out_of_Pocket__c) 
           && accumulation.MOOP_Dedictible_Amount__c!=null && double.valueOf(accumulation.MOOP_Dedictible_Amount__c)>0.00){
               if(accumulation.MOOP_Period__c==null){
                   setErrorModel.add(new ErrorModel(' Accumulation - MOOP Period','ERR00058',  system.label.ERR00058));
                   isValid=false;
               }
           }               
        if('Yes'.equalsIgnoreCase(accumulation.Is_there_a_Maximum_Allowable_Benefit__c) 
           && accumulation.MAB_Dedictible_Amount__c!=null && double.valueOf(accumulation.MAB_Dedictible_Amount__c)>0){
               if(accumulation.MAB_Period__c==null){
                   setErrorModel.add(new ErrorModel(' Accumulation - MAB Period','ERR00057',  system.label.ERR00057));
                   isValid=false;
               }
           }        
        return isValid ;
    }
    /**
* Method :- validateAccumulationDrugListMNOY
* Description :- This Method check for the validation of Accumulation Drug List for MNOY
**/         
    public boolean validateAccumulationDrugListMNOY(LIST<AccumulationSpecificDrug__c> wrappedList, String recordTypeName){    
        boolean isValid = true;   
        set<Id> setMsCodeM=new set<Id>();
        set<Id> setMsCodeN=new set<Id>();
        set<Id> setMsCodeO=new set<Id>();
        set<Id> setMsCodeY=new set<Id>();
        
        set<Id> setMsCodeMdG=new set<Id>();
        set<Id> setMsCodeNdG=new set<Id>();
        set<Id> setMsCodeOdG=new set<Id>();
        set<Id> setMsCodeYdG=new set<Id>();        
        if(wrappedList!=null && wrappedList.size()>0){          
            for(AccumulationSpecificDrug__c wrap:wrappedList){
                if(!wrap.M__c && !wrap.N__c && !wrap.O__c && !wrap.Y__c){
                    setErrorModel.add(new ErrorModel(' Accumulation - M,N,O,Y','ERR00006',  system.label.ERR00006));
                    isValid=false;
                }
                
                // For Unique MNOY       
                if(wrap.M__c!=null && wrap.M__c){
                    if(setMsCodeM!=null && wrap.Drug_List__c!=Null && setMsCodeM.contains(wrap.Drug_List__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeM.add(wrap.Drug_List__c);
                    }
                    
                    if(setMsCodeMdG!=null && wrap.Drug_Group__c!=Null && setMsCodeMdG.contains(wrap.Drug_Group__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeMdG.add(wrap.Drug_Group__c);
                    }
                }
                if(wrap.N__c!=null &&wrap.N__c){
                    if(setMsCodeN!=null && wrap.Drug_List__c!=Null && setMsCodeN.contains(wrap.Drug_List__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeN.add(wrap.Drug_List__c);
                    }                    
                    if(setMsCodeNdG!=null && wrap.Drug_Group__c!=Null && setMsCodeNdG.contains(wrap.Drug_Group__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeNdG.add(wrap.Drug_Group__c);
                    }
                }
                if(wrap.O__c!=null &&wrap.O__c){
                    if(setMsCodeO!=null && wrap.Drug_List__c!=Null && setMsCodeO.contains(wrap.Drug_List__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeO.add(wrap.Drug_List__c);
                    }
                    if(setMsCodeOdG!=null && wrap.Drug_Group__c!=Null && setMsCodeOdG.contains(wrap.Drug_Group__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeOdG.add(wrap.Drug_Group__c);
                    }
                }
                if(wrap.Y__c!=null &&wrap.Y__c){
                    if(setMsCodeY!=null && wrap.Drug_List__c!=Null && setMsCodeY.contains(wrap.Drug_List__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug List','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeY.add(wrap.Drug_List__c);
                    }
                    if(setMsCodeYdG!=null && wrap.Drug_Group__c!=Null && setMsCodeYdG.contains(wrap.Drug_Group__c)){
                        setErrorModel.add(new ErrorModel(' Accumulation - Drug Group','ERR00065',  system.label.ERR00065));
                        isValid=false;
                    }else{                          
                        setMsCodeYdG.add(wrap.Drug_Group__c);
                    }
                }
                
            }
        }
        return isValid;
        
    }
    /**
* Method :- validateAccumulationDrugListDeductible
* Description :- This Method check for the validation of Accumulation Drug List
**/ 
    public boolean validateAccumulationDrugListDeductible(LIST<AccumulationSpecificDrug__c> wrappedList, String recordTypeName){
        boolean isValid = true;
        set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }            
        if(wrappedList!=null && wrappedList.size()>0){                           
            for(AccumulationSpecificDrug__c wrap:wrappedList){               
                if(wrap.Drug_List__c==null && wrap.Drug_Group__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR00019',  system.label.ERR00019));
                    isValid=false;
                }
                if(wrap.Drug_List__c!=null && wrap.Drug_Group__c!=null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR00069',  system.label.ERR00069));
                    isValid=false;
                } 
                // added by Vikram for request 06211
                    if (wrap.Drug_Group__c!=null){
                        String alact = wrap.Drug_Group__r.Allowable_Actions__c;
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                        }else{
                            if(String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) || !(alact.contains(DRUGSPECIFICACCUM))){
                                setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                        }
                    }else if(wrap.Drug_List__c!=null){
                            String alact1 = wrap.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) || !(alact1.contains(DRUGSPECIFICACCUM))){
                                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                             }
                            }
                    // 06211 ends  
                if(wrap.Deductible_Amount__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Deductible Amount','ERR00024',  system.label.ERR00024));
                    isValid=false;                      
                }   
                if(wrap.Deductible_Period__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Deductible Period','ERR00024',  system.label.ERR00024));
                    isValid=false;
                }
                if(wrap.Deuductible_Accumulation_from_4th_Qtr__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Deuductible Accumulation from 4th Qtr'
                                                     ,'ERR00024'
                                                     ,system.label.ERR00024));
                    isValid=false;
                } 
            }  
        } 
        return isValid;          
    }
    /**
* Method :- validateAccumulationDrugListMab
* Description :- This Method check for the validation of Accumulation Drug List
**/        
    public boolean validateAccumulationDrugListMab(LIST<AccumulationSpecificDrug__c> wrappedList,String recordTypeName){    
        boolean isValid = true;       
        set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }                        
        if(wrappedList!=null && wrappedList.size()>0){          
            for(AccumulationSpecificDrug__c wrap:wrappedList){            
                if(wrap.Drug_List__c==null && wrap.Drug_Group__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug Group, Drug List','ERR00020',  system.label.ERR00020));
                    isValid=false;
                }                        
                if(wrap.Drug_List__c!=null && wrap.Drug_Group__c!=null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug Group, Drug List','ERR00069',  system.label.ERR00069));
                    isValid=false;
                }
                // added by Vikram for request 06211
                    if (wrap.Drug_Group__c!=null){
                        String alact = wrap.Drug_Group__r.Allowable_Actions__c;
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                        }else{
                            if(String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) || !(alact.contains(DRUGSPECIFICACCUM))){
                                setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                        }
                    }else if(wrap.Drug_List__c!=null){
                            String alact1 = wrap.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) || !(alact1.contains(DRUGSPECIFICACCUM))){
                                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                             }
                            }
                    // 06211 ends   
                /*if(wrap.What_happens_when_MAB_is_met__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - What happens when MAB is met','ERR00024',  system.label.ERR00024));
                    isValid=false;
                } */ 
                //Below 2 If Loops, added by Sushant for Request 07033 -- ** Start **--
                if((wrap.Exclude_from_Accumulation__c != NULL && wrap.Exclude_from_Accumulation__c == True) && (wrap.MAB_Period__c != NULL || wrap.MAB_Dedictible_Amount__c != NULL || wrap.What_happens_when_MAB_is_met__c !=NULL))
                    {
                        setErrorModel.add(new ErrorModel(' Accumulation Specific Drug- Exclude From Accumulation','ERR0285',  system.label.ERR0285));
                        isValid=false;
                    }
                if((wrap.Exclude_from_Accumulation__c == FALSE) && (wrap.MAB_Period__c == NULL || wrap.MAB_Dedictible_Amount__c == NULL || wrap.What_happens_when_MAB_is_met__c == NULL))
                    {
                        setErrorModel.add(new ErrorModel(' Accumulation Specific Drug - Exclude From Accumulation','ERR0284',  system.label.ERR0284));
                        isValid=false;
                    }
                // Request 07033 -- ** End ** --
                // Below 2 If Loops Commented by Sushant for Request 07033  -- ** Start ** --
                /*
                if(wrap.MAB_Dedictible_Amount__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - MAB Dedictible Amount','ERR00024',  system.label.ERR00024));
                    isValid=false;  
                }
                if(wrap.MAB_Period__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - MAB Period','ERR00024',  system.label.ERR00024));
                    isValid=false;
                } */
                // Request 07033 -- ** End ** --
            }          
        }
        return isValid;          
    }
    
    /**
* Method :- validateAccumulationDrugListMoop
* Description :- This Method check for the validation of Accumulation Drug List
**/ 
    public boolean validateAccumulationDrugListMoop(Accumulations__c accumulation, LIST<AccumulationSpecificDrug__c> wrappedList,String recordTypeName){
        boolean isValid = true; 
        set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }    
        if(wrappedList!=null && wrappedList.size()>0){          
            for(AccumulationSpecificDrug__c wrap:wrappedList){
                if(wrap.Drug_List__c==null && wrap.Drug_Group__c==null){                
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR00021',  system.label.ERR00021));
                    isValid=false;
                }  
                if(wrap.Drug_List__c!=null && wrap.Drug_Group__c!=null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR00069',  system.label.ERR00069));
                    isValid=false;
                }
                // added by Vikram for request 06211
                    if (wrap.Drug_Group__c!=null){
                        String alact = wrap.Drug_Group__r.Allowable_Actions__c;
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)){   
                        }else{
                            if(String.isBlank(wrap.Drug_Group__r.Allowable_Actions__c) || !(alact.contains(DRUGSPECIFICACCUM))){
                                setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                        }
                    }else if(wrap.Drug_List__c!=null){
                            String alact1 = wrap.Drug_List__r.Allowable_Actions__c;
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)){   
                            }else{
                                if(String.isBlank(wrap.Drug_List__r.Allowable_Actions__c) || !(alact1.contains(DRUGSPECIFICACCUM))){
                                    setErrorModel.add(new ErrorModel(' Accumulation - Drug List,Drug Group','ERR0298',  system.label.ERR0298));
                                    isValid=false;
                                }
                             }
                            }
                    // 06211 ends  
                //Below 2 If Loops, added by Sushant for Request 07033 -- ** Start **--
                if((wrap.Exclude_from_Accumulation__c != NULL && wrap.Exclude_from_Accumulation__c == True) && (wrap.MOOP_Period__c != NULL || wrap.MOOP_Dedictible_Amount__c != NULL || wrap.What_happens_when_MOOP_is_met__c !=NULL || wrap.DAW_Differential_Penalty_Applies_to_MOOP__c != NULL || wrap.Deductible_Applies_towards_the_MOOP__c !=NULL))
                    {
                        setErrorModel.add(new ErrorModel(' Accumulation Specific Drug - Exclude From Accumulation','ERR0287',  system.label.ERR0287));
                        isValid=false;
                    }
                if((wrap.Exclude_from_Accumulation__c == FALSE) && (wrap.MOOP_Period__c == NULL || wrap.MOOP_Dedictible_Amount__c == NULL || wrap.What_happens_when_MOOP_is_met__c == NULL || wrap.DAW_Differential_Penalty_Applies_to_MOOP__c == NULL || wrap.Deductible_Applies_towards_the_MOOP__c == NULL))
                    {
                        setErrorModel.add(new ErrorModel(' Accumulation Specific Drug - Exclude From Accumulation','ERR0286',  system.label.ERR0286));
                        isValid=false;
                    }
                // Request 07033 -- ** End ** --
                // Below 2 If Loops Commented by Sushant for Request 07033  -- ** Start ** --
                /*          
                if(wrap.MOOP_Period__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - MOOP Period','ERR00024',  system.label.ERR00024));
                    isValid=false;                
                }  
                if(wrap.Deductible_Applies_towards_the_MOOP__c==null){
                    setErrorModel.add(new ErrorModel(' Accumulation - Deductible Applies towards the MOOP','ERR00024',  system.label.ERR00024));
                    isValid=false;                
                }   
                // Request 07033 -- ** End ** --    
                */                     
            }
        }
        return isValid;          
    }
    /**
* Method :- programScreenValidation
* Description :- This method check for validation of crd fields and display error message accordingly
**/    
    public boolean programScreenValidation(crd__C crdRec){
        boolean isValid = true;         
        if (crdRec.Pharmacy_Advisor__c ) {
            if (!crdRec.Adherence_to_Drug_Therapy__c  || !crdRec.Aetna_Autofill__c   ) {
                setErrorModel.add(new ErrorModel(' CRD - Adherence to Drug Therapy,Aetna Autofill','ERR00148',  system.label.ERR00148));
                isValid=false;
            }
        }
        
        if ('Yes'.equalsIgnoreCase(crdRec.Is_DM_vendor_the_same_for_each_condition__c) 
            && (crdRec.Implementation_Type__c == null || string.isblank(crdRec.Implementation_Type__c))) {
                setErrorModel.add(new ErrorModel(' CRD - Implementation Type','ERR00144',  system.label.ERR00144));
                isValid=false;
            } 
        
        
        if (crdRec.Disease_Management_Referral_Messaging__c != NULL 
            && 'Yes'.equalsIgnoreCase(crdRec.Disease_Management_Referral_Messaging__c)){
                if(crdRec.Disease_Management_Messaging_for__c == NULL || crdRec.Is_DM_vendor_the_same_for_each_condition__c == NULL ){
                    setErrorModel.add(new ErrorModel(' CRD - Disease Management Messaging for,Is DM vendor the same for each condition'
                                                     ,'ERR00190'
                                                     ,system.label.ERR00190));
                    isValid=false;
                }
            }
        
        if (crdRec.Pharmacy_Advisor__c != NULL && crdRec.Pharmacy_Advisor__c){
            if(crdRec.Implementation_Type__c == NULL || crdRec.Enrolled_in_PA_for_other_condition__c == NULL 
               || crdRec.Participate_in_CVS_mail_pharmacy_service__c == NULL ||
               crdRec.Disease_Management_Referral_Messaging__c == NULL){
                   setErrorModel.add(new ErrorModel(' CRD - Disease Management Referral Messaging,Participate in CVS mail pharmacy service'
                                                    ,'ERR00191'
                                                    ,system.label.ERR00191));
                   isValid=false;
               }      
        }
        
        if (crdRec.Is_DM_vendor_the_same_for_each_condition__c != NULL 
            && 'No'.equalsIgnoreCase(crdRec.Is_DM_vendor_the_same_for_each_condition__c)){
                if(crdRec.PA_Disease_Vendor_1__c == NULL 
                   || crdRec.PA_Condition_1__c == NULL 
                   || crdRec.PA_Custom_Disease_Vendor_Phone_1__c == NULL 
                   || crdRec.PA_DM_Vendor_Contract_End_Date_1__c == NULL 
                   || crdRec.PA_Disease_Vendor_2__c == NULL 
                   || crdRec.PA_Condition_2__c == NULL 
                   || crdRec.PA_Custom_Disease_Vendor_Phone_2__c == NULL 
                   || crdRec.PA_DM_Vendor_Contract_End_Date_2__c == NULL){
                       setErrorModel.add(new ErrorModel(' CRD - Is DM vendor the same for each condition','ERR00192',  system.label.ERR00192));
                       isValid=false;
                   }
            }
        if(crdRec.Implementation_Type__c != NULL 
           && 'Pharmacy Advisor All Conditions Complete Buy-Up Option'.equalsIgnoreCase(crdRec.Implementation_Type__c)){
               if((crdRec.PA_Condition_1__c != NULL && crdRec.PA_Condition_1__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_2__c != NULL && crdRec.PA_Condition_2__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_3__c != NULL && crdRec.PA_Condition_3__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_4__c != NULL && crdRec.PA_Condition_4__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_5__c != NULL && crdRec.PA_Condition_5__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_6__c != NULL && crdRec.PA_Condition_6__c != 'All Other Conditions') 
                  || (crdRec.PA_Condition_7__c != NULL && crdRec.PA_Condition_7__c != 'All Other Conditions')){
                      setErrorModel.add(new ErrorModel(' CRD - Implementation Type','ERR00195',  system.label.ERR00195));
                      isValid=false;
                  }
           }
        List<String> condition_List = New List<String>();
        
        If(crdRec.PA_Condition_1__c != NULL){
            Condition_List.add(crdRec.PA_Condition_1__c);
        }
        If(crdRec.PA_Condition_2__c != NULL){
            Condition_List.add(crdRec.PA_Condition_2__c);
        }
        If(crdRec.PA_Condition_3__c != NULL){
            Condition_List.add(crdRec.PA_Condition_3__c);
        }
        If(crdRec.PA_Condition_4__c != NULL){
            Condition_List.add(crdRec.PA_Condition_4__c);
        }
        If(crdRec.PA_Condition_5__c != NULL){
            Condition_List.add(crdRec.PA_Condition_5__c);
        }
        If(crdRec.PA_Condition_6__c != NULL){
            Condition_List.add(crdRec.PA_Condition_6__c);
        }
        If(crdRec.PA_Condition_7__c != NULL){
            Condition_List.add(crdRec.PA_Condition_7__c);
        }
        
        integer sizeOfList = Condition_List.Size();
        
        for(integer i=0; i<SizeOfList ; i++){  
            for(integer j=i+1; j<SizeOfList ; j++){    
                if(Condition_List[i] == Condition_List[j]){
                    setErrorModel.add(new ErrorModel(' CRD','ERR00194',  system.label.ERR00194));
                    isValid=false;          
                }
            }
        }
        return isValid;
    }
    
    /**
* Method :- isElementCommon
* Description :- Method that takes two string str1 and str2 which are semi-colon delimited,
*                converts them to arrays and checks if there are elements common between them.
**/
    public boolean isElementCommon(String str1, String str2) {
        boolean isValid = false;
        if (str1 == null || str2 == null) {
            isValid=false;
        }
        String[] strList1 = str1.split(';');
        String[] strList2 = str2.split(';');
        Set < String > strSet1 = new Set < String > ();
        strSet1.addAll(strList1);
        for (String s: strList2) {
            if (strSet1.contains(s)) {
                isValid=True;
            }
        }
        return isValid;
    }
    
    /**
* Method :- cRDThirdScreenValidations
* Description :- This method check for validation of third screen CRD fields and display error messages accordingly
**/      
    public boolean cRDThirdScreenValidations (crd__c crd){
        boolean isValid = true;
       /* if('Custom'.equals(crd.Toll_Free_Number__c)){
            if(crd.Custom_TFN__c == NULL){
                setErrorModel.add(new ErrorModel(' CRD- Custom Toll Free Number','ERR00215',  system.label.ERR00215));
                isValid=false;
            }
        }*/
       /* if(crd.Does_plan_have_an_Open_Enrollment_Date__c){
            if(crd.Open_Enrollment_Date__c == NULL){
                setErrorModel.add(new ErrorModel(' CRD- Does plan have an Open Enrollment Date?','ERR00216',  system.label.ERR00216));
                isValid=false;
            }
        }*/
        
        if('Yes'.equals(crd.POS_Rebate_for_Plan__c)){
            if(crd.RTMD_Effective_Date__c == NULL || crd.RTMD_Client_Share_Percent__c== NULL ){
                setErrorModel.add(new ErrorModel(' CRD- POS Rebate for Plan?','ERR00217',  system.label.ERR00217));
                isValid=false;
            }
        }
        if('No'.equals(crd.POS_Rebate_for_Plan__c)){
            if(crd.RTMD_Effective_Date__c != NULL || crd.RTMD_Client_Share_Percent__c!= NULL ){
                setErrorModel.add(new ErrorModel(' CRD- POS Rebate for Plan?','ERR00218',  system.label.ERR00218));
                isValid=false;
            }
        }
        if(crd.In_Network_claims_are_reimbursed__c){
            if(crd.In_Network_Discount_Rate__c == NULL){
                setErrorModel.add(new ErrorModel(' CRD- In-Network claims are reimbursed','ERR00219',  system.label.ERR00219));
                isValid=false;
            }
        }
        if(crd.Out_of_Network_claims_are_reimbused__c){
            if(crd.Out_of_Network_Discount_Rate__c == NULL){
                setErrorModel.add(new ErrorModel(' CRD- Out-of-Network claims are reimbused','ERR00220',  system.label.ERR00220));
                isValid=false;
            }
        }
        if('No'.equals(crd.Does_the_client_want_to_do_COB__c)){
            if(crd.COB_or_MOB__c != Null 
               || crd.Process_Point_of_Sales_COB__c != False 
               || crd.Reimbursement_Levels__c != Null
               || crd.In_Network__c != False 
               || crd.In_Network_Reimbursement_Level__c != Null
               || crd.Out_of_Network__c != False 
               || crd.Out_of_Network_Reimbursement_Level__c != Null){ 
                   setErrorModel.add(new ErrorModel(' CRD- Does client want to coordinate benefits?','ERR0241',  system.label.ERR0241));
                   isValid=false;  
               }
        }
        if('Yes'.equals(crd.Does_the_client_want_to_do_COB__c)){
            if(crd.COB_or_MOB__c == NULL){
                setErrorModel.add(new ErrorModel(' CRD- Does client want to coordinate benefits?','ERR00221',  system.label.ERR00221));
                isValid=false;
            }
            if('COB'.equals(crd.COB_or_MOB__c)){
                if(crd.Process_Point_of_Sales_COB__c &&crd.Reimbursement_Levels__c != '100% of submitted charges less ZERO copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0235',  system.label.ERR0235));
                    isValid=false;
                }
                if(crd.In_Network__c && crd.In_Network_Reimbursement_Level__c != '100% submitted less ZERO copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0236',  system.label.ERR0236));
                    isValid=false;
                }
                if(crd.Out_of_Network__c && crd.Out_of_Network_Reimbursement_Level__c != '100% submitted less ZERO copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0237',  system.label.ERR0237));
                    isValid=false;
                }
            }
            if('MOB'.equals(crd.COB_or_MOB__c)){
                if(crd.Process_Point_of_Sales_COB__c && crd.Reimbursement_Levels__c != '100% of submitted charges less copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0238',  system.label.ERR0238));
                    isValid=false;
                }
                if(crd.In_Network__c  && crd.In_Network_Reimbursement_Level__c != '100% submitted charges less copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0239',  system.label.ERR0239));
                    isValid=false;
                }
                if(crd.Out_of_Network__c  && crd.Out_of_Network_Reimbursement_Level__c != '100% submitted charges less copay'){
                    setErrorModel.add(new ErrorModel(' CRD- COB or MOB?','ERR0240',  system.label.ERR0240));
                    isValid=false;
                }
            } 
        }
        return isValid;
    }
 
    /**
* Method :- valiadte_DCDL
* Description :- This Class is to capture error code, error desciption, and field value
**/ 
    public boolean valiadte_DCDL (drug_coverage__c drugCoverage){
        map<id,string> addedDGs = new map<id,string>();
        map<id,string> addedDLs = new map<id,string>();
        map<id,string> DLwithAA = new map<id,string>();
        map<id,string> DGwithAA = new map<id,string>();
        set<string> restrictedProfiles = new set<string>();
        boolean isValid = true;
        Set<Id> drugListIds = new Set<Id>();
        set<ID> druggroupIds = new set<Id>();
        string TempVar;
        for(DC_Drug_List_Group__c dcdl: [Select
                                             Id,Name,Allow_Transition_Fill__c,Apply_Limitations__c,Bypass_MOOP__c,CRDID__c,Daily_Dose__c,Day_Quantity_Rule__c
                                            ,Days_Over_Time_of_Days__c,Days_Over_Time_Time_Period__c,Days_Over_Time_Time_Value__c,Drug_Class_Name__c,Drug_Group__c,Drug_Group__r.Allowable_Actions__c,Drug_List__r.Allowable_Actions__c
                                            ,Drug_Group_Name__c,Drug_List__c,Drug_List_Name__c,End_Age__c,End_Age_Type__c,Gender__c,Inclusion_Exclusion__c
                                            ,Inclusion_Exclusion_Drug_Class__c,Is_Automated__c,LastSent__c,Max_Days_per_Fill__c,Related_Drug_Coverage__c
                                            ,Related_Drug_Coverage_Name__c,Related_Drug_Coverage__r.RecordTypeId,Quantity_Over_Time_Time_Value__c,Maximum_Days__c,
                                            Drug_List__r.name, Drug_Group__r.name,Related_Drug_Coverage__r.Maximum_days_supply__c
                                                                                     
                                          From 
                                            DC_Drug_List_Group__c 
                                          where 
                                            Related_Drug_Coverage__c =: drugCoverage.Id Limit 1000]){
            
            //Added By Nitish for 7029
            If(dcdl.Inclusion_Exclusion_Drug_Class__c != null){
                  if(!mapDCDL.containskey(dcdl.Inclusion_Exclusion_Drug_Class__c)){
                        mapDCDL.put(dcdl.Inclusion_Exclusion_Drug_Class__c,new list<DC_Drug_List_Group__c>{dcdl}); 
                  }
                  else if(mapDCDL.containskey(dcdl.Inclusion_Exclusion_Drug_Class__c)){
                      mapDCDL.get(dcdl.Inclusion_Exclusion_Drug_Class__c).add(dcdl);
                  }
            }
            else if(dcdl.Drug_Class_Name__c != null){
                if(!mapDCDL.containskey(dcdl.Drug_Class_Name__c)){
                        mapDCDL.put(dcdl.Drug_Class_Name__c,new list<DC_Drug_List_Group__c>{dcdl}); 
                  }
                  else if(mapDCDL.containskey(dcdl.Drug_Class_Name__c)){
                      mapDCDL.get(dcdl.Drug_Class_Name__c).add(dcdl);
                  }
                 
            }
            //End of 7029
            
            if(dcdl.Apply_Limitations__c == null || NO.equalsIgnoreCase(dcdl.Apply_Limitations__c)){TempVar = 'No';}else {TempVar = 'Yes';}
            if(dcdl.Drug_List__c!= Null && dcdl.Drug_Group__c == Null){
                if(drugListIds.contains(dcdl.Drug_List__c)){
                    setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0270',  system.label.ERR0270));
                    isValid=false;  
                }else{
                    drugListIds.add(dcdl.Drug_List__c);
                    addedDLs.put(dcdl.Drug_List__c , TempVar + PLUSLABEL + dcdl.Inclusion_Exclusion__c + ANDLABEL + dcdl.name);
                    DLwithAA.put(dcdl.Drug_List__c, dcdl.Drug_List__r.Allowable_Actions__c);
                }
            }else if(dcdl.Drug_List__c== Null && dcdl.Drug_Group__c != Null){
                  if(druggroupIds.contains(dcdl.Drug_Group__c)){
                    setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug Group','ERR0269',  system.label.ERR0269));
                    isValid=false;
                  }else{
                    druggroupIds.add(dcdl.Drug_Group__c);
                    addedDGs.put(dcdl.Drug_Group__c , TempVar + PLUSLABEL + dcdl.Inclusion_Exclusion__c + ANDLABEL + dcdl.name);
                    DGwithAA.put(dcdl.Drug_Group__c, dcdl.Drug_Group__r.Allowable_Actions__c);
                  }
                  }
            else{
                //DO NOTHING
                // Commenting to remove this restriction as 5810 Story
                //setErrorModel.add(new ErrorModel('DC Drug List/Group- COB or MOB?','ERR0240',  system.label.ERR0240));
                //isValid=false;
            }
             // Added by Nitish Story - 06419    
            if(dcdl.Related_Drug_Coverage__r.RecordTypeId == DCMAIL){
            //Added for story - 6669 by Toshi
            if((dcdl.Related_Drug_Coverage__r.Maximum_days_supply__c != NULL 
            && dcdl.Related_Drug_Coverage__r.Maximum_days_supply__c == 60) 
            && (dcdl.Quantity_Over_Time_Time_Value__c!= null && dcdl.Quantity_Over_Time_Time_Value__c == 90) && bpf==false){                //edited by VP for ST 1715 - added bpf                    
                setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0316', system.label.ERR0316));
                        isValid=false;
            }
           if((dcdl.Quantity_Over_Time_Time_Value__c != dcdl.Maximum_Days__c) && !(dcdl.Maximum_Days__c == null || dcdl.Maximum_Days__c == 365 || math.mod(integer.valueof(dcdl.Maximum_Days__c),30) == 0)) {            
                    if((dcdl.Drug_List__c!= null) && (dcdl.Drug_Group_Name__c != null) && bpf==false){                                                                              //added bpf by vatsal for ST 1715                                                                                                                                                                                                   
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0300', system.label.ERR0300 + ' ' + dcdl.Drug_List__r.name));                    
                        isValid=false;
                    }
                    else if((dcdl.Drug_List__c != null) && (dcdl.Drug_Group__c == null)  && bpf==false){                                                                           //added bpf by vatsal for ST 1715
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0300', system.label.ERR0300 + ' ' + dcdl.Drug_List__r.name));
                        isValid=false;
                    }
                    else if((dcdl.Drug_Group__c != null) && (dcdl.Drug_List__c == null) && bpf==false){                                                                            //added bpf by Vatsal for ST 1715
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0300', system.label.ERR0300 + ' ' + dcdl.Drug_Group__r.name));
                        isValid=false;
                    }
                }
            }
            else if(dcdl.Related_Drug_Coverage__r.RecordTypeId == DCRETAIL){
               
                if((dcdl.Quantity_Over_Time_Time_Value__c != dcdl.Maximum_Days__c) && !(dcdl.Maximum_Days__c == null || dcdl.Maximum_Days__c == 365 || math.mod(integer.valueof(dcdl.Maximum_Days__c),30) == 0)){            //edited by VP for ST 1715
                    if((dcdl.Drug_List__c != null) && (dcdl.Drug_Group__c != null) && bpf == false){                                                                   //added bpf by vatsal for ST 1715                          
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0301', system.label.ERR0301 + ' ' + dcdl.Drug_List__r.name));            
                        isValid=false;
                    }
                    else if((dcdl.Drug_List__c != null) && (dcdl.drug_group__c == null)  && bpf == false){                                                             //added bpf by vatsal for ST 1715
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0301', system.label.ERR0301 + ' ' + dcdl.Drug_List__r.name));            
                        isValid=false;                                                           
                    }
                    else if((dcdl.Drug_Group__c != null) && (dcdl.Drug_List__c == null) && bpf == false ){                                                             //added bpf by vatsal for ST 1715
                        setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List','ERR0301', system.label.ERR0301 + ' ' + dcdl.Drug_List__r.name));            
                        isValid=false;
                        }                                                    
                    
                }
            }
         }
                 //Richa added below 2 if blocks for Req 6212 
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
        if(isValid && addedDLs.size()>0){ 
            for(Id alAction : addedDLs.keyset()){
                String applyLimit = addedDLs.get(alAction).substringBefore(PLUSLABEL);
                String incluExclu = addedDLs.get(alAction).substringBetween(PLUSLABEL, ANDLABEL);
                String dcdlName = addedDLs.get(alAction).substringAfter(ANDLABEL);
                if(restrictedProfiles.contains(userinfo.getProfileId()) && (DLwithAA.get(alAction) != null && DLwithAA.get(alAction).containsIgnoreCase(ALLOWOVERRIDE))){
                }            
                    else if(DLwithAA.get(alAction) != null){
                        if((YES.equalsIgnoreCase(applyLimit) && DLwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(applyLimit))) || (NO.equalsIgnoreCase(applyLimit) && !DLwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(applyLimit)))){
                            if (!DLwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(incluExclu))){
                                setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List'+'-'+dcdlName,'ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }  
                        } else {
                                setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List'+'-'+dcdlName,'ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                    } else {
                            setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug List'+'-'+dcdlName,'ERR0298',  system.label.ERR0298));
                            isValid=false;
                        }
            }
        }
        if(isValid && addedDGs.size()>0){ 
            for(Id alAction : addedDGs.keyset()){
                String applyLimit = addedDGs.get(alAction).substringBefore(PLUSLABEL);
                String incluExclu = addedDGs.get(alAction).substringBetween(PLUSLABEL, ANDLABEL);
                String dcdlName = addedDGs.get(alAction).substringAfter(ANDLABEL);
                 if(restrictedProfiles.contains(userinfo.getProfileId()) && (DGwithAA.get(alAction) != null && DGwithAA.get(alAction).containsIgnoreCase(ALLOWOVERRIDE))){
                }
                    else if(DGwithAA.get(alAction) != null){
                        if((YES.equalsIgnoreCase(applyLimit) && DGwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(applyLimit))) || (NO.equalsIgnoreCase(applyLimit) && !DGwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(applyLimit)))){
                            if (!DGwithAA.get(alAction).containsIgnoreCase(allowableActionsMap.get(incluExclu))){
                                setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug Group'+'-'+dcdlName,'ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }  
                        } else {
                                setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug Group'+'-'+dcdlName,'ERR0298',  system.label.ERR0298));
                                isValid=false;
                            }
                    } else {
                            setErrorModel.add(new ErrorModel('DC Drug List/Group- Drug Group','ERR0298'+'-'+dcdlName,  system.label.ERR0298));
                            isValid=false;
                        }
            }
        }
         if(isValid && ! druggroupIds.isEmpty()){
                for(Drug_List_Junction__c dlJunc: [Select 
                                             Id,Name,Drug_List_Description__c,Drug_List__c,Drug_List_Name__c,Drug_List_Record_Type__c
                                            ,Inactive__c,LastSent__c,Parent_Drug_Group__c,Parent_Drug_Group_Description__c,Parent_Drug_Group_Name__c
                                           From
                                             Drug_List_Junction__c
                                           Where
                                             Parent_Drug_Group__c =: druggroupIds limit 1000]){
                if(drugListIds.contains(dlJunc.Drug_List__c)){
                    setErrorModel.add(new ErrorModel('DC Drug List/Group,Drug List Junction- Drug List','ERR0270',  system.label.ERR0270));
                    isValid = false;    
                }else{
                    drugListIds.add(dlJunc.Drug_List__c);
                }
            }   
        } 
       return isValid;                             
    }
    /* Method - validateDSCFormulary
     * Description - This method check if the Formulary group on DC records matches with the Formulary Group string on DSC record
     * Request/Story - 06597
     */
        public boolean validateDSCFormulary(CRD__c crdRecord,List<Pers_Full_Report__c> pfrRecords, List<CRD_BuilderFallout__c>lstcrdfo){
                //Added By Nitish - 6597
                    //Compare LV Combination on PFR's of CRD to the DSC Mapping Values
                    set<String> setCRDLV = new set<String>();
                    set<String> setMappingLV = new set<String>();
                    boolean isValid = True;
                    boolean falloutChk = False;
                    boolean bypassFallout = False;
                    boolean checkDiabeticPlanDSC = False;
                    id dlId = [select id from Drug_List__c where Name ='DL-0033674'].id;
                    if(pfrRecords.size() > 0){
                        for(CRD_BuilderFallout__c crdfoRecord:lstcrdfo){
                            if(crdfoRecord.Error_Code__c == 'ERR0305'){
                                bypassFallout = True;
                            }
                            /* BYPass Validation rule after first fallout for ST 2380*/
                            if(crdfoRecord.Error_Code__c == 'ERR0322'){
                                byPassFalloutForDrugCoverage = True;
                            }
                        }
                        if(mapVal.containsKey('Drug_Specific_Copay__c')){
                            for(mapping_values__c mvRecord: mapVal.get('Drug_Specific_Copay__c')){
                                if(string.isNotBlank(mvRecord.Field_API__c) && mvRecord.field_Api__C.equalsIgnoreCase('Formulary_group__c')){
                                    String LVCOMBINATION = 'P'+ mvRecord.Provision__c + 'L' +mvRecord.line_value__c ;
                                    setMappingLV.add(LVCOMBINATION);
                                }
                            }
                        }
                        for(Pers_Full_Report__c persRecord: pfrRecords){
                            String LVCOMBINATION = 'P'+ persRecord.WS_PROV_NUM__c + 'L' +persRecord.WS_LV_NO__c ;
                            if(setMappingLV.contains(LVCOMBINATION) && persRecord.processed__c== False && !bypassFallout){
                                falloutChk = TRUE;
                               
                            }
                        }
                    }
                    /*
                    List<Drug_Specific_Copay__c> dscList = new List<Drug_Specific_Copay__c>();
                    boolean falloutChk = False;
                    
                    List<String> dscFormularyGroupSet = new List<String>();
                    set<String> dscFormularyGroupSet2 = new set<String>();
                    set<string> formularyGroup = new set<string>();
                    for(Drug_Coverage__c dc : crdRecord.Drug_Coverage__r){
                        if(dc.Formulary_Group__c!=null && dc.Formulary_Group__c!= ''){
                            formularyGroup.add(dc.Formulary_Group__c);
                        }
                        
                    }
                        for(Drug_Specific_Copay__c dsc :crdRecord.Drug_Specific_Copay_s__r){
                            if(dsc.Formulary_Group__c != null){
                                dscFormularyGroupSet = dsc.Formulary_Group__c.split(';');
                               
                                     dscFormularyGroupSet2.addall(dscFormularyGroupSet);
                                    system.debug('formularyGroup ++++ ' + formularyGroup);
                                    system.debug('dscFormularyGroupSet2+++ ' +dscFormularyGroupSet2);
                                    for(String fgstr : formularyGroup){
                                        if(formularyGroup.size()>0 && formularyGroup!=null  && dscFormularyGroupSet2.size()>0 && (dscFormularyGroupSet2.contains(ALL) || dscFormularyGroupSet2.contains(fgstr))){
                                            dscList.add(dsc);
                                        }
                                    }
                            }
                                dscFormularyGroupSet2.clear();
                        }
                        system.debug('dscList.size+++ ' +dscList.size());
                        system.debug('CB_CrdBuilderUtil.dscFalloutChk++ ' +CB_CrdBuilderUtil.dscFalloutChk);
                        
                        if((dscList.size()<1 || dscList.size()==0)){
                            system.debug('rrrr');
                            falloutChk = TRUE;
                        }
                    
                    */     
               //Added By Nitish 6819
            for(Drug_Specific_Copay__c dsc2 : crdRecord.Drug_Specific_Copay_s__r){
                if(dsc2.Drug_List__c != null){
                    if(dlId != dsc2.Drug_List__c && chkDiabeticPlan){
                        checkDiabeticPlanDSC = true;
                    }
                }
            } 
            if(checkDiabeticPlanDSC && !bypassDiabeticPlan){
                setErrorModel.add(new ErrorModel(' Drug Specific Copay - DL-0033674 Mismatch','ERR304',  system.label.ERR304));
                    isValid = False;
            }              
            
            if(falloutChk){                    
                    setErrorModel.add(new ErrorModel(' Drug Specific Copay - Formulary Group','ERR0305',  system.label.ERR0305));
                    isValid = False;                    
                }
            //End of 6597
            return isValid;
        }
    /** 
     * Method :- matchDCDLFormulary()
     * Description - This method is developed corresponding to Formulary Expansion Project #RRC184171. This method decide the DCDL attachment to Drug Coverage
                      record based on formulary group coming from Provision 137 for 7029
     **/
    public boolean matchDCDLFormulary(map<integer,Pers_Full_Report__c> pfrMap,CRD__c crdRec,Map<string,List<Mapping_Values__c>> allMapValue){
        boolean matchingformularyGroup = true;
        set<DC_Drug_List_Group__c> setDCDL = new set<DC_Drug_List_Group__c>();
        set<string> frgStr = new set<string>();
        set<id> formId = new set<id>();
        set<id> parentMapVal = new set<id>();
        listDCDL = new List<DC_Drug_List_Group__c>();//Added By Nitish for formulary Exclusion
        boolean stopFallout = false;
        id dcMailRecordType = schema.sObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
        id dcRetailRecordType = schema.sObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        map<id,Drug_Coverage__c> dcMapbyRecordType = new map<id,Drug_Coverage__c>();
        if(pfrMap!=null && !pfrMap.IsEmpty() && pfrMap.ContainsKey(137) && pfrMap.get(137).WS_LV_NO__c != 0 && pfrMap.get(137).WS_LV_NO__c != 999){
            for(Drug_Coverage__c dc : crdRec.Drug_Coverage__r){
                if(dc.Formulary__c != null){
                    formId.add(dc.Formulary__c);
                }
                if(!dcMapbyRecordType.containsKey(dc.RecordTypeId)){
                    dcMapbyRecordType.put(dc.RecordTypeId,dc);
                }
                if(String.isNotBlank(String.Valueof(dc.Formulary_Group__c)) && dc.Formulary_Group__c!=null){
                    frgStr.add(dc.Formulary_Group__c);
                }
            }

            for(Mapping_Values__c mvalue : allMapValue.get(DCDLAPI)){
                if(mvalue.Provision__c == 137 && String.isNotBlank(string.valueof(mvalue.Field_Api__c)) && mvalue.Field_Api__c.equalsIgnoreCase('Formulary_Group__c')){
                    List<String> formularyGrp = mvalue.FieldValue__c.Split(';');
                    set<string> formularyGrpSet = new set<string>();                    
                    formularyGrpSet.addall(formularyGrp);
                    if(!dcMapbyRecordType.IsEmpty() && (dcMapbyRecordType.containsKey(dcMailRecordType) && dcMapbyRecordType.get(dcMailRecordType).Formulary__c!=null) ||
                       (dcMapbyRecordType.containsKey(dcRetailRecordType) && dcMapbyRecordType.get(dcRetailRecordType).Formulary__c!=null))
                         
                    {
                       if(dcMapbyRecordType.ContainsKey(dcRetailRecordType) && dcMapbyRecordType.ContainsKey(dcMailRecordType) ){
                            if(formularyGrpSet.contains(string.valueof(dcMapbyRecordType.get(dcMailRecordType).Formulary_Group__c)) && 
                               formularyGrpSet.contains(string.valueof(dcMapbyRecordType.get(dcRetailRecordType).Formulary_Group__c)) ||
                               (formId.size()>0 && dcMapbyRecordType.get(dcRetailRecordType).Formulary_Group__c == null && 
                               dcMapbyRecordType.get(dcMailRecordType).Formulary_Group__c == null && formularyGrpSet.contains(COMMERCIAL))
                               ){
                                   stopFallout = True;
                                }
                        }
                        else if(dcMapbyRecordType.ContainsKey(dcRetailRecordType) && !dcMapbyRecordType.ContainsKey(dcMailRecordType) ){
                            if(formularyGrpSet.contains(string.valueof(dcMapbyRecordType.get(dcRetailRecordType).Formulary_Group__c)) ||
                               (formId.size()>0 && dcMapbyRecordType.get(dcRetailRecordType).Formulary_Group__c == null && formularyGrpSet.contains(COMMERCIAL))
                               ){
                                   stopFallout = True;
                                }
                        }
                        else if(dcMapbyRecordType.ContainsKey(dcMailRecordType) && !dcMapbyRecordType.ContainsKey(dcRetailRecordType) ){
                            if(formularyGrpSet.contains(string.valueof(dcMapbyRecordType.get(dcMailRecordType).Formulary_Group__c)) ||
                               (formId.size()>0 && dcMapbyRecordType.get(dcMailRecordType).Formulary_Group__c == null && formularyGrpSet.contains(COMMERCIAL))
                               ){
                                   stopFallout = True;
                                }
                        }
                        
                    }
                                
            if(formId.size()>0 && !frgStr.IsEmpty() && !frgStr.contains(null) && frgStr.size()>0 && !formularyGrpSet.containsAll(frgStr) || 
                            formId.size()>0 && frgStr.size()==0 && !formularyGrpSet.contains(COMMERCIAL) ||
                            (dcMapbyRecordType!=null && dcMapbyRecordType.size()>0 && dcMapbyRecordType.containsKey(dcMailRecordType) && dcMapbyRecordType.get(dcMailRecordType).Formulary__c==null)|| 
                            (dcMapbyRecordType!=null && dcMapbyRecordType.size()>0 && dcMapbyRecordType.containsKey(dcRetailRecordType) && dcMapbyRecordType.get(dcRetailRecordType).Formulary__c==null)
                    )
                    {
                        parentMapVal.add(mvalue.ParentMappingValue__c);
                        matchingformularyGroup = false;
                    } 
              }
            }          
         for(Mapping_Values__c mvalue : allMapValue.get(DCDLAPI)){                
            if(mvalue.Provision__c == 137 && !matchingformularyGroup && String.isNotBlank(string.valueof(mvalue.Field_Api__c)) && mvalue.Field_Api__c.equalsIgnoreCase('Inclusion_Exclusion_Drug_Class__c') && parentMapVal.contains(mvalue.ParentMappingValue__c)){
                            if(mapDCDL.containsKey(mvalue.FieldValue__c)){
                                setDCDL.addall(mapDCDL.get(mvalue.FieldValue__c));
                            }
                        }
                else if(mvalue.Provision__c == 137 && !matchingformularyGroup && String.isNotBlank(string.valueof(mvalue.Field_Api__c)) && mvalue.Field_Api__c.equalsIgnoreCase('Drug_Class_Name__c')&& parentMapVal.contains(mvalue.ParentMappingValue__c)){
                            if(mapDCDL.containsKey(mvalue.FieldValue__c)){
                                setDCDL.addall(mapdcdl.get(mvalue.FieldValue__c));
                            }
                           
                        }
             }
         if(!matchingformularyGroup && !stopFallout){
                pfrMap.get(137).Processed__c = false;
                Database.Update(pfrMap.get(137));
            }
            
        }
            if(setDCDL.size()>0){
                if(!setDCDL.contains(null)){
                    listDCDL.addall(setDCDL);
                }
                if(!listDCDL.isEmpty()){
                    Database.delete(listDCDL);
                }
            }
            if(!matchingformularyGroup && !stopFallout){
            return false;
        }
        else{
            return true;
        }
    }
    /** Class :- ErrorModel
    * Description :- This Class is to capture error code, error desciption, and field value
    **/      
    public class ErrorModel{      
        public string field;
        public string errorcode;
        public string errormessage;
        
/**
* Method :- ErrorModel
* Description :- This method is to capture error code, error desciption, and field value
**/      
        public ErrorModel(string field,string errorcode,string errormessage){
            this.field = field;
            this.errorcode = errorcode;
            this.errormessage = errormessage;
        }
    }                       
}