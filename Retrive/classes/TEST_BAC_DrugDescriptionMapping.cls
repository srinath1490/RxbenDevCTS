@isTest (seeAllData = true)
private class TEST_BAC_DrugDescriptionMapping {
    static testMethod void myUnitTest() {
        
        /*Drug_List_Criteria__c[] dlcList = 
               [SELECT Id, Name, Drug_Type_Code__c, Drug_Code_Value__c, NDC__c,
                       Drug_List_Criteria_Description__c, Description_of_NDC_Drug_List_Criteria__c
                FROM Drug_List_Criteria__c
                WHERE Drug_List_Criteria_Description__c = null
                ORDER BY Id DESC
                LIMIT 10];
        
        Set<Id> dlcIdSet = new Set<Id>();
        for (Drug_List_Criteria__c dlc : dlcList)
            dlcIdSet.add(dlc.Id);
        
        Test.startTest();
        
        BAC_DrugDescriptionMapping ddMapping = new BAC_DrugDescriptionMapping ();
        ddMapping.Query = 'SELECT Id, Name, Drug_Type_Code__c, Drug_Code_Value__c, NDC__c, ' +
                          '       Drug_List_Criteria_Description__c, Description_of_NDC_Drug_List_Criteria__c ' +
                          'FROM Drug_List_Criteria__c ' +
                          'WHERE Drug_List_Criteria_Description__c = null ' +
                          'ORDER BY Id DESC ' +
                          'LIMIT 10';
        
        ID batchprocessid = Database.executeBatch(ddMapping);
        Test.StopTest();
        
        dlcList = [SELECT Id FROM Drug_List_Criteria__c WHERE Id IN :dlcIdSet AND Drug_List_Criteria_Description__c = null LIMIT 10];
        
       // System.assertEquals(dlcList.size(), 10);*/
    }
}