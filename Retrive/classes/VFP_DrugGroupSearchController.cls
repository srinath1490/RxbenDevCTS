/*Purpose: Apex Class for  Drug Group Search Page                                     
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 05/07/2011       Apex Class for Drug Group Search Page 
======================================================================== */
public with sharing class VFP_DrugGroupSearchController {
    public list<String> searchResults{get;set;}

    public static final List<Schema.PicklistEntry> P1= Drug_List_Criteria__c.Drug_Type_Code__c.getDescribe().getPicklistValues();
     
    Public string groupName{get;set;}
    Public string nameCriteria {get;set;}
    Public string description{get;set;}
    Public string descCriteria{get;set;}
    Public string drugListName{get;set;}
    Public string listCriteria{get;set;}
    Public string listDesc{get;set;}
    Public string listDescCriteria{get;set;}
    Public string codeValue{get;set;}
    Public string codeType{get;set;}
    
    /*flags to capture errors*/
    Public boolean isCriteriaSet{get;set;}
    Public boolean listCriteriaSet{get;set;}
    Public boolean isValid;
    Public boolean isNDCValid;
    Public boolean isGPIValid;
    Public boolean isBlankResult{get;set;}
    
    Public Id drugCriteriaRtId{get;set;}
    Public List<Drug_Group__c> junctionList{get;set;}
    Set<Id> drugListId = new Set<Id>();
    
    /* Sorting */
    Map<String,String> sortOrderMap = new Map<String,String>{'groupId' => 'Name'
                                                            ,'groupdescription' => 'Description__c'
                                                             ,'groupName' => 'Drug_Group_Name__c','segment' => 'Segment__c','state' => 'State__c','platform' => 'Platform__c','funding' => 'Funding__c', 'account' => 'Account__r.Name', 'standard' => 'Standard__c'};
                                                             
    Map<Integer,String> sortDirMap = new Map<Integer,String>{ 1=>'ASC' , 2 => 'DESC'};
    public String sortOrder {get;set;}
    public Integer sortDir {get;set;}
    public String searchSOQL {get;set;}
    
    /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 25; 
     
       /*Constructor*/
    public VFP_DrugGroupSearchController(ApexPages.StandardController controller) { 
        junctionList = new List<Drug_Group__c>();  
        List<Schema.RecordTypeInfo> CriteriaRtInfo = Drug_List_Criteria__c.sObjectType.getDescribe().getRecordTypeInfos();
             for(Schema.Recordtypeinfo thisInfo : CriteriaRtInfo)
                {
                   if(thisInfo.Name == 'Drug List')
                   {
                    drugCriteriaRtId = thisInfo.getRecordTypeId();
                   }
                }

        }
    /*Options for searching criteria*/
     public List<SelectOption> getcriteia() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new Selectoption('Starts',''));
         options.add(new Selectoption('Includes',''));
         return options;
     }
    /* drug Type Code picklist */
     public List<SelectOption> getTypeCode() {
           List<SelectOption> options = new List<SelectOption>();
           options.add(new Selectoption('','None')); 

             for(Schema.PicklistEntry P : P1)             
                 options.add(new Selectoption(p.getValue(),p.getLabel())); 
           return options;
     } 
     /* Main Search method*/
    public Pagereference doDrugGroupSearch(){
        
        drugListId.clear();
        junctionList = null;
        junctionList = new List<Drug_Group__c>();
        isCriteriaSet=false;
        listCriteriaSet=false;      
        isValid = true;
        isNDCValid = true;
        isGPIValid = true;
        validation();
        sortOrder = 'groupId';
        sortdir = 1;
        List <Drug_List_Criteria__c> drugCriteriaList = new List<Drug_List_Criteria__c>();
        String listQuery = searchQuery();
        if(isValid && isNDCValid && isGPIValid){
            if(listCriteriaSet){
            drugCriteriaList = database.query(listQuery);
            if(drugCriteriaList.size()>0 && drugCriteriaList.size()< 10000){
                for(Drug_List_Criteria__c tempCriteria:drugCriteriaList){
                    if(tempCriteria.Drug_List__c != null)
                       drugListId.add(tempCriteria.Drug_List__c);
                       string stringList = '\''+tempCriteria.Drug_List__c+'\'';
                }
             }else if(drugCriteriaList.size() == 10000){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,System.label.ERR00095);  
                   ApexPages.addMessage(myMsg); 
             }
            } 
           String groupQuery = finalQuery(drugListId);
          if(isCriteriaSet){
              stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(groupQuery));
              stdCon.setPageSize(PAGE_SIZE);
              junctionList = stdCon.getRecords();
              }
              if(junctionList.size() ==0 ||junctionList==null)
                  isBlankResult = true;

      }
      else{
          if(!isValid){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,System.label.CL0000002);
              ApexPages.addMessage(myMsg);
          }
          if(!isNDCValid){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,System.label.CL0000001);
              ApexPages.addMessage(myMsg);
          }
          if(!isGPIValid){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,System.label.CL0000005);
              ApexPages.addMessage(myMsg);
          }
      }
     return null;
    }
    
    public void sort(){
        
      if(searchSOQL != null && searchSOQL != ''){
        String query = searchSOQL + ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';
        stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        stdCon.setPageSize(PAGE_SIZE);
        junctionList = stdCon.getRecords();
      }
    }
    /* Query Builder for Drug group*/
    Public String finalQuery(Set<Id> druglistId){
        String masterString = 'Select Name, Id, Drug_Group_Name__c, Description__c,Segment__c,State__c,Platform__c,Funding__c,Account__c,Account__r.Name,Standard__c From Drug_Group__c WHERE ';

        if(nameCriteria == 'Starts' && groupName <> ''){
            masterString = masterString +' Drug_Group_Name__c LIKE'+'\''+ groupName +'%'+'\''+' and';
            isCriteriaSet=true;   
            }
        else if(nameCriteria =='Includes' && groupName <> ''){
            masterString = masterString+' Drug_Group_Name__c LIKE'+'\''+'%'+ groupName +'%'+'\''+' and';
            isCriteriaSet=true;  
            }
        else if(groupName <> ''){
            masterString= masterString +' Drug_Group_Name__c ='+'\''+ groupName +'\''+' and';
            isCriteriaSet=true; 
            }
            
        if(descCriteria == 'Starts' && description <> ''){
            masterString = masterString +' Description__c LIKE'+'\''+ description +'%'+'\''+' and';
            isCriteriaSet=true;   
            }
        else if(descCriteria =='Includes' && description <> ''){
            masterString = masterString+' Description__c LIKE'+'\''+'%'+ description +'%'+'\''+' and';
            isCriteriaSet=true;  
            }
        else if(description <> ''){
            masterString= masterString +' Description__c ='+'\''+ description +'\''+' and';
            isCriteriaSet=true; 
            }
        if(listCriteriaSet ){
            if(druglistId.size()>0 && druglistId.size() != 0){
                 masterString =masterString +' Id IN( select Parent_Drug_Group__c from Drug_List_Junction__c where  Drug_List__c IN ('+setToString(druglistId)+')) and';
                  isCriteriaSet=true;
                 }    
         }
         if(isCriteriaSet==false){ 
             if(listCriteriaSet ==false){           
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                 ApexPages.addMessage(myMsg);
                 }                           
            }
         else{   
               masterString = masterString.substring(0,masterString.lastIndexof(' and'));  
               }   

       searchSOQL = masterString;
       masterString += ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir);   
                     
       return masterString;            
   }
   /*method to clear the fields of the page*/
    Public Pagereference clearField(){
        groupName=null;
        nameCriteria=null;
        description=null;
        descCriteria=null;
        drugListName=null;
        listCriteria=null;
        listDesc=null;
        listDescCriteria=null;
        codeValue=null;        
        codeType=null;
        junctionList = new List<Drug_Group__c>();
        isValid=true;
        listCriteriaSet=true;
        return null;
   
    }
    /* drug List Query Builder*/
    Public String searchQuery(){
          
      String BaseString = 'select Id,Name,Drug_List__c,Drug_Type_Code__c,Drug_List_Name__c,Drug_List_Criteria_Description__c from Drug_List_Criteria__c where RecordTypeId='+'\''+drugCriteriaRtId+'\'';
        
        if(codeValue <> ''){
        BaseString = BaseString+ ' and Drug_Code_Value__c  Like'+'\''+codeValue+'%'+'\'';
            listCriteriaSet =true;
        }
        if(codeType != null){
        BaseString = BaseString+' and Drug_Type_Code__c =\''+codeType+'\'';
            listCriteriaSet =true;
        }
        if(listCriteria == 'Starts' && drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c LIKE'+'\''+ drugListName +'%'+'\'';
            listCriteriaSet =true;
        }
        else if(listCriteria =='Includes' && drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c LIKE'+'\''+'%'+ drugListName +'%'+'\'';
            listCriteriaSet =true;
        }
        else if(drugListName <> ''){
            BaseString = BaseString+' and Drug_List_Name__c ='+'\''+ drugListName +'\'';
            listCriteriaSet =true;
        }
        if(listDescCriteria == 'Starts' && listDesc<> ''){
            BaseString = BaseString+' and Drug_List_Criteria_Description__c LIKE'+'\''+ listDesc +'%'+'\'';
            listCriteriaSet =true;
        }
        else if(listDescCriteria =='Includes' && listDesc <> ''){
            BaseString = BaseString+' and Drug_List_Criteria_Description__c LIKE'+'\''+'%'+ listDesc+'%'+'\'';
            listCriteriaSet =true;
        } 
        else if(listDesc <> '') {
            BaseString = BaseString+' and Drug_List_Criteria_Description__c ='+'\''+ listDesc+'\'';
            listCriteriaSet =true;
        } 
        if(listCriteriaSet){
            BaseString = BaseString+' Limit 10000';
        }
      
        return BaseString;
    
    }
    public Pagereference newPage(){
     	PageReference pageRef = new PageReference('/apex/VF_NewDrugGroup');      
     	return pageRef ;
    }
    /* method to convert a list of id into a comma seperated string*/
    Public String  setToString(Set<Id> idSet){
   		 String idstring = '';
    	if(idSet.size()>0){
   			for(Id listId: idSet){
      			idstring = idstring+'\''+listId+'\''+',';    
       		}
            idstring = idstring.substring(0, idstring.lastIndexOf(','));
    	}
        return idstring;
     }
     
     /* method used to validate the pre requisite for doing a search*/
     Public void  validation(){
        if(nameCriteria !=null && groupName ==''){
            isValid = false;
        }
        if(descCriteria != null && description=='' ){
            isValid = false;
        }
        if(listCriteria != null && drugListName == '' ){
            isValid = false;
        }
        if(listDescCriteria != null && listDesc == ''){
            isValid = false;
        }
        if(codeType == system.Label.CL0000003 && codeValue <>''){
                if(codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    isNDCValid = GC_Validation_Methods.valiadteNDC(codeValue);
                }
                else if(codeValue.length() !=11 || codeValue.contains('.')){
                    isNDCValid = false;
                }
                else{
                    try{
                        Double.valueof(codeValue);
                    }
                    catch(exception e){
                        isNDCValid = false;
                    }               
                }
          }
          if(codeType == system.Label.CL0000004 && codeValue <>''){
               if( codeValue.contains('*')){
                    codeValue = codeValue.substring(0,codeValue.lastIndexOf('*'));
                    isGPIValid = GC_Validation_Methods.valiadteGPI(codeValue);
                }
                else if(codeValue.length() !=14 || codeValue.contains('.')){
                    isGPIValid = false;
                }
                else{
                    try{
                        Double.valueof(codeValue);
                    }
                    catch(exception e){
                        isGPIValid = false;
                    }
                 
                }
           }     
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
        junctionList = stdCon.getRecords();
    }
 
    // returns the last page of records
    public void last() {
        stdCon.last();
        junctionList = stdCon.getRecords();
    }
 
    // returns the previous page of records
    public void previous() {
        stdCon.previous();
        junctionList = stdCon.getRecords();
    }
 
    // returns the next page of records
    public void next() {
        stdCon.next();
        junctionList = stdCon.getRecords();
    }
}