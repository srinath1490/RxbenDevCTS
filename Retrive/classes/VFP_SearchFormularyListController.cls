/*Purpose: Apex Class for VFP_SearchFormularyList Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 07/15/2011       Apex Class for VFP_SearchFormularyList Page.
======================================================================== 
*/
public with sharing class VFP_SearchFormularyListController {
    Public string formularyListName{get;set;}
    Public string formularyListNameCriteria{get;set;}
    Public string formularyListDescription{get;set;}
    Public string formularyListDescriptionCriteria{get;set;}
    public boolean isCriteriaAdded{get;set;}    
    public boolean isValidGPI{get;set;}
    public boolean isValidNDC{get;set;}
    Public string listValue{get;set;}   
    Public string GPI{get;set;}
    Public string NDC{get;set;}
    Public list<Formulary_List__c> searchResults{get;set;}
    Public Formulary_List__c formularyListOptionCode {get;set;}
    Public Set<Id> formularyListSet; 
    
    /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 25;
    
    
    /* Sorting Parameters */
    Map<String,String> sortOrderMap = new Map<String,String>{'Name' => 'Name'
                                                         ,'optioncode' => 'Option_Code__c'
                                                         ,'description' => 'Formulary_List_Description__c'
                                                         ,'listName' => 'Formulary_List_Name__c'};
    Map<Integer,String> sortDirMap = new Map<Integer,String>{ 1=>'ASC' , 2 => 'DESC'};
    public String sortOrder {get;set;}
    public Integer sortDir {get;set;}
    public String searchSOQL {get;set;}
    Public boolean validDrugCodeValue{get;set;}
    public boolean isBlankResult{get;set;}
    



    public VFP_SearchFormularyListController(ApexPages.StandardController controller) {
        formularyListSet = new set<Id>();
        formularyListOptionCode = new Formulary_List__c();
        searchResults= new List<Formulary_List__c>();
    }
    
    Public PageReference redirectToNewFormularyList(){
        return Page.VF_FormularyListCreation;
    }
    public List<SelectOption> getcriteia() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new Selectoption('Starts',''));
         options.add(new Selectoption('Includes',''));
         return options;
     }
     
     
     public PageReference doSearch(){
         validDrugCodeValue = true;
         isValidGPI = true;
         isValidNDC = true;
        if(NDC.contains('*')){
            NDC = NDC.substring(0,NDC.lastIndexOf('*'));
            isValidNDC = GC_Validation_Methods.valiadteNDC(NDC);
        }
        else if((NDC <>'' && NDC.length() !=11)||NDC.contains('.')){
            isValidNDC = false;
        }                 
        else if(NDC <> ''){
            try{
                Double.valueof(NDC);
            }
            catch(exception e){
                 isValidNDC = false;
            } 
         }               
         if(GPI.contains('*')){
            GPI = GPI.substring(0,GPI.lastIndexOf('*'));
            isValidGPI= GC_Validation_Methods.valiadteGPI(GPI);
          }
         else if((GPI <>''&& GPI.length() !=14)||GPI.contains('.')){
            isValidGPI = false;
         }
         else if(GPI <> ''){
            try{
                Double.valueof(GPI);
            }
            catch(exception e){
                 isValidGPI = false;
            } 
         }
        sortDir =1;
        sortOrder = 'Name';
        if(isValidGPI && isValidNDC ){
           List<Formulary_List_Entry__c> listEntry = new List<Formulary_List_Entry__c>();
                     
           if((GPI != ''&& GPI!=null) || (NDC != null && NDC != '')){            
              String subquery = baseQuery();
              System.debug('**********subquery*******'+subquery);
              listEntry = database.query(subquery);
           }
           
            if(listEntry.size() >0){
             for(Formulary_List_Entry__c formList: listEntry ){
                 if(formList.Formulary_List__c != null){
                   formularyListSet.add(formList.Formulary_List__c);
                   }                   
                }
            } 
             string query =SearchQuery();  
            if(isCriteriaAdded){
                try{
                    system.debug('**Query***'+query);
                    stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                    stdCon.setPageSize(PAGE_SIZE);
                    searchResults = stdCon.getRecords();
                    if(searchResults==null || searchResults.size()==0){
                       isBlankResult= true;
                    }
                }catch(exception e){                     
                }
            }
            else if(!isCriteriaAdded){            
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00095);
                   ApexPages.addMessage(myMsg);               
            }
         }      
         else if(!isValidNDC){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00042);
               ApexPages.addMessage(myMsg); 
         }
         else if(!isValidGPI){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00039);
              ApexPages.addMessage(myMsg); 
         } 
           return null;
       }
       
    Public Pagereference clearFields(){
        formularyListName = null;
        formularyListNameCriteria = null;
        formularyListDescription = null;
        formularyListDescriptionCriteria = null; 
        GPI = null;
        NDC = null;
        formularyListOptionCode.OptionCode__c = null;
        
        return null;
    } 
     
    public void sort(){
      if(searchSOQL != null && searchSOQL != ''){
        String query = searchSOQL + ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';      
        if(isCriteriaAdded){
            stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            stdCon.setPageSize(PAGE_SIZE);
            searchResults = stdCon.getRecords();
        }
      }
    }
    
       
    Public String SearchQuery(){
           isCriteriaAdded=false;
           String searchString='Select Id,OptionCode__c,OptionCode__r.Name, Name, Formulary_List_Description__c,Formulary_List_Name__c From Formulary_List__c';

            if(formularyListName!='' && formularyListName!=null){
              if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where ';
               }
            if(formularyListNameCriteria== 'Starts'){            
                searchString = searchString +'Formulary_List_Name__c LIKE'+'\''+ formularyListName+'%'+'\'';
             }else if(formularyListNameCriteria=='Includes'){
                searchString = searchString +'Formulary_List_Name__c LIKE'+'\''+'%'+ formularyListName+'%'+'\'';
            }else{
                searchString = searchString +'Formulary_List_Name__c ='+'\''+ formularyListName+'\'';
            }
               isCriteriaAdded=true;
            }
            


           if(formularyListDescription!='' && formularyListDescription!=null){
             
               if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where ';
               }
            if(formularyListDescriptionCriteria== 'Starts'){            
                searchString = searchString +'Formulary_List_Description__c LIKE'+'\''+ formularyListDescription+'%'+'\'';
             }else if(formularyListDescriptionCriteria=='Includes'){
                searchString = searchString +'Formulary_List_Description__c LIKE'+'\''+'%'+ formularyListDescription+'%'+'\'';
            }else{
                searchString = searchString +'Formulary_List_Description__c='+'\''+ formularyListDescription+'\'';
            }
               isCriteriaAdded=true;
           }
     if(formularyListOptionCode.OptionCode__c != null){
                        if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where ';
               }
               searchString = searchString +'OptionCode__c='+'\''+formularyListOptionCode.OptionCode__c+'\'';
               isCriteriaAdded=true;
     }             
          if(formularyListSet.size()>0){
               if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where ';
               }
               searchString = searchString +'Id IN ('+setToString(formularyListSet)+')';
               isCriteriaAdded=true;
             
             }     
            
           searchSOQL = searchString;
           searchString += ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';      
           return searchString;
           
       }
       
   Public  string baseQuery(){

       String baseString = 'Select Id,Name,Formulary_List__c from Formulary_List_Entry__c where';
       if(GPI != null && GPI != ''){
           baseString = baseString+' GPI__c Like'+'\'' +GPI +'%'+'\''+' and';
       }
       if(NDC != null && NDC != ''){
           baseString = baseString+' NDC__c Like'+'\'' +NDC +'%'+'\''+' and';
       }
       baseString = baseString.substring(0,baseString.lastIndexOf('and'));
       return baseString;  
   }  
       Public string setToString(Set<Id> idSet){
        String idstring = '';
        if(idSet.size()>0){
        for(Id listId:idSet){
            if(listId != null){
                idstring = idstring+'\''+string.valueof(listId)+'\''+',';    
              }
           }
               idstring = idstring.substring(0, idstring.lastIndexOf(','));
        }
    
            return idstring;
     }   
           /* Pagging*/
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
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
        searchResults = stdCon.getRecords();
    }
 
    // returns the last page of records
    public void last() {
        stdCon.last();
        searchResults = stdCon.getRecords();
    }
 
    // returns the previous page of records
    public void previous() {
        stdCon.previous();
        searchResults = stdCon.getRecords();
    }
 
    // returns the next page of records
    public void next() {
        stdCon.next();
        searchResults = stdCon.getRecords();
    }

}