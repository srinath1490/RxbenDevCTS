/*Purpose: Apex Class for VFP_CRDClinicalProgramStep1 Page.
========================================================================
History                                                           
-------                                                          
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -    Abhay                 07/28/2011       Apex Class for VFP_CRDClinicalProgramStep1 Page.
2.0 -    Abhishek              11/14/2016       ST#1579-Story#5-CRD Default Fields [CRD Programs Page]
======================================================================== 
*/
public with sharing class VFP_CRDClinicalProgramStep1Controller {
    public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public blob fileAttach {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    public Attachment waiverFromAttachment {
        get;
        set;
    }
    public Attachment rxOtcWaiverFromAttachment {
        get;
        set;
    }
    public string ConcurrentDUR {
        get;
        set;
    }
    public string posDose {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }   
public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING CURRENTPAGE = 'currentPageName';
    PRIVATE STATIC FINAL STRING PHARMACYPAGE = '/apex/VF_CRDPharmacyNetwork?crdid=';
    PRIVATE STATIC FINAL STRING INCENT = 'Incentivized';
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING STPAGE = '/apex/VF_CRDStepTherepy?crdid=';
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING MANDATORY = 'Mandatory';
    GC_Validation_Methods gCValidationMethod = new GC_Validation_Methods(); 
    public String managementUser {get;set;} 
/*Constructor for VFP_CRDClinicalProgramStep1Controller*/
    public VFP_CRDClinicalProgramStep1Controller(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        crd = [Select Name, Y_Schd__c, Override_Standard_Max_Pay__c, Max_Pay__c, Integrate_with_Medical__c, Aetna_Autofill__c, Plan_Type_Paper__c, Insured_Type__c, account__c, Is_there_Compound_Max_Pay__c, Override_Standard_Compound_Max_Pay__c, Compound_Max_Pay__c, RxPlan_ID_Status__c, Concurrent_DUR_ID__c, Concurrent_DUR_ID__r.Name, Retail_to_Mail__c,Generic_Launch__c, POS_Dose_Optimization_ID__r.Name, Generic_Uptake__c, Specialty_Therapy_Management__c, Gaps_in_Care__c, Opt_out_of_Rx_OTC_Edit__c, POS_Dose_Optimization_Drug_List_ID__r.Name, Adherence_to_Drug_Therapy__c,Extra_Care_Health_Card__c,Value_Generic__c,Pharmacy_Advisor__c,Implementation_Type__c,Enrolled_in_PA_for_other_condition__c,Participate_in_CVS_mail_pharmacy_service__c,Disease_Management_Referral_Messaging__c,Disease_Management_Messaging_for__c,Is_DM_vendor_the_same_for_each_condition__c,PA_Disease_Vendor_1__C,PA_Condition_1__C,PA_DM_Vendor_Contract_End_Date_1__C,PA_Custom_Disease_Vendor_Phone_1__C,PA_Disease_Vendor_2__C,PA_Condition_2__C,PA_DM_Vendor_Contract_End_Date_2__C,PA_Custom_Disease_Vendor_Phone_2__C,PA_Disease_Vendor_3__C,PA_Condition_3__C,PA_DM_Vendor_Contract_End_Date_3__C,PA_Custom_Disease_Vendor_Phone_3__C,PA_Disease_Vendor_4__C,PA_Condition_4__C,PA_DM_Vendor_Contract_End_Date_4__C,PA_Custom_Disease_Vendor_Phone_4__C,PA_Disease_Vendor_5__C,PA_Condition_5__C,PA_DM_Vendor_Contract_End_Date_5__C,PA_Custom_Disease_Vendor_Phone_5__C,PA_Disease_Vendor_6__C,PA_Condition_6__C,PA_DM_Vendor_Contract_End_Date_6__C,PA_Custom_Disease_Vendor_Phone_6__C,PA_Disease_Vendor_7__C,PA_Condition_7__C,PA_DM_Vendor_Contract_End_Date_7__C,PA_Custom_Disease_Vendor_Phone_7__C

        From CRD__c Where ID = : crdId LIMIT 80000];

        ConcurrentDUR = crd.Concurrent_DUR_ID__r.Name;
        posDose = crd.POS_Dose_Optimization_Drug_List_ID__r.Name;
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;
        waiverFromAttachment = new Attachment();
        rxOtcWaiverFromAttachment = new Attachment();
        errorMessages = new list < String > ();
    }

    /*Method to redirect to Pharmacy Page for next button story*/
    Public PageReference redirectToPaperOptions2(){
        try{
        Pagereference pageRef = new Pagereference(PHARMACYPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to redirect to Pharmacy Page*/
    Public PageReference redirectToPaperOptions() {
        List < Drug_Coverage__c > drugCoverageList = new List < Drug_Coverage__c > ([select id, RecordType.Name, Mandatory_Mail_Order_Option__c, Maintenance_Choice__c, CRD_ID__c from Drug_Coverage__c WHERE CRD_ID__c = : crdId AND RecordType.Name = : MAIL LIMIT 80000]);
        try {
            errorMessages.clear();
            
            //Commented by JR on 18/11/2014 and moved to CRD update trigger
           /* if (crd.Is_there_Compound_Max_Pay__c == 'No' || crd.Is_there_Compound_Max_Pay__c == null) {
                crd.Compound_Max_Pay__c = NULL;
                crd.Override_Standard_Compound_Max_Pay__c = null;
            }
            if (crd.Override_Standard_Compound_Max_Pay__c == YES && crd.Compound_Max_Pay__c == null) {
                errorMessages.add(System.Label.ERR00139);
                return null;
            }

            if (crd.Override_Standard_Compound_Max_Pay__c == 'No') crd.Compound_Max_Pay__c = System.Label.DCSRT22;
            */
            for (Drug_Coverage__c drugCoverage: drugCoverageList) {
                if (MANDATORY.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__C) || INCENT.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) || MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || INCENT.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                    if (crd.Retail_to_Mail__c == TRUE) {
                        errorMessages.add(System.Label.ERR00160);
                        return null;
                    }
                }
            }

            /*if (crd.POS_Dose_Optimization__c == YES) {
                Drug_List__c cvsDrugList = [SELECT CVS_Caremark_Drug_List_ID__c FROM Drug_List__c WHERE Id = : System.Label.DCSRT20];
                crd.POS_Dose_Optimization_Drug_List_ID__c = System.Label.DCSRT20;
                crd.CVS_Caremark_Drug_List_ID__c = cvsDrugList.CVS_Caremark_Drug_List_ID__c;
            } else crd.POS_Dose_Optimization_Drug_List_ID__c = null;*/
            
                       
            if(GCValidationMethod.programScreenValidation(crd)!=null && GCValidationMethod.programScreenValidation(crd).size()>0){
             errorMessages = GCValidationMethod.programScreenValidation(crd);       
             return null;
            }
            DATABASE.update(crd);
            
            
        } catch (exception e) {
            //errorMessages.add(e.getMessage());
            return null;
        }

        Pagereference pageRef = new Pagereference(PHARMACYPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }



    /*Method to redirect to ST Page for next button story*/
    Public PageReference redirectToPharmacyNetwork2(){
        try{
        Pagereference pageRef = new Pagereference(STPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to redirect to ST Page*/
    Public PageReference redirectToPharmacyNetwork() {
        List < Drug_Coverage__c > drugCoverageList = new List < Drug_Coverage__c > ([select id, RecordType.Name, Mandatory_Mail_Order_Option__c, Maintenance_Choice__c, CRD_ID__c from Drug_Coverage__c WHERE CRD_ID__c = : crdId AND RecordType.Name = : MAIL LIMIT 80000]);
        try {
            errorMessages.clear();
           //Commented by JR on 18/11/2014 and moved to CRD update trigger
           /* if (crd.Is_there_Compound_Max_Pay__c == 'No' || crd.Is_there_Compound_Max_Pay__c == null) {
                crd.Compound_Max_Pay__c = NULL;
                crd.Override_Standard_Compound_Max_Pay__c = null;
            }
            if (crd.Override_Standard_Compound_Max_Pay__c == YES && crd.Compound_Max_Pay__c == null) {
                errorMessages.add(System.Label.ERR00139);
                return null;
            }

            if (crd.Override_Standard_Compound_Max_Pay__c == 'No') crd.Compound_Max_Pay__c = System.Label.DCSRT22;
            */
            for (Drug_Coverage__c drugCoverage: drugCoverageList) {
                if (MANDATORY.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) || INCENT.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) || MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || INCENT.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                    if (crd.Retail_to_Mail__c == TRUE) {
                        errorMessages.add(System.Label.ERR00160);
                        return null;
                    }
                }
            }

         /*   if (crd.POS_Dose_Optimization__c == YES) {
                Drug_List__c cvsDrugList = [SELECT CVS_Caremark_Drug_List_ID__c FROM Drug_List__c WHERE Id = : System.Label.DCSRT20];
                crd.POS_Dose_Optimization_Drug_List_ID__c = System.Label.DCSRT20;
                crd.CVS_Caremark_Drug_List_ID__c = cvsDrugList.CVS_Caremark_Drug_List_ID__c;
            } else crd.POS_Dose_Optimization_Drug_List_ID__c = null;*/
            
                       
            if(GCValidationMethod.programScreenValidation(crd)!=null && GCValidationMethod.programScreenValidation(crd).size()>0){
             errorMessages = GCValidationMethod.programScreenValidation(crd);       
             return null;
            }


            DATABASE.update(crd);

        } catch (exception e) {           
            //errorMessages.add(e.getMessage());
            return null;
        }

        Pagereference pageRef = new Pagereference(STPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }



    /*Method to handle Form Attachment*/
    public pagereference attachWaiverDoc() {
        try {
            if (waiverFromAttachment != null) {
                upload(waiverFromAttachment, 'Waiver Form Attachment');
                errorMessages.add(System.Label.ERR00096);
            }
        } catch (exception e) {
            //errorMessages.add(e.getMessage());
            return null;
        }
        return null;
    }

    /*Method to handle Compound max pay field visibility*/
    public pagereference showmaxpay() {
       //added by JR on 20/11/2014
       try{
        if (YES.equalsIgnoreCase(crd.Override_Standard_Compound_Max_Pay__c)){
         crd.Compound_Max_Pay__c =null;
         }
        return null;
    }catch(exception e){return null;}
    }

    /*Method to handle form attachment*/
    public pagereference attachRxWaiverDoc() {
        try {
            if (rxOtcWaiverFromAttachment != null) {
                upload(rxOtcWaiverFromAttachment, 'Rx/OTC Waiver form attachment');
                errorMessages.add(System.Label.ERR00096);
            }
        } catch (exception e) {
            //errorMessages.add(e.getMessage());
            return null;
        }
        return null;
    }
    /*Method to upload the file to the CRD*/
    public void upload(Attachment attachment, string namePrefix) {

        attachment.Name = system.today() + '_' + namePrefix + '_' + attachment.Name;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = crd.id; // the record the file is attached to
        attachment.IsPrivate = true;

        try {
            DATABASE.insert(attachment);
        } catch (DMLException e) {
            errorMessages.add(System.Label.ERR00082);
        }
    }
}