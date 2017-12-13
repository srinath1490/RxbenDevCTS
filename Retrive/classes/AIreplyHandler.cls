/*
Project: Aetna.8380
Team Lead: Josh Turnof; joshua.turnof@accenture.com
Developer: Saraag Reddy: rsaraag@gmail.com
Package: None
Dependencies: 8269c.Aetna Integrator; Lead by: Mike Bougie; bougiem@aetna.com
Requires: CRD__c, Task, Case,IntegrationLog__c,IntegrationLogger.cls
Description: class is called by IntegrationDispatcher, used as a worker class to handle BCTnotifications,replies,errors. Create cases,tasks,CRD etc.
*/
public class AIreplyHandler{
  // Variables
   public Static String fieldsfilled='';
   QueueSobject crdqueue;
   IntegrationLogger logger=new IntegrationLogger();
   
   //Methods
   public void BCTnotification(String Arg_RxPlanID,Map<string,string> arguments, Boolean flag,Id sourceId){
     //create new CRD with details and create a task with the lookup to CRD. Have the detail__c filled as finish CRD, assign to BCTQueue
    CRD__c newBCTrecord=new CRD__c();
    Set<String> notificationKeys=new Set<String>();
    notificationKeys=arguments.keyset();
    fieldsfilled='';
    for(String s:notificationKeys){
      if(s.contains('Date'))
         newBCTrecord.put(s,Date.valueOf(arguments.get(s)));
      else
         newBCTrecord.put(s,arguments.get(s));
       fieldsfilled+=s+',';
    }//assign field values from Aetna Integrator
// ~~~~~ REMOVE COMMENT ~~~~
    newBCTrecord.RxPlanID__c=Arg_RxPlanID;
    try{
    insert newBCTrecord;
    }catch(exception e){
      system.debug(e.getMessage());
      logger.logme(true,'Exception','Exception was caught when trying to handle BCTnotification, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
    }
    //create case and assign it to Queue.
    system.debug(newBCTrecord.Name);
    if(flag){ // Tiering TPID reply
        newBCTrecord.OwnerId=sourceId;
        Task newCRDtask=new Task();
        newCRDtask.WhatId=newBCTrecord.Id;
        system.debug(newBCTrecord.Name);
        newCRDtask.OwnerId=newBCTrecord.OwnerId;
        newCRDtask.Subject='Reply received from AI- Tiering';
        newCRDtask.Description='Aetna integrator sent back reply for your TPID, system detected Tiering. The original record was updated and a new record was created for the additional tier';
        newCRDtask.type='Integration Reply';
        try{
        insert newCRDtask;
        update newBCTrecord;
        }catch(exception e){
          system.debug(e.getMessage());
          logger.logme(true,'Exception','Exception was caught when trying to handle BCTnotification/new Task FLAG :Ln41, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
        }
        system.debug(newCRDtask.subject);
    }
    
    else{ //BCTnotification, we are currently not doing this.
        Case c=new Case();
        //Hardcoded BCT Managers queue name, change if needed.
        List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name='Case - BCT Managers' LIMIT 1];
        //crdqueue=new QueueSobject();
        if(crdqueueList.size()>0)
         crdqueue=crdqueueList[0]; // If the queue was valid and a record was found.
        if(crdqueue!=NULL){
        c.OwnerId=crdqueue.QueueId; //may cause problems
        c.Description='On notification from Aetna Integrator, a new CRD was created and was filled with the values supplied:'+fieldsfilled+ '      Please go ahead and complete creating the CRD.';
       // c.CRD_ID__c=newBCTrecord.Id;
        try{
        insert c;
        }catch(Exception e){
          system.debug(e.getMessage());
          logger.logme(true,'Exception','Exception was caught when trying to handle BCTnotification/ Else New case:Ln61, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
        }
        }//end IF CRDqueue NULL
    }
    
   }
  
  public void Rxreply(String Arg_dcn,String Arg_RxPlanID,Map<String,String> arguments,CRD__c sourceCRD){
    //SOQL on DCN, find the CRD_record and update it with the reply, make task with lookup to CRD record and assign to owner of CRD
    
    Set<String> notificationKeys=new Set<String>();
    notificationKeys=arguments.keyset();
    fieldsfilled='';
    try{
    for(String s:notificationKeys){
       sourceCRD.put(s,arguments.get(s));
       fieldsfilled+=s;
    }//assign field values from Aetna Integrator
// ~~~~~ REMOVE COMMENT ~~~~    
    sourceCRD.RxPlanID__c=Arg_RxPlanID;
    
    update sourceCRD;
    }catch(Exception e){
     system.debug(e.getMessage());
      logger.logme(true,'Exception','Exception was caught when trying to handle Rxreply/Updating CRD record, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
    }
    try{    
    system.debug(sourceCRD.Name);
    Task newCRDtask=new Task();
    newCRDtask.WhatId=sourceCRD.Id;
    newCRDtask.OwnerId=sourceCRD.OwnerId;
    newCRDtask.Subject='Reply received from AI ';
    newCRDtask.Description='Aetna integrator sent back reply for your submission, the CRD record has been updated. Please click on the CRD to review or complete the wizard';
    newCRDtask.type='Integration Reply';
    
    insert newCRDtask;
    }catch(Exception e){
      system.debug(e.getMessage());
      logger.logme(true,'Exception','Exception was caught when trying to handle Rxreply/Insert Task:Ln99, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
    }
    
    
    
  }
  public void ErrorHandler(String Arg_Error,String description){
    //BCT notification error. The request has the error element filled or has incorrect argumnents.
     Case c=new Case();
    //Hardcoded BCT Managers queue name, change if needed.
    List<QueueSobject> crdqueueList=[Select Queue.Name,QueueId from QueueSobject WHERE Queue.Name='Case - BCT Managers' LIMIT 1];
    if(crdqueueList.size()>0)
     crdqueue=crdqueueList[0];
    if(crdqueue!=NULL){
    c.OwnerId=crdqueue.QueueId; //may cause problems
    c.Description=description;
    c.subject=Arg_Error;
    try{
    insert c;
    }catch(Exception e){
      system.debug(e.getMessage());
      logger.logme(true,'Exception','Exception was caught when in ErrorHandler/inserting case:Ln114, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
    }
    }// end IF crdqueue NULL
   
    
   /* Task newCRDtask=new Task();
    newCRDtask.OwnerId=crdqueue.QueueId;
    newCRDtask.Subject=Arg_Error;
    newCRDtask.Description=description;
    insert newCRDtask;
   */
  }
  public void ErrorHandler(String Arg_Error,String description,CRD__c sourceCRD){
    //send email to BCT manager and create a task for BCT manager
   try{
    Task newCRDtask=new Task();
    newCRDtask.WhatId=sourceCRD.Id;
    newCRDtask.OwnerId=SourceCRD.OwnerId;
    newCRDtask.Subject=Arg_Error;
    newCRDtask.Description=description;
    insert newCRDtask;
    system.debug(newCRDtask.Id);
    }catch(Exception e){
     system.debug(e.getMessage());
      logger.logme(true,'Exception','Exception was caught when in ErrorHandler/New Task:Ln137, look under arguments for details',system.now(),Userinfo.getName(),'Warning',e.getMessage(),'');
    }
  }
  
  
}