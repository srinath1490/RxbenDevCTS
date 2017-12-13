/*Purpose: Apex Test Class for VFP_CustomerCareAttributesController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/6/2011       Apex Test Class for VFP_CustomerCareAttributesController.
======================================================================== 
*/
@isTest
private class TEST_CustomerCareAttributesController{
    static testMethod void testCustomerCareAttributesController(){
        CRD__c testCrd=new CRD__c(); 
        testcrd.insured_type__c = 'Self Insured';
        testcrd.vacation__c = 'yes';
        testcrd.Participant_Lost_Stolen_Damaged_Meds__c='Yes';
        testcrd.Mail_Order_Delay__c='Yes';
        testcrd.multiple_births__c='Yes';
        testcrd.maximum_dollar__c='Yes';
        testcrd.dose_optimization__c='Yes';
        insert testCrd;
        crd__c testcrd1 = new crd__c();
        testcrd1.insured_type__c ='split funded';
        insert testcrd1;
        PageReference newCustomerCareAttributesController = Page.VF_CRDCustomerCareAttributes_Step1; 
        newCustomerCareAttributesController.getParameters().put('id',testCrd.id);    
        Test.setCurrentPage(newCustomerCareAttributesController);        
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CustomerCareAttributesController  controller = new VFP_CustomerCareAttributesController(s);
        controller.editMode = 'BCTME';
       controller.redirectToCopay();
       controller.previous();
        controller.showpanel();
        controller.redirectToCopay2();
        controller.previous2();
       
       delete testCrd;
        delete testcrd1;
       controller.uploadCustomerCare();
       controller.uploadNewGreeting();
       Attachment aa=new Attachment();
       controller.upload(aa,'test');
       controller.redirectToCopay();
       controller.previous();
        
    }
    static testMethod void testCustomerCareAttributesController1(){
        CRD__c testcrd2=new CRD__c(); 
        testcrd2.insured_type__c = 'Split Funded';
        testcrd2.vacation__c = 'yes';
        testcrd2.Participant_Lost_Stolen_Damaged_Meds__c='Yes';
        testcrd2.Mail_Order_Delay__c='Yes';
        testcrd2.multiple_births__c='Yes';
        testcrd2.maximum_dollar__c='Yes';
        testcrd2.dose_optimization__c='Yes';
        testcrd2.pos_rebate_for_plan__c='Yes';
        insert testcrd2;
        PageReference newCustomerCareAttributesController = Page.VF_CRDCustomerCareAttributes_Step1; 
        newCustomerCareAttributesController.getParameters().put('id',testcrd2.id);    
        Test.setCurrentPage(newCustomerCareAttributesController);        
        ApexPages.StandardController s = new ApexPages.standardController(testcrd2);
        VFP_CustomerCareAttributesController  controller = new VFP_CustomerCareAttributesController(s);
       controller.redirectToCopay();
       controller.previous();
       
       delete testcrd2;
       controller.uploadCustomerCare();
       controller.uploadNewGreeting();
       Attachment aa=new Attachment();
       controller.upload(aa,'test');
       controller.redirectToCopay();
       controller.previous();
        controller.showpanel();
        

    }
}