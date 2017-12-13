/*Purpose: Apex Test Class to test In State Flow
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7/10/2013       Apex Test class to test In State Flow
======================================================================== */
@isTest
private class Test_BAC_FetchInStateCRD{
//#######Test method for BAC_FetchInStateCRD batch #######
  static testMethod void Test_BAC_InState(){
    /*Crd__c newcrd = new Crd__c();
        newcrd.Rxplanid__c='1257894589';
        insert newcrd;*/
      
    Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.TPID__c='00014242422';
        persinstance.Processed__c=false;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        insert persinstance;
      
    /* Batch_Logger__c batch = new Batch_Logger__c();
        batch.For_In_State__c=True;
        batch.Processed__c=False;
        batch.Has_Error__c= false;
        batch.Ready_For_AI__c=True;
        batch.Dummy_CRD__c=null;
        batch.Rxplanid__c='1257894589';
        insert batch;*/
      
        Test.StartTest();
        //BAC_FetchInStateCRD InStatebatch = new BAC_FetchInStateCRD();
        //ID batchprocessid = Database.executeBatch(InStatebatch);   
      
        //BAC_FetchCRDWithRxplanId InStatebatch2 = new BAC_FetchCRDWithRxplanId();
        //ID batchprocessid1 = Database.executeBatch(InStatebatch2);
      
        Test.StopTest();
  }
    
  //#######Test method for BAC_FetchCRDWithRxplanId batch #######  
    static testMethod void Test_BAC_FetchCRDWithRxplanId(){
    Crd__c newcrd = new Crd__c();
        newcrd.Rxplanid__c='1257894589';
        insert newcrd;
             
    Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.TPID__c='00014242422';
        persinstance.Processed__c=false;
        persinstance.Control_No__c='475506';
        persinstance.PLSM_CD__c='DB';
        insert persinstance;
      
    Batch_Logger__c batch = new Batch_Logger__c();
        batch.For_In_State__c=True;
        batch.Processed__c=False;
        batch.Has_Error__c= false;
        batch.Ready_For_AI__c=True;
        batch.Dummy_CRD__c=null;
        batch.Rxplanid__c='1257894589';
        insert batch;
      
        Test.StartTest();        
        BAC_FetchCRDWithRxplanId InStatebatch2 = new BAC_FetchCRDWithRxplanId();
        ID batchprocessid1 = Database.executeBatch(InStatebatch2);
      
        Test.StopTest();
  }
    
     //#######Test method for TRG_CRDAfterUpdate batch #######  
/*    static testMethod void Test_TRG_CRDAfterUpdate(){
        Crd__c newcrd = new Crd__c();
        newcrd.ISDummyCRD__c=true;
        insert newcrd;
        newcrd.Rxplanid__c='1257894589';
        update newcrd;
    }*/

}