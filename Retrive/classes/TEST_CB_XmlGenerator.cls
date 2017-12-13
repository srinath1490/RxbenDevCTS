@isTest
private class TEST_CB_XmlGenerator{ 
    Static testMethod void xmlTest(){
        case fallcase = new case(subject ='TestData');
        insert fallcase;
        case exCase = new case(subject ='ExternalCase');
        insert exCase;
        case successCase = new case(subject ='SuccessCase');
        insert successCase;
            
        CRD__c testCrd=new CRD__c();
        testCrd.RxPlanID__c = '11111111';
        testCrd.Status__c ='XML & Case Generated. CRD Complete.';
        testCrd.LastSent__c =system.Now();
        testCrd.XMLDate_Time_Stamp__c =system.Now();
        insert testCrd;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(new crd__c(id=testCrd.id));       
        GMF_XML_CRD_Controller gmf = new GMF_XML_CRD_Controller(sc); 
        string CaseID = gmf.generateCaseAndXML();
        
        crdbuildorder__c  obj = new crdbuildorder__c (); 
        obj.valid__c = True;
        obj.Build__c = True;
        obj.Complete__c = True;
        obj.PERS__c = True;
        obj.CAG__c = True;        
        obj.Case__c = CaseID;
        obj.crd__c = testCrd.id;
        obj.Case__c = exCase.id;
        obj.Success_Case__c = successCase.id;
        insert obj;
        
        Test.StartTest();
            BAC_CB_CRDXMLStep xmlBatch = new BAC_CB_CRDXMLStep();
            ID batchprocessid = Database.executeBatch(xmlBatch);
        Test.StopTest();
              
    }
}