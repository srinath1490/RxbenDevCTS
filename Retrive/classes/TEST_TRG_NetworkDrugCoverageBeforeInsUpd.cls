/*
Purpose: Test Class for testing TRG_NetworkDrugCoverageBeforeInsertUpdate
===============================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL
-------------------------------------------------------------------------------
1.0         rakesh          06/21/2013          TRG_NetworkDrugCoverageBeforeInsertUpdate coverage.
===============================================================================
*/

@isTest
public class TEST_TRG_NetworkDrugCoverageBeforeInsUpd {
    
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
      
      List<Network_Drug_Coverage__c> ndcList = new List<Network_Drug_Coverage__c>();

      Network_Drug_Coverage__c ndcMail = new Network_Drug_Coverage__c();
      ndcMail.RecordTypeId = recordTypeMap.get('Mail');
      ndcMail.Override_Standard_Refill_too_Soon__c = 'No';
      ndcMail.Custom_Rx_Network_ID__c = crn.Id;
      ndcList.add(ndcMail);

      Network_Drug_Coverage__c ndcRetail = new Network_Drug_Coverage__c();
      ndcRetail.RecordTypeId = recordTypeMap.get('Retail');
      ndcRetail.Override_Standard_Refill_too_Soon__c = 'No';
      ndcRetail.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List';
      ndcRetail.Do_you_have_Specialty__c = 'Yes';
      ndcRetail.Custom_Rx_Network_ID__c = crn.Id;
      ndcList.add(ndcRetail);

      Network_Drug_Coverage__c ndc3 = new Network_Drug_Coverage__c();
      ndc3.RecordTypeId = recordTypeMap.get('Retail');
      ndc3.Override_Standard_Refill_too_Soon__c = 'No';
      ndc3.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List w/ Fertility';
      ndc3.Do_you_have_Specialty__c = 'Yes';
      ndc3.Custom_Rx_Network_ID__c = crn.Id;
      ndcList.add(ndc3);

      Network_Drug_Coverage__c ndc4 = new Network_Drug_Coverage__c();
      ndc4.RecordTypeId = recordTypeMap.get('Retail');
      ndc4.Override_Standard_Refill_too_Soon__c = 'No';
      ndc4.Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only';
      ndc4.Do_you_have_Specialty__c = 'Yes';
      ndc4.Custom_Rx_Network_ID__c = crn.Id;
      ndcList.add(ndc4);
      
      Network_Drug_Coverage__c ndc5 = new Network_Drug_Coverage__c();
      ndc5.RecordTypeId = recordTypeMap.get('Retail');
      ndc5.Override_Standard_Refill_too_Soon__c = 'No';
      ndc5.Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only w/Fertility';
      ndc5.Do_you_have_Specialty__c = 'Yes';
      ndc5.Custom_Rx_Network_ID__c = crn.Id;
      ndcList.add(ndc5);
      
      Test.startTest();
      insert ndcList;
      update ndcList;
      Test.stopTest();
    }
}