/*Purpose: Apex Class for VFP_DrugList Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 07/06/2011       Apex Class for VFP_DrugList Page.
======================================================================== 
*/
public with sharing class VFP_DrugListController {


    Public List<Drug_List_Criteria__c> wrapList{get;set;}
    public integer TotalCriteria{set;get;}
    List<Drug_List_Criteria__c> CriteriaList = new List<Drug_List_Criteria__c>();
    Public List<wrapperclass> drugcriterialist{get;set;}
    Public boolean messageFlag{get;set;} 
    Public boolean isSpecialUseSet{get;set;} 
    Public Boolean validationflag;
    Public boolean showUnitCost{get;set;}
    Public Drug_List__c DrugList{get;set;}   
    Public boolean dateValidation;
    Public boolean drugListValidation;
    Id drugListRtId ;
    Id drugCriteriaRtId ;
    Id priorAuthRtId ;
    Id priorCriteriaRtId; 
    Id quantLimitRtId ;
    Id quantCriteriaRtId; 
    
    public VFP_DrugListController(ApexPages.StandardController controller) {
       
        List<Schema.RecordTypeInfo> drugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
        List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List_Criteria__c.sObjectType.getDescribe().getRecordTypeInfos();
            for(Schema.Recordtypeinfo thisInfo : drugListRtInfo)
        {            
            if(thisInfo.Name == 'Drug List')
                {
                drugListRtId = thisInfo.getRecordTypeId();
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+drugListRtId);
                }
           if(thisInfo.Name == 'Prior Authorization')
               {
                priorAuthRtId  = thisInfo.getRecordTypeId();
               }
           if(thisInfo.Name == 'Quantity Limit')
               {
                quantLimitRtId = thisInfo.getRecordTypeId();
               }        
               
           }
        for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo)
        {
            
            if(thisInfo.Name == 'Drug List')
                {
                drugCriteriaRtId = thisInfo.getRecordTypeId();
                }
           if(thisInfo.Name == 'Prior Authorization')
               {
                priorCriteriaRtId = thisInfo.getRecordTypeId();
               }
           if(thisInfo.Name == 'Quantity Limit')
               {
                quantCriteriaRtId = thisInfo.getRecordTypeId();
               }        
               
           }
            this.DrugList=(Drug_List__c)Controller.getRecord();
            messageFlag = false;
            if(DrugList.Special_Use__c !=Null){
                showUnitCost = true;                
                }
            else{
                showUnitCost = false; 
            }    
            TotalCriteria =0;
           
            wrapList = new List<Drug_List_Criteria__c>();
            drugcriterialist = new List<wrapperclass>(); 
           // sortList();
    }
    
    Public Pagereference addCriteria(){
         system.debug('*********wraplist*******'+wrapList.size());
         system.debug('*********Unitcost*******'+showUnitCost);
        boolean isValid = true; 
                  for(wrapperclass wrap: drugcriterialist){
           if(wrap.criterialist.Drug_Type_Code__c == null){
              wrap.criterialist.Drug_Type_Code__c.adderror(system.Label.ERR00070);
              isValid = false ;
          }
          if(wrap.criterialist.Status__c==null){                 
              wrap.criterialist.Status__c.adderror(system.Label.ERR00070);                
              isValid = false ;           
           }            
           if(wrap.criterialist.Drug_Code_Value__c==null){                
               wrap.criterialist.Drug_Code_Value__c.adderror(system.Label.ERR00070);                
               isValid = false ;            
           }
        }
        if(isValid){
          TotalCriteria = TotalCriteria+1;
           sortList();          
           messageFlag= false;
         }  
         Return null;
    }
    Public Pagereference CustomSave(){
        GC_Validation_Methods objValidationCls = new GC_Validation_Methods();
        drugListValidation = objValidationCls.validateDrugList(DrugList) ;
        if(drugListValidation){
         boolean isValid = objValidationCls.validateNDC(drugcriterialist);
         if(DrugList.Drug_List_Name__c ==null){
             isValid = false ;
             DrugList.Drug_List_Name__c.adderror(system.Label.ERR00070); 
         }
         if(DrugList.Description__c==null){
             isValid = false ;
            DrugList.Description__c.adderror(system.Label.ERR00070); 
         }
         for(wrapperclass wrap: drugcriterialist){
           if(wrap.criterialist.Drug_Type_Code__c == null){
              wrap.criterialist.Drug_Type_Code__c.adderror(system.Label.ERR00070);
              isValid = false ;
          }
          if(wrap.criterialist.Status__c==null){                 
              wrap.criterialist.Status__c.adderror(system.Label.ERR00070);                
              isValid = false ;           
           }            
           if(wrap.criterialist.Drug_Code_Value__c==null){                
               wrap.criterialist.Drug_Code_Value__c.adderror(system.Label.ERR00070);                
               isValid = false ;            
           }
        }
        if(!isValid){
            for(String  message:objValidationCls.errorMessages){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,message);
                ApexPages.addMessage(myMsg);
            }
             
            return null;
        }
        List<Drug_List_Criteria__c> sortedDlcList = new List<Drug_List_Criteria__c>();
        List<Drug_List_Criteria__c> dlcList = new List<Drug_List_Criteria__c>();
         for(wrapperclass wrap: drugcriterialist){
            dlcList.add(wrap.criterialist);
        }
        sortedDlcList = GC_Utils_Method.merge_sort(dlcList);
        dateValidation = objValidationCls.dateRangeValid(sortedDlcList);
        dlcList.clear();
        sortedDlcList.clear ();
        validationflag = false ;

        set<Decimal> seqlist = new set<Decimal>();

        /* For(wrapperclass wrap: drugcriterialist){
             seqlist.add(wrap.criterialist.Sequence__c);
            }
            
            if(seqlist.size() != drugcriterialist.size()){
               validationflag = true ;
            }*/
            if(drugcriterialist.size()>0){
              if(dateValidation){                
                List<Drug_List_Criteria__c> CriteriaList = new List<Drug_List_Criteria__c>();
                DrugList.RecordTypeId =drugListRtId;
                insert DrugList; 
                For(wrapperclass wrap: drugcriterialist){            
                    wrap.criterialist.Drug_List__c=DrugList.Id;
                    wrap.criterialist.RecordTypeId =drugCriteriaRtId;
                    CriteriaList.add(wrap.criterialist);                               

                }
                if(CriteriaList.size() !=0 ){
                    insert CriteriaList ;
                }
                PageReference pageRef = new PageReference('/'+DrugList.Id);  
                pageRef.setRedirect(true);
                return  pageRef ;
               }
           else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Please check, Date range of one critera is overlapping with another');
               ApexPages.addMessage(myMsg); 
               return null;
              }
          }   
       else{    
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Please create atleast one criteria');
             ApexPages.addMessage(myMsg); 
             return null;
          } 
       }
       else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Please populate the Account field or the Standard Field');
             ApexPages.addMessage(myMsg); 
             return null;
       }    
    }
     
             
    Public PageReference deleterow(){
        Integer deletecount=0 ;
            if(drugcriterialist.size()> 0){
                for(integer i=0;i< drugcriterialist.size();i++){
                     if(drugcriterialist[i].check == true){                    
                      drugcriterialist.remove(i);
                       deletecount = deletecount+1;                       
                       }
                   } 
               }
            if(deletecount ==0)
               messageFlag = true;       
          return null;  
        }
        
        public void sortList()
        {
            //wraplist.clear();

                wrapperclass tempwrapper = new wrapperclass();
                tempwrapper.check = false;
                tempwrapper.criterialist.Sequence__c=TotalCriteria;
                tempwrapper.criterialist.Effective__c=system.today();
                tempwrapper.criterialist.Term__c=system.today();
                tempwrapper.criterialist.MS_Code_M__c=true;
                tempwrapper.criterialist.MS_Code_N__c=true;
                tempwrapper.criterialist.MS_Code_O__c=true;
                tempwrapper.criterialist.MS_Code_Y__c=true;
                tempwrapper.criterialist.Rx__c=true;
                tempwrapper.criterialist.DESI__c=true;
                tempwrapper.criterialist.Maintenance__c=true;
                tempwrapper.criterialist.OTC__c=true;
                tempwrapper.criterialist.Repack__c=true;
                tempwrapper.criterialist.Non_Maintenance__c=true;
                
                drugcriterialist.add(tempwrapper);
            
        }

   /* Public List<Drug_List_Criteria__c> getSearchCriteria(){   
    return wrapList;    
    }*/
   
    Public Pagereference cancelPage(){
            PageReference pageRef = Page.VF_DrugListSearch;  
            return  pageRef ;    
    }
   /* Public Pagereference cancelPriorAuth(){
            return Page.VF_PriorAuthrisationSearch;     
    }
    Public Pagereference cancelQuantLimit(){
            return Page.VF_QuantitySearch;      
    }*/
    //Wrapper Class of Drug List criteria
    Public class wrapperclass{
    Public Drug_List_Criteria__c criterialist{get;set;}
    Public boolean check {get;set;} 

       
     Public wrapperclass(){
     criterialist = new Drug_List_Criteria__c();

     }
     
    }
    Public void updatePanel(){
    if(DrugList.Special_Use__c !=Null){
    showUnitCost = true;
    }
    else {
    showUnitCost = false;
    }
    system.debug('*********Unitcost*******'+showUnitCost+DrugList.Special_Use__c);
    
    }    

}