@isTest
private class TEST_CB_PersFullReportTriggerHandler{   
    
    Static testMethod void persTest(){
        Pers_Full_Report__c obj = new Pers_Full_Report__c();
        
        obj.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        obj.WS_CNTRL_NO__c = 77;
        obj.WS_PLSM_CD__c = 'JR';
        obj.WS_NEW_INFRC_EFF_DT__c =System.today();
        obj.WS_PROV_NUM__c = 90;
        obj.WS_LV_NO__c = 81;
        
        insert obj;
        
        List<Pers_Full_Report__c>lstPersFullReport = new List<Pers_Full_Report__c>();
        set<string>setCPEs = new set<string>();
        setCPEs.add('308701AI1/1/2010');
        lstPersFullReport.add(obj); 
        Map<String,List<Pers_Full_Report__c>> mapNotifPersFull = new Map<String,List<Pers_Full_Report__c>>();
        mapNotifPersFull.put('308701AI1/1/2010',lstPersFullReport);
        
        NotificationFallout__c objFall = new NotificationFallout__c(CarrierId__c='7700',ControlPlanEffective__c='308701AI1/1/2010');
        insert objFall;
        NotificationStandard__c objStd = new NotificationStandard__c(CarrierId__c='7705',ControlPlanEffective__c='308701AI1/1/2010');
        insert objStd;
        
        //CB_PersFullReportTriggerHandler.populateCarrier(setCPEs,mapNotifPersFull);
        
    }                                                        
}