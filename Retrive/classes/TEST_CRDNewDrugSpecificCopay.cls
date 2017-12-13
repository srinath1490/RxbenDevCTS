/*Purpose: Apex Test Class for VFP_CRDNewDrugSpecificCopay.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/27/2011       Apex Test Class for VFP_CRDNewDrugSpecificCopay.
======================================================================== 
*/
@isTest
private class TEST_CRDNewDrugSpecificCopay
{       
 static testmethod void testCRDNewDrugSpecificCopay10()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
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
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
        
        }
 static testmethod void testCRDNewDrugSpecificCopay9()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();

         
        //controller.lstDrugSpecificCopayWrapMailItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousStep2();
         controller.lstDrugSpecificCopayWrapMailItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedMailItems();       

         

        }
 static testmethod void testCRDNewDrugSpecificCopay8()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         
         //controller.lstDrugSpecificCopayWrapSpecialityItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousStep2();
         controller.lstDrugSpecificCopayWrapSpecialityItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedSpecialityItems();
         

        }
        
        static testmethod void testCRDNewDrugSpecificCopay8a()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty_OON'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();

         
        //controller.lstDrugSpecificCopayWrapSpecialityItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         
         controller.lstDrugSpecificCopayWrapSpecialtyOONItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         

        }
        
        static testmethod void testCRDNewDrugSpecificCopay8b()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper_Out_of_Network'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();

         
        //controller.lstDrugSpecificCopayWrapSpecialityItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         
         controller.lstDrugSpecificCopayWrapOutOfNetworkItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedSpecialityItems();
         

        }

 static testmethod void testCRDNewDrugSpecificCopay6()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         controller.lstDrugSpecificCopayWrapPaperItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         
         }
         static testmethod void testCRDNewDrugSpecificCopay8c()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;         
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         //String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();

         
        //controller.lstDrugSpecificCopayWrapSpecialityItems = controller.lstDrugSpecificCopayWrapRetailItems;
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousstep2();
         controller.lstDrugSpecificCopayWrapPaperItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedPaperItems();
         

        }
         
     static testmethod void testCRDNewDrugSpecificCopay()
    {
         test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
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
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
       
         controller.populateExistingItems();
         String rtype=controller.getRecordTypeNameByid(rt.Id);
         controller.save();
         controller.previousStep();
         controller.save1();
         controller.previousStep2();
         
         controller.AddNewDrugSpecificRetailItem();
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper retaillist:controller.lstDrugSpecificCopayWrapRetailItems)
         {
             retaillist.isMarkedForDeletion=true;
         }
         controller.lstDrugSpecificCopayWrapRetailItems.get(0).isMarkedForDeletion=true;
         controller.deleteSelectedRetailItems();
         test.StopTest();
        } 
        
        
        
         static testmethod void testCRDNewDrugSpecificCopay2()
        {   
        test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c  drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificMailItem();
         
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper maillist:controller.lstDrugSpecificCopayWrapMailItems)
         {
             maillist.isMarkedForDeletion=true;
         }
         controller.lstDrugSpecificCopayWrapMailItems.get(0).isMarkedForDeletion=true;
        test.stopTest();
        }
        
        
        
        
        static testmethod void testCRDNewDrugSpecificCopay3()
        {   
        test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialityItem();
         
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper speclist:controller.lstDrugSpecificCopayWrapSpecialityItems)
         {
             speclist.isMarkedForDeletion=true;
         }
         controller.lstDrugSpecificCopayWrapSpecialityItems.get(0).isMarkedForDeletion=true;
        test.stopTest();
         }
         
         
         
         
         static testmethod void testCRDNewDrugSpecificCopay4()
        {   
        test.StartTest();
         CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
         }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;     
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;   
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificPaperItem();          
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper paperlist:controller.lstDrugSpecificCopayWrapPaperItems)
         {
             paperlist.isMarkedForDeletion=true;
         }          
              
         controller.saveWrappedList(controller.lstDrugSpecificCopayWrapPaperItems,'Retail');   
         drug=new Drug_Specific_Copay__c();
         rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;    
        
         
         
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificRetailItem();          
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper paperlist:controller.lstDrugSpecificCopayWrapRetailItems)
         {
             paperlist.isMarkedForDeletion=true;
         }               
         controller.lstDrugSpecificCopayWrapRetailItems.get(0).isMarkedForDeletion=true;
         
         controller.saveWrappedList(controller.lstDrugSpecificCopayWrapRetailItems,'Retail');   
         drug=new Drug_Specific_Copay__c();
         rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and Name='Paper Out of Network'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug; 

         
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificOutOfNetworkItem();          
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper paperlist:controller.lstDrugSpecificCopayWrapPaperItems)
         {
             paperlist.isMarkedForDeletion=true;
         }                        
         controller.saveWrappedList(controller.lstDrugSpecificCopayWrapOutOfNetworkItems,'Paper Out of Network');    
         
         //added by JR      

         drug=new Drug_Specific_Copay__c();
         rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and Name='Specialty OON'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug; 

         
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         stdcontroller =new ApexPages.StandardController (testCrd);
         controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificOutOfNetworkItem();          
         for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper paperlist:controller.lstDrugSpecificCopayWrapSpecialtyOONItems)
         {
             paperlist.isMarkedForDeletion=true;
         }                        
         controller.saveWrappedList(controller.lstDrugSpecificCopayWrapSpecialtyOONItems,'Specialty OON'); 
         
         controller.lstDrugSpecificCopayWrapOutOfNetworkItems.get(0).isMarkedForDeletion=true;   
         controller.deleteSelectedROutOfNetworkItems();
         controller.deleteSelectedMailItems();
         controller.deleteSelectedSpecialityItems();
         controller.deleteSelectedPaperItems(); 
          test.stopTest();
    }
    
    static testmethod void test1()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         test.stopTest();      
    }
    
    static testmethod void test1a()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         test.stopTest();      
    }
    
    static testmethod void test1b()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         controller.save1();
         controller.previousStep2();
         test.stopTest();      
    }
    
    static testmethod void test1c()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         test.stopTest();      
    }
    
    static testmethod void test1d()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Paper_Out_of_Network'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         test.stopTest();      
    }
    
    static testmethod void test1e()
    {
        test.startTest();
        CRD__c testCrd=new CRD__c();
         insert testCrd;
         
         GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
         Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
         Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Specialty_OON'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
         Copay_Tier__c mailTier = new Copay_Tier__c();
         mailTier.CRD__c=testCrd.id;  
         mailTier.Stepped_Copay__c=true;
         insert mailTier;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDNewDrugSpecificCoPay')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDNewDrugSpecificCopay controller =new VFP_CRDNewDrugSpecificCopay(stdcontroller);
         controller.save();
         controller.save1();
         controller.previousStep2();
         controller.AddNewDrugSpecificSpecialtyOutOfNetworkItem();
         controller.deleteSelectedSpecialtyOutOfNetworkItems();
         test.stopTest();      
    }
}