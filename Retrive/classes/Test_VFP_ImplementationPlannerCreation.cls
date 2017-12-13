@isTest
private class Test_VFP_ImplementationPlannerCreation {
	static testMethod void createIMPlanner1() {

        //test data setup
        Sold_Case_Worksheet__c testSCW = testdata1(); //get test record
        insert testSCW; //insert test record
        ApexPages.StandardController sc = new ApexPages.StandardController(testSCW); //create a standardController since the code needs one to create object.

        //constructing 
        VFP_ImplementationPlannerCreation impObj=new VFP_ImplementationPlannerCreation(sc);

        //invoking methods
        PageReference pr=impObj.CreateImplementationPlanner();

    }

    //Utility method used to create test record.
    private static Sold_Case_Worksheet__c testdata1(){
        Account TestAccount = new Account();
        TestAccount.name = 'Test Account';
        TestAccount.APM_PSUID__c = '11223344';
        Database.insert (TestAccount,false);
        
        Sold_Case_Worksheet__c TestCase = new Sold_Case_Worksheet__c();
        TestCase.Account__c = TestAccount.Id;
		TestCase.Effective_Date__c = System.Today();
		TestCase.Segment__c= 'National';
		TestCase.Region__c = 'Northeast';
		//TestCase.Membership__c = '1200';
		TestCase.Product__c = 'PPO';
		TestCase.Prior_Carrier__c = 'BCBS';
		TestCase.Consultant_Name__c = 'Test Consultant';
		TestCase.Funding__c = 'Self Insured';
		TestCase.Population_Demographics__c = 'Active';
		TestCase.Existing_Aetna_Benefits_in_Place__c = 'None';
		TestCase.Custom_TFN__c = 'No';
		//TestCase.Custom_Network_Type__c = 
		//TestCase.Custom_Network_Pricing__c = 
		TestCase.SMU_Requests_Approval_Required__c = 'Yes';
		TestCase.SMU_Request_Approval_Details__c = 'test details';
		TestCase.Implementation_Performance_Guarantee__c= 'Not Applicable';
		TestCase.PG_Description__c = 'description';
		TestCase.Implementation_Type__c = 'New Rx and New Med';
		TestCase.Integration_with_Accumulators__c = 'No';
		TestCase.Special_Files_Needed__c = 'MOD;Specialty;Prior Auth;Accums';
		TestCase.Formulary_Disruption_Done__c = 'No';
		TestCase.Formulary_Type__c = 'Premier Plus';
		TestCase.Client_Nuances_Unique_Benefit_Needs__c = 'lots of stuff';
		//TestCase.Rx_AM_Name__c = 
		//TestCase.VPCM_Name__c = 
		//TestCase.SAE_Name__c = 
		TestCase.Aetna_Medical_Contact__c= 'Bob Jones';
		//TestCase.Clinical_Account_Executive__c=
		TestCase.Programs_Sold_Requiring_Lead_Time__c = 'MC - Voluntary;Pharmacy Advisor;ECHC';
		TestCase.School_Client_Name__c = 'None';

        return TestCase; //return the record without inserting.
    }
}