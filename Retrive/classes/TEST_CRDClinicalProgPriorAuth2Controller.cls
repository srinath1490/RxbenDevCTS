/*Purpose: Apex Test Class for VFP_CRDClinicalProgPriorAuth2Controller.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/23/2011       Apex Test Class for VFP_CRDClinicalProgPriorAuth2Controller.
     2.0     Amit                 8 Oct 2014        Updated as per the class changes
======================================================================== 
*/
@isTest
private class TEST_CRDClinicalProgPriorAuth2Controller
{
    
    static testmethod void testCRDClinicalProgPriorAuth2Controller()
    {
            Id RetailRecordTypeId = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId(); 
            Id MailRecordTypeId = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();  
            CRD__c testCrd=new CRD__c(); 
            testCrd.Insured_Type__c = 'Fully Insured'; 
            testCrd.Plan_Type_Retail__c = True;
            testCrd.Plan_Type_Mail__c= True;
            testCrd.NPL_Applies__c = 'Yes';
            insert testCrd;
        
        Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Formulary_Open_Closed__c = 'open';
            frm.Termination_Date__c =system.today() +7;
            insert frm;
            string dcfrm = frm.Formulary_Open_Closed__c;      
            Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
            drugCoverateItem.Formulary__c=frm.id;
            drugCoverateItem.CRD_ID__c = testCrd.id;
            drugCoverateItem.RecordTypeId=RetailRecordTypeId;
            drugCoverateItem.Force_to_Specialty__c = 'none'; 
            drugCoverateItem.Formulary_Open_Closed__c = 'open';
            insert drugCoverateItem;
            
         Drug_Coverage__c drugCoverateItem2=new Drug_Coverage__c();
            
            drugCoverateItem2.CRD_ID__c = testCrd.id;
            drugCoverateItem2.RecordTypeId=MailRecordTypeId;
            drugCoverateItem2.Choose_Generic_Copay_Diff_Exclusion__c='No';
            drugCoverateItem2.Force_to_Specialty__c = 'none'; 
            drugCoverateItem2.Formulary_Open_Closed__c = 'open';
            insert drugCoverateItem2;
            Drug_List__c dlist = new Drug_List__c();
            insert dlist;
        
            CRD_NPL_Junction__c npl = new CRD_NPL_Junction__c();
            npl.crd_id__c = testCrd.id;
            npl.IsStandard__c = True;
            npl.Drug_List__c = dlist.id;
            insert npl;
            
             Drug_List__c dlist2 = new Drug_List__c();
            dlist2.standard__c = True;
            insert dlist2;
            
            Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgPriorAuth2')); 
            System.currentPageReference().getParameters().put('id', testCrd.id);
            System.currentPageReference().getParameters().put('currentPageName', 'clinicalProg');
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_CRDClinicalProgPriorAuth2Controller controller =new VFP_CRDClinicalProgPriorAuth2Controller(stdcontroller);
            controller.displayDrugList();
            controller.validateNonOptEdits();
            controller.addNewItem();
           
        
            CRD_NPL_Junction__c npl2 = new CRD_NPL_Junction__c();
            npl2.crd_id__c = testCrd.id;
            npl2.Drug_List__c = dlist2.id;
            npl2.Select__c = True;
            insert npl2;
            
            controller.nextButton();
            controller.backButton();
            
            controller.populateDrugListData();
            controller.deleteJunctionObjetRecords();
        
            testCrd.Insured_Type__c = 'Self Insured';
            update testCrd;
            controller.getNPLreRender();
            controller.setNPLreRender();
            controller.nextButton2();
            controller.backButton2();
            controller.displayDrugList();
    }
    static testmethod void testCRDClinicalProgPriorAuth2Controller1()
    {
            Drug_List__c dlist = new Drug_List__c();
            dlist.standard__c = False;
            insert dlist;
            CRD__c testCrd=new CRD__c(); 
            testCrd.Plan_Platform__c = 'Aetna Global Benefits';
            testCrd.Opt_out_of_Rx_OTC_Edit__c = True;
            testCrd.NPL_Applies__c = 'No';
            testCrd.NPL_Drug_List__c = dlist.id;
            insert testCrd;
        
            
            
            Drug_List__c dlist2 = new Drug_List__c();
            dlist2.standard__c = True;
            insert dlist2;
        
            CRD_NPL_Junction__c npl = new CRD_NPL_Junction__c();
            npl.crd_id__c = testCrd.id;
            npl.Drug_List__c = dlist.id;
            insert npl;
            
            CRD_NPL_Junction__c npl2 = new CRD_NPL_Junction__c();
            npl2.crd_id__c = testCrd.id;
            npl2.Drug_List__c = dlist2.id;
            npl2.Select__c = True;
            insert npl2;
        
            Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgPriorAuth2')); 
            System.currentPageReference().getParameters().put('id', testCrd.id);
            System.currentPageReference().getParameters().put('currentPageName', 'clinicalProg');
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_CRDClinicalProgPriorAuth2Controller controller =new VFP_CRDClinicalProgPriorAuth2Controller(stdcontroller);            
            controller.backButton();
            controller.getNPLreRender();
            controller.setNPLreRender();
            controller.nextButton2();
            controller.backButton2();
            controller.displayDrugList();
    }
    static testmethod void testCRDClinicalProgPriorAuth2Controller3()
    {
            Id RetailRecordTypeId = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId(); 
            Id MailRecordTypeId = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();  
            CRD__c testCrd=new CRD__c(); 
            testCrd.Insured_Type__c = 'Fully Insured'; 
            testCrd.Plan_Type_Retail__c = True;
            testCrd.Plan_Type_Mail__c= True;
            testCrd.NPL_Applies__c = 'Yes';
            insert testCrd;
            
            CRD__c testCrd2=new CRD__c(); 
            testCrd2.Insured_Type__c = 'Self Insured'; 
            testCrd2.Plan_Type_Retail__c = True;
            testCrd2.Plan_Type_Mail__c= True;
            testCrd2.NPL_Applies__c = 'Yes';
            insert testCrd2;
            
            Test.setCurrentPageReference(new PageReference('Page.VF_CRDClinicalProgPriorAuth2')); 
            System.currentPageReference().getParameters().put('id', testCrd.id);
            System.currentPageReference().getParameters().put('currentPageName', 'clinicalProg');
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (testCrd);
            VFP_CRDClinicalProgPriorAuth2Controller controller =new VFP_CRDClinicalProgPriorAuth2Controller(stdcontroller);            
            controller.backButton();
            controller.getNPLreRender();
            controller.setNPLreRender();
            controller.nextButton2();
            controller.backButton2();
            controller.displayDrugList();
            
     }
}