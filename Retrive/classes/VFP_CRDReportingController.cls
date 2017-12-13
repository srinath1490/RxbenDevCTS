/*Purpose: Apex Class for VFP_CRDReporting Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Sourabh                 08/5/2011       Apex Class for VFP_CRDReporting Page .
======================================================================== 
*/
public with sharing class VFP_CRDReportingController {

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
    public boolean isRdsPanelSelected {
        get;
        set;
    }
    public VFP_CRDReportingController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        this.crd = [Select Name, Y_Schd__c, RxPlan_ID_Status__c, Plan_Type_Paper__c, Integrate_with_Medical__c, Insured_Type__c, CM_submits_ongoing_monthly_files_to_RDS__c, Caremark_submit_IRL_files_to_RDS__c, RDS__c, Application_ID__c, UBOI_ID__c, Year__c, RDS_Effective_Date__c, Group_submits_Cost_Reporting__c, RDS_Termination_Date__c, CVS_submits_cost_reporting_to_Aetna__c, Group_submits_eligibility_file__c, Reporting_Frequency__c, Drug_List_Option__c, CVS_submits_eligibility_file_to_Aetna__c From CRD__c Where ID = : crdId];
        pageName = 'reporting';
        if (crd.RDS__c == 'Yes') {
            isRdsPanelSelected = true;
        } else {
            isRdsPanelSelected = false;
        }
    }
    public PageReference showPanel() {
        if (crd.RDS__c == 'Yes') {
            isRdsPanelSelected = true;
        } else {
            isRdsPanelSelected = false;
            crd.Application_ID__c = null;
            crd.UBOI_ID__c = null;
            crd.Year__c = null;
            crd.RDS_Effective_Date__c = null;
            crd.RDS_Termination_Date__c = null;
            crd.CVS_submits_eligibility_file_to_Aetna__c = null;
            crd.Group_submits_eligibility_file__c = null;
            crd.CVS_submits_cost_reporting_to_Aetna__c = null;
            crd.Group_submits_Cost_Reporting__c = null;
            crd.Reporting_Frequency__c = null;
            crd.Caremark_submit_IRL_files_to_RDS__c = null;
            crd.CM_submits_ongoing_monthly_files_to_RDS__c = null;
            crd.Drug_List_Option__c = null;
        }
        system.debug('------------------------isRdsPanelSelected-----' + isRdsPanelSelected);
        return null;
    }
    Public PageReference redirectToCOB() {
        try {
            update crd;
        } catch (exception e) {
            //crd.addError('There was a problem updating the accounts');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, e.getMessage());

            ApexPages.addMessage(myMsg);

            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_NewCobOptions?crdid=' + crdId);
        return pageRef;
    }

    Public PageReference redirectToFinalStep() {
        try {
            update crd;
        } catch (exception e) {
            //crd.addError('There was a problem updating the accounts');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00110);

            ApexPages.addMessage(myMsg);
            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_CRDCompleteProcess?crdid=' + crdId);
        return pageRef;
    }

}