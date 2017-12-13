@isTest
    private class TEST_WaiverOfDeductibleTriggerHandler{
        static testMethod void TEST_WaiverOfDeductibleTriggerHandler() {
            CRD__c testCrd=new CRD__c();  
            testcrd.lastsent__c=system.now();      
            insert testCrd;
        
            Waiver_of_Deductible__c testwod = new Waiver_of_Deductible__c();
            testwod.crd_id__c = testCrd.id;
            testwod.drug_class__c = 'FOR PREEFRRED GENERIC FOR COSTCO';
            insert testwod;
            
            Drug_List__c dl = new Drug_List__c();         
            insert dl;
            
            testwod.drug_list__c = dl.id;
            testwod.delivery_system__c = 'both';
            testwod.drug_class__c = 'FOR FORMULARY GENERICS, TIER 1A';
            testwod.m__c = false;
            testwod.n__c = true;
            testwod.o__c = false;
            testwod.y__c = false;
            update testwod;
            
            delete testwod;
        }
    }