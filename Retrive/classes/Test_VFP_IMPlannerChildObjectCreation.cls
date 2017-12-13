@isTest
private class Test_VFP_IMPlannerChildObjectCreation {
	static testMethod void createIMPBP() {

        //test data setup
        Implementation_Planner__c testIMP = testdata1(); //get test record
        insert testIMP; //insert test record
        ApexPages.StandardController sc = new ApexPages.StandardController(testIMP); //create a standardController since the code needs one to create object.

        //constructing 
        VFP_IMPlannerChildObjectCreation imbpObj=new VFP_IMPlannerChildObjectCreation(sc);

        //invoking methods
        PageReference pr=imbpObj.CreateIMPlannerChild();

    }

    //Utility method used to create test record.
    private static Implementation_Planner__c testdata1(){
        Account TestAccount = new Account();
        TestAccount.name = 'Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        Database.insert (TestAccount,false);
        
        Implementation_Planner__c TestIMP = new Implementation_Planner__c();
        TestIMP.Account_Name__c = TestAccount.Id;
		TestIMP.Effective_Date__c = System.Today();
		TestIMP.Custom_Network__c = 'No';
		TestIMP.SMU_Requests_Approval_Required__c = 'Yes';
		TestIMP.SMU_Request_Approval_Details__c = 'test details';
		TestIMP.Implementation_Performance_Guarantee__c= 'Not Applicable';
		TestIMP.Implementation_Type__c = 'New Rx and New Med';
		TestIMP.Integration_with_Accumulators__c = 'No';
		TestIMP.ORFT_Files_Needed__c = 'MOD;Specialty;Prior Auth;Accums';
		TestIMP.Formulary_Disruption_Done__c = 'No';
		TestIMP.Formulary_Type__c = 'Premier Plus';
		TestIMP.Pre_Imp_Audit_Requested__c = 'No';
		TestIMP.Programs_Requiring_Lead_Time__c = 'ECHC (60 days);MC - Mandatory (60 days/90 days 1/1 and 2/1 dates);Pharmacy Advisor (60 days)';
		TestIMP.School_Client_Name__c = 'None';

        return TestIMP; //return the record without inserting.
    }
}