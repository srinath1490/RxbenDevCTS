/*

Purpose: Apex  Controller Class for VF_CRDIntegrationProcess

===============================================================================

History                                                            

-------------------------------------------------------------------------------

VERSION     AUTHOR                 DATE             DETAIL                                 

1.0         Abhishek               11/18/2013        Apex  Controller Class for VF_CRDIntegrationProcess
1.1         Joognu Rao              7/1/2014         Implemented request no 4931
===============================================================================

*/

public with sharing class VFP_CRDIntegrationProcessController {

  Public CRD__c crd {

        get;

        set;

    }

    public string crdId {

        get;

        set;

    }
    public CRDBuildOrder__c objCRDBuildOrder{
        get;
        set;
    }
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    private static final string EDITTRUE = 'BCTME';
    private static final string EDITFALSE = 'BCTNR';
    public String currentStatus{
        get;
        set;
    }
    

    //public List<case> lstAutomatedCases{get;set;}

    public VFP_CRDIntegrationProcessController(ApexPages.StandardController controller) {

        editMode = EDITFALSE;            //Added by Ayushi for next button story
        if(System.currentPagereference().getParameters().get('p1')==EDITTRUE)       //Added by Ayushi for next button story
            editMode=EDITTRUE;
        groupMember=System.currentPagereference().getParameters().get('p2');    //Added by Ayushi for next button story
        crdId = ApexPages.CurrentPage().getParameters().get('id');

        this.crd = (CRD__c) Controller.getRecord();

        crd = [Select Name, crd_Automated__c, Y_Schd__c, Override_Standard_Max_Pay__c, Max_Pay__c, Integrate_with_Medical__c, Aetna_Autofill__c, Plan_Type_Paper__c, Insured_Type__c

        From CRD__c Where ID = : crdId];

        //lstAutomatedCases=[select id,CaseNumber,MappedTimeStamped__c,CreatedDate,Status,CRD_ID__c, MappingRequestedBy__c from case where CRD_ID__c=:ApexPages.CurrentPage().getParameters().get('id') AND MappingRequestedBy__c!=null AND MappedTimeStamped__c!=null];
       //Added by JR to implemnt request no 4931
         for(CRDBuildOrder__c obj : [Select 
                                        CAG__c,CurrentStatusCRD__c,valid__c,complete__c,Case__c,Success_Case__c,CRD__c,CVS__c,FalloutCase__c,PDF__c,PERS__c,XML__c 
                                    From 
                                        CRDBuildOrder__c 
                                    Where 
                                        CRD__c = : crdId LIMIT 1]){
                                        
                    objCRDBuildOrder = obj;                 
                                        
        }
         
        if(objCRDBuildOrder!=null){ 
        system.debug('*****'+objCRDBuildOrder.CurrentStatusCRD__c);
             if(objCRDBuildOrder.CurrentStatusCRD__c==null){
                currentStatus ='CRD is yet to be validated';
                 
             }else{
             
             if(CRDBuildOrders__c.getValues(objCRDBuildOrder.CurrentStatusCRD__c)!=null){
                 CRDBuildOrders__c setting = CRDBuildOrders__c.getValues(objCRDBuildOrder.CurrentStatusCRD__c);
                    currentStatus = setting.Value__c;
                    
                 }
             }
        }else {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'No Crd Build Order record for this CRD'));
        }
        // Added by JR ends
         
    }
        
    // Method added by JR to implement request 04931
      public PageReference choiceYesToRemoveCRD() {
      system.debug('entered choice yes');
        try {
        
            crd.CRD_Automated__c = false;
            update crd;
            system.debug('automated false');
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            
        }
        return null;

    }

}