/*Purpose: Apex Class for VFP_DrugResearch Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Sourabh                 07/20/2011       Apex Class for VFP_DrugResearch Page.
======================================================================== 
*/
public with sharing class VFP_DrugResearchController {
        
        Public boolean isCriteriaSet;
        Public boolean isValid;
        Public boolean isNDCValid;
        Public boolean isGPIValid;
        Public boolean isBlankResult{get;set;}
        Public List<Drug__c> drugList {get; private set;}
        Public Drug__c searchdata{get;set;}
        Public string labelCriteria{get;set;}
        Public string prodCriteria{get;set;}
        Public string gciCriteria{get;set;}
        public String searchSOQL {get;set;}
        Public string ndcValue{get;set;}
        Public string gpiValue{get;set;}
        Public string labelName{get;set;}
        Public string productName{get;set;}
        Public string gpiGeneric{get;set;}
                
        /* Pagging */
        public ApexPages.StandardSetController stdCon{get;set;}
        Integer PAGE_SIZE = 25;
               
        /* Sorting Parameters */
        Map<String,String> sortOrderMap = new Map<String,String>{'Name' => 'Drug_Name__c'
                                                             ,'GPI' => 'GPI__c'
                                                             ,'GenericName' => 'GPI_Generic_Name__c'
                                                             ,'DrugListName' => 'Label_Name__c'
                                                             ,'MsCode' => 'Multi_Source_Code__c'
                                                             ,'NDC' => 'NDC__c'};
        Map<Integer,String> sortDirMap = new Map<Integer,String>{ 1=>'ASC' , 2 => 'DESC'};
        public String sortOrder {get;set;}
        public Integer sortDir {get;set;}
    
        
    public VFP_DrugResearchController(ApexPages.StandardController controller) {
        drugList = new List<Drug__c>();
        searchdata = new Drug__c();       
        
    }
        public List<SelectOption> getcriteia() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('Starts',''));
            options.add(new Selectoption('Includes',''));
            return options;
        }
        Public Pagereference clearFields(){                    
            labelCriteria=null;
            prodCriteria=null;
            gciCriteria=null;
            searchdata.NDC__c = null;
            searchdata.Rx_OTC_Indicator_Code__c = null;
            searchdata.Label_Name__c = null;
            searchdata.Third_Party_Restriction_Code__c = null;
            searchdata.Product_Name__c = null;
            searchdata.Maintenance_Drug_Code__c = null;
            searchdata.GPI__c = null;
            searchdata.Route_of_Administration__c = null;
            searchdata.GPI_Generic_Name__c = null;
            searchdata.Dosage_Form__c = null;
            searchdata.DESI_Code__c= null;
            searchdata.Repack_Code__c = null;
            searchdata.Multi_Source_Code__c = null;
            searchdata.DEA_Class_Code__c = null;
             return null;
        }
        public pagereference doDrugListSearch(){  
          /* Init Sorting Parameter*/   
          searchdata.NDC__c = ndcValue;
          searchdata.GPI__c = gpiValue;
          searchdata.GPI_Generic_Name__c = gpiGeneric;
          searchdata.Label_Name__c= labelName;
          searchdata.Product_Name__c = productName;
          sortOrder = 'NDC';
          sortDir =1;        
          isCriteriaSet=false;
          isNDCValid = true;
          isGPIValid = true;
          drugList = new List<Drug__c>();
          isValid = validation();
          if(searchdata.NDC__c != null && searchdata.NDC__c <>''){
              if(searchdata.NDC__c.contains('*')){
                   searchdata.NDC__c = searchdata.NDC__c.substring(0,searchdata.NDC__c.lastIndexOf('*'));  
              isNDCValid = GC_Validation_Methods.valiadteNDC(searchdata.NDC__c);
            }
            else if(searchdata.NDC__c.length() !=11 || searchdata.NDC__c.contains('.')){
                isNDCValid = false;
            } 
            else{
                try{
                    Double.valueof(searchdata.NDC__c);
                    }
               catch(exception e){
                        isNDCValid = false;
                    }
                 
               }
          }   
          if(searchdata.GPI__c != null && searchdata.GPI__c<>'' ){
             if(searchdata.GPI__c.contains('*')){
                   searchdata.GPI__c = searchdata.GPI__c.substring(0,searchdata.GPI__c.lastIndexOf('*'));  
                             isGPIValid = GC_Validation_Methods.valiadteGPI(searchdata.GPI__c);
           }
           else if(searchdata.GPI__c.length() !=14 || searchdata.GPI__c.contains('.')){
                isGPIValid = false;
            }
           else{
                try{
                    Double.valueof(searchdata.GPI__c);
                    }
               catch(exception e){
                        isGPIValid = false;
                    }
                 
               }
          }    
           String query =SearchQuery();
          If(isCriteriaSet && isValid && (isNDCValid) && (isGPIValid)){
            stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            stdCon.setPageSize(PAGE_SIZE);
            drugList = stdCon.getRecords();
            if(drugList.size() ==0 || drugList ==null)
                isBlankResult = true;
          }else{
           addErrorMessages();
          }
      return null;

    }
    
    public void sort(){
      if(searchSOQL != null && searchSOQL != ''){
        String query = searchSOQL + ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';      
        If(isCriteriaSet && isValid && (isNDCValid) && (isGPIValid)){
            stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            stdCon.setPageSize(PAGE_SIZE);
            drugList = stdCon.getRecords();

        }
      }
    }
    
    Public String SearchQuery(){
       String BaseString = 'select Id,Name,NDC__c,Rx_OTC_Indicator_Code__c,Label_Name__c,Third_Party_Restriction_Code__c,Product_Name__c,Maintenance_Drug_Code__c,GPI__c,Route_of_Administration__c,GPI_Generic_Name__c,Dosage_Form__c,DESI_Code__c,Repack_Code__c,Multi_Source_Code__c,DEA_Class_Code__c from Drug__c where Name != null';
        
        if(searchdata.NDC__c != null && searchdata.NDC__c<>''){        
        BaseString = BaseString+ ' and NDC__c LIKE'+'\''+searchdata.NDC__c +'%'+'\'';
        isCriteriaSet=true;
        }
        if(searchdata.Rx_OTC_Indicator_Code__c != null){
        BaseString = BaseString+' and Rx_OTC_Indicator_Code__c =\''+searchdata.Rx_OTC_Indicator_Code__c +'\'';
        
        }
        if(labelCriteria == 'Starts' && searchdata.Label_Name__c!= null && searchdata.Label_Name__c <>''){
            BaseString = BaseString+' and Label_Name__c LIKE'+'\''+ searchdata.Label_Name__c +'%'+'\'';
            isCriteriaSet=true;
        }
        
        else if(labelCriteria =='Includes' && searchdata.Label_Name__c != null && searchdata.Label_Name__c <>''){
            BaseString = BaseString+' and Label_Name__c LIKE'+'\''+'%'+ searchdata.Label_Name__c +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(searchdata.Label_Name__c != null && searchdata.Label_Name__c <>''){
            BaseString = BaseString+' and Label_Name__c ='+'\''+ searchdata.Label_Name__c +'\'';
            isCriteriaSet=true;
        }
        if(searchdata.Third_Party_Restriction_Code__c != null){
        BaseString = BaseString+' and Third_Party_Restriction_Code__c =\''+searchdata.Third_Party_Restriction_Code__c +'\'';
       
        }
        
        if(searchdata.Maintenance_Drug_Code__c != null){
        BaseString = BaseString+' and Maintenance_Drug_Code__c =\''+searchdata.Maintenance_Drug_Code__c +'\'';
        
        }
        if(searchdata.GPI__c != null && searchdata.GPI__c <>''){
        BaseString = BaseString+' and GPI__c LIKE '+'\''+searchdata.GPI__c +'%'+'\'';
        isCriteriaSet=true;
        }
        if(searchdata.Route_of_Administration__c != null){
        BaseString = BaseString+' and Route_of_Administration__c =\''+searchdata.Route_of_Administration__c +'\'';
        
        }
        
        if(prodCriteria == 'Starts' && searchdata.Product_Name__c != null && searchdata.Product_Name__c != ''){
            BaseString = BaseString+' and Product_Name__c LIKE'+'\''+ searchdata.Product_Name__c +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(prodCriteria =='Includes' && searchdata.Product_Name__c != null && searchdata.Product_Name__c != ''){
            BaseString = BaseString+' and Product_Name__c LIKE'+'\''+'%'+ searchdata.Product_Name__c+'%'+'\'';
            isCriteriaSet=true;
        } 
        else if(searchdata.Product_Name__c != null && searchdata.Product_Name__c != '') {
            BaseString = BaseString+' and Product_Name__c ='+'\''+ searchdata.Product_Name__c +'\'';
            isCriteriaSet=true;
        }
        if(gciCriteria == 'Starts' && searchdata.GPI_Generic_Name__c != null && searchdata.GPI_Generic_Name__c !=''){
            BaseString = BaseString+' and GPI_Generic_Name__c LIKE'+'\''+ searchdata.GPI_Generic_Name__c +'%'+'\'';
            isCriteriaSet=true;
        }
        else if(gciCriteria =='Includes' && searchdata.GPI_Generic_Name__c != null && searchdata.GPI_Generic_Name__c !=''){
            BaseString = BaseString+' and GPI_Generic_Name__c LIKE'+'\''+'%'+ searchdata.GPI_Generic_Name__c+'%'+'\'';
            isCriteriaSet=true;
        } 
        else if(searchdata.GPI_Generic_Name__c != null && searchdata.GPI_Generic_Name__c !='') {
            BaseString = BaseString+' and GPI_Generic_Name__c ='+'\''+ searchdata.GPI_Generic_Name__c +'\'';
            isCriteriaSet=true;
        }
        
        if(searchdata.Dosage_Form__c != null){
        BaseString = BaseString+' and Dosage_Form__c =\''+searchdata.Dosage_Form__c +'\'';
        
        }
        if(searchdata.DESI_Code__c != null){
        BaseString = BaseString+' and DESI_Code__c =\''+searchdata.DESI_Code__c +'\'';
        
        }
        if(searchdata.Repack_Code__c != null){
        BaseString = BaseString+' and Repack_Code__c =\''+searchdata.Repack_Code__c +'\'';
        
        }
        if(searchdata.Multi_Source_Code__c != null){
        BaseString = BaseString+' and Multi_Source_Code__c =\''+searchdata.Multi_Source_Code__c +'\'';
        
        }
        if(searchdata.DEA_Class_Code__c != null){
        BaseString = BaseString+' and Repack_Code__c =\''+searchdata.DEA_Class_Code__c +'\'';
        
        }
        
        searchSOQL = BaseString;
        BaseString += ' ORDER BY ' + sortOrderMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';
        
        system.debug('****base String*******'+BaseString);
        system.debug('****Criteria*******'+isCriteriaSet);
         if(isCriteriaSet==false){            
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
               ApexPages.addMessage(myMsg);               
            }      
        return BaseString;
    } 
    Public Boolean validation(){
        boolean valid = true;
        if(labelCriteria !=null && searchdata.Label_Name__c == null){
            valid = false;
        }
        if(prodCriteria != null && searchdata.Product_Name__c == null ){
            valid = false;
        }
        if(gciCriteria != null && searchdata.GPI_Generic_Name__c == null ){
            valid = false;
        }
      
        return valid ;
    }
    Public void addErrorMessages(){
           if(isValid==false){            
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00116);
               ApexPages.addMessage(myMsg);               
            }
             if(isNDCValid==false && isCriteriaSet == true){            
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00042);
               ApexPages.addMessage(myMsg);               
            }
             if(isGPIValid==false && isCriteriaSet == true){            
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00039);
               ApexPages.addMessage(myMsg);               
            }
    }
    
    /* Pagging*/
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
        
            if(stdCon!=null)
                return stdCon.getHasNext();
            else
            return false;
            }
            
        
        set;
        
        
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
       
           if(stdCon!=null)
            return stdCon.getHasPrevious();
            else
            return false;
        
        }
        set;
    }
    
    public Boolean isFirst {
        get {
       
            return this.pageNumber > 1;
       }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean isLast {
        get {
        if(stdCon==null)
        return false;
            if(stdCon.getResultSize() ==0) return false;
             return stdCon.getResultSize()/PAGE_SIZE < this.pageNumber;
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            if(stdCon==null)
            {
                return null;
            }
            else
            return stdCon.getPageNumber();
            
        }
        set;
    }
    
    
 
    // returns the first page of records
    public void first() 
    {
        try{
       
            stdCon.first();
            drugList = stdCon.getRecords();
            }
            catch(Exception e)
            {
                System.debug(e);
            }
       
    }
 
    // returns the last page of records
    public void last() {
        try
        {
            stdCon.last();
            drugList = stdCon.getRecords();
        }
        catch(Exception e)
        {
            System.debug(e);
        }
    }
 
    // returns the previous page of records
    public void previous() {
            try
            {
                stdCon.previous();
                drugList = stdCon.getRecords();
            }
            catch(Exception e)
            {
                system.debug(e);
            }
         }
 
    // returns the next page of records
    public void next() {
            try
            {
                stdCon.next();
                drugList = stdCon.getRecords();
            }
            catch(Exception e)
            {
                system.debug(e);
            }
    }

}