/*Purpose: Apex Test Class for VFP_CRDQuantityLimitsController.
========================================================================
History                                                           
-------                                                          
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -   Anuj                 10/23/2011       Apex Test Class for VFP_CRDQuantityLimitsController.
======================================================================== 
*/
@isTest
private class TEST_CRDQuantityLimitsController
{
    
    static testmethod void testCRDQuantityLimitsController()
    {
        CRD__c testCrd1=new CRD__c(); 
        testCrd1.Custom_Step_Therapy_Classes__c='No';  
        testCrd1.Insured_Type__c = 'self insured';
        testCrd1.Contract_State__c='AK';
        testCrd1.Do_you_want_to_do_Precert__c='Yes';
        insert testCrd1;
        
        CRD__c testCrd=new CRD__c();  
        testCrd.Clone_from_which_CRD__c=testCrd1.id;
         testCrd.Do_you_want_to_do_Precert__c='Yes';
        insert testCrd;
        
        
        
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        //Option code
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = 'PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        
        // Formulary 
        Formulary__c F=testdata.newFormulary();
        F.Formulary_Name__c = 'Test_GMFBuilderUtilF1';
        F.Formulary_Description__c ='Test_GMFBuilderUtilF1';
        F.Option_Code__c=oc.id;
        insert F;
         
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
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Quantity Limit'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        Drug_List__c drug2=new Drug_List__c();
        drug2.Inactive__c=false;
        drug2.RecordTypeId=rt.Id;
        drug2.Clinical_Edit_Code__c='1';
        drug2.Special_Use__c='Save-A-Copay';
        drug2.Standard__c=true;
        insert drug2;
        
        Drug_List__c DL=[select id,name from Drug_List__c where id=:drug.id limit 1];
        
        FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
        objform.precert__c = 'precert';
        objForm.Quantity_Limit__c = string.valueof(DL.Name);
        objform.Step_Therapy__c = string.valueof(DL.Name);
        objForm.QL_Safety_Edits__c=drug2.id;
        objForm.Save_A_Copay__c = 'sac';
        objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
        objform.Formulary__c=F.id;
        insert objform;
        
        CRD_Quantity_Limit_Junction__c obj=new CRD_Quantity_Limit_Junction__c ();
        obj.CRD_ID__c=testCrd.Id;
        obj.QL_Class__c=drug.id;
        insert obj;
        //
        PageReference CRDQuantityLimit = Page.VF_CRDQuantityLimits;
        CRDQuantityLimit.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(CRDQuantityLimit);
        System.currentPageReference().getParameters().put('currentPageName', 'clientInfo');
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDQuantityLimitsController controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.deleteSelectedQl();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        
        testCrd=new CRD__c();
        testCrd.Standard_QL_List_or_Select_Classes__c='Select Classes';
        testCrd.Are_there_Quantity_Limits__c='Yes';
        insert testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        testCrd.Standard_QL_List_or_Select_Classes__c='Standard Program';
        Drug_Group__c tempDrugGroup = new  Drug_Group__c();
        tempDrugGroup =testData.createDrugGroup();
        insert tempDrugGroup ;          
        testCrd.Standard_QL_Program__c=tempDrugGroup .id;
        update testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        controller.ReturnToCrdPriorAuth();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.crd.Standard_QL_List_or_Select_Classes__c= 'Standard Program1';
        controller.saveQuantityLimits();
        
        controller.crd.Are_there_Quantity_Limits__c='Yes';
        controller.crd.Standard_QL_List_or_Select_Classes__c = 'Select Classes';
        controller.ReturnToCrdPriorAuth();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        controller.areQuantityLimitsNeeded();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.ReturnToCrdPriorAuth();
        controller.returnToCrdPriorAuth2();
        controller.saveQuantityLimits2();
    }
    static testmethod void testCRDQuantityLimitsController2()
    {
        CRD__c testCrd=new CRD__c();
        testCrd.Are_there_Quantity_Limits__c='No';
        insert testCrd;
        
        CRD_Quantity_Limit_Junction__c obj=new CRD_Quantity_Limit_Junction__c ();
        obj.CRD_ID__c=testCrd.Id;
        insert obj;
        
        PageReference CRDQuantityLimit = Page.VF_CRDQuantityLimits;
        CRDQuantityLimit.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(CRDQuantityLimit);
        System.currentPageReference().getParameters().put('currentPageName', 'clientInfo');
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDQuantityLimitsController controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.deleteSelectedQl();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        
        testCrd=new CRD__c();
        testCrd.Standard_QL_List_or_Select_Classes__c='Select Classes';
        testCrd.Are_there_Quantity_Limits__c='No';
        insert testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        testCrd.Standard_QL_List_or_Select_Classes__c='Standard Program';
        GC_UtilityClassTestData testData= new GC_UtilityClassTestData(); 
        Drug_Group__c tempDrugGroup = new  Drug_Group__c();
        tempDrugGroup =testData.createDrugGroup();
        insert tempDrugGroup ;          
        testCrd.Standard_QL_Program__c=tempDrugGroup .id;
        update testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        controller.ReturnToCrdPriorAuth();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.crd.Standard_QL_List_or_Select_Classes__c= 'Standard Program1';
        controller.saveQuantityLimits();
        //controller.crd.Are_there_Quantity_Limits__c='Yes';
        controller.crd.Standard_QL_List_or_Select_Classes__c = 'Select Classes';
        controller.ReturnToCrdPriorAuth();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        controller.areQuantityLimitsNeeded();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.ReturnToCrdPriorAuth();
        controller.returnToCrdPriorAuth2();
        controller.saveQuantityLimits2();
        
    }
    static testmethod void testCRDQuantityLimitsController3()
    {
        CRD__c testCrd1=new CRD__c(); 
        testCrd1.Custom_Step_Therapy_Classes__c='Yes';  
        testCrd1.Insured_Type__c = 'self insured';
        testCrd1.Contract_State__c='AK';
        testCrd1.Do_you_want_to_do_Precert__c='Yes';
        insert testCrd1;
        
        CRD__c testCrd=new CRD__c();  
        testCrd.Clone_from_which_CRD__c=testCrd1.id;
         testCrd.Do_you_want_to_do_Precert__c='Yes';
        testCrd.Custom_Step_Therapy_Classes__c='Yes'; 
        testCrd.Insured_Type__c = 'self insured';
         testCrd.Contract_State__c='AK';
        insert testCrd;
        
        
        
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        //Option code
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = 'PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        
        // Formulary 
        Formulary__c F=testdata.newFormulary();
        F.Formulary_Name__c = 'Test_GMFBuilderUtilF1';
        F.Formulary_Description__c ='Test_GMFBuilderUtilF1';
        F.Option_Code__c=oc.id;
        insert F;
         
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
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Quantity Limit'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        Drug_List__c drug2=new Drug_List__c();
        drug2.Inactive__c=false;
        drug2.RecordTypeId=rt.Id;
        drug2.Clinical_Edit_Code__c='1';
        drug2.Special_Use__c='Save-A-Copay';
        drug2.Standard__c=true;
        insert drug2;
        
        Drug_List__c DL=[select id,name from Drug_List__c where id=:drug.id limit 1];
        
        FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
        objform.precert__c = 'precert';
        objForm.Quantity_Limit__c ='Test';// string.valueof(DL.Name);
        objform.Step_Therapy__c = string.valueof(DL.Name);
        objForm.QL_Safety_Edits__c=drug2.id;
        objForm.Save_A_Copay__c = 'sac';
        objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
        objform.Formulary__c=F.id;
        insert objform;
        
        CRD_Quantity_Limit_Junction__c obj=new CRD_Quantity_Limit_Junction__c ();
        obj.CRD_ID__c=testCrd.Id;
        obj.QL_Class__c=drug.id;
        insert obj;
        
        ST_PA_QL_Auto_Populate__c stpaqllist = new ST_PA_QL_Auto_Populate__c();
        stpaqllist.name = 'test';
        stpaqllist.Record_Type__c='Quantity Limit';
        stpaqllist.What_is_the_Funding_Type__c = 'self insured';
        stpaqllist.Contract_State__c='AK';
        stpaqllist.Drug_List__c=drug.id;
        insert stpaqllist;
        //
        PageReference CRDQuantityLimit = Page.VF_CRDQuantityLimits;
        CRDQuantityLimit.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(CRDQuantityLimit);
        System.currentPageReference().getParameters().put('currentPageName', 'clientInfo');
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDQuantityLimitsController controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.deleteSelectedQl();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        
        testCrd=new CRD__c();
        testCrd.Standard_QL_List_or_Select_Classes__c='Select Classes';
        testCrd.Are_there_Quantity_Limits__c='Yes';
        insert testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        testCrd.Standard_QL_List_or_Select_Classes__c='Standard Program';
        Drug_Group__c tempDrugGroup = new  Drug_Group__c();
        tempDrugGroup =testData.createDrugGroup();
        insert tempDrugGroup ;          
        testCrd.Standard_QL_Program__c=tempDrugGroup .id;
        update testCrd;
        stdcontroller =new ApexPages.StandardController (testCrd);
        controller =new VFP_CRDQuantityLimitsController(stdcontroller);
        controller.AddNewQl();
        controller.saveQuantityLimits();
        controller.ReturnToCrdPriorAuth();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.crd.Standard_QL_List_or_Select_Classes__c= 'Standard Program1';
        controller.saveQuantityLimits();
        
        controller.crd.Are_there_Quantity_Limits__c='Yes';
        controller.crd.Standard_QL_List_or_Select_Classes__c = 'Select Classes';
        controller.ReturnToCrdPriorAuth();
        controller.saveQuantityLimits();
        controller.showLowerPanel();
        controller.areQuantityLimitsNeeded();
        controller.crd.Are_there_Quantity_Limits__c='No';
        controller.ReturnToCrdPriorAuth();
        controller.returnToCrdPriorAuth2();
        controller.saveQuantityLimits2();
    }
}