/*Purpose: Apex  Class to generate the XML of CRD and attach it with case
    ========
    History
    -------
    VERSION     AUTHOR                 DATE                    DETAIL
    0.1 -    Saraag                Not known       generate CRD XML
    0.2      Anuj                  05/07/2012      Expansion of CRD XML
    0.3 -    Becca                 05/23/2012      commented out field "What are you doing?"
    1.0      Anuj                  05/25/2012      Expansion of drug List Criteria
    1.1      Anuj                  06/03/2012      Hot fix for may release
    1.2      Becca                 06/05/2012      Updated Pricing Fields and checked 'CRD:Benefits' on new case
    1.3      Becca                 07/09/2012      Unchecked checkbox for PGs associated with GMF on new case
    1.4      Rishabh               07/18/2012      Request#752 Commented the partial control group statement.
    1.5      Anuj                  07/24/2012      Request #784, updated the version of XML
    1.6      Rishabh               07/30/2012      Request #758, on line 1698
    1.7      Rishabh               08/07/2012      Request #817, commented lines 848,849
    1.8      Rishabh               08/08/2012      Request #828, added line 1819
    1.9      Rishabh               08/10/2012      Request #826 new fields in paper claims section added
    1.10     Sourabh               08/21/2012      Request #734
    1.11     Rishabh               09/05/2012      request #802
    2.0      rakesh                10-Aug'12       As per req. 761
                                                   Commented 'Pays_the_DAW_difference_after_deductible' field.
                                                   Added field 'DAW_Differential_Penalty_Applies_to_MOOP'
    2.1      rakesh                11-Aug'12       Added field 'What_happens_when_MOOP_is_met' field in Accumulation Specific Drug. (Req. 786)
    2.2      Rishabh               11thSep'12      Request 00870
    2.3      Becca                  12/12/2012      Updated with changes from requirements from Expansion Notes on 11-13-2012
    2.4      Sourabh               12/28/2012      Updated the Programs section for PSP,SAC and RxCheck
    2.5      Becca                  01/03/2013      Updated to complete request from 11-28-12
    2.6      Becca                  01/28/2013      Updated Clinical Program Group Junction to have it's own node and to show record type
    2.7      Becca                  4/2/2013        Added CRD Pricing record name on CRD Node per request #959
    2.8      Becca                  4/10/13         Removed Commenting on Copay Tier Tier Type line per JT
    3.0      Rishabh                3/13/2013        all commented code removed and formatting of code
    3.1      Rishabh                3/14/2013        Added fields as per Req 868
    3.2      Sushant                6/20/2013        Added fields as per Req 1033
    3.3      Sushant                7/29/2013        Modified fields as per Req 01112
    3.4      Sushant                08/05/2013       Modified fields as per Req 01129
    3.5      Sushant                08/06/2013       Modified fields as per Req 01139
    3.6      Sushant                09/16/2013       Modified fields as per Req 01183
    3.7      Sushant                09/30/2013       Req 01203    
    3.8      abhishek               10/07/2013       Req 01124
    3.9      Becca                  11/06/2013       Added HIX back into case creation
    4.0      Sushant                11/19/2013       Added Fields as per Req 01159   
    4.1      Becca                  12/19/2013       Added AHA Junction fields to the XML
    4.2      Joognu                 02/18/2014      Added Aetna RxStep Junction fields to the XML
    4.3      Becca                  02/25/2014      Change field labels for request # 04373
    4.4      Joognu Rao             04/18/2014      Implemented request no 4712
    4.5      Joognu Rao             04/24/2014      Implemented request no 4729
    4.6      Joognu Rao             04/28/2014      Implemented request no 4525
    4.7      Joognu Rao             04/29/2014      Implemented request no 4719
    4.8      Joognu Rao             04/30/2014      Implemented request no 4771
    5.0      Nitish Verma           06/05/2014      Implemented request no 04869
    5.1      Nitish Verma           06/06/2014      Implemented request no 04870
    5.2      Richa                  07/30/2014      Commented all Hypertension and Hyperlipidemia fields for Req4558  
    5.3      Sushant                08/20/2014      Added CRD NPl Section as per request 04872 
    5.4      Joognu Rao             09/08/2014      Implemented request no 5072   
    6.0      Nitish Verma           05/11/2014      Request No 5095
    6.1      Sushant Sethi          01/13/2015      Request No 05310
    6.2 -    Abhishek               01/22/2015      #5471 removed field "CVS_Caremark_Stellant_ID__c" 
    6.3 -    Abhishek goel          02/12/2015      #Request 05558/05559 added a section split fill in the code.
    6.4      Sushant Sethi          03/24/2015      Implemented Request 05521
    6.4 -    Abhishek              9/7/ 2016        Implemented request for ST1299.
    6.5      Bhaskar Arora          09/15/2016      Implemted request 06664 and 06665
    7.0      Nitish Verma           02/13/2017      Implemented request 6850
    
    ======================================================================== */
    public with sharing class GMF_XML_CRD_controller {

        CRD__c crdRecord;
        List < Network_Junction__c > NJRecord = new List < Network_Junction__c > ();
        List < Copay_Tier__c > CTRecord = new List < Copay_Tier__c > ();
        List < Drug_Specific_Copay__c > DSCRecord = new List < Drug_Specific_Copay__c > ();
        List < Drug_Coverage__c > DCRecord = new List < Drug_Coverage__c > ();
        List < Accumulations__c > ARecord = new List < Accumulations__c > ();
        // List < MOOP_Bypass__c > MOOPBypassRecord = new List < MOOP_Bypass__c > (); Commented By Sushant : Req 04937
        List < RxCheck_Junction__c > rcjRecord = new List < RxCheck_Junction__c > ();
        List < PSP_Junction__c > pspjRecord = new List < PSP_Junction__c > ();
        //new list added by anuj (Issue# 56)
        List < Clinical_Program_Group_Junction__c > cpjGroupRecord = new List < Clinical_Program_Group_Junction__c > ();
        //List < Clinical_Program_Junction__c > cpjRecord = new List < Clinical_Program_Junction__c > ();
        List < Save_A_Copay_Junction__c > sacRecord = new List < Save_A_Copay_Junction__c > ();
        List < CRD_Step_Therapy_Junction__c > stjRecord = new List < CRD_Step_Therapy_Junction__c > ();
        List < CRD_PriorAuth_Junction__c > pajRecord = new List < CRD_PriorAuth_Junction__c > ();
        List < CRD_Quantity_Limit_Junction__c > qljRecord = new List < CRD_Quantity_Limit_Junction__c > ();
        //List < CVS_Web_Access_Users__c > cvsRecord = new List < CVS_Web_Access_Users__c > (); Commented By Sushant : Req 04937
        List < DAW_Specific_Copay__c > DAWRecordList = new List < DAW_Specific_Copay__c > ();
        // List<Full_Control_Group__c> FCGRecordList= new List<Full_Control_Group__c>();
        List < CSAP_CGLP_Junction__c > CSAP_CGLPRecordList = new List < CSAP_CGLP_Junction__c > ();
        //List < DC_Copay__c > DCCopayList = new List < DC_Copay__c > ();
        List < AHA_Junction__c > AhaJunctionList = new List < AHA_Junction__c > ();
        List < Aetna_RxStep_Junction__c > ARSJunctionList = new List < Aetna_RxStep_Junction__c > ();
        List < Accumulation_Change_Copay__c > accumChangeCopayList = new List < Accumulation_Change_Copay__c > ();
        List < Aetna_RxHealthy_Outcomes_Junction__c > ahoJunctionList = new List < Aetna_RxHealthy_Outcomes_Junction__c > ();
        List < Drug_List_Junction__c > SEJRecord = new List < Drug_List_Junction__c > ();
        List < Waiver_Of_Deductible__c > WODRecord = new List < Waiver_Of_Deductible__c > ();
        string MailTypeRecord;
        //new Sets and Lists included by anuj
        Set < Id > rtsIdSet = new set < Id > ();
        set < Id > dgIdSet = new set < id > ();
        set < Id > cpgIdSet = new set < id > ();
        set < Id > dlIdSet = new set < id > ();
        set < Id > dclist = new set < Id > ();
        set < Id > accumlationIdSet = new set < Id > ();

        List < Refill_Too_Soon_Criteria__c > RTSCRecordList = new List < Refill_Too_Soon_Criteria__c > ();
        List < Max_Pay_Limitation__c > mxplRecordList = new List < Max_Pay_Limitation__c > ();
        List < Drug_List_Junction__c > dljRecordList = new List < Drug_List_Junction__c > ();
        List < Clinical_Program_Group__c > cpgRecordList = new List < Clinical_Program_Group__c > ();
        List < Drug_List__c > dlRecordList = new List < Drug_List__c > ();

        Clinical_Program__c concDURCP = new Clinical_Program__c();
        List < Conflict_Codes__c > conflictCodesListList = new List < Conflict_Codes__c > ();
        List < Codes__c > codesList = new List < Codes__c > ();
        List < Max_Pay_Limitation__c > maxPayLimitList = new List < Max_Pay_Limitation__c > ();
        List < CRD_NPL_Junction__c > crdNPLJuncList = new List < CRD_NPL_Junction__c > ();
        List < Retail_Vaccine_Program__c> RVPRecordList = new List < Retail_Vaccine_Program__c >();

        public XmlStreamWriter w = new XmlStreamWriter();

        Id parentId;
        /* 
         * Constructor of class GMF_XML_CRD_controller or controller method
         */  
        public GMF_XML_CRD_controller(ApexPages.StandardController controller) {

            parentId = controller.getId();
            /*******Start**************
            added by abhishek date on 02/12/2015 for request 05558/05559 *************/
            crdRecord = [Select
           /* c.Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c,*/c.Contract_state__c,c.Custom_NPL__c,c.CA_50_Cost_Share_Applies__c,c.CRD_Automated__c, c.Acquisition_Indicator__c,c.Save_A_Copay_Custom_Letter__r.Name, c.Save_A_Copay_Custom_Letter__r.LastSent__c, c.Migration_Run_Number__c, c.Plan_Type_Paper_Out_of_Network__c, c.Is_there_Paper_Out_of_Network__c, c.Different_copays_from_Paper_In_Network__c, c.Apply_Penalty__c, c.Penalty_Type__c, c.Penalty_Amount__c, c.Percentage_Applied__c, c.Paper_Out_of_Network_Number_of_Tiers__c, c.Any_drug_specific_Paper_Out_of_Network__c, c.Any_DAW_specific_Paper_OON_copays__c, c.Brands_w_DAW_5_take_a_generic_copay__c, /*c.Hypertension_All_Hypertension_Drugs__c, c.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c,*/ c.ARH_Offering_Type__c, c.Heart_Failure_Beta_Blockers_ARH__c, c.Asthma_Preventive__c, c.Diabetes_Preventive__c, c.Brands_DAW_5_take_a_gen_copay_Mail__c, c.Brands_DAW_5_take_a_gen_copay_Paper__c, c.Brands_DAW_5_take_a_gen_copay_Speciality__c, c.Brands_DAW_5_take_a_gen_copay_Retail__c, c.Account__r.Name, c.PSU__c, /*c.of_months_for_Copay_Waiver__c,*/ c.Year__c, c.Y_Schd__c, c.Who_processes_PA_or_Override__c, c.Which_system_will_the_plan_be_installed__c, c.Veterans_Admin__c, c.Vendor_Transition_Files__c, c.Value_Generic__c, c.Vacation__c, c.UBOI_ID__c, c.Type_of_Cost_Sharing__c, c.Transition_Plan_1_x_override_30DS__c, c.Toll_Free_Number__c, c.Tiering__c, c.Tier_3_Copay_Reduction__c, c.Tier_2_Copay_Reduction__c, c.Tier_1_Copay_Reduction__c, c.PSP_Letter_Templates__c, c.TP_ID__c, c.Custom_Safety_Edits__c, c.SystemModstamp, c.Sub_segment__c, c.SteppedCopayCount__c, c.Step_Therapy_TOC_days__c, c.Status__c, c.State_associated_with_this_plan__c, c.State__c, c.Standard_or_Custom_Plan__c, c.Standard_Step_Therapy_Program__c, c.Standard_Step_Therapy_Program__r.Name, c.Standard_Step_Therapy_Program__r.LastSent__c, c.Standard_QL_Program__c, c.Standard_QL_Program__r.Name, c.Standard_QL_Program__r.LastSent__c, c.Standard_QL_List_or_Select_Classes__c, c.Standard_Program_or_Select_Classes__c, c.Standard_Precert_Program__r.Name, c.Standard_Precert_Program__r.LastSent__c, c.Standard_Precert_List_or_Select_Classes__c, c.Standard_Plan_Selection__c, c.Specialty_Therapy_Management__c, c.Specialty_Retail_Lock_Out__c, c.Specialty_Number_of_Tiers__c, c.Specialty_Exclusion_Flag__c, c.Service_Enhancement_Date__c, c.SAC_Override_Option__c, c.Rx_Will_you_be_Picking_Drug_Classes__c, c.Rx_PP_ID__c, c.Rx_Override_Option__c, c.RxPlan_ID_Status__c, c.RxPlanID__c, c.RxPlanData__c, c.RxPlanDataExp__c, c.Risk_Indicator__c, c.Retail_to_Mail__c,
            /* c.Retail_to_Mail_Messaging__c,*/c.Standard_Fully_Insured_Pricing__c,c.Medical_Injectible_Claim_Denial_Process__c,c.Does_Chemo_Parity_Apply__c,c.Chemo_Parity_Drug_List__r.Name,c.Oral_Chemo_Cap__c,c.Dollar_Amount__c,c.Percent__c,c.Copay_Calculation__c,
                c.Chemo_Drugs_Bypass_Deductible__c,c.Chemo_Drugs_Bypass_MAB__c,c.Chemo_Drugs_Bypass_OOP__c,c.Chemo_Drugs_In_Network_same_as_OON__c,
            c.Retail_refill_for_Manufacture_Back_Order__c,c.Any_DAW_specific_Specialty_OON_copays__c,c.Any_drug_specific_Specialty_OON_copays__c,c.Apply_Penalty_to_Specialty_OON__c,c.Brands_w_DAW_5_take_a_generic_copay_spec__c,c.Different_Copays_from_Specialty__c,c.Is_there_Specialty_Out_of_Network__c,c.Penalty_Amount_Specialty_OON__c,c.Penalty_Type_Specialty_OON__c,c.Percentage_Applied_Specialty_OON__c,c.Plan_Type_Specialty_OON__c,c.Specialty_OON_Number_of_Tiers__c, c.Retail_Source_AWP__c, c.Retail_Number_of_Tiers__c, c.Reporting_Frequency__c, c.CreatedDate, c.LastModifiedDate, c.Reimbursement_Levels__c, c.Rating__c, c.RTMD_Modulator_Percent__c, c.Old_RxPlan_ID__c, c.RTMD_Effective_Date__c, c.Mac_at_Mail_Applies__c, c.RTMD_Client_Share_Percent__c, c.RTMD_Admin_Fee_rate__c, c.RTMD_Admin_Fee_basis__c, c.RDS__c, c.RDS_Termination_Date__c, c.RDS_Effective_Date__c, c.Prorate__c, c.Process_Point_of_Sales_COB__c, c.Prior_Authorization_ID__c, c.Pricing_Schedule__c, c.Prescriber_Network__c, c.Precert_TOC_days__c, c.Pre_Implementation_Audit__c, c.Platform_Information__c, c.Plan_Type_Specialty__c, c.Plan_Type_Retail__c, c.Plan_Type_Paper__c, c.Plan_Type_Mail__c, c.Plan_Platform__c, c.Plan_Extract_Date__c, c.Plan_Description__c, c.Plan_Coordinate_Benefits__c, c.Pharmacy_Advisor__c, c.Participate_in_CVS_mail_pharmacy_service__c, c.Participant_Mail_In_Delay__c, c.Participant_Lost_Stolen_Damaged_Meds__c, c.Paper_Number_of_Tiers__c, c.PSP_Override_Option__c, c.POS_Rebate_for_Plan__c, c.AHA_Drug_Group__c, c.AHA_Drug_Group__r.Name, c.AHA_Drug_Group__r.LastSent__c, /*c.POS_Dose_Optimization_Drug_List_ID__r.Name,*/ c.POS_Dose_Optimization_Drug_List_ID__r.LastSent__c, c.POS_Dose_Optimization_Drug_List_ID__r.CVS_Caremark_Drug_List_ID__c, c.POS_Dose_Optimization_Drug_List_ID__r.Non_GPI_Non_NDC_Check__c, /*c.POS_Dose_Optimization__c,*/ c.CVS_Caremark_Drug_List_ID__c, c.OwnerId, c.Out_of_Network_claims_are_reimbused__c, c.Out_of_Network__c, c.Out_of_Network_Reimbursement_Level__c, c.Out_of_Network_Cost_Sharing__c, c.Other_Insurance_Paid_in_Error__c, c.Ostomy_Supplies__c, c.Opt_out_of_Safety_Edits__c, c.Opt_out_of_Rx_OTC_Edit__c, c.Offshore__c, c.Nursing_Home__c, c.Nursing_Home_Claims__c, c.Number_of_Participants__c, c.No_of_Days_to_file_a_claim__c, c.National__c,c.Does_3_Month_Grace_Period_Apply__c, c.Name_of_Approver_on_SSD__c, c.Name, c.Multiple_Births__c, /*c.Migrane_Management__c,*/ c.Medicaid__c, c.Maximum_Dollar__c, c.Manual_Pharmacy_Payments__c, /*c.SAC_Letter_Templates__c,*/ c.Mail_Order_Delay__c, c.Mail_Number_of_Tiers__c, c.MDL_or_QVT_Limit_Exceptions__c, c.Is_DM_vendor_the_same_for_each_condition__c, c.Integration_Status__c, c.Integrate_with_Medical__c, c.Insured_Type__c, c.Indian_Facilities__c, c.Incumbent_PBM__c, c.Incorrect_Days_Supply__c, c.Include_Kit_Logic__c, c.In_Network_claims_are_reimbursed__c, c.In_Network__c, c.In_Network_Reimbursement_Level__c, c.Implementation_Type__c, c.Id,  c.High_Value_Client__c, /*c.Health_Care_for_Life__c,*/ c.Group_submits_eligibility_file__c, c.Group_submits_Cost_Reporting__c /*, c.Group_ID__c*/ , c.Generic_Uptake__c, c.Generic_Launch__c, c.Gaps_in_Care__c, c.Foreign_Claims__c, c.Extra_Care_Health_Card__c, c.Expatriate_Employees__c, c.Erisa_Client__c, c.Enrolled_in_PA_for_other_condition__c, c.Enroll_in_RxCheck__c, c.End_Date__c, c.Effective_Start_Date__c, c.Effective_Date__c, c.Durg_Specific_Stepped_Count__c, c.Duplicate_Therapy__c, c.Drug_Specific_copay_count__c, c.Drug_List_Option__c, c.Dose_Optimization__c, c.Dosage_Increase_Change__c, c.Does_the_client_want_to_do_COB__c,c.Do_you_want_to_do_Step_Therapy__c, c.Do_you_want_to_do_Save_A_Copay__c, c.Do_you_want_to_do_Precert__c, c.Do_Prescription_Savings_Program__c, c.Disease_Vendor__c, c.Disease_Management_Referral_Messaging__c, c.Disease_Management_Messaging_for__c, c.Discount_Rate__c, c.Disaster_Emergency__c, c.Delete_connectivitytest2__c, c.Default_NABP__c, c.Date_of_Approval_on_SSD__c, c.Customization_Approved__c, c.Custom_call_center_phone_number__c, /*c.Custom_TFN__c,*/ c.Custom_Step_Therapy_Date_Approved_ST__c, c.Custom_Step_Therapy_Date_Approved_QL__c, c.Custom_Step_Therapy_Classes__c, c.Custom_Quantity_Limits_Classes__c, c.Custom_Precert_Date_Approved__c, c.Custom_Precert_Classes__c, c.Custom_Network_Flag__c, c.Custom_Ben_ID__c, c.Cost_Sharing_Amount__c, c.Copay_Dollar_Amount__c,c.ConnectionSentId, c.ConnectionReceivedId, c.Concurrent_DUR_ID__r.Name, c.Concurrent_DUR_ID__r.LastSent__c, c.Concurrent_DUR_ID__r.CVS_Caremark_DUR_ID__c, c.Compound_Code_2__c, c.Co_Brand_Initial_Program_Welcome_Mailing__c, c.Clinic_Physician_Reimbursement__c, c.Client_Effective_Date__c, c.Client_Contact_Phone__c, c.Client_Contact_Last_Name__c, c.Client_Contact_First_Name__c, c.Client_Contact_Email_Address__c, c.Claims_payable_with_Pharm_Signature__c, c.Claims_Acceptable_w_o_receipts__c, c.Carrier_Number__c, c.Carrier_ID__c, c.Caremark_submit_IRL_files_to_RDS__c, c.Adherence_to_Drug_Therapy__c, c.CVS_submits_eligibility_file_to_Aetna__c, c.CVS_submits_cost_reporting_to_Aetna__c, c.COB_or_MOB__c, c.CM_submits_ongoing_monthly_files_to_RDS__c, c.Bridge_Supply__c, /*c.Blood_Glucose_Monitoring__c,*/ c.BPERxPlan_ID__c, c.Are_you_creating_a_Package_Plan__c, c.Are_there_Quantity_Limits__c, c.Approved_from_CustFormulary_Committee_ST__c, c.Approved_from_CustFormulary_Committee_QL__c, c.Approved_from_CustFormulary_Committee_PA__c, c.Apply_Retail_Copay__c, c.Application_ID__c, c.Any_drug_specific_Specialty_copays__c, c.Any_drug_specific_Retail_copays__c, c.Any_drug_specific_Paper_copays__c, c.Any_drug_specific_Mail_copays__c, c.Annual_Fill_Limit_Allowed_Limit__c, c.Allergy_Serums__c, c.Aetna_Healthy_Actions__c, c.Aetna_Autofill__c, c.Administration_of_External_COB__c, c.Account__c, c.Account_State__c, c.Account_Manager__c, c.Account_ID__c, c.Offering_Type__c, c.G_PlanSummary__c, c.Tier_4_Copay_Reduction__c, c.Tier_5_Copay_Reduction__c, c.Subsegment__c, c.Mail_Y_Schedule__c, c.Integration_1__c, c.Integration_2__c, c.G_Control__c, c.Partial_Control_Group__r.Name, Partial_Control_Group__r.CSAP_Plan_ID__c, Partial_Control_Group__r.CSAP_Control_ID__c, /*c.FSA_Integration__c,*/ c.Aetna_Rx_Healthy_Outcomes__c, c.Tier_1_Rx_Reduction__c, c.Tier_2_Rx_Reduction__c, c.Tier_3_Rx_Reduction__c, c.Tier_4_Rx_Reduction__c, c.Tier_5_Rx_Reduction__c, c.Asthma_Inhaled_Steroids__c, c.Asthma_Anti_Inflammatory_Agents__c, c.Full_Control_Group__r.Carrier_ID__c, c.Diabetes_Anti_Diabetic_Agents__c, c.Diabetes_Anti_Diabetic_Agent_Supplies__c, c.Heart_Failure_Beta_Blockers__c, /*c.Hyperlipidemia_Statins__c, c.Hyperlipidemia_Lipid_Lowering_Agents__c, c.Hypertension_ACE_Inhibitors_ARBs__c, c.Hypertension_All_Anti_Hypertensives__c,*/ c.Max_Pay__r.Name, c.Max_Pay__r.LastSent__c, c.Max_Pay__r.MP_Name__c, c.Max_Pay__c, c.Max_Pay__r.Begin_Date__c, c.Max_Pay__r.End_Date__c, c.Max_Pay__r.Message__c, c.Override_Standard_Max_Pay__c, c.Generic_Code_Conversion__r.Name, c.Generic_Code_Conversion__r.LastSent__c, c.GPI_System_Drug_List__r.Name, c.GPI_System_Drug_List__r.LastSent__c, c.GPI_System_Drug_List__r.CVS_Caremark_Drug_List_ID__c, c.NDC_System_Drug_List__r.Name, c.NDC_System_Drug_List__r.LastSent__c, c.NDC_System_Drug_List__r.CVS_Caremark_Drug_List_ID__c, c.Kit_Logic_Standard_Drug_List__r.Name, c.Kit_Logic_Standard_Drug_List__r.LastSent__c, c.Kit_Logic_Standard_Drug_List__r.CVS_Caremark_Drug_List_ID__c, c.XMLDate_Time_Stamp__c, c.In_Network_Discount_Rate__c, c.Out_of_Network_Discount_Rate__c, c.Bypass_DMR__c, c.High_Priority_Comments__c, c.Quantity_Limit_TOC_of_Days__c, c.Is_there_Compound_Max_Pay__c, c.Override_Standard_Compound_Max_Pay__c, c.Compound_Max_Pay__c, c.Compound_Max_Pay__r.Name, c.Compound_Max_Pay__r.LastSent__c, c.Compound_Max_Pay__r.Record_Type__c, c.Compound_Max_Pay__r.MP_Name__c, c.DM_Vendor_2_Contract_End_Date__c, c.Compound_Max_Pay__r.Begin_Date__c, c.Compound_Max_Pay__r.End_Date__c, c.Compound_Max_Pay__r.Message__c, c.Tier_1_Rx_Reduction_Type__c, c.Tier_2_Rx_Reduction_Type__c, c.Tier_3_Rx_Reduction_Type__c, c.Tier_4_Rx_Reduction_Type__c, c.Tier_5_Rx_Reduction_Type__c, c.Tier_1_Rx_Reduction_Amount__c, c.Tier_2_Rx_Reduction_Amount__c, c.Tier_3_Rx_Reduction_Amount__c, c.Tier_4_Rx_Reduction_Amount__c, c.Tier_5_Rx_Reduction_Amount__c, c.CRD_Risk_Indicator__c, c.Client_Name_On_Communication__c, c.Custom_Disease_Vendor_2_Phone_Number__c, c.Disease_Vendor_2__c, c.Disease_Vendor_1_Implementation_Type__c, c.Disease_Vendor_2_Implementation_Type__c, c.Aetna_RxHealthy_Outcomes_Drug_Group__c, c.Are_Emergency_Claims_Reimbursed__c, c.Are_Hemo_Claims_Reimbursed__c, c.Emergency_Discount_Rate__c, c.Hemo_Discount_Rate__c, c.Aetna_RxHealthy_Outcomes_Drug_Group__r.Name, c.Aetna_RxHealthy_Outcomes_Drug_Group__r.LastSent__c, c.Brand_Penalty_Exception__c, c.Tiering_Formulary_Exception__c, c.Global_Benefit_Exclusion__c,
            /*c.Waiver_of_Rx_Deductible__c,*/c.Aetna_RxStep__c, /*c.Chronic_Preventive_Drug_List__r.name,*/ /*c.Chronic_and_or_Preventive_List__c,*/c.OON_Cost_Share_Not_Greater_50_Drug_Cost__c,/*c.What_is_the_HDHP_fund_type__c,*/c.PA_Disease_Vendor_1__c,c.PA_Condition_1__c,c.PA_DM_Vendor_Contract_End_Date_1__c,c.PA_Custom_Disease_Vendor_Phone_1__c,c.PA_Disease_Vendor_2__c,c.PA_Condition_2__c,c.PA_DM_Vendor_Contract_End_Date_2__c,c.PA_Custom_Disease_Vendor_Phone_2__c,c.PA_Disease_Vendor_3__c,c.PA_Condition_3__c,c.PA_DM_Vendor_Contract_End_Date_3__c,c.PA_Custom_Disease_Vendor_Phone_3__c,c.PA_Disease_Vendor_4__c,c.PA_Condition_4__c,c.PA_DM_Vendor_Contract_End_Date_4__c,c.PA_Custom_Disease_Vendor_Phone_4__c,c.PA_Disease_Vendor_5__c,c.PA_Condition_5__c,c.PA_DM_Vendor_Contract_End_Date_5__c,c.PA_Custom_Disease_Vendor_Phone_5__c,c.PA_Disease_Vendor_6__c,c.PA_Condition_6__c,c.PA_DM_Vendor_Contract_End_Date_6__c,c.PA_Custom_Disease_Vendor_Phone_6__c,c.PA_Disease_Vendor_7__c,c.PA_Condition_7__c,c.PA_DM_Vendor_Contract_End_Date_7__c,c.PA_Custom_Disease_Vendor_Phone_7__c,c.Waive_Deductible_for_Tier_1_Drugs__c,c.Enroll_in_Aetna_Ways_to_Save__c, c.Mail_Request_Date__c, c.Requested_mailing_received_on__c, c.Target_Generic_Opportunities__c, c.Target_Formulary_Brand_Opportunities__c, c.Target_Pref_Manufacturer_Brand_Opportun__c, c.Target_Participants_18_years_and_older__c, c.Preferred_Manufacturer_Brands_Code__c, c.If_Not_18_Indicate_Age__c, c.Member_Letter_Selection__c, c.Minimum_Member_Savings_Projection__c, c.Introductory_Paragraph_to_Include__c,c.Is_there_split_fill__c,c.Split_Fill_Drug_List__r.name,c.Split_Fill_Drug_List__r.Drug_List_Name__c,c.Split_Fill_Drug_List__r.Description__c, NPL_Applies__c,NPL_Drug_List__r.Name,NPL_Drug_List__c,NPL_Drug_List__r.LastSent__c,NPL_Drug_List__r.CVS_Caremark_Drug_List_ID__c,NPL_Drug_List__r.Drug_List_Name__c,NPL_Drug_List__r.Description__c,/*c.DED_Waive_Preferred_Generic_IN__c,c.DED_Waive_Preferred_Generic_OON__c,*/
            (SELECT CRDID__c, Drug_Group__c, Drug_Group_Description__c, Drug_Group_ID__c, Drug_Group__r.LastSent__c, Drug_Group_Name__c, Drug_List__c, Drug_List_Description__c, Drug_List_ID__c, Drug_List_Name__c, Drug_LIst__r.LastSent__c, Is_Standard__c, LastSent__c, Name, Select__c, Drug_List__r.CVS_Caremark_Drug_List_ID__c
            FROM CRD_Standard_Safety_Edit_Junction__r
            WHERE CRDID__c = : parentId)
            From CRD__c c
            WHERE c.Id = : parentId AND isDeleted = false LIMIT 1];
            /*******END**************
            added by abhishek date on 02/12/2015 for request 05558/05559 *************/
            dgIdSet.add(crdRecord.Standard_QL_Program__c);
            dgIdSet.add(crdRecord.Standard_Precert_Program__c);
            dgIdSet.add(crdRecord.Standard_Step_Therapy_Program__c);
            dgIdSet.add(crdRecord.AHA_Drug_Group__c);

            dgIdSet.add((Id) System.label.DCSRT21);

            for (CRD_Standard_Safety_Edit_Junction__c sseJunction: crdRecord.CRD_Standard_Safety_Edit_Junction__r) {
                dgIdSet.add(sseJunction.Drug_Group__c);
            }
            
            
            //Added by Sourabh 4/1/2014
            
            SEJRecord = [Select Parent_Drug_Group_Name__c,Parent_Drug_Group__r.Name, Drug_List__r.Description__c, Drug_List_Name__c,Drug_List__r.Name, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Inactive__c from Drug_List_Junction__c where Inactive__c = False AND Parent_Drug_Group__c IN (select Drug_Group__c from CRD_Standard_Safety_Edit_Junction__c where CRDID__c=: crdRecord.Id AND Select__c = TRUE) ORDER BY Parent_Drug_Group__r.Name]  ;
            //Added by Sourabh

            NJRecord = [SELECT
            n.Specialty_Custom__r.Name, n.Retail_Custom__r.Name, n.Network_Specialty__c, n.Network_Retail__c, n.Network_Mail__c, n.Name, n.Mail_Custom__r.Name, n.Id, n.Does_client_have_suppression__c,/* n.Medvantix_Copay_Calculation__c, */ n.Medvantix_Copay_Dollar_Amount__c,/* n.Medvantix_Copay_Max_Dollar__c, n.Medvantix_Copay_Min_Dollar__c, n.Medvantix_Copay_Percent__c,*/ n.Enroll_in_Medvantix__c, n.CRD_ID__c FROM Network_Junction__c n
            WHERE n.CRD_ID__c = : crdRecord.Id AND isDeleted = false];
            
           RVPRecordList = [SELECT id,Name,Applies__c,CoPay_Calculation__c,CRD__c,recordtype.name,Dollar_Amount__c,Maximum_Dollar__c,Minimum_Dollar__c,Percent__c,Vaccine_Network__c,Waiver_of_Deductible__c FROM Retail_Vaccine_Program__c where CRD__C = : crdRecord.Id];

            CTRecord = [SELECT
            c.Tier__c, c.Tier_Name__c, c.Stepped_Copay__c, c.SteppedCopayCount__c, c.Reverse_Copay__c, c.RecordType.Name, c.Percent__c, c.Number_Of_Steps__c, c.Name, c.Min_Dollar__c, c.Max_Dollar__c, c.Id, c.Dollar_Amount__c, c.Copay_Calc__c, c.Tier_Type__c, Days_Per_Fill__c, (Select
            Stepped_CoPay_Types__c, Percent_Amount__c, Number_of_Ranges__c, Name, Min_Range__c, Min_Dollar__c, Max_Range__c, Max_Dollar__c, Id, Dollar_Amount__c, Copay_Calc__c,Reverse__c
            From SteppedCopays__r WHERE isDeleted = false)
            FROM Copay_Tier__c c
            WHERE c.CRD__c = : crdRecord.Id AND c.isDeleted = false
            ORDER BY Tier_Name__c];

            DSCRecord = [Select
            d.M__c, d.N__c, d.O__c, d.Y__c, d.TierNo__c, d.TierName__c, d.Stepped_Copay__c, d.SteppedCopayCount__c,d.Reverse_Copay__c,d.RecordType.Name, d.Percent__c, d.Name, d.Minimum_Dollar__c, d.Maximum_Dollar__c, d.Id, d.Drug_List__r.Name, d.Drug_List__r.Non_GPI_Non_NDC_Check__c, d.Drug_List__r.LastSent__c, d.Drug_Group__r.Name, d.Dollar_Amount__c, d.Drug_Group__r.LastSent__c, d.Copay_Calculation__c, d.Drug_List__c, d.Drug_Group__c, d.Drug_List__r.CVS_Caremark_Drug_List_ID__c, (Select
            Id,Reverse__c, IsDeleted, Name, Drug_Specific_Copay_ID__c, CRD_ID__c, Stepped_CoPay_Type__c, Number_of_Steps__c, Beginning_Range__c, End_Range__c, Dollar_Amount__c, Percent__c, Copay_Calculation__c, Maximum_Dollar__c, Minimum_Dollar__c, Related_Drug_Group_List__c
            From Drug_Specific_Stepped_Copay_s__r WHERE isDeleted = false)
            From Drug_Specific_Copay__c d
            WHERE d.CRD_ID__c = : crdRecord.Id AND d.isDeleted = false
            ORDER BY d.RecordType.Name];
            // Added By Nitish
            
            WODRecord = [Select w.CRD_ID__c, w.Delivery_System__c, w.Drug_Class__c, w.Drug_Class_Desc__c, w.Drug_Group__r.Name, w.Drug_List__r.Name, w.M__c, w.N__c, w.O__c, w.Y__c, w.Standard__c, w.Network__c FROM Waiver_Of_Deductible__c w WHERE w.CRD_ID__C = :crdRecord.Id ];      
            /*for (Drug_Specific_Copay__c record: DSCRecord) {
                dgIdSet.add(record.Drug_Group__c);
                dlIdSet.add(record.Drug_List__c);
            }
            */
            DCRecord = [SELECT
            d.No_of_fills_allowed_at_retail__c, d.Custom_Inclusion_Drug_Group__c,d.Max_Specialty_Day_Supply__c,d.Secondary_of_Fills_before_Force_to_MOD__c, d.Custom_Exclusion_Drug_Group__c, d.Choose_Generic_Copay_Diff_Exclusion__c,
            d.Aetna_Specialty_Care_Rx__c, d.Speciality_Drug_List__c, d.Do_you_have_Specialty__c, d.of_fills_before_force_to_specialty__c,d.Secondary_of_fills_before_force_to_SPN__c,d.Secondary_Aetna_Specialty_Care_Rx__c,d.Secondary_Force_to_Specialty__c,d.Secondary_RRA_Drug_List__r.Name,d.Secondary_RSO_Drug_List__r.Name,  d.Secondary_Speciality_Drug_List__r.Name, d.Secondary_Speciality_Drug_List__r.Non_GPI_Non_NDC_Check__c,
            d.Secondary_Speciality_Drug_List__r.LastSent__c, d.Secondary_Speciality_Drug_List__r.CVS_Caremark_Drug_List_ID__c, d.fills_before_MMO_option_is_invoked__c, /*d.X3rd_Party_Exceptions__c,*/ d.What_is_the_Penalty__c, d.What_Option__c,
            d.Use_Standard_MMOD_VMOD_Drug_List__c, d.Retail_Refill_Allowance_No_of_days__c, d.RSO_Drug_List__r.Name, d.Standard_Refill_too_Soon__c, d.Speciality_Drug_List__r.Name, d.Speciality_Drug_List__r.Non_GPI_Non_NDC_Check__c,
            d.Speciality_Drug_List__r.LastSent__c, d.Speciality_Drug_List__r.CVS_Caremark_Drug_List_ID__c, d.Smoking_Cessation_Aids__c, d.Rule_for_supply_quantity__c,
            /*d.Refill_Limits__c,*/ d.RecordType.Name, d.RecordType.DeveloperName, d.Period_Type__c, /*d.Packaging_Exceptions__c, d.OTC__c,*/ d.Nutritional_Dietary_Supplies_PKU__c,
            d.Number_of_Periods__c, d.Norplan__c, d.Name, /*d.Multi_Ingredient_Compounds__c, */d.Minimum_quantity__c, d.Minimum_days_supply__c,  d.Maximum_quantity__c, d.Maximum_days_supply__c, /*d.Max_Day_Supply__c,*/
            d.Mandatory_Mail_Order_Option__c, /*d.Maintenance_Form__c,*/ d.Maintenance_Choice__c, d.Mailing_Options__c, d.Lookback_Period__c, d.Id, d.Formulary__c, d.Formulary__r.LastSent__c,d.Does_Dose_Limit_apply__c, d.Dose_Limit__c, d.Higher_Lower_than__c, d.Dose_Limit_Exception_Drug_List__r.Name,
            d.Formulary__r.CVS_Caremark_Formulary_ID__c, d.Formulary_Open_Closed__c, d.Force_to_Specialty__c, /*d.FDA_Therapeutic_Equivalent__c, d.FDA_Therapeutic_Category__c,*/
            d.Exception_Drug_List__c, d.Exception_Drug_List__r.Name, d.Exception_Drug_List__r.LastSent__c, d.Exception_Drug_Group__r.Name, d.Exception_Drug_Group__r.LastSent__c,
            d.Exception_Drug_List__r.Non_GPI_Non_NDC_Check__c, d.Exception_Drug_Group__c, d.Exception_Drug_List__r.CVS_Caremark_Drug_List_ID__c,/*d.Dosage_Form__c, d.Dollar_Amount__c,*/
            d.Do_you_have_Choose_Generic__c,/*d.DUR__c, d.DUR_Message_Type__c, d.DESI__c, d.DEA__c,*/ d.Custom_Refill_too_Soon__c, d.Custom_MMOD_VMOD_Drug_List__c, d.CreatedDate, d.CreatedById, 
            d.Cost_Type__c, d.Cost_Amount__c,/*d.Copay_Based_On__c,*/d.Compounds_with_1_Federal_Legend_Drug__c, d.Use_Medispan_Indicator__c, d.Co_Insurance_Percentage__c, d.Co_Insurance_Dollar_Amount__c,
            /*d.Brand_Generic__c,*/ d.Apply_difference_of_cost__c,d.Formulary__r.Name, d.Custom_Refill_too_Soon__r.Name, d.Custom_Refill_too_Soon__r.LastSent__c, d.Custom_MMOD_VMOD_Drug_List__r.Name,
            d.Custom_MMOD_VMOD_Drug_List__r.Non_GPI_Non_NDC_Check__c, d.Allow_Transition_Fill__c,d.Transition_Fill_Number_of_Days__c,d.Custom_MMOD_VMOD_Drug_List__r.LastSent__c, d.Custom_MMOD_VMOD_Drug_List__r.CVS_Caremark_Drug_List_ID__c,d.Custom_Refill_too_Soon__r.Id,
            d.Custom_Refill_too_Soon__r.Refill_too_Soon_Name__c, d.Custom_Refill_too_Soon__r.Refill_too_Soon_Description__c, d.Custom_Refill_too_Soon__r.RecordType.DeveloperName, d.Custom_Refill_too_Soon__r.Effective_Date__c,
            d.Custom_Refill_too_Soon__r.Termination_Date__c, d.Custom_Refill_too_Soon__r.Early_Refill_Option__c, d.Custom_Refill_too_Soon__r.Search_Indication__c, d.Custom_Refill_too_Soon__r.Bypass_History_Days_Supply__c,
            d.Custom_Refill_too_Soon__r.Cumulative_Rx_Max_Days_Supply__c, d.Custom_Refill_too_Soon__r.Cumulative_Minimum_Percent__c, d.Days_Per_Fill__c, d.Custom_Refill_too_Soon__r.Begin_Refill_Logic_after_Fills__c,
            d.Custom_Refill_too_Soon__r.Cumulative_Search_Indication__c, d.Custom_Refill_too_Soon__r.Cumulative_History_Days__c, d.Custom_Refill_too_Soon__r.Exclusion_Drug_List__r.Name,
            d.Custom_Refill_too_Soon__r.Message_returned_to_the_Provider__c, d.Formulary_ID__c, d.Brand_Penalty_Based_Retail_Mail_AWP__c, d.Brand_Penalty_Dollar_Amount__c, d.Brand_Penalty_Maximum_Dollar__c, 
            d.Brand_Penalty_Minimum_Dollar__c, d.Brand_Penalty_Percent__c, d.Brand_Penalty_Type__c, d.Generic_Penalty_Dollar_Amount__c, d.Generic_Penalty_Maximum_Dollar__c, 
            d.Generic_Penalty_Minimum_Dollar__c, d.Generic_Penalty_Percent__c, d.Generic_Penalty_Type__c, d.Gen_Penalty_Based_Retail_Mail_AWP__c, d.Incentivized_Mail_Generic_Penalty_Type__c,
            d.Incentivized_Mail_Generic_Penalty_Amount__c, d.Incentivized_Mail_Brand_Penalty_Type__c, d.Incentivized_Mail_Brand_Penalty_Amount__c, d.Incent_Mail_NonPref_Brand_Penalty_Type__c,
            d.Incent_Mail_NonPref_Brand_Penalty_Amount__c, d.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c, d.Non_Pref_Brand_Penalty_Dollar_Amount__c, d.Non_Pref_Brand_Penalty_Maximum_Dollar__c, 
            d.Non_Pref_Brand_Penalty_Minimum_Dollar__c, d.Non_Pref_Brand_Penalty_Percent__c, d.Non_Pref_Brand_Penalty_Type__c, d.Restart_Fills__c,d.Incent_Mail_Gen_Penalty_Percent__c,
            d.Incent_Mail_Gen_Penalty_Min__c,d.Incent_Mail_Gen_Penalty_Max__c,d.Incent_Mail_Brand_Penalty_Percent__c,d.Incent_Mail_Brand_Penalty_Min__c,d.Incent_Mail_Brand_Penalty_Max__c,
            d.Incent_Mail_NP_Brand_Penalty_Percent__c,d.Incent_Mail_NP_Brand_Penalty_Min__c,d.Incent_Mail_NP_Brand_Penalty_Max__c,d.Number_of_fills__c, (Select Id, Name, Apply_Limitations__c,Bypass_MOOP__c, 
            Start_Age__c, Allow_Transition_Fill__c, Start_Age_Type__c, End_Age__c, End_Age_Type__c, Gender__c, Maximum_Days__c, Minimum_Days__c, Day_Quantity_Rule__c, Minimum_Quantity__c, Maximum_Quantity__c,
            Maximum_Dollars__c, Maximum_Fills__c, Daily_Dose__c, Days_Over_Time_of_Days__c, Days_Over_Time_Time_Period__c, Days_Over_Time_Time_Value__c, Quantity_Over_Time_Quantity__c,
            Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Max_Days_per_Fill__c, Max_Quantity_per_Fill__c, /*Drug_Class_Name__c,*/ Drug_Group__c, Drug_List__c, 
            Drug_Group__r.Name, Drug_Group__r.LastSent__c, Drug_List__r.Name, Drug_List__r.LastSent__c, Drug_List__r.Non_GPI_Non_NDC_Check__c, Inclusion_Exclusion__c, Inclusion_Exclusion_Drug_Class__c,
            Related_Drug_Coverage__r.Name, Drug_List__r.CVS_Caremark_Drug_List_ID__c,Drug_Group__r.Drug_Group_Name__c,Drug_List__r.Drug_List_Name__c
            from DC_Drug_List__r where isDeleted = false)
            From Drug_Coverage__c d
            WHERE d.CRD_ID__c = : crdRecord.Id AND isDeleted = false];
            
            // Added by JR to implement request no 5072
            
             MailTypeRecord = [Select r.SobjectType, r.DeveloperName From RecordType r where r.SobjectType='Drug_coverage__c' and r.DeveloperName='Mail'].id;
            
            //request Id 262 on 07 may 2012----Start
            for (Drug_Coverage__c record: DCRecord) {
                rtsIdSet.add(record.Custom_Refill_too_Soon__c);
                for (DC_Drug_List_Group__c childRecord: record.DC_Drug_List__r) {
                    dgIdSet.add(childRecord.Drug_Group__c);
                    dlIdSet.add(childRecord.Drug_List__c);
                    dclist.add(childRecord.Id);
                }

                dgIdSet.add(record.Exception_Drug_Group__c);
                dlIdSet.add(record.Exception_Drug_List__c);
            }

            RTSCRecordList = [SELECT r.Id, r.Rx_Max_Days_Supply__c, r.Rx_Min_Days_Supply__c, r.Minimum_Percent__c, r.Name, r.Related_Refill_Too_Soon__c From Refill_Too_Soon_Criteria__c r where r.Related_Refill_Too_Soon__c IN: rtsIdSet];
            // ----End
            ARecord = [SELECT
            a.MOOP_Maintenance_Drugs__c, a.When_will_the_Accumulations_renew__c, a.Accumulation_End_Date__c,a.What_happens_when_MOOP_is_met__c, a.MOOP_Brand_Drugs_no_Generics__c, a.MOOP_Brand_Drugs_Generics__c, a.MOOP_Generic_Drugs__c, a.MOOP_Out_of_Network__c, a.MOOP_In_Network__c, a.MAB_Maintenance_Drugs__c, a.MAB_Brand_Drugs_no_Generics__c, a.MAB_Brand_Drugs_Generics__c, a.MAB_Generic_Drugs__c, a.MAB_Out_of_Network__c, a.MAB_In_Network__c, /*added as per req 01033 by Sushant*/ a.Do_not_apply_flat_fee_to_OOP__c, a.Do_not_apply_penalty_to_OOP__c,a.What_is_the_In_Network_MOOP_Amount__c,a.What_is_the_In_Network_Deductible_Amount__c,a.What_is_the_OON_Deductible_Amount__c,a.What_is_the_OON_MOOP_Amount__c,a.Cross_Accumulation__c, a.Deductible_Maintenance_Drugs__c, a.Deductible_Brand_Drugs_no_Generics__c, a.Deductible_Brand_Drugs_Generics__c, a.Deductible_Generic_Drugs__c, a.Deductible_Out_of_Network__c, a.Deductible_In_Network__c, a.What_happens_when_the_MAB_is_met__c, a.Start_Month_New__c, a.Start_Day__c, a.RecordType.Name, a.DAW_Differential_Penalty_Applies_to_MOOP__c, Family_Members_to_meet_Family_Deduct__c, a.Noof_Family_Members_to_Meet_Family_MOOP__c, a.Name, a.MOOP_Period__c, a.MOOP_Dedictible_Amount__c, a.MAB_Period__c, a.MAB_Dedictible_Amount__c, a.Is_there_a_Maximum_Out_of_Pocket__c, a.Is_there_a_Maximum_Allowable_Benefit__c,  a.Id, a.Deuductible_Accumulation_from_4th_Qtr__c, a.Deductible_Period__c, a.Deductible_Applies_towards_the_MOOP__c, a.Deductible_Amount__c, a.Carry_Balance_when_member_moves__c, a.CRD_Name__c, a.CRD_ID__c, a.Are_there_any_drug_specific_deductibles__c, a.Are_there_any_drug_specific_MAB__c, a.Are_there_any_drug_specifc_MOOP__c, a.Accum_No__c, a.Accum_Name__c, a.Accum_Code_Deductible__c, a.Accum_Code_Maximum_Allowable_Benefit__c, a.Accum_Code_Maximum_Out_Of_Pocket__c, (Select Id, Name, RecordType.Name, Drug_List__c, Drug_List__r.Name, Drug_List__r.LastSent__c, Drug_List__r.Non_GPI_Non_NDC_Check__c, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Deductible_Amount__c,Exclude_from_Accumulation__c, Deductible_Period__c, Deuductible_Accumulation_from_4th_Qtr__c, M__c, N__c, O__c, Y__c, DAW_Differential_Penalty_Applies_to_MOOP__c, MAB_Dedictible_Amount__c, MAB_Period__c, What_happens_when_MAB_is_met__c, Drug_Group__c, Drug_Group__r.Name, Drug_Group__r.LastSent__c, Accumulations_ID__c, Accumulatoins_Type__c, CRD_ID__c, MOOP_Dedictible_Amount__c, MOOP_Period__c, Deductible_Applies_towards_the_MOOP__c,
            /* Family_Members_to_meet_Family_Deduct__c, Noof_Family_Members_to_Meet_Maximum_MOOP__c,*/
            What_happens_when_MOOP_is_met__c
            From AccumulationDrugLists__r WHERE isDeleted = false)
            From Accumulations__c a
            WHERE a.CRD_ID__c = : crdRecord.Id AND a.isDeleted = false];
            
            //MOOPBypassRecord = [Select CRD_ID__c,MOOP_Bypass_Drug_Group__c,MOOP_Bypass_Drug_Group_Name__c,MOOP_Bypass_Drug_List__c,MOOP_Bypass_Drug_List_Name__c,MOOP_Bypass_Type__c
            //From MOOP_Bypass__c where CRD_ID__c  = : crdRecord.Id AND isDeleted = false ]; Commented By Sushant: Req 04937

            //Loop to fetch Accumulation Id, Drug Group Id by anuj on 09/05/2012
            for (Accumulations__c record: ARecord) {
                accumlationIdSet.add(record.Id);
                for (AccumulationSpecificDrug__c childRecord: record.AccumulationDrugLists__r) {
                    dgIdSet.add(childRecord.Drug_Group__c);
                    dlIdSet.add(childRecord.Drug_List__c);
                }
            }

            accumChangeCopayList = [SELECT Name, RecordType.Name, RecordTypeId, Accumulation_ID__c, Copay_Calculation__c, DAW_Code__c, Dollar_Amount__c, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Percent__c, Reverse__c, Stepped__c, (SELECT Name, Accumulation_Change_Copay_ID__c, Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, Dollar_Amount__c, End_Range__c, Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c, Percent__c, Reverse__c, Type_of_Stepped_Copay__c
            FROM Accumulation_Change_Copays_Stepped__r)
            FROM Accumulation_Change_Copay__c
            WHERE Accumulation_ID__c = : accumlationIdSet];


            /*PRecord = [Select
            c.Term_without_cause__c, c.Specialty_Master_Drug_List__c, c.Specialty_Mail_Default_Disct__c, c.Specialty_Dispensing_Fee__c, c.Specialty_Client_Drug_List__c, c.Spec_Mail_Disc_Basis_Source__c, c.Rx_Pricing__r.Name, c.Rtl_Gen_Eff_Rate_Guar2__c, c.Rtl_Gen_Eff_Rate_Guar1__c, c.Rtl_Gen_Disc_Guar2_ZBDs__c, c.Rtl_Gen_Disc_Guar2_UC__c, c.Rtl_Gen_Disc_Guar2_SSGs__c, c.Rtl_Gen_Disc_Guar2_MAC_Only__c, c.Rtl_Gen_Disc_Guar2_Brnd_MAC__c, c.Rtl_Gen_Disc_Guar1_ZBDs__c, c.Rtl_Gen_Disc_Guar1_UC__c, c.Rtl_Gen_Disc_Guar1_SSGs__c, c.Rtl_Gen_Disc_Guar1_MAC_Only__c, c.Rtl_Gen_Disc_Guar1_Brand_MAC__c, c.Rtl_EDS_Non_Pref_Brnd_Disct__c, c.Rtl_EDS_Non_MAC_Gen_Disct__c, c.Rtl_EDS_Gen_Eff_Rte_Guar1__c, c.Rtl_EDS_Gen_Eff_Rate_Guar2__c, c.Rtl_EDS_Gen_Dispense_Fee__c, c.Rtl_EDS_Gen_Disc_Guar2_ZBDs__c, c.Rtl_EDS_Gen_Disc_Guar2_U_C__c, c.Rtl_EDS_Gen_Disc_Guar2_SSGs__c, c.Rtl_EDS_Gen_Disc_Guar1_U_C__c, c.Rtl_EDS_Gen_Disc_Guar1_SSGs__c, c.Rtl_EDS_Gen_DIsc_Guar1_ZBDs__c, c.Rtl_EDS_GenDiscGuar2_MAC_Only__c, c.Rtl_EDS_GenDiscGuar1_MAC_Only__c, c.Rtl_EDS_GenDiscGuar1_Br_MAC__c, c.Rtl_EDS_GenDIscGuar2_Brnd_MAC__c, c.Rtl_EDS_Custom_MAC_Applies__c, c.Rtl_EDS_Brnd_Eff_Rate_Guar__c, c.Rtl_EDS_Brnd_Dispense_Fee__c, c.Rtl_EDS_Brnd_Disc_Guar_ZBDs__c, c.Rtl_EDS_Brnd_Disc_Guar_U_C__c, c.Rtl_EDS_Brnd_Disc_Guar_SSGs__c, c.Rtl_EDS_Brnd_Disc_Guar_Br_MAC__c, c.Rtl_EDS_Br_Gen_Avl_Apply_MAC__c, c.Rtl_EDS_Adjudicatn_Logic_Mbr__c, c.Rtl_EDS_Adjud_Logic_Mbr__c, c.Rtl_Brnd_Eff_Rate_Guar__c, c.Rtl_Brnd_Disct_Guar_UC__c, c.Rtl_Brnd_Disc_Guar_ZBDs__c, c.Rtl_Brnd_Disc_Guar_SSGs__c, c.Rtl_Brnd_Disc_Guar_Brnd_MAC__c, c.Rtl_Adjudicatn_Logic_Mbr__c, c.Rtl_EDS_Adjud_Logic_Client__c, c.Rtl_Adjudicatn_Logic_Client__c, c.Retail_Pricing_End_Date__c, c.Retail_Pricing_Effective_Date__c, c.Retail_Price_Type__c, c.Retail_Non_Preferred_Brand_Discount__c, c.Retail_Brand_Discount__c, c.Retail_Non_MAC_Generic_Discount__c, c.Retail_MAC_Percent__c, c.Retail_MAC_Percent2__c, c.Retail_MAC_List_ID__c, c.Retail_MAC_List_ID2__c, c.Retail_MAC_Applies__c, c.Retail_Guar_Recon_Method__c, c.Retail_Guar_Recon_Freq__c, c.Retail_Generic_Flat_Discount__c, c.Retail_Generic_Dispensing_Fee__c, c.Retail_EDS_Pref_Brnd_Disct__c, c.Retail_EDS_Ntwk_35_DS__c, c.Retail_EDS_MAC_Percent__c, c.Retail_EDS_MAC_List_ID__c, c.Retail_EDS_MAC_Applies__c, c.Retail_EDS_Guar_Recon_Method__c, c.Retail_EDS_Guar_Recon_Freq__c, c.Retail_EDS_Gen_Flat_Disct__c, c.Retail_EDS_Brand_Disct__c, c.Retail_Discount_Basis__c, c.Retail_Custom_MAC_List_ID__c, c.Retail_Custom_MAC_Applies__c, c.Retail_Brand_Dispensing_Fee__c, c.Platform__c, c.PSUnique_ID__c, c.Other_Retail_Disc_Guar_Prov__c, c.Other_Mail_Disc_Guar_Prov__c, c.Oth_Rtl_EDS_Disc_Guar_Prov__c, c.Name, /*c.Medical_Benefit_Option__c, */ /*c.Maintenance_Choice_Applies__c, c.Mail_Pricing_End_Date__c, c.Mail_Pricing_Effective_Date__c, c.Mail_Price_Type__c, c.Mail_Pref_Brand_Disct__c, c.Mail_Non_Pref_Brand_Disct__c, c.MAC_Effective_Date__c, c.Mail_Non_MAC_Gen_Disct__c, c.Mail_MAC_Percent__c, c.Mail_MAC_Percent2__c, c.Mail_MAC_List_ID__c, c.Mail_MAC_List_ID2__c, c.Mail_MAC_Applies__c, c.Mail_Guarantee_Recon_Freq__c, c.Mail_Guaranatee_Recon_Method__c, c.Mail_Generic_Flat_Disct__c, c.Mail_Generic_Dispnse_Fee__c, c.Mail_Gen_Eff_Rate_Guar_2__c, c.Mail_Gen_Eff_Rate_Guar_1__c, c.Mail_Gen_Disc_Guar2_ZBDs__c, c.Mail_Gen_Disc_Guar2_UC__c, c.Mail_Gen_Disc_Guar2_SSGs__c, c.Mail_Gen_Disc_Guar2_MAC_Only__c, c.Mail_Gen_Disc_Guar2_Brnd_MAC__c, c.Mail_Gen_Disc_Guar1_ZBDs__c, c.Mail_Gen_Disc_Guar1_UC__c, c.Mail_Gen_Disc_Guar1_SSGs__c, c.Mail_Gen_Disc_Guar1_MAC_Only__c, c.Mail_Gen_Disc_Guar1_Brnd_MAC__c, c.Mail_Discount_Basis__c, c.Mail_Brnd_Disc_Guar_ZBDs__c, c.Mail_Brnd_Disc_Guar_UC__c, c.Mail_Brnd_Disc_Guar_SSGs__c, c.Mail_Brnd_Disc_Guar_Brnd_MAC__c, c.Mail_Brand_Eff_Rate_Guar__c, c.Mail_Brand_Dispense_Fee__c, c.Mail_Brand_Discount__c, c.Mail_Adjudicatn_Logic_Mbr__c, c.Mail_Adjudicatn_Logic_Client__c, c.MOEL_ID__c, c.MOEL_Applies__c, c.Id, c.Escalating_Pricing__c, c.Early_Pricing__c, c.Dys_written_notice_bfr_term__c, c.Contract_Terms__c, c.Contract_Term_Year__c, c.Contract_End_Date__c, c.Contract_Effective_Date__c, c.Consultant__c, c.Competitive_Mkt_Check_Clause__c, c.Client_Audit_of_Rtl_Rx_Cntracts__c, c.Brnd_Drug_Gen_Avail_Apply_MAC__c, c.Base_Retail_Network_Name__c, c.Standard_or_Custom_Pricing__c
            From CRD_Pricing__c c
            WHERE c.Id = : crdRecord.CRD_Pricing__c AND isDeleted = false]; Richa commenetd the query for Req 4882*/

            rcjRecord = [Select
            r.Name, r.Selected__c, r.RxCheck__r.Description__c, r.RxCheck__c, r.RxCheck_Program_Name__c, r.RxCheck__r.Name
            From RxCheck_Junction__c r
            WHERE r.CRD__c = : crdRecord.Id AND r.Selected__c = TRUE AND isDeleted = false];

            pspjRecord = [Select
            p.Selected__c, p.Prescription_Savings_Program_Drug_Class__c, p.PSP_ID__r.Description__c, p.PSP_ID__r.CVS_Caremark_Drug_List_ID__c, p.PSP_ID__r.Clinical_Programs_Name__c, p.PSP_ID__r.Name, p.Name
            From PSP_Junction__c p
            WHERE p.CRD_ID__c = : crdRecord.Id AND p.Selected__c = TRUE AND isDeleted = false];

            sacRecord = [Select
            s.Selected__c, s.Save_A_Copay_ID__r.Description__c, s.Save_A_Copay_ID__r.Clinical_Programs_Name__c, s.Save_A_Copay_ID__r.Letter_Description__c, /*s.Save_A_Copay_ID__r.SAC_Letter_Templates__r.CVS_Caremark_Stellant_ID__c,*/ s.Save_A_Copay_ID__r.SAC_Campaign_ID__c, s.Save_A_Copay_ID__r.of_months_for_Copay_Waiver__c, s.Save_A_Copay_ID__c, s.Save_A_Copay_ID__r.CVS_Caremark_Drug_List_ID__c, s.Save_A_Copay_Drug_Class__c, s.Save_A_Copay_ID__r.Name, s.Name,Save_A_Copay_ID__r.SAC_Letter_Templates__r.name
            From Save_A_Copay_Junction__c s
            WHERE s.CRD_ID__c = : crdRecord.Id AND s.Selected__c = TRUE AND isDeleted = false];

            stjRecord = [Select
            c.Step_Therapy_Drug_Class__c, c.Step_Therapy_DrugList_Class__r.Drug_List_Name__c, c.Step_Therapy_DrugList_Class__r.Name, c.Step_Therapy_DrugList_Class__r.LastSent__c, c.Step_Therapy_DrugList_Class__r.CVS_Caremark_Drug_List_ID__c, c.Step_Therapy_DrugList_Class__r.Description__c, c.Step_Therapy_DrugList_Class__c, c.Name
            From CRD_Step_Therapy_Junction__c c
            WHERE c.CRD_ID__c = : crdRecord.Id AND isDeleted = false];

            pajRecord = [Select
            c.Precert_Class__r.Drug_List_Name__c, c.Precert_Class__r.Description__c, c.Precert_Class__c, c.Precert_Class__r.Name, c.Precert_Class__r.LastSent__c, c.Precert_Class__r.CVS_Caremark_Drug_List_ID__c
            From CRD_PriorAuth_Junction__c c
            WHERE c.CRD_ID__c = : crdRecord.Id AND isDeleted = false];

            qljRecord = [Select
            c.QL_Class__r.Name, c.QL_Class__r.Drug_List_Name__c, c.QL_Class__r.Description__c, c.QL_Class__c, QL_Class__r.LastSent__c, QL_Class__r.CVS_Caremark_Drug_List_ID__c
            From CRD_Quantity_Limit_Junction__c c
            WHERE c.CRD_ID__c = : crdRecord.Id AND isDeleted = false];

            //cvsRecord = [Select c.Web_Acces_User_Name__c, c.SystemModstamp, c.RxNav__c, c.OwnerId, c.Name, c.Last_4_digits_of_SSN__c, c.Id, c.Client_Access__c, c.Client_Acces_Security__c From CVS_Web_Access_Users__c c WHERE c.CRD_ID__c = : crdRecord.Id AND isDeleted = false]; Commented by Sushant: Req 04937

            DAWRecordList = [SELECT Name, Cloned_From__c, Copay_Calculation__c, CRD_ID__c, DAW_Code__c, Dollar_Amount__c, LastSent__c, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Percent__c, Reverse__c, Stepped__c, SteppedCopayCount__c, (select Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, Name, DAW_Specific_Copay_ID__c, DAW_Specific_Copay_ID__r.name, Dollar_Amount__c, End_Range__c, LastSent__c, Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c, Percent__c,Reverse__c, Stepped_CoPay_Type__c
            from DAW_Specific_Stepped_Copays__r)
            FROM DAW_Specific_Copay__c
            WHERE CRD_ID__c = : crdRecord.Id];

            // FCGRecordList=[SELECT Carrier_ID__c,CAG_Account_ID__c, CAG_Group_ID__c,Contract_State__c FROM Full_Control_Group__c WHERE Id IN (select Full_Control_Group__c from CSAP_CGLP_Junction__c where CRD__c=:crdRecord.Id) ];
            CSAP_CGLPRecordList = [SELECT Name, recordtype.name, Full_Control_Group__r.Carrier_ID__c, Full_Control_Group__r.CAG_Account_ID__c, Full_Control_Group__r.CAG_Group_ID__c, Full_Control_Group__r.Contract_State__c
            from CSAP_CGLP_Junction__c
            where CRD__c = : crdRecord.Id AND recordtype.name = 'CRD to Full CG'];


            cpjGroupRecord = [SELECT Clinical_Program_Group_ID__c, Clinical_Program_Group_ID__r.Name, Clinical_Program_Group_ID__r.LastSent__c, Clinical_Program_Group_ID__r.Clinical_Program_Group_Description__c, Clinical_Program_Group_Name__c, CRD_ID__c, LastSent__c, Record_Type__c, Selected__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdRecord.Id AND Selected__c = true];

            /*cpjRecord = [SELECT Clinical_Program__r.SAC_Letter_Templates__r.CVS_Caremark_Stellant_ID__c, 
Clinical_Program__r.of_months_for_Copay_Waiver__c, 
Clinical_Program__r.SAC_Campaign_ID__c, 
Clinical_Program__r.SAC_Letter_Templates__r.name, 
Clinical_Program__r.Letter_Description__c, 
Clinical_Program_Name__c, 
Clinical_Program_Group_ID__c 
FROM Clinical_Program_Junction__c 
WHERE Clinical_Program_Group__c in 
(SELECT Clinical_Program_Group_ID__c 
FROM Clinical_Program_Group_Junction__c 
WHERE CRD_ID__c = :crdRecord.Id AND Record_Type__c = 'Save-A-Copay' AND Selected__c = TRUE)];*/
            
            mxplRecordList = [Select Id, Name, Max_Pay_Limit__c, Begin_Days_Supply__c, End_Days_Supply__c from Max_Pay_Limitation__c where Max_Pay__c = : crdRecord.Max_Pay__c];

            dljRecordList = [Select Id, Name, Inactive__c, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Drug_List__c, Drug_List_Name__c, Drug_List_Description__c, Parent_Drug_Group_Name__c, Drug_List__r.Name, Parent_Drug_Group__c, Parent_Drug_Group__r.name from Drug_List_Junction__c where Parent_Drug_Group__c IN: dgIdSet AND Inactive__c = false];
            for (Drug_List_Junction__c record: dljRecordList) {
                dlIdSet.add(record.Drug_List__c);
            }

            for (Clinical_Program_Group_Junction__c record: cpjGroupRecord) {
                cpgIdSet.add(record.Clinical_Program_Group_ID__c);
            }

            cpgRecordList = [Select c.Id, c.Name, (Select Id, Name, Clinical_Program_Group__c, Clinical_Program__c, Clinical_Program__r.CVS_Caremark_Drug_List_ID__c, /*Clinical_Program__r.SAC_Letter_Templates__r.CVS_Caremark_Stellant_ID__c, */Clinical_Program__r.of_months_for_Copay_Waiver__c, Clinical_Program__r.SAC_Campaign_ID__c, Clinical_Program__r.SAC_Letter_Templates__r.name, Clinical_Program__r.Letter_Description__c,Clinical_Program_Description__c, Clinical_Program_Name__c, Clinical_Program_ID__c from Clinical_Program_Junction__r) from Clinical_Program_Group__c c where c.Id IN: cpgIdSet];

            //DCCopayList = [select d.Name, d.Id, d.Copay_Calculation__c, d.CRD_ID__c, d.DAW_Code__c, d.DC_Drug_List_Group_ID__c, d.DC_Drug_List_Group_ID__r.Name, d.Dollar_Amount__c, d.Maximum_Dollar__c, d.Minimum_Dollar__c, d.MS_Code_M__c, d.MS_Code_N__c, d.MS_Code_O__c, d.MS_Code_Y__c, d.Percent__c, d.Reverse__c, d.Stepped__c, d.DC_Drug_List_Group_ID__r.Related_Drug_Coverage__r.Name, (select Id, name, Beginning_Range__c, Copay_Calculation__c, CRD_ID__c, DC_Copay_ID__c, Dollar_Amount__c, End_Range__c, Maximum_Dollar__c, Minimum_Dollar__c, Number_of_Steps__c, Percent__c, Reverse__c, Type_of_Stepped_Copay__c from DC_Copays__r) from DC_Copay__c d where d.DC_Drug_List_Group_ID__c IN: dclist];
            AhaJunctionList = [select Id, Name, CRD_ID__c, Drug_List__c, Drug_List_ID__c, Drug_List_ID__r.CVS_Caremark_Drug_List_ID__c, Drug_List_ID__r.Name, Drug_List_ID__r.Drug_List_Name__c, Selected__c, LastSent__c, Drug_List_ID__r.Description__c from AHA_Junction__c where CRD_ID__c = : crdRecord.Id];
            ARSJunctionList = [select id, name, CRD_Id__c, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Drug_List__c, Drug_Lists__c, LastSent__c, Selected__c, Drug_List__r.Name, Drug_List__r.Drug_List_Name__c from Aetna_RxStep_Junction__c where CRD_ID__c = : crdRecord.Id];
          
          dlRecordList = [SELECT d.Id, d.Name, d.Drug_List_Name__c, d.Description__c, (SELECT Id, Name, Drug_List_Criteria_Description__c, Drug_List_Name__c, Drug_List__r.Name, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Drug_List__r.Drug_List_Name__c, Drug_List__r.Description__c, RecordType.Name, Effective__c, Term__c, Drug_Type_Code__c, Drug_Code_Value__c, Description_of_NDC_Drug_List_Criteria__c, NDC__c, Status__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Rx__c, /*OTC__c,*/ Repack__c, DESI__c, Maintenance__c, Non_Maintenance__c, Route__c, DAW_Code__c, Unit_Cost__c, Force_to_Specialty__c, X100_Copay__c, Zero_Copay__c, Excluded_from_Deductible__c, Funding__c, Prescriber__r.Name, Prescriber_Name__c, Prescriber_Description__c, Provider__r.Name, Provider_Name__c, Provider_Descriptoin__c, Allow_Transition_Fill__c,TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c,Speciality__r.Name, Specialty_Name__c, Specialty_Description__c, Lab_Tests__r.Name, Lab_Tests_Name__c, Lab_Test_Description__c, Diagnosis__r.Name, Diagnosis_Name__c, Diagnosis_Description__c, Start_Age__c, Start_Age_Type__c, End_Age__c, End_Age_Type__c, Gender__c, Grandfathering__c, Message__c, Transition_of_Care__c, Maximum_Days__c, Maximum_Quantity__c, Minimum_Days__c, Minimum_Quantity__c, Rule__c, Maximum_Dollars__c, Maximum_Fills__c, Daily_Dose__c, Max_Days_per_Fill__c, Max_Quantity_per_Fill__c, Days_over_Time_of_Days__c, Days_over_Time_Time_Period__c, Days_over_Time_Time_Value__c, Quantity_over_Time_Quantity__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Time_Value__c, Message_Action__c, Inactive__c
            FROM Drug_List_Search__r
            WHERE Inactive__c = false)
            FROM Drug_List__c d
            WHERE d.Id IN: dlIdSet AND d.Non_GPI_Non_NDC_Check__c = true];
            if (crdRecord.Concurrent_DUR_ID__c != null) {
                /* added by rakesh - 2012-9-12 */
                concDURCP = [SELECT
                Name, LastSent__c, CVS_Caremark_DUR_ID__c, Clinical_Programs_Name__c, Description__c, RecordType.Name, Maximum_Conflicts_per_Prescription__c, History_Window__c, Gender_Priority__c, Gender_Contraindication__c, Severity_Major_Priority__c, Severity_Major_Other_Pharmacy__c, Severity_Major_Same_Pharmacy__c, Severity_Moderate_Priority__c, Severity_Moderate_Other_Pharmacy__c, Severity_Moderate_Same_Pharmacy__c, Severity_Minor_Priority__c, Severity_Minor_Other_Pharmacy__c, Severity_Minor_Same_Pharmacy__c, Extend_Historical_Days_Supply__c, Duplicate_Rx_Therapy_Same_Pharmacy__c, Duplicate_Rx_Therapy_Other_Pharmacy__c, Slow_Consumption_Assumption__c, Onset__c, Documentation_Level__c, Duplicate_Therapy_Priority__c, Duplicate_Exact_GPI_Priority__c, Duplicate_Exact_GPI_Other_Pharmacy__c, Duplicate_Exact_GPI_Same_Pharmacy__c, Therapeutic_Overlap_Allowed__c, Therapeutic_Overlap_Allowed_Days__c, Adjust_Historical_Days_Supply__c, Drug_Regimen_Priority__c, Minimum_Days_for_Inclusion__c, Days_below_per_fill__c, Maximum_days_below_fill_for_life_of_Rx__c, Include_Maintenance_Drugs__c, Inferred_Disease_Priority__c, Indication_Level__c, Inferred_Disease_Contradiction_Level__c, Historical_Days_Extension__c, Dosing_Priority__c, Dosage_info_not_available__c, Pediatric_dosage_not_available__c, Geriatrics_dosage_info_not_available__c, Dosage_Thresholds__c, Duration_of_therapy__c, Drug_Age_Priority__c, Drug_Age_Contraindication_Level__c, Controlled_Substance_Priority__c, History_Check_Days__c, Claim_Threshold__c, Conflict_Code_Drug_Age__r.Name, Conflict_Code_Drug_Age__r.Conflict_Code_List_Name__c, Conflict_Code_Drug_Age__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_Age__r.RecordType.Name, Conflict_Code_Drug_Age__r.Termination_Date__c, Conflict_Code_Drug_Age__r.Effective_Date__c, Conflict_Code_Drug_Disease__r.Name, Conflict_Code_Drug_Disease__r.Conflict_Code_List_Name__c, Conflict_Code_Drug_Disease__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_Disease__r.RecordType.Name, Conflict_Code_Drug_Disease__r.Termination_Date__c, Conflict_Code_Drug_Disease__r.Effective_Date__c, Conflict_Code_Drug_to_Drug_Interaction__r.Name, Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Name__c, Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_to_Drug_Interaction__r.RecordType.Name, Conflict_Code_Drug_to_Drug_Interaction__r.Termination_Date__c, Conflict_Code_Drug_to_Drug_Interaction__r.Effective_Date__c, Conflict_Code_Duplicate_Therapy__r.Name, Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Name__c, Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Description__c, Conflict_Code_Duplicate_Therapy__r.RecordType.Name, Conflict_Code_Duplicate_Therapy__r.Termination_Date__c, Conflict_Code_Duplicate_Therapy__r.Effective_Date__c, Conflict_Code_High_Dose__r.Name, Conflict_Code_High_Dose__r.Conflict_Code_List_Name__c, Conflict_Code_High_Dose__r.Conflict_Code_List_Description__c, Conflict_Code_High_Dose__r.RecordType.Name, Conflict_Code_High_Dose__r.Termination_Date__c, Conflict_Code_High_Dose__r.Effective_Date__c,

                Codes_Drug_Age__r.Name, Codes_Drug_Age__r.Code_List_Name__c, Codes_Drug_Age__r.Code_List_Description__c, Codes_Drug_Age__r.Effective_Date__c, Codes_Drug_Age__r.Termination_Date__c, Codes_Drug_Disease__r.Name, Codes_Drug_Disease__r.Code_List_Name__c, Codes_Drug_Disease__r.Code_List_Description__c, Codes_Drug_Disease__r.Effective_Date__c, Codes_Drug_Disease__r.Termination_Date__c, Codes_Drug_to_Drug_Interaction__r.Name, Codes_Drug_to_Drug_Interaction__r.Code_List_Name__c, Codes_Drug_to_Drug_Interaction__r.Code_List_Description__c, Codes_Drug_to_Drug_Interaction__r.Effective_Date__c, Codes_Drug_to_Drug_Interaction__r.Termination_Date__c, Codes_Duplicate_Therapy__r.Name, Codes_Duplicate_Therapy__r.Code_List_Name__c, Codes_Duplicate_Therapy__r.Code_List_Description__c, Codes_Duplicate_Therapy__r.Effective_Date__c, Codes_Duplicate_Therapy__r.Termination_Date__c, Codes_High_Dose__r.Name, Codes_High_Dose__r.Code_List_Name__c, Codes_High_Dose__r.Code_List_Description__c, Codes_High_Dose__r.Effective_Date__c, Codes_High_Dose__r.Termination_Date__c,

                RxCheck_Effective_Date__c, RxCheck_Termination_Date__c, Adjust_Historical_Rx_Days_Supply__c, Dosing_Response__c, Drug_Age_Response__c, Drug_Regimen_Response__c, Duplicate_Rx_Therapy_Priority__c, Duplicate_Therapy_Response__c, Duplicate_Therapy_Same_Pharmacy_Response__c, Duplications_to_Report__c, Gender_Response__c, Inferred_Disease_Contraindication_Priori__c, Inferred_Disease_Response__c, Member_ID_Level__c, SBM_Date_of_Birth__c, SBM_Person_Code__c, SBM_Sex_Code__c, Severity_Major_Documentation_Level__c, Severity_Major_Onset__c, Severity_Major_Status__c, Severity_Minor_Documentation_Level__c, Severity_Minor_Onset__c, Severity_Minor_Status__c, Severity_Moderate_Documentation_Level__c, Severity_Moderate_Onset__c, Severity_Moderate_Status__c, Severity_None_Documentation_Level__c, Severity_None_Onset__c, Severity_None_Other_Pharmacy__c, Severity_None_Priority__c, Severity_None_Same_Pharmacy__c, Severity_None_Status__c, Significance_Level__c, of_Days_Therapeutic_Overlap_Allowed__c, Therapeutic_Overlap_Allowed_DT__c, Controlled_Substance_Response__c
                FROM Clinical_Program__c WHERE Id = : crdRecord.Concurrent_DUR_ID__c];
            }
            Set < Id > conflictCodeListIdSet = new Set < Id > ();
            conflictCodeListIdSet.add(concDURCP.Conflict_Code_Drug_Age__c);
            conflictCodeListIdSet.add(concDURCP.Conflict_Code_Drug_Disease__c);
            conflictCodeListIdSet.add(concDURCP.Conflict_Code_Drug_to_Drug_Interaction__c);
            conflictCodeListIdSet.add(concDURCP.Conflict_Code_Duplicate_Therapy__c);
            conflictCodeListIdSet.add(concDURCP.Conflict_Code_High_Dose__c);


            conflictCodesListList = [SELECT Name, RecordType.Name, Conflict_Codes__c, Effective_Date__c, Termination_Date__c, GPI__c, Related_GPI__c, Age__c, Clinical_Program__c, Codes__c, CreatedById, CreatedDate, DUR_Message__c, Daily_Dose__c, Days_to_Review__c, IsDeleted, Diagnosis_Code__c, LastModifiedById, LastModifiedDate, LastSent__c, Operator__c, Overlap_Percent__c, OwnerId, ConnectionReceivedId, Id, Related_Conflict_Code_List__c, ConnectionSentId, Value__c
            FROM Conflict_Codes__c
            WHERE Related_Conflict_Code_List__c IN: conflictCodeListIdSet];

            Set < Id > codesIdSet = new Set < Id > ();
            codesIdSet.add(concDURCP.Codes_Drug_Age__c);
            codesIdSet.add(concDURCP.Codes_Drug_Disease__c);
            codesIdSet.add(concDURCP.Codes_Drug_to_Drug_Interaction__c);
            codesIdSet.add(concDURCP.Codes_Duplicate_Therapy__c);
            codesIdSet.add(concDURCP.Codes_High_Dose__c);

            codesList = [SELECT Name, Related_Code_List__c, RecordType.Name, Professional__c, Result_of_Service_Codes__c
            FROM Codes__c
            WHERE Related_Code_List__c IN: codesIdSet];


            maxPayLimitList = [SELECT Name, Begin_Days_Supply__c, End_Days_Supply__c, Max_Pay_Limit__c, Max_Pay__r.Name FROM Max_Pay_Limitation__c WHERE Max_Pay__c = : crdRecord.Compound_Max_Pay__c];
            ahoJunctionList = [SELECT Aetna_RxHealthy_Outcomes_Drug_List__c, CRD_ID__c, LastSent__c, Selected__c, Aetna_RxHealthy_Outcomes_Drug_List__r.Name, Aetna_RxHealthy_Outcomes_Drug_List__r.CVS_Caremark_Drug_List_ID__c, Aetna_RxHealthy_Outcomes_Drug_List__r.Drug_List_Name__c, Aetna_RxHealthy_Outcomes_Drug_List__r.Description__c
            FROM Aetna_RxHealthy_Outcomes_Junction__c
            WHERE CRD_ID__c = : crdRecord.Id AND Selected__c = TRUE];
            
            crdNPLJuncList = [Select Drug_List__c, Drug_List__r.Name, Drug_List__r.LastSent__c, Drug_List__r.CVS_Caremark_Drug_List_ID__c, Drug_List_Description__c, Drug_List_Name__c, IsStandard__c FROM CRD_NPL_Junction__c WHERE CRD_ID__c = : crdRecord.Id];
 
        }
        /* 
         * Method :- PageReference
         * Description :- This method transfer current page to case detail page after generating xml for specified object
         */  
            public PageReference generateXML() {
            String CID = generateCaseAndXML();
            String urlStr = '/' + String.valueOf(cId)+'/e?retURL='+String.valueOf(cId);
            PageReference MyObjectPR = new
            PageReference(urlStr);

            //updating the CRD Status
            crdRecord.Status__c = 'XML & Case Generated. CRD Complete.';
            //updating the record for custom history tracking.
            crdRecord.LastSent__c = system.Now();
            crdRecord.XMLDate_Time_Stamp__c = system.now();
            update crdRecord;

            return MyObjectPR;
        }
        /*Method :- To Create XML and Attachment
          Description :- This method creates the Case, inserts XML and returns the Case Id.
        */
        Public string generateCaseAndXML(){
        
            w.writeStartDocument(null, '1.0');
            w.writeComment('CRD Section');
            w.writeStartElement(null, 'CRD', null);
            writeXMLElement('CRD-XMLVersion', String.valueOf('4.4'));
            writeXMLElement('XMLDate-TimeStamp', String.valueOf(system.now()));
            writeXMLElement('CRDID', String.valueOf(crdRecord.Name));
            writeXMLElement('CRDCreateDate', String.valueOf(crdRecord.CreatedDate));
            writeXMLElement('CRDLastModified', String.valueOf(crdRecord.LastModifiedDate));
            writeXMLElement('TPID', String.valueOf(crdRecord.TP_ID__c));
            //commented by Nitish Request no 04888
           // writeXMLElement('RXPPID', String.valueOf(crdRecord.Rx_PP_ID__c));
            w.writeComment('Client Information');
            writeXMLElement('RxPlanID', String.valueOf(crdRecord.RxPlanID__c));
            writeXMLElement('OldRxPlanID', String.valueOf(crdRecord.Old_RxPlan_ID__c));
            writeXMLElement('BPERxPlanID', String.valueOf(crdRecord.BPERxPlan_ID__c));
            writeXMLElement('MigrationRunNumber', String.valueOf(crdRecord.Migration_Run_Number__c));
            writeXMLElement('PlanDescription', String.valueOf(crdRecord.Plan_Description__c));
            writeXMLElement('Account', String.valueOf(crdRecord.Account__r.Name));
            writeXMLElement('Account_ID_PSU', String.valueOf(crdRecord.PSU__c));
            writeXMLElement('HighPriorityComments', String.valueOf(crdRecord.High_Priority_Comments__c));
            writeXMLElement('WhatIsTheCarrier', String.valueOf(crdRecord.Plan_Platform__c));
            writeXMLElement('Segment', String.valueOf(crdRecord.National__c));
            writeXMLElement('Does3MonthGracePeriodApply', String.valueof(crdRecord.Does_3_Month_Grace_Period_Apply__c));             
            writeXMLElement('FundingType', String.valueOf(crdRecord.Insured_Type__c));
            writeXMLElement('CRDRiskIndicator', String.valueOf(crdRecord.CRD_Risk_Indicator__c));
            writeXMLElement('ContractState', String.valueOf(crdRecord.Contract_state__c));
            /*commened as per request 06665
            writeXMLElement('CA50PerCostShareApplies',String.valueof(crdRecord.CA_50_Cost_Share_Applies__c));*/
            /*//Added custom Lable CA50PerCostShareApplies as per request 06665*/
            writeXMLElement('CA50PerCostShareApplies', String.valueOf(System.Label.CA50PerCostShareApplies));   
            writeXMLElement('PlanType_Retail', String.valueOf(crdRecord.Plan_Type_Retail__c));
            writeXMLElement('PlanType_Mail', String.valueOf(crdRecord.Plan_Type_Mail__c));
            writeXMLElement('PlanType_Paper', String.valueOf(crdRecord.Plan_Type_Paper__c));
            writeXMLElement('PlanTypePaperOutofNetwork', String.valueOf(crdRecord.Plan_Type_Paper_Out_of_Network__c));
            writeXMLElement('PlanType_Specialty', String.valueOf(crdRecord.Plan_Type_Specialty__c));
            writeXMLElement('PlanTypeSpecialtyOON', String.valueOf(crdRecord.Plan_Type_Specialty_OON__c));   
            writeXMLElement('HighValueClient', String.valueOf(crdRecord.High_Value_Client__c));
            writeXMLElement('PreImplementationAudit', String.valueOf(crdRecord.Pre_Implementation_Audit__c));
            writeXMLElement('VendorTransitionFiles', String.valueOf(crdRecord.Vendor_Transition_Files__c));
            writeXMLElement('MedicalPlatformToInstallPlan', String.valueOf(crdRecord.Which_system_will_the_plan_be_installed__c));
            //writeXMLElement('IntegratedAccumsWMedical', String.valueOf(crdRecord.Integrate_with_Medical__c));
            //writeXMLElement('MedicalInjectibleClaimDenialProcess', String.valueOf(crdRecord.Medical_Injectible_Claim_Denial_Process__c));
            writeXMLElement('WaiveDeductibleForTier1Drugs', String.valueof(crdrecord.Waive_Deductible_for_Tier_1_Drugs__c));
            writeXMLElement('PlanEffectiveDate', String.valueOf(crdRecord.Effective_Start_Date__c));
            writeXMLElement('CarrierNumber', String.valueOf(crdRecord.Carrier_Number__c));
            writeXMLElement('RetailYSchedule', String.valueOf(crdRecord.Y_Schd__c));
            writeXMLElement('MailYSchedule', String.valueOf(crdRecord.Mail_Y_Schedule__c));
            writeXMLElement('StandardFullyInsuredPricing', String.valueOf(crdRecord.Standard_Fully_Insured_Pricing__c));//Richa added for 04871
            //Added by JR to implement request no 4525
            writeXMLElement('MacatMailApplies', String.valueOf(crdRecord.Mac_at_Mail_Applies__c));
            writeXMLElement('BrandPenaltyException', String.valueOf(crdRecord.Brand_Penalty_Exception__c));
            writeXMLElement('TieringFormularyException', String.valueOf(crdRecord.Tiering_Formulary_Exception__c));
            writeXMLElement('GlobalBenefitExclusion', String.valueOf(crdRecord.Global_Benefit_Exclusion__c));
           //writeXMLElement('IsthisanHDHPPlan', String.valueOf(crdRecord.Is_this_an_HDHP_Plan__c));
           //writeXMLElement('ChronicPreventiveDrugList', String.valueOf(crdRecord.Chronic_Preventive_Drug_List__r.name));
           //writeXMLElement('ChronicandorPreventiveList', String.valueOf(crdRecord.Chronic_and_or_Preventive_List__c));
           //writeXMLElement('WaiverofRxDeductible', String.valueOf(crdRecord.Waiver_of_Rx_Deductible__c));
          // writeXMLElement('WhatistheHDHPfundtype', String.valueOf(crdRecord.What_is_the_HDHP_fund_type__c));
          //commented as per request 06664 
             writeXMLElement('OONCostShareNotGreater', String.valueOf(crdRecord.OON_Cost_Share_Not_Greater_50_Drug_Cost__c));           
            
            
            w.writeComment('Customer Care Attributes Section');
           // writeXMLElement('CustomerCareImplementsDate', String.valueOf(crdRecord.Implementations_Date__c));
          //  writeXMLElement('PlanHaveAnOpenEnrollmentDate', String.valueOf(crdRecord.Does_plan_have_an_Open_Enrollment_Date__c));
           // writeXMLElement('OpenEnrollmentDate', String.valueOf(crdRecord.Open_Enrollment_Date__c));
           // writeXMLElement('PlanNeedAPrivateLabelGreeting', String.valueOf(crdRecord.Need_Private_Label_Greeting__c));
            //writeXMLElement('IVRRoutingDuringOpenEnrolment', String.valueOf(crdRecord.IVR_Routing_during_Open_Enrollment__c));
          //  writeXMLElement('SensitiveClient', String.valueOf(crdRecord.Sensitive_Client__c));

            w.writeComment('Overrides Section');
            writeXMLElement('WhoProcessesPAOrOverride', String.valueOf(crdRecord.Who_processes_PA_or_Override__c));
            writeXMLElement('Vacation', String.valueOf(crdRecord.Vacation__c));
            writeXMLElement('ParticipLostStolenDamagedMeds', String.valueOf(crdRecord.Participant_Lost_Stolen_Damaged_Meds__c));
            writeXMLElement('MailOrderDelay', String.valueOf(crdRecord.Mail_Order_Delay__c));
            writeXMLElement('MaximumDollar', String.valueOf(crdRecord.Maximum_Dollar__c));
            writeXMLElement('DosageIncreaseChange', String.valueOf(crdRecord.Dosage_Increase_Change__c));
            writeXMLElement('MultipleBirths', String.valueOf(crdRecord.Multiple_Births__c));
            writeXMLElement('RtlRefillManufactureBackOrder', String.valueOf(crdRecord.Retail_refill_for_Manufacture_Back_Order__c));
            writeXMLElement('DoseOptimization', String.valueOf(crdRecord.Dose_Optimization__c));
            writeXMLElement('DuplicateTherapy', String.valueOf(crdRecord.Duplicate_Therapy__c));
            writeXMLElement('IncorrectDaysSupply', String.valueOf(crdRecord.Incorrect_Days_Supply__c));
            writeXMLElement('AnnualFillLimitAllowedLimit', String.valueOf(crdRecord.Annual_Fill_Limit_Allowed_Limit__c));
            writeXMLElement('NursingHome', String.valueOf(crdRecord.Nursing_Home__c));
            writeXMLElement('SpecialtyRetailLockOut', String.valueOf(crdRecord.Specialty_Retail_Lock_Out__c));
            writeXMLElement('ParticipantMailInDelay', String.valueOf(crdRecord.Participant_Mail_In_Delay__c));
            writeXMLElement('DisasterEmergency', String.valueOf(crdRecord.Disaster_Emergency__c));
            writeXMLElement('TransitionPlan1override30DS', String.valueOf(crdRecord.Transition_Plan_1_x_override_30DS__c));
            writeXMLElement('MDLOrQVTLimitExceptions', String.valueOf(crdRecord.MDL_or_QVT_Limit_Exceptions__c));
            writeXMLElement('IncludeKitLogic', String.valueOf(crdRecord.Include_Kit_Logic__c));
            writeXMLElement('KitLogicStandardDrugList', String.valueOf(crdRecord.Kit_Logic_Standard_Drug_List__r.Name));
            writeXMLElement('KitLogicStandardDrugListLastSent', String.valueOf(crdRecord.Kit_Logic_Standard_Drug_List__r.LastSent__C));
            writeXMLElement('KitLogicCVSCaremarkDrugListID', '');
            writeXMLElement('GPISystemDrugList', String.valueOf(crdRecord.GPI_System_Drug_List__r.Name));
            writeXMLElement('GPISystemDrugListLastSent', String.valueOf(crdRecord.GPI_System_Drug_List__r.LastSent__c));
            writeXMLElement('GPISystemDLCVSCaremarkDLID', '');
            writeXMLElement('NDCSystemDrugList', String.valueOf(crdRecord.NDC_System_Drug_List__r.Name));
            writeXMLElement('NDCSystemDrugListLastSent', String.valueOf(crdRecord.NDC_System_Drug_List__r.LastSent__c));
            writeXMLElement('NDCSystemDLCVSCaremarkDLID', '');
            writeXMLElement('GenericCodeConversionID', String.valueOf(crdRecord.Generic_Code_Conversion__r.Name));
            writeXMLElement('GenericCodeConversionLastSent', String.valueOf(crdRecord.Generic_Code_Conversion__r.LastSent__c));
            w.writeComment('Oral Chemo Copay');
            writeXMLElement('ChemoDrugsBypassMAB', String.valueOf(crdRecord.Chemo_Drugs_Bypass_MAB__c));
            writeXMLElement('ChemoDrugsBypassOOP', String.valueOf(crdRecord.Chemo_Drugs_Bypass_OOP__c));
            writeXMLElement('ChemoDrugsBypassDeductible', String.valueOf(crdRecord.Chemo_Drugs_Bypass_Deductible__c));
            writeXMLElement('ChemoDrugsInNetworksameasOutOfNetwork', String.valueOf(crdRecord.Chemo_Drugs_In_Network_same_as_OON__c));
            writeXMLElement('DoesChemoParityApply', String.valueOf(crdRecord.Does_Chemo_Parity_Apply__c));
            writeXMLElement('ChemoParityDrugList', String.valueOf(crdRecord.Chemo_Parity_Drug_List__r.Name));
            writeXMLElement('DollarAmount', String.valueOf(crdRecord.Dollar_Amount__c));
            writeXMLElement('Percent', String.valueOf(crdRecord.Percent__c));
            writeXMLElement('CopayCalculation', String.valueOf(crdRecord.Copay_Calculation__c));
            writeXMLElement('OralChemoCap', String.valueOf(crdRecord.Oral_Chemo_Cap__c));
            w.writeComment('Copay Section');
            writeXMLElement('RetailNumberOfTiers', String.valueOf(crdRecord.Retail_Number_of_Tiers__c));
            writeXMLElement('AnyDrugSpecificRetailCopays', String.valueOf(crdRecord.Any_drug_specific_Retail_copays__c));
            writeXMLElement('MailNumberOfTiers', String.valueOf(crdRecord.Mail_Number_of_Tiers__c));
            writeXMLElement('AnyDrugSpecificMailCopays', String.valueOf(crdRecord.Any_drug_specific_Mail_copays__c));
            writeXMLElement('PaperNumberOfTiers', String.valueOf(crdRecord.Paper_Number_of_Tiers__c));
            writeXMLElement('AnyDrugSpecificPaperCopays', String.valueOf(crdRecord.Any_drug_specific_Paper_copays__c));
            writeXMLElement('SpecialtyNumberOfTiers', String.valueOf(crdRecord.Specialty_Number_of_Tiers__c));
            writeXMLElement('DrugSpecificSpecialtyCopays', String.valueOf(crdRecord.Any_drug_specific_Specialty_copays__c));
            writeXMLElement('BrandsWDAW5GenericCopayRetail', String.valueOf(crdRecord.Brands_DAW_5_take_a_gen_copay_Retail__c));
            writeXMLElement('BrandsWDAW5GenericCopayMail', String.valueOf(crdRecord.Brands_DAW_5_take_a_gen_copay_Mail__c));
            writeXMLElement('BrandsWDAW5GenericCopaySpec', String.valueOf(crdRecord.Brands_DAW_5_take_a_gen_copay_Speciality__c));
            writeXMLElement('BrandsWDAW5GenericCopayPaper', String.valueOf(crdRecord.Brands_DAW_5_take_a_gen_copay_Paper__c));
            writeXMLElement('PaperOutofNetworkCopays', String.valueOf(crdRecord.Is_there_Paper_Out_of_Network__c));
            writeXMLElement('DifferentCopaysFromPaperInNetwork', String.valueOf(crdRecord.Different_copays_from_Paper_In_Network__c));
            writeXMLElement('ApplyPenalty', String.valueOf(crdRecord.Apply_Penalty__c));
            writeXMLElement('PenaltyType', String.valueOf(crdRecord.Penalty_Type__c));
            writeXMLElement('PenaltyAmount', String.valueOf(crdRecord.Penalty_Amount__c));
            writeXMLElement('PercentageApplied', String.valueOf(crdRecord.Percentage_Applied__c));
            writeXMLElement('PaperOutNetworkNumberofTiers', String.valueOf(crdRecord.Paper_Out_of_Network_Number_of_Tiers__c));
            writeXMLElement('AnyDrugSpecificPaperOONCopays', String.valueOf(crdRecord.Any_drug_specific_Paper_Out_of_Network__c));
            writeXMLElement('AnyDAWSpecificPaperOONCopays', String.valueOf(crdRecord.Any_DAW_specific_Paper_OON_copays__c));
            writeXMLElement('BrandswDAW5TakeGenericCopay', String.valueOf(crdRecord.Brands_w_DAW_5_take_a_generic_copay__c));
            //writeXMLElement('CRDPricingName', String.valueOf(crdRecord.CRD_Pricing__r.Name));Richa commented for 4882
            writeXMLElement('DAWspecificSpecialtyOONcopays', String.valueOf(crdRecord.Any_DAW_specific_Specialty_OON_copays__c));
            writeXMLElement('DrugspecificSpecialtyOONcopays', String.valueOf(crdRecord.Any_drug_specific_Specialty_OON_copays__c));
            writeXMLElement('ApplyPenaltytoSpecialtyOON', String.valueOf(crdRecord.Apply_Penalty_to_Specialty_OON__c));
            writeXMLElement('BrandsWDAW5TakeGenericCopaySpe', String.valueOf(crdRecord.Brands_w_DAW_5_take_a_generic_copay_spec__c));
            writeXMLElement('DifferentCopaysfromSpecialty', String.valueOf(crdRecord.Different_Copays_from_Specialty__c));
            writeXMLElement('PenaltyAmountSpecialtyOON', String.valueOf(crdRecord.Penalty_Amount_Specialty_OON__c));
            writeXMLElement('PenaltyTypeSpecialtyOON', String.valueOf(crdRecord.Penalty_Type_Specialty_OON__c));
            writeXMLElement('PercentageAppliedSpecialtyOON', String.valueOf(crdRecord.Percentage_Applied_Specialty_OON__c));
            writeXMLElement('PlanTypeSpecialtyOutofNetwork', String.valueOf(crdRecord.Is_there_Specialty_Out_of_Network__c));
            writeXMLElement('SpecialtyOONNumberofTiers', String.valueOf(crdRecord.Specialty_OON_Number_of_Tiers__c));
            
            

            //Sourabh
            //writeCRDPricingXML(); Richa commented for Req 4882
            //Sourabh
            //write child element for Network Junction
            for (Network_Junction__c record: NJRecord) {
                w.writeComment('NetworkJunction Section');
                w.writeStartElement(null, 'NetworkJunction', null);
                writeXMLElement('NetworkRetail', String.valueOf(record.Network_Retail__c));
                writeXMLElement('RetailCustom', String.valueOf(record.Retail_Custom__r.Name));
                writeXMLElement('DoesClientHaveSuppression', String.valueOf(record.Does_client_have_suppression__c));
                writeXMLElement('NetworkMail', String.valueOf(record.Network_Mail__c));
                writeXMLElement('MailCustom', String.valueOf(record.Mail_Custom__r.Name));
                writeXMLElement('NetworkSpecialty', String.valueOf(record.Network_Specialty__c));
                writeXMLElement('SpecialtyCustom', String.valueOf(record.Specialty_Custom__r.Name));
                writeXMLElement('EnrollInMedvantix', String.valueOf(record.Enroll_in_Medvantix__c));
                writeXMLElement('MedvantixCopayDollarAmount', String.valueOf(record.Medvantix_Copay_Dollar_Amount__c));
               //writeXMLElement('MedvantixCopayPercent', String.valueOf(record.Medvantix_Copay_Percent__c));
               //writeXMLElement('MedvantixCopayCalculation', String.valueOf(record.Medvantix_Copay_Calculation__c));
               //writeXMLElement('MedvantixCopayMaxDollar', String.valueOf(record.Medvantix_Copay_Max_Dollar__c));
               //writeXMLElement('MedvantixCopayMinDollar', String.valueOf(record.Medvantix_Copay_Min_Dollar__c));
                w.writeEndElement();
            } //end of child element


            //Copay Tier Section
            w.writeComment('CopayTier Section');

            for (Copay_Tier__c record: CTRecord) {
                w.writeComment(record.RecordType.Name + 'CopayTier Section');
                w.writeStartElement(null, 'CopayTier', null);
                writeXMLElement('CopayTierID', String.valueOf(record.Name));
                writeXMLElement('RecordType', String.valueOf(record.RecordType.Name));
                writeXMLElement('TierType',String.valueOf(record.Tier_Type__c));
                writeXMLElement('TierName', String.valueOf(record.Tier_Name__c));
                writeXMLElement('Tier', String.valueOf(record.Tier__c));
                writeXMLElement('SteppedCopay', String.valueOf(record.Stepped_Copay__c));
                writeXMLElement('NumberOfSteps', String.valueOf(record.Number_Of_Steps__c));
                writeXMLElement('DollarAmount', String.valueOf(record.Dollar_Amount__c));
                writeXMLElement('Percent', String.valueOf(record.Percent__c));
                writeXMLElement('CopayCalculation', String.valueOf(record.Copay_Calc__c));
                writeXMLElement('MaximumDollar', String.valueOf(record.Max_Dollar__c));
                writeXMLElement('MinimumDollar', String.valueOf(record.Min_Dollar__c));
                writeXMLElement('ReverseCopay', String.valueOf(record.Reverse_Copay__c));
                writeXMLElement('DaysPerFill', String.valueOf(record.Days_Per_Fill__c));

                // stepped Copay
                for (SteppedCopay__c grandRecord: record.SteppedCopays__r) {
                    w.writeComment(record.RecordType.Name + 'SteppedCoPay Section');
                    w.writeStartElement(null, 'SteppedCoPay', null);
                    writeXMLElement('SteppedCopayID', String.valueOf(grandRecord.Name));
                    writeXMLElement('CopayTierID', String.valueOf(record.Name));
                    writeXMLElement('RecordType', String.valueOf(record.RecordType.Name));
                    writeXMLElement('BeginningRange', String.valueOf(grandRecord.Min_Range__c));
                    writeXMLElement('EndRange', String.valueOf(grandRecord.Max_Range__c));
                    writeXMLElement('SteppedCopayType', String.valueOf(grandRecord.Stepped_CoPay_Types__c));
                    writeXMLElement('DollarAmount', String.valueOf(grandRecord.Dollar_Amount__c));
                    writeXMLElement('Percent', String.valueOf(grandRecord.Percent_Amount__c));
                    writeXMLElement('CopayCalculation', String.valueOf(grandRecord.Copay_Calc__c));
                    writeXMLElement('MaximumDollar', String.valueOf(grandRecord.Max_Dollar__c));
                    writeXMLElement('MinimumDollar', String.valueOf(grandRecord.Min_Dollar__c));
                    writeXMLElement('Reverse', String.valueOf(grandRecord.Reverse__c));
                    w.writeEndElement(); // w.writeStartElement(null,'SteppedCoPay', null);
                }

                w.writeEndElement(); // w.writeStartElement(null,'CopayTier', null);
            } //end of child elements
            w.writeComment('DrugSpecificCopays Section');
            //write child elements
            for (Drug_Specific_Copay__c record: DSCRecord) {
                w.writeComment(record.RecordType.Name + 'DrugSpecificCopays Section');
                w.writeStartElement(null, 'DrugSpecificCopay', null);
                writeXMLElement('DrugSpecificCopayID', String.valueOf(record.Name).replace(' ', ''));
                writeXMLElement('RecordType', String.valueOf(record.RecordType.Name));
                writeXMLElement('DrugListID', String.valueOf(record.Drug_List__r.Name));
                writeXMLElement('DrugListLastSent', String.valueOf(record.Drug_List__r.LastSent__c));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('NonGPINonNDCCheck', String.valueOf(record.Drug_List__r.Non_GPI_Non_NDC_Check__c));
                writeXMLElement('DrugGroupID', String.valueOf(record.Drug_Group__r.Name));
                writeXMLElement('DrugGroupLastSent', String.valueOf(record.Drug_Group__r.LastSent__c));
                writeXMLElement('M', String.valueOf(record.M__c));
                writeXMLElement('N', String.valueOf(record.N__c));
                writeXMLElement('O', String.valueOf(record.O__c));
                writeXMLElement('Y', String.valueOf(record.Y__c));
                writeXMLElement('SteppedCopay', String.valueOf(record.Stepped_Copay__c));
                writeXMLElement('DollarAmount', String.valueOf(record.Dollar_Amount__c));
                writeXMLElement('Percent', String.valueOf(record.Percent__c));
                writeXMLElement('CopayCalculation', String.valueOf(record.Copay_Calculation__c));
                writeXMLElement('MaximumDollar', String.valueOf(record.Maximum_Dollar__c));
                writeXMLElement('MinimumDollar', String.valueOf(record.Minimum_Dollar__c));
        writeXMLElement('ReverseCopay', String.valueOf(record.Reverse_Copay__c));
                for (Drug_Specific_Stepped_Copay__c grandRecord: record.Drug_Specific_Stepped_Copay_s__r) {
                    w.writeComment(record.RecordType.Name + 'DrugSpecificSteppedCopays Section');
                    w.writeStartElement(null, 'DrugSpecificSteppedCopays', null);
                    writeXMLElement('DrugSpecificSteppedCopayID', String.valueOf(grandRecord.Name));
                    writeXMLElement('DrugSpecificCopayID', String.valueOf(record.Name));
                    String drugListOrGroup = '';
                    if (null != record.Drug_List__c) {
                        drugListOrGroup = record.Drug_List__r.Name;
                    } else if (null != record.Drug_Group__c) {
                        drugListOrGroup = record.Drug_Group__r.Name;
                    }
                    writeXMLElement('DrugListOrGroup', String.valueOf(drugListOrGroup));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('SteppedCoPayType', String.valueOf(grandRecord.Stepped_CoPay_Type__c));
                    writeXMLElement('BeginningRange', String.valueOf(grandRecord.Beginning_Range__c));
                    writeXMLElement('EndRange', String.valueOf(grandRecord.End_Range__c));
                    writeXMLElement('DollarAmount', String.valueOf(grandRecord.Dollar_Amount__c));
                    writeXMLElement('Percent', String.valueOf(grandRecord.Percent__c));
                    writeXMLElement('CopayCalculation', String.valueOf(grandRecord.Copay_Calculation__c));
                    writeXMLElement('MinimumDollar', String.valueOf(grandRecord.Minimum_Dollar__c));
                    writeXMLElement('MaximumDollar', String.valueOf(grandRecord.Maximum_Dollar__c));
                    writeXMLElement('Reverse', String.valueOf(grandRecord.Reverse__c));
                    w.writeEndElement(); // w.writeStartElement(null,'DrugSpecificSteppedCopays', null);
                }

                w.writeEndElement(); // w.writeStartElement(null,'DrugSpecificCopay', null);
            }


            // DAW Specific Copay
            for (DAW_Specific_Copay__c DAWRecord: DAWRecordList) {
                w.writeComment('DAWSpecificCopaySection');
                w.writeStartElement(null, 'DAWSpecificCopay', null);
                writeXMLElement('DAWSpecificCopayID', String.valueOf(DAWRecord.Name));
                writeXMLElement('DAWCode', String.valueOf(DAWRecord.DAW_Code__c));
                writeXMLElement('MSCodeM', String.valueOf(DAWRecord.MS_Code_M__c));
                writeXMLElement('MSCodeN', String.valueOf(DAWRecord.MS_Code_N__c));
                writeXMLElement('MSCodeO', String.valueOf(DAWRecord.MS_Code_O__c));
                writeXMLElement('MSCodeY', String.valueOf(DAWRecord.MS_Code_Y__c));
                writeXMLElement('Stepped', String.valueOf(DAWRecord.Stepped__c));
                writeXMLElement('CopayCalculation', String.valueOf(DAWRecord.Copay_Calculation__c));
                writeXMLElement('NumberofSteps', String.valueOf(DAWRecord.SteppedCopayCount__c));
                writeXMLElement('DollarAmount', String.valueOf(DAWRecord.Dollar_Amount__c));
                writeXMLElement('Percent', String.valueOf(DAWRecord.Percent__c));
                writeXMLElement('MinimumDollar', String.valueOf(DAWRecord.Minimum_Dollar__c));
                writeXMLElement('MaximumDollar', String.valueOf(DAWRecord.Maximum_Dollar__c));
                writeXMLElement('Reverse', String.valueOf(DAWRecord.Reverse__c));
                //DAW Specific Stepped Copay
                for (DAW_Specific_Stepped_Copay__c DAWSteppedRecord: DAWRecord.DAW_Specific_Stepped_Copays__r) {
                    w.writeComment('DAWSpecificSteppedCopaySection');
                    w.writeStartElement(null, 'DAWSpecificSteppedCopay', null);
                    writeXMLElement('DAWSpecificCopayID', String.valueOf(DAWSteppedRecord.DAW_Specific_Copay_ID__r.name));
                    writeXMLElement('DAWSpecificSteppedCopayID', String.valueOf(DAWSteppedRecord.Name));
                    writeXMLElement('SteppedCopayType', String.valueOf(DAWSteppedRecord.Stepped_CoPay_Type__c));
                    writeXMLElement('BeginningRange', String.valueOf(DAWSteppedRecord.Beginning_Range__c));
                    writeXMLElement('EndRange', String.valueOf(DAWSteppedRecord.End_Range__c));
                    writeXMLElement('DollarAmount', String.valueOf(DAWSteppedRecord.Dollar_Amount__c));
                    writeXMLElement('Percent', String.valueOf(DAWSteppedRecord.Percent__c));
                    writeXMLElement('CopayCalculation', String.valueOf(DAWSteppedRecord.Copay_Calculation__c));
                    writeXMLElement('MinimumDollar', String.valueOf(DAWSteppedRecord.Minimum_Dollar__c));
                    writeXMLElement('MaximumDollar', String.valueOf(DAWSteppedRecord.Maximum_Dollar__c));
                    writeXMLElement('Reverse', String.valueOf(DAWSteppedRecord.Reverse__c));
                    w.writeEndElement(); // w.writeStartElement(null,'DAWSpecificSteppedCopay', null);
                }
                w.writeEndElement(); // w.writeStartElement(null,'DAWSpecificCopay', null);
            }
            //Drug Coverage
            for (Drug_Coverage__c record: DCRecord) {
                w.writeComment(record.RecordType.Name + 'DrugCoverage Section');
                w.writeStartElement(null, 'DrugCoverage', null);
                writeXMLElement('DrugCoverageID', String.valueOf(record.Name));
                writeXMLElement('RecordType', String.valueOf(record.RecordType.Name));
                writeXMLElement('ExceptionDrugGroupID', String.valueOf(record.Exception_Drug_Group__r.Name));
                writeXMLElement('ExceptionDrugGroupLastSent', String.valueOf(record.Exception_Drug_Group__r.LastSent__c));
                writeXMLElement('ExceptionDrugListID', String.valueOf(record.Exception_Drug_List__r.Name));
                writeXMLElement('ExceptionDrugListLastSent', String.valueOf(record.Exception_Drug_List__r.LastSent__c));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('NonGPINonNDCCheck', String.valueOf(record.Exception_Drug_List__r.Non_GPI_Non_NDC_Check__c));
                writeXMLElement('AllowTransitionFill', String.valueOf(record.Allow_Transition_Fill__c));
                writeXMLElement('NumberOfFills', String.valueOf(record.Number_of_fills__c));//Richa added for Req-4811
                writeXMLElement('TransitionFillNumberofDays', String.valueOf(record.Transition_Fill_Number_of_Days__c));
                writeXMLElement('FormularyID', String.valueOf(record.Formulary_ID__c));
                writeXMLElement('FormularyLastSent', String.valueOf(record.Formulary__r.LastSent__c));
                writeXMLElement('CVSFormularyID', String.valueOf(record.Formulary__r.CVS_Caremark_Formulary_ID__c));
                writeXMLElement('FormularyOpenClosed', String.valueOf(record.Formulary_Open_Closed__c));
                writeXMLElement('StandardRefillTooSoonQuestion', String.valueOf(record.Standard_Refill_too_Soon__c));
                writeXMLElement('RefillTooSoonID', String.valueOf(record.Custom_Refill_too_Soon__r.Name));
                writeXMLElement('RefillTooSoonLastSent', String.valueOf(record.Custom_Refill_too_Soon__r.LastSent__c));
                writeXMLElement('DoesDoseLimitapply', String.valueOf(record.Does_Dose_Limit_apply__c));
                writeXMLElement('DoseLimit', String.valueOf(record.Dose_Limit__c));
                writeXMLElement('HigherLowerthan', String.valueOf(record.Higher_Lower_than__c));
                writeXMLElement('DoseLimitExceptionDrugList', String.valueOf(record.Dose_Limit_Exception_Drug_List__r.Name));
                // Sourabh
                //write grand children DC Drug List/Group- Added by Saraag 2/28 #Issue 1475
                w.writeComment('DCDrugListGroup Section');
                for (DC_Drug_List_Group__c chrecord: record.DC_Drug_List__r) {
                    w.writeStartElement(null, 'DCDrugListGroup', null);
                    writeXMLElement('DCDrugListGroupID', String.valueOf(chrecord.Name));
                   // commented by JR to implement 4729
                   // writeXMLElement('DrugClassName', String.valueOf(chrecord.Drug_Class_Name__c));
                    writeXMLElement('DrugGroup', String.valueOf(chrecord.Drug_Group__r.Name));
                    writeXMLElement('DrugGroupName', String.valueOf(chrecord.Drug_Group__r.Drug_Group_Name__c));//Added By Amit
                    writeXMLElement('DrugGroupLastSent', String.valueOf(chrecord.Drug_Group__r.LastSent__c));                   
                    writeXMLElement('DrugList', String.valueOf(chrecord.Drug_List__r.Name));
                    writeXMLElement('DrugListName', String.valueOf(chrecord.Drug_List__r.Drug_List_Name__c));//Added By Amit
                    writeXMLElement('DrugListLastSent', String.valueOf(chrecord.Drug_List__r.LastSent__c));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('NonGPINonNDCCheck', String.valueOf(chrecord.Drug_List__r.Non_GPI_Non_NDC_Check__c));
                    writeXMLElement('AllowTransitionFill', String.valueOf(chrecord.Allow_Transition_Fill__c));
                    writeXMLElement('InclusionExclusion', String.valueOf(chrecord.Inclusion_Exclusion__c));
                    writeXMLElement('InclusionExclusionDrugClass', String.valueOf(chrecord.Inclusion_Exclusion_Drug_Class__c));
                    writeXMLElement('RelatedDrugCoverage', String.valueOf(chrecord.Related_Drug_Coverage__r.Name));

                    writeXMLElement('ApplyLimitations', String.valueOf(chrecord.Apply_Limitations__c));
                    writeXMLElement('StartAge', String.valueOf(chrecord.Start_Age__c));
                    writeXMLElement('StartAgeType', String.valueOf(chrecord.Start_Age_Type__c));
                    writeXMLElement('EndAge', String.valueOf(chrecord.End_Age__c));
                    writeXMLElement('EndAgeType', String.valueOf(chrecord.End_Age_Type__c));
                    writeXMLElement('Gender', String.valueOf(chrecord.Gender__c));
                    writeXMLElement('MaximumDays', String.valueOf(chrecord.Maximum_Days__c));
                    writeXMLElement('MinimumDays', String.valueOf(chrecord.Minimum_Days__c));
                    writeXMLElement('DayQuantityRule', String.valueOf(chrecord.Day_Quantity_Rule__c));
                    writeXMLElement('MinimumQuantity', String.valueOf(chrecord.Minimum_Quantity__c));
                    writeXMLElement('MaximumQuantity', String.valueOf(chrecord.Maximum_Quantity__c));
                    writeXMLElement('Maximum_Dollars', String.valueOf(chrecord.Maximum_Dollars__c));
                    writeXMLElement('Maximum_Fills', String.valueOf(chrecord.Maximum_Fills__c));
                    writeXMLElement('DailyDose', String.valueOf(chrecord.Daily_Dose__c));
                    writeXMLElement('DaysOverTimeofDays', String.valueOf(chrecord.Days_Over_Time_of_Days__c));
                    writeXMLElement('DaysOverTimeTimePeriod', String.valueOf(chrecord.Days_Over_Time_Time_Period__c));
                    writeXMLElement('DaysOverTimeTimeValue', String.valueOf(chrecord.Days_Over_Time_Time_Value__c));
                    writeXMLElement('QuantityOverTimeQuantity', String.valueOf(chrecord.Quantity_Over_Time_Quantity__c));
                    writeXMLElement('QuantityOverTimeTimePeriod', String.valueOf(chrecord.Quantity_Over_Time_Time_Period__c));
                    writeXMLElement('QuantityOverTimeTimeValue', String.valueOf(chrecord.Quantity_Over_Time_Time_Value__c));
                    writeXMLElement('MaxDaysperFill', String.valueOf(chrecord.Max_Days_per_Fill__c));
                    writeXMLElement('MaxQuantityperFill', String.valueOf(chrecord.Max_Quantity_per_Fill__c));
                    writeXMLElement('BypassMOOP', String.valueOf(chrecord.Bypass_MOOP__c));


                    

                    /*w.writeComment('DC Copay Section');
                    for (DC_Copay__c dcrecord: DCCopayList) {
                        if (dcrecord.DC_Drug_List_Group_ID__c == chrecord.Id) {
                            w.writeStartElement(null, 'DCCopay', null);
                            writeXMLElement('DrugCoverageID', String.valueOf(dcrecord.DC_Drug_List_Group_ID__r.Related_Drug_Coverage__r.Name));
                            writeXMLElement('DCDrugListGroup', String.valueOf(dcrecord.DC_Drug_List_Group_ID__r.Name));
                            writeXMLElement('DCCopayID', String.valueOf(dcrecord.Name));
                            writeXMLElement('CopayCalculation', String.valueOf(dcrecord.Copay_Calculation__c));
                            //writeXMLElement('CRDID',String.valueOf(dcrecord.CRD_ID__c));
                            writeXMLElement('DAWCode', String.valueOf(dcrecord.DAW_Code__c));
                            writeXMLElement('DollarAmount', String.valueOf(dcrecord.Dollar_Amount__c));
                            writeXMLElement('MaximumDollar', String.valueOf(dcrecord.Maximum_Dollar__c));
                            writeXMLElement('MinimumDollar', String.valueOf(dcrecord.Minimum_Dollar__c));
                            writeXMLElement('MSCodeM', String.valueOf(dcrecord.MS_Code_M__c));
                            writeXMLElement('MSCodeN', String.valueOf(dcrecord.MS_Code_N__c));
                            writeXMLElement('MSCodeO', String.valueOf(dcrecord.MS_Code_O__c));
                            writeXMLElement('MSCodeY', String.valueOf(dcrecord.MS_Code_Y__c));
                            writeXMLElement('Percent', String.valueOf(dcrecord.Percent__c));
                     //     writeXMLElement('Reverse', String.valueOf(dcrecord.Reverse__c));
                            writeXMLElement('Stepped', String.valueOf(dcrecord.Stepped__c));
                            w.writeComment('DC Copay Stepped Section');
                            for (DC_Copay_Stepped__c dcSteppedrecord: dcrecord.DC_Copays__r) {

                                w.writeStartElement(null, 'DCCopayStepped', null);
                                writeXMLElement('DrugCoverageID', String.valueOf(dcrecord.DC_Drug_List_Group_ID__r.Related_Drug_Coverage__r.Name));
                                writeXMLElement('DCDrugListGroup', String.valueOf(dcrecord.DC_Drug_List_Group_ID__r.Name));
                                writeXMLElement('DCCopayID', String.valueOf(dcrecord.Name));
                                writeXMLElement('DCSteppedCopayID', String.valueOf(dcSteppedrecord.Name));
                                writeXMLElement('CopayCalculation', String.valueOf(dcSteppedrecord.Copay_Calculation__c));
                                writeXMLElement('BeginningRange', String.valueOf(dcSteppedrecord.Beginning_Range__c));
                                writeXMLElement('EndRange', String.valueOf(dcSteppedrecord.End_Range__c));
                                //writeXMLElement('BeginningRange', String.valueOf(dcSteppedrecord.Beginning_Range__c));
                                writeXMLElement('DollarAmount', String.valueOf(dcSteppedrecord.Dollar_Amount__c));
                                writeXMLElement('MaximumDollar', String.valueOf(dcSteppedrecord.Maximum_Dollar__c));
                                writeXMLElement('MinimumDollar', String.valueOf(dcSteppedrecord.Minimum_Dollar__c));
                                writeXMLElement('NumberofSteps', String.valueOf(dcSteppedrecord.Number_of_Steps__c));
                                writeXMLElement('Percent', String.valueOf(dcSteppedrecord.Percent__c));
                         //     writeXMLElement('Reverse', String.valueOf(dcSteppedrecord.Reverse__c));
                                writeXMLElement('TypeofSteppedCopay', String.valueOf(dcSteppedrecord.Type_of_Stepped_Copay__c));
                                w.writeEndElement();

                            }
                            w.writeEndElement();
                        }
                    }*/
                    w.writeEndElement();
                }

                // Sourabh
                if ('retail'.equalsIgnoreCase(record.RecordType.DeveloperName)) {
                    //writeXMLElement('RRADrugList', String.valueOf(record.RRA_Drug_List__r.Name));
                    //writeXMLElement('RSODrugList', String.valueOf(record.RSO_Drug_List__r.Name));
                    writeXMLElement('DoyouhaveSpecialty', String.valueOf(record.Do_you_have_Specialty__c));
                    writeXMLElement('ForcetoSpecialty', String.valueOf(record.Force_to_Specialty__c));                    
                    writeXMLElement('FillsBeforeForcetoSpecialty', String.valueOf(record.of_fills_before_force_to_specialty__c));
                    writeXMLElement('AetnaSpecialtyCareRx ', String.valueOf(record.Aetna_Specialty_Care_Rx__c));
                    writeXMLElement('SpecialtyDrugList', String.valueOf(record.Speciality_Drug_List__r.Name));
                    writeXMLElement('SpecialtyDrugListLastSent', String.valueOf(record.Speciality_Drug_List__r.LastSent__c));
                    writeXMLElement('SpecialtyCVSCaremarkDLId', '');
                    writeXMLElement('SpecialtyNonGPINonNDCCheck', String.valueOf(record.Speciality_Drug_List__r.Non_GPI_Non_NDC_Check__c));
                     //Added By JR to implement request 4719 *start
                    writeXMLElement('MaxSpecialtyDaySupply', String.valueOf(record.Max_Specialty_Day_Supply__c));
                    //JR ends
                    
                    //Added By JR to implement request 4712                    
                    //writeXMLElement('SecondaryRRADrugList', String.valueOf(record.Secondary_RRA_Drug_List__r.Name));
                    //writeXMLElement('SecondaryRSODrugList', String.valueOf(record.Secondary_RSO_Drug_List__r.Name));
                    writeXMLElement('SecondaryForcetoSpecialty', String.valueOf(record.Secondary_Force_to_Specialty__c));
                    writeXMLElement('SecondaryFillsBeforeForcetoSpecialty', String.valueOf(record.Secondary_of_fills_before_force_to_SPN__c));                   
                    writeXMLElement('SecondaryAetnaSpecialtyCareRx', String.valueOf(record.Secondary_Aetna_Specialty_Care_Rx__c));
                    writeXMLElement('SecondarySpecialtyDrugList', String.valueOf(record.Secondary_Speciality_Drug_List__r.Name));
                    writeXMLElement('SecondaryofFillsbeforeForcetoMOD', String.valueOf(record.Secondary_of_Fills_before_Force_to_MOD__c));
                    //JR ends
                    writeXMLElement('RetailRefillAllowanceNoofdays', String.valueOf(record.Retail_Refill_Allowance_No_of_days__c));
                }
                if ('mail'.equalsIgnoreCase(record.RecordType.DeveloperName)) {
                    writeXMLElement('MandatoryMailOrderOption', String.valueOf(record.Mandatory_Mail_Order_Option__c));
                    writeXMLElement('NumberFillsBeforeMMOOInvoked', String.valueOf(record.fills_before_MMO_option_is_invoked__c));
                    writeXMLElement('NumberOfPeriods', String.valueOf(record.Number_of_Periods__c));
                    writeXMLElement('PeriodType', String.valueOf(record.Period_Type__c));
                    writeXMLElement('IncentivizedMailGenericPenaltyType', String.valueOf(record.Incentivized_Mail_Generic_Penalty_Type__c));
                    writeXMLElement('IncentMailGenPenaltyDollarAmount', String.valueOf(record.Incentivized_Mail_Generic_Penalty_Amount__c));
                    writeXMLElement('IncentMailGenPenaltyPercent', String.valueOf(record.Incent_Mail_Gen_Penalty_Percent__c));
                    writeXMLElement('IncentMailGenPenaltyMin', String.valueOf(record.Incent_Mail_Gen_Penalty_Min__c));
                    writeXMLElement('IncentMailGenPenaltyMax', String.valueOf(record.Incent_Mail_Gen_Penalty_Max__c));
                    writeXMLElement('IncentivizedMailBrandPenaltyType', String.valueOf(record.Incentivized_Mail_Brand_Penalty_Type__c));
                    writeXMLElement('IncentMailBrandPenaltyDollarAmount', String.valueOf(record.Incentivized_Mail_Brand_Penalty_Amount__c));
                    writeXMLElement('IncentMailBrandPenaltyPercent', String.valueOf(record.Incent_Mail_Brand_Penalty_Percent__c));
                    writeXMLElement('IncentMailBrandPenaltyMin', String.valueOf(record.Incent_Mail_Brand_Penalty_Min__c));
                    writeXMLElement('IncentMailBrandPenaltyMax', String.valueOf(record.Incent_Mail_Brand_Penalty_Max__c));
                    writeXMLElement('IncentMailNonPrefBrandPenaltyType', String.valueOf(record.Incent_Mail_NonPref_Brand_Penalty_Type__c));
                    writeXMLElement('IncentMailNPBrandPenaltyDolAmount', String.valueOf(record.Incent_Mail_NonPref_Brand_Penalty_Amount__c));
                    writeXMLElement('IncentMailNPBrandPenaltyPercent', String.valueOf(record.Incent_Mail_NP_Brand_Penalty_Percent__c));
                    writeXMLElement('IncentMailNPBrandPenaltyMin', String.valueOf(record.Incent_Mail_NP_Brand_Penalty_Min__c));
                    writeXMLElement('IncentMailNPBrandPenaltyMax', String.valueOf(record.Incent_Mail_NP_Brand_Penalty_Max__c));

                }
                writeXMLElement('UseMedispanIndicator', String.valueOf(record.Use_Medispan_Indicator__c));
                writeXMLElement('Custom_MMOD_VMOD_DrugList', String.valueOf(record.Custom_MMOD_VMOD_Drug_List__r.Name));
                writeXMLElement('Custom_MMOD_VMOD_DrugListLastSent', String.valueOf(record.Custom_MMOD_VMOD_Drug_List__r.LastSent__c));
                writeXMLElement('MMODCVSCaremarkDrugListID', String.valueOf(record.Custom_MMOD_VMOD_Drug_List__r.CVS_Caremark_Drug_List_ID__c));
                writeXMLElement('MMODNonGPINonNDCCheck', String.valueOf(record.Custom_MMOD_VMOD_Drug_List__r.Non_GPI_Non_NDC_Check__c));
                writeXMLElement('No_of_FillsAllowed_at_Retail', String.valueOf(record.No_of_fills_allowed_at_retail__c));

                if ('mail'.equalsIgnoreCase(record.RecordType.DeveloperName)) {
                    writeXMLElement('MaintenanceChoice', String.valueOf(record.Maintenance_Choice__c));
                   // writeXMLElement('MaintenanceChoiceDrugListID', String.valueOf(record.Mchoice_Drug_List__r.Name));
                   // writeXMLElement('MaintenanceChoiceDrugListLastSent', String.valueOf(record.Mchoice_Drug_List__r.LastSent__c));
                   // writeXMLElement('MChoiceCVSCaremarkDrugListID', String.valueOf(record.Mchoice_Drug_List__r.CVS_Caremark_Drug_List_ID__c));
                    //writeXMLElement('MailingOptions',String.valueOf(record.Mailing_Options__c));
                    writeXMLElement('RestartFills', String.valueOf(record.Restart_Fills__c));
                    writeXMLElement('GenericPenaltyType', String.valueOf(record.Generic_Penalty_Type__c));
                    writeXMLElement('GenericPenaltyDollarAmount', String.valueOf(record.Generic_Penalty_Dollar_Amount__c));
                    writeXMLElement('GenericPenaltyPercent', String.valueOf(record.Generic_Penalty_Percent__c));
                    writeXMLElement('GenPenaltyBasedRetailMailAWP', String.valueOf(record.Gen_Penalty_Based_Retail_Mail_AWP__c));
                    writeXMLElement('GenericPenaltyMinimumDollar', String.valueOf(record.Generic_Penalty_Minimum_Dollar__c));
                    writeXMLElement('GenericPenaltyMaximumDollar', String.valueOf(record.Generic_Penalty_Maximum_Dollar__c));
                    writeXMLElement('BrandPenaltyType', String.valueOf(record.Brand_Penalty_Type__c));
                    writeXMLElement('BrandPenaltyDollarAmount', String.valueOf(record.Brand_Penalty_Dollar_Amount__c));
                    writeXMLElement('BrandPenaltyPercent', String.valueOf(record.Brand_Penalty_Percent__c));
                    writeXMLElement('BrandPenaltyBasedRetailMailAWP', String.valueOf(record.Brand_Penalty_Based_Retail_Mail_AWP__c));
                    writeXMLElement('BrandPenaltyMinimumDollar', String.valueOf(record.Brand_Penalty_Minimum_Dollar__c));
                    writeXMLElement('BrandPenaltyMaximumDollar', String.valueOf(record.Brand_Penalty_Maximum_Dollar__c));
                    writeXMLElement('NonPrefBrandPenaltyRtlMailAWP', String.valueOf(record.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c));
                    writeXMLElement('NonPrefBrandPenaltyDollarAmnt', String.valueOf(record.Non_Pref_Brand_Penalty_Dollar_Amount__c));
                    writeXMLElement('NonPrefBrandPenaltyMaxDollar', String.valueOf(record.Non_Pref_Brand_Penalty_Maximum_Dollar__c));
                    writeXMLElement('NonPrefBrandPenaltyMinDollar', String.valueOf(record.Non_Pref_Brand_Penalty_Minimum_Dollar__c));
                    writeXMLElement('NonPrefBrandPenaltyPercent', String.valueOf(record.Non_Pref_Brand_Penalty_Percent__c));
                    writeXMLElement('NonPrefBrandPenaltyType', String.valueOf(record.Non_Pref_Brand_Penalty_Type__c));
                }

                writeXMLElement('MinimumDaysSupply', String.valueOf(record.Minimum_days_supply__c));
                writeXMLElement('MaximumDaysSupply', String.valueOf(record.Maximum_days_supply__c));
                writeXMLElement('MinimumQuantity', String.valueOf(record.Minimum_quantity__c));
                writeXMLElement('MaximumQuantity', String.valueOf(record.Maximum_quantity__c));
                writeXMLElement('RuleForDaySupplyQuantity', String.valueOf(record.Rule_for_supply_quantity__c));
                writeXMLElement('DaysPerFill', String.valueOf(record.Days_Per_Fill__c));
                writeXMLElement('DoYouHaveChooseGeneric', String.valueOf(record.Do_you_have_Choose_Generic__c));
                writeXMLElement('WhatOption', String.valueOf(record.What_Option__c));
                writeXMLElement('WhatIsTheApplicableCopay', String.valueOf(record.What_is_the_Penalty__c));
                writeXMLElement('ApplyDifferenceOfCost', String.valueOf(record.Apply_difference_of_cost__c));
                writeXMLElement('CostType', String.valueOf(record.Cost_Type__c));
                writeXMLElement('CostAmount', String.valueOf(record.Cost_Amount__c));
                writeXMLElement('ChooseGenericCopayDiffExclusion', String.valueOf(record.Choose_Generic_Copay_Diff_Exclusion__c));

                if ('retail'.equalsIgnoreCase(record.RecordType.DeveloperName) || 'specialty'.equalsIgnoreCase(record.RecordType.DeveloperName)) {
                    //writeXMLElement('MultiIngredientCompounds', String.valueOf(record.Multi_Ingredient_Compounds__c));
                    //writeXMLElement('CopayBasedOn', String.valueOf(record.Copay_Based_On__c));
                    //writeXMLElement('DollarAmount', String.valueOf(record.Dollar_Amount__c));
                    //writeXMLElement('MaxDaySupplyOverride', String.valueOf(record.Max_Day_Supply__c));
                    //writeXMLElement('RefillLimitsOverride', String.valueOf(record.Refill_Limits__c));
                    //writeXMLElement('OTCOverride', String.valueOf(record.OTC__c));
                    //writeXMLElement('BrandGenericOverride', String.valueOf(record.Brand_Generic__c));
                    //writeXMLElement('ThirdPartyExceptionsOverride', String.valueOf(record.X3rd_Party_Exceptions__c));
                    //writeXMLElement('DEAOverride', String.valueOf(record.DEA__c));
                    //writeXMLElement('DosageFormOverride', String.valueOf(record.Dosage_Form__c));
                    //writeXMLElement('DESIOverride', String.valueOf(record.DESI__c));
                    //writeXMLElement('MaintenanceFormOverride', String.valueOf(record.Maintenance_Form__c));
                    //writeXMLElement('PackagingExceptionsOverride', String.valueOf(record.Packaging_Exceptions__c));
                    //writeXMLElement('FDATherapeuticEquivOverride', String.valueOf(record.FDA_Therapeutic_Equivalent__c));
                    //writeXMLElement('FDATherapeuticCategoryOveride', String.valueOf(record.FDA_Therapeutic_Category__c));
                    //writeXMLElement('DUR', String.valueOf(record.DUR__c));
                    //writeXMLElement('DURMessageType', String.valueOf(record.DUR_Message_Type__c));
                }

                w.writeEndElement(); // w.writeStartElement(null,'DrugCoverage', null);
            }
            // Nitish for Implementing 4731
            
            w.writeComment('WaiverOfDeductibleSection');
            for (Waiver_Of_Deductible__c record: WODRecord) {
            w.writeStartElement(null, 'WaiverOfDeductibleRecord', null);
            writeXMLElement('DrugClass', String.valueOf(record.Drug_Class__c));
            writeXMLElement('DrugClassDesc', String.valueOf(record.Drug_Class_Desc__c));
            writeXMLElement('DrugGroup', String.valueOf(record.Drug_Group__r.Name));
            writeXMLElement('DrugList', String.valueOf(record.Drug_List__r.Name));
            writeXMLElement('DeliverySystem', String.valueOf(record.Delivery_System__c));
            writeXMLElement('M', String.valueOf(record.M__c));        
            writeXMLElement('N', String.valueOf(record.N__c));        
            writeXMLElement('O', String.valueOf(record.O__c));        
            writeXMLElement('Y', String.valueOf(record.Y__c));        
            writeXMLElement('Standard', String.valueOf(record.Standard__c)); 
            writeXMLElement('Network', String.valueOf(record.Network__c));
            w.writeEndElement();
             }      
            
            // Max Pay
            w.writeComment('MaxPay Section');
            writeXMLElement('OverrideStandardMaxPay', String.valueOf(crdRecord.Override_Standard_Max_Pay__c));
            writeXMLElement('MaxPayID', String.valueOf(crdRecord.Max_Pay__r.Name));
            writeXMLElement('MaxPayLastSent', String.valueOf(crdRecord.Max_Pay__r.LastSent__c));
            writeXMLElement('IsThereCompoundMaxPay', String.valueOf(crdRecord.Is_there_Compound_Max_Pay__c));
            writeXMLElement('OverrideStandardCompoundMaxPay', String.valueOf(crdRecord.Override_Standard_Compound_Max_Pay__c));
            writeXMLElement('CompoundMaxPayID', String.valueOf(crdRecord.Compound_Max_Pay__r.Name));
            writeXMLElement('CompoundMaxPayLastSent', String.valueOf(crdRecord.Compound_Max_Pay__r.LastSent__c));            
            // Accumulation
            w.writeComment('Accumulation Section');
            writeXMLElement('IsthereMedicalIntegration', String.valueOf(crdRecord.Integrate_with_Medical__c));
           // writeXMLElement('DEDWaivePreferredGenericIN', String.valueof(crdRecord.DED_Waive_Preferred_Generic_IN__c));
           // writeXMLElement('DEDWaivePreferredGenericOON', String.valueof(crdRecord.DED_Waive_Preferred_Generic_OON__c));
    
            /* MOOP Bypass Section Commented By Sushant : Req 04937
            for(MOOP_Bypass__c record: MOOPBypassRecord){
                w.writeComment('MOOP Bypass Section');
                writeXMLElement('MOOPBypassType', String.valueOf(record.MOOP_Bypass_Type__c));
                writeXMLElement('MOOPBypassDrugList', String.valueOf(record.MOOP_Bypass_Drug_List_Name__c));
                writeXMLElement('MOOPBypassDrugGroup', String.valueOf(record.MOOP_Bypass_Drug_Group_Name__c));
                
            } */
            
            for (Accumulations__c record: ARecord) {
                w.writeComment('AccumulationsRecords Section' + record.RecordType.Name);
                w.writeStartElement(null, 'Accumulation', null);
                writeXMLElement('AccumulationID', String.valueOf(record.Name));
                writeXMLElement('RecordType', String.valueOf(record.RecordType.Name));
                writeXMLElement('AccumCodeDeductible', String.valueOf(record.Accum_Code_Deductible__c));
                writeXMLElement('AccumCodeMaximumAllowableBenefit', String.valueOf(record.Accum_Code_Maximum_Allowable_Benefit__c));
                writeXMLElement('AccumCodeMaximumOutOfPocket', String.valueOf(record.Accum_Code_Maximum_Out_Of_Pocket__c));
                writeXMLElement('StartMonth', String.valueOf(record.Start_Month_New__c));
                writeXMLElement('StartDay', String.valueOf(record.Start_Day__c));
                writeXMLElement('AccumulationEndDate', string.valueof(record.Accumulation_End_Date__c));
                writeXMLElement('WhenwilltheAccumulationsrenew', String.valueOf(record.When_will_the_Accumulations_renew__c));
                writeXMLElement('CarryBalanceWhenMemberMoves', String.valueOf(record.Carry_Balance_when_member_moves__c));
                writeXMLElement('FlatDeductibleAmount', String.valueOf(record.Deductible_Amount__c));
                //Added by Sushant: Req 1129
                writeXMLElement('InNetworkDeductibleAmount', String.valueOf(record.What_is_the_In_Network_Deductible_Amount__c));
                writeXMLElement('OONDeductibleAmount', String.valueOf(record.What_is_the_OON_Deductible_Amount__c));
                writeXMLElement('CrossAccumulation', String.valueOf(record.Cross_Accumulation__c));
                writeXMLElement('InNetworkMOOPAmount', String.valueOf(record.What_is_the_In_Network_MOOP_Amount__c));
                writeXMLElement('OONMOOPAmount', String.valueOf(record.What_is_the_OON_MOOP_Amount__c));
                writeXMLElement('DeductiblePeriod', String.valueOf(record.Deductible_Period__c));
                writeXMLElement('DeuductibleAccumFromFourthQtr', String.valueOf(record.Deuductible_Accumulation_from_4th_Qtr__c));
                writeXMLElement('NumFamilyMembersMeetFamDeduct', String.valueOf(record.Family_Members_to_meet_Family_Deduct__c));
                writeXMLElement('AreDrugSpecificDeductibles', String.valueOf(record.Are_there_any_drug_specific_deductibles__c));
                //commented by JR to implement request no 4771
                //writeXMLElement('DEDInNetwork', String.valueOf(record.Deductible_In_Network__c));
                //writeXMLElement('DEDOutofNetwork', String.valueOf(record.Deductible_Out_of_Network__c));
                //writeXMLElement('DEDGenericDrugs', String.valueOf(record.Deductible_Generic_Drugs__c));
                //writeXMLElement('DEDBrandDrugsWithGenAvailable', String.valueOf(record.Deductible_Brand_Drugs_Generics__c));
                //writeXMLElement('DEDBrandDrugsWithNoGenAvailable', String.valueOf(record.Deductible_Brand_Drugs_no_Generics__c));
                //writeXMLElement('DEDMaintenanceDrugs', String.valueOf(record.Deductible_Maintenance_Drugs__c));
                writeXMLElement('ThereAMaximumAllowableBenefit', String.valueOf(record.Is_there_a_Maximum_Allowable_Benefit__c));
                writeXMLElement('WhatIsTheMABAmount', String.valueOf(record.MAB_Dedictible_Amount__c));
                writeXMLElement('WhatIsTheMABPeriod', String.valueOf(record.MAB_Period__c));
                writeXMLElement('WhatHappensWhenTheMABIsMet', String.valueOf(record.What_happens_when_the_MAB_is_met__c));
               // accumulation change copay MAB
                for (Accumulation_Change_Copay__c accumChangeCopay: accumChangeCopayList) {
                    if (accumChangeCopay.RecordType.Name == 'MAB') {
                        w.writeStartElement(null, 'AccumulationChangeCopay', null);
                        writeXMLElement('AccumulationChangeCopayID', String.valueOf(accumChangeCopay.Name));
                        writeXMLElement('RecordType', String.valueOf(accumChangeCopay.RecordType.Name));
                        writeXMLElement('DAWCode', String.valueOf(accumChangeCopay.DAW_Code__c));
                        writeXMLElement('MSCodeM', String.valueOf(accumChangeCopay.MS_Code_M__c));
                        writeXMLElement('MSCodeN', String.valueOf(accumChangeCopay.MS_Code_N__c));
                        writeXMLElement('MSCodeO', String.valueOf(accumChangeCopay.MS_Code_O__c));
                        writeXMLElement('MSCodeY', String.valueOf(accumChangeCopay.MS_Code_Y__c));
                        writeXMLElement('Stepped', String.valueOf(accumChangeCopay.Stepped__c));
                        writeXMLElement('DollarAmount', String.valueOf(accumChangeCopay.Dollar_Amount__c));
                        writeXMLElement('Percent', String.valueOf(accumChangeCopay.Percent__c));
                        writeXMLElement('CopayCalculation', String.valueOf(accumChangeCopay.Copay_Calculation__c));
                        writeXMLElement('MinimumDollar', String.valueOf(accumChangeCopay.Minimum_Dollar__c));
                        writeXMLElement('MaximumDollar', String.valueOf(accumChangeCopay.Maximum_Dollar__c));
                        writeXMLElement('Reverse', String.valueOf(accumChangeCopay.Reverse__c));
                        for (Accumulation_Change_Copay_Stepped__c accumStepped: accumChangeCopay.Accumulation_Change_Copays_Stepped__r) {
                            w.writeStartElement(null, 'AccumChangeCopayStepped', null);
                            writeXMLElement('AccChangeCopaySteppedID', String.valueOf(accumStepped.Name));
                            writeXMLElement('BeginningRange', String.valueOf(accumStepped.Beginning_Range__c));
                            writeXMLElement('EndRange', String.valueOf(accumStepped.End_Range__c));
                            writeXMLElement('SteppedCopayType', String.valueOf(accumStepped.Type_of_Stepped_Copay__c));
                            writeXMLElement('DollarAmount', String.valueOf(accumStepped.Dollar_Amount__c));
                            writeXMLElement('Percent', String.valueOf(accumStepped.Percent__c));
                            writeXMLElement('CopayCalculation', String.valueOf(accumStepped.Copay_Calculation__c));
                            writeXMLElement('MinimumDollar', String.valueOf(accumStepped.Minimum_Dollar__c));
                            writeXMLElement('MaximumDollar', String.valueOf(accumStepped.Maximum_Dollar__c));
                            writeXMLElement('Reverse', String.valueOf(accumStepped.Reverse__c));
                            w.writeEndElement(); // w.writeStartElement(null,'AccumChangeCopayStepped', null);
                        }

                        w.writeEndElement(); // w.writeStartElement(null,'AccumulationChangeCopay', null);
                    }
                }
                
                //Added by Sushant Req 01033
                writeXMLElement('DoNotApplyFlatFeeToOOP', String.valueOf(record.Do_not_apply_flat_fee_to_OOP__c));
                writeXMLElement('DoNotApplyPenaltyToOOP', String.valueOf(record.Do_not_apply_penalty_to_OOP__c));
                writeXMLElement('AreThereAnyDrugSpecificMAB', String.valueOf(record.Are_there_any_drug_specific_MAB__c));
                writeXMLElement('MABExcludeInNetwork', String.valueOf(record.MAB_In_Network__c));
                writeXMLElement('MABExcludeOutofNetwork', String.valueOf(record.MAB_Out_of_Network__c));
                writeXMLElement('MABExcludeGenericDrugs', String.valueOf(record.MAB_Generic_Drugs__c));
                writeXMLElement('MABExclBrandDrugswithGenAvail', String.valueOf(record.MAB_Brand_Drugs_Generics__c));
                writeXMLElement('MABExclBrandDrugswnoGenAvail', String.valueOf(record.MAB_Brand_Drugs_no_Generics__c));
                writeXMLElement('MABExcludeMaintenanceDrugs', String.valueOf(record.MAB_Maintenance_Drugs__c));
                writeXMLElement('IsThereAMaximumOutOfPocket', String.valueOf(record.Is_there_a_Maximum_Out_of_Pocket__c));
                writeXMLElement('WhatIsTheFlatMOOPAmount', String.valueOf(record.MOOP_Dedictible_Amount__c));
                writeXMLElement('WhatIsTheMOOPPeriod', String.valueOf(record.MOOP_Period__c));
                writeXMLElement('DeductibleAppliesTowardsMOOP', String.valueOf(record.Deductible_Applies_towards_the_MOOP__c));
                writeXMLElement('DAWDiffPenaltyAppliestoMOOP', String.valueOf(record.DAW_Differential_Penalty_Applies_to_MOOP__c));
                writeXMLElement('WhathappenswhenMOOPismet', String.valueOf(record.What_happens_when_MOOP_is_met__c));
                // accumulation change copay MOOP
                for (Accumulation_Change_Copay__c accumChangeCopay: accumChangeCopayList) {
                    if (accumChangeCopay.RecordType.Name == 'MOOP') {
                        w.writeStartElement(null, 'AccumulationChangeCopay', null);
                        writeXMLElement('AccumulationChangeCopayID', String.valueOf(accumChangeCopay.Name));
                        writeXMLElement('RecordType', String.valueOf(accumChangeCopay.RecordType.Name));
                        writeXMLElement('DAWCode', String.valueOf(accumChangeCopay.DAW_Code__c));
                        writeXMLElement('MSCodeM', String.valueOf(accumChangeCopay.MS_Code_M__c));
                        writeXMLElement('MSCodeN', String.valueOf(accumChangeCopay.MS_Code_N__c));
                        writeXMLElement('MSCodeO', String.valueOf(accumChangeCopay.MS_Code_O__c));
                        writeXMLElement('MSCodeY', String.valueOf(accumChangeCopay.MS_Code_Y__c));
                        writeXMLElement('Stepped', String.valueOf(accumChangeCopay.Stepped__c));
                        writeXMLElement('DollarAmount', String.valueOf(accumChangeCopay.Dollar_Amount__c));
                        writeXMLElement('Percent', String.valueOf(accumChangeCopay.Percent__c));
                        writeXMLElement('CopayCalculation', String.valueOf(accumChangeCopay.Copay_Calculation__c));
                        writeXMLElement('MinimumDollar', String.valueOf(accumChangeCopay.Minimum_Dollar__c));
                        writeXMLElement('MaximumDollar', String.valueOf(accumChangeCopay.Maximum_Dollar__c));
                        writeXMLElement('Reverse', String.valueOf(accumChangeCopay.Reverse__c));
                        for (Accumulation_Change_Copay_Stepped__c accumStepped: accumChangeCopay.Accumulation_Change_Copays_Stepped__r) {
                            w.writeStartElement(null, 'AccumChangeCopayStepped', null);
                            writeXMLElement('AccChangeCopaySteppedID', String.valueOf(accumStepped.Name));
                            writeXMLElement('BeginningRange', String.valueOf(accumStepped.Beginning_Range__c));
                            writeXMLElement('EndRange', String.valueOf(accumStepped.End_Range__c));
                            writeXMLElement('SteppedCopayType', String.valueOf(accumStepped.Type_of_Stepped_Copay__c));
                            writeXMLElement('DollarAmount', String.valueOf(accumStepped.Dollar_Amount__c));
                            writeXMLElement('Percent', String.valueOf(accumStepped.Percent__c));
                            writeXMLElement('CopayCalculation', String.valueOf(accumStepped.Copay_Calculation__c));
                            writeXMLElement('MinimumDollar', String.valueOf(accumStepped.Minimum_Dollar__c));
                            writeXMLElement('MaximumDollar', String.valueOf(accumStepped.Maximum_Dollar__c));
                            writeXMLElement('Reverse', String.valueOf(accumStepped.Reverse__c));
                            w.writeEndElement(); // w.writeStartElement(null,'AccumChangeCopayStepped', null);
                        }

                        w.writeEndElement(); // w.writeStartElement(null,'AccumulationChangeCopay', null);
                    }
                }

                writeXMLElement('NumFamilyMembersMeetFamMOOP', String.valueOf(record.Noof_Family_Members_to_Meet_Family_MOOP__c));
                writeXMLElement('AreThereAnyDrugSpecifcMOOP', String.valueOf(record.Are_there_any_drug_specifc_MOOP__c));
                writeXMLElement('MOOPExcludeInNetwork', String.valueOf(record.MOOP_In_Network__c));
                writeXMLElement('MOOPExcludeOutofNetwork', String.valueOf(record.MOOP_Out_of_Network__c));
                writeXMLElement('MOOPExcludeGenericDrugs', String.valueOf(record.MOOP_Generic_Drugs__c));
                writeXMLElement('MOOPExclBrandDrugswithGenAvail', String.valueOf(record.MOOP_Brand_Drugs_Generics__c));
                writeXMLElement('MOOPExclBrandDrugswnoGenAvail', String.valueOf(record.MOOP_Brand_Drugs_no_Generics__c));
                writeXMLElement('MOOPExcludeMaintenanceDrugs', String.valueOf(record.MOOP_Maintenance_Drugs__c));

                for (AccumulationSpecificDrug__c grandRecord: record.AccumulationDrugLists__r) {
                    w.writeComment('AccumulationSpecificDrug Section');
                    w.writeStartElement(null, 'AccumulationSpecificDrug', null);
                    writeXMLElement('AccumulationSpecificDrugID', String.valueOf(grandRecord.Name));
                    writeXMLElement('RecordType', String.valueOf(grandRecord.RecordType.Name));
                    writeXMLElement('DrugList', String.valueOf(grandRecord.Drug_List__r.Name));
                    writeXMLElement('DrugListLastSent', String.valueOf(grandRecord.Drug_List__r.LastSent__c));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('NonGPINonNCDCheck', String.valueOf(grandRecord.Drug_List__r.Non_GPI_Non_NDC_Check__c));
                    writeXMLElement('DrugGroupID', String.valueOf(grandRecord.Drug_Group__r.Name));
                    writeXMLElement('DrugGroupLastSent', String.valueOf(grandRecord.Drug_Group__r.LastSent__c));
                    writeXMLElement('DeductibleAmount', String.valueOf(grandRecord.Deductible_Amount__c));
                    writeXMLElement('DeductiblePeriod', String.valueOf(grandRecord.Deductible_Period__c));
                    writeXMLElement('DeductibleAccumulationFromFourthQtr', String.valueOf(grandRecord.Deuductible_Accumulation_from_4th_Qtr__c));
                    // writeXMLElement('NumFamilyMembersMeetFamDeduct',String.valueOf(grandRecord.Family_Members_to_meet_Family_Deduct__c));
                    writeXMLElement('WhatIsTheMABAmount', String.valueOf(grandRecord.MAB_Dedictible_Amount__c));
                    writeXMLElement('WhatIsTheMABPeriod', String.valueOf(grandRecord.MAB_Period__c));
                    writeXMLElement('WhatHappensWhenTheMABIsMet', String.valueOf(grandRecord.What_happens_when_MAB_is_met__c));
                    writeXMLElement('WhatIsTheMOOPAmount', String.valueOf(grandRecord.MOOP_Dedictible_Amount__c));
                    writeXMLElement('WhatIsTheMOOPPeriod', String.valueOf(grandRecord.MOOP_Period__c));
                    writeXMLElement('DeductibleAppliesTowardsMOOP', String.valueOf(grandRecord.Deductible_Applies_towards_the_MOOP__c));
                    writeXMLElement('DAWDiffPenaltyAppliesToMOOP', String.valueOf(grandRecord.DAW_Differential_Penalty_Applies_to_MOOP__c));
                    writeXMLElement('WhathappenswhenMOOPismet', String.valueOf(grandRecord.What_happens_when_MOOP_is_met__c));
                    writeXMLElement('ExcludefromAccumulation', String.valueOf(grandRecord.Exclude_from_Accumulation__c));
                    writeXMLElement('M', String.valueOf(grandRecord.M__c));
                    writeXMLElement('N', String.valueOf(grandRecord.N__c));
                    writeXMLElement('O', String.valueOf(grandRecord.O__c));
                    writeXMLElement('Y', String.valueOf(grandRecord.Y__c));
                    //  writeXMLElement('NumFamilyMembersMeetFamMOOP',String.valueOf(grandRecord.Noof_Family_Members_to_Meet_Maximum_MOOP__c));

                    w.writeEndElement(); // w.writeStartElement(null,'AccumulationSpecificDrug', null);
                }

                w.writeEndElement(); // w.writeStartElement(null,'Accumulation', null);
            }

            // RDS Section
            w.writeComment('RDS Section');
            writeXMLElement('RDSelem', String.valueOf(crdRecord.RDS__c));

            // PaperClaims Section
            w.writeComment('PaperClaims Section');
            writeXMLElement('InNetworkclaimsarereimbursed', String.valueOf(crdRecord.In_Network_claims_are_reimbursed__c));
            writeXMLElement('InNetworkDiscountRate', String.valueOf(crdRecord.In_Network_Discount_Rate__c));
            writeXMLElement('OutOfNetworkClaimsReimbursed', String.valueOf(crdRecord.Out_of_Network_claims_are_reimbused__c));
            writeXMLElement('OutofNetworkDiscountRate', String.valueOf(crdRecord.Out_of_Network_Discount_Rate__c));
            writeXMLElement('NumberofDaystofileaclaim', String.valueOf(crdRecord.No_of_Days_to_file_a_claim__c));
            writeXMLElement('BypassDMR', String.valueOf(crdRecord.Bypass_DMR__c));
            writeXMLElement('RetailSourceAWP', String.valueOf(crdRecord.Retail_Source_AWP__c));
            writeXMLElement('AllowOffshoreProcessing', String.valueOf(crdRecord.Offshore__c));
            writeXMLElement('Prorate', String.valueOf(crdRecord.Prorate__c));
            writeXMLElement('PlanCoordinateBenefits', String.valueOf(crdRecord.Plan_Coordinate_Benefits__c));
            writeXMLElement('NursingHomeClaims', String.valueOf(crdRecord.Nursing_Home_Claims__c));
            writeXMLElement('ForeignClaims', String.valueOf(crdRecord.Foreign_Claims__c));
            writeXMLElement('Medicaid', String.valueOf(crdRecord.Medicaid__c));
            writeXMLElement('ClaimsAcceptableworeceipts', String.valueOf(crdRecord.Claims_Acceptable_w_o_receipts__c));
            writeXMLElement('CompoundCodeTwo', String.valueOf(crdRecord.Compound_Code_2__c));
            writeXMLElement('ClaimsPayableWPharmSignature', String.valueOf(crdRecord.Claims_payable_with_Pharm_Signature__c));
            writeXMLElement('IndianFacilities', String.valueOf(crdRecord.Indian_Facilities__c));
            writeXMLElement('DefaultNABPNumber', String.valueOf(crdRecord.Default_NABP__c));
            writeXMLElement('AdministrationofExternalCOB', String.valueOf(crdRecord.Administration_of_External_COB__c));
            writeXMLElement('VeteransAdmin', String.valueOf(crdRecord.Veterans_Admin__c));
            writeXMLElement('AllergySerums', String.valueOf(crdRecord.Allergy_Serums__c));
            writeXMLElement('ClinicPhysicianReimbursement', String.valueOf(crdRecord.Clinic_Physician_Reimbursement__c));
            writeXMLElement('ErisaClient', String.valueOf(crdRecord.Erisa_Client__c));
            writeXMLElement('OstomySupplies', String.valueOf(crdRecord.Ostomy_Supplies__c));
            writeXMLElement('OtherInsurancePaidinError', String.valueOf(crdRecord.Other_Insurance_Paid_in_Error__c));
            writeXMLElement('ManualPharmacyPayments', String.valueOf(crdRecord.Manual_Pharmacy_Payments__c));
            writeXMLElement('AreEmergencyClaimsReimbursed', String.valueOf(crdRecord.Are_Emergency_Claims_Reimbursed__c));
            writeXMLElement('AreHemoClaimsReimbursed', String.valueOf(crdRecord.Are_Hemo_Claims_Reimbursed__c));
            writeXMLElement('EmergencyDiscountRate', String.valueOf(crdRecord.Emergency_Discount_Rate__c));
            writeXMLElement('HemoDiscountRate', String.valueOf(crdRecord.Hemo_Discount_Rate__c));

            // Coordination of Benefits Section
            w.writeComment('Coordintation of Benefits Section');
            writeXMLElement('DoesclientwantCOB', String.valueOf(crdRecord.Does_the_client_want_to_do_COB__c));
            writeXMLElement('COBorMOB', String.valueOf(crdRecord.COB_or_MOB__c));
            writeXMLElement('ProcessPointofSalesCOB', String.valueOf(crdRecord.Process_Point_of_Sales_COB__c));
            writeXMLElement('ReimbursementLevels', String.valueOf(crdRecord.Reimbursement_Levels__c));
            writeXMLElement('InNetwork', String.valueOf(crdRecord.In_Network__c));
            writeXMLElement('InNetworkReimbursementLevel', String.valueOf(crdRecord.In_Network_Reimbursement_Level__c));
            writeXMLElement('OutofNetwork', String.valueOf(crdRecord.Out_of_Network__c));
            writeXMLElement('OutOfNetworkReimbursementLvl', String.valueOf(crdRecord.Out_of_Network_Reimbursement_Level__c));

            // POS Rebate Section
            w.writeComment('POS Rebate Section');
            writeXMLElement('POSRebateforPlan', String.valueOf(crdRecord.POS_Rebate_for_Plan__c));
            writeXMLElement('POSRebateEffectiveDate', String.valueOf(crdRecord.RTMD_Effective_Date__c));
            writeXMLElement('POSRebateClientSharePercent', String.valueOf(crdRecord.RTMD_Client_Share_Percent__c));
            writeXMLElement('POSRebateModulatorPercent', String.valueOf(crdRecord.RTMD_Modulator_Percent__c));
            writeXMLElement('SpecialtyExclusionFlag', String.valueOf(crdRecord.Specialty_Exclusion_Flag__c));
            writeXMLElement('POSRebateAdminFeebasis', String.valueOf(crdRecord.RTMD_Admin_Fee_basis__c));
            writeXMLElement('POSRebateAdminFeerate', String.valueOf(crdRecord.RTMD_Admin_Fee_rate__c));

            // Programs Section
            w.writeComment('Programs Section');
            writeXMLElement('AdherenceToDrugTherapy', String.valueOf(crdRecord.Adherence_to_Drug_Therapy__c));
            writeXMLElement('PharmacyAdvisor', String.valueOf(crdRecord.Pharmacy_Advisor__c));
            writeXMLElement('TollFreeNumberType', String.valueOf(crdRecord.Toll_Free_Number__c));
            //writeXMLElement('CustomTollFreeNumber', String.valueOf(crdRecord.Custom_TFN__c));Richa commented for Req - 4887
            writeXMLElement('EnrolledPAForOtherCondition', String.valueOf(crdRecord.Enrolled_in_PA_for_other_condition__c));
            writeXMLElement('ImplementationType', String.valueOf(crdRecord.Implementation_Type__c));
            writeXMLElement('ParticipatMailPharmacyService', String.valueOf(crdRecord.Participate_in_CVS_mail_pharmacy_service__c));
            writeXMLElement('DiseaseManageReferralMessage', String.valueOf(crdRecord.Disease_Management_Referral_Messaging__c));
            writeXMLElement('DiseaseManagementMessagingfor', String.valueOf(crdRecord.Disease_Management_Messaging_for__c));
            writeXMLElement('DMVendorSameForEachCondition', String.valueOf(crdRecord.Is_DM_vendor_the_same_for_each_condition__c));
            //writeXMLElement('DiseaseVendor', String.valueOf(crdRecord.Disease_Vendor__c));
            //writeXMLElement('CustomDiseaseVendorPhoneNum', String.valueOf(crdRecord.Custom_call_center_phone_number__c));
            //writeXMLElement('DiseaseVendor1ImplementationType', String.valueOf(crdRecord.Disease_Vendor_1_Implementation_Type__c));
            //writeXMLElement('DiseaseVendor2', String.valueOf(crdRecord.Disease_Vendor_2__c));
            //writeXMLElement('CustomDiseaseVendor2PhoneNumber', String.valueOf(crdRecord.Custom_Disease_Vendor_2_Phone_Number__c));
            //writeXMLElement('DiseaseVendor2ImplementationType', String.valueOf(crdRecord.Disease_Vendor_2_Implementation_Type__c));
            //writeXMLElement('DMVendor2ContractEndDate', String.valueOf(crdRecord.DM_Vendor_2_Contract_End_Date__c));
            //writeXMLElement('DMVendorContractEndDate', String.valueOf(crdRecord.End_Date__c));
            writeXMLElement('PADiseaseVendor1', String.valueOf(crdRecord.PA_Disease_Vendor_1__c));
            writeXMLElement('PACondition1', String.valueOf(crdRecord.PA_Condition_1__c));
            writeXMLElement('PADMVendorContractEndDate1', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_1__c));
            writeXMLElement('PACustomDiseaseVendorPhone1', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_1__c));
            writeXMLElement('PADiseaseVendor2', String.valueOf(crdRecord.PA_Disease_Vendor_2__c));
            writeXMLElement('PACondition2', String.valueOf(crdRecord.PA_Condition_2__c));
            writeXMLElement('PADMVendorContractEndDate2', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_2__c));
            writeXMLElement('PACustomDiseaseVendorPhone2', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_2__c));
            writeXMLElement('PADiseaseVendor3', String.valueOf(crdRecord.PA_Disease_Vendor_3__c));
            writeXMLElement('PACondition3', String.valueOf(crdRecord.PA_Condition_3__c));
            writeXMLElement('PADMVendorContractEndDate3', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_3__c));
            writeXMLElement('PACustomDiseaseVendorPhone3', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_3__c));
            writeXMLElement('PADiseaseVendor4', String.valueOf(crdRecord.PA_Disease_Vendor_4__c));
            writeXMLElement('PACondition4', String.valueOf(crdRecord.PA_Condition_4__c));
            writeXMLElement('PADMVendorContractEndDate4', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_4__c));
            writeXMLElement('PACustomDiseaseVendorPhone4', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_4__c));
            writeXMLElement('PADiseaseVendor5', String.valueOf(crdRecord.PA_Disease_Vendor_5__c));
            writeXMLElement('PACondition5', String.valueOf(crdRecord.PA_Condition_5__c));
            writeXMLElement('PADMVendorContractEndDate5', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_5__c));
            writeXMLElement('PACustomDiseaseVendorPhone5', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_5__c));
            writeXMLElement('PADiseaseVendor6', String.valueOf(crdRecord.PA_Disease_Vendor_6__c));
            writeXMLElement('PACondition6', String.valueOf(crdRecord.PA_Condition_6__c));
            writeXMLElement('PADMVendorContractEndDate6', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_6__c));
            writeXMLElement('PACustomDiseaseVendorPhone6', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_6__c));
            writeXMLElement('PADiseaseVendor7', String.valueOf(crdRecord.PA_Disease_Vendor_7__c));
            writeXMLElement('PACondition7', String.valueOf(crdRecord.PA_Condition_7__c));
            writeXMLElement('PADMVendorContractEndDate7', String.valueOf(crdRecord.PA_DM_Vendor_Contract_End_Date_7__c));
            writeXMLElement('PACustomDiseaseVendorPhone7', String.valueOf(crdRecord.PA_Custom_Disease_Vendor_Phone_7__c));

            // Clinical Programs Section
            w.writeComment('Clinical Programs Section');
           //writeXMLElement('POSDoseOptimization', String.valueOf(crdRecord.POS_Dose_Optimization__c)); ---> Request no- 04870 by Nitish
           // writeXMLElement('POSDoseOptimizationDrugListID', String.valueOf(crdRecord.POS_Dose_Optimization_Drug_List_ID__r.Name));--> Commented by Nitish dependency of request no 4870
           //writeXMLElement('POSDoseDrugListLastSent', String.valueOf(crdRecord.POS_Dose_Optimization_Drug_List_ID__r.LastSent__c));--> Commented by Nitish dependency of request no 4870
           // writeXMLElement('POSDoseDLCVSCaremarkDLID', String.valueOf(crdRecord.POS_Dose_Optimization_Drug_List_ID__r.CVS_Caremark_Drug_List_ID__c));--> Commented by Nitish dependency of request no 4870
           // writeXMLElement('POSDoseNonGPINonNDCCheck', String.valueOf(crdRecord.POS_Dose_Optimization_Drug_List_ID__r.Non_GPI_Non_NDC_Check__c));--> Commented by Nitish dependency of request no 4870
            writeXMLElement('RetailtoMail', String.valueOf(crdRecord.Retail_to_Mail__c));
            writeXMLElement('GenericLaunch', String.valueOf(crdRecord.Generic_Launch__c));
            writeXMLElement('GenericUptake', String.valueOf(crdRecord.Generic_Uptake__c));
            writeXMLElement('SpecialtyTherapyManagement', String.valueOf(crdRecord.Specialty_Therapy_Management__c));
            writeXMLElement('GapsinCare', String.valueOf(crdRecord.Gaps_in_Care__c));
            writeXMLElement('ConcurrentDURID', String.valueOf(crdRecord.Concurrent_DUR_ID__r.Name));
            writeXMLElement('ConcurrentDURLastSent', String.valueOf(crdRecord.Concurrent_DUR_ID__r.LastSent__c));
            writeXMLElement('ConcurrentDURCVSCMDURID', String.valueOf(crdRecord.Concurrent_DUR_ID__r.CVS_Caremark_DUR_ID__c));
            // Aetna Programs Section
            w.writeComment('Aetna Programs Section');
           // writeXMLElement('BloodGlucoseMonitoring', String.valueOf(crdRecord.Blood_Glucose_Monitoring__c));
           // writeXMLElement('MigraineManagement', String.valueOf(crdRecord.Migrane_Management__c));
           // writeXMLElement('HealthCareforLife', String.valueOf(crdRecord.Health_Care_for_Life__c));
            writeXMLElement('ExtraCareHealthCard', String.valueOf(crdRecord.Extra_Care_Health_Card__c));
            //writeXMLElement('FSAIntegration', String.valueOf(crdRecord.FSA_Integration__c));--> Request no - 4874-- Nitish

            // Shell Plan
            w.writeComment('Shell Plan');
            writeXMLElement('AetnaRxAutofill', String.valueOf(crdRecord.Aetna_Autofill__c));
            
            // Aetna Rx Ways To save
            w.writeComment('Aetna Rx Ways');
            writeXMLElement('EnrollinAetnaWaystoSave', String.valueOf(crdRecord.Enroll_in_Aetna_Ways_to_Save__c));
            writeXMLElement('MailRequestDate', String.valueOf(crdRecord.Mail_Request_Date__c));
            writeXMLElement('Requestedmailingreceivedon', String.valueOf(crdRecord.Requested_mailing_received_on__c));
            writeXMLElement('TargetGenericOpportunities', String.valueOf(crdRecord.Target_Generic_Opportunities__c));
            writeXMLElement('TargetFormularyBrandOpportun', String.valueOf(crdRecord.Target_Formulary_Brand_Opportunities__c));
            writeXMLElement('TargetPrefManufacturerBrandOpp', String.valueOf(crdRecord.Target_Pref_Manufacturer_Brand_Opportun__c));
            writeXMLElement('TargetParticipants18yrandolder', String.valueOf(crdRecord.Target_Participants_18_years_and_older__c));
            writeXMLElement('PreferredManufacturerBrandCode', String.valueOf(crdRecord.Preferred_Manufacturer_Brands_Code__c));
            writeXMLElement('IfNot18IndicateAge', String.valueOf(crdRecord.If_Not_18_Indicate_Age__c));
            writeXMLElement('MemberLetterSelection', String.valueOf(crdRecord.Member_Letter_Selection__c));
            writeXMLElement('MinimumMemberSavingsProjection', String.valueOf(crdRecord.Minimum_Member_Savings_Projection__c));
            writeXMLElement('IntroductoryParagraphtoInclude', String.valueOf(crdRecord.Introductory_Paragraph_to_Include__c));
            
            
            // Aetna Healthy Actions
            w.writeComment('Aetna Healthy Actions');
            writeXMLElement('AetnaHealthyActions', String.valueOf(crdRecord.Aetna_Healthy_Actions__c));
            writeXMLElement('OfferingType', String.valueOf(crdRecord.Offering_Type__c));
            writeXMLElement('AHADrugGroupID', String.valueOf(crdRecord.AHA_Drug_Group__r.Name));
            writeXMLElement('AHADrugGroupLastSent', String.valueOf(crdRecord.AHA_Drug_Group__r.LastSent__c));
            writeXMLElement('TierOneCopayReductionPercent', String.valueOf(crdRecord.Tier_1_Copay_Reduction__c));
            writeXMLElement('TierTwoCopayReductionPercent', String.valueOf(crdRecord.Tier_2_Copay_Reduction__c));
            writeXMLElement('TierThreeCopayReductionPercent', String.valueOf(crdRecord.Tier_3_Copay_Reduction__c));
            writeXMLElement('TierFourCopayReductionPercent', String.valueOf(crdRecord.Tier_4_Copay_Reduction__c));
            writeXMLElement('TierFiveCopayReductionPercent', String.valueOf(crdRecord.Tier_5_Copay_Reduction__c));

            for (AHA_Junction__c rec: AhaJunctionList) {
                if(rec.Selected__c == true){
                    w.writeStartElement(null, 'AHAJunction', null);
                    writeXMLElement('AHAJunctionID', String.valueOf(rec.Name));
                    writeXMLElement('AHADrugListID', String.valueOf(rec.Drug_List_ID__r.Name));
                    writeXMLElement('AHADrugListName', String.valueOf(rec.Drug_List_ID__r.Drug_List_Name__c));
                    writeXMLElement('AHADrugListDescription', String.valueOf(rec.Drug_List_ID__r.Description__c));
                    writeXMLElement('Selected', String.valueOf(rec.Selected__c));
                    writeXMLElement('AHADrugListLastSentDate', String.valueOf(rec.LastSent__c));
                    w.writeEndElement();
                }
            }
            
            // Aetna Rx Healthy Outcome Section
            w.writeComment('Aetna Rx Healthy Outcome Section');
            writeXMLElement('AetnaRxHealthyOutcomes', String.valueOf(crdRecord.Aetna_Rx_Healthy_Outcomes__c));
            writeXMLElement('ARHOfferingType', String.valueOf(crdRecord.ARH_Offering_Type__c));
            writeXMLElement('ARHODrugGroupID', String.valueOf(crdRecord.Aetna_RxHealthy_Outcomes_Drug_Group__r.Name));
            writeXMLElement('ARHODrugGroupLastSent', String.valueOf(crdRecord.Aetna_RxHealthy_Outcomes_Drug_Group__r.LastSent__c));
            writeXMLElement('TierOneRxReductionType', String.valueOf(crdRecord.Tier_1_Rx_Reduction_Type__c));
            writeXMLElement('TierOneRxReductionAmount', String.valueOf(crdRecord.Tier_1_Rx_Reduction_Amount__c));
            writeXMLElement('TierTwoRxReductionType', String.valueOf(crdRecord.Tier_2_Rx_Reduction_Type__c));
            writeXMLElement('TierTwoRxReductionAmount', String.valueOf(crdRecord.Tier_2_Rx_Reduction_Amount__c));
            writeXMLElement('TierThreeRxReductionType', String.valueOf(crdRecord.Tier_3_Rx_Reduction_Type__c));
            writeXMLElement('TierThreeRxReductionAmount', String.valueOf(crdRecord.Tier_3_Rx_Reduction_Amount__c));
            writeXMLElement('TierFourRxReductionType', String.valueOf(crdRecord.Tier_4_Rx_Reduction_Type__c));
            writeXMLElement('TierFourRxReductionAmount', String.valueOf(crdRecord.Tier_4_Rx_Reduction_Amount__c));
            writeXMLElement('TierFiveRxReductionType', String.valueOf(crdRecord.Tier_5_Rx_Reduction_Type__c));
            writeXMLElement('TierFiveRxReductionAmount', String.valueOf(crdRecord.Tier_5_Rx_Reduction_Amount__c));
            
            
            //added by JR for Request no 4288
            // Aetna RxStep Junction
            
            w.writeComment('Aetna RxStep Junction');
            writeXMLElement('AetnaRxStep', String.valueOf(crdRecord.Aetna_RxStep__c));
            

            for (Aetna_RxStep_Junction__c rec: ARSJunctionList) {
                if(rec.Selected__c == true){
                    w.writeStartElement(null, 'AetnaRxStepJunction', null);
                    writeXMLElement('AetnaRxStepJunctionID', String.valueOf(rec.Name));
                    writeXMLElement('AetnaRxStepJunctionDrugListID', String.valueOf(rec.Drug_List__r.Name));
                    writeXMLElement('AetnaRxStepJunctionDrugListName', String.valueOf(rec.Drug_Lists__c));                    
                    writeXMLElement('Selected', String.valueOf(rec.Selected__c));
                    writeXMLElement('AetnaRxStepJunctionDrugListLastSentDate', String.valueOf(rec.LastSent__c));
                    w.writeEndElement();
                }
            }

            // RxCheck Section
            w.writeComment('RxCheck Section');
            writeXMLElement('EnrollinRxCheck', String.valueOf(crdRecord.Enroll_in_RxCheck__c));
            writeXMLElement('WillyoubePickingDrugClasses', String.valueOf(crdRecord.Rx_Will_you_be_Picking_Drug_Classes__c));
            writeXMLElement('OverrideOptionRx', String.valueOf(crdRecord.Rx_Override_Option__c));
            
            for (Clinical_Program_Group_Junction__c rec: cpjgroupRecord) {
                if (rec.Record_Type__c == 'RxCheck') {
                            // w.writeStartElement(null, 'ClinicalProgramGroupJunctionRxCheck', null);

                    for (Clinical_Program_Group__c childRecord: cpgRecordList) {
                        if (childRecord.Id == rec.Clinical_Program_Group_ID__c) {
                             w.writeStartElement(null, 'ClinicalProgramGroupJunction', null);

                            writeXMLElement('ClinicalProgramGroupID', String.valueOf(rec.Clinical_Program_Group_ID__r.Name));
                            writeXMLElement('ClinicalProgramGroupLastSent', String.valueOf(rec.Clinical_Program_Group_ID__r.LastSent__c));
                            writeXMLElement('ClinicalProgramGroupRecordType', String.valueOf(rec.Record_Type__c));
                             
                            w.writeEndElement();
                        }
                    }
                                      //  w.writeEndElement();
                }
            }

            

            // Commenting Drug Group Expansion - Becca 12-13-12
            for (RxCheck_Junction__c rec: rcjRecord) {
                //w.writeComment('RxChecks Section');Commented per request from 11-28-12
                w.writeStartElement(null, 'RxCheckJunction', null);
                writeXMLElement('RxCheckJunctionID', String.valueOf(rec.Name));
                writeXMLElement('ClinicalProgramID', String.valueOf(rec.RxCheck__r.Name));
                writeXMLElement('ClinicalProgramName', String.valueOf(rec.RxCheck_Program_Name__c));
                writeXMLElement('ClinialProgramDescription', String.valueOf(rec.RxCheck__r.Description__c));
                w.writeEndElement(); // w.writeStartElement(null,'RxCheckJunction', null);
            }

            // Prescription Savings Program Section
            w.writeComment('Prescription Savings Program Section');
            writeXMLElement('EnrollPSP', String.valueOf(crdRecord.Do_Prescription_Savings_Program__c));
            writeXMLElement('PSPLetterTemplates', String.valueOf(crdRecord.PSP_Letter_Templates__c));
            writeXMLElement('OverrideOptionPSP', String.valueOf(crdRecord.PSP_Override_Option__c));
            for (Clinical_Program_Group_Junction__c rec: cpjgroupRecord) {
                if (rec.Record_Type__c == 'Prescription Savings Program') {
                  // w.writeStartElement(null, 'ClinicalProgramGroupJunctionPSP', null);

                    for (Clinical_Program_Group__c childRecord: cpgRecordList) {
                        if (childRecord.Id == rec.Clinical_Program_Group_ID__c) {
                            w.writeStartElement(null, 'ClinicalProgramGroupJunction', null);

                            writeXMLElement('ClinicalProgramGroupID', String.valueOf(rec.Clinical_Program_Group_ID__r.Name));
                            writeXMLElement('ClinicalProgramGroupLastSent', String.valueOf(rec.Clinical_Program_Group_ID__r.LastSent__c));
                            writeXMLElement('ClinicalProgramGroupRecordType', String.valueOf(rec.Record_Type__c));
                             
                            w.writeEndElement();
                            
                        }
                    }
                   //  w.writeEndElement();
                }
            }

            

            // Commenting Drug Group Expansion - Becca 12-13-12
            for (PSP_Junction__c rec: pspjRecord) {
                w.writeStartElement(null, 'PSPJunction', null);
                writeXMLElement('PSPJunctionID', String.valueOf(rec.Name));
                writeXMLElement('ClinicalProgramID', String.valueOf(rec.PSP_ID__r.Name));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('ClinicalProgramName', String.valueOf(rec.Prescription_Savings_Program_Drug_Class__c));
                writeXMLElement('ClinialProgramDescription', String.valueOf(rec.PSP_ID__r.Description__c));
                w.writeEndElement(); // w.writeStartElement(null,'PSPJunction', null);
            }

            //w.writeEndElement(); // w.writeStartElement(null,'PrescriptionSavingsProgram', null);Commented per request from 11-28-12

            // SaveACopay Section
            w.writeComment('SaveACopay Section');
            writeXMLElement('EnrollinSaveACopay', String.valueOf(crdRecord.Do_you_want_to_do_Save_A_Copay__c));
            //writeXMLElement('NumberofmonthsforCopayWaiver', String.valueOf(crdRecord.of_months_for_Copay_Waiver__c));
            //writeXMLElement('SaveACopayCustomLetter', String.valueOf(crdRecord.Save_A_Copay_Custom_Letter__r.Name));
            //writeXMLElement('SaveACopayCustomLetterLastSent', String.valueOf(crdRecord.Save_A_Copay_Custom_Letter__r.LastSent__c));
            //writeXMLElement('CVSCaremarkStellantID', String.valueOf(crdRecord.Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c));
            //writeXMLElement('SACLetterTemplates', String.valueOf(crdRecord.SAC_Letter_Templates__c));
            writeXMLElement('OverrideOptionSAC', String.valueOf(crdRecord.SAC_Override_Option__c));
            for (Clinical_Program_Group_Junction__c rec: cpjgroupRecord) {
                if (rec.Record_Type__c == 'Save-A-Copay') {
                 //w.writeStartElement(null, 'ClinicalProgramGroupJunctionSAC', null);

                    for (Clinical_Program_Group__c childRecord: cpgRecordList) {
                        if (childRecord.Id == rec.Clinical_Program_Group_ID__c) {
                            w.writeStartElement(null, 'Save-A-CopayGroupJunction', null);

                            writeXMLElement('Save-A-CopayGroupID', String.valueOf(rec.Clinical_Program_Group_ID__r.Name));
                            writeXMLElement('Save-A-CopayGroupName', String.valueOf(rec.Clinical_Program_Group_Name__c));
                            writeXMLElement('Save-A-CopayDescription', String.valueOf(rec.Clinical_Program_Group_ID__r.Clinical_Program_Group_Description__c));
                            /*for (Clinical_Program_Junction__c childjuncRecord: cpjRecord){ 
                                writeXMLElement('SACLetterTemplates', String.valueOf(childjuncRecord.Clinical_Program__r.SAC_Letter_Templates__r.name));
                                writeXMLElement('LetterDescription', String.valueOf(childjuncRecord.Clinical_Program__r.Letter_Description__c));
                                writeXMLElement('CVSCaremarkStellantID', String.valueOf(childjuncRecord.Clinical_Program__r.SAC_Letter_Templates__r.CVS_Caremark_Stellant_ID__c));
                                writeXMLElement('NumberofmonthsforCopayWaiver', String.valueOf(childjuncRecord.Clinical_Program__r.of_months_for_Copay_Waiver__c));
                                writeXMLElement('SACCampaignID', String.valueOf(childjuncRecord.Clinical_Program__r.SAC_Campaign_ID__c));
                            }*/ 
                            w.writeEndElement();
                        }
                    }
                                    //w.writeEndElement();
                }
            }

            // Commenting Drug Group Expansion - Becca 12-13-12
            for (Save_A_Copay_Junction__c rec: sacRecord) {
                w.writeStartElement(null, 'SACJunction', null);
                writeXMLElement('SACJunctionID', String.valueOf(rec.Name));
                //writeXMLElement('ClinicalProgramID', String.valueOf(rec.Save_A_Copay_ID__r.Name));
                writeXMLElement('CVSCaremarkDrugListID','');
                writeXMLElement('Save-A-CopayDrugClass', String.valueOf(rec.Save_A_Copay_Drug_Class__c));
                writeXMLElement('Save-A-CopayProgramDescription', String.valueOf(rec.Save_A_Copay_ID__r.Description__c));
                //writeXMLElement('SACLetterTemplates', String.valueOf(rec.Save_A_Copay_ID__r.SAC_Letter_Templates__r.name));
                //writeXMLElement('LetterDescription', String.valueOf(rec.Save_A_Copay_ID__r.Letter_Description__c));
                //writeXMLElement('CVSCaremarkStellantID', String.valueOf(rec.Save_A_Copay_ID__r.SAC_Letter_Templates__r.CVS_Caremark_Stellant_ID__c));
                //writeXMLElement('NumberofmonthsforCopayWaiver', String.valueOf(rec.Save_A_Copay_ID__r.of_months_for_Copay_Waiver__c));
                //writeXMLElement('SACCampaignID', String.valueOf(rec.Save_A_Copay_ID__r.SAC_Campaign_ID__c));
                
                w.writeEndElement(); // w.writeStartElement(null,'SACJunction', null);
            }

            //w.writeEndElement(); // w.writeStartElement(null,'SaveACopay', null);Commented per request from 11-28-12

            // StepTherapy Section
            w.writeComment('StepTherapy Section');
            writeXMLElement('IsThereStepTherapy', String.valueOf(crdRecord.Do_you_want_to_do_Step_Therapy__c));
            writeXMLElement('ChooseSTDrugGroupOrSTDrugList', String.valueOf(crdRecord.Standard_Program_or_Select_Classes__c));
            writeXMLElement('StepTherapyTOCNumberofdays', String.valueOf(crdRecord.Step_Therapy_TOC_days__c));
            writeXMLElement('StepTherapyDrugGroup', String.valueOf(crdRecord.Standard_Step_Therapy_Program__r.Name));
            writeXMLElement('StepTherapyDrugGroupLastSent', String.valueOf(crdRecord.Standard_Step_Therapy_Program__r.LastSent__c));


            

            writeXMLElement('CustomStepTherapyClasses', String.valueOf(crdRecord.Custom_Step_Therapy_Classes__c));
            writeXMLElement('ApprovedFromCustomFormularyST', String.valueOf(crdRecord.Approved_from_CustFormulary_Committee_ST__c));
            writeXMLElement('CustomStepTherapyDateApproved', String.valueOf(crdRecord.Custom_Step_Therapy_Date_Approved_ST__c));

            //w.writeStartElement(null,'StepTherapyJunction', null);Commented per request from 11-28-12
            for (CRD_Step_Therapy_Junction__c rec: stjRecord) {
                w.writeStartElement(null, 'StepTherapyDrugList', null);
                writeXMLElement('StepTherapyClassID', String.valueOf(rec.Step_Therapy_DrugList_Class__r.Name));
                writeXMLElement('StepTherapyClassLastSent', String.valueOf(rec.Step_Therapy_DrugList_Class__r.LastSent__c));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('StepTherapyClassName', String.valueOf(rec.Step_Therapy_DrugList_Class__r.Drug_List_Name__c));
                writeXMLElement('StepTherapyClassDescription', String.valueOf(rec.Step_Therapy_DrugList_Class__r.Description__c));
                w.writeEndElement(); // w.writeStartElement(null,'StepTherapyDrugList', null);
            }
            //w.writeEndElement(); // w.writeStartElement(null,'StepTherapyJunction', null);Commented per request from 11-28-12

            // Prior Authorization Section
            w.writeComment('Prior Authorization Section');
            writeXMLElement('IsTherePrecert', String.valueOf(crdRecord.Do_you_want_to_do_Precert__c));
            writeXMLElement('ChoosePADrugGroupOrPADrugList', String.valueOf(crdRecord.Standard_Precert_List_or_Select_Classes__c));
            writeXMLElement('PrecertTOCNumberdays', String.valueOf(crdRecord.Precert_TOC_days__c));
            writeXMLElement('PrecertDrugGroup', String.valueOf(crdRecord.Standard_Precert_Program__r.Name));
            writeXMLElement('PrecertDrugGroupLastSent', String.valueOf(crdRecord.Standard_Precert_Program__r.LastSent__c));

            

            writeXMLElement('CustomPrecertClasses', String.valueOf(crdRecord.Custom_Precert_Classes__c));
            writeXMLElement('ApprovedFromCustomFormularyPA', String.valueOf(crdRecord.Approved_from_CustFormulary_Committee_PA__c));
            writeXMLElement('CustomPrecertDateApproved', String.valueOf(crdRecord.Custom_Precert_Date_Approved__c));
            //writeXMLElement('OptoutofNPL', String.valueOf(crdRecord.Opt_out_of_Rx_OTC_Edit__c));

            // PriorAuthorizationJunction (Line 1567)
            for (CRD_PriorAuth_Junction__c rec: pajRecord) {
                w.writeStartElement(null, 'PriorAuthorizationDrugList', null);
                writeXMLElement('PrecertClassID', String.valueOf(rec.Precert_Class__r.Name));
                writeXMLElement('PrecertClassLastSent', String.valueOf(rec.Precert_Class__r.LastSent__c));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('PrecertClassName', String.valueOf(rec.Precert_Class__r.Drug_List_Name__c));
                writeXMLElement('PrecertClassDescription', String.valueOf(rec.Precert_Class__r.Description__c));
                w.writeEndElement(); // w.writeStartElement(null,'PriorAuthorizationDrugList', null);
            }
            /*******Start**************
            added by abhishek date on 02/12/2015 for request 05558/05559 *************/
            // Split Fill Section 
            w.writeComment('Split Fill Section');
            writeXMLElement('IsThereSplitFill', String.valueOf(crdRecord.Is_there_split_fill__c));
            writeXMLElement('SplitFillDrugListID', String.valueOf(crdRecord.Split_Fill_Drug_List__r.name));
            writeXMLElement('SplitFillDrugListName', String.valueOf(crdRecord.Split_Fill_Drug_List__r.Drug_List_Name__c));
            writeXMLElement('SplitFillDrugListDescription', String.valueOf(crdRecord.Split_Fill_Drug_List__r.Description__c ));
            /*******End**************
            added by abhishek date on 02/12/2015 for request 05558/05559 *************/
            // Quantity Limits Section
            w.writeComment('Quantity Limits Section');
            writeXMLElement('ArethereQuantityLimits', String.valueOf(crdRecord.Are_there_Quantity_Limits__c));
            writeXMLElement('ChooseQLDrugGroupOrQLDrugList', String.valueOf(crdRecord.Standard_QL_List_or_Select_Classes__c));
            writeXMLElement('QuantityLimitTOCNumberdays', String.valueOf(crdRecord.Quantity_Limit_TOC_of_Days__c));
            writeXMLElement('QuantityLimitDrugGroup', String.valueOf(crdRecord.Standard_QL_Program__r.Name));
            writeXMLElement('QuantityLimitDrugGroupLastSent', String.valueOf(crdRecord.Standard_QL_Program__r.LastSent__c));
            writeXMLElement('CustomQuantityLimitsClasses', String.valueOf(crdRecord.Custom_Quantity_Limits_Classes__c));
            writeXMLElement('ApprovedFromCustomFormularyQL', String.valueOf(crdRecord.Approved_from_CustFormulary_Committee_QL__c));
            writeXMLElement('CustomStepTherapyDateAproveQL', String.valueOf(crdRecord.Custom_Step_Therapy_Date_Approved_QL__c));

            //w.writeStartElement(null,'QLJuction', null);Commented per request from 11-28-12
            for (CRD_Quantity_Limit_Junction__c rec: qljRecord) {
                w.writeStartElement(null, 'QuantityLimitDrugList', null);
                writeXMLElement('QuantityLimitClassID', String.valueOf(rec.QL_Class__r.Name));
                writeXMLElement('QuantityLimitClassLastSent', String.valueOf(rec.QL_Class__r.LastSent__c));
                writeXMLElement('CVSCaremarkDrugListID', '');
                writeXMLElement('QuantityLimitClassName', String.valueOf(rec.QL_Class__r.Drug_List_Name__c));
                writeXMLElement('QuantityLimitClassDescription', String.valueOf(rec.QL_Class__r.Description__c));
                w.writeEndElement(); // w.writeStartElement(null,'QuantityLimitDrugList', null);
            }
            //w.writeEndElement(); // w.writeStartElement(null,'QLJuction', null);Commented per request from 11-28-12

            // Standard Safety Edit Section
            w.writeComment('Standard Safety Edits');
            writeXMLElement('OptOutOfSafetyEdits', String.valueOf(crdRecord.Opt_out_of_Safety_Edits__c));
            //Added by Amit Jain for CVH Sprint 5, 1April '14
            for (Drug_List_Junction__c record: SEJRecord) {
            //for (CRD_Standard_Safety_Edit_Junction__c seJunction: crdRecord.CRD_Standard_Safety_Edit_Junction__r) {
                if (record.Parent_Drug_Group_Name__c != null) {
                    w.writeStartElement(null, 'SSEDrugGroup', null);
                    writeXMLElement('ParentDrugGroupID', String.valueOf(record.Parent_Drug_Group__r.Name));
                    writeXMLElement('DrugListID', String.valueOf(record.Drug_List__r.Name));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('DrugListName', String.valueOf(record.Drug_List_Name__c));
                    writeXMLElement('DrugListDescription', String.valueOf(record.Drug_List__r.Description__c));
                    w.writeEndElement();
                }   
            }
            //**ends
            w.writeComment('Custom Safety Edits');
            writeXMLElement('CustomSafetyEdits', String.valueOf(crdRecord.Custom_Safety_Edits__c));
            for (CRD_Standard_Safety_Edit_Junction__c sseJunction: crdRecord.CRD_Standard_Safety_Edit_Junction__r) {
                if (sseJunction.Drug_List__c != null && sseJunction.Select__c == True) {

                    w.writeStartElement(null, 'CSEDrugList', null);
                    writeXMLElement('DrugListID', String.valueOf(sseJunction.Drug_List_ID__c));
                    writeXMLElement('DrugListLastSent', String.valueOf(sseJunction.Drug_List__r.LastSent__c));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('DrugListName', String.valueOf(sseJunction.Drug_List_Name__c));
                    writeXMLElement('DrugListDescription', String.valueOf(sseJunction.Drug_List_Description__c));
                    w.writeEndElement(); // w.writeStartElement(null,'CSEDrugList', null);
                }
            }
        // Richa added NPL Section on 14/8 for Req - 4872
            w.writeComment('Standard NPL');
            writeXMLElement('OptoutofNPL', String.valueOf(crdRecord.Opt_out_of_Rx_OTC_Edit__c));
            writeXMLElement('NPLApplies', String.valueOf(crdRecord.NPL_Applies__c));
            writeXMLElement('NPLDrugList', String.valueOf(crdRecord.NPL_Drug_List__r.Name)); 
            writeXMLElement('NPLDrugListLastSent', String.valueOf(crdRecord.NPL_Drug_List__r.LastSent__c));
            writeXMLElement('NPLCVSCaremarkDrugListID','');
            writeXMLElement('NPLDrugListName', String.valueOf(crdRecord.NPL_Drug_List__r.Drug_List_Name__c));
            writeXMLElement('NPLDrugListDescription', String.valueOf(crdRecord.NPL_Drug_List__r.Description__c));           
        for (CRD_NPL_Junction__c nplRecord: crdNPLJuncList) {
                if (nplRecord.Drug_List__c != null && nplRecord.IsStandard__c) {
                    w.writeStartElement(null, 'NPLStandardDrugList', null);
                    writeXMLElement('DrugListID', String.valueOf(nplRecord.Drug_List__r.Name));
                    writeXMLElement('DrugListLastSent', String.valueOf(nplRecord.Drug_List__r.LastSent__c));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('DrugListName', String.valueOf(nplRecord.Drug_List_Name__c));
                    writeXMLElement('DrugListDescription', String.valueOf(nplRecord.Drug_List_Description__c));
                    w.writeEndElement();
        }  
      }
            w.writeComment('Custom NPL');
            for (CRD_NPL_Junction__c nplRecord: crdNPLJuncList) {
                if (nplRecord.Drug_List__c != null && !nplRecord.IsStandard__c) {
                    w.writeStartElement(null, 'NPLCustomDrugList', null);
                    writeXMLElement('DrugListID', String.valueOf(nplRecord.Drug_List__r.Name));
                    writeXMLElement('DrugListLastSent', String.valueOf(nplRecord.Drug_List__r.LastSent__c));
                    writeXMLElement('CVSCaremarkDrugListID', '');
                    writeXMLElement('DrugListName', String.valueOf(nplRecord.Drug_List_Name__c));
                    writeXMLElement('DrugListDescription', String.valueOf(nplRecord.Drug_List_Description__c));
                    w.writeEndElement();  
        }
      }
            // CAG Information Section
            w.writeComment('CAG Information');
            for (CSAP_CGLP_Junction__c rec: CSAP_CGLPRecordList) {
                w.writeStartElement(null, 'CAGInformation', null);
                writeXMLElement('CAGInformationID', String.valueOf(rec.Name));
                writeXMLElement('ContractState', String.valueOf(rec.Full_Control_Group__r.Contract_State__c));
                writeXMLElement('CAGGroupID', String.valueOf(rec.Full_Control_Group__r.CAG_Group_ID__c));
                writeXMLElement('CarrierID', String.valueOf(rec.Full_Control_Group__r.Carrier_ID__c));
                writeXMLElement('CAGAccountID', String.valueOf(rec.Full_Control_Group__r.CAG_Account_ID__c));               
                w.writeEndElement();
            }
            
            //Retail Vaccine Program Section
            w.writeComment('Retail Vaccine Program');
            
            for(Retail_Vaccine_Program__c rvp : RVPRecordList){
                w.writeStartElement(null,'RetailVaccineProgram',null);
                writeXMLElement('Type', String.valueOf(rvp.recordtype.name));
                writeXMLElement('Applies', String.valueOf(rvp.Applies__c));
                writeXMLElement('WaiverOfDeductible', String.valueOf(rvp.Waiver_of_Deductible__c));
                writeXMLElement('DollarAmount', String.valueOf(rvp.Dollar_Amount__c));
                writeXMLElement('Percent', String.valueOf(rvp.Percent__c)); 
                writeXMLElement('CopayCalculation', String.valueOf(rvp.CoPay_Calculation__c));
                writeXMLElement('MinimumDollar', String.valueOf(rvp.Minimum_Dollar__c));
                writeXMLElement('MaximumDollar', String.valueOf(rvp.Maximum_Dollar__c));
                w.writeEndElement();
            }
            
            w.writeEndElement(); // w.writeStartElement(null,'CRD', null);
            w.writeEndDocument();
            String xmlOutput = w.getXmlString();
            w.close();

            // Create case and save as attachment
            Case c = new Case();
            c.Previous_RxPlan_ID__c = crdRecord.Old_RxPlan_ID__c;
            c.CRD_ID__c = crdRecord.Id;
            c.RxPlan_ID__c = crdRecord.RxPlanID__c;
            c.Status = 'New';
            c.Aetna_Case_Type__c = 'CRD Case';
            c.AccountId = crdRecord.Account__c;
            c.CVS_Account_ID__c = String.valueOf(crdRecord.PSU__c);
            c.CVS_Carrier_ID__c = String.valueOf(crdRecord.Full_Control_Group__r.Carrier_ID__c);
            c.Control_Group_Number__c = String.valueOf(crdRecord.Partial_Control_Group__r.CSAP_Control_ID__c) + String.valueOf(crdRecord.Partial_Control_Group__r.CSAP_Plan_ID__c);
            c.CRD_GMF_Case_Status__c = 'New';
            c.CRD_Benefits__c = true;
            c.Acquisition_Indicator__c = crdRecord.Acquisition_Indicator__c;
            c.Is_there_a_PG_associated_with_GMF__c = false;
            c.Effective_Date__c = crdRecord.Effective_Start_Date__c;
            c.BPERxPlan_ID__c = crdRecord.BPERxPlan_ID__c;
            c.Run_Number__c = string.valueOf(crdRecord.Migration_Run_Number__c);
            c.Subject = crdRecord.Name;
            c.Description = crdRecord.Plan_Description__c;
            if(crdRecord.Standard_or_Custom_Plan__c == 'Creating a HIX plan'|| crdRecord.Standard_or_Custom_Plan__c=='Cloning a HIX plan from existing CRD') {
                c.HIX__c = true;
                } else {
                    c.HIX__c = false;
                }
            if (crdRecord.Are_you_creating_a_Package_Plan__c == 'Yes') {
                c.CRD_Package_Plan__c = true;
            } else {
                c.CRD_Package_Plan__c = false;
            }
            //c.RecordTypeId = [Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
            c.RecordTypeId = System.label.CL0000069;//Replaced the query by custom label
            // Added by JR to implement request no 5072, this will be implemented only for CRD's created through CRD Builder Process
            if(crdRecord.CRD_Automated__c){
                for (Drug_Coverage__c record: DCRecord) {
                    if(record.recordtypeid == MailTypeRecord){                                  
                        if(record.Maintenance_Choice__c=='Mandatory'||record.Maintenance_Choice__c=='Incentivized'||record.Maintenance_Choice__c=='Voluntary'){
                            c.CRD_GMF_Clinical_Programs__c=true;
                            c.CRD_Pricing__c=true;
                        }
                    }
                }
                 //Query Added by Sushant for Req 05223 -- Start
                //List<Group> lstQueues = [Select Id,name from Group where name = 'EZ Test Reviews Queue' LIMIT 1];
                //Query Ends
                //Amit replaced List by variable, and removed the query and used custom label
                if(crdRecord.Do_you_want_to_do_Save_A_Copay__c=='yes'||crdRecord.Do_Prescription_Savings_Program__c=='yes'||crdRecord.Adherence_to_Drug_Therapy__c==true ||crdRecord.Pharmacy_Advisor__c==true){
                    c.CRD_GMF_Clinical_Programs__c=true;
                }
                for (Network_Junction__c record: NJRecord) {
                    if(record.Mail_Custom__c!=null || record.Retail_Custom__c!=null ||record.Specialty_Custom__c!=null ){
                        c.CRD_GMF_Network__c = true;
                    }
                }
                c.CRD_GMF_Case_Status__c='Submitted';
                c.CRD_GMF_Case_Types__c = 'New CRD for creating a new plan';
                c.CRD_RDS__c = false;
                c.CRD_Specialty__c=true;
                //c.OwnerID= lstQueues[0].id; //Owner Added by Sushant for Req 05223
                c.OwnerID = System.label.CL0000068;//Added by Amit
            }
            
            //Added for ST#543 starts
            //Added for ST#1299 by abhishek
            if (!(crdRecord.CRD_Automated__c)) 
            { 
                RecordType rt= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1]; 
                Case FalloutcasesforCRD = new case();
                Case[] Caselist= [select id,fifo_tag__c, transaction_type__c from case where RecordTypeId =: rt.Id and (CRD_name__c=: crdRecord.Id or CRD_id__c=: crdRecord.Id ) order by lastmodifieddate desc LIMIT 1];
                if (Caselist.size() > 0)
                    FalloutcasesforCRD = Caselist[0];
            
                if ( (FalloutcasesforCRD!=null)&&(FalloutcasesforCRD.fifo_tag__c!=null))
                {
                    if(crdRecord.Custom_Network_Flag__c){
                        c.fifo_tag__c = 'General';
                    }
                    else{
                        c.fifo_tag__c = FalloutcasesforCRD.fifo_tag__c;
                    }
                    c.transaction_type__c = FalloutcasesforCRD.transaction_type__c;
                }
                else {
                    c.fifo_tag__c = 'General';
                }
            }
            //Added for ST#543 ends

            insert c;

            Blob xmlblob = Blob.valueof(xmlOutput);
            Attachment xmlAttach = new Attachment();
            xmlAttach.body = xmlblob;
            xmlAttach.Name = crdRecord.Name + '.xml';
            xmlAttach.parentId = c.Id;
            xmlAttach.contentType = 'XML';
            insert xmlAttach;
            return c.id;
        }
        
        /* 
         * Method :-  writeDrugListCriteria
         * Description :- This Method  generates XML Element for Drug List Criteria 
         */    
        Public void writeDrugListCriteria(Drug_List_Criteria__c dlcrecord) {
            w.writeStartElement(null, 'DrugListCriteria', null);
            writeXMLElement('DrugListCriteriaID', String.valueOf(dlcrecord.Name));
            writeXMLElement('RecordType', String.valueOf(dlcrecord.RecordType.Name));
            writeXMLElement('EffectiveDate', String.valueOf(dlcrecord.Effective__c));
            writeXMLElement('TerminationDate', String.valueOf(dlcrecord.Term__c));
            writeXMLElement('DrugTypeCode', String.valueOf(dlcrecord.Drug_Type_Code__c));
            writeXMLElement('DrugCodeValue', String.valueOf(dlcrecord.Drug_Code_Value__c));
            writeXMLElement('DrugListCriteriaDescription', String.valueOf(dlcrecord.Drug_List_Criteria_Description__c));
            writeXMLElement('Inactive', String.valueOf(dlcrecord.Inactive__c));
            writeXMLElement('AllowTransitionFill', String.valueOf(dlcrecord.Allow_Transition_Fill__c));
            writeXMLElement('TOCapplies', String.valueOf(dlcrecord.TOC_applies__c));
            writeXMLElement('ShouldcounttowardsmeetingSTProtocol', String.valueOf(dlcrecord.Should_count_towards_meeting_ST_Protocol__c));
            writeXMLElement('NDC', String.valueOf(dlcrecord.NDC__c));
            writeXMLElement('DescriptionNDCCriteria', String.valueOf(dlcrecord.Description_of_NDC_Drug_List_Criteria__c));
            writeXMLElement('Status', String.valueOf(dlcrecord.Status__c));
            writeXMLElement('MSCodeM', String.valueOf(dlcrecord.MS_Code_M__c));
            writeXMLElement('MSCodeN', String.valueOf(dlcrecord.MS_Code_N__c));
            writeXMLElement('MSCodeO', String.valueOf(dlcrecord.MS_Code_O__c));
            writeXMLElement('MSCodeY', String.valueOf(dlcrecord.MS_Code_Y__c));
            writeXMLElement('Rx', String.valueOf(dlcrecord.Rx__c));
            writeXMLElement('OTC', String.valueOf(dlcrecord.OTC__c));
            writeXMLElement('Repack', String.valueOf(dlcrecord.Repack__c));
            writeXMLElement('DESI', String.valueOf(dlcrecord.DESI__c));
            writeXMLElement('Maintenance', String.valueOf(dlcrecord.Maintenance__c));
            writeXMLElement('NonMaintenance', String.valueOf(dlcrecord.Non_Maintenance__c));
            writeXMLElement('RouteofAdministration', String.valueOf(dlcrecord.Route__c));
            writeXMLElement('DAWCode', String.valueOf(dlcrecord.DAW_Code__c));
            writeXMLElement('UnitCost', String.valueOf(dlcrecord.Unit_Cost__c));
            writeXMLElement('ForcetoSpecialty', String.valueOf(dlcrecord.Force_to_Specialty__c));
            
            writeXMLElement('HundredPercentCopay', String.valueOf(dlcrecord.X100_Copay__c));
            writeXMLElement('ZeroCopay', String.valueOf(dlcrecord.Zero_Copay__c));
            writeXMLElement('ExcludedfromDeductible', String.valueOf(dlcrecord.Excluded_from_Deductible__c));
            writeXMLElement('Funding', String.valueOf(dlcrecord.Funding__c));
            writeXMLElement('Prescriber', String.valueOf(dlcrecord.Prescriber__r.Name));
            writeXMLElement('PrescriberName', String.valueOf(dlcrecord.Prescriber_Name__c));
            writeXMLElement('PrescriberDescription', String.valueOf(dlcrecord.Prescriber_Description__c));
            writeXMLElement('Speciality', String.valueOf(dlcrecord.Speciality__r.Name));
            writeXMLElement('SpecialtyName', String.valueOf(dlcrecord.Specialty_Name__c));
            writeXMLElement('SpecialtyDescription', String.valueOf(dlcrecord.Specialty_Description__c));
            writeXMLElement('LabTests', String.valueOf(dlcrecord.Lab_Tests__r.Name));
            writeXMLElement('LabTestsName', String.valueOf(dlcrecord.Lab_Tests_Name__c));
            writeXMLElement('LabTestDescription', String.valueOf(dlcrecord.Lab_Test_Description__c));
            writeXMLElement('Diagnosis', String.valueOf(dlcrecord.Diagnosis__r.Name));
            writeXMLElement('DiagnosisName', String.valueOf(dlcrecord.Diagnosis_Name__c));
            writeXMLElement('DiagnosisDescription', String.valueOf(dlcrecord.Diagnosis_Description__c));
            writeXMLElement('Provider', String.valueOf(dlcrecord.Provider__r.Name));
            writeXMLElement('ProviderName', String.valueOf(dlcrecord.Provider_Name__c));
            writeXMLElement('ProviderDescription', String.valueOf(dlcrecord.Provider_Descriptoin__c));
            writeXMLElement('StartAge', String.valueOf(dlcrecord.Start_Age__c));
            writeXMLElement('StartAgeType', String.valueOf(dlcrecord.Start_Age_Type__c));
            writeXMLElement('EndAge', String.valueOf(dlcrecord.End_Age__c));
            writeXMLElement('EndAgeType', String.valueOf(dlcrecord.End_Age_Type__c));
            writeXMLElement('Gender', String.valueOf(dlcrecord.Gender__c));
            writeXMLElement('Grandfathering', String.valueOf(dlcrecord.Grandfathering__c));
            writeXMLElement('TransitionofCare', String.valueOf(dlcrecord.Transition_of_Care__c));
            writeXMLElement('Message', String.valueOf(dlcrecord.Message__c));
            writeXMLElement('MessageAction', String.valueOf(dlcrecord.Message_Action__c));
            writeXMLElement('MinimumDays', String.valueOf(dlcrecord.Minimum_Days__c));
            writeXMLElement('MaximumDays', String.valueOf(dlcrecord.Maximum_Days__c));
            writeXMLElement('MinimumQuantity', String.valueOf(dlcrecord.Minimum_Quantity__c));
            writeXMLElement('MaximumQuantity', String.valueOf(dlcrecord.Maximum_Quantity__c));
            writeXMLElement('DayQuantityRule', String.valueOf(dlcrecord.Rule__c));
            writeXMLElement('MaximumDollars', String.valueOf(dlcrecord.Maximum_Dollars__c));
            writeXMLElement('MaximumFills', String.valueOf(dlcrecord.Maximum_Fills__c));
            writeXMLElement('DailyDose', String.valueOf(dlcrecord.Daily_Dose__c));
            writeXMLElement('MaxDaysperFill', String.valueOf(dlcrecord.Max_Days_per_Fill__c));
            writeXMLElement('MaxQuantityperFill', String.valueOf(dlcrecord.Max_Quantity_per_Fill__c));
            writeXMLElement('DaysoverTimeNumberofDays', String.valueOf(dlcrecord.Days_over_Time_of_Days__c));
            writeXMLElement('DaysoverTimeTimePeriod', String.valueOf(dlcrecord.Days_over_Time_Time_Period__c));
            writeXMLElement('DaysoverTimeTimeValue', String.valueOf(dlcrecord.Days_over_Time_Time_Value__c));
            writeXMLElement('QuantityoverTimeQuantity', String.valueOf(dlcrecord.Quantity_over_Time_Quantity__c));
            writeXMLElement('QuantityoverTimeTimePeriod', String.valueOf(dlcrecord.Quantity_over_Time_Time_Period__c));
            writeXMLElement('QuantityoverTimeTimeValue', String.valueOf(dlcrecord.Quantity_over_Time_Time_Value__c));
            w.writeEndElement(); // w.writeStartElement(null,'DrugListCriteria', null);
        }
        /* Richa commented the section for 4882  
         * Method :- writeCRDPricingXML
         * Description :- This Method generate XML Element for CRD Pricing*/
                
        private void writeCRDPricingXML() {
/*             for (CRD_Pricing__c record: PRecord) {
                w.writeComment('CRD Pricing Section');
                w.writeStartElement(null, 'CRDPricing', null);
                writeXMLElement('CRDPricingName', String.valueOf(record.Name));
                writeXMLElement('StandardOrCustomPricing', String.valueOf(record.Standard_or_Custom_Pricing__c));
                writeXMLElement('PSUniqueID', String.valueOf(record.PSUnique_ID__c));
                writeXMLElement('RxPricing', String.valueOf(record.Rx_Pricing__r.Name));
                writeXMLElement('SpecialtyClientDrugList', String.valueOf(record.Specialty_Client_Drug_List__c));

                writeXMLElement('Platform', String.valueOf(record.Platform__c));
                writeXMLElement('ClientAuditofRtlRxCntrcts', String.valueOf(record.Client_Audit_of_Rtl_Rx_Cntracts__c));
                writeXMLElement('ContractEffectiveDate', String.valueOf(record.Contract_Effective_Date__c));
                writeXMLElement('Consultant', String.valueOf(record.Consultant__c));
                writeXMLElement('ContractEndDate', String.valueOf(record.Contract_End_Date__c));
                writeXMLElement('EarlyPricing', String.valueOf(record.Early_Pricing__c));
                writeXMLElement('ContractTerms', String.valueOf(record.Contract_Terms__c));
                writeXMLElement('EscalatingPricing', String.valueOf(record.Escalating_Pricing__c));
                writeXMLElement('ContractTermYear', String.valueOf(record.Contract_Term_Year__c));
                writeXMLElement('MaintenanceChoiceApplies', String.valueOf(record.Maintenance_Choice_Applies__c));
                writeXMLElement('CompetitiveMktCheckClause', String.valueOf(record.Competitive_Mkt_Check_Clause__c));
                writeXMLElement('BaseRetailNetworkName', String.valueOf(record.Base_Retail_Network_Name__c));
                writeXMLElement('Termwithoutcause', String.valueOf(record.Term_without_cause__c));
                writeXMLElement('DysWrittenNoticeBfrTerm', String.valueOf(record.Dys_written_notice_bfr_term__c));
                writeXMLElement('MACEffectiveDate', String.valueOf(record.MAC_Effective_Date__c));

                w.writeComment('Retail Pricing Section');
                writeXMLElement('RetailPricingEffectiveDate', String.valueOf(record.Retail_Pricing_Effective_Date__c));
                writeXMLElement('RtlAdjudicatnLogic_Client', String.valueOf(record.Rtl_Adjudicatn_Logic_Client__c));
                writeXMLElement('RetailPricingEndDate', String.valueOf(record.Retail_Pricing_End_Date__c));
                writeXMLElement('RtlAdjudicatnLogic_Mbr', String.valueOf(record.Rtl_Adjudicatn_Logic_Mbr__c));
                writeXMLElement('RetailPriceType', String.valueOf(record.Retail_Price_Type__c));
                writeXMLElement('RetailGuarReconFreq', String.valueOf(record.Retail_Guar_Recon_Freq__c));
                writeXMLElement('RetailDiscountBasis', String.valueOf(record.Retail_Discount_Basis__c));
                writeXMLElement('RetailGuarReconMethod', String.valueOf(record.Retail_Guar_Recon_Method__c));
                writeXMLElement('BrndDrugGencAvailApplyMAC', String.valueOf(record.Brnd_Drug_Gen_Avail_Apply_MAC__c));
                writeXMLElement('RetailGenericFlatDiscount', String.valueOf(record.Retail_Generic_Flat_Discount__c));
                writeXMLElement('RetailNonMACGenericDiscount', String.valueOf(record.Retail_Non_MAC_Generic_Discount__c));
                writeXMLElement('RetailGenericDispensingFee', String.valueOf(record.Retail_Generic_Dispensing_Fee__c));

                writeXMLElement('RetailNonPreferredBrandDiscnt', String.valueOf(record.Retail_Non_Preferred_Brand_Discount__c));
                writeXMLElement('RtlGenEffRateGuarOne', String.valueOf(record.Rtl_Gen_Eff_Rate_Guar1__c));
                writeXMLElement('RetailBrandDiscount', String.valueOf(record.Retail_Brand_Discount__C));
                writeXMLElement('RetailBrandDispensingFee', String.valueOf(record.Retail_Brand_Dispensing_Fee__c));
                writeXMLElement('RtlGenDiscGuarOne_MACOnly', String.valueOf(record.Rtl_Gen_Disc_Guar1_MAC_Only__c));
                writeXMLElement('RtlGenDiscGuarOne_ZBDs', String.valueOf(record.Rtl_Gen_Disc_Guar1_ZBDs__c));
                writeXMLElement('RetailMACApplies', String.valueOf(record.Retail_MAC_Applies__c));
                writeXMLElement('RtlGenDiscGuarOne_UAndC', String.valueOf(record.Rtl_Gen_Disc_Guar1_UC__c));
                writeXMLElement('RetailMACListID', String.valueOf(record.Retail_MAC_List_ID2__c));
                writeXMLElement('RtlGenDiscGuarOne_SSGs', String.valueOf(record.Rtl_Gen_Disc_Guar1_SSGs__c));
                writeXMLElement('RetailMACPercent', String.valueOf(record.Retail_MAC_Percent2__c));
                writeXMLElement('RtlGenDiscGuarOne_BrandMAC', String.valueOf(record.Rtl_Gen_Disc_Guar1_Brand_MAC__c));
                writeXMLElement('RetailCustomMACApplies', String.valueOf(record.Retail_Custom_MAC_Applies__c));
                writeXMLElement('RetailCustomMACListID', String.valueOf(record.Retail_Custom_MAC_List_ID__c));
                writeXMLElement('RtlGenEffRateGuarTwo', String.valueOf(record.Rtl_Gen_Eff_Rate_Guar2__c));
                writeXMLElement('RtlGenDiscGuarTwo_MACOnly', String.valueOf(record.Rtl_Gen_Disc_Guar2_MAC_Only__c));
                writeXMLElement('RtlBrndEffRateGuar', String.valueOf(record.Rtl_Brnd_Eff_Rate_Guar__c));
                writeXMLElement('RtlGenDiscGuarTwo_ZBDs', String.valueOf(record.Rtl_Gen_Disc_Guar2_ZBDs__c));
                writeXMLElement('RtlBrndDiscGuar_ZBDs', String.valueOf(record.Rtl_Brnd_Disc_Guar_ZBDs__c));
                writeXMLElement('RtlGenDiscGuarTwo_UAndC', String.valueOf(record.Rtl_Gen_Disc_Guar2_UC__c));
                writeXMLElement('RtlBrndDiscGuar_UAndC', String.valueOf(record.Rtl_Brnd_Disct_Guar_UC__c));
                writeXMLElement('RtlGenDiscGuarTwo_SSGs', String.valueOf(record.Rtl_Gen_Disc_Guar2_SSGs__c));
                writeXMLElement('RtlBrndDiscGuar_SSGs', String.valueOf(record.Rtl_Brnd_Disc_Guar_SSGs__c));
                writeXMLElement('RtlGenDiscGuarTwo_BrndMAC', String.valueOf(record.Rtl_Gen_Disc_Guar2_Brnd_MAC__c));
                writeXMLElement('RtlBrndDiscGuar_BrndMAC', String.valueOf(record.Rtl_Brnd_Disc_Guar_Brnd_MAC__c));
                writeXMLElement('OtherRetailDiscGuarProv', String.valueOf(record.Other_Retail_Disc_Guar_Prov__c));

                w.writeComment('Mail Pricing Section');
                writeXMLElement('MailPricingEffectiveDate', String.valueOf(record.Mail_Pricing_Effective_Date__c));
                writeXMLElement('MailAdjudicatnLogic_Client', String.valueOf(record.Mail_Adjudicatn_Logic_Client__c));
                writeXMLElement('MailPricingEndDate', String.valueOf(record.Mail_Pricing_End_Date__c));
                writeXMLElement('MailAdjudicatnLogic_Mbr', String.valueOf(record.Mail_Adjudicatn_Logic_Mbr__c));
                writeXMLElement('MailPriceType', String.valueOf(record.Mail_Price_Type__c));
                writeXMLElement('MailGuaranateeReconMethod', String.valueOf(record.Mail_Guaranatee_Recon_Method__c));
                writeXMLElement('MailDiscountBasis', String.valueOf(record.Mail_Discount_Basis__c));
                writeXMLElement('MailGuaranteeReconFreq', String.valueOf(record.Mail_Guarantee_Recon_Freq__c));
                writeXMLElement('MailBrandDiscount', String.valueOf(record.Mail_Brand_Discount__c));
                writeXMLElement('MailGenericFlatDisct', String.valueOf(record.Mail_Generic_Flat_Disct__c));
                writeXMLElement('MailPrefBrandDisct', String.valueOf(record.Mail_Pref_Brand_Disct__c));
                writeXMLElement('MailNonMACGenDisct', String.valueOf(record.Mail_Non_MAC_Gen_Disct__c));
                writeXMLElement('MailNonPrefBrandDisct', String.valueOf(record.Mail_Non_Pref_Brand_Disct__c));
                writeXMLElement('MailGenericDispnseFee', String.valueOf(record.Mail_Generic_Dispnse_Fee__c));
                writeXMLElement('MailBrandDispenseFee', String.valueOf(record.Mail_Brand_Dispense_Fee__c));
                writeXMLElement('MailGenEffRateGuarOne', String.valueOf(record.Mail_Gen_Eff_Rate_Guar_1__c));
                writeXMLElement('MailMACPercent', String.valueOf(record.Mail_MAC_Percent2__c));
                writeXMLElement('MailMACApplies', String.valueOf(record.Mail_MAC_Applies__c));
                writeXMLElement('MailGenDiscGuarOne_MACOnly', String.valueOf(record.Mail_Gen_Disc_Guar1_MAC_Only__c));
                writeXMLElement('MailMACListID', String.valueOf(record.Mail_MAC_List_ID2__c));
                writeXMLElement('MailGenDiscGuarOne_ZBDs', String.valueOf(record.Mail_Gen_Disc_Guar1_ZBDs__c));
                writeXMLElement('MOELApplies', String.valueOf(record.MOEL_Applies__c));
                writeXMLElement('MailGenDiscGuarOne_UAndC', String.valueOf(record.Mail_Gen_Disc_Guar1_UC__c));
                writeXMLElement('MOELID', String.valueOf(record.MOEL_ID__c));
                writeXMLElement('MailGenDiscGuarOne_SSGs', String.valueOf(record.Mail_Gen_Disc_Guar1_SSGs__c));
                writeXMLElement('MailGenDiscGuarOne_BrndMAC', String.valueOf(record.Mail_Gen_Disc_Guar1_Brnd_MAC__c));
                writeXMLElement('MailBrandEffRateGuar', String.valueOf(record.Mail_Brand_Eff_Rate_Guar__c));
                writeXMLElement('MailBrndDiscGuar_ZBDs', String.valueOf(record.Mail_Brnd_Disc_Guar_ZBDs__c));
                writeXMLElement('MailGenEffRateGuarTwo', String.valueOf(record.Mail_Gen_Eff_Rate_Guar_2__c));
                writeXMLElement('MailBrndDiscGuar_UAndC', String.valueOf(record.Mail_Brnd_Disc_Guar_UC__c));
                writeXMLElement('MailGenDiscGuarTwo_MACOnly', String.valueOf(record.Mail_Gen_Disc_Guar2_MAC_Only__c));
                writeXMLElement('MailBrndDiscGuar_SSGs', String.valueOf(record.Mail_Brnd_Disc_Guar_SSGs__c));
                writeXMLElement('MailGenDiscGuarTwo_ZBDs', String.valueOf(record.Mail_Gen_Disc_Guar2_ZBDs__c));
                writeXMLElement('MailBrndDiscGuar_BrndMAC', String.valueOf(record.Mail_Brnd_Disc_Guar_Brnd_MAC__c));
                writeXMLElement('MailGenDiscGuarTwo_UAndC', String.valueOf(record.Mail_Gen_Disc_Guar2_UC__c));
                writeXMLElement('MailGenDiscGuarTwo_SSGs', String.valueOf(record.Mail_Gen_Disc_Guar2_SSGs__c));
                writeXMLElement('MailGenDiscGuarTwo_BrndMAC', String.valueOf(record.Mail_Gen_Disc_Guar2_Brnd_MAC__c));
                writeXMLElement('OtherMailDiscGuarProv', String.valueOf(record.Other_Mail_Disc_Guar_Prov__c));

                w.writeComment('EDS Pricing Section');
                writeXMLElement('RetailEDSNtwk', String.valueOf(record.Retail_EDS_Ntwk_35_DS__c));
                writeXMLElement('RtlEDSAdjudLogic_Client', String.valueOf(record.Rtl_EDS_Adjud_Logic_Client__c));
                writeXMLElement('RtlEDSBrGenAvlApplyMAC', String.valueOf(record.Rtl_EDS_Br_Gen_Avl_Apply_MAC__c));
                writeXMLElement('RtlEDSAdjudLogic_Mbr', String.valueOf(record.Rtl_EDS_Adjud_Logic_Mbr__c));
                writeXMLElement('RetailEDSGuarReconFreq', String.valueOf(record.Retail_EDS_Guar_Recon_Freq__c));
                writeXMLElement('RetailEDSBrandDisct', String.valueOf(record.Retail_EDS_Gen_Flat_Disct__c));
                writeXMLElement('RetailEDSGuarReconMethod', String.valueOf(record.Retail_EDS_Guar_Recon_Method__c));
                writeXMLElement('RetailEDSPrefBrndDisct', String.valueOf(record.Retail_EDS_Pref_Brnd_Disct__c));
                writeXMLElement('RtlEDSNonPrefBrndDisct', String.valueOf(record.Rtl_EDS_Non_Pref_Brnd_Disct__c));
                writeXMLElement('RetailEDSGenFlatDisct', String.valueOf(record.Retail_EDS_Gen_Flat_Disct__c));
                writeXMLElement('RtlEDSBrndDispenseFee', String.valueOf(record.Rtl_EDS_Brnd_Dispense_Fee__c));
                writeXMLElement('RtlEDSNonMACGenDisct', String.valueOf(record.Rtl_EDS_Non_MAC_Gen_Disct__c));
                writeXMLElement('RtlEDSGenDispenseFee', String.valueOf(record.Rtl_EDS_Gen_Dispense_Fee__c));
                writeXMLElement('RetailEDSMACApplies', String.valueOf(record.Retail_EDS_MAC_Applies__c));
                writeXMLElement('RetailEDSMACListID', String.valueOf(record.Retail_EDS_MAC_List_ID__c));
                writeXMLElement('RtlEDSGenEffRteGuarOne', String.valueOf(record.Rtl_EDS_Gen_Eff_Rte_Guar1__c));
                writeXMLElement('RetailEDSMACPercent', String.valueOf(record.Retail_EDS_MAC_Percent__c));
                writeXMLElement('RtlEDSGenDiscGuarOne_MACOnly', String.valueOf(record.Rtl_EDS_GenDiscGuar1_MAC_Only__c));
                writeXMLElement('RtlEDSCustomMACApplies', String.valueOf(record.Rtl_EDS_Custom_MAC_Applies__c));
                writeXMLElement('RtlEDSGenDIscGuarOne_ZBDs', String.valueOf(record.Rtl_EDS_Gen_DIsc_Guar1_ZBDs__c));
                writeXMLElement('RtlEDSGenDiscGuarOne_UAndC', String.valueOf(record.Rtl_EDS_Gen_Disc_Guar1_U_C__c));
                writeXMLElement('RtlEDSBrndEffRateGuar', String.valueOf(record.Rtl_EDS_Brnd_Eff_Rate_Guar__c));
                writeXMLElement('RtlEDSGenDiscGuarOne_SSGs', String.valueOf(record.Rtl_EDS_Gen_Disc_Guar1_SSGs__c));
                writeXMLElement('RtlEDSBrndDiscGuar_ZBDs', String.valueOf(record.Rtl_EDS_Brnd_Disc_Guar_ZBDs__c));
                writeXMLElement('RtlEDSGenDiscGuarOne_BrMAC', String.valueOf(record.Rtl_EDS_GenDiscGuar1_Br_MAC__c));
                writeXMLElement('RtlEDSBrndDiscGuar_UAndC', String.valueOf(record.Rtl_EDS_Brnd_Disc_Guar_U_C__c));
                writeXMLElement('RtlEDSBrndDiscGuar_SSGs', String.valueOf(record.Rtl_EDS_Brnd_Disc_Guar_SSGs__c));
                writeXMLElement('RtlEDSGenEffRateGuarTwo', String.valueOf(record.Rtl_EDS_Gen_Eff_Rate_Guar2__c));
                writeXMLElement('RtlEDSBrndDiscGuar_BrMAC', String.valueOf(record.Rtl_EDS_Brnd_Disc_Guar_Br_MAC__c));
                writeXMLElement('RtlEDSGenDiscGuarTwo_MACOnly', String.valueOf(record.Rtl_EDS_GenDiscGuar2_MAC_Only__c));
                writeXMLElement('RtlEDSGenDiscGuarTwo_ZBDs', String.valueOf(record.Rtl_EDS_Gen_Disc_Guar2_ZBDs__c));
                writeXMLElement('RtlEDSGenDiscGuarTwo_UAndC', String.valueOf(record.Rtl_EDS_Gen_Disc_Guar2_U_C__c));
                writeXMLElement('RtlEDSGenDiscGuarTwo_SSGs', String.valueOf(record.Rtl_EDS_Gen_Disc_Guar2_SSGs__c));
                writeXMLElement('RtlEDSGenDIscGuarTwo_BrndMAC', String.valueOf(record.Rtl_EDS_GenDIscGuar2_Brnd_MAC__c));
                writeXMLElement('OthRtlEDSDiscGuarProv', String.valueOf(record.Oth_Rtl_EDS_Disc_Guar_Prov__c));

                w.writeComment('Specialty Pricing Section');
                writeXMLElement('SpecMailDiscBasisSource', String.valueOf(record.Spec_Mail_Disc_Basis_Source__c));
                writeXMLElement('SpecialtyMailDefaultDisct', String.valueOf(record.Specialty_Mail_Default_Disct__c));
                writeXMLElement('SpecialtyDispensingFee', String.valueOf(record.Specialty_Dispensing_Fee__c));


                w.writeEndElement();
            } */
        }
        /* 
         * Method :- writeXMLElement
         * Description :- This Method write XML Element
         */       
        private void writeXMLElement(String elementName, String elementValue) {
            w.writeStartElement(null, elementName, null);
            if (elementValue != NULL) {
                w.writeCharacters(elementValue);
            } else {
                w.writeCharacters('');
            }
            w.writeEndElement();
        }

    }