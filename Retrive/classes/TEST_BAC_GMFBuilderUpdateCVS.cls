//This test class will cover below classes
//
@isTest
private class TEST_BAC_GMFBuilderUpdateCVS {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testMethod void TEST_BAC_GMFBuilderUpdateCVS(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        System.debug([Select Id,name From RecordType Where SobjectType = 'Case' and DeveloperName = 'Internal_GMF_Case' LIMIT 1].name);
        System.debug([Select Id,name,developername From RecordType Where SobjectType = 'case']);
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
        String strRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'Clinical_Program_Group__c' and DeveloperName = 'Prescription_Savings_Program'].Id;
        cpg.RecordTypeId = strRecordTypeId2;
        cpg.PDF__c= True;
        cpg.XML__c= True;
        cpg.CVS__c = False;
        cpg.Clinical_Program_Group_Description__c= 'Shubham';
        cpg.Clinical_Program_Group_Name__c = 'Test';
        cpg.Effective_Date__c= System.today();
        cpg.Termination_Date__c =  System.today()+30;
        insert cpg;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Clinical_Program__c cp= new Clinical_Program__c();
        String strRecordTypeId56 = [Select Id From RecordType Where SobjectType = 'Clinical_Program__c' and DeveloperName= 'Prescription_Savings_Program'].Id;
        cp.RecordTypeId = strRecordTypeId56;
        cp.PDF__c= True;
        cp.Account__c=acc.id;
        cp.Clinical_Programs_Name__c = 'Shubham';
        cp.Description__c = 'Shubham';
        insert cp;
        
        Drug_list__c dl = new Drug_list__c();
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Drug_list__c' and DeveloperName= 'Drug_List'].Id;
        dl.RecordTypeId = strRecordTypeId1;
        dl.Sent_To_CVS_Date__c  = System.today();
        dl.LastSent__c = System.today() + 10;
        insert dl;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Drug_List'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Drug_list__c = dl.id;
        GMF.Case__c = cs.id;
        GMF.ReadyToSendDate__c = System.today() + 5;
        insert GMF; 
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
        
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new BAC_GMFBuilderUpdateCVS());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        String jobId1 = System.schedule('ScheduleApexClassTest1', CRON_EXP, new BAC_GMFBuilder());
        CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
        
        String jobId2 = System.schedule('ScheduleApexClassTest2', CRON_EXP, new  BAC_GMFBuilderUpdateCase());
        CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId2];
        
    }    
    
    static testMethod void TEST_BAC_GMFBuilderUpdateCVS1(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
                
        Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
        String strRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'Clinical_Program_Group__c' and DeveloperName= 'Prescription_Savings_Program'].Id;
        cpg.RecordTypeId = strRecordTypeId2;
        cpg.Send_Error__c= 'Conga Failure';
        cpg.PDF__c= True;
        cpg.Clinical_Program_Group_Description__c= 'Shubham';
        cpg.Clinical_Program_Group_Name__c = 'Test';
        cpg.Effective_Date__c= System.today();
        cpg.LastSent__c = System.today();
        cpg.Termination_Date__c =  System.today()+30;
        cpg.Sent_To_CVS_Date__c = System.today();
        insert cpg;
        
        Drug_list__c dl = new Drug_list__c();
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Drug_list__c' and DeveloperName= 'Drug_List'].Id;
        dl.RecordTypeId = strRecordTypeId1;
        dl.Sent_To_CVS_Date__c  = System.today();
        dl.LastSent__c = System.today() + 10;
        dl.PDF__c = True;
        insert dl;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Clinical_Program_Group'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Clinical_Program_Group__c = cpg.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
    
    static testMethod void TEST_BAC_GMFBuilderUpdateCVS1a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
        String strRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'Clinical_Program_Group__c' and DeveloperName= 'Prescription_Savings_Program'].Id;
        cpg.RecordTypeId = strRecordTypeId2;
        cpg.Send_Error__c= 'Conga Failure';
        cpg.PDF__c= True;
        cpg.Clinical_Program_Group_Description__c= 'Shubham';
        cpg.Clinical_Program_Group_Name__c = 'Test';
        cpg.Effective_Date__c= System.today();
        cpg.LastSent__c = System.today() - 5 ;
        cpg.Termination_Date__c =  System.today()+30;
        cpg.Sent_To_CVS_Date__c = System.today();
        insert cpg;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Clinical_Program_Group'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Clinical_Program_Group__c = cpg.id;
        GMF.ReadyToSendDate__c = System.today();
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
       static testMethod void TEST_BAC_GMFBuilderUpdateCVS2(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Clinical_Program__c cp= new Clinical_Program__c();
        String strRecordTypeId56 = [Select Id From RecordType Where SobjectType = 'Clinical_Program__c' and DeveloperName= 'Prescription_Savings_Program'].Id;
        cp.RecordTypeId = strRecordTypeId56;
        cp.PDF__c= True;
        cp.Account__c=acc.id;
        cp.Clinical_Programs_Name__c = 'Shubham';
        cp.Description__c = 'Shubham';
        insert cp;
        
        Drug_list__c dl = new Drug_list__c();
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Drug_list__c' and DeveloperName= 'Drug_List'].Id;
        dl.RecordTypeId = strRecordTypeId1;
        dl.Sent_To_CVS_Date__c  = System.today();
        dl.LastSent__c = System.today() + 10;
        dl.PDF__c = True;
        insert dl;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Clinical_Programs'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Clinical_Program__c = cp.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS2a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Clinical_Program__c cp= new Clinical_Program__c();
        String strRecordTypeId56 = [Select Id From RecordType Where SobjectType = 'Clinical_Program__c' and DeveloperName= 'Prescription_Savings_Program'].Id;
        cp.RecordTypeId = strRecordTypeId56;
        cp.PDF__c= True;
        cp.Account__c=acc.id;
        cp.Clinical_Programs_Name__c = 'Shubham';
        cp.Description__c = 'Shubham';
        cp.LastSent__c = System.today();
        insert cp;
        
        Drug_list__c dl = new Drug_list__c();
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Drug_list__c' and DeveloperName= 'Drug_List'].Id;
        dl.RecordTypeId = strRecordTypeId1;
        dl.Sent_To_CVS_Date__c  = System.today();
        dl.LastSent__c = System.today() + 10;
        dl.PDF__c = True;
        insert dl;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Clinical_Programs'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Clinical_Program__c = cp.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS3(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Drug_Group__c testDG4 = new Drug_Group__c();        
        RecordType rtDG4 = [Select id, Name from RecordType where SobjectType = 'Drug_Group__c' LIMIT 1];                     
        testDG4.RecordTypeId = rtDG4.id;        
        testDG4.Effective_Date__c = date.newinstance(2015,1,6);             
        testDG4.Termination_Date__c = date.newinstance(2015,7,6);         
        testDG4.Drug_Group_Name__c = 'DG4';        
        testDG4.Description__c = 'testDesc4';
        insert testDG4;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Drug_Group'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Drug_Group__c = testDG4.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS3a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Drug_Group__c testDG4 = new Drug_Group__c();        
        RecordType rtDG4 = [Select id, Name from RecordType where SobjectType = 'Drug_Group__c' LIMIT 1];                     
        testDG4.RecordTypeId = rtDG4.id;        
        testDG4.Effective_Date__c = date.newinstance(2015,1,6);             
        testDG4.Termination_Date__c = date.newinstance(2015,7,6);         
        testDG4.Drug_Group_Name__c = 'DG4';        
        testDG4.Description__c = 'testDesc4';
        testDG4.LastSent__c = System.today();                
        insert testDG4;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Drug_Group'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Drug_Group__c = testDG4.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS3b(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Drug_Group__c testDG4 = new Drug_Group__c();        
        RecordType rtDG4 = [Select id, Name from RecordType where SobjectType = 'Drug_Group__c' LIMIT 1];                     
        testDG4.RecordTypeId = rtDG4.id;        
        testDG4.Effective_Date__c = date.newinstance(2015,1,6);             
        testDG4.Termination_Date__c = date.newinstance(2015,7,6);         
        testDG4.Drug_Group_Name__c = 'DG4';        
        testDG4.Description__c = 'testDesc4';
        testDG4.PDF__c = True;
        testDG4.LastSent__c = System.today();                
        insert testDG4;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Drug_Group'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Drug_Group__c = testDG4.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS4(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary__c testForm = new Formulary__c();        
        testForm.Effective_Date__c = date.newinstance(2015,1,6);         
        testForm.Termination_Date__c = date.newinstance(2015,7,6);              
        testForm.Formulary_Name__c = 'Form1';        
        testForm.Formulary_Description__c = 'FormDesc';        
        insert testForm;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary__c= testForm.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS4a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary__c testForm = new Formulary__c();        
        testForm.Effective_Date__c = date.newinstance(2015,1,6);         
        testForm.Termination_Date__c = date.newinstance(2015,7,6); 
        testForm.LastSent__c = System.today();             
        testForm.Formulary_Name__c = 'Form1';        
        testForm.Formulary_Description__c = 'FormDesc'; 
        insert testForm;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary__c= testForm.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS4b(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary__c testForm = new Formulary__c();        
        testForm.Effective_Date__c = date.newinstance(2015,1,6);         
        testForm.Termination_Date__c = date.newinstance(2015,7,6); 
        testForm.LastSent__c = System.today();             
        testForm.Formulary_Name__c = 'Form1';        
        testForm.Formulary_Description__c = 'FormDesc'; 
        testForm.PDF__c = True;       
        insert testForm;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary__c= testForm.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS5(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary_List__c testFL = new Formulary_List__c();        
        testFL.Effective_Date__c = date.newinstance(2015,1,6);         
        testFL.Termination_Date__c = date.newinstance(2015,7,6);              
        testFL.Formulary_List_Name__c = 'FL';         
        testFL.Formulary_List_Description__c = 'FLDesc';         
        insert testFL;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary_List'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary_List__c= testFL.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS5a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'Low';
        cs.Annual_Changes__c = 'Mid-Year';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary_List__c testFL = new Formulary_List__c();        
        testFL.Effective_Date__c = date.newinstance(2015,1,6);         
        testFL.Termination_Date__c = date.newinstance(2015,7,6);              
        testFL.Formulary_List_Name__c = 'FL';         
        testFL.Formulary_List_Description__c = 'FLDesc';         
        testFL.LastSent__c = System.today(); 
        insert testFL;            
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary_List'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary_List__c = testFL.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS5b(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Formulary_List__c testFL = new Formulary_List__c();        
        testFL.Effective_Date__c = date.newinstance(2015,1,6);         
        testFL.Termination_Date__c = date.newinstance(2015,7,6);              
        testFL.Formulary_List_Name__c = 'FL';         
        testFL.Formulary_List_Description__c = 'FLDesc';         
        testFL.LastSent__c = System.today(); 
        testFL.PDF__c = True;
        insert testFL;            
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Formulary_List'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Formulary_List__c = testFL.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS6(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Generic_Code_Conversion__c testGCC1 = new Generic_Code_Conversion__c();        
        RecordType rtGCC1 = [Select id, Name from RecordType where SobjectType = 'Generic_Code_Conversion__c' LIMIT 1];                     
        testGCC1.RecordTypeId = rtGCC1.id;        
        testGCC1.Effective_Date__c = date.newinstance(2015,1,6);             
        testGCC1.Termination_Date__c = date.newinstance(2015,7,6);         
        testGCC1.Generic_Code_Conversion_Name__c = 'GCC1';        
        testGCC1.Generic_Code_Conversion_Description__c = 'GCC1Desc';              
        insert testGCC1;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Generic_Code_Conversion'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Generic_Code_Conversion__c = testGCC1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS6a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'Mid-Year';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Generic_Code_Conversion__c testGCC1 = new Generic_Code_Conversion__c();        
        RecordType rtGCC1 = [Select id, Name from RecordType where SobjectType = 'Generic_Code_Conversion__c' LIMIT 1];                     
        testGCC1.RecordTypeId = rtGCC1.id;        
        testGCC1.Effective_Date__c = date.newinstance(2015,1,6);             
        testGCC1.Termination_Date__c = date.newinstance(2015,7,6);         
        testGCC1.Generic_Code_Conversion_Name__c = 'GCC1';        
        testGCC1.Generic_Code_Conversion_Description__c = 'GCC1Desc';  
        testGCC1.LastSent__c = System.today();             
        insert testGCC1;         
                    
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Generic_Code_Conversion'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Generic_Code_Conversion__c = testGCC1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS6b(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'Mid-Year';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Generic_Code_Conversion__c testGCC1 = new Generic_Code_Conversion__c();        
        RecordType rtGCC1 = [Select id, Name from RecordType where SobjectType = 'Generic_Code_Conversion__c' LIMIT 1];                     
        testGCC1.RecordTypeId = rtGCC1.id;        
        testGCC1.Effective_Date__c = date.newinstance(2015,1,6);             
        testGCC1.Termination_Date__c = date.newinstance(2015,7,6);         
        testGCC1.Generic_Code_Conversion_Name__c = 'GCC1';        
        testGCC1.Generic_Code_Conversion_Description__c = 'GCC1Desc';  
        testGCC1.LastSent__c = System.today();
        testGCC1.PDF__c = True;             
        insert testGCC1;         
                    
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Generic_Code_Conversion'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Generic_Code_Conversion__c = testGCC1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS7(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'Medium';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Object_List__c testOL1 = new Object_List__c();        
        RecordType rtOL1 = [Select id, Name from RecordType where SobjectType = 'Object_List__c' LIMIT 1];                     
        testOL1.RecordTypeId = rtOL1.id;        
        testOL1.Effective_Date__c = date.newinstance(2015,1,6);             
        testOL1.Termination_Date__c = date.newinstance(2015,7,6);         
        testOL1.Object_List_Name__c = 'OL1';         
        testOL1.Object_List_Description__c = 'OL1Desc';        
        insert testOL1;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Object_Lists'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Object_List__c = testOL1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS7a(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'Low';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Object_List__c testOL1 = new Object_List__c();        
        RecordType rtOL1 = [Select id, Name from RecordType where SobjectType = 'Object_List__c' LIMIT 1];                     
        testOL1.RecordTypeId = rtOL1.id;        
        testOL1.Effective_Date__c = date.newinstance(2015,1,6);             
        testOL1.Termination_Date__c = date.newinstance(2015,7,6);         
        testOL1.Object_List_Name__c = 'OL1';         
        testOL1.Object_List_Description__c = 'OL1Desc'; 
        testOL1.LastSent__c = System.today();        
        insert testOL1;         
                   
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Object_Lists'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Object_List__c = testOL1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS7b(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        cs.Priority = 'High';
        cs.Annual_Changes__c = 'ANOC';
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Object_List__c testOL1 = new Object_List__c();        
        RecordType rtOL1 = [Select id, Name from RecordType where SobjectType = 'Object_List__c' LIMIT 1];                     
        testOL1.RecordTypeId = rtOL1.id;        
        testOL1.Effective_Date__c = date.newinstance(2015,1,6);             
        testOL1.Termination_Date__c = date.newinstance(2015,7,6);         
        testOL1.Object_List_Name__c = 'OL1';         
        testOL1.Object_List_Description__c = 'OL1Desc'; 
        testOL1.LastSent__c = System.today(); 
        testOL1.PDF__c = True;       
        insert testOL1;         
                   
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Object_Lists'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Object_List__c = testOL1.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
      
      static testMethod void TEST_BAC_GMFBuilderUpdateCVS8(){
        Case cs = new Case();
        cs.status = 'Ready to Send';
        cs.SentGMFCR__c = 123;
        String strRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and DeveloperName= 'Internal_GMF_Case'].Id;
        cs.RecordTypeId = strRecordTypeId3;
        insert cs;
        
        Account acc = new account();
        acc.name = 'Shubham birthday bash';
        insert acc;
        
        Option_Code__c testOC = new Option_Code__c();  
        testOC.Effective_Date__c = date.newinstance(2015,1,6);         
        testOC.Termination_Date__c = date.newinstance(2015,7,6);              
        testOC.Option_Code_Name__c = 'OC';         
        testOC.Option_Code_Description__c = 'OCDesc';        
        insert testOC;
        
        GMF_Change_Request__c GMF = new GMF_Change_Request__c();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'GMF_Change_Request__c' and DeveloperName= 'Option_Codes'].Id;
        GMF.RecordTypeId = strRecordTypeId;
        GMF.Case__c = cs.id;
        GMF.Option_Code__c = testOC.id;
        GMF.ReadyToSendDate__c = System.today() - 5;
        insert GMF;
        
        BAC_GMFBuilderUpdateCVS bac = new BAC_GMFBuilderUpdateCVS();
        Database.executeBatch(bac);
        
        BAC_GMFBuilder bac1 = new BAC_GMFBuilder();
        Database.executeBatch(bac1);
      }
}