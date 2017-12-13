/*Purpose: Apex Class for Cloning the CRD                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -    ABHAY                10/20/2011       Apex Class for Cloning the CRD
2.0 -    Anuj                 12/20/2011       Issue # 1282
2.1 -    Anuj                 02/02/2012       10 new fields on crd 
2.3 -    Sourabh              02/24/2012       Added new fields for Drug Coverage # Issue 1477
2.4 -    Rishabh              04/06/2012       Request no: 028  
2.5 -    Rishabh              08/10/2012       Request no: 826
2.6 -    Sourabh              08/21/2012       Request 754  
2.7 -    Anuj                 08/22/2012       added 2 new object in under drug Coverage
3.0      rakesh               09/10/2012       As per req. 761
Commented 'Pays_the_DAW_difference_after_deductible' field.
Added field 'DAW_Differential_Penalty_Applies_to_MOOP__c'
3.1      rakesh               09/11/2012       added field 'What_happens_when_MOOP_is_met__c' (Req. 786)
3.2      rakesh               09/19/2012       Req 761
3.3      rakesh               09/24/2012       Req 225
3.4      rakesh               10/12/2012       Req 442
3.5      Amit                 03/06/2013       Req 906
3.6      Rishabh              03/12/2013       Req 900
3.7      Rishabh              03/14/2013       Req 868
3.8      Rishabh              03/29/2013       Req 927
3.9      Sushant              04/12/2013       Req 967
4.0      Amit                 06/25/2013       Req P8533a
4.1      Sushant              07/17/2013       Req 01094
4.2      Sushant              07/18/2013       Re 1050
4.3      Sushant              07/29/2013       Req 01112
4.4      Sushant              08/05/2013       Req 01129
4.5      Sushant              08/07/2013       Req 01139(MOOP Bypass Code)
4.6      Sushant              08/14/2013       Req 01122
4.7      Rahul Nasa           08/14/2013       Req 01121
4.8      Rahul Nasa           08/14/2013       Req 01120
4.9      Sushant              09/16/2013       Req 01185
4.10     Abhishek             10/07/2013       Req 01142
4.11     Sushant              11/19/2013       Req 01159  
4.12     Joognu Rao           02/19/2014       Req 04288 
5.0      Sushant              02/25/2014       Comments added
5.1      Joognu Rao           02/26/2014       Req 04550
5.2      Sushant              03/25/2014       Req 04610
5.3      Joognu Rao           04/18/2014      Implemented Request no 4712
5.4      Joognu Rao           04/24/2014      Implemented request no 4729
5.5      Joognu Rao           04/28/2014      Implemented request no 4525
5.6      Joognu Rao           04/29/2014      Implemented request no 4719
5.7      Nitish Verma         04/30/2014      Implemented request no 4681
5.8      Joognu Rao           04/30/2014      Implemented request no 4771
6.0      Nitish Verma         06/05/2014      Implemented request no 04869
6.1      Nitish Verma         06/05/2014      Implemented request no 4870
6.2      Richa Gupta          07/30/2014      Commented all Hypertension and Hyperlipidemia fields for Req4558
6.3      Sushant Sethi        08/20/2014      Implemented Cloning of CRD NPL Section as per Req 04872
7.0      Nitish Verma         12/03/2014      Implemented Request No 4751
8.0      Sushant Sethi        01/13/2015      Implemented Request 05310
8.1      Sushant Sethi        03/23/2015      Implemented Requuest 05521
9.0      Nikita Bansal        07/31/2015      Implemented Request 05947
======================================================================== */
/**
* Class :- VFP_CloneCRD
* Description :- Apex Class for Cloning the CRD
**/

public class VFP_CloneCRD {
    
    public string crdid {
        get;
        set;
    }
    public string Concatinated15DigitCRDID {
        get;
        set;
    }    
    public string currentCRDID {
        get;
        set;
    }
    public CRD__c existingCRD {
        get;
        set;
    }
    public CRD__c clonedCRD {
        get;
        set;
    }
    public ID newCRDId {
        get;
        set;
    }
    public boolean IsFrombatch {
        get;
        set;
    }
    public String selectedCrdId{
        get;
        set;
    }
    public Map < Id, Id > oldnewCopayMap = new Map < Id, Id > ();
    
    /**
* Method :- VFP_CloneCRD
* Description :- Method to clone CRD and all associated records/related objects/child objects
**/    
    public VFP_CloneCRD() {}
    /**
* Method :- cloneCrdWithItems
* Description :- Method to Start the cloning process from CRD
**/
    public void cloneCrdWithItems(String selectedCrdId, CRD__c currentCrd, Boolean IsFrombatch) {
        if(selectedCrdId!=null){
            crdId = selectedCrdId;
        }else{
            crdId = currentCrd.Standard_Plan_Selection__c; //    RxCheselectedCrdId;
        }
        Concatinated15DigitCRDID = crdid.substring(0,15);
        
        try {
            existingCRD = [Select RxPlanID__c,Aetna_RxStep__c,TPID_New_Value__c,
                           Full_Control_Group__c,Plan_Platform__c,
                           OON_Cost_Share_Not_Greater_50_Drug_Cost__c,Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c,
                           Clone_Retail_Y_Schedule__c,Account__c, Migration_Run_Number__c, BPERxPlan_ID__c, Transition_Plan_1_x_override_30DS__c,
                           Toll_Free_Number__c, Tiering__c, Tier_5_Copay_Reduction__c, Tier_4_Copay_Reduction__c, Tier_3_Copay_Reduction__c,
                           Tier_2_Copay_Reduction__c, Tier_1_Copay_Reduction__c, PSP_Letter_Templates__c, TP_ID__c, SystemModstamp, Subsegment__c,
                           SteppedCopayCount__c, Step_Therapy_TOC_days__c, Status__c, State_associated_with_this_plan__c, State__c, Standard_or_Custom_Plan__c,
                           Standard_Step_Therapy_Program__c, Standard_QL_Program__c, Standard_QL_List_or_Select_Classes__c, Standard_Program_or_Select_Classes__c,
                           Standard_Precert_Program__c, Standard_Precert_List_or_Select_Classes__c, Standard_Plan_Selection__c, Specialty_Therapy_Management__c,
                           Specialty_Retail_Lock_Out__c, Specialty_Number_of_Tiers__c, Specialty_Exclusion_Flag__c, Service_Enhancement_Date__c, 
                           Rx_Will_you_be_Picking_Drug_Classes__c, Rx_PP_ID__c, Rx_Override_Option__c, RxPlanData__c, RxPlanDataExp__c, Risk_Indicator__c,
                           Retail_to_Mail__c, /*Retail_to_Mail_Messaging__c,*/Retail_refill_for_Manufacture_Back_Order__c,Retail_Source_AWP__c,
                           Retail_Number_of_Tiers__c, Reporting_Frequency__c, Reimbursement_Levels__c, Rating__c, Rating_ERB__c, RTMD_Modulator_Percent__c,
                           RTMD_Effective_Date__c, RTMD_Client_Share_Percent__c, RTMD_Admin_Fee_rate__c, RTMD_Admin_Fee_basis__c, RDS__c, RDS_Termination_Date__c,
                           RDS_Effective_Date__c, Prorate__c, Process_Point_of_Sales_COB__c, Prior_Authorization_ID__c, Pricing_Schedule__c, Prescriber_Network__c,
                           Precert_TOC_days__c, Pre_Implementation_Audit__c, Platform_Information__c, Plan_Type_Specialty__c, Plan_Type_Retail__c, Plan_Type_Paper__c,
                           Plan_Type_Mail__c, Plan_Extract_Date__c, Plan_Description__c, Plan_Coordinate_Benefits__c, Pharmacy_Advisor__c, Partner_Server__c,
                           Participate_in_CVS_mail_pharmacy_service__c, Participant_Mail_In_Delay__c, Participant_Lost_Stolen_Damaged_Meds__c, Partial_Control_Group__c,
                           Paper_Number_of_Tiers__c, PSP_Override_Option__c, POS_Rebate_for_Plan__c, /*POS_Dose_Optimization_Drug_List_ID__c,*/
                           Out_of_Network_claims_are_reimbused__c, Out_of_Network__c, Out_of_Network_Reimbursement_Level__c, Out_of_Network_Cost_Sharing__c,
                           Other_Insurance_Paid_in_Error__c, Ostomy_Supplies__c, Opt_out_of_Safety_Edits__c, Opt_out_of_Rx_OTC_Edit__c,Custom_NPL__c,NPL_Applies__c,NPL_Drug_List__c,                           Offshore__c, Offering_Type__c, Nursing_Home__c, Nursing_Home_Claims__c, Number_of_Participants__c, No_of_Days_to_file_a_claim__c,
                            National__c, Name_of_Approver_on_SSD__c, Name, Multiple_Births__c, /*Migrane_Management__c,*/ Medicaid__c,
                           Maximum_Dollar__c, Manual_Pharmacy_Payments__c, /*SAC_Letter_Templates__c,*/ Mail_Y_Schedule__c, Mail_Order_Delay__c, Mail_Number_of_Tiers__c,
                           MDL_or_QVT_Limit_Exceptions__c, Is_DM_vendor_the_same_for_each_condition__c, Integration_Status__c, Integration_2__c, Integration_1__c,
                           Integrate_with_Medical__c, Waive_Deductible_for_Tier_1_Drugs__c,Indian_Facilities__c, Incumbent_PBM__c, Incorrect_Days_Supply__c,
                           Include_Kit_Logic__c, In_Network_claims_are_reimbursed__c, In_Network__c, In_Network_Reimbursement_Level__c, 
                           Implementation_Type__c, Id,High_Value_Client__c, /*Health_Care_for_Life__c,*/
                           Group_submits_eligibility_file__c, Group_submits_Cost_Reporting__c, Group_ID__c, Generic_Uptake__c, Generic_Launch__c, Gaps_in_Care__c,
                           G_PlanSummary__c, G_Control__c, Foreign_Claims__c, /*FSA_Integration__c,*/ Extra_Care_Health_Card__c, Expatriate_Employees__c, Erisa_Client__c,
                           Enrolled_in_PA_for_other_condition__c, Enroll_in_RxCheck__c, End_Date__c, Effective_Start_Date__c, Effective_Date__c,
                           Durg_Specific_Stepped_Count__c, Duplicate_Therapy__c, Drug_Specific_copay_count__c, Drug_List_Option__c, Dose_Optimization__c,
                           Dosage_Increase_Change__c, Does_the_client_want_to_do_COB__c,  Do_you_want_to_do_Step_Therapy__c,
                           Do_you_want_to_do_Save_A_Copay__c, Do_you_want_to_do_Precert__c, Do_Prescription_Savings_Program__c, Disease_Vendor__c,
                           Disease_Management_Referral_Messaging__c, Disease_Management_Messaging_for__c, Discount_Rate__c, Disaster_Emergency__c, Default_NABP__c,
                           Date_of_Approval_on_SSD__c, Customization_Approved__c, Custom_call_center_phone_number__c, /*Custom_TFN__c,*/ Custom_Step_Therapy_Date_Approved_ST__c,
                           Custom_Step_Therapy_Date_Approved_QL__c, Custom_Step_Therapy_Classes__c, Custom_Quantity_Limits_Classes__c, Custom_Precert_Date_Approved__c,
                           Custom_Precert_Classes__c, Custom_Network_Flag__c, Custom_Ben_ID__c, Cost_Sharing_Amount__c, Copay_Dollar_Amount__c, ConnectionSentId,
                           ConnectionReceivedId, Concurrent_DUR_ID__c, Compound_Code_2__c, Co_Brand_Initial_Program_Welcome_Mailing__c, Clinic_Physician_Reimbursement__c,
                           Client_Effective_Date__c, Client_Contact_Phone__c, Client_Contact_Last_Name__c, Client_Contact_First_Name__c, Client_Contact_Email_Address__c,
                           Claims_payable_with_Pharm_Signature__c, Claims_Acceptable_w_o_receipts__c, Carrier_ID__c, Caremark_submit_IRL_files_to_RDS__c,
                           CVS_submits_eligibility_file_to_Aetna__c, CVS_submits_cost_reporting_to_Aetna__c, COB_or_MOB__c, CM_submits_ongoing_monthly_files_to_RDS__c,
                           Bridge_Supply__c,/* Blood_Glucose_Monitoring__c,*/ Are_you_creating_a_Package_Plan__c, Are_there_Quantity_Limits__c,
                           /*Approved_from_CustFormulary_Committee_ST__c, Approved_from_CustFormulary_Committee_QL__c, Approved_from_CustFormulary_Committee_PA__c,*/
                           Apply_Retail_Copay__c, Application_ID__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Retail_copays__c, Any_drug_specific_Paper_copays__c,
                           Any_drug_specific_Mail_copays__c, SAC_Override_Option__c, Annual_Fill_Limit_Allowed_Limit__c, Allergy_Serums__c, Aetna_Healthy_Actions__c,
                           Aetna_Autofill__c, Administration_of_External_COB__c, ARH_Offering_Type__c, Diabetes_Preventive__c, Asthma_Preventive__c,
                           Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/
                           Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Mail_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Specialty_copays__c,
                           Plan_Type_Paper_Out_of_Network__c, Different_copays_from_Paper_In_Network__c, Apply_Penalty__c, Penalty_Type__c, Penalty_Amount__c,
                           Percentage_Applied__c, Paper_Out_of_Network_Number_of_Tiers__c, Any_drug_specific_Paper_Out_of_Network__c,/* of_months_for_Copay_Waiver__c,*/ Year__c,
                           Y_Schd__c, Who_processes_PA_or_Override__c, Which_system_will_the_plan_be_installed__c, Veterans_Admin__c, Vendor_Transition_Files__c, Value_Generic__c,
                           Vacation__c, UBOI_ID__c, Type_of_Cost_Sharing__c, Brands_w_DAW_5_take_a_generic_copay__c, Is_there_Paper_Out_of_Network__c,
                           Any_DAW_specific_Paper_OON_copays__c, Generic_Code_Conversion__c, GPI_System_Drug_List__c, NDC_System_Drug_List__c, Kit_Logic_Standard_Drug_List__c,
                           Max_Pay__c, Override_Standard_Max_Pay__c, In_Network_Discount_Rate__c, Out_of_Network_Discount_Rate__c, Bypass_DMR__c, Quantity_Limit_TOC_of_Days__c,
                           High_Priority_Comments__c, Is_there_Compound_Max_Pay__c, Override_Standard_Compound_Max_Pay__c, Compound_Max_Pay__c, Client_Name_On_Communication__c,
                           Custom_Disease_Vendor_2_Phone_Number__c, Disease_Vendor_2__c, Disease_Vendor_1_Implementation_Type__c, Disease_Vendor_2_Implementation_Type__c,
                           CRD_Risk_Indicator__c, Aetna_Rx_Healthy_Outcomes__c, Are_Emergency_Claims_Reimbursed__c, Are_Hemo_Claims_Reimbursed__c, Emergency_Discount_Rate__c,
                           Hemo_Discount_Rate__c, DM_Vendor_2_Contract_End_Date__c, /*POS_Dose_Optimization__c,*/ Insured_Type__c, Clone_Insured_Type__c, Funding_Type_New_Value__c,
                           Adherence_to_Drug_Therapy__c, Tier_1_Rx_Reduction_Type__c, Tier_2_Rx_Reduction_Type__c, Tier_3_Rx_Reduction_Type__c, Tier_4_Rx_Reduction_Type__c,
                           Tier_5_Rx_Reduction_Type__c, Tier_1_Rx_Reduction_Amount__c, Tier_2_Rx_Reduction_Amount__c, Tier_3_Rx_Reduction_Amount__c, Tier_4_Rx_Reduction_Amount__c,
                           Tier_5_Rx_Reduction_Amount__c, Brand_Penalty_Exception__c, Tiering_Formulary_Exception__c, Global_Benefit_Exclusion__c,PA_Disease_Vendor_1__c,
                           PA_Condition_1__c,PA_DM_Vendor_Contract_End_Date_1__c,PA_Custom_Disease_Vendor_Phone_1__c,PA_Disease_Vendor_2__c,PA_Condition_2__c,
                           PA_DM_Vendor_Contract_End_Date_2__c,PA_Custom_Disease_Vendor_Phone_2__c,PA_Disease_Vendor_3__c,PA_Condition_3__c,
                           PA_DM_Vendor_Contract_End_Date_3__c,PA_Custom_Disease_Vendor_Phone_3__c,PA_Disease_Vendor_4__c,PA_Condition_4__c,
                           PA_DM_Vendor_Contract_End_Date_4__c,PA_Custom_Disease_Vendor_Phone_4__c,PA_Disease_Vendor_5__c,PA_Condition_5__c,PA_DM_Vendor_Contract_End_Date_5__c,
                           PA_Custom_Disease_Vendor_Phone_5__c,PA_Disease_Vendor_6__c,PA_Condition_6__c,PA_DM_Vendor_Contract_End_Date_6__c,PA_Custom_Disease_Vendor_Phone_6__c,
                           PA_Disease_Vendor_7__c,PA_Condition_7__c,PA_DM_Vendor_Contract_End_Date_7__c,PA_Custom_Disease_Vendor_Phone_7__c,Enroll_in_Aetna_Ways_to_Save__c,
                           Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,
                           Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,
                           Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c,
                           Cloned_CRD_Plan_Effective_Date__c,Cloned_CRD_RxPlan_ID__c,Contract_State__c, Mail_Request_Date__c, Requested_mailing_received_on__c,
                           Target_Generic_Opportunities__c, Target_Formulary_Brand_Opportunities__c, Target_Pref_Manufacturer_Brand_Opportun__c,
                           Target_Participants_18_years_and_older__c, Preferred_Manufacturer_Brands_Code__c, If_Not_18_Indicate_Age__c, Member_Letter_Selection__c,
                           Minimum_Member_Savings_Projection__c, Introductory_Paragraph_to_Include__c, Medical_Injectible_Claim_Denial_Process__c, LastSent__c,
                           /*Fields added by Rahul Nasa Request No. 1146*/ Brands_DAW_5_take_a_gen_copay_Retail__c,Brands_DAW_5_take_a_gen_copay_Mail__c,
                           Brands_DAW_5_take_a_gen_copay_Speciality__c,Brands_DAW_5_take_a_gen_copay_Paper__c,Aetna_RxHealthy_Outcomes_Drug_Group__c,AHA_Drug_Group__c,Mac_at_Mail_Applies__c,
                           Custom_Safety_Edits__c,Tier_1_Rx_Reduction__c,Tier_2_Rx_Reduction__c,Tier_3_Rx_Reduction__c,Tier_4_Rx_Reduction__c,Tier_5_Rx_Reduction__c,Acquisition_Indicator__c,
                           /*, DED_Waive_Preferred_Generic_IN__c, DED_Waive_Preferred_Generic_OON__c*/Does_Chemo_Parity_Apply__c,Chemo_Parity_Drug_List__c,Oral_Chemo_Cap__c,Dollar_Amount__c,Percent__c,Copay_Calculation__c,
                            Chemo_Drugs_Bypass_Deductible__c,Chemo_Drugs_Bypass_MAB__c,Chemo_Drugs_Bypass_OOP__c,Chemo_Drugs_In_Network_same_as_OON__c,CA_50_Cost_Share_Applies__c
                           From CRD__c where id =: crdid];
            
            
            currentCrd.Override_Retail_Y_Schedule__c = existingCRD.Override_Retail_Y_Schedule__c;
            currentCrd.Retail_Y_Schedule_Override__c = existingCRD.Retail_Y_Schedule_Override__c;
            
            //Added By Sushant: Req:1018 Start***
            currentCrd.Cloned_CRD_Plan_Effective_Date__c = Date.valueof(existingCRD.Effective_Start_Date__c);
            //currentCrd.Cloned_CRD_RxPlan_ID__c = Decimal.valueof(existingCRD.RxPlanID__c);
            if(existingCRD.RxPlanID__c == null){
                currentCrd.Cloned_CRD_RxPlan_ID__c = 0;             
            }else{
                if(existingcrd.Standard_or_Custom_Plan__c != 'Creating a packaged consumer business plan' && existingCRd.Standard_or_Custom_Plan__c !='Cloning a packaged consumer business plan from an existing CRD'){
                        currentCrd.Cloned_CRD_RxPlan_ID__c = Decimal.valueof(existingCRD.RxPlanID__c);  
                }
            }
            // *** End
            
            currentCrd.Brand_Penalty_Exception__c = existingCRD.Brand_Penalty_Exception__c;
            currentCrd.Tiering_Formulary_Exception__c = existingCRD.Tiering_Formulary_Exception__c;
            currentCrd.Global_Benefit_Exclusion__c = existingCRD.Global_Benefit_Exclusion__c;
            currentCrd.Override_Standard_Max_Pay__c = existingCRD.Override_Standard_Max_Pay__c;
            currentCrd.Max_Pay__c = existingCRD.Max_Pay__c;
            //added on 4/6/12 by Rishabh for request 028
            currentCrd.Kit_Logic_Standard_Drug_List__c = existingCRD.Kit_Logic_Standard_Drug_List__c;
            currentCrd.Generic_Code_Conversion__c=existingCRD.Generic_Code_Conversion__c;
            //add a condition below for cloning hix plan by abhishek goel date on 1/10/2014
            if(existingCRD.Standard_or_Custom_Plan__c != 'Cloning a HIX plan from existing CRD')
            {
                currentCrd.GPI_System_Drug_List__c = existingCRD.GPI_System_Drug_List__c;
                currentCrd.NDC_System_Drug_List__c = existingCRD.NDC_System_Drug_List__c;
            }
            // added bby rishabh for request 826 on 08/10/12
            currentCrd.In_Network_Discount_Rate__c = existingCRD.In_Network_Discount_Rate__c;
            currentCrd.Out_of_Network_Discount_Rate__c = existingCRD.Out_of_Network_Discount_Rate__c;
            currentCrd.Bypass_DMR__c = existingCRD.Bypass_DMR__c;
            currentCrd.Aetna_Rx_Healthy_Outcomes__c = existingCRD.Aetna_Rx_Healthy_Outcomes__c;
            //Added by Sourabh  : Request 754
            currentCrd.High_Priority_Comments__c = existingCRD.High_Priority_Comments__c;
            currentCrd.Aetna_Healthy_Actions__c = existingCRD.Aetna_Healthy_Actions__c;
            currentCrd.Any_DAW_specific_Retail_copays__c = existingCRD.Any_DAW_specific_Retail_copays__c;
            currentCrd.Any_DAW_specific_Mail_copays__c = existingCRD.Any_DAW_specific_Mail_copays__c;
            currentCrd.Any_DAW_specific_Paper_copays__c = existingCRD.Any_DAW_specific_Paper_copays__c;
            currentCrd.Any_DAW_specific_Specialty_copays__c = existingCRD.Any_DAW_specific_Specialty_copays__c;
            currentCrd.Allergy_Serums__c = existingCRD.Allergy_Serums__c;
            currentCrd.Annual_Fill_Limit_Allowed_Limit__c = existingCRD.Annual_Fill_Limit_Allowed_Limit__c;
            currentCrd.Any_drug_specific_Mail_copays__c = existingCRD.Any_drug_specific_Mail_copays__c;
            currentCrd.Any_drug_specific_Paper_copays__c = existingCRD.Any_drug_specific_Paper_copays__c;
            currentCrd.Any_drug_specific_Retail_copays__c = existingCRD.Any_drug_specific_Retail_copays__c;
            currentCrd.Any_drug_specific_Specialty_copays__c = existingCRD.Any_drug_specific_Specialty_copays__c;
            currentCrd.Application_ID__c = existingCRD.Application_ID__c;
            currentCrd.Apply_Retail_Copay__c = existingCRD.Apply_Retail_Copay__c;
            currentCrd.Are_there_Quantity_Limits__c = existingCRD.Are_there_Quantity_Limits__c;
            currentCrd.Aetna_Autofill__c = existingCRD.Aetna_Autofill__c;
            //currentCrd.Blood_Glucose_Monitoring__c = existingCRD.Blood_Glucose_Monitoring__c;  --> Commented By Nitish Request No- 04869
            currentCrd.Bridge_Supply__c = existingCRD.Bridge_Supply__c;
            currentCrd.Adherence_to_Drug_Therapy__c = existingCRD.Adherence_to_Drug_Therapy__c;
            currentCrd.Caremark_submit_IRL_files_to_RDS__c = existingCRD.Caremark_submit_IRL_files_to_RDS__c;
            currentCrd.Carrier_ID__c = existingCRD.Carrier_ID__c;
            currentCrd.Claims_Acceptable_w_o_receipts__c = existingCRD.Claims_Acceptable_w_o_receipts__c;
            currentCrd.Claims_payable_with_Pharm_Signature__c = existingCRD.Claims_payable_with_Pharm_Signature__c;
            currentCrd.Client_Contact_Email_Address__c = existingCRD.Client_Contact_Email_Address__c;
            currentCrd.Client_Contact_First_Name__c = existingCRD.Client_Contact_First_Name__c;
            currentCrd.Client_Contact_Last_Name__c = existingCRD.Client_Contact_Last_Name__c;
            currentCrd.Client_Contact_Phone__c = existingCRD.Client_Contact_Phone__c;
            currentCrd.Client_Effective_Date__c = existingCRD.Client_Effective_Date__c;
            currentCrd.Clinic_Physician_Reimbursement__c = existingCRD.Clinic_Physician_Reimbursement__c;
            currentCrd.CM_submits_ongoing_monthly_files_to_RDS__c = existingCRD.CM_submits_ongoing_monthly_files_to_RDS__c;
            currentCrd.Co_Brand_Initial_Program_Welcome_Mailing__c = existingCRD.Co_Brand_Initial_Program_Welcome_Mailing__c;
            currentCrd.COB_or_MOB__c = existingCRD.COB_or_MOB__c;
            currentCrd.Compound_Code_2__c = existingCRD.Compound_Code_2__c;
            currentCrd.Concurrent_DUR_ID__c = existingCRD.Concurrent_DUR_ID__c;
            currentCrd.Copay_Dollar_Amount__c = existingCRD.Copay_Dollar_Amount__c;
            currentCrd.Cost_Sharing_Amount__c = existingCRD.Cost_Sharing_Amount__c;
            currentCrd.Contract_State__c= existingCRD.Contract_State__c;
            if (currentCrd.Clone_Ben_ID__c == 'Clone Field Value') {
                currentCrd.Custom_Ben_ID__c = existingCRD.Custom_Ben_ID__c;
            } else if (currentCrd.Clone_Ben_ID__c == 'Enter New Field Value') {
                currentCrd.Custom_Ben_ID__c = currentCrd.Ben_ID_New_Value__c;
            }
            currentCrd.DM_Vendor_2_Contract_End_Date__c = existingCRD.DM_Vendor_2_Contract_End_Date__c;
            currentCrd.Custom_call_center_phone_number__c = existingCRD.Custom_call_center_phone_number__c;
            currentCrd.Custom_Network_Flag__c = existingCRD.Custom_Network_Flag__c;
            currentCrd.Custom_Step_Therapy_Date_Approved_ST__c = existingCRD.Custom_Step_Therapy_Date_Approved_ST__c;
            //currentCrd.Custom_TFN__c = existingCRD.Custom_TFN__c;Richa commented for Req - 4887
            currentCrd.Customization_Approved__c = existingCRD.Customization_Approved__c;
            currentCrd.CVS_submits_cost_reporting_to_Aetna__c = existingCRD.CVS_submits_cost_reporting_to_Aetna__c;
            currentCrd.CVS_submits_eligibility_file_to_Aetna__c = existingCRD.CVS_submits_eligibility_file_to_Aetna__c;
            currentCrd.Date_of_Approval_on_SSD__c = existingCRD.Date_of_Approval_on_SSD__c;
            currentCrd.Default_NABP__c = existingCRD.Default_NABP__c;
            currentCrd.Disaster_Emergency__c = existingCRD.Disaster_Emergency__c;
            currentCrd.Discount_Rate__c = existingCRD.Discount_Rate__c;
            currentCrd.Disease_Management_Messaging_for__c = existingCRD.Disease_Management_Messaging_for__c;
            currentCrd.Disease_Management_Referral_Messaging__c = existingCRD.Disease_Management_Referral_Messaging__c;
            currentCrd.Disease_Vendor__c = existingCRD.Disease_Vendor__c;
            currentCrd.Do_Prescription_Savings_Program__c = existingCRD.Do_Prescription_Savings_Program__c;
            currentCrd.Do_you_want_to_do_Precert__c = existingCRD.Do_you_want_to_do_Precert__c;
            currentCrd.Do_you_want_to_do_Save_A_Copay__c = existingCRD.Do_you_want_to_do_Save_A_Copay__c;
            currentCrd.Do_you_want_to_do_Step_Therapy__c = existingCRD.Do_you_want_to_do_Step_Therapy__c;
           // currentCrd.Does_plan_have_an_Open_Enrollment_Date__c = existingCRD.Does_plan_have_an_Open_Enrollment_Date__c;
            currentCrd.Does_the_client_want_to_do_COB__c = existingCRD.Does_the_client_want_to_do_COB__c;
            currentCrd.Dosage_Increase_Change__c = existingCRD.Dosage_Increase_Change__c;
            currentCrd.Dose_Optimization__c = existingCRD.Dose_Optimization__c;
            currentCrd.Drug_List_Option__c = existingCRD.Drug_List_Option__c;
            currentCrd.Duplicate_Therapy__c = existingCRD.Duplicate_Therapy__c;
            currentCrd.Effective_Date__c = existingCRD.Effective_Date__c;
            currentCrd.Effective_Start_Date__c = existingCRD.Effective_Start_Date__c;
            currentCrd.End_Date__c = existingCRD.End_Date__c;
            currentCrd.Enroll_in_RxCheck__c = existingCRD.Enroll_in_RxCheck__c;
            currentCrd.Enrolled_in_PA_for_other_condition__c = existingCRD.Enrolled_in_PA_for_other_condition__c;
            currentCrd.Erisa_Client__c = existingCRD.Erisa_Client__c;
            currentCrd.Expatriate_Employees__c = existingCRD.Expatriate_Employees__c;
            currentCrd.Extra_Care_Health_Card__c = existingCRD.Extra_Care_Health_Card__c;
            currentCrd.Foreign_Claims__c = existingCRD.Foreign_Claims__c;
            //currentCrd.FSA_Integration__c = existingCRD.FSA_Integration__c;--> request no 4874 -- Nitish
            currentCrd.Gaps_in_Care__c = existingCRD.Gaps_in_Care__c;
            currentCrd.Generic_Launch__c = existingCRD.Generic_Launch__c;
            currentCrd.Generic_Uptake__c = existingCRD.Generic_Uptake__c;
            currentCrd.Group_ID__c = existingCRD.Group_ID__c;
            currentCrd.Group_submits_Cost_Reporting__c = existingCRD.Group_submits_Cost_Reporting__c;
            currentCrd.Group_submits_eligibility_file__c = existingCRD.Group_submits_eligibility_file__c;
            //currentCrd.Health_Care_for_Life__c = existingCRD.Health_Care_for_Life__c;  --> Commented By Nitish Request No- 04869
            currentCrd.High_Value_Client__c = existingCRD.High_Value_Client__c;
            currentCrd.Implementation_Type__c = existingCRD.Implementation_Type__c;
           // currentCrd.Implementations_Date__c = existingCRD.Implementations_Date__c;
            //currentCrd.Implementing_for__c=existingCRD.Implementing_for__c;
            currentCrd.In_Network__c = existingCRD.In_Network__c;
            currentCrd.In_Network_claims_are_reimbursed__c = existingCRD.In_Network_claims_are_reimbursed__c;
            currentCrd.In_Network_Reimbursement_Level__c = existingCRD.In_Network_Reimbursement_Level__c;
            currentCrd.Incorrect_Days_Supply__c = existingCRD.Incorrect_Days_Supply__c;
            currentCrd.Incumbent_PBM__c = existingCRD.Incumbent_PBM__c;
            currentCrd.Indian_Facilities__c = existingCRD.Indian_Facilities__c;
            currentCrd.Integrate_with_Medical__c = existingCRD.Integrate_with_Medical__c;
            currentcrd.Waive_Deductible_for_Tier_1_Drugs__c = existingCRD.Waive_Deductible_for_Tier_1_Drugs__c;
            currentCrd.SAC_Override_Option__c = existingCRD.SAC_Override_Option__c;
            currentCrd.Integration_1__c = existingCRD.Integration_1__c;
            currentCrd.Integration_2__c = existingCRD.Integration_2__c;
            currentCrd.Integration_Status__c = existingCRD.Integration_Status__c;
            currentCrd.Is_DM_vendor_the_same_for_each_condition__c = existingCRD.Is_DM_vendor_the_same_for_each_condition__c;
           // currentCrd.IVR_Routing_during_Open_Enrollment__c = existingCRD.IVR_Routing_during_Open_Enrollment__c;
            currentCrd.Mail_Number_of_Tiers__c = existingCRD.Mail_Number_of_Tiers__c;
            currentCrd.Mail_Order_Delay__c = existingCRD.Mail_Order_Delay__c;
            //currentCrd.SAC_Letter_Templates__c = existingCRD.SAC_Letter_Templates__c;
            currentCrd.Mail_Y_Schedule__c = existingCRD.Mail_Y_Schedule__c;
            currentCrd.Manual_Pharmacy_Payments__c = existingCRD.Manual_Pharmacy_Payments__c;
            currentCrd.Maximum_Dollar__c = existingCRD.Maximum_Dollar__c;
            currentCrd.MDL_or_QVT_Limit_Exceptions__c = existingCRD.MDL_or_QVT_Limit_Exceptions__c;
            currentCrd.Medicaid__c = existingCRD.Medicaid__c;
            //currentCrd.Migrane_Management__c = existingCRD.Migrane_Management__c;  --> Commented By Nitish Request No- 04869
            currentCrd.Multiple_Births__c = existingCRD.Multiple_Births__c;
            currentCrd.Name_of_Approver_on_SSD__c = existingCRD.Name_of_Approver_on_SSD__c;
            currentCrd.National__c = existingCRD.National__c;
           // currentCrd.Need_Private_Label_Greeting__c = existingCRD.Need_Private_Label_Greeting__c;
            currentCrd.No_of_Days_to_file_a_claim__c = existingCRD.No_of_Days_to_file_a_claim__c;
            currentCrd.Nursing_Home__c = existingCRD.Nursing_Home__c;
            currentCrd.Nursing_Home_Claims__c = existingCRD.Nursing_Home_Claims__c;
            // currentCrd.of_months_for_Copay_Waiver__c = existingCRD.of_months_for_Copay_Waiver__c;
            currentCrd.Offering_Type__c = existingCRD.Offering_Type__c;
            currentCrd.Offshore__c = existingCRD.Offshore__c;
           // currentCrd.Open_Enrollment_Date__c = existingCRD.Open_Enrollment_Date__c;
            currentCrd.Opt_out_of_Rx_OTC_Edit__c = existingCRD.Opt_out_of_Rx_OTC_Edit__c;
            //Added by ankur for 5486 - starts
            currentCrd.NPL_Applies__c = existingCRD.NPL_Applies__c;
            currentCrd.NPL_Drug_List__c = existingCRD.NPL_Drug_List__c;
            //Added by ankur for 5486 - ends
            currentCrd.Opt_out_of_Safety_Edits__c = existingCRD.Opt_out_of_Safety_Edits__c;
            
            currentCrd.Custom_NPL__c = existingCRD.Custom_NPL__c;
            currentCrd.Ostomy_Supplies__c = existingCRD.Ostomy_Supplies__c;
            currentCrd.Other_Insurance_Paid_in_Error__c = existingCRD.Other_Insurance_Paid_in_Error__c;
            currentCrd.Out_of_Network__c = existingCRD.Out_of_Network__c;
            currentCrd.Out_of_Network_claims_are_reimbused__c = existingCRD.Out_of_Network_claims_are_reimbused__c;
            currentCrd.Out_of_Network_Cost_Sharing__c = existingCRD.Out_of_Network_Cost_Sharing__c;
            currentCrd.Out_of_Network_Reimbursement_Level__c = existingCRD.Out_of_Network_Reimbursement_Level__c;
            currentCrd.Paper_Number_of_Tiers__c = existingCRD.Paper_Number_of_Tiers__c;
            currentCrd.Participant_Lost_Stolen_Damaged_Meds__c = existingCRD.Participant_Lost_Stolen_Damaged_Meds__c;
            currentCrd.Participant_Mail_In_Delay__c = existingCRD.Participant_Mail_In_Delay__c;
            currentCrd.Participate_in_CVS_mail_pharmacy_service__c = existingCRD.Participate_in_CVS_mail_pharmacy_service__c;
            currentCrd.Pharmacy_Advisor__c = existingCRD.Pharmacy_Advisor__c;
            currentCrd.Plan_Coordinate_Benefits__c = existingCRD.Plan_Coordinate_Benefits__c;
            currentCrd.Plan_Extract_Date__c = existingCRD.Plan_Extract_Date__c;
            currentCrd.Plan_Type_Mail__c = existingCRD.Plan_Type_Mail__c;
            currentCrd.Plan_Type_Paper__c = existingCRD.Plan_Type_Paper__c;
            currentCrd.Plan_Type_Retail__c = existingCRD.Plan_Type_Retail__c;
            currentCrd.Plan_Type_Specialty__c = existingCRD.Plan_Type_Specialty__c;
            currentCrd.Platform_Information__c = existingCRD.Platform_Information__c;
           // currentCrd.POS_Dose_Optimization_Drug_List_Id__c = existingCRD.POS_Dose_Optimization_Drug_List_Id__c;--> Commented by nitish dependecy of request no 4870
            currentCrd.POS_Rebate_for_Plan__c = existingCRD.POS_Rebate_for_Plan__c;
            currentCrd.Pre_Implementation_Audit__c = existingCRD.Pre_Implementation_Audit__c;
            currentCrd.Precert_TOC_days__c = existingCRD.Precert_TOC_days__c;
            currentCrd.Prescriber_Network__c = existingCRD.Prescriber_Network__c;
            currentCrd.Pricing_Schedule__c = existingCRD.Pricing_Schedule__c;
            currentCrd.Prior_Authorization_ID__c = existingCRD.Prior_Authorization_ID__c;
            currentCrd.Acquisition_Indicator__c = existingCRD.Acquisition_Indicator__c;
            
            currentCrd.Process_Point_of_Sales_COB__c = existingCRD.Process_Point_of_Sales_COB__c;
            currentCrd.Prorate__c = existingCRD.Prorate__c;
            currentCrd.PSP_Override_Option__c = existingCRD.PSP_Override_Option__c;
            currentCrd.RDS__c = existingCRD.RDS__c;
            currentCrd.RDS_Effective_Date__c = existingCRD.RDS_Effective_Date__c;
            currentCrd.RDS_Termination_Date__c = existingCRD.RDS_Termination_Date__c;
            currentCrd.Reimbursement_Levels__c = existingCRD.Reimbursement_Levels__c;
            currentCrd.Reporting_Frequency__c = existingCRD.Reporting_Frequency__c;
            currentCrd.Retail_Number_of_Tiers__c = existingCRD.Retail_Number_of_Tiers__c;
            currentCrd.Retail_refill_for_Manufacture_Back_Order__c = existingCRD.Retail_refill_for_Manufacture_Back_Order__c;
            currentCrd.Retail_Source_AWP__c = existingCRD.Retail_Source_AWP__c;
            currentCrd.Retail_to_Mail__c = existingCRD.Retail_to_Mail__c;
            currentCrd.Risk_Indicator__c = existingCRD.Risk_Indicator__c;
            currentCrd.RTMD_Admin_Fee_basis__c = existingCRD.RTMD_Admin_Fee_basis__c;
            currentCrd.RTMD_Admin_Fee_rate__c = existingCRD.RTMD_Admin_Fee_rate__c;
            currentCrd.RTMD_Client_Share_Percent__c = existingCRD.RTMD_Client_Share_Percent__c;
            currentCrd.RTMD_Effective_Date__c = existingCRD.RTMD_Effective_Date__c;
            currentCrd.RTMD_Modulator_Percent__c = existingCRD.RTMD_Modulator_Percent__c;
            currentCrd.Rx_Override_Option__c = existingCRD.Rx_Override_Option__c;
            if (currentCrd.Clone_RxPlan_ID__c == 'Clone Field Value') {
                currentCrd.RxPlanID__c = existingCRD.RxPlanID__c;
            } else if (currentCrd.Clone_RxPlan_ID__c == 'Enter New Field Value') {
                currentCrd.RxPlanID__c = currentCrd.RxPlan_ID_New_Value__c;
            }
            currentCrd.Rx_Will_you_be_Picking_Drug_Classes__c = existingCRD.Rx_Will_you_be_Picking_Drug_Classes__c;
            currentCrd.RxPlanData__c = existingCRD.RxPlanData__c;
            currentCrd.RxPlanDataExp__c = existingCRD.RxPlanDataExp__c;
           // currentCrd.Sensitive_Client__c = existingCRD.Sensitive_Client__c;
            currentCrd.Specialty_Exclusion_Flag__c = existingCRD.Specialty_Exclusion_Flag__c;
            currentCrd.Specialty_Number_of_Tiers__c = existingCRD.Specialty_Number_of_Tiers__c;
            currentCrd.Specialty_Retail_Lock_Out__c = existingCRD.Specialty_Retail_Lock_Out__c;
            currentCrd.Specialty_Therapy_Management__c = existingCRD.Specialty_Therapy_Management__c;
            currentCrd.Standard_Precert_List_or_Select_Classes__c = existingCRD.Standard_Precert_List_or_Select_Classes__c;
            currentCrd.Standard_Precert_Program__c = existingCRD.Standard_Precert_Program__c;
            currentCrd.Standard_Program_or_Select_Classes__c = existingCRD.Standard_Program_or_Select_Classes__c;
            currentCrd.Standard_QL_List_or_Select_Classes__c = existingCRD.Standard_QL_List_or_Select_Classes__c;
            currentCrd.Standard_QL_Program__c = existingCRD.Standard_QL_Program__c;
            currentCrd.Standard_Step_Therapy_Program__c = existingCRD.Standard_Step_Therapy_Program__c;
            currentCrd.State_associated_with_this_plan__c = existingCRD.State_associated_with_this_plan__c;
            currentCrd.Step_Therapy_TOC_days__c = existingCRD.Step_Therapy_TOC_days__c;
            currentCrd.PSP_Letter_Templates__c = existingCRD.PSP_Letter_Templates__c;
            currentCrd.Tier_1_Copay_Reduction__c = existingCRD.Tier_1_Copay_Reduction__c;
            currentCrd.Tier_2_Copay_Reduction__c = existingCRD.Tier_2_Copay_Reduction__c;
            currentCrd.Tier_3_Copay_Reduction__c = existingCRD.Tier_3_Copay_Reduction__c;
            currentCrd.Tier_4_Copay_Reduction__c = existingCRD.Tier_4_Copay_Reduction__c;
            currentCrd.Tier_5_Copay_Reduction__c = existingCRD.Tier_5_Copay_Reduction__c;
            currentCrd.Tier_1_Rx_Reduction_Type__c = existingCRD.Tier_1_Rx_Reduction_Type__c;
            currentCrd.Tier_2_Rx_Reduction_Type__c = existingCRD.Tier_2_Rx_Reduction_Type__c;
            currentCrd.Tier_3_Rx_Reduction_Type__c = existingCRD.Tier_3_Rx_Reduction_Type__c;
            currentCrd.Tier_4_Rx_Reduction_Type__c = existingCRD.Tier_4_Rx_Reduction_Type__c;
            currentCrd.Tier_5_Rx_Reduction_Type__c = existingCRD.Tier_5_Rx_Reduction_Type__c;
            currentCrd.Tier_1_Rx_Reduction_Amount__c = existingCRD.Tier_1_Rx_Reduction_Amount__c;
            currentCrd.Tier_2_Rx_Reduction_Amount__c = existingCRD.Tier_2_Rx_Reduction_Amount__c;
            currentCrd.Tier_3_Rx_Reduction_Amount__c = existingCRD.Tier_3_Rx_Reduction_Amount__c;
            currentCrd.Tier_4_Rx_Reduction_Amount__c = existingCRD.Tier_4_Rx_Reduction_Amount__c;
            currentCrd.Tier_5_Rx_Reduction_Amount__c = existingCRD.Tier_5_Rx_Reduction_Amount__c;
            //Richa added below fields for Req 4890
            currentCrd.Does_Chemo_Parity_Apply__c = existingCRD.Does_Chemo_Parity_Apply__c;
            currentCrd.Chemo_Parity_Drug_List__c = existingCRD.Chemo_Parity_Drug_List__c;
            currentCrd.Oral_Chemo_Cap__c = existingCRD.Oral_Chemo_Cap__c;
            currentCrd.Dollar_Amount__c = existingCRD.Dollar_Amount__c;
            currentCrd.Percent__c = existingCRD.Percent__c;
            currentCrd.Copay_Calculation__c = existingCRD.Copay_Calculation__c;
            currentCrd.Chemo_Drugs_Bypass_Deductible__c = existingCRD.Chemo_Drugs_Bypass_Deductible__c;
            currentCrd.Chemo_Drugs_Bypass_MAB__c = existingCRD.Chemo_Drugs_Bypass_MAB__c;
            currentCrd.Chemo_Drugs_Bypass_OOP__c = existingCRD.Chemo_Drugs_Bypass_OOP__c;
            currentCrd.Chemo_Drugs_In_Network_same_as_OON__c = existingCRD.Chemo_Drugs_In_Network_same_as_OON__c;
            //Added by Sushant: Req 05521
            currentCrd.CA_50_Cost_Share_Applies__c= existingCRD.CA_50_Cost_Share_Applies__c;
            
            currentCrd.Tiering__c = existingCRD.Tiering__c;
            currentCrd.Toll_Free_Number__c = existingCRD.Toll_Free_Number__c;
            if (currentCrd.Clone_TPID__c == 'Clone Field Value') {
                currentCrd.TP_ID__c = existingCRD.TP_ID__c;
            } else if (currentCrd.Clone_TPID__c == 'Enter New Field Value') {
                currentCrd.TP_ID__c = currentCrd.TPID_New_Value__c;
            }
            
            if (currentCrd.Clone_Account__c == 'Clone Field Value') {
                currentCrd.Account__c = existingCRD.Account__c;
            } else if (currentCrd.Clone_Account__c == 'Enter New Field Value') {
                currentCrd.Account__c = currentCrd.Account_New_Value__c;
            }            
            
            if (currentCrd.Clone_Owner_PPID__c == 'Clone Field Value') {
                currentCrd.Rx_PP_ID__c = existingCRD.Rx_PP_ID__c;
            } else if (currentCrd.Clone_Owner_PPID__c == 'Enter New Field Value') {
                currentCrd.Rx_PP_ID__c = currentCrd.Owner_PPID_New_Value__c;
            }
            /*if (currentCrd.Clone_Insured_Type__c == 'Clone Field Value') {
currentCrd.Insured_Type__c = existingCRD.Insured_Type__c;

} else if (currentCrd.Clone_Insured_Type__c == 'Enter New Field Value') {
currentCrd.Insured_Type__c = currentCrd.Funding_Type_New_Value__c;
}*/
            currentCrd.Insured_Type__c = existingCRD.Insured_Type__c;
            currentCrd.Plan_Description__c = existingCRD.Plan_Description__c;
            //currentCrd.Account__c = existingCRD.Account__c;
            currentCrd.Plan_Platform__c = existingCRD.Plan_Platform__c;
            currentCrd.Include_Kit_Logic__c = existingCRD.Include_Kit_Logic__c;
            currentCrd.CRD_Risk_Indicator__c = existingCRD.CRD_Risk_Indicator__c;
            //currentCrd.Full_Control_Group__c = existingCRD.Full_Control_Group__c; /* Commented by Amit Jain on 3rd Dec, 2013 as per request */
            currentCrd.Transition_Plan_1_x_override_30DS__c = existingCRD.Transition_Plan_1_x_override_30DS__c;
            currentCrd.Type_of_Cost_Sharing__c = existingCRD.Type_of_Cost_Sharing__c;
            currentCrd.UBOI_ID__c = existingCRD.UBOI_ID__c;
            currentCrd.Vacation__c = existingCRD.Vacation__c;
            currentCrd.Value_Generic__c = existingCRD.Value_Generic__c;
            currentCrd.Vendor_Transition_Files__c = existingCRD.Vendor_Transition_Files__c;
            currentCrd.Veterans_Admin__c = existingCRD.Veterans_Admin__c;
            currentCrd.Which_system_will_the_plan_be_installed__c = existingCRD.Which_system_will_the_plan_be_installed__c;
            currentCrd.Who_processes_PA_or_Override__c = existingCRD.Who_processes_PA_or_Override__c;
            currentCrd.Year__c = existingCRD.Year__c;
            
            currentCrd.ARH_Offering_Type__c = existingCRD.ARH_Offering_Type__c;
            //currentCrd.Hypertension_All_Hypertension_Drugs__c = existingCRD.Hypertension_All_Hypertension_Drugs__c;
            //currentCrd.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c = existingCRD.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c;
            currentCrd.Heart_Failure_Beta_Blockers_ARH__c = existingCRD.Heart_Failure_Beta_Blockers_ARH__c;
            currentCrd.Diabetes_Preventive__c = existingCRD.Diabetes_Preventive__c;
            currentCrd.Asthma_Preventive__c = existingCRD.Asthma_Preventive__c;
            
            //new fields added on 02/02/2012
            currentCrd.Plan_Type_Paper_Out_of_Network__c = existingCRD.Plan_Type_Paper_Out_of_Network__c;
            currentCrd.Different_copays_from_Paper_In_Network__c = existingCRD.Different_copays_from_Paper_In_Network__c;
            currentCrd.Apply_Penalty__c = existingCRD.Apply_Penalty__c;
            currentCrd.Penalty_Type__c = existingCRD.Penalty_Type__c;
            currentCrd.Penalty_Amount__c = existingCRD.Penalty_Amount__c;
            currentCrd.Percentage_Applied__c = existingCRD.Percentage_Applied__c;
            currentCrd.Paper_Out_of_Network_Number_of_Tiers__c = existingCRD.Paper_Out_of_Network_Number_of_Tiers__c;
            currentCrd.Any_drug_specific_Paper_Out_of_Network__c = existingCRD.Any_drug_specific_Paper_Out_of_Network__c;
            currentCrd.Brands_w_DAW_5_take_a_generic_copay__c = existingCRD.Brands_w_DAW_5_take_a_generic_copay__c;
            // new fields added by Rahul Nasa Request No. 1146
            currentCrd.Brands_DAW_5_take_a_gen_copay_Retail__c = existingCRD.Brands_DAW_5_take_a_gen_copay_Retail__c;
            currentCrd.Brands_DAW_5_take_a_gen_copay_Mail__c = existingCRD.Brands_DAW_5_take_a_gen_copay_Mail__c;
            currentCrd.Brands_DAW_5_take_a_gen_copay_Speciality__c = existingCRD.Brands_DAW_5_take_a_gen_copay_Speciality__c;
            currentCrd.Brands_DAW_5_take_a_gen_copay_Paper__c = existingCRD.Brands_DAW_5_take_a_gen_copay_Paper__c; 
            
            
            currentCrd.Aetna_RxHealthy_Outcomes_Drug_Group__c = existingCRD.Aetna_RxHealthy_Outcomes_Drug_Group__c;
            currentCrd.AHA_Drug_Group__c = existingCRD.AHA_Drug_Group__c;
            currentCrd.Custom_Safety_Edits__c = existingCRD.Custom_Safety_Edits__c;
            currentCrd.Standard_Plan_Selection__c = existingCRD.Standard_Plan_Selection__c;
            currentCrd.Tier_1_Rx_Reduction__c = existingCRD.Tier_1_Rx_Reduction__c;
            currentCrd.Tier_2_Rx_Reduction__c = existingCRD.Tier_2_Rx_Reduction__c;
            currentCrd.Tier_3_Rx_Reduction__c = existingCRD.Tier_3_Rx_Reduction__c;
            currentCrd.Tier_4_Rx_Reduction__c = existingCRD.Tier_4_Rx_Reduction__c;
            currentCrd.Tier_5_Rx_Reduction__c = existingCRD.Tier_5_Rx_Reduction__c;
            
            
            
            // new fields added by Rahul Nasa Request No. 1146
            
            currentCrd.Is_there_Paper_Out_of_Network__c = existingCRD.Is_there_Paper_Out_of_Network__c;
            currentCrd.Any_DAW_specific_Paper_OON_copays__c = existingCRD.Any_DAW_specific_Paper_OON_copays__c;
            currentCrd.Quantity_Limit_TOC_of_Days__c = existingCRD.Quantity_Limit_TOC_of_Days__c;
            
            // rakesh Req: 761
            currentCrd.Is_there_Compound_Max_Pay__c = existingCRD.Is_there_Compound_Max_Pay__c;
            currentCrd.Override_Standard_Compound_Max_Pay__c = existingCRD.Override_Standard_Compound_Max_Pay__c;
            currentCrd.Compound_Max_Pay__c = existingCRD.Compound_Max_Pay__c;
            
            //Rishabh Req:868
          //  currentCrd.Is_this_an_HDHP_Plan__c = existingCRD.Is_this_an_HDHP_Plan__c;
          //  currentCrd.What_is_the_HDHP_fund_type__c = existingCRD.What_is_the_HDHP_fund_type__c;
           // currentCrd.Waiver_of_Rx_Deductible__c = existingCRD.Waiver_of_Rx_Deductible__c;
         //   currentCrd.Chronic_Preventive_Drug_List__c = existingCRD.Chronic_Preventive_Drug_List__c;
       //     currentCrd.Chronic_and_or_Preventive_List__c= existingCRD.Chronic_and_or_Preventive_List__c;
            
            //Rishabh Req:927
            currentCrd.PA_Condition_1__c = existingCRD.PA_Condition_1__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_1__c = existingCRD.PA_Custom_Disease_Vendor_Phone_1__c;
            currentCrd.PA_Disease_Vendor_1__c = existingCRD.PA_Disease_Vendor_1__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_1__c= existingCRD.PA_DM_Vendor_Contract_End_Date_1__c;
            currentCrd.PA_Condition_2__c = existingCRD.PA_Condition_2__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_2__c = existingCRD.PA_Custom_Disease_Vendor_Phone_2__c;
            currentCrd.PA_Disease_Vendor_2__c = existingCRD.PA_Disease_Vendor_2__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_2__c= existingCRD.PA_DM_Vendor_Contract_End_Date_2__c;            
            currentCrd.PA_Condition_3__c = existingCRD.PA_Condition_3__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_3__c = existingCRD.PA_Custom_Disease_Vendor_Phone_3__c;
            currentCrd.PA_Disease_Vendor_3__c = existingCRD.PA_Disease_Vendor_3__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_3__c= existingCRD.PA_DM_Vendor_Contract_End_Date_3__c;            
            currentCrd.PA_Condition_4__c = existingCRD.PA_Condition_4__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_4__c = existingCRD.PA_Custom_Disease_Vendor_Phone_4__c;
            currentCrd.PA_Disease_Vendor_4__c = existingCRD.PA_Disease_Vendor_4__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_4__c= existingCRD.PA_DM_Vendor_Contract_End_Date_4__c;            
            currentCrd.PA_Condition_5__c = existingCRD.PA_Condition_5__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_5__c = existingCRD.PA_Custom_Disease_Vendor_Phone_5__c;
            currentCrd.PA_Disease_Vendor_5__c = existingCRD.PA_Disease_Vendor_5__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_5__c= existingCRD.PA_DM_Vendor_Contract_End_Date_5__c;            
            currentCrd.PA_Condition_6__c = existingCRD.PA_Condition_6__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_6__c = existingCRD.PA_Custom_Disease_Vendor_Phone_6__c;
            currentCrd.PA_Disease_Vendor_6__c = existingCRD.PA_Disease_Vendor_6__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_6__c= existingCRD.PA_DM_Vendor_Contract_End_Date_6__c;            
            currentCrd.PA_Condition_7__c = existingCRD.PA_Condition_7__c;
            currentCrd.PA_Custom_Disease_Vendor_Phone_7__c = existingCRD.PA_Custom_Disease_Vendor_Phone_7__c;
            currentCrd.PA_Disease_Vendor_7__c = existingCRD.PA_Disease_Vendor_7__c;
            currentCrd.PA_DM_Vendor_Contract_End_Date_7__c= existingCRD.PA_DM_Vendor_Contract_End_Date_7__c;
            
            //Sushant Req:885
            currentCrd.Enroll_in_Aetna_Ways_to_Save__c= existingCRD.Enroll_in_Aetna_Ways_to_Save__c;
            currentCrd.Mail_Request_Date__c= existingCRD.Mail_Request_Date__c;
            currentCrd.Requested_mailing_received_on__c= existingCRD.Requested_mailing_received_on__c;
            currentCrd.Target_Generic_Opportunities__c= existingCRD.Target_Generic_Opportunities__c;
            currentCrd.Target_Formulary_Brand_Opportunities__c= existingCRD.Target_Formulary_Brand_Opportunities__c;
            currentCrd.Target_Pref_Manufacturer_Brand_Opportun__c= existingCRD.Target_Pref_Manufacturer_Brand_Opportun__c;
            currentCrd.Target_Participants_18_years_and_older__c= existingCRD.Target_Participants_18_years_and_older__c;
            currentCrd.Preferred_Manufacturer_Brands_Code__c= existingCRD.Preferred_Manufacturer_Brands_Code__c;
            currentCrd.If_Not_18_Indicate_Age__c= existingCRD.If_Not_18_Indicate_Age__c;
            currentCrd.Member_Letter_Selection__c= existingCRD.Member_Letter_Selection__c;
            currentCrd.Minimum_Member_Savings_Projection__c= existingCRD.Minimum_Member_Savings_Projection__c;
            currentCrd.Introductory_Paragraph_to_Include__c= existingCRD.Introductory_Paragraph_to_Include__c;
            
            // Sushant Req: 01094
            currentCrd.Medical_Injectible_Claim_Denial_Process__c= existingCRD.Medical_Injectible_Claim_Denial_Process__c;
            
            // Sushant Req: 01159
            currentCrd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c= existingCRD.OON_Cost_Share_Not_Greater_50_Drug_Cost__c;
            
            // Joognu Rao For Requirement No :04288
            currentCrd.Aetna_RxStep__c = existingCRD.Aetna_RxStep__c;
            
            // Added by JR to implement request no 4525         
            currentCrd.Mac_at_Mail_Applies__c = existingCRD.Mac_at_Mail_Applies__c;
            
            
            // Sushant Req: 04366(Prod.)  
            currentCrd.Any_DAW_specific_Specialty_OON_copays__c= existingCRD.Any_DAW_specific_Specialty_OON_copays__c;
            currentCrd.Any_drug_specific_Specialty_OON_copays__c= existingCRD.Any_drug_specific_Specialty_OON_copays__c;
            currentCrd.Apply_Penalty_to_Specialty_OON__c= existingCRD.Apply_Penalty_to_Specialty_OON__c;
            currentCrd.Brands_w_DAW_5_take_a_generic_copay_spec__c= existingCRD.Brands_w_DAW_5_take_a_generic_copay_spec__c;
            currentCrd.Different_Copays_from_Specialty__c= existingCRD.Different_Copays_from_Specialty__c;
            currentCrd.Is_there_Specialty_Out_of_Network__c= existingCRD.Is_there_Specialty_Out_of_Network__c;
            currentCrd.Penalty_Amount_Specialty_OON__c= existingCRD.Penalty_Amount_Specialty_OON__c;
            currentCrd.Penalty_Type_Specialty_OON__c= existingCRD.Penalty_Type_Specialty_OON__c;
            currentCrd.Percentage_Applied_Specialty_OON__c= existingCRD.Percentage_Applied_Specialty_OON__c;
            currentCrd.Plan_Type_Specialty_OON__c= existingCRD.Plan_Type_Specialty_OON__c;
            currentCrd.Specialty_OON_Number_of_Tiers__c= existingCRD.Specialty_OON_Number_of_Tiers__c;        
            //Added for PERS Mass Change by Amit Jain on 26May '14                         
            if(currentCrd.CreatedByPersMassChange__c != Null){
                System.debug('###########################');
                if(existingCRD.STANDARD_OR_CUSTOM_PLAN__C == 'Creating a package plan'){
                    currentCrd.STANDARD_OR_CUSTOM_PLAN__C = 'Cloning a package plan from existing CRD';
                } else if(existingCRD.STANDARD_OR_CUSTOM_PLAN__C == 'Creating a packaged consumer business plan'){
                    currentCrd.STANDARD_OR_CUSTOM_PLAN__C = 'Cloning a packaged consumer business plan from an existing CRD';  // Implemented Request 05947                         
                } else if(existingCRD.STANDARD_OR_CUSTOM_PLAN__C == 'Creating a custom plan'){
                    currentCrd.STANDARD_OR_CUSTOM_PLAN__C = 'Cloning a custom plan from existing CRD';
                } else if(existingCRD.STANDARD_OR_CUSTOM_PLAN__C == 'Creating a HIX plan'){
                    currentCrd.STANDARD_OR_CUSTOM_PLAN__C = 'Cloning a HIX plan from existing CRD';
                } else{
                    currentCrd.STANDARD_OR_CUSTOM_PLAN__C = existingCRD.STANDARD_OR_CUSTOM_PLAN__C;
                    System.debug('###########################');
                }
                currentCrd.Clone_from_which_CRD__c = existingCRD.ID;
                currentCrd.Clone_TPID__c = 'Do Not Clone Value';
                currentCrd.Clone_Owner_PPID__c = 'Do Not Clone Value';
                currentCrd.Clone_Ben_ID__c = 'Do Not Clone Value';
                currentCrd.Clone_Account__c = 'Clone Field Value'; 
                currentCrd.Account__c = existingCRD.Account__c;         
            }  //**ends
            newCRDId = currentCrd.id;
            database.update (currentCrd);
            
            //for pers mass change do not remove below code
            if(IsFrombatch){           
                clonCSAPCGLPJunction(newCRDId);
            }
            //for pers mass change do not remove above code
            
            cloneCopay(newCRDId);
            cloneDrugSpecificCopay(newCRDId);
            cloneAccumulations(newCRDId);
            cloneDrugCoverage(newCRDId);
            cloneRxCheck(newCRDId);
            //cloneCvsWebUsers(newCRDId); Commented By Sushant : Req 04937
            cloneNetworkJunction(newCRDId);
            cloneSaveACopayJunction(newCRDId);
            clonePSPJunction(newCRDId);
            cloneCrStepTherepyJunction(newCRDId);
            clonePOStepTherepyJunction(newCRDId);
            cloneQlStepTherepyJunction(newCRDId);
            clonClinicalProgrameGroupJunction(newCRDId);
            cloneDawCopay(newCRDId);
            cloneAHAJunction(newCRDId);
            cloneSSEJunction(newCRDId);
            cloneRXOJunction(newCRDId);
            //cloneMOOPBypass(newCRDId); Commented By Sushant : Req 04937
            cloneRxStepJunction(newCRDId);
            cloneWOD(newCRDId);
            cloneNPL(newCRDId);            
        } catch (Exception e) {
            if (IsFrombatch == true && currentCrd.CreatedByPersMassChange__c == Null) {
                //There can be multiple Batch Logger Records associated with same CRD.
                List<Batch_Logger__c> loggerrecord = new List<Batch_Logger__c>();
                loggerrecord = [Select Id,Has_error__c,Ready_For_AI__c, Description__c from Batch_Logger__c where Crd__c=: existingCRD.id];
                for(Batch_Logger__c bl : loggerrecord ){
                    bl.Ready_For_AI__c = false;
                    bl.Description__c='Error from Clone Class: '+e.getmessage();
                    bl.Has_error__c=true;
                }
                database.update (loggerrecord);
            } else {                
                throw e;               
            }
        }
    }
    
    /**
* Method :- cloneCopay
* Description :- Method to Start the cloning for Copay
**/    
    public void cloneCopay(id newCrdId) {
        
        list < Copay_Tier__c > newCopayitems = new list < Copay_Tier__c > ();
        list < Copay_Tier__c > existingCopayitems = new list < Copay_Tier__c > ([Select Tier__c, Tier_Type__c, Tier_Name__c, Stepped_Copay__c, SteppedCopayCount__c,
                                                                                 Reverse_Copay__c, RecordTypeId, Percent__c, Number_Of_Steps__c, Name,
                                                                                 Min_Dollar__c, Max_Dollar__c, Id, Dollar_Amount__c, Copay_Calc__c, ConnectionSentId,
                                                                                 ConnectionReceivedId, CRD__c, Days_Per_Fill__c 
                                                                                 From Copay_Tier__c 
                                                                                 where CRD__c = : crdid]);
        list < SteppedCopay__c > lstOldSteppedCopay = new list < SteppedCopay__c > ([Select Tier_Type__c, Stepped_CoPay_Types__c, Percent_Amount__c, Number_of_Ranges__c,
                                                                                     Reverse__c,Name, Min_Range__c, Min_Dollar__c, Max_Range__c, Max_Dollar__c,
                                                                                     Dollar_Amount__c, Copay_Tier__c, Copay_Calc__c, ConnectionSentId, ConnectionReceivedId
                                                                                     From SteppedCopay__c 
                                                                                     where Copay_Tier__c in : existingCopayitems]);
        list < SteppedCopay__c > lstNewSteppeditems = new list < SteppedCopay__c > ();
        
        try{
            for (Copay_Tier__c tierItem: existingCopayitems) {
                Copay_Tier__c newTierItem = tierItem.clone(false);
                newTierItem.CRD__c = newCRDId;
                newCopayitems.add(newTierItem);
            }
            if (newCopayitems != null && newCopayitems.size() > 0) {
                database.insert (newCopayitems);
            }
            
            //We create a map of old and new copay items
            for (Copay_Tier__c newcopay: newCopayitems) {
                for (Copay_Tier__c oldcopay: existingCopayitems) {
                    if (newcopay.Tier_Name__c == oldcopay.Tier_Name__c) {
                        oldnewCopayMap.put(oldcopay.Id, newcopay.Id);
                    }
                }
            }
            
            //Cloning the Stepped copay
            for (SteppedCopay__c steppedItem: lstOldSteppedCopay) {
                SteppedCopay__c newSteppedItem = steppedItem.clone(false);
                newSteppedItem.Copay_Tier__c = oldnewCopayMap.get(steppedItem.Copay_Tier__c);
                lstNewSteppeditems.add(newSteppedItem);
            }
            if (lstNewSteppeditems != null && lstNewSteppeditems.size() > 0) {
                database.insert (lstNewSteppeditems);
            }
            oldnewCopayMap.clear();
        }catch(Exception e){throw e;}
    }
    /**
* Method :- cloneDrugSpecificCopay
* Description :- Method to Start the cloning for Drug Specific Copay
**/    
    public void cloneDrugSpecificCopay(id newCrdId) {
        list < Drug_Specific_Copay__c > newDrugSpecificCopays = new list < Drug_Specific_Copay__c > ();
        list < Drug_Specific_Copay__c > existingDrugSpecificCopays = new list < Drug_Specific_Copay__c > ([Select TierNo__c, TierName__c, Stepped_Copay__c, SteppedCopayCount__c,
                                                                                                           Reverse_Copay__c,RecordTypeId, Percent__c, Name, Minimum_Dollar__c,
                                                                                                           Maximum_Dollar__c, Id, Drug_List__c, Drug_Group__c, Dollar_Amount__c,
                                                                                                           Copay_Calculation__c, ConnectionSentId, ConnectionReceivedId, CRD_ID__c,
                                                                                                           M__c, N__c, O__c, Y__c
                                                                                                           From Drug_Specific_Copay__c where CRD_ID__c = : crdid]);
        list < Drug_Specific_Stepped_Copay__c > lstOldDrugSpecificSteppedCopays = new list < Drug_Specific_Stepped_Copay__c > ([Select Stepped_CoPay_Type__c, Related_Drug_Group_List__c,
                                                                                                                                Percent__c, Number_of_Steps__c, Name, Minimum_Dollar__c,
                                                                                                                                Maximum_Dollar__c, Id, End_Range__c, Drug_Specific_Copay_ID__c,
                                                                                                                                Dollar_Amount__c, Copay_Calculation__c, ConnectionSentId,
                                                                                                                                ConnectionReceivedId, CRD_ID__c, Beginning_Range__c
                                                                                                                                From Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c in : existingDrugSpecificCopays]);
        list < Drug_Specific_Stepped_Copay__c > lstNewDrugSpecificSteppedCopays = new list < Drug_Specific_Stepped_Copay__c > ();
        
        try{
            for (Drug_Specific_Copay__c tierItem: existingDrugSpecificCopays) {
                Drug_Specific_Copay__c newTierItem = tierItem.clone(false);
                newTierItem.CRD_ID__c = newCRDId;
                newDrugSpecificCopays.add(newTierItem);
            }
            if (newDrugSpecificCopays != null && newDrugSpecificCopays.size() > 0) {
                database.insert (newDrugSpecificCopays);
            }
            
            //We create a map of old and new copay items
            for (Drug_Specific_Copay__c newcopay: newDrugSpecificCopays) {
                for (Drug_Specific_Copay__c oldcopay: existingDrugSpecificCopays) {
                    if (newcopay.TierName__c == oldcopay.TierName__c) {
                        oldnewCopayMap.put(oldcopay.Id, newcopay.Id);
                    }
                }
            }
            
            //Cloning the Stepped copay
            for (Drug_Specific_Stepped_Copay__c steppedItem: lstOldDrugSpecificSteppedCopays) {
                Drug_Specific_Stepped_Copay__c newSteppedItem = steppedItem.clone(false);
                newSteppedItem.Drug_Specific_Copay_ID__c = oldnewCopayMap.get(steppedItem.Drug_Specific_Copay_ID__c);
                lstNewDrugSpecificSteppedCopays.add(newSteppedItem);
            }
            if (lstNewDrugSpecificSteppedCopays != null && lstNewDrugSpecificSteppedCopays.size() > 0) {
                database.insert (lstNewDrugSpecificSteppedCopays);
            }
            oldnewCopayMap.clear();
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneDawCopay
* Description :- Functon to clone Daw specific Copays
**/    
    public void cloneDawCopay(id newCrdId) {
        list < DAW_Specific_Copay__c > newDawSpecificCopays = new list < DAW_Specific_Copay__c > ();
        list < DAW_Specific_Stepped_Copay__c > lstNewDawSpecificSteppedCopays = new list < DAW_Specific_Stepped_Copay__c > ();
        
        list < DAW_Specific_Copay__c > existingDawSpecificCopays = new list < DAW_Specific_Copay__c > ([Select Stepped__c, SteppedCopayCount__c,
                                                                                                        Reverse__c, RecordTypeId, Percent__c, /* Penalty__c,*/ Name,
                                                                                                        Minimum_Dollar__c, Maximum_Dollar__c, MS_Code_Y__c,
                                                                                                        MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Id,
                                                                                                        Dollar_Amount__c, DAW_Code__c, Copay_Calculation__c,
                                                                                                        CRD_ID__c
                                                                                                        From DAW_Specific_Copay__c where CRD_ID__c = : crdid ]);
        list < DAW_Specific_Stepped_Copay__c > lstOldDawSpecificSteppedCopays = new list < DAW_Specific_Stepped_Copay__c > ([Select Stepped_CoPay_Type__c,Reverse__c, 
                                                                                                                             Percent__c, Number_of_Steps__c,
                                                                                                                             Name, Minimum_Dollar__c, Maximum_Dollar__c,
                                                                                                                             Id, End_Range__c, Dollar_Amount__c,
                                                                                                                             DAW_Specific_Copay_ID__c, Copay_Calculation__c,
                                                                                                                             CRD_ID__c, Beginning_Range__c 
                                                                                                                             From DAW_Specific_Stepped_Copay__c
                                                                                                                             where CRD_ID__c = : Concatinated15DigitCRDID]);
        try{                                        
            for (DAW_Specific_Copay__c tierItem: existingDawSpecificCopays) {
                DAW_Specific_Copay__c newTierItem = tierItem.clone(false);
                newTierItem.CRD_ID__c = newCRDId;
                newTierItem.Cloned_From__c = tierItem.id;
                newDawSpecificCopays.add(newTierItem);
            }
            
            if (newDawSpecificCopays != null && newDawSpecificCopays.size() > 0) {
                database.insert (newDawSpecificCopays);
            }
            
            //We create a map of old and new copay items
            for (DAW_Specific_Copay__c newcopay: newDawSpecificCopays) {
                for (DAW_Specific_Copay__c oldcopay: existingDawSpecificCopays) {
                    if (newcopay.Cloned_From__c == oldcopay.id) {
                        oldnewCopayMap.put(oldcopay.Id, newcopay.Id);
                    }
                }
            }
            
            //Cloning the Stepped copay
            for (DAW_Specific_Stepped_Copay__c steppedItem: lstOldDawSpecificSteppedCopays) {
                DAW_Specific_Stepped_Copay__c newSteppedItem = steppedItem.clone(false);
                newSteppedItem.DAW_Specific_Copay_ID__c = oldnewCopayMap.get(steppedItem.DAW_Specific_Copay_ID__c);
                lstNewDawSpecificSteppedCopays.add(newSteppedItem);
            }
            
            if (lstNewDawSpecificSteppedCopays != null && lstNewDawSpecificSteppedCopays.size() > 0) {
                database.insert (lstNewDawSpecificSteppedCopays);
            }
            oldnewCopayMap.clear();
        }catch(Exception e){throw e;}
        
    }
    
     /** Commented By Sushant : Req 04937
* Method :- cloneMOOPBypass
* Description :- Method to Start the cloning for MOOPBypass

    Map < Id, Id > oldnewMOOPMap= new Map < Id, Id > ();
    public void cloneMOOPBypass(id newCRDId) {
        list <MOOP_Bypass__c> existingMOOPBypass = new list<Moop_Bypass__c> ([SELECT CRD_ID__c,MOOP_Bypass_Drug_Group__c, MOOP_Bypass_Drug_Group_Name__c,
                                                                              MOOP_Bypass_Drug_List__c, MOOP_Bypass_Drug_List_Name__c, MOOP_Bypass_Type__c
                                                                              From MOOP_Bypass__c 
                                                                              where CRD_ID__c = : crdid]);
        list< MOOP_Bypass__c > newMOOPBypass = new list<MOOP_Bypass__c> ();
        
        try{
            for(Moop_Bypass__c MOOP:existingMOOPBypass){
                MOOP_Bypass__c newMOOP = MOOP.clone(false);
                newMOOP.CRD_ID__c = newCRDID;
                newMOOPBypass.add(newMOOP);
            }
            if (newMOOPBypass!= null && newMOOPBypass.size() > 0) {
                database.insert (newMOOPBypass);
            }
            for (MOOP_Bypass__c newMOOP: newMOOPBypass) {
                for (MOOP_Bypass__c oldMOOP: existingMOOPBypass) {
                    if (newMOOP.MOOP_Bypass_Type__c== oldMOOP.MOOP_Bypass_Type__c) {
                        oldnewMOOPMap.put(oldMOOP.Id, newMOOP.Id);
                    }
                }
            }
            oldnewMOOPMap.clear();
        }catch(Exception e){throw e;}
    }
    
    **/ 
/**
* Method :- cloneAccumulations
* Description :- Method to Start the cloning for Accumulations
**/ 
    public void cloneAccumulations(id newCRDId) {
        list < Accumulations__c > existingAccumulations = new list < Accumulations__c > ([Select Accum_Name__c, What_happens_when_MOOP_is_met__c, Start_Month_New__c,
                                                                                          Start_Day__c, What_happens_when_the_MAB_is_met__c, Start_Month__c,
                                                                                          RecordTypeId, DAW_Differential_Penalty_Applies_to_MOOP__c,
                                                                                          Family_Members_to_meet_Family_Deduct__c, Noof_Family_Members_to_Meet_Family_MOOP__c,
                                                                                          Name, MOOP_Period__c, MOOP_Dedictible_Amount__c, MAB_Period__c,
                                                                                          MAB_Dedictible_Amount__c, Id, Deuductible_Accumulation_from_4th_Qtr__c,
                                                                                          Deductible_Period__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Amount__c,
                                                                                          CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId,
                                                                                          When_will_the_Accumulations_renew__c,Carry_Balance_when_member_moves__c,CRD_Name__c,
                                                                                          CRD_ID__c, Are_there_any_drug_specific_deductibles__c, Are_there_any_drug_specific_MAB__c,
                                                                                          Are_there_any_drug_specifc_MOOP__c, Accum_Code_Deductible__c,
                                                                                          Accum_Code_Maximum_Allowable_Benefit__c, Accum_Code_Maximum_Out_Of_Pocket__c,Accumulation_end_date__c,
                                                                                          /* commented by JR to implemented 4771
Deductible_Brand_Drugs_Generics__c, Deductible_Brand_Drugs_no_Generics__c,
Deductible_Generic_Drugs__c, Deductible_In_Network__c, Deductible_Maintenance_Drugs__c,
Deductible_Out_of_Network__c,*/ Is_there_a_Maximum_Allowable_Benefit__c,
                                                                                          Is_there_a_Maximum_Out_of_Pocket__c, MAB_Brand_Drugs_Generics__c,
                                                                                          MAB_Brand_Drugs_no_Generics__c, MAB_Generic_Drugs__c, MAB_In_Network__c,
                                                                                          Do_not_apply_flat_fee_to_OOP__c,Do_not_apply_penalty_to_OOP__c, MAB_Maintenance_Drugs__c,
                                                                                          MAB_Out_of_Network__c, MOOP_Brand_Drugs_Generics__c, MOOP_Brand_Drugs_no_Generics__c,
                                                                                          MOOP_Generic_Drugs__c, MOOP_In_Network__c, MOOP_Maintenance_Drugs__c, MOOP_Out_of_Network__c,
                                                                                          What_is_the_In_Network_MOOP_Amount__c,What_is_the_In_Network_Deductible_Amount__c,
                                                                                          What_is_the_OON_Deductible_Amount__c,What_is_the_OON_MOOP_Amount__c,Cross_Accumulation__c
                                                                                          From Accumulations__c
                                                                                          where CRD_ID__c = : crdid]);
        
        list < Accumulations__c > newAccumulations = new list < Accumulations__c > ();
        list < AccumulationSpecificDrug__c > existingAccumulationsSpecificDrugs = new list < AccumulationSpecificDrug__c > ([Select What_happens_when_MAB_is_met__c, RecordTypeId, DAW_Differential_Penalty_Applies_to_MOOP__c,
                                                                                                                             /*Noof_Family_Members_to_Meet_Maximum_MOOP__c,Family_Members_to_meet_Family_Deduct__c,*/Name,
                                                                                                                             MOOP_Period__c, MOOP_Dedictible_Amount__c, MAB_Period__c, MAB_Dedictible_Amount__c, Id,
                                                                                                                             Drug_List__c, Drug_Group__c,M__c,N__c,O__c,Y__c, Deuductible_Accumulation_from_4th_Qtr__c,
                                                                                                                             Deductible_Period__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Amount__c,
                                                                                                                             ConnectionSentId, ConnectionReceivedId, CRD_ID__c, Accumulatoins_Type__c, Accumulations_ID__c,
                                                                                                                             What_happens_when_MOOP_is_met__c, Pay_the_DAW_difference_after_deductible__c,Exclude_from_Accumulation__c
                                                                                                                             From AccumulationSpecificDrug__c 
                                                                                                                             where Accumulations_ID__c in : existingAccumulations]);
        list < AccumulationSpecificDrug__c > newAccumulationsSpecificDrugs = new list < AccumulationSpecificDrug__c > ();
        
        try{
            for (Accumulations__c accum: existingAccumulations) {
                Accumulations__c newAccum = accum.clone(false);
                newAccum.CRD_ID__c = newCRDId;
                newAccumulations.add(newAccum);
            }
            
            if (newAccumulations != null && newAccumulations.size() > 0) {
                database.insert (newAccumulations);
            }
            
            //We create a map of old and new Accumalations items
            for (Accumulations__c newAccum: newAccumulations) {
                for (Accumulations__c oldAccum: existingAccumulations) {
                    if (newAccum.Accum_Name__c == oldAccum.Accum_Name__c) {
                        oldnewCopayMap.put(oldAccum.Id, newAccum.Id);
                    }
                }
            }
            //Cloning the Drug Specific Accumulation
            for (AccumulationSpecificDrug__c accumItem: existingAccumulationsSpecificDrugs) {
                AccumulationSpecificDrug__c newAccumSpecificItem = accumItem.clone(false);
                newAccumSpecificItem.Accumulations_ID__c = oldnewCopayMap.get(accumItem.Accumulations_ID__c);
                newAccumulationsSpecificDrugs.add(newAccumSpecificItem);
            }
            if (newAccumulationsSpecificDrugs != null && newAccumulationsSpecificDrugs.size() > 0) {
                database.insert (newAccumulationsSpecificDrugs);
            }
            
            // Clone Accumulation Change Copay
            List < Accumulation_Change_Copay__c > accList = [SELECT Name, RecordTypeId, Accumulation_ID__c, Copay_Calculation__c, DAW_Code__c,
                                                             Dollar_Amount__c, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c,
                                                             MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Percent__c, Reverse__c, Stepped__c
                                                             FROM Accumulation_Change_Copay__c
                                                             WHERE Accumulation_ID__c = : existingAccumulations];
            
            List < Accumulation_Change_Copay__c > newAccumChangeCopayList = new List < Accumulation_Change_Copay__c > ();
            for (Accumulation_Change_Copay__c accumChangeCopay: accList) {
                Accumulation_Change_Copay__c newAccumChangeCopay = accumChangeCopay.clone(false);
                newAccumChangeCopay.Accumulation_ID__c = oldnewCopayMap.get(accumChangeCopay.Accumulation_ID__c);
                newAccumChangeCopayList.add(newAccumChangeCopay);
            }
            
            if (newAccumChangeCopayList != null && newAccumChangeCopayList.size() > 0){
                database.insert (newAccumChangeCopayList);
            }
            
            
            // Clone Accumulation_Change_Copay_Stepped__c
            Map < Id, Id > oldNewAccChangeCopayMap = new Map < Id, Id > ();
            for (Accumulation_Change_Copay__c accOld: accList) {
                for (Accumulation_Change_Copay__c accNew: newAccumChangeCopayList) {
                    if (accOld.Copay_Calculation__c == accNew.Copay_Calculation__c && accOld.DAW_Code__c == accNew.DAW_Code__c && accOld.Dollar_Amount__c == accNew.Dollar_Amount__c && accOld.Maximum_Dollar__c == accNew.Maximum_Dollar__c && accOld.Minimum_Dollar__c == accNew.Minimum_Dollar__c && accOld.MS_Code_M__c == accNew.MS_Code_M__c && accOld.MS_Code_N__c == accNew.MS_Code_N__c && accOld.MS_Code_O__c == accNew.MS_Code_O__c && accOld.MS_Code_Y__c == accNew.MS_Code_Y__c && accOld.Percent__c == accNew.Percent__c && accOld.Reverse__c == accNew.Reverse__c && accOld.Stepped__c == accNew.Stepped__c) {
                        oldNewAccChangeCopayMap.put(accOld.Id, accNew.Id);
                    }
                }
            }
            
            Set < Id > accumulationIdSet = new Set < Id > ();
            for (Accumulation_Change_Copay__c accum: accList)
                accumulationIdSet.add(accum.Id);
            
            List < Accumulation_Change_Copay_Stepped__c > accsList = [SELECT Name, Accumulation_Change_Copay_ID__c, Beginning_Range__c,
                                                                      Copay_Calculation__c, CRD_ID__c, Dollar_Amount__c, End_Range__c,
                                                                      Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c,
                                                                      Percent__c, Reverse__c, Type_of_Stepped_Copay__c
                                                                      FROM Accumulation_Change_Copay_Stepped__c
                                                                      WHERE Accumulation_Change_Copay_ID__c in : accumulationIdSet];
            
            List < Accumulation_Change_Copay_Stepped__c > newAccumChangeCopaySteppedList = new List < Accumulation_Change_Copay_Stepped__c > ();
            for (Accumulation_Change_Copay_Stepped__c accumChangeCopayStepped: accsList) {
                Accumulation_Change_Copay_Stepped__c newAccumChangeCopayStepped = accumChangeCopayStepped.clone(false);
                newAccumChangeCopayStepped.Accumulation_Change_Copay_ID__c = oldNewAccChangeCopayMap.get(accumChangeCopayStepped.Accumulation_Change_Copay_ID__c);
                newAccumChangeCopaySteppedList.add(newAccumChangeCopayStepped);
            }
            
            if (newAccumChangeCopaySteppedList != null && newAccumChangeCopaySteppedList.size() > 0){
                database.insert (newAccumChangeCopaySteppedList);
            }
            
            oldnewCopayMap.clear();
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneDrugCoverage
* Description :- Method to Start the cloning for DrugCoverage
**/    
    public void cloneDrugCoverage(id newCRDId) {
        
        list < Drug_Coverage__c > lstExistingDrugCoverage = new list < Drug_Coverage__c > ([Select of_fills_before_force_to_specialty__c, Allow_Transition_Fill__c,Transition_Fill_Number_of_Days__c,
                                                                                            fills_before_MMO_option_is_invoked__c, Retail_Refill_Allowance_No_of_days__c,
                                                                                            /*RSO_Drug_List__c,*/Secondary_of_Fills_before_Force_to_MOD__c,No_of_fills_allowed_at_retail__c, Do_you_have_Specialty__c, Aetna_Specialty_Care_Rx__c,
                                                                                            Max_Specialty_Day_Supply__c,
                                                                                            Secondary_of_fills_before_force_to_SPN__c,
                                                                                            Secondary_Aetna_Specialty_Care_Rx__c,
                                                                                            Secondary_Force_to_Specialty__c,
                                                                                            /*Secondary_RRA_Drug_List__c,
Secondary_RSO_Drug_List__c,*/
                                                                                            Secondary_Speciality_Drug_List__c,
                                                                                            /* X3rd_Party_Exceptions__c,*/ What_is_the_Penalty__c, What_Option__c, Use_Standard_MMOD_VMOD_Drug_List__c,
                                                                                            Standard_Refill_too_Soon__c, Choose_Generic_Copay_Diff_Exclusion__c, Speciality_Drug_List__c,
                                                                                            Smoking_Cessation_Aids__c, Rule_for_supply_quantity__c,/*Refill_Limits__c,*/ RecordTypeId, Period_Type__c,
                                                                                            /*Packaging_Exceptions__c,OTC__c,*/ Nutritional_Dietary_Supplies_PKU__c, Number_of_Periods__c, Norplan__c,
                                                                                            Name, /*Multi_Ingredient_Compounds__c,*/ Minimum_quantity__c, Minimum_days_supply__c, 
                                                                                            Maximum_quantity__c, Maximum_days_supply__c, /*Max_Day_Supply__c,*/ Mandatory_Mail_Order_Option__c,
                                                                                            /*Maintenance_Form__c,*/ Maintenance_Choice__c, Mailing_Options__c, Lookback_Period__c,Id,
                                                                                            Grandfathering_for__c, Formulary__c, Formulary_Open_Closed__c, Force_to_Specialty__c,
                                                                                            /*FDA_Therapeutic_Equivalent__c, FDA_Therapeutic_Category__c,*/ Exception_Drug_List__c, Exception_Drug_Group__c,
                                                                                            /*Dosage_Form__c, Dollar_Amount__c,*/ Do_you_have_Choose_Generic__c, /*DUR__c, DUR_Message_Type__c, DESI__c,
DEA__c,*/ Custom_Refill_too_Soon__c, Custom_NDC_GPI_List__c, Custom_NDC_GPI_List_ID__c,
                                                                                            Custom_MMOD_VMOD_Drug_List__c, Cost_Type__c, Cost_Amount__c, /*Copay_Based_On__c,*/ ConnectionSentId,
                                                                                            ConnectionReceivedId, Compounds_with_1_Federal_Legend_Drug__c, Co_Insurance_Percentage__c,
                                                                                            Co_Insurance_Dollar_Amount__c,CRD_ID__c, /*Brand_Generic__c,*/ Apply_difference_of_cost__c,
                                                                                            Use_Medispan_Indicator__c, Brand_Penalty_Based_Retail_Mail_AWP__c, Brand_Penalty_Dollar_Amount__c,
                                                                                            Brand_Penalty_Maximum_Dollar__c, Brand_Penalty_Minimum_Dollar__c, Brand_Penalty_Percent__c,
                                                                                            Brand_Penalty_Type__c, Generic_Penalty_Dollar_Amount__c, Generic_Penalty_Maximum_Dollar__c,
                                                                                            Generic_Penalty_Minimum_Dollar__c, Generic_Penalty_Percent__c, Generic_Penalty_Type__c,
                                                                                            Gen_Penalty_Based_Retail_Mail_AWP__c, Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c,
                                                                                            Non_Pref_Brand_Penalty_Dollar_Amount__c, Non_Pref_Brand_Penalty_Maximum_Dollar__c,Does_Dose_Limit_apply__c,
                                                                                            Dose_Limit__c,Higher_Lower_than__c,Dose_Limit_Exception_Drug_List__c,
                                                                                            Non_Pref_Brand_Penalty_Minimum_Dollar__c, Non_Pref_Brand_Penalty_Percent__c, Non_Pref_Brand_Penalty_Type__c,
                                                                                            Days_Per_Fill__c, Incentivized_Mail_Brand_Penalty_Amount__c, Incentivized_Mail_Brand_Penalty_Type__c,
                                                                                            Incentivized_Mail_Generic_Penalty_Amount__c, Incentivized_Mail_Generic_Penalty_Type__c,
                                                                                            Incent_Mail_NonPref_Brand_Penalty_Amount__c, Incent_Mail_NonPref_Brand_Penalty_Type__c, Restart_Fills__c,
                                                                                            Incent_Mail_Gen_Penalty_Percent__c,Incent_Mail_Gen_Penalty_Min__c,Incent_Mail_Gen_Penalty_Max__c,
                                                                                            Incent_Mail_Brand_Penalty_Percent__c,Incent_Mail_Brand_Penalty_Min__c,Incent_Mail_Brand_Penalty_Max__c,
                                                                                            Incent_Mail_NP_Brand_Penalty_Percent__c,Incent_Mail_NP_Brand_Penalty_Min__c,Incent_Mail_NP_Brand_Penalty_Max__c,Number_of_fills__c 
                                                                                            From Drug_Coverage__c 
                                                                                            where CRD_ID__c = : crdid]);
        map < id, Drug_Coverage__c > lstNewDrugCoverage = new map < id, Drug_Coverage__c > ();
        
        
        try{
            for (Drug_Coverage__c drugCoverage: lstExistingDrugCoverage) {
                Drug_Coverage__c newDrugCoverage = drugCoverage.clone(false);
                newDrugCoverage.CRD_ID__c = newCRDId;
                lstNewDrugCoverage.put(drugCoverage.id, newDrugCoverage);
            }
            if (lstNewDrugCoverage != null && lstNewDrugCoverage.size() > 0) {
           System.debug('lstNewDrugCoverage'+lstNewDrugCoverage);
                /*System.debug(lstNewDrugCoverage[0].Maintenance_Choice__c);
                            System.debug(lstNewDrugCoverage[0].No_of_fills_allowed_at_retail__c);
                            System.debug(lstNewDrugCoverage[0].Mchoice_Drug_List__c);
                            System.debug(lstNewDrugCoverage[0].Restart_Fills__c);
                            System.debug(lstNewDrugCoverage[1].Maintenance_Choice__c);
                            System.debug(lstNewDrugCoverage[1].No_of_fills_allowed_at_retail__c);
                            System.debug(lstNewDrugCoverage[1].Mchoice_Drug_List__c);
                            System.debug(lstNewDrugCoverage[1].Restart_Fills__c);*/
            
                database.insert (lstNewDrugCoverage.values());
            }
            // Added for DC Drug List/Group Objects
            list < DC_Drug_List_Group__c > lstexistingDCDrugListGroup = new list < DC_Drug_List_Group__c > ([SELECT Apply_Limitations__c,Bypass_MOOP__c, Allow_Transition_Fill__c,Start_Age__c,
                                                                                                             Start_Age_Type__c, End_Age__c, End_Age_Type__c, Gender__c, Maximum_Days__c,
                                                                                                             Minimum_Days__c, Day_Quantity_Rule__c, Minimum_Quantity__c, Maximum_Quantity__c,
                                                                                                             Maximum_Dollars__c, Maximum_Fills__c, Daily_Dose__c, Days_Over_Time_of_Days__c,
                                                                                                             Days_Over_Time_Time_Period__c, Days_Over_Time_Time_Value__c, Quantity_Over_Time_Quantity__c,
                                                                                                             Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Max_Days_per_Fill__c,
                                                                                                             Max_Quantity_per_Fill__c,/* Drug_Class_Name__c,*/ Drug_Group__c, Drug_List__c,
                                                                                                             Inclusion_Exclusion_Drug_Class__c, Inclusion_Exclusion__c, Name, Related_Drug_Coverage__c 
                                                                                                             FROM DC_Drug_List_Group__c
                                                                                                             where Related_Drug_Coverage__c in : lstNewDrugCoverage.keyset()]);
            Map < Id, DC_Drug_List_Group__c > lstnewDCDrugListGroup = new Map < Id, DC_Drug_List_Group__c > ();
            //Cloning the DC Drug List/Group
            for (DC_Drug_List_Group__c dcDrugList: lstexistingDCDrugListGroup) {
                DC_Drug_List_Group__c newdcDrugList = dcDrugList.clone(false);
                newdcDrugList.Related_Drug_Coverage__c = lstNewDrugCoverage.get(dcDrugList.Related_Drug_Coverage__c).id;
                lstnewDCDrugListGroup.put(dcDrugList.Id, newdcDrugList);
            }
            if (lstnewDCDrugListGroup != null && lstnewDCDrugListGroup.size() > 0) {
                database.insert (lstnewDCDrugListGroup.values());
            }
            // cloning the DC Copay
            /*List < DC_Copay__c > lstexistingDCCopay = new List < DC_Copay__c > ([select Id, Copay_Calculation__c, CRD_ID__c, DAW_Code__c, DC_Drug_List_Group_ID__c, DC_Drug_List_Group_ID__r.Name, Dollar_Amount__c, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Percent__c, Reverse__c, Stepped__c from DC_Copay__c where DC_Drug_List_Group_ID__c IN: lstnewDCDrugListGroup.keyset()]);

Map < Id, DC_Copay__c > lstnewDCCopay = new Map < Id, DC_Copay__c > ();


for (DC_Copay__c dcCopay: lstexistingDCCopay) {
DC_Copay__c newDcCopay = dcCopay.clone(false);
newDcCopay.DC_Drug_List_Group_ID__c = lstnewDCDrugListGroup.get(dcCopay.DC_Drug_List_Group_ID__c).Id;
lstnewDCCopay.put(dcCopay.Id, newDcCopay);
}
if (lstnewDCCopay != null && lstnewDCCopay.size() > 0) {
insert lstnewDCCopay.values();
}
List < DC_Copay_Stepped__c > lstexistingDCCopayStepped = new List < DC_Copay_Stepped__c > ([select Id, name, Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, DC_Copay_ID__c, Dollar_Amount__c, End_Range__c, Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c, Percent__c, Reverse__c, Type_of_Stepped_Copay__c from DC_Copay_Stepped__c where DC_Copay_ID__c IN: lstnewDCCopay.keyset()]);

List < DC_Copay_Stepped__c > lstnewDCCopayStepped = new List < DC_Copay_Stepped__c > ();
for (DC_Copay_Stepped__c dcstepped: lstexistingDCCopayStepped) {
DC_Copay_Stepped__c newdcStepped = dcstepped.clone(false);
newdcStepped.DC_Copay_ID__c = lstnewDCCopay.get(dcstepped.DC_Copay_ID__c).Id;
lstnewDCCopayStepped.add(newdcStepped);
}
if (lstnewDCCopayStepped != null && lstnewDCCopayStepped.size() > 0) {
insert lstnewDCCopayStepped;
}*/
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneRxCheck
* Description :- Method to Start the cloning for RxCheck Junction
**/
    public void cloneRxCheck(id newCRDId) {
        list < RxCheck_Junction__c > lstExistingRxCheck = new list < RxCheck_Junction__c > ([Select Selected__c, RxCheck__c, RxCheck_Program_Name__c, RxCheck_Clinical_Programe__c, Name, Id, CRD__c 
                                                                                             From RxCheck_Junction__c 
                                                                                             where CRD__c = : crdId]);
        list < RxCheck_Junction__c > lstNewRxCheck = new list < RxCheck_Junction__c > ();
        
        try{
            for (RxCheck_Junction__c rxCheck: lstExistingRxCheck) {
                RxCheck_Junction__c newRxCheck = rxCheck.clone(false);
                newRxCheck.CRD__c = newCRDId;
                lstNewRxCheck.add(newRxCheck);
            }
            if (lstNewRxCheck != null && lstNewRxCheck.size() > 0) {
                database.insert (lstNewRxCheck);
            }
        }catch(Exception e){throw e;}
    }
     /** Commented By Sushant : Req 04937
* Method :- cloneCvsWebUsers
* Description :- Method to Start the cloning for CVS web users

    public void cloneCvsWebUsers(id newCRDId) {
        list < CVS_Web_Access_Users__c > lstExistingUser = new list < CVS_Web_Access_Users__c > ([Select Web_Acces_User_Name__c, RxNav__c, Name, Last_4_digits_of_SSN__c, Id,
                                                                                                  ConnectionSentId, ConnectionReceivedId, Client_Access__c, Client_Acces_Security__c, CRD_ID__c
                                                                                                  From CVS_Web_Access_Users__c 
                                                                                                  where CRD_ID__c = : crdId]);
        list < CVS_Web_Access_Users__c > lstNewUser = new list < CVS_Web_Access_Users__c > ();
        
        try{
            for (CVS_Web_Access_Users__c usr: lstExistingUser) {
                CVS_Web_Access_Users__c newUsr = usr.clone(false);
                newUsr.CRD_ID__c = newCRDId;
                lstNewUser.add(newUsr);
            }
            if (lstNewUser != null && lstNewUser.size() > 0) {
                database.insert (lstNewUser);
            }
        }catch(Exception e){throw e;}
    }
**/        
/**
* Method :- cloneNetworkJunction
* Description :- Method to Start the cloning for Network Junction
**/    
    public void cloneNetworkJunction(id newCRDId) {
        list < Network_Junction__c > lstExistingNetworkJunction = new list < Network_Junction__c > ([Select Specialty_Custom__c, Retail_Custom__c, Network_Specialty__c,
                                                                                                     Network_Retail__c, Network_Mail__c, Name, Mail_Custom__c, Id,
                                                                                                     Does_client_have_suppression__c,/* Medvantix_Copay_Calculation__c,*/
                                                                                                     Medvantix_Copay_Dollar_Amount__c,/* Medvantix_Copay_Max_Dollar__c,
Medvantix_Copay_Min_Dollar__c, Medvantix_Copay_Percent__c,*/
                                                                                                     Enroll_in_Medvantix__c, CRD_ID__c 
                                                                                                     From Network_Junction__c 
                                                                                                     where CRD_ID__c = : crdId]);
        list < Network_Junction__c > lstNetworkJunction = new list < Network_Junction__c > ();
        
        try{
            for (Network_Junction__c Item: lstExistingNetworkJunction) {
                Network_Junction__c newNetworkJunctionItem = Item.clone(false);
                newNetworkJunctionItem.CRD_ID__c = newCRDId;
                lstNetworkJunction.add(newNetworkJunctionItem);
            }
            if (lstNetworkJunction != null && lstNetworkJunction.size() > 0) {
                database.insert (lstNetworkJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    
    
    /**
* Method :- cloneSaveACopayJunction
* Description :- Method to Start the cloning for Save-A-Copay Junction
**/   
    public void cloneSaveACopayJunction(id newCRDId) {
        list < Save_A_Copay_Junction__c > lstExistingSaveACopayJunction = new list < Save_A_Copay_Junction__c > ([Select Selected__c, Save_A_Copay_ID__c, Save_A_Copay_Drug_Class__c,
                                                                                                                  Name, Id, ConnectionSentId, ConnectionReceivedId, CRD_ID__c
                                                                                                                  From Save_A_Copay_Junction__c 
                                                                                                                  where CRD_ID__c = : crdId]);
        list < Save_A_Copay_Junction__c > lstSaveACopayJunction = new list < Save_A_Copay_Junction__c > ();
        
        try{
            for (Save_A_Copay_Junction__c Item: lstExistingSaveACopayJunction) {
                Save_A_Copay_Junction__c newSaveACopayJunctionItem = Item.clone(false);
                newSaveACopayJunctionItem.CRD_ID__c = newCRDId;
                lstSaveACopayJunction.add(newSaveACopayJunctionItem);
            }
            if (lstSaveACopayJunction != null && lstSaveACopayJunction.size() > 0) {
                database.insert (lstSaveACopayJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- clonePSPJunction
* Description :- Method to Start the cloning for PSP Junction
**/  
    public void clonePSPJunction(id newCRDId) {
        list < PSP_Junction__c > lstExistingPSPJunction = new list < PSP_Junction__c > ([Select Selected__c, Prescription_Savings_Program_Drug_Class__c, PSP_ID__c, Name, Id, CRD_ID__c 
                                                                                         From PSP_Junction__c 
                                                                                         where CRD_ID__c = : crdId]);
        list < PSP_Junction__c > lstPSPJunction = new list < PSP_Junction__c > ();
        
        try{
            for (PSP_Junction__c Item: lstExistingPSPJunction) {
                PSP_Junction__c newPSPJunctionItem = Item.clone(false);
                newPSPJunctionItem.CRD_ID__c = newCRDId;
                lstPSPJunction.add(newPSPJunctionItem);
            }
            if (lstPSPJunction != null && lstPSPJunction.size() > 0) {
                database.insert (lstPSPJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneCrStepTherepyJunction
* Description :- Method to Start the cloning for Step Therapy Junction
**/   
    public void cloneCrStepTherepyJunction(id newCRDId) {
        list < CRD_Step_Therapy_Junction__c > lstExistingStJunction = new list < CRD_Step_Therapy_Junction__c > ([Select c.Step_Therapy_Drug_Class__c, c.Step_Therapy_DrugList_Class__c,
                                                                                                                  c.Name, c.Id, c.CRD_ID__c
                                                                                                                  From CRD_Step_Therapy_Junction__c c 
                                                                                                                  where c.CRD_ID__c = : crdId]);
        list < CRD_Step_Therapy_Junction__c > lstStJunction = new list < CRD_Step_Therapy_Junction__c > ();
        
        try{
            for (CRD_Step_Therapy_Junction__c Item: lstExistingStJunction) {
                CRD_Step_Therapy_Junction__c newStJunctionItem = Item.clone(false);
                newStJunctionItem.CRD_ID__c = newCRDId;
                lstStJunction.add(newStJunctionItem);
            }
            if (lstStJunction != null && lstStJunction.size() > 0) {
                database.insert (lstStJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- clonClinicalProgrameGroupJunction
* Description :- Method to Start the cloning for Clinical Program Junction
**/    
    public void clonClinicalProgrameGroupJunction(id newCRDId) {
        list < Clinical_Program_Group_Junction__c > lstExistinCPGroupJunction = new list < Clinical_Program_Group_Junction__c > ([Select c.Selected__c, c.Record_Type__c, c.Clinical_Program_Group_ID__c,
                                                                                                                                  c.Clinical_Program_Group_Name__c, c.CRD_ID__c
                                                                                                                                  From Clinical_Program_Group_Junction__c c 
                                                                                                                                  where c.CRD_ID__c = : crdId]);
        list < Clinical_Program_Group_Junction__c > lstCPGroupJunction = new list < Clinical_Program_Group_Junction__c > ();
        
        try{
            for (Clinical_Program_Group_Junction__c Item: lstExistinCPGroupJunction) {
                Clinical_Program_Group_Junction__c newcpgJunctionItem = Item.clone(false);
                newcpgJunctionItem.CRD_ID__c = newCRDId;
                lstCPGroupJunction.add(newcpgJunctionItem);
            }
            if (lstCPGroupJunction != null && lstCPGroupJunction.size() > 0) {
                database.insert (lstCPGroupJunction);
                
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- clonePOStepTherepyJunction
* Description :- Method to Start the cloning for Prior Auth Junction
**/    
    public void clonePOStepTherepyJunction(id newCRDId) {
        list < CRD_PriorAuth_Junction__c > lstExistingPoJunction = new list < CRD_PriorAuth_Junction__c > ([Select c.Precert_Class__c, c.Name, c.Id, c.ConnectionSentId,
                                                                                                            c.ConnectionReceivedId, c.CRD_ID__c
                                                                                                            From CRD_PriorAuth_Junction__c c 
                                                                                                            where c.CRD_ID__c = : crdId]);
        list < CRD_PriorAuth_Junction__c > lstPoJunction = new list < CRD_PriorAuth_Junction__c > ();
        
        try{
            for (CRD_PriorAuth_Junction__c Item: lstExistingPoJunction) {
                CRD_PriorAuth_Junction__c newPoJunctionItem = Item.clone(false);
                newPoJunctionItem.CRD_ID__c = newCRDId;
                lstPoJunction.add(newPoJunctionItem);
            }
            if (lstPoJunction != null && lstPoJunction.size() > 0) {
                database.insert (lstPoJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneQlStepTherepyJunction
* Description :-Method to Start the cloning for Quantity Limit Junction
**/
    public void cloneQlStepTherepyJunction(id newCRDId) {
        list < CRD_Quantity_Limit_Junction__c > lstExistingQlJunction = new list < CRD_Quantity_Limit_Junction__c > ([Select c.QL_Class__c, c.Name, c.Id, c.ConnectionSentId,
                                                                                                                      c.ConnectionReceivedId, c.CRD_ID__c 
                                                                                                                      From CRD_Quantity_Limit_Junction__c c 
                                                                                                                      Where c.CRD_ID__c = : crdId]);
        list < CRD_Quantity_Limit_Junction__c > lstQlJunction = new list < CRD_Quantity_Limit_Junction__c > ();
        
        try{
            for (CRD_Quantity_Limit_Junction__c Item: lstExistingQlJunction) {
                CRD_Quantity_Limit_Junction__c newQlJunctionItem = Item.clone(false);
                newQlJunctionItem.CRD_ID__c = newCRDId;
                lstQlJunction.add(newQlJunctionItem);
            }
            if (lstQlJunction != null && lstQlJunction.size() > 0) {
                database.insert (lstQlJunction);
            }
        }catch(Exception e){throw e;}
    }
    /**
* Method :- cloneAHAJunction
* Description :-Method to Start the cloning for AHA Junction
**/    
    Public void cloneAHAJunction(id newCRDId) {
        List < AHA_Junction__c > lstexistingAHAJunction = new List < AHA_Junction__c > ([select Name, CRD_ID__c, Drug_List__c, Drug_List_ID__c, Selected__c 
                                                                                         from AHA_Junction__c 
                                                                                         where CRD_ID__c = : crdId]);
        List < AHA_Junction__c > lstnewAHAJunction = new List < AHA_Junction__c > ();
        
        try{
            for (AHA_Junction__c Item: lstexistingAHAJunction) {
                AHA_Junction__c newAHA = Item.clone(false);
                newAHA.CRD_ID__c = newCRDId;
                lstnewAHAJunction.add(newAHA);
            }
            if (lstnewAHAJunction != null && lstnewAHAJunction.size() > 0){
                database.insert (lstnewAHAJunction);
            }
        }catch(Exception e){throw e;}
    }
    
    /**
* Method :- cloneRxStepJunction
* Description :-Method to start cloning for Aetna RxStep Junction
**/ 
    Public void cloneRxStepJunction(id newCRDId) {
        List < Aetna_RxStep_Junction__c > lstexistingRxStepJunction = new List < Aetna_RxStep_Junction__c > ([select id,Drug_Lists__c, Name, CRD_Id__c, Drug_List__c,  Selected__c 
                                                                                                              from Aetna_RxStep_Junction__c 
                                                                                                              where CRD_ID__c = : crdId]);
        List < Aetna_RxStep_Junction__c > lstnewRxStepJunction = new List < Aetna_RxStep_Junction__c > ();
        
        try{
            for (Aetna_RxStep_Junction__c Item: lstexistingRxStepJunction) {
                Aetna_RxStep_Junction__c newRxStep = Item.clone(false);
                newRxStep.CRD_ID__c = newCRDId;
                lstnewRxStepJunction.add(newRxStep);
            }
            if (lstnewRxStepJunction != null && lstnewRxStepJunction.size() > 0){
                database.insert (lstnewRxStepJunction);
            }
        }catch(Exception e){throw e;}
    }
    /**
* Method :- cloneRXOJunction
* Description :-Method to Start the cloning for Rx outcome Junction
**/  
    Public void cloneRXOJunction(id newCRDId) {
        List < Aetna_RxHealthy_Outcomes_Junction__c > lstexistingRXOJunction = new List < Aetna_RxHealthy_Outcomes_Junction__c > ([Select Id, Aetna_RxHealthy_Outcomes_Drug_List__c, Selected__c 
                                                                                                                                   from Aetna_RxHealthy_Outcomes_Junction__c 
                                                                                                                                   where CRD_ID__c = : crdid]);
        List < Aetna_RxHealthy_Outcomes_Junction__c > lstnewRXOJunction = new List < Aetna_RxHealthy_Outcomes_Junction__c > ();
        
        try{
            for (Aetna_RxHealthy_Outcomes_Junction__c Item: lstexistingRXOJunction) {
                Aetna_RxHealthy_Outcomes_Junction__c newRXO = Item.clone(false);
                newRXO.CRD_ID__c = newCRDId;
                lstnewRXOJunction.add(newRXO);
            }
            if (lstnewRXOJunction != null && lstnewRXOJunction.size() > 0){
                database.insert (lstnewRXOJunction);
            }
        }catch(Exception e){throw e;}
    }
    /**
* Method :- cloneSSEJunction
* Description :-method for cloning CRD Standard Safety Edits
**/ 
    public void cloneSSEJunction(Id newCRDId) {
        List < CRD_Standard_Safety_Edit_Junction__c > sseJunctionList = [SELECT CRDID__c, Drug_Group__c, Drug_Group_Description__c, Drug_Group_ID__c,
                                                                         Drug_Group_Name__c, Drug_List__c, Drug_List_Description__c, Drug_List_ID__c,
                                                                         Drug_List_Name__c, Is_Standard__c, Name, Select__c
                                                                         FROM CRD_Standard_Safety_Edit_Junction__c
                                                                         WHERE CRDID__c = : crdId];
        
        List < CRD_Standard_Safety_Edit_Junction__c > newSSEJunctionList = new List < CRD_Standard_Safety_Edit_Junction__c > ();
        
        try{
            for (CRD_Standard_Safety_Edit_Junction__c sseJunc: sseJunctionList) {
                CRD_Standard_Safety_Edit_Junction__c newSSEJunction = sseJunc.clone(false);
                newSSEJunction.CRDID__c = newCRDId;
                newSSEJunctionList.add(newSSEJunction);
            }
            
            if (newSSEJunctionList != null && newSSEJunctionList.size() > 0){
                database.insert (newSSEJunctionList);
            }
        }catch(Exception e){throw e;}
    }
    /**
* Method :- clonCSAPCGLPJunction
* Description :-Method to Start the cloning for CSAP/CGLP Junction
This method is added for PERS Mass Change 06/25/2013

**/   
    public void clonCSAPCGLPJunction(id newCRDId) {
        list < CSAP_CGLP_Junction__c > lstExistinCSAPCGLPJunction = new list < CSAP_CGLP_Junction__c > ([Select CRD__c,CRD_RxPlan_ID__c,CSAP_Control_ID__c,
                                                                                                         CSAP_Detail__c,CSAP_Plan_ID__c,Full_Control_Group__c,
                                                                                                         GLP_Group_Number__c,GLP_Plan_ID__c,Partial_Control_Group__c
                                                                                                         From CSAP_CGLP_Junction__c  
                                                                                                         where CRD__c = : crdId]);
        list < CSAP_CGLP_Junction__c > lstnewCSAPCGLPJunction = new list < CSAP_CGLP_Junction__c > ();
        
        try{
            for (CSAP_CGLP_Junction__c Item: lstExistinCSAPCGLPJunction) {
                CSAP_CGLP_Junction__c newcsapJunctionItem = Item.clone(false);
                newcsapJunctionItem.CRD__c = newCRDId;
                lstnewCSAPCGLPJunction.add(newcsapJunctionItem);
            }
            if (lstnewCSAPCGLPJunction != null && lstnewCSAPCGLPJunction.size() > 0) {
                database.insert (lstnewCSAPCGLPJunction);
            }
        }catch(Exception e){throw e;}
    }
    /**Added by Richa for Request 4731
* Method :- cloneWOD
* Description :- Method for cloning Waiver Of Deductible
**/ 
    Map < Id, Id > oldnewWODMap= new Map < Id, Id > ();
    public void cloneWOD(id newCRDId) {
        list < Waiver_Of_Deductible__c > existingWOD = new list< Waiver_Of_Deductible__c > ([SELECT CRD_ID__c,Delivery_System__c, Drug_Class__c,
                                                                                             Drug_Class_Desc__c, Drug_Group__c, Drug_List__c,M__c,N__c,O__c,Y__c,Standard__c
                                                                                             From Waiver_Of_Deductible__c
                                                                                             where CRD_ID__c = : crdid]);
        list< Waiver_Of_Deductible__c > newWODList = new list< Waiver_Of_Deductible__c > ();
        
        try{
            for(Waiver_Of_Deductible__c WOD:existingWOD){
                Waiver_Of_Deductible__c newWOD = WOD.clone(false);
                newWOD.CRD_ID__c = newCRDID;
                newWODList.add(newWOD);
            }
            if (newWODList!= null && newWODList.size() > 0) {
                database.insert (newWODList);
            }
        }catch(Exception e){throw e;}
    }
    /**Added by Sushant for Request 04872
    *Method :- cloneNPL
    *Description :- Method for cloning NPL Junction
    **/
    Map<Id,Id> oldnewNPLMap = new Map<Id,Id>();
    public void cloneNPL(id newCRDId){
        list< CRD_NPL_Junction__c > existingNPL = new list<CRD_NPL_Junction__c>([SELECT CRD_ID__c,Drug_List__c,Drug_List_Description__c,
                                                                                Drug_List_Name__c,IsStandard__c,Select__c 
                                                                                FROM CRD_NPL_Junction__c 
                                                                                where CRD_ID__c = :crdid]);
                                                                                
        list< CRD_NPL_Junction__c> newNPLList = new List<CRD_NPL_Junction__c>();
         try{
                for(CRD_NPL_Junction__c NPL:existingNPL){
                        CRD_NPL_Junction__c newNPL = NPL.clone(false);
                        newNPL.CRD_ID__c = newCRDID;
                        newNPLList.add(newNPL);
                }               
                if (newNPLList != NULL && newNPLList.size() >0){
                    database.insert (newNPLList);
                }        
            }catch(Exception e){throw e;}
        }  
}