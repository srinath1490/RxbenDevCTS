/*Purpose: Apex Class for VF_Formulary                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 30/09/2011       Apex Class for  VF_Formulary
   1.1 -    Anuj                 11/01/2012       Issue# 1352   
   1.2-     Anuj                 07/06/2012       Request Id 328
======================================================================== */
public with sharing class VFP_FormularyController {

    Public string formularyName {get;set;}
    Public string description {get;set;}
    Public Formulary__c formulary{get;set;}
    Public List<JunctionWrapper>  junctionList{get;set;}
    Public boolean validationflag{get;set;}
    Public boolean drugListValidation{get;set;}
    Public Integer  sequence;
    Public boolean messageFlag{get;set;}

    public VFP_FormularyController(ApexPages.StandardController controller) {
        sequence =1;
        formulary = new Formulary__c();
        junctionList = new List<JunctionWrapper>();
            sortList();

    }
    Public Pagereference customSave(){
        validationflag = false ;
        Set<Id> OptionIdSet = new Set<Id>();       
        Set<Id> formularyListSet = new set <Id>();
        date termdate = system.today();
        for(JunctionWrapper wrap: junctionList){
             if(wrap.formJunction.Effective_Date__c >=termdate){
                 termdate =wrap.formJunction.Termination_Date__c;
              }
             else{
                  validationflag = true ;
              }
             if(wrap.formJunction.Formulary_List__c ==null){
                  wrap.formJunction.Formulary_List__c.adderror(system.Label.ERR00070);
                  validationflag = true ;
             }else{
                 formularyListSet.add(wrap.formJunction.Formulary_List__c);
             }
        }
        //Commented by anuj on 07/06/2012 on request 328
      /*  if(formularyListSet.size() != 0){
            List<Formulary_List__c> tempFormularyList = new List<Formulary_List__c>([select Id,Name,Option_Code_Name__c,OptionCode__c from Formulary_List__c where  Id In: formularyListSet]);
            for(Formulary_List__c formList : tempFormularyList){
                OptionIdSet.add(formList.OptionCode__c);
            }            
            if(OptionIdSet.size() != 1){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00117);
                 ApexPages.addMessage(myMsg); 
             return null;   
            }
        }*/
        
       if(junctionList.size()>0){
            if(!validationflag ){
               GC_Validation_Methods objValidationCls = new GC_Validation_Methods();
                   drugListValidation = objValidationCls.validateFormularyList(formulary) ;
                  Insert formulary;
             List<Formulary_Junction__c> listFormulary = new List<Formulary_Junction__c>();
                for(JunctionWrapper forjunc : junctionList){
                    Formulary_Junction__c tempJunction = new Formulary_Junction__c();
                    tempJunction = forjunc.formJunction;
                    tempJunction.Formulary__c =formulary.Id;
                    listFormulary.add(tempJunction);
                }
                if(listFormulary.size()>0){
                   Insert listFormulary;
                 }      
                Pagereference pageRef = new  Pagereference('/'+formulary.Id);
                pageRef.setRedirect(true);
                return pageRef;
             }
             else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00118);
                ApexPages.addMessage(myMsg); 
                return null;  
             }
          }
        else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00119);
             ApexPages.addMessage(myMsg); 
             return null;
          }
     } 
            
    Public void sortList(){
        JunctionWrapper tempWrapper = new JunctionWrapper();
            tempWrapper.check = false;
            tempWrapper.formJunction.Priority__c = sequence;
            tempWrapper.formJunction.Effective_Date__c = system.today();
            tempWrapper.formJunction.Termination_Date__c = system.today();
            junctionList.add(tempWrapper);        
    }
    
    Public class JunctionWrapper{
    
        Public Formulary_Junction__c formJunction{get;set;}
        Public Boolean check{get;set;}
        Public JunctionWrapper()
        {
        formJunction = new Formulary_Junction__c();
        }
    }
    
    Public Pagereference redirectToSearch(){  
        Return Page.VF_SearchFormulary;
    }
    
    Public Pagereference addRow(){
       boolean  isValid = true ;
        For(JunctionWrapper wrap: junctionList){
          if(wrap.formJunction.Formulary_List__c ==null){
              wrap.formJunction.Formulary_List__c.adderror(system.Label.ERR00070);
              isValid = false ;
              }
        } 
        if(isValid){
        sequence =sequence+1;
        sortList();
        }
        return null;
    }
    
    Public Pagereference delRow(){
             Integer deletecount=0 ;
            if(junctionList.size()> 0){
                for(integer i=0;i< junctionList.size();i++){
                     if(junctionList[i].check == true){
                        junctionList.remove(i);
                         deletecount = deletecount+1;
                       }
                   } 
               }
            if(deletecount ==0)
               messageFlag = true;  
     return null;
  }
}