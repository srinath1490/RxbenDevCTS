/*Purpose: Apex Class for VFP_CRDCob Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 07/25/2011       Apex Class for VFP_CRDCob Page.
======================================================================== 
*/
public with sharing class VFP_CRDCobController {
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
    Public Boolean showCOBorMOB {
        get;
        set;
    }
    Public Boolean showCobFields {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public VFP_CRDCobController(ApexPages.StandardController controller) {
        showCOBorMOB = false;
        showCobFields = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        crd = [Select Name, Y_Schd__c, Insured_Type__c, Integrate_with_Medical__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, Durg_Specific_Stepped_Count__c, Drug_Specific_copay_count__c, Process_Point_of_Sales_COB__c, In_Network__c, Out_of_Network_Cost_Sharing__c, Reimbursement_Levels__c, In_Network_Reimbursement_Level__c, Out_of_Network__c, Out_of_Network_Reimbursement_Level__c, Does_the_client_want_to_do_COB__c, COB_or_MOB__c, Plan_Type_Paper__c From CRD__c Where ID = : crdId];
        if (crd.Does_the_client_want_to_do_COB__c == 'Yes') showCOBorMOB = true;
        if (crd.COB_or_MOB__c == 'COB') showCobFields = true;
        pageName = ApexPages.CurrentPage().getParameters().get('currentPageName');
        errorMessages = new list < String > ();
    }
    Public PageReference redirectToPos() {
        errorMessages.clear();
        try {
            if (crd.COB_or_MOB__c != null && crd.COB_or_MOB__c == 'COB') {
                if (crd.Process_Point_of_Sales_COB__c == false && crd.In_Network__c == false && crd.Out_of_Network__c == false) {
                    errorMessages.add(system.Label.ERR00084);
                    return null;
                }
            }
            if (crd.Does_the_client_want_to_do_COB__c != null && crd.Does_the_client_want_to_do_COB__c == 'No') {
                crd.Process_Point_of_Sales_COB__c = false;
                crd.Reimbursement_Levels__c = null;
                crd.In_Network__c = false;
                crd.In_Network_Reimbursement_Level__c = null;
                crd.Out_of_Network__c = false;
                crd.Out_of_Network_Reimbursement_Level__c = null;
            }
            update crd;
            if (crd.Plan_Type_Paper__c) {
                Pagereference pageRef = new Pagereference('/apex/VF_CRDPaperOptions?crdid=' + crdId);
                return pageRef;

            } else if (crd.Insured_Type__c == 'Self Insured') {
                Pagereference pageRef = new Pagereference('/apex/VF_CRDPOSRebate?crdid=' + crd.Id);
                return pageRef;
            } else {
                Pagereference pageRef = new Pagereference('/apex/VF_CRDRxCheckJunction?crdid=' + crdId);
                return pageRef;
            }
        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            return null;
        }

    }
    public PageReference redirectToRDS() {
        errorMessages.clear();
        try {
            if (crd.COB_or_MOB__c != null && crd.COB_or_MOB__c == 'COB') {
                if (crd.Process_Point_of_Sales_COB__c == false && crd.In_Network__c == false && crd.Out_of_Network__c == false) {
                    errorMessages.add(system.Label.ERR00084);
                    return null;
                }
            }
            if (crd.Does_the_client_want_to_do_COB__c != null && crd.Does_the_client_want_to_do_COB__c == 'No') {
                crd.Process_Point_of_Sales_COB__c = false;
                crd.Reimbursement_Levels__c = null;
                crd.In_Network__c = false;
                crd.In_Network_Reimbursement_Level__c = null;
                crd.Out_of_Network__c = false;
                crd.Out_of_Network_Reimbursement_Level__c = null;
                crd.Process_Point_of_Sales_COB__c = false;
            }
            update crd;
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_CRDReporting?crdid=' + crdId);
        return pageRef;

    }

    public void showCobFields() {
        showCobFields = false;
        if (crd.COB_or_MOB__c == 'COB') {
            showCobFields = true;
        } else {
            showCobFields = false;
            crd.Reimbursement_Levels__c = null;
            crd.In_Network__c = false;
            crd.In_Network_Reimbursement_Level__c = null;
            crd.Out_of_Network__c = false;
            crd.Out_of_Network_Reimbursement_Level__c = null;
            crd.Process_Point_of_Sales_COB__c = false;
        }
    }
    Public void showCOBorMOB() {
        showCOBorMOB = false;
        if (crd.Does_the_client_want_to_do_COB__c == 'Yes') {
            showCOBorMOB = true;
        } else {
            showCOBorMOB = false;
            showCobFields = false;
            crd.COB_or_MOB__c = null;
            crd.Reimbursement_Levels__c = null;
            crd.In_Network__c = false;
            crd.In_Network_Reimbursement_Level__c = null;
            crd.Out_of_Network__c = false;
            crd.Out_of_Network_Reimbursement_Level__c = null;
            crd.Process_Point_of_Sales_COB__c = false;
        }
    }
    Public void outofNetwork() {
        if (crd.Out_of_Network__c = true) crd.Out_of_Network_Reimbursement_Level__c = '100% submitted charges less copay';
    }
}