/*Purpose: Test Class for VFP_CRDNewDAWSpecificCopay Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Rashi                 3/1/2012       Test Class for VFP_CRDNewDAWSpecificCopay Page
======================================================================== 
*/
@isTest
private class TEST_CRDNewDAWSpecificCopay {

    static testMethod void testNewCopay() {
       
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       testCrd.Any_drug_specific_Paper_Out_of_Network__c=true;
       testCrd.Any_drug_specific_Specialty_OON_copays__c=true;
       //testcrd.Durg_Specific_Stepped_Count__c = 4;
       testCrd.Any_drug_specific_Specialty_copays__c = true;
       //testcrd.SteppedCopayCount__c = 4;
       insert testCrd;
       
       DAW_Specific_Copay__c copay=new DAW_Specific_Copay__c();
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Dollar_Amount__c=10;
       mailCopay.MS_Code_M__c=true;
       insert mailCopay;

       DAW_Specific_Copay__c retailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Retail'];
       retailCopay.RecordTypeId=retailRt.id;
       retailCopay.DAW_Code__c='1';
       retailCopay.Dollar_Amount__c=10;
       retailCopay.MS_Code_M__c=true;
       retailCopay.Maximum_Dollar__c = 5;
       retailCopay.Minimum_Dollar__c =10;
       insert retailCopay;
        
       DAW_Specific_Copay__c paperCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper'];
       paperCopay.RecordTypeId=paperRt.id;
       paperCopay.DAW_Code__c='1';
       paperCopay.Dollar_Amount__c=10;
       paperCopay.MS_Code_M__c=true;
       insert paperCopay;
       
       DAW_Specific_Copay__c specialtyCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty'];
       specialtyCopay.RecordTypeId=specialtyRt.id;
       specialtyCopay.DAW_Code__c='1';
       specialtyCopay.Dollar_Amount__c=10;
       specialtyCopay.MS_Code_M__c=true;
       insert specialtyCopay;              

       DAW_Specific_Copay__c paperOonCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperOonRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper Out of Network'];
       paperOonCopay.RecordTypeId=paperOonRt.id;
       paperOonCopay.DAW_Code__c='1';
       paperOonCopay.Dollar_Amount__c=10;
       paperOonCopay.MS_Code_M__c=true;
       insert paperOonCopay;              

       DAW_Specific_Copay__c SpecialtyOonCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType SpecialtyOonRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty OON'];
       SpecialtyOonCopay.RecordTypeId=SpecialtyOonRt.id;
       SpecialtyOonCopay.DAW_Code__c='1';
       SpecialtyOonCopay.Dollar_Amount__c=10;
       SpecialtyOonCopay.MS_Code_M__c=true;
       insert SpecialtyOonCopay;        
       VFP_CRDNewDAWSpecificCopay.dawSpecificCopayWrapper daWrap = new VFP_CRDNewDAWSpecificCopay.dawSpecificCopayWrapper();
       List<VFP_CRDNewDAWSpecificCopay.dawSpecificCopayWrapper> dWrapList = new List<VFP_CRDNewDAWSpecificCopay.dawSpecificCopayWrapper>();
       dWrapList.add(daWrap);
       string recType = 'Mail';
       
       copay.CRD_ID__c=testCrd.id;
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDAWSpecificCopay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController (copay);
       VFP_CRDNewDAWSpecificCopay controller =new VFP_CRDNewDAWSpecificCopay(stdcontroller);      
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       controller.populateExistingItems();
       testCrd.Any_drug_specific_Specialty_copays__c = false;
       update testcrd;
       controller.previousStep();
       controller.previousstep2();
                     
       controller.lstDAWSpecificCopayWrapMailItems.get(0).isMarkedForDeletion=true;
       controller.lstDAWSpecificCopayWrapPaperItems.get(0).isMarkedForDeletion=true;
       controller.lstDAWSpecificCopayWrapRetailItems.get(0).isMarkedForDeletion=true;
       controller.lstDAWSpecificCopayWrapSpecialityItems.get(0).isMarkedForDeletion=true;
       controller.lstDAWSpecificCopayWrapOONItems.get(0).isMarkedForDeletion=true;
       controller.lstDAWSpecificCopayWrapSpecialtyOONItems.get(0).isMarkedForDeletion=true;

       controller.deleteSelectedMailItems();
       controller.deleteSelectedPaperItems();
       controller.deleteSelectedRetailItems();
       controller.deleteSelectedSpecialityItems();
       controller.deleteSelectedSpecialtyOONItems();
       controller.deleteSelectedOONItems();
       
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       
       controller.AddNewDAWSpecificMailItem();
       controller.AddNewDAWSpecificPaperItem();
       controller.AddNewDAWSpecificRetailItem();
       controller.AddNewDAWSpecificSpecialityItem();
       controller.AddNewDAWSpecificSpecialtyOONItem();
       controller.AddNewDAWSpecificOONItem();
       
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       controller.saveWrappedList(dWrapList,recType);
       controller.saveWrappedList1(dWrapList, recType);
       }
       static testMethod void testNewCopay2() {
       
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       testCrd.Any_drug_specific_Paper_Out_of_Network__c=true;
       testCrd.Any_drug_specific_Specialty_OON_copays__c=true;
       insert testCrd;
       
       Drug_Specific_Copay__c dscRecord = new Drug_Specific_Copay__c();
       RecordType maildsc=[Select Id,Name from RecordType where sobjecttype='Drug_Specific_Copay__c' and name ='Mail'];
       dscRecord.RecordTypeId = maildsc.id;
       dscRecord.CRD_ID__c = testcrd.id;
       
       insert dscRecord;
       
       update testcrd;
       
       DAW_Specific_Copay__c copay=new DAW_Specific_Copay__c();
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Dollar_Amount__c=10;
       mailCopay.MS_Code_M__c=true;
       mailCopay.stepped__c = true;
       insert mailCopay;

       DAW_Specific_Copay__c retailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Retail'];
       retailCopay.RecordTypeId=retailRt.id;
       retailCopay.DAW_Code__c='1';
       retailCopay.Dollar_Amount__c=10;
       retailCopay.MS_Code_M__c=true;
       retailCopay.Maximum_Dollar__c = 5;
       retailCopay.Minimum_Dollar__c =10;
       insert retailCopay;
        
       DAW_Specific_Copay__c paperCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper'];
       paperCopay.RecordTypeId=paperRt.id;
       paperCopay.DAW_Code__c='1';
       paperCopay.Dollar_Amount__c=10;
       paperCopay.MS_Code_M__c=true;
       insert paperCopay;
       
       DAW_Specific_Copay__c specialtyCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType specialtyRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty'];
       specialtyCopay.RecordTypeId=specialtyRt.id;
       specialtyCopay.DAW_Code__c='1';
       specialtyCopay.Dollar_Amount__c=10;
       specialtyCopay.MS_Code_M__c=true;
       insert specialtyCopay;              

       DAW_Specific_Copay__c paperOonCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType paperOonRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Paper Out of Network'];
       paperOonCopay.RecordTypeId=paperOonRt.id;
       paperOonCopay.DAW_Code__c='1';
       paperOonCopay.Dollar_Amount__c=10;
       paperOonCopay.MS_Code_M__c=true;
       insert paperOonCopay;              

       DAW_Specific_Copay__c SpecialtyOonCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType SpecialtyOonRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Specialty OON'];
       SpecialtyOonCopay.RecordTypeId=SpecialtyOonRt.id;
       SpecialtyOonCopay.DAW_Code__c='1';
       SpecialtyOonCopay.Dollar_Amount__c=10;
       SpecialtyOonCopay.MS_Code_M__c=true;
       insert SpecialtyOonCopay;        
         
       copay.CRD_ID__c=testCrd.id;
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDAWSpecificCopay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController (copay);
       VFP_CRDNewDAWSpecificCopay controller =new VFP_CRDNewDAWSpecificCopay(stdcontroller);  
            
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       
       }
       static testMethod void testNewCopay3() {
       
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       testCrd.Any_drug_specific_Paper_Out_of_Network__c=true;
       testCrd.Any_drug_specific_Specialty_OON_copays__c=true;
       insert testCrd;
       
       DAW_Specific_Copay__c copay=new DAW_Specific_Copay__c();
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Dollar_Amount__c=10;
       mailCopay.MS_Code_M__c=true;
       insert mailCopay;
       
       Drug_Specific_Copay__c dscRecord = new Drug_Specific_Copay__c();
       RecordType maildsc=[Select Id,Name from RecordType where sobjecttype='Drug_Specific_Copay__c' and name ='Mail'];
       dscRecord.RecordTypeId = maildsc.id;
       dscRecord.CRD_ID__c = testcrd.id;
       dscRecord.Stepped_Copay__c = true;
       insert dscRecord;
       update testcrd;
         copay.CRD_ID__c=testCrd.id;
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDAWSpecificCopay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController (copay);
       VFP_CRDNewDAWSpecificCopay controller =new VFP_CRDNewDAWSpecificCopay(stdcontroller);  
            
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       
       }
       static testMethod void testNewCopay4() {
       
       CRD__c testCrd=new CRD__c();  
       testCrd.Any_DAW_specific_Mail_copays__c=true;
       testCrd.Any_DAW_specific_Retail_copays__c=true;
       testCrd.Any_DAW_specific_Specialty_copays__c=true;
       testCrd.Any_DAW_specific_Paper_copays__c=true;                                        
       testCrd.Any_drug_specific_Paper_Out_of_Network__c=true;
       testCrd.Any_drug_specific_Specialty_OON_copays__c=true;
       insert testCrd;
       
       DAW_Specific_Copay__c copay=new DAW_Specific_Copay__c();
       
       DAW_Specific_Copay__c mailCopay=new DAW_Specific_Copay__c(CRD_ID__c=testCrd.id);
       RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='DAW_Specific_Copay__c' and name ='Mail'];
       mailCopay.RecordTypeId=mailRt.id;
       mailCopay.DAW_Code__c='1';
       mailCopay.Dollar_Amount__c=10;
       mailCopay.MS_Code_M__c=true;
       insert mailCopay;
       
       Copay_Tier__c ct = new Copay_Tier__c();
       ct.CRD__c = testcrd.id;
       ct.Stepped_Copay__c = true;
       
       RecordType maildsc=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Mail'];
       ct.RecordTypeId = maildsc.id;
       insert ct;
       update testcrd;
         
       copay.CRD_ID__c=testCrd.id;
       Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDAWSpecificCopay')); 
       System.currentPageReference().getParameters().put('crdid', testCrd.id);
       ApexPages.StandardController stdcontroller =new ApexPages.StandardController (copay);
       VFP_CRDNewDAWSpecificCopay controller =new VFP_CRDNewDAWSpecificCopay(stdcontroller);  
           string rtName = controller.getRecordTypeNameByid(mailRt.id);
       controller.Save();   
       controller.previousStep();
       controller.save2();
       controller.previousstep2();
       
       }
}