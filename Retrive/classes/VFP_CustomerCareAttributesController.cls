/*Purpose: Apex Class for VFP_CustomerCareAttributes Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 7/20/2011       Apex Class for VFP_CustomerCareAttributes Page.
     2.0 -    Ankur                 3/12/2015       Implemented request 5361
======================================================================== 
*/
public with sharing class VFP_CustomerCareAttributesController {
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public String AGBname = 'Aetna Global Benefits';
    public static final string EDITTRUE = 'BCTME';
    public string groupMember{get;set;}
    public string managementUser {get;set;}
    public String editMode{
      get;
      set;
    }
    public string inNetVal{get;set;}
    public string pageName {
        get;
        set;
    }
    public boolean showIvrField {
        get;
        set;
    }
    public List < Attachment > CustomerCareattachments {
        get;
        set;
    }
    public List < Attachment > newGreetingsattachments {
        get;
        set;
    }
    public blob fileContent {
        get;
        set;
    }
    public Attachment ccScript {
        get;
        set;
    }
    public Attachment greetingNmenu {
        get;
        set;
    }
    public boolean isInsuranceTypeSelf {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    } 
    GC_Validation_Methods gCValidationMethod = new GC_Validation_Methods();
    private static final string YES = 'Yes';
    private static final string NO = 'No';
    private static final string SI = 'Self Insured';
    private static final string EDITMODEPARAM = 'p1';
    private static final string GROUPMEMBERPARAM = 'p2';
    private static final string CURRENTPAGE = 'currentPageName';
    private static final string ORALPAGE = '/apex/VF_CRDoralChemoCopay?crdid=';
    private static final string SECONDSCREEN = '/apex/VF_NewCRDPlan_Step1?id=';
    private static final string CCAPAGE = '/apex/VF_CRDCustomerCareAttributes_Step1?id=';
    private static final string V1 = 'N = include';
    private static final string V2 = 'per claim';
    
    /*Constructor for VFP_CustomerCareAttributesController class*/
    public VFP_CustomerCareAttributesController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) controller.getRecord();
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);
        crd = [Select Name,Ostomy_Supplies__c,Other_Insurance_Paid_in_Error__c,National__c,Manual_Pharmacy_Payments__c,Erisa_Client__c,Plan_Coordinate_Benefits__c,Default_NABP__c,Administration_of_External_COB__c,Veterans_Admin__c,Allergy_Serums__c,Clinic_Physician_Reimbursement__c,Nursing_Home_Claims__c,Medicaid__c,Foreign_Claims__c,Claims_Acceptable_w_o_receipts__c,Compound_Code_2__c,Claims_payable_with_Pharm_Signature__c,Indian_Facilities__c,RTMD_Modulator_Percent__c,Specialty_Exclusion_Flag__c,RTMD_Admin_Fee_basis__c,RTMD_Admin_Fee_rate__c,In_Network__c,RDS__c,Are_Emergency_Claims_Reimbursed__c,Emergency_Discount_Rate__c,Are_Hemo_Claims_Reimbursed__c,Hemo_Discount_Rate__c,Out_of_Network_Reimbursement_Level__c,In_Network_Reimbursement_Level__c,Out_of_Network__c,Does_the_client_want_to_do_COB__c, Process_Point_of_Sales_COB__c,Reimbursement_Levels__c,COB_or_MOB__c,Integrate_with_Medical__c, POS_Rebate_for_Plan__c,In_Network_claims_are_reimbursed__c,Prorate__c,No_of_Days_to_file_a_claim__c,Offshore__c,Bypass_DMR__c,Retail_Source_AWP__c,In_Network_Discount_Rate__c,Out_of_Network_Discount_Rate__c,Out_of_Network_claims_are_reimbused__c,RTMD_Effective_Date__c,RTMD_Client_Share_Percent__c,Are_you_creating_a_Package_Plan__c, Insured_Type__c, RxPlan_ID_Status__c, Toll_Free_Number__c, Plan_Type_Paper__c, Vacation__c, Participant_Lost_Stolen_Damaged_Meds__c, Mail_Order_Delay__c, Maximum_Dollar__c, Dosage_Increase_Change__c, Multiple_Births__c, Retail_refill_for_Manufacture_Back_Order__c, Dose_Optimization__c, Duplicate_Therapy__c, Incorrect_Days_Supply__c, Annual_Fill_Limit_Allowed_Limit__c, Nursing_Home__c, Specialty_Retail_Lock_Out__c, Expatriate_Employees__c, Participant_Mail_In_Delay__c, Disaster_Emergency__c, Transition_Plan_1_x_override_30DS__c, MDL_or_QVT_Limit_Exceptions__c, Y_Schd__c From CRD__c Where ID = : this.crd.id LIMIT 80000];
        crdId = crd.id;
        //Requets -6765 By Nitish
        inNetVal = System.currentPagereference().getParameters().get('inNetVal');
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;
        CustomerCareattachments = [Select Id, Name From Attachment where ParentId = : crdId AND Name Like '%Customer Care Script%' LIMIT 80000];
        newGreetingsattachments = [Select Id, Name From Attachment where ParentId = : crdId AND Name Like '%Greeting & Menus%' LIMIT 80000];
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        errorMessages = new list < String > ();
        if (SI.equalsIgnoreCase(crd.Insured_Type__c)) {
            isInsuranceTypeSelf = false;
        } else {
            isInsuranceTypeSelf = true;
        }
        ccScript = new Attachment();
        greetingNmenu = new Attachment();
        if (SI.equalsIgnoreCase(crd.Insured_Type__c)) {
            if (crd.Vacation__c != NO) {
                crd.Vacation__c = YES;
            }
            if (crd.Participant_Lost_Stolen_Damaged_Meds__c != NO) {
                crd.Participant_Lost_Stolen_Damaged_Meds__c = YES;
            }
            if (crd.Mail_Order_Delay__c != NO) {
                crd.Mail_Order_Delay__c = YES;
            }
            if (crd.Maximum_Dollar__c != NO) {
                crd.Maximum_Dollar__c = YES;
            }
            if (crd.Dosage_Increase_Change__c != NO) {
                crd.Dosage_Increase_Change__c = YES;
            }
            if (crd.Multiple_Births__c != NO) {
                crd.Multiple_Births__c = YES;
            }
            if (crd.Retail_refill_for_Manufacture_Back_Order__c != NO) {
                crd.Retail_refill_for_Manufacture_Back_Order__c = YES;
            }
            if (crd.Dose_Optimization__c != NO) {
                crd.Dose_Optimization__c = YES;
            }
            if (crd.Duplicate_Therapy__c != NO) {
                crd.Duplicate_Therapy__c = YES;
            }
            if (crd.Incorrect_Days_Supply__c != NO) {
                crd.Incorrect_Days_Supply__c = YES;
            }
            if (crd.Annual_Fill_Limit_Allowed_Limit__c != NO) {
                crd.Annual_Fill_Limit_Allowed_Limit__c = YES;
            }
            if (crd.Nursing_Home__c != NO) {
                crd.Nursing_Home__c = YES;
            }
            if (crd.Specialty_Retail_Lock_Out__c != NO) {
                crd.Specialty_Retail_Lock_Out__c = YES;
            }
            if (crd.Participant_Mail_In_Delay__c != NO) {
                crd.Participant_Mail_In_Delay__c = YES;
            }
            if (crd.Transition_Plan_1_x_override_30DS__c != NO) {
                crd.Transition_Plan_1_x_override_30DS__c = YES;
            }
            if (crd.MDL_or_QVT_Limit_Exceptions__c != NO) {
                crd.MDL_or_QVT_Limit_Exceptions__c = YES;
            }
            if (crd.Disaster_Emergency__c != NO) {
                crd.Disaster_Emergency__c = YES;
            }
            if (crd.Expatriate_Employees__c != NO) {
                crd.Expatriate_Employees__c = YES;
            }
        } else {
            crd.Vacation__c = NO;
            crd.Participant_Lost_Stolen_Damaged_Meds__c = NO;
            crd.Mail_Order_Delay__c = NO;
            crd.Maximum_Dollar__c = NO;
            crd.Dosage_Increase_Change__c = NO;
            crd.Multiple_Births__c = NO;
            crd.Retail_refill_for_Manufacture_Back_Order__c = NO;
            crd.Dose_Optimization__c = NO;
            crd.Duplicate_Therapy__c = NO;
            crd.Incorrect_Days_Supply__c = NO;
            crd.Annual_Fill_Limit_Allowed_Limit__c = NO;
            crd.Nursing_Home__c = NO;
            crd.Specialty_Retail_Lock_Out__c = NO;
            crd.Participant_Mail_In_Delay__c = NO;
            crd.Transition_Plan_1_x_override_30DS__c = NO;
            crd.MDL_or_QVT_Limit_Exceptions__c = NO;
            crd.Disaster_Emergency__c = NO;
            crd.Expatriate_Employees__c = NO;
        }
        managementUserAccess();
        system.debug('crd.In_Network_Reimbursement_Level__c+++ ' +crd.In_Network_Reimbursement_Level__c);

    }
    /*Method to redirect to Copay screen*/
    public PageReference redirectToCopay() {
        try {
            if(EDITTRUE.equalsIgnoreCase(editMode)){
            errorMessages.clear();
        if(GCValidationMethod.CRDThirdScreenValidations(crd)!=null && GCValidationMethod.CRDThirdScreenValidations(crd).size()>0){
             errorMessages = GCValidationMethod.CRDThirdScreenValidations(crd);       
             return null;
            }
            database.update(crd);
        }
        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        /*if(crd.Insured_Type__c==SI &&(crd.National__c=='Key' || crd.National__c=='National')){
            Pagereference pageRef = new Pagereference('/apex/VF_CRDCVSWebAccessUsers?id=' + crdId);
            return pageRef;
        }
        else{Req 4937*/
            Pagereference pageRef = new Pagereference(ORALPAGE + crdId);//Richa modified the redirection as per Req 5890
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        //}
    }

    //Added by Ayushi for next button story
    public PageReference redirectToCopay2() {
       try {
            Pagereference pageRef = new Pagereference(ORALPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
       } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /*Method to redirect to previous screen*/
    public PageReference previous() {
        try {
        errorMessages.clear();
        if(GCValidationMethod.CRDThirdScreenValidations(crd)!=null && GCValidationMethod.CRDThirdScreenValidations(crd).size()>0){
             errorMessages = GCValidationMethod.CRDThirdScreenValidations(crd);       
             return null;
            }
            database.update(crd);
        } catch (exception e) {
            return null;
        }


        Pagereference pageRef = new Pagereference(SECONDSCREEN + crd.Id);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
    /*Method to redirect to previous screen for Readonly Mode*/
    public PageReference previous2() {
        try{
        Pagereference pageRef = new Pagereference(SECONDSCREEN + crd.Id);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to upload script*/
    Public pagereference uploadCustomerCare() {
        try {
            if (ccScript != null) {
                upload(ccScript, 'Customer Care Script');
            }
            Pagereference pageRef = new Pagereference(CCAPAGE + crd.Id);
            pageRef.setredirect(True);
            return pageRef;
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /*Method to upload greeting*/
    Public pagereference uploadNewGreeting() {
        try {
            if (greetingNmenu != null) {
                upload(greetingNmenu, 'Greeting & Menus');
            }
            Pagereference pageRef = new Pagereference(CCAPAGE + crd.Id);
            pageRef.setredirect(True);
            return pageRef;
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }

    /*Method to upload the file to the CRD*/
    public void upload(Attachment attachment, string namePrefix) {

        attachment.Name = system.today() + '_' + namePrefix + '_' + attachment.Name;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = crd.id; // the record the file is attached to
        attachment.IsPrivate = true;

        try {
            database.insert(attachment);
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.ERR00082));

        }
    }
    /*Method to render fields to previous screen*/
    public void showpanel() {
        if (crd.POS_Rebate_for_Plan__c != null && YES.equalsIgnoreCase(crd.POS_Rebate_for_Plan__c)) {
            crd.RTMD_Modulator_Percent__c = 100;
            crd.Specialty_Exclusion_Flag__c = V1;
            crd.RTMD_Admin_Fee_basis__c = V2;
            crd.RTMD_Admin_Fee_rate__c = 0;
        } else {
            crd.RTMD_Effective_Date__c = null;
            crd.RTMD_Client_Share_Percent__c = null;
            crd.RTMD_Modulator_Percent__c = null;
            crd.Specialty_Exclusion_Flag__c = null;
            crd.RTMD_Admin_Fee_basis__c = null;
            crd.RTMD_Admin_Fee_rate__c = null;            
        }
    }
    //Start of 06765 Methods
     //Method 1
      public void managementUserAccess(){
            /*
            if(crd.In_Network_claims_are_reimbursed__c && managementUser== 'false'){
                crd.In_Network_Discount_Rate__c = 'Submitted Price';  
            }
            if(crd.Out_of_Network_claims_are_reimbused__c && managementUser== 'false'){
                crd.Out_of_Network_Discount_Rate__c= 'AWP + 10%';  
            }
            if(crd.In_Network__c && managementUser== 'false' && crd.COB_or_MOB__c == 'COB'){
                crd.In_Network_Reimbursement_Level__c = '100% submitted less ZERO copay';
            }
           
            if(crd.In_Network__c && managementUser== 'false' && crd.COB_or_MOB__c == 'MOB'){
                crd.In_Network_Reimbursement_Level__c = '100% submitted charges less copay';
            }*/
            
             
                
               
            Crd.RDS__c = 'No';    
            
           /*
            if(crd.Process_Point_of_Sales_COB__c && managementUser== 'false'){
                crd.Reimbursement_Levels__c = '100% of submitted charges less ZERO copay';
            }*/
     }
   // End of 06765 Method
   
}