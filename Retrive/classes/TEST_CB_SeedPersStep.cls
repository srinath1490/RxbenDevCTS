@isTest
private class TEST_CB_SeedPersStep{ 
    Static testMethod void seedPersStepTest(){
        case c = new case(subject ='TestData');
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        testCrd.RxPlanID__c = '11111111';
        insert testCrd;
        
        crdbuildorder__c  obj = new crdbuildorder__c (); 
        obj.valid__c = True;
        obj.Build__c = True;
        obj.Complete__c = True;
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;      
        insert obj;
   
        Test.StartTest();
    		BAC_CB_SeedPersStep seedPersBatch = new BAC_CB_SeedPersStep();
    		ID batchprocessid = Database.executeBatch(seedPersBatch);
    	Test.StopTest();              
    }
    Static testMethod void seedPersStepTest1(){
        case c = new case(subject ='TestData');
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        testCrd.RxPlanID__c = '11111111';
        insert testCrd;
        
        crdbuildorder__c  obj = new crdbuildorder__c (); 
        obj.valid__c = True;
        obj.Build__c = True;
        obj.Complete__c = True;
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;      
        insert obj;
        
        List < CRDBuildOrder__c > cbon = new List < CRDBuildOrder__c>();
        cbon.add(obj);
        
        CB_SeedPersStep cbseed = new CB_SeedPersStep();
        cbseed.seedStep(cbon);
    }
}