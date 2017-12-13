/*Purpose: Apex Test Class to test PcgFcgAutomationHandler
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            8 Oct 2014       Apex Test class to test PcgFcgAutomationHandler
======================================================================== */
@isTest
private class TEST_PcgFcgAutomationHandler {
    static testMethod void TEST_PcgFcgAutomationHandler(){
        
        Test.StartTest();
        List <sObject> sObj = new list<sObject>();
        
        Account testAcc = new Account();
        testAcc.Name = 'testAccount';
        testAcc.APM_PSUID__c = '12332112';
        testAcc.CFO_CD__c = 'ABC';
        insert testAcc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '123123';
        pcg.CSAP_Plan_ID__c ='AB';
        //pcg.Last_Synced_Date__c = system.today()-2;
        insert pcg;
        
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.Account_Name__c = testAcc.id;
        fcg.CSAP_Control_ID__c = '123123';
        fcg.CSAP_Plan_ID__c ='AB';
        //fcg.Last_Synced_Date__c = system.today()-2;
        insert fcg;
        
        NotificationFallout__c notfFallout = new NotificationFallout__c();
        notfFallout.PSUID__c = '12332112';
        notfFallout.Control__c = '123123';
        notfFallout.Plan_Summary__c ='AB';
        notfFallout.suffix__c='AB';
        notfFallout.Trad_AccountId__c ='1233';
        notfFallout.AccountName__c = 'testAccount';
        notfFallout.Account_CAG_Processed__c = false;
        notfFallout.CFO__c = 'ABC';
        insert notfFallout;
        sObj.add(notfFallout);
        System.assertEquals(notfFallout.Id,[Select Id from NotificationFallout__C where Id =:notfFallout.Id and Account_CAG_Processed__c=false AND PSUID__c <> null
                                                        AND Control__c <> null 
                                                        AND Plan_Summary__c <> null AND suffix__c<> null AND Trad_AccountId__c <>null].Id);
        
        
        NotificationStandard__c notfStandard = new NotificationStandard__c();
        notfStandard.PSUID__c = '12332112';
        notfStandard.Control__c = '123123';
        notfStandard.Plan__c = 'AB';
        notfStandard.suffix__c='AB';
        notfStandard.Trad_AccountId__c ='1233';
        notfStandard.AccountName__c = 'testAccount';
        notfStandard.Account_CAG_Processed__c = false;
        notfStandard.CFO__c = 'ABC';
        insert notfStandard;
        sObj.add(notfStandard);

        
        CFO_Region__c cfoRegion = new CFO_Region__c();
        cfoRegion.CFO__c = 'ABC';
        cfoRegion.Market_Region__c = 'MarketRegion';
        cfoRegion.Region__c = 'Region';
        cfoRegion.APM_CFO__c = 'APMCFO';
        insert cfoRegion;
        
        OrgandArrangement__c org = new OrgandArrangement__c();
        org.OrgId__c = '123';
        org.OrgName__c = 'OrgName';
        org.OrgType__c = 'OrgType';
        org.JoinKey__c = '123';
        org.ArrangmentId__c = '123';
        insert org;
        
        OrgStructure__c orgStr = new OrgStructure__c();
        orgStr.FullControlGroup__c = fcg.id;
        orgStr.OrgandArrangement__c = org.id;
        orgStr.JoinKey__c = '123';
        orgStr.OrgArrangmentId__c = '123';
        orgStr.OrgId__c = '123';
        orgStr.OrgType__c = 'OrgType';
        insert orgStr;
        
               
        CB_PcgFcgAutomationUtil.NotificationModel wrp1 = new CB_PcgFcgAutomationUtil.NotificationModel(notfStandard);
        CB_PcgFcgAutomationUtil.NotificationModel wrp2 = new CB_PcgFcgAutomationUtil.NotificationModel(notfFallout);
        
        CB_PcgFcgAutomationUtil utilInst = new CB_PcgFcgAutomationUtil();
        utilInst.executeAutomation(sObj);

        CB_PcgFcgAutomationUtil.updateFCGrecord(fcg,wrp1);
        CB_PcgFcgAutomationUtil.updatePCGrecord(pcg,wrp2);

                       
        BAC_PcgFcgAutomationHandler handlerInstance = new BAC_PcgFcgAutomationHandler();
        handlerInstance.executeAutomation(new List<String> { testAcc.APM_PSUID__c});
 
        Test.StopTest();
    }
    
    
    static testMethod void TEST_BAC_PcgFcgAutomationHandler(){
        
        Test.StartTest();
        List <sObject> sObj = new list<sObject>();
        
        Account testAcc = new Account();
        testAcc.Name = 'testAccount';
        testAcc.APM_PSUID__c = '12332112';
        testAcc.CFO_CD__c = 'ABC';
        insert testAcc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '123123';
        pcg.CSAP_Plan_ID__c ='AB';
        //pcg.Last_Synced_Date__c = system.today()-2;
        insert pcg;
        
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.Account_Name__c = testAcc.id;
        fcg.CSAP_Control_ID__c = '123123';
        fcg.CSAP_Plan_ID__c ='AB';
        //fcg.Last_Synced_Date__c = system.today()-2;
        insert fcg;
        
        NotificationFallout__c notfFallout = new NotificationFallout__c();
        notfFallout.PSUID__c = '12332112';
        notfFallout.Control__c = '123123';
        notfFallout.Plan_Summary__c ='AB';
        notfFallout.suffix__c='AB';
        notfFallout.Trad_AccountId__c ='1233';
        notfFallout.AccountName__c = 'testAccount';
        notfFallout.Account_CAG_Processed__c = false;
        notfFallout.CFO__c = 'ABC';
        insert notfFallout;
        sObj.add(notfFallout);
        System.assertEquals(notfFallout.Id,[Select Id from NotificationFallout__C where Id =:notfFallout.Id and Account_CAG_Processed__c=false AND PSUID__c <> null
                                                        AND Control__c <> null 
                                                        AND Plan_Summary__c <> null AND suffix__c<> null AND Trad_AccountId__c <>null].Id);
        
        
        NotificationStandard__c notfStandard = new NotificationStandard__c();
        notfStandard.PSUID__c = '12332112';
        notfStandard.Control__c = '123123';
        notfStandard.Plan__c = 'AB';
        notfStandard.suffix__c='AB';
        notfStandard.Trad_AccountId__c ='1233';
        notfStandard.AccountName__c = 'testAccount';
        notfStandard.Account_CAG_Processed__c = false;
        notfStandard.CFO__c = 'ABC';
        insert notfStandard;
        sObj.add(notfStandard);

        
        CFO_Region__c cfoRegion = new CFO_Region__c();
        cfoRegion.CFO__c = 'ABC';
        cfoRegion.Market_Region__c = 'MarketRegion';
        cfoRegion.Region__c = 'Region';
        cfoRegion.APM_CFO__c = 'APMCFO';
        insert cfoRegion;
        
        OrgandArrangement__c org = new OrgandArrangement__c();
        org.OrgId__c = '123';
        org.OrgName__c = 'OrgName';
        org.OrgType__c = 'OrgType';
        org.JoinKey__c = '123';
        org.ArrangmentId__c = '123';
        insert org;
        
        OrgStructure__c orgStr = new OrgStructure__c();
        orgStr.FullControlGroup__c = fcg.id;
        orgStr.OrgandArrangement__c = org.id;
        orgStr.JoinKey__c = '123';
        orgStr.OrgArrangmentId__c = '123';
        orgStr.OrgId__c = '123';
        orgStr.OrgType__c = 'OrgType';
        insert orgStr;
        

        
       BAC_PcgFcgAutomationHandler handlerInstance = new BAC_PcgFcgAutomationHandler();
        handlerInstance.executeAutomation(new List<String> { testAcc.APM_PSUID__c});
 
        //utilInst.execute(20,sObj);
        //CB_PcgFcgAutomationUtil.updateRecordsAccount
        
        
            BAC_PcgFcgAutomationHandler pcgBatch = new BAC_PcgFcgAutomationHandler();
            ID batchprocessid = Database.executeBatch(pcgBatch);
        Test.StopTest();
    }

}