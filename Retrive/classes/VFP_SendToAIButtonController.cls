/*Purpose: Apex Class for populating RxPlan Data Contents in CRD Wizard.
========================================================================
History
-------
VERSION     AUTHOR                 DATE                    DETAIL
1.0 -    ANUJ                11/25/2011       Apex Class for populating RxPlan Data Contents in CRD Wizard.s
1.1 -    ANUJ                01/18/2012       commented the RxPlanData and RxPlanDataExp field
1.2 -    Sourabh             01/23/2012       Issue 1429 & 1430
1.3 -    Sourabh             02/14/2012       Issue 1451 & 1455
1.4 -    Sourabh             02/27/2012       Issue 1477
1.5 -    Rishabh             04/06/12         request 029
1.6 -    Anuj                04/09/2012       request 023
1.7 -    Anuj                06/06/2012       Request 303
2.0 -    Sourabh             06/10/2012       Request 307
2.1 -    Anuj                06/13/2012       Request 307
2.2 -    Sourabh             06/14/2012       Request 307( Based on Keith's comments)
2.3 -    Rishabh             08/10/2012       Request no: 826
2.4 -    Sourabh             08/21/2012       Request 754,819
2.0      rakesh               10 Aug'12       As per req. 761 Commented 'Pays_the_DAW_difference_after_deductible' field. Added field 'DAW_Differential_Penalty_Applies_to_MOOP'
2.1      rakesh               11-Aug'12       Added field 'What_happens_when_MOOP_is_met__c' (Req. 786)
2.2      Rishabh              12-Mar-'13      Added field 'Restart Fills' (Req. 900)
2.3     Rishabh              13-Mar-13        Removed all commented code and formatted.
2.4     Rishabh              05-Apr-13        Request 930
2.5     Sushant              20-Jun-13       Request 1033
2.6     Sushant              29-Jul-13       Request 01112
2.7     Sushant              05-Aug-13       Request 01129
2.8     Sushant              06-Aug-13       Request 01139
2.9     Rahul Nasa           14-Aug-13       Request 01122
3.0     Rahul Nasa           14-Aug-13       Request 01121
3.1     Rahul Nasa           14-Aug-13       Request 01120
3.2     Sushant              30-Sep-13       Request 01203
3.3     Abhishek             10/9/2013       Request 01142
3.4     Joognu Rao          02/21/2014       Request 04288
4.0     Amit                24 Feb 2014      Added Comments
4.1     Sushant             03/25/2014       Request 4610
4.2     Joognu Rao          04/18/2014      Implemented Request 4712
4.3     Joognu Rao          04/29/2014      Implemented Request 4719
4.4     Joognu Rao          05/01/2014      Implemented Request 4771
5.0     Nitish Verma        06/05/2014      Implemented Request 04869
5.1     Nitish Verma        06/06/2014      Implemented Request 04870
5.2     Richa               07/30/2014      Commented Hyperlipidemia and Hypertension fields for Req4558
5.3     Sushant             08/20/2014      Implemented Request 04872
6.0     Nitish              12/03/2014      Implemented Request 04751
6.1     Abhishek goel       01/28/2015      #5471 Removed field CVS_Caremark_Stellant_ID__c
7.0     Richa               03/02/2015      Queries were modified for Req 5470 - Added Select = true condition and order by
7.1    Abhishek             02/19/2015      added a reverse__c field in the query for request 05557
7.2      Sushant Sethi        03/23/2015      Implemented Requuest 05521
7.3     Amit jain           24th July,2015  Modified for Support Ticket 150
7.4     Abhishek Goel        ST 1626- Aetna RxStep Enhancement Adding "Rx Step TOC # days" in AI
7.5     Sushant     02/17/2016  Added Retal vaccine Program Object fields
======================================================================== */

public Class VFP_SendToAIButtonController {

    public CRD__c crd;
    public List < Copay_Tier__c > copayTierList = new List < Copay_Tier__c > ();
    public List < SteppedCopay__c > steppedCopayList = new List < SteppedCopay__c > ();
    public List < Drug_Specific_Copay__c > drugSpecificCopayList = new List < Drug_Specific_Copay__c > ();
    public List < Drug_Specific_Stepped_Copay__c > drugSteppedcCopayList = new List < Drug_Specific_Stepped_Copay__c > ();
    public List < Accumulations__c > accumulationList = new List < Accumulations__c > ();
    public List < Retail_Vaccine_Program__c > rvpList = new List < Retail_Vaccine_Program__c > ();
    //public List < MOOP_Bypass__c > MOOPBypassList = new List < MOOP_Bypass__c > (); Commented By Sushant: Req 04937
    public List < AccumulationSpecificDrug__c > accumDrugList = new List < AccumulationSpecificDrug__c > ();
    //public List < PSP_Junction__c > pspList = new List < PSP_Junction__c > ();list no where used
    public List < Drug_Coverage__c > drugCoverageList = new List < Drug_Coverage__c > ();
    public List < RxCheck_Junction__c > rxCheckList = new List < RxCheck_Junction__c > ();
    public List < Save_A_Copay_Junction__c > saveACopayList = new List < Save_A_Copay_Junction__c > ();
    public List < CRD_Step_Therapy_Junction__c > stepTherapyList = new List < CRD_Step_Therapy_Junction__c > ();
    public List < Network_Junction__c > networkList = new List < Network_Junction__c > ();
    public List < CRD_PriorAuth_Junction__c > PrecertList = new List < CRD_PriorAuth_Junction__c > ();
    public List < CRD_Quantity_Limit_Junction__c > QuantityLimitList = new List < CRD_Quantity_Limit_Junction__c > ();
    /* public List < CRD_Pricing__c > pricing = new List < CRD_Pricing__c > (); */
    public List < DAW_Specific_Copay__c > dawSpecificCopay = new List < DAW_Specific_Copay__c > ();
    public List < DAW_Specific_Stepped_Copay__c > dawSpecificSteppedCopay = new List < DAW_Specific_Stepped_Copay__c > ();
    public List < DC_Drug_List_Group__c > dcDrugListGroup = new List < DC_Drug_List_Group__c > ();
    //public List < DC_Copay__c > dcCopay = new List < DC_Copay__c > ();
    //public List < DC_Copay_Stepped__c > dcsteppedCopay = new List < DC_Copay_Stepped__c > ();
    public List < AHA_Junction__c > AhaJunctionList = new List < AHA_Junction__c > ();
    public List < Aetna_RxStep_Junction__c > AsrJunctionList = new List < Aetna_RxStep_Junction__c > ();
    public List < CRD_Standard_Safety_Edit_Junction__c > CSEJunctionList = new List < CRD_Standard_Safety_Edit_Junction__c > ();
    public List < Accumulation_Change_Copay__c > accumCopayList = new List < Accumulation_Change_Copay__c > ();
    public List <CRD_NPL_Junction__c> CRDNPLJunctionList = new List<CRD_NPL_Junction__c>();
    public List < Accumulation_Change_Copay_Stepped__c > accumCopaySteppedList = new List < Accumulation_Change_Copay_Stepped__c > ();
    public List < Aetna_RxHealthy_Outcomes_Junction__c > ahoJunctionList = new List < Aetna_RxHealthy_Outcomes_Junction__c > ();
    public List < Waiver_Of_Deductible__c > WODList = new List < Waiver_Of_Deductible__c > ();//Richa added for Req-4731
    
    public set < Id > drugCopayIdSet = new set < Id > ();
    public set < Id > copayIdSet = new Set < ID > ();
    public set < Id > accumulationIdSet = new Set < ID > ();
    public set < ID > MOOPBypassIDSet = new Set < ID > ();
    public set < Id > dawSpecifIdSet = new Set < ID > ();
    public set < Id > dcIdSet = new Set < ID > ();
    public set < Id > dcCopayIdSet = new Set < ID > ();
    public set < Id > dcDrugListGroupIdSet = new Set < ID > ();


    /**
    * Method :- sendToAIString(Id crdId)
    * Description :- The method is used to Query and fetch record of all objects which are to be Send to AI
    **/
    public string sendToAIString(Id crdId) {
        string mainString = '';
        //Fields for CRD Object
        crd = [SELECT Standard_Fully_Insured_Pricing__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c,Aetna_RxStep__c,Does_3_Month_Grace_Period_Apply__c,Tier_1_Rx_Reduction_Type__c, Tier_2_Rx_Reduction_Type__c, Tier_3_Rx_Reduction_Type__c, Tier_4_Rx_Reduction_Type__c, Tier_5_Rx_Reduction_Type__c, Tier_1_Rx_Reduction_Amount__c, Tier_2_Rx_Reduction_Amount__c, Tier_3_Rx_Reduction_Amount__c, Tier_4_Rx_Reduction_Amount__c, Tier_5_Rx_Reduction_Amount__c, Save_A_Copay_Custom_Letter__r.Name, /*Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c,*/ Account_ID__c, MAX_PAY__c, Override_Standard_Max_Pay__c, Account_Manager__c, Migration_Run_Number__c, Account_State__c, Account__c, Administration_of_External_COB__c, Aetna_Autofill__c, Aetna_Healthy_Actions__c, Aetna_Rx_Healthy_Outcomes__c, Allergy_Serums__c, Annual_Fill_Limit_Allowed_Limit__c, Any_drug_specific_Mail_copays__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, Any_drug_specific_Specialty_copays__c, API_Session_Id__c, Application_ID__c, Apply_Retail_Copay__c, Approved_from_CustFormulary_Committee_PA__c, Approved_from_CustFormulary_Committee_QL__c, Approved_from_CustFormulary_Committee_ST__c, Are_there_Quantity_Limits__c, Are_you_creating_a_Package_Plan__c, Asthma_Anti_Inflammatory_Agents__c, Asthma_Inhaled_Steroids__c, /*Blood_Glucose_Monitoring__c,*/ BPERxPlan_ID__c, Brands_DAW_5_take_a_gen_copay_Mail__c, Brands_DAW_5_take_a_gen_copay_Paper__c, Brands_DAW_5_take_a_gen_copay_Retail__c, Brands_DAW_5_take_a_gen_copay_Speciality__c, Bridge_Supply__c, Caremark_submit_IRL_files_to_RDS__c, Carrier_ID__c, Carrier_Number__c, Claims_Acceptable_w_o_receipts__c, Claims_payable_with_Pharm_Signature__c, Client_Contact_Email_Address__c, Client_Contact_First_Name__c, Client_Contact_Last_Name__c, Client_Contact_Phone__c, Client_Effective_Date__c, Clinic_Physician_Reimbursement__c, CM_submits_ongoing_monthly_files_to_RDS__c, COB_or_MOB__c, Compound_Code_2__c, Concurrent_DUR_ID__c, ConnectionReceivedId, ConnectionSentId, Copay_Dollar_Amount__c, Cost_Sharing_Amount__c, Co_Brand_Initial_Program_Welcome_Mailing__c, /* CRD_Pricing__c */ Customization_Approved__c, Custom_Ben_ID__c, Custom_call_center_phone_number__c, Custom_Network_Flag__c, Custom_Precert_Classes__c, Custom_Precert_Date_Approved__c, Custom_Quantity_Limits_Classes__c, Custom_Step_Therapy_Classes__c, Custom_Step_Therapy_Date_Approved_QL__c, Custom_Step_Therapy_Date_Approved_ST__c, CVS_submits_cost_reporting_to_Aetna__c, CVS_submits_eligibility_file_to_Aetna__c, Date_of_Approval_on_SSD__c, Default_NABP__c, Delete_connectivitytest2__c, Diabetes_Anti_Diabetic_Agents__c, Diabetes_Anti_Diabetic_Agent_Supplies__c, Disaster_Emergency__c, Discount_Rate__c, Disease_Management_Messaging_for__c, Disease_Management_Referral_Messaging__c, Disease_Vendor__c, Does_the_client_want_to_do_COB__c, Dosage_Increase_Change__c, Dose_Optimization__c, Do_Prescription_Savings_Program__c, Do_you_want_to_do_Precert__c, Do_you_want_to_do_Save_A_Copay__c, Do_you_want_to_do_Step_Therapy__c, Drug_List_Option__c, Drug_Specific_copay_count__c, Duplicate_Therapy__c, Durg_Specific_Stepped_Count__c, Effective_Date__c, Effective_Start_Date__c, End_Date__c, Enrolled_in_PA_for_other_condition__c, Enroll_in_RxCheck__c, Erisa_Client__c, Expatriate_Employees__c, Extra_Care_Health_Card__c, Foreign_Claims__c, /*FSA_Integration__c,*/ Gaps_in_Care__c, Generic_Launch__c, Generic_Uptake__c, Group_ID__c, Group_submits_Cost_Reporting__c, Group_submits_eligibility_file__c, G_Control__c, G_PlanSummary__c, /*Health_Care_for_Life__c,*/ Heart_Failure_Beta_Blockers__c, High_Value_Client__c, /*Hyperlipidemia_Lipid_Lowering_Agents__c, Hyperlipidemia_Statins__c, Hypertension_ACE_Inhibitors_ARBs__c, Hypertension_All_Anti_Hypertensives__c,*/ Id,Implementation_Type__c, Include_Kit_Logic__c, Incorrect_Days_Supply__c, Incumbent_PBM__c, Indian_Facilities__c, Insured_Type__c, Integrate_with_Medical__c, Integration_1__c, Integration_2__c, Integration_Status__c, In_Network_claims_are_reimbursed__c, In_Network_Reimbursement_Level__c, In_Network__c, IsDeleted, Is_DM_vendor_the_same_for_each_condition__c,LastActivityDate,/* SAC_Letter_Templates__c,*/ Mail_Number_of_Tiers__c, Mail_Order_Delay__c, Mail_Y_Schedule__c, Manual_Pharmacy_Payments__c, Maximum_Dollar__c, MDL_or_QVT_Limit_Exceptions__c, Medicaid__c, Medical_Injectible_Claim_Denial_Process__c, /*Migrane_Management__c,*/ Multiple_Births__c, Name, Name_of_Approver_on_SSD__c, National__c, No_of_Days_to_file_a_claim__c, Number_of_Participants__c, Nursing_Home_Claims__c, Nursing_Home__c, Offering_Type__c, Offshore__c,/* of_months_for_Copay_Waiver__c,*/ Old_RxPlan_ID__c, Opt_out_of_Rx_OTC_Edit__c,custom_npl__c,NPL_Applies__c,NPL_Drug_List__c, Opt_out_of_Safety_Edits__c, Ostomy_Supplies__c, Other_Insurance_Paid_in_Error__c, Out_of_Network_claims_are_reimbused__c, Out_of_Network_Cost_Sharing__c, Out_of_Network_Reimbursement_Level__c, Out_of_Network__c, OwnerId, Paper_Number_of_Tiers__c, Partial_Control_Group__c, Participant_Lost_Stolen_Damaged_Meds__c, Participant_Mail_In_Delay__c, Participate_in_CVS_mail_pharmacy_service__c, Partner_Server__c, Pharmacy_Advisor__c, Plan_Coordinate_Benefits__c, Plan_Description__c, Plan_Extract_Date__c, Plan_Platform__c, Plan_Type_Mail__c, Plan_Type_Paper__c, Plan_Type_Retail__c, Plan_Type_Specialty__c, Platform_Information__c, /*POS_Dose_Optimization_ID__c,*/ POS_Rebate_for_Plan__c, Precert_TOC_days__c, Prescriber_Network__c, Pre_Implementation_Audit__c, Pricing_Schedule__c, Prior_Authorization_ID__c, Process_Point_of_Sales_COB__c, Prorate__c, PSP_Override_Option__c, Rating_ERB__c, Rating__c, RDS_Effective_Date__c, RDS_Termination_Date__c, RDS__c, Reimbursement_Levels__c, Reporting_Frequency__c, Retail_Number_of_Tiers__c, Retail_refill_for_Manufacture_Back_Order__c, Retail_Source_AWP__c, Retail_to_Mail__c, Risk_Indicator__c, RTMD_Admin_Fee_basis__c, RTMD_Admin_Fee_rate__c, RTMD_Client_Share_Percent__c, RTMD_Effective_Date__c, RTMD_Modulator_Percent__c, RxPlanDataExp__c, RxPlanData__c, RxPlanID__c, RxPlan_ID_Status__c, Rx_Override_Option__c, Rx_PP_ID__c, Rx_Will_you_be_Picking_Drug_Classes__c, SAC_Override_Option__c, Service_Enhancement_Date__c, Specialty_Exclusion_Flag__c, Specialty_Number_of_Tiers__c, Specialty_Retail_Lock_Out__c, Specialty_Therapy_Management__c, Standard_or_Custom_Plan__c, Standard_Plan_Selection__c, Standard_Precert_List_or_Select_Classes__c, Standard_Precert_Program__c, Standard_Program_or_Select_Classes__c, Standard_QL_List_or_Select_Classes__c, Standard_QL_Program__c, Standard_Step_Therapy_Program__c, State_associated_with_this_plan__c, State__c, Status__c, SteppedCopayCount__c, Step_Therapy_TOC_days__c, Subsegment__c, SystemModstamp, PSP_Letter_Templates__c, Tiering__c, Tier_1_Copay_Reduction__c, Tier_1_Rx_Reduction__c, Tier_2_Copay_Reduction__c, Tier_2_Rx_Reduction__c, Tier_3_Copay_Reduction__c, Tier_3_Rx_Reduction__c, Tier_4_Copay_Reduction__c, Tier_4_Rx_Reduction__c, Tier_5_Copay_Reduction__c, Tier_5_Rx_Reduction__c, Toll_Free_Number__c, TP_ID__c, Transition_Plan_1_x_override_30DS__c, Type_of_Cost_Sharing__c, UBOI_ID__c, Vacation__c, Value_Generic__c, Vendor_Transition_Files__c, Veterans_Admin__c, Which_system_will_the_plan_be_installed__c, Who_processes_PA_or_Override__c, Year__c, Y_Schd__c, PSU__c, ARH_Offering_Type__c, Diabetes_Preventive__c, Asthma_Preventive__c, Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/ Plan_Type_Paper_Out_of_Network__c, Different_copays_from_Paper_In_Network__c, Apply_Penalty__c, Penalty_Type__c, Penalty_Amount__c, Percentage_Applied__c, Paper_Out_of_Network_Number_of_Tiers__c, Any_drug_specific_Paper_Out_of_Network__c, Any_DAW_specific_Paper_OON_copays__c, Brands_w_DAW_5_take_a_generic_copay__c, Is_there_Paper_Out_of_Network__c, Generic_Code_Conversion__c, NDC_System_Drug_List__c, GPI_System_Drug_List__c, Kit_Logic_Standard_Drug_List__c, In_Network_Discount_Rate__c, Out_of_Network_Discount_Rate__c, Bypass_DMR__c, Quantity_Limit_TOC_of_Days__c, High_Priority_Comments__c, AHA_Drug_Group__r.Name, Is_there_Compound_Max_Pay__c, Override_Standard_Compound_Max_Pay__c, Compound_Max_Pay__r.Name, Client_Name_On_Communication__c, Custom_Disease_Vendor_2_Phone_Number__c, Disease_Vendor_2__c, Disease_Vendor_1_Implementation_Type__c, Disease_Vendor_2_Implementation_Type__c, CRD_Risk_Indicator__c, Are_Emergency_Claims_Reimbursed__c, Are_Hemo_Claims_Reimbursed__c, Emergency_Discount_Rate__c, Hemo_Discount_Rate__c, /*POS_Dose_Optimization__c,*/ POS_Dose_Optimization_Drug_List_ID__r.Name, CVS_Caremark_Drug_List_ID__c, Brand_Penalty_Exception__c,/* DED_Waive_Preferred_Generic_IN__c,DED_Waive_Preferred_Generic_OON__c,*/ Tiering_Formulary_Exception__c, Global_Benefit_Exclusion__c, Waive_Deductible_for_Tier_1_Drugs__c
        ,Does_Chemo_Parity_Apply__c,Chemo_Parity_Drug_List__c,Oral_Chemo_Cap__c,Dollar_Amount__c,Percent__c,Copay_Calculation__c,
                Chemo_Drugs_Bypass_Deductible__c,Chemo_Drugs_Bypass_MAB__c,Chemo_Drugs_Bypass_OOP__c,Chemo_Drugs_In_Network_same_as_OON__c,CA_50_Cost_Share_Applies__c FROM CRD__c where Id = : crdId];

        //Fields for related AHAJunction
        AhaJunctionList = [select Id, Name, CRD_ID__c, Drug_List__c, Drug_List_ID__c, Drug_List_ID__r.Name, Drug_List_ID__r.CVS_Caremark_Drug_List_ID__c, Selected__c from AHA_Junction__c where CRD_ID__c = : crdId AND Selected__c = true order by Drug_List__c];//Query modified for Req 5470
        
        // Fields for related Aetna RxStep Junction
        AsrJunctionList = [select id, name, CRD_Id__c,Drug_List__r.CVS_Caremark_Drug_List_ID__c,Drug_List__c,Drug_Lists__c,LastSent__c,Selected__c from Aetna_RxStep_Junction__c where CRD_Id__c = : crdId AND Selected__c = true order by Drug_List__c];//Query modified for Req 5470
       
       //Fields for related Safty Edit Junction        
        CSEJunctionList = [select Id, Name, CRDID__c, Drug_Group__c, Drug_Group_Description__c, Drug_Group_ID__c, Drug_Group_Name__c, Drug_List__c, Drug_List_ID__c, Drug_List__r.Name, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Select__c from CRD_Standard_Safety_Edit_Junction__c where CRDID__c = : crdId AND Select__c = true order by Drug_List__c,Drug_Group__c];//Query modified for Req 5470
        
         //Fields for related CRD NPL Junctions
        CRDNPLJunctionList = [select ID,name,CRD_ID__c,Drug_List__c,Drug_List_Description__c,Drug_List_Name__c,IsStandard__c,LastSent__c,Select__c,Drug_List__r.name from CRD_NPL_Junction__c where CRD_ID__c = :crdID order by Drug_List__c];//Query modified for Req 5470
        
        //Fields for related Copay Tiers
        copayTierList = [SELECT ConnectionReceivedId, ConnectionSentId,Reverse_Copay__c, Copay_Calc__c, CRD__c, CreatedById, CreatedDate, Dollar_Amount__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Max_Dollar__c, Min_Dollar__c, Name, Number_Of_Steps__c, Percent__c, RecordTypeId, SteppedCopayCount__c, Stepped_Copay__c, SystemModstamp, Tier_Name__c, Tier_Type__c, Tier__c, Days_Per_Fill__c FROM Copay_Tier__c WHERE CRD__c = : crdId order by recordtype.name,Tier__c];
        for (Copay_Tier__c coPay: copayTierList) {
            copayIdSet.add(coPay.Id);
        }

        //Fields for related Stepped Copays for Copays
        steppedCopayList = [SELECT ConnectionReceivedId,Reverse__c, ConnectionSentId, Copay_Calc__c, Copay_Tier__c, CRD_ID__c, CreatedById, CreatedDate, Dollar_Amount__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Max_Dollar__c, Max_Range__c, Min_Dollar__c, Min_Range__c,  Name, Number_of_Ranges__c, Percent_Amount__c, Stepped_CoPay_Types__c, SystemModstamp, Tier_Type__c FROM SteppedCopay__c where Copay_Tier__c IN: copayIdSet order by Tier_Type__c,Number_of_Ranges__c];//Query modified for Req 5470

        //Fields for related Drug Specific for Copays
        drugSpecificCopayList = [SELECT ConnectionReceivedId,Reverse_Copay__c, ConnectionSentId, Copay_Calculation__c, CRD_ID__c, CreatedById, CreatedDate, Dollar_Amount__c, M__c, N__c, O__c, Y__c, Drug_Group__c, Drug_List__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Maximum_Dollar__c, Minimum_Dollar__c, Name, Percent__c, RecordTypeId, SteppedCopayCount__c, Stepped_Copay__c, SystemModstamp, TierName__c, TierNo__c FROM Drug_Specific_Copay__c where CRD_ID__c = : crdId order by recordtypeid,Drug_List__c,Drug_Group__c];//Query modified for Req 5470
        for (Drug_Specific_Copay__c drugCopay: drugSpecificCopayList) {
            drugCopayIdSet.add(drugCopay.Id);
        }

        //Fields for related Drug Specific Stepped Copays
        drugSteppedcCopayList = [SELECT Beginning_Range__c,Reverse__c, ConnectionReceivedId, ConnectionSentId, Copay_Calculation__c, CRD_ID__c, CreatedById, CreatedDate, Dollar_Amount__c, Drug_Specific_Copay_ID__c, End_Range__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Maximum_Dollar__c, Minimum_Dollar__c, Name, Number_of_Steps__c, Percent__c, Related_Drug_Group_List__c,  Stepped_CoPay_Type__c, SystemModstamp FROM Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c IN: drugCopayIdSet order by Related_Drug_Group_List__c,Number_of_Steps__c];//Query modified for Req 5470

        /* Commented By Sushant : Req 04937
        //Fields for MOOPBypass
        MOOPBypassList = [SELECT CRD_ID__c,MOOP_Bypass_Drug_Group__c,MOOP_Bypass_Drug_Group_Name__c,MOOP_Bypass_Drug_List__c,MOOP_Bypass_Drug_List_Name__c,MOOP_Bypass_Type__c FROM MOOP_Bypass__c where CRD_ID__c = : crdId]; 
        for (MOOP_Bypass__c MOOPBypass: MOOPBypassList) {
             MOOPBypassIDSet.add(MOOPBypass.ID);
        }
        */        
        //Fields for related Accumalations
        accumulationList = [SELECT What_happens_when_MOOP_is_met__c, MOOP_Brand_Drugs_Generics__c, MOOP_Brand_Drugs_no_Generics__c, MOOP_Maintenance_Drugs__c, MOOP_In_Network__c, MOOP_Out_of_Network__c
                                , MOOP_Generic_Drugs__c, Accum_Name__c, Accum_No__c, RecordType.Name, Start_Month_New__c,  Are_there_any_drug_specifc_MOOP__c, Are_there_any_drug_specific_deductibles__c
                                , Are_there_any_drug_specific_MAB__c,Carry_Balance_when_member_moves__c, Start_Day__c, ConnectionReceivedId, ConnectionSentId, CRD_ID__c, CRD_Name__c, CreatedById
                                , CreatedDate, Deductible_Amount__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Period__c, Deuductible_Accumulation_from_4th_Qtr__c, Id, IsDeleted
                                , Is_there_a_Maximum_Allowable_Benefit__c, Is_there_a_Maximum_Out_of_Pocket__c, LastModifiedById, LastModifiedDate, MAB_Dedictible_Amount__c, MAB_Period__c
                                , MOOP_Dedictible_Amount__c, MOOP_Period__c, /*Deductible_Out_of_Network__c,  Deductible_Maintenance_Drugs__c,Deductible_Generic_Drugs__c
                                , Deductible_Brand_Drugs_Generics__c, Deductible_In_Network__c,Deductible_Brand_Drugs_no_Generics__c,*/ Name, Noof_Family_Members_to_Meet_Family_MOOP__c
                                , Family_Members_to_meet_Family_Deduct__c,  OwnerId, DAW_Differential_Penalty_Applies_to_MOOP__c, /*Pays_the_DAW_difference_after_deductible__c,*/ RecordTypeId
                                , Start_Month__c, SystemModstamp, What_happens_when_the_MAB_is_met__c, MAB_In_Network__c,Do_not_apply_flat_fee_to_OOP__c,Do_not_apply_penalty_to_OOP__c
                                ,What_is_the_In_Network_MOOP_Amount__c,What_is_the_In_Network_Deductible_Amount__c,What_is_the_OON_Deductible_Amount__c,What_is_the_OON_MOOP_Amount__c
                                ,Cross_Accumulation__c, MAB_Out_of_Network__c, MAB_Generic_Drugs__c, MAB_Brand_Drugs_Generics__c, MAB_Brand_Drugs_no_Generics__c, MAB_Maintenance_Drugs__c
                                , Accum_Code_Deductible__c, Accum_Code_Maximum_Allowable_Benefit__c, Accum_Code_Maximum_Out_Of_Pocket__c,Accumulation_End_Date__c,When_will_the_Accumulations_renew__c
        FROM Accumulations__c
        where CRD_ID__c = : crdId order by RecordType.Name, Name ];//Query modified for Req 5470
        for (Accumulations__c accumulation: accumulationList) {
            accumulationIdSet.add(accumulation.Id);
        }
        //Fields for related Retail Vaccine Program
        rvpList = [SELECT Applies__c,CoPay_Calculation__c,CRD__c,Dollar_Amount__c,Maximum_Dollar__c,Minimum_Dollar__c,Percent__c,Vaccine_Network__c,Waiver_of_Deductible__c,RecordTypeId, RecordType.Name FROM Retail_Vaccine_Program__c where CRD__c = : crdId order by RecordType.Name, Name ];
        //Fields for related Accumalations Specific Drugs
        accumDrugList = [SELECT Accumulations_ID__c, Accumulatoins_Type__c, ConnectionReceivedId, ConnectionSentId, CRD_ID__c, CreatedById, CreatedDate, Deductible_Amount__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Period__c, Deuductible_Accumulation_from_4th_Qtr__c, Drug_Group__c, Drug_List__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, MAB_Dedictible_Amount__c, MAB_Period__c, MOOP_Dedictible_Amount__c, MOOP_Period__c, Name, What_happens_when_MOOP_is_met__c,Exclude_from_Accumulation__c, /*Noof_Family_Members_to_Meet_Maximum_MOOP__c,Family_Members_to_meet_Family_Deduct__c,*/
        DAW_Differential_Penalty_Applies_to_MOOP__c, RecordTypeId, RecordType.Name, SystemModstamp, What_happens_when_MAB_is_met__c,SortOrder__c FROM AccumulationSpecificDrug__c where Accumulations_ID__c = : accumulationIdSet ORDER BY SortOrder__c ASC];

        //Fields for Accumulation Change Copay
        accumCopayList = [SELECT Accumulation_ID__c, Copay_Calculation__c, CRD_ID__c, DAW_Code__c, Dollar_Amount__c, Id, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Name, Percent__c, RecordTypeId, RecordType.Name, Reverse__c, Stepped__c FROM Accumulation_Change_Copay__c where Accumulation_ID__c = : accumulationIdSet order by RecordType.Name];//Query modified for Req 5470

        //Fields related to Accumulations Change Copay Stepped
        accumCopaySteppedList = [SELECT Accumulation_Change_Copay_ID__c, Accumulation_Change_Copay_ID__r.Accumulation_ID__c, Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, Dollar_Amount__c, End_Range__c, Id, Maximum_Dollar__c, Minimum_Dollar__c, Name, Number_of_Steps__c, Percent__c, Reverse__c, Type_of_Stepped_Copay__c FROM Accumulation_Change_Copay_Stepped__c
        where Accumulation_Change_Copay_ID__r.Accumulation_ID__c = : accumulationIdSet order by Number_of_Steps__c, Name];//Query modified for Req 5470

        //Fields for related Drug Coverage
        drugCoverageList = [SELECT RecordType.Name, Apply_difference_of_cost__c,/* Brand_Generic__c,*/ Allow_Transition_Fill__c,Transition_Fill_Number_of_Days__c,Compounds_with_1_Federal_Legend_Drug__c, ConnectionReceivedId, ConnectionSentId, /*Copay_Based_On__c,*/ Choose_Generic_Copay_Diff_Exclusion__c, Cost_Amount__c, Cost_Type__c, Co_Insurance_Dollar_Amount__c, Co_Insurance_Percentage__c, CRD_ID__c, CreatedById, CreatedDate, Custom_MMOD_VMOD_Drug_List__c, Custom_NDC_GPI_List_ID__c, Custom_NDC_GPI_List__c, Custom_Refill_too_Soon__c, /*DEA__c, DESI__c,Dollar_Amount__c, Dosage_Form__c,*/ Do_you_have_Choose_Generic__c, /*DUR_Message_Type__c, DUR__c,*/ Exception_Drug_Group__c, Exception_Drug_List__c, /*FDA_Therapeutic_Category__c, FDA_Therapeutic_Equivalent__c,*/ fills_before_MMO_option_is_invoked__c,Max_Specialty_Day_Supply__c,Secondary_of_Fills_before_Force_to_MOD__c,Secondary_of_fills_before_force_to_SPN__c,Secondary_Aetna_Specialty_Care_Rx__c,Secondary_Force_to_Specialty__c,Secondary_RRA_Drug_List__c,Secondary_RSO_Drug_List__c,Secondary_Speciality_Drug_List__c, Force_to_Specialty__c, Formulary_Open_Closed__c, Formulary__c, Do_you_have_Specialty__c, Grandfathering_for__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Lookback_Period__c, Mailing_Options__c, Maintenance_Choice__c, /*Maintenance_Form__c,*/ Mandatory_Mail_Order_Option__c, Maximum_days_supply__c, Maximum_quantity__c, /*Max_Day_Supply__c,*/  Minimum_days_supply__c, Minimum_quantity__c, /*Multi_Ingredient_Compounds__c,*/ Name, Norplan__c, Number_of_Periods__c, Nutritional_Dietary_Supplies_PKU__c, of_fills_before_force_to_specialty__c, No_of_fills_allowed_at_retail__c, /*OTC__c, */OwnerId, /*Packaging_Exceptions__c,*/ Period_Type__c, RecordTypeId, /*Refill_Limits__c,*/ Rule_for_supply_quantity__c, Smoking_Cessation_Aids__c, Speciality_Drug_List__c, Standard_Refill_too_Soon__c, Does_Dose_Limit_apply__c, Dose_Limit__c, Higher_Lower_than__c, Dose_Limit_Exception_Drug_List__c, SystemModstamp, Use_Standard_MMOD_VMOD_Drug_List__c, What_is_the_Penalty__c, What_Option__c, /*X3rd_Party_Exceptions__c,*/ Use_Medispan_Indicator__c, Brand_Penalty_Based_Retail_Mail_AWP__c, Brand_Penalty_Dollar_Amount__c, Brand_Penalty_Maximum_Dollar__c, Brand_Penalty_Minimum_Dollar__c, Brand_Penalty_Percent__c, Brand_Penalty_Type__c, Generic_Penalty_Dollar_Amount__c, Generic_Penalty_Maximum_Dollar__c, Generic_Penalty_Minimum_Dollar__c, Generic_Penalty_Percent__c, Generic_Penalty_Type__c, Gen_Penalty_Based_Retail_Mail_AWP__c, Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c, Non_Pref_Brand_Penalty_Dollar_Amount__c, Non_Pref_Brand_Penalty_Maximum_Dollar__c, Non_Pref_Brand_Penalty_Minimum_Dollar__c, Non_Pref_Brand_Penalty_Percent__c, Non_Pref_Brand_Penalty_Type__c, Incentivized_Mail_Brand_Penalty_Amount__c, Incentivized_Mail_Brand_Penalty_Type__c, Incentivized_Mail_Generic_Penalty_Amount__c, Incentivized_Mail_Generic_Penalty_Type__c, Incent_Mail_NonPref_Brand_Penalty_Amount__c, Incent_Mail_NonPref_Brand_Penalty_Type__c,Restart_Fills__c,Incent_Mail_Gen_Penalty_Percent__c,Incent_Mail_Gen_Penalty_Min__c,Incent_Mail_Gen_Penalty_Max__c,Incent_Mail_Brand_Penalty_Percent__c,Incent_Mail_Brand_Penalty_Min__c,Incent_Mail_Brand_Penalty_Max__c,Incent_Mail_NP_Brand_Penalty_Percent__c,Incent_Mail_NP_Brand_Penalty_Min__c,Incent_Mail_NP_Brand_Penalty_Max__c, Retail_Refill_Allowance_No_of_days__c, RRA_Drug_List__c, RSO_Drug_List__c,Number_of_fills__c,(Select Id, Name, Drug_List__c, Drug_Group__c, Inclusion_Exclusion__c from DC_Drug_List__r) FROM Drug_Coverage__c where CRD_ID__c = : crdId ORDER BY RecordType.Name DESC];

        for (Drug_Coverage__c dcId: drugCoverageList) {
            dcIdSet.add(dcId.Id);
        }

        dcDrugListGroup = [Select Id, Apply_Limitations__c, Related_Drug_Coverage__r.recordtype.name,Allow_Transition_Fill__c,Bypass_MOOP__c,Start_Age__c, Start_Age_Type__c, End_Age__c, End_Age_Type__c, Gender__c, Maximum_Days__c, Minimum_Days__c, Day_Quantity_Rule__c, Minimum_Quantity__c, Maximum_Quantity__c, Maximum_Dollars__c, Maximum_Fills__c, Daily_Dose__c, Days_Over_Time_of_Days__c, Days_Over_Time_Time_Period__c, Days_Over_Time_Time_Value__c, Quantity_Over_Time_Quantity__c, Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Max_Days_per_Fill__c, Max_Quantity_per_Fill__c, Name, Drug_List__c, Drug_Group__c, Inclusion_Exclusion__c from DC_Drug_List_Group__c where Related_Drug_Coverage__c IN: dcIdSet order by Related_Drug_Coverage__r.recordtype.name,Drug_List__c, Drug_Group__c];//Query modified for Req 5470(ordering done by recordtype name)
        for (DC_Drug_List_Group__c dcgroupId: dcDrugListGroup) {
            dcDrugListGroupIdSet.add(dcgroupId.Id);
        }

        /*dcCopay = [Select Name, Id, Copay_Calculation__c, CRD_ID__c, DAW_Code__c, DC_Drug_List_Group_ID__c, Dollar_Amount__c, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Percent__c, Reverse__c, Stepped__c from DC_Copay__c where DC_Drug_List_Group_ID__c IN: dcDrugListGroupIdSet];
        for (DC_Copay__c dcCopayId: dcCopay) {
            dcCopayIdSet.add(dcCopayId.Id);
        }*/
        //dcsteppedCopay = [select Id, name, Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, DC_Copay_ID__c, Dollar_Amount__c, End_Range__c, Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c, Percent__c, Reverse__c, Type_of_Stepped_Copay__c from DC_Copay_Stepped__c where DC_Copay_ID__c IN: dcCopayIdSet];
        //Fields for related Rx Check Programs
        rxCheckList = [SELECT CRD__c, Id, Name, RxCheck_Clinical_Programe__c, RxCheck_Program_Name__c, RxCheck__c, Selected__c FROM RxCheck_Junction__c where CRD__c = : crdId AND Selected__c = true];//Query modified for Req 5470

        //Fields for related Prescription Saving Programs
        //pspList = [SELECT CRD_ID__c, Id, Prescription_Savings_Program_Drug_Class__c, PSP_ID__c, Selected__c FROM PSP_Junction__c where CRD_ID__c = : crdId AND Selected__c = true order by Prescription_Savings_Program_Drug_Class__c];//Query modified for Req 5470

        //Fields for related Save A Copays
        saveACopayList = [SELECT CRD_ID__c, Id, Name, OwnerId, Save_A_Copay_Drug_Class__c, Save_A_Copay_ID__c, Selected__c FROM Save_A_Copay_Junction__c where CRD_ID__c = : crdId AND Selected__c = true order by Save_A_Copay_Drug_Class__c];//Query modified for Req 5470

        //Fields for related Step Therapy Programs
        stepTherapyList = [SELECT CRD_ID__c, Id, Name, Step_Therapy_Drug_Class__c, Step_Therapy_Class_Description__c, Step_Therapy_Class_Name__c, Step_Therapy_DrugList_Class__c FROM CRD_Step_Therapy_Junction__c where CRD_ID__c = : crdId order by Step_Therapy_DrugList_Class__c];//Query modified for Req 5470
        system.debug('Richa - stepTherapy + ' +stepTherapyList);
        //Fields for related Networks
        networkList = [SELECT CRD_ID__c, Id, Mail_Custom__c, Name, Network_Mail__c, Network_Retail__c, Network_Specialty__c, OwnerId, Retail_Custom__c, Specialty_Custom__c, Does_client_have_suppression__c /* Medvantix_Copay_Calculation__c,Medvantix_Copay_Dollar_Amount__c, Medvantix_Copay_Max_Dollar__c, Medvantix_Copay_Min_Dollar__c, Medvantix_Copay_Percent__c, Enroll_in_Medvantix__c */ FROM Network_Junction__c where CRD_ID__c = : crdId];

        //Fields for related Precerts
        PrecertList = [select CRD_ID__c, Precert_Class_Name__c, Precert_Class_Description__c, Precert_Class__c from CRD_PriorAuth_Junction__c where CRD_ID__c = : crdId order by Precert_Class__c];//Query modified for Req 5470

        //Fields for related Quantity Limits
        QuantityLimitList = [select CRD_ID__c, QL_Class__c, QL_Class_Name__c, QL_Class_Description__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crdId order by QL_Class__c];//Query modified for Req 5470

       /*  pricing = [Select c.Term_without_cause__c, c.SystemModstamp, c.Specialty_Master_Drug_List__c, c.Specialty_Mail_Default_Disct__c, c.Specialty_Dispensing_Fee__c, c.Specialty_Client_Drug_List__c, c.Spec_Mail_Disc_Basis_Source__c, c.Rx_Pricing__c, c.Rtl_Gen_Eff_Rate_Guar2__c, c.Rtl_Gen_Eff_Rate_Guar1__c, c.Rtl_Gen_Disc_Guar2_ZBDs__c, c.Rtl_Gen_Disc_Guar2_UC__c, c.Rtl_Gen_Disc_Guar2_SSGs__c, c.Rtl_Gen_Disc_Guar2_MAC_Only__c, c.Rtl_Gen_Disc_Guar2_Brnd_MAC__c, c.Rtl_Gen_Disc_Guar1_ZBDs__c, c.Rtl_Gen_Disc_Guar1_UC__c, c.Rtl_Gen_Disc_Guar1_SSGs__c, c.Rtl_Gen_Disc_Guar1_MAC_Only__c, c.Rtl_Gen_Disc_Guar1_Brand_MAC__c, c.Rtl_EDS_Non_Pref_Brnd_Disct__c, c.Rtl_EDS_Non_MAC_Gen_Disct__c, c.Rtl_EDS_Gen_Eff_Rte_Guar1__c, c.Rtl_EDS_Gen_Eff_Rate_Guar2__c, c.Rtl_EDS_Gen_Dispense_Fee__c, c.Rtl_EDS_Gen_Disc_Guar2_ZBDs__c, c.Rtl_EDS_Gen_Disc_Guar2_U_C__c, c.Rtl_EDS_Gen_Disc_Guar2_SSGs__c, c.Rtl_EDS_Gen_Disc_Guar1_U_C__c, c.Rtl_EDS_Gen_Disc_Guar1_SSGs__c, c.Rtl_EDS_Gen_DIsc_Guar1_ZBDs__c, c.Rtl_EDS_GenDiscGuar2_MAC_Only__c, c.Rtl_EDS_GenDiscGuar1_MAC_Only__c, c.Rtl_EDS_GenDiscGuar1_Br_MAC__c, c.Rtl_EDS_GenDIscGuar2_Brnd_MAC__c, c.Rtl_EDS_Custom_MAC_List_ID__c, c.Rtl_EDS_Custom_MAC_Applies__c, c.Rtl_EDS_Brnd_Eff_Rate_Guar__c, c.Rtl_EDS_Brnd_Dispense_Fee__c, c.Rtl_EDS_Brnd_Disc_Guar_ZBDs__c, c.Rtl_EDS_Brnd_Disc_Guar_U_C__c, c.Rtl_EDS_Brnd_Disc_Guar_SSGs__c, c.Rtl_EDS_Brnd_Disc_Guar_Br_MAC__c, c.Rtl_EDS_Br_Gen_Avl_Apply_MAC__c, c.Rtl_EDS_Adjudicatn_Logic_Mbr__c, c.Rtl_EDS_Adjud_Logic_Mbr__c, c.Rtl_EDS_Adjud_Logic_Client__c, c.Rtl_Brnd_Eff_Rate_Guar__c, c.Rtl_Brnd_Disct_Guar_UC__c, c.Rtl_Brnd_Disc_Guar_ZBDs__c, c.Rtl_Brnd_Disc_Guar_SSGs__c, c.Rtl_Brnd_Disc_Guar_Brnd_MAC__c, c.Rtl_Adjudicatn_Logic_Mbr__c, c.Rtl_Adjudicatn_Logic_Client__c, c.Retail_Pricing_End_Date__c, c.Retail_Pricing_Effective_Date__c, c.Retail_Price_Type__c, c.Retail_Preferred_Brand_Disct__c, c.Retail_Non_Preferred_Brand_Discount__c, c.Retail_Non_MAC_Generic_Discount__c, c.Retail_MAC_Percent__c, c.Retail_MAC_List_ID__c, c.Retail_MAC_Applies__c, c.Retail_Guar_Recon_Method__c, c.Retail_Guar_Recon_Freq__c, c.Retail_Generic_Flat_Discount__c, c.Retail_Generic_Dispensing_Fee__c, c.Retail_EDS_Pref_Brnd_Disct__c, c.Retail_EDS_Ntwk_35_DS__c, c.Retail_EDS_MAC_Percent__c, c.Retail_EDS_MAC_List_ID__c, c.Retail_EDS_MAC_Applies__c, c.Retail_EDS_Guar_Recon_Method__c, c.Retail_EDS_Guar_Recon_Freq__c, c.Retail_EDS_Gen_Flat_Disct__c, c.Retail_EDS_Brand_Disct__c, c.Retail_Discount_Basis__c, c.Retail_Custom_MAC_List_ID__c, c.Retail_Custom_MAC_Applies__c, c.Retail_Brand_Dispensing_Fee__c, c.Retail_Brand_Discount__c, c.Platform__c, c.Pharmacy_Benefit_Exclusive__c, c.PSUnique_ID__c, c.OwnerId, c.Other_Retail_Disc_Guar_Prov__c, c.Other_Mail_Disc_Guar_Prov__c, c.Oth_Rtl_EDS_Disc_Guar_Prov__c, c.Name, c.Medical_Benefit_Option__c, c.Maintenance_Choice_Applies__c, c.Mail_Pricing_End_Date__c, c.Mail_Pricing_Effective_Date__c, c.Mail_Price_Type__c, c.Mail_Pref_Brand_Disct__c, c.Mail_Non_Pref_Brand_Disct__c, c.Mail_Non_MAC_Gen_Disct__c, c.Mail_MAC_Percent__c, c.Mail_MAC_List_ID__c, c.Mail_MAC_Applies__c, c.Mail_Guarantee_Recon_Freq__c, c.Mail_Guaranatee_Recon_Method__c, c.Mail_Generic_Flat_Disct__c, c.Mail_Generic_Dispnse_Fee__c, c.Mail_Gen_Eff_Rate_Guar_2__c, c.Mail_Gen_Eff_Rate_Guar_1__c, c.Mail_Gen_Disc_Guar2_ZBDs__c, c.Mail_Gen_Disc_Guar2_UC__c, c.Mail_Gen_Disc_Guar2_SSGs__c, c.Mail_Gen_Disc_Guar2_MAC_Only__c, c.Mail_Gen_Disc_Guar2_Brnd_MAC__c, c.Mail_Gen_Disc_Guar1_ZBDs__c, c.Mail_Gen_Disc_Guar1_UC__c, c.Mail_Gen_Disc_Guar1_SSGs__c, c.Mail_Gen_Disc_Guar1_MAC_Only__c, c.Mail_Gen_Disc_Guar1_Brnd_MAC__c, c.Mail_Discount_Basis__c, c.Mail_Brnd_Disc_Guar_ZBDs__c, c.Mail_Brnd_Disc_Guar_UC__c, c.Mail_Brnd_Disc_Guar_SSGs__c, c.Mail_Brnd_Disc_Guar_Brnd_MAC__c, c.Mail_Brand_Eff_Rate_Guar__c, c.Mail_Brand_Dispense_Fee__c, c.Mail_Brand_Discount__c, c.Mail_Adjudicatn_Logic_Mbr__c, c.Mail_Adjudicatn_Logic_Client__c, c.MOEL_ID__c, c.MOEL_Applies__c, c.LastSent__c, c.LastModifiedDate, c.LastModifiedById, c.LastActivityDate, c.IsDeleted, c.Id, c.Escalating_Pricing__c, c.Early_Pricing__c, c.Dys_written_notice_bfr_term__c, c.CreatedDate, c.CreatedById, c.Contract_Terms__c, c.Contract_Term_Year__c, c.Contract_End_Date__c, c.Contract_Effective_Date__c, c.Consultant__c, c.ConnectionSentId, c.ConnectionReceivedId, c.Competitive_Mkt_Check_Clause__c, c.Client_Audit_of_Rtl_Rx_Cntracts__c, c.Brnd_Drug_Gen_Avail_Apply_MAC__c, c.Base_Retail_Network_Name__c, c.Account_Name__c From CRD_Pricing__c c where c.Id = : crd.CRD_Pricing__c];
 */
        //Fields for related DAW Specific Copay
        dawSpecificCopay = [Select Stepped__c,Reverse__c, SteppedCopayCount__c, RecordTypeId, Percent__c, Name, RecordType.name,Minimum_Dollar__c, Maximum_Dollar__c, MS_Code_Y__c, MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, LastSent__c, Id, Dollar_Amount__c, DAW_Code__c, Copay_Calculation__c, CRD_ID__c From DAW_Specific_Copay__c where CRD_ID__c = : crdId order by RecordType.name];//Query modified for Req 5470
        for (DAW_Specific_Copay__c dawCopay: dawSpecificCopay) {
            dawSpecifIdSet.add(dawCopay.Id);
        }
        //Fields for related DAW Specific stepped copay
        dawSpecificSteppedCopay = [Select Id,Reverse__c, name, DAW_Specific_Copay_ID__c, CRD_ID__c, Stepped_CoPay_Type__c, Number_of_Steps__c, Beginning_Range__c, End_Range__c, Dollar_Amount__c, Percent__c, Copay_Calculation__c, Maximum_Dollar__c, Minimum_Dollar__c from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c IN: dawSpecifIdSet order by Number_of_Steps__c,name];//Query modified for Req 5470

        ahoJunctionList = [SELECT Name, Aetna_RxHealthy_Outcomes_Drug_List__c, CRD_ID__c, LastSent__c, Selected__c
        FROM Aetna_RxHealthy_Outcomes_Junction__c
        WHERE CRD_ID__c = : crdId order by Aetna_RxHealthy_Outcomes_Drug_List__c];//Query modified for Req 5470

       //Richa added for Req-4731
        WODList = [Select CRD_ID__c, Delivery_System__c, Drug_Class__c, Drug_Class_Desc__c, Drug_Group__c, Drug_List__c, M__c, N__c, O__c, Y__c, Standard__c,Network__c FROM Waiver_Of_Deductible__c  WHERE CRD_ID__c = : crdId order by Drug_Class__c,Drug_List__c,Drug_Group__c];//Query modified for Req 5470      


        //Inclusion of value in string
        mainString = mainString + '\'' + crd.Plan_Platform__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Insured_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Plan_Type_Retail__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Plan_Type_Mail__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Plan_Type_Paper__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Plan_Type_Specialty__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Include_Kit_Logic__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Integrate_with_Medical__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Mail_Number_of_Tiers__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Retail_Number_of_Tiers__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Paper_Number_of_Tiers__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Specialty_Number_of_Tiers__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_drug_specific_Retail_copays__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_drug_specific_Mail_copays__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_drug_specific_Paper_copays__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_drug_specific_Specialty_copays__c + '\'' + ',';

        for (Copay_Tier__c coPay: copayTierList) {
            mainString = mainString + '\'' + coPay.Tier__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Tier_Type__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Stepped_Copay__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Reverse_Copay__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Copay_Calc__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Max_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + coPay.Min_Dollar__c + '\'' + ',';

            for (SteppedCopay__c steppedCopay: steppedCopayList) {
                if (steppedCopay.Copay_Tier__c == coPay.Id) {
                    mainString = mainString + '\'' + steppedCopay.Tier_Type__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Stepped_CoPay_Types__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Number_of_Ranges__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Max_Range__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Dollar_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Percent_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Copay_Calc__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Max_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Min_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Reverse__c + '\'' + ',';
                }
            }
        }
        for (Drug_Specific_Copay__c drugCopay: drugSpecificCopayList) {
            mainString = mainString + '\'' + drugCopay.Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Drug_Group__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Stepped_Copay__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCopay.Reverse_Copay__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Copay_Calculation__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Minimum_Dollar__c + '\'' + ',';

            for (Drug_Specific_Stepped_Copay__c drugSteppedCopay: drugSteppedcCopayList) {
                if (drugSteppedCopay.Drug_Specific_Copay_ID__c == drugCopay.Id) {
                    mainString = mainString + '\'' + drugSteppedCopay.Stepped_CoPay_Type__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Beginning_Range__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.End_Range__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Dollar_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Percent__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Copay_Calculation__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Maximum_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Minimum_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + drugSteppedCopay.Reverse__c + '\'' + ',';
                }
            }
        }
        mainString = mainString + '\'' + crd.COB_or_MOB__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Process_Point_of_Sales_COB__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Reimbursement_Levels__c + '\'' + ',';
        mainString = mainString + '\'' + crd.In_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.In_Network_Reimbursement_Level__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Out_of_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Out_of_Network_Reimbursement_Level__c + '\'' + ',';
        mainString = mainString + '\'' + crd.In_Network_claims_are_reimbursed__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Out_of_Network_claims_are_reimbused__c + '\'' + ',';
        mainString = mainString + '\'' + crd.No_of_Days_to_file_a_claim__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Retail_Source_AWP__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Discount_Rate__c + '\'' + ',';
        mainString = mainString + '\'' + crd.In_Network_Discount_Rate__c + '\'' + ','; //added by rishabh on 08/10/12
        mainString = mainString + '\'' + crd.Out_of_Network_Discount_Rate__c + '\'' + ','; //added by rishabh on 08/10/12
        mainString = mainString + '\'' + crd.Bypass_DMR__c + '\'' + ','; //added by rishabh on 08/10/12
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.RecordType.Name + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Formulary__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Formulary_Open_Closed__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Standard_Refill_too_Soon__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Custom_Refill_too_Soon__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Exception_Drug_Group__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Exception_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Mandatory_Mail_Order_Option__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.fills_before_MMO_option_is_invoked__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Number_of_Periods__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Period_Type__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Co_Insurance_Percentage__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Co_Insurance_Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Custom_MMOD_VMOD_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Maintenance_Choice__c + '\'' + ',';
           // mainString = mainString + '\'' + drugCoverage.Mchoice_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Do_you_have_Specialty__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Speciality_Drug_List__c + '\'' + ',';
            
            mainString = mainString + '\'' + drugCoverage.Force_to_Specialty__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.of_fills_before_force_to_specialty__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Minimum_days_supply__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Maximum_days_supply__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Maximum_quantity__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Minimum_quantity__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Rule_for_supply_quantity__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Do_you_have_Choose_Generic__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.What_Option__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.What_is_the_Penalty__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Apply_difference_of_cost__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Cost_Type__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Cost_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Compounds_with_1_Federal_Legend_Drug__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Norplan__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Nutritional_Dietary_Supplies_PKU__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Smoking_Cessation_Aids__c + '\'' + ',';
           
            //mainString = mainString + '\'' + drugCoverage.Multi_Ingredient_Compounds__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Copay_Based_On__c + '\'' + ',';
           // mainString = mainString + '\'' + drugCoverage.Dollar_Amount__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Refill_Limits__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.OTC__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Brand_Generic__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.X3rd_Party_Exceptions__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.DEA__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Dosage_Form__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.DESI__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Maintenance_Form__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Packaging_Exceptions__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.FDA_Therapeutic_Equivalent__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.FDA_Therapeutic_Category__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.DUR__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.DUR_Message_Type__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Max_Day_Supply__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Choose_Generic_Copay_Diff_Exclusion__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Concurrent_DUR_ID__c + '\'' + ',';
       // mainString = mainString + '\'' + crd.POS_Dose_Optimization_ID__c + '\'' + ','; --> Commented by Nitish dependency of request no 4870
        mainString = mainString + '\'' + crd.Do_you_want_to_do_Step_Therapy__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_Program_or_Select_Classes__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Step_Therapy_TOC_days__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_Step_Therapy_Program__c + '\'' + ',';       
        for (CRD_Step_Therapy_Junction__c stepTherapy: stepTherapyList) {
            system.debug('Richa - inside loop');
            mainString = mainString + '\'' + stepTherapy.Step_Therapy_DrugList_Class__c + '\'' + ',';
        }

        mainString = mainString + '\'' + crd.Do_you_want_to_do_Precert__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_Precert_List_or_Select_Classes__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Precert_TOC_days__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_Precert_Program__c + '\'' + ',';
       // mainString = mainString + '\'' + crd.Custom_Precert_Classes__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Opt_out_of_Safety_Edits__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Opt_out_of_Rx_OTC_Edit__c + '\'' + ',';

        for (CRD_PriorAuth_Junction__c precert: PrecertList) {
            mainString = mainString + '\'' + precert.Precert_Class__c + '\'' + ',';
        }

        mainString = mainString + '\'' + crd.Are_there_Quantity_Limits__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_QL_List_or_Select_Classes__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Standard_QL_Program__c + '\'' + ',';       

        for (CRD_Quantity_Limit_Junction__c quantityLimit: QuantityLimitList) {
            mainString = mainString + '\'' + quantityLimit.QL_Class__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Aetna_Autofill__c + '\'' + ',';
       // mainString = mainString + '\'' + crd.Blood_Glucose_Monitoring__c + '\'' + ','; Request no- 04869 Nitish verma
        mainString = mainString + '\'' + crd.Enrolled_in_PA_for_other_condition__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Implementation_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Participate_in_CVS_mail_pharmacy_service__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Management_Referral_Messaging__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Management_Messaging_for__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Is_DM_vendor_the_same_for_each_condition__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Vendor__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Custom_call_center_phone_number__c + '\'' + ',';
        mainString = mainString + '\'' + crd.End_Date__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Value_Generic__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Do_you_want_to_do_Save_A_Copay__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.of_months_for_Copay_Waiver__c + '\'' + ',';

        for (Save_A_Copay_Junction__c sac: saveACopayList) {
            mainString = mainString + '\'' + sac.Save_A_Copay_Drug_Class__c + '\'' + ',';
            mainString = mainString + '\'' + sac.Selected__c + '\'' + ',';

        }
        mainString = mainString + '\'' + crd.Aetna_Healthy_Actions__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Offering_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Asthma_Inhaled_Steroids__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Asthma_Anti_Inflammatory_Agents__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Diabetes_Anti_Diabetic_Agents__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Diabetes_Anti_Diabetic_Agent_Supplies__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Heart_Failure_Beta_Blockers__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hyperlipidemia_Statins__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hyperlipidemia_Lipid_Lowering_Agents__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hypertension_ACE_Inhibitors_ARBs__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hypertension_All_Anti_Hypertensives__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_1_Copay_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_2_Copay_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_3_Copay_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_4_Copay_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_5_Copay_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Aetna_Rx_Healthy_Outcomes__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_1_Rx_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_2_Rx_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_3_Rx_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_4_Rx_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_5_Rx_Reduction__c + '\'' + ',';
        mainString = mainString + '\'' + crd.POS_Rebate_for_Plan__c + '\'' + ',';
        mainString = mainString + '\'' + crd.RTMD_Client_Share_Percent__c + '\'' + ',';
        mainString = mainString + '\'' + crd.RTMD_Modulator_Percent__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Specialty_Exclusion_Flag__c + '\'' + ',';

        for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.RecordType.Name + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Carry_Balance_when_member_moves__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Deductible_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Deductible_Period__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Deuductible_Accumulation_from_4th_Qtr__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Are_there_any_drug_specific_deductibles__c + '\'' + ',';
           //Commented by JR to implement request 4771
           // mainString = mainString + '\'' + accumulation.Deductible_In_Network__c + '\'' + ',';
           // mainString = mainString + '\'' + accumulation.Deductible_Out_of_Network__c + '\'' + ',';
            //mainString = mainString + '\'' + accumulation.Deductible_Generic_Drugs__c + '\'' + ',';
           // mainString = mainString + '\'' + accumulation.Deductible_Brand_Drugs_Generics__c + '\'' + ',';
           // mainString = mainString + '\'' + accumulation.Deductible_Brand_Drugs_no_Generics__c + '\'' + ',';
           // mainString = mainString + '\'' + accumulation.Deductible_Maintenance_Drugs__c + '\'' + ',';          
            mainString = mainString + '\'' + accumulation.Is_there_a_Maximum_Allowable_Benefit__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.What_happens_when_the_MAB_is_met__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Dedictible_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Period__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Are_there_any_drug_specific_MAB__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_In_Network__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Out_of_Network__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Generic_Drugs__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Brand_Drugs_Generics__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Brand_Drugs_no_Generics__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MAB_Maintenance_Drugs__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Is_there_a_Maximum_Out_of_Pocket__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Dedictible_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Period__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Deductible_Applies_towards_the_MOOP__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.DAW_Differential_Penalty_Applies_to_MOOP__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Are_there_any_drug_specifc_MOOP__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_In_Network__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Out_of_Network__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Generic_Drugs__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Brand_Drugs_Generics__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Brand_Drugs_no_Generics__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.MOOP_Maintenance_Drugs__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Family_Members_to_meet_Family_Deduct__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Noof_Family_Members_to_Meet_Family_MOOP__c + '\'' + ',';        
            

            for (AccumulationSpecificDrug__c accumDrug: accumDrugList) {
                if (accumDrug.Accumulations_ID__c == accumulation.Id) {
                    mainString = mainString + '\'' + accumDrug.Accumulatoins_Type__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Deductible_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Deductible_Period__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Deuductible_Accumulation_from_4th_Qtr__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.What_happens_when_MAB_is_met__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.MAB_Dedictible_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.MAB_Period__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.MOOP_Dedictible_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.MOOP_Period__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Deductible_Applies_towards_the_MOOP__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.DAW_Differential_Penalty_Applies_to_MOOP__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Drug_List__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.Drug_Group__c + '\'' + ',';
                    mainString = mainString + '\'' + accumDrug.RecordType.Name + '\'' + ',';
                    
                }
            }
        }

        for (Network_Junction__c network: networkList) {
            mainString = mainString + '\'' + network.Network_Retail__c + '\'' + ',';
            mainString = mainString + '\'' + network.Retail_Custom__c + '\'' + ',';
            mainString = mainString + '\'' + network.Does_client_have_suppression__c + '\'' + ',';
            mainString = mainString + '\'' + network.Network_Mail__c + '\'' + ',';
            mainString = mainString + '\'' + network.Mail_Custom__c + '\'' + ',';
            mainString = mainString + '\'' + network.Network_Specialty__c + '\'' + ',';
            mainString = mainString + '\'' + network.Specialty_Custom__c + '\'' + ',';
        }

      /*  Richa had to comment for 4882 but was already commented
      for (CRD_Pricing__c crdPricing: pricing) {
            mainString = mainString + '\'' + crdPricing.Base_Retail_Network_Name__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Maintenance_Choice_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Price_Type__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Discount_Basis__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Brand_Discount__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Preferred_Brand_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Non_Preferred_Brand_Discount__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Brnd_Drug_Gen_Avail_Apply_MAC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Brand_Dispensing_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Generic_Flat_Discount__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Non_MAC_Generic_Discount__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_MAC_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Custom_MAC_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Custom_MAC_List_ID__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_Generic_Dispensing_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Adjudicatn_Logic_Client__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Adjudicatn_Logic_Mbr__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Eff_Rate_Guar1__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar1_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar1_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar1_UC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar1_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Eff_Rate_Guar2__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar2_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar2_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar2_UC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_Gen_Disc_Guar2_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_Ntwk_35_DS__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_Brand_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_Pref_Brnd_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Non_Pref_Brnd_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Br_Gen_Avl_Apply_MAC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Brnd_Dispense_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_Gen_Flat_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Non_MAC_Gen_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_MAC_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Custom_MAC_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Custom_MAC_List_ID__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Retail_EDS_MAC_List_ID__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Dispense_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Adjud_Logic_Client__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Adjud_Logic_Mbr__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Eff_Rte_Guar1__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_GenDiscGuar1_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_DIsc_Guar1_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Disc_Guar1_U_C__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Disc_Guar1_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Eff_Rate_Guar2__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_GenDiscGuar2_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Disc_Guar2_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Disc_Guar2_U_C__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Rtl_EDS_Gen_Disc_Guar2_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.MOEL_Applies__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.MOEL_ID__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Discount_Basis__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Brand_Discount__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Pref_Brand_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Non_Pref_Brand_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Brand_Dispense_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Generic_Flat_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Non_MAC_Gen_Disct__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Generic_Dispnse_Fee__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Adjudicatn_Logic_Client__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Adjudicatn_Logic_Mbr__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Eff_Rate_Guar_1__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar1_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar1_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar1_UC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar1_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Eff_Rate_Guar_2__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar2_MAC_Only__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar2_ZBDs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar2_UC__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Mail_Gen_Disc_Guar2_SSGs__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Pharmacy_Benefit_Exclusive__c + '\'' + ',';
            mainString = mainString + '\'' + crdPricing.Specialty_Mail_Default_Disct__c + '\'' + ',';
        } */

        mainString = mainString + '\'' + crd.Asthma_Preventive__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Diabetes_Preventive__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hypertension_All_Hypertension_Drugs__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Heart_Failure_Beta_Blockers_ARH__c + '\'' + ',';
        mainString = mainString + '\'' + crd.ARH_Offering_Type__c + '\'' + ',';

        // new fields added on 01/02/2012
        mainString = mainString + '\'' + crd.Plan_Type_Paper_Out_of_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Different_copays_from_Paper_In_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Apply_Penalty__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Penalty_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Penalty_Amount__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Percentage_Applied__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Paper_Out_of_Network_Number_of_Tiers__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_drug_specific_Paper_Out_of_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Brands_w_DAW_5_take_a_generic_copay__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Is_there_Paper_Out_of_Network__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Any_DAW_specific_Paper_OON_copays__c + '\'' + ',';


        for (DAW_Specific_Copay__c dawCopay: dawSpecificCopay) {
            mainString = mainString + '\'' + dawCopay.DAW_Code__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.MS_Code_M__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.MS_Code_N__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.MS_Code_O__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.MS_Code_Y__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Stepped__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Reverse__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dawCopay.Copay_Calculation__c + '\'' + ',';
            for (DAW_Specific_Stepped_Copay__c steppedCopay: dawSpecificSteppedCopay) {
                if (steppedCopay.DAW_Specific_Copay_ID__c == dawCopay.Id) {
                    mainString = mainString + '\'' + steppedCopay.Stepped_CoPay_Type__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Beginning_Range__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.End_Range__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Dollar_Amount__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Percent__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Copay_Calculation__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Maximum_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Minimum_Dollar__c + '\'' + ',';
                    mainString = mainString + '\'' + steppedCopay.Reverse__c + '\'' + ',';

                }
            }
        }
        // new fields added on 01/02/2012
        for (Drug_Specific_Copay__c drugCopay: drugSpecificCopayList) {
            mainString = mainString + '\'' + drugCopay.M__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.N__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.O__c + '\'' + ',';
            mainString = mainString + '\'' + drugCopay.Y__c + '\'' + ',';
        }

        // new field added on 15/02/2012
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.No_of_fills_allowed_at_retail__c + '\'' + ',';
                        
        }

        //new fields added on 4/6/12 by Rishabh
        mainString = mainString + '\'' + crd.GPI_System_Drug_List__c + '\'' + ',';
        mainString = mainString + '\'' + crd.NDC_System_Drug_List__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Kit_Logic_Standard_Drug_List__c + '\'' + ',';
        //new fields added on 04/09/2012 by Anuj
        mainString = mainString + '\'' + crd.Override_Standard_Max_Pay__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Max_Pay__c + '\'' + ',';

        //new fields added on 05 June by anuj
        for (DC_Drug_List_Group__c dc: dcDrugListGroup) {
            mainString = mainString + '\'' + dc.Drug_Group__c + '\'' + ',';
            mainString = mainString + '\'' + dc.Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + dc.Inclusion_Exclusion__c + '\'' + ',';

        }

        //mainString = mainString + '\'' + crd.FSA_Integration__c + '\'' + ',';-->//commented by Nitish request no 4874
        for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.What_happens_when_MOOP_is_met__c + '\'' + ',';
        }
        //Added by Sourabh : request 754,468
        mainString = mainString + '\'' + crd.High_Priority_Comments__c + '\'' + ',';
        mainString = mainString + '\'' + crd.AHA_Drug_Group__r.Name + '\'' + ',';
        //Added by Sourabh : request 819
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Use_Medispan_Indicator__c + '\'' + ',';
        }
        //Added by anuj on 24 aug
        /* for (DC_Copay__c dcCopayrecord: dcCopay) {
            // mainString = mainString + '\'' + dcCopayrecord.Name + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Copay_Calculation__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.CRD_ID__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.DAW_Code__c + '\'' + ',';
           // mainString = mainString + '\'' + dcCopayrecord.DC_Drug_List_Group_ID__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.MS_Code_M__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.MS_Code_N__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.MS_Code_O__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.MS_Code_Y__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Reverse__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayrecord.Stepped__c + '\'' + ',';
        }
        for (DC_Copay_Stepped__c dcCopayStepped: dcsteppedCopay) {
           // mainString = mainString + '\'' + dcCopayStepped.name + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Copay_Calculation__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.CRD_ID__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Beginning_Range__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.End_Range__c + '\'' + ',';
            //mainString = mainString + '\'' + dcCopayStepped.DC_Copay_ID__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Reverse__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Type_of_Stepped_Copay__c + '\'' + ',';
            mainString = mainString + '\'' + dcCopayStepped.Number_of_Steps__c + '\'' + ',';
        }*/

        for (AHA_Junction__c aharecord: AhaJunctionList) {
            //mainString = mainString + '\'' + aharecord.Name + '\'' + ',';
            mainString = mainString + '\'' + aharecord.Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + aharecord.Selected__c + '\'' + ',';
        }
        
       

        for (CRD_Standard_Safety_Edit_Junction__c sfjrecord: CSEJunctionList) {
            // mainString = mainString + '\'' + sfjrecord.Name + '\'' + ',';
            mainString = mainString + '\'' + sfjrecord.Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + sfjrecord.Drug_Group__c + '\'' + ',';
            mainString = mainString + '\'' + sfjrecord.Select__c + '\'' + ',';
        }

        for (AccumulationSpecificDrug__c accumDrug: accumDrugList) {
            mainString = mainString + '\'' + accumDrug.What_happens_when_MOOP_is_met__c + '\'' + ',';
        }

        mainString = mainString + '\'' + crd.Quantity_Limit_TOC_of_Days__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Is_there_Compound_Max_Pay__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Override_Standard_Compound_Max_Pay__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Compound_Max_Pay__r.Name + '\'' + ',';

        for (Accumulation_Change_Copay__c accumCopay: accumCopayList) {
            mainString = mainString + '\'' + accumCopay.Copay_Calculation__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.DAW_Code__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.MS_Code_M__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.MS_Code_N__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.MS_Code_O__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.MS_Code_Y__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Reverse__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.Stepped__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopay.RecordType.Name + '\'' + ',';
        }

        for (Accumulation_Change_Copay_Stepped__c accumCopayStepped: accumCopaySteppedList) {
            mainString = mainString + '\'' + accumCopayStepped.Copay_Calculation__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Beginning_Range__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Number_of_Steps__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.End_Range__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Percent__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Reverse__c + '\'' + ',';
            mainString = mainString + '\'' + accumCopayStepped.Type_of_Stepped_Copay__c + '\'' + ',';
        }

       

        // added by rakesh - Req. 00889
        mainString = mainString + '\'' + crd.Client_Name_On_Communication__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Custom_Disease_Vendor_2_Phone_Number__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Vendor_2__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Vendor_1_Implementation_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Disease_Vendor_2_Implementation_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.CRD_Risk_Indicator__c + '\'' + ',';

        for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.Accum_Code_Deductible__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Accum_Code_Maximum_Allowable_Benefit__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Accum_Code_Maximum_Out_Of_Pocket__c + '\'' + ',';
        }
        for (Copay_Tier__c coPay: copayTierList) {
            mainString = mainString + '\'' + coPay.Days_Per_Fill__c + '\'' + ',';
        }

        mainString = mainString + '\'' + crd.Are_Emergency_Claims_Reimbursed__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Are_Hemo_Claims_Reimbursed__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Emergency_Discount_Rate__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Hemo_Discount_Rate__c + '\'' + ',';
       // mainString = mainString + '\'' + crd.POS_Dose_Optimization__c + '\'' + ','; ---> request no 4870- Nitish
        mainString = mainString + '\'' + crd.CVS_Caremark_Drug_List_ID__c + '\'' + ',';
       // mainString = mainString + '\'' + crd.POS_Dose_Optimization_Drug_List_ID__r.Name + '\'' + ',';--> Commented by Nitish dependency of request no 4870

    

        for (Aetna_RxHealthy_Outcomes_Junction__c ahoRecord: ahoJunctionList) {
           // mainString = mainString + '\'' + ahoRecord.Name + '\'' + ',';
            mainString = mainString + '\'' + ahoRecord.Aetna_RxHealthy_Outcomes_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + ahoRecord.Selected__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Save_A_Copay_Custom_Letter__r.Name + '\'' + ',';
        //mainString = mainString + '\'' + crd.Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c + '\'' + ',';

        mainString = mainString + '\'' + crd.Tier_1_Rx_Reduction_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_1_Rx_Reduction_Amount__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_2_Rx_Reduction_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_2_Rx_Reduction_Amount__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_3_Rx_Reduction_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_3_Rx_Reduction_Amount__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_4_Rx_Reduction_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_4_Rx_Reduction_Amount__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_5_Rx_Reduction_Type__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tier_5_Rx_Reduction_Amount__c + '\'' + ',';

        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Brand_Penalty_Type__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Generic_Penalty_Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Generic_Penalty_Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Generic_Penalty_Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Generic_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Generic_Penalty_Type__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c + '\'' + ',';
        }

        

        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Non_Pref_Brand_Penalty_Type__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incentivized_Mail_Brand_Penalty_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incentivized_Mail_Brand_Penalty_Type__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Percent__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Min__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Max__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incentivized_Mail_Generic_Penalty_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incentivized_Mail_Generic_Penalty_Type__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Percent__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Min__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Max__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_NonPref_Brand_Penalty_Amount__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_NonPref_Brand_Penalty_Type__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Percent__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Min__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Max__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Restart_Fills__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Brand_Penalty_Exception__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Tiering_Formulary_Exception__c + '\'' + ',';
        mainString = mainString + '\'' + crd.Global_Benefit_Exclusion__c + '\'' + ',';
       
        // Rishabh : Req 868
     //   mainString = mainString + '\'' + crd.Is_this_an_HDHP_Plan__c + '\'' + ',';
      //  mainString = mainString + '\'' + crd.What_is_the_HDHP_fund_type__c + '\'' + ',';
     //   mainString = mainString + '\'' + crd.Chronic_Preventive_Drug_List__c + '\'' + ',';
     //   mainString = mainString + '\'' + crd.Chronic_and_or_Preventive_List__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.Waiver_of_Rx_Deductible__c + '\'' + ',';
        
        // Added by Sushant: Req 01033
        for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.Do_not_apply_flat_fee_to_OOP__c + '\'' + ',';
            mainString = mainString + '\'' + accumulation.Do_not_apply_penalty_to_OOP__c + '\'' + ',';
        }
        
        // Added by Sushant: Req 01129
        //mainString = mainString + '\'' + crd.DED_Waive_Preferred_Generic_IN__c + '\'' + ',';
        //mainString = mainString + '\'' + crd.DED_Waive_Preferred_Generic_OON__c + '\'' + ',';
        
        // Added by Sushant: Req 01129
        for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.What_is_the_In_Network_Deductible_Amount__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.What_is_the_In_Network_MOOP_Amount__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.Cross_Accumulation__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.What_is_the_OON_Deductible_Amount__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.What_is_the_OON_MOOP_Amount__c+ '\'' + ',';
            }
         /*
          Commented By Sushant : Req 04937  
         // Added by Sushant : Req 01139   
         for (MOOP_Bypass__c MOOPBypass : MOOPBypassList) {
            mainString = mainString + '\'' + MOOPBypass.MOOP_Bypass_Type__c + '\'' + ',';
            mainString = mainString + '\'' + MOOPBypass.MOOP_Bypass_Drug_List_Name__c + '\'' + ',';
            mainString = mainString + '\'' + MOOPBypass.MOOP_Bypass_Drug_Group_Name__c + '\'' + ',';
            }
          */         
          // Added by Sushant : Req 01129
         mainString = mainString + '\'' + crd.Waive_Deductible_for_Tier_1_Drugs__c+ '\'' + ',';
         
         // Added by Sushant : Req 01185
         for (DC_Drug_List_Group__c dc: dcDrugListGroup) {
            mainString = mainString + '\'' + dc.Bypass_MOOP__c+ '\'' + ',';
            }
            
         mainString = mainString + '\'' + crd.Does_3_Month_Grace_Period_Apply__c + '\'' + ',';
       
         // below line of code added by abhishek date on 10/9/2013
         for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Min__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Brand_Penalty_Max__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Min__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_Gen_Penalty_Max__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Percent__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Min__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Incent_Mail_NP_Brand_Penalty_Max__c + '\'' + ',';
        }
            
        //Added by Sushant for Req 1159
          mainString = mainString + '\'' + crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c + '\'' + ',';           
        
        //Added by JR for Req 4288
          mainString = mainString + '\'' + crd.Aetna_RxStep__c + '\'' + ',';
          
           //added by JR for request no 4288
        for (Aetna_RxStep_Junction__c asrRecord: AsrJunctionList) {
            //mainString = mainString + '\'' + asrRecord.Name + '\'' + ',';
            mainString = mainString + '\'' + asrRecord.Drug_Lists__c + '\'' + ',';
            mainString = mainString + '\'' + asrRecord.Selected__c + '\'' + ',';
            mainString = mainString + '\'' + asrRecord.Drug_List__r.CVS_Caremark_Drug_List_ID__c + '\'' + ',';
            mainString = mainString + '\'' + asrRecord.Drug_List__c + '\'' + ',';
            
        }
               
        //Added by Richa for Req 4591 & 4592  
          for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Retail_Refill_Allowance_No_of_days__c + '\'' + ','; 
            //mainString = mainString + '\'' + drugCoverage.RRA_Drug_List__c+ '\'' + ','; 
            //mainString = mainString + '\'' + drugCoverage.RSO_Drug_List__c+ '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Transition_Fill_Number_of_Days__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Allow_Transition_Fill__c + '\'' + ',';
        }
        
        for (DC_Drug_List_Group__c dc: dcDrugListGroup) {
            mainString = mainString + '\'' + dc.Allow_Transition_Fill__c + '\'' + ',';
        }
        
        //Added by Richa for Req 4611  
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Does_Dose_Limit_apply__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Dose_Limit__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Higher_Lower_than__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Dose_Limit_Exception_Drug_List__c + '\'' + ',';
        }
        
        //Added by JR to implement request 4712
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Secondary_of_fills_before_force_to_SPN__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Secondary_Force_to_Specialty__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Secondary_RRA_Drug_List__c + '\'' + ',';
            //mainString = mainString + '\'' + drugCoverage.Secondary_RSO_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Secondary_Speciality_Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c + '\'' + ',';
        }
        // Added By Nitish : req no 04731
       for (Waiver_Of_Deductible__c WOD: WODList) {
                if (WOD.CRD_ID__c == crd.Id) {
                    mainString = mainString + '\'' + WOD.Drug_Class__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Drug_Class_Desc__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Drug_Group__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Drug_List__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Delivery_System__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.M__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.N__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.O__C + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Y__c + '\'' + ',';
                    mainString = mainString + '\'' + WOD.Standard__c + '\'' + ',';
                    mainString = mainString + '\'' + Wod.Network__c + '\'' + ',';//Added By Nitish 6911
                }
            }
        //Richa added for Req-4811
        for (Drug_Coverage__c drugCoverage: drugCoverageList) {
            mainString = mainString + '\'' + drugCoverage.Number_of_fills__c + '\'' + ',';
            //Added by JR to implement request 4719 *start
            mainString = mainString + '\'' + drugCoverage.Max_Specialty_Day_Supply__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Standard_Fully_Insured_Pricing__c + '\'' + ',';//Richa added for 04871
        for (CRD_NPL_Junction__c crdNPLJunction : CRDNPLJunctionList) {
 
            mainString = mainString + '\'' + crdNPLJunction.Drug_List__c + '\'' + ',';
            mainString = mainString + '\'' + crdNPLJunction.Select__c + '\'' + ',';
        }
        mainString = mainString + '\'' + crd.Custom_NPL__c + '\'' + ',';
        
     //Added by Sushant Req 05244: 04/11/2014
        
        for (DC_Drug_List_Group__c dc: dcDrugListGroup) {
          mainString = mainString + '\'' + dc.Start_Age__c + '\'' + ',';
          mainString = mainString + '\'' + dc.End_Age__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Start_Age_Type__c + '\'' + ',';
          mainString = mainString + '\'' + dc.End_Age_Type__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Gender__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Day_Quantity_Rule__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Minimum_Days__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Minimum_Quantity__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Maximum_Days__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Maximum_Quantity__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Daily_Dose__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Maximum_Fills__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Max_Days_per_Fill__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Maximum_Dollars__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Days_Over_Time_Time_Period__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Days_Over_Time_of_Days__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Days_Over_Time_Time_Value__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Max_Quantity_per_Fill__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Quantity_Over_Time_Time_Period__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Quantity_Over_Time_Quantity__c + '\'' + ',';
          mainString = mainString + '\'' + dc.Quantity_Over_Time_Time_Value__c + '\'' + ',';

        }        
        // Added By Nitish Request No 4751
         for (AccumulationSpecificDrug__c accumDrug: accumDrugList) {
                mainString = mainString + '\'' + accumDrug.Exclude_from_Accumulation__c+ '\'' + ',';
         }
         //Richa added on 22nd Dec for Req 4890
         mainString = mainString + '\'' + crd.Does_Chemo_Parity_Apply__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Chemo_Parity_Drug_List__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Dollar_Amount__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Percent__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Copay_Calculation__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Oral_Chemo_Cap__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Chemo_Drugs_Bypass_Deductible__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Chemo_Drugs_Bypass_MAB__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Chemo_Drugs_Bypass_OOP__c + '\'' + ',';
         mainString = mainString + '\'' + crd.Chemo_Drugs_In_Network_same_as_OON__c + '\'' + ',';
         
         //Added by Sushant : Request 05521
         mainString = mainString + '\'' + crd.CA_50_Cost_Share_Applies__c+ '\'' + ',';
         //Added by sushant : Request 05486
         mainString = mainString + '\'' + crd.NPL_Applies__c+ '\'' + ',';
         mainString = mainString + '\'' + crd.NPL_Drug_List__c+ '\'' + ',';
         //Added by Amit for Support Ticket 150 on 24th July,2015
         for (Accumulations__c accumulation: accumulationList) {
            mainString = mainString + '\'' + accumulation.Start_Month_New__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.Start_Day__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.Accumulation_End_Date__c+ '\'' + ',';
            mainString = mainString + '\'' + accumulation.When_will_the_Accumulations_renew__c+ '\'' + ',';
        }
        //Added by Sushant: ST 2153
        for(Retail_Vaccine_Program__c rvp : rvpList){
            mainString = mainString + '\'' + rvp.RecordType.Name+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Applies__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.CoPay_Calculation__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Dollar_Amount__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Maximum_Dollar__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Minimum_Dollar__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Percent__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Vaccine_Network__c+ '\'' + ',';
            mainString = mainString + '\'' + rvp.Waiver_of_Deductible__c+ '\'' + ',';
        }
        
        
        return mainString;
    }

    /**
    * Method :- SendToAI(Id crdId)
    * Description :- The method is used to break the String if the length of string is greater than 32000
    **/
    Public List < string > SendToAI(Id crdId) {
        List < string > RxPlanString = new List < string > ();
        String mainString = sendToAIString(crdId);
        string regExp = 'null';
        string Replacement = '';
        mainstring = mainstring.Replace('null', '');

        Integer length = mainString.length();
        if (length > 32000) {
            string substring1 = mainstring.substring(0, 31999);
            substring1 = substring1.substring(0, substring1.lastIndexof(','));
            Integer length2 = substring1.length();
            string substring2 = mainstring.substring(length2 + 1, length - 1);
            Integer length3 = substring2.length();
            RxPlanString.add(substring1);
            RxPlanString.add(substring2);
        } else RxPlanString.add(mainString);
        RxPlanString.add(' ');
        return RxPlanString;
    }

}