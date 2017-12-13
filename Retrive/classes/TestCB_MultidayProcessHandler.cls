@isTest

public class TestCB_MultidayProcessHandler{

 static   Testmethod void test1(){
 
     
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today()+5;
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
        
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
    
    CSAP_CGLP_Junction__c csapPCG = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG.RecordTypeId=strPCGRecordTypeId;
        csapPCG.CRD__c = c.id;
        csapPCG.Partial_Control_Group__c = pc.id;
        insert csapPCG;
    
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG.RecordTypeId=strFCGRecordTypeId;
        csapFCG.CRD__c = c.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
        
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
     
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '797yu90';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today();
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = crd.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 
  static   Testmethod void test2(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today();
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
        
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
    
    CSAP_CGLP_Junction__c csapPCG = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG.RecordTypeId=strPCGRecordTypeId;
        csapPCG.CRD__c = c.id;
        csapPCG.Partial_Control_Group__c = pc.id;
        insert csapPCG;
    
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG.RecordTypeId=strFCGRecordTypeId;
        csapFCG.CRD__c = c.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
        
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = c.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 static   Testmethod void test3(){
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
      Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
        
      CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today();
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
       case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase; 
                 
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = c.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest(); 
  }
  
  static   Testmethod void test4(){
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
        
      CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today();
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
       case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase; 
      case falloutCase = new case();
        String strCaseRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        falloutCase.RecordTypeId = strCaseRecordTypeId2;
        falloutCase.status = 'New';
        falloutCase.Review_Notes__c = 'Test';
        falloutCase.FIFO_Tag__c = 'General';
        falloutCase.Transaction_Type__c = 'New';
        insert falloutCase;           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = c.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        cbon.falloutCase__c = falloutCase.id;
        insert cbon;
    cbList.add(cbon);
    
    
    
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest(); 
  }
  static   Testmethod void test5(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today()+5;
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
        
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
     
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strPCGFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'Full CG to Partial CG'].Id;
        csapFCG.RecordTypeId=strPCGFCGRecordTypeId;
        csapFCG.Partial_Control_Group__c= pc.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
        
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
     
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '797yu90';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today();
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = crd.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 
 static   Testmethod void test6(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today()+5;
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
        
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
     
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
            
    case successCase2 = new case();
        String strCaseRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase2.RecordTypeId = strCaseRecordTypeId2;
        successCase2.status = 'New';
        successCase2.Reason = 'Duplicate';
        successCase2.FIFO_Tag__c = 'General';
        successCase2.Transaction_Type__c = 'New';
        insert successCase2; 
        
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = c.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase2.id;
        insert cbon;
        cbList.add(cbon);
        
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '797yu90';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today();
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
    
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase; 
        
       case falloutCase = new case();
        String strfalloutCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        falloutCase.RecordTypeId = strfalloutCaseRecordTypeId;
        falloutCase.status = 'New';
        falloutCase.Reason = 'Duplicate';
        falloutCase.FIFO_Tag__c = 'General';
        falloutCase.Transaction_Type__c = 'New';
        insert falloutCase; 
               
    CRDBuildOrder__c cbon2 = new CRDBuildOrder__c();
        cbon2.CRD__c = crd.id;
        cbon2.Control__c = 254;
        cbon2.Plan__c = 'CC';
        cbon2.Effective_date__c = System.Today();
        cbon2.Build__c = TRUE;
        cbon2.valid__c = TRUE;
        cbon2.complete__c = TRUE;
        cbon2.Aicallout__c = TRUE;
        cbon2.Sent_AI_request__c = TRUE;
        cbon2.Success_Case__c = successCase.id;
        cbon2.FalloutCase__c = falloutCase.id;
        insert cbon2;
    cbList.add(cbon2);
    
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 
 static   Testmethod void test7(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today();
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
        
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
    
    CSAP_CGLP_Junction__c csapPCG = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG.RecordTypeId=strPCGRecordTypeId;
        csapPCG.CRD__c = c.id;
        csapPCG.Partial_Control_Group__c = pc.id;
        insert csapPCG;
    
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG.RecordTypeId=strFCGRecordTypeId;
        csapFCG.CRD__c = c.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
        
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
     
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '797yu90';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today()+2;
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = crd.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
        CRD__c crd2 = new CRD__c();
        crd2.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd2.Account__c = ac.id;
        crd2.National__c = 'Key';
        crd2.Contract_State__c = 'OH';
        crd2.Plan_Type_Retail__c = TRUE;
        crd2.Effective_Start_Date__c = system.today();
        crd2.PERS_timestamp__c = system.today();
        crd2.Integrate_with_Medical__c = 'No';
        crd2.control__c = '254';
        crd2.Plan__c = 'CC';
        insert crd2;
           
    CRDBuildOrder__c cbon2 = new CRDBuildOrder__c();
        cbon2.CRD__c = crd2.id;
        cbon2.Control__c = 254;
        cbon2.Plan__c = 'CC';
        cbon2.Effective_date__c = System.Today();
        cbon2.Build__c = TRUE;
        cbon2.valid__c = TRUE;
        insert cbon2;
        
    cbList.add(cbon);
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 
 static   Testmethod void test8(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
     
      Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
       
       Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;  
      
       Partial_Control_Group__c pc2 = new Partial_Control_Group__c();
        pc2.Account__c = ac.id;
        pc2.CSAP_Control_ID__c = '0000253';
        pc2.CSAP_Plan_ID__c = 'CE';
        insert pc2;
       
       Full_Control_Group__c fc2 = new Full_Control_Group__c();
        fc2.Account_Name__c = ac.id;
        fc2.CSAP_Control_ID__c = '0000253';
        fc2.CSAP_Plan_ID__c = 'CJ';
        insert fc2;
               
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '797yu90';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today();
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        c.Partial_Control_Group__c = pc.id;
        c.Full_Control_Group__c = fc.id;
        insert c;
     
    
   
    
    CSAP_CGLP_Junction__c csapPCG = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG.RecordTypeId=strPCGRecordTypeId;
        csapPCG.CRD__c = c.id;
        csapPCG.Partial_Control_Group__c = pc.id;
        insert csapPCG;
    
    
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG.RecordTypeId=strFCGRecordTypeId;
        csapFCG.CRD__c = c.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
     
       
     
        CSAP_CGLP_Junction__c csapPCG2 = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG2.RecordTypeId=strPCGRecordTypeId2;
        csapPCG2.CRD__c = c.id;
        csapPCG2.Partial_Control_Group__c = pc2.id;
        insert csapPCG2;
    
    
        
      CSAP_CGLP_Junction__c csapFCG2 = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG2.RecordTypeId=strFCGRecordTypeId2;
        csapFCG2.CRD__c = c.id;
        csapFCG2.Full_Control_Group__c = fc2.id;
        insert csapFCG2;
       
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
     
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '797yu90';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today()+2;
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = crd.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        insert cbon;
    cbList.add(cbon);
    
        CRD__c crd2 = new CRD__c();
        crd2.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd2.Account__c = ac.id;
        crd2.National__c = 'Key';
        crd2.Contract_State__c = 'OH';
        crd2.Plan_Type_Retail__c = TRUE;
        crd2.Effective_Start_Date__c = system.today();
        crd2.PERS_timestamp__c = system.today();
        crd2.Integrate_with_Medical__c = 'No';
        crd2.control__c = '254';
        crd2.Plan__c = 'CC';
        insert crd2;
           
    CRDBuildOrder__c cbon2 = new CRDBuildOrder__c();
        cbon2.CRD__c = crd2.id;
        cbon2.Control__c = 254;
        cbon2.Plan__c = 'CC';
        cbon2.Effective_date__c = System.Today();
        cbon2.Build__c = TRUE;
        cbon2.valid__c = TRUE;
        insert cbon2;
        
    cbList.add(cbon);
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
 
 static   Testmethod void test9(){
 
 
     List<CRDBuildOrder__c> cbList = new List<CRDBuildOrder__c>();
     Test.StartTest();
     Account ac = new Account();
         ac.Name = 'TestAccountForMultiday';
         insert ac;
         
     CRD__c c = new CRD__c();
        c.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c.RxPlanID__c = '5000091504';
        c.Account__c = ac.id;
        c.National__c = 'Key';
        c.Contract_State__c = 'OH';
        c.Plan_Type_Retail__c = TRUE;
        c.Effective_Start_Date__c = system.today();
        c.PERS_timestamp__c = system.today()+5;
        c.Integrate_with_Medical__c = 'No';
        c.control__c = '254';
        c.Plan__c = 'CC';
        insert c;
    Partial_Control_Group__c pc = new Partial_Control_Group__c();
        pc.Account__c = ac.id;
        pc.CSAP_Control_ID__c = '0000254';
        pc.CSAP_Plan_ID__c = 'CC';
        insert pc;
    
    CSAP_CGLP_Junction__c csapPCG = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG.RecordTypeId=strPCGRecordTypeId;
        csapPCG.CRD__c = c.id;
        csapPCG.Partial_Control_Group__c = pc.id;
        insert csapPCG;
    
     Full_Control_Group__c fc = new Full_Control_Group__c();
        fc.Account_Name__c = ac.id;
        fc.CSAP_Control_ID__c = '0000254';
        fc.CSAP_Plan_ID__c = 'CC';
        insert fc;
        
      CSAP_CGLP_Junction__c csapFCG = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG.RecordTypeId=strFCGRecordTypeId;
        csapFCG.CRD__c = c.id;
        csapFCG.Full_Control_Group__c = fc.id;
        insert csapFCG;
        
     case successCase = new case();
        String strCaseRecordTypeId = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        successCase.RecordTypeId = strCaseRecordTypeId;
        successCase.status = 'New';
        successCase.Reason = 'Duplicate';
        successCase.FIFO_Tag__c = 'General';
        successCase.Transaction_Type__c = 'New';
        insert successCase;   
     
    CRD__c crd = new CRD__c();
        crd.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd.RxPlanID__c = '5000091504';
        crd.Account__c = ac.id;
        crd.National__c = 'Key';
        crd.Contract_State__c = 'OH';
        crd.Plan_Type_Retail__c = TRUE;
        crd.Effective_Start_Date__c = system.today();
        crd.PERS_timestamp__c = system.today();
        crd.Integrate_with_Medical__c = 'No';
        crd.control__c = '254';
        crd.Plan__c = 'CC';
        insert crd;
           
    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
        cbon.CRD__c = crd.id;
        cbon.Control__c = 254;
        cbon.Plan__c = 'CC';
        cbon.Effective_date__c = System.Today();
        cbon.Build__c = TRUE;
        cbon.valid__c = TRUE;
        cbon.complete__c = TRUE;
        cbon.Aicallout__c = TRUE;
        cbon.Sent_AI_request__c = TRUE;
        cbon.Success_Case__c = successCase.id;
        cbon.ExistingRxplan__c = TRUE;
        insert cbon;
    cbList.add(cbon);
  
    CRD__c c2 = new CRD__c();
        c2.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        c2.RxPlanID__c = '5000091504';
        c2.Account__c = ac.id;
        c2.National__c = 'Key';
        c2.Contract_State__c = 'OH';
        c2.Plan_Type_Retail__c = TRUE;
        c2.Effective_Start_Date__c = system.today();
        c2.PERS_timestamp__c = system.today()+5;
        c2.Integrate_with_Medical__c = 'No';
        c2.control__c = '255';
        c2.Plan__c = 'CC';
        insert c2;
    Partial_Control_Group__c pc2 = new Partial_Control_Group__c();
        pc2.Account__c = ac.id;
        pc2.CSAP_Control_ID__c = '0000255';
        pc2.CSAP_Plan_ID__c = 'CC';
        insert pc2;
    
    CSAP_CGLP_Junction__c csapPCG2 = new CSAP_CGLP_Junction__c();
        String strPCGRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Partial CG'].Id;
        csapPCG2.RecordTypeId=strPCGRecordTypeId2;
        csapPCG2.CRD__c = c2.id;
        csapPCG2.Partial_Control_Group__c = pc2.id;
        insert csapPCG2;
    
     Full_Control_Group__c fc2 = new Full_Control_Group__c();
        fc2.Account_Name__c = ac.id;
        fc2.CSAP_Control_ID__c = '0000255';
        fc2.CSAP_Plan_ID__c = 'CC';
        insert fc2;
        
      CSAP_CGLP_Junction__c csapFCG2 = new CSAP_CGLP_Junction__c();
        String strFCGRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'CSAP_CGLP_Junction__c' and Name = 'CRD to Full CG'].Id;
        csapFCG2.RecordTypeId=strFCGRecordTypeId2;
        csapFCG2.CRD__c = c2.id;
        csapFCG2.Full_Control_Group__c = fc2.id;
        insert csapFCG2;
       case falloutCase2 = new case();
        String strCaseRecordTypeId2 = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        falloutCase2.RecordTypeId = strCaseRecordTypeId2;
        falloutCase2.status = 'New';
        falloutCase2.Review_Notes__c = 'Test';
        falloutCase2.FIFO_Tag__c = 'General';
        falloutCase2.Transaction_Type__c = 'New';
        insert falloutCase2;
          
      CRD__c crd2 = new CRD__c();
        crd2.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd2.RxPlanID__c = '5000091504';
        crd2.Account__c = ac.id;
        crd2.National__c = 'Key';
        crd2.Contract_State__c = 'OH';
        crd2.Plan_Type_Retail__c = TRUE;
        crd2.Effective_Start_Date__c = system.today();
        crd2.PERS_timestamp__c = system.today();
        crd2.Integrate_with_Medical__c = 'No';
        crd2.control__c = '255';
        crd2.Plan__c = 'CC';
        insert crd2;
           
    CRDBuildOrder__c cbon2 = new CRDBuildOrder__c();
        cbon2.CRD__c = crd2.id;
        cbon2.Control__c = 255;
        cbon2.Plan__c = 'CC';
        cbon2.Effective_date__c = System.Today();
        cbon2.Build__c = TRUE;
        cbon2.valid__c = TRUE;
        cbon2.complete__c = TRUE;
        cbon2.Aicallout__c = TRUE;
        cbon2.Sent_AI_request__c = TRUE;
        cbon2.Success_Case__c = successCase.id;
        cbon2.falloutCase__c = falloutcase2.id;
        
        insert cbon2;
    cbList.add(cbon2);
    
        case falloutCase3 = new case();
        String strCaseRecordTypeId3 = [Select Id From RecordType Where SobjectType = 'case' and Name = 'Internal CRD/GMF Process'].Id;
        falloutCase3.RecordTypeId = strCaseRecordTypeId2;
        falloutCase3.status = 'New';
        falloutCase3.Review_Notes__c = 'Test';
        falloutCase3.FIFO_Tag__c = 'General';
        falloutCase3.Transaction_Type__c = 'New';
        insert falloutCase3;
          
      CRD__c crd3 = new CRD__c();
        crd3.Standard_or_Custom_Plan__c = 'Creating a package plan';
        crd3.Account__c = ac.id;
        crd3.National__c = 'Key';
        crd3.Contract_State__c = 'OH';
        crd3.Plan_Type_Retail__c = TRUE;
        crd3.Effective_Start_Date__c = system.today();
        crd3.PERS_timestamp__c = system.today();
        crd3.Integrate_with_Medical__c = 'No';
        crd3.control__c = '255';
        crd3.Plan__c = 'CC';
        insert crd3;
           
    CRDBuildOrder__c cbon3 = new CRDBuildOrder__c();
        cbon3.CRD__c = crd3.id;
        cbon3.Control__c = 255;
        cbon3.Plan__c = 'CC';
        cbon3.Effective_date__c = System.Today();
        cbon3.Build__c = TRUE;
        cbon3.valid__c = TRUE;
        cbon3.complete__c = TRUE;
        cbon3.Aicallout__c = TRUE;
        cbon3.Sent_AI_request__c = TRUE;
        cbon3.falloutCase__c = falloutcase2.id;
        
        insert cbon3;
    cbList.add(cbon3);
    
    CVSRxPlanId__c cvsEntry = new CVSRxPlanId__c();
           cvsEntry.CRD_Name__c = c2.name;
           cvsEntry.RxPlanId__c = c2.RxPlanId__c;
           insert cvsEntry;
  List<CVSRxPlanId__c> existingrxplaindsGlobal = [select id,RxPlanId__c,CRD_Name__c from CVSRxPlanId__c where RxPlanId__c  =:crd2.RxPlanID__c];
  system.debug('$$$$$$' + existingrxplaindsGlobal);
    BAC_CB_CAGRestructure multidayBatch = new BAC_CB_CAGRestructure();
    database.executeBatch(multidayBatch);
    Test.StopTest();
 }
}