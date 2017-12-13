/*Purpose: Apex Test Class for VFP_CRDStep2Controller Page.                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Abhay                 9/6/2011       Apex Test Class for VFP_CRDStep2Controller Page. 
========================================================================
 */        

@isTest
private class TEST_CRDStep2Controller{
    static testMethod void testPlanInformationStep2(){
        CRD__c testCrd=new CRD__c();
        testCrd.Are_you_creating_a_Package_Plan__c='Yes';
        insert testCrd;     
        
       // Instanciate  Visualforce Page
        PageReference newCrdPlanInformationStep2 = Page.VF_NewCRDPlan_Step2; 
        Test.setCurrentPage(newCrdPlanInformationStep2 ); 
        newCrdPlanInformationStep2.getParameters().put('id',testCrd.id);    
        ApexPages.StandardController s = new ApexPages.standardController(testCrd);
        VFP_CRDStep2Controller  controller = new VFP_CRDStep2Controller(s);
        controller.getHideForBCTC();
        controller.redirectToStep1a();
        controller.redirectToClientInfo();
        delete testCrd;
        controller.redirectToClientInfo();
            
       
    }

}