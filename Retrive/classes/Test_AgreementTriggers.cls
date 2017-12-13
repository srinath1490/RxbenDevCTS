@isTest
private class Test_AgreementTriggers {

    /*static testMethod void Test_NDASigned() {
    	
    	Pharmacy_Network_Request_Invitation__c TestI = new Pharmacy_Network_Request_Invitation__c();
		TestI.Name_of_Pharmacy__c = 'Test Pharmacy';
		TestI.NCPDP__c = '1234567';
		testI.Send_NDA__c=true;
		testI.Stage__c='NDA Pending';
		insert TestI;
		
		test.startTest();
		echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
		TestA.Pharmacy_Network_Request_Invitation__c = TestI.Id;
		TestA.Contract_Type__c = 'NDA';
		TestA.echosign_dev1__Status__c = 'Out for Signature';
		insert TestA;
		
		TestA.echosign_dev1__Status__c = 'Signed';
		update TestA;
		test.stopTest();

    }*/
    
    /*static testMethod void Test_NDADeclined() {
    	
    	Pharmacy_Network_Request_Invitation__c TestI = new Pharmacy_Network_Request_Invitation__c();
		TestI.Name_of_Pharmacy__c = 'Test Pharmacy';
		TestI.NCPDP__c = '1234567';
		testI.Send_NDA__c=true;
		testI.Stage__c='NDA Pending';
		insert TestI;
		
		test.startTest();
		echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
		TestA.Pharmacy_Network_Request_Invitation__c = TestI.Id;
		TestA.Contract_Type__c = 'NDA';
		TestA.echosign_dev1__Status__c = 'Out for Signature';
		insert TestA;
		
		TestA.echosign_dev1__Status__c = 'Cancelled / Declined';
		update TestA;
		test.stopTest();

    }*/
    
    static testMethod void Test_InviteContractSigned() {
      
      Pharmacy_Network_Request_Invitation__c TestI = new Pharmacy_Network_Request_Invitation__c();
    TestI.Name_of_Pharmacy__c = 'Test Pharmacy';
    TestI.NCPDP__c = '1234567';
    testI.Send_Contract__c=true;
    testI.Stage__c='Contract Pending';
    insert TestI;
    
    test.startTest();
    echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
    TestA.Pharmacy_Network_Request_Invitation__c = TestI.Id;
    TestA.Contract_Type__c = 'Network Contract';
    TestA.echosign_dev1__Status__c = 'Out for Signature';
    insert TestA;
    
    TestA.echosign_dev1__Status__c = 'Signed';
    update TestA;
    test.stopTest();

    }
    
    static testMethod void Test_InviteContractDeclined() {
      
      Pharmacy_Network_Request_Invitation__c TestI = new Pharmacy_Network_Request_Invitation__c();
    TestI.Name_of_Pharmacy__c = 'Test Pharmacy';
    TestI.NCPDP__c = '1234567';
    testI.Send_NDA__c=true;
    testI.Stage__c='Contract Pending';
    insert TestI;
    
    test.startTest();
    echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
    TestA.Pharmacy_Network_Request_Invitation__c = TestI.Id;
    TestA.Contract_Type__c = 'Network Contract';
    TestA.echosign_dev1__Status__c = 'Out for Signature';
    insert TestA;
    
    TestA.echosign_dev1__Status__c = 'Cancelled / Declined';
    update TestA;
    test.stopTest();

    }
    
    static testMethod void Test_InviteContractExpired() {
      
      Pharmacy_Network_Request_Invitation__c TestI = new Pharmacy_Network_Request_Invitation__c();
    TestI.Name_of_Pharmacy__c = 'Test Pharmacy';
    TestI.NCPDP__c = '1234567';
    testI.Send_NDA__c=true;
    testI.Stage__c='Contract Pending';
    insert TestI;
    
    test.startTest();
    echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
    TestA.Pharmacy_Network_Request_Invitation__c = TestI.Id;
    TestA.Contract_Type__c = 'Network Contract';
    TestA.echosign_dev1__Status__c = 'Out for Signature';
    insert TestA;
    
    TestA.echosign_dev1__Status__c = 'Expired';
    update TestA;
    test.stopTest();

    }
    
    static testMethod void Test_ContractSigned() {
    	
    	NCPDP_Pharmacy_Database__c NCPDP1 = new NCPDP_Pharmacy_Database__c();
    	NCPDP1.Name = '1111111';
    	NCPDP1.Unique_Key__c = '1111111';
    	NCPDP1.CVS_Action__c = 'Actionable';
    	NCPDP1.Name_of_Pharmacy__c = 'Test Pharm';
    	NCPDP1.Contracting_Status__c = 'In Progress';
    	insert NCPDP1;
    	
    	Pharmacy_Network_Request__c TestI = new Pharmacy_Network_Request__c();
    	TestI.NCPDP_Pharmacy_Database__c = NCPDP1.Id;
    	RecordType rt= [Select Id,Name from RecordType where DeveloperName='Inbound_CVS' LIMIT 1];
        TestI.RecordTypeId = rt.Id;
		TestI.Stage__c='PDA Pending';
		TestI.Contact_Email_Address__c = 'allenr4@aetna.com';
		TestI.Contact_Name__c = 'Becca Allen';
		insert TestI;
		
		echosign_dev1__SIGN_Agreement__c TestA = new echosign_dev1__SIGN_Agreement__c();
		TestA.Pharmacy_Network_Request__c = TestI.Id;
		TestA.Contract_Type__c = 'Network Contract';
		TestA.echosign_dev1__Status__c = 'Out for Signature';
		insert TestA;
		
		test.startTest();
		TestA.echosign_dev1__Status__c = 'Signed';
		update TestA;
		test.stopTest();

    }
    
    static testMethod void Test_ContractDeclined() {
    	
    	NCPDP_Pharmacy_Database__c NCPDP2 = new NCPDP_Pharmacy_Database__c();
    	NCPDP2.Name = '2222222';
    	NCPDP2.Unique_Key__c = '2222222';
    	NCPDP2.CVS_Action__c = 'Actionable';
    	NCPDP2.Name_of_Pharmacy__c = 'Test Pharm 2';
    	NCPDP2.Contracting_Status__c = 'In Progress';
    	insert NCPDP2;
    	
    	Pharmacy_Network_Request__c TestD = new Pharmacy_Network_Request__c();
    	TestD.NCPDP_Pharmacy_Database__c = NCPDP2.Id;
    	RecordType rt= [Select Id,Name from RecordType where DeveloperName='Inbound_CVS' LIMIT 1];
        TestD.RecordTypeId = rt.Id;
		testD.Stage__c='PDA Pending';
		TestD.Contact_Email_Address__c = 'allenr4@aetna.com';
		TestD.Contact_Name__c = 'Becca Allen';
		insert TestD;
		
		test.startTest();
		echosign_dev1__SIGN_Agreement__c TestB = new echosign_dev1__SIGN_Agreement__c();
		TestB.Pharmacy_Network_Request__c = TestD.Id;
		TestB.Contract_Type__c = 'Network Contract';
		TestB.echosign_dev1__Status__c = 'Out for Signature';
		insert TestB;
		
		TestB.echosign_dev1__Status__c = 'Cancelled / Declined';
		update TestB;
		test.stopTest();

    }
    
    static testMethod void Test_ContractExpired() {
    	
    	NCPDP_Pharmacy_Database__c NCPDP3 = new NCPDP_Pharmacy_Database__c();
    	NCPDP3.Name = '3333333';
    	NCPDP3.Unique_Key__c = '3333333';
    	NCPDP3.CVS_Action__c = 'Actionable';
    	NCPDP3.Name_of_Pharmacy__c = 'Test Pharm 3';
    	NCPDP3.Contracting_Status__c = 'In Progress';
    	insert NCPDP3;
    	
    	Pharmacy_Network_Request__c TestE = new Pharmacy_Network_Request__c();
    	TestE.NCPDP_Pharmacy_Database__c = NCPDP3.Id;
    	RecordType rt= [Select Id,Name from RecordType where DeveloperName='Inbound_CVS' LIMIT 1];
        TestE.RecordTypeId = rt.Id;
		testE.Stage__c='PDA Pending';
		TestE.Contact_Email_Address__c = 'allenr4@aetna.com';
		TestE.Contact_Name__c = 'Becca Allen';
		insert TestE;
		
		test.startTest();
		echosign_dev1__SIGN_Agreement__c TestC = new echosign_dev1__SIGN_Agreement__c();
		TestC.Pharmacy_Network_Request__c = TestE.Id;
		TestC.Contract_Type__c = 'Network Contract';
		TestC.echosign_dev1__Status__c = 'Out for Signature';
		insert TestC;
		
		TestC.echosign_dev1__Status__c = 'Expired';
		update TestC;
		test.stopTest();

    }
    
}