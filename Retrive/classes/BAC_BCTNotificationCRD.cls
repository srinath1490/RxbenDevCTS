/*Purpose: Batch Class to process CRD's from BCT Notification CRD object   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            10/8/2013           Batch Class to process CRD's from BCT Notification CRD object    

======================================================================== */
global class BAC_BCTNotificationCRD implements Database.Batchable<sObject>{
      global String query;
            
      global BAC_BCTNotificationCRD (){
        query='Select Id,Name,Account__c,CRD_ID__c,Error__c,Plan_Description__c,Cloned_CRD__c,Processed__c from BCT_Notification_CRD__c where Processed__c = False and Error__c = false';
      }  
      
      global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(query);
      }
      
      global void execute(Database.BatchableContext BC, List<sObject> scope){
        try{
          for(SOBJECT s :Scope){
              BCT_Notification_CRD__c CurrentInstance = (BCT_Notification_CRD__c)s;
             try{   
                //Create new CRD
                Crd__c newcrd = new Crd__c();
                insert newcrd;
                
                //Clone from Existing CRD
                String Selectedid = CurrentInstance.CRD_ID__c;
                VFP_CloneCRD clonecrd = new VFP_CloneCRD();
                clonecrd.cloneCrdWithItems(Selectedid, newcrd, False);
                
                //Update Account and Plan Description
                newcrd.Account__c = CurrentInstance.Account__c;
                newcrd.Plan_Description__c = CurrentInstance.Plan_Description__c;
                update newcrd;
                
                //Update BCT Notification CRD Record
                CurrentInstance.Cloned_CRD__c = newcrd.id;
                CurrentInstance.Processed__c = true;
                
                //Create Ai Request
                GC_Utils_BCT AIRequest = new GC_Utils_BCT();                
                AIRequest.sendToAi1(newcrd);            
                                    
              } catch (exception e) {
                System.debug('%%%% Exception in BAC_BCTNotificationCRD : ' + e);
                CurrentInstance.Error__c = True;
                CurrentInstance.Description__c= 'Message: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString();
             } 
            
          }
             update scope;
        } catch (exception e){
            System.debug('%%%% Exception in BAC_BCTNotificationCRD : ' + e);
        }   
      }
      
      global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('SCH_BCTNotificationCallout' + sysTime.getTime(), chron_exp, new SCH_BCTNotificationCallout());
      }
      
      }