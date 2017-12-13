/*Purpose: Apex Test Class for VFP_CRDDAWSpecificSteppedCopayController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Rashi                 3/1/2012       Apex Test Class for VFP_CRDDAWSpecificSteppedCopayController.
======================================================================== 
*/
@isTest
private class TEST_CRDDAWSpecificSteppedCopay {

    static testMethod void testNewSteppedCopay() {
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       testCrd.Plan_Type_Paper_Out_of_Network__c=true;  
       testCrd.Any_DAW_specific_Specialty_OON_copays__c=true;
       testCrd.Plan_Type_Specialty_OON__c=true;
       insert testCrd;
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Stepped__c=true;
       insert mailCopay;
       
       DAW_Specific_Copay__c retailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Retail'];
       retailCopay.RecordTypeId=retailRt.id;
       retailCopay.DAW_Code__c='1';
       retailCopay.Stepped__c=true;       
       insert retailCopay;
       
       DAW_Specific_Copay__c paperCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper'];
       paperCopay.RecordTypeId=paperRt.id;
       paperCopay.DAW_Code__c='1';
       paperCopay.Stepped__c=true;
       insert paperCopay;
       
       DAW_Specific_Copay__c specialtyCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty'];
       specialtyCopay.RecordTypeId=specialtyRt.id;
       specialtyCopay.DAW_Code__c='1';
       specialtyCopay.Stepped__c=true;       
       insert specialtyCopay; 
       
       DAW_Specific_Copay__c paperOOnCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperOOnRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper Out of Network'];
       paperOOnCopay.RecordTypeId=paperOOnRt.id;
       paperOOnCopay.DAW_Code__c='1';
       paperOOnCopay.Stepped__c=true;       
       insert paperOOnCopay;   
        
       DAW_Specific_Copay__c specialtyOOnCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyOOnRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty OON'];
       specialtyOOnCopay.RecordTypeId=specialtyOOnRt.id;
       specialtyOOnCopay.DAW_Code__c='1';
       specialtyOOnCopay.Stepped__c=true;       
       insert specialtyOOnCopay; 
       
       DAW_Specific_Stepped_Copay__c steppedCopay=new DAW_Specific_Stepped_Copay__c();
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDDAWSpecificSteppedCoPay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController(steppedCopay);
       VFP_CRDDAWSpecificSteppedCopay controller =new VFP_CRDDAWSpecificSteppedCopay(stdcontroller);  
       controller.getItems();    
       controller.getTypeOfStepCopay();
       
              
       controller.mailParentId=mailCopay.id;       
       controller.steppedMailCopayWrapper.get(0).noOfSteps=1;
       DAW_Specific_Stepped_Copay__c steppedMailCopay=new DAW_Specific_Stepped_Copay__c();     
       steppedMailCopay.DAW_Specific_Copay_ID__c=mailCopay.id;
       steppedMailCopay.Percent__c=10;       
       controller.steppedMailCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.SortMailList();       
       
       controller.Next();
       controller.previousStep();
       controller.SpecialtyoonParentId = mailcopay.id;
       controller.steppedSpecialtyOONCopayWrapper = controller.steppedMailCopayWrapper;
       controller.sortSpecialtyOOnlist();   
       controller.Next();
       controller.previousStep();
       


              
       controller.paperParentId=paperCopay.id;      
       controller.steppedPaperCopayWrapper.get(0).noOfSteps=1;       
       controller.steppedPaperCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.SortPaperList();
       controller.Next();
       controller.previousStep();
              
       controller.retailParentId=retailCopay.id;
       controller.steppedRetailCopayWrapper.get(0).noOfSteps=1;       
       controller.steppedRetailCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.sortRetaillist();
       controller.Next();
       controller.previousStep();
       
       
       controller.specialityParentId=specialtyCopay.id;       
       controller.steppedSpecialityCopayWrapper.get(0).noOfSteps=1;             
       controller.steppedSpecialityCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.SortSpecialityList();
       controller.Next();
       controller.previousStep(); 
       controller.Next2();
       controller.previousStep2();     

       controller.oonParentId=paperOOnCopay.id;       
       controller.steppedOONCopayWrapper.get(0).noOfSteps=1;             
       controller.steppedOONCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.sortOOnlist();
       controller.Next();
       controller.previousStep();    
        
       controller.oonParentId=specialtyOOnCopay.id;       
       controller.steppedSpecialtyOONCopayWrapper.get(0).noOfSteps=1;             
       controller.steppedSpecialtyOONCopayWrapper.get(0).dawSpecificSteppedCopayItemList.add(steppedMailCopay);
       controller.sortSpecialtyOOnlist();
       controller.Next();
       controller.previousStep(); 
       
       controller.saveWrappedList(controller.steppedSpecialityCopayWrapper);
       
       List < VFP_CRDDAWSpecificSteppedCopay.dawSpecificCopayWrapper > tempcopay= controller.steppedMailCopayWrapper;
       controller.steppedMailCopayWrapper=null;
       
       controller.steppedRetailCopayWrapper=null;
       controller.steppedPaperCopayWrapper=null;
       controller.steppedSpecialityCopayWrapper=null;
       controller.steppedOONCopayWrapper=null;
       controller.steppedSpecialtyOONCopayWrapper=null;
       
       controller.previousStep(); 
       controller.next(); 
       controller.steppedSpecialtyOONCopayWrapper=tempcopay;
       controller.previousStep(); 
       controller.next(); 
       
       controller.steppedOONCopayWrapper=tempcopay;
       controller.previousStep(); 
       controller.next(); 
       controller.steppedSpecialityCopayWrapper=tempcopay;
       controller.previousStep(); 
       controller.next(); 
       controller.steppedPaperCopayWrapper=tempcopay;
       controller.previousStep(); 
       controller.next(); 
       controller.steppedRetailCopayWrapper=tempcopay;
       controller.previousStep(); 
       controller.next();      
       
    }
    
     static testMethod void testNewSteppedCopayValidations() {
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       insert testCrd;
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Stepped__c=true;
       insert mailCopay;
       
       DAW_Specific_Copay__c retailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Retail'];
       retailCopay.RecordTypeId=retailRt.id;
       retailCopay.DAW_Code__c='1';
       retailCopay.Stepped__c=true;       
       insert retailCopay;
       
       DAW_Specific_Copay__c paperCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper'];
       paperCopay.RecordTypeId=paperRt.id;
       paperCopay.DAW_Code__c='1';
       paperCopay.Stepped__c=true;
       insert paperCopay;
       
       DAW_Specific_Copay__c specialtyCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty'];
       specialtyCopay.RecordTypeId=specialtyRt.id;
       specialtyCopay.DAW_Code__c='1';
       specialtyCopay.Stepped__c=true;       
       insert specialtyCopay; 
         
       DAW_Specific_Copay__c specialtyOONCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyOONRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty OON'];
       specialtyOONCopay.RecordTypeId=specialtyOONRt.id;
       specialtyOONCopay.DAW_Code__c='1';
       specialtyOONCopay.Stepped__c=true;       
       insert specialtyOONCopay;   
       
       DAW_Specific_Stepped_Copay__c steppedCopay=new DAW_Specific_Stepped_Copay__c();
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDDAWSpecificSteppedCoPay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController(steppedCopay);
       VFP_CRDDAWSpecificSteppedCopay controller =new VFP_CRDDAWSpecificSteppedCopay(stdcontroller);  
       controller.getItems();    
       controller.getTypeOfStepCopay();
       
       DAW_Specific_Stepped_Copay__c steppedMailCopay=new DAW_Specific_Stepped_Copay__c();
       steppedMailCopay.DAW_Specific_Copay_ID__c=mailCopay.id;
       steppedMailCopay.Beginning_Range__c=10;
       steppedMailCopay.End_Range__c=12;
       steppedMailCopay.Copay_Calculation__c='test';
       steppedMailCopay.Minimum_Dollar__c=10;
       steppedMailCopay.Maximum_Dollar__c=11;
       controller.Next();
       controller.previousStep();
     }
}