@isTest (seealldata = false)
private class TEST_CBAuditUIExtension{ 
    Static testMethod void auditUiTest(){
        test.StartTest();
        case c = new case(subject ='TestData');
         RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        boolean hideButton = true;
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.Build__c   = true;        
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        insert obj;
        lstCBO.add(obj);
        System.assertEquals( hideButton, obj.Build__c);

        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        lstBF.Type__c = 'conflicts';
        insert lstBF;
       // Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
     //   mapCrdIdsToBuilder.put(obj.CRD__c,obj);
        
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.CRD_Build_Order__c =obj.id;
        objPers.Processed__c = false;
        insert objPers;
        
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
        newCrdBuilder.valid__c = True;
        newCrdBuilder.Build__c = true;
        
        insert newCrdBuilder;
        Mapping__c mc = new Mapping__c(Field_Type__c = 'String', Create__c = true, Object__c = 'CRD__c');
        insert mc;
        mapping_values__c mv = new mapping_values__c(MappingColumnId__c = mc.Id);    
        insert mv;
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);           
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);       
        
        objClass.lineNumber = '1';
        objClass.provNumber = '127';
        string Test2='Test';
        objClass.setSortDirection(Test2);
        objClass.getSortDirection();
        
        Provision__c objPro = new Provision__c();
        objPro.ProvisionNumber__c =127;
        objPro.name='Provision 127';
        objPro.Provision_Text__c='Prescribing Cascade Program';
        objPro.Active__c =true;
        insert objPro;
        
        LineValue__c objLV = new LineValue__c();
        objLV.Line_value__c = 1;
        objLV.Provision_ID__c= objPro.id;
      
        
        objClass.loadMappingFiles();
      //  objClass.setBuilderCases();
        objClass.redirectToLV();
        objClass.AssignToIT();

        objClass.hideButton();
        //objClass.continueAutomation();
        //objClass.setBuilderCases();
        test.StopTest();
              
    }
    Static testMethod void auditUiTest1(){
        test.StartTest();
        case c = new case();
        c.subject ='TestData';
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        insert lstBF;
        
        List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.valid__c  = true;        
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        insert obj;
        lstCBO.add(obj);
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.CRD_Build_Order__c =obj.id;
        objPers.Processed__c = true;
        insert objPers;
        
        Id machingPers = objPers.Id;
        Boolean hasSimiliarRecords  = true;
        Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
        mapCrdIdsToBuilder.put(obj.CRD__c,obj);
        Mapping__c mc = new Mapping__c(Field_Type__c = 'String', Create__c = true, Object__c = 'CRD__c');
        insert mc;
        mapping_values__c mv = new mapping_values__c(MappingColumnId__c = mc.Id);    
        insert mv;
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);           
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);
       // objClass.loadMappingFiles();
        //objClass.redirectToLV();
        //objClass.AssignToIT();
        //objClass.hideButton();
        objClass.continueAutomation();
      //  objClass.setBuilderCases();
        CRD__c testCrd1=new CRD__c();
        testCrd1.RxPlanID__c = '111111';
        insert testCrd1;
        objClass.checkRxPlanId();
        test.StopTest();
    }
     Static testMethod void auditUiTest2(){
        test.StartTest();
        case c = new case(subject ='TestData');
         RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        testCrd.RxPlanID__c = '1111111';
        insert testCrd;
        
        List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
        
        for(Integer i=0;i<7; i++){
                crdbuildorder__c  obj = new crdbuildorder__c ();   
                if(i==0)                     
                obj.XML__c  = true;
                else if(i==1)
                obj.CAG__c = true;
                else if(i==2)
                obj.PDF__c = true;
                else if(i==3)
                obj.CVS__c = true;
                else if(i==4)
                obj.PERS__c = true;
                else if(i==5)
                obj.Aicallout__c = true;
                else if(i==6)
                obj.complete__c = true;
                obj.CRD__c = testCrd.id; 
                obj.Case__c = c.id;  
                obj.FalloutCase__c = c.id;    
                lstCBO.add(obj);
        }
        if(lstCBO.size()>0){
            insert lstCBO;
        }
        
        
     
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
        newCrdBuilder.valid__c = True;
        newCrdBuilder.Build__c = true;
        insert newCrdBuilder;
       
        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        lstBF.Type__c = 'conflicts';
        insert lstBF;
        Mapping__c mc = new Mapping__c(Field_Type__c = 'String', Create__c = true, Object__c = 'CRD__c');
        insert mc;
        mapping_values__c mv = new mapping_values__c(MappingColumnId__c = mc.Id);    
        insert mv;
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);           
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);       
        
        objClass.lineNumber = '1';
        objClass.provNumber = '127';
        
        Provision__c objPro = new Provision__c();
        objPro.ProvisionNumber__c =127;
        objPro.name='Provision 127';
        objPro.Provision_Text__c='Prescribing Cascade Program';
        objPro.Active__c =true;
        insert objPro;
            LineValue__c objLV = new LineValue__c();
            objLV.Line_value__c = 1;
            objLV.Provision_ID__c= objPro.id;
        test.StopTest();
              
    }
    
         /*Static testMethod void auditUiTest3(){
        
        case c = new case();
        c.subject ='TestData';
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<CRD_BuilderFallout__c> lstCF = new List<CRD_BuilderFallout__c>();
        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        insert lstBF;
        lstCF.add(lstBF);
        
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.valid__c  = true;        
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        insert obj;
        
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.CRD_Build_Order__c =obj.id;
        objPers.Processed__c = true;
        insert objPers;
        
        ContinueAutomationLog__c caLog = new ContinueAutomationLog__c();
        insert caLog;

        CRD_BF_CALog_Junc__c objCaLog = new CRD_BF_CALog_Junc__c();
        objCaLog.CRD_BID__c = lstBF.Id;
        objCaLog.Type__c = 'Triggered';
        objCaLog.CA_LogID__c = caLog.Id;
        insert objCaLog;
        
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);           
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);       
        objClass.continueAutomation();
        //CB_ContinueAutomation.handleProcessError('result',lstCF,'error');
        obj.build__c = false;
        obj.builtRealTime__c = false;
        test.StartTest();
        CB_ContinueAutomation tempconautomation = new CB_ContinueAutomation(obj);
        tempconautomation.executeProcess(new list<CRD_BuilderFallout__c>(),'abc',c.id);
        obj.build__c = false;
        obj.builtRealTime__c = false;
        update obj; 
        test.StopTest();
    }*/
      
    Static testMethod void auditUiTest5(){
        case c = new case();
        c.subject ='TestData';
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<CRD_BuilderFallout__c> lstCF = new List<CRD_BuilderFallout__c>();
        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        insert lstBF;
        lstCF.add(lstBF);
        
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.valid__c  = false;  
        obj.validatedRealTime__c = false;      
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        obj.build__c = true;
        obj.builtRealTime__c = false;
        insert obj;
        
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.CRD_Build_Order__c =obj.id;
        objPers.Processed__c = true;
        insert objPers;
        
        ContinueAutomationLog__c caLog = new ContinueAutomationLog__c();
        insert caLog;

        CRD_BF_CALog_Junc__c objCaLog = new CRD_BF_CALog_Junc__c();
        objCaLog.CRD_BID__c = lstBF.Id;
        objCaLog.Type__c = 'Triggered';
        objCaLog.CA_LogID__c = caLog.Id;
        insert objCaLog;
        
        Mapping__c mc = new Mapping__c(Field_Type__c = 'String', Create__c = true, Object__c = 'CRD__c');
        insert mc;
        mapping_values__c mv = new mapping_values__c(MappingColumnId__c = mc.Id);    
        insert mv;
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);           
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);       
        objClass.continueAutomation();
        test.StartTest();
        CB_ContinueAutomation tempconautomation = new CB_ContinueAutomation(obj);
        tempconautomation.executeProcess(new list<CRD_BuilderFallout__c>(),'abc',c.id);
        test.StopTest();
        
    } 
  
 Static testMethod void auditUiTest6(){
        
        case c = new case();
        c.subject ='TestData';
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        List<CRD_BuilderFallout__c> lstCF = new List<CRD_BuilderFallout__c>();
        CRD_BuilderFallout__c lstBF = new CRD_BuilderFallout__c();
        lstBF.CaseId__c = c.id;
        lstBF.Resolved__c = false;
        insert lstBF;
        lstCF.add(lstBF);
        
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.valid__c  = true;        
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        obj.build__c = true;
        obj.builtRealTime__c = false;
        obj.AIRealtime__c = false ;
        obj.Sent_AI_request__c = false;
        obj.complete__c = true;
        insert obj;
        
        Pers_Full_Report__c objPers = new Pers_Full_Report__c();
        objPers.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        objPers.WS_CNTRL_NO__c = 77;
        objPers.WS_PLSM_CD__c = 'JR';
        objPers.WS_NEW_INFRC_EFF_DT__c =System.today();
        objPers.WS_PROV_NUM__c = 90;
        objPers.WS_LV_NO__c = 81;
        objPers.CRD__c = testCrd.id;
        objPers.CRD_Build_Order__c =obj.id;
        objPers.Processed__c = true;
        insert objPers;
        
        ContinueAutomationLog__c caLog = new ContinueAutomationLog__c();
        insert caLog;

        CRD_BF_CALog_Junc__c objCaLog = new CRD_BF_CALog_Junc__c();
        objCaLog.CRD_BID__c = lstBF.Id;
        objCaLog.Type__c = 'Triggered';
        objCaLog.CA_LogID__c = caLog.Id;
        insert objCaLog;
        Mapping__c mc = new Mapping__c(Field_Type__c = 'String', Create__c = true, Object__c = 'CRD__c');
        insert mc;
        mapping_values__c mv = new mapping_values__c(MappingColumnId__c = mc.Id);    
        insert mv;
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (c);      
        test.StartTest();     
        CBAuditUIExtension objClass = new CBAuditUIExtension(stdcontroller);       
        objClass.continueAutomation();

         CB_ContinueAutomation tempconautomation = new CB_ContinueAutomation(obj);
         tempconautomation.executeProcess(new list<CRD_BuilderFallout__c>(),'abcz',c.id);
                          
        test.StopTest();
    }     
Static testMethod void auditUiTest7(){
        Test.StartTest();
        case c = new case();
        c.subject ='TestData';
        RecordType rtNAPL= [Select Id,Name from RecordType where DeveloperName='Internal_CRD_GMF_Process' and SobjectType='Case' LIMIT 1];
        c.RecordTypeId = rtNAPL.Id;
        insert c;
        
        CRD__c testCrd=new CRD__c();
        testCrd.CRD_Automated__c = True;
        insert testCrd;
        
        crdbuildorder__c  obj = new crdbuildorder__c ();                        
        obj.valid__c  = true;        
        obj.CRD__c = testCrd.id; 
        obj.Case__c = c.id;   
        obj.Success_Case__c = c.id;   
        obj.build__c = true;
        obj.builtRealTime__c = false;
        obj.AIRealtime__c = false ;
        obj.Sent_AI_request__c = false;
        obj.complete__c = true;
        insert obj;
        Mapping__c mc = new Mapping__c();
        mc.Object__c = 'CRD__C';
        mc.Create__c = TRUE;
        insert mc;
        mapping_values__c mv = new mapping_values__c ();
       
        mv.MappingColumnID__c= mc.id;
        insert mv;
        CB_ContinueAutomation cbContinue = new CB_ContinueAutomation(obj);
        cbContinue.chkForRxPlanId();
        CB_ContinueAutomation.processAICallout(obj.id);
        cbContinue.processXML();
        cbContinue.processFIFO();
        Test.StopTest();
        }
}