/**
 * Class Name: VFP_AHAProgramsController
 * Author: Accenture
 * Date: 18-Aug-2012
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <ACE2011>
 */
/*Purpose: Controller class of page VF_SafetyEditPrograms                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ                  10/28/2012       Controller class of page VF_AHAPrograms
   1.1 -    RISHABH               03/13/2013       removed commented code and formatted
   1.2 -    Joognu Rao            02/22/2014        for requirement no 4518
  ======================================================================== */
/**
     *Method :- VFP_AHAProgramsController
     *Description :- Controller class of page VF_AHAPrograms
**/
public with sharing class VFP_AHAProgramsController {
    //Variable initialization
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    Public List < AHA_Junction__c > ahaList {
        get;
        set;
    }
    Public Boolean isChanged {
        get;
        set;
    }
    //List to store drug lists related to AHA programs
    Public list < Drug_List__c > drugList;
    Public list < Drug_List__c > drugListSplitFill;
    
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING SPLITFILL = 'Split Fill';
    PRIVATE STATIC FINAL STRING EXPANDEDCUST = 'CareEngine Powered – Expanded Custom';
    PRIVATE STATIC FINAL STRING FOCUSEDCUST = 'CareEngine Powered – Focused Custom';
    PRIVATE STATIC FINAL STRING DRUGCLASS ='Drug Class Driven – Custom';
    PRIVATE STATIC FINAL STRING HEALTHACTIONS = 'Aetna Healthy Actions';
    PRIVATE STATIC FINAL STRING YESOPT = 'Yes';
    PRIVATE STATIC FINAL STRING AHOURL  = '/apex/VF_AHOPrograms?crdid=';
    PRIVATE STATIC FINAL STRING RXCHECKURL = '/apex/VF_CRDRxCheckJunction?crdid=';

    /* Constructor for the controller class */
    public VFP_AhaProgramsController(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        isChanged = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        this.crd = [Select Name, Y_Schd__c, Integrate_with_Medical__c, RxPlan_ID_Status__c, SAC_Letter_Templates__c, Pharmacy_Advisor__c, Disease_Vendor__c, End_Date__c, Custom_call_center_phone_number__c, PSP_Letter_Templates__c, Enrolled_in_PA_for_other_condition__c, Implementation_Type__c, Participate_in_CVS_mail_pharmacy_service__c, Disease_Management_Referral_Messaging__c, Disease_Management_Messaging_for__c, Is_DM_vendor_the_same_for_each_condition__c, Co_Brand_Initial_Program_Welcome_Mailing__c, Value_Generic__c, Aetna_Healthy_Actions__c, Tier_1_Copay_Reduction__c, Tier_2_Copay_Reduction__c, Tier_3_Copay_Reduction__c, Extra_Care_Health_Card__c, Plan_Platform__c, Plan_Type_Paper__c, Insured_Type__c, Tier_5_Copay_Reduction__c, Tier_4_Copay_Reduction__c, Offering_Type__c, Tier_1_Rx_Reduction__c, Tier_2_Rx_Reduction__c, Tier_3_Rx_Reduction__c, Tier_4_Rx_Reduction__c, Tier_5_Rx_Reduction__c, Asthma_Inhaled_Steroids__c, Asthma_Anti_Inflammatory_Agents__c, Diabetes_Anti_Diabetic_Agents__c, Diabetes_Anti_Diabetic_Agent_Supplies__c, Heart_Failure_Beta_Blockers__c, /*Hyperlipidemia_Statins__c, Hyperlipidemia_Lipid_Lowering_Agents__c, Hypertension_ACE_Inhibitors_ARBs__c, Hypertension_All_Anti_Hypertensives__c,*/ ARH_Offering_Type__c, Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/ Diabetes_Preventive__c, Asthma_Preventive__c, Aetna_Autofill__c From CRD__c Where ID = : crdId LIMIT 100000];
        ahaList = new List < AHA_Junction__c > ([Select Id,Name,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Drug_List_ID__r.Description__c, Drug_List_ID__c, Drug_List__c, Selected__c from AHA_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
    }

    /**
     * Method :- searchAHA
     * Description :- Method to search AHA based on the criteria entered by the USER i.e. offering type
     **/
    Public void searchAHA() {
       try{
        isChanged = true;
        ahaList = new List < AHA_Junction__c > ();
        //Added by Amit Jain for Request 4615
        if(crd.Offering_Type__c != SPLITFILL){
            crd.Tier_1_Copay_Reduction__c = Null;
            crd.Tier_2_Copay_Reduction__c = Null;
            crd.Tier_3_Copay_Reduction__c = Null;
            crd.Tier_4_Copay_Reduction__c = Null;
            crd.Tier_5_Copay_Reduction__c = Null;   
        }
        //**ends
        if (EXPANDEDCUST.equalsIgnoreCase(crd.Offering_Type__c) || FOCUSEDCUST.equalsIgnoreCase(crd.Offering_Type__c) || DRUGCLASS.equalsIgnoreCase(crd.Offering_Type__c)) {
            drugList = new List < Drug_List__c > ([select Id, Name, Drug_List_Name__c,Special_Use__c from Drug_List__c where Special_Use__c =: HEALTHACTIONS LIMIT 100000]);
            if (drugList.size() != 0) {
                for (Drug_List__c dlist: drugList) {
                        AHA_Junction__c aha = new AHA_Junction__c();
                        aha.Drug_List_ID__c = dlist.Id;
                        aha.Drug_List__c = dlist.Drug_List_Name__c;
                        aha.CRD_ID__c = crdId;
                        ahaList.add(aha);
                    
                }

            }
            // modified by JR for request no 4518   
        } else if (SPLITFILL.equalsIgnoreCase(crd.Offering_Type__c)) {
            crd.Tier_1_Copay_Reduction__c = 50.0;
            crd.Tier_2_Copay_Reduction__c = 50.0;
            crd.Tier_3_Copay_Reduction__c = 50.0;
            crd.Tier_4_Copay_Reduction__c = 50.0;
            crd.Tier_5_Copay_Reduction__c = 50.0;

            drugListSplitFill = new List < Drug_List__c > ([select Id, Name,Special_Use__c, Drug_List_Name__c from Drug_List__c where Special_Use__c =: SPLITFILL LIMIT 100000]);
            if (drugListSplitFill.size() != 0) {
                for (Drug_List__c dlists: drugListSplitFill) {
                    AHA_Junction__c aha = new AHA_Junction__c();
                    aha.Drug_List_ID__c = dlists.Id;
                    aha.Drug_List__c = dlists.Drug_List_Name__c;
                    aha.CRD_ID__c = crdId;
                    aha.Selected__c = true;
                    ahaList.add(aha);
                }
            }

        }
        else {
         //Nothing has to be done
        }
       }
      catch(exception e)
      {
        throw e;
      }  
    }
    
    /**
     * Method :- nextbutton
     * Description :- Method that is invoked on clicking the next button. All changes done on the VF page are committed to database and wizard moves on to the next page.
     **/
    Public Pagereference nextbutton() {
    
       
        Integer selected = 0;
        try {
            if (ahaList.size() != 0) {
                for (AHA_Junction__c aha: ahaList) {
                    if (aha.Selected__c) selected = selected + 1;
                }
            }
            if (isChanged) {
                List < AHA_Junction__c > deleteahaList = new List < AHA_Junction__c > ([Select Id, Drug_List_ID__c, Drug_List__c, Selected__c from AHA_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                    if (deleteahaList.size() != 0) database.delete(deleteahaList);
                if (selected >= 1) {
                if(YESOPT.equalsIgnoreCase(crd.Aetna_Healthy_Actions__c)){   
                    database.insert(ahaList);
                }    
                    database.update(crd);
                } else if (ahaList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            } else {
                if (selected >= 1) {
                if(YESOPT.equalsIgnoreCase(crd.Aetna_Healthy_Actions__c)){   
                    database.upsert(ahaList);
                }    
                    database.update(crd);
                } else if (ahaList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }

            }
            if (ApexPages.hasMessages()) {
                return null;
            } else {
                Pagereference pageRef = new Pagereference(AHOURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }
        } catch (exception e) {
            return null;
        }
    }

    /**
     * Method :- backbutton
     * Description :- method invoked on clicking the back button on the VF page. changes done on the page are committed to database.
     **/
    Public Pagereference backbutton() {
        Integer selected = 0;
        try {
            if (ahaList.size() != 0) {
                for (AHA_Junction__c aha: ahaList) {
                    if (aha.Selected__c) selected = selected + 1;
                }
            }
            if (isChanged) {
                List < AHA_Junction__c > deleteahaList = new List < AHA_Junction__c > ([Select Id, Drug_List_ID__c, Drug_List__c, Selected__c from AHA_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);           
                    if (deleteahaList.size() != 0) database.delete(deleteahaList);
                if (selected >= 1) {
                if(YESOPT.equalsIgnoreCase(crd.Aetna_Healthy_Actions__c)){   
                    database.insert(ahaList);
                }    
                    database.update(crd);
                } else if (ahaList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            } else {
                if (selected >= 1) {
                if(YESOPT.equalsIgnoreCase(crd.Aetna_Healthy_Actions__c)){   
                    database.upsert(ahaList);
                }    
                    database.update(crd);
                } else if (ahaList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }

            }
            if (ApexPages.hasMessages()) {
                return null;
            } else {
                Pagereference pageRef = new Pagereference(RXCHECKURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }
        } catch (exception e) {
            return null;
        }
    }
    
    /**
     * Method :- nextbutton2
     * Description :- Method that is invoked when user not in public group clicks on the next button. Changes done on the VF page are not saved and wizard moves on to the next page.
     **/
    Public Pagereference nextbutton2() {
       try {
        Pagereference pageRef = new Pagereference(AHOURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
       }
      catch(exception e)
      {
        return null;
      }  
    }    
    

/**
     * Method :- backbutton2
     * Description :- method invoked when a user not in public group clicks the back button on the VF page.
     **/
    Public Pagereference backbutton2() {
      try {  
        Pagereference pageRef = new Pagereference(RXCHECKURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
       }
       catch(exception e)
       {
         return null;
       }     
    }

}