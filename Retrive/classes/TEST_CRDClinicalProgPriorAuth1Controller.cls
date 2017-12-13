/*Purpose: Apex Test Class for VFP_CRDClinicalProgPriorAuth1Controller.
========================================================================
History                                                           
-------                                                          
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -   Anuj                 10/23/2011       Apex Test Class for VFP_CRDClinicalProgPriorAuth1Controller.
======================================================================== 
*/
@isTest
private class TEST_CRDClinicalProgPriorAuth1Controller
{
    
    static testmethod void testCRDClinicalProgPriorAuth1Controller()
    {
        
        Drug_Group__c tempDrugGroup = new  Drug_Group__c();    
        tempDrugGroup.Drug_Group_Name__c= 'Test';
        tempDrugGroup.Description__c = 'description'; 
        tempDrugGroup.Standard__c = true;
        tempDrugGroup.LastSent__c = system.now();
        tempDrugGroup.Effective_Date__c = system.today();
        tempDrugGroup.Termination_Date__c = system.today()+7;
        insert tempDrugGroup ;
        
        CRD__c testCrd=new CRD__c();  
        testcrd.Standard_Precert_List_or_Select_Classes__c = 'PA Drug Group';
        testCrd.Custom_Step_Therapy_Classes__c='No';  
        testCrd.Insured_Type__c = 'Self Insured';
        testCrd.Standard_Precert_Program__c = tempDrugGroup.id;
        testcrd.Is_there_split_fill__c='Yes';
        testCrd.Do_you_want_to_do_Step_Therapy__c='No';
        testCRD.Precert_TOC_days__c=3;
        testCRD.Contract_State__c = 'IL';
        insert testCrd;
        
        //----
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        
        //Option code
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = 'PRM';
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
        dc.Allow_Transition_Fill__c='Yes';
        dc.Transition_Fill_Number_of_Days__c =2;
        insert dc;   
        //----
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Prior Authorization'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        Drug_List__c DL=[select id,name from Drug_List__c where id=:drug.id limit 1];
        
        FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
        objform.precert__c = string.valueof(DL.Name);
        objForm.Quantity_Limit__c = string.valueof(DL.Name);
        objform.Step_Therapy__c = string.valueof(DL.Name);
        //objForm.QL_Safety_Edits__c=drug2.id;
        objForm.PR_Safety_Edits__c=DL.id;
        objForm.Save_A_Copay__c = 'sac';
        objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
        objform.Formulary__c=F.id;
        insert objform;
        
        CRD_PriorAuth_Junction__c newobj=new CRD_PriorAuth_Junction__c();
        newobj.CRD_ID__c=testCrd.Id;
        newobj.IsAutoPopulated__c = true;
        newobj.Precert_Class__c = drug.Id;
        insert newobj;
        
        List<ST_PA_QL_Auto_Populate__c> stList = new List<ST_PA_QL_Auto_Populate__c>();
        
        ST_PA_QL_Auto_Populate__c stPA = new ST_PA_QL_Auto_Populate__c();
        stPA.Record_Type__c='Precert';
        stPA.Contract_State__c = 'IL';
        stPA.What_is_the_Funding_Type__c = 'Self Insured';
        stPA.Drug_List__c = drug.Id;
        stList.add(stPA);
        insert stList;
        
        Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgPriorAuth1')); 
        //System.currentPageReference().getParameters().put('crdid', testCrd.id);
        System.currentPageReference().getParameters().put('currentPageName', 'clientInfo');
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDClinicalProgPriorAuth1Controller controller =new VFP_CRDClinicalProgPriorAuth1Controller(stdcontroller);
        controller.redirectToStepTherepy();
        controller.redirectToClinicalProgPriorAuth2();
        controller.AddNewUser();
        controller.deleteSelectedUser();
        controller.updatefields();
        controller.crd.Do_you_want_to_do_Precert__c='No';
        controller.crd.Standard_Precert_List_or_Select_Classes__c='Select Classes';
        controller.crd.Custom_Precert_Classes__c='Yes';
        controller.crd.Custom_Precert_Date_Approved__c=null;
        
        controller.redirectToClinicalProgPriorAuth2();
        controller.crd.Approved_from_CustFormulary_Committee_PA__c=false;
        controller.redirectToClinicalProgPriorAuth2();
        controller.crd.Custom_Precert_Classes__c=null;
        
        
        controller.redirectToClinicalProgPriorAuth2();
        controller.isprecertneeded();
        controller.crd.Approved_from_CustFormulary_Committee_PA__c=true;
        controller.updatefields();
        controller.webPriorAuthUsers.clear();
        controller.crd.Insured_Type__c='Fully Insured';
        controller.crd.contract_state__c='IL';
        controller.crd.Do_you_want_to_do_Precert__c='Yes';
        controller.isPrecertNeeded();
        controller.redirectToStepTherepy2();
        controller.redirectToClinicalProgPriorAuth22();
    }
    static testmethod void testCRDClinicalProgPriorAuth1Controller1()
    {
        Drug_Group__c tempDrugGroup = new  Drug_Group__c();    
        tempDrugGroup.Drug_Group_Name__c= 'Test';
        tempDrugGroup.Description__c = 'description'; 
        tempDrugGroup.Standard__c = true;
        tempDrugGroup.LastSent__c = system.now();
        tempDrugGroup.Effective_Date__c = system.today();
        tempDrugGroup.Termination_Date__c = system.today()+7;
        insert tempDrugGroup ;
        
        CRD__c testCrd=new CRD__c();  
        testcrd.Standard_Precert_List_or_Select_Classes__c = 'PA Drug Group';
        testCrd.Custom_Step_Therapy_Classes__c='Yes';  
        testCrd.Insured_Type__c = 'Fully insured';
        testCrd.Standard_Precert_Program__c = tempDrugGroup.id;
        testCRD.Standard_Precert_List_or_Select_Classes__c='PA Drug List(s)';
        testCRD.Do_you_want_to_do_Precert__c='Yes';
        insert testCrd;
        
        List<CRD_PriorAuth_Junction__c> newobj=new List<CRD_PriorAuth_Junction__c>();
        
        
        Drug_List__c drug=new Drug_List__c();
        drug.Inactive__c=false;
        RecordType rt=[select Id from RecordType where Sobjecttype='Drug_List__c' and name='Step Therapy'];
        drug.RecordTypeId=rt.Id;
        drug.Clinical_Edit_Code__c='1';
        drug.Special_Use__c='Save-A-Copay';
        drug.Standard__c=true;
        insert drug;
        
        
        
        List<ST_PA_QL_Auto_Populate__c> stList = new List<ST_PA_QL_Auto_Populate__c>();
        
        ST_PA_QL_Auto_Populate__c stPA = new ST_PA_QL_Auto_Populate__c();
        stPA.Record_Type__c='Precert';
        stPA.Contract_State__c = 'IL';
        stPA.What_is_the_Funding_Type__c = 'Fully Insured';
        stPA.Drug_List__c = drug.Id;
        stList.add(stPA);
        insert stList;
        
        Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgPriorAuth1')); 
        //System.currentPageReference().getParameters().put('crdid', testCrd.id);
        System.currentPageReference().getParameters().put('currentPageName', 'clientInfo');
        ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
        VFP_CRDClinicalProgPriorAuth1Controller controller =new VFP_CRDClinicalProgPriorAuth1Controller(stdcontroller);
        controller.redirectToStepTherepy();
        controller.redirectToClinicalProgPriorAuth2();
        controller.AddNewUser();
        controller.deleteSelectedUser();
        
        controller.crd.Do_you_want_to_do_Precert__c='Yes';
        controller.crd.Standard_Precert_List_or_Select_Classes__c='PA Drug List(s)';
        controller.crd.Custom_Precert_Classes__c='Yes';
        controller.crd.Custom_Precert_Date_Approved__c=null;
        
        controller.redirectToClinicalProgPriorAuth2();
        controller.crd.Approved_from_CustFormulary_Committee_PA__c=false;
        controller.redirectToClinicalProgPriorAuth2();
        controller.crd.Custom_Precert_Classes__c=null;
        
        controller.redirectToClinicalProgPriorAuth2();
        controller.isprecertneeded();
        controller.crd.Approved_from_CustFormulary_Committee_PA__c=true;
        controller.updatefields();  
        controller.redirectToStepTherepy2();
        controller.redirectToClinicalProgPriorAuth22();
        
    }
    
}