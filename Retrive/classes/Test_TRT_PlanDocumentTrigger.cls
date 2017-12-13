/*
Test class for 'TRT_Documenthandler' Apex class 
------------------------------------------------------------------------------------------------*/

@isTest

private class Test_TRT_PlanDocumentTrigger{

static testMethod void Test_PlanDocument(){
        
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User usr = new User(Alias = 'draf', Email='testdmin@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Draftest152', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,EmployeeNumber='E101',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testdraf152@testdraft.com');
          insert usr;
           
       test.startTest();
       
      System.runAs (usr) {
      
        Document__c docrec = new Document__c();
            docrec.Document_Name__c='Test Doc';
            insert docrec;
             
        Control__c cont= new Control__c();
          cont.Market_Segment__c= 'MM';
          cont.CFO_Number__c='123';
         // cont.OwnerId=usr.id;
          insert cont;  
            
        Product__c prod = new Product__c();  
          prod.Control_transaction_number__c=cont.id;   
          prod.Product_Category__c='Medical'; 
          prod.BIC_Abbreviation__c ='BASIC'; 
          prod.Product__c='Basic';
          prod.Funding__c ='Self Funded'; 
         // prod.OwnerId=usr.id;
          insert prod;
             
         

        Transaction__c transrec= new Transaction__c();
          transrec.Product_Number__c=prod.id;      
          transrec.Implementation_Consultant__c='Test Consultant';
          transrec.Transaction_Type__c='Preload';
          transrec.Effective_Date__c=system.today();
          transrec.OwnerId=usr.id;
          insert transrec;
       
        
        Plan_Document__c plandoc= new Plan_Document__c();
          plandoc.Transaction__c = transrec.id;
          plandoc.Document_Name__c= docrec.id;
          insert plandoc;
       

        Transaction__c ts1 = [select Document_Names__c from Transaction__c where Id = :transrec.Id];
        Plan_Document__c pd1 = [select TRT_Document_Name__c from Plan_Document__c where Id = :plandoc.Id];
       
        system.assertequals(ts1.Document_Names__c, pd1.TRT_Document_Name__c+';');
       
        Document__c docrec2 = new Document__c();
          docrec2.Document_Name__c='Test2 Doc';
          insert docrec2;
         
        Plan_Document__c plandoc2= new Plan_Document__c();
          plandoc2.Transaction__c = transrec.id;
          plandoc2.Document_Name__c= docrec.id;
          insert plandoc2;
     
        Transaction__c ts2 = [select Document_Names__c from Transaction__c where Id = :transrec.Id];
        Plan_Document__c pd2 = [select TRT_Document_Name__c from Plan_Document__c where Id = :plandoc.Id];
        Plan_Document__c pd3 = [select TRT_Document_Name__c from Plan_Document__c where Id = :plandoc2.Id];
        
        system.AssertEquals(ts2.Document_Names__c, pd2.TRT_Document_Name__c+ '; ' +pd3.TRT_Document_Name__c+';');
      
      delete plandoc2;
      }
      test.stopTest();
    }
  
}