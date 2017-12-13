/*Purpose: Apex Class for VFP_SearchFormulary Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 07/12/2011       Apex Class for VFP_SearchFormulary Page.
======================================================================== 
*/
public with sharing class VFP_SearchFormularyController {
    
    Public string formularyName{get;set;}
    Public string formularyNameCriteria{get;set;}
    Public string cvsCaremarkId{get;set;}
    Public string cvsCaremarkIdCriteria{get;set;}
    Public string formularyDescription{get;set;}
    Public string formularyDescriptionCriteria{get;set;}
    Public boolean validDrugCodeValue{get;set;}
    Public boolean isNDCValid;
    Public boolean isGPIValid;    
    public boolean isBlankResult{get;set;}
    public boolean isCriteriaAdded{get;set;}
    public boolean isValidCriteria;   
    Public string formularyList{get;set;} 
    Public string formularyListCriteria{get;set;}  
    Public string listValue{get;set;}   
    Public string GPI{get;set;}
    Public string NDC{get;set;}
    Public list<Formulary__c> searchResults{get;set;}
    Set<Id> formularyListSet = new set<Id>();
    Public Formulary__c formularyListOptionCode {get;set;}    
     /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 25;
        
    /* Sorting Parameters */
    Map<String,String> sortOrderMap = new Map<String,String>{'Name' => 'Name'
                                                         ,'formularyname' => 'Formulary_Name__c'
                                                         ,'description' => 'Formulary_Description__c','Id' =>'Name','Account' =>'Account__c'
                                                         ,'Funding' =>'Funding__c','Standard' => 'Standard__c'};
    
    Map<Integer,String> sortDirMap = new Map<Integer,String>{ 1=>'ASC' , 2 => 'DESC'};
    public String sortOrder {get;set;}
    public Integer sortDir {get;set;}
    public String searchSOQL {get;set;}



    
    public VFP_SearchFormularyController(ApexPages.StandardController controller) {
           searchResults= new List<Formulary__c>();
           formularyListOptionCode  = new Formulary__c();

    }
    
    public List<SelectOption> getcriteia() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new Selectoption('Starts',''));
         options.add(new Selectoption('Includes',''));
         return options;
     }
     
       Public PageReference redirectToNewFOrmularyList(){
        return Page.VF_FormularyCreation;
       }
       Public PageReference clearFields(){
              formularyName = null;
              formularyNameCriteria = null;
              cvsCaremarkId= null;
              cvsCaremarkIdCriteria = null;
              formularyDescription = null;
              formularyDescriptionCriteria = null;   
              formularyList = null;
              formularyListCriteria = null;
              listValue= null;  
              GPI= null;
              NDC= null;
              formularyListOptionCode.Option_Code__c = null;
              return Null;
       }
       public PageReference searchFormulary(){
               validDrugCodeValue = true;
               isNDCValid=true;
               isGPIValid= true; 
               isValidCriteria = validation(); 
               system.debug('***********test1******'+validDrugCodeValue) ;         
               if(NDC.contains('*') ){
                    NDC = NDC.substring(0,NDC.lastIndexOf('*'));
                    isNDCValid = GC_Validation_Methods.valiadteNDC(NDC);
                    system.debug('***********test2******'+validDrugCodeValue) ;   
                }
                else if((NDC <> ''  && NDC.length() !=11)||NDC.contains('.')){
                    isNDCValid = false;
                    system.debug('***********test3******'+validDrugCodeValue+'****'+NDC) ;   
                }
                else if(NDC <> ''){
                    try{
                        Double.valueof(NDC);
                    }
                    catch(exception e){
                         isNDCValid = false;
                    }
               }                               
                 if(GPI.contains('*') ){
                    GPI = GPI.substring(0,GPI.lastIndexOf('*'));
                    isGPIValid = GC_Validation_Methods.valiadteGPI(GPI);
                    system.debug('***********test4******'+validDrugCodeValue) ;   
                  }
                 else if((GPI <>'' && GPI.length() !=14)|| GPI.contains('.')){
                    isGPIValid = false;
                    system.debug('***********isGPIValid******'+isGPIValid+'****'+GPI) ;   
                 }
                 else if(GPI <>''){
                     try{
                        Double.valueof(GPI);
                     }
                    catch(exception e){
                         isGPIValid = false;
                    }
                 
                }
                 system.debug('***********isGPIValid******'+isGPIValid) ;   
            sortDir =1;
            sortOrder = 'Name';
            
           if(isGPIValid && isNDCValid && isValidCriteria){
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
                String query = SearchQuery();   
                system.debug('Final Query'+query );        
            if(isCriteriaAdded){
            try{
                 stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                 stdCon.setPageSize(PAGE_SIZE);
                 searchResults = stdCon.getRecords();
                 system.debug('*************search result*******************'+searchResults);
                 if(searchResults.size()>0){
                    system.debug('*************search result*******************'+searchResults);
                }

            }catch(exception e){  
                  
            }
            }
            else if(GPI != '' &&  NDC != ''){            
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00095);
                  ApexPages.addMessage(myMsg); 
            }
           } 
          else{
          if(!isValidCriteria){                 
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00095);
                  ApexPages.addMessage(myMsg); 
          
          }
          if(!isGPIValid){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00039);
               ApexPages.addMessage(myMsg); 
              }
           if(!isNDCValid){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00042);
                ApexPages.addMessage(myMsg); 
             }
          }
          if(searchResults==null || searchResults.size()==0){
                   isBlankResult= true;
                }            
           return null;
       }
       

        Public String SearchQuery(){
           isCriteriaAdded=false;
              String searchString='select id,Name,Formulary_Name__c,Formulary_Description__c,Standard__c,State__c,Segment__c,Platform__c,Funding__c,Account__c,CVS_Caremark_Formulary_ID__c,Account__r.Name FROM Formulary__c  ';
           system.debug('***********************search string **************************'+searchString);
           if(formularyName!='' && formularyName!=null){

              if(isCriteriaAdded){
                   searchString =searchString +'and ';
               }else{
                   searchString =searchString +' where ';
               }
            
            if(formularyNameCriteria == 'Starts'){            
                searchString = searchString +'Formulary_Name__c LIKE'+'\''+ formularyName+'%'+'\'';
             }else if(formularyNameCriteria=='Includes'){
                searchString = searchString +'Formulary_Name__c LIKE'+'\''+'%'+ formularyName+'%'+'\'';
            }else{
                searchString = searchString +'Formulary_Name__c='+'\''+ formularyName+'\'';
            }
               isCriteriaAdded=true;
            }
            if(cvsCaremarkId!='' && cvsCaremarkId!=null){

              if(isCriteriaAdded){
                   searchString =searchString +'and ';
               }else{
                   searchString =searchString +' where ';
               }
            
            if(cvsCaremarkIdCriteria == 'Starts'){            
                searchString = searchString +'CVS_Caremark_Formulary_ID__c LIKE'+'\''+ cvsCaremarkId+'%'+'\'';
             }else if(cvsCaremarkIdCriteria=='Includes'){
                searchString = searchString +'CVS_Caremark_Formulary_ID__c LIKE'+'\''+'%'+ cvsCaremarkId+'%'+'\'';
            }else{
                searchString = searchString +'CVS_Caremark_Formulary_ID__c='+'\''+ cvsCaremarkId+'\'';
            }
               isCriteriaAdded=true;
            }


           if(formularyDescription !='' && formularyDescription !=null){
             
               if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +'where ';
               }
            if(formularyDescriptionCriteria== 'Starts'){            
                searchString = searchString +'Formulary_Description__c LIKE'+'\''+ formularyDescription+'%'+'\'';
             }else if(formularyDescriptionCriteria=='Includes'){
                searchString = searchString +'Formulary_Description__c LIKE'+'\''+'%'+ formularyDescription+'%'+'\'';
            }else{
            
                searchString = searchString +'Formulary_Description__c='+'\''+ formularyDescription+'\'';
            }
               isCriteriaAdded=true;
           }
                      
           if(formularyListOptionCode.Option_Code__c !=null){
            
               if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where ';
               }
               searchString = searchString +'Option_Code__c='+'\''+ formularyListOptionCode.Option_Code__c+'\'';
               isCriteriaAdded=true;
           }
           if((formularyList !='' && formularyList !=null) || (GPI != null && GPI != '') || (NDC != null || NDC != '')){
                if(isCriteriaAdded){
                   searchString =searchString +' and ';
               }else{
                   searchString =searchString +' where  ';
               }
           searchString =searchString + ' Id IN( select Formulary__c from Formulary_Junction__c where  ';        
           
          if(formularyList !='' && formularyList !=null){
              if(formularyListCriteria== 'Starts'){            
                    searchString = searchString +'Formulary_List__r.Formulary_List_Name__c Like'+'\''+ formularyList+'%'+'\'' +' )';
               }else if(formularyListCriteria=='Includes'){
                    searchString = searchString +'Formulary_List__r.Formulary_List_Name__c Like'+'\''+'%'+ formularyList+'%'+'\''+ ' )';
               }else{
                    searchString = searchString +'Formulary_List__r.Formulary_List_Name__c='+'\''+ formularyList+'\'' +' )';
                }
               isCriteriaAdded=true;
           }
           system.debug('***********************search string 2 **************************'+searchString);
        system.debug('----------formularyListSet--------'+formularyListSet);
        system.debug('----------GPI --------'+GPI );
        system.debug('----------NDC --------'+NDC );
             if(formularyListSet.size()>0 && ((GPI != null && GPI != '') || (NDC != null && NDC != '')) ){
               searchString = searchString +' Formulary_List__c IN ('+setToString(formularyListSet)+')';
                searchString += ' ) ';
               isCriteriaAdded=true;
             
             }
             else if((GPI != null && GPI != '') || (NDC != null && NDC != '')){
               searchString = searchString +' Formulary_List__c = Null';
               searchString += ' ) ';
               isCriteriaAdded=true;
             }else if(searchString.contains(' and')){
               searchString= searchString.substring(0,searchString.lastIndexof(' and')); 
             }
          // searchString += ' ) ';  
        }
           
           searchSOQL = searchString;
           searchString += ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';      

              system.debug('************search string complete*****************'+searchString);
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
   public boolean validation(){
        
        system.debug('*formularyName**'+formularyName+'*formularyNameCriteria**'+formularyNameCriteria+'*cvsCaremarkId**'+'*cvsCaremarkIdCriteria **'+cvsCaremarkIdCriteria +'*formularyDescription**'+formularyDescription+'*formularyDescriptionCriteria**'+formularyDescriptionCriteria+'*formularyList**'+formularyList+'*formularyListCriteria**'+formularyListCriteria);
        boolean isValid = true;
        if(formularyName == '' &&  cvsCaremarkId =='' && formularyDescription =='' && formularyList =='' && formularyListOptionCode ==null && GPI =='' && NDC ==''){
            isValid = false;
            system.debug('*************test1*****' + isValid);
        }else if((formularyName == '' &&  formularyNameCriteria !=null) || (cvsCaremarkId =='' && cvsCaremarkIdCriteria !=null) || (formularyDescription =='' && formularyDescriptionCriteria !=null)||(formularyList =='' && formularyListCriteria !=null)){
            isValid = false;
            system.debug('*************test2*****' + isValid);
        } 
        return isValid;       
   }    
   public void sort(){
      if(searchSOQL != null && searchSOQL != ''){
        system.debug('*************searchSOQL*****' + searchSOQL);
        system.debug('*************sortOrderMap*****' + sortOrderMap);
        system.debug('*************sortOrder*****' + sortOrder);
        String query = searchSOQL + ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';
        system.debug('*************query*****' + query);      
        if(isCriteriaAdded){
            stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            stdCon.setPageSize(PAGE_SIZE);
            searchResults = stdCon.getRecords();
            //searchResults = database.query(query);
        }
      }
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