/*Purpose: Apex Class for Accumalation Screen on CRD Wizard.
========================================================================
History
-------
VERSION     AUTHOR                 DATE                    DETAIL
   1.0 -    ABHAY                  07/25/2011       Apex Class for Accumalation Screen on CRD Wizard
   2.0      rakesh                 10 Aug'12        As per req. 761
                                                    Commented 'Pays_the_DAW_difference_after_deductible' field.
                                                    Added field 'DAW_Differential_Penalty_Applies_to_MOOP__c'
   2.1 -    Sushant                01 Aug 2013      Added fields as per Req 01129
   
   2.2      Joognu Rao              25 Feb 2014     Request no 4550
   3.0      Nitish                  04 Dec 2014     Request no 4751
   4.0      Abhishek Goel          11/14/2016       ST#1579-Story#4-CRD Default Fields [CRD Accumulations Page]
======================================================================== */
/**
     *Method :- VFP_AccumulationController
     *Description :- Apex Class for Accumalation Screen on CRD Wizard.
**/ 
public with sharing class VFP_AccumulationController {
    public string crdId {
        set;
        get;
    }
    public string clientDate {
        get;
        set;
    }
    public string recordTypeValue {
        get;
        set;
    }
    public string userSelectionRecordTypeName {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }

    public integer deductibleElementCount {
        get;
        set;
    }
    public integer ElementCount {
        get;
        set;
    }
    public integer moopElementCount {
        get;
        set;
    }

    public boolean showDedcutiblePanel {
        get;
        set;
    }
    public boolean showMoopPanel {
        get;
        set;
    }
    public boolean showMabPanel {
        get;
        set;
    }
    public boolean isDeletionCheckboxSelected {
        get;
        set;
    }
    public boolean isDuplicate {
        get;
        set;
    }
    public boolean isRecordTypeFamily {
        get;
        set;
    }

    public list < AccumsDruglistWrapper > deductibleAccum {
        get;
        set;
    }
    public list < AccumsDruglistWrapper > mabAccum {
        get;
        set;
    }
    public list < AccumsDruglistWrapper > moopAccum {
        get;
        set;
    }
    public list < AccumslistWrapper > lstAccumWrap {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public List < SelectOption > recordTypeOptions {
        get;
        set;
    }

    public list < Accumulations__c > existingAccums {
        get;
        set;
    }
    public CRD__c CRD {
        get;
        set;
    }
    public Accumulations__c accumulation {
        get;
        set;
    }
    public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING CURRENTPAGE = 'currentPageName';
    PRIVATE STATIC FINAL STRING OOP = 'OOP';
    PRIVATE STATIC FINAL STRING MAB = 'MAB';
    PRIVATE STATIC FINAL STRING DED = 'DED';
    PRIVATE STATIC FINAL STRING JAN = 'JAN';
    PRIVATE STATIC FINAL STRING FEB = 'FEB';
    PRIVATE STATIC FINAL STRING MAR = 'MAR';
    PRIVATE STATIC FINAL STRING APR = 'APR';
    PRIVATE STATIC FINAL STRING MAY = 'MAY';
    PRIVATE STATIC FINAL STRING JUN = 'JUN';
    PRIVATE STATIC FINAL STRING JUL = 'JUL';
    PRIVATE STATIC FINAL STRING AUG = 'AUG';
    PRIVATE STATIC FINAL STRING SEP = 'SEP';
    PRIVATE STATIC FINAL STRING OCT = 'OCT';
    PRIVATE STATIC FINAL STRING NOV = 'NOV';
    PRIVATE STATIC FINAL STRING DEC = 'DEC';
    PRIVATE STATIC FINAL STRING PHARMACYSCREEN = '/apex/VF_CRDPharmacyNetwork?crdid=';
    PRIVATE STATIC FINAL STRING COPAYSCREEN = '/apex/VF_CRDNewSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING ACCSCREEN = '/apex/VF_AccumulationsStep2?crdid=';
    PRIVATE STATIC FINAL STRING WODSCREEN = '/apex/VF_WaiverOfDeductible?crdid=';
    PRIVATE STATIC FINAL STRING FA = 'Family - All';
    PRIVATE STATIC FINAL STRING F = 'Family';
    PRIVATE STATIC FINAL STRING IA = 'Individual - All';
    PRIVATE STATIC FINAL STRING I = 'Individual';
    PRIVATE STATIC FINAL STRING ISMOOP = 'Yes';
    public String managementUser {get;set;}

    /**
     *Method :- VFP_AccumulationController
     *Description :- Constructor for Accumalation Screen on CRD Wizard.
**/
    public VFP_AccumulationController(ApexPages.StandardController stdController) {
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;
        List < Schema.RecordTypeInfo > objListrecType = Accumulations__c.sObjectType.getDescribe().getRecordTypeInfos();
        recordTypeOptions = new List < SelectOption > ();
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        existingAccums = new list < Accumulations__c > ();
        lstAccumWrap = new list < AccumslistWrapper > ();
        errorMessages = new list < String > ();
        if (crdId != null) {
            CRD = [Select(Select Id, Start_Day__c, Start_Month_New__c, OwnerId, IsDeleted, recordType.Name, Name, RecordTypeId, CreatedDate, CreatedById,
                                 LastModifiedDate, LastModifiedById, SystemModstamp, CRD_ID__c, Carry_Balance_when_member_moves__c,When_will_the_Accumulations_renew__c,
                                 Deductible_Amount__c,What_is_the_In_Network_Deductible_Amount__c,What_is_the_OON_Deductible_Amount__c,Cross_Accumulation__c,
                                 What_is_the_OON_MOOP_Amount__c,What_is_the_In_Network_MOOP_Amount__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Period__c,
                                 MAB_Dedictible_Amount__c,Do_not_apply_flat_fee_to_OOP__c,Do_not_apply_penalty_to_OOP__c, MAB_Period__c, MOOP_Dedictible_Amount__c,
                                 MOOP_Period__c, What_happens_when_the_MAB_is_met__c, Family_Members_to_meet_Family_Deduct__c, DAW_Differential_Penalty_Applies_to_MOOP__c,
                                 Start_Month__c, Deuductible_Accumulation_from_4th_Qtr__c, Are_there_any_drug_specific_deductibles__c, Are_there_any_drug_specific_MAB__c,
                                 Are_there_any_drug_specifc_MOOP__c, Noof_Family_Members_to_Meet_Family_MOOP__c,Accumulation_End_Date__c
                           From Accumulations__r LIMIT 80000),
                          Insured_Type__c, Name,Specialty_Number_of_Tiers__c, SteppedCopayCount__c, Retail_Number_of_Tiers__c, Paper_Number_of_Tiers__c, Mail_Number_of_Tiers__c,
                          Plan_Type_Retail__c, Plan_Type_Mail__c, Client_Effective_Date__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c,
                          Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, Durg_Specific_Stepped_Count__c, Integrate_with_Medical__c,
                          Drug_Specific_copay_count__c, Plan_Type_Paper__c, Y_Schd__c
                    From CRD__c 
                    where Id = : crdId LIMIT 80000];
            existingAccums = [select CRD_ID__c, Name, Deductible_Amount__c, recordType.Name, id 
                              From Accumulations__c 
                              where CRD_ID__c = : crdId LIMIT 80000];
        }
        if (existingAccums != null && existingAccums.size() > 0) {
            for (Accumulations__c accum: existingAccums) {
                AccumslistWrapper wrap = new AccumslistWrapper();
                wrap.accumsList = accum;
                lstAccumWrap.add(wrap);
            }
        }
        createClientDate();
        this.accumulation = (Accumulations__c) stdController.getRecord();
        this.accumulation.Accum_Code_Maximum_Out_Of_Pocket__c =OOP;
        this.accumulation.Accum_Code_Maximum_Allowable_Benefit__c =MAB;
        this.accumulation.Accum_Code_Deductible__c =DED;
        //below line of code commented by abhishek goel date on 1/24/2014
       // this.accumulation.What_happens_when_the_MAB_is_met__c = 'Change Copay to $0';                
       // this.accumulation.What_happens_when_MOOP_is_met__c = 'Change Copay to $0';        
        deductibleAccum = new list < AccumsDruglistWrapper > ();
        mabAccum = new list < AccumsDruglistWrapper > ();
        moopAccum = new list < AccumsDruglistWrapper > ();
        try {
            recordTypeValue = null;
            showNumberField();
        } catch (exception e) {}
        recordTypeOptions.add(new Selectoption('none', '-None-'));
        for (Schema.RecordTypeInfo recType: objListrecType) {
            If(recType.name != 'Master') {
                recordTypeOptions.add(new Selectoption(recType.getRecordTypeId(), recType.name));
            }
        }
        isDeletionCheckboxSelected = true;
        isDuplicate = false;
    }
/**
     *Method :- previousStep
     *Description :- Method to navigate to previous screen
**/
    public PageReference previousStep() {
        try{
            PageReference pageRef = new PageReference(COPAYSCREEN + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch (exception e) {return null;}
    }
/**
     *Method :- nextStep
     *Description :- Method to navigate to next screen
**/
    public PageReference nextStep() {
        try{
            PageReference pageRef = new PageReference(ACCSCREEN + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch (exception e) {return null;}
    }
    
    
    
/**
     *Method :- redirectToDrugCoverage2
     *Description :- Method to navigate to drug coverage screen in ReadOnly Mode
**/ 
public pageReference redirectToDrugCoverage2(){
        try{
            PageReference pageRef = new PageReference(WODSCREEN + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef; 
    }catch (exception e) {return null;}
    }
/**
     *Method :- redirectToDrugCoverage
     *Description :- Method to navigate to drug coverage screen
**/
    public PageReference redirectToDrugCoverage() {
        try{
            PageReference pageRef = new PageReference(WODSCREEN + crdId);
            list<Copay_Tier__c> copayTier = new list<Copay_Tier__c>();
            list<Accumulations__c>acumltn = new list<Accumulations__c>();
            copayTier = [Select Tier__c, Percent__c, Dollar_Amount__c, Tier_Type__c, Tier_Name__c from Copay_Tier__c where Tier_Name__c LIKE '%Mail%' AND crd__c = : crdId LIMIT 80000]; 
            acumltn = [Select Deductible_Amount__c, What_is_the_In_Network_Deductible_Amount__c, What_is_the_OON_Deductible_Amount__c from Accumulations__c where CRD_ID__c = : crdId LIMIT 80000];
            GC_Utils_Method utilinstance = new GC_Utils_Method();
            utilinstance.setMACatMailApplies(crd, copayTier, acumltn);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch (exception e) {return null;}
    }
/**
     *Method :- checkDuplicate
     *Description :- Method to check if user is trying to add a duplicate recordtype
**/
    public boolean checkDuplicate() {
        list < Accumulations__c > existingAccums = new list < Accumulations__c > ();
        isDuplicate = false;
        existingAccums = CRD.Accumulations__r;
        try{
        for (Accumulations__c acc: existingAccums) {
            if (acc.RecordTypeId == recordTypeValue) {
                isDuplicate = true;
                break;
            }
        }
        return isDuplicate;
        }catch (exception e) {return null;}
    }
/**
     *Method :- redirectToAccumStep32
     *Description :- Method to check validations before navigating to next screen in ReadOnly Mode
**/
public pageReference redirectToAccumStep32(){
     try{
        PageReference pageRef = new PageReference(PHARMACYSCREEN + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef; 
    }catch (exception e) {return null;}
    }
/**
     *Method :- redirectToAccumStep3
     *Description :- Method to check validations before navigating to next screen
**/
    public PageReference redirectToAccumStep3() {
        isDeletionCheckboxSelected = true;
        errorMessages.clear();
        If(accumulation.Deductible_Amount__c != NULL){
                If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL || accumulation.What_is_the_OON_Deductible_Amount__c != NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00200);
                    return null;
                }
            }
            /*Added by Sushant for Req 04914       
             string accumulationEndDate;
              accumulationEndDate = string.valueOf(accumulation.Accumulation_end_date__c);    
            If(accumulation.When_will_the_Accumulations_renew__c != NULL && accumulation.When_will_the_Accumulations_renew__c == 'Custom')
             {    if(string.isBlank(accumulationEndDate))
                  {
                  errorMessages.clear();
                  errorMessages.add(system.label.ERR00251);
                  return null;                  
                  }               
             }*/
            If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL && accumulation.What_is_the_OON_Deductible_Amount__c != NULL ){
                If(accumulation.Deductible_Amount__c != NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00201);
                    return null;
                }
            }
            
            If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL && accumulation.What_is_the_OON_Deductible_Amount__c != NULL){
                If(accumulation.Cross_Accumulation__c == NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00202);
                    return null;
                }
            }
            
            If(accumulation.Deductible_Amount__c != Null){
                If(accumulation.Cross_Accumulation__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00203);
                return null;
                }
            }
            
            IF(accumulation.MOOP_Dedictible_Amount__c != NULL){
                If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL || accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00205);
                return null;
                }
            }
            If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL && accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                If(accumulation.MOOP_Dedictible_Amount__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00206);
                }
            }
        if (recordTypeValue != 'none') {
            if (checkDuplicate()) {
                isDuplicate = true;
                errorMessages.clear();
                //errorMessages.add('Accumalation for same recordtype is already present.You cannot add same type of accumulation again');
                errorMessages.add(system.Label.ERR00056);
                return null;
            }
            if (userSelectionRecordTypeName != '' && userSelectionRecordTypeName.contains(F)) {
                list < Accumulations__c > existingAccums = new list < Accumulations__c > ();
                existingAccums = CRD.Accumulations__r;
                for (Accumulations__c acc: existingAccums) {
                    if (userSelectionRecordTypeName.contains(F) && userSelectionRecordTypeName != FA) {
                        if (acc.recordtype.Name.equalsignorecase(FA)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Family Accumulation when you have accumulation of type Family-All');
                            errorMessages.add(system.Label.ERR00067);
                            return null;
                        }
                    }
                    if (userSelectionRecordTypeName.equalsignorecase(FA)) {
                        if (acc.recordtype.Name.contains(F)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Family-All Accumulation when you have accumulation of type Family');
                            errorMessages.add(system.Label.ERR00075);
                            return null;
                        }
                    }
                }
            }
            if (userSelectionRecordTypeName != '' && userSelectionRecordTypeName.contains(I)) {
                list < Accumulations__c > existingAccums = new list < Accumulations__c > ();
                existingAccums = CRD.Accumulations__r;
                for (Accumulations__c acc: existingAccums) {
                    if (userSelectionRecordTypeName.contains(I) && userSelectionRecordTypeName != IA) {
                        if (acc.recordtype.Name.equalsignorecase(IA)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Individual Accumulation when you have accumulation of type Individual - All');
                            errorMessages.add(system.Label.ERR00078);
                            return null;
                        }
                    }
                   if (userSelectionRecordTypeName.equalsignorecase(FA)) {
                        if (acc.recordtype.Name.contains(F)) {
                            errorMessages.clear();
                            errorMessages.add(system.Label.ERR00075);
                            return null;
                        }
                    }

                    if (userSelectionRecordTypeName.equalsignorecase(IA)) {
                        if (acc.recordtype.Name.contains(I)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Individual - All Accumulation when you have accumulation of type Individual');
                            errorMessages.add(system.Label.ERR00079);
                            return null;
                        }
                    }
                }
            }
            try {
                accumulation.CRD_ID__c = this.CRD.id;
                accumulation.RecordTypeId = recordTypeValue;
                GC_Validation_Methods validationmethod = new GC_Validation_Methods();
                boolean isValid2  = true;
                boolean isvalid = true;
                boolean IsValidMNOY = true;
                boolean isDedAccumDrugvalid = true;
                boolean isMabAccumDrugvalid = true;
                boolean isMoopAccumDrugvalid = true;
                errorMessages.clear();
                // modification done by Rishabh Kushagra Bansal on 23rd July'12
                isValid2 = validationmethod.validateAccums4thQuarter(accumulation);
                isvalid = validationmethod.validateFamilyFields(accumulation, userSelectionRecordTypeName);
             /*   if (accumulation.Is_this_an_HDHP_plan__c == null && crd.Integrate_with_Medical__c != 'Yes') {
                    accumulation.Is_this_an_HDHP_plan__c.addError(system.Label.ERR00024);
                    isValid = false;
                }  */
                if (deductibleAccum != null && deductibleAccum.size() > 0) {
                    
                    // Added by JR for request no 4550
                    IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(deductibleAccum,userSelectionRecordTypeName);
                    
                    if (accumulation.Are_there_any_drug_specific_deductibles__c != null && accumulation.Are_there_any_drug_specific_deductibles__c == true) {
                        isDedAccumDrugvalid = validationmethod.validateAccumulationDrugListDeductible(deductibleAccum, userSelectionRecordTypeName);
                        if (!isDedAccumDrugvalid) {
                            errorMessages.clear();
                            errorMessages.addAll(validationmethod.errorMessages);
                        }
                    }
                }
                
                if (mabAccum != null && mabAccum.size() > 0) {
                
                    // Added by JR for request no 4550
                    IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(mabAccum,userSelectionRecordTypeName);
                    
                    //Commented for request no 4751 by Nitish
                   /* if (accumulation.Is_there_a_Maximum_Allowable_Benefit__c != null && accumulation.Is_there_a_Maximum_Allowable_Benefit__c == 'Yes') {
                        if (accumulation.Are_there_any_drug_specific_MAB__c != null && accumulation.Are_there_any_drug_specific_MAB__c == true) {
                            isMabAccumDrugvalid = validationmethod.validateAccumulationDrugListMab(mabAccum, userSelectionRecordTypeName);
                        }
                    }*/
                    //Added By Nitish 4751
                    if (accumulation.Are_there_any_drug_specific_MAB__c != null && accumulation.Are_there_any_drug_specific_MAB__c == true) {
                    isMabAccumDrugvalid = validationmethod.validateAccumulationDrugListMab(mabAccum, userSelectionRecordTypeName);
                }
                    
                    
                    if (!isMabAccumDrugvalid) {
                        errorMessages.clear();
                        errorMessages.addAll(validationmethod.errorMessages);
                    }
                }
                
                if (moopAccum != null && moopAccum.size() > 0) {
                    
                    // Added by JR for request no 4550
                    IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(moopAccum,userSelectionRecordTypeName);
                    
                    //Commented for request no 4751 by Nitish
                   /* if (accumulation.Is_there_a_Maximum_Out_of_Pocket__c != null && accumulation.Is_there_a_Maximum_Out_of_Pocket__c == 'Yes') {
                        if (accumulation.Are_there_any_drug_specifc_MOOP__c != null && accumulation.Are_there_any_drug_specifc_MOOP__c == true) {
                            isMoopAccumDrugvalid = validationmethod.validateAccumulationDrugListMoop(accumulation, moopAccum, userSelectionRecordTypeName);
                        }
                    }*/
                    
                    if (accumulation.Are_there_any_drug_specifc_MOOP__c != null && accumulation.Are_there_any_drug_specifc_MOOP__c == true) {
                        isMoopAccumDrugvalid = validationmethod.validateAccumulationDrugListMoop(accumulation, moopAccum, userSelectionRecordTypeName);
                    }
                    if (!isMoopAccumDrugvalid) {
                        errorMessages.clear();
                        errorMessages.addAll(validationmethod.errorMessages);
                    }
                }
                if (!isValid || !isDedAccumDrugvalid || !isMabAccumDrugvalid || !isMoopAccumDrugvalid || !isValid2 || !IsValidMNOY) {
                    return null;
                } else {

                    database.upsert((accumulation));
                    saveMabList(accumulation.id);
                    saveMoopList(accumulation.id);
                    saveDeductibleList(accumulation.id);
                }
            } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
                return null;
            }
        }
        list<Copay_Tier__c> copayTier = new list<Copay_Tier__c>();
        list<Accumulations__c>acumltn = new list<Accumulations__c>();
        copayTier = [Select Tier__c, Percent__c, Dollar_Amount__c, Tier_Type__c, Tier_Name__c from Copay_Tier__c where Tier_Name__c LIKE '%Mail%' AND crd__c = : crdId LIMIT 80000]; 
        acumltn = [Select Deductible_Amount__c, What_is_the_In_Network_Deductible_Amount__c, What_is_the_OON_Deductible_Amount__c from Accumulations__c where CRD_ID__c = : crdId LIMIT 80000];
        GC_Utils_Method utilinstance = new GC_Utils_Method();
        utilinstance.setMACatMailApplies(crd, copayTier, acumltn);
        PageReference pageRef = new PageReference(PHARMACYSCREEN + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
/**
     *Method :- saveAndNew
     *Description :- Method to save Drug List and redirect to same page
**/ 
    public PageReference saveAndNew() {
        isDeletionCheckboxSelected = true;

        if (recordTypeValue == 'none') {
            errorMessages.clear();
            //errorMessages.add('Please select a recordtype to proceed');
            errorMessages.add(system.Label.ERR00080);
            return null;
        }
       
        if (checkDuplicate()) {
            isDuplicate = true;
            errorMessages.clear();
            //errorMessages.add('Accumalation for same recordtype is already present.You cannot add same type of accumulation again');
            errorMessages.add(system.Label.ERR00056);
            return null;
        }
      
        if (userSelectionRecordTypeName != '') {
            if (userSelectionRecordTypeName.contains(F)) {
                list < Accumulations__c > existingAccums = new list < Accumulations__c > ();
                existingAccums = CRD.Accumulations__r;
                for (Accumulations__c acc: existingAccums) {
                    if (userSelectionRecordTypeName.contains(F) && userSelectionRecordTypeName != FA) {
                        if (acc.recordtype.Name.equalsignorecase(FA)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Family Accumulation when you have accumulation of type Family-All');
                            errorMessages.add(system.Label.ERR00067);
                            return null;
                        }
                    }
                    if (userSelectionRecordTypeName.equalsignorecase(FA)) {
                        if (acc.recordtype.Name.contains(F)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Family-All Accumulation when you have accumulation of type Family');
                            errorMessages.add(system.Label.ERR00075);
                            return null;
                        }
                    }

                }

            }
            if (userSelectionRecordTypeName != '' && userSelectionRecordTypeName.contains(I)) {
                list < Accumulations__c > existingAccums = new list < Accumulations__c > ();
                existingAccums = CRD.Accumulations__r;
                for (Accumulations__c acc: existingAccums) {
                    if (userSelectionRecordTypeName.contains(I) && userSelectionRecordTypeName != IA) {
                        if (acc.recordtype.Name.equalsignorecase(IA)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Individual Accumulation when you have accumulation of type Individual - All');
                            errorMessages.add(system.Label.ERR00078);
                            return null;
                        }
                    }
                    if (userSelectionRecordTypeName.equalsignorecase(IA)) {
                        if (acc.recordtype.Name.contains(I)) {
                            errorMessages.clear();
                            //errorMessages.add('You can not add a Individual - All Accumulation when you have accumulation of type Individual');
                            errorMessages.add(system.Label.ERR00079);
                            return null;
                        }
                    }

                }

            }
        }
        //Validations added by Sushant as per Req 01129
            If(accumulation.Deductible_Amount__c != NULL){
                If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL || accumulation.What_is_the_OON_Deductible_Amount__c != NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00200);
                    return null;
                }
            }
            
            If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL && accumulation.What_is_the_OON_Deductible_Amount__c != NULL ){
                If(accumulation.Deductible_Amount__c != NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00201);
                    return null;
                }
            }
            
            If(accumulation.What_is_the_In_Network_Deductible_Amount__c != NULL && accumulation.What_is_the_OON_Deductible_Amount__c != NULL){
                If(accumulation.Cross_Accumulation__c == NULL){
                    errorMessages.clear();
                    errorMessages.add(system.label.ERR00202);
                    return null;
                }
            }
            
            If(accumulation.Deductible_Amount__c != Null){
                If(accumulation.Cross_Accumulation__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00203);
                return null;
                }
            } 
            IF(accumulation.MOOP_Dedictible_Amount__c != NULL){
                If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL || accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00205);
                return null;
                }
            }
            If(accumulation.What_is_the_In_Network_MOOP_Amount__c != NULL && accumulation.What_is_the_OON_MOOP_Amount__c != NULL){
                If(accumulation.MOOP_Dedictible_Amount__c != NULL){
                errorMessages.clear();
                errorMessages.add(system.label.ERR00206);
                }
            }

        try {
            accumulation.CRD_ID__c = this.CRD.id;
            accumulation.RecordTypeId = recordTypeValue;
            GC_Validation_Methods validationmethod = new GC_Validation_Methods();
            boolean isvalid = true;
            boolean isValid2 = true;
            boolean IsValidMNOY =true;
            boolean isDedAccumDrugvalid = true;
            boolean isMabAccumDrugvalid = true;
            boolean isMoopAccumDrugvalid = true;
            errorMessages.clear();
            // modification done by Rishabh Kushagra Bansal on 23rd July'12
            isValid2 = validationmethod.validateAccums4thQuarter(accumulation);
            isvalid = validationmethod.validateFamilyFields(accumulation, userSelectionRecordTypeName);
         /*   if (accumulation.Is_this_an_HDHP_plan__c == null && crd.Integrate_with_Medical__c != 'Yes') {
                accumulation.Is_this_an_HDHP_plan__c.addError(system.Label.ERR00024);
                isValid = false;
            }   */


            if (deductibleAccum != null && deductibleAccum.size() > 0) {
            
                // Added by JR for request no 4550
                    IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(deductibleAccum,userSelectionRecordTypeName);
                    
                
                if (accumulation.Are_there_any_drug_specific_deductibles__c != null && accumulation.Are_there_any_drug_specific_deductibles__c == true) {
                    isDedAccumDrugvalid = validationmethod.validateAccumulationDrugListDeductible(deductibleAccum, userSelectionRecordTypeName);
                    if (!isDedAccumDrugvalid) {
                        errorMessages.clear();
                        errorMessages.addAll(validationmethod.errorMessages);
                    }
                }
            }
            
            if (mabAccum != null && mabAccum.size() > 0) {
            
                // Added by JR for request no 4550
                IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(mabAccum,userSelectionRecordTypeName);
                
                //Commented for request no 4751 by Nitish
                /*if (accumulation.Is_there_a_Maximum_Allowable_Benefit__c != null && accumulation.Is_there_a_Maximum_Allowable_Benefit__c == 'Yes') {
                    if (accumulation.Are_there_any_drug_specific_MAB__c != null && accumulation.Are_there_any_drug_specific_MAB__c == true) {
                        isMabAccumDrugvalid = validationmethod.validateAccumulationDrugListMab(mabAccum, userSelectionRecordTypeName);
                    }
                }*/
                //Added By Nitish 4751
                if (accumulation.Are_there_any_drug_specific_MAB__c != null && accumulation.Are_there_any_drug_specific_MAB__c == true) {
                    isMabAccumDrugvalid = validationmethod.validateAccumulationDrugListMab(mabAccum, userSelectionRecordTypeName);
                }
               
                if (!isMabAccumDrugvalid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationmethod.errorMessages);
                }
            }
            
            if (moopAccum != null && moopAccum.size() > 0) {
                
                // Added by JR for request no 4550
                IsValidMNOY = validationmethod.validateAccumulationDrugListMNOY(moopAccum,userSelectionRecordTypeName);
                
                //Commented for request no 4751 by Nitish
               /* if (accumulation.Is_there_a_Maximum_Out_of_Pocket__c != null && accumulation.Is_there_a_Maximum_Out_of_Pocket__c == 'Yes') {
                    if (accumulation.Are_there_any_drug_specifc_MOOP__c != null && accumulation.Are_there_any_drug_specifc_MOOP__c == true) {
                        isMoopAccumDrugvalid = validationmethod.validateAccumulationDrugListMoop(accumulation, moopAccum, userSelectionRecordTypeName);
                    }
                }*/
                if (accumulation.Are_there_any_drug_specifc_MOOP__c != null && accumulation.Are_there_any_drug_specifc_MOOP__c == true) {
                    isMoopAccumDrugvalid = validationmethod.validateAccumulationDrugListMoop(accumulation, moopAccum, userSelectionRecordTypeName);
                }
                if (!isMoopAccumDrugvalid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationmethod.errorMessages);
                }
            }
            if (!isValid || !isDedAccumDrugvalid || !isMabAccumDrugvalid || !isMoopAccumDrugvalid || !isValid2 || !IsValidMNOY) {
                return null;
            } else {

                database.insert (accumulation);
                saveMabList(accumulation.id);
                saveMoopList(accumulation.id);
                saveDeductibleList(accumulation.id);
            }
        } catch (exception e) {
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
           // ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
        
        this.accumulation = new Accumulations__c();
        AddNewDeductible();
        AddNewMoop();
        AddNewMab();
        PageReference pageRef = new PageReference(ACCSCREEN + crdId);
        pageRef.setRedirect(true);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
/**
     *Method :- saveMabList
     *Description :- Method to save MAB List
**/
    public PageReference saveMabList(String accumId) {
        list < AccumulationSpecificDrug__c > listAccum = new list < AccumulationSpecificDrug__c > ();
        if (mabAccum != null && mabAccum.size() > 0) {
            for (AccumsDruglistWrapper wrap: mabAccum) {
                wrap.accumsDrugList.Accumulations_ID__c = accumId;
                listAccum.add(wrap.accumsDrugList);
            }
            database.insert (listAccum);
        }
        mabAccum.clear();
        return null;
        //mabAccum
    }
/**
     *Method :- saveMoopList
     *Description :- Method to save MOOP List
**/
    public PageReference saveMoopList(String accumId) {
        try{list < AccumulationSpecificDrug__c > listAccum = new list < AccumulationSpecificDrug__c > ();
        if (moopAccum != null && moopAccum.size() > 0) {
            for (AccumsDruglistWrapper wrap: moopAccum) {
                wrap.accumsDrugList.Accumulations_ID__c = accumId;
                listAccum.add(wrap.accumsDrugList);
            }
            database.insert (listAccum);
        }
        moopAccum.clear();
        return null;
        //moopAccum
    }catch(exception e){return null;}
    }
/**
     *Method :- saveDeductibleList
     *Description :- Method to save Deductible List
**/   
    public PageReference saveDeductibleList(String accumId) {
        try{list < AccumulationSpecificDrug__c > listAccum = new list < AccumulationSpecificDrug__c > ();
        if (deductibleAccum != null && deductibleAccum.size() > 0) {
            for (AccumsDruglistWrapper wrap: deductibleAccum) {

                wrap.accumsDrugList.Accumulations_ID__c = accumId;
                // wrap.accumsDrugList.Drug_List__c=wrap.currentDruglistId;
                listAccum.add(wrap.accumsDrugList);
            }
            database.insert (listAccum);
        }
        deductibleAccum.clear();
        return null;
        //deductibleAccum
    }catch(exception e){return null;}}
/**
     *Method :- showNumberField
     *Description :- Method to check record type validation
**/
    public PageReference showNumberField() {
        try {
            if (recordTypeValue != null) {
                String nameOfRecordType = getRecordTypeNameByid(recordTypeValue);
                userSelectionRecordTypeName = nameOfRecordType;
                if (nameOfRecordType.contains(F)) {
                    isRecordTypeFamily = true;
                } else {
                    isRecordTypeFamily = false;
                }
            } else {
                isRecordTypeFamily = false;
            }
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
/**
     *Method :- getRecordTypeNameByid
     *Description :- Method to get the record type Name from schema describe information
**/    
    public String getRecordTypeNameByid(id recordTypeid) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Accumulations__c;
        Map < Id, Schema.RecordTypeInfo > rtMapById = d.getRecordTypeInfosById();
        String strRecordTypename = rtMapById.get(recordTypeid).getName();
        return strRecordTypename;
    }
/**
     *Method :- getRecordType
     *Description :- Method to get the record type id from schema describe information
**/
    public Id getRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Accumulations__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }
/**
     *Method :- getAccumDrugRecordType
     *Description :- Method to get the record type id from schema describe information
**/    
    public Id getAccumDrugRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.AccumulationSpecificDrug__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }
/**
     *Method :- deleteSelectedDeductible
     *Description :- Method to delete Selected instance of Wrapper to list of dynamic input sections
**/    
    public PageReference deleteSelectedDeductible() {
        try{list < AccumsDruglistWrapper > tempList = new list < AccumsDruglistWrapper > ();
        if (deductibleAccum != null && deductibleAccum.size() > 0) {
            for (AccumsDruglistWrapper wrapItem: deductibleAccum) {
                if (!wrapItem.isMarkedForDeletion) {
                    tempList.add(wrapItem);
                }
            }
            deductibleAccum.clear();
            deductibleAccum.addAll(tempList);
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- deleteSelectedMab
     *Description :- Method to delete Selected instance of Wrapper to list of dynamic input sections
**/    
    public PageReference deleteSelectedMab() {
        try{list < AccumsDruglistWrapper > tempList = new list < AccumsDruglistWrapper > ();
        if (mabAccum != null && mabAccum.size() > 0) {
            for (AccumsDruglistWrapper wrapItem: mabAccum) {
                if (!wrapItem.isMarkedForDeletion) {
                    tempList.add(wrapItem);
                }
            }
            mabAccum.clear();
            mabAccum.addAll(tempList);
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- deleteSelectedMoop
     *Description :- Method to delete Selected instance of Wrapper to list of dynamic input sections
**/
    public PageReference deleteSelectedMoop() {
        try{
        list < AccumsDruglistWrapper > tempList = new list < AccumsDruglistWrapper > ();
        if (moopAccum != null && moopAccum.size() > 0) {
            for (AccumsDruglistWrapper wrapItem: moopAccum) {
                if (!wrapItem.isMarkedForDeletion) {
                    tempList.add(wrapItem);
                }
            }
            moopAccum.clear();
            moopAccum.addAll(tempList);
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- AddNewDeductible
     *Description :- Method to add a new instance of Wrapper to list of dynamic input sections
**/
    public PageReference addNewDeductible() {
        try{if (userSelectionRecordTypeName != null) {
            AccumsDruglistWrapper wrap = new AccumsDruglistWrapper();
            if (userSelectionRecordTypeName.contains(F)) {
                wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Family - Deductible');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            } else {
                wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Individual - Deductible');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            }
            wrap.accumsDrugList.Accumulatoins_Type__c = 'Deductible - ' + userSelectionRecordTypeName;
            if (deductibleAccum != null) {
                wrap.currentItemSeq = deductibleAccum.size();
            } else {
                wrap.currentItemSeq = 1;
            }
            deductibleAccum.add(wrap);
            return null;
        } else {
            errorMessages.clear();
            //errorMessages.add('Please Select a record Type');
            errorMessages.add(system.Label.ERR00080);
            return null;
        }
 }catch(exception e){return null;}
    }
/**
     *Method :- AddNewMab
     *Description :- Method to add a new instance of Wrapper to list of dynamic input sections
**/
    public PageReference addNewMab() {
        try{if (userSelectionRecordTypeName != null) {
            AccumsDruglistWrapper wrap = new AccumsDruglistWrapper();
            if (userSelectionRecordTypeName.contains(F)) {
                
wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Family - MAB');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            } else {
                wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Individual - MAB');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            }
            wrap.accumsDrugList.Accumulatoins_Type__c = 'MAB - ' + userSelectionRecordTypeName;
            if (mabAccum != null) {
                wrap.currentItemSeq = mabAccum.size();
            } else {
                wrap.currentItemSeq = 1;
            }
            mabAccum.add(wrap);
            return null;
        } else {
            errorMessages.clear();
            //errorMessages.add('Please Select a record Type');
            errorMessages.add(system.Label.ERR00080);
            return null;
        }
    }catch(exception e){return null;}
    }
/**
     *Method :- AddNewMoop
     *Description :- Method to add a new instance of Wrapper to list of dynamic input sections
**/    
    public PageReference addNewMoop() {
        try{if (userSelectionRecordTypeName != null) {
            AccumsDruglistWrapper wrap = new AccumsDruglistWrapper();
            if (userSelectionRecordTypeName.contains(F)) {             
                wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Family - MOOP');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            } else {
                wrap.accumsDrugList.recordTypeId = getAccumDrugRecordType('Individual - MOOP');
                wrap.accumsDrugList.M__c = true;
                wrap.accumsDrugList.N__c = true;
                wrap.accumsDrugList.O__c = true;
                wrap.accumsDrugList.Y__c = true;
            }
            wrap.accumsDrugList.Accumulatoins_Type__c = 'MOOP - ' + userSelectionRecordTypeName;
            if (moopAccum != null) {
                wrap.currentItemSeq = moopAccum.size();
            } else {
                wrap.currentItemSeq = 1;
            }
            moopAccum.add(wrap);
            return null;
        } else {
            errorMessages.clear();
            //errorMessages.add('Please Select a record Type');
            errorMessages.add(system.Label.ERR00080);
            return null;
        }
    }catch(exception e){return null;}
    }


/**
     *Class :- AccumsDruglistWrapper
     *Description :- Wrapper Class To Create dynamic inputs
**/    
    public class AccumsDruglistWrapper {
        public AccumulationSpecificDrug__c accumsDrugList {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
        public integer currentItemSeq {
            get;
            set;
        }
        Public string druglistName {
            get;
            set;
        }
    /*Accum wrapper*/
        public AccumsDruglistWrapper() {
            currentItemSeq = 0;
            accumsDrugList = new AccumulationSpecificDrug__c();
        }
    }


/**
     *Class :- AccumslistWrapper
     *Description :- Wrapper Class To Create dynamic inputs
**/    
    public class AccumslistWrapper {
    
            public Accumulations__c accumsList {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
    /*Accum wrapper*/
        public AccumslistWrapper() {
            accumsList = new Accumulations__c();
        }
    }
/**
     *Method :- deleteSelectedAccums
     *Description :- Method to remove the selected rows from the web user panel
**/    
    public PageReference deleteSelectedAccums() {
        try{
            list < Accumulations__c > listDeletedAccums = new list < Accumulations__c > ();
        list < AccumslistWrapper > lsttempDeletedWrap = new list < AccumslistWrapper > ();
        if (lstAccumWrap != null && lstAccumWrap.size() > 0) {
            for (integer j = 0; j < lstAccumWrap.size(); j++) {
                if (lstAccumWrap[j].isMarkedForDeletion == true) {
                    listDeletedAccums.add(lstAccumWrap[j].accumsList);
                    //lstAccumWrap.remove(i);
                } else {
                    lsttempDeletedWrap.add(lstAccumWrap[j]);
                }
            }
            if (listDeletedAccums == null || listDeletedAccums.size() == 0) {
                isDeletionCheckboxSelected = false;
            } else {
                isDeletionCheckboxSelected = true;
                lstAccumWrap.clear();
                lstAccumWrap.addAll(lsttempDeletedWrap);
                database.delete (listDeletedAccums);
                lstAccumWrap.clear();
            }
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- showDeductiblePanel
     *Description :- Method to display Deductible panel
**/

    public PageReference showDeductiblePanel() {
      try{  if (accumulation.Are_there_any_drug_specific_deductibles__c) {
            showDedcutiblePanel = true;
            AddNewDeductible();
        } else {
            deductibleAccum.clear();
            showDedcutiblePanel = false;
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- showMainMabPanel
     *Description :- Method to display Main MAB panel
**/
    public PageReference showMainMabPanel() {
         try{accumulation.MAB_Dedictible_Amount__c = null;
        accumulation.Are_there_any_drug_specific_MAB__c = false;
        accumulation.MAB_Period__c = null;
        //accumulation.What_happens_when_the_MAB_is_met__c = 'Change Copay to $0';
        accumulation.MAB_In_Network__c = false;
        accumulation.MAB_Out_of_Network__c = false;
        accumulation.MAB_Generic_Drugs__c = false;
        accumulation.MAB_Brand_Drugs_Generics__c = false;
        accumulation.MAB_Brand_Drugs_no_Generics__c = false;
        accumulation.MAB_Maintenance_Drugs__c = false;
        accumulation.Do_not_apply_flat_fee_to_OOP__c = null;
        accumulation.Do_not_apply_penalty_to_OOP__c = null;        
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- showMainMoopPanel
     *Description :- Method to display Main MOOP panel
**/
    public PageReference showMainMoopPanel() {
        try{
        accumulation.Noof_Family_Members_to_Meet_Family_MOOP__c = null;
        accumulation.MOOP_Dedictible_Amount__c = null;
        //accumulation.Pays_the_DAW_difference_after_deductible__c=null;
        accumulation.DAW_Differential_Penalty_Applies_to_MOOP__c = null;
        accumulation.MOOP_Period__c = null;
        accumulation.Deductible_Applies_towards_the_MOOP__c = null;
        accumulation.Are_there_any_drug_specifc_MOOP__c = false;
        accumulation.MOOP_In_Network__c = false;
        accumulation.MOOP_Out_of_Network__c = false;
        accumulation.MOOP_Generic_Drugs__c = false;
        accumulation.MOOP_Brand_Drugs_Generics__c = false;
        accumulation.MOOP_Brand_Drugs_no_Generics__c = false;
        accumulation.MOOP_Maintenance_Drugs__c = false;
        //accumulation.What_happens_when_MOOP_is_met__c = 'Change Copay to $0';
        /*
        if (accumulation.Is_there_a_Maximum_Out_of_Pocket__c != true) {
            showMoopPanel = false;
        }
        */
        return null;
}catch(exception e){return null;}
    }
/**
     *Method :- showMoopPanel
     *Description :- Method to display MOOP panel
**/
    public PageReference showMoopPanel() {
     try{   if (accumulation.Are_there_any_drug_specifc_MOOP__c) {
            showMoopPanel = true;
            AddNewMoop();
        } else {
            moopAccum.clear();
            showMoopPanel = false;
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- showMabPanel
     *Description :- Method to display MAB panel
**/
    public PageReference showMabPanel() {
       try{if (accumulation.Are_there_any_drug_specific_MAB__c) {
            showMabPanel = true;
            AddNewMab();
        } else {
            mabAccum.clear();
            showMabPanel = false;
        }
        return null;
    }catch(exception e){return null;}
    }
     /**
     *Method :- showMoopValues
     *Description :- Method to display Default value for Initialized fields.
    **/
   
     public PageReference showMoopValues() {
       try{if (accumulation.Is_there_a_Maximum_Out_of_Pocket__c == ISMOOP) {
            accumulation.DAW_Differential_Penalty_Applies_to_MOOP__c = 'No';
            accumulation.Deductible_Applies_towards_the_MOOP__c = 'Yes';
        } else
        {
            accumulation.DAW_Differential_Penalty_Applies_to_MOOP__c = Null;
            accumulation.Deductible_Applies_towards_the_MOOP__c = Null;
        }
        return null;
    }catch(exception e){return null;}
    }
/**
     *Method :- createClientDate
     *Description :- Method to display Client Date
**/
    public void createClientDate() {
        Integer effectiveMonth;
        if (CRD.Client_Effective_Date__c != null) {
            effectiveMonth = CRD.Client_Effective_Date__c.month();
        } else {
            effectiveMonth = 0;
        }
        if (effectiveMonth == 1) {
            clientDate = JAN;
        } else if (effectiveMonth == 2) {
            clientDate = FEB;
        } else if (effectiveMonth == 3) {
            clientDate = MAR;
        } else if (effectiveMonth == 4) {
            clientDate = APR;
        } else if (effectiveMonth == 5) {
            clientDate = MAY;
        } else if (effectiveMonth == 6) {
            clientDate = JUN;
        } else if (effectiveMonth == 7) {
            clientDate = JUL;
        } else if (effectiveMonth == 8) {
            clientDate = AUG;
        } else if (effectiveMonth == 9) {
            clientDate = SEP;
        } else if (effectiveMonth == 10) {
            clientDate = OCT;
        } else if (effectiveMonth == 11) {
            clientDate = NOV;
        } else if (effectiveMonth == 12) {
            clientDate = DEC;
        } else {
            clientDate = ' ';
        }
    }
}