/*Purpose: Apex Test Class for VFP_CRDDrugSpecificSteppedCoPay.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/28/2011       Apex Test Class for VFP_CRDDrugSpecificSteppedCoPay.
======================================================================== 
*/
@isTest
private class TEST_CRDDrugSpecificSteppedCoPay
{

    static testmethod void testCRDDrugSpecificSteppedCoPay()
    {
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         Drug_List__c druglist=testdata.createDrugList();
         RecordType rt1=[Select Id,Name from RecordType where sobjecttype='Drug_List__c' and Name='Drug List' limit 1];
         List<Recordtype> rt=[select id,RecordType.DeveloperName from RecordType where SobjectType='Drug_Specific_Copay__c' and (developername='Retail' OR developername='Mail' OR developername='Specialty' OR developername='Paper Out of Network' OR developername='Paper'  OR developername='Specialty OON')];
         druglist.recordTypeid=rt1.id;
         insert druglist;
         

         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
        // Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         for(Recordtype r : rt){
             if(r.developername=='Retail'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Drug_Specific_Stepped_Copay__c drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         drugsteppedcopay.Beginning_Range__c=1;
         drugsteppedcopay.End_Range__c=2;
         drugsteppedcopay.Percent__c=100;
         drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugsteppedcopay;
         
         
         Copay_Tier__c mailCopay= new Copay_Tier__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         mailCopay.CRD__c = testCrd.id;
         insert mailCopay;
         
         SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailCopay.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDDrugSpecificSteppedCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDDrugSpecificSteppedCoPay controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         
         Test.StartTest();
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.sortRetaillist();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedRetailCopayWrapper);
         VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper wrap = new  VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper();
         
         
         delete drug;
         drug=new Drug_Specific_Copay__c();
         //rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         for(Recordtype r : rt){
             if(r.developername=='Mail'){
                drug.recordTypeId=r.Id;
             }
         }
         
         
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         insert drugsteppedcopay;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.mailParentId = drug.id;
         controller.SortMailList();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedMailCopayWrapper);
         
         
         delete drug;
         drug=new Drug_Specific_Copay__c();
         //rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty'];
         for(Recordtype r : rt){
             if(r.developername=='Specialty'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         insert drugsteppedcopay;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.specialityParentId = drug.id;
         controller.SortSpecialityList();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedSpecialityCopayWrapper);         
         
         delete drug;
         drug=new Drug_Specific_Copay__c();
         //rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper'];
         for(Recordtype r : rt){
             if(r.developername=='Paper'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         insert drugsteppedcopay;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.paperParentId = drug.id;
         controller.SortPaperList();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedPaperCopayWrapper);    
         delete drug;
         
        
         drug=new Drug_Specific_Copay__c();
        //rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and Name='Paper Out of Network' limit 1];
        for(Recordtype r : rt){
             if(r.developername=='Paper Out of Network'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         insert drugsteppedcopay;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.outOfnetworkParentId = drug.Id;
         controller.SortOutofNetworkList();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedPaperCopayWrapper);
         controller.SortSpecialtyOutofNetworkList();
         //added by abhishek
         drug=new Drug_Specific_Copay__c();
         //rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and Name='Specialty OON' limit 1];
         for(Recordtype r : rt){
             if(r.developername=='Specialty OON'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         insert drugsteppedcopay;
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         controller.getTypeOfStepCopay();
         controller.getItems();
         
         
         controller.SpecialtyoutOfnetworkParentId = drug.Id;
         controller.SortOutofNetworkList();
         controller.previousStep();
         
         controller.Next();
         controller.saveWrappedList(controller.steppedOutOfnetworkCopayWrapper);
         controller.SortSpecialtyOutofNetworkList();
         Test.stopTest();
         
    }
    
    static testmethod void testCRDDrugSpecificSteppedCoPay1a()
    {
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         Drug_List__c druglist=testdata.createDrugList();
         RecordType rt1=[Select Id,Name from RecordType where sobjecttype='Drug_List__c' and Name='Drug List' limit 1];
         List<Recordtype> rt=[select id,RecordType.DeveloperName from RecordType where SobjectType='Drug_Specific_Copay__c' and (developername='Retail' OR developername='Mail' OR developername='Specialty' OR developername='Paper Out of Network' OR developername='Paper'  OR developername='Specialty OON')];
         druglist.recordTypeid=rt1.id;
         insert druglist;
         

         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
        // Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         for(Recordtype r : rt){
             if(r.developername=='Paper Out of Network'){
                drug.recordTypeId=r.Id;
             }
         }
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Drug_Specific_Stepped_Copay__c drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         drugsteppedcopay.Beginning_Range__c=1;
         drugsteppedcopay.End_Range__c=2;
         drugsteppedcopay.Percent__c=100;
         drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugsteppedcopay;
         
         
         Copay_Tier__c mailCopay= new Copay_Tier__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper Out of Network').getRecordTypeId();
         mailCopay.CRD__c = testCrd.id;
         insert mailCopay;
         
         SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailCopay.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDDrugSpecificSteppedCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDDrugSpecificSteppedCoPay controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         
         
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.SortOutofNetworkList();
         controller.previousStep();
         controller.Next();
         controller.saveWrappedList(controller.steppedOutOfnetworkCopayWrapper);
         VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper wrap = new  VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper();
        
        } 
        static testmethod void testTRG_UpdateDrugSpecificSteppedTiers()
        {
         CRD__c testCrd=new CRD__c();
         
         insert testCrd;
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         Drug_List__c druglist=testdata.createDrugList();
         RecordType rt3=[Select Id,Name from RecordType where sobjecttype='Drug_List__c' and Name='Drug List' limit 1];         
         druglist.recordTypeid=rt3.id;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Drug_Specific_Stepped_Copay__c drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         drugsteppedcopay.Beginning_Range__c=1;
         drugsteppedcopay.End_Range__c=2;
         drugsteppedcopay.Percent__c=100;
         drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugsteppedcopay;         
         drug.Stepped_Copay__c=false;
         update drug;
         
        }

        static testmethod void testTRG_UpdateCopayTiers()
        {
             CRD__c testCrd=new CRD__c();
             testCrd.Any_drug_specific_Mail_copays__c = true;
             testCrd.Any_drug_specific_Paper_copays__c = true;
             testCrd.Any_drug_specific_Retail_copays__c= true;
             testCrd.Any_drug_specific_Specialty_copays__c= true;
             testCrd.Plan_Type_Paper__c=true;
             insert testCrd;
             
             Account a= new Account(Name='testcrd');
             a.A_c_Email__c='a@a.com';
             insert a;
             
             testCrd.Account__c =a.Id;
             testCrd.Any_drug_specific_Mail_copays__c = false;
             testCrd.Any_drug_specific_Paper_copays__c = false;
             testCrd.Any_drug_specific_Retail_copays__c=false;
             testCrd.Any_drug_specific_Specialty_copays__c= false;
             update testCrd;
             
             
        }
      
        static testmethod void testCRDDrugSteppedCopay(){
        Test.StartTest();
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         CRD__c testCrd=new CRD__c();
         testCrd.LastSent__c = system.now();
         insert testCrd;
         
         Drug_List__c druglist=testdata.createDrugList();
         RecordType rt1=[Select Id,Name from RecordType where sobjecttype='Drug_List__c' and Name='Drug List' limit 1];
         druglist.recordTypeid=rt1.id;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
            
         Drug_Specific_Copay__c mailCopay= new Drug_Specific_Copay__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.Drug_Group__c=druggroup.Id;
         mailCopay.Drug_List__c=druglist.Id;         
         mailCopay.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
         mailCopay.CRD_ID__c = testCrd.id;
         insert mailCopay;
         
         Drug_Specific_Stepped_Copay__c drugMailsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugMailsteppedcopay.Dollar_Amount__c=100;
         drugMailsteppedcopay.Number_of_Steps__c='1';
         drugMailsteppedcopay.Drug_Specific_Copay_ID__c=mailCopay.Id;
         drugMailsteppedcopay.Beginning_Range__c=1;
         drugMailsteppedcopay.End_Range__c=2;
         drugMailsteppedcopay.Percent__c=100;
         drugMailsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugMailsteppedcopay;
         
         Drug_Specific_Copay__c Retail= new Drug_Specific_Copay__c();
         Retail.Stepped_Copay__c=true;
         Retail.Drug_Group__c=druggroup.Id;
         Retail.Drug_List__c=druglist.Id;
         Retail.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         Retail.CRD_ID__c = testCrd.id;
         insert Retail;

         Drug_Specific_Copay__c speciality= new Drug_Specific_Copay__c();
         speciality.Stepped_Copay__c=true;
         speciality.Drug_Group__c=druggroup.Id;
         speciality.Drug_List__c=druglist.Id;
         speciality.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Specialty OON').getRecordTypeId();
         speciality.CRD_ID__c = testCrd.id;
         insert speciality;

         Drug_Specific_Copay__c paperOON= new Drug_Specific_Copay__c();
         paperOON.Stepped_Copay__c=true;
         paperOON.Drug_Group__c=druggroup.Id;
         paperOON.Drug_List__c=druglist.Id;
         paperOON.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Paper Out of Network').getRecordTypeId();
         paperOON.CRD_ID__c = testCrd.id;
         insert paperOON;
         
         Drug_Specific_Stepped_Copay__c drugRetailsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugRetailsteppedcopay.Dollar_Amount__c=100;
         drugRetailsteppedcopay.Number_of_Steps__c='1';
         drugRetailsteppedcopay.Drug_Specific_Copay_ID__c=Retail.Id;
         drugRetailsteppedcopay.Beginning_Range__c=1;
         drugRetailsteppedcopay.End_Range__c=2;
         drugRetailsteppedcopay.Percent__c=100;
         drugRetailsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugRetailsteppedcopay;
         
         
         Drug_Specific_Copay__c Paper= new Drug_Specific_Copay__c();
         Paper.Stepped_Copay__c=true;
         Paper.Drug_Group__c=druggroup.Id;
         Paper.Drug_List__c=druglist.Id;         
         Paper.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
         Paper.CRD_ID__c = testCrd.id;
         insert Paper;
         
          Drug_Specific_Stepped_Copay__c drugPapersteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugPapersteppedcopay.Dollar_Amount__c=100;
         drugPapersteppedcopay.Number_of_Steps__c='1';
         drugPapersteppedcopay.Drug_Specific_Copay_ID__c=Paper.Id;
         drugPapersteppedcopay.Beginning_Range__c=1;
         drugPapersteppedcopay.End_Range__c=2;
         drugPapersteppedcopay.Percent__c=100;
         drugPapersteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugPapersteppedcopay;
         Drug_Specific_Copay__c Specialty= new Drug_Specific_Copay__c();
         Specialty.Stepped_Copay__c=true;
         Specialty.Drug_Group__c=druggroup.Id;
         Specialty.Drug_List__c=druglist.Id;
         Specialty.recordtypeid=Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
         Specialty.CRD_ID__c = testCrd.id;
         insert Specialty;
         
         Drug_Specific_Stepped_Copay__c drugSpecialitysteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugSpecialitysteppedcopay.Dollar_Amount__c=100;
         drugSpecialitysteppedcopay.Number_of_Steps__c='1';
         drugSpecialitysteppedcopay.Drug_Specific_Copay_ID__c=Specialty.Id;
         drugSpecialitysteppedcopay.Beginning_Range__c=1;
         drugSpecialitysteppedcopay.End_Range__c=2;
         drugSpecialitysteppedcopay.Percent__c=100;
         drugSpecialitysteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugSpecialitysteppedcopay;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDDrugSpecificSteppedCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDDrugSpecificSteppedCoPay controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         
         controller.mailParentId=mailCopay.id;
         controller.retailParentId=Retail.id;
         controller.paperParentId=Paper.id;
         controller.specialityParentId=Specialty.id;
         controller.steppedRetailCopayWrapper[0].noOfSteps=1;
         controller.sortRetaillist();
         Test.stopTest();
      }
        
    static testmethod void testCRDDrugSpecificSteppedCoPay5()
    {
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         Drug_List__c druglist=testdata.createDrugList();
         RecordType rt1=[Select Id,Name from RecordType where sobjecttype='Drug_List__c' and Name='Drug List' limit 1];
         druglist.recordTypeid=rt1.id;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Drug_Specific_Stepped_Copay__c drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         drugsteppedcopay.Beginning_Range__c=1;
         drugsteppedcopay.End_Range__c=2;
         drugsteppedcopay.Percent__c=100;
         drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugsteppedcopay;
         
         
         Copay_Tier__c mailCopay= new Copay_Tier__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         mailCopay.CRD__c = testCrd.id;
         insert mailCopay;
         
         SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailCopay.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDDrugSpecificSteppedCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDDrugSpecificSteppedCoPay controller =new VFP_CRDDrugSpecificSteppedCoPay(stdcontroller);
         
         test.startTest();
         controller.getTypeOfStepCopay();
         controller.getItems();
         controller.sortRetaillist();
         controller.previousStep();
         controller.Next();
         
         controller.steppedMailCopayWrapper = controller.steppedRetailCopayWrapper;
        controller.Next();
        controller.steppedPaperCopayWrapper = controller.steppedRetailCopayWrapper;
        controller.Next();
        controller.steppedSpecialityCopayWrapper = controller.steppedRetailCopayWrapper;
        controller.Next();
        controller.steppedOutOfnetworkCopayWrapper = controller.steppedRetailCopayWrapper;
        controller.Next();
        controller.steppedSpecialtyOONCopayWrapper = controller.steppedRetailCopayWrapper;
        controller.Next();
    }       
    
 }