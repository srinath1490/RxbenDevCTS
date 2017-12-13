@isTest
private class Test_XML_DrugList_RT_DrugList_controller {
	/** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        GMFBuilderUtil.byPassGMFValidation=true; 
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Drug_List_Criteria__c' AND DeveloperName like '%Drug_List%' LIMIT 1];
        Drug_List__c dl = new Drug_List__c();
        dl.Description__c = 'test';
        dl.Drug_List_Name__c = 'new drug group';
        dl.Effective_Date__c=system.today();
        dl.Termination_Date__c=system.today().addDays(3);
        insert dl;
        
        Drug_List_Criteria__c dlc = new Drug_List_Criteria__c();
        dlc.RecordTypeId = rt.Id;
        dlc.Drug_List__c = dl.Id;
        dlc.Drug_Type_Code__c = 'test';
        dlc.Effective__c = system.today();
        dlc.Term__c = system.today() + 3;
        insert dlc;    
        
        Denial_Letter_Junction__c DLJ=new Denial_Letter_Junction__c();
        DLJ.Drug_List_Criteria_ID__c=dlc.Id;
         
        insert DLJ;
        
        ApexPages.StandardController dlsc = new ApexPages.StandardController(dl);
        GMF_XML_DrugList_RT_DrugList_controller drc = new GMF_XML_DrugList_RT_DrugList_controller(dlsc);
        drc.generateXML();
    }
}