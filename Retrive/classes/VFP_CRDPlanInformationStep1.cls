/*Purpose: Apex  Controller Class for VF_NewCRDPlan_Step1
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0         Abhay               09/02/2011          Apex Class for VF_NewCRDPlan_Step1
1.1         Anuj                12/20/2011          Issue # 1282  
1.2         Anuj                02/28/2012          Issue # 1492
2.0         Sourabh             05/10/2012          Request 290 :Removing the Kit Logic Validation  ]
2.1         Rishabh             06/14/2012          Request 330: edited method: CrdPartialGroup
3.0         Anuj                07/24
4.0         Abhay               2/15/2013           request 00535: y-schedule change
4.1         Saraag              2/26/2013           Removed CRD_Pricing nullification on clicking next.
4.2         rakesh              03/21/2013          Request 00934: update CRD Risk Indicator value based on Funding type
4.3         rakesh              03/29/2013          Request 00483: update Y-Schedule calculation
4.4         Sushant             04/05/2013          Request 00962
4.5         rakesh              4/16/2013           Request 00483 - multiple validations, see comments below for details
4.6         rakesh              05/10/2013          Request 00483: removed validation 'All Custom Plans require an FCG'
4.7         Abhishek            10/11/2013          Request 001184 - hide field based on certain conditions.
5.0         Amit Jain           27Dec 2013          Request 04366 - Added Plan Type: Specialty Out of Network Tier  
5.1        Joognu Rao            03/28/2014         Implemented Request 4601
5.2        Joognu Rao            04/11/2014         Implemented request 4675
5.3        Nitish Verma          07/01/2014         Implemented request no 4924
5.4        Sushant               01/28/2015         Implemented Request 05476
5.5        Ankur Aggarwal        01/28/2015         Implemented Request 05361
5.6        Raj Prasad            09/28/2015         ST#301(Remove AGB/BR Validation Rule)
5.7        Vikram                01/11/2016         Request 06293: ST 637 : Remove AGB contract State rule
5.8        Bhaskar Arora         09/28/2016         Request 06664: 146052:ST#1459-Remove 50% logic from IL HMO OON

======================================================================== */
public with sharing class VFP_CRDPlanInformationStep1 {
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    public string rxPlanId {
        get;
        set;
    }
    public string migrationNo {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    //Changes for request number 5361- starts
    private static final String AGB = 'Aetna Global Benefits';
    private static final String TRADITIONAL = 'TRADITIONAL';
    private static final String AGBNAME = 'Aetna Global Benefits';
    private static final String BRSTATE = 'BR';  
    //Changes for request number 5361- ends 
    private string medicalPlatform = TRADITIONAL;
    Public boolean updateCarrier;
    Public Account AccountonScreen{get; set;} //Added by Ayushi for St#669
    Public Boolean PredefinedFlag{get; set;} //Added by Ayushi for St#669
    Public Full_Control_Group__c[] FCGpredefined{get; set;} //Added by Ayushi for St#669
    Public Partial_Control_Group__c[] PCGpredefined{get; set;} //Added by Ayushi for St#669
    Public String FCGpredefinedName {get; set;} //Added by Ayushi for St#669
    Public String PCGpredefinedName {get; set;} //Added by Ayushi for St#669
    Public boolean ispcgfcgerror {get; set;} //Added by Ayushi for ST#669
    Public Boolean showGracePrd{get; set;}
    Public Boolean showPERSTimeStamp{get; set;} // added by Sushant : Request 05476
    Public Boolean showOONCostShare{get;set;}    
    Public Boolean networkYSchedule{get;set;}
    public Boolean showDrug{get;set;}
    public Boolean reRenderSubSeg {get;set;}//Added By Nitis 6935
    Public string editMode{get;set;}
    public boolean hideRetailYschedule{get;set;}
    public boolean makeWhatisSegmentReadOnly{get;set;}// Added By Nitish 6939
    public boolean makeWhatisSegmentEditable{get;set;}//Added By Nitish 6939
    public boolean changeYschtoY4; // Added by Nitish for 6936
    Public boolean fundingTypeCriteria {
        get;
        set;
    }
    Public Full_Control_Group__c objFCG {
        get;
        set;
    }
    Public boolean CrdPartialGroup {
        set;
    }
    public boolean predefBol{get;set;}
    public boolean setRequired{get;set;}//Added By Nitish 6939
    Public AI_Request__c aiRequest;
    GC_Validation_Methods checkAccum = new GC_Validation_Methods();
    private static final String BLANK = '';
    private static String benefitStateList = BLANK;
    private static String statesToRemoveList = BLANK;
    private static string subSegmentValue;
    private static final string COMMA = ',';
    private static final String CUSTOMPLAN = 'Creating a custom plan';
    private static final String CLONECUSTOMPLAN = 'Cloning a custom plan from existing CRD';
    private static final String HIXPLAN = 'Creating a HIX plan';
    private static final String CLONEHIXPLAN = 'Cloning a HIX plan from existing CRD';
    private static final String HIX = 'HIX';
    private static final String SG = 'SG';//Added By Nitish for 6939
    private static final String SGX = 'SGX';//Added By Nitish for 6939
    private static final String IVL = 'IVL';//Added By Nitish for 6939
    private static final String SMALLGROUP = 'Small Group';//Added By Nitish 6939
    private static final String INDIVIDUAL = 'Individual';//Added BY Nitish 6939
    private static final String OPTION1 = 'AETNA-PPO Public On HIX';
    private static final String OPTION2 = 'AETNA-HNO Public On HIX';
    private static final String CONSUMERPLAN = 'Creating a packaged consumer business plan';
    private static final String CLONECONSUMERPLAN = 'Cloning a packaged consumer business plan from an existing CRD';
    private static final string HRP = 'HRP';
    private static final string CONSUMEROPTION = 'CP IVL Public Exchange';
    private static final String CURRENTPAGE= 'currentPageName';
    private static final String HMO = 'HMO';
    private static final string NO = 'NO';
    private static final String H = 'H';
    private static final String T = 'T';
    private static final String PSP = 'Prescription Savings Program';
    private static final String SELFINSURED = 'Self Insured';
    private static final String FULLYINSURED = 'Fully Insured';
    private static final String SPLITFUNDED = 'Split Funded';
    private static final string SPLIT = ';';
    private static final String ASH = 'Aetna Student Health';
    private static final String N = 'N';
    private static final String Y = 'Y';
    private static final String NONRISK = 'Non-Risk';
    private static final String RISK = 'RISK';
    private static final String IL = 'IL';
    private static final String APPLIES = 'APPLIES';
    private static final String YES = 'YES';
    private static final String FIRSTSCREEN = '/apex/VF_CRDFirstScreen?id=';
    private static final String DOESNOTAPPLY = 'Does not Apply';
    private static final String SA = 'System Administrator';
    private static final String SAA = 'System Administrator Accenture';
    private static final String SAP = 'System Administrator Primary';
    private static final String IM = 'Implementation Manager';
    private static final String BCTC = 'BCT Consultant';
    private static final String BCTM = 'BCT Manager';
    private static final String BCTS = 'BCT Supervisor';
    private static final String BCTMG = 'BCT Management';
    private static final String SENDTOAI = 'Send to AI';
    private static final String ZERO = '0';
    private static final String LIKEMAIL = '%Mail%';
    private static final String CONSUMERBUSINESSPLAN = 'Creating a packaged consumer business plan';
    private static final String CLONECONSUMERBUSINESSPLAN = 'Cloning a packaged consumer business plan from an existing CRD';
    private static final String PACKAGEDPLAN = 'Creating a package plan';
    private static final String CLONEPACKAGEDPLAN = 'Cloning a package plan from existing CRD';
    private static final string EDITTRUE = 'BCTME';
    private static final string EDITFALSE = 'BCTNR';
    private static final string GRPMEMTRUE = 'RUME';
    private static final string GRPMEMFLASE = 'RUNR';
    private static final string NULLVAL = 'Null';
    private static final string YESLABEL = 'Yes';
    private static final string ERRORMSG = 'No PCG/FCG exists for this account, contact SFDC team';
    private static final string NOLABEL = 'No';
    private static final string NEXTPAGE = '/apex/VF_CRDCustomerCareAttributes_Step1?id=';
    private static final string EDITPAGE = '/apex/VF_NewCRDPlan_Step1?id=';
    private static final string PARAMEDITMODE ='p1';
    private static final string PARAMGRPMEMBER ='p2';
    private static final string Y4 = 'Y4';// Added By Nitish for 6936
    string networkRetailYSchedule{get;set;}
    public string userId{get;set;}
    public string PUBLICGROUP {get;set;}
   public string groupID{get;set;}
   public list<group> groupCheck{get;set;}
   public list<group> managementGroupCheck {get;set;}
   public string groupMember{get;set;}
   public string managementUser {get;set;}
   public string managementUserID {get;set;}
   public string managementgroupID {get;set;}
   public list<string> groupUserIds = new list<string>();
   public list<string> managementGroupUserIds = new list<string>(); 
    
         /*Added For Request 01280 */
    public static final List < Schema.PicklistEntry > PLANPLATEFORMPICKVALUES = CRD__c.Plan_Platform__c.getDescribe().getPicklistValues();
    public List <SelectOption> CareerValues{get;set;}
    public List <SelectOption> platformValues{get;set;}
    public List <SelectOption> OverrideRetail{get;set;}
     public List <SelectOption> OverrideRetail2{get;set;}
    public static final list < Schema.PickListEntry> PLATFORMPICKVALUES = crd__c.Which_system_will_the_plan_be_installed__c.getDescribe().getPickListValues();
    public static final list < Schema.PickListEntry> 
    SCHEDULE = crd__c.Override_Retail_Y_Schedule__c.getDescribe().getPickListValues();
    public list<Network_Junction__c> networkJunctionList = new list<Network_Junction__c>();
    public list<Pricing_Network__c> pricingNetworkCrosswalkList = new list<Pricing_Network__c>();
    public list<Pricing_Network__c> pncList = new list<Pricing_Network__c>();
    public Network_Junction__c networkJunction{get;set;}
    
           /*Change  For Request 01280 */
    public VFP_CRDPlanInformationStep1(ApexPages.StandardController controller) {
        setRequired = True;//Added By Nitih 6939
        updateCarrier = false;
        networkYSchedule = false;
        hideRetailYschedule = true;
        reRenderSubSeg = false;//addede by Nitish 6935
        makeWhatisSegmentEditable = true;//added by Nitish 6939
        makeWhatisSegmentReadOnly = false;//added by Nitish 6939
        changeYschtoY4 =  false;// Added By Nitish 6936
        PUBLICGROUP = System.Label.PublicGroupCRDEditMode;
        editMode = EDITFALSE;
        checkPublicGroup();
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;
        
        if(System.currentPagereference().getParameters().get(PARAMEDITMODE)==EDITTRUE) {
            editMode=EDITTRUE; }
        this.crd = (CRD__c) Controller.getRecord();
        if (controller.getId() != null) {
            this.crd = getCRDRecord(controller.getId());
            crd = [select Id,Non_Packaged_Plans__c, Sub_segment__c,predefined__c,Account__r.Predefined__c,Account__r.APM_PSUID__c,Account__r.name, Override_Retail_Y_Schedule__c,status__c, Retail_Y_Schedule_Override__c, StatesList_for_Mandate__c,Tiering_Formulary_Exception__c, //Modified by Ayushi for St#669
                          Benefits_State_List__c, Do_mandates_apply_to_all_states__c, List_Of_states_to_remove_the_plan__c,Medical_Injectible_Claim_Denial_Process__c,
                          Plan_Type_Paper_Out_of_Network__c, Partial_Control_Group__c,Brand_Penalty_Exception__c,Acquisition_Indicator__c,PERS_timestamp__c,
                          Partial_Control_Group__r.Name, Full_Control_Group__r.Name /*CRD_Pricing__r.Name*/,Global_Benefit_Exclusion__c,
                          name, PSP_Override_Option__c, PSU__c, Rx_Override_Option__c, Tiering__c, SAC_Override_Option__c,
                          /*CRD_Pricing__c,*/ Are_you_creating_a_Package_Plan__c, Platform_Information__c, RxPlanID__c,
                          Risk_Indicator__c, Plan_Type_Specialty__c, Plan_Type_Retail__c, Y_Schd__c, Plan_Type_Mail__c,Opt_out_of_Safety_Edits__c,
                          BPERxPlan_ID__c, RxPlan_ID_Status__c, Account_State__c, Custom_Ben_ID__c, Insured_Type__c,
                          Rx_PP_ID__c, Account__c, TP_ID__c, Vendor_Transition_Files__c, Pre_Implementation_Audit__c,
                          High_Value_Client__c, Include_Kit_Logic__c, National__c, Plan_Type_Paper__c, Integrate_with_Medical__c,
                          Plan_Platform__c, Plan_Description__c, Which_system_will_the_plan_be_installed__c, Subsegment__c,
                          Rating_ERB__c, Mail_Y_Schedule__c, Old_RxPlan_ID__c,Migration_Run_Number__c, /*RxPPID_NEW__c, Request no- 04888 by Nitish */
                          Full_Control_Group__c, Account__r.High_Priority_Comments__c, High_Priority_Comments__c, CRD_Risk_Indicator__c,
                          Effective_Start_Date__c, Full_Control_Group__r.CSAP_Plan_ID__c, Full_Control_Group__r.CSAP_Control_ID__c,
                          Full_Control_Group__r.CSAP_Suffix_ID__c,Full_Control_Group__r.Account_name__c, Full_Control_Group__r.CSAP_Account_ID__c,
                         /* FSA_Integration__c,*/Waive_Deductible_for_Tier_1_Drugs__c,Mac_at_Mail_Applies__c,
                          Client_Effective_Date__c,Contract_state__c,CA_50_Cost_Share_Applies__c,
                         Plan_Extract_Date__c,Does_3_Month_Grace_Period_Apply__c,Standard_or_Custom_Plan__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c,Plan_Type_Specialty_OON__c,
                          Standard_Fully_Insured_Pricing__c,CRD_Automated__c,Archived__c,OBOR_ORG_TYPE__c,ORG_NAME__c,ARRNG_NAME__c
                   from CRD__c
                   where Id = : this.crd.Id LIMIT 100000];
        }
        
        
        crdId = crd.id;
        string networkRetailValue;
        networkJunctionList = [select Id, CRD_ID__c, Does_client_have_suppression__c, Mail_Custom__c, Retail_Custom__c, Specialty_Custom__c, Network_Mail__c, Network_Retail__c, Network_Specialty__c, Enroll_in_Medvantix__c, Medvantix_Copay_Dollar_Amount__c from Network_Junction__c where CRD_ID__c = : crdId limit 1];
        pricingNetworkCrosswalkList = [select id,name,End_date__c,Network_Name__c,Start_Date__c,Y_Schedule__c,Sub_Segment__c,Medical_Platform__c from Pricing_Network__c LIMIT 80000];
        networkJunction = new Network_Junction__c();
        if (networkJunctionList.size() != 0)
            {
                networkJunction = networkJunctionList[0];
            }
            // Added plan type for story 6936- to override Y schdeule if Network Junction exist for all plans
        if(networkJunction.Network_Retail__c != null && (crd.Standard_or_Custom_Plan__c == CONSUMERPLAN || crd.Standard_or_Custom_Plan__c == CLONECONSUMERPLAN || crd.Standard_or_Custom_Plan__c == PACKAGEDPLAN || crd.Standard_or_Custom_Plan__c == CLONEPACKAGEDPLAN || crd.Standard_or_Custom_Plan__c == HIXPLAN || crd.Standard_or_Custom_Plan__c == CLONEHIXPLAN)){
            networkRetailValue = string.valueof(networkJunction.Network_Retail__c);
            for(Pricing_Network__c pnc : pricingNetworkCrosswalkList){
                if(pnc.Network_Name__c == networkRetailValue && crd.sub_segment__c == pnc.Sub_Segment__c && crd.Which_system_will_the_plan_be_installed__c == pnc.Medical_Platform__c){
                    pncList.add(pnc);
                }
            }
            
            if(pncList.size() > 0){
                networkYSchedule = true;
                networkRetailYSchedule = pncList[0].Y_Schedule__c;
            }
            else{
                networkRetailYSchedule = Y4;
            }
            
        }
        
        //crd.predefined__C = crd.Account__r.Predefined__c; // Added by Nitish ST#669
        /*if(crd.Account__c!=null && crd.Account__r.Predefined__c){ //Added by Ayushi for 669
          PredefinedFlag=True;
        }else{
          PredefinedFlag=False; 
        }   */
        rxPlanId = String.ValueOf(crd.RxPlanID__c);
        migrationNo = string.valueOf(crd.Migration_Run_Number__c);
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        benefitStateList = crd.Benefits_State_List__c;
        statesToRemoveList = crd.List_Of_states_to_remove_the_plan__c;
        errorMessages = new list < String > (); 
     platformValues = new List<SelectOption>();
        for(Schema.Picklistentry p : PLATFORMPICKVALUES){
            if(crd.Standard_or_Custom_Plan__c!= CONSUMERPLAN || crd.Standard_or_Custom_Plan__c != CLONECONSUMERPLAN){
            if(p.getValue().contains(HRP) || p.getValue()  == HRP ){
                                //Skip These as we dont have to show them
            }else{ 
            platformValues.add(new Selectoption(p.getValue(),p.getLabel()));
            }
            }
        }
 
            if(crd.Standard_or_Custom_Plan__c==CONSUMERPLAN || crd.Standard_or_Custom_Plan__c==CLONECONSUMERPLAN){            
                        platformValues.add(new Selectoption(HRP,HRP));
                        

                 }
       
        /*Added For Request 06127 */
        OverrideRetail2 = new List<SelectOption>();
        if(crd.Standard_or_Custom_Plan__c==PACKAGEDPLAN || crd.Standard_or_Custom_Plan__c==CLONEPACKAGEDPLAN || crd.Standard_or_Custom_Plan__c==HIXPLAN  || crd.Standard_or_Custom_Plan__c== CLONEHIXPLAN ||crd.Standard_or_Custom_Plan__c==CONSUMERBUSINESSPLAN || crd.Standard_or_Custom_Plan__c==CLONECONSUMERBUSINESSPLAN ){
            OverrideRetail2.add(new Selectoption(YESLABEL,YESLABEL));
            OverrideRetail2.add(new Selectoption(NOLABEL,NOLABEL));
            if(crd.Override_Retail_Y_Schedule__c == null || BLANK.equalsIgnoreCase(crd.Override_Retail_Y_Schedule__c)){
            crd.Override_Retail_Y_Schedule__c = NOLABEL;
            }
        }
        /*END Story 06127*/
        /*Added For Request 01280 */
        CareerValues = new List <SelectOption> ();
        for (Schema.PicklistEntry pv: PLANPLATEFORMPICKVALUES){
            
                 if(crd.Standard_or_Custom_Plan__c!=HIXPLAN || crd.Standard_or_Custom_Plan__c!=CLONEHIXPLAN){
                        if(pv.getValue().contains(HIX) || pv.getValue()  == CONSUMEROPTION){
                                //Skip These as we dont have to show them
                        } else{
                                CareerValues.add(new Selectoption(pv.getValue(), pv.getLabel()));
                        }
                        
                 }
                }
                 if(crd.Standard_or_Custom_Plan__c==HIXPLAN || crd.Standard_or_Custom_Plan__c==CLONEHIXPLAN){            
                         CareerValues.add(new Selectoption(OPTION1,OPTION1));
                         CareerValues.add(new Selectoption(OPTION2,OPTION2));
                 }
                 /*Change For Request 01280 ends */
                 
                 /*Added For Request 05931 */
                 if(crd.Standard_or_Custom_Plan__c==CONSUMERPLAN || crd.Standard_or_Custom_Plan__c==CLONECONSUMERPLAN){            
                         CareerValues.add(new Selectoption(CONSUMEROPTION,CONSUMEROPTION));
                         
                 }
                 /*Change For Request 05931 ends */
                 
            //string[] carrierList = new string[]{};
         
//public string[] getcarrierList(){
//return carrierList;                
  //      } 
        if (crd.Insured_Type__c != NULL && crd.National__c != NULL && crd.Plan_Platform__c != NULL) {
            fundingTypeCriteria = true;
        } else {
            fundingTypeCriteria = false;
        }
        showDrugList();
        updateKitLogic();
        if(crd.Medical_Injectible_Claim_Denial_Process__c == NULL || crd.Medical_Injectible_Claim_Denial_Process__c == ''){
            crd.Medical_Injectible_Claim_Denial_Process__c = 'Applies';
        }
        if(crd.Integrate_with_Medical__c != null){//Richa added for Req - 5003
            populateMAC();
        }
        // added by Sushant : Request 05476 **Start**
        if (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL)
        {
            if(crd.Standard_or_Custom_Plan__c != null && (crd.Standard_or_Custom_Plan__c == CUSTOMPLAN || crd.Standard_or_Custom_Plan__c == CLONECUSTOMPLAN))
            {
                showPERSTimestamp = true;
            }
            
        } // **End**
        
        //Added By Nitish Request 6939
        if(string.isNotEmpty(crd.sub_segment__c) &&(crd.sub_segment__c.equalsIgnoreCase(SG) || crd.sub_segment__c.equalsIgnoreCase(SGX) || crd.sub_segment__c.equalsIgnoreCase(IVL) || crd.sub_Segment__c.equalsIgnoreCase(HIX))){
            makeWhatisSegmentEditable = False;
            makeWhatisSegmentReadOnly = TRUE;
        }
        
    }
    
   /* ST 669 : Method to find the PCG and FCG of the Predefined Account associated with the CRD*/
   public void predefAccountPCGFCG (){
       try{
       FCGpredefined = [Select Id,name from Full_Control_Group__c where CAG_Account_ID__c=: AccountonScreen.APM_PSUID__c LIMIT 1];
       PCGpredefined = [Select Id,name from Partial_Control_Group__c where PSUnique_ID__c=: AccountonScreen.APM_PSUID__c LIMIT 1];
       crd.Predefined__c = AccountonScreen.Predefined__c;// Added by nitish ST#669
       if(FCGpredefined.size()>0 && PCGpredefined.size()>0) {
              crd.Full_Control_Group__c= FCGpredefined[0].id;
              crd.Partial_Control_Group__c = PCGpredefined[0].id;
              FCGpredefinedName = FCGpredefined[0].name;
              PCGpredefinedName = PCGpredefined[0].name;
              ispcgfcgerror = false;
        } else if(FCGpredefined.size()>0 && PCGpredefined.size()<=0) {
              crd.Full_Control_Group__c= FCGpredefined[0].id;
              FCGpredefinedName = FCGpredefined[0].name;
              PCGpredefinedName = null;
              ispcgfcgerror = true;  
            } else if(FCGpredefined.size()<=0 && PCGpredefined.size()>0) {
              crd.Partial_Control_Group__c = PCGpredefined[0].id;
              FCGpredefinedName = null;
              PCGpredefinedName = PCGpredefined[0].name;
              ispcgfcgerror = true;  
            } else {
              FCGpredefinedName = null;
              PCGpredefinedName = null;
              ispcgfcgerror = true;
            }
   }catch(exception e){
       ApexPages.addMessages(e);
   }
   }
    
   /* Method to execute the steps when the user clicks on 'Save and Next' button on the screen*/    
        Public PageReference redirectToStep2() {
    updataePredefined();
        errorMessages.clear();
        try {
        if (editMode==EDITTRUE)
        {
    /*Commented BY Nitish for Request 06127
            //Pattern ySchedule = Pattern.Compile('[C][0-9][0-9]');
            if(crd.Standard_or_Custom_Plan__c != NULL && (crd.Standard_or_Custom_Plan__c == CONSUMERPLAN || crd.Standard_or_Custom_Plan__c == CLONECONSUMERPLAN)){
                if(!Pattern.matches('[A-Z][0-9][0-9]',string.valueof(crd.Retail_Y_Schedule_Override__c))){
                    errorMessages.add(System.label.ERR00299);
                    return null; 
                }
            }*/
        //Added As part of Request number 5361 - Starts
        // Remove AGB/BR Validation Rule
        /* if(crd.Plan_Platform__c == AGBNAME){
                if(crd.Contract_State__c != BRSTATE){
                    errorMessages.add(System.label.err0289);
                    return null;            
                }
        }// Commented for request 06293 - ST 637 */
        /* else{
            if(crd.Contract_State__c == BRSTATE){
                errorMessages.add(System.label.err0290);
                return null;            
            }           
        } */
    
        /*Added by Ayushi for ST#669 starts*/
        
            if(AccountonScreen!=null && AccountonScreen.Predefined__c==True && !(crd.CRD_Automated__c))
            {
              predefAccountPCGFCG();
              if(ispcgfcgerror) {
                  errorMessages.add(ERRORMSG);
                  return null;
              }
            
            } 
            
        /*Added by Ayushi for ST#669 ends*/     
            //added by Sushant Request 05965
        if(crd.Standard_or_Custom_Plan__c != NULL && (CONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONECONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && (crd.Override_Retail_Y_Schedule__c != NULL && YES.equalsIgnoreCase(crd.Override_Retail_Y_Schedule__c))){
            if(crd.Retail_Y_Schedule_Override__c == NULL){
                errorMessages.add(System.label.ERR00298);
                    return null;
            }
        }
            //Added As part of Request number 5361 - ends   

            manageHmoFields();
           // if(crd.Override_Retail_Y_Schedule__c == NULL || crd.Override_Retail_Y_Schedule__c == ''){crd.Override_Retail_Y_Schedule__c = 'No';}
            // added by Sushant : Request 05476 **Start**
            if((crd.Which_system_will_the_plan_be_installed__c != TRADITIONAL) || (crd.Standard_or_Custom_Plan__c != CUSTOMPLAN && crd.Standard_or_Custom_Plan__c != CLONECUSTOMPLAN) ){
                crd.PERS_timestamp__c = null;
                }            // **End**
             //added by Sushant : Request 05930 **Start**
            if((crd.Standard_or_Custom_Plan__c != NULL && crd.Standard_or_Custom_Plan__c != CONSUMERPLAN && crd.Standard_or_Custom_Plan__c != CLONECONSUMERPLAN) && (crd.Which_system_will_the_plan_be_installed__c == HRP)){
                errorMessages.add(System.Label.ERR00296);
                return null;
            }
            //**End**      
            GC_Validation_Methods validatioClass = new GC_Validation_Methods();
            boolean isValid;
            
           
             // modified by JR to implement request no 4675
             if (crd.Plan_Type_Specialty_OON__c == true && crd.Plan_Type_Paper_Out_of_Network__c==false) {
                errorMessages.add(System.Label.ERR0244);
                return null;
            }else if (isElementCommon(crd.Benefits_State_List__c, crd.List_Of_states_to_remove_the_plan__c) && crd.Plan_Platform__c == HMO) {
                errorMessages.add(System.Label.ERR00136);
                return null;
            } else {
                /* rakesh - 5/8 - Req.00483 bug - Platform Information was not calculated on next and back buttons, so adding them here */
                if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                    crd.Platform_Information__c = H;
                } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                    crd.Platform_Information__c = T;
                } else {
                    crd.Platform_Information__c = BLANK;
                }
                /* rakesh - 5/8 - end */

                //crd.of_months_for_Copay_Waiver__c = 6;
                if (crd.Insured_Type__c == SELFINSURED) {
                    List < Clinical_Program_Group_Junction__c > deletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name from Clinical_Program_Group_Junction__c
                    where CRD_ID__c = : crdid and Record_Type__c =: PSP LIMIT 100000]);
                    if (deletePSPGroup.size() != 0) {
                        database.delete(deletePSPGroup);
                    }
                    //crd.SAC_Override_Option__c = null;
                    crd.PSP_Override_Option__c = null;
                }

                if (crd.Plan_Platform__c == ASH && crd.Plan_Platform__c == AGB) {
                    crd.Do_Prescription_Savings_Program__c = Null;
                    crd.PSP_Letter_Templates__c = Null;
                    crd.PSP_Override_Option__c = null;
                    List < PSP_Junction__c > deletePSPList = new List < PSP_Junction__c > ([Select Id, Prescription_Savings_Program_Drug_Class__c, Selected__c from PSP_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                    List < Clinical_Program_Group_Junction__c > deletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name from Clinical_Program_Group_Junction__c
                    where CRD_ID__c = : crdid and Record_Type__c =: PSP LIMIT 100000]);
                    if (deletePSPList.size() != 0) {
                        database.delete(deletePSPList);
                    }
                    if (deletePSPGroup.size() != 0) {
                        database.delete(deletePSPGroup);
                    }
                }
                
                crd.High_Priority_Comments__c = crd.Account__r.High_Priority_Comments__c;
                
                if (crd.Which_system_will_the_plan_be_installed__c == HMO && crd.Do_mandates_apply_to_all_states__c == N && crd.Benefits_State_List__c == null) {
                    errorMessages.add(system.label.ERR00180);
                    return null;
                }
                
                if (crd.Which_system_will_the_plan_be_installed__c == HMO && crd.Do_mandates_apply_to_all_states__c == Y && crd.Benefits_State_List__c != null) {
                    errorMessages.add(system.label.ERR00181);
                    return null;
                }
                
                if (crd.Insured_Type__c == SELFINSURED && crd.CRD_Risk_Indicator__c == NULL) {
                    crd.CRD_Risk_Indicator__c = NONRISK;
                } else if ((crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) && crd.CRD_Risk_Indicator__c == NULL) {
                    crd.CRD_Risk_Indicator__c = RISK;
        } else { //Do Nothing    
                }
                Boolean hasError = false; 
                Boolean isAccountMapped = True;           // Flag to indicate any error
                 if(!validatioClass.matchAccount(crd)){
                     isAccountMapped =false;
                errormessages.add(system.label.ERR00198);
        }
                 else { //Do Nothing
                 }
                /* rakesh - 4/16 - Req 00483 - Validations
                 *  1. All HMO Plans should have the Medical Platform of HMO
                 *  2. All Custom Plans require an FCG
                 */
                if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Which_system_will_the_plan_be_installed__c == null) {
                    errorMessages.add(system.label.ERR00196);
                    hasError = true;
                }               

                if (hasError || isAccountMapped == FALSE ){ return null;}
                
                
                overrideSubSegmentValue();
                
                List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);
                if (yScheduleList != null) {
                    if(!networkYSchedule){
                    crd.Y_Schd__c = yScheduleList[0];
                    crd.Pricing_Schedule__c = yScheduleList[0];
                }else if(crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c.equalsIgnoreCase(NO) && networkRetailYSchedule != NULL){ 
                    crd.y_schd__c = networkRetailYSchedule;
                    crd.Pricing_Schedule__c = networkRetailYSchedule;
                }
                    crd.Mail_Y_Schedule__c = yScheduleList[1];
                }
                
                overideYscheduleValues();
                //Added by Amit Jain on 8/23/2013 for request 01128
               /* if(crd.Chronic_and_or_Preventive_List__c == 'Chronic'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT17;
                }else if(crd.Chronic_and_or_Preventive_List__c == 'Preventive'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT19;
                }else if(crd.Chronic_and_or_Preventive_List__c == 'Both'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT18;
                }else  if(crd.Chronic_and_or_Preventive_List__c == null || crd.Chronic_and_or_Preventive_List__c=='Not Applicable'){
                    crd.Chronic_Preventive_Drug_List__c = null;
                }*/
                /////End/////
                //Added By Sushant for request 01261//
                // commented by JR
              /*  if((crd.Waive_Deductible_for_Tier_1_Drugs__c == 'Yes – Waive In Network and Out of Network' || crd.Waive_Deductible_for_Tier_1_Drugs__c == 'Yes – Waive In Network' || crd.Waive_Deductible_for_Tier_1_Drugs__c == 'Yes - Waive Out of Network') &&
                      crd.Integrate_with_Medical__c == 'No'){
                          errorMessages.add(system.label.ERR0234); 
                          return null;   
                }*/
                if(crd.Plan_Type_Paper__c != NULL && crd.Plan_Type_Paper__c == TRUE){
                        crd.Bypass_DMR__c = 15;
                   }else{
                            crd.Bypass_DMR__c = NULL;
                         } 
                //End//   
                // added by Sushant : Request 05476 **Start**
                if ((crd.Standard_or_Custom_Plan__c  != null && (crd.Standard_or_Custom_Plan__c == CUSTOMPLAN || crd.Standard_or_Custom_Plan__c == CLONECUSTOMPLAN)) && (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL) && (crd.PERS_timestamp__c == null) && (crd.CRD_Automated__c != TRUE) ) {
                errorMessages.add(System.Label.ERR00254);
                return null;
                }   // **End**
                 // Added by Sushant for request 01159// Start*  Modified by JR to implement request 4601
                 /*Commented as per request 06664 : 146052:ST#1459-Remove 50% logic from IL HMO OON*/
                     /*if(crd.Plan_Type_Paper_Out_of_Network__c && crd.Contract_State__c == IL && (crd.Insured_Type__c != NULL && (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) && crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c != APPLIES )){
                        errorMessages.add(system.label.ERR00232);
                        return null;
                        }*/                 
                      // *End 
                        //Richa added on 25/07 for Req 4925 
                     if((crd.Acquisition_Indicator__c == YES)||(crd.Acquisition_Indicator__c == NO)){ //Modified for ST#1170 (PMO# 06489)
                        crd.Opt_out_of_Rx_OTC_Edit__c = False;    //Modified for ST#1170 (PMO# 06489)
                      } 

                //Added by JR on 04/02/2015 to implement request no 5431 : added the field in the query above               
                if((CLONECUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && crd.Which_system_will_the_plan_be_installed__c!=null && medicalPlatform.equalsIgnoreCase(crd.Which_system_will_the_plan_be_installed__c)){
                    crd.Non_Packaged_Plans__c = true;
                }
                database.update(crd);
            }
        
        }       
        } catch (exception e) {
           //errorMessages.add(system.Label.ERR00053);//Richa commented this line and
            //errorMessages.add(e.getmessage());//commented this line on 13/6/2014 since VR_CRDPlanOptionCheck was throwing exception
            //throw e;
            ApexPages.addMessages(e);//added this line
            return null;
        }
        Pagereference pageRef = new Pagereference(NEXTPAGE + crd.Id); 
        pageRef.getParameters().put(PARAMEDITMODE,editMode);
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
        list<crd__c> debugcrd = new list<crd__c>();
        debugcrd = [Select Name,Ostomy_Supplies__c,Other_Insurance_Paid_in_Error__c,National__c,Manual_Pharmacy_Payments__c,Erisa_Client__c,Plan_Coordinate_Benefits__c,Default_NABP__c,Administration_of_External_COB__c,Veterans_Admin__c,Allergy_Serums__c,Clinic_Physician_Reimbursement__c,Nursing_Home_Claims__c,Medicaid__c,Foreign_Claims__c,Claims_Acceptable_w_o_receipts__c,Compound_Code_2__c,Claims_payable_with_Pharm_Signature__c,Indian_Facilities__c,RTMD_Modulator_Percent__c,Specialty_Exclusion_Flag__c,RTMD_Admin_Fee_basis__c,RTMD_Admin_Fee_rate__c,In_Network__c,RDS__c,Are_Emergency_Claims_Reimbursed__c,Emergency_Discount_Rate__c,Are_Hemo_Claims_Reimbursed__c,Hemo_Discount_Rate__c,Out_of_Network_Reimbursement_Level__c,In_Network_Reimbursement_Level__c,Out_of_Network__c,Does_the_client_want_to_do_COB__c, Process_Point_of_Sales_COB__c,Reimbursement_Levels__c,COB_or_MOB__c,Integrate_with_Medical__c, POS_Rebate_for_Plan__c,In_Network_claims_are_reimbursed__c,Prorate__c,No_of_Days_to_file_a_claim__c,Offshore__c,Bypass_DMR__c,Retail_Source_AWP__c,In_Network_Discount_Rate__c,Out_of_Network_Discount_Rate__c,Out_of_Network_claims_are_reimbused__c,RTMD_Effective_Date__c,RTMD_Client_Share_Percent__c,Are_you_creating_a_Package_Plan__c, Insured_Type__c, RxPlan_ID_Status__c, Toll_Free_Number__c, Plan_Type_Paper__c, Vacation__c, Participant_Lost_Stolen_Damaged_Meds__c, Mail_Order_Delay__c, Maximum_Dollar__c, Dosage_Increase_Change__c, Multiple_Births__c, Retail_refill_for_Manufacture_Back_Order__c, Dose_Optimization__c, Duplicate_Therapy__c, Incorrect_Days_Supply__c, Annual_Fill_Limit_Allowed_Limit__c, Nursing_Home__c, Specialty_Retail_Lock_Out__c, Expatriate_Employees__c, Participant_Mail_In_Delay__c, Disaster_Emergency__c, Transition_Plan_1_x_override_30DS__c, MDL_or_QVT_Limit_Exceptions__c, Y_Schd__c From CRD__c Where ID = : this.crd.id LIMIT 1];
        return pageRef;
    }
    
    /* Added by Ayushi for Next button Story */
    Public PageReference redirectToStep3() {
        try {
        Pagereference pageRef = new Pagereference(NEXTPAGE + crd.Id); 
        pageRef.getParameters().put(PARAMEDITMODE,editMode);
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
        return pageRef;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    /* Added for the Edit button on the screen */
    public pageReference editButton(){
        try{
        editMode = EDITTRUE;
        Pagereference pageRef = new Pagereference(EDITPAGE + crd.Id); 
        pageRef.getParameters().put(PARAMEDITMODE,editMode);
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
        return pageRef; 
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    /* Method for the Back button functionality */
    Public PageReference redirectToStep0() {
        errorMessages.clear();
        try {
            //added by Sushant Request:05965
            if(crd.Standard_or_Custom_Plan__c != NULL && (CONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONECONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && (crd.Override_Retail_Y_Schedule__c != NULL && YES.equalsIgnoreCase(crd.Override_Retail_Y_Schedule__c))){
            if(crd.Retail_Y_Schedule_Override__c == NULL){
                errorMessages.add(System.label.ERR00298);
                    return null;
            }
        }
            manageHmoFields();
            GC_Validation_Methods validatioClass = new GC_Validation_Methods();
            boolean isValid;
            // added by Sushant : Request 05476 **Start**
            if((crd.Which_system_will_the_plan_be_installed__c != TRADITIONAL) || (crd.Standard_or_Custom_Plan__c != CUSTOMPLAN && crd.Standard_or_Custom_Plan__c != CLONECUSTOMPLAN) ){
                crd.PERS_timestamp__c = null; 
                }            // **End**
                //added by Sushant : Request 05930 **Start**
            if((crd.Standard_or_Custom_Plan__c != NULL && crd.Standard_or_Custom_Plan__c != CONSUMERPLAN && crd.Standard_or_Custom_Plan__c != CLONECONSUMERPLAN) && (crd.Which_system_will_the_plan_be_installed__c == HRP)){
                errorMessages.add(System.Label.ERR00296);
                return null;
            }
            //**End**
            if (isElementCommon(crd.Benefits_State_List__c, crd.List_Of_states_to_remove_the_plan__c) && crd.Plan_Platform__c == HMO) {
                errorMessages.add(System.Label.ERR00136);
                return null;
            } else {
                /* rakesh - 5/8 - Req.00483 bug - Platform Information was not calculated on next and back buttons, so adding them here */
                if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                    crd.Platform_Information__c = H;
                } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                    crd.Platform_Information__c = T;
                } else {
                    crd.Platform_Information__c = BLANK;
                }
                /* rakesh - 5/8 - end */

                //crd.of_months_for_Copay_Waiver__c = 6;
                if (crd.Insured_Type__c == SELFINSURED) {
                    List < Clinical_Program_Group_Junction__c > deletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name from Clinical_Program_Group_Junction__c
                    where CRD_ID__c = : crdid and Record_Type__c =: PSP LIMIT 100000]);
                    if (deletePSPGroup.size() != 0) {
                        database.delete(deletePSPGroup);
                    }

                    //crd.SAC_Override_Option__c = null;
                    crd.PSP_Override_Option__c = null;
                }
                if (crd.Plan_Platform__c == ASH && crd.Plan_Platform__c == AGB) {
                    crd.Do_Prescription_Savings_Program__c = Null;
                    crd.PSP_Letter_Templates__c = Null;
                    crd.PSP_Override_Option__c = null;
                    List < PSP_Junction__c > deletePSPList = new List < PSP_Junction__c > ([Select Id, Prescription_Savings_Program_Drug_Class__c, Selected__c from PSP_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                    List < Clinical_Program_Group_Junction__c > deletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name from Clinical_Program_Group_Junction__c
                    where CRD_ID__c = : crdid and Record_Type__c =: PSP LIMIT 100000]);
                    if (deletePSPList.size() != 0) {
                        database.delete(deletePSPList);
                    }
                    if (deletePSPGroup.size() != 0) {
                        database.delete(deletePSPGroup);
                    }
                   }
               
                         
                /* rakesh - 4/16 - Req 00483 - Validations
                 *  1. All HMO Plans should have the Medical Platform of HMO
                 *  2. All Custom Plans require an FCG
                 */
                 
                 Boolean hasError = false;            // Flag to indicate any error
                Full_Control_Group__c objFCG;        // Instantiation of FCG type object
                if(crd.Full_Control_Group__c != NULL)
                {
                    objFCG=[Select Id,Account_Name__c from Full_Control_Group__c where Id=: crd.Full_Control_group__c LIMIT 100000];
                    if(objFCG!=null)
                    {
                        if (crd.account__c != objFCG.Account_name__c)
                        {
                         errormessages.add(system.label.ERR00198);
                         hasError = true;
                        } 
                    }
                }
                // Boolean hasError = false;
                if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Which_system_will_the_plan_be_installed__c == null) {
                    errorMessages.add(system.label.ERR00196);
                    hasError = true;
                }

                if (hasError){
                 return null; 
                }
                //Mofified by Amit Jain on 8/23/2013 for request 01128
              /*  if(crd.Chronic_and_or_Preventive_List__c == 'Chronic'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT17;
                }
                if(crd.Chronic_and_or_Preventive_List__c == 'Preventive'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT19;
                }
                if(crd.Chronic_and_or_Preventive_List__c == 'Both'){
                    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT18;
                }  
                if(crd.Chronic_and_or_Preventive_List__c==null || crd.Chronic_and_or_Preventive_List__c=='Not Applicable'){
                 crd.Chronic_Preventive_Drug_List__c=null;
                }  */
                // added by Sushant : Request 05476 **Start**
                if ((crd.Standard_or_Custom_Plan__c  != null && (crd.Standard_or_Custom_Plan__c == CUSTOMPLAN || crd.Standard_or_Custom_Plan__c == CLONECUSTOMPLAN)) && (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL) && (crd.PERS_timestamp__c == null) && (crd.CRD_Automated__c != TRUE) ) {
                errorMessages.add(System.Label.ERR00254);
                return null;
                } // **End**
                 // Added by Sushant for request 01159// Start*
                 /*Commented as per request 06664 : 146052:ST#1459-Remove 50% logic from IL HMO OON */  
                 /*if(crd.Contract_State__c == IL && (crd.Insured_Type__c != NULL && (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) && crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c != APPLIES )){
                    errorMessages.add(system.label.ERR00232);
                    return null;
                    }*/                 
                  // *End                 update crd;
                Pagereference pageRef = new Pagereference(FIRSTSCREEN + crd.Id);
                pageRef.getParameters().put(PARAMEDITMODE,editMode);
                pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
                return pageRef;
                /////End/////
            }
        } catch (exception e) {
            errorMessages.add(system.Label.ERR00053);
            return null;
        }
    }

    /* Method to return the CRD record */
    public static CRD__c getCRDRecord(String crdId) {
        try{
        for (crd__c crd: [Select c.Sub_segment__c, c.BPERxPlan_ID__c, c.RxPlan_ID_Status__c, c.Include_Kit_Logic__c, c.TP_ID__c, c.Rx_PP_ID__c, c.RxPlanID__c, c.Plan_Type_Specialty__c, c.Plan_Type_Specialty_OON__c,c.Plan_Type_Retail__c, c.Plan_Type_Paper__c, c.Plan_Type_Mail__c, c.Plan_Platform__c, c.National__c, c.Name, c.Integrate_with_Medical__c, c.Insured_Type__c, c.Id, c.Bridge_Supply__c, c.Allergy_Serums__c, c.Administration_of_External_COB__c, c.Account__c, c.Account_Manager__c, c.Custom_Ben_ID__c, c.Vendor_Transition_Files__c, c.Pre_Implementation_Audit__c, c.High_Value_Client__c
        From CRD__c c Where c.ID = : crdId LIMIT 100000]) {
            return crd;
        }
        return new CRD__c();
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    /* Method for Override Y schedule logic */
    public void overrideYschedule() {
        try{
            if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == 'No') {
                crd.Retail_Y_Schedule_Override__c = '';
                setRequired = True;
                changeYschtoY4 = True;
            }
            
            if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == 'Yes') {
                crd.Retail_Y_Schedule_Override__c = ''; 
                setRequired = true;// Added by Nitish 6939
                crd.sub_Segment__c = '';//Added By Nitish 6935
                makeWhatisSegmentEditable = true;
                makeWhatisSegmentReadOnly = false; 
            }
            
           
                
        } catch (exception e) {
            ApexPages.addMessages(e);
        }
    }
    /* Method to override values provided by user*/
    public void overideYscheduleValues() {
        try{
        if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == YES) {
            //Removed a logic to stop update of Retail Y Schedule for Story 6936
            crd.Y_Schd__c = crd.Retail_Y_Schedule_Override__c;
            crd.Pricing_Schedule__c = crd.Retail_Y_Schedule_Override__c;
            
        } else {//Do Nothing
        }
        DATABASE.update(crd);
        } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
    /*method to override values provided by user */
    public void overrideSubSegmentValue() {
        try{
        if (crd.Sub_segment__c != null) {
            subSegmentValue = crd.Sub_segment__c;
        } else {
            subSegmentValue = crd.Subsegment__c;
        }
        } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
    
    /* Method to set the updateCarrier flag */
    Public void updateCrd() {
        try{
        updateCarrier = true;
    }catch(exception e){
        ApexPages.addMessages(e);
    }
    }
    
     /* Added by JR to implement request 4601 */
    Public void updateOONPaperNw(){
            try{
           // if(crd.Plan_Type_Paper_Out_of_Network__c){
                showOONCostShare = true;
               /* Commented by Vatsal for ST 1716 - Start
               if(crd.Contract_State__c == IL && (crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED)){
                    //Commented as per request 06664 : 146052:ST#1459-Remove 50% logic from IL HMO OON
                    //crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = APPLIES; 
                    //Added as per request  06664 to make  DOESNOTAPPLY as default value
                 //   crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
                }else if(crd.Insured_Type__c == SELFINSURED){                                    //Added by Vatsal as per ST 1716 - Starts
                    //Added as per ST 1716 to make BLANK as default value
                    crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;                      //Added by Vatsal as per ST 1716 - Ends
                }else{
                    showOONCostShare = false;
                    //Added as per request  06664 to make  DOESNOTAPPLY as default value
                    crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
                }
            }else if(crd.Plan_Type_Paper_Out_of_Network__c ==false){
                showOONCostShare = false;
                crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
            }else{ //Do Nothing
                //Added as per request  06664 to make  DOESNOTAPPLY as default value
                //crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
            }
       Commented by Vatsal for ST 1716 */
       } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
   
   /*Added By Nitish ST#669 */   
   public void updataePredefined(){
   try{
   if(crd.Account__c != null && !(crd.CRD_Automated__c))
   {
      Account acc =[select id,predefined__c from Account where id=:crd.Account__c LIMIT 1];
       crd.predefined__c = acc.predefined__c;// Added By Nitish ST#669
   }
   } catch (exception e) {
            ApexPages.addMessages(e);

   }
  }
       
    /* Method to make updates when the CRD Account is changed */ 
    Public void updateKitLogic() {
        try{
        updataePredefined();
        showGracePrd = false;
        //showOONCostShare = false;   
        PredefinedFlag = False;   
        if(crd.Account__c!=null && !(crd.CRD_Automated__c)) { //Added by Ayushi fo ST#669
            AccountonScreen=[select id,predefined__c,name,APM_PSUID__c from Account where id=:crd.Account__c LIMIT 1];  
            if(AccountonScreen.Predefined__c ) {
              PredefinedFlag = True;
          } else{
              PredefinedFlag = False; 
              FCGpredefined =null;
              PCGpredefined =null;
              }
        } else{
              PredefinedFlag = False;
              FCGpredefined =null;
              PCGpredefined =null;}
        if (crd.Plan_Platform__c != HMO) {
            crd.Do_mandates_apply_to_all_states__c = null;
            crd.StatesList_for_Mandate__c = null;
        } else{ //Do Nothing
        }
        /* Rakesh - 3/21 - Request 00934 - update CRD Risk Indicator value based on Funding type*/
        if (crd.Insured_Type__c == FULLYINSURED || crd.Insured_Type__c == SPLITFUNDED) {
            crd.CRD_Risk_Indicator__c = RISK; }
        else if (crd.Insured_Type__c == SELFINSURED) {
            crd.CRD_Risk_Indicator__c = NONRISK; }
           else { //Do Nothing
              }  
         if (((crd.Standard_or_Custom_Plan__c == HIXPLAN) || (crd.Standard_or_Custom_Plan__c == CLONEHIXPLAN)) && ((crd.National__c ==INDIVIDUAL) || (crd.National__c ==SMALLGROUP)))
         {
               showGracePrd = true;
         }
         //Added by JR to implement request 4601
         /* Commented by Vatsal for ST 1716  
            if(crd.Contract_State__c == IL && (crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED)){
                showOONCostShare = true;
              }
          //else if(crd.Insured_Type__c == SELFINSURED){                //Added by Vatsal for ST 1716
            //        showOONCostShare = true;                           //Added by Vatsal for ST 1716
          //}
          else{
          showOONCostShare = false;
          }*/
          // added by ayushi 
          if(AccountonScreen!=null && AccountonScreen.Predefined__c==True && !(crd.CRD_Automated__c))
            {
              predefAccountPCGFCG();
             } 
         
            
         // added by JR to implement 4601
          updateOONPaperNw();          
         /*if(crd.Contract_State__c == IL && (crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED)){
          if(crd.Plan_Type_Paper_Out_of_Network__c){                        added by Richa for Request 4601
          crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = APPLIES;
          }
          else{
          crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = null;
          }showOONCostShare = true;
          }else{
          if(crd.Plan_Type_Paper_Out_of_Network__c){
          crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = DOESNOTAPPLY;
          }
          else{
          crd.OON_Cost_Share_Not_Greater_50_Drug_Cost__c = null;
          }
          }  */  
          } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
    /* Method to identify the profile of the user */
    Public boolean getCRDPricing() {
        try{
        boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId() LIMIT 100000].Profile.Name;
        if (usrProfileName == SA) {
            check = true;
        } else if (usrProfileName == SAA) {
            check = true;
        } else if (usrProfileName == SAP) {
            check = true;
        } else if (usrProfileName == IM) {
            check = true;
        } else {
            check = false;
        }
        return check;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }

    /* Method to check if the profile of the user id BCT Consultant*/
    Public boolean getHideForBCTC() {
        try{
        boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId() LIMIT 100000].Profile.Name;
        if (usrProfileName == BCTC) {
            check = false;
        } else {
            check = true;
        }
        return check;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    /* Method to find if the current user's is a BCT user*/
    Public boolean getCrdPartialGroup() {
        try{
        boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId() LIMIT 100000].Profile.Name;
        if (usrProfileName == BCTM) {
            check = true;
        } else if (usrProfileName == BCTC) {
            check = true;
        } else if (usrProfileName == BCTS) {           
            check=true;            
        } else if (usrProfileName == BCTMG) {
            check = true;
        } else {
            check = false;
        }
        return check;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    /*Method for checking Y schedule override */
    Public list < Y_Schedule_Pricing_Override__c > checkOverride(String GControl, String PlatformInformation) {
        try{
        List < Y_Schedule_Pricing_Override__c > overridesList = new List < Y_Schedule_Pricing_Override__c > ([Select Id, Control_Group__c, Platform_Indicator__c, Price_Schedule__c FROM Y_Schedule_Pricing_Override__c
        WHERE Control_Group__c = : GControl AND Platform_Indicator__c = : PlatformInformation LIMIT 100000]);
        if (overridesList != NULL && overridesList.size() > 0) {
            return overridesList;
        } else {
            return NULL;
        }
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    /* Method for the Clear Fields button on CRD Wizard*/
    public void clearFields() {
        try{
        crd.Account__c = null;
        crd.Plan_Platform__c = null;
        crd.National__c = null;
        crd.Insured_Type__c = null;
        crd.National__c = null;
        crd.Plan_Type_Retail__c = false;
        crd.PERS_timestamp__c = null;         // added by Sushant : Request 05476 
        crd.Plan_Type_Mail__c = false;
        crd.Plan_Type_Paper__c = false;
        crd.Plan_Type_Specialty__c = false;
        crd.Include_Kit_Logic__c = false;
        crd.High_Value_Client__c = false;
        crd.Insured_Type__c = null;
        crd.Plan_Description__c = null;
        crd.Pre_Implementation_Audit__c = null;
        crd.Vendor_Transition_Files__c = null;
        crd.TP_ID__c = null;
        crd.Rx_PP_ID__c = null;
        crd.Custom_Ben_ID__c = null;
        crd.Which_system_will_the_plan_be_installed__c = null;
        crd.Plan_Type_Specialty_OON__c = False;
        } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
    /* Method to send the CRD to TPID */
    public Void sendTPID1() {
        errorMessages.clear();
        GC_Validation_Methods validatioClass = new GC_Validation_Methods();
        Boolean isAccountMapped = True;
        Boolean isValidAccum = True;
        if(!validatioClass.matchAccount(crd)){
               isAccountMapped =false;
                errormessages.add(system.label.ERR00198);
               //errorMessage add
          }
        isValidAccum = checkAccum.checkChangeCopay(crd.id);
        if (!isValidAccum) {
            errorMessages.add(system.Label.ERR00147);
        }
        if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == NO && crd.Full_Control_Group__c == null) {
            errorMessages.add(system.label.ERR00134);
        } else if ((crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED) && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Full_Control_Group__c != null) {
            errorMessages.add(system.label.ERR00135);
        } else {
            crd.Integrating_User__c = UserInfo.getUserId();
            try {
                database.update(crd);
            } catch (exception e) {
                errorMessages.add(system.Label.ERR00053);
            }
            crd = [select Id, Standard_or_Custom_Plan__c,Sub_segment__c, Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c, Partial_Control_Group__c, name, SAC_Override_Option__c, /*CRD_Pricing__c,*/ Are_you_creating_a_Package_Plan__c, Platform_Information__c, RxPlanID__c, Risk_Indicator__c, Plan_Type_Specialty__c, Plan_Type_Retail__c,Plan_Type_Specialty_OON__c, Y_Schd__c, Plan_Type_Mail__c, BPERxPlan_ID__c, RxPlan_ID_Status__c, Account_State__c, Custom_Ben_ID__c, Insured_Type__c, Rx_PP_ID__c, Account__c, TP_ID__c, Vendor_Transition_Files__c, Pre_Implementation_Audit__c, High_Value_Client__c, Include_Kit_Logic__c, National__c, Plan_Type_Paper__c, Integrate_with_Medical__c, Plan_Platform__c, Plan_Description__c, Which_system_will_the_plan_be_installed__c, Subsegment__c, Rating_ERB__c, Mail_Y_Schedule__c from CRD__c where Id = : this.crd.Id LIMIT 100000];

            overrideSubSegmentValue();
            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = H;
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = T;
            } else {
                crd.Platform_Information__c = BLANK;
            }           
            
            /* rakesh - 4/16 - Req 00483 - Validations
             *  1. All HMO Plans should have the Medical Platform of HMO
             *  2. All Custom Plans require an FCG
             */
            overrideSubSegmentValue();
           Boolean hasError = false;            // Flag to indicate any error
                
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }

            overrideSubSegmentValue();
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);

            if (yScheduleList != null) {
                if(!networkYSchedule){
                crd.Y_Schd__c = yScheduleList[0];
                crd.Pricing_Schedule__c = yScheduleList[0];
                }else if(networkRetailYSchedule != NULL){ 
                    crd.y_schd__c = networkRetailYSchedule;
                    crd.Pricing_Schedule__c = networkRetailYSchedule;
                }
                crd.Mail_Y_Schedule__c = yScheduleList[1];
            } else {
                //Do Nothing
            }
            overideYscheduleValues();
            try {
                database.update(crd);
            } catch (exception e) {
                ApexPages.addMessages(e);

            }

            if (crd.TP_ID__c != BLANK && crd.TP_ID__c != Null && crd.Rx_PP_ID__c == null && crd.Custom_Ben_ID__c == null && crd.Y_Schd__c != BLANK && crd.Platform_Information__c != Null && crd.Platform_Information__c != BLANK && crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL && isValidAccum && isAccountMapped ) {
                aiRequest = new AI_Request__c();
                aiRequest.CRD_ID__c = crd.Id;
                aiRequest.Request_Type__c = system.label.CL0000039;
                aiRequest.Plan_ID__c = crd.TP_ID__c;
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;
                aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;
                database.update(crd);
                database.insert(aiRequest);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00106);
                ApexPages.addMessage(myMsg);
            } else if (crd.Rx_PP_ID__c != null || crd.Custom_Ben_ID__c != null) {
                errorMessages.add(system.Label.ERR00129);
            } else {
                errorMessages.add(system.Label.ERR00045);
            }
        }
    }
    /* Method for AI Callout*/
    Public Pagereference callout() {
        WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
        WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();
        if (aiRequest != null) {
            try {
                crdDetail.requestId = aiRequest.Id;
                crdDetail.crdId = aiRequest.CRD_ID__c;
                crdDetail.requestType = aiRequest.Request_Type__c;
                if (aiRequest.Plan_ID__c != null) {
                    crdDetail.planId = aiRequest.Plan_ID__c;
                }
                if (aiRequest.Benefit__c != null) {
                    crdDetail.benefitsString = aiRequest.Benefit__c;
                }
                if (aiRequest.Benefits_String_Extn__c != null) {
                    crdDetail.benefitsStringExtension = aiRequest.Benefits_String_Extn__c;
                }
                if (aiRequest.Integration_1__c != null) {
                    crdDetail.traditionalControlNumberPlanSummaryDetails = aiRequest.Integration_1__c;
                }
                if (aiRequest.Pricing_Schedule__c != null) {
                    crdDetail.pricingSchedule = aiRequest.Pricing_Schedule__c;
                }
                if (aiRequest.Risk_Indicator__c != null) {
                    crdDetail.riskIndicator = aiRequest.Risk_Indicator__c;
                }
                if (aiRequest.StateList_to_Remove__c != null) {
                    crdDetail.listOfStatesToRemoveFromPlan = aiRequest.StateList_to_Remove__c;
                }
                if (aiRequest.Request_Type__c.contains(system.label.CL0000035)) {
                    crdDetail.benefitsApplyToAllStates = string.valueof(aiRequest.State_Mandates_Apply__c);
                    crdDetail.benefitsStateList = aiRequest.States_List_for_Mandate__c;
                }
                integrationClass.SessionId = Userinfo.getsessionId();
                integrationClass.CRDDetails = crdDetail;
                WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();
                sendData.endpoint_x = system.label.CL0000034;
                sendData.timeout_x = 30000;
                Boolean result = sendData.createRxPlan(integrationClass);
                if (result) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00106);
                    ApexPages.addMessage(myMsg);
                }
            } catch (exception e) {
                errorMessages.add(system.label.ERR00127);
            }
        } else {
            errorMessages.add(system.label.ERR00128);
        }
        return null;
    }
    /* Method to send the CRD to PPID*/
    Public Void sendPPID1() {
        errorMessages.clear();
        Boolean isValidAccum = True;
        Boolean isAccountMapped = True;
        GC_Validation_Methods validatioClass = new GC_Validation_Methods();
        
        if(!validatioClass.matchAccount(crd)){
               isAccountMapped =false;
                errormessages.add(system.label.ERR00198);
               //errorMessage add
          }
        isValidAccum = checkAccum.checkChangeCopay(crd.id);
        if (!isValidAccum) {
            errorMessages.add(system.Label.ERR00147);
        }
        if (isElementCommon(crd.Benefits_State_List__c, crd.List_Of_states_to_remove_the_plan__c)) {
            errorMessages.add(System.Label.ERR00136);
        } else if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == NO && crd.Full_Control_Group__c == null) {
            errorMessages.add(system.label.ERR00134);
        } else if ((crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED) && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Full_Control_Group__c != null) {
            errorMessages.add(system.label.ERR00135);
        } else {
            aiRequest = new AI_Request__c();
            crd.Integrating_User__c = UserInfo.getUserId();
            try {
                database.update(crd);
            } catch (exception e) {
                errorMessages.add(system.Label.ERR00053);
            }
            crd = [select Id, Sub_segment__c, Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c, Benefits_State_List__c, Do_mandates_apply_to_all_states__c, Partial_Control_Group__c, name, Tiering__c, SAC_Override_Option__c, /*CRD_Pricing__c,*/ Are_you_creating_a_Package_Plan__c, Platform_Information__c, RxPlanID__c, Risk_Indicator__c, Plan_Type_Specialty__c,Plan_Type_Specialty_OON__c, Plan_Type_Retail__c, Y_Schd__c, Plan_Type_Mail__c, BPERxPlan_ID__c, RxPlan_ID_Status__c, Account_State__c, Custom_Ben_ID__c, Insured_Type__c, Rx_PP_ID__c, Account__c, TP_ID__c, Vendor_Transition_Files__c, Pre_Implementation_Audit__c, High_Value_Client__c, Include_Kit_Logic__c, National__c, Plan_Type_Paper__c, Integrate_with_Medical__c, Plan_Platform__c, Plan_Description__c, Which_system_will_the_plan_be_installed__c, Subsegment__c, Rating_ERB__c, Mail_Y_Schedule__c from CRD__c where Id = : this.crd.Id LIMIT 100000];
            overrideSubSegmentValue();
            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = H;
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = T;
            } else {
                crd.Platform_Information__c = BLANK;
            }
            
            /* rakesh - 4/16 - Req 00483 - Validations
             *  1. All HMO Plans should have the Medical Platform of HMO
             *  2. All Custom Plans require an FCG
             */
            overrideSubSegmentValue();
            
            Boolean hasError = false;
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }

            overrideSubSegmentValue();
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);

            if (yScheduleList != null) {
                if(!networkYSchedule){
                crd.Y_Schd__c = yScheduleList[0];
                crd.Pricing_Schedule__c = yScheduleList[0];
                }else if(networkRetailYSchedule != NULL){ 
                    crd.y_schd__c = networkRetailYSchedule;
                    crd.Pricing_Schedule__c = networkRetailYSchedule;
                }
                crd.Mail_Y_Schedule__c = yScheduleList[1];
            } else {
                //Do Nothing
            }
           overideYscheduleValues(); 
            try {
                database.update(crd);
            } catch (exception e) {
                ApexPages.addMessages(e);

            }
      
            if (crd.Rx_PP_ID__c != BLANK && crd.Rx_PP_ID__c != Null && crd.TP_ID__c == Null && crd.Custom_Ben_ID__c == Null && crd.Y_Schd__c != BLANK && crd.Platform_Information__c != Null && crd.Platform_Information__c != BLANK && crd.Risk_Indicator__c != Null && crd.Risk_Indicator__c != BLANK && crd.Account_State__c != BLANK && crd.Which_system_will_the_plan_be_installed__c == HMO && isValidAccum && isAccountMapped) {
                aiRequest.CRD_ID__c = crd.Id;
                aiRequest.Request_Type__c = system.Label.CL0000037;
                aiRequest.Plan_ID__c = crd.Rx_PP_ID__c;
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;
                aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;
                if (crd.Benefits_State_List__c != null && crd.Benefits_State_List__c != BLANK) {
                    aiRequest.States_List_for_Mandate__c = crd.Benefits_State_List__c.replaceAll(SPLIT, COMMA);
                }
                if (crd.Do_mandates_apply_to_all_states__c == Y) {
                    aiRequest.State_Mandates_Apply__c = True;
                } else {
                    aiRequest.State_Mandates_Apply__c = False;
                }
                database.insert(aiRequest);
                crd.Integration_Status__c = SENDTOAI;
                database.update(crd);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00106);
                ApexPages.addMessage(myMsg);
            } else if (crd.TP_ID__c != Null || crd.Custom_Ben_ID__c != Null) {
                errorMessages.add(system.Label.ERR00061);
            } else {
                errorMessages.add(system.Label.ERR00044);
            }
        }
    }
    /* Method for custom Ben ID*/
    Public Void sendBenId() {
        errorMessages.clear();
        Boolean isValidAccum = True;
        Boolean isValidAI = True;
        Boolean isAccountMapped = True;
        GC_Validation_Methods validatioClass = new GC_Validation_Methods();
        
        if(!validatioClass.matchAccount(crd)){
               isAccountMapped =false;
                errormessages.add(system.label.ERR00198);
          }
        isValidAccum = checkAccum.checkChangeCopay(crd.id);
        if (!isValidAccum) {
            errorMessages.add(system.Label.ERR00147);
        }
        if (isElementCommon(crd.Benefits_State_List__c, crd.List_Of_states_to_remove_the_plan__c)) {
            errorMessages.add(System.Label.ERR00136);
        } else if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == NO && crd.Full_Control_Group__c == null) {
            errorMessages.add(system.label.ERR00134);
        } else if ((crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED) && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Full_Control_Group__c != null) {
            errorMessages.add(system.label.ERR00135);
        } else {
            try {
                database.update(crd);
            } catch (exception e) {
                errorMessages.add(system.Label.ERR00053);
            }
            crd = [select Id, Sub_segment__c, Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c, Partial_Control_Group__c, name, Tiering__c, Benefits_State_List__c, Do_mandates_apply_to_all_states__c, List_Of_states_to_remove_the_plan__c, SAC_Override_Option__c, /*CRD_Pricing__c,*/ Are_you_creating_a_Package_Plan__c, Platform_Information__c, RxPlanID__c, Risk_Indicator__c, Plan_Type_Specialty__c, Plan_Type_Specialty_OON__c,Plan_Type_Retail__c, Y_Schd__c, Plan_Type_Mail__c, BPERxPlan_ID__c, RxPlan_ID_Status__c, Account_State__c, Custom_Ben_ID__c, Insured_Type__c, Rx_PP_ID__c, Account__c, TP_ID__c, Vendor_Transition_Files__c, Pre_Implementation_Audit__c, High_Value_Client__c, Include_Kit_Logic__c, National__c, Plan_Type_Paper__c, Integrate_with_Medical__c, Plan_Platform__c, Plan_Description__c, Which_system_will_the_plan_be_installed__c, Subsegment__c, Rating_ERB__c, Mail_Y_Schedule__c from CRD__c where Id = : this.crd.Id LIMIT 100000];

            overrideSubSegmentValue();
            crd.Integrating_User__c = UserInfo.getUserId();
            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = H;
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = T;
            } else {
                crd.Platform_Information__c = BLANK;
            }
            
            /* rakesh - 4/16 - Req 00483 - Validations
             *  1. All HMO Plans should have the Medical Platform of HMO
             *  2. All Custom Plans require an FCG
             */
            overrideSubSegmentValue();
            
            Boolean hasError = false;
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == YES && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }

            overrideSubSegmentValue();
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);

            if (yScheduleList != null) {
                if(!networkYSchedule){
                crd.Y_Schd__c = yScheduleList[0];
                crd.Pricing_Schedule__c = yScheduleList[0];
                }else if(networkRetailYSchedule != NULL){ 
                    crd.y_schd__c = networkRetailYSchedule;
                    crd.Pricing_Schedule__c = networkRetailYSchedule;
                }
                crd.Mail_Y_Schedule__c = yScheduleList[1];
            } else {//Do Nothing
            }
            
            if (crd.Which_system_will_the_plan_be_installed__c == HMO && crd.Do_mandates_apply_to_all_states__c == N && crd.Benefits_State_List__c == null) {
                errorMessages.add(system.label.ERR00180);
                isValidAI = False;
            }
            if (crd.Which_system_will_the_plan_be_installed__c == HMO && crd.Do_mandates_apply_to_all_states__c == Y && crd.Benefits_State_List__c != null) {
                errorMessages.add(system.label.ERR00181);
                isValidAI = False;
            }
            
            try {
                database.update(crd);
            } catch (exception e) {
                ApexPages.addMessages(e);

            }

            if (crd.Rx_PP_ID__c == Null && crd.TP_ID__c == Null && crd.Custom_Ben_ID__c != null && crd.Custom_Ben_ID__c != BLANK && crd.Y_Schd__c != BLANK && crd.Platform_Information__c != Null && crd.Platform_Information__c != BLANK && crd.Risk_Indicator__c != Null && crd.Risk_Indicator__c != BLANK && isValidAccum && isValidAI && isAccountMapped ) {
                aiRequest = new AI_Request__c();
                aiRequest.CRD_ID__c = crd.Id;
                aiRequest.Request_Type__c = system.Label.CL0000038;

                Integer currentBenidSize = crd.Custom_Ben_ID__c.length();
                Integer trailing0Needs = 10 - currentBenidSize;
                if (trailing0Needs > 0) {
                    String trailingBenIdString = ZERO;
                    for (integer i = 1; i < trailing0Needs; i++) {
                        trailingBenIdString = trailingBenIdString + ZERO;
                    }
                    crd.Custom_Ben_ID__c = trailingBenIdString + crd.Custom_Ben_ID__c;
                }
                aiRequest.Benefit__c = crd.Custom_Ben_ID__c;
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;
                aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;
                if (crd.Benefits_State_List__c != NULL) {
                    aiRequest.States_List_for_Mandate__c = crd.Benefits_State_List__c.replaceAll(SPLIT, COMMA);
                }
                if (crd.Do_mandates_apply_to_all_states__c == Y) {
                    aiRequest.State_Mandates_Apply__c = True;
                    aiRequest.States_List_for_Mandate__c = BLANK;
                } else {
                    aiRequest.State_Mandates_Apply__c = False;
                }
                if (crd.List_Of_states_to_remove_the_plan__c != Null && crd.List_Of_states_to_remove_the_plan__c != BLANK) {
                    aiRequest.StateList_to_Remove__c = crd.List_Of_states_to_remove_the_plan__c.replaceAll(SPLIT, COMMA);
                }
                database.insert(aiRequest);
                crd.Integration_Status__c = SENDTOAI;
                database.update(crd);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00106);
                ApexPages.addMessage(myMsg);
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00138);
                ApexPages.addMessage(myMsg);
            }
        }
    }

    /* 
     * Method that takes two string str1 and str2 which are semi-colon delimited,
     * converts them to arrays and checks if there are elements common between them.
     *
     * @return 
     *      true - if some elements are common
     *      false - otherwise
     */
    public boolean isElementCommon(String str1, String str2) {
        try{
        if (str1 == null || str2 == null) {
            return false;
        }
        String[] strList1 = str1.split(SPLIT);
        String[] strList2 = str2.split(SPLIT);
        Set < String > strSet1 = new Set < String > ();
        strSet1.addAll(strList1);
        for (String s: strList2) {
            if (strSet1.contains(s)) {
                return true;
            }
        }
        return false;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    /* Method for managing the HMO fields */
    public void manageHmoFields() {
         try{
         showPERSTimestamp = false;
        if (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c != HMO) {
            crd.Do_mandates_apply_to_all_states__c = null;
            crd.Benefits_State_List__c = null;
            crd.List_Of_states_to_remove_the_plan__c = null;
            crd.Rx_PP_ID__c = null;
            crd.Custom_Ben_ID__c = null;
            if(crd.Standard_or_Custom_Plan__c != NULL && (crd.Standard_or_Custom_Plan__c != CONSUMERPLAN && crd.Standard_or_Custom_Plan__c != CLONECONSUMERPLAN && crd.Standard_or_Custom_Plan__c != PACKAGEDPLAN && crd.Standard_or_Custom_Plan__c != CLONEPACKAGEDPLAN && crd.Standard_or_Custom_Plan__c != HIXPLAN  && crd.Standard_or_Custom_Plan__c != CLONEHIXPLAN ))
                {
                    crd.Override_Retail_Y_Schedule__c = null;
                    crd.Retail_Y_Schedule_Override__c = null;                    
                }
        }
        // added by Sushant : Request 05476 **Start**
        if (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL)
        {
            if(crd.Standard_or_Custom_Plan__c != null && (crd.Standard_or_Custom_Plan__c == CUSTOMPLAN || crd.Standard_or_Custom_Plan__c == CLONECUSTOMPLAN))
            {
                showPERSTimestamp = true;
            }          
        } // **End**
        } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
    /*Below line of code added by abhishek date on 10/11/2013 */
    public void showDrugList()
    {
        try{
        showDrug = false;
        /*if(crd.Chronic_and_or_Preventive_List__c == 'Custom')
        {
            showDrug = true;
        }*/
       /*  if(crd.Chronic_and_or_Preventive_List__c == NULL)
        {
            crd.Chronic_Preventive_Drug_List__c = null;
        }*/
    }
    catch(exception e){
        ApexPages.addMessages(e);
    }
    }
    
    /* method for request no 04924 Added By Nitish*/// Commented as on August 16th 2016 Request 06600
    /*public void changelogic(){
    try{
    if(crd.Acquisition_Indicator__c == YES)
      {
   crd.Include_Kit_Logic__c = False;
   crd.Opt_out_of_Safety_Edits__c = YES;
     }
     } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
     }*/
     /* method added by Sushant for next Button Story */
     public pageReference checkPublicGroup(){
        try{
        userId = UserInfo.getUserId();
        groupMember= GRPMEMFLASE;
        groupCheck = [Select g.Id,g.Name from Group g where Name =: PUBLICGROUP LIMIT 10000];
        groupId = groupcheck[0].id;
        
        for(GroupMember gm : [Select g.UserOrGroupId, g.Id, g.GroupId From GroupMember g where GroupId =: groupId LIMIT 100000]){
             groupUserIds.add(string.valueof(gm.UserOrGroupId));
        }  
        
        for(string s : groupUserIds){
            if(s.contains(userId)){
            groupMember = GRPMEMTRUE;
        }
        }
        
        return null;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
     
       
    /* Richa added method for Req - 5003 */
    public void populateMAC(){
        try{
        list<Copay_Tier__c> copayTier = new list<Copay_Tier__c>();
        list<Accumulations__c> acumltn = new list<Accumulations__c>();
        copayTier = [Select Tier__c, Percent__c, Dollar_Amount__c, Tier_Type__c, Tier_Name__c from Copay_Tier__c where Tier_Name__c LIKE :LIKEMAIL AND crd__c = : crdId LIMIT 100000]; 
        acumltn = [Select Deductible_Amount__c, What_is_the_In_Network_Deductible_Amount__c, What_is_the_OON_Deductible_Amount__c from Accumulations__c where CRD_ID__c = : crdId LIMIT 100000];
        GC_Utils_Method utilinstance = new GC_Utils_Method();
        utilinstance.setMACatMailApplies(crd, copayTier, acumltn);
        } catch (exception e) {
            ApexPages.addMessages(e);

        }
    }
 
 /* Added by Ayushi for next button story */
 Public PageReference redirectToStep02() {
        try{
        Pagereference pageRef = new Pagereference(FIRSTSCREEN + crd.Id);
        pageRef.getParameters().put(PARAMEDITMODE,editMode);
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
        return pageRef;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
 //Added By Nitish Story 6939
 
 public void modifyCarrier(){
     if(string.isNotEmpty(crd.sub_segment__c) &&(crd.sub_segment__c.equalsIgnoreCase(SG) || crd.sub_segment__c.equalsIgnoreCase(SGX))){
         crd.National__c = SMALLGROUP;
         makeWhatisSegmentReadOnly = true;
         makeWhatisSegmentEditable = false;
     }
     else if(string.isNotEmpty(crd.sub_segment__c) && (crd.sub_segment__c.equalsIgnoreCase(IVL) || crd.sub_Segment__c.equalsIgnoreCase(HIX))){
         crd.National__c = INDIVIDUAL;
         makeWhatisSegmentReadOnly = true;
         makeWhatisSegmentEditable = false;
     }
     if(string.isNotEmpty(crd.sub_segment__c) && !(crd.sub_segment__c.equalsIgnoreCase(SG) || crd.sub_segment__c.equalsIgnoreCase(SGX) || crd.sub_segment__c.equalsIgnoreCase(IVL) || crd.sub_Segment__c.equalsIgnoreCase(HIX))){
         makeWhatisSegmentEditable = true;
         makeWhatisSegmentReadOnly = false;
         crd.National__c = BLANK;
         
     }
  }
}