/*Purpose: Apex Class for Plan Step 3 for CRD Wizard.                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                08/05/2011       Apex Class for Plan Step 3 for CRD Wizard.        
======================================================================== */

public with sharing class VFP_CRDPlanStep2Controller {

    Public CRD__c crd{get;set;}
    Public String crdname{get;set;}
    public VFP_CRDPlanStep2Controller(ApexPages.StandardController controller) {
            this.crd = (CRD__c)Controller.getRecord();
            crd = [select Id,name,Plan_Platform__c,Standard_or_Custom_Plan__c,Plan_Type_Retail__c,Plan_Type_Mail__c,Plan_Type_Paper__c,Plan_Type_Specialty__c,National__c,Insured_Type__c from CRD__c where Id =:this.crd.Id];
            crdname = crd.name;
    }
        Public PageReference redirectToStep2(){
        update crd;
        Pagereference pageRef = new Pagereference('/apex/VF_NewCRDPlan_Step2?id='+crd.Id);
        return pageRef;
    }
    Public PageReference redirectToStep1(){
        Pagereference pageRef = new Pagereference('/apex/VF_NewCRDPlan_Step1?id='+crd.id);
        return pageRef;
    }
}