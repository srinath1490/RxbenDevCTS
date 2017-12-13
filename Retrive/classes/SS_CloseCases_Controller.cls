public with sharing class SS_CloseCases_Controller {
 
   public  Transient Boolean              success      {get;set;}
   Public  Transient Blob                 fileContent  {get;set;}
   private Transient Blob				  Attachment;
   Public  Transient String               fileName    {get;set;}
   Public  Transient String               fileType    {get;set;}
   Public  Transient Integer              fileSize     {get;set;}
   Public  Transient String               fileString    {get;set;}
   Public  Integer                        fileLinesSize {get;set;}   
   private Generic_CSVReader              csvReader;
   private Transient List<string>         fileLines;
   private final static Integer           MAXFILESIZE=2097152; // 2MB
   private final static Integer           MAXROWS=1000;
   private final static set<String> allowedFileMIMEs =new set<String>{'text/comma-separated-values',
                                                            'text/csv',  
                                                            'application/csv', 
                                                            'application/excel', 
                                                            'application/vnd.ms-excel', 
                                                            'application/vnd.msexcelapplication/vnd.ms-excel',
                                                            'application/octet-stream'
                                                            };

public pageReference closeInternalCase(){
         success=true;
       if(fileContent==NULL){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file.');
             ApexPages.addMessage(myMsg);
             return NULL;
       }
       if(!fileName.contains('.csv')){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Not a CSV File');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
       }
       if(!allowedFileMIMEs.contains(fileType)){ 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid File Contents');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
        }
      
       else{    
            if(fileContent.size()>MAXFILESIZE){ //currently limited to 2MB
                ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'File size should be less than 2MB.');
                ApexPages.addMessage(fileMsg);
                fileContent=NULL;
                return NULL;
            }
            else{
                csvReader=new Generic_CSVReader();
                
                List<string> fileLines=csvReader.readCVSList(fileContent);
                fileLinesSize=fileLines.size();
                 if(fileLinesSize>MAXROWS){
                    ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Sorry, lite version is limited to 1000 cases.');
                    ApexPages.addMessage(fileMsg);
                    fileContent=NULL;
                    return NULL;
                }    
                else{
                    Transient List<case> caseupdateList=new List<case>();
                    Transient Map<string,List<String>> casenamemap=new Map<string,List<String>>();
                    Transient Map<string,id> internalcasemap=new Map<string,id>();
                    Transient List<String> innercasenameList=new List<String>();
                    Transient List<case> innercaseList;
                    Transient List<string> casenumberList=new List<string>();
                    Transient List<case> caseList;
                    
                    for(integer i=1;i<fileLinesSize&i<1000;i++){
                        String[] inputvalues = filelines[i].split(',');
                       // inputvalues = filelines[i].split(','); 
                        string s=inputvalues[0];
                        if(s.length()!=8){
                          ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please review input data,one or more rows under casenumber are missing leading zeros.');
                          ApexPages.addMessage(fileMsg);
                          fileContent=NULL;
                          return NULL;
                        }
                        casenumberList.add(s);
                        casenameMap.put(s,inputvalues);
                        string inc=inputvalues[2].normalizespace();
                         if(inc.length()!=8){
                          ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please review input data,one or more rows under internalcase column are missing leading zeros.'+inc+'size:'+inc.length());
                          ApexPages.addMessage(fileMsg);
                          fileContent=NULL;
                          return NULL;
                        }
                        innercasenameList.add(inc);
                      
                        
                                
                    }
                    system.debug(logginglevel.error,'InternalcaseNAMElIST:'+innercasenameList);
                    caseList=[select casenumber,status,review_notes__c,reason from case where casenumber in:casenumberList];
                    innercaseList=[select id,casenumber from case where casenumber in:innercasenameList];
                    for(case c:innercaselist){
                        internalcasemap.put(c.casenumber,c.id);
                    }
                    system.debug(logginglevel.error,'InternalcaseMap:'+internalcasemap);
                    for(case c:caseList){
                        c.status='Closed';
                        c.Reason='Duplicate';
                        c.Review_Notes__c=casenameMap.get(c.casenumber)[1]+'\n'+c.Review_Notes__c;
                        //system.debug(logginglevel.error,'getting value:'+casenameMap.get(c.casenumber)[2]);

                        //system.debug(logginglevel.error,'getting value:'+internalcasemap.get(casenameMap.get(c.casenumber)[2].normalizespace()));
                        c.Related_Internal_CRD_Case__c=internalcasemap.get(casenameMap.get(c.casenumber)[2].normalizespace());
                        caseupdateList.add(c);
                    }
                 system.debug(logginglevel.error,'caseupdateList:'+caseupdateList);
                try{   
                    update caseupdateList;
                }catch(exception e){
                    success=false;
                    system.debug(logginglevel.error,'Exception:'+e);
                }
               
               // fileContent=NULL;
                    
                }
            }
            
       }
       confirmationMessage();
        return NULL;
   }//end closeInternalCase()
   
   public pageReference closeCase(){
       success=true;
       if(fileContent==NULL){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file.');
             ApexPages.addMessage(myMsg);
             return NULL;
       }
       if(!fileName.contains('.csv')){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Not a CSV File');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
       }
       if(!allowedFileMIMEs.contains(fileType)){ 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid File Contents');
             fileContent=NULL;
             ApexPages.addMessage(myMsg);
             return NULL;
        }
      
       else{    
            if(fileContent.size()>MAXFILESIZE){ //currently limited to 2MB
                ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'File size should be less than 2MB.');
                ApexPages.addMessage(fileMsg);
                fileContent=NULL;
                return NULL;
            }
            else{
                
                csvReader=new Generic_CSVReader();

                List<string> fileLines=csvReader.readCVSList(fileContent);
                fileLinesSize=fileLines.size();

                if(fileLinesSize>MAXROWS){
                    ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Sorry, lite version is limited to 1000 cases.');
                    ApexPages.addMessage(fileMsg);
                    fileContent=NULL;
                    return NULL;
                }                
                else{
                
                        Transient List<case> caseupdateList=new List<case>();
                        Transient Map<string,List<String>> casenamemap=new Map<string,List<String>>();
                        Transient List<case> caseList;
                        Transient List<string> casenumberList=new List<string>();
                        for(integer i=1;i<fileLinesSize&i<1000;i++){
                        String[] inputvalues = filelines[i].split(',');
                       // inputvalues = filelines[i].split(',');
                        string s=inputvalues[0].normalizespace();
                        if(s.length()!=8){
                          ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please review input data,one or more rows under casenumber are missing leading zeros.');
                          ApexPages.addMessage(fileMsg);
                          fileContent=NULL;
                          return NULL;
                        } 
                        casenumberList.add(s);
                        
                        casenameMap.put(s,inputvalues);
                                
                    }
                    caseList=[select casenumber,status,review_notes__c,reason from case where casenumber in:casenumberList];
                    for(case c:caseList){
                        c.status='Closed';
                        c.Reason='Duplicate';
                        c.Review_Notes__c=casenameMap.get(c.casenumber)[1]+'\n'+c.Review_Notes__c;
                        caseupdateList.add(c);
                    }
                try{    
                    update caseupdateList;
                 }catch(exception e){
                     success=false;
                     system.debug(logginglevel.error,'Exception:'+e);

                 }
                
               // fileContent=NULL;
                    
                }
            }
            
       }
       confirmationMessage();
       return NULL;
        
   }//end closecase()
   
   private void confirmationMessage(){
       if(success){
          Id jobid=JobLogger.create(NULL,NULL,NULL,'Closed cases',UserInfo.getUserId(),NULL,True,'CloseCases',fileContent);
          ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.CONFIRM,'Successfully closed '+fileLinesSize+' cases.'+'  For your reference, please note the Job ID:'+jobid);
          ApexPages.addMessage(fileMsg);
          
          fileContent=NULL;
       }else{
       	  fileContent=NULL;
          ApexPages.Message fileMsg = new ApexPages.Message(ApexPages.severity.FATAL,'System encountered error updating cases. Please try again.');
          ApexPages.addMessage(fileMsg);
               
       }
     
   }
   
   public class closecasesException extends Exception{}
}