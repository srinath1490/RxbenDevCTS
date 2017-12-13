/*Purpose: Apex Class for Plan Step 2 for CRD Wizard.                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                08/05/2011       Apex Class for Plan Step 2 for CRD Wizard. 
   2.0 -    Sourabh              06/01/2012       Issue 1271           
======================================================================== */

public with sharing class VFP_CRDStep2Controller {

    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }

    Public String crdname;
    public VFP_CRDStep2Controller(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        crd = [select Id, Y_Schd__c, Standard_or_Custom_Plan__c, State_associated_with_this_plan__c, name, Are_you_creating_a_Package_Plan__c, Medical_Injectible_Claim_Denial_Process__c, Effective_Start_Date__c, Plan_Platform__c, Plan_Extract_Date__c, RxPlan_ID_Status__c, Integrate_with_Medical__c,Waive_Deductible_for_Tier_1_Drugs__c,/*DED_Waive_Preferred_Generic_IN__c,DED_Waive_Preferred_Generic_OON__c,*/ Medicaid__c, Insured_Type__c, Plan_Type_Paper__c, Brand_Penalty_Exception__c, Tiering_Formulary_Exception__c, Global_Benefit_Exclusion__c from CRD__c where Id = : this.crd.Id];
        crdname = crd.name;
        crdId = crd.id;
    }

    // Flag to check the profile is equal to BCT Consultant and hide the field Last BPE Date
    Public boolean getHideForBCTC() {
        boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId()].Profile.Name;
        if (usrProfileName == 'BCT Consultant') {
            check = false;
        } else {
            check = true;
        }
        return check;
    }

    Public PageReference redirectToStep1a() {
   /* if(crd.Chronic_and_or_Preventive_List__c == 'Chronic'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT17;
    }
    if(crd.Chronic_and_or_Preventive_List__c == 'Preventive'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT19;
    }
    if(crd.Chronic_and_or_Preventive_List__c == 'Both'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT18;
    }*/
    
  /*  if(crd.Is_this_an_HDHP_Plan__c == 'Yes'){
    if(crd.What_is_the_HDHP_fund_type__c == Null || crd.Chronic_and_or_Preventive_List__c == Null || crd.Waiver_of_Rx_Deductible__c == Null ){
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00189);
     ApexPages.addMessage(myMsg);
      return null;
    }
    }*/
    
    
        update crd;
        Pagereference pageRef = new Pagereference('/apex/VF_NewCRDPlan_Step1?id=' + crd.Id);
        return pageRef;
    }


    Public PageReference redirectToClientInfo() {
        try {
   /*     if(crd.Chronic_and_or_Preventive_List__c == 'Chronic'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT17;
    }
    if(crd.Chronic_and_or_Preventive_List__c == 'Preventive'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT19;
    }
    if(crd.Chronic_and_or_Preventive_List__c == 'Both'){
    crd.Chronic_Preventive_Drug_List__c = system.label.DCSRT18;
    }*/
 /*   if(crd.Is_this_an_HDHP_Plan__c == 'Yes'){
    if(crd.What_is_the_HDHP_fund_type__c == Null || crd.Chronic_and_or_Preventive_List__c == Null || crd.Waiver_of_Rx_Deductible__c == Null ){
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00189);
     ApexPages.addMessage(myMsg);
      return null;
    }
    }*/

            update crd;
        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }

        Pagereference pageRef = new Pagereference('/apex/VF_NewCRDPlan_Step3?id=' + crd.id);
        return pageRef;

    }
}