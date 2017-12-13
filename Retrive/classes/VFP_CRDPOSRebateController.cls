/*Purpose: Apex Class for VFP_CRDPOSRebat Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 8/2/2011       Apex Class for VFP_CRDPOSRebat Page.
======================================================================== 
*/
public with sharing class VFP_CRDPOSRebateController {
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
    public boolean isPosPanelSelected {
        get;
        set;
    }
    public VFP_CRDPOSRebateController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        this.crd = [Select Name, Y_Schd__c, Integrate_with_Medical__c, POS_Rebate_for_Plan__c, RTMD_Effective_Date__c, RTMD_Client_Share_Percent__c, Plan_Type_Paper__c, Insured_Type__c From CRD__c Where ID = : crdId];
        pageName = 'posrebate';
        isPosPanelSelected = false;
        if (crd.POS_Rebate_for_Plan__c != null && crd.POS_Rebate_for_Plan__c == 'Yes') {
            isPosPanelSelected = true;
        }
    }
    Public PageReference redirectToRxCheck() {
        try {
            update crd;
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00107);
            ApexPages.addMessage(myMsg);
            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_CRDRxCheckJunction?crdid=' + crdId);
        return pageRef;
    }

    Public PageReference redirectToReporting() {
        try {
            update crd;
        } catch (exception e) {
            return null;
        }
        if (crd.Plan_Type_Paper__c) {
            Pagereference pageRef = new Pagereference('/apex/VF_CRDPaperOptions?crdid=' + crdId);
            return pageRef;

        } else {

            Pagereference pageRef = new Pagereference('/apex/VF_NewCobOptions?crdid=' + crdId);
            return pageRef;
        }
    }
    public PageReference showPanel() {
        isPosPanelSelected = false;
        if (crd.POS_Rebate_for_Plan__c != null && crd.POS_Rebate_for_Plan__c == 'Yes') {
            isPosPanelSelected = true;
            crd.RTMD_Modulator_Percent__c = 100;
            crd.Specialty_Exclusion_Flag__c = 'N = include';
            crd.RTMD_Admin_Fee_basis__c = 'per claim';
            crd.RTMD_Admin_Fee_rate__c = 0;
        } else {
            crd.RTMD_Effective_Date__c = null;
            crd.RTMD_Client_Share_Percent__c = null;
            crd.RTMD_Modulator_Percent__c = null;
            crd.Specialty_Exclusion_Flag__c = null;
            crd.RTMD_Admin_Fee_basis__c = null;
            crd.RTMD_Admin_Fee_rate__c = null;
        }
        return null;
    }
}