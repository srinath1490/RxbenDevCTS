/*Purpose: Apex Class for VFP_CRDPaperOptions Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 07/28/2011       Apex Class for VFP_CRDPaperOptions Page.
======================================================================== 
*/
public with sharing class VFP_CRDPaperOptionsController {
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
    public boolean isCostPanelSelected {
        get;
        set;
    }
    public VFP_CRDPaperOptionsController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        pageName = 'paperclaims';

        crd = [Select name, Y_Schd__c, Integrate_with_Medical__c, Plan_Type_Paper__c, In_Network_claims_are_reimbursed__c, Retail_Source_AWP__c, Out_of_Network_claims_are_reimbused__c, No_of_Days_to_file_a_claim__c, Prorate__c, Offshore__c, Discount_Rate__c, Out_of_Network_Cost_Sharing__c, Cost_Sharing_Amount__c, Type_of_Cost_Sharing__c, Apply_Retail_Copay__c, Insured_Type__c, In_Network_Discount_Rate__c, Out_of_Network_Discount_Rate__c, Bypass_DMR__c From CRD__c Where ID = : crdId];
        isCostPanelSelected = false;
        if (crd.Out_of_Network_Cost_Sharing__c != null && crd.Out_of_Network_Cost_Sharing__c == 'Yes') {
            isCostPanelSelected = true;
        }
    }

    Public PageReference redirectToPOSRebate() {
        try {
            if (crd.Plan_Type_Paper__c && crd.No_of_Days_to_file_a_claim__c == null) {
                crd.No_of_Days_to_file_a_claim__c.addError(system.Label.ERR00072);
                return null;
            }
            update crd;
        } catch (exception e) {


            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            return null;
        }
        if (crd.Insured_Type__c == 'Self Insured') {
            Pagereference pageRef = new Pagereference('/apex/VF_CRDPOSRebate?crdid=' + crdId);
            return pageRef;
        } else {
            Pagereference pageRef = new Pagereference('/apex/VF_CRDRxCheckJunction?crdid=' + crdId);
            return pageRef;
        }
    }

    Public PageReference redirectToCOB() {
        try {
            if (crd.Plan_Type_Paper__c && crd.No_of_Days_to_file_a_claim__c == null) {
                crd.No_of_Days_to_file_a_claim__c.addError(system.Label.ERR00072);
                return null;
            }


            update crd;
        } catch (exception e) {


            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());

            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_NewCobOptions?crdid=' + crdId);
        return pageRef;
    }
    Public Void Updatedays() {
        if ((crd.In_Network_claims_are_reimbursed__c == true || crd.Out_of_Network_claims_are_reimbused__c == true) && crd.No_of_Days_to_file_a_claim__c == Null) {
            crd.No_of_Days_to_file_a_claim__c = 730;
        }
    }
    public PageReference showPanel() {
        isCostPanelSelected = false;
        if (crd.Out_of_Network_Cost_Sharing__c != null && crd.Out_of_Network_Cost_Sharing__c == 'Yes') {
            isCostPanelSelected = true;
        } else {
            crd.Cost_Sharing_Amount__c = null;
            crd.Type_of_Cost_Sharing__c = null;
            crd.Apply_Retail_Copay__c = null;


        }
        return null;
    }

}