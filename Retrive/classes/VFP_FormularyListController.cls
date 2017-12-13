/*Purpose: Apex Class for VFP_FormularyList Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 07/12/2011       Apex Class for VFP_FormularyList Page.
     2.0     Amit                 24 Feb 2014      Added Comments
======================================================================== 
*/
public with sharing class VFP_FormularyListController {

    Public string formularyName {get;set;}
    Public string description {get;set;}
    Public List<JunctionWrapper>  junctionList{get;set;}
    Public string listValue{get;set;}  
    Public boolean validation;    
    Public Formulary_List__c formularyList{get;set;}
    Integer sequence;

    /**
    * Method :- Constructor: VFP_FormularyListController(ApexPages.StandardController controller)
    * Description :- 
    **/     
    public VFP_FormularyListController(ApexPages.StandardController controller) {          
           formularyList = new Formulary_List__c();
           sequence =1;
           junctionList = new List<JunctionWrapper>();
           sortList();
    }

    /**
    * Method :- addRow()
    * Description :- The method is used to add a row
    **/      
    Public Pagereference addrow(){
       Boolean isValid = true;
       /* for(JunctionWrapper forjunc : junctionList){
         if(forjunc.listEntry.GPI__c ==Null || forjunc.listEntry.GPI__c ==''){
                forjunc.listEntry.GPI__c.adderror(system.Label.ERR00070);
                 isValid = false;
                  }
         }*/
         //if(isValid){
            sequence = sequence+1;
            sortList();
         //}
        return null;
    }

    /**
    * Method :- saveFormularyList()
    * Description :- The method is used to validate and insert the Formulary List Entry records
    **/    
    public Pagereference saveFormularyList(){
    Savepoint sp = Database.setSavepoint(); 
        Boolean isValid = true;
        Formulary_List__c  tempFormList=new Formulary_List__c ();
        tempFormList = formularyList.clone(false);
          List<Formulary_List_Entry__c> formularyListEntry = new List<Formulary_List_Entry__c>();
          if(junctionList.size()>0){
              for(JunctionWrapper forjunc : junctionList){
                  Formulary_List_Entry__c tempJunction = new Formulary_List_Entry__c();
                  tempJunction = forjunc.listEntry ;
                  formularyListEntry.add(forjunc.listEntry);
                  /*if(forjunc.listEntry.GPI__c ==Null || forjunc.listEntry.GPI__c ==''){
                      forjunc.listEntry.GPI__c.adderror(system.Label.ERR00070);
                      isValid = false;
                  }*/
              }

              GC_Validation_Methods objValidationCls = new GC_Validation_Methods();
              //if(isValid){
              validation = objValidationCls.validateFormularyListMsCode(formularyListEntry); 
             if(validation){
             try{
              
                 insert tempFormList;  
                // List<Formulary_List_Entry__c > temEntryList= new List<Formulary_List_Entry__c >();       
                 for(Formulary_List_Entry__c listEntry: formularyListEntry){
                     listEntry.Formulary_List__c = tempFormList.Id;
                 }
                 Insert formularyListEntry ;
                
                     Pagereference pageRef = new  Pagereference('/'+tempFormList.Id);
                     pageRef.setRedirect(true);
                     return pageRef; 
             }catch(Exception e){
               //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
               //ApexPages.addMessage(myMsg);
               
               Database.rollback(sp);
              tempFormList = new  Formulary_List__c();
               return null;
             }    
             }
             else{
                 for(String  message:objValidationCls.errorMessages){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,message);
                        ApexPages.addMessage(myMsg);
                    }
             return null;
          }
          //}
          //else{
          //return null;
          //}
         

         }else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00120);
               ApexPages.addMessage(myMsg);
             return null;
         }   
    }

    /**
    * Method :- redirectToSearch()
    * Description :- The method is used to redirect uset to VF_SearchFormularyList page
    **/    
    public Pagereference redirectToSearch(){
        Return Page.VF_SearchFormularyList;
    }

    /**
    * Method :- deleteRow()
    * Description :- The method is used to delete the selected row
    **/ 
    Public Pagereference deleteRow(){
        list<JunctionWrapper> tempList= new List<JunctionWrapper>();
        for(JunctionWrapper wrapper: junctionList){
            if(wrapper.check==false){
                  tempList.add(wrapper);  
            }
        }
        junctionList.clear();
        junctionList.addAll(tempList);
        return null;
    }

    /**
    * Method :- sortList()
    * Description :- The method is used to set the particular field values in wrapper
    **/     
    Public void sortList(){
        JunctionWrapper tempWrapper = new JunctionWrapper();
                tempWrapper.check = false;
                tempWrapper.listEntry.Effective_Date__c = system.today();
                tempWrapper.listEntry.Termination_Date__c = system.today();
                junctionList.add(tempWrapper);        
    }

    Public class JunctionWrapper{   
        Public Formulary_List_Entry__c listEntry{get;set;}
        Public boolean check{get;set;}
        Public JunctionWrapper(){
            listEntry = new Formulary_List_Entry__c();
            listEntry.MS_Code_M__c = true;
            listEntry.MS_Code_N__c = true;
            listEntry.MS_Code_O__c = true;
            listEntry.MS_Code_Y__c = true;
            
        }
    }
}