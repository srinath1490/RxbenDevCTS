/*Purpose: Apex Test Class for VFP_CRDoralChemoCopay
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Richa                 16/02/2015       Apex Test Class for VFP_CRDoralChemoCopay
======================================================================== 
*/
@isTest 
private class TEST_CRDoralChemoCopay {
    

    static testMethod void myUnitTest() {
           
        CRD__c testCRD = new CRD__c();
        test.startTest();
        insert testCRD;
        test.stopTest();
        
        PageReference oralChemoPage = Page.VF_CRDoralChemoCopay;
        oralChemoPage.getParameters().put('crdid',testCRD.id);
        Test.setCurrentPage(oralChemoPage);
        ApexPages.StandardController stCon = new ApexPages.standardController(testCRD);
        VFP_CRDoralChemoCopay oralChemoController = new VFP_CRDoralChemoCopay(stCon);
        oralChemoController.crdId = testCRD.id;
        oralChemoController.clearFields();
        oralChemoController.crd.Does_Chemo_Parity_Apply__c = true;   
        //System.assertNotEquals(null,oralChemoController.redirectToCRD().getUrl());
        //System.assertNotEquals(null,oralChemoController.redirectToCopay().getUrl());
        oralChemoController.crd.Does_Chemo_Parity_Apply__c = false;
        oralChemoController.crd.Percent__c = 23;
        oralChemoController.redirectToCopay();
        oralChemoController.redirectToCRD();
        oralChemoController.redirectToCopay2();//Added by Raj
        oralChemoController.redirectToCRD2(); //Added by Raj
    }
    //Added by Raj Start
    static testMethod void myUnitTest1()
    {
    
     CRD__c testCRD = new CRD__c();
        test.startTest();
        insert testCRD;
        test.stopTest();
        
        PageReference oralChemoPage = Page.VF_CRDoralChemoCopay;
        oralChemoPage.getParameters().put('crdid',testCRD.id);
        Test.setCurrentPage(oralChemoPage);
        ApexPages.StandardController stCon = new ApexPages.standardController(testCRD);
        VFP_CRDoralChemoCopay oralChemoController = new VFP_CRDoralChemoCopay(stCon);
        oralChemoController.crdId = testCRD.id;
        oralChemoController.clearFields();
        oralChemoController.crd.Does_Chemo_Parity_Apply__c = false;
        oralChemoController.redirectToCopay();
        oralChemoController.redirectToCRD();
        oralChemoController.redirectToCopay2();
        oralChemoController.redirectToCRD2();
    
    }
    //Added by Raj End
    
}