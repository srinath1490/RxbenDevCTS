/*Purpose: Apex Test Class to test CAG Restructure
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            18Aug 2014       Apex Test class to test CAG Restructure
======================================================================== */
@isTest
private class TEST_CB_CAGRestructure{
	
    
 static testMethod void TEST_CB_CAGRestructure(){
    string csapCRD2FCG;
    String csapCRD2PCG;
    String csapFCGtoPCG;
    for(RecordType rtName : [Select Id,Name from RecordType where SobjectType = 'CSAP_CGLP_Junction__c']){
            if(rtName.Name == 'CRD to Full CG'){
                csapCRD2FCG = rtName.Id;
            }else if (rtName.Name == 'CRD to Partial CG'){
                csapCRD2PCG = rtName.Id;
            }else if (rtName.Name == 'Full CG to Partial CG'){
                csapFCGtoPCG = rtName.Id;
            }
    } 
    Account newAccount = new Account();
     	newAccount.Name = 'Test Account';
     	newAccount.APM_PSUID__c = '84745151';
     	insert newAccount;
   Account newAccount1 = new Account();
     	newAccount1.Name = 'Test Account';
     	newAccount1.APM_PSUID__c = '84745152';
     	insert newAccount1;  
    CRD__c newCRD = new CRD__c();
     	newCRD.Plan_Type_Mail__c = true;
     	newCRD.RxPlanId__c ='1111111111';
     	newCRD.Control__c ='866382';
     	newCRD.Plan__c='UQ';
     	newCRD.Effective_Date__c = System.today();
     	newCRD.Account__c = newAccount.id;
     	insert newCRD;
    CRD__c newCRD1 = new CRD__c();
     	newCRD1.Plan_Type_Mail__c = true;
     	newCRD1.RxPlanId__c ='2222222222';
     	newCRD1.Control__c ='434343';
     	newCRD1.Plan__c='UQ';
     	newCRD1.Effective_Date__c = System.today();
     	newCRD1.Account__c = newAccount.id;
     	insert newCRD1; 
 	CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
 		newCrdBuilder.valid__c = true;
 		newCrdBuilder.Build__c = true;
 		newCrdBuilder.Complete__c = true;
 		newCrdBuilder.PERS__c = true;
     	newCrdBuilder.CRD__c = newCRD.id;
 		insert newCrdBuilder;
    CRDBuildOrder__c newCrdBuilder1 = new CRDBuildOrder__c();
 		newCrdBuilder1.valid__c = true;
 		newCrdBuilder1.Build__c = true;
 		newCrdBuilder1.Complete__c = true;
 		newCrdBuilder1.PERS__c = true;
     	newCrdBuilder1.CRD__c = newCRD1.id;
 		insert newCrdBuilder1;
    CVSRxPlanId__c newCVS = new CVSRxPlanId__c();
     	newCVS.RxPlanId__c = '1111111111';
     	insert newCVS;
    //Create PCG,FCg and CSAP records to match the CPE 
    Partial_Control_Group__c newPCG = new Partial_Control_Group__c();
     	newPCG.Account__c = newAccount.id;
        newPCG.CSAP_Control_ID__c = '0866382';
        newPCG.CSAP_Plan_ID__c = 'UQ';
     	insert newPCG;
    Full_Control_Group__c newFCG = new Full_Control_Group__c();
     	newFCG.Account_Name__c = newAccount.id;
        newFCG.CSAP_Control_ID__c = '0866382';
        newFCG.CSAP_Plan_ID__c = 'UQ';
     	insert newFCG;
     	
    CRD__c newCRD2 = new CRD__c();
     	newCRD2.Plan_Type_Mail__c = true;
     	newCRD2.Effective_Date__c = System.today();
     	newCRD2.Account__c = newAccount.id;
     	insert newCRD2;
    CRD__c newCRD3 = new CRD__c();
     	newCRD3.Plan_Type_Mail__c = true;
     	newCRD3.Effective_Date__c = System.today().adddays(-2);
     	newCRD3.Account__c = newAccount.id;
     	insert newCRD3;
    CSAP_CGLP_Junction__c newCSAP = new CSAP_CGLP_Junction__c();
     	newCSAP.RecordTypeId = csapCRD2FCG;
     	newCSAP.Full_Control_Group__c = newFCG.id;
     	newCSAP.Partial_Control_Group__c = newPCG.id;
        newCSAP.CRD__c = newCRD2.id;
        insert newCSAP;     
    CSAP_CGLP_Junction__c newCSAP1 = new CSAP_CGLP_Junction__c();
     	newCSAP1.RecordTypeId = csapCRD2PCG;
     	newCSAP1.CRD__c = newCRD2.id;
     	newCSAP1.Partial_Control_Group__c = newPCG.id;
        insert newCSAP1; 
    CSAP_CGLP_Junction__c newCSAP2 = new CSAP_CGLP_Junction__c();
     	newCSAP2.RecordTypeId = csapCRD2PCG;
     	newCSAP2.CRD__c = newCRD3.id;
     	newCSAP2.Partial_Control_Group__c = newPCG.id;
        insert newCSAP2;
    CSAP_CGLP_Junction__c newCSAP3 = new CSAP_CGLP_Junction__c();
     	newCSAP3.RecordTypeId = csapFCGtoPCG;
     	newCSAP3.Partial_Control_Group__c = newPCG.id;
     	newCSAP3.Full_Control_Group__c = newFCG.id;
        insert newCSAP3; 
    	newFCG.Account_Name__c = newAccount1.id;
        update newFCG; 
 	Test.StartTest();
    	BAC_CB_CAGRestructure cagRestructureBatch = new BAC_CB_CAGRestructure();
    	ID batchprocessid = Database.executeBatch(cagRestructureBatch);
    Test.StopTest();
 }
}