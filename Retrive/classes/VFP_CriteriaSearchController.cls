/*Purpose: Apex Class for VFP_CriteriaSearch Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 7/4/2011       Apex Class for VFP_CriteriaSearch Page.
======================================================================== 
*/
public with sharing class VFP_CriteriaSearchController {

    /*variables*/
    Public string description{get;set;}
    Public string codeValue{get;set;}
    Public string listValue{get;set;}
    Public string listCriteria{get;set;}
    Public String descCriteria {get;set;}
    Public String drugListName{get;set;}
    Public boolean isBlankResult{get;set;}
    Public List<Drug_List__c> drugsList {get; private set;}
    public static final List<Schema.PicklistEntry> P1= Drug_List_Criteria__c.Drug_Type_Code__c.getDescribe().getPicklistValues();
    private Integer searchMaxSize = 25;
    Public boolean isCriteriaSet;
    Public boolean validDrugCodeValue;
    Public boolean validSearch;
    Id drugCriteriaRtId ;

    /*Sorting variables*/
    Map<String,String> sortColumnMap = new Map<String,String>{'Name' => 'Drug_List_Name__c'
                                                             ,'Description' => 'Description__c','Id'=>'Name',
                                                             'SpecialUse' => 'Special_Use__c','Funding' => 'Funding__c',
                                                             'Account' =>'Account__r.Name','Standard' => 'Standard__c'};
                                                             
    
    Map<Integer,String> sortDirMap = new Map<Integer,String>{ 1=>'ASC' , 2 => 'DESC'};
    public String sortOrder {get;set;}
    public Integer sortDir {get;set;}
    public String searchSOQL {get;set;}
    
    /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 25;
    
    /*Constructor*/
    public VFP_CriteriaSearchController(ApexPages.StandardController controller) {
                 
        drugsList = new List<Drug_List__c>();
    }

    /****** Methods****************/
     public pagereference doDrugListSearch(){
     
          isCriteriaSet=false;
          validSearch = validation();
          validDrugCodeValue = true;
          
          /**************NDC validation*****************/
          if(listValue == system.Label.CL0000003 && codeValue <>''){
                if(codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    validDrugCodeValue = GC_Validation_Methods.valiadteNDC(codeValue);
                }
                else if(codeValue.length() !=11 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }
                else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }
                 
                 }
          }
          /**************GPI validation*****************/
          if(listValue == system.Label.CL0000004 && codeValue <>''){
               if( codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                   if(codeValue<>''){
                    validDrugCodeValue = GC_Validation_Methods.valiadteGPI(codeValue);
                    }else{
                       validDrugCodeValue = true;  
                    }
                }
                else if(codeValue.length() !=14 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                                        system.debug('**Check5****'+validDrugCodeValue);
                }
                 else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                                            system.debug('**Check6****'+validDrugCodeValue);
                    }
                 
                 }
          } 
        sortOrder = 'Name';
        sortDir = 1;
        List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
            for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo){            
                if(thisInfo.Name == 'Drug List'){
                    drugCriteriaRtId = thisInfo.getRecordTypeId();
                }          
             }
      String query =SearchQuery();
      drugsList = new List<Drug_List__c>();
      If(validDrugCodeValue){
          If(isCriteriaSet && validSearch){
              filterSearchResults(query);     
              }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                ApexPages.addMessage(myMsg);
             }
        }else if(listValue == system.Label.CL0000003){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000001);
                ApexPages.addMessage(myMsg);
           
         }else if(listValue == system.Label.CL0000004){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000005);
               ApexPages.addMessage(myMsg); 
          }
       
      return null;
     }
     
     public void sort(){   
       if(searchSOQL != null && searchSOQL != ''){
          String query = searchSOQL + ' ORDER BY ' + sortColumnMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';
          filterSearchResults(query);
      }
    }

     Public Pagereference doPriorAuthSearch(){
             isCriteriaSet=false;
             validSearch = validation();
             validDrugCodeValue = true;
               if(listValue == system.Label.CL0000003 && codeValue <>''){
                  if(codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    validDrugCodeValue = GC_Validation_Methods.valiadteNDC(codeValue);
                }
                else if(codeValue.length() !=11 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }
                else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }
                 
                 }
          }
          if(listValue == system.Label.CL0000004 && codeValue <>''){
               if( codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                   if(codeValue<>''){
                    validDrugCodeValue = GC_Validation_Methods.valiadteGPI(codeValue);
                    }else{
                    validDrugCodeValue = true;
                    }
                }
                else if(codeValue.length() !=14 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }
                 else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }
                 
                 }
          }
            sortOrder = 'Name';
            sortDir = 1;
            List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
             for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo)
                {
                   if(thisInfo.Name == 'Prior Authorization')
                   {
                    drugCriteriaRtId = thisInfo.getRecordTypeId();
                   }                     
           }
           String query =SearchQuery();
           drugsList = new List<Drug_List__c>();
           If(validDrugCodeValue){
              If(isCriteriaSet && validSearch){
                    filterSearchResults(query);        
                }
               else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                ApexPages.addMessage(myMsg);
             }
           }
           else if(listValue == system.Label.CL0000003){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000001);
                ApexPages.addMessage(myMsg);
           
           } 
          else if(listValue == system.Label.CL0000004){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000005);
               ApexPages.addMessage(myMsg); 
          }  
          return null;           
     }
     
      Public Pagereference doQuantLimitSearch(){
            isCriteriaSet=false;
             validSearch = validation();
             validDrugCodeValue = true;
              if(listValue == system.Label.CL0000003 && codeValue <>''){
                    if(codeValue.contains('*')){
                        codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                        if(codeValue<>''){
                        validDrugCodeValue = GC_Validation_Methods.valiadteNDC(codeValue);
                        }else{
                        validDrugCodeValue = true;
                        }
                    }
                    else if(codeValue.length() !=11 || codeValue.contains('.')){
                        validDrugCodeValue = false;
                    }
                    else{
                        try{
                          Double.valueof(codeValue);
                        }
                        catch(exception e){
                            validDrugCodeValue = false;
                        }   
                     }
               }
          if(listValue == system.Label.CL0000004 && codeValue <>''){
               if( codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    if(codeValue<>''){
                    validDrugCodeValue = GC_Validation_Methods.valiadteGPI(codeValue);
                    }else{
                    validDrugCodeValue = true;
                    }
                }else if(codeValue.length() !=14 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }        
                 }
          }           
          sortOrder = 'Name';
          sortDir = 1;
          List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
           for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo){
                 if(thisInfo.Name == 'Quantity Limit'){
                    drugCriteriaRtId = thisInfo.getRecordTypeId();
                   }                     
           }
           String query =SearchQuery();
           drugsList = new List<Drug_List__c>();
           If(validDrugCodeValue){          
               If(isCriteriaSet && validSearch){
                    filterSearchResults(query);
               }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                ApexPages.addMessage(myMsg);
             }            
          }else if(listValue == system.Label.CL0000003){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000001);
                ApexPages.addMessage(myMsg);
           
          }else if(listValue == system.Label.CL0000004){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000005);
               ApexPages.addMessage(myMsg); 
          }
          return null;           
     }
     
     // Test Sourabh
     Public Pagereference doStepTherapySearch(){
             isCriteriaSet=false;
             validSearch = validation();
             validDrugCodeValue = true;
               if(listValue == system.Label.CL0000003 && codeValue <>''){
                if(codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                   if(codeValue<>''){
                    validDrugCodeValue = GC_Validation_Methods.valiadteNDC(codeValue);
                    }else{
                        validDrugCodeValue = true;
                    }
                }
                else if(codeValue.length() !=11 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }
                else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }
                 
                 }
          }
          if(listValue == system.Label.CL0000004 && codeValue <>''){
               if( codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    validDrugCodeValue = GC_Validation_Methods.valiadteGPI(codeValue);
                }
                else if(codeValue.length() !=14 || codeValue.contains('.')){
                    validDrugCodeValue = false;
                }
                 else{
                    try{
                      Double.valueof(codeValue);
                    }
                    catch(exception e){
                        validDrugCodeValue = false;
                    }
                 
                 }
          }
             sortOrder = 'Name';
             sortDir = 1;
            List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
             for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo)
                {
                   if(thisInfo.Name == 'Step Therapy')
                   {
                    drugCriteriaRtId = thisInfo.getRecordTypeId();
                   }                     
           }
           system.debug('***Step Therapy Record Type***'+drugCriteriaRtId);
           String query =SearchQuery();
           drugsList = new List<Drug_List__c>();
           If(validDrugCodeValue){
              If(isCriteriaSet && validSearch){
                    filterSearchResults(query);        
                }
               else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                ApexPages.addMessage(myMsg);
             }
           }
           else if(listValue == system.Label.CL0000003){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000001);
                ApexPages.addMessage(myMsg);
           
           } 
          else if(listValue == system.Label.CL0000004){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000005);
               ApexPages.addMessage(myMsg); 
          }  
          return null;           
     }
     
     
     // Sourabh
     /*This function filters the search results and returns the unique results*/
     public void filterSearchResults(String query){
         List<Drug_List__c> totalDrugList = new List<Drug_List__c>();
         totalDrugList =database.query(query);
         if(totalDrugList.size() <1000){
           stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
          stdCon.setPageSize(PAGE_SIZE);
          drugsList = stdCon.getRecords();
          }else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,system.label.ERR00115);  
           ApexPages.addMessage(myMsg); 
          }
          if(drugsList.size() ==0 ||drugsList==null)
              isBlankResult = true;
     }
     
     Public Pagereference clearfields(){
        description = null;
        codeValue = null;
        listValue = null;
        listCriteria = null;
        descCriteria = null;
        drugListName = null;
        return null;
     
     }
     Public boolean validation(){
         boolean valid = true;    
         if(listCriteria !=null && drugListName ==''){
             valid = false;
         }
         if(descCriteria !=null && description == ''){
             valid = false;
         }
         return valid; 
     }
     /************** Page Redirection methods************/
     Public PageReference redirectToNewDrugList(){
               return  new PageReference(system.label.CL0000028);
     }
     Public Pagereference redirectToNewPriorAuth(){
           return  new PageReference(system.label.CL0000006);
     }
     Public Pagereference redirectToNewQuantLimit(){
         return new PageReference(system.label.CL0000007);
     }
     Public Pagereference redirectToNewStepTherapy(){
           return  new PageReference(system.label.CL0000027);
     }
     
     
     // indicates whether there are more records than the searchMaxSize.

    public Boolean hasNext {
        get {
            return (DrugsList == null || (DrugsList != null && DrugsList.size() > searchMaxSize));
        }
        set;
    }
        public List<SelectOption> getcriteia() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('Starts',''));
            options.add(new Selectoption('Includes',''));
            return options;
     } 
      public List<SelectOption> gettypeCode() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('','None')); 
             for(Schema.PicklistEntry P : P1)             
                 options.add(new Selectoption(p.getValue(),p.getLabel()));      

            return options;
     }
     public List<SelectOption> getDrugTypeCode() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('','None')); 
             for(Schema.PicklistEntry P : P1){             
                 if(p.getLabel() !='Labeler Code'){
                 options.add(new Selectoption(p.getValue(),p.getLabel()));
                 }      
             }
            return options;
     }  
    
    /**************Dynamic Query Builder*******************/ 
    Public String SearchQuery(){
       String BaseString = 'Select Id,Name,Drug_List_Name__c, Description__c,Account__c,Account__r.Name,Funding__c,Platform__c,Segment__c,Special_Use__c, Standard__c,State__c From Drug_List__c  WHERE RecordTypeId='+'\''+drugCriteriaRtId+'\'';       
       if(listCriteria == 'Starts' && drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c LIKE'+'\''+ drugListName +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(listCriteria =='Includes' && drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c LIKE'+'\''+'%'+ drugListName +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c ='+'\''+ drugListName +'\'';
            isCriteriaSet=true;
        }
        if(descCriteria == 'Starts' && description <> ''){
            BaseString = BaseString+' and Description__c  LIKE'+'\''+ description +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(descCriteria =='Includes' && description <> ''){
            BaseString = BaseString+' and Description__c  LIKE'+'\''+'%'+ description+'%'+'\'';
            isCriteriaSet=true;
        } 
        else if(description <> '') {
            BaseString = BaseString+' and Description__c  ='+'\''+ description +'\'';
            isCriteriaSet=true;
        }
      if((codeValue <> '' && codeValue != null) ||(listvalue != null && listvalue <>'')){
      BaseString = BaseString+ ' and ID IN (select Drug_List__c from Drug_List_Criteria__c where' ;
        if(codeValue <> ''){
            if(listvalue == null){
                BaseString = BaseString+ ' Drug_Code_Value__c LIKE'+'\''+codeValue+'%'+'\'';
            }
            else{
                BaseString = BaseString+ ' Drug_Code_Value__c LIKE'+'\''+codeValue+'%'+'\'' +' and';
            }
            isCriteriaSet=true;
        }
        if(listvalue != null){
        BaseString = BaseString+' Drug_Type_Code__c =\''+listvalue+'\'';
        isCriteriaSet=true;
        }
        BaseString += ')';

     }
        system.debug('****base String*******'+BaseString);
        system.debug('****Criteria*******'+isCriteriaSet);
      
                searchSOQL = BaseString;
        BaseString += ' ORDER BY ' + sortColumnMap.get(sortOrder) + ' ' +   sortDirMap.get(sortDir) +' Limit 1000';
        system.debug('****base String*******'+BaseString);
        return BaseString;
    }
    
    /* Pagging*/
    // indicates whether there are more records after the current page set.
    public Boolean hasNextRecord {
        get {
            if(stdCon == null) return false;
            return stdCon.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            if(stdCon == null) return false;
            return stdCon.getHasPrevious();
        }
        set;
    }
    
    public Boolean isFirst {
        get {
            if(stdCon == null) return true;
            return this.pageNumber > 1;
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean isLast {
        get {
            if(stdCon == null) return true;
            if(stdCon.getResultSize() ==0) return false;
             return stdCon.getResultSize()/PAGE_SIZE < this.pageNumber;
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return stdCon.getPageNumber();
        }
        set;
    }
    
    
 
    // returns the first page of records
    public void first() {
        stdCon.first();
        drugsList = stdCon.getRecords();
    }
 
    // returns the last page of records
    public void last() {
        stdCon.last();
        drugsList = stdCon.getRecords();
    }
 
    // returns the previous page of records
    public void previous() {
        stdCon.previous();
        drugsList = stdCon.getRecords();
    }
 
    // returns the next page of records
    public void next() {
        stdCon.next();
        drugsList = stdCon.getRecords();
    }
    
}