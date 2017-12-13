@isTest
Private class Test_VFP_CRDFirstPageRedirection{

    static testmethod void test1(){
            crd__c testcrd= new crd__c();
            testcrd.Enroll_in_Aetna_Ways_to_Save__c = 'Yes' ;
            testcrd.Target_Participants_18_years_and_older__c = 'No';
            testcrd.Target_Pref_Manufacturer_Brand_Opportun__c = 'No';
            testcrd.If_Not_18_Indicate_Age__c = 15;
            testcrd.Preferred_Manufacturer_Brands_Code__c = 'test';            
            insert testcrd;
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_CRDFirstPageRedirection controller =new VFP_CRDFirstPageRedirection(stdcontroller );
             controller.checkPublicGroup();
             } 
    static testmethod void test2(){
            string crdid;
            crd__c testcrd= new crd__c();
            testcrd.Enroll_in_Aetna_Ways_to_Save__c = 'Yes' ;
            testcrd.Target_Participants_18_years_and_older__c = 'No';
            testcrd.Target_Pref_Manufacturer_Brand_Opportun__c = 'No';
            testcrd.If_Not_18_Indicate_Age__c = 15;
            testcrd.Preferred_Manufacturer_Brands_Code__c = 'test';            
            insert testcrd;
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_CRDFirstPageRedirection controller =new VFP_CRDFirstPageRedirection(stdcontroller );
            crdid = string.valueof(testcrd.id);
            System.currentPageReference().getParameters().put('id', testcrd.id);
            controller.checkPublicGroup();
             } 
           }