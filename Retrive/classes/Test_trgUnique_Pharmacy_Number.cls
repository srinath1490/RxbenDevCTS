/*
Purpose: Test Class for testing trgUnique_Pharmacy_Number
===============================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL
-------------------------------------------------------------------------------
1.0         Rahul          06/21/2013          trgUnique_Pharmacy_Number coverage.
===============================================================================
*/

@isTest
public class Test_trgUnique_Pharmacy_Number {
    
    static testMethod void myUnitTest() {

      List < Schema.RecordTypeInfo > networkDrugCoverageRtInfo = Network_Drug_Coverage__c.sObjectType.getDescribe().getRecordTypeInfos();

      Map < String, Id > recordTypeMap = new Map < String, Id > ();
      for (Schema.Recordtypeinfo thisInfo: networkDrugCoverageRtInfo ) {
          recordTypeMap.put(thisInfo.Name, thisInfo.getRecordTypeId());
      }
      
      Custom_Rx_Network__c crn = new Custom_Rx_Network__c();
      crn.Does_Network_Apply_to_Entire_PSU__c = true;
      crn.Self_Insured__c = true;
      crn.Does_spread_pricing_apply__c = 'Yes';
      insert crn;
      
      Network_Pharmacy__c np=new Network_Pharmacy__c();
      np.Pharmacy_Name__c ='Test Pharmacy';
      insert np;
      
       
      List<Network_Pharmacy_Junction__c> npjList = new List<Network_Pharmacy_Junction__c>();

      Network_Pharmacy_Junction__c npj= new  Network_Pharmacy_Junction__c();
      npj.Custom_Rx_Network_ID__c = crn.Id;
      npj.Network_Pharmacy_ID__c = np.Id;
      npj.Pharmacy_Number__c = 1;
      npjList.add(npj);

      Network_Pharmacy_Junction__c npj1= new  Network_Pharmacy_Junction__c();
      npj1.Custom_Rx_Network_ID__c = crn.Id;
      npj1.Network_Pharmacy_ID__c = np.Id;
      npj1.Pharmacy_Number__c =2;
      npjList.add(npj1);

     
      
      Test.startTest();
      insert npjList;
      
      npjList[0].Pharmacy_Number__c=3;
      npjList[1].Pharmacy_Number__c=4;
      update npjList;
      Test.stopTest();
    }
}