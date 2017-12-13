@isTest
Private class Test_AetnaRxWaysToSave{
    static testmethod void waysToSave(){
            crd__c testcrd= new crd__c();
            testcrd.Enroll_in_Aetna_Ways_to_Save__c = 'Yes' ;
            testcrd.Target_Participants_18_years_and_older__c = 'No';
            testcrd.Target_Pref_Manufacturer_Brand_Opportun__c = 'No';
            testcrd.If_Not_18_Indicate_Age__c = 15;
            testcrd.Preferred_Manufacturer_Brands_Code__c = 'test';            
            insert testcrd;
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_AetnaRxWaysToSave controller =new VFP_AetnaRxWaysToSave(stdcontroller );
             controller.showfields();
             controller.showfields3();
             controller.clearfields();
             controller.backbutton();
             controller.nextbutton();
             controller.nextbutton2();
             controller.backbutton2();        
            }
     static testmethod void waysToSave1(){
          crd__c testcrd1 = new crd__c();
           testcrd1.Enroll_in_Aetna_Ways_to_Save__c = 'No';
           insert testcrd1;
           ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd1);
           VFP_AetnaRxWaysToSave controller1 =new VFP_AetnaRxWaysToSave(stdcontroller );
             controller1.showfields();
             controller1.showfields3();
             controller1.clearfields();
             controller1.backbutton();
             controller1.nextbutton();        
             }  
           }