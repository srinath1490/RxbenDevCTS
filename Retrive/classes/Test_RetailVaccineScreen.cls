/*Purpose: Apex Test Class to Test Retail Vaccine Screen Functionality
========================================================================
History                                                            
-------   
VERSION         AUTHOR                DATE                          DETAIL       
1.0             Nitish Verma          19/9/2016                    Created Test Class to test Retail Vaccine Screen functionality

======================================================================== */


@isTest

public class Test_RetailVaccineScreen{

     static testMethod void Test_VFP_RetailVaccine(){
        Test.StartTest();
        Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypeSeasonal;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        rvp.Waiver_of_Deductible__c = 'Yes';
        insert rvp;
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        rvpController.backReadOnly();
        rvpController.nextReadOnly();
        rvpController.clearFields();
        rvpController.rvpPopulateVaccineNetwork.Vaccine_Network__c = 'Broad Network';
        rvpController.seasonal = false;
        rvpController.preventive = false;
        rvpController.travel = false;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        rvpController.reRenderCheckbox();
       
      
        rvpController.seasonal = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();  
        Test.StopTest();
    }
      static testMethod void Test_VFP_RetailVaccine2(){
        
        Test.StartTest();
        Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
      
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypePreventive;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        rvp.Waiver_of_Deductible__c = 'Yes';
        insert rvp;
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
        rvp2.RecordTypeId = recordTypePreventive;
        rvp2.CoPay_Calculation__c = 'test';
        rvp2.CRD__c = crdRec.id;
        rvp2.Dollar_Amount__c = 10;
        rvp2.Maximum_Dollar__c = 100;
        rvp2.Minimum_Dollar__c = 9;
        rvp2.Percent__c = 12;
        rvp2.Vaccine_Network__c = 'Broad Network';
        insert rvp2;
         
        rvpController.preventive= TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
    }
      static testMethod void Test_VFP_RetailVaccine3(){
        
        Test.StartTest();
        Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
      
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypeTravel;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        rvp.Waiver_of_Deductible__c = 'Yes';
        insert rvp;
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
        rvp2.RecordTypeId = recordTypeTravel;
        rvp2.CoPay_Calculation__c = 'test';
        rvp2.CRD__c = crdRec.id;
        rvp2.Dollar_Amount__c = 10;
        rvp2.Maximum_Dollar__c = 100;
        rvp2.Minimum_Dollar__c = 9;
        rvp2.Percent__c = 12;
        rvp2.Vaccine_Network__c = 'Broad Network';
        insert rvp2;
        rvpController.travel = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
    }
    static testMethod void Test_VFP_RetailVaccine4(){
        Test.StartTest();
        Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
        Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
        
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypeTravel;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        insert rvp;
        
        Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
        rvp2.RecordTypeId = recordTypePreventive;
        rvp2.CoPay_Calculation__c = 'test';
        rvp2.CRD__c = crdRec.id;
        rvp2.Dollar_Amount__c = 10;
        rvp2.Maximum_Dollar__c = 100;
        rvp2.Minimum_Dollar__c = 9;
        rvp2.Percent__c = 12;
        rvp2.Vaccine_Network__c = 'Broad Network';
        insert rvp2;
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
       
        rvpController.travel = TRUE;
        rvpController.preventive = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
      }
      static testMethod void Test_VFP_RetailVaccine5(){
          Test.StartTest();
          Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
          Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
          CRD__c crdRec = new CRD__c();
          crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
          insert crdRec;
      
          
            Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
            rvp2.RecordTypeId = recordTypeTravel;
            rvp2.CRD__c = crdRec.id;
            rvp2.Dollar_Amount__c = 10;
            rvp2.Maximum_Dollar__c = 100;
            rvp2.Minimum_Dollar__c = 9;
            rvp2.Percent__c = 12;
            rvp2.Vaccine_Network__c = 'Broad Network';
            insert rvp2;
            
            
            Retail_Vaccine_Program__C rvp4 = new Retail_Vaccine_Program__C();
            rvp4.RecordTypeId = recordTypePreventive;
            rvp4.CRD__c = crdRec.id;
            rvp4.Dollar_Amount__c = 10;
            rvp4.Maximum_Dollar__c = 100;
            rvp4.Minimum_Dollar__c = 9;
            rvp4.Percent__c = 12;
            rvp4.Vaccine_Network__c = 'Broad Network';
            insert rvp4;
            
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
       
        rvpController.travel = TRUE;
        rvpController.preventive = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
        }
        static testMethod void Test_VFP_RetailVaccine6(){
          Test.StartTest();
          Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
          Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
          Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
          CRD__c crdRec = new CRD__c();
          crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
          insert crdRec;
          
        Retail_Vaccine_Program__C rvp3 = new Retail_Vaccine_Program__C();
            rvp3.RecordTypeId = recordTypePreventive;
            rvp3.CoPay_Calculation__c = 'test';
            rvp3.CRD__c = crdRec.id;
            rvp3.Maximum_Dollar__c = 100;
            rvp3.Minimum_Dollar__c = 9;
            rvp3.Vaccine_Network__c = 'Broad Network';
            rvp3.Dollar_Amount__c = Null;
            rvp3.Percent__c = Null;
            insert rvp3;
        
         Retail_Vaccine_Program__C rvp1 = new Retail_Vaccine_Program__C();
            rvp1.RecordTypeId = recordTypeTravel;
            rvp1.CoPay_Calculation__c = 'test';
            rvp1.CRD__c = crdRec.id;
            rvp1.Maximum_Dollar__c = 100;
            rvp1.Minimum_Dollar__c = 9;
            rvp1.Vaccine_Network__c = 'Broad Network';
            rvp1.Dollar_Amount__c = Null;
            rvp1.Percent__c = Null;
            insert rvp1;
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
            rvp.RecordTypeId = recordTypeSeasonal;
            rvp.CRD__c = crdRec.id;
            rvp.Dollar_Amount__c = 10;
            rvp.Maximum_Dollar__c = 100;
            rvp.Minimum_Dollar__c = 9;
            rvp.Percent__c = 12;
            rvp.Vaccine_Network__c = 'Broad Network';
            rvp.Waiver_of_Deductible__c = 'Yes';
            insert rvp;    
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        rvpController.seasonal = TRUE;
        rvpController.travel = TRUE;
        rvpController.preventive = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
      }
      static testMethod void Test_VFP_RetailVaccine7(){
        Test.StartTest();
        Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypeSeasonal;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        rvp.Waiver_of_Deductible__c = 'Yes';
        insert rvp;
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        rvpController.seasonal = TRUE;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
        }
        
      static testMethod void Test_VFP_RetailVaccine8(){
        Test.StartTest();
        Id recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Seasonal').getRecordTypeId();
        Id recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Preventive').getRecordTypeId();
        Id recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get('Travel').getRecordTypeId();
        CRD__c crdRec = new CRD__c();
        crdRec.Standard_or_Custom_Plan__c = 'Creating a custom plan';
        insert crdRec;
        system.debug('crdRecId++++ ' + crdRec.id);
        Retail_Vaccine_Program__C rvp = new Retail_Vaccine_Program__C();
        rvp.RecordTypeId = recordTypeSeasonal;
        rvp.CoPay_Calculation__c = 'test';
        rvp.CRD__c = crdRec.id;
        rvp.Dollar_Amount__c = 10;
        rvp.Maximum_Dollar__c = 100;
        rvp.Minimum_Dollar__c = 9;
        rvp.Percent__c = 12;
        rvp.Vaccine_Network__c = 'Broad Network';
        rvp.Waiver_of_Deductible__c = 'Yes';
        insert rvp;
        
        Retail_Vaccine_Program__C rvp2 = new Retail_Vaccine_Program__C();
        rvp2.RecordTypeId = recordTypePreventive;
        rvp2.CoPay_Calculation__c = 'test';
        rvp2.CRD__c = crdRec.id;
        rvp2.Dollar_Amount__c = 10;
        rvp2.Maximum_Dollar__c = 100;
        rvp2.Minimum_Dollar__c = 9;
        rvp2.Percent__c = 12;
        rvp2.Vaccine_Network__c = 'Broad Network';
        rvp2.Waiver_of_Deductible__c = 'Yes';
        insert rvp2;
        
        Retail_Vaccine_Program__C rvp3 = new Retail_Vaccine_Program__C();
        rvp3.RecordTypeId = recordTypeTravel;
        rvp3.CoPay_Calculation__c = 'test';
        rvp3.CRD__c = crdRec.id;
        rvp3.Dollar_Amount__c = 10;
        rvp3.Maximum_Dollar__c = 100;
        rvp3.Minimum_Dollar__c = 9;
        rvp3.Percent__c = 12;
        rvp3.Vaccine_Network__c = 'Broad Network';
        rvp3.Waiver_of_Deductible__c = 'Yes';
        insert rvp3;
        
        PageReference retailVaccinePage = page.VF_RetailVaccineProgramScreen;
        retailVaccinePage .getParameters().put('crdid',crdRec.id);    
        Test.setCurrentPage(retailVaccinePage);
        ApexPages.StandardController sc = new ApexPages.standardController(crdRec);
        
        VFP_RetailVaccineProgramScreenController rvpController = new VFP_RetailVaccineProgramScreenController(sc);
        rvpController.seasonal = False;
        rvpController.preventive= False;
        rvpController.travel= False;
        rvpController.backEditMode();
        rvpController.nextEditMode();
        Test.StopTest();
        }
 }