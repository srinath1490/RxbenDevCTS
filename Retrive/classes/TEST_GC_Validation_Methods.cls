@isTest
private class TEST_GC_Validation_Methods
{
     private static testMethod void testvalidateAccums4thQuarter(){
        List<Formulary_List_Entry__c> list_form_list = new List<Formulary_List_Entry__c>();
        GC_Validation_Methods util = new GC_Validation_Methods();
        list_form_list.add(new Formulary_List_Entry__c(Effective_Date__c=date.newinstance(2014,8,11), Termination_Date__c=date.newinstance(2015,1,2)));
        list_form_list.add(new Formulary_List_Entry__c(Effective_Date__c=date.newinstance(2014,9,10), Termination_Date__c=date.newinstance(2015,2,9)));
        list_form_list.add(new Formulary_List_Entry__c(Effective_Date__c=date.newinstance(2013,8,11), Termination_Date__c=date.newinstance(2014,1,2)));
        list_form_list.add(new Formulary_List_Entry__c(Effective_Date__c=date.newinstance(2010,8,11), Termination_Date__c=date.newinstance(2013,6,2)));
        util.validateAccums4thQuarter(new Accumulations__c(Deductible_Amount__c = 123));
        util.formularyDateRangeValid(list_form_list);
        //VFP_DrugListController.wrapperclass dlc = new VFP_DrugListController.wrapperclass();
        List<VFP_DrugListController.wrapperclass> dlc = new List<VFP_DrugListController.wrapperclass>();
        util.validateNDC(dlc);

    }
    
    static testMethod void testGCValidationMethods()
    {
        try
        {
        List<Copay_Tier__c> list_copaytiers = new List<Copay_Tier__c>();
        List<SteppedCopay__c> list_SteppedCopay= new List<SteppedCopay__c>();                  
        List<Drug_Specific_Stepped_Copay__c> list_drugspecificcopay = new List<Drug_Specific_Stepped_Copay__c>();
        
        Full_Control_Group__c FCG = new Full_Control_Group__c();
        insert FCG;
                
        CRD__c testCrd=new CRD__c();
        testCrd.Full_Control_Group__c = FCG.id;
        testCrd.PA_Disease_Vendor_1__c = null;
        testCrd.Client_Contact_Phone__c='1234567890';
        insert testCrd;
                        
        Copay_Tier__c copayTier1 = new Copay_Tier__c();       
        copayTier1.CRD__c = testCrd.id;
        copayTier1.tier_type__c='Brand (SSB & MSB)';
        insert  copayTier1;  

        Copay_Tier__c copayTier2 = new Copay_Tier__c();       
        copayTier2.CRD__c = testCrd.id;
        copayTier2.tier_type__c='Generic (SSG & MSG)';
        copayTier2.Percent__c=20;
        copayTier2.Copay_Calc__c=null;
        insert  copayTier2; 
        
        Copay_Tier__c copayTier3 = new Copay_Tier__c();       
        copayTier3.CRD__c = testCrd.id;
        copayTier3.tier_type__c='Specialty (Preferred & Non-Preferred)';
        copayTier3.Dollar_Amount__c=20;
        copayTier3.Percent__c=20;
        copayTier3.Copay_Calc__c='test';
        insert  copayTier3;   

        list_copaytiers.add(copayTier1);
        list_copaytiers.add(copayTier2);
        //list_copaytiers.add(copayTier3);

        SteppedCopay__c steppedCopay1 = new SteppedCopay__c();
        steppedCopay1.Copay_Tier__c = copayTier1.id;
        insert SteppedCopay1;

        SteppedCopay__c steppedCopay2 = new SteppedCopay__c();
        steppedCopay2.Copay_Tier__c = copayTier1.id;
        insert SteppedCopay2;

        list_SteppedCopay.add(steppedCopay1);
        list_SteppedCopay.add(steppedCopay2);

        Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
        drugSCopay.CRD_ID__c =  testCrd.id;  
        insert drugSCopay; 
        
        Drug_Specific_Stepped_Copay__c drugSSteppedCopay1 = new Drug_Specific_Stepped_Copay__c();
        drugSSteppedCopay1.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
        drugSSteppedCopay1.Dollar_Amount__c=10;
        insert drugSSteppedCopay1; 
        
        Drug_Specific_Stepped_Copay__c drugSSteppedCopay2 = new Drug_Specific_Stepped_Copay__c();
        drugSSteppedCopay2.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
        drugSSteppedCopay2.Dollar_Amount__c=10;
        insert drugSSteppedCopay2;
        
        list_drugspecificcopay.add(drugSSteppedCopay1); 
        list_drugspecificcopay.add(drugSSteppedCopay2); 
        
        Drug_Coverage__c drugCoverage = new Drug_Coverage__c();
        drugCoverage.CRD_ID__c=testCrd.id;  
        drugCoverage.Do_you_have_Choose_Generic__c='Yes';
        drugCoverage.Choose_Generic_Copay_Diff_Exclusion__c='Not elected';
        insert drugCoverage;
        
        Drug_List__c dl =new Drug_List__c();
        dl.Standard__c=true;
        dl.Inactive__c=false;       
        dl.Description__c='tyest';    
        insert dl;
        
        //rmulary__c formuilaryList = new Formulary__c();
        //sert formuilaryList;
        
        
        
    
        
        Drug_List_Criteria__c objDrugListCriteria=new Drug_List_Criteria__c();
        List<Drug_List_Criteria__c> lstDrugListCriteria=new List<Drug_List_Criteria__c>();
        objDrugListCriteria.Term__c = System.today()+7;
        objDrugListCriteria.Drug_List__c=dl.id;
        objDrugListCriteria.Effective__c=system.today();
        lstDrugListCriteria.add(objDrugListCriteria);
        Drug_List_Criteria__c objDrugListCriteria1=new Drug_List_Criteria__c();
        objDrugListCriteria1.Term__c = System.today()+8;
        objDrugListCriteria1.Drug_List__c=dl.id;
        objDrugListCriteria1.Effective__c=system.today();
        lstDrugListCriteria.add(objDrugListCriteria1);
        database.insert(lstDrugListCriteria);

        /*CVS_Web_Access_Users__c webUsers1 = new CVS_Web_Access_Users__c();
        webUsers1.Last_4_digits_of_SSN__c='1234';
        webUsers1.CRD_ID__c=testCrd.id;  
        insert webUsers1;

        CVS_Web_Access_Users__c webUsers2 = new CVS_Web_Access_Users__c();
        webUsers2.Last_4_digits_of_SSN__c='1234';
        webUsers2.CRD_ID__c=testCrd.id;  
        insert webUsers2;

        list_webusers.add(webUsers1);
        list_webusers.add(webUsers2);*/
        
        Accumulations__c acum=new Accumulations__c();
        acum.Is_there_a_Maximum_Allowable_Benefit__c = 'Yes';
        acum.MAB_Dedictible_Amount__c = 30;
        acum.Is_there_a_Maximum_Out_of_Pocket__c = 'Yes';
        acum.MOOP_Dedictible_Amount__c = 30;
        acum.Is_there_a_Maximum_Allowable_Benefit__c = 'Yes';
        acum.CRD_ID__c=testCrd.id;  
        insert acum;     
        
        
        AccumulationSpecificDrug__c accumDrug=new AccumulationSpecificDrug__c();
        accumDrug.Accumulations_ID__c= acum.id;
        insert  accumDrug;

        GC_Validation_Methods controller = new GC_Validation_Methods(); 
        
        testcrd.plan_platform__c='HMO';
        testcrd.include_kit_logic__c=true;
        testcrd.apply_penalty__c='Yes';
        testcrd.Apply_Penalty_to_Specialty_OON__c='Yes';
        testcrd.Toll_Free_Number__c = 'Custom';
        
       
        testcrd.POS_Rebate_for_Plan__c = 'Yes';
        testcrd.In_Network_claims_are_reimbursed__c = True;
        testcrd.Out_of_Network_claims_are_reimbused__c = True;
        testcrd.Does_the_client_want_to_do_COB__c = 'Yes';
        testcrd.Process_Point_of_Sales_COB__c = True;
        testcrd.In_Network__c = True;
        testcrd.Out_of_Network__c = True;
        testcrd.COB_or_MOB__c = 'MOB';
        testcrd.Pharmacy_Advisor__c = true;
        testcrd.Is_DM_vendor_the_same_for_each_condition__c = 'No';
        testcrd.Disease_Management_Referral_Messaging__c = 'Yes';
        testcrd.Implementation_Type__c = 'Pharmacy Advisor All Conditions Complete Buy-Up Option';
        
        list<DAW_Specific_Stepped_Copay__c> steppedCopayItemList = new list<DAW_Specific_Stepped_Copay__c>();
        DAW_Specific_Stepped_Copay__c DawSpecificStepped = new DAW_Specific_Stepped_Copay__c();
        DawSpecificStepped.Maximum_Dollar__c = 20;
        DawSpecificStepped.Minimum_Dollar__c = 30;
        DawSpecificStepped.Percent__c = 20;
        DawSpecificStepped.Dollar_Amount__c=10;
        DawSpecificStepped.Beginning_Range__c = 1;
        DawSpecificStepped.End_Range__c= 20;
        steppedCopayItemList.add(DawSpecificStepped);
        //insert steppedCopayItemList;
        controller.checkDawCopayRange(steppedCopayItemList);
        controller.validateDrugList(dl);
        
        list<VFP_CRDDAWSpecificSteppedCopay.dawSpecificCopayWrapper> wrappedList = new list<VFP_CRDDAWSpecificSteppedCopay.dawSpecificCopayWrapper>();
        
        
       
        
        
        
        List<VFP_NewDrugGroupController.GroupWrapper> GroupWrapper = new List<VFP_NewDrugGroupController.GroupWrapper>();
        
        list<Formulary_List_Entry__c> formuilaryList1 = new list<Formulary_List_Entry__c>();
        formuilaryList1.add(new Formulary_List_Entry__c(Message__c='',Action__c='Message Only',NDC__c='12345*',Effective_Date__c=date.newinstance(2014,8,11), Termination_Date__c=date.newinstance(2015,1,2)));
        formuilaryList1.add(new Formulary_List_Entry__c(GPI__c='12A',NDC__c='1234567',Effective_Date__c=date.newinstance(2014,9,10), Termination_Date__c=date.newinstance(2015,2,9)));
        formuilaryList1.add(new Formulary_List_Entry__c(GPI__c='12A34',NDC__c='1234567891*',Effective_Date__c=date.newinstance(2010,9,10), Termination_Date__c=date.newinstance(2013,2,9)));
        formuilaryList1.add(new Formulary_List_Entry__c(GPI__c='12A345',NDC__c='12345678*1',Effective_Date__c=date.newinstance(2010,9,10), Termination_Date__c=date.newinstance(2014,3,9)));
        formuilaryList1.add(new Formulary_List_Entry__c(GPI__c='12A345V',NDC__c='1235678*1',Effective_Date__c=date.newinstance(2009,7,10), Termination_Date__c=date.newinstance(2010,3,9)));
        formuilaryList1.add(new Formulary_List_Entry__c(GPI__c='12A3I85V8',NDC__c='1235678*1',Effective_Date__c=date.newinstance(2009,7,11), Termination_Date__c=date.newinstance(2010,3,9)));
        
        list<VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper> wrappedList1 = new list<VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper>();
        
        LIST<VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper> wrappedList2 = new LIST<VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper>();
        
        LIST<VFP_CRDNewSteppedCoPayController.steppedCopayWrapper> wrappedList3 = new LIST<VFP_CRDNewSteppedCoPayController.steppedCopayWrapper>();
        
        LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList4 = new LIST<VFP_AccumulationController.AccumsDruglistWrapper>();
        
        LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList5 = new LIST<VFP_AccumulationController.AccumsDruglistWrapper>();
        
        list<VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper> wrappedList6 = new list<VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper>();
        
        LIST<VFP_WaiverOfDeductible.WaiverDeductible> wrappedList7 = new LIST<VFP_WaiverOfDeductible.WaiverDeductible>();
        
       
        
        controller.validateDrugListJunction(GroupWrapper);
        controller.validateFormularyListMsCode(formuilaryList1);
        controller.validateDrugSpecificCopay(wrappedList1);
        controller.validateDrugSpecificSteppedCopay(wrappedList2);
        controller.validateSteppedCopay(wrappedList3);
        controller.validateAccumulationDrugListDeductible(wrappedList4,'test');
        controller.validateAccumulationDrugListMab(wrappedList5,'test');
        controller.checkUniqueMNOY(wrappedList6);
        controller.validatedawSpecificSteppedCopay(wrappedList);
        controller.validatedawSpecificCopay(wrappedList6);
        controller.validateWaiverofDeductible(wrappedList7);
        controller.programScreenValidation(testCrd);
        controller.validateAccumulationDrugListMoop(acum,wrappedList5,'test');
        controller.validateAccumulationDrugListMNOY(wrappedList5,'test');
        controller.validateFamilyFields(acum,'Family_All');
        controller.dateRangeValid(lstDrugListCriteria);
        controller.CRDThirdScreenValidations(testCrd);
        controller.validateClientInfoPhoneNumber(testcrd);
        controller.matchAccount(testCrd);
        controller.checkDrugSpecificCopayRange(list_drugspecificcopay);
        controller.checkChangeCopay(testCrd.id);
        controller.validatePlanPlateform(testCrd);
        controller.validateAccums4thQuarter(acum);
        GC_Validation_Methods.valiadteNDC('abcde');
        GC_Validation_Methods.valiadteGPI('abcde');
        controller.validatePlanPlateform(testCrd);
        controller.checkTierType(list_copaytiers);
        controller.validatePaperOutOfNetworkCopay(testCrd);
        controller.validateCopay(list_copaytiers);
        controller.checkCopayRange(list_SteppedCopay);
        }
        Catch(exception e){}
               
}
    private static testMethod void myunittest(){
        list<VFP_DrugListController.wrapperclass> drugcriterialis = new list<VFP_DrugListController.wrapperclass>();
        VFP_DrugListController.wrapperclass testwrap = new VFP_DrugListController.wrapperclass();
        testwrap.criterialist.Drug_Type_Code__c = system.label.CL0000003;
        drugcriterialis.add(testwrap);
        
        GC_validation_methods testinstance = new GC_validation_methods();
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abc';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcde';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcabc';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabca';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcab';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcab*';
        testinstance.validateNDC(drugcriterialis);
        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabca*';
        testinstance.validateNDC(drugcriterialis);      
        
        testwrap.criterialist.Drug_Type_Code__c = system.label.CL0000004;       
        testwrap.criterialist.Drug_Code_Value__c = 'ab';
        testinstance.validateNDC(drugcriterialis);      

        testwrap.criterialist.Drug_Code_Value__c = 'abc';
        testinstance.validateNDC(drugcriterialis);      

        testwrap.criterialist.Drug_Code_Value__c = 'abcab';
        testinstance.validateNDC(drugcriterialis);      

        testwrap.criterialist.Drug_Code_Value__c = 'abcabcc';
        testinstance.validateNDC(drugcriterialis);          

        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabc';
        testinstance.validateNDC(drugcriterialis);          

        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcac';
        testinstance.validateNDC(drugcriterialis);              

        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcabcc';
        testinstance.validateNDC(drugcriterialis);              

        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcabcab';
        testinstance.validateNDC(drugcriterialis);  
        testwrap.criterialist.Drug_Code_Value__c = 'abcabcabcabca*';
        testinstance.validateNDC(drugcriterialis);   

        GC_validation_methods.valiadteNDC('abc');
        
        Drug_List__c drugList = new Drug_List__c();
        drugList .account__C = null;
        drugList.Standard__c = false;
        
        testinstance.validateDrugList(drugList);
        Formulary__c formuilaryList = new Formulary__c();
        formuilaryList.account__C = null;
        formuilaryList.Standard__c = false;
        
        testinstance.validateFormularyList(formuilaryList);            
        crd__c crd = new crd__c();
        crd.Plan_Platform__c='HMO'; 
        crd.Include_Kit_Logic__c=true;
        testinstance.validatePlanPlateform(crd);
        crd.Include_Kit_Logic__c=false;
        testinstance.validatePlanPlateform(crd);  


    }
  
  static testMethod void testvalidateDrugSpecificCopay()
    {
        list<VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper> wrappedList1 = new list<VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper>();
        RecordType rt=[Select Id,name from RecordType where DeveloperName='Specialty_OON' and SobjectType='Drug_Specific_Copay__c' LIMIT 1];
        
        Drug_List__c dl =new Drug_List__c();
        dl.Standard__c=true;
        dl.Inactive__c=false;       
        dl.Description__c='tyest';    
        insert dl;
        
        VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper wrap = new VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = rt.id;
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        wrap.drugSpecificCopayItem.Drug_List__c = dl.id;        
        wrap.drugSpecificCopayItem.Dollar_Amount__c = 123.12;
        wrap.drugSpecificCopayItem.Percent__c = 12;
        wrappedList1.add(wrap);
        
        VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper wrap1 = new VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper();
        wrap1.drugSpecificCopayItem.recordTypeId = rt.id;
        wrap1.drugSpecificCopayItem.M__c = false;
        wrap1.drugSpecificCopayItem.N__c = false;
        wrap1.drugSpecificCopayItem.O__c = false;
        wrap1.drugSpecificCopayItem.Y__c = false;
        wrap1.drugSpecificCopayItem.Dollar_Amount__c = null;
        wrap1.drugSpecificCopayItem.Percent__c = 12;
        wrap1.drugSpecificCopayItem.Drug_Group__c=null;
        wrap1.drugSpecificCopayItem.Drug_List__c=null;
        wrappedList1.add(wrap1);
        
        VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper wrap2 = new VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper();
        wrap2.drugSpecificCopayItem.recordTypeId = rt.id;
        wrap2.drugSpecificCopayItem.Stepped_Copay__c=false;
        wrap2.drugSpecificCopayItem.Dollar_Amount__c = null;
        wrap2.drugSpecificCopayItem.Percent__c = null;
        wrap2.drugSpecificCopayItem.Copay_Calculation__c='Sum of Copay + percentage';
        wrappedList1.add(wrap2);
        
        GC_validation_methods testinstance1 = new GC_validation_methods();
        testinstance1.validateDrugSpecificCopay(wrappedList1);
    }  
}