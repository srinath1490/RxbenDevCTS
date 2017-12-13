/*Purpose: Trigger Handler class for PersFullReport
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      7/25/2014           To set PersTimeStamp at the time of new Pers Report
   2.0      Nitish          11/28/2014          Conversion into Batch
   3.0      Abhishek        09/28/2015           Populate carrier id through batch.
======================================================================== */

public with sharing class CB_PersFullReportTriggerHandler {
  public  static boolean CLONEMODE = False; 
  public  static boolean TRIGGER_CONTEXT = True; 
  private static final string Y13 = 'Y13'; //Added By Nitish for 7093
  private static final string DISCOUNTCARD = 'Discount Card';//Added By Nitish for 7093
    public static void onBeforeInsert(List<Pers_Full_Report__c> newList){
        //added by abhishek date on 8/3/2014 for added cpe list to matching CPE on Notification Fallout record.
        Map<String,List<Pers_Full_Report__c>> mapCpEPtoPersFullreports = new Map<String, List<Pers_Full_Report__c>>();
        DateTime effectDate;
        //Set PersTimeStamp and ControlPlanEffectiveDate
         for(Pers_Full_Report__c persRecord : newList){
            //Set PersTimestamp to starting of the day//Commented by JR as discussed with Saraag
           //persRecord.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
           //set Controlplaneffectivedate with Control + Plan + effective Date
           String effectiveDate = '';
           if(persRecord.WS_NEW_INFRC_EFF_DT__c != null){
            effectiveDate = DateTime.newInstance(persRecord.WS_NEW_INFRC_EFF_DT__c,Time.newInstance(0,0,0,0)).format('MM/dd/yyyy');
            system.debug('>>>>>>>'+effectiveDate);
           }
           persRecord.ControlPlanEffective__c = String.valueOf(integer.valueOf(persRecord.WS_CNTRL_NO__c)) + String.valueof(persRecord.WS_PLSM_CD__c) + effectiveDate;
            /* if(effectiveDate!=null && persRecord.WS_NEW_INFRC_EFF_DT__c != null && persRecord.WS_PLSM_CD__c != null && persRecord.WS_CNTRL_NO__c != null){
                //These set will be used for find carried id from notification fallout record
                 String notificationKey = (String.valueOf(integer.valueOf(persRecord.WS_CNTRL_NO__c)) 
                                            + appendLeadingZero(2,String.valueof(persRecord.WS_PLSM_CD__c),' ') 
                                            + DateTime.newInstance(persRecord.WS_NEW_INFRC_EFF_DT__c,Time.newInstance(0,0,0,0)).format('yyyy-MM-dd'));
                 setNotificationKeys.add(notificationKey);
                 system.debug('>>>>>>>setNotificationKeys'+setNotificationKeys);
                 if(mapNotifKeyPtoPersFullreports.containsKey(notificationKey)){
                    mapNotifKeyPtoPersFullreports.get(notificationKey).add(persRecord);
                 }else{
                    mapNotifKeyPtoPersFullreports.put(notificationKey , new List<Pers_Full_Report__c> {persRecord} );
                 }
                  
           }  */
           String crdBuilderKey = persRecord.ControlPlanEffective__c + '|' + persRecord.PERStimestamp__c.format();
           if(mapCpEPtoPersFullreports.containsKey(crdBuilderKey)){
                mapCpEPtoPersFullreports.get(crdBuilderKey).add(persRecord);
           }else{
                mapCpEPtoPersFullreports.put(crdBuilderKey, new List<Pers_Full_Report__c>{persRecord});
           }
        }
        
        //Populate CRD Builder Record into Pers Full Report based on CPE and PersTimeStamp if clone mode 
        if(CLONEMODE || (!TRIGGER_CONTEXT))  
            populateCrdBuilder(mapCpEPtoPersFullreports);
        
    } 
    
    public static void populateCarrierIDBatchHandler(List<Pers_Full_Report__c> newList){
        Set<string> setNotificationKeys = new Set<string>();
        Map<String,List<Pers_Full_Report__c>> mapNotifKeyPtoPersFullreports = new Map<String, List<Pers_Full_Report__c>>();
        for(Pers_Full_Report__c persRecord : newList){
           String effectiveDate = '';
           if(persRecord.WS_NEW_INFRC_EFF_DT__c != null){
            effectiveDate = DateTime.newInstance(persRecord.WS_NEW_INFRC_EFF_DT__c,Time.newInstance(0,0,0,0)).format('MM/dd/yyyy');
           }
           persRecord.ControlPlanEffective__c = String.valueOf(integer.valueOf(persRecord.WS_CNTRL_NO__c)) + String.valueof(persRecord.WS_PLSM_CD__c) + effectiveDate;
            if(effectiveDate!=null && persRecord.WS_NEW_INFRC_EFF_DT__c != null && persRecord.WS_PLSM_CD__c != null && persRecord.WS_CNTRL_NO__c != null){
                //These set will be used for find carried id from notification fallout record
                 String notificationKey = (String.valueOf(integer.valueOf(persRecord.WS_CNTRL_NO__c)) 
                                            + appendLeadingZero(2,String.valueof(persRecord.WS_PLSM_CD__c),' ') 
                                            + DateTime.newInstance(persRecord.WS_NEW_INFRC_EFF_DT__c,Time.newInstance(0,0,0,0)).format('yyyy-MM-dd'));
                 setNotificationKeys.add(notificationKey);
                 system.debug('>>>>>>>setNotificationKeys'+setNotificationKeys);
                 if(mapNotifKeyPtoPersFullreports.containsKey(notificationKey)){
                    mapNotifKeyPtoPersFullreports.get(notificationKey).add(persRecord);
                 }else{
                    mapNotifKeyPtoPersFullreports.put(notificationKey , new List<Pers_Full_Report__c> {persRecord} );
                 }
                  
            } 
        }
        populateCarrier(setNotificationKeys,mapNotifKeyPtoPersFullreports);
    }
     private static string  appendLeadingZero(Integer maxlength,String value, String leadingChar){                                                          
        value = String.isBlank(value) ? '' : value;  
        Integer currentLength = value.length();
        String prefix = '';
        for(Integer i = 0; i < maxlength - currentLength; i++){
            prefix += leadingChar;
        }
        value = prefix + value;
        return value;
    } 
    //Populate CarrierId from Notification Fallout or Standard Tables 
     Public static void populateCarrier(Set<String> setOfCPEs, Map<String,List<Pers_Full_Report__c>> mapNotifKeyPtoPersFullreports){
        boolean stopIfDiscountCard = false;
        Map<String,List<String>> mapCarrierToCPEs = new Map<String,List<String>>();
        Map<Id,Pers_Full_Report__c> lstperfullreportupdate = new Map<Id,Pers_Full_Report__c>();
        for(NotificationFallout__c fallout : [Select
                                                CarrierId__c,ControlPlanEffective__c,pricingSchedule__c
                                              From
                                                NotificationFallout__c
                                              Where 
                                                ControlPlanEffective__c in:setOfCPEs AND CarrierId__c <> null ORDER BY CreatedDate Desc]){
            setOfCPEs.remove(fallout.ControlPlanEffective__c);
            if(fallout.pricingSchedule__c == Y13){
                    for(Pers_Full_Report__c pers : mapNotifKeyPtoPersFullreports.get(fallout.ControlPlanEffective__c)){
                        pers.Carrier_Id__c = decimal.valueOf(fallout.CarrierId__c);
                        pers.What_is_the_carrier__c = DISCOUNTCARD;
                        lstperfullreportupdate.put(pers.id,pers);
                    }   
                    stopIfDiscountCard = True;
              }
              
            else if(!stopIfDiscountCard){ 
                system.debug('stopIfDiscountCard 22 ' + stopIfDiscountCard );   
                if(mapCarrierToCPEs.containsKey(fallout.CarrierId__c)){
                    mapCarrierToCPEs.get(fallout.CarrierId__c).add(fallout.ControlPlanEffective__c);
                }else{
                    mapCarrierToCPEs.put(fallout.CarrierId__c, new List<String>{fallout.ControlPlanEffective__c});
                }
                
                for(Pers_Full_Report__c pers : mapNotifKeyPtoPersFullreports.get(fallout.ControlPlanEffective__c)){
                        pers.Carrier_Id__c = decimal.valueOf(fallout.CarrierId__c);
                        lstperfullreportupdate.put(pers.id,pers);
                }    
            }            
        }
        
        /**Updated By Nitish for 7093
          * Added pricingSchedule__c in the query
          **/
        if(! setOfCPEs.isEmpty()){
            for(NotificationStandard__c std : [Select
                                                    CarrierId__c,ControlPlanEffective__c,pricingSchedule__c
                                                  From
                                                    NotificationStandard__c
                                                  Where 
                                                    ControlPlanEffective__c in:setOfCPEs AND CarrierId__c <> null ORDER BY CreatedDate Desc]){
                                                        
                if(std.pricingSchedule__c == Y13){
                    for(Pers_Full_Report__c pers : mapNotifKeyPtoPersFullreports.get(std.ControlPlanEffective__c)){
                        pers.Carrier_Id__c = decimal.valueOf(std.CarrierId__c);
                        pers.What_is_the_carrier__c = DISCOUNTCARD;
                        lstperfullreportupdate.put(pers.id,pers);
                    }
                    stopIfDiscountCard = True;
                    
                }
                else if(!stopIfDiscountCard){
                    if(mapCarrierToCPEs.containsKey(std.CarrierId__c)){
                        mapCarrierToCPEs.get(std.CarrierId__c).add(std.ControlPlanEffective__c);
                    }else{
                        mapCarrierToCPEs.put(std.CarrierId__c, new List<String>{std.ControlPlanEffective__c});
                    }
                    for(Pers_Full_Report__c pers : mapNotifKeyPtoPersFullreports.get(std.ControlPlanEffective__c)){
                        pers.Carrier_Id__c = decimal.valueOf(std.CarrierId__c);
                        lstperfullreportupdate.put(pers.id,pers);
                    }
                }
                
            }
        }
        if(! mapCarrierToCPEs.isEmpty()){
            
            for(Carrier_ID_Crosswalk__c crossWalk : [Select 
                                                        Carrier__c, What_is_the_Carrier__c
                                                    FROM 
                                                        Carrier_ID_Crosswalk__c
                                                    WHERE 
                                                        Carrier__c IN :mapCarrierToCPEs.keyset()]){
                for(String CPE : mapCarrierToCPEs.get(crossWalk.Carrier__c)){
                    for(Pers_Full_Report__c pers : mapNotifKeyPtoPersFullreports.get(CPE)){
                        pers.What_is_the_Carrier__c = crossWalk.What_is_the_Carrier__c;
                        lstperfullreportupdate.put(pers.id,pers);
                    }
                }
            }
        }
        update lstperfullreportupdate.values();
    }
    
    //Populate CRD Builder Record into Pers Full Report based on CPE and PersTimeStamp
    /**
     * Method :- populateCrdBuilder
     * Description :- This method check for CBON with Build = False and Pers Key with that of existing PFR. If Key Matches
                      PFR gets attached to that CBON. In case of mismatch of Key new CBON is created and PFR gets 
                      attached to that new CBON.
    **/
    public static void populateCrdBuilder(Map<String,List<Pers_Full_Report__c>> mapCpEPtoPersFullreports){
    Map<String,CRDBuildOrder__c> PersCBONMap = new Map<String,CRDBuildOrder__c>();
    for(CRDBuildOrder__c Cb : [select
                                                 id,PERS_timestamp__c,Control_Plan_Effective__c , Pers_Key__c
                                                ,Carrier_ID__c, What_is_the_carrier__c,Subsegment__c
                                                 
                                            from 
                                                CRDBuildOrder__c 
                                            where 
                                                Pers_Key__c in : mapCpEPtoPersFullreports.keyset() AND PERS_KEY__c <> null AND Build__c = False])
       {
         if(!PersCBONMap.containskey(Cb.Pers_Key__c))
           {
            PersCBONMap.put(Cb.PERS_KEY__c,Cb);
            }
        }
       for(String key : mapCpEPtoPersFullreports.keyset())
       {
             if(!PersCBONMap.containskey(key))
             {
                List<CRDBuildOrder__c>  CBuilder = new List<CRDBuildOrder__c>();  
                //Get any of the one record of pers report
                Pers_Full_Report__c PReport = mapCpEPtoPersFullreports.get(key)[0];
                CRDBuildOrder__c oBuilder = new CRDBuildOrder__c(
                                                Control_Plan_Effective__c = PReport.ControlPlanEffective__c
                                                , PERS_timestamp__c = PReport.PERStimestamp__c
                                                , Pers_Key__c = key
                                            );
                oBuilder.Control__c = PReport.WS_CNTRL_NO__c;
                oBuilder.Plan__c =  PReport.WS_PLSM_CD__c;
                oBuilder.Effective_date__c = PReport.WS_NEW_INFRC_EFF_DT__c;
                oBuilder.Carrier_ID__c =  PReport.Carrier_ID__c;
                oBuilder.What_is_the_carrier__c =  PReport.What_is_the_carrier__c;
                oBuilder.Subsegment__c =  PReport.WS_CUST_SUBSEG__c;                          
                CBuilder.add(oBuilder);         
                PersCBONMap.put(key,oBuilder);
            }
        }
        upsert PersCBONMap.values();
        //Populate CRD Builder Record into Pers Full Report based on CPE and PersTimeStamp
        list<Pers_Full_Report__c> lstperfullreportupdate = new list<Pers_Full_Report__c>();
        for (CRDBuildOrder__c objBuilder : [select
                                                 id,PERS_timestamp__c,Control_Plan_Effective__c , Pers_Key__c
                                            from 
                                                CRDBuildOrder__c 
                                            where 
                                                Pers_Key__c in : mapCpEPtoPersFullreports.keyset() AND PERS_KEY__c <> null  AND Build__c = False]){
            //Find PersFullReport maching with CrdbuilderKey and populate CRD Builder lookup field
            if(mapCpEPtoPersFullreports.containsKey(objBuilder.Pers_Key__c)){
                for(Pers_Full_Report__c persReport : mapCpEPtoPersFullreports.get(objBuilder.Pers_Key__c)){
                    persReport.CRD_Build_Order__c = objBuilder.id;
                }
                lstperfullreportupdate.addall(mapCpEPtoPersFullreports.get(objBuilder.Pers_Key__c));
                //mapCpEPtoPersFullreports.remove(objBuilder.Pers_Key__c);
            }
            
        }
        if(!TRIGGER_CONTEXT)
          update lstperfullreportupdate;
        /*
        
        //If map => mapCpEPtoPersFullreports still have record then created new CRDBuilder record and set it into PersFullReport
        if(! mapCpEPtoPersFullreports.isEmpty()){
           Map<String,CRDBuildOrder__c>  mapCPEPtoCRDBuild = new Map<String,CRDBuildOrder__c>();            
            for(String key : mapCpEPtoPersFullreports.keyset()){
                //Get any of the one record of pers report
                Pers_Full_Report__c persReport = mapCpEPtoPersFullreports.get(key)[0];
                CRDBuildOrder__c objBuilder = new CRDBuildOrder__c(
                                                Control_Plan_Effective__c = persReport.ControlPlanEffective__c
                                                , PERS_timestamp__c = persReport.PERStimestamp__c
                                                , Pers_Key__c = key
                                            );
                objBuilder.Control__c = persReport.WS_CNTRL_NO__c;
                objBuilder.Plan__c = persReport.WS_PLSM_CD__c;
                objBuilder.Effective_date__c = persReport.WS_NEW_INFRC_EFF_DT__c;
                                          
                mapCPEPtoCRDBuild.put(key, objBuilder);         
            }
            Database.upsert(mapCPEPtoCRDBuild.values(), CRDBuildOrder__c.fields.Pers_Key__c);
            
            for(String key : mapCPEPtoCRDBuild.keyset()){
                CRDBuildOrder__c objBuilder = mapCPEPtoCRDBuild.get(key);
                //Find PersFullReport maching with CrdbuilderKey and populate CRD Builder lookup field
                if(mapCpEPtoPersFullreports.containsKey(key)){
                    for(Pers_Full_Report__c persReport : mapCpEPtoPersFullreports.get(key)){
                        persReport.CRD_Build_Order__c = objBuilder.id;
                    }
                }   
            }
        }
        */
        
    }
}