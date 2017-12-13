@isTest (seeAllData = true)
Private class TEST_CRDSinglePageController{
    static testmethod void testSinglePage(){
        Test.startTest();
        
        Account testacc= new Account();
        testacc.Name= 'Test account';
        testacc.A_c_Email__c='a@a.com';
        insert testacc;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.crd_automated__c =True;
        testCrd.Offering_Type__c ='CareEngine Powered – Focused Custom';
        testCrd.Account_New_Value__c = testacc.id;
        testCrd.Account__c = testacc.id;
        testCrd.Are_you_creating_a_Package_Plan__c = 'Yes';
        testCrd.Aetna_Healthy_Actions__c = 'Yes';
        testCrd.Plan_Type_Mail__c = True;
        testCrd.Plan_Platform__c ='Traditional/PPO';                   
        insert testCrd;
        
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        Drug_Coverage__c testDrugCoverage = new Drug_Coverage__c();
        testDrugCoverage.CRD_ID__c= testCrd.ID;
        testDrugCoverage.Do_you_have_Choose_Generic__c='No';
        insert testDrugCoverage;
        
        Copay_Tier__c testCopayTier = testdata.createCopayTier(testCrd.id);
        insert testCopayTier ;
        
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
         Recordtype rt1=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt1.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         insert drug;
         
        Accumulations__c acc=new Accumulations__c();
        RecordType rt2=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
        acc.RecordTypeId=rt2.id;
        acc.CRD_ID__c=testCrd.Id;            
        acc.Carry_Balance_when_member_moves__c='yes';
        acc.Deductible_Amount__c=100.0;
        acc.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
        acc.Is_this_an_HDHP_plan__c='No';
        acc.Deductible_Period__c='Month';      
        acc.Are_there_any_drug_specific_deductibles__c=true;
        insert acc;
        
         Network_Junction__c testrec=new Network_Junction__c();
         testrec.Network_Mail__c='test';
         testrec.Network_Specialty__c=null;
         testrec.CRD_ID__c=testCrd.Id;
         insert testrec;
         
         Test.setCurrentPageReference(new PageReference('Page.VF_CRDSinglePageLayout')); 
         System.currentPageReference().getParameters().put('crdid', testCrd.id);
         ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
         VFP_CRDSinglePageController controller =new VFP_CRDSinglePageController(stdcontroller);
         controller.getcongaComposerSinglePage();
        
        Test.stopTest();
    }
}