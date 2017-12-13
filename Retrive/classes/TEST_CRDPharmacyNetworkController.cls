/*Purpose: Apex Test Class for VFP_CRDPharmacyNetworkController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/26/2011       Apex Test Class for VFP_CRDPharmacyNetworkController.
======================================================================== 
*/
@isTest
private class TEST_CRDPharmacyNetworkController 
{

 static testmethod void Test_CRDPharmacyNetworkController()
 {
         CRD__c testCrd=new CRD__c();
         testCrd.LastSent__c = system.now();
         testcrd.standard_or_custom_plan__c = 'Creating a packaged consumer business plan';
         testcrd.Insured_Type__c = 'Split Funded';
         testcrd.Plan_Type_Mail__c = true;
         testcrd.Plan_Type_Retail__c = true;
         testcrd.Plan_Type_Specialty__c = true;
         insert testCrd;
         
         Custom_Rx_Network__c customtestrec=new Custom_Rx_Network__c();
         customtestrec.Summary_of_Request_Intent__c='test';
         customtestrec.Control_Group_Number__c = 'test';
         customtestrec.Self_Insured__c = True;
         customtestrec.Fully_Insured__c = True;
         customtestrec.Split_Funded__c = True;
         customtestrec.Does_spread_pricing_apply__c='Yes';
         insert customtestrec; 
           
         Network_Junction__c testrec=new Network_Junction__c();
         testrec.Network_Mail__c='test';
         testrec.Network_Retail__c = 'Custom';
        testrec.Does_client_have_suppression__c = 'no';   
        testrec.Retail_Custom__c = customtestrec.id;               
         insert testrec; 
         
         

         testrec.Network_Specialty__c=null;
         testrec.CRD_ID__c=testCrd.Id;
         testrec.Network_Retail__c = 'Aetna Rx value Network';
         update testrec;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDPharmacyNetwork')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDPharmacyNetworkController controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
         controller.speciality='No';
         controller.redirectToClinicalProgStep2();
         controller.showPanel();
         controller.redirectToPrograms();
         controller.clearField();
         
         testrec.Network_Specialty__c='Open';
         testrec.Enroll_in_Medvantix__c='Yes';
         update testrec;
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
        
         testrec.CRD_ID__c=null;
         update testrec;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
         controller.redirectToClinicalProgStep2();
         controller.redirectToPrograms();
               
 }
 
 static testMethod void Test_CRDPharmacyNetworkController1(){
       CRD__c testCrd=new CRD__c();
         testCrd.LastSent__c = system.now();
         insert testCrd;
         
         Custom_Rx_Network__c customtestrec = new Custom_Rx_Network__c();
         customtestrec.Summary_of_Request_Intent__c='test';
         customtestrec.Control_Group_Number__c = 'test';
         customtestrec.Self_Insured__c = True;
         customtestrec.Fully_Insured__c = True;
         customtestrec.Split_Funded__c = True;
         customtestrec.Does_spread_pricing_apply__c='Yes';
         insert customtestrec; 
         
         Network_Junction__c testrec=new Network_Junction__c();
         testrec.Network_Retail__c='test';
         testrec.Mail_Custom__c=customtestrec.id;
         testrec.Network_Specialty__c = 'test';
         testrec.Network_Mail__c='Custom' ;
         testrec.CRD_ID__c= testCrd.id;
         testrec.Enroll_in_Medvantix__c ='Yes';
         testrec.Medvantix_Copay_Percent__c =12;
         testrec.Medvantix_Copay_Dollar_Amount__c =25;        
         insert testrec; 
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDPharmacyNetwork')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDPharmacyNetworkController controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
        
        controller.crd.Plan_Type_Mail__c=true;
        controller.redirectToPrograms(); 
        controller.redirectToClinicalProgStep2();   
        controller.redirectToPrograms2();    

       controller.crd.Plan_Type_Retail__c=true;
        controller.redirectToPrograms(); 
        testrec.Retail_Custom__c=customtestrec.id;
       testrec.Network_Retail__c='Custom' ;
        update testrec;
        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.crd.Plan_Type_Specialty__c=true;
        controller.redirectToPrograms();
       testrec.Specialty_Custom__c=customtestrec.id;
       testrec.Network_Specialty__c='Custom'; 
       testrec.Medvantix_Copay_Dollar_Amount__c =null;
       testrec.Medvantix_Copay_Min_Dollar__c =42;
       testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToPrograms();
        testrec.Medvantix_Copay_Min_Dollar__c =2;
        testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToClinicalProgStep2();
        testrec.Network_Specialty__c ='Prefferd';
        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.redirectToClinicalProgStep22();
                delete testCrd;
 }
 static testmethod void Test_CRDPharmacyNetworkController3()
 {
         CRD__c testcrd=new CRD__c();
         testcrd.LastSent__c = system.now();
         testcrd.standard_or_custom_plan__c = 'Creating a packaged consumer business plan';
         testcrd.Insured_Type__c = 'Split Funded';
         testcrd.Plan_Type_Mail__c = true;
         testcrd.Plan_Type_Retail__c = true;
         testcrd.Plan_Type_Specialty__c = true;
         testcrd.Sub_Segment__c = 'SGI';
         testcrd.Which_system_will_the_plan_be_installed__c = 'HMO';
         testcrd.Override_Retail_Y_Schedule__c = 'No';
         insert testCrd;
         Custom_Rx_Network__c customtestrec=new Custom_Rx_Network__c();
         customtestrec.Summary_of_Request_Intent__c='test';
         customtestrec.Control_Group_Number__c = 'test';
         customtestrec.Self_Insured__c = True;
         customtestrec.Fully_Insured__c = True;
         customtestrec.Split_Funded__c = True;
         customtestrec.Does_spread_pricing_apply__c='Yes';
         insert customtestrec;
        Network_Junction__c testrec=new Network_Junction__c();
         testrec.Network_Retail__c='test';
         testrec.Mail_Custom__c=customtestrec.id;
         testrec.Network_Specialty__c = 'test';
         testrec.Network_Mail__c='Custom' ;
         testrec.CRD_ID__c= testcrd.id;
         testrec.Enroll_in_Medvantix__c ='Yes';
         testrec.Medvantix_Copay_Percent__c =12;
         testrec.Medvantix_Copay_Dollar_Amount__c =25;        
         insert testrec; 
        Pricing_Network__c pnc = new Pricing_Network__c();
            pnc.Network_Name__c = 'test';
            pnc.Medical_Platform__c = 'HMO';
            pnc.Sub_Segment__c = 'SGI';
            pnc.Y_Schedule__c = 'Ysc';
            insert pnc;
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDPharmacyNetwork')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDPharmacyNetworkController controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
        
        controller.crd.Plan_Type_Mail__c=true;
        controller.redirectToPrograms(); 
        controller.redirectToClinicalProgStep2();   
        controller.redirectToPrograms2();    

       controller.crd.Plan_Type_Retail__c=true;
        controller.redirectToPrograms(); 
        testrec.Retail_Custom__c=customtestrec.id;
       testrec.Network_Retail__c='Custom' ;
        update testrec;
        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.crd.Plan_Type_Specialty__c=true;
        controller.redirectToPrograms();
       testrec.Specialty_Custom__c=customtestrec.id;
       testrec.Network_Specialty__c='Custom'; 
       testrec.Medvantix_Copay_Dollar_Amount__c =null;
       testrec.Medvantix_Copay_Min_Dollar__c =42;
       testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToPrograms();
        testrec.Medvantix_Copay_Min_Dollar__c =2;
        testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToClinicalProgStep2();
        testrec.Network_Specialty__c ='Prefferd';
        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.redirectToClinicalProgStep22();
      }
   static testmethod void Test_CRDPharmacyNetworkController4()
     {
         CRD__c testcrd=new CRD__c();
         testcrd.LastSent__c = system.now();
         testcrd.standard_or_custom_plan__c = 'Creating a packaged consumer business plan';
         testcrd.Insured_Type__c = 'Split Funded';
         testcrd.Plan_Type_Mail__c = true;
         testcrd.Plan_Type_Retail__c = true;
         testcrd.Plan_Type_Specialty__c = true;
         testcrd.Sub_Segment__c = 'SGI';
         testcrd.Which_system_will_the_plan_be_installed__c = 'HMO';
         testcrd.Override_Retail_Y_Schedule__c = 'No';
         insert testCrd;
         Custom_Rx_Network__c customtestrec=new Custom_Rx_Network__c();
         customtestrec.Summary_of_Request_Intent__c='test';
         customtestrec.Control_Group_Number__c = 'test';
         customtestrec.Self_Insured__c = True;
         customtestrec.Fully_Insured__c = True;
         customtestrec.Split_Funded__c = True;
         customtestrec.Does_spread_pricing_apply__c='Yes';
         insert customtestrec;
        Network_Junction__c testrec=new Network_Junction__c();
         testrec.Network_Retail__c='test';
         testrec.Mail_Custom__c=customtestrec.id;
         testrec.Network_Specialty__c = 'test';
         testrec.Network_Mail__c='Custom' ;
         testrec.CRD_ID__c= testcrd.id;
         testrec.Enroll_in_Medvantix__c ='Yes';
         testrec.Medvantix_Copay_Percent__c =12;
         testrec.Medvantix_Copay_Dollar_Amount__c =25;        
         insert testrec; 
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDPharmacyNetwork')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDPharmacyNetworkController controller =new VFP_CRDPharmacyNetworkController (stdcontroller);
        controller.redirectToPrograms(); 
        controller.redirectToClinicalProgStep2();   
        controller.redirectToPrograms2();
        controller.redirectToPrograms(); 
        testrec.Retail_Custom__c=customtestrec.id;
       testrec.Network_Retail__c='Custom' ;
        update testrec;
        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.redirectToPrograms();
       testrec.Specialty_Custom__c=customtestrec.id;
       testrec.Network_Specialty__c='Custom'; 
       testrec.Medvantix_Copay_Dollar_Amount__c =null;
       testrec.Medvantix_Copay_Min_Dollar__c =42;
       testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToPrograms();
        testrec.Medvantix_Copay_Min_Dollar__c =2;
        testrec.Medvantix_Copay_Max_Dollar__c =24;
        update testrec;
        controller.redirectToClinicalProgStep2();
        testrec.Network_Specialty__c ='Prefferd';

        controller.redirectToPrograms();
        controller.redirectToClinicalProgStep2();
        controller.redirectToClinicalProgStep22();
      }
      
}