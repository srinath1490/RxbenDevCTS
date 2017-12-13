/*Purpose: Utility class GC_Utils_BCT
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Joognu        04/20/2015           Controller Class of VF_CrdMedicareImportCSV
   1.1 -    Nitish        04/21/2015           Updated Code to read CSV and create Medicare Record
======================================================================== */

public without Sharing class VFP_CrdMedicareImportCSV {

    public VFP_CrdMedicareImportCSV(ApexPages.StandardController controller) {
        
    }

public transient Blob csvFileBody{get;set;}
public  string csvAsString{get;set;}
private static list<list<String>> csvFileinarray =  new list<list<string>>();
public List<Attachment> acclist{get;set;}
public  List<case>lstCase{get;set;}
List<CRD_Medicare__c>lstCrdMedicare{get;set;}
Private static transient final string RECORDTYPE = 'External Medicare CRD';
Private static transient final string PBP = 'PBP';
Private static transient final string COMMA = ',';
Private static transient final string NEWSTRING = 'new';
Private static transient final string CRDMEDICARE = 'Medicare CRD';
Private static transient final string MEDICARENEW = 'Medicare CRD New';
Private static transient final string TEXTPLAIN = 'text/plain; charset=UTF-8';
Private static transient final string CSV = '.csv';
Private static transient final string CAT = 'case';
Private static transient final string ERR = 'An error has occured while importing data Please make sure input csv file is correct';
Private static transient final string SPACE = '';
Private static transient final string CARRIAGERETURN = '\r\n';
public list<AsyncApexJob> listAsyncApexJob {get;set;}
public boolean bval {get;set;}
//public set<ID> casesID = ReadAndPopulateBatch.setCases;
private final static set<string> setStatus = new set<string>{'Queued','Processing','preparing'}; public boolean isRunning {get;set;}
public Datetime CurrentDate {get;set;}
Map <String,CrdCVSMedicare__c> fieldcustomMap = new map<string,CrdCVSMedicare__c>();
public transient Boolean bRenderTable{get;set;}
public List<case> cvscase = new List<case>();
set<Id>setCases = new set<Id>();
Public List<CRDMedicare__c> listFailedRecords{get;set;} 
public List<CRDMedicare__c>lstfailedRecords = new List<CRDMedicare__c>();
public boolean bFailedRecords{get;set;}
//public string customLabelValue{get;set;}

  public VFP_CrdMedicareImportCSV(){
    acclist  = New List<Attachment>(); 
    lstCase = new List<case>();
    lstCrdMedicare = new List<CRD_Medicare__c>();
    bRenderTable = false;  
    bFailedRecords = false; 
    
    }
    public List<WrapCase> setwrapperList(){
    return null;
    }
    public List<WrapCase> getwrapperList(){
      List<WrapCase> wrapperList = new List<WrapCase>();
     
      for(case ca:cvscase){
          if(ca.crd_medicare__c != null)
         {
         WrapCase WC = new WrapCase(ca);
         wrapperList.add(WC);
         }
        system.debug('++++==='+wrapperList);
        
        if(wrapperList.size()!=0 && !wrapperList.IsEmpty()){
            bRenderTable = true;
        }
         
     }
   system.debug('EEEE'+wrapperList.size());
     return wrapperList;
  }

  public PageReference importCSVFile(){
 
    if(csvFileBody==NULL){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,system.label.ERR0292);
            ApexPages.addMessage(myMsg);
            return null;
       }
    
    bval = true;
    
    lstfailedRecords = [select Error_Description__c,PBP_ID_del__c,name,PlanBuildID__c,UserId__c from CRDMedicare__c where UserId__c=:userInfo.getUserId()]; //CRDMedicare__c.getall().values();
    delete lstfailedRecords;
    
    string m_CSVData = csvFileBody.toString(); 
    string row = m_CSVData.subString(0, m_CSVData.indexOf(CARRIAGERETURN));
    m_CSVData = m_CSVData.subString(m_CSVData.indexOf(CARRIAGERETURN) + (CARRIAGERETURN).length(),m_CSVData.length());
    BAC_ReadAndPopulateBatch obj = new BAC_ReadAndPopulateBatch ();
    obj.m_csvFile =  m_CSVData;
    obj.HeaderRow= row;
    database.executeBatch(obj,1);
    
    CurrentDate = system.now();
    bval = true;
   system.debug('CurrentDate'+CurrentDate);
   return new PageReference ('/apex/VF_ListofMedicareCse');
            
  }
  
   public void loadExistingBatch(){
         isRunning = false;   
         listAsyncApexJob = [SELECT 
                                ApexClass.name,CompletedDate,CreatedDate,JobItemsProcessed
                                ,ExtendedStatus,Id, NumberOfErrors
                                ,ParentJobId,Status, TotalJobItems
                            FROM 
                                AsyncApexJob 
                            where 
                                ApexClass.Name = 'BAC_ReadAndPopulateBatch'
                            Order By 
                                CreatedDate DESC NULLS First 
                            LIMIT 2] ;
          system.debug(  'listAsyncApexJob' + listAsyncApexJob  );             
          //system.debug('ddddd'+listAsyncApexJob[0].CompletedDate);                 
          for(AsyncApexJob async : [Select Id from AsyncApexJob where ApexClass.Name = 'BAC_ReadAndPopulateBatch'  and Status in:setStatus limit 1]){
           isRunning = true; 
           system.debug(  'async ' + async ); 
           
                                       
           }  

          
             //system.debug('listAsyncApexJob[0].CompletedDate'+listAsyncApexJob[0].CompletedDate);   
          
          
            
          cvscase =  [Select id,casenumber,CRD_Medicare__c,crd_medicare__r.name,crd_medicare__r.CMS_Contract_ID_Plan_PBP_ID__c,Medicare_D__c,crd_medicare__r.PlanBuildID__c from case where CreatedDate >=:CurrentDate  limit 10 ];
          system.debug('_+_+_+'+cvscase );
          
          listFailedRecords = new List<CRDMedicare__c>();
          listFailedRecords = [select Error_Description__c,PBP_ID_del__c,name,PlanBuildID__c,UserId__c from CRDMedicare__c where UserId__c=:userInfo.getUserId()]; //CRDMedicare__c.getall().values();
          if(listFailedRecords.size()>0){
              bFailedRecords = true;
          }
        
           
     }                 
  public class WrapCase{
        public string ContractPBPID{get;set;}
        public string PlanBuildID{get;set;}
        public string CRDMedID {get;set;}
        public ID CaseID {get;set;}
        public ID MedID {get;set;}
        public string caNum{get;set;}
        
        Public WrapCase(Case c)
        {
        ContractPBPID = c.crd_medicare__r.CMS_Contract_ID_Plan_PBP_ID__c;
        PlanBuildID = c.crd_medicare__r.PlanBuildID__c;
        CRDMedID = c.crd_medicare__r.name;
        CaseID = c.id;
        caNum = c.casenumber;
        MedID = c.crd_medicare__c;
        }
  }
  }