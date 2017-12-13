/*Purpose: Apex  Controller Class for VFP_TPIDSendToAI
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0        Abhishek Goel          08/07/2014         Implemented request 05012
======================================================================== */
global class VFP_TPIDSendToAI {
   public list < String > errorMessages {get;set;}
   Public AI_Request__c aiReq {get;set;}
   public crd__c dumCrd;
   public Id jobid;
   public string TPID {get;set;}
   public String message {get;set;}
   public Boolean result {get;set;}
   Public set<Id> setAiId = new set<Id>(); 
   Public List<AI_Request__c> aiRequestList = new List<AI_Request__c>();
   public  Transient Boolean              success      {get;set;}
   Public  Transient Blob                 fileContent  {get;set;}
   private Transient Blob                 Attachment;
   Public  Transient String               fileName    {get;set;}
   Public  Transient String               fileType    {get;set;}
   Public  Transient Integer              fileSize     {get;set;}
   Public  Transient String               fileString    {get;set;}
   Public  Integer                        fileLinesSize {get;set;}   
   private Generic_CSVReader              csvReader;
   private Transient List<string>         fileLines;
   private final static Integer           MAXFILESIZE=2097152; // 2MB
   private final static Integer           MAXROWS=1000;
   public boolean isRunning {get;set;}
   public list<AsyncApexJob> listAsyncApexJob {get;set;} 
   private final static set<string> setStatus = new set<string>{'Queued','Processing','preparing'};
   private final static set<String> allowedFileMIMEs =new set<String>{'text/comma-separated-values',
                                                            'text/csv',  
                                                            'application/csv', 
                                                            'application/excel', 
                                                            'application/vnd.ms-excel', 
                                                            'application/vnd.msexcelapplication/vnd.ms-excel',
                                                            'application/octet-stream'};
   public VFP_TPIDSendToAI(){
       loadExistingBatch();
   }
                                                    
    public pageReference sendTPIDToAi(){
        aiRequestList.clear();
        success=true;
        if(fileContent==NULL){
            // message = 'Please select a file.';
            // result = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file.');
             ApexPages.addMessage(myMsg);
             return NULL;
        }
        if(!fileName.contains('.csv')){
            // message = 'Not a CSV File';
           //  result = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Not a CSV File');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
       }
       if(!allowedFileMIMEs.contains(fileType)){ 
           //  message = 'Invalid File Contents';
           //  result = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid File Contents');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
        }else{
              if(fileContent.size()>MAXFILESIZE){
                //  message = 'File size should be less than 2MB.';
               //   result = true;
                  ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'File size should be less than 2MB.');
                  ApexPages.addMessage(fileMsg);
                  fileContent=NULL;
                  return NULL;
              }else{
                  csvReader=new Generic_CSVReader();
                  List<string> fileLines=csvReader.readCVSList(fileContent);
                  fileLinesSize=fileLines.size();
                  system.debug('>>fileLinesSize'+fileLinesSize);
                  if(fileLinesSize>MAXROWS){
                  //  message = 'File should have no more than 1000 rows';
                   // result = true;
                    ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'File should have no more than 1000 rows');
                    ApexPages.addMessage(fileMsg);
                    fileContent=NULL;
                    return NULL;
                  }else{
                       Transient List<string> tpidList=new List<string>();
                       system.debug('fileLines'+fileLines);
                       for(integer i=1;i<fileLinesSize&i<1000;i++){
                           String[] inputvalues = filelines[i].split(',');
                           string s=inputvalues[0];
                           tpidList.add(s);
                       }
                        if(tpidList.size()>0){
                            system.debug('>>tpidList'+tpidList);
                            jobid=JobLogger.create(NULL,NULL,NULL,NULL,UserInfo.getUserId(),NULL,false,NULL,NULL);
                           //create dummy crd
                           dumCrd = new crd__c();
                           insert dumCrd;
                           for(integer i=0;i<tpidList.size();i++){
                                aiReq = new AI_Request__c();
                                aiReq.CRD_ID__c = dumCrd.id;
                                aiReq.Request_Type__c = 'Traditional_Packaged';
                                aiReq.Plan_ID__c = tpidList[i];
                                aiReq.Pricing_Schedule__c = 'Y4';
                                aiReq.Risk_Indicator__c = 'R';
                                aiReq.Job_Logger__c = jobid;
                                aiRequestList.add(aiReq);
                                system.debug('>>aiRequestList'+aiRequestList);
                           } 
                            try{ 
                                if(aiRequestList.size()>0){
                                    insert aiRequestList;
                                    system.debug('>>>aiRequestList'+aiRequestList);
                                }
                            }catch(exception e){
                                success=false;
                                system.debug(logginglevel.error,'Exception:'+e);
                            }
                        }else{
                                ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'File should have 1 TPID per row');
                                ApexPages.addMessage(fileMsg);
                                fileContent=NULL;
                                return NULL;
                        }
                           
                    }
              }
        }
      //  confirmationMessage();
        List<crd__c> delCrd = [select Id from crd__C where Id=:dumCrd.id];
        system.debug('file content'+fileContent);
        Database.executeBatch(new BAC_MassTPIDSend2AI(jobid,delcrd,fileContent),1);
        loadExistingBatch();
        return null;
    }
    
    public void loadExistingBatch(){
         isRunning = false;   
        for(AsyncApexJob async : [Select Id from AsyncApexJob where ApexClass.Name =:'BAC_MassTPIDSend2AI'  and Status in:setStatus limit 1]){
           if(async!=null){
               isRunning = true;
           }
        }
    }
    public pageReference resetDataLoad(){
       fileContent = null;
       fileType = null;
       fileSize=null;
       fileName=null;
       return null;
   }
}