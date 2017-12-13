public with sharing class VFP_CRDCPStepTherapyController {
   
    public CRD__c crd{get;set;}
    public string crdId{get;set;}      
    public string pageName{get;set;}
    Public List<Step_Therapy_Option__c> stepTherapyOption;
    Public List<CRD_Step_Therapy_Junction__c> stepTherapyList {get;set;}
    Public boolean showfields{get;set;}
    Public Boolean isChanged{get;set;}
    Id saveACopayRtId;
    public VFP_CRDCPStepTherapyController(ApexPages.StandardController controller) {
         isChanged = false;  
         this.crd = (CRD__c)Controller.getRecord();
         crdId= ApexPages.CurrentPage().getParameters().get('crdid');     
         crd=[Select Id,Name,Integrate_with_Medical__c,Insured_Type__c,Account__c,National__c,Plan_Type_Paper__c,Do_you_want_to_do_Step_Therapy__c,State_associated_with_this_plan__c,Step_Therapy_TOC_days__c,Plan_Platform__c From  CRD__c Where ID =:crdId];    
        
        stepTherapyList =new List<CRD_Step_Therapy_Junction__c>([Select Id,Name,Step_Therapy_Drug_Class__c,Selected__c from CRD_Step_Therapy_Junction__c where CRD_ID__c =:crdId]);
        if(crd.Do_you_want_to_do_Step_Therapy__c =='yes'){
             showfields = true;}
        else{
               showfields = false;
           }
    }
    Public void searchStepTherapy(){
        isChanged = true;
        stepTherapyList = null;
        stepTherapyList = new List<CRD_Step_Therapy_Junction__c>(); 
        if(crd.Do_you_want_to_do_Step_Therapy__c == 'Yes'){
        showfields = true;
        stepTherapyOption = new List<Step_Therapy_Option__c>();
        system.debug('****State*****'+crd.State_associated_with_this_plan__c);
        String basequery ='select Id,Name,Step_Therapy_Option_Name__c,Funding__c,Account__c,Segment__c from Step_Therapy_Option__c where Inactive__c = false and Funding__c ='+ '\''+crd.Insured_Type__c+'\''+' and Segment__c includes ('+'\''+crd.National__c+'\''+') and State__c includes('+'\''+crd.State_associated_with_this_plan__c+'\''+') and Platform__c includes('+'\''+crd.Plan_Platform__c+'\''+')';
        basequery = basequery +' and (Account__c ='+ '\''+crd.Account__c+'\''+' Or Standard__c = true)'; 
    try{
    stepTherapyOption = database.query(basequery);
    }    
    catch(exception e){   
    }
    if(stepTherapyOption.size() !=0){
        for(Step_Therapy_Option__c  stOption:stepTherapyOption){
            CRD_Step_Therapy_Junction__c crdStepTherapy = new CRD_Step_Therapy_Junction__c();
            crdStepTherapy.Step_Therapy_Drug_Class__c =stOption.Step_Therapy_Option_Name__c;
            crdStepTherapy.CRD_ID__c = crdid;
            crdStepTherapy.Step_Therapy_Option__c = stOption.Id;
            stepTherapyList.add(crdStepTherapy);
        }
    }
    }else{
        showfields = false;
        crd.Step_Therapy_TOC_days__c = Null;
    }
    }
    Public Pagereference redirectToNetwork(){
      try{
       update crd;
       if(isChanged){
          List<CRD_Step_Therapy_Junction__c> DeletestepTherapyList = new List<CRD_Step_Therapy_Junction__c>([Select Id,Selected__c from CRD_Step_Therapy_Junction__c where CRD_ID__c =: crdid]);
            delete DeletestepTherapyList;
            }
            if(stepTherapyList.size()!=0){
                upsert stepTherapyList;
            }       
            Pagereference pageRef = new Pagereference('/apex/VF_CRDPharmacyNetwork?crdid='+crdId);
            return pageRef;
       }
      catch(exception e){
            return null;
      }
  }
      Public Pagereference redirectClinicalPrograme1(){
      try{
       update crd;
       if(isChanged){
          List<CRD_Step_Therapy_Junction__c> DeletestepTherapyList = new List<CRD_Step_Therapy_Junction__c>([Select Id,Selected__c from CRD_Step_Therapy_Junction__c where CRD_ID__c =: crdid]);
            delete DeletestepTherapyList;
            }
            if(stepTherapyList.size()!=0){
                upsert stepTherapyList;
            }       
            Pagereference pageRef = new Pagereference('/apex/VF_CRDClinicalProgStep1?crdid='+crdId);
            return pageRef;
       }
      catch(exception e){
            return null;
      }
  }

}