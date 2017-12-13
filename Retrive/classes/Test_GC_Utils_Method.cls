@isTest(SeeAllData=True)

public class Test_GC_Utils_Method{
    static testmethod void testGCutil(){
    List<Drug_List_Criteria__c> dlcList = new List<Drug_List_Criteria__c>();
    List<Drug_List_Criteria__c> dlcList1 = new List<Drug_List_Criteria__c>();
    List<Drug_List_Criteria__c> dlcList2 = new List<Drug_List_Criteria__c>();
    Test_TestDataFactory testdataDrugList = new Test_TestDataFactory();
    drug_list__c dl1 = testdataDrugList.TestDataFactoryDrugList();
    Drug_List_Criteria__c dlc = new Drug_List_Criteria__c();
        dlc.Drug_Type_Code__c = 'GPI';
        dlc.Drug_Code_Value__c='6210*';
        dlc.Effective__c = system.today();
        dlc.term__c = system.today();
        dlc.drug_list__c = dl1.id;
        dlc.Status__c = 'Approved';
        insert dlc;
        dlcList.add(dlc);
    Drug_List_Criteria__c dlc1 = new Drug_List_Criteria__c();
        dlc1.Drug_Type_Code__c = 'GPI';
        dlc1.Drug_Code_Value__c='6210*';
        dlc1.Effective__c = system.today() + 5;
        dlc1.term__c = system.today() + 5;
        dlc1.drug_list__c = dl1.id;
        dlc1.Status__c = 'Approved';
        insert dlc1;
        dlcList1.add(dlc1);   
        
        dlcList2.add(dlc);
        dlcList2.add(dlc1);
    CRD__c newCRD = new CRD__c();
        newCRD.IsDummyCRD__c= False; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Override_Retail_Y_Schedule__c = 'Yes';
        newCRD.Which_system_will_the_plan_be_installed__c = 'HMO';
        newCRD.Predefined__c = True;
        newCRD.Integrating_User__c = '00550000003BTal';
        insert newCRD;
    AI_Request__c Air = new AI_Request__c();
        Air.CRD_ID__c = newCRD.id;
        insert Air;
    GC_Utils_Method gcutil = new GC_Utils_Method();
    gcutil.compareWithMultiSelect('abc','def');
    gcutil.truncateString('abc',9);
    GC_Utils_Method.mergeLists(dlcList,dlcList1);
    GC_Utils_Method.mergeLists(dlcList,dlcList);
    GC_Utils_Method.merge_sort(dlcList);
    GC_Utils_Method.merge_sort(dlcList2);
    Id userId = '00550000003BTal';
    Batch_Logger__c bcLog = new Batch_Logger__c();
        bcLog.CRD__c = newCRD.id;
        insert bcLog;
    gcutil.sendToAi1(newCRD,userId,bcLog);
    gcutil.overideYscheduleValues(newCRD);
    GC_Utils_Method.callout(bcLog.id , Air);
     Air.Plan_ID__c = 'AB';
     Air.Request_Type__c = 'HMO';
     Air.Benefit__c = 'Aetna Student Health';
     Air.Benefits_String_Extn__c = 'Test';
     Air.Integration_1__c = 'Test';
     Air.Pricing_Schedule__c ='Y4';
     Air.Risk_Indicator__c ='R';
     Air.StateList_to_Remove__c = 'Test';
     update Air;
     GC_Utils_Method.callout(bcLog.id , Air);
    GC_Utils_Method.calculateYSchedule(newCRD, newCRD.Sub_segment__c);
    GC_Utils_Method.calculateControl('1111111');
    GC_Utils_Method.calculateControl('111111');
    GC_Utils_Method.calculateControl('11111');
    GC_Utils_Method.calculateControl('1111');
    GC_Utils_Method.calculateControl('111');
    GC_Utils_Method.calculateControl('11');
    GC_Utils_Method.calculateControl('1');
    GC_Utils_Method.calculateControl('');
    gcutil.truncateString('1111111',5);
    gcutil.compareWithMultiSelect('Test1;Test2','Test1');
    }
    static testMethod void testGCutil2(){
    CRD__c newCRD = new CRD__c();
        newCRD.IsDummyCRD__c= False; 
        newCRD.Standard_or_Custom_Plan__c ='Cloning a HIX plan from existing CRD';
        newCRD.Are_you_creating_a_Package_Plan__c = 'Yes';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Override_Retail_Y_Schedule__c = 'Yes';
        newCRD.Which_system_will_the_plan_be_installed__c = 'HRP';
        newCRD.Predefined__c = True;
        newCRD.Plan_Type_Retail__c = TRUE;
        insert newCRD;
    GC_Utils_Method.calculateYSchedule(newCRD, newCRD.Sub_segment__c);
    
 }
 static testmethod void testGCutil3(){
     String dcRetailRecordID;
     for(RecordType RecType : [Select Id,Name,SobjectType From RecordType where SobjectType = 'Drug_Coverage__c'] ){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
         }
     }
     CRD__c newCRD = new CRD__c();
        newCRD.IsDummyCRD__c= False; 
        newCRD.Standard_or_Custom_Plan__c ='Cloning a HIX plan from existing CRD';
        insert newCRD;
     List < Batch_Logger__c > batchLoggerList = new List<Batch_Logger__c>();
     List < Drug_Coverage__c > dcList = new List<Drug_Coverage__c>();
     Batch_Logger__c bcLog = new Batch_Logger__c();
     bcLog.CRD__c = newCRD.id;
     insert bcLog;
     batchLoggerList.add(bcLog);
     Database.SaveResult[] sr1= Database.insert(batchLoggerList,false);
     Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = newCRD.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = Null;
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'Yes';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='RRA';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = 2;
        dcList.add(dCoverageRetail);
     Database.SaveResult[] sr2= Database.insert(dcList,false);
          
     GC_Utils_Method.logSaveresult(batchLoggerList , sr1);
     GC_Utils_Method.saveBusinessRuleResults(dcList,sr2);
     
 }
 static testMethod void testGCutil4(){
 Test_TestDataFactory testdataDrugList = new Test_TestDataFactory();
    drug_list__c dl1 = testdataDrugList.TestDataFactoryDrugList();
   Account ac = new Account();
       ac.Name='TestACC';
       ac.Predefined__c = True;
       insert ac;
    case c = new case(subject ='TestData',Service_Request_Type__c='Issue',Triage_Category__c='Other');
            insert c;
   List<CRD__c> listCRD = new List<CRD__c>();
   CRD__c testCrd=new CRD__c();
        CRD__c newCRD = new CRD__c();
        newCRD.IsDummyCRD__c= False; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'AB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Override_Retail_Y_Schedule__c = 'Yes';
        newCRD.Which_system_will_the_plan_be_installed__c = 'HMO';
        newCRD.Predefined__c = True;
        newCRD.Integrating_User__c = '00550000003BTal';
        newCRD.CRD_Automated__c = TRUE;
        newCRD.Control__c = '1234567';
        newCRD.Account__c = ac.id;
        newCRD.Plan_Type_Retail__c = TRUE;
        newCRD.Insured_Type__c = 'Self Insured';
        Database.SaveResult insertCRD = Database.insert(newCRD, false);
        listCRD.add(newCRD);
     Pers_Data_Storage__c persinstance  = new Pers_Data_Storage__c ();
        persinstance.TPID__c='00017242422';
        persinstance.Processed__c=false;
        persinstance.case__c=c.id;
        persinstance.Rxplan_id__c='1231231233';
        insert persinstance;
     Map<String,Pers_Data_Storage__c> mapPersStorage = new Map<string,Pers_Data_Storage__c>();
         mapPersStorage.put('test',persinstance);
     
     crdbuildorder__c  obj = new crdbuildorder__c ();                        
            obj.XML__c  = true;
            obj.CRD__c = newCRD.id; 
            obj.Case__c = c.id;      
            insert obj;
     Partial_Control_Group__c pcg = new Partial_Control_Group__c();
     pcg.CSAP_Control_ID__c = '1234567';
     pcg.Subsegment__c= 'AB';
     pcg.Account__c = ac.id;
     pcg.CSAP_Plan_ID__c = 'CB';
     insert pcg;
     Y_Schedule_Pricing_Override__c YSCH = new Y_Schedule_Pricing_Override__c ();
     YSCH.Discount_Card__c = 'N';
     YSCH.ERB__c = 'N';
     YSCH.Funding_Type__c = 'N';
     YSCH.Retail_Network__c  = 16;
     YSCH.Sub_Segment__c = 'AB';
     YSCH.Key__c = 'ABNNN16';
     YSCH.Override_Type__c= 'pricing_schedule_trad';
     insert YSCH;
     
     GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
     Pers_Full_Report__c PFR=new Pers_Full_Report__c();
        PFR.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        PFR.WS_PSUID__c='83712271';
        PFR.WS_CNTRL_NO__c = 77;
        PFR.WS_PLSM_CD__c = 'JR';
        PFR.WS_NEW_INFRC_EFF_DT__c =System.today();
        PFR.WS_COB_CD__c = '02';
        PFR.WS_RISK_IND__c ='R';
        PFR.WS_PROV_NUM__c=73;
        PFR.WS_LV_NO__c=16;
        PFR.CRD_Build_Order__c=obj.id;
        PFR.CRD__c = newCRD.id;
        Database.SaveResult insertPFR = Database.insert(PFR, false);
     system.assertEquals(newCRD.id,PFR.CRD__c);
     List<Database.SaveResult> lsDR = new List<Database.SaveResult>();
         lsDR.add(insertPFR);
         lsDR.add(insertCRD);
     
     GC_Utils_Method.calculateYSchedule(newCRD, newCRD.Sub_segment__c);
     GC_Utils_Method.logSaveresult(listCRD,mapPersStorage,lsDR);
     GC_Utils_Method gc = new GC_Utils_Method();
     gc.checkManagementUser();
     AHA_Junction__c cH = new AHA_Junction__c();
     cH.CRD_ID__c = newCRD.id;
     cH.Drug_List_ID__c = dl1.id;
     insert cH;
     AHA_Junction_History__c chHis = new AHA_Junction_History__c ();
     gc.historyData(chHis ,cH.id,'Drug_List__c  ','Nitish','DF','FG');
     gc.historyDatasObject(chHis ,cH.id,'Drug_List__c','Nitish','DF','FG');
     
  }
}