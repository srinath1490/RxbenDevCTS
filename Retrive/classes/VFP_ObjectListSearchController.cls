public with sharing class VFP_ObjectListSearchController {
        
    Public Object_List_Item__c searchdata{get;set;}
    Public Object_List_Item__c searchdataDummy{get;set;}
    Public Object_List__c objectListSearch{get;set;}
    Public List<SelectOption> options{get;set;}      
    Public string funding{get;set;}
    Public string listvalue{get;set;}
    Public string recordType{get;set;}
    Public string objectId{get;set;}
    Public string objectName{get;set;}
    Public string objectNameCriteria{get;set;}
    Public string description{get;set;}
    Public string descriptionCriteria{get;set;}
    Public string valueCriteria{get;set;}
    Public List<Object_List__c> objectListdata{get;set;}
    private Integer searchMaxSize = 25;
    public String searchSOQL {get;set;}
    Public Boolean isBlankResult{get;set;}
    Public Map<String,Id> recTypeMap;
    Public Map<Id,String> ItemrecTypeMap;
    Public string ObjectListrecordtype;
    Public Boolean isValid{get;set;}
    
    Public boolean isCriteriaSet;
    public static final List<Schema.PicklistEntry> plateformList= Object_List__c.Platform__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> segmentList= Object_List__c.Segment__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> fundingList= Object_List__c.Funding__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> stateList= Object_List__c.State__c.getDescribe().getPicklistValues();
    
            /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 25;
         
        /* Sorting Parameters */
    Map<String,String> sortColumnMap = new Map<String,String>{'Id'=>'Name'
                                                             ,'RecordType' => 'RecordTypeId'
                                                             ,'Name' => 'Object_List_Name__c'
                                                             ,'Description' => 'Object_List_Description__c'};
     Map<Integer,String> sortDirMap = new Map<Integer,String>{1 =>'ASC' , 2 => 'DESC'};
     public String sortOrder {get;set;}
     public Integer sortDir {get;set;}
    
    public VFP_ObjectListSearchController(ApexPages.StandardController controller) {  
        objectListSearch = new Object_List__c();
        searchdata=  new Object_List_Item__c();
        ItemrecTypeMap = new Map<Id,String>();
        List<Schema.RecordTypeInfo> objListrecType = Object_List_Item__c.sObjectType.getDescribe().getRecordTypeInfos();               
        objectListdata = new List<Object_List__c>();
        //RecordType PickList
        options = new List<SelectOption>();
        options.add(new Selectoption('','-None--'));
        for(Schema.RecordTypeInfo recType : objListrecType){                     
             if(recType.name !='Master'){
                 options.add(new Selectoption(recType.getRecordTypeId(),recType.name));
                 ItemrecTypeMap.Put(recType.getRecordTypeId(),recType.name);
             }

        }
    } 
    
    Public Pagereference doObjectSearch(){
        sortDir =1;
        sortOrder = 'Id';
        recTypeMap = new  Map<String,Id>();
        List<Schema.RecordTypeInfo> objrecType = Object_List__c.sObjectType.getDescribe().getRecordTypeInfos();               
        for(Schema.RecordTypeInfo recType : objrecType){                     
             recTypeMap.put(recType.name,recType.getRecordTypeId());
        }
        if(recordType != null)
            ObjectListrecordtype =recTypeMap.get(ItemrecTypeMap.get(recordType));
        string query = searchString(); 
        objectListdata = new List<Object_List__c>();
         isValid =validation();
         if(isValid){
	        try{
	        stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
	        stdCon.setPageSize(PAGE_SIZE);
	        objectListdata = stdCon.getRecords();
	        }catch(exception e){

	        } 
         }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.CL0000002);
                ApexPages.addMessage(myMsg);
         }         
         if(objectListdata.size() ==0 ||objectListdata ==null)
              isBlankResult = true;
        return null;   
    }
    Public void recordtypeupdate(){
            searchdata.RecordTypeId = null;
        if(recordType != null){        
            searchdata.RecordTypeId =recordType;
            searchdata.Qualifiers__c = null;
        }
    }

     public List<SelectOption> getfundingList() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('','None')); 
             for(Schema.PicklistEntry P : fundingList)             
                 options.add(new Selectoption(p.getValue(),p.getLabel()));      

            return options;
     }

    Public string searchString(){
        string baseString = 'select Id,Name,RecordType.Name,Object_List_Description__c ,Object_List_Name__c  from Object_List__c where Inactive__c = false';
        if(recordType != null){
            baseString = baseString+' and RecordTypeId ='+'\''+ObjectListrecordtype+'\'';
        }
        if(objectName <>'' && objectNameCriteria =='Starts'){
            baseString = baseString+' and Object_List_Name__c Like '+'\''+objectName+'%'+'\'';
         }
         else if(objectName <>'' && objectNameCriteria =='Includes'){
             baseString = baseString+' and Object_List_Name__c  Like '+'\''+'%'+objectName+'%'+'\'';
         }
         else if(objectName <>''){
            baseString = baseString+' and Object_List_Name__c ='+'\''+objectName+'\'';
        }
        if(description <>'' && descriptionCriteria =='Starts'){
            baseString = baseString+' and Object_List_Description__c Like '+'\''+description+'%'+'\'';
         }
         else if(description <>'' && descriptionCriteria =='Includes'){
             baseString = baseString+' and Object_List_Description__c Like '+'\''+'%'+description+'%'+'\'';
         }
         else if(description <>''){
            baseString = baseString+' and Object_List_Description__c ='+'\''+description+'\'';
        }

        if(funding <>'' && funding != null){
            baseString = baseString+' and Funding__c ='+'\''+funding+'\'';
        }

                //Sub Query on Object List Item
        if((searchdata.Qualifiers__c != null || searchdata.Value__c != null) && recordType != null){

            baseString = baseString+' and ID IN(Select Object_List__c from Object_List_Item__c where RecordTypeId ='+'\''+recordType+'\'';
                    
            if(searchdata.Qualifiers__c <>'' && searchdata.Qualifiers__c != null){
                baseString = baseString+' and Qualifiers__c ='+'\''+searchdata.Qualifiers__c+'\'';
            }
            if(searchdata.Value__c <>'' && searchdata.Value__c != null  && valueCriteria =='Starts'){
                baseString = baseString+' and Value__c Like '+'\''+searchdata.Value__c+'%'+'\'';
            }
            else if(searchdata.Value__c <>'' && searchdata.Value__c != null  && valueCriteria =='Includes'){
                baseString = baseString+' and Value__c Like '+'\''+'%'+searchdata.Value__c+'%'+'\'';
            }
            else if(searchdata.Value__c <>'' && searchdata.Value__c != null  ){
            baseString = baseString+' and Value__c ='+'\''+searchdata.Value__c+'\'';
            }
            baseString += ' )';
        }
        searchSOQL = baseString;
        baseString += ' ORDER BY ' + sortColumnMap.get(sortOrder) + ' ' +   sortDirMap.get(sortDir);
        system.debug('****base String*******'+baseString);        
        return baseString;
    }
    public List<SelectOption> getcriteia() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new Selectoption('Starts',''));
         options.add(new Selectoption('Includes',''));
         return options;
     } 
    //Sorting
    public void sort(){
      if(searchSOQL != null && searchSOQL != ''){
        String query = searchSOQL + ' ORDER BY ' + sortColumnMap.get(sortOrder) + ' ' + sortDirMap.get(sortDir) + ' NULLS LAST';
        system.debug('*****************sort**********searchSoql-->' + query);
            stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            stdCon.setPageSize(PAGE_SIZE);
            objectListdata = stdCon.getRecords();
      }
    }
    Public boolean validation(){
        boolean valid = true;
        if(recordType ==null && objectName =='' && description=='' && searchdata.Qualifiers__c == null){
            valid = false;
            system.debug('***Validation1****'+valid);
        }
        if(searchdata.Qualifiers__c == null && searchdata.Value__c != null){
            valid = false;
            system.debug('***Validation2****'+valid);
        }
        return valid;
    }   

 /* Pagging*/
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return (objectListdata == null || (objectListdata != null && objectListdata.size() > searchMaxSize));
        }
        set;
    }
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
        objectListdata = stdCon.getRecords();
    }
 
    // returns the last page of records
    public void last() {
        stdCon.last();
        objectListdata = stdCon.getRecords();
    }
 
    // returns the previous page of records
    public void previous() {
        stdCon.previous();
        objectListdata = stdCon.getRecords();
    }
 
    // returns the next page of records
    public void next() {
        stdCon.next();
        objectListdata = stdCon.getRecords();
    }
    
}