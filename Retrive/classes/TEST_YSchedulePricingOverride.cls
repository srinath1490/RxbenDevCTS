/*
Purpose: Test Class for testing YSchedulePricingOverride functionality
===============================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL
-------------------------------------------------------------------------------
1.0         rakesh          03/29/2013          Requst 00483.
===============================================================================
*/

@isTest
private class TEST_YSchedulePricingOverride {

    static testMethod void myUnitTest() {
        
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.CSAP_Plan_ID__c = 'PI';
        fcg.CSAP_Control_ID__c = 'CI';
        fcg.CSAP_Account_ID__c = 'AI';
        fcg.CSAP_Suffix_ID__c = 'SI';
        insert fcg;
        
        CRD__c crd = new CRD__c(Full_Control_Group__c = fcg.Id);
        crd.Platform_Information__c = 'H';
        crd.Effective_Start_Date__c = System.today();
        crd.Are_you_creating_a_Package_Plan__c = 'Yes';
        crd.Which_system_will_the_plan_be_installed__c = 'HMO';
        crd.Override_Retail_Y_Schedule__c = 'No';
        crd.Sub_segment__c='AAM';
        insert crd;        
        
        Y_Schedule_Pricing_Override__c ySchedule = new Y_Schedule_Pricing_Override__c();
        ySchedule.Platform_Indicator__c = 'H';
        ySchedule.Control_Group__c = 'CI';
        ySchedule.Effective_Date__c = System.today() - 7;
        ySchedule.Termination_Date__c = System.today() + 7;
        ySchedule.Plan_Summary_Company_Code__c = '*';
        ySchedule.Suffix_Location__c = '*';
        ySchedule.Price_Schedule__c = 'Y3';
        ySchedule.Account_Plan__c = '*';
        ySchedule.CRD_Indicator__c = 'C';
        ySchedule.key__c = '*CIY3';
        ySchedule.Override_Type__c = 'test';
        insert ySchedule;
        
       
          Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          dl.Description__c='tyest';    
          insert dl;

        
        
        Test.startTest();
        String returnedSched = GC_Utils_Method.getPricingSchedule(crd);
        List<String> calySchedule=GC_Utils_Method.calculateYSchedule(crd,'Test');
        Drug_List_Criteria__c objDrugListCriteria=new Drug_List_Criteria__c();
        List<Drug_List_Criteria__c> lstDrugListCriteria=new List<Drug_List_Criteria__c>();
       // objDrugListCriteria.Required__c=12;
        objDrugListCriteria.Term__c = System.today()+7;
        objDrugListCriteria.Drug_List__c=dl.id;
        objDrugListCriteria.Effective__c=system.today();
       // insert objDrugListCriteria;
        lstDrugListCriteria.add(objDrugListCriteria);
        insert lstDrugListCriteria;
       
        
        
        // System.assertEquals(returnedSched, 'Y3');
        GC_Utils_Method utils =new GC_Utils_Method(); 
         GC_Utils_Method.calculateYSchedule(crd,'AAM');
        utils.overrideSubSegmentValue(crd);
        utils.overideYscheduleValues(crd);
         GC_Utils_Method.mergeLists(lstDrugListCriteria,lstDrugListCriteria);
        Test.stopTest();
    }
     static testMethod void myUnitTest1() {
        
        Full_Control_Group__c fcg = new Full_Control_Group__c();
        fcg.CSAP_Plan_ID__c = 'PI';
        fcg.CSAP_Control_ID__c = 'CI';
        fcg.CSAP_Account_ID__c = 'AI';
        fcg.CSAP_Suffix_ID__c = 'SI';
        insert fcg;
        
        CRD__c crd = new CRD__c(Full_Control_Group__c = fcg.Id);
        crd.Platform_Information__c = 'H';
        crd.Effective_Start_Date__c = System.today();
        crd.Are_you_creating_a_Package_Plan__c = 'Yes';
        crd.Which_system_will_the_plan_be_installed__c = 'HMO';
        crd.Override_Retail_Y_Schedule__c = 'Yes';
        crd.Sub_segment__c=null;
        insert crd;        
        
        Y_Schedule_Pricing_Override__c ySchedule = new Y_Schedule_Pricing_Override__c();
        ySchedule.Platform_Indicator__c = 'H';
        ySchedule.Control_Group__c = 'CI';
        ySchedule.Effective_Date__c = System.today() - 7;
        ySchedule.Termination_Date__c = System.today() + 7;
        ySchedule.Plan_Summary_Company_Code__c = '*';
        ySchedule.Suffix_Location__c = '*';
        ySchedule.Price_Schedule__c = 'Y3';
        ySchedule.Account_Plan__c = '*';
        ySchedule.CRD_Indicator__c = 'C';
        ySchedule.key__c = '*CIY3';
        ySchedule.Override_Type__c = 'test';
        insert ySchedule;
        
       
          Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          dl.Description__c='tyest';    
          insert dl;

        
        
        Test.startTest();
        String returnedSched = GC_Utils_Method.getPricingSchedule(crd);
        List<String> calySchedule=GC_Utils_Method.calculateYSchedule(crd,'Test');
        Drug_List_Criteria__c objDrugListCriteria=new Drug_List_Criteria__c();
        List<Drug_List_Criteria__c> lstDrugListCriteria=new List<Drug_List_Criteria__c>();
       // objDrugListCriteria.Required__c=12;
        objDrugListCriteria.Term__c = System.today()+7;
        objDrugListCriteria.Drug_List__c=dl.id;
        objDrugListCriteria.Effective__c=system.today();
       // insert objDrugListCriteria;
        lstDrugListCriteria.add(objDrugListCriteria);
        database.insert(lstDrugListCriteria);
       
       account testaccount = new account();
       account testaccount2 = new account();
       list<account> lstaccount = new list<account>();
       lstaccount .add(testaccount );
       lstaccount .add(testaccount2 );
        Database.SaveResult[] srList =  database.insert(lstaccount ,false);
        
        // System.assertEquals(returnedSched, 'Y3');
        GC_Utils_Method utils =new GC_Utils_Method(); 
         GC_Utils_Method.calculateYSchedule(crd,'AAM');
        utils.overrideSubSegmentValue(crd);
        utils.overideYscheduleValues(crd);
         GC_Utils_Method.mergeLists(lstDrugListCriteria,lstDrugListCriteria);
         GC_Utils_Method.mergeLists(lstDrugListCriteria,lstDrugListCriteria);
         TRY{
         GC_Utils_Method.logBatchLoggerError(new Batch_Logger__c(),null);
         }
         catch(exception ex){
            GC_Utils_Method.logBatchLoggerError(new Batch_Logger__c(),ex);
         }
         
         Y_Schedule_Pricing_Override__c testschpriceover = new Y_Schedule_Pricing_Override__c();
         map<id,Y_Schedule_Pricing_Override__c> testschpriceovermap= new map<id,Y_Schedule_Pricing_Override__c>();
         testschpriceovermap.put(dl.id,testschpriceover);
         GC_Utils_Method.YSchedulePricingOverrideFilter(testschpriceovermap,testschpriceover);
         try{
         GC_Utils_Method.logSaveresult(null,null,srList);}
         catch(exception ex){}
         List < Batch_Logger__c > batchLoggerList = new list<Batch_Logger__c>();
         batchLoggerList.add(new Batch_Logger__c());
         try{
         GC_Utils_Method.logSaveresult(batchLoggerList,srList);}
         catch(exception ex){}
         crd.isdummycrd__c = false;
         utils.sendToAi1(crd,userinfo.getUserId(),new Batch_Logger__c());
        Test.stopTest();
    }
}