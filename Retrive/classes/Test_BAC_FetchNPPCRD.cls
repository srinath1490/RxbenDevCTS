/*Purpose: Apex Test Class to test NPP Flow
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7/10/2013       Apex Test class to test NPP Flow
======================================================================== */
@isTest
private class Test_BAC_FetchNPPCRD{
//#######Test method for BAC_FetchNPPCRD batch #######
 static testMethod void Test_BAC_FetchNPPCRD(){/*
   
   List<Pers_Data_Storage__c> persRecords = new List<Pers_Data_Storage__c >(); 
     Crd__c newcrd = new Crd__c();
     //Values for Testing if Integration log is created
      newcrd.Platform_Information__c = 'H';
      newcrd.TP_ID__c = null;
      newcrd.Rx_PP_ID__c = null;
      newcrd.Y_Schd__c = 'Y4';
      insert newcrd;
      Partial_Control_Group__c partialgroup = new Partial_Control_Group__c(CSAP_Control_ID__c='475506',CSAP_Plan_ID__c='DB');
      insert partialgroup; 
      
      RecordType rt =[select id,Name from RecordType where sObjectType='CSAP_CGLP_Junction__c' AND Name='CRD to Partial CG' limit 1];
      CSAP_CGLP_Junction__c csapInstance = new CSAP_CGLP_Junction__c();  
      csapInstance.Partial_Control_Group__c= partialgroup.id;
      csapInstance.CRD__c=newcrd.id;
      csapInstance.RecordtypeID=rt.id;
      insert csapInstance;
     
    for (Integer i = 0; i<3; i++){
        Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.ConfigID__c= null;
        persinstance.TPID__c=null;
        persinstance.Processed__c=false;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        persRecords.add(persinstance);
    }
    insert persRecords;
    Test.StartTest();
    BAC_FetchNPPCRD nppbatch = new BAC_FetchNPPCRD();
    ID batchprocessid = Database.executeBatch(nppbatch);   
    Test.StopTest();
    
 */}
 //####### Test Method for BAC_FetchNPPCRD Batch #######
 static testMethod void Test_BAC_FetchNPPCRD1(){/*
 List<Pers_Data_Storage__c> persRecords = new List<Pers_Data_Storage__c >(); 
   CSAP_CGLP_Junction__c csapInstance = new CSAP_CGLP_Junction__c();  
      csapInstance.Partial_Control_Group__c=null;
      insert csapInstance;
     
        Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.ConfigID__c= null;
        persinstance.TPID__c=null;
        persinstance.Processed__c=false;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        insert persinstance;
        
    Test.StartTest();
    BAC_FetchNPPCRD nppbatch = new BAC_FetchNPPCRD();
    ID batchprocessid = Database.executeBatch(nppbatch);    
    Test.StopTest();
 */}
    
 //#######Test Method for BAC_CloneNPPCRD Batch #######   
 static testMethod void Test_BAC_CloneNPPCRD(){/*
 Crd__c newcrd = new Crd__c();
     //Values for Testing if Integration log is created
      newcrd.Platform_Information__c = 'H';
      newcrd.TP_ID__c = null;
      newcrd.Rx_PP_ID__c = null;
      newcrd.Y_Schd__c = 'Y4';
      newcrd.Effective_Start_Date__c= system.today();
      insert newcrd;
      
 Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.ConfigID__c= null;
        persinstance.TPID__c=null;
        persinstance.Processed__c=false;
        persinstance.Effective_date_of_New_Benefits__c = System.today() +5;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        insert persinstance;
        
    Batch_Logger__c batch = new Batch_Logger__c();
    batch.Pers_Data_Storage__c=persinstance.id;
    batch.crd__c=newcrd.id;
    batch.For_NPP__c=True;
    insert batch;
    
    Test.StartTest();
    BAC_CloneNPPCRD clone = new BAC_CloneNPPCRD( 'select Id,CRD__c from Batch_Logger__c where Pers_Data_Storage__c!=null And Processed__c=false And For_NPP__c=True And EffectiveDate_Greater_Than_CRD__c=\'true\'',true);
    ID batchprocessid1 = Database.executeBatch(clone);


    BAC_CloneNPPCRD clone1 = new BAC_CloneNPPCRD( 'select Id from Batch_Logger__c where Pers_Data_Storage__c!=null And Processed__c=false And For_NPP__c=True And EffectiveDate_Greater_Than_CRD__c=\'true\'',true);
    ID batchprocessid2 = Database.executeBatch(clone1);
    Test.StopTest();
*/ }
    
//#######Test Method for BAC_MassSend2AI Batch #######
 static testMethod void Test_BAC_MassSend2AI(){/*
 Crd__c newcrd = new Crd__c();
     //Values for Testing if Integration log is created
      newcrd.Platform_Information__c = 'H';
      newcrd.TP_ID__c = null;
      newcrd.Rx_PP_ID__c = null;
      newcrd.Y_Schd__c = 'Y4';
      newcrd.Effective_Start_Date__c= system.today();
      insert newcrd;
     
 Crd__c CloneCRD = new Crd__c();    
      insert CloneCRD;
     
 Crd__c DummyCRD = new Crd__c();    
      insert DummyCRD;   
 Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.ConfigID__c= null;
        persinstance.TPID__c=null;
        persinstance.Processed__c=false;
        persinstance.Effective_date_of_New_Benefits__c = System.today() +5;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        insert persinstance;
        
    Batch_Logger__c batch = new Batch_Logger__c();
    batch.Pers_Data_Storage__c=persinstance.id;
    batch.crd__c=newcrd.id;
    batch.For_NPP__c=True;
    batch.Processed__c=true;
    batch.Has_Error__c= false;
    batch.Ready_For_AI__c=True;
    batch.Dummy_CRD__c=null;
    insert batch;
    
    Test.StartTest();
    BAC_MassSend2AIclone = new BAC_MassSend2AI('select id,Successfully_Sent_To_AI__c,Has_AI_Error__c,Crd__c,For_NPP__c,For_In_State__c,For_Out_State__c,Cloned_CRD_ID__c,Dummy_crd__c, name from Batch_Logger__c where Processed__c= true and Has_Error__c= false and Ready_For_AI__c=True');
    ID batchprocessid1 = Database.executeBatch(clone);
    
    batch.Dummy_CRD__c=DummyCRD.id;
    batch.Cloned_CRD_ID__c=null; 
    batch.For_NPP__c = False;
    batch.For_In_State__c= True;
    update batch;
    ID batchprocessid2 = Database.executeBatch(clone);
    
    batch.Dummy_CRD__c=null;
    batch.Cloned_CRD_ID__c=CloneCRD.id; 
    batch.For_In_State__c= True;
    update batch;
    ID batchprocessid3 = Database.executeBatch(clone);    
     
    batch.Dummy_CRD__c=null;
    batch.Cloned_CRD_ID__c=CloneCRD.id; 
    batch.For_In_State__c= False;
    batch.For_Out_state__c=True;
    update batch;
    ID batchprocessid4 = Database.executeBatch(clone);
    Test.StopTest();
 */}
    
//#######Test Method for BAC_Callout Batch #######
 static testMethod void Test_BAC_Callout(){ /*
    Crd__c newcrd = new Crd__c();
     //Values for Testing if Integration log is created
      newcrd.Platform_Information__c = 'H';
      newcrd.TP_ID__c = null;
      newcrd.Rx_PP_ID__c = null;
      newcrd.Y_Schd__c = 'Y4';
      newcrd.Effective_Start_Date__c= system.today();
      insert newcrd;
     
    Batch_Logger__c batch = new Batch_Logger__c();
      batch.crd__c=newcrd.id;
      batch.For_NPP__c=True;
      batch.Processed__c=true;
      batch.Has_Error__c= false;
      batch.Ready_For_AI__c=True;
      batch.Dummy_CRD__c=null;
      insert batch;
     
    AI_Request__c AIRec = new AI_Request__c(); 
     AIRec.Batch_Logger_ID__c=batch.id;
     AIRec.CRD_ID__c=newcrd.id;
     AIRec.Created_by_Batch_Process__c=True;
     AIRec.Request_Type__c='Traditional_Non_Packaged';
     insert AIRec;
     
    Test.StartTest();
    BAC_Callout callout = new BAC_Callout();
    ID batchprocessid = Database.executeBatch(callout); 
    Test.StopTest();
 */}
}