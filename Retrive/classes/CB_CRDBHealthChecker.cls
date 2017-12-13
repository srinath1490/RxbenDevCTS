/*Purpose: This class is used to send Email to a list of users in case any of any CRD Builder batch Failure
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Sushant Sethi   25 Dec,2014       This class is used to send Email to a list of users in case any of any CRD Builder batch Failure
======================================================================== */
global class CB_CRDBHealthChecker implements schedulable {

    // List for collecting all Apex jobs details
    public static list<AsyncApexJob> listAsyncApexJob {get;set;}
    
    //Set for all classes to be monitored
    private final static set<string> setClasses = new set<string>{'Batch_CRDBuildStep1', 'BAC_CB_Validations', 'BAC_CB_Completion', 'BAC_CB_MassSend2AIRequest', 'BAC_CB_MassSend2AI'/*'BAC_CB_SeedPersStep', 'BAC_CB_CAGRestructure', 'BAC_CB_CRDXMLStep'*/};
    
    // Set for identifying the status of the Job records --> queued,processing or preparing
    private final static set<string> setStatus = new set<string>{'Queued','Processing','Preparing'};
    
    // Set for identifying the status of the failed records --> status equals aborted or failed 
    private final static set<string> setFailedStatus = new set<string>{'Aborted','Failed'};
    
    //flags for collecting process status
    public static boolean isRunning;
    public static boolean isFailed;
    
    public static String CRDBHealthChecker= 'CRDBHealthChecker';
        
    //Insert in List the Processes to be Monitored for their Status --> Filters -> createddate = today/ jobtype = batchApex/ apex class name = crd builder classes
    global void execute(SchedulableContext ctx){
    listAsyncApexJob = [SELECT ApexClass.name,CompletedDate,CreatedDate,JobType,ExtendedStatus,Id,NumberOfErrors,ParentJobId,Status,TotalJobItems 
                         FROM 
                             AsyncApexJob
                         where 
                             createdDate >=: system.today() 
                                 AND 
                             Jobtype = 'BatchApex'
                                 AND
                             apexClass.Name in: setClasses
                        ];
      isRunning = false;
      isFailed = false;
      for (AsyncapexJob async : listAsyncApexJob)
      {
         if(setStatus.contains(async.status))
             {
                 isRunning = true;       //indicates running processes 
             }
         if(setFailedStatus.contains(async.status))
             {
                 isFailed = true;        //indicates failed processes
             }           

      }
     // sendEmail();
    if(isRunning || listAsyncApexJob.size() != 5 || isFailed)
           {
              sendemail(ctx.getTriggerId());
           }
    }
    
    
    webservice static void sendEmail(id cronid){
        boolean sendmail = true;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
        integer cbonSize;
        cbonSize = [SELECT id FROM CRDBuildorder__c WHERE CreatedDate = today].size(); 
        if(isRunning==true)
        {

            //if time<8AM EST.. call futuremethod     
            datetime dt = system.now();
            string hourValue =  string.valueOf(dt.hour());
                If(integer.valueof(dt.hour()) < 1)
                {
                    futuremethod( cronid, CRDBHealthChecker);
                    sendmail = false;
                }
                else{
            mail.setSubject('CRDBuilder health check fail');
            String[] toAddresse = new String[] {Label.CRDBHealthChecker};
            mail.setToAddresses(toAddresse);
            string body = 'CRD Builder health checker code has detected an issue - CRD Builder process seems to be running too long. More details:' +'\r\n'; 
            body += 'Total CBONs loaded:'+ cbonSize+'\r\n'; 
            body += 'Batch jobs:' +'\r\n'; 
                for (AsyncapexJob async : listAsyncApexJob)
              {
                 if(setStatus.contains(async.status))
                     {
                         body += async.ApexClass.name +'\r\n';   //indicates failed processes
                     }           

              }         
            mail.setplainTextBody(body);                 
                }
                
        }
        else if(isFailed==true)
        {
            mail.setSubject('CRDBuilder health check fail');
            String[] toAddresse = new String[] {Label.CRDBHealthChecker};
            mail.setToAddresses(toAddresse);
            string body = 'CRDBuilder health checker has detected an issue. One or more batches have aborted/failed.' + '\r\n';
            body += 'Total CBONs loaded:' + cbonSize +'\r\n';
            body += 'Batch jobs:'+ '\r\n';
             for (AsyncapexJob async : listAsyncApexJob)
              {
                 if(setFailedStatus.contains(async.status))
                     {
                         body += async.ApexClass.name +'\r\n';   //indicates failed processes
                     }           

              }
            mail.setplainTextBody(body);
        } 
        else if(listAsyncApexJob.size() != 5 || isFailed)
        {
            mail.setSubject('CRDBuilder health check fail');
            String[] toAddresse = new String[] {Label.CRDBHealthChecker};
            integer batchesrunning = 0;
            integer batchesfailed = 0;
            integer batchescompleted = 0;
            for (AsyncapexJob async : listAsyncApexJob){
                if(setStatus.contains(async.status))
                    batchesrunning++;
                if(setfailedStatus.contains(async.status))
                    batchesfailed++;                    
                if(!setfailedStatus.contains(async.status) && !setStatus.contains(async.status))
                    batchescompleted++;                     
            }
            mail.setToAddresses(toAddresse);
            string body = 'CRDBuilder health checker has detected that CRDbuilder process did not complete in the allocated time window. I could not find all batch records. Here is what i found:\r\n'; 
            body += 'Total CBONs: ' + cbonSize + '\r\n';
            body += 'Completed batches:' + batchescompleted + '\r\n';
            body += 'Batches in progress:' + batchesrunning + '\r\n';

             for (AsyncapexJob async : listAsyncApexJob)
              {
                 if(setStatus.contains(async.status))
                     {
                         body += async.ApexClass.name + '\r\n' ;  //indicates failed processes
                     }           

              }
            body += 'Batches that have not yet started:' + string.valueof(setclasses.size() - listAsyncApexJob.size()) + '\r\n';
            mail.setplainTextBody(body); 
        }
        if(sendmail )
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
    }
    
    // Function to reschedule the Collection of failed records based on finding any Process which is currently in Queued,Processing or Preparing state.
    @future
    public static void futuremethod(Id cronId,String strJobName)
    {   
    
            System.debug('cronId ' + cronId);
            
            DateTime dte = system.now();                
            dte = dte.addMinutes(60);                
            String day = string.valueOf(dte.day());        
            String month = string.valueOf(dte.month());        
            String hour = string.valueOf(dte.hour());
            String year = string.valueOf(dte.year());
            String minute = string.valueOf(dte.minute());
            String second = string.valueOf(dte.second());                                
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            
            try{    
                CronTrigger t  = [SELECT Id FROM CronTrigger where Id =: cronId];
                System.abortJob(t.Id); //abort the job
            }
            catch(Exception e){
                system.debug('Abort Exception ' + e.getMessage());
            } 
               
            try{   
            //schedule the job
                System.schedule(strJobName, strSchedule, new CB_CRDBHealthChecker());
            }
            catch (exception e){
                system.debug('Schedule Exception ' + e.getMessage());
            }   

    }  

}