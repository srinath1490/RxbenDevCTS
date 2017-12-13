/*Purpose: Apex Test Class for VFP_CRDStepTherepyController.
========================================================================
History                                                           
-------                                                          
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -   Anuj                 10/23/2011       Apex Test Class for VFP_CRDStepTherepyController.
2.1     Bhaskar Arora        03/11/2016       Worked on the code coverage  Request 06731
======================================================================== 
*/
@isTest
private class TEST_CRDStepTherepyController
{
    
    private static testmethod void testCRDStepTherepyController()
    {
        CRD__c testCrd1=new CRD__c(); 
        testCrd1.Custom_Step_Therapy_Classes__c='No';  
        testCrd1.Insured_Type__c = 'self insured';
        testCrd1.Contract_State__c='AK';
        insert testCrd1;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.Custom_Step_Therapy_Classes__c='No';  
        testCrd.Insured_Type__c = 'self insured';
        testCrd.Clone_from_which_CRD__c=testCrd1.id;
        testCrd.Contract_State__c='AK';
        insert testCrd;
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Step Therapy'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        
        ST_PA_QL_Auto_Populate__c stPA = new ST_PA_QL_Auto_Populate__c();
        RecordType rt1=[select Id from RecordType where name='Step Therapy' limit 1];
        stPA.Record_Type__c='Step Therapy';
        stPA.Contract_State__c = 'IL';
        stPA.What_is_the_Funding_Type__c = 'Fully Insured';
        stPA.Drug_List__c = drug.Id;
        insert stPA;
        
        
        CRD_Step_Therapy_Junction__c newstepobj=new CRD_Step_Therapy_Junction__c ();
        newstepobj.CRD_ID__c =testCrd.Id;
        newstepobj.Step_Therapy_DrugList_Class__c=drug.Id;
        insert newstepobj;
        
        Test.startTest();
        PageReference CRDStepTherapy = Page.VF_CRDStepTherepy;
        CRDStepTherapy.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(CRDStepTherapy); 
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDStepTherepyController controller =new VFP_CRDStepTherepyController(stdcontroller);
        controller.addJunctionObjetRecord();
        controller.populateDrugListData();
        controller.saveDetails();
        //controller.setMandatoryFields();
        controller.deleteJunctionObjetRecords();
        controller.redirectToClinicalProg();
        
        testCrd.Do_you_want_to_do_Step_Therapy__c='Yes';
        testCrd.Insured_Type__c = 'Fully insured';
        update testCrd;
        
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        // Formulary 
        Formulary__c F=testdata.newFormulary();
        F.Formulary_Name__c = 'Test_GMFBuilderUtilF1';
        F.Formulary_Description__c ='Test_GMFBuilderUtilF1';insert F;
        controller.isStepTherapyNeeded();
        
        Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = testCrd.id;
        dc.RecordTypeId = dcId;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'Yes';
        dc.of_fills_before_force_to_specialty__c = 2;
        dc.Do_you_have_Specialty__c = 'Yes';
        dc.Formulary__c=F.id;
        insert dc;
        Drug_List__c DL=[select id,name from Drug_List__c where id=:drug.id limit 1];
        FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
        objform.precert__c = 'precert';
        objForm.Quantity_Limit__c = 'ql';
        objform.Step_Therapy__c = string.valueof(DL.Name);
        objForm.Save_A_Copay__c = 'sac';
        objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
        objform.Formulary__c=F.id;
        insert objform;
        
        ST_PA_QL_Auto_Populate__c stpaqllist = new ST_PA_QL_Auto_Populate__c();
        stpaqllist.name = 'test';
        stpaqllist.Record_Type__c='Step Therapy';
        stpaqllist.What_is_the_Funding_Type__c = 'self insured';
        stpaqllist.Contract_State__c='AK';
        stpaqllist.Drug_List__c=Drug.id;
        insert stpaqllist;
        
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDStepTherepyController(stdcontroller);
        controller.inIt();
        controller.addJunctionObjetRecord();
        controller.saveDetails();
        controller.crd.Custom_Step_Therapy_Classes__c='Yes';
        //controller.setMandatoryFields(); 
        Controller.crd=new CRD__c();
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDStepTherepyController(stdcontroller);
        controller.crd.Standard_Program_or_Select_Classes__c = 'Select Classes';
        controller.saveDetails(); 
        controller.isStepTherapyNeeded();
        VFP_CRDStepTherepyController.WrapperJunctionObjetRecord testinstance  = new VFP_CRDStepTherepyController.WrapperJunctionObjetRecord();
        testinstance  .selected = false;
        testinstance.crdAuthJunction = new CRD_Step_Therapy_Junction__c();
        controller.listWrapperJunctionObjetRecord.add(testinstance  );
        //controller.deleteJunctionObjetRecords();
        Controller.crd.Insured_Type__c = 'Fully Insured';
        Controller.crd.Contract_State__c = 'IL'; 
        Controller.crd.Do_you_want_to_do_Step_Therapy__c='Yes';
        Controller.crd.Standard_Program_or_Select_Classes__c = 'ST Drug List(s)';
        controller.isStepTherapyNeeded(); 
        VFP_CRDStepTherepyController.WrapperJunctionObjetRecord testinstance1  = new VFP_CRDStepTherepyController.WrapperJunctionObjetRecord();
        testinstance1  .selected = false;
        testinstance1.crdAuthJunction = new CRD_Step_Therapy_Junction__c();                      
        controller.listWrapperJunctionObjetRecord.add(testinstance1  );
        // controller.wrapperId.add(testcrd.id);
        Controller.saveDetails()    ;          
        // controller.listWrapperJunctionObjetRecord[0].crdAuthJunction = null                       ;
        controller.listWrapperJunctionObjetRecord[0].crdAuthJunction.Step_Therapy_DrugList_Class__c = testcrd.id;
        Controller.saveDetails()    ; 
        Controller.saveDetails2();
        Controller.redirectToClinicalProg2();
        Test.stopTest();
    }
    private static testmethod void testCRDStepTherepyController2()
    {
        CRD__c testCrd1=new CRD__c(); 
        testCrd1.Custom_Step_Therapy_Classes__c='No';  
        testCrd1.Insured_Type__c = 'self insured';
        testCrd1.Contract_State__c='AK';
        testCrd1.Do_you_want_to_do_Step_Therapy__c='Yes';
        insert testCrd1;
        
        CRD__c testCrd=new CRD__c(); 
        testCrd.Custom_Step_Therapy_Classes__c='No';  
        testCrd.Insured_Type__c = 'self insured';
        testCrd.Clone_from_which_CRD__c=testCrd1.id;
        testCrd.Contract_State__c='AK';
        testCrd.Do_you_want_to_do_Step_Therapy__c='Yes';
        insert testCrd;
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Step Therapy'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        
        ST_PA_QL_Auto_Populate__c stPA = new ST_PA_QL_Auto_Populate__c();
        RecordType rt1=[select Id from RecordType where name='Step Therapy' limit 1];
        stPA.Record_Type__c='Step Therapy';
        stPA.Contract_State__c = 'IL';
        stPA.What_is_the_Funding_Type__c = 'Fully Insured';
        stPA.Drug_List__c = drug.Id;
        insert stPA;
        
        
        CRD_Step_Therapy_Junction__c newstepobj=new CRD_Step_Therapy_Junction__c ();
        newstepobj.CRD_ID__c =testCrd.Id;
        newstepobj.Step_Therapy_DrugList_Class__c=drug.Id;
        insert newstepobj;
        
        Test.startTest();
        PageReference CRDStepTherapy = Page.VF_CRDStepTherepy;
        CRDStepTherapy.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(CRDStepTherapy); 
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDStepTherepyController controller =new VFP_CRDStepTherepyController(stdcontroller);
        controller.addJunctionObjetRecord();
        controller.populateDrugListData();
        controller.saveDetails();
        //controller.setMandatoryFields();
        controller.deleteJunctionObjetRecords();
        controller.redirectToClinicalProg();
        
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        // Formulary 
        Formulary__c F=testdata.newFormulary();
        F.Formulary_Name__c = 'Test_GMFBuilderUtilF1';
        F.Formulary_Description__c ='Test_GMFBuilderUtilF1';insert F;
        controller.isStepTherapyNeeded();
        Test.stopTest();
    }
}