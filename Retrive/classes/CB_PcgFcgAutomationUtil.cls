/*Purpose: Util Class for PCG/FCG Automation
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      10/20/2014           Revised Util Class for PCG/FCG Automation
   1.2      Richa           23/02/2015           Richa updated the method appendleadingzeroes to public to reuse
   1.3      Richa Gupta     06/24/2015           CFO update commented for Req 5868
   1.4      Abhishek goel   07/29/2015          #Request 5868 Remove autoupadate for field marketSegment,subsegment
   1.5      Amit Jain       7 April, 2016        Corrected Orgkey for ST# 797
   2.0      Amit Jain       25th April,216      Added Territory field from CFO when creating PCG, Request 6484
   2.1      Abhishek        8/2/2016            ST#1513 Replaced the map key with "notifUniqueOrgKey" at Line 304.
======================================================================== */
global class CB_PcgFcgAutomationUtil{
   
    //Open Term Date
    public final static string  OPEN_TERM_DATE = '2099-12-31';
    public final static integer queryLimit = 500;
    public final static string  RECORD_PSUID = 'PSUID__c';
    public  static boolean Batch_context = true;
    global void execute(SchedulableContext sc) {
      
    }
      
    global CB_PcgFcgAutomationUtil() {
       
       
    }   
   
   private void SetValues(NotificationModel wrap, Set<String> setOfCFO
                            ,  Map<String,List<NotificationModel>> fcgToNotifications
                            , Map<String,List<NotificationModel>> pcgToNotifications
                            , Map<String,NotificationModel> psuidtoNotificationModel){
                            
                            
        //addt this record to map pcgToNotifications based on pcgkey
       if(pcgToNotifications.containskey(wrap.PCGKey)){
            pcgToNotifications.get(wrap.PCGKey).add(wrap);
        }else if(wrap.PCGKey != null){
            pcgToNotifications.put(wrap.PCGKey, new List<NotificationModel>{wrap});
        }else{
            //Do nothing
        }               
        
        //add this record to map fcgToNotifications based on fcgkey
        if(fcgToNotifications.containskey(wrap.FCGKey)){
            fcgToNotifications.get(wrap.FCGKey).add(wrap);
        }else if(wrap.FCGKey != null){
            fcgToNotifications.put(wrap.FCGKey, new List<NotificationModel>{wrap});
        }else{
            //Do nothing
        }  
        
         //add this record to map fcgToNotifications based on fcgkey
        if(psuidtoNotificationModel.containskey(wrap.psuId)){
            NotificationModel existingWrapper = psuidtoNotificationModel.get(wrap.psuId);
            if(existingWrapper.NotificationDate < wrap.NotificationDate){
                 psuidtoNotificationModel.put(wrap.psuId, wrap);
            }
        }else{
                psuidtoNotificationModel.put(wrap.psuId, wrap);
        } 
        
        if(! String.isBlank(wrap.CFO)){      
            setOfCFO.add(wrap.CFO);     
        }
   }

    global void execute(Database.BatchableContext BC, List <sObject> scope) {
      
        executeAutomation(scope);
    }
    
    public void executeAutomation (List <sObject> scope){
            Set<string> psuids = new Set<String>();
            for(sObject s : scope){
                psuids.add((String)s.get(RECORD_PSUID));
            }
           
           Map<String, Account> mapPsuidAcc = new Map<String, Account>();
           List<NotificationModel> notificationRecords = new List<NotificationModel>();
           List<Sobject> notificationToUpdate = new List<Sobject>();
           Map<String,List<NotificationModel>> fcgToNotifications = new Map<String,List<NotificationModel>>();
           Map<String,List<NotificationModel>> pcgToNotifications = new Map<String,List<NotificationModel>>();
           map<string, Full_Control_Group__c> fcgToFCGRecord = new map<string, Full_Control_Group__c>();
           map<string, Partial_Control_Group__c> pcgToPCGRecord = new map<string, Partial_Control_Group__c>();            
           Map<String, OrgandArrangement__c> orgkeyToOrgArrangement = new Map<String, OrgandArrangement__c>();
           List<String> lstOrgKeys = new List<String>();            
           Map<String , OrgStructure__c> mapUniqueStringToOrgStr = new Map<String , OrgStructure__c>();
           set<String> setUniquePcgFcgKey = new set<string>();          
           List<OrgStructure__c> lstOrgStructureRecord = new List<OrgStructure__c>();
           List<CSAP_CGLP_Junction__c> lstCsap = new List<CSAP_CGLP_Junction__c>();   
           Map<String,NotificationModel> psuidtoNotificationModel = new  Map<String,NotificationModel>();
           
           Set<String> setOfCFO = new Set<String>();     
                for(sObject s : scope){
                    NotificationModel wrap;
                    Schema.sObjectType actualSobject = Schema.NotificationStandard__c.getSObjectType();
                    If (s.getsobjectType()==actualSobject) {
                     wrap = new NotificationModel((NotificationStandard__c)s);
                    }else{
                        wrap = new NotificationModel((notificationfallout__c )s);
                    }              
                    ///Add this wrapper into list- notificationRecords
                    notificationRecords.add(wrap);
                    this.SetValues(wrap,  setOfCFO, fcgToNotifications,  pcgToNotifications, psuidtoNotificationModel);
                    s.put('Account_CAG_Processed__c',true);
                    notificationToUpdate.add(s);             
                   this.SetValues(wrap,  setOfCFO, fcgToNotifications,  pcgToNotifications, psuidtoNotificationModel);     
               }    
           //Step -1  - Create new Account if do not exist based on PSUID   
           //
               
           for(account acc:  [select 
                                id,APM_PSUID__c,CFO_CD__c
                              from 
                                Account 
                              where 
                                APM_PSUID__c IN:psuids]){
                                    
                mapPsuidAcc.put(acc.APM_PSUID__c ,acc);
                
           }
           Map<String,CFO_Region__c> mapCfoToRegion = new  Map<String,CFO_Region__c>();
           //Amit added the field Territory__c in query for request 6484
           for(CFO_Region__c cfoRegion : [Select APM_CFO__c,CFO__c,Region__c,Market_Region__c,VPCM_Name__c,Territory__c FROM CFO_Region__c WHERE CFO__c IN : setOfCFO]){
                mapCfoToRegion.put(cfoRegion.CFO__c, cfoRegion);
           }
          Account aobject = new account();
          for(sObject s : scope){
            if(mapPsuidAcc.containsKey((string)s.get(RECORD_PSUID))){
                NotificationModel notif = psuidtoNotificationModel.get((string)s.get(RECORD_PSUID));
                    aobject = mapPsuidAcc.get((string)s.get(RECORD_PSUID));
                    aobject = updateRecordsAccount(notif,aobject,mapCfoToRegion);
            }else{
                if(psuidtoNotificationModel.containsKey((string)s.get(RECORD_PSUID))){
                    NotificationModel notif = psuidtoNotificationModel.get((string)s.get(RECORD_PSUID));
                        if(!string.isBlank(notif.Accountname)){
                            aobject = new Account();
                            aobject.APM_PSUID__c =  (string)s.get(RECORD_PSUID);
                            if(notif.Accountname!=null){
                                aobject.name = notif.Accountname;
                            }
                            aobject = updateRecordsAccount(notif,aobject,mapCfoToRegion);
                            mapPsuidAcc.put(aobject.APM_PSUID__c,aobject);
                        }
                }
            }
        
          }       
          Database.upsert (mapPsuidAcc.values(),false);       
          //Step - 2 :- Find Existing PCG, if do not exist then create new one else update existing         
          //1. Query on PCG filtering pcgToNotifications.keyset()
          //List<Partial_Control_Group__c> lstPCG = ;         
          //2. if found then iteriate pcgToNotifications.get(record.pcgkey)      
          for(Partial_Control_Group__c pcg : [select id,Account__c,Last_Synced_Date__c
                  ,LastModifiedDate, CSAP_Control_ID__c ,Rating_ERB__c,Subsegment__c,PSUID__c,Control_Group_Term_Date__c, CSAP_Plan_ID__c,
                  Product_Indicator__c,PCGKey__c,Territory__c,CFO_Code__c from Partial_Control_Group__c where PCGKey__c IN:pcgToNotifications.keyset()]){
            system.debug('-----inside pcg'+pcgToNotifications.get(pcg.PCGKey__c));
            //ST#1513 added condition below which was causing an issue of null pointer exception.
            if(pcgToNotifications.containsKey(pcg.PCGKey__c)){
                for(NotificationModel notification : pcgToNotifications.get(pcg.PCGKey__c)){     
                  if(pcg.Last_Synced_Date__c == NULL){
                        pcg.Last_Synced_Date__c = pcg.LastModifiedDate;
                    }
                    if(notification.notificationdate >= pcg.last_synced_date__c){  
                      //update with values refer automation code
                     if(mapPsuidAcc.containskey(notification.PSUID)){
                         pcg.Account__c = mapPsuidAcc.get(notification.PSUID).id;
                     }
                     //Added by Amit for Request 6484
                     if(pcg.CFO_Code__c!= Null && mapCfoToRegion.get(pcg.CFO_Code__c)!= Null && mapCfoToRegion.get(pcg.CFO_Code__c).Territory__c != Null){
                        pcg.Territory__c = mapCfoToRegion.get(pcg.CFO_Code__c).Territory__c;
                     }
                     //Ends     
                     updatePCGrecord(pcg,notification);     
                  }     
                }
                ////3. update pcg record , add into map -> pcgKey => pcg record [pcgToPCGRecord]                
                pcgToPCGRecord.put(pcg.PCGKey__c,pcg); 
            }         
          }  
          //If PCG Key does not match find in above query, then create a new PCG record and insert into database.
          for(string pcgKey : pcgToNotifications.keyset()){
            if(!pcgToPCGRecord.containsKey(pcgKey)){
                Partial_Control_Group__c objPCG = new Partial_Control_Group__c();
                for(NotificationModel notification : pcgToNotifications.get(pcgKey)){   
                     if(objPCG.last_synced_date__c == NULL){
                        objPCG.last_synced_Date__c = notification.NotificationDate;
                     }
                      if(notification.NotificationDate >= objPCG.Last_Synced_Date__c){
                           //update with values refer automation code
                           if(mapPsuidAcc.containskey(notification.PSUID)){
                               objPCG.Account__c = mapPsuidAcc.get(notification.PSUID).id;
                           }
                          objPCG = (Partial_Control_Group__c)/*BAC_PcgFcgAutomationHandler.*/updateRecordsCFO(notification,(Sobject) objPCG,mapCfoToRegion); 
                          updatePCGrecord(objPCG,notification);   
                      }          
                }             
                pcgToPCGRecord.put(pcgKey, objPCG);  
            } 
          }
          /// upsert pcgToPCGRecord.values();
          Database.upsert (pcgToPCGRecord.values(),false);         
          //Step  - 3 :- Find Exisigng FCG, if do not exist then create new one else update existing  
          //1. Query on FCG filtering fcgToNotifications.keyset()
          //List<Full_Control_Group__c> lstFCG = ;         
          //2. if found then iteriate fcgToNotifications.get(record.fcgkey)      
          for(Full_Control_Group__c fcg : [select id,FCGKey__c,lastModifiedDate,CSAP_Account_ID__c,CSAP_Control_ID__c, CSAP_Suffix_ID__c, CSAP_Plan_ID__c,
          Carrier_ID__c,Product_Indicator__c, Subsegment__c,last_synced_date__c, Control_Group_Effective_Date__c, Control_Group_Term_Date__c,
          CAG_Group_ID__c, PSUID__c,Group_Funding_Type_Code__c  from Full_Control_Group__c where FCGKey__c IN:fcgToNotifications.keyset()]){
            system.debug('-----inside FCG'+fcgToNotifications.get(fcg.FCGKey__c));
            //ST#1513 added condition below which was causing an issue of null pointer exception.
            if(fcgToNotifications.containsKey(fcg.FCGKey__c)){
                for(NotificationModel notification : fcgToNotifications.get(fcg.FCGKey__c)){
                    //update with values refer automation code
                    system.debug('-----inside pcg');
                    if(fcg.last_synced_date__c == NULL){
                         fcg.last_synced_date__c = fcg.lastModifiedDate;
                    }
                    if(notification.notificationdate >= fcg.last_synced_date__c){    
                         if(mapPsuidAcc.containskey(notification.PSUID)){
                            fcg.Account_Name__c = mapPsuidAcc.get(notification.PSUID).id;  
                         }                
                       updateFCGrecord(fcg,notification);
                   }    
                }
                ////3. update fcg record , add into map -> fcgKey => fcg record [fcgToFCGRecord]
                fcgToFCGRecord.put(fcg.FCGKey__c,fcg);   
            }
            
          }  
          //If FCG Key does not match find in above query, then create a new FCG record and insert into database.
          for(string fcgKey : fcgToNotifications.keyset()){
            if(!fcgToFCGRecord.containsKey(fcgKey)){
                Full_Control_Group__c objFCG = new Full_Control_Group__c();
                for(NotificationModel notification : fcgToNotifications.get(fcgKey)){   
                   if(objFCG.last_synced_date__c == NULL){
                        objFCG.last_synced_Date__c = notification.NotificationDate;
                   }
                   if(notification.notificationdate >= objFCG.Last_Synced_Date__c){
                       //update with values refer automation code
                     if(mapPsuidAcc.containskey(notification.PSUID)){
                         objFCG.Account_Name__c = mapPsuidAcc.get(notification.PSUID).id;
                     }
                     updateFCGrecord(objFCG,notification);          
                 }    
                }             
                fcgToFCGRecord.put(fcgKey, objFCG);  
            } 
          }         
          /// upsert fcgToFCGRecord values;
          Database.upsert (fcgToFCGRecord.values(),false);      
          
                      system.debug('---fcgToFCGRecord' + fcgToFCGRecord);         
          //Step 4 OrgId and CSAP records processing
          for(NotificationModel notif : notificationRecords){
            lstOrgKeys.add(notif.orgKey);
        }
            for(OrgandArrangement__c org :[Select 
                                            Name, id, ArrangmentId__c, ArrangmentName__c, JoinKey__c, OrgId__c, OrgType__c 
                                          from 
                                            OrgandArrangement__c
                                          where 
                                            JoinKey__c  IN:lstOrgKeys]){    
                orgkeyToOrgArrangement.put(org.JoinKey__c, org);
            }                                   
            for(OrgStructure__c org : [Select 
                                    Id, FullControlGroup__c, FullControlGroup__r.FCGKey__c,OrgandArrangement__c, OrgArrangmentId__c, JoinKey__c, OrgType__c, OrgId__c 
                                FROM 
                                    OrgStructure__c 
                                WHERE  
                                    JoinKey__c IN: lstOrgKeys AND FullControlGroup__c IN:fcgToFCGRecord.Values()]){
                mapUniqueStringToOrgStr.put('o:' + org.JoinKey__c + 'F:' + org.FullControlGroup__r.FCGKey__c, org);
            }
            for(CSAP_CGLP_Junction__c csap : [SELECT 
                                Id, Full_Control_Group__c,Full_Control_Group__r.FCGKey__c,Partial_Control_Group__c,Partial_Control_Group__r.PCGKey__c,RecordTypeId 
                            FROM 
                                CSAP_CGLP_Junction__c 
                            WHERE 
                                Full_Control_Group__c IN: fcgToFCGRecord.Values()  AND Partial_Control_Group__c IN:pcgToPCGRecord.Values()]){
                setUniquePcgFcgKey.add('F:'+ csap.Full_Control_Group__r.FCGKey__c + 'P:' + csap.Partial_Control_Group__r.PCGKey__c);
            }   
            
            Id csapcglpRecordTypeId = Schema.SObjectType.CSAP_CGLP_Junction__c.getRecordTypeInfosByName().get('Full CG to Partial CG').getRecordTypeId();                    
            for(NotificationModel notification : notificationRecords){
            
                String notifUniqueOrgKey = 'o:' + notification.orgkey + 'F:' + notification.FCGKey;
                String notifUniqueFcgPcgKey = 'F:'+ notification.FCGKey+ 'P:' + notification.PCGKey;
                
                // Org Structure Record
                System.debug('orgkeyToOrgArrangement' +orgkeyToOrgArrangement);
                System.debug('notification.orgkey' +notification.orgkey);
                if(orgkeyToOrgArrangement.containsKey(notification.orgkey)){
                    System.debug('###################' +mapUniqueStringToOrgStr.get(notifUniqueOrgKey));
                    OrgStructure__c orgStruct = mapUniqueStringToOrgStr.get(notifUniqueOrgKey);
                    if(orgStruct == null){
                        orgStruct = new OrgStructure__c();
                        orgStruct.OrgandArrangement__c = orgkeyToOrgArrangement.get(notification.orgkey).id;
                    }
                    orgStruct.FullControlGroup__c = fcgToFCGRecord.get(notification.FCGKey).id;
                    orgStruct.OrgArrangmentId__c = notification.orgarrangementid;
                    orgStruct.JoinKey__c = notification.orgkey;
                    orgStruct.OrgType__c = notification.orgType;
                    orgStruct.OrgId__c = notification.orgId;
                    mapUniqueStringToOrgStr.put(notifUniqueOrgKey , orgStruct);
                }               
                // CSAP junction Records
                if(! setUniquePcgFcgKey.contains(notifUniqueFcgPcgKey)){
                  CSAP_CGLP_Junction__c csapRecord = new CSAP_CGLP_Junction__c();
                    if(fcgToFCGRecord.size()>0 && fcgToFCGRecord.get(notification.FCGKey) !=null){
                        csapRecord.Full_Control_Group__c = fcgToFCGRecord.get(notification.FCGKey).id;
                    }
                    if(pcgToPCGRecord.size()>0 && pcgToPCGRecord.get(notification.PCGKey) !=null){                 
                        csapRecord.Partial_Control_Group__c = pcgToPCGRecord.get(notification.PCGKey).id;
                    }
                    csapRecord.RecordTypeId = csapcglpRecordTypeId;
                    lstCsap.add(csapRecord);
                    setUniquePcgFcgKey.add(notifUniqueFcgPcgKey);
                  
                }                 
            }
            Database.upsert (mapUniqueStringToOrgStr.values(),false);
            Database.insert (lstCsap,false);  
                                   
         Database.update (notificationToUpdate,false);   
                                       
    }
    /**
     * Method:- updateRecordsOnAccount.
     * Description:- if account exists update records and if doesn't than create new account based on PSUID.
     */
    public static Sobject updateRecordsCFO(NotificationModel notif,Sobject aobject,Map<String,CFO_Region__c> mapCfoToRegion){
         if(notif!=null){
            CFO_Region__c region; 
            //if(aobject.get('CFO_Code__c') == NULL || aobject.get('CFO_Code__c') == ''){
                if(!String.isEmpty(notif.CFO) && mapCfoToRegion.containsKey(notif.CFO)){
                    region = mapCfoToRegion.get(notif.CFO);
                    aobject.put('CFO_Code__c',notif.CFO);
                    aobject.put('Market_Region__c',region.Market_Region__c);
                    aobject.put('CFO_Name__c',region.APM_CFO__c);
                    aobject.put('Region__c',region.Region__c);
                    aobject.put('Territory__c',region.Territory__c);
                } 
            //} 
        }      
        return aobject;      
    }
    /**
     * Method:- updateRecordsOnAccount.
     * Description:- if account exists update records and if doesn't than create new account based on PSUID.
     */
    public static Account updateRecordsAccount(NotificationModel notif,Account aobject,Map<String,CFO_Region__c> mapCfoToRegion){
         if(notif!=null){
            CFO_Region__c region; 
             if(aobject.CFO_CD__c==NULL || aobject.CFO_CD__c==''){
                if(!String.isEmpty(notif.CFO) && mapCfoToRegion.containsKey(notif.CFO)){
                    region = mapCfoToRegion.get(notif.CFO);
                    aobject.CFO_CD__c = region.CFO__c;
                    aobject.Market_Region__c = region.Market_Region__c;
                    aobject.APM_CFO__c = region.APM_CFO__c;
                    aobject.Region__c = region.Region__c;
                    if(region.VPCM_Name__c!=null){
                        aobject.OwnerId = region.VPCM_Name__c;
                    }
                } 
                if(!String.isEmpty(notif.CFO)){
                  aobject.CFO_CD__c = notif.CFO;
                } 
                if(!String.isEmpty(notif.MarketSegment)){
                    aobject.Market_Segment__c = notif.MarketSegment;
                }
                if(!String.isEmpty(notif.SubSegment)){
                    aobject.Subsegment__c = notif.SubSegment;
                } 
            } //Richa commented on 24thJun 2015 for Req 5868, Ankur :modified to fix defect.
        }        
        return aobject;      
    }
    
    
    /**
     * Method:- appendLeadingZero.
     * Description:- it's an util method based on the certain condition we append zero.
     */
    public static string  appendLeadingZero(Integer maxlength,String value, String leadingChar){    //Richa modified the method to public to use the code in Req 5555 on 23rd feb 2015                                                      
        value = String.isEmpty(value) ? '' : value;  
        Integer currentLength = value.length();
        String prefix = '';
        for(Integer i = 0; i < maxlength - currentLength; i++){
            prefix += leadingChar;
        }
        value = prefix + value;
        return value;
    }
    
    /**
     * Method:- updatePCGrecord.
     * Description:- it's an util method to update PCG record.
     */
    public static void  updatePCGrecord(Partial_Control_Group__c pcg ,NotificationModel notification){
        pcg.CSAP_Control_ID__c = appendLeadingZero(7,String.valueof(notification.Control),'0');
        if(notification.erb == '1' || notification.erb == '01'){
            pcg.Rating_ERB__c = 'R';
        }else{
            pcg.Rating_ERB__c = 'NR';
        }
        pcg.Subsegment__c = notification.SubSegment;
        pcg.PSUID__c = notification.PSUID;
       
        pcg.CSAP_Plan_ID__c = notification.PlanSummary;
        pcg.Product_Indicator__c ='PPO'; 
        pcg.Control_Group_Effective_Date__c =notification.effectiveDate;
        
        if(String.isBlank(notification.Termdate) || notification.termDate > OPEN_TERM_DATE){
            pcg.Control_Group_Term_Date__c = date.valueOf(OPEN_TERM_DATE);
        }else{
            pcg.Control_Group_Term_Date__c = date.valueof(notification.Termdate);
        }
    }
    
     /**
     * Method:- updateFCGrecord.
     * Description:- it's an util method to update FCG record.
     */
    public static void  updateFCGrecord(Full_Control_Group__c fcg ,NotificationModel notification){ 
        if(notification.csap_AccountId!=null && notification.csap_AccountId!=''){
            fcg.CSAP_Account_ID__c = appendLeadingZero(4,String.valueof(notification.csap_AccountId),'0');
        }       
        if(notification.Control!=null&&notification.Control!=''){
            fcg.CSAP_Control_ID__c = appendLeadingZero(7,String.valueof(notification.Control),'0');
        }
        if(notification.suffix!=null&&notification.suffix!=''){
            fcg.CSAP_Suffix_ID__c =  appendLeadingZero(2,String.valueof(notification.suffix),'0');
        }
        
        fcg.CSAP_Plan_ID__c = notification.PlanSummary;
        fcg.Carrier_ID__c = notification.carrierid;
        fcg.Product_Indicator__c ='PPO';
        fcg.Subsegment__c = notification.SubSegment;
        fcg.Control_Group_Effective_Date__c = notification.effectivedate;
        
        if(String.isBlank(notification.Termdate) || notification.termDate > OPEN_TERM_DATE){
            fcg.Control_Group_Term_Date__c = date.valueOf(OPEN_TERM_DATE);
        }else{
            fcg.Control_Group_Term_Date__c = date.valueof(notification.Termdate);
        }
        if(notification.Control!=null && notification.PlanSummary!=null && notification.suffix!=null){
            fcg.CAG_Group_ID__c = appendLeadingZero(7,String.valueof(notification.Control),'0') 
                                + appendLeadingZero(2,String.valueof(notification.suffix),'0') 
                                + fcg.CSAP_Account_ID__c 
                                + appendLeadingZero(2,(notification.PlanSummary),'-');
        }
        fcg.PSUID__c = notification.PSUID;
        if(notification.fundingType == '01' || notification.fundingType == '1'){ 
            fcg.Group_Funding_Type_Code__c = 'FI';
        }
        else if(notification.fundingType == '3' || notification.fundingType == '03' || notification.fundingType == '5' || notification.fundingType == '05' || 
        notification.fundingType == '6' || notification.fundingType == '06' || notification.fundingType == '7' || notification.fundingType == '07'){ 
            fcg.Group_Funding_Type_Code__c = 'SI';
        }
        else if(notification.fundingType == '99'){ 
            fcg.Group_Funding_Type_Code__c = String.valueof('UNK');
        }
        else {
            fcg.Group_Funding_Type_Code__c = 'SF';
        }              
    }
    
    global class NotificationModel{
        public string erb{get;set;}
        public string Control{get;set;}
        public string PSUID{get;set;}
        public string SubSegment{get;set;}
        public string MarketSegment{get;set;}
        public string CFO{get;set;}
        public string PCGKey{get;set;}
        public date effectivedate{get;set;}
        public string FCGKey{get;set;}
        public string account{get;set;}
        public string suffix{get;set;}
        public string carrierid{get;set;}
        public string fundingType{get;set;}
        public string orgId{get;set;}
        public string orgType{get;set;}
        public string orgarrangementid{get;set;}
        public string NotificationType{get;set;}
        public string NotificationId{get;set;}
        public datetime NotificationDate{get;set;}
        public string Termdate{get;set;}
        public string PlanSummary{get;set;}
        public string Accountname{get;set;}
        public string orgkey{get;set;}
        public string csap_AccountId {get;set;}
        
        
        
        public NotificationModel(NotificationStandard__c temprec){
            
            PlanSummary = temprec.Plan__c;
            suffix = temprec.suffix__c;
            Accountname = temprec.AccountName__c;
            erb = temprec.erb__C;
            csap_AccountId = tempRec.Trad_AccountId__c;
            Control = String.isBlank(temprec.Control__c) ? '' : temprec.Control__c;           
            PSUID = temprec.PSUID__c;
            SubSegment = temprec.Subsegment__c;
            MarketSegment = temprec.MarketSegment__c;
            CFO = temprec.CFO__c;
            
            if(Control!=null && PlanSummary!=null){
                PCGKey = appendLeadingZero(7,String.valueof(Control), '0') + PlanSummary;                
            }
            effectivedate = temprec.effectiveDate__c;
           
            if(Control!=null && PlanSummary!=null && suffix!=null && csap_AccountId!=null){
                FCGKey = appendLeadingZero(7,String.valueof(Control), '0')  + appendLeadingZero(2,String.valueof(suffix), '0')+ appendLeadingZero(4,String.valueof(csap_AccountId), '0') +PlanSummary;
            }
            account = temprec.AccountName__c;           
            carrierid = temprec.CarrierId__c;
            fundingType = temprec.FundingType__c;
            orgId = temprec.OrgId__c;
            orgType = temprec.OrgType__c;
            orgarrangementid = temprec.OrgArrangementId__c;
            orgkey = orgId + orgarrangementid;// Corrected by Amit for ST# 797
            Termdate = temprec.TermDate__c;
            NotificationType = 'Success';
            NotificationId = temprec.id;
            NotificationDate = temprec.createddate;
            
        }
        
        public NotificationModel(notificationfallout__c temprec){
            csap_AccountId = tempRec.Trad_AccountId__c;
            PlanSummary = temprec.Plan_Summary__c;
            suffix = temprec.suffix__c;
            Accountname = temprec.AccountName__c;
            erb = temprec.erb__C;
            Control = String.isBlank(temprec.Control__c) ? '' : temprec.Control__c; 
            PSUID = temprec.PSUID__c;
            SubSegment = temprec.Subsegment__c;
            MarketSegment = temprec.MarketSegment__c;
            CFO = temprec.CFO__c;
            if(Control !=null && PlanSummary !=null){
                PCGKey = appendLeadingZero(7,String.valueof(Control), '0') + PlanSummary;
            }
            effectivedate = temprec.effectiveDate__c;
            account = temprec.AccountName__c;
            
            if(Control!=null && PlanSummary!=null && suffix!=null && Accountname!=null){
               FCGKey = appendLeadingZero(7,String.valueof(Control),'0') + appendLeadingZero(2,String.valueof(suffix),'0') + appendLeadingZero(4,String.valueof(csap_AccountId),'0') + PlanSummary;
            }
            
            carrierid = temprec.CarrierId__c;
            fundingType = temprec.FundingType__c;
            orgId = temprec.OrgId__c;
            orgType = temprec.OrgType__c;
            orgarrangementid = temprec.OrgArrangementId__c;
            orgkey = orgId + orgarrangementid;// Corrected by Amit for ST# 797
            Termdate = temprec.TermDate__c;
            NotificationType = 'fallout';
            NotificationId = temprec.id;
            NotificationDate = temprec.createddate;
            
        }
        
    }
}