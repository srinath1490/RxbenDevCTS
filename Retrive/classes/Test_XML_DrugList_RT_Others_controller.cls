@isTest
private class Test_XML_DrugList_RT_Others_controller {
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        GMFBuilderUtil.byPassGMFValidation=true; 
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Drug_List__c' AND (DeveloperName LIKE '%Step_Therapy%') AND isActive = true LIMIT 1];
        Drug_List__c dl = new Drug_List__c();
        dl.Description__c = 'test';
        dl.Drug_List_Name__c = 'new drug group';
        dl.RecordTypeId = rt.Id;
        dl.Effective_Date__c=system.today();
        dl.Termination_Date__c=system.today().addDays(3);
        dl.Clinical_Edit_Code__c='4';
        insert dl;
        
        RecordType rt2 = [SELECT id from RecordType WHERE SobjectType = 'Drug_List_Criteria__c' AND (DeveloperName LIKE '%Step_Therapy%') AND isActive = true LIMIT 1];
        Drug_List_Criteria__c dlc = new Drug_List_Criteria__c();
        dlc.Drug_List__c = dl.Id;
        dlc.Drug_Type_Code__c = 'test';
        dlc.Effective__c = system.today();
        dlc.Term__c = system.today() + 3;
        dlc.RecordTypeId = rt2.id;
        insert dlc;     
        
        Step_Therapy_PreRequisite_Drug__c stprd = new Step_Therapy_PreRequisite_Drug__c();
        stprd.Step_Therapy_Pre_Requisite_Drug_Name__c = 'test';
        stprd.Drug_Type_Code__c = 'Third Party Restriction';
        stprd.Drug_Code_Value__c = '125465';
        stprd.Mandatory__c = 'Yes';
        stprd.No_of_Distinct_Drugs__c = 126456;
        stprd.Lookback__c = 5;
        stprd.Lookback_Period__c = 'Days';
        stprd.Effective_Date__c = system.today();
        stprd.Termination_Date__c = system.today()+5;
        stprd.Minimum_Day_Supply__c = 2;
        stprd.Related_Drug_List_Criteria__c = dlc.Id;
        insert stprd;
        
        Step_Therapy_PreRequisite_Drug__c stprd2 = new Step_Therapy_PreRequisite_Drug__c();
        stprd2.Step_Therapy_Pre_Requisite_Drug_Name__c = 'test';
        stprd2.Drug_Type_Code__c = 'Third Party Restriction';
        stprd2.Drug_Code_Value__c = '125465';
        stprd2.Mandatory__c = 'Yes';
        stprd2.No_of_Distinct_Drugs__c = 126456;
        stprd2.Lookback__c = 5;
        stprd2.Lookback_Period__c = 'Days';
        stprd2.Effective_Date__c = system.today();
        stprd2.Termination_Date__c = system.today()+5;
        stprd2.Minimum_Day_Supply__c = 2;
        stprd2.Related_Drug_List_Criteria__c = dlc.Id;
        stprd2.Step_Therapy_Pre_Requisite_Drug_Parent__c = stprd.Id;
        insert stprd2;
        
        RecordType rt3 = [SELECT id from RecordType WHERE SobjectType = 'Forms__c' AND DeveloperName LIKE '%Denial%' AND isActive = true LIMIT 1];
        Forms__c f = new Forms__c(); 
        f.RecordTypeId = rt3.id;
        f.Form_Name__c = 'test';
        f.Form_Description__c = 'test';
        f.Form_Text__c = 'test';
        f.Location_of_Form__c = 'http://www.google.com';
        f.Effective_Date__c=system.today();
        f.Termination_Date__c=system.today().addDays(3);
        insert f;
        
        Denial_Letter_Junction__c dlj = new Denial_Letter_Junction__c();
        dlj.Denial_Letter_ID__c = f.id;
        dlj.Drug_List_Criteria_ID__c = dlc.id;
        insert dlj;
        
        ApexPages.StandardController dlsc = new ApexPages.StandardController(dl);
        GMF_XML_DrugList_RT_Others_controller dlrc = new GMF_XML_DrugList_RT_Others_controller(dlsc);
        dlrc.generateXML();
        
    }

}