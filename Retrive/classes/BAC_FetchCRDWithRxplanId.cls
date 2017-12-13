global class BAC_FetchCRDWithRxplanId implements Database.Batchable<sObject>{
      global String query;
      private Savepoint sp; 
            
      global BAC_FetchCRDWithRxplanId(){
        query='select id,Rxplanid__c,Successfully_Sent_To_AI__c,Has_AI_Error__c,Crd__c, For_NPP__c,For_In_State__c,Cloned_CRD_ID__c,Dummy_crd__c, name from Batch_Logger__c where Processed__c= false and Has_Error__c= false and For_In_state__c=true and Rxplanid__c!=null';
      }  
      
      global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(query);
      }  
      
      global void execute(Database.BatchableContext BC, List<sObject> scope){
      map<String,CRD__c> mapRxPlanId2CRDrecord=new map<String,CRD__c>();
      map<String,CRD__c> mapId2CRDrecord=new map<String,CRD__c>();
      Set<String> setRxPlanIdRecords = new Set<String>(); 
      try {    
            sp = Database.setSavepoint();	
      
          for(SOBJECT s :Scope){
                  Batch_Logger__c CurrentInstance = (Batch_Logger__c)s;
                  setRxPlanIdRecords.add(CurrentInstance.Rxplanid__c);
          }
          //Fetch All CRD's for RxplanIds
          //This Query is based on the discussion with onshore that at max only 5000 records will be processed
          if(setRxPlanIdRecords != null){
             mapId2CRDrecord= new map<String,CRD__c>([select id,Rxplanid__c,name from CRD__c where Rxplanid__c in:setRxPlanIdRecords]);
          }
          
          //Map Each RxPlanId 2 CRD record
          if(mapId2CRDrecord!=null && mapId2CRDrecord.size()>0){
              for(CRD__c currentCrd:mapId2CRDrecord.values()){
                    mapRxPlanId2CRDrecord.put(currentCrd.Rxplanid__c,currentCrd);   
              }
          }
          //Find RXPlanId which dont have any CRD's
          for(SOBJECT s :Scope){
                  Batch_Logger__c CurrentlogInstance = (Batch_Logger__c)s;
                  if(mapRxPlanId2CRDrecord!=null && mapRxPlanId2CRDrecord.size()>0){
                      if(mapRxPlanId2CRDrecord.get(CurrentlogInstance.Rxplanid__c)== null){
                       CurrentlogInstance.NoCRDForInStatePP__c = true;
                      }
                      else if (mapRxPlanId2CRDrecord.get(CurrentlogInstance.Rxplanid__c)!= null){ 
                       CurrentlogInstance.CRD__c=mapRxPlanId2CRDrecord.get(CurrentlogInstance.Rxplanid__c).id;
                      }
                  }    
          }  
          update Scope;           
        } catch (exception e) {
            Database.rollback(sp);
        }  
        }
       
      
      global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Batch Process 1 Finished');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        /*Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year()+'-2023';
        system.debug(chron_exp);*/
        String query = 'select Id,CRD__c from Batch_Logger__c where Processed__c=false And For_In_State__c=True and crd__c!=null and RxPlanId__c != null';
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('SCH_CloneNPPCRD' + sysTime.getTime(),chron_exp,new SCH_CloneNPPCRD(query));
         Database.executeBatch(new BAC_CloneNPPCRD(query,false), 1);
      }
      
}