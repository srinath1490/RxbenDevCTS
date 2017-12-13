/*Purpose: Apex Test Class for VFP_CRDRxCheckJunctionController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/28/2011       Apex Test Class for VFP_CRDRxCheckJunctionController.
======================================================================== 
*/
@isTest
Private class TEST_CRDRxCheckJunctionController{             
    static testmethod void testRxCheckJunction(){        
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
           Clinical_Program__c testPrograme =testdata.createClinicalPrograme('RxCheck');
              testPrograme.Available_to_be_Picked__c = true;
              testPrograme.Available_Date__c = system.today()-7;
              testPrograme.RxCheck_Termination_Date__c =system.today()+7;
           insert  testPrograme;
           Clinical_Program_Group__c testgroup = testdata.creteProgrameGroup('RxCheck','Self Insured');
           insert testgroup;
           Clinical_Program_Group__c testgroup1 = testdata.creteProgrameGroup('RxCheck','Fully Insured');
           insert testgroup1;
           CRD__c testCrd = new CRD__c();
           insert testCrd ;
           
          // Instanciate  Drug search Page        
          PageReference RxCheckJunction = Page.VF_CRDRxCheckJunction;        
            Test.setCurrentPage(RxCheckJunction); 
            RxCheckJunction.getParameters().put('crdid',testCrd.id);
          
          ApexPages.StandardController s = new ApexPages.standardController(testCrd);
          VFP_CRDRxCheckJunctionController controller = new VFP_CRDRxCheckJunctionController(s);       
              controller.redirectToProgram();
              controller.redirectToPOSRebate();
              controller.searchRxCheck();
              controller.redirectToProgram();
              controller.redirectToPOSRebate();
              controller.redirectToProgram2();
              controller.redirectToPOSRebate2();
              controller.searchRxCheck();
  //            controller.searchRxCheck();
  
          testCrd.Rx_Will_you_be_Picking_Drug_Classes__c='yes';
              testCrd.Rx_Override_Option__c ='Yes';
          update testCrd;
          
          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
              controller.searchRxCheck();
          
          delete testCrd;
          
          testCrd=new CRD__c();
             testCrd.Rx_Will_you_be_Picking_Drug_Classes__c ='No';
          insert testCrd;
                   
          RxCheckJunction.getParameters().put('crdid',testCrd.id);                              

          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.searchRxCheck();
          controller.displayField();  
          delete testCrd;
             testCrd=new CRD__c();
             testCrd.Rx_Override_Option__c ='No';

           testCrd.Enroll_in_RxCheck__c ='Yes';
            testCrd.Insured_Type__c ='Self Insured';
          insert testCrd;
           RxCheckJunction.getParameters().put('crdid',testCrd.id);  
          system.debug('****'+testCrd);
          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.displayField();  

          
          
    }
    static testmethod void testRxCheckJunction1(){  
           CRD__c   testCrd=new CRD__c();
             testCrd.Rx_Override_Option__c ='No';
          insert testCrd;
          
          system.debug(testCrd.id);
          PageReference RxCheckJunction = Page.VF_CRDRxCheckJunction; 
            Test.setCurrentPage(RxCheckJunction); 
          RxCheckJunction.getParameters().put('crdid',testCrd.id);     
          ApexPages.StandardController s = new ApexPages.standardController(testCrd);                         
         VFP_CRDRxCheckJunctionController  controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.searchRxCheck();
          

          
            testCrd.Enroll_in_RxCheck__c ='Yes';
            testCrd.Insured_Type__c='Insured';
          update testCrd;
          
          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.redirectToProgram();
            controller.displayField();
          
            testCrd.Enroll_in_RxCheck__c='No';
            testCrd.Insured_Type__c='Insured';
          update testCrd;
          
          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.redirectToProgram();
            controller.displayField();
          
          testCrd=new CRD__c();
            testCrd.Enroll_in_RxCheck__c='No';
          insert testCrd;
          
          s = new ApexPages.standardController(testCrd);
          controller = new  VFP_CRDRxCheckJunctionController(s);
            controller.redirectToProgram();
            controller.displayField();
            }
}