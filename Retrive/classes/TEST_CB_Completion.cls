@isTest
private class TEST_CB_Completion{ 
    Static testMethod void completionTest(){
        case c = new case(subject ='TestData');
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.XML__c  = true;
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;      
        insert obj;
        lstCBO.add(obj);
        
        Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
        mapCrdIdsToBuilder.put(obj.CRD__c,obj);
        
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.Processed__c = false;
        insert objPers;
        
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
        newCrdBuilder.valid__c = True;
 		newCrdBuilder.Build__c = true;
     	newCrdBuilder.CRD__c = testCrd.id;
 		insert newCrdBuilder;
        
        Test.StartTest();
            BAC_CB_Completion completionBatch = new BAC_CB_Completion();
            ID batchprocessid = Database.executeBatch(completionBatch);
    	Test.StopTest();
        
        CB_Completion objClass = new CB_Completion ();
        objClass.execute(lstCBO);
              
    }
    Static testMethod void completionTest1(){
        case c = new case(subject ='TestData');
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.XML__c  = true;
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;      
        insert obj;
        lstCBO.add(obj);
        
        Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
        mapCrdIdsToBuilder.put(obj.CRD__c,obj);
        
        CB_Completion objClass = new CB_Completion ();
        objClass.execute(lstCBO);
    }
}