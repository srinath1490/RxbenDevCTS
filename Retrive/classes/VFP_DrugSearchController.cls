/*Purpose: Apex Class for VFP_DrugSearch Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 07/06/2011       Apex Class for VFP_DrugSearch Page.
======================================================================== 
*/
public with sharing class VFP_DrugSearchController {
    
    //Public List<Drug__c> drugs{get;set;}
    Public transient Map <Id,Drug__c> DrugMap;
    Public Id drugListId ;
    //Public List<Drug_List_Criteria__c> SearchList;
    Public Drug_List__c parentDrugList{get;set;}
   // public string BaseString;
            
    /* Pagging */
    public ApexPages.StandardSetController stdCon{get;set;}
    Integer PAGE_SIZE = 50;

    public VFP_DrugSearchController(ApexPages.StandardController controller) {
          DrugMap = new Map<Id,Drug__c>();
            drugListId = controller.getRecord().Id;
            parentDrugList = (Drug_List__c)controller.getRecord();
            parentDrugList = [select Id,Name,Description__c from Drug_List__c where Id=: parentDrugList.Id];
           List<Drug_List_Criteria__c> SearchList = new List<Drug_List_Criteria__c>([Select Id,Name,DESI__c,Drug_Code_Value__c,Drug_List__c,
                                                Drug_Type_Code__c,Maintenance__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,
                                                 Non_Maintenance__c,OTC__c,Repack__c,Rx__c from Drug_List_Criteria__c where Drug_List__c =:  drugListId]);

        if(SearchList.size()>0){
             for(Drug_List_Criteria__c drugListCriteria:SearchList){
                if(Limits.getLimitQueries() > Limits.getQueries()){
                    List<Drug__c> tempDrugList = new List<Drug__c>();
                    tempDrugList = drugList(drugListCriteria);
                    if(tempDrugList.size()!= null){
                        for(Drug__c singleDrug:tempDrugList){
                           DrugMap.put(singleDrug.Id,singleDrug);
                        }
                    }
                 }
             } 
        }
        
        /****Added For Sorting****/
         //if(drugListId != null && DrugMap.size()!=0){           
           // DrugList=DrugMap.values();
         //}else{
            // DrugList=null;
         //}
         
         stdCon = new ApexPages.StandardSetController((List<Sobject>)DrugMap.Values());
         stdCon.setPageSize(PAGE_SIZE);
         DrugList = stdCon.getRecords();

        /*************************/
        
    }
public transient List<Drug__c> DrugList{get;set;}

  /* public List<Drug__c> getDrugList()
   {
       if(drugListId != null && DrugMap.size()!=0){
           
            return DrugMap.values();
        }
        else
       return null;
   }*/

   
   Public List<Drug__c> drugList(Drug_List_Criteria__c ListCriteria){   
       system.debug('****ListCriteria****'+ListCriteria.Drug_Type_Code__c);
      
        string BaseString = 'Select Id,Label_Name__c,NDC__c,'//DEA_Class_Code__c,'//DESI_Code__c,' //Dosage_Form__c,'
                     +'GPI_Generic_Name__c,GPI__c'//,Labeler_Code__c'//,Maintenance_Drug_Code__c,Multi_Source_Code__c,NDC__c'
                    // +'Product_Name__c,Repack_Code__c,Route_of_Administration__c,Rx_OTC_Indicator_Code__c,Third_Party_Restriction_Code__c
                    + ' FROM Drug__c where' 
                                 //   +'and Drug_Code_Value__c =\''+ListCriteria.Drug_Code_Value__c+'\''  
                            +' Multi_Source_Code__c IN('+msCode(ListCriteria)+')'
                            +'and Rx_OTC_Indicator_Code__c IN('+otcRX(ListCriteria)+')'
                            +'and Repack_Code__c IN('+repack(ListCriteria)+')'
                            +'and Maintenance_Drug_Code__c IN('+maintenance(ListCriteria)+')'
                            +'and DESI_Code__c IN('+desiCode(ListCriteria)+')';
       BaseString= BaseString + DrugCodevalue(ListCriteria) ; 
       //integer qlimit = Limits.getLimitQueryRows() - Limits.getQueryRows();  
       integer qlimit = 5000 - Limits.getQueryRows();   
        BaseString = BaseString +' LIMIT '+ qlimit;  
     // LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())];
 
          system.debug('*****Search Query*********'+BaseString);
          List<Drug__c> Drugs = new  List<Drug__c>();
          try{
          //stdCon = new ApexPages.StandardSetController(Database.getQueryLocator(BaseString));
          //stdCon.setPageSize(PAGE_SIZE);
          Drugs = Database.query(BaseString);//stdCon.getRecords();
          }catch (exception e){   
          }
               
           return Drugs;
   }
   Public String msCode(Drug_List_Criteria__c Criteria){
       string codeString ='';
       if(Criteria.MS_Code_M__c == true){
           codeString =codeString +'\''+'M'+'\''+',';
       }
       if(Criteria.MS_Code_N__c == true){
           codeString =codeString +'\''+'N'+'\''+',';       
       }
       if(Criteria.MS_Code_O__c == true){
           codeString =codeString +'\''+'O'+'\''+',';       
       }
       if(Criteria.MS_Code_Y__c == true){
           codeString =codeString +'\''+'Y'+'\''+',';       
       }
       if(codeString.contains(',')){
       codeString = codeString.substring(0,codeString.lastIndexof(','));              
        }      
       system.debug('MSCODE Strin ****'+codeString);
       return codeString;
       
   }
   Public String otcRX(Drug_List_Criteria__c Criteria){
          string codeString ='';
          if(Criteria.Rx__c == true){
               codeString =codeString +'\''+'R'+'\''+',';       
               codeString =codeString +'\''+'S'+'\''+',';       
          }
          if(Criteria.OTC__c == true){
               codeString =codeString +'\''+'P'+'\''+',';       
               codeString =codeString +'\''+'O'+'\''+',';       
          }
       codeString = codeString.substring(0,codeString.lastIndexof(','));              
          return codeString;  
   }
   Public String repack(Drug_List_Criteria__c Criteria){
          string codeString ='\''+'\''+',';
          if(Criteria.OTC__c == true){
                codeString =codeString +'\''+'X'+'\''+',';       
          }
       codeString = codeString.substring(0,codeString.lastIndexof(','));              
          return codeString;   
   }
   Public String maintenance(Drug_List_Criteria__c Criteria){
          string codeString ='';
          if(Criteria.Maintenance__c == true){
                   codeString =codeString +'\''+'X'+'\''+',';       
          }
          if(Criteria.Non_Maintenance__c == true){ 
                  codeString =codeString +'\''+'\''+',';       
          }   
       codeString = codeString.substring(0,codeString.lastIndexof(','));              
          return codeString;
   }        
   Public String desiCode(Drug_List_Criteria__c Criteria){
          string codeString ='';
                 codeString =codeString +'\''+'Non-drug and other non-applicable items'+'\''+',';       
                 codeString =codeString +'\''+'2'+'\''+',';       
                 codeString =codeString +'\''+'3'+'\''+',';       
          if(Criteria.DESI__c == true){
                 codeString =codeString +'\''+'4'+'\''+',';       
                 codeString =codeString +'\''+'5'+'\''+',';       
                 codeString =codeString +'\''+'6'+'\''+',';
          }  
       codeString = codeString.substring(0,codeString.lastIndexof(','));              
          return codeString; 
   }
   Public String DrugCodevalue(Drug_List_Criteria__c Criteria){
       string codeString='';
       if(Criteria.Drug_Type_Code__c == system.label.CL0000004){
       system.debug('****GPI**1***'+Criteria.Drug_Code_Value__c);
           if(Criteria.Drug_Code_Value__c.contains('*')){
           system.debug('****GPI***2**'+Criteria.Drug_Code_Value__c);
               Criteria.Drug_Code_Value__c = Criteria.Drug_Code_Value__c.substring(0,Criteria.Drug_Code_Value__c.lastIndexof('*'));
           }
           system.debug('****GPI**3***'+Criteria.Drug_Code_Value__c);
           if(Criteria.Drug_Code_Value__c <> ''){
           codeString=+ ' and GPI__c Like'+'\''+Criteria.Drug_Code_Value__c+'%'+'\'';
           }
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000003){
           codeString=+ ' and NDC__c like'+'\''+Criteria.Drug_Code_Value__c+'%'+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000009){
           codeString=+ ' and AHFS_Therapeutic_Class_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       } 
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000008){
           codeString=+ ' and Third_Party_Restriction_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000010){
           codeString=+ ' and DEA_Class_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000011 ){       
           codeString=+ ' and Labeler_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000012){
           codeString=+ ' and Dosage_Form__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000013){
           codeString=+ ' and Repack_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000014){
           codeString=+ ' and DESI_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }
       else if(Criteria.Drug_Type_Code__c == system.label.CL0000015){
           codeString=+ ' and Maintenance_Drug_Code__c ='+'\''+Criteria.Drug_Code_Value__c+'\'';
       }        
       return codeString; 
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
        DrugList = stdCon.getRecords();
    }
 
    // returns the last page of records
    public void last() {
        stdCon.last();
        DrugList = stdCon.getRecords();
    }
 
    // returns the previous page of records
    public void previous() {
        stdCon.previous();
        DrugList = stdCon.getRecords();
    }
 
    // returns the next page of records
    public void next() {
        stdCon.next();
        DrugList = stdCon.getRecords();
    }
 
   
}