/**
 * Class Name: VFP_AetnaRxStepJunction
 * Author: Accenture
 * Date: 17-Feb-2014
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <04288>
 */
/*Purpose: Controller class of page VF_AetnaRxStepJunction                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Joognu Rao                  02/17/2014       Controller class of page VF_AetnaRxStepJunction
   2.0 -    Richa                       07/30/2014       Commented all Hypertension and Hyperlipidemia fields for Req4558  
  ======================================================================== */
public with sharing class VFP_AetnaRxStepJunction {
    //Variable initialization
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    Public List < Aetna_RxStep_Junction__c > lstRxStep {
        get;
        set;
    }
    Public Boolean isChanged {
        get;
        set;
    }
    public string groupMember{get;set;}
    public String editMode{get;set;}
    //List to store drug lists related to RxStepJunction programs
    Public list < Drug_List__c > drugList;
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING RXSTEP = 'Rx Step';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING PPA1URL = '/apex/VF_CRDClinicalProgPriorAuth1?id=';
    PRIVATE STATIC FINAL STRING STURL = '/apex/VF_CRDStepTherepy?crdid=';
    
/* Constructor for VFP_AetnaRxStepJunction */
    public VFP_AetnaRxStepJunction(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);  
        isChanged = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1); 
        this.crd = [Select Name, Y_Schd__c, Aetna_RxStep__c, Integrate_with_Medical__c, RxPlan_ID_Status__c,  Pharmacy_Advisor__c, Disease_Vendor__c, End_Date__c, Custom_call_center_phone_number__c, PSP_Letter_Templates__c, Enrolled_in_PA_for_other_condition__c, Implementation_Type__c, Participate_in_CVS_mail_pharmacy_service__c, Disease_Management_Referral_Messaging__c, Disease_Management_Messaging_for__c, Is_DM_vendor_the_same_for_each_condition__c, Co_Brand_Initial_Program_Welcome_Mailing__c, Value_Generic__c, Aetna_Healthy_Actions__c, Tier_1_Copay_Reduction__c, Tier_2_Copay_Reduction__c, Tier_3_Copay_Reduction__c, Extra_Care_Health_Card__c, Plan_Platform__c, Plan_Type_Paper__c, Insured_Type__c, Tier_5_Copay_Reduction__c, Tier_4_Copay_Reduction__c, Offering_Type__c, Tier_1_Rx_Reduction__c, Tier_2_Rx_Reduction__c, Tier_3_Rx_Reduction__c, Tier_4_Rx_Reduction__c, Tier_5_Rx_Reduction__c, Asthma_Inhaled_Steroids__c, Asthma_Anti_Inflammatory_Agents__c, Diabetes_Anti_Diabetic_Agents__c, Diabetes_Anti_Diabetic_Agent_Supplies__c, Heart_Failure_Beta_Blockers__c, /*Hyperlipidemia_Statins__c, Hyperlipidemia_Lipid_Lowering_Agents__c, Hypertension_ACE_Inhibitors_ARBs__c, Hypertension_All_Anti_Hypertensives__c,*/ ARH_Offering_Type__c, Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/ Diabetes_Preventive__c, Asthma_Preventive__c, Aetna_Autofill__c From CRD__c Where ID = : crdId LIMIT 80000];
        lstRxStep = new List < Aetna_RxStep_Junction__c > ([Select Id, CRD_Id__c, Drug_Lists__c, Selected__c, Drug_List__c from Aetna_RxStep_Junction__c where CRD_ID__c = : crdid LIMIT 80000]);
    }

    /**
     * Method :- clearFields
     * Description :- Method to reset the field values
     **/
    public PageReference clearFields() {
        try{
        for (Aetna_RxStep_Junction__c asr: lstRxStep) {
            asr.Selected__c = false;

        }
        Database.update(lstRxStep);
        return null;
        }
        catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    /**
     * Method :- searchRxStep
     * Description :- Method to display the drug list
     **/
    Public void searchRxStep() {
        
        try{
            isChanged = true;
        lstRxStep = new List < Aetna_RxStep_Junction__c > ();
        if (YES.equalsIgnoreCase(crd.Aetna_RxStep__c)) {
            drugList = new List < Drug_List__c > ([select Id, Name, Drug_List_Name__c from Drug_List__c where Special_Use__c =: RXSTEP Limit : limits.getLimitQueryRows()]);
            if (drugList.size() != 0) {
                for (Drug_List__c dlist: drugList) {
                    Aetna_RxStep_Junction__c aha = new Aetna_RxStep_Junction__c();
                    aha.Drug_List__c = dlist.id;
                    aha.CRD_ID__c = crdId;
                    aha.Drug_Lists__c = dlist.Drug_List_Name__c;
                    lstRxStep.add(aha);
                }
            }

        }
        }
        catch (exception e) {
            ApexPages.addMessages(e);
        }
    }
    /**
     * Method :- Next2
     * Description :- Redirects to the next screen for ReadOnly Mode
     **/
     Public PageReference next2(){
         try{
             PageReference pageRef = new Pagereference(PPA1URL + crd.Id);
         pageRef.getParameters().put(EDITMODEPARAM,editMode);
         pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
         return pageRef;
         }catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
     }
    /**
     * Method :- Next
     * Description :- Redirects to the next screen 
     **/

    Public Pagereference next() {
        Integer selected = 0;
        Pagereference pageRef;
        try {
            if (lstRxStep.size() != 0) {
                for (Aetna_RxStep_Junction__c aha: lstRxStep) {
                    if (aha.Selected__c) {selected = selected + 1;}
                }
            }
            if (isChanged) {
                List < Aetna_RxStep_Junction__c > deleteRxStepList = new List < Aetna_RxStep_Junction__c > ([Select Id, Drug_Lists__c, Drug_List__c, CRD_Id__c, Selected__c from Aetna_RxStep_Junction__c where CRD_Id__c = : crdid LIMIT 80000]);
                if (deleteRxStepList.size() != 0){ delete deleteRxStepList;}
                if (selected >= 1) {
                    Database.insert(lstRxStep);
                    database.update(crd);
                } else if (lstRxStep.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137));
                }
            } else {
                if (selected >= 1) {
                    Database.upsert(lstRxStep);
                    database.update(crd);
                } else if (lstRxStep.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137));
                }

            }
            if (! ApexPages.hasMessages()) {
                 pageRef = new Pagereference(PPA1URL + crd.Id);
            }
        } catch (exception e) {
            ApexPages.addMessages(e);
        }
         pageRef.getParameters().put(EDITMODEPARAM,editMode);
         pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
         return pageRef;
         
    }
    /**
     * Method :- Back2
     * Description :- Redirects to the previous screen for ReadOnly Mode
     **/
     Public Pagereference back2(){
        Try{    
        Pagereference pageRef = new Pagereference(STURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
        }
        catch (exception e) {
            ApexPages.addMessages(e);
            return null;
        }
     }
    /**
     * Method :- Back
     * Description :- Redirects to the previous screen 
     **/

    Public Pagereference back() {
        Integer selected = 0;
        try {
            if (lstRxStep.size() != 0) {
                for (Aetna_RxStep_Junction__c aha: lstRxStep) {
                    if (aha.Selected__c) {selected = selected + 1;}
                }
            }
            if (isChanged) {
                List < Aetna_RxStep_Junction__c > deleteahaList = new List < Aetna_RxStep_Junction__c > ([Select Id, Drug_List__c, Drug_Lists__c, CRD_ID__c, Selected__c from Aetna_RxStep_Junction__c where CRD_ID__c = : crdid LIMIT 80000]);
                if (deleteahaList.size() != 0){ delete deleteahaList;}
                if (selected >= 1) {
                    database.insert(lstRxStep);
                    database.update(crd);
                } else if (lstRxStep.size() == 0) {
                    database.update(crd);
                } else {
                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137));
                    return null;
                }
            } else {
                if (selected >= 1) {
                    Database.upsert(lstRxStep);
                    database.update(crd);
                } else if (lstRxStep.size() == 0) {
                    database.update(crd);
                } else {
                   
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137));
                    return null;
                }

            }
            if (!ApexPages.hasMessages()) {       
                Pagereference pageRef = new Pagereference(STURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }
        } catch (exception e) {
           
        return null;
        }
        return null;
    }
}