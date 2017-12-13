/*Purpose: Apex Test Class for VFP_CRDSaveACopayJunctionController
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Richa                 24/02/2015       Apex Test Class for VFP_CRDSaveACopayJunctionController
======================================================================== 
*/
@isTest (SeeAllData=true)
private class TEST_CRDSaveACopayJunctionController {
    
    //@SeeAllData=true
    public static id getRecordType(string objName){
        id recordId;
        recordId = [Select id from RecordType where Name='Save-A-Copay' and SobjectType = :objName][0].id;
        return recordId;
    }
    
    public static id getAccount(){
        id accountId;
        accountId = [Select id from Account LIMIT 1][0].id;
        return accountId;
    }
    
    static testMethod void myUnitTest() {

        Clinical_Program__c cp = new Clinical_Program__c();
        cp.Funding__c = 'Fully Insured';
        cp.Inactive__c = false;
        cp.Available_to_be_Picked__c = true;
        cp.Available_Date__c = system.today()-2;
        cp.RecordTypeId = getRecordType('Clinical_Program__c');
        cp.Account__c = getAccount();
        cp.Description__c = 'test';
        cp.Clinical_Programs_Name__c = 'test';
        insert cp;
        
        Clinical_Program__c cp2 = new Clinical_Program__c();
        cp2.Funding__c = 'Self Insured';
        cp2.Inactive__c = false;
        cp2.Available_to_be_Picked__c = true;
        cp2.Available_Date__c = system.today()-2;
        cp2.RecordTypeId = getRecordType('Clinical_Program__c');
        cp2.Account__c = getAccount();
        cp2.Description__c = 'test';
        cp2.Clinical_Programs_Name__c = 'test';
        insert cp2;
        
        Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
        cpg.Inactive__c = false;
        cpg.Funding__c = 'Any';
        cpg.RecordTypeId = getRecordType('Clinical_Program_Group__c');
        cpg.Clinical_Program_Group_Description__c = 'test';
        cpg.Clinical_Program_Group_Name__c = 'test';
        cpg.Effective_Date__c = system.today()-2;
        cpg.Termination_Date__c = system.today()+2;
        insert cpg;
        
        Clinical_Program_Group__c cpg2 = new Clinical_Program_Group__c();
        cpg2.Inactive__c = false;
        cpg2.Funding__c = 'Self Insured';
        cpg2.RecordTypeId = getRecordType('Clinical_Program_Group__c');
        cpg2.Clinical_Program_Group_Description__c = 'test';
        cpg2.Clinical_Program_Group_Name__c = 'test';
        cpg2.Effective_Date__c = system.today()-2;
        cpg2.Termination_Date__c = system.today()+2;
        insert cpg2;
        
        CRD__c testCRD = new CRD__c();
        testCRD.Insured_Type__c = 'Fully Insured';
        testCRD.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
        testCRD.SAC_Override_Option__c = 'Yes';
        insert testCRD;
        
        Save_A_Copay_Junction__c sacJunc = new Save_A_Copay_Junction__c();
        sacJunc.Save_A_Copay_Drug_Class__c = 'TestDrugClass';
        sacJunc.Selected__c = true;
        sacJunc.CRD_ID__c = testCRD.id;
        insert sacJunc;
        
        /*Clinical_Program_Group_Junction__c cpgj = new Clinical_Program_Group_Junction__c();
        cpgj.CRD_ID__c = testCRD.id;
        cpgj.Record_Type__c = 'Save-A-Copay';
        cpgj.Clinical_Program_Group_Name__c = 'TestCPG';
        cpgj.Selected__c = true;
        insert cpgj;*/
        
        
        PageReference sacPage = Page.VF_CRDSaveACopayJunction;
        sacPage.getParameters().put('crdid',testCRD.id);
        Test.setCurrentPage(sacPage);
        
        ApexPages.StandardController stCon = new ApexPages.standardController(testCRD);
        VFP_CRDSaveACopayJunctionController sacController = new VFP_CRDSaveACopayJunctionController(stCon);
        sacController.crdId = testCRD.id;
        sacController.showfields = true;
        sacController.showCheckBox = true;
        sacController.searchSaveACopay();
        sacController.showDrugClass();
        sacController.redirectToPrograme1();
        sacController.redirectToRxCheck();
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
        testCRD2.SAC_Override_Option__c = 'No';
        insert testCRD2;
        
        Clinical_Program_Group_Junction__c cpgj = new Clinical_Program_Group_Junction__c();
        cpgj.CRD_ID__c = testCRD2.id;
        cpgj.Record_Type__c = 'Save-A-Copay';
        cpgj.Clinical_Program_Group_Name__c = 'TestCPG';
        cpgj.Selected__c = true;
        insert cpgj;
        
        PageReference sacPage2 = Page.VF_CRDSaveACopayJunction;
        sacPage2.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(sacPage2);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_CRDSaveACopayJunctionController sacController2 = new VFP_CRDSaveACopayJunctionController(stCon2);
        sacController2.crdId = testCRD2.id;
        sacController2.showfields = true;
        sacController2.showCheckBox = true;
        sacController2.searchSaveACopay();
        sacController2.showDrugClass();
        sacController2.redirectToPrograme1();
        sacController2.redirectToRxCheck();
        
        /*sacController.isUpdated = true;
        sacController.searchSaveACopay();
        sacController.showDrugClass();*/
        
        CRD__c testCRD3 = new CRD__c();
        testCRD3.Insured_Type__c = 'Fully Insured';
        testCRD3.Do_you_want_to_do_Save_A_Copay__c = 'No';
        testCRD3.SAC_Override_Option__c = '';
        insert testCRD3;
        
        PageReference sacPage3 = Page.VF_CRDSaveACopayJunction;
        sacPage3.getParameters().put('crdid',testCRD3.id);
        Test.setCurrentPage(sacPage3);
        
        ApexPages.StandardController stCon3 = new ApexPages.standardController(testCRD3);
        VFP_CRDSaveACopayJunctionController sacController3 = new VFP_CRDSaveACopayJunctionController(stCon3);
        sacController3.crdId = testCRD3.id;
        sacController3.showfields = false;
        sacController3.showCheckBox = false;
        sacController3.searchSaveACopay();
        sacController3.showDrugClass();
        sacController3.redirectToPrograme1();
        sacController3.redirectToRxCheck();
        
        /*testCRD.Do_you_want_to_do_Save_A_Copay__c = 'No';
        testCRD.SAC_Override_Option__c = '';
        update testCRD;
        
        sacController.searchSaveACopay();
        sacController.showDrugClass();
        
        testCRD.Do_you_want_to_do_Save_A_Copay__c = 'No';
        testCRD.SAC_Override_Option__c = 'No';
        update testCRD;
        
        sacController.searchSaveACopay();
        sacController.showDrugClass();
        
        testCRD.Insured_Type__c = 'Self Insured';
        testCRD.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
        testCRD.SAC_Override_Option__c = 'No';
        update testCRD;
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD);
        VFP_CRDSaveACopayJunctionController sacController2 = new VFP_CRDSaveACopayJunctionController(stCon2);
        sacController2.crdId = testCRD.id;
        sacController2.searchSaveACopay();
        sacController2.showDrugClass();
        
        testCRD.SAC_Override_Option__c = 'Yes';
        update testCRD;

        sacController2.searchSaveACopay();
        sacController2.showDrugClass();
        sacController2.showCheckBox = false;
        sacController.redirectToPrograme1();
        sacController.redirectToRxCheck();*/
        
        CRD__c testCRD4 = new CRD__c();
        testCRD4.Insured_Type__c = 'Self Insured';
        testCRD4.Do_you_want_to_do_Save_A_Copay__c = 'Yes';
        testCRD4.SAC_Override_Option__c = 'No';
        insert testCRD4;
        
        PageReference sacPage4 = Page.VF_CRDSaveACopayJunction;
        sacPage4.getParameters().put('crdid',testCRD4.id);
        Test.setCurrentPage(sacPage4);
        
        ApexPages.StandardController stCon4 = new ApexPages.standardController(testCRD4);
        VFP_CRDSaveACopayJunctionController sacController4 = new VFP_CRDSaveACopayJunctionController(stCon4);
        sacController4.crdId = testCRD4.id;
        sacController3.showfields = true;
        sacController4.showCheckBox = true;
        sacController4.searchSaveACopay();
        sacController4.showDrugClass();
        sacController4.redirectToPrograme1();
        sacController4.redirectToRxCheck();
        sacController4.redirectToPrograme12();
        sacController4.redirectToRxCheck2();
    }
}