/**************************************************************************************************
* Name               : Test_TRT_UpdateDocumentReviewStatus                                         *
* Description        : This class performs following functionality: It is the test class build to
                       test the functionality built by class 'TRT_UpdateDocumentReviewStatus'.    *
*                      
* Created Date       : 24/01/2017                                                                 *
* Created By         : Sushant Kumar Dhingra                                                      *
* Last Modified Date :                                                                  *
* Last Modified By   :                                                       *
* ----------------------------------------------------------------------------------------------- *
* VERSION         AUTHOR              DATE                                                        *
*   1.0 -  Sushant Kumar Dhingra   24/01/2017                                                     *
**************************************************************************************************/
@isTest

private class Test_TRT_UpdateDocumentReviewStatus{

static testMethod void Test_PlanDocument(){
    List<Transaction__c> transacList =new   List<Transaction__c>(); 
    List<TRT_IQR_Document_Type__c> csDataList =new   List<TRT_IQR_Document_Type__c>();
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User usr = new User(Alias = 'draf', Email='testdmin@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Draftest152', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,EmployeeNumber='E101',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testdraf152@testdraft.com');
          insert usr;
          
        TRT_IQR_Document_Type__c objCSData = New TRT_IQR_Document_Type__c();
        objCSData.Document_Type__c ='Booklet';
        objCSData.Name='CS1';
        
        TRT_IQR_Document_Type__c CSData1 = New TRT_IQR_Document_Type__c();
        CSData1.Document_Type__c ='Summary of Coverage';
        CSData1.Name='CS2';
       
       csDataList.add(objCSData);
       csDataList.add(CSData1);
       insert csDataList;
           
       test.startTest();       
       
      System.runAs (usr) {
      
        Document__c docrec = new Document__c();
            docrec.Document_Name__c='Test Doc';
            docrec.Document_Type__c='Booklet';
            insert docrec;
            
        Document__c docrec1 = new Document__c();
            docrec1.Document_Name__c='Test Doc';
            docrec1.Document_Type__c='Summary of Coverage';
            insert docrec1;
             
        Control__c cont= new Control__c();
          cont.Market_Segment__c= 'MM';
          cont.CFO_Number__c='123';
          cont.TRT_Control_Contract_State__c='MO';
          insert cont;  
            
        Product__c prod = new Product__c();  
          prod.Control_transaction_number__c=cont.id;   
          prod.Product_Category__c='Medical'; 
          prod.BIC_Abbreviation__c ='BASIC'; 
          prod.Product__c='Basic';
          prod.Funding__c ='Self Funded'; 
          prod.MLR_Contract_Situs_Code__c='MO';
          insert prod;
             
         

        Transaction__c transrec= new Transaction__c();
          transrec.Product_Number__c=prod.id;      
          transrec.Implementation_Consultant__c='Test Consultant';
          transrec.Transaction_Type__c='Preload';
          transrec.Effective_Date__c=system.today();
          transrec.OwnerId=usr.id;
          insert transrec;
       
       transacList.add(transrec);
        
        Plan_Document__c plandoc= new Plan_Document__c();
          plandoc.Transaction__c = transrec.id;
          plandoc.Document_Name__c= docrec.id;
          insert plandoc;
          
        Plan_Document__c plandoc1= new Plan_Document__c();
          plandoc1.Transaction__c = transrec.id;
          plandoc1.Document_Name__c= docrec1.id;
          insert plandoc1;
       
       TRT_UpdateDocumentReviewStatus objClass = new TRT_UpdateDocumentReviewStatus();
       TRT_UpdateDocumentReviewStatus.getDocumentList(transacList);
       
       TRT_IQR_Document_Type__c cs1 = [select Document_Type__c from TRT_IQR_Document_Type__c where Document_Type__c = :docrec1.Document_Type__c];
       Document__c doc1 = [select Document_Type__c from Document__c where Id = :docrec1.Id];
       
        system.assertequals(cs1.Document_Type__c, doc1.Document_Type__c);
       
      }
      test.stopTest();
    }
  
}