/*Purpose: Apex Class for Custom History Tracking for the CRD    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Abhay               1/10/2012      Class to track the custom history tracking for CRD
   1.1 -    Anuj                02/01/2012     new fields added
   1.2 -    Anuj                02/14/2012     new field added(Issue#1451)
   1.3 -    Rishabh             04/06/2012     request 027,028 and 029
   1.4 -    Sourabh             08/21/2012     Request 754
   1.5 -    rakesh              08/19/2012     Request 761
   1.6 -    rahul               08/29/2013     Request 1120,1121,1122
   1.7 -    Joognu Rao          4/28/2014      Implemented Request 4525 
   1.8 -    Richa               07/30/2014     Commented all Hypertension and Hyperlipidemia fields for Req4558
   1.9 -  Abhishek goel         01/28/2015     #5471 Removed field CVS_Caremark_Stellant_ID__c    
   2.0 -    Sushant Sethi       03/23/2015    Request 05521
   3.0      Amit Jain 			07 Oct, 2015   Amit added a variable 'firstRun' to track the execution count of class, this is for ST # 379
======================================================================== */
public class GC_CRDHistoryTrackingEngine{
    String modifiedBy{get;set;}
    public List<CRD_History__c> historyList{get;set;}
    public Map<String,CRD_History__c> historyMap{get;set;}

    public set<id> drugListId = new set<id>();
    public set<id> maxPayId = new set<id>();
    public set<id> gccId = new set<id>();
    public set<id> dgId = new set<id>();
    public set<id> posDLId = new set<id>();
    public Map<id,string> mapIDMaxPay{get;set;}
    public Map<id,string> mapIDDrugList{get;set;}
    public Map<id,string> mapIDGCC{get;set;}
    public Map<id,string> mapDG{get;set;}
    //public Map<id,string> mapPosDL{get;set;} Dead Code Commented by Amit on 11/27/2015 for Code Optimization
    public static boolean firstRun = true;
    /*
     * Constructor of class GC_CRDHistoryTrackingEngine
     */   
    public GC_CRDHistoryTrackingEngine(){
        historyList=new list<CRD_History__c>();
        historyMap = new Map<String,CRD_History__c>();
        mapIDMaxPay=new map<id,string>();
        mapIDDrugList=new map<id,String>();
        mapIDGCC=new map<id,String>();
        mapDG= new map<id,String>();
        //mapPosDL= new map<id,String>();Dead Code Commented by Amit on 11/27/2015 for Code Optimization
    }
    /* 
     * Method :- updateCrdHistory
     * Description :- Returning field history of drugList
     */  
             
    public List<CRD_History__c> updateCrdHistory(map<id,CRD__c>mapOldCrdData,list<CRD__c>lstNewCrdData){
        modifiedby = system.Userinfo.getName();
        //historyList = new List<CRD_History__c>();
        for(CRD__c crd:lstNewCrdData){
            drugListId.add(crd.Kit_Logic_Standard_Drug_List__c);
            drugListId.add(mapOldCrdData.get(crd.Id).Kit_Logic_Standard_Drug_List__c);
            drugListId.add(crd.GPI_System_Drug_List__c);
            drugListId.add(mapOldCrdData.get(crd.Id).GPI_System_Drug_List__c);
            drugListId.add(crd.NDC_System_Drug_List__c);
            drugListId.add(mapOldCrdData.get(crd.Id).NDC_System_Drug_List__c);
            drugListId.add(crd.Chemo_Parity_Drug_List__c);
            drugListId.add(mapOldCrdData.get(crd.Id).Chemo_Parity_Drug_List__c);
            maxPayId.add(crd.Compound_Max_Pay__c);
            maxPayId.add(mapOldCrdData.get(crd.Id).Compound_Max_Pay__c);
            maxPayId.add(crd.Max_Pay__c);
            maxPayId.add(mapOldCrdData.get(crd.Id).Max_Pay__c);
            gccId.add(crd.Generic_Code_Conversion__c);
            gccId.add(mapOldCrdData.get(crd.Id).Generic_Code_Conversion__c);
            if(crd.AHA_Drug_Group__c!= Null){
            	dgid.add(crd.AHA_Drug_Group__c);
            }
            if(mapOldCrdData.get(crd.Id).AHA_Drug_Group__c!= Null){
            	dgid.add(mapOldCrdData.get(crd.Id).AHA_Drug_Group__c);
            }
           // posDLId.add(crd.POS_Dose_Optimization_Drug_List_ID__c);--> commented by nitish dependecy of request no 4870
          //  posDLId.add(mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c); --> commented by nitish dependecy of request no 4870
        }
        /* These 5 queries are Optimized by Amit on 11/27/2015
        list<Drug_List__c> lstDlists=new list<Drug_List__c>([Select Id, Name from Drug_List__c where Id IN: drugListId]);
        for(Drug_List__c  lst:lstDlists){
            mapIDDrugList.put(lst.id,lst.name);
        }
        list<Max_Pay__c> lstMaxpays=new list<Max_Pay__c>([Select Id, Name from Max_Pay__c where Id IN: maxPayId]);
        for(Max_Pay__c  lst:lstMaxpays){
            mapIDMaxPay.put(lst.id,lst.name);
        }
        list<Generic_code_conversion__c> lstgcc=new list<Generic_code_conversion__c>([Select Id, Name from Generic_code_conversion__c where Id IN: gccId]);
        for(Generic_code_conversion__c  lst:lstgcc){
            mapIDGCC.put(lst.id,lst.name);
        }
        list<Drug_Group__c> lstdg=new list<Drug_Group__c>([Select Id, Name from Drug_Group__c where Id IN: DGId]);
        for(Drug_Group__c lst:lstdg){
            mapDG.put(lst.id,lst.name);
        }
        // Dead Code Commented by Amit on 11/27/2015 for Code Optimization
        list<Drug_List__c> lstPosDL=new list<Drug_List__c>([Select Id, Name from Drug_List__c where Id IN: posDLId]);
        for(Drug_List__c lst:lstPosDL){
            mapPosDL.put(lst.id,lst.name);
        }
		*/
		if(drugListId.size() > 0){
	        for(Drug_List__c  lst:[Select Id, Name from Drug_List__c where Id IN: drugListId]){
	            mapIDDrugList.put(lst.id,lst.name);
	        }
		}
        if(maxPayId.size() > 0){
	        for(Max_Pay__c  lst:[Select Id, Name from Max_Pay__c where Id IN: maxPayId]){
	            mapIDMaxPay.put(lst.id,lst.name);
	        }
        }
        if(gccId.size() > 0){
	        for(Generic_code_conversion__c  lst:[Select Id, Name from Generic_code_conversion__c where Id IN: gccId]){
	            mapIDGCC.put(lst.id,lst.name);
	        }
        }
        if(DGId.size() > 0){
	        for(Drug_Group__c lst:[Select Id, Name from Drug_Group__c where Id IN: DGId]){
	            mapDG.put(lst.id,lst.name);
	        }
        }
        //Ends
        for(CRD__c crd:lstNewCrdData){
            if(crd.LastSent__c != Null){
                if(crd.Are_you_creating_a_Package_Plan__c!= mapOldCrdData.get(crd.Id).Are_you_creating_a_Package_Plan__c){historyData(crd.Id,'Are you creating a Package Plan?',string.valueof(mapOldCrdData.get(crd.Id).Are_you_creating_a_Package_Plan__c),string.valueof(crd.Are_you_creating_a_Package_Plan__c)); }
                if(crd.Aetna_RxStep__c!= mapOldCrdData.get(crd.Id).Aetna_RxStep__c){historyData(crd.Id,'Aetna RxStep',string.valueof(mapOldCrdData.get(crd.Id).Aetna_RxStep__c),string.valueof(crd.Aetna_RxStep__c)); }
                if(crd.RxPlan_ID_Status__c!= mapOldCrdData.get(crd.Id).RxPlan_ID_Status__c){historyData(crd.Id,'RxPlan ID Status',string.valueof(mapOldCrdData.get(crd.Id).RxPlan_ID_Status__c),string.valueof(crd.RxPlan_ID_Status__c)); }
                if(crd.RxPlanID__c!= mapOldCrdData.get(crd.Id).RxPlanID__c){historyData(crd.Id,'Rx Plan ID',string.valueof(mapOldCrdData.get(crd.Id).RxPlanID__c),string.valueof(crd.RxPlanID__c)); }
                if(crd.Old_RxPlan_ID__c!= mapOldCrdData.get(crd.Id).Old_RxPlan_ID__c){historyData(crd.Id,'Old Rx Plan ID',string.valueof(mapOldCrdData.get(crd.Id).Old_RxPlan_ID__c),string.valueof(crd.Old_RxPlan_ID__c)); }
                if(crd.BPERxPlan_ID__c!= mapOldCrdData.get(crd.Id).BPERxPlan_ID__c){historyData(crd.Id,'BRERxPlan ID',string.valueof(mapOldCrdData.get(crd.Id).BPERxPlan_ID__c),string.valueof(crd.BPERxPlan_ID__c)); }
                if(crd.Status__c!= mapOldCrdData.get(crd.Id).Status__c){historyData(crd.Id,'Status',string.valueof(mapOldCrdData.get(crd.Id).Status__c),string.valueof(crd.Status__c)); }
                if(crd.Standard_Plan_Selection__c!= mapOldCrdData.get(crd.Id).Standard_Plan_Selection__c){historyData(crd.Id,'Standard Plan Selection',string.valueof(mapOldCrdData.get(crd.Id).Standard_Plan_Selection_Name__c),string.valueof(crd.Standard_Plan_Selection_Name__c)); }
                if(crd.Standard_or_Custom_Plan__c!= mapOldCrdData.get(crd.Id).Standard_or_Custom_Plan__c){historyData(crd.Id,'What are you doing?',string.valueof(mapOldCrdData.get(crd.Id).Standard_or_Custom_Plan__c),string.valueof(crd.Standard_or_Custom_Plan__c)); }
                if(crd.Account_Name__c!= mapOldCrdData.get(crd.Id).Account_Name__c){historyData(crd.Id,'Account',string.valueof(mapOldCrdData.get(crd.Id).Account_Name__c),string.valueof(crd.Account_Name__c)); }
                if(crd.Prescriber_Network__c!= mapOldCrdData.get(crd.Id).Prescriber_Network__c){historyData(crd.Id,'Prescriber Network',string.valueof(mapOldCrdData.get(crd.Id).Prescriber_Network__c),string.valueof(crd.Prescriber_Network__c)); }
                if(crd.Bridge_Supply__c!= mapOldCrdData.get(crd.Id).Bridge_Supply__c){historyData(crd.Id,'Bridge Supply',string.valueof(mapOldCrdData.get(crd.Id).Bridge_Supply__c),string.valueof(crd.Bridge_Supply__c)); }
                if(crd.Plan_Platform__c!= mapOldCrdData.get(crd.Id).Plan_Platform__c){historyData(crd.Id,'What is the Carrier?',string.valueof(mapOldCrdData.get(crd.Id).Plan_Platform__c),string.valueof(crd.Plan_Platform__c)); }
                if(crd.National__c!= mapOldCrdData.get(crd.Id).National__c){historyData(crd.Id,'Segment',string.valueof(mapOldCrdData.get(crd.Id).National__c),string.valueof(crd.National__c)); }
                if(crd.Does_3_Month_Grace_Period_Apply__c!= mapOldCrdData.get(crd.Id).Does_3_Month_Grace_Period_Apply__c){historyData(crd.Id,'Does 3 Month Grace Period Apply',string.valueof(mapOldCrdData.get(crd.Id).Does_3_Month_Grace_Period_Apply__c),string.valueof(crd.Does_3_Month_Grace_Period_Apply__c)); }
                if(crd.Insured_Type__c!= mapOldCrdData.get(crd.Id).Insured_Type__c){historyData(crd.Id,'Funding Type',string.valueof(mapOldCrdData.get(crd.Id).Insured_Type__c),string.valueof(crd.Insured_Type__c)); }
                if(crd.Plan_Type_Retail__c!= mapOldCrdData.get(crd.Id).Plan_Type_Retail__c){historyData(crd.Id,'Plan Type: Retail',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Retail__c),string.valueof(crd.Plan_Type_Retail__c)); }
                if(crd.Contract_State__c!= mapOldCrdData.get(crd.Id).Contract_State__c){historyData(crd.Id,'Contract State',string.valueof(mapOldCrdData.get(crd.Id).Contract_State__c),string.valueof(crd.Contract_State__c)); }
                if(crd.Plan_Type_Mail__c!= mapOldCrdData.get(crd.Id).Plan_Type_Mail__c){historyData(crd.Id,'Plan Type: Mail',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Mail__c),string.valueof(crd.Plan_Type_Mail__c)); }
                if(crd.Plan_Type_Paper__c!= mapOldCrdData.get(crd.Id).Plan_Type_Paper__c){historyData(crd.Id,'Plan Type: Paper',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Paper__c),string.valueof(crd.Plan_Type_Paper__c)); }
                if(crd.Plan_Type_Specialty__c!= mapOldCrdData.get(crd.Id).Plan_Type_Specialty__c){historyData(crd.Id,'Plan Type: Specialty',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Specialty__c),string.valueof(crd.Plan_Type_Specialty__c)); }
                if(crd.High_Value_Client__c!= mapOldCrdData.get(crd.Id).High_Value_Client__c){historyData(crd.Id,'High Value Client',string.valueof(mapOldCrdData.get(crd.Id).High_Value_Client__c),string.valueof(crd.High_Value_Client__c)); }
                if(crd.Include_Kit_Logic__c!= mapOldCrdData.get(crd.Id).Include_Kit_Logic__c){historyData(crd.Id,'Include Kit Logic',string.valueof(mapOldCrdData.get(crd.Id).Include_Kit_Logic__c),string.valueof(crd.Include_Kit_Logic__c)); }
                if(crd.Pre_Implementation_Audit__c!= mapOldCrdData.get(crd.Id).Pre_Implementation_Audit__c){historyData(crd.Id,'Pre-Implementation Audit',string.valueof(mapOldCrdData.get(crd.Id).Pre_Implementation_Audit__c),string.valueof(crd.Pre_Implementation_Audit__c)); }
                if(crd.Vendor_Transition_Files__c!= mapOldCrdData.get(crd.Id).Vendor_Transition_Files__c){historyData(crd.Id,'Vendor Transition Files',string.valueof(mapOldCrdData.get(crd.Id).Vendor_Transition_Files__c),string.valueof(crd.Vendor_Transition_Files__c)); }
                if(crd.Which_system_will_the_plan_be_installed__c!= mapOldCrdData.get(crd.Id).Which_system_will_the_plan_be_installed__c){historyData(crd.Id,'Which medical platform to install plan?',string.valueof(mapOldCrdData.get(crd.Id).Which_system_will_the_plan_be_installed__c),string.valueof(crd.Which_system_will_the_plan_be_installed__c)); }
                if(crd.TP_ID__c!= mapOldCrdData.get(crd.Id).TP_ID__c){historyData(crd.Id,'TPID',string.valueof(mapOldCrdData.get(crd.Id).TP_ID__c),string.valueof(crd.TP_ID__c)); }
                if(crd.Rx_PP_ID__c!= mapOldCrdData.get(crd.Id).Rx_PP_ID__c){historyData(crd.Id,'Owner PPID',string.valueof(mapOldCrdData.get(crd.Id).Rx_PP_ID__c),string.valueof(crd.Rx_PP_ID__c)); }
                if(crd.Custom_Ben_ID__c!= mapOldCrdData.get(crd.Id).Custom_Ben_ID__c){historyData(crd.Id,'Custom Ben ID',string.valueof(mapOldCrdData.get(crd.Id).Custom_Ben_ID__c),string.valueof(crd.Custom_Ben_ID__c)); }
                if(crd.Integrate_with_Medical__c!= mapOldCrdData.get(crd.Id).Integrate_with_Medical__c){historyData(crd.Id,'Is there Medical Integration?',string.valueof(mapOldCrdData.get(crd.Id).Integrate_with_Medical__c),string.valueof(crd.Integrate_with_Medical__c)); }
                if(crd.Waive_Deductible_for_Tier_1_Drugs__c!= mapOldCrdData.get(crd.Id).Waive_Deductible_for_Tier_1_Drugs__c){historyData(crd.Id,'Waive Deductible for Tier 1 Drugs',string.valueof(mapOldCrdData.get(crd.Id).Waive_Deductible_for_Tier_1_Drugs__c),string.valueof(crd.Waive_Deductible_for_Tier_1_Drugs__c)); }
                if(crd.Effective_Start_Date__c!= mapOldCrdData.get(crd.Id).Effective_Start_Date__c){historyData(crd.Id,'Plan Effective Date',string.valueof(mapOldCrdData.get(crd.Id).Effective_Start_Date__c),string.valueof(crd.Effective_Start_Date__c)); }
                if(crd.Plan_Extract_Date__c!= mapOldCrdData.get(crd.Id).Plan_Extract_Date__c){historyData(crd.Id,'Last BPE Update',string.valueof(mapOldCrdData.get(crd.Id).Plan_Extract_Date__c),string.valueof(crd.Plan_Extract_Date__c)); }
                if(crd.Client_Contact_First_Name__c!= mapOldCrdData.get(crd.Id).Client_Contact_First_Name__c){historyData(crd.Id,'Client Contact First Name',string.valueof(mapOldCrdData.get(crd.Id).Client_Contact_First_Name__c),string.valueof(crd.Client_Contact_First_Name__c)); }
                if(crd.Client_Contact_Last_Name__c!= mapOldCrdData.get(crd.Id).Client_Contact_Last_Name__c){historyData(crd.Id,'Client Contact Last Name',string.valueof(mapOldCrdData.get(crd.Id).Client_Contact_Last_Name__c),string.valueof(crd.Client_Contact_Last_Name__c)); }
                if(crd.Client_Contact_Email_Address__c!= mapOldCrdData.get(crd.Id).Client_Contact_Email_Address__c){historyData(crd.Id,'Client  Contact Email Address',string.valueof(mapOldCrdData.get(crd.Id).Client_Contact_Email_Address__c),string.valueof(crd.Client_Contact_Email_Address__c)); }
                if(crd.Client_Contact_Phone__c!= mapOldCrdData.get(crd.Id).Client_Contact_Phone__c){historyData(crd.Id,'Client Contact  Phone Number',string.valueof(mapOldCrdData.get(crd.Id).Client_Contact_Phone__c),string.valueof(crd.Client_Contact_Phone__c)); }
                if(crd.Client_Effective_Date__c!= mapOldCrdData.get(crd.Id).Client_Effective_Date__c){historyData(crd.Id,'Client Effective Date',string.valueof(mapOldCrdData.get(crd.Id).Client_Effective_Date__c),string.valueof(crd.Client_Effective_Date__c)); }
                if(crd.Number_of_Participants__c!= mapOldCrdData.get(crd.Id).Number_of_Participants__c){historyData(crd.Id,'What is the number of members?',string.valueof(mapOldCrdData.get(crd.Id).Number_of_Participants__c),string.valueof(crd.Number_of_Participants__c)); }
                if(crd.Incumbent_PBM__c!= mapOldCrdData.get(crd.Id).Incumbent_PBM__c){historyData(crd.Id,'Incumbent PBM',string.valueof(mapOldCrdData.get(crd.Id).Incumbent_PBM__c),string.valueof(crd.Incumbent_PBM__c)); }
                if(crd.Toll_Free_Number__c!= mapOldCrdData.get(crd.Id).Toll_Free_Number__c){historyData(crd.Id,'Toll Free Number Type',string.valueof(mapOldCrdData.get(crd.Id).Toll_Free_Number__c),string.valueof(crd.Toll_Free_Number__c)); }
                //if(crd.Custom_TFN__c!= mapOldCrdData.get(crd.Id).Custom_TFN__c){historyData(crd.Id,'Custom Toll Free Number',string.valueof(mapOldCrdData.get(crd.Id).Custom_TFN__c),string.valueof(crd.Custom_TFN__c)); }Richa commented for Req - 4887
                //if(crd.Implementations_Date__c!= mapOldCrdData.get(crd.Id).Implementations_Date__c){historyData(crd.Id,'Customer Care Implementations Date',string.valueof(mapOldCrdData.get(crd.Id).Implementations_Date__c),string.valueof(crd.Implementations_Date__c)); }
                //if(crd.Does_plan_have_an_Open_Enrollment_Date__c!= mapOldCrdData.get(crd.Id).Does_plan_have_an_Open_Enrollment_Date__c){historyData(crd.Id,'Does plan have an Open Enrollment Date?',string.valueof(mapOldCrdData.get(crd.Id).Does_plan_have_an_Open_Enrollment_Date__c),string.valueof(crd.Does_plan_have_an_Open_Enrollment_Date__c)); }
                //if(crd.Open_Enrollment_Date__c!= mapOldCrdData.get(crd.Id).Open_Enrollment_Date__c){historyData(crd.Id,'Open Enrollment Date',string.valueof(mapOldCrdData.get(crd.Id).Open_Enrollment_Date__c),string.valueof(crd.Open_Enrollment_Date__c)); }
                //if(crd.IVR_Routing_during_Open_Enrollment__c!= mapOldCrdData.get(crd.Id).IVR_Routing_during_Open_Enrollment__c){historyData(crd.Id,'IVR Routing during Open Enrollment?',string.valueof(mapOldCrdData.get(crd.Id).IVR_Routing_during_Open_Enrollment__c),string.valueof(crd.IVR_Routing_during_Open_Enrollment__c)); }
                //if(crd.Need_Private_Label_Greeting__c!= mapOldCrdData.get(crd.Id).Need_Private_Label_Greeting__c){historyData(crd.Id,'Does this plan need a Private Label Greeting?',string.valueof(mapOldCrdData.get(crd.Id).Need_Private_Label_Greeting__c),string.valueof(crd.Need_Private_Label_Greeting__c)); }
                //if(crd.Sensitive_Client__c!= mapOldCrdData.get(crd.Id).Sensitive_Client__c){historyData(crd.Id,'Sensitive Client',string.valueof(mapOldCrdData.get(crd.Id).Sensitive_Client__c),string.valueof(crd.Sensitive_Client__c)); }
                if(crd.Vacation__c!= mapOldCrdData.get(crd.Id).Vacation__c){historyData(crd.Id,'Vacaction',string.valueof(mapOldCrdData.get(crd.Id).Vacation__c),string.valueof(crd.Vacation__c)); }
                if(crd.Participant_Lost_Stolen_Damaged_Meds__c!= mapOldCrdData.get(crd.Id).Participant_Lost_Stolen_Damaged_Meds__c){historyData(crd.Id,'Participant Lost/Stolen/Damaged Meds',string.valueof(mapOldCrdData.get(crd.Id).Participant_Lost_Stolen_Damaged_Meds__c),string.valueof(crd.Participant_Lost_Stolen_Damaged_Meds__c)); }
                if(crd.Mail_Order_Delay__c!= mapOldCrdData.get(crd.Id).Mail_Order_Delay__c){historyData(crd.Id,'Mail Order Delay',string.valueof(mapOldCrdData.get(crd.Id).Mail_Order_Delay__c),string.valueof(crd.Mail_Order_Delay__c)); }
                if(crd.Maximum_Dollar__c!= mapOldCrdData.get(crd.Id).Maximum_Dollar__c){historyData(crd.Id,'Maximum Dollar',string.valueof(mapOldCrdData.get(crd.Id).Maximum_Dollar__c),string.valueof(crd.Maximum_Dollar__c)); }
                if(crd.Dosage_Increase_Change__c!= mapOldCrdData.get(crd.Id).Dosage_Increase_Change__c){historyData(crd.Id,'Dosage Increase/Change',string.valueof(mapOldCrdData.get(crd.Id).Dosage_Increase_Change__c),string.valueof(crd.Dosage_Increase_Change__c)); }
                if(crd.Multiple_Births__c!= mapOldCrdData.get(crd.Id).Multiple_Births__c){historyData(crd.Id,'Multiple Births',string.valueof(mapOldCrdData.get(crd.Id).Multiple_Births__c),string.valueof(crd.Multiple_Births__c)); }
                if(crd.Retail_refill_for_Manufacture_Back_Order__c!= mapOldCrdData.get(crd.Id).Retail_refill_for_Manufacture_Back_Order__c){historyData(crd.Id,'Retail refill for Manufacture Back Order',string.valueof(mapOldCrdData.get(crd.Id).Retail_refill_for_Manufacture_Back_Order__c),string.valueof(crd.Retail_refill_for_Manufacture_Back_Order__c)); }
                if(crd.Dose_Optimization__c!= mapOldCrdData.get(crd.Id).Dose_Optimization__c){historyData(crd.Id,'Dose Optimization',string.valueof(mapOldCrdData.get(crd.Id).Dose_Optimization__c),string.valueof(crd.Dose_Optimization__c)); }
                if(crd.Duplicate_Therapy__c!= mapOldCrdData.get(crd.Id).Duplicate_Therapy__c){historyData(crd.Id,'Duplicate Therapy',string.valueof(mapOldCrdData.get(crd.Id).Duplicate_Therapy__c),string.valueof(crd.Duplicate_Therapy__c)); }
                if(crd.Incorrect_Days_Supply__c!= mapOldCrdData.get(crd.Id).Incorrect_Days_Supply__c){historyData(crd.Id,'Incorrect Days Supply',string.valueof(mapOldCrdData.get(crd.Id).Incorrect_Days_Supply__c),string.valueof(crd.Incorrect_Days_Supply__c)); }
                if(crd.Annual_Fill_Limit_Allowed_Limit__c!= mapOldCrdData.get(crd.Id).Annual_Fill_Limit_Allowed_Limit__c){historyData(crd.Id,'Annual Fill Limit / Allowed Limit',string.valueof(mapOldCrdData.get(crd.Id).Annual_Fill_Limit_Allowed_Limit__c),string.valueof(crd.Annual_Fill_Limit_Allowed_Limit__c)); }
                if(crd.Nursing_Home__c!= mapOldCrdData.get(crd.Id).Nursing_Home__c){historyData(crd.Id,'Nursing Home',string.valueof(mapOldCrdData.get(crd.Id).Nursing_Home__c),string.valueof(crd.Nursing_Home__c)); }
                if(crd.Specialty_Retail_Lock_Out__c!= mapOldCrdData.get(crd.Id).Specialty_Retail_Lock_Out__c){historyData(crd.Id,'Specialty Retail Lock Out',string.valueof(mapOldCrdData.get(crd.Id).Specialty_Retail_Lock_Out__c),string.valueof(crd.Specialty_Retail_Lock_Out__c)); }
                if(crd.Expatriate_Employees__c!= mapOldCrdData.get(crd.Id).Expatriate_Employees__c){historyData(crd.Id,'Expatriate Employees',string.valueof(mapOldCrdData.get(crd.Id).Expatriate_Employees__c),string.valueof(crd.Expatriate_Employees__c)); }
                if(crd.Participant_Mail_In_Delay__c!= mapOldCrdData.get(crd.Id).Participant_Mail_In_Delay__c){historyData(crd.Id,'Participant Mail In Delay',string.valueof(mapOldCrdData.get(crd.Id).Participant_Mail_In_Delay__c),string.valueof(crd.Participant_Mail_In_Delay__c)); }
                if(crd.Disaster_Emergency__c!= mapOldCrdData.get(crd.Id).Disaster_Emergency__c){historyData(crd.Id,'Disaster Emergency',string.valueof(mapOldCrdData.get(crd.Id).Disaster_Emergency__c),string.valueof(crd.Disaster_Emergency__c)); }
                if(crd.Transition_Plan_1_x_override_30DS__c!= mapOldCrdData.get(crd.Id).Transition_Plan_1_x_override_30DS__c){historyData(crd.Id,'Transition Plan 1 x override 30DS',string.valueof(mapOldCrdData.get(crd.Id).Transition_Plan_1_x_override_30DS__c),string.valueof(crd.Transition_Plan_1_x_override_30DS__c)); }
                if(crd.MDL_or_QVT_Limit_Exceptions__c!= mapOldCrdData.get(crd.Id).MDL_or_QVT_Limit_Exceptions__c){historyData(crd.Id,'MDL or QVT Limit Exceptions',string.valueof(mapOldCrdData.get(crd.Id).MDL_or_QVT_Limit_Exceptions__c),string.valueof(crd.MDL_or_QVT_Limit_Exceptions__c)); }
                if(crd.RDS__c!= mapOldCrdData.get(crd.Id).RDS__c){historyData(crd.Id,'RDS',string.valueof(mapOldCrdData.get(crd.Id).RDS__c),string.valueof(crd.RDS__c)); }
                if(crd.Application_ID__c!= mapOldCrdData.get(crd.Id).Application_ID__c){historyData(crd.Id,'Application ID',string.valueof(mapOldCrdData.get(crd.Id).Application_ID__c),string.valueof(crd.Application_ID__c)); }
                if(crd.UBOI_ID__c!= mapOldCrdData.get(crd.Id).UBOI_ID__c){historyData(crd.Id,'UBOI ID',string.valueof(mapOldCrdData.get(crd.Id).UBOI_ID__c),string.valueof(crd.UBOI_ID__c)); }
                if(crd.Year__c!= mapOldCrdData.get(crd.Id).Year__c){historyData(crd.Id,'Year',string.valueof(mapOldCrdData.get(crd.Id).Year__c),string.valueof(crd.Year__c)); }
                if(crd.RDS_Effective_Date__c!= mapOldCrdData.get(crd.Id).RDS_Effective_Date__c){historyData(crd.Id,'RDS Effective Date',string.valueof(mapOldCrdData.get(crd.Id).RDS_Effective_Date__c),string.valueof(crd.RDS_Effective_Date__c)); }
                if(crd.RDS_Termination_Date__c!= mapOldCrdData.get(crd.Id).RDS_Termination_Date__c){historyData(crd.Id,'RDS Termination Date',string.valueof(mapOldCrdData.get(crd.Id).RDS_Termination_Date__c),string.valueof(crd.RDS_Termination_Date__c)); }
                if(crd.CVS_submits_eligibility_file_to_Aetna__c!= mapOldCrdData.get(crd.Id).CVS_submits_eligibility_file_to_Aetna__c){historyData(crd.Id,'CVS submits eligibility file to Aetna',string.valueof(mapOldCrdData.get(crd.Id).CVS_submits_eligibility_file_to_Aetna__c),string.valueof(crd.CVS_submits_eligibility_file_to_Aetna__c)); }
                if(crd.Group_submits_eligibility_file__c!= mapOldCrdData.get(crd.Id).Group_submits_eligibility_file__c){historyData(crd.Id,'Group submits eligibility file',string.valueof(mapOldCrdData.get(crd.Id).Group_submits_eligibility_file__c),string.valueof(crd.Group_submits_eligibility_file__c)); }
                if(crd.CVS_submits_eligibility_file_to_Aetna__c!= mapOldCrdData.get(crd.Id).CVS_submits_eligibility_file_to_Aetna__c){historyData(crd.Id,'CVS submits cost reporting to Aetna',string.valueof(mapOldCrdData.get(crd.Id).CVS_submits_eligibility_file_to_Aetna__c),string.valueof(crd.CVS_submits_eligibility_file_to_Aetna__c)); }
                if(crd.Group_submits_Cost_Reporting__c!= mapOldCrdData.get(crd.Id).Group_submits_Cost_Reporting__c){historyData(crd.Id,'Group submits Cost Reporting ',string.valueof(mapOldCrdData.get(crd.Id).Group_submits_Cost_Reporting__c),string.valueof(crd.Group_submits_Cost_Reporting__c)); }
                if(crd.Reporting_Frequency__c!= mapOldCrdData.get(crd.Id).Reporting_Frequency__c){historyData(crd.Id,'Reporting Frequency',string.valueof(mapOldCrdData.get(crd.Id).Reporting_Frequency__c),string.valueof(crd.Reporting_Frequency__c)); }
                if(crd.Drug_List_Option__c!= mapOldCrdData.get(crd.Id).Drug_List_Option__c){historyData(crd.Id,'Drug List Option',string.valueof(mapOldCrdData.get(crd.Id).Drug_List_Option__c),string.valueof(crd.Drug_List_Option__c)); }
                if(crd.Carrier_ID__c!= mapOldCrdData.get(crd.Id).Carrier_ID__c){historyData(crd.Id,'Carrier ID',string.valueof(mapOldCrdData.get(crd.Id).Carrier_ID__c),string.valueof(crd.Carrier_ID__c)); }
                if(crd.Account_ID__c!= mapOldCrdData.get(crd.Id).Account_ID__c){historyData(crd.Id,'Account ID',string.valueof(mapOldCrdData.get(crd.Id).Account_ID__c),string.valueof(crd.Account_ID__c)); }
                if(crd.Group_ID__c!= mapOldCrdData.get(crd.Id).Group_ID__c){historyData(crd.Id,'Group ID',string.valueof(mapOldCrdData.get(crd.Id).Group_ID__c),string.valueof(crd.Group_ID__c)); }
                if(crd.Subsegment__c!= mapOldCrdData.get(crd.Id).Subsegment__c){historyData(crd.Id,'Subsegment',string.valueof(mapOldCrdData.get(crd.Id).Subsegment__c),string.valueof(crd.Subsegment__c)); }
                if(crd.Tiering__c!= mapOldCrdData.get(crd.Id).Tiering__c){historyData(crd.Id,'Tiering',string.valueof(mapOldCrdData.get(crd.Id).Tiering__c),string.valueof(crd.Tiering__c)); }
                if(crd.Rating__c!= mapOldCrdData.get(crd.Id).Rating__c){historyData(crd.Id,'Rating',string.valueof(mapOldCrdData.get(crd.Id).Rating__c),string.valueof(crd.Rating__c)); }
                if(crd.Y_Schd__c!= mapOldCrdData.get(crd.Id).Y_Schd__c){historyData(crd.Id,'Retail Y-Schedule',string.valueof(mapOldCrdData.get(crd.Id).Y_Schd__c),string.valueof(crd.Y_Schd__c)); }
                if(crd.Mail_Y_Schedule__c!= mapOldCrdData.get(crd.Id).Mail_Y_Schedule__c){historyData(crd.Id,'Mail Y-Schedule',string.valueof(mapOldCrdData.get(crd.Id).Mail_Y_Schedule__c),string.valueof(crd.Mail_Y_Schedule__c)); }
                if(crd.Who_processes_PA_or_Override__c!= mapOldCrdData.get(crd.Id).Who_processes_PA_or_Override__c){historyData(crd.Id,'Who processes PA or Override?',string.valueof(mapOldCrdData.get(crd.Id).Who_processes_PA_or_Override__c),string.valueof(crd.Who_processes_PA_or_Override__c)); }
                //if(crd.RxPlanData__c!= mapOldCrdData.get(crd.Id).RxPlanData__c){historyData(crd.Id,'RxPlanData',string.valueof(mapOldCrdData.get(crd.Id).RxPlanData__c),string.valueof(crd.RxPlanData__c)); }
                //if(crd.RxPlanDataExp__c!= mapOldCrdData.get(crd.Id).RxPlanDataExp__c){historyData(crd.Id,'RxPlanDataExp',string.valueof(mapOldCrdData.get(crd.Id).RxPlanDataExp__c),string.valueof(crd.RxPlanDataExp__c)); }
                if(crd.Integration_Status__c!= mapOldCrdData.get(crd.Id).Integration_Status__c){historyData(crd.Id,'Integration Status',string.valueof(mapOldCrdData.get(crd.Id).Integration_Status__c),string.valueof(crd.Integration_Status__c)); }
                if(crd.Risk_Indicator__c!= mapOldCrdData.get(crd.Id).Risk_Indicator__c){historyData(crd.Id,'Risk Indicator',string.valueof(mapOldCrdData.get(crd.Id).Risk_Indicator__c),string.valueof(crd.Risk_Indicator__c)); }
                if(crd.Carrier_Number__c!= mapOldCrdData.get(crd.Id).Carrier_Number__c){historyData(crd.Id,'Carrier Number',string.valueof(mapOldCrdData.get(crd.Id).Carrier_Number__c),string.valueof(crd.Carrier_Number__c)); }
                if(crd.Platform_Information__c!= mapOldCrdData.get(crd.Id).Platform_Information__c){historyData(crd.Id,'Platform Information ',string.valueof(mapOldCrdData.get(crd.Id).Platform_Information__c),string.valueof(crd.Platform_Information__c)); }
                if(crd.Pricing_Schedule__c!= mapOldCrdData.get(crd.Id).Pricing_Schedule__c){historyData(crd.Id,'Pricing Schedule',string.valueof(mapOldCrdData.get(crd.Id).Pricing_Schedule__c),string.valueof(crd.Pricing_Schedule__c)); }
                if(crd.G_Control__c!= mapOldCrdData.get(crd.Id).G_Control__c){historyData(crd.Id,'G Control',string.valueof(mapOldCrdData.get(crd.Id).G_Control__c),string.valueof(crd.G_Control__c)); }
                if(crd.G_PlanSummary__c!= mapOldCrdData.get(crd.Id).G_PlanSummary__c){historyData(crd.Id,'G Plan Summary',string.valueof(mapOldCrdData.get(crd.Id).G_PlanSummary__c),string.valueof(crd.G_PlanSummary__c)); }
                if(crd.Integration_1__c!= mapOldCrdData.get(crd.Id).Integration_1__c){historyData(crd.Id,'Integration 1',string.valueof(mapOldCrdData.get(crd.Id).Integration_1__c),string.valueof(crd.Integration_1__c)); }
                if(crd.Integration_2__c!= mapOldCrdData.get(crd.Id).Integration_2__c){historyData(crd.Id,'Integration 2',string.valueof(mapOldCrdData.get(crd.Id).Integration_2__c),string.valueof(crd.Integration_2__c)); }
                //if(crd.Partial_Control_Group__c!= mapOldCrdData.get(crd.Id).Partial_Control_Group__c){historyData(crd.Id,'Partial Control/Group',string.valueof(mapOldCrdData.get(crd.Id).Partial_Control_Group_Name__c),string.valueof(crd.Partial_Control_Group_Name__c)); }
                if(crd.Name_of_Approver_on_SSD__c!= mapOldCrdData.get(crd.Id).Name_of_Approver_on_SSD__c){historyData(crd.Id,'Name of Approver on SSD',string.valueof(mapOldCrdData.get(crd.Id).Name_of_Approver_on_SSD__c),string.valueof(crd.Name_of_Approver_on_SSD__c)); }
                if(crd.Date_of_Approval_on_SSD__c!= mapOldCrdData.get(crd.Id).Date_of_Approval_on_SSD__c){historyData(crd.Id,'Date of Approval on SSD',string.valueof(mapOldCrdData.get(crd.Id).Date_of_Approval_on_SSD__c),string.valueof(crd.Date_of_Approval_on_SSD__c)); }
                if(crd.Customization_Approved__c!= mapOldCrdData.get(crd.Id).Customization_Approved__c){historyData(crd.Id,'Customization Approved',string.valueof(mapOldCrdData.get(crd.Id).Customization_Approved__c),string.valueof(crd.Customization_Approved__c)); }
                if(crd.Mail_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Mail_Number_of_Tiers__c){historyData(crd.Id,'Mail - Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Mail_Number_of_Tiers__c),string.valueof(crd.Mail_Number_of_Tiers__c)); }
                if(crd.Retail_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Retail_Number_of_Tiers__c){historyData(crd.Id,'Retail - Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Retail_Number_of_Tiers__c),string.valueof(crd.Retail_Number_of_Tiers__c)); }
                if(crd.Paper_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Paper_Number_of_Tiers__c){historyData(crd.Id,'Paper - Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Paper_Number_of_Tiers__c),string.valueof(crd.Paper_Number_of_Tiers__c)); }
                if(crd.Specialty_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Specialty_Number_of_Tiers__c){historyData(crd.Id,'Specialty - Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Specialty_Number_of_Tiers__c),string.valueof(crd.Specialty_Number_of_Tiers__c)); }
                if(crd.Any_drug_specific_Retail_copays__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Retail_copays__c){historyData(crd.Id,'Any drug specific Retail copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Retail_copays__c),string.valueof(crd.Any_drug_specific_Retail_copays__c)); }
                if(crd.Any_drug_specific_Mail_copays__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Mail_copays__c){historyData(crd.Id,'Any drug specific Mail copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Mail_copays__c),string.valueof(crd.Any_drug_specific_Mail_copays__c)); }
                if(crd.Any_drug_specific_Paper_copays__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Paper_copays__c){historyData(crd.Id,'Any drug specific Paper copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Paper_copays__c),string.valueof(crd.Any_drug_specific_Paper_copays__c)); }
                if(crd.Any_drug_specific_Specialty_copays__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Specialty_copays__c){historyData(crd.Id,'Any drug specific Specialty copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Specialty_copays__c),string.valueof(crd.Any_drug_specific_Specialty_copays__c)); }
                if(crd.Does_the_client_want_to_do_COB__c!= mapOldCrdData.get(crd.Id).Does_the_client_want_to_do_COB__c){historyData(crd.Id,'Does client want to coordinate benefits?',string.valueof(mapOldCrdData.get(crd.Id).Does_the_client_want_to_do_COB__c),string.valueof(crd.Does_the_client_want_to_do_COB__c)); }
                if(crd.COB_or_MOB__c!= mapOldCrdData.get(crd.Id).COB_or_MOB__c){historyData(crd.Id,'COB or MOB?',string.valueof(mapOldCrdData.get(crd.Id).COB_or_MOB__c),string.valueof(crd.COB_or_MOB__c)); }
                if(crd.Process_Point_of_Sales_COB__c!= mapOldCrdData.get(crd.Id).Process_Point_of_Sales_COB__c){historyData(crd.Id,'Process Point of Sales COB?',string.valueof(mapOldCrdData.get(crd.Id).Process_Point_of_Sales_COB__c),string.valueof(crd.Process_Point_of_Sales_COB__c)); }
                if(crd.Reimbursement_Levels__c!= mapOldCrdData.get(crd.Id).Reimbursement_Levels__c){historyData(crd.Id,'Reimbursement Levels',string.valueof(mapOldCrdData.get(crd.Id).Reimbursement_Levels__c),string.valueof(crd.Reimbursement_Levels__c)); }
                if(crd.In_Network__c!= mapOldCrdData.get(crd.Id).In_Network__c){historyData(crd.Id,'In-Network',string.valueof(mapOldCrdData.get(crd.Id).In_Network__c),string.valueof(crd.In_Network__c)); }
                if(crd.In_Network_Reimbursement_Level__c!= mapOldCrdData.get(crd.Id).In_Network_Reimbursement_Level__c){historyData(crd.Id,'In-Network Reimbursement Level',string.valueof(mapOldCrdData.get(crd.Id).In_Network_Reimbursement_Level__c),string.valueof(crd.In_Network_Reimbursement_Level__c)); }
            //Added by JR to implement request no 4525
                if(crd.Mac_at_Mail_Applies__c!= mapOldCrdData.get(crd.Id).Mac_at_Mail_Applies__c){historyData(crd.Id,'Mac at Mail Applies',string.valueof(mapOldCrdData.get(crd.Id).Mac_at_Mail_Applies__c),string.valueof(crd.Mac_at_Mail_Applies__c)); }
          
            }
        }
       	return historyList;
    }
    /* 
     * Method :- updateCrdHistory2
     * Description :- Returning Crd fields History
     */  
    public List<CRD_History__c> updateCrdHistory2(map<id,CRD__c>mapOldCrdData,list<CRD__c>lstNewCrdData){
        for(CRD__c crd:lstNewCrdData){
            if(crd.LastSent__c != Null){
                if(crd.Out_of_Network__c!= mapOldCrdData.get(crd.Id).Out_of_Network__c){historyData(crd.Id,'Out of Network',string.valueof(mapOldCrdData.get(crd.Id).Out_of_Network__c),string.valueof(crd.Out_of_Network__c)); }
                if(crd.Medical_Injectible_Claim_Denial_Process__c!= mapOldCrdData.get(crd.Id).Medical_Injectible_Claim_Denial_Process__c){historyData(crd.Id,'Medical Injectible Claim Denial Process',string.valueof(mapOldCrdData.get(crd.Id).Medical_Injectible_Claim_Denial_Process__c),string.valueof(crd.Medical_Injectible_Claim_Denial_Process__c)); }
                //if(crd.CRD_Pricing_Name__c!= mapOldCrdData.get(crd.Id).CRD_Pricing_Name__c){historyData(crd.Id,'CRD Pricing',string.valueof(mapOldCrdData.get(crd.Id).CRD_Pricing_Name__c),string.valueof(crd.CRD_Pricing_Name__c)); }Richa commented for 4882
                //if(crd.CRD_Pricing__r.Standard_or_Custom_Pricing__c!= mapOldCrdData.get(crd.Id).CRD_Pricing__r.Standard_or_Custom_Pricing__c){historyData(crd.Id,'Standard or Custom Pricing',string.valueof(mapOldCrdData.get(crd.Id).CRD_Pricing__r.Standard_or_Custom_Pricing__c),string.valueof(crd.CRD_Pricing__r.Standard_or_Custom_Pricing__c)); }Richa commented for 4882
                if(crd.Out_of_Network_Reimbursement_Level__c!= mapOldCrdData.get(crd.Id).Out_of_Network_Reimbursement_Level__c){historyData(crd.Id,'Out of Network Reimbursement Level',string.valueof(mapOldCrdData.get(crd.Id).Out_of_Network_Reimbursement_Level__c),string.valueof(crd.Out_of_Network_Reimbursement_Level__c)); }
                if(crd.In_Network_claims_are_reimbursed__c!= mapOldCrdData.get(crd.Id).In_Network_claims_are_reimbursed__c){historyData(crd.Id,'In-Network claims are reimbursed',string.valueof(mapOldCrdData.get(crd.Id).In_Network_claims_are_reimbursed__c),string.valueof(crd.In_Network_claims_are_reimbursed__c)); }
                if(crd.Out_of_Network_claims_are_reimbused__c!= mapOldCrdData.get(crd.Id).Out_of_Network_claims_are_reimbused__c){historyData(crd.Id,'Out-of-Network claims are reimbused',string.valueof(mapOldCrdData.get(crd.Id).Out_of_Network_claims_are_reimbused__c),string.valueof(crd.Out_of_Network_claims_are_reimbused__c)); }
                if(crd.No_of_Days_to_file_a_claim__c!= mapOldCrdData.get(crd.Id).No_of_Days_to_file_a_claim__c){historyData(crd.Id,'# of Days to file a claim',string.valueof(mapOldCrdData.get(crd.Id).No_of_Days_to_file_a_claim__c),string.valueof(crd.No_of_Days_to_file_a_claim__c)); }
                if(crd.Retail_Source_AWP__c!= mapOldCrdData.get(crd.Id).Retail_Source_AWP__c){historyData(crd.Id,'Retail Source: AWP',string.valueof(mapOldCrdData.get(crd.Id).Retail_Source_AWP__c),string.valueof(crd.Retail_Source_AWP__c)); }
                if(crd.Discount_Rate__c!= mapOldCrdData.get(crd.Id).Discount_Rate__c){historyData(crd.Id,'Discount Rate',string.valueof(mapOldCrdData.get(crd.Id).Discount_Rate__c),string.valueof(crd.Discount_Rate__c)); }
                if(crd.Out_of_Network_Cost_Sharing__c!= mapOldCrdData.get(crd.Id).Out_of_Network_Cost_Sharing__c){historyData(crd.Id,'Is there Out of Network Cost Sharing?',string.valueof(mapOldCrdData.get(crd.Id).Out_of_Network_Cost_Sharing__c),string.valueof(crd.Out_of_Network_Cost_Sharing__c)); }
                if(crd.Apply_Retail_Copay__c!= mapOldCrdData.get(crd.Id).Apply_Retail_Copay__c){historyData(crd.Id,'Apply Retail Copay',string.valueof(mapOldCrdData.get(crd.Id).Apply_Retail_Copay__c),string.valueof(crd.Apply_Retail_Copay__c)); }
                if(crd.Type_of_Cost_Sharing__c!= mapOldCrdData.get(crd.Id).Type_of_Cost_Sharing__c){historyData(crd.Id,'Type of Cost Sharing',string.valueof(mapOldCrdData.get(crd.Id).Type_of_Cost_Sharing__c),string.valueof(crd.Type_of_Cost_Sharing__c)); }
                if(crd.Cost_Sharing_Amount__c!= mapOldCrdData.get(crd.Id).Cost_Sharing_Amount__c){historyData(crd.Id,'Cost Sharing Amount',string.valueof(mapOldCrdData.get(crd.Id).Cost_Sharing_Amount__c),string.valueof(crd.Cost_Sharing_Amount__c)); }
                if(crd.Offshore__c!= mapOldCrdData.get(crd.Id).Offshore__c){historyData(crd.Id,'Allow Offshore Processing',string.valueof(mapOldCrdData.get(crd.Id).Offshore__c),string.valueof(crd.Offshore__c)); }
                if(crd.Prorate__c!= mapOldCrdData.get(crd.Id).Prorate__c){historyData(crd.Id,'Prorate',string.valueof(mapOldCrdData.get(crd.Id).Prorate__c),string.valueof(crd.Prorate__c)); }
                if(crd.Plan_Coordinate_Benefits__c!= mapOldCrdData.get(crd.Id).Plan_Coordinate_Benefits__c){historyData(crd.Id,'Plan Coordinate Benefits',string.valueof(mapOldCrdData.get(crd.Id).Plan_Coordinate_Benefits__c),string.valueof(crd.Plan_Coordinate_Benefits__c)); }
                if(crd.Nursing_Home_Claims__c!= mapOldCrdData.get(crd.Id).Nursing_Home_Claims__c){historyData(crd.Id,'Nursing Home Claims',string.valueof(mapOldCrdData.get(crd.Id).Nursing_Home_Claims__c),string.valueof(crd.Nursing_Home_Claims__c)); }
                if(crd.Foreign_Claims__c!= mapOldCrdData.get(crd.Id).Foreign_Claims__c){historyData(crd.Id,'Foreign Claims',string.valueof(mapOldCrdData.get(crd.Id).Foreign_Claims__c),string.valueof(crd.Foreign_Claims__c)); }
                if(crd.Medicaid__c!= mapOldCrdData.get(crd.Id).Medicaid__c){historyData(crd.Id,'Medicaid',string.valueof(mapOldCrdData.get(crd.Id).Medicaid__c),string.valueof(crd.Medicaid__c)); }
                if(crd.Claims_Acceptable_w_o_receipts__c!= mapOldCrdData.get(crd.Id).Claims_Acceptable_w_o_receipts__c){historyData(crd.Id,'Claims Acceptable w/o receipts',string.valueof(mapOldCrdData.get(crd.Id).Claims_Acceptable_w_o_receipts__c),string.valueof(crd.Claims_Acceptable_w_o_receipts__c)); }
                if(crd.Compound_Code_2__c!= mapOldCrdData.get(crd.Id).Compound_Code_2__c){historyData(crd.Id,'Compound Code 2',string.valueof(mapOldCrdData.get(crd.Id).Compound_Code_2__c),string.valueof(crd.Compound_Code_2__c)); }
                if(crd.Claims_payable_with_Pharm_Signature__c!= mapOldCrdData.get(crd.Id).Claims_payable_with_Pharm_Signature__c){historyData(crd.Id,'Claims payable with Pharm Signature',string.valueof(mapOldCrdData.get(crd.Id).Claims_payable_with_Pharm_Signature__c),string.valueof(crd.Claims_payable_with_Pharm_Signature__c)); }
                if(crd.Indian_Facilities__c!= mapOldCrdData.get(crd.Id).Indian_Facilities__c){historyData(crd.Id,'Indian Facilities',string.valueof(mapOldCrdData.get(crd.Id).Indian_Facilities__c),string.valueof(crd.Indian_Facilities__c)); }
                if(crd.Default_NABP__c!= mapOldCrdData.get(crd.Id).Default_NABP__c){historyData(crd.Id,'Default NABP#',string.valueof(mapOldCrdData.get(crd.Id).Default_NABP__c),string.valueof(crd.Default_NABP__c)); }
                if(crd.Administration_of_External_COB__c!= mapOldCrdData.get(crd.Id).Administration_of_External_COB__c){historyData(crd.Id,'Administration of External COB',string.valueof(mapOldCrdData.get(crd.Id).Administration_of_External_COB__c),string.valueof(crd.Administration_of_External_COB__c)); }
                if(crd.Veterans_Admin__c!= mapOldCrdData.get(crd.Id).Veterans_Admin__c){historyData(crd.Id,'Veterans Admin',string.valueof(mapOldCrdData.get(crd.Id).Veterans_Admin__c),string.valueof(crd.Veterans_Admin__c)); }
                if(crd.Allergy_Serums__c!= mapOldCrdData.get(crd.Id).Allergy_Serums__c){historyData(crd.Id,'Allergy Serums',string.valueof(mapOldCrdData.get(crd.Id).Allergy_Serums__c),string.valueof(crd.Allergy_Serums__c)); }
                if(crd.Clinic_Physician_Reimbursement__c!= mapOldCrdData.get(crd.Id).Clinic_Physician_Reimbursement__c){historyData(crd.Id,'Clinic/Physician Reimbursement',string.valueof(mapOldCrdData.get(crd.Id).Clinic_Physician_Reimbursement__c),string.valueof(crd.Clinic_Physician_Reimbursement__c)); }
                if(crd.Erisa_Client__c!= mapOldCrdData.get(crd.Id).Erisa_Client__c){historyData(crd.Id,'Erisa Client',string.valueof(mapOldCrdData.get(crd.Id).Erisa_Client__c),string.valueof(crd.Erisa_Client__c)); }
                if(crd.Ostomy_Supplies__c!= mapOldCrdData.get(crd.Id).Ostomy_Supplies__c){historyData(crd.Id,'Ostomy Supplies',string.valueof(mapOldCrdData.get(crd.Id).Ostomy_Supplies__c),string.valueof(crd.Ostomy_Supplies__c)); }
                if(crd.Other_Insurance_Paid_in_Error__c!= mapOldCrdData.get(crd.Id).Other_Insurance_Paid_in_Error__c){historyData(crd.Id,'Other Insurance Paid in Error',string.valueof(mapOldCrdData.get(crd.Id).Other_Insurance_Paid_in_Error__c),string.valueof(crd.Other_Insurance_Paid_in_Error__c)); }
                if(crd.Manual_Pharmacy_Payments__c!= mapOldCrdData.get(crd.Id).Manual_Pharmacy_Payments__c){historyData(crd.Id,'Manual Pharmacy Payments',string.valueof(mapOldCrdData.get(crd.Id).Manual_Pharmacy_Payments__c),string.valueof(crd.Manual_Pharmacy_Payments__c)); }
                if(crd.Concurrent_DUR_Name__c!= mapOldCrdData.get(crd.Id).Concurrent_DUR_Name__c){historyData(crd.Id,'Concurrent DUR ID',string.valueof(mapOldCrdData.get(crd.Id).Concurrent_DUR_Name__c),string.valueof(crd.Concurrent_DUR_Name__c)); }
               // if(crd.POS_Dose_Optimization_Name__c!= mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Name__c){historyData(crd.Id,'POS Dose Optimization ID',string.valueof(mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Name__c),string.valueof(crd.POS_Dose_Optimization_Name__c)); } --> commented by nitish dependecy of request no 4870
                if(crd.Retail_to_Mail__c!= mapOldCrdData.get(crd.Id).Retail_to_Mail__c){historyData(crd.Id,'Retail to Mail',string.valueof(mapOldCrdData.get(crd.Id).Retail_to_Mail__c),string.valueof(crd.Retail_to_Mail__c)); }
                if(crd.Generic_Launch__c!= mapOldCrdData.get(crd.Id).Generic_Launch__c){historyData(crd.Id,'Generic Launch',string.valueof(mapOldCrdData.get(crd.Id).Generic_Launch__c),string.valueof(crd.Generic_Launch__c)); }
                if(crd.Generic_Uptake__c!= mapOldCrdData.get(crd.Id).Generic_Uptake__c){historyData(crd.Id,'Generic Uptake',string.valueof(mapOldCrdData.get(crd.Id).Generic_Uptake__c),string.valueof(crd.Generic_Uptake__c)); }
                if(crd.Gaps_in_Care__c!= mapOldCrdData.get(crd.Id).Gaps_in_Care__c){historyData(crd.Id,'Gaps in Care',string.valueof(mapOldCrdData.get(crd.Id).Gaps_in_Care__c),string.valueof(crd.Gaps_in_Care__c)); }
                if(crd.Do_you_want_to_do_Step_Therapy__c!= mapOldCrdData.get(crd.Id).Do_you_want_to_do_Step_Therapy__c){historyData(crd.Id,'Is there Step Therapy?',string.valueof(mapOldCrdData.get(crd.Id).Do_you_want_to_do_Step_Therapy__c),string.valueof(crd.Do_you_want_to_do_Step_Therapy__c)); }
                if(crd.Standard_Program_or_Select_Classes__c!= mapOldCrdData.get(crd.Id).Standard_Program_or_Select_Classes__c){historyData(crd.Id,'Choose ST Drug Group or ST Drug List(s)',string.valueof(mapOldCrdData.get(crd.Id).Standard_Program_or_Select_Classes__c),string.valueof(crd.Standard_Program_or_Select_Classes__c)); }
                if(crd.Step_Therapy_TOC_days__c!= mapOldCrdData.get(crd.Id).Step_Therapy_TOC_days__c){historyData(crd.Id,'Step Therapy TOC # days',string.valueof(mapOldCrdData.get(crd.Id).Step_Therapy_TOC_days__c),string.valueof(crd.Step_Therapy_TOC_days__c)); }
                if(crd.Standard_Step_Therapy_Program_Name__c!= mapOldCrdData.get(crd.Id).Standard_Step_Therapy_Program_Name__c){historyData(crd.Id,'Step Therapy Drug Group',  string.valueof(mapOldCrdData.get(crd.Id).Standard_Step_Therapy_Program_Name__c),string.valueof(crd.Standard_Step_Therapy_Program_Name__c)); }
                if(crd.Custom_NPL__c!= mapOldCrdData.get(crd.Id).Custom_NPL__c){historyData(crd.Id,'Custom NPL',string.valueof(mapOldCrdData.get(crd.Id).Custom_NPL__c),string.valueof(crd.Custom_NPL__c)); }
                if(crd.Do_you_want_to_do_Precert__c!= mapOldCrdData.get(crd.Id).Do_you_want_to_do_Precert__c){historyData(crd.Id,'Is there Precert?',string.valueof(mapOldCrdData.get(crd.Id).Do_you_want_to_do_Precert__c),string.valueof(crd.Do_you_want_to_do_Precert__c)); }
                if(crd.Standard_Precert_List_or_Select_Classes__c!= mapOldCrdData.get(crd.Id).Standard_Precert_List_or_Select_Classes__c){historyData(crd.Id,'Choose PA Drug Group or PA Drug List(s)',string.valueof(mapOldCrdData.get(crd.Id).Standard_Precert_List_or_Select_Classes__c),string.valueof(crd.Standard_Precert_List_or_Select_Classes__c)); }
                if(crd.Precert_TOC_days__c!= mapOldCrdData.get(crd.Id).Precert_TOC_days__c){historyData(crd.Id,'Precert TOC # days',string.valueof(mapOldCrdData.get(crd.Id).Precert_TOC_days__c),string.valueof(crd.Precert_TOC_days__c)); }
                if(crd.Standard_Precert_Program_Name__c!= mapOldCrdData.get(crd.Id).Standard_Precert_Program_Name__c){historyData(crd.Id,'Precert Drug Group', string.valueof(mapOldCrdData.get(crd.Id).Standard_Precert_Program_Name__c),string.valueof(crd.Standard_Precert_Program_Name__c)); }
                
                if(crd.Opt_out_of_Safety_Edits__c!= mapOldCrdData.get(crd.Id).Opt_out_of_Safety_Edits__c){historyData(crd.Id,'Opt out of Safety Edits',string.valueof(mapOldCrdData.get(crd.Id).Opt_out_of_Safety_Edits__c),string.valueof(crd.Opt_out_of_Safety_Edits__c)); }
                if(crd.Opt_out_of_Rx_OTC_Edit__c!= mapOldCrdData.get(crd.Id).Opt_out_of_Rx_OTC_Edit__c){historyData(crd.Id,'Opt out of NPL',string.valueof(mapOldCrdData.get(crd.Id).Opt_out_of_Rx_OTC_Edit__c),string.valueof(crd.Opt_out_of_Rx_OTC_Edit__c)); }
                if(crd.NPL_Applies__c!= mapOldCrdData.get(crd.Id).NPL_Applies__c){historyData(crd.Id,'NPL Applies',string.valueof(mapOldCrdData.get(crd.Id).NPL_Applies__c),string.valueof(crd.NPL_Applies__c)); }
                if(crd.NPL_Drug_List__c!= mapOldCrdData.get(crd.Id).NPL_Drug_List__c){historyData(crd.Id,'NPL Drug List',string.valueof(mapOldCrdData.get(crd.Id).NPL_Drug_List__c),string.valueof(crd.NPL_Drug_List__c)); }

                if(crd.Are_there_Quantity_Limits__c!= mapOldCrdData.get(crd.Id).Are_there_Quantity_Limits__c){historyData(crd.Id,'Are there Quantity Limits?',string.valueof(mapOldCrdData.get(crd.Id).Are_there_Quantity_Limits__c),string.valueof(crd.Are_there_Quantity_Limits__c)); }
                if(crd.Standard_QL_List_or_Select_Classes__c!= mapOldCrdData.get(crd.Id).Standard_QL_List_or_Select_Classes__c){historyData(crd.Id,'Choose QL Drug Group or QL Drug List(s)',string.valueof(mapOldCrdData.get(crd.Id).Standard_QL_List_or_Select_Classes__c),string.valueof(crd.Standard_QL_List_or_Select_Classes__c)); }
                if(crd.Standard_QL_Program_Name__c!= mapOldCrdData.get(crd.Id).Standard_QL_Program_Name__c){historyData(crd.Id,'Quantity Limit Drug Group',   string.valueof(mapOldCrdData.get(crd.Id).Standard_QL_Program_Name__c),string.valueof(crd.Standard_QL_Program_Name__c)); }
                
                if(crd.Aetna_Autofill__c!= mapOldCrdData.get(crd.Id).Aetna_Autofill__c){historyData(crd.Id,'Aetna Rx Autofill',string.valueof(mapOldCrdData.get(crd.Id).Aetna_Autofill__c),string.valueof(crd.Aetna_Autofill__c)); }
                //if(crd.Blood_Glucose_Monitoring__c!= mapOldCrdData.get(crd.Id).Blood_Glucose_Monitoring__c){historyData(crd.Id,'Blood Glucose Monitoring',string.valueof(mapOldCrdData.get(crd.Id).Blood_Glucose_Monitoring__c),string.valueof(crd.Blood_Glucose_Monitoring__c)); } --> Commented By Nitish Request No- 04869
                //if(crd.Migrane_Management__c!= mapOldCrdData.get(crd.Id).Migrane_Management__c){historyData(crd.Id,'Migrane Management',string.valueof(mapOldCrdData.get(crd.Id).Migrane_Management__c),string.valueof(crd.Migrane_Management__c)); }  --> Commented By Nitish Request No- 04869
               // if(crd.Health_Care_for_Life__c!= mapOldCrdData.get(crd.Id).Health_Care_for_Life__c){historyData(crd.Id,'Health Care for Life',string.valueof(mapOldCrdData.get(crd.Id).Health_Care_for_Life__c),string.valueof(crd.Health_Care_for_Life__c)); }  --> Commented By Nitish Request No- 04869
                if(crd.Specialty_Therapy_Management__c!= mapOldCrdData.get(crd.Id).Specialty_Therapy_Management__c){historyData(crd.Id,'Specialty Therapy Management',string.valueof(mapOldCrdData.get(crd.Id).Specialty_Therapy_Management__c),string.valueof(crd.Specialty_Therapy_Management__c)); }
                if(crd.Pharmacy_Advisor__c!= mapOldCrdData.get(crd.Id).Pharmacy_Advisor__c){historyData(crd.Id,'Pharmacy Advisor',string.valueof(mapOldCrdData.get(crd.Id).Pharmacy_Advisor__c),string.valueof(crd.Pharmacy_Advisor__c)); }
                if(crd.Enrolled_in_PA_for_other_condition__c!= mapOldCrdData.get(crd.Id).Enrolled_in_PA_for_other_condition__c){historyData(crd.Id,'Enrolled in PA for other condition?',string.valueof(mapOldCrdData.get(crd.Id).Enrolled_in_PA_for_other_condition__c),string.valueof(crd.Enrolled_in_PA_for_other_condition__c)); }
                if(crd.Implementation_Type__c!= mapOldCrdData.get(crd.Id).Implementation_Type__c){historyData(crd.Id,'Implementation Type',string.valueof(mapOldCrdData.get(crd.Id).Implementation_Type__c),string.valueof(crd.Implementation_Type__c)); }
                //if(crd.Implementing_for__c!= mapOldCrdData.get(crd.Id).Implementing_for__c){historyData(crd.Id,'Implementing for:',string.valueof(mapOldCrdData.get(crd.Id).Implementing_for__c),string.valueof(crd.Implementing_for__c)); }
                if(crd.Participate_in_CVS_mail_pharmacy_service__c!= mapOldCrdData.get(crd.Id).Participate_in_CVS_mail_pharmacy_service__c){historyData(crd.Id,'Participate in CVS mail pharmacy services',string.valueof(mapOldCrdData.get(crd.Id).Participate_in_CVS_mail_pharmacy_service__c),string.valueof(crd.Participate_in_CVS_mail_pharmacy_service__c)); }
                if(crd.Disease_Management_Referral_Messaging__c!= mapOldCrdData.get(crd.Id).Disease_Management_Referral_Messaging__c){historyData(crd.Id,'Disease Management Referral Messaging',string.valueof(mapOldCrdData.get(crd.Id).Disease_Management_Referral_Messaging__c),string.valueof(crd.Disease_Management_Referral_Messaging__c)); }
                if(crd.Disease_Management_Messaging_for__c!= mapOldCrdData.get(crd.Id).Disease_Management_Messaging_for__c){historyData(crd.Id,'Disease Management Messaging for',string.valueof(mapOldCrdData.get(crd.Id).Disease_Management_Messaging_for__c),string.valueof(crd.Disease_Management_Messaging_for__c)); }
                if(crd.Is_DM_vendor_the_same_for_each_condition__c!= mapOldCrdData.get(crd.Id).Is_DM_vendor_the_same_for_each_condition__c){historyData(crd.Id,'Is DM vendor the same for each condition',string.valueof(mapOldCrdData.get(crd.Id).Is_DM_vendor_the_same_for_each_condition__c),string.valueof(crd.Is_DM_vendor_the_same_for_each_condition__c)); }
                if(crd.Disease_Vendor__c!= mapOldCrdData.get(crd.Id).Disease_Vendor__c){historyData(crd.Id,'Disease Vendor',string.valueof(mapOldCrdData.get(crd.Id).Disease_Vendor__c),string.valueof(crd.Disease_Vendor__c)); }
                if(crd.Custom_call_center_phone_number__c!= mapOldCrdData.get(crd.Id).Custom_call_center_phone_number__c){historyData(crd.Id,'Custom Disease Vendor phone number',string.valueof(mapOldCrdData.get(crd.Id).Custom_call_center_phone_number__c),string.valueof(crd.Custom_call_center_phone_number__c)); }
                if(crd.End_Date__c!= mapOldCrdData.get(crd.Id).End_Date__c){historyData(crd.Id,'DM Vendor Contract End Date',string.valueof(mapOldCrdData.get(crd.Id).End_Date__c),string.valueof(crd.End_Date__c)); }
                //if(crd.Retail_to_Mail_Messaging__c!= mapOldCrdData.get(crd.Id).Retail_to_Mail_Messaging__c){historyData(crd.Id,'Retail to Mail Messaging',string.valueof(mapOldCrdData.get(crd.Id).Retail_to_Mail_Messaging__c),string.valueof(crd.Retail_to_Mail_Messaging__c)); }
                if(crd.Co_Brand_Initial_Program_Welcome_Mailing__c!= mapOldCrdData.get(crd.Id).Co_Brand_Initial_Program_Welcome_Mailing__c){historyData(crd.Id,'Co-Brand Initial Program Welcome Mailing',string.valueof(mapOldCrdData.get(crd.Id).Co_Brand_Initial_Program_Welcome_Mailing__c),string.valueof(crd.Co_Brand_Initial_Program_Welcome_Mailing__c)); }
                if(crd.Do_Prescription_Savings_Program__c!= mapOldCrdData.get(crd.Id).Do_Prescription_Savings_Program__c){historyData(crd.Id,'Enroll Prescription Savings Program?',string.valueof(mapOldCrdData.get(crd.Id).Do_Prescription_Savings_Program__c),string.valueof(crd.Do_Prescription_Savings_Program__c)); }
                //if(crd.SAC_Letter_Templates__c!= mapOldCrdData.get(crd.Id).SAC_Letter_Templates__c){historyData(crd.Id,'SAC Letter Templates',string.valueof(mapOldCrdData.get(crd.Id).SAC_Letter_Templates__c),string.valueof(crd.SAC_Letter_Templates__c)); }
                if(crd.PSP_Override_Option__c!= mapOldCrdData.get(crd.Id).PSP_Override_Option__c){historyData(crd.Id,'PSP Override Option?',string.valueof(mapOldCrdData.get(crd.Id).PSP_Override_Option__c),string.valueof(crd.PSP_Override_Option__c)); }
                if(crd.Adherence_to_Drug_Therapy__c!= mapOldCrdData.get(crd.Id).Adherence_to_Drug_Therapy__c){historyData(crd.Id,'Adherence to Drug Therapy',string.valueof(mapOldCrdData.get(crd.Id).Adherence_to_Drug_Therapy__c),string.valueof(crd.Adherence_to_Drug_Therapy__c)); }
                if(crd.Value_Generic__c!= mapOldCrdData.get(crd.Id).Value_Generic__c){historyData(crd.Id,'Value Generic',string.valueof(mapOldCrdData.get(crd.Id).Value_Generic__c),string.valueof(crd.Value_Generic__c)); }
                if(crd.Extra_Care_Health_Card__c!= mapOldCrdData.get(crd.Id).Extra_Care_Health_Card__c){historyData(crd.Id,'Extra Care Health Card',string.valueof(mapOldCrdData.get(crd.Id).Extra_Care_Health_Card__c),string.valueof(crd.Extra_Care_Health_Card__c)); }
               // if(crd.FSA_Integration__c!= mapOldCrdData.get(crd.Id).FSA_Integration__c){historyData(crd.Id,'FSA Integration',string.valueof(mapOldCrdData.get(crd.Id).FSA_Integration__c),string.valueof(crd.FSA_Integration__c)); } --> Commented By Nitish Request No- 04874
                if(crd.Enroll_in_RxCheck__c!= mapOldCrdData.get(crd.Id).Enroll_in_RxCheck__c){historyData(crd.Id,'Enroll in RxCheck?',string.valueof(mapOldCrdData.get(crd.Id).Enroll_in_RxCheck__c),string.valueof(crd.Enroll_in_RxCheck__c)); }
                if(crd.Rx_Will_you_be_Picking_Drug_Classes__c!= mapOldCrdData.get(crd.Id).Rx_Will_you_be_Picking_Drug_Classes__c){historyData(crd.Id,'Rx Will you be Picking Drug Classes?',string.valueof(mapOldCrdData.get(crd.Id).Rx_Will_you_be_Picking_Drug_Classes__c),string.valueof(crd.Rx_Will_you_be_Picking_Drug_Classes__c)); }
                if(crd.Rx_Override_Option__c!= mapOldCrdData.get(crd.Id).Rx_Override_Option__c){historyData(crd.Id,'Rx Override Option?',string.valueof(mapOldCrdData.get(crd.Id).Rx_Override_Option__c),string.valueof(crd.Rx_Override_Option__c)); }
                if(crd.Do_you_want_to_do_Save_A_Copay__c!= mapOldCrdData.get(crd.Id).Do_you_want_to_do_Save_A_Copay__c){historyData(crd.Id,'Enroll in Save-A-Copay?',string.valueof(mapOldCrdData.get(crd.Id).Do_you_want_to_do_Save_A_Copay__c),string.valueof(crd.Do_you_want_to_do_Save_A_Copay__c)); }
                //if(crd.of_months_for_Copay_Waiver__c!= mapOldCrdData.get(crd.Id).of_months_for_Copay_Waiver__c){historyData(crd.Id,'# of months for Copay Waiver',string.valueof(mapOldCrdData.get(crd.Id).of_months_for_Copay_Waiver__c),string.valueof(crd.of_months_for_Copay_Waiver__c)); }
                if(crd.PSP_Letter_Templates__c!= mapOldCrdData.get(crd.Id).PSP_Letter_Templates__c){historyData(crd.Id,'PSP Letter Templates',string.valueof(mapOldCrdData.get(crd.Id).PSP_Letter_Templates__c),string.valueof(crd.PSP_Letter_Templates__c)); }
                if(crd.Copay_Dollar_Amount__c!= mapOldCrdData.get(crd.Id).Copay_Dollar_Amount__c){historyData(crd.Id,'Copay Dollar Amount',string.valueof(mapOldCrdData.get(crd.Id).Copay_Dollar_Amount__c),string.valueof(crd.Copay_Dollar_Amount__c)); }
                if(crd.SAC_Override_Option__c!= mapOldCrdData.get(crd.Id).SAC_Override_Option__c){historyData(crd.Id,'SAC Override Option?',string.valueof(mapOldCrdData.get(crd.Id).SAC_Override_Option__c),string.valueof(crd.SAC_Override_Option__c)); }
                if(crd.Aetna_Healthy_Actions__c!= mapOldCrdData.get(crd.Id).Aetna_Healthy_Actions__c){historyData(crd.Id,'Aetna Healthy Actions',string.valueof(mapOldCrdData.get(crd.Id).Aetna_Healthy_Actions__c),string.valueof(crd.Aetna_Healthy_Actions__c)); }
                if(crd.Offering_Type__c!= mapOldCrdData.get(crd.Id).Offering_Type__c){historyData(crd.Id,'AHA Offering Type',string.valueof(mapOldCrdData.get(crd.Id).Offering_Type__c),string.valueof(crd.Offering_Type__c)); }
                if(crd.Asthma_Inhaled_Steroids__c!= mapOldCrdData.get(crd.Id).Asthma_Inhaled_Steroids__c){historyData(crd.Id,'Asthma: Inhaled Steroids',string.valueof(mapOldCrdData.get(crd.Id).Asthma_Inhaled_Steroids__c),string.valueof(crd.Asthma_Inhaled_Steroids__c)); }
                if(crd.Asthma_Anti_Inflammatory_Agents__c!= mapOldCrdData.get(crd.Id).Asthma_Anti_Inflammatory_Agents__c){historyData(crd.Id,'Asthma: Anti-Inflammatory Agents',string.valueof(mapOldCrdData.get(crd.Id).Asthma_Anti_Inflammatory_Agents__c),string.valueof(crd.Asthma_Anti_Inflammatory_Agents__c)); }
                if(crd.Diabetes_Anti_Diabetic_Agents__c!= mapOldCrdData.get(crd.Id).Diabetes_Anti_Diabetic_Agents__c){historyData(crd.Id,'Diabetes: Anti-Diabetic Agents',string.valueof(mapOldCrdData.get(crd.Id).Diabetes_Anti_Diabetic_Agents__c),string.valueof(crd.Diabetes_Anti_Diabetic_Agents__c)); }
                if(crd.Diabetes_Anti_Diabetic_Agent_Supplies__c!= mapOldCrdData.get(crd.Id).Diabetes_Anti_Diabetic_Agent_Supplies__c){historyData(crd.Id,'Diabetes: Anti-Diabetic Agent & Supplies',string.valueof(mapOldCrdData.get(crd.Id).Diabetes_Anti_Diabetic_Agent_Supplies__c),string.valueof(crd.Diabetes_Anti_Diabetic_Agent_Supplies__c)); }
                if(crd.Heart_Failure_Beta_Blockers__c!= mapOldCrdData.get(crd.Id).Heart_Failure_Beta_Blockers__c){historyData(crd.Id,'AHA Heart Failure: Beta Blockers',string.valueof(mapOldCrdData.get(crd.Id).Heart_Failure_Beta_Blockers__c),string.valueof(crd.Heart_Failure_Beta_Blockers__c)); }
                //if(crd.Hyperlipidemia_Statins__c!= mapOldCrdData.get(crd.Id).Hyperlipidemia_Statins__c){historyData(crd.Id,'Hyperlipidemia: Statins',string.valueof(mapOldCrdData.get(crd.Id).Hyperlipidemia_Statins__c),string.valueof(crd.Hyperlipidemia_Statins__c)); }
                //if(crd.Hyperlipidemia_Lipid_Lowering_Agents__c!= mapOldCrdData.get(crd.Id).Hyperlipidemia_Lipid_Lowering_Agents__c){historyData(crd.Id,'AHA Hyperlipidemia: Lipid Lowering Agents',string.valueof(mapOldCrdData.get(crd.Id).Hyperlipidemia_Lipid_Lowering_Agents__c),string.valueof(crd.Hyperlipidemia_Lipid_Lowering_Agents__c)); }
                //if(crd.Hypertension_ACE_Inhibitors_ARBs__c!= mapOldCrdData.get(crd.Id).Hypertension_ACE_Inhibitors_ARBs__c){historyData(crd.Id,'Hypertension: ACE Inhibitors/ARBs',string.valueof(mapOldCrdData.get(crd.Id).Hypertension_ACE_Inhibitors_ARBs__c),string.valueof(crd.Hypertension_ACE_Inhibitors_ARBs__c)); }
                //if(crd.Hypertension_All_Anti_Hypertensives__c!= mapOldCrdData.get(crd.Id).Hypertension_All_Anti_Hypertensives__c){historyData(crd.Id,'AHA Hypertension: All Anti-Hypertensives',string.valueof(mapOldCrdData.get(crd.Id).Hypertension_All_Anti_Hypertensives__c),string.valueof(crd.Hypertension_All_Anti_Hypertensives__c)); }
                if(crd.Tier_1_Copay_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_1_Copay_Reduction__c){historyData(crd.Id,'Tier 1 Copay Reduction %',string.valueof(mapOldCrdData.get(crd.Id).Tier_1_Copay_Reduction__c),string.valueof(crd.Tier_1_Copay_Reduction__c)); }
                if(crd.Tier_2_Copay_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_2_Copay_Reduction__c){historyData(crd.Id,'Tier 2 Copay Reduction %',string.valueof(mapOldCrdData.get(crd.Id).Tier_2_Copay_Reduction__c),string.valueof(crd.Tier_2_Copay_Reduction__c)); }
                if(crd.Tier_3_Copay_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_3_Copay_Reduction__c){historyData(crd.Id,'Tier 3 Copay Reduction %',string.valueof(mapOldCrdData.get(crd.Id).Tier_3_Copay_Reduction__c),string.valueof(crd.Tier_3_Copay_Reduction__c)); }
                if(crd.Tier_4_Copay_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_4_Copay_Reduction__c){historyData(crd.Id,'Tier 4 Copay Reduction %',string.valueof(mapOldCrdData.get(crd.Id).Tier_4_Copay_Reduction__c),string.valueof(crd.Tier_4_Copay_Reduction__c)); }
                if(crd.Tier_5_Copay_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_5_Copay_Reduction__c){historyData(crd.Id,'Tier 5 Copay Reduction %',string.valueof(mapOldCrdData.get(crd.Id).Tier_5_Copay_Reduction__c),string.valueof(crd.Tier_5_Copay_Reduction__c)); }
                if(crd.Aetna_Rx_Healthy_Outcomes__c!= mapOldCrdData.get(crd.Id).Aetna_Rx_Healthy_Outcomes__c){historyData(crd.Id,'Aetna Rx Healthy Outcomes',string.valueof(mapOldCrdData.get(crd.Id).Aetna_Rx_Healthy_Outcomes__c),string.valueof(crd.Aetna_Rx_Healthy_Outcomes__c)); }
                if(crd.Tier_1_Rx_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction__c){historyData(crd.Id,'Tier 1 Rx Reduction % ',string.valueof(mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction__c),string.valueof(crd.Tier_1_Rx_Reduction__c)); }
                if(crd.Tier_2_Rx_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction__c){historyData(crd.Id,'Tier 2 Rx Reduction % ',string.valueof(mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction__c),string.valueof(crd.Tier_2_Rx_Reduction__c)); }
                if(crd.Tier_3_Rx_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction__c){historyData(crd.Id,'Tier 3 Rx Reduction % ',string.valueof(mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction__c),string.valueof(crd.Tier_3_Rx_Reduction__c)); }
                if(crd.Tier_4_Rx_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction__c){historyData(crd.Id,'Tier 4 Rx Reduction % ',string.valueof(mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction__c),string.valueof(crd.Tier_4_Rx_Reduction__c)); }
                if(crd.Tier_5_Rx_Reduction__c!= mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction__c){historyData(crd.Id,'Tier 5 Rx Reduction % ',string.valueof(mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction__c),string.valueof(crd.Tier_5_Rx_Reduction__c)); }
                if(crd.POS_Rebate_for_Plan__c!= mapOldCrdData.get(crd.Id).POS_Rebate_for_Plan__c){historyData(crd.Id,'POS Rebate for Plan?',string.valueof(mapOldCrdData.get(crd.Id).POS_Rebate_for_Plan__c),string.valueof(crd.POS_Rebate_for_Plan__c)); }
                if(crd.RTMD_Effective_Date__c!= mapOldCrdData.get(crd.Id).RTMD_Effective_Date__c){historyData(crd.Id,'POS Rebate Effective Date',string.valueof(mapOldCrdData.get(crd.Id).RTMD_Effective_Date__c),string.valueof(crd.RTMD_Effective_Date__c)); }
                if(crd.RTMD_Client_Share_Percent__c!= mapOldCrdData.get(crd.Id).RTMD_Client_Share_Percent__c){historyData(crd.Id,'POS Rebate Client Share Percent',string.valueof(mapOldCrdData.get(crd.Id).RTMD_Client_Share_Percent__c),string.valueof(crd.RTMD_Client_Share_Percent__c)); }
                if(crd.RTMD_Modulator_Percent__c!= mapOldCrdData.get(crd.Id).RTMD_Modulator_Percent__c){historyData(crd.Id,'POS Rebate Modulator Percent',string.valueof(mapOldCrdData.get(crd.Id).RTMD_Modulator_Percent__c),string.valueof(crd.RTMD_Modulator_Percent__c)); }
                if(crd.Specialty_Exclusion_Flag__c!= mapOldCrdData.get(crd.Id).Specialty_Exclusion_Flag__c){historyData(crd.Id,'Specialty Exclusion Flag',string.valueof(mapOldCrdData.get(crd.Id).Specialty_Exclusion_Flag__c),string.valueof(crd.Specialty_Exclusion_Flag__c)); }
                if(crd.RTMD_Admin_Fee_basis__c!= mapOldCrdData.get(crd.Id).RTMD_Admin_Fee_basis__c){historyData(crd.Id,'POS Rebate Admin Fee basis',string.valueof(mapOldCrdData.get(crd.Id).RTMD_Admin_Fee_basis__c),string.valueof(crd.RTMD_Admin_Fee_basis__c)); }
                if(crd.RTMD_Admin_Fee_rate__c!= mapOldCrdData.get(crd.Id).RTMD_Admin_Fee_rate__c){historyData(crd.Id,'POS Rebate Admin Fee rate',string.valueof(mapOldCrdData.get(crd.Id).RTMD_Admin_Fee_rate__c),string.valueof(crd.RTMD_Admin_Fee_rate__c)); }
                if(crd.Brands_DAW_5_take_a_gen_copay_Mail__c!= mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Mail__c){historyData(crd.Id,'Brands w/ DAW 5 take a generic copay',string.valueof(mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Mail__c),string.valueof(crd.Brands_DAW_5_take_a_gen_copay_Mail__c)); }
                if(crd.Brands_DAW_5_take_a_gen_copay_Speciality__c!= mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Speciality__c){historyData(crd.Id,'Brands w/ DAW 5 take a generic copay',string.valueof(mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Speciality__c),string.valueof(crd.Brands_DAW_5_take_a_gen_copay_Speciality__c)); }
                if(crd.Brands_DAW_5_take_a_gen_copay_Paper__c!= mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Paper__c){historyData(crd.Id,'Brands w/ DAW 5 take a generic copay',string.valueof(mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Paper__c),string.valueof(crd.Brands_DAW_5_take_a_gen_copay_Paper__c)); }
                if(crd.Brands_DAW_5_take_a_gen_copay_Retail__c!= mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Retail__c){historyData(crd.Id,'Brands w/ DAW 5 take a generic copay',string.valueof(mapOldCrdData.get(crd.Id).Brands_DAW_5_take_a_gen_copay_Retail__c),string.valueof(crd.Brands_DAW_5_take_a_gen_copay_Retail__c)); }
                if(crd.Asthma_Preventive__c!= mapOldCrdData.get(crd.Id).Asthma_Preventive__c){historyData(crd.Id,'Asthma: Preventive',string.valueof(mapOldCrdData.get(crd.Id).Asthma_Preventive__c),string.valueof(crd.Asthma_Preventive__c)); }
                if(crd.Diabetes_Preventive__c!= mapOldCrdData.get(crd.Id).Diabetes_Preventive__c){historyData(crd.Id,'Diabetes: Preventive',string.valueof(mapOldCrdData.get(crd.Id).Diabetes_Preventive__c),string.valueof(crd.Diabetes_Preventive__c)); }
                //if(crd.Hypertension_All_Hypertension_Drugs__c!= mapOldCrdData.get(crd.Id).Hypertension_All_Hypertension_Drugs__c){historyData(crd.Id,'Hypertension: All Hypertension Drugs',string.valueof(mapOldCrdData.get(crd.Id).Hypertension_All_Hypertension_Drugs__c),string.valueof(crd.Hypertension_All_Hypertension_Drugs__c)); }
                //if(crd.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c!= mapOldCrdData.get(crd.Id).Hyperlipidemia_Lipid_Lowering_Agents_ARH__c){historyData(crd.Id,'Hyperlipidemia: Lipid Lowering Agents',string.valueof(mapOldCrdData.get(crd.Id).Hyperlipidemia_Lipid_Lowering_Agents_ARH__c),string.valueof(crd.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c)); }
                if(crd.Heart_Failure_Beta_Blockers_ARH__c!= mapOldCrdData.get(crd.Id).Heart_Failure_Beta_Blockers_ARH__c){historyData(crd.Id,'Heart_Failure_Beta_Blockers_ARH__c',string.valueof(mapOldCrdData.get(crd.Id).Heart_Failure_Beta_Blockers_ARH__c),string.valueof(crd.Heart_Failure_Beta_Blockers_ARH__c)); }
                if(crd.ARH_Offering_Type__c!= mapOldCrdData.get(crd.Id).ARH_Offering_Type__c){historyData(crd.Id,'Offering Type',string.valueof(mapOldCrdData.get(crd.Id).ARH_Offering_Type__c),string.valueof(crd.ARH_Offering_Type__c)); }

                // new fields added on 01/02/2012(Anuj)
                if(crd.Plan_Type_Paper_Out_of_Network__c!= mapOldCrdData.get(crd.Id).Plan_Type_Paper_Out_of_Network__c){historyData(crd.Id,'Plan Type: Paper Out of Network',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Paper_Out_of_Network__c),string.valueof(crd.Plan_Type_Paper_Out_of_Network__c)); }
                if(crd.Different_copays_from_Paper_In_Network__c!= mapOldCrdData.get(crd.Id).Different_copays_from_Paper_In_Network__c){historyData(crd.Id,'Different copays from Paper In Network',string.valueof(mapOldCrdData.get(crd.Id).Different_copays_from_Paper_In_Network__c),string.valueof(crd.Different_copays_from_Paper_In_Network__c)); }
                if(crd.Apply_Penalty__c!= mapOldCrdData.get(crd.Id).Apply_Penalty__c){historyData(crd.Id,'Apply Penalty',string.valueof(mapOldCrdData.get(crd.Id).Apply_Penalty__c),string.valueof(crd.Apply_Penalty__c)); }
                if(crd.Penalty_Type__c!= mapOldCrdData.get(crd.Id).Penalty_Type__c){historyData(crd.Id,'Penalty Type',string.valueof(mapOldCrdData.get(crd.Id).Penalty_Type__c),string.valueof(crd.Penalty_Type__c)); }
                if(crd.Penalty_Amount__c!= mapOldCrdData.get(crd.Id).Penalty_Amount__c){historyData(crd.Id,'Penalty Amount',string.valueof(mapOldCrdData.get(crd.Id).Penalty_Amount__c),string.valueof(crd.Penalty_Amount__c)); }
                if(crd.Percentage_Applied__c!= mapOldCrdData.get(crd.Id).Percentage_Applied__c){historyData(crd.Id,'Percentage Applied',string.valueof(mapOldCrdData.get(crd.Id).Percentage_Applied__c),string.valueof(crd.Percentage_Applied__c)); }
                if(crd.Paper_Out_of_Network_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Paper_Out_of_Network_Number_of_Tiers__c){historyData(crd.Id,'Paper Out of Network - Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Paper_Out_of_Network_Number_of_Tiers__c),string.valueof(crd.Paper_Out_of_Network_Number_of_Tiers__c)); }
                if(crd.Any_drug_specific_Paper_Out_of_Network__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Paper_Out_of_Network__c){historyData(crd.Id,'Any drug specific OON  copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Paper_Out_of_Network__c),string.valueof(crd.Any_drug_specific_Paper_Out_of_Network__c)); }
                if(crd.Brands_w_DAW_5_take_a_generic_copay__c!= mapOldCrdData.get(crd.Id).Brands_w_DAW_5_take_a_generic_copay__c){historyData(crd.Id,'Brands w/ DAW 5 take a generic copay',string.valueof(mapOldCrdData.get(crd.Id).Brands_w_DAW_5_take_a_generic_copay__c),string.valueof(crd.Brands_w_DAW_5_take_a_generic_copay__c)); }
                if(crd.Is_there_Paper_Out_of_Network__c!= mapOldCrdData.get(crd.Id).Is_there_Paper_Out_of_Network__c){historyData(crd.Id,'Is there Paper Out of Network?',string.valueof(mapOldCrdData.get(crd.Id).Is_there_Paper_Out_of_Network__c),string.valueof(crd.Is_there_Paper_Out_of_Network__c)); }
                if(crd.Any_DAW_specific_Paper_OON_copays__c!= mapOldCrdData.get(crd.Id).Any_DAW_specific_Paper_OON_copays__c){historyData(crd.Id,'Any DAW specific Paper OON copays?',string.valueof(mapOldCrdData.get(crd.Id).Any_DAW_specific_Paper_OON_copays__c),string.valueof(crd.Any_DAW_specific_Paper_OON_copays__c)); }
                //new field added on 14/02/2012(anuj) RxPPID_NEW__c
                if(crd.Migration_Run_Number__c!= mapOldCrdData.get(crd.Id).Migration_Run_Number__c){historyData(crd.Id,'Migration Run Number',string.valueof(mapOldCrdData.get(crd.Id).Migration_Run_Number__c),string.valueof(crd.Migration_Run_Number__c)); }
                //commented by nitish Request no- 04888
                //if(crd.RxPPID_NEW__c!= mapOldCrdData.get(crd.Id).RxPPID_NEW__c){historyData(crd.Id,'New RxPPID',string.valueof(mapOldCrdData.get(crd.Id).RxPPID_NEW__c),string.valueof(crd.RxPPID_NEW__c)); }
                // New fields added on 22/02/2012(Sourabh)
                if(crd.Clone_TPID__c!= mapOldCrdData.get(crd.Id).Clone_TPID__c){historyData(crd.Id,'Clone TPID',string.valueof(mapOldCrdData.get(crd.Id).Clone_TPID__c),string.valueof(crd.Clone_TPID__c)); }
                if(crd.Clone_Owner_PPID__c!= mapOldCrdData.get(crd.Id).Clone_Owner_PPID__c){historyData(crd.Id,'Clone Owner PPID',string.valueof(mapOldCrdData.get(crd.Id).Clone_Owner_PPID__c),string.valueof(crd.Clone_Owner_PPID__c)); }
                if(crd.Clone_Ben_ID__c!= mapOldCrdData.get(crd.Id).Clone_Ben_ID__c){historyData(crd.Id,'Clone Ben ID',string.valueof(mapOldCrdData.get(crd.Id).Clone_Ben_ID__c),string.valueof(crd.Clone_Ben_ID__c)); }
                if(crd.Clone_Migration_Run_Number__c!= mapOldCrdData.get(crd.Id).Clone_Migration_Run_Number__c){historyData(crd.Id,'Clone Migration Run Number',string.valueof(mapOldCrdData.get(crd.Id).Clone_Migration_Run_Number__c),string.valueof(crd.Clone_Migration_Run_Number__c)); }
                if(crd.Clone_RxPlan_ID__c!= mapOldCrdData.get(crd.Id).Clone_RxPlan_ID__c){historyData(crd.Id,'Clone RxPlan ID',string.valueof(mapOldCrdData.get(crd.Id).Clone_RxPlan_ID__c),string.valueof(crd.Clone_RxPlan_ID__c)); }
                if(crd.Clone_Old_RxPlan_ID__c!= mapOldCrdData.get(crd.Id).Clone_Old_RxPlan_ID__c){historyData(crd.Id,'Clone Old RxPlan ID',string.valueof(mapOldCrdData.get(crd.Id).Clone_Old_RxPlan_ID__c),string.valueof(crd.Clone_Old_RxPlan_ID__c)); }
                if(crd.Clone_BPERxPlan_ID__c!= mapOldCrdData.get(crd.Id).Clone_BPERxPlan_ID__c){historyData(crd.Id,'Clone BPERxPlan ID',string.valueof(mapOldCrdData.get(crd.Id).Clone_BPERxPlan_ID__c),string.valueof(crd.Clone_BPERxPlan_ID__c)); }
                if(crd.Clone_File_ID__c!= mapOldCrdData.get(crd.Id).Clone_File_ID__c){historyData(crd.Id,'Clone File ID',string.valueof(mapOldCrdData.get(crd.Id).Clone_File_ID__c),string.valueof(crd.Clone_File_ID__c)); }
                if(crd.Clone_Account__c!= mapOldCrdData.get(crd.Id).Clone_Account__c){historyData(crd.Id,'Clone Account',string.valueof(mapOldCrdData.get(crd.Id).Clone_Account__c),string.valueof(crd.Clone_Account__c)); }
                if(crd.Do_mandates_apply_to_all_states__c!= mapOldCrdData.get(crd.Id).Do_mandates_apply_to_all_states__c){historyData(crd.Id,'Do mandates apply to all states',string.valueof(mapOldCrdData.get(crd.Id).Do_mandates_apply_to_all_states__c),string.valueof(crd.Do_mandates_apply_to_all_states__c)); }
                if(crd.StatesList_for_Mandate__c!= mapOldCrdData.get(crd.Id).StatesList_for_Mandate__c ){historyData(crd.Id,'StatesList For Mandates',string.valueof(mapOldCrdData.get(crd.Id).StatesList_for_Mandate__c ),string.valueof(crd.StatesList_for_Mandate__c )); }
                if(crd.GPI_System_Drug_List__c!= mapOldCrdData.get(crd.Id).GPI_System_Drug_List__c){historyData(crd.Id,'GPI System Drug List',string.valueof(mapIDDrugList.get(mapOldCrdData.get(crd.Id).GPI_System_Drug_List__c)),string.valueof(mapIDDrugList.get(crd.GPI_System_Drug_List__c)));}
                if(crd.NDC_System_Drug_List__c!= mapOldCrdData.get(crd.Id).NDC_System_Drug_List__c){historyData(crd.Id,'NDC System Drug List',string.valueof(mapIDDrugList.get(mapOldCrdData.get(crd.Id).NDC_System_Drug_List__c)),string.valueof(mapIDDrugList.get(crd.NDC_System_Drug_List__c)));}
                if(crd.Kit_Logic_Standard_Drug_List__c!= mapOldCrdData.get(crd.Id).Kit_Logic_Standard_Drug_List__c){historyData(crd.Id,'Kit Logic Standard Drug List',string.valueof(mapIDDrugList.get(mapOldCrdData.get(crd.Id).Kit_Logic_Standard_Drug_List__c)),string.valueof(mapIDDrugList.get(crd.Kit_Logic_Standard_Drug_List__c))); }
                if(crd.Override_Standard_Max_Pay__c!= mapOldCrdData.get(crd.Id).Override_Standard_Max_Pay__c){historyData(crd.Id,'Override Standard Max Pay',string.valueof(mapOldCrdData.get(crd.Id).Override_Standard_Max_Pay__c),string.valueof(crd.Override_Standard_Max_Pay__c)); }
                if(crd.Max_Pay__c!= mapOldCrdData.get(crd.Id).Max_Pay__c){historyData(crd.Id,'Max Pay',string.valueof(mapIDMaxPay.get(mapOldCrdData.get(crd.Id).Max_Pay__c)),string.valueof(mapIDMaxPay.get(crd.Max_Pay__c))); }
                if(crd.In_Network_Discount_Rate__c!= mapOldCrdData.get(crd.Id).In_Network_Discount_Rate__c){historyData(crd.Id,'In Network Discount Rate',string.valueof(mapOldCrdData.get(crd.Id).In_Network_Discount_Rate__c),string.valueof(crd.In_Network_Discount_Rate__c)); }
                if(crd.Out_of_Network_Discount_Rate__c!= mapOldCrdData.get(crd.Id).Out_of_Network_Discount_Rate__c){historyData(crd.Id,'Out of Network Discount Rate',string.valueof(mapOldCrdData.get(crd.Id).Out_of_Network_Discount_Rate__c),string.valueof(crd.Out_of_Network_Discount_Rate__c)); }
                if(crd.Bypass_DMR__c!= mapOldCrdData.get(crd.Id).Bypass_DMR__c){historyData(crd.Id,'Bypass DMR',string.valueof(mapOldCrdData.get(crd.Id).Bypass_DMR__c),string.valueof(crd.Bypass_DMR__c)); }
                if(crd.Quantity_Limit_TOC_of_Days__c!= mapOldCrdData.get(crd.Id).Quantity_Limit_TOC_of_Days__c){historyData(crd.Id,'Quantity Limit TOC # of Days',string.valueof(mapOldCrdData.get(crd.Id).Quantity_Limit_TOC_of_Days__c),string.valueof(crd.Quantity_Limit_TOC_of_Days__c)); }
                if(crd.DM_Vendor_2_Contract_End_Date__c!= mapOldCrdData.get(crd.Id).DM_Vendor_2_Contract_End_Date__c){historyData(crd.Id,'DM Vendor 2 Contract End Date',string.valueof(mapOldCrdData.get(crd.Id).DM_Vendor_2_Contract_End_Date__c),string.valueof(crd.DM_Vendor_2_Contract_End_Date__c)); }
                // Added by Sourabh : Request 754
                if(crd.High_Priority_Comments__c!= mapOldCrdData.get(crd.Id).High_Priority_Comments__c){historyData(crd.Id,'High Priority Comments',string.valueof(mapOldCrdData.get(crd.Id).High_Priority_Comments__c),string.valueof(crd.High_Priority_Comments__c)); }

                if(crd.AHA_Drug_Group__c!= mapOldCrdData.get(crd.Id).AHA_Drug_Group__c){historyData(crd.Id,'AHA Drug Group',mapDG.get(mapOldCrdData.get(crd.Id).AHA_Drug_Group__c),mapDG.get(crd.AHA_Drug_Group__c)); }
                
                // Added by rakesh : Request 461
                if(crd.Is_there_Compound_Max_Pay__c!= mapOldCrdData.get(crd.Id).Is_there_Compound_Max_Pay__c){historyData(crd.Id,'Is there Compound Max Pay?',string.valueof(mapOldCrdData.get(crd.Id).Is_there_Compound_Max_Pay__c),string.valueof(crd.Is_there_Compound_Max_Pay__c)); }
                if(crd.Override_Standard_Compound_Max_Pay__c!= mapOldCrdData.get(crd.Id).Override_Standard_Compound_Max_Pay__c){historyData(crd.Id,'Override Standard Compound Max Pay',string.valueof(mapOldCrdData.get(crd.Id).Override_Standard_Compound_Max_Pay__c),string.valueof(crd.Override_Standard_Compound_Max_Pay__c)); }
                if(crd.Compound_Max_Pay__c!= mapOldCrdData.get(crd.Id).Compound_Max_Pay__c){historyData(crd.Id,'Compound Max Pay',string.valueof(mapIDMaxPay.get(mapOldCrdData.get(crd.Id).Compound_Max_Pay__c)),string.valueof(mapIDMaxPay.get(crd.Compound_Max_Pay__c))); }
                if(crd.Custom_Safety_Edits__c!= mapOldCrdData.get(crd.Id).Custom_Safety_Edits__c){historyData(crd.Id,'Custom Safety Edits',string.valueof(mapOldCrdData.get(crd.Id).Custom_Safety_Edits__c),string.valueof(crd.Custom_Safety_Edits__c)); }

                // Added by rakesh : Request 00889
                if(crd.Client_Name_On_Communication__c!= mapOldCrdData.get(crd.Id).Client_Name_On_Communication__c){historyData(crd.Id,'Client Name On Communication',string.valueof(mapOldCrdData.get(crd.Id).Client_Name_On_Communication__c),string.valueof(crd.Client_Name_On_Communication__c)); }
                if(crd.Custom_Disease_Vendor_2_Phone_Number__c!= mapOldCrdData.get(crd.Id).Custom_Disease_Vendor_2_Phone_Number__c){historyData(crd.Id,'Custom Disease Vendor #2 Phone Number',string.valueof(mapOldCrdData.get(crd.Id).Custom_Disease_Vendor_2_Phone_Number__c),string.valueof(crd.Custom_Disease_Vendor_2_Phone_Number__c)); }
                if(crd.Disease_Vendor_2__c!= mapOldCrdData.get(crd.Id).Disease_Vendor_2__c){historyData(crd.Id,'Disease Vendor #2',string.valueof(mapOldCrdData.get(crd.Id).Disease_Vendor_2__c),string.valueof(crd.Disease_Vendor_2__c)); }
                if(crd.Disease_Vendor_1_Implementation_Type__c!= mapOldCrdData.get(crd.Id).Disease_Vendor_1_Implementation_Type__c){historyData(crd.Id,'Disease Vendor 1 Implementation Type',string.valueof(mapOldCrdData.get(crd.Id).Disease_Vendor_1_Implementation_Type__c),string.valueof(crd.Disease_Vendor_1_Implementation_Type__c)); }

                // Added by rakesh : Request 753
                if(crd.CRD_Risk_Indicator__c!= mapOldCrdData.get(crd.Id).CRD_Risk_Indicator__c){historyData(crd.Id,'CRD Risk Indicator',string.valueof(mapOldCrdData.get(crd.Id).CRD_Risk_Indicator__c),string.valueof(crd.CRD_Risk_Indicator__c)); }
                
                // Added by rakesh : Request 00866
                if(crd.Are_Emergency_Claims_Reimbursed__c!= mapOldCrdData.get(crd.Id).Are_Emergency_Claims_Reimbursed__c){historyData(crd.Id,'Are Emergency Claims Reimbursed?',string.valueof(mapOldCrdData.get(crd.Id).Are_Emergency_Claims_Reimbursed__c),string.valueof(crd.Are_Emergency_Claims_Reimbursed__c)); }
                if(crd.Are_Hemo_Claims_Reimbursed__c!= mapOldCrdData.get(crd.Id).Are_Hemo_Claims_Reimbursed__c){historyData(crd.Id,'Are Hemo Claims Reimbursed?',string.valueof(mapOldCrdData.get(crd.Id).Are_Hemo_Claims_Reimbursed__c),string.valueof(crd.Are_Hemo_Claims_Reimbursed__c)); }
                if(crd.Emergency_Discount_Rate__c!= mapOldCrdData.get(crd.Id).Emergency_Discount_Rate__c){historyData(crd.Id,'Emergency Discount Rate',string.valueof(mapOldCrdData.get(crd.Id).Emergency_Discount_Rate__c),string.valueof(crd.Emergency_Discount_Rate__c)); }
                if(crd.Hemo_Discount_Rate__c!= mapOldCrdData.get(crd.Id).Hemo_Discount_Rate__c){historyData(crd.Id,'Hemo Discount Rate',string.valueof(mapOldCrdData.get(crd.Id).Hemo_Discount_Rate__c),string.valueof(crd.Hemo_Discount_Rate__c)); }
                
                // Added by rakesh : Request 442
                //if(crd.POS_Dose_Optimization__c!= mapOldCrdData.get(crd.Id).POS_Dose_Optimization__c){historyData(crd.Id,'POS Dose Optimization',string.valueof(mapOldCrdData.get(crd.Id).POS_Dose_Optimization__c),string.valueof(crd.POS_Dose_Optimization__c)); } --> Commented By Nitish Request No- 04870
                
              /*  if(crd.POS_Dose_Optimization_Drug_List_ID__c!= mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c) {
                    if (crd.POS_Dose_Optimization_Drug_List_ID__c != null && mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c != null)
                        historyData(crd.Id,'POS Dose Optimization Drug List ID',mapPosDL.get(mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c),mapPosDL.get(crd.POS_Dose_Optimization_Drug_List_ID__c));
                    else if (crd.POS_Dose_Optimization_Drug_List_ID__c != null)
                        historyData(crd.Id,'POS Dose Optimization Drug List ID','',mapPosDL.get(crd.POS_Dose_Optimization_Drug_List_ID__c));
                    else if (mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c != null)
                        historyData(crd.Id,'POS Dose Optimization Drug List ID',mapPosDL.get(mapOldCrdData.get(crd.Id).POS_Dose_Optimization_Drug_List_ID__c),'');
                }
                --> commented by nitish dependecy of request no 4870
                */
                if(crd.Save_A_Copay_Custom_Letter__r.Name!= mapOldCrdData.get(crd.Id).Save_A_Copay_Custom_Letter__r.Name){historyData(crd.Id,'Save-A-Copay Custom Letter',string.valueof(mapOldCrdData.get(crd.Id).Save_A_Copay_Custom_Letter__r.Name),string.valueof(crd.Save_A_Copay_Custom_Letter__r.Name)); }
                //if(crd.Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c!= mapOldCrdData.get(crd.Id).Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c){historyData(crd.Id,'CVS Caremark Stellant ID',string.valueof(mapOldCrdData.get(crd.Id).Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c),string.valueof(crd.Save_A_Copay_Custom_Letter__r.CVS_Caremark_Stellant_ID__c)); }
                if(crd.Tier_1_Rx_Reduction_Amount__c!= mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction_Amount__c){historyData(crd.Id,'Tier 1 Rx Reduction Amount',string.valueof(mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction_Amount__c),string.valueof(crd.Tier_1_Rx_Reduction_Amount__c)); }
                if(crd.Tier_1_Rx_Reduction_Type__c!= mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction_Type__c){historyData(crd.Id,'Tier 1 Rx Reduction Type',string.valueof(mapOldCrdData.get(crd.Id).Tier_1_Rx_Reduction_Type__c),string.valueof(crd.Tier_1_Rx_Reduction_Type__c)); }
                if(crd.Tier_2_Rx_Reduction_Amount__c!= mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction_Amount__c){historyData(crd.Id,'Tier 2 Rx Reduction Amount',string.valueof(mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction_Amount__c),string.valueof(crd.Tier_2_Rx_Reduction_Amount__c)); }
                if(crd.Tier_2_Rx_Reduction_Type__c!= mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction_Type__c){historyData(crd.Id,'Tier 2 Rx Reduction Type',string.valueof(mapOldCrdData.get(crd.Id).Tier_2_Rx_Reduction_Type__c),string.valueof(crd.Tier_2_Rx_Reduction_Type__c)); }
                if(crd.Tier_3_Rx_Reduction_Amount__c!= mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction_Amount__c){historyData(crd.Id,'Tier 3 Rx Reduction Amount',string.valueof(mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction_Amount__c),string.valueof(crd.Tier_3_Rx_Reduction_Amount__c)); }
                if(crd.Tier_3_Rx_Reduction_Type__c!= mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction_Type__c){historyData(crd.Id,'Tier 3 Rx Reduction Type',string.valueof(mapOldCrdData.get(crd.Id).Tier_3_Rx_Reduction_Type__c),string.valueof(crd.Tier_3_Rx_Reduction_Type__c)); }
                if(crd.Tier_4_Rx_Reduction_Amount__c!= mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction_Amount__c){historyData(crd.Id,'Tier 4 Rx Reduction Amount',string.valueof(mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction_Amount__c),string.valueof(crd.Tier_4_Rx_Reduction_Amount__c)); }
                if(crd.Tier_4_Rx_Reduction_Type__c!= mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction_Type__c){historyData(crd.Id,'Tier 4 Rx Reduction Type',string.valueof(mapOldCrdData.get(crd.Id).Tier_4_Rx_Reduction_Type__c),string.valueof(crd.Tier_4_Rx_Reduction_Type__c)); }
                if(crd.Tier_5_Rx_Reduction_Amount__c!= mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction_Amount__c){historyData(crd.Id,'Tier 5 Rx Reduction Amount',string.valueof(mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction_Amount__c),string.valueof(crd.Tier_5_Rx_Reduction_Amount__c)); }
                if(crd.Tier_5_Rx_Reduction_Type__c!= mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction_Type__c){historyData(crd.Id,'Tier 5 Rx Reduction Type',string.valueof(mapOldCrdData.get(crd.Id).Tier_5_Rx_Reduction_Type__c),string.valueof(crd.Tier_5_Rx_Reduction_Type__c)); }
                if(crd.Brand_Penalty_Exception__c!= mapOldCrdData.get(crd.Id).Brand_Penalty_Exception__c){historyData(crd.Id,'Brand Penalty Exception',string.valueof(mapOldCrdData.get(crd.Id).Brand_Penalty_Exception__c),string.valueof(crd.Brand_Penalty_Exception__c)); }
                if(crd.Tiering_Formulary_Exception__c!= mapOldCrdData.get(crd.Id).Tiering_Formulary_Exception__c){historyData(crd.Id,'Tiering Formulary Exception',string.valueof(mapOldCrdData.get(crd.Id).Tiering_Formulary_Exception__c),string.valueof(crd.Tiering_Formulary_Exception__c)); }
                if(crd.Global_Benefit_Exclusion__c!= mapOldCrdData.get(crd.Id).Global_Benefit_Exclusion__c){historyData(crd.Id,'Global Benefit Exclusion',string.valueof(mapOldCrdData.get(crd.Id).Global_Benefit_Exclusion__c),string.valueof(crd.Global_Benefit_Exclusion__c)); }
                
                if(crd.Override_Retail_Y_Schedule__c!= mapOldCrdData.get(crd.Id).Override_Retail_Y_Schedule__c){historyData(crd.Id,'Override Retail Y-Schedule',string.valueof(mapOldCrdData.get(crd.Id).Override_Retail_Y_Schedule__c),string.valueof(crd.Override_Retail_Y_Schedule__c)); }
                if(crd.Retail_Y_Schedule_Override__c!= mapOldCrdData.get(crd.Id).Retail_Y_Schedule_Override__c){historyData(crd.Id,'Retail Y-Schedule Override',string.valueof(mapOldCrdData.get(crd.Id).Retail_Y_Schedule_Override__c),string.valueof(crd.Retail_Y_Schedule_Override__c)); }
                // Added by Rishabh: Req 868
                 //if (crd.Is_this_an_HDHP_Plan__c != mapOldCrdData.get(crd.Id).Is_this_an_HDHP_Plan__c) { historyData(crd.Id, 'Is this an HDHP Plan', string.valueof(mapOldCrdData.get(crd.Id).Is_this_an_HDHP_Plan__c), string.valueof(crd.Is_this_an_HDHP_Plan__c)); }
                 //if (crd.What_is_the_HDHP_fund_type__c != mapOldCrdData.get(crd.Id).What_is_the_HDHP_fund_type__c) { historyData(crd.Id, 'What is the HDHP fund type', string.valueof(mapOldCrdData.get(crd.Id).What_is_the_HDHP_fund_type__c), string.valueof(crd.What_is_the_HDHP_fund_type__c)); }
                 //if (crd.Waiver_of_Rx_Deductible__c != mapOldCrdData.get(crd.Id).Waiver_of_Rx_Deductible__c) { historyData(crd.Id, 'Waiver of Rx Deductible', string.valueof(mapOldCrdData.get(crd.Id).Waiver_of_Rx_Deductible__c), string.valueof(crd.Waiver_of_Rx_Deductible__c)); }
                 //if (crd.Chronic_Preventive_Drug_List__c != mapOldCrdData.get(crd.Id).Chronic_Preventive_Drug_List__c) { historyData(crd.Id, 'Chronic Preventive Drug List', string.valueof(mapIDDrugList.get(mapOldCrdData.get(crd.Id).Chronic_Preventive_Drug_List__c)), string.valueof(mapIDDrugList.get(crd.Chronic_Preventive_Drug_List__c))); }
                 //Added by Rishabh: Req 927
                 if (crd.PA_Disease_Vendor_1__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_1__c) { historyData(crd.Id, 'PA Disease Vendor 1', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_1__c), string.valueof(crd.PA_Disease_Vendor_1__c)); }
                 if (crd.PA_Condition_1__c != mapOldCrdData.get(crd.Id).PA_Condition_1__c) { historyData(crd.Id, 'PA Condition 1', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_1__c), string.valueof(crd.PA_Condition_1__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_1__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_1__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 1', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_1__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_1__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_1__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_1__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 1', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_1__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_1__c)); }
                 if (crd.PA_Disease_Vendor_2__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_2__c) { historyData(crd.Id, 'PA Disease Vendor 2', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_2__c), string.valueof(crd.PA_Disease_Vendor_2__c)); }
                 if (crd.PA_Condition_2__c != mapOldCrdData.get(crd.Id).PA_Condition_2__c) { historyData(crd.Id, 'PA Condition 2', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_2__c), string.valueof(crd.PA_Condition_2__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_2__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_2__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 2', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_2__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_2__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_2__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_2__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 2', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_2__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_2__c)); }
                 if (crd.PA_Disease_Vendor_3__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_3__c) { historyData(crd.Id, 'PA Disease Vendor 3', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_3__c), string.valueof(crd.PA_Disease_Vendor_3__c)); }
                 if (crd.PA_Condition_3__c != mapOldCrdData.get(crd.Id).PA_Condition_3__c) { historyData(crd.Id, 'PA Condition 3', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_3__c), string.valueof(crd.PA_Condition_3__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_3__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_3__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 3', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_3__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_3__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_3__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_3__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 3', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_3__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_3__c)); }
                 if (crd.PA_Disease_Vendor_4__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_4__c) { historyData(crd.Id, 'PA Disease Vendor 4', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_4__c), string.valueof(crd.PA_Disease_Vendor_4__c)); }
                 if (crd.PA_Condition_4__c != mapOldCrdData.get(crd.Id).PA_Condition_4__c) { historyData(crd.Id, 'PA Condition 4', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_4__c), string.valueof(crd.PA_Condition_4__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_4__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_4__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 4', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_4__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_4__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_4__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_4__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 4', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_4__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_4__c)); }
                 if (crd.PA_Disease_Vendor_5__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_5__c) { historyData(crd.Id, 'PA Disease Vendor 5', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_5__c), string.valueof(crd.PA_Disease_Vendor_5__c)); }
                 if (crd.PA_Condition_5__c != mapOldCrdData.get(crd.Id).PA_Condition_5__c) { historyData(crd.Id, 'PA Condition 5', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_5__c), string.valueof(crd.PA_Condition_5__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_5__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_5__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 5', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_5__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_5__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_5__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_5__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 5', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_5__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_5__c)); }
                 if (crd.PA_Disease_Vendor_6__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_6__c) { historyData(crd.Id, 'PA Disease Vendor 6', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_6__c), string.valueof(crd.PA_Disease_Vendor_6__c)); }
                 if (crd.PA_Condition_6__c != mapOldCrdData.get(crd.Id).PA_Condition_6__c) { historyData(crd.Id, 'PA Condition 6', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_6__c), string.valueof(crd.PA_Condition_6__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_6__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_6__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 6', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_6__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_6__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_6__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_6__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 6', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_6__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_6__c)); }
                 if (crd.PA_Disease_Vendor_7__c != mapOldCrdData.get(crd.Id).PA_Disease_Vendor_7__c) { historyData(crd.Id, 'PA Disease Vendor 7', string.valueof(mapOldCrdData.get(crd.Id).PA_Disease_Vendor_7__c), string.valueof(crd.PA_Disease_Vendor_7__c)); }
                 if (crd.PA_Condition_7__c != mapOldCrdData.get(crd.Id).PA_Condition_7__c) { historyData(crd.Id, 'PA Condition 7', string.valueof(mapOldCrdData.get(crd.Id).PA_Condition_7__c), string.valueof(crd.PA_Condition_7__c)); }
                 if (crd.PA_DM_Vendor_Contract_End_Date_7__c != mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_7__c) { historyData(crd.Id, 'PA DM Vendor Contract End Date 7', string.valueof(mapOldCrdData.get(crd.Id).PA_DM_Vendor_Contract_End_Date_7__c), string.valueof(crd.PA_DM_Vendor_Contract_End_Date_7__c)); }
                 if (crd.PA_Custom_Disease_Vendor_Phone_7__c != mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_7__c) { historyData(crd.Id, 'PA Custom Disease Vendor Phone 7', string.valueof(mapOldCrdData.get(crd.Id).PA_Custom_Disease_Vendor_Phone_7__c), string.valueof(crd.PA_Custom_Disease_Vendor_Phone_7__c)); }
            
                //Added by Sushant: Req 885
                if (crd.Enroll_in_Aetna_Ways_to_Save__c != mapOldCrdData.get(crd.Id).Enroll_in_Aetna_Ways_to_Save__c) {historyData(crd.Id, 'Enroll in Aetna Ways to Save', string.valueof(mapOldCrdData.get(crd.Id).Enroll_in_Aetna_Ways_to_Save__c), string.valueof(crd.Enroll_in_Aetna_Ways_to_Save__c));}
                if (crd.Mail_Request_Date__c != mapOldCrdData.get(crd.Id).Mail_Request_Date__c) {historyData(crd.Id, 'Mail Request Date', string.valueof(mapOldCrdData.get(crd.Id).Mail_Request_Date__c), string.valueof(crd.Mail_Request_Date__c));}
                if (crd.Requested_mailing_received_on__c != mapOldCrdData.get(crd.Id).Requested_mailing_received_on__c) {historyData(crd.Id, 'Requested mailing received on', string.valueof(mapOldCrdData.get(crd.Id).Requested_mailing_received_on__c), string.valueof(crd.Requested_mailing_received_on__c));}
                if (crd.Target_Generic_Opportunities__c != mapOldCrdData.get(crd.Id).Target_Generic_Opportunities__c) {historyData(crd.Id, 'Target Generic Opportunities', string.valueof(mapOldCrdData.get(crd.Id).Target_Generic_Opportunities__c), string.valueof(crd.Target_Generic_Opportunities__c));}
                if (crd.Target_Formulary_Brand_Opportunities__c != mapOldCrdData.get(crd.Id).Target_Formulary_Brand_Opportunities__c) {historyData(crd.Id, 'Target Formulary Brand Opportunities', string.valueof(mapOldCrdData.get(crd.Id).Target_Formulary_Brand_Opportunities__c), string.valueof(crd.Target_Formulary_Brand_Opportunities__c));}
                if (crd.Target_Pref_Manufacturer_Brand_Opportun__c != mapOldCrdData.get(crd.Id).Target_Pref_Manufacturer_Brand_Opportun__c) {historyData(crd.Id, 'Target Pref Manufacturer Brand Opportun.', string.valueof(mapOldCrdData.get(crd.Id).Target_Pref_Manufacturer_Brand_Opportun__c), string.valueof(crd.Target_Pref_Manufacturer_Brand_Opportun__c));}
                if (crd.Target_Participants_18_years_and_older__c != mapOldCrdData.get(crd.Id).Target_Participants_18_years_and_older__c) {historyData(crd.Id, 'Target Participants 18 years and older', string.valueof(mapOldCrdData.get(crd.Id).Target_Participants_18_years_and_older__c), string.valueof(crd.Target_Participants_18_years_and_older__c));}
                if (crd.Preferred_Manufacturer_Brands_Code__c != mapOldCrdData.get(crd.Id).Preferred_Manufacturer_Brands_Code__c) {historyData(crd.Id, 'Preferred Manufacturer Brands Code', string.valueof(mapOldCrdData.get(crd.Id).Preferred_Manufacturer_Brands_Code__c), string.valueof(crd.Preferred_Manufacturer_Brands_Code__c));}
                if (crd.If_Not_18_Indicate_Age__c != mapOldCrdData.get(crd.Id).If_Not_18_Indicate_Age__c) {historyData(crd.Id, 'If Not 18 Indicate Age', string.valueof(mapOldCrdData.get(crd.Id).If_Not_18_Indicate_Age__c), string.valueof(crd.If_Not_18_Indicate_Age__c));}
                if (crd.Member_Letter_Selection__c != mapOldCrdData.get(crd.Id).Member_Letter_Selection__c) {historyData(crd.Id, 'Member Letter Selection', string.valueof(mapOldCrdData.get(crd.Id).Member_Letter_Selection__c), string.valueof(crd.Member_Letter_Selection__c));}
                if (crd.Minimum_Member_Savings_Projection__c != mapOldCrdData.get(crd.Id).Minimum_Member_Savings_Projection__c) {historyData(crd.Id, 'Minimum Member Savings Projection', string.valueof(mapOldCrdData.get(crd.Id).Minimum_Member_Savings_Projection__c), string.valueof(crd.Minimum_Member_Savings_Projection__c));}
                if (crd.Introductory_Paragraph_to_Include__c != mapOldCrdData.get(crd.Id).Introductory_Paragraph_to_Include__c) {historyData(crd.Id, 'Introductory Paragraph to Include', string.valueof(mapOldCrdData.get(crd.Id).Introductory_Paragraph_to_Include__c), string.valueof(crd.Introductory_Paragraph_to_Include__c));}               
                //Added by Sushant Req:1018
                if (crd.Cloned_CRD_Plan_Effective_Date__c != mapOldCrdData.get(crd.Id).Cloned_CRD_Plan_Effective_Date__c) {historyData(crd.Id, 'Cloned CRD Plan Effective Date', string.valueof(mapOldCrdData.get(crd.Id).Cloned_CRD_Plan_Effective_Date__c), string.valueof(crd.Cloned_CRD_Plan_Effective_Date__c));}
                if (crd.Cloned_CRD_RxPlan_ID__c != mapOldCrdData.get(crd.Id).Cloned_CRD_RxPlan_ID__c) {historyData(crd.Id, 'Cloned CRD RxPlan ID', string.valueof(mapOldCrdData.get(crd.Id).Cloned_CRD_RxPlan_ID__c), string.valueof(crd.Cloned_CRD_RxPlan_ID__c));}               
                //Added by Sushant Req: 01159
                if (crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c != mapOldCrdData.get(crd.Id).OON_Cost_Share_Not_Greater_50_Drug_Cost__c) {historyData(crd.Id, 'OON Cost Share Not Greater 50% Drug Cost', string.valueof(mapOldCrdData.get(crd.Id).OON_Cost_Share_Not_Greater_50_Drug_Cost__c), string.valueof(crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c));}
                //Added by Sushant
                if(crd.Any_DAW_specific_Specialty_OON_copays__c!= mapOldCrdData.get(crd.Id).Any_DAW_specific_Specialty_OON_copays__c){historyData(crd.Id,'Any DAW specific Specialty OON copays',string.valueof(mapOldCrdData.get(crd.Id).Any_DAW_specific_Specialty_OON_copays__c),string.valueof(crd.Any_DAW_specific_Specialty_OON_copays__c)); }
                if(crd.Any_drug_specific_Specialty_OON_copays__c!= mapOldCrdData.get(crd.Id).Any_drug_specific_Specialty_OON_copays__c){historyData(crd.Id,'Any drug specific Specialty OON copays',string.valueof(mapOldCrdData.get(crd.Id).Any_drug_specific_Specialty_OON_copays__c),string.valueof(crd.Any_drug_specific_Specialty_OON_copays__c)); }
                if(crd.Apply_Penalty_to_Specialty_OON__c!= mapOldCrdData.get(crd.Id).Apply_Penalty_to_Specialty_OON__c){historyData(crd.Id,'Apply Penalty to Specialty OON',string.valueof(mapOldCrdData.get(crd.Id).Apply_Penalty_to_Specialty_OON__c),string.valueof(crd.Apply_Penalty_to_Specialty_OON__c)); }
                if(crd.Brands_w_DAW_5_take_a_generic_copay_spec__c!= mapOldCrdData.get(crd.Id).Brands_w_DAW_5_take_a_generic_copay_spec__c){historyData(crd.Id,'Brands w DAW 5 take a generic copay spec',string.valueof(mapOldCrdData.get(crd.Id).Brands_w_DAW_5_take_a_generic_copay_spec__c),string.valueof(crd.Brands_w_DAW_5_take_a_generic_copay_spec__c)); }
                if(crd.Different_Copays_from_Specialty__c!= mapOldCrdData.get(crd.Id).Different_Copays_from_Specialty__c){historyData(crd.Id,'Different Copays from Specialty ',string.valueof(mapOldCrdData.get(crd.Id).Different_Copays_from_Specialty__c),string.valueof(crd.Different_Copays_from_Specialty__c)); }
                if(crd.Is_there_Specialty_Out_of_Network__c!= mapOldCrdData.get(crd.Id).Is_there_Specialty_Out_of_Network__c){historyData(crd.Id,'Is there Specialty Out of Network ',string.valueof(mapOldCrdData.get(crd.Id).Is_there_Specialty_Out_of_Network__c),string.valueof(crd.Is_there_Specialty_Out_of_Network__c)); }
                if(crd.Penalty_Amount_Specialty_OON__c!= mapOldCrdData.get(crd.Id).Penalty_Amount_Specialty_OON__c){historyData(crd.Id,'Penalty Amount Specialty OON',string.valueof(mapOldCrdData.get(crd.Id).Penalty_Amount_Specialty_OON__c),string.valueof(crd.Penalty_Amount_Specialty_OON__c)); }
                if(crd.Penalty_Type_Specialty_OON__c!= mapOldCrdData.get(crd.Id).Penalty_Type_Specialty_OON__c){historyData(crd.Id,'Penalty Type Specialty OON',string.valueof(mapOldCrdData.get(crd.Id).Penalty_Type_Specialty_OON__c),string.valueof(crd.Penalty_Type_Specialty_OON__c)); }
                if(crd.Percentage_Applied_Specialty_OON__c!= mapOldCrdData.get(crd.Id).Percentage_Applied_Specialty_OON__c){historyData(crd.Id,'Percentage Applied Specialty OON',string.valueof(mapOldCrdData.get(crd.Id).Percentage_Applied_Specialty_OON__c),string.valueof(crd.Percentage_Applied_Specialty_OON__c)); }
                if(crd.Plan_Type_Specialty_OON__c!= mapOldCrdData.get(crd.Id).Plan_Type_Specialty_OON__c){historyData(crd.Id,'Plan Type Specialty OON',string.valueof(mapOldCrdData.get(crd.Id).Plan_Type_Specialty_OON__c),string.valueof(crd.Plan_Type_Specialty_OON__c)); }
                if(crd.Specialty_OON_Number_of_Tiers__c!= mapOldCrdData.get(crd.Id).Specialty_OON_Number_of_Tiers__c){historyData(crd.Id,'Specialty OON Number of Tiers',string.valueof(mapOldCrdData.get(crd.Id).Specialty_OON_Number_of_Tiers__c),string.valueof(crd.Specialty_OON_Number_of_Tiers__c)); }
                //Richa added below fields on 22nd dec for Req 4890
                if(crd.Does_Chemo_Parity_Apply__c!= mapOldCrdData.get(crd.Id).Does_Chemo_Parity_Apply__c){historyData(crd.Id,'Does Chemo Parity Apply',string.valueof(mapOldCrdData.get(crd.Id).Does_Chemo_Parity_Apply__c),string.valueof(crd.Does_Chemo_Parity_Apply__c)); }
                if(crd.Chemo_Parity_Drug_List__c!= mapOldCrdData.get(crd.Id).Chemo_Parity_Drug_List__c){historyData(crd.Id,'Chemo Parity Drug List',string.valueof(mapIDDrugList.get(mapOldCrdData.get(crd.Id).Chemo_Parity_Drug_List__c)),string.valueof(mapIDDrugList.get(crd.Chemo_Parity_Drug_List__c))); }
                if(crd.Oral_Chemo_Cap__c!= mapOldCrdData.get(crd.Id).Oral_Chemo_Cap__c){historyData(crd.Id,'Oral Chemo Cap',string.valueof(mapOldCrdData.get(crd.Id).Oral_Chemo_Cap__c),string.valueof(crd.Oral_Chemo_Cap__c)); }
                if(crd.Dollar_Amount__c!= mapOldCrdData.get(crd.Id).Dollar_Amount__c){historyData(crd.Id,'Dollar Amount',string.valueof(mapOldCrdData.get(crd.Id).Dollar_Amount__c),string.valueof(crd.Dollar_Amount__c)); }
                if(crd.Percent__c!= mapOldCrdData.get(crd.Id).Percent__c){historyData(crd.Id,'Oral Chemo Percent',string.valueof(mapOldCrdData.get(crd.Id).Percent__c),string.valueof(crd.Percent__c)); }
                if(crd.Copay_Calculation__c!= mapOldCrdData.get(crd.Id).Copay_Calculation__c){historyData(crd.Id,'Copay Calculation',string.valueof(mapOldCrdData.get(crd.Id).Copay_Calculation__c),string.valueof(crd.Copay_Calculation__c)); }
                if(crd.CA_50_Cost_Share_Applies__c!= mapOldCrdData.get(crd.Id).CA_50_Cost_Share_Applies__c){historyData(crd.Id,'CA 50% Cost Share Applies',string.valueof(mapOldCrdData.get(crd.Id).CA_50_Cost_Share_Applies__c),string.valueof(crd.CA_50_Cost_Share_Applies__c)); }
                if(crd.Chemo_Drugs_Bypass_OOP__c!= mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_OOP__c){historyData(crd.Id,'Chemo Drugs Bypass OOP',string.valueof(mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_OOP__c),string.valueof(crd.Chemo_Drugs_Bypass_OOP__c)); }
                if(crd.Chemo_Drugs_Bypass_MAB__c!= mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_MAB__c){historyData(crd.Id,'Chemo Drugs Bypass MAB',string.valueof(mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_MAB__c),string.valueof(crd.Chemo_Drugs_Bypass_MAB__c));}
                if(crd.Chemo_Drugs_Bypass_Deductible__c!= mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_Deductible__c){historyData(crd.Id,'Chemo Drugs Bypass Deductible',string.valueof(mapOldCrdData.get(crd.Id).Chemo_Drugs_Bypass_Deductible__c),string.valueof(crd.Chemo_Drugs_Bypass_Deductible__c));}
                if(crd.Chemo_Drugs_In_Network_same_as_OON__c!= mapOldCrdData.get(crd.Id).Chemo_Drugs_In_Network_same_as_OON__c){historyData(crd.Id,'Chemo Drugs In Network same as OON',string.valueof(mapOldCrdData.get(crd.Id).Chemo_Drugs_In_Network_same_as_OON__c),string.valueof(crd.Chemo_Drugs_In_Network_same_as_OON__c));}
                }
     
        }
        return historyMap.values();
    }
    /*
     * Method :- historyData
     * Description :- This method creates a new CRD history
     */
    Public void historyData(Id crdId,string fieldName, string oldValue,string newValue){
        CRD_History__c history = new  CRD_History__c();
        string key;
        key =string.valueof(crdId) + fieldName;
        history.CRD_ID__c = crdId;
        history.Field_Name__c = fieldName;
        history.Modified_By__c = modifiedby;
        history.New_Value__c = newValue;
        history.Old_Value__c = oldValue;
        historyList.add(history);
        system.debug('>>>>>>>'+historyList);
        historyMap.put(key,history);
        system.debug('>>>>>>>'+historyMap);
    }
 
}