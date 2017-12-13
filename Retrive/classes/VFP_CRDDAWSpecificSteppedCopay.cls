/*Purpose: Apex Class for DAW Specific Stepped Copay Screen on CRD Wizard.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Sourabh                01/09/2012       Apex Class for DAW Specific Stepped Copay Screen on CRD Wizard.
======================================================================== */
public with sharing class VFP_CRDDAWSpecificSteppedCopay {
    /*list of Wrapper Class to maintain the Copay Tiers */
    public List < dawSpecificCopayWrapper > steppedMailCopayWrapper {
        set;
        get;
    }
    public List < dawSpecificCopayWrapper > steppedRetailCopayWrapper {
        set;
        get;
    }
    public List < dawSpecificCopayWrapper > steppedPaperCopayWrapper {
        set;
        get;
    }
    public List < dawSpecificCopayWrapper > steppedSpecialityCopayWrapper {
        set;
        get;
    }
    public List < dawSpecificCopayWrapper > steppedOONCopayWrapper {
        set;
        get;
    }
    public List < dawSpecificCopayWrapper > steppedSpecialtyOONCopayWrapper {
        set;
        get;
    }

    public list < String > errorMessages {
        get;
        set;
    }

    public List < DAW_Specific_Copay__c > lstDAWSpecificCopay = new list < DAW_Specific_Copay__c > ();
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';   
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING DRUG = 'Drug';
    PRIVATE STATIC FINAL STRING MAILDAWCODE = 'Mail - DAW Code ';
    PRIVATE STATIC FINAL STRING PAPER = 'Paper';
    PRIVATE STATIC FINAL STRING PAPERDAWCODE = 'Paper - DAW Code ';
    PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
    PRIVATE STATIC FINAL STRING RETAILDAWCODE = 'Retail - DAW Code ';
    PRIVATE STATIC FINAL STRING SPECIALITY = 'Specialty';
    PRIVATE STATIC FINAL STRING SPECIALITYDAWCODE = 'Specialty - DAW Code ';
    PRIVATE STATIC FINAL STRING PAPEROON = 'Paper Out of Network';
    PRIVATE STATIC FINAL STRING PAPEROONDAWCODE = 'Paper Out Of Network- DAW Code ';
    PRIVATE STATIC FINAL STRING SPECIALITYOON = 'Specialty OON';
    PRIVATE STATIC FINAL STRING SPECIALITYOONDAWCODE = 'Specialty OON- DAW Code';
    PRIVATE STATIC FINAL STRING CRDDAWSPCOPAYURL = '/apex/VF_CRDNewDAWSpecificCopay?crdid=';
    PRIVATE STATIC FINAL STRING CRDDC2URL = '/apex/VF_CRDDrugCoverageStep2?crdid=';

    /*Flags to maintain Sections based on available Tiers*/
    public boolean isSteppedMail {
        set;
        get;
    }
    public boolean isSteppedRetail {
        set;
        get;
    }
    public boolean isSteppedPaper {
        set;
        get;
    }
    public boolean isSteppedSpeciality {
        set;
        get;
    }
    public boolean isSteppedOON {
        set;
        get;
    }
    public boolean isSteppedSpecialtyOON {
        set;
        get;
    }
    public boolean isSteppedCopaDataAvailable {
        set;
        get;
    }

    public string retailParentId {
        get;
        set {
            retailParentId = value;
        }
    }
    public string mailParentId {
        get;
        set {
            mailParentId = value;
        }
    }
    public string paperParentId {
        get;
        set {
            paperParentId = value;
        }
    }
    public string specialityParentId {
        get;
        set {
            specialityParentId = value;
        }
    }
    public string oonParentId {
        get;
        set {
            oonParentId = value;
        }
    }
    public string SpecialtyoonParentId {
        get;
        set {
            SpecialtyoonParentId = value;
        }
    }

    public string crdId {
        set;
        get;
    }
    public CRD__c crd {
        get;
        set;
    }

    /* Constructor for the controller class */
    public VFP_CRDDAWSpecificSteppedCopay(ApexPages.StandardController controller) {
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        crd = [select id, Y_Schd__c, Integrate_with_Medical__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Mail_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Retail_copays__c, name, Plan_Type_Paper__c, Insured_Type__c,Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c from CRD__c where id = : crdId LIMIT 100000];
        lstDAWSpecificCopay = [Select DAW_Code__c, SteppedCopayCount__c, Stepped__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, RecordTypeId, RecordType.Name, (SELECT Beginning_Range__c, Copay_Calculation__c, Stepped_CoPay_Type__c, CRD_ID__c, DAW_Specific_Copay_ID__c, Dollar_Amount__c, End_Range__c, Id, Number_of_Steps__c, Maximum_Dollar__c, Minimum_Dollar__c, Name, Percent__c, Reverse__c FROM DAW_Specific_Stepped_Copays__r order by Name LIMIT 100000)
        From DAW_Specific_Copay__c where Stepped__c = true and CRD_ID__c = : crdId LIMIT 100000];

        errorMessages = new list < String > ();
        steppedMailCopayWrapper = new List < dawSpecificCopayWrapper > ();
        steppedRetailCopayWrapper = new List < dawSpecificCopayWrapper > ();
        steppedPaperCopayWrapper = new List < dawSpecificCopayWrapper > ();
        steppedSpecialityCopayWrapper = new List < dawSpecificCopayWrapper > ();
        steppedOONCopayWrapper = new List < dawSpecificCopayWrapper > ();
        steppedSpecialtyOONCopayWrapper = new List < dawSpecificCopayWrapper > ();

        if (lstDAWSpecificCopay != null && lstDAWSpecificCopay.size() > 0) {
            isSteppedCopaDataAvailable = true;
            for (DAW_Specific_Copay__c ctl: lstDAWSpecificCopay) {
                if (MAIL.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedMail = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = MAILDAWCODE + ctl.DAW_Code__c;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedMailCopayWrapper.add(sw);
                }
                if (PAPER.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedPaper = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = PAPERDAWCODE + ctl.DAW_Code__c;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);

                    steppedPaperCopayWrapper.add(sw);
                }
                if (RETAIL.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedRetail = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = RETAILDAWCODE + ctl.DAW_Code__c;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedRetailCopayWrapper.add(sw);
                }
                if (SPECIALITY.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedSpeciality = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = SPECIALITYDAWCODE + ctl.DAW_Code__c;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedSpecialityCopayWrapper.add(sw);
                }
                if (PAPEROON.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedOON = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = PAPEROONDAWCODE + ctl.DAW_Code__c;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedOONCopayWrapper.add(sw);
                }
                if (SPECIALITYOON.equalsIgnoreCase(ctl.RecordType.Name)) {
                    isSteppedSpecialtyOON = true;
                    dawSpecificCopayWrapper sw = new dawSpecificCopayWrapper();
                    sw.dawSpecificSteppedCopayItemList = ctl.DAW_Specific_Stepped_Copays__r;
                    if (ctl.DAW_Specific_Stepped_Copays__r != null && ctl.DAW_Specific_Stepped_Copays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.DAW_Specific_Stepped_Copays__r[0].Stepped_CoPay_Type__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.relatedDrugName = DRUG;
                    sw.relatedDrugName = SPECIALITYOONDAWCODE + ctl.DAW_Code__c;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedSpecialtyOONCopayWrapper.add(sw);
                }
            }
        }
    }
    /*Creating the Items for number of steps */
    public list < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        for (integer i = 0; i < = integer.valueOf(System.Label.CL0000018); i++)
        options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        return options;
    }
    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void sortOOnlist() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedOONCopayWrapper.size(); i++) {
            if (steppedOONCopayWrapper.get(i).copayTierId == oonParentId) {

                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : oonParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedOONCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);
                    steppedOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);
                }
            }
        }
    }
    
    /*This method creates the dynamic input for the Specialty OON panel on the basis of no of steps selected by user*/
    public void sortSpecialtyOOnlist() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedSpecialtyOONCopayWrapper.size(); i++) {
            if (steppedSpecialtyOONCopayWrapper.get(i).copayTierId == SpecialtyoonParentId) {

                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : SpecialtyoonParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedSpecialtyOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialtyOONCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedSpecialtyOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);
                    steppedSpecialtyOONCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);
                }
            }
        }
    }

    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void sortRetaillist() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedRetailCopayWrapper.size(); i++) {
            if (steppedRetailCopayWrapper.get(i).copayTierId == retailParentId) {

                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : retailParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedRetailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedRetailCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedRetailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);
                    steppedRetailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);
                }
            }
        }
    }
    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortMailList() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();


        for (Integer i = 0; i < steppedMailCopayWrapper.size(); i++) {
            if (steppedMailCopayWrapper.get(i).copayTierId == mailParentId) {

                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : mailParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }


                steppedMailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedMailCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedMailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);

                    steppedMailCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }
    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortPaperList() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedPaperCopayWrapper.size(); i++) {
            if (steppedPaperCopayWrapper.get(i).copayTierId == paperParentId) {
                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : paperParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }
                steppedPaperCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedPaperCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedPaperCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);

                    steppedPaperCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }
    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortSpecialityList() {
        list < DAW_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < DAW_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedSpecialityCopayWrapper.size(); i++) {
            if (steppedSpecialityCopayWrapper.get(i).copayTierId == specialityParentId) {
                lstStepped2ReplaceCopay = [select id from DAW_Specific_Stepped_Copay__c where DAW_Specific_Copay_ID__c = : specialityParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedSpecialityCopayWrapper.get(i).dawSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialityCopayWrapper.get(i).noOfSteps; j++) {
                    DAW_Specific_Stepped_Copay__c d = new DAW_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedSpecialityCopayWrapper.get(i).dawSpecificSteppedCopayItemList.size() + 1);
                    steppedSpecialityCopayWrapper.get(i).dawSpecificSteppedCopayItemList.add(d);
                }
            }
        }
    }

    public static final List < Schema.PicklistEntry > PickValue = DAW_Specific_Stepped_Copay__c.Stepped_CoPay_Type__c.getDescribe().getPicklistValues();
    /* Method to get the value of the Type of Step Copay */
    public List < SelectOption > getTypeOfStepCopay() {
        List < SelectOption > options = new List < SelectOption > ();
        for (Schema.PicklistEntry P: PickValue)
        options.add(new Selectoption(p.getValue(), p.getLabel()));

        return options;
    }
    /* Method for the functionality of the back button */
    public PageReference previousStep() {
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid = false;
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            /*validating the Copay Items before save*/
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedOONCopayWrapper != null && steppedOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedSpecialtyOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }


            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOONCopayWrapper != null && steppedOONCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedOONCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOONCopayWrapper);
            }
            if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedSpecialtyOONCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialtyOONCopayWrapper);
            }
        } catch (exception e) {
            // roll everything back in case of error
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            Database.rollback(sp);
            return null;
        }
        PageReference pageRef = new PageReference(CRDDAWSPCOPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
    
    /* Method for the Back button for users not in public group */
    public PageReference previousStep2() {
        PageReference pageRef = new PageReference(CRDDAWSPCOPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
    
    /*Method for the functionality of the Next button */
    public PageReference Next() {
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid = false;
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            /*validating the Copay Items before save*/
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
            if (steppedOONCopayWrapper != null && steppedOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }
             if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validatedawSpecificSteppedCopay(steppedSpecialtyOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            }


            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOONCopayWrapper != null && steppedOONCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedOONCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOONCopayWrapper);
            }
            if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                //Code added for request 273
                for (dawSpecificCopayWrapper wrap: steppedSpecialtyOONCopayWrapper) {
                    if (wrap.dawSpecificSteppedCopayItemList == null || wrap.dawSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialtyOONCopayWrapper);
            }
        } catch (exception e) {
            // roll everything back in case of error
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            Database.rollback(sp);
            return null;
        }
        PageReference pageRef = new PageReference(CRDDC2URL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

    /* Method for the next button story */
    public PageReference Next2() {
        PageReference pageRef = new PageReference(CRDDC2URL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

    /*Method to save the Tier information from  user screen takes the list of Tier along with recordType name*/
    public void saveWrappedList(List < dawSpecificCopayWrapper > wrappedList) {

        list < DAW_Specific_Stepped_Copay__c > tempList = new list < DAW_Specific_Stepped_Copay__c > ();
        for (dawSpecificCopayWrapper wrap: wrappedList) {
            if (wrap.dawSpecificSteppedCopayItemList != null && wrap.dawSpecificSteppedCopayItemList.size() > 0) {
                for (DAW_Specific_Stepped_Copay__c ct: wrap.dawSpecificSteppedCopayItemList) {
                    DAW_Specific_Stepped_Copay__c tempCopay = new DAW_Specific_Stepped_Copay__c();
                    tempCopay = ct;
                    if (tempCopay.DAW_Specific_Copay_ID__c == null) {
                        tempCopay.DAW_Specific_Copay_ID__c = wrap.copayTierId;
                    }
                    tempCopay.Stepped_CoPay_Type__c = wrap.TypeOfStepCopay;
                    tempCopay.Copay_Calculation__c = ct.Copay_Calculation__c;
                    tempCopay.Beginning_Range__c = ct.Beginning_Range__c;
                    tempCopay.End_Range__c = ct.End_Range__c;
                    tempCopay.Dollar_Amount__c = ct.Dollar_Amount__c;
                    tempCopay.Maximum_Dollar__c = ct.Maximum_Dollar__c;
                    tempCopay.Minimum_Dollar__c = ct.Minimum_Dollar__c;
                    tempCopay.Percent__c = ct.Percent__c;
                    tempCopay.Reverse__c = ct.Reverse__c;
                    tempList.add(tempCopay);
                }
            }
        }

        if (tempList != null && tempList.size() > 0) {
            database.upsert(tempList);
            tempList.clear();
        }

    }


    /* Wrapper class to maintain Steps for each copay Tier */
    public class dawSpecificCopayWrapper {
        public Id copayTierId {
            get;
            set;
        }
        public Integer noOfSteps {
            get;
            set;
        }
        public String TypeOfStepCopay {
            get;
            set;
        }
        public String relatedDrugName {
            get;
            set;
        }
        public list < DAW_Specific_Stepped_Copay__c > dawSpecificSteppedCopayItemList {
            get;
            set;
        }
        /* Constructor for the wrapper class */
        public dawSpecificCopayWrapper() {
            dawSpecificSteppedCopayItemList = new List < DAW_Specific_Stepped_Copay__c > ();
            noOfSteps = 0;
        }
    }
}