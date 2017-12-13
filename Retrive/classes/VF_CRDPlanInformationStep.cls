/*Purpose: Apex Class for Plan Information Screen on CRD Wizard.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                07/07/2011       Apex Class for Plan Information Screen on CRD Wizard
   1.1 -    Rishabh              02/26/2013       added Retail Y-Schedule to be displayed on page.
======================================================================== */

public with sharing class VF_CRDPlanInformationStep {
    Public CRD__c crd{
        get;set;
    }
    public string crdId{
        get;set;
    }
    public string pageName{
        get;set;
    }
    public VF_CRDPlanInformationStep(ApexPages.StandardController controller) {
        this.crd = (CRD__c)Controller.getRecord();
        crdId= ApexPages.CurrentPage().getParameters().get('id');
        if(crdId!=null){
            crd=[Select Name,Status__c,Custom_Network_Flag__c,owner.name,Integrate_with_Medical__c,RxPlan_ID_Status__c,Are_you_creating_a_Package_Plan__c,
                Plan_Type_Paper__c,Insured_Type__c, Y_Schd__c, Pricing_Schedule__c, Mail_Y_Schedule__c From CRD__c Where id =:this.crd.id];
            crdId=crd.id;
        }
        pageName='home';
    }
   public PageReference redirectToStep1() {
        try {
          
           
                    if (crdId != null) {
                    	//Done by Rahul Nasa on 7/3/2013 as per the change requested by Ryan
                         if (crd.Are_you_creating_a_Package_Plan__c == 'Yes' && crd.Y_Schd__c == NULL) {
                            crd.Y_Schd__c = 'Y4';
                        }
                        crd.Pricing_Schedule__c = crd.Y_Schd__c;
                        crd.Mail_Y_Schedule__c = 'Y6';
                        update crd;
                    } else {
                        if (crd.Are_you_creating_a_Package_Plan__c == 'Yes') {
                            crd.Y_Schd__c = 'Y4';
                        }
                        crd.Pricing_Schedule__c = crd.Y_Schd__c;
                        crd.Mail_Y_Schedule__c = 'Y6';
                        insert crd;
                            }
                
            }
         catch (exception e) {
            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_NewCRDPlan_Step1?id=' + crd.Id);
        return pageRef;
    }
}