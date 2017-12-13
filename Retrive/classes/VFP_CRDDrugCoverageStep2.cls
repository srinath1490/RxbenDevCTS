/*Purpose: Apex  Controller Class for VF_CRDDrugCoverageStep2
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Abhay                07/25/2011      Apex Class for VF_CRDDrugCoverageStep2
   1.1 -    Anuj                 02/28/2012      I71 -    Rishabh              03/11/2013      Modified for Request 900 [Accenture 04/2013]
   3.2 -    rakesh               03/26/2013      Modified for Request 00012 [Accenture 04/2013]
   3.3 -    rahul                06/11/2013      Modified for Request 01016 [Accenture 06/2013]
   3.4 -    Sushant              07/29/2013      Modified for Request 01112
   3.4 -    abhishek             10/4/2013       Modified for Request 01142
   3.5 -    Abhishek             11/6/2013       Modified for Request 01270
   4.0 -    Amit                 27 Nov 2013     Modified for Request 1208
   4.1 -    Joognu Rao           19 May 2014     Modified for Request 4813
   4.2 -    Joognu Rao           17 June 2014    Implemented Request 4719
   5.0 -    Nikita Bansal        07/29/2015      Implemented Request 05947
   6.0 -    Bhaskar Arora        11/17/2016      Implemented Request 06770 Reverted as per updated RRC
======================================================================== */
public with sharing class VFP_CRDDrugCoverageStep2 {
    public CRD__c crd {
        get;
        set;
    }
    public boolean isRecordTypeMail {
        get;
        set;
    }
    public boolean isRecordTypeSpeciality {
        get;
        set;
    }
    public boolean isRecordTypeRetail {
        get;
        set;
    }
    public string groupMember{get;set;}
    public String editMode{
      get;
      set;
    }
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';   
    PRIVATE STATIC FINAL STRING DCID1 = 'dcId';
    PRIVATE STATIC FINAL STRING MASTER = 'Master';
    PRIVATE STATIC FINAL STRING NONE1 = 'none';
    PRIVATE STATIC FINAL STRING NONE2 = '-None-';
    PRIVATE STATIC FINAL STRING WODURL = '/apex/VF_WaiverOfDeductible?crdid=';
    PRIVATE STATIC FINAL STRING DCURL = '/apex/VF_CRDDrugCoverageStep2?crdid=';
    PRIVATE STATIC FINAL STRING CRDDAWSPCOPAYURL = '/apex/VF_CRDDAWSpecificSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING CRDNEWDAWCOPAY = '/apex/VF_CRDNewDAWSpecificCopay?crdid=';
    PRIVATE STATIC FINAL STRING CRDNEWDRUGSPCOPAYURL = '/apex/VF_CRDNewDrugSpecificCoPay?crdid=';
    PRIVATE STATIC FINAL STRING STEPPERCOPAYURL = '/apex/VF_CRDNewSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING CRDNEWCOPAYURL = '/apex/VF_CRDNewCoPay?id=' ;
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING MANDATORY = 'Mandatory';
    PRIVATE STATIC FINAL STRING NOTAPPLICABLE = 'Not Applicable';
    PRIVATE STATIC FINAL STRING VOLUNTARY = 'Voluntary';
    PRIVATE STATIC FINAL STRING INCENTIVIZED = 'Incentivized';
    PRIVATE STATIC FINAL STRING SELFINSURED = 'Self Insured';
    PRIVATE STATIC FINAL STRING YES= 'Yes';
    PRIVATE STATIC FINAL STRING NO = 'No';
    public boolean isHavingSpeciality {
        get;
        set;
    }
    public boolean ismmoIncentive {
        get;
        set;
    }
    public boolean isMultiIndregient {
        get;
        set;
    }
    public boolean isMandatoryGeneric {
        get;
        set;
    }
    public boolean isCopiedRecord;
    public string selectedDrugId {
        get;
        set;
    }
    public string userSelectionRecordTypeName {
        get;
        set;
    }
    public boolean isDeletionCheckboxSelected {
        get;
        set;
    }
    public list < Copay_Tier__c > lstCurrentRetailCopays;
    public list < Copay_Tier__c > lstCurrentMailCopays;


    public Drug_Coverage__c drugCoverage {
        get;
        set;
    }
    Public Drug_Coverage__c drugCoverageClone {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public string drugCoverageId {
        get;
        set;
    }
    Public List < SelectOption > recordTypeOptions {
        get;
        set;
    }
    public list < Drug_Coverage__c > lstDrugCoverage {
        get;
        set;
    }
    public list < DrugCoverageWrapper > lstDrugCoverageWrapper {
        get;
        set;
    }
    public string recordTypeValue {
        get;
        set;
    }
    public DC_Drug_List_Group__c dcDrugList {
        get;
        set;
    }
    public list < DCListWrapper > DCListWrapperlist {
        get;
        set;
    }
    list < DC_Drug_List_Group__c > lstNewDCDrugList = new List < DC_Drug_List_Group__c > ();

    list < CRD__c > lstCRD = new list < CRD__c > ();
    public list < String > errorMessages {
        get;
        set;
    }
    /** 
     * Constructor of class VFP_CRDDrugCoverageStep2
    **/
    public VFP_CRDDrugCoverageStep2(ApexPages.StandardController stdController) {
        editMode=ApexPages.CurrentPage().getParameters().get('p1');
        groupMember=ApexPages.CurrentPage().getParameters().get('p2');
        
        List < Schema.RecordTypeInfo > objListrecType = Drug_Coverage__c.sObjectType.getDescribe().getRecordTypeInfos();
        recordTypeOptions = new List < SelectOption > ();
        this.drugCoverage = (Drug_Coverage__c) stdController.getRecord();
        if (drugCoverage.Standard_Refill_too_Soon__c == '' || drugCoverage.Standard_Refill_too_Soon__c == Null) {
            drugCoverage.Standard_Refill_too_Soon__c = 'No';
        }        
        lstDrugCoverage = new list < Drug_Coverage__c > ();
        lstDrugCoverageWrapper = new list < DrugCoverageWrapper > ();
        errorMessages = new list < String > ();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        drugCoverageId = ApexPages.CurrentPage().getParameters().get(DCID1);
        if (crdId != null) {
            lstDrugCoverage = [select name, Days_Per_Fill__c, Use_Medispan_Indicator__c, No_of_fills_allowed_at_retail__c,Force_to_Specialty__c, Custom_MMOD_VMOD_Drug_List__c, Use_Standard_MMOD_VMOD_Drug_List__c, Formulary_Open_Closed__c, Standard_Refill_too_Soon__c, Custom_Refill_too_Soon__c, Formulary__c,Compounds_with_1_Federal_Legend_Drug__c, Smoking_Cessation_Aids__c, Norplan__c, Nutritional_Dietary_Supplies_PKU__c, Cost_Amount__c, Cost_Type__c, Apply_difference_of_cost__c, Maintenance_Choice__c, recordType.Name, id, Aetna_Specialty_Care_Rx__c, Choose_Generic_Copay_Diff_Exclusion__c, Custom_Inclusion_Drug_Group__c, Custom_Exclusion_Drug_Group__c,Brand_Penalty_Based_Retail_Mail_AWP__c, Brand_Penalty_Dollar_Amount__c, Brand_Penalty_Maximum_Dollar__c, Brand_Penalty_Minimum_Dollar__c, Brand_Penalty_Percent__c, Brand_Penalty_Type__c, Generic_Penalty_Dollar_Amount__c, Generic_Penalty_Maximum_Dollar__c, Generic_Penalty_Minimum_Dollar__c, Generic_Penalty_Percent__c, Generic_Penalty_Type__c, Gen_Penalty_Based_Retail_Mail_AWP__c, Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c, Non_Pref_Brand_Penalty_Dollar_Amount__c, Non_Pref_Brand_Penalty_Maximum_Dollar__c, Non_Pref_Brand_Penalty_Minimum_Dollar__c, Non_Pref_Brand_Penalty_Percent__c, Non_Pref_Brand_Penalty_Type__c, Incentivized_Mail_Brand_Penalty_Amount__c, Incentivized_Mail_Brand_Penalty_Type__c, Incentivized_Mail_Generic_Penalty_Amount__c, Incentivized_Mail_Generic_Penalty_Type__c, Incent_Mail_NonPref_Brand_Penalty_Amount__c, Incent_Mail_NonPref_Brand_Penalty_Type__c,Mandatory_Mail_Order_Option__c,Exception_Drug_Group__c,Minimum_days_supply__c,Do_you_have_Choose_Generic__c,Maximum_days_supply__c,Minimum_quantity__c,Maximum_quantity__c,What_is_the_Penalty__c,Rule_for_supply_quantity__c,Speciality_Drug_List__c,of_fills_before_force_to_specialty__c,/*Multi_Ingredient_Compounds__c,Max_Day_Supply__c,Copay_Based_On__c,Refill_Limits__c,DUR__c,OTC__c,DUR_Message_Type__c,Brand_Generic__c,X3rd_Party_Exceptions__c,DEA__c,Dosage_Form__c,DESI__c,Maintenance_Form__c,Packaging_Exceptions__c,FDA_Therapeutic_Equivalent__c,FDA_Therapeutic_Category__c,*/fills_before_MMO_option_is_invoked__c,Number_of_Periods__c,Period_Type__c,Restart_Fills__c,Incent_Mail_Gen_Penalty_Percent__c,Incent_Mail_NP_Brand_Penalty_Percent__c,Incent_Mail_Gen_Penalty_Min__c,Incent_Mail_NP_Brand_Penalty_Min__c,Incent_Mail_Gen_Penalty_Max__c,Incent_Mail_NP_Brand_Penalty_Max__c,Incent_Mail_Brand_Penalty_Percent__c,Incent_Mail_Brand_Penalty_Min__c,Incent_Mail_Brand_Penalty_Max__c,Allow_Transition_Fill__c,Retail_Refill_Allowance_No_of_days__c,Transition_Fill_Number_of_Days__c,RRA_Drug_List__c,RSO_Drug_List__c,Does_Dose_Limit_apply__c,Dose_Limit__c,Higher_Lower_than__c,Dose_Limit_Exception_Drug_List__c,Number_of_fills__c From Drug_Coverage__c where CRD_ID__c = : crdId LIMIT 100000];
        }
        if (lstDrugCoverage != null && lstDrugCoverage.size() > 0) {
            for (Drug_Coverage__c drugC: lstDrugCoverage) {
                DrugCoverageWrapper wrap = new DrugCoverageWrapper();

                wrap.drugCoverage = drugC;
                lstDrugCoverageWrapper.add(wrap);
            }
        }

        lstCRD = [Select id,Acquisition_Indicator__c,National__C,Plan_Platform__c,Effective_Start_Date__c,Contract_state__c, Y_Schd__c, Retail_to_Mail__c, Any_DAW_specific_Paper_OON_copays__c, Any_drug_specific_Paper_Out_of_Network__c, Any_DAW_specific_Mail_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Specialty_copays__c, Daw_Specific_Stepped_Copay_Count__c, Plan_Type_Specialty__c, Plan_Type_Retail__c, Any_drug_specific_Retail_copays__c, Plan_Type_Mail__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Specialty_copays__c, Durg_Specific_Stepped_Count__c, Integrate_with_Medical__c, Insured_Type__c, Name, Plan_Type_Paper__c, SteppedCopayCount__c, Any_drug_specific_Mail_copays__c,Standard_or_Custom_Plan__c , (select id, RecordTypeId, Name from Drug_Coverage__r) From CRD__c Where ID = : crdId LIMIT 100000];
        if (lstCRD != null && lstCRD.size() > 0) {
            crd = lstCRD.get(0);
        }

        recordTypeOptions.add(new Selectoption(NONE1, NONE2));
        for (Schema.RecordTypeInfo recType: objListrecType) {
            if (recType.name != MASTER) {
                recordTypeOptions.add(new Selectoption(recType.getRecordTypeId(), recType.name));
            }
        }
        DCListWrapperlist = new list < DCListWrapper > ();
        recordTypeValue = NONE1;
        isDeletionCheckboxSelected = true;
        isRecordTypeRetail = false;
        isMultiIndregient = false;
    }
    public PageReference copyDrugCoverageValues() {
        string mailId;
        List < Schema.RecordTypeInfo > recType = Drug_Coverage__c.sObjectType.getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo objListrecType: recType) {
            if (MAIL.equalsIgnoreCase(objListrecType.name)) mailId = objListrecType.getRecordTypeId();
        }
        Decimal refillOldvalue;
        Decimal maxDaysSuppliedOldValue;

        maxDaysSuppliedOldValue = this.drugCoverage.Maximum_days_supply__c;
        if (selectedDrugId != null) {
            drugCoverageClone = [Select d.of_fills_before_force_to_specialty__c, d.fills_before_MMO_option_is_invoked__c, /*d.X3rd_Party_Exceptions__c,*/ d.What_is_the_Penalty__c, d.What_Option__c, d.Standard_Refill_too_Soon__c, d.Speciality_Drug_List__c, d.Smoking_Cessation_Aids__c, d.Rule_for_supply_quantity__c, /*d.Refill_Percentage__c, d.Refill_Limits__c,*/ d.Period_Type__c,/* d.Packaging_Exceptions__c, d.OTC__c,*/ d.Nutritional_Dietary_Supplies_PKU__c, d.Number_of_Periods__c, d.Norplan__c, /*d.Multi_Ingredient_Compounds__c,*/ d.Minimum_quantity__c, d.Minimum_days_supply__c,  d.Maximum_quantity__c, d.Maximum_days_supply__c, /*d.Max_Day_Supply__c,*/ d.Mandatory_Mail_Order_Option__c, /*d.Maintenance_Form__c,*/ d.Maintenance_Choice__c, /* d.Mailing_Template__c,*/ d.Mailing_Options__c, d.Lookback_Period__c, d.Grandfathering_for__c, d.Formulary__c, d.Formulary_Open_Closed__c, d.Force_to_Specialty__c, /*d.FDA_Therapeutic_Equivalent__c, d.FDA_Therapeutic_Category__c,*/ d.Exception_Drug_List__c, d.Exception_Drug_Group__c,/*d.Dosage_Form__c, d.Dollar_Amount__c, */d.Do_you_have_Choose_Generic__c,/*d.DUR__c, d.DUR_Message_Type__c, d.DESI__c, d.DEA__c,*/ d.Custom_Refill_too_Soon__c, d.Custom_NDC_GPI_List__c, d.Custom_NDC_GPI_List_ID__c, d.Custom_MMOD_VMOD_Drug_List__c, d.Cost_Type__c, d.Cost_Amount__c,/*d.Copay_Based_On__c,*/d.Compounds_with_1_Federal_Legend_Drug__c, /*d.Co_Insurance_Percentage__c, */ d.Co_Insurance_Dollar_Amount__c, d.CRD_ID__c, /*d.Brand_Generic__c,*/ d.Apply_difference_of_cost__c,d.Brand_Penalty_Based_Retail_Mail_AWP__c, d.Brand_Penalty_Dollar_Amount__c, d.Brand_Penalty_Maximum_Dollar__c, d.Brand_Penalty_Minimum_Dollar__c, d.Brand_Penalty_Percent__c, d.Brand_Penalty_Type__c, d.Generic_Penalty_Dollar_Amount__c, d.Generic_Penalty_Maximum_Dollar__c, d.Generic_Penalty_Minimum_Dollar__c, d.Generic_Penalty_Percent__c, d.Generic_Penalty_Type__c, d.Gen_Penalty_Based_Retail_Mail_AWP__c,d.RRA_Drug_List__c,d.RSO_Drug_List__c,d.Retail_Refill_Allowance_No_of_days__c,d.Allow_Transition_Fill__c,d.Transition_Fill_Number_of_Days__c,d.Does_Dose_Limit_apply__c,d.Dose_Limit__c,d.Higher_Lower_than__c,d.Dose_Limit_Exception_Drug_List__c From Drug_Coverage__c d where d.id = : selectedDrugId LIMIT 100000];
            this.drugCoverage = drugCoverageClone.clone(false);
            this.drugCoverage.fills_before_MMO_option_is_invoked__c = null;
            this.drugCoverage.Number_of_Periods__c = null;
            this.drugCoverage.Period_Type__c = null;
           
            if (recordTypeValue == mailId) {
                isMultiIndregient = false;
                //this.drugCoverage.Multi_Ingredient_Compounds__c = Null;
                //this.drugCoverage.Copay_Based_On__c = null;
                this.drugCoverage.Custom_NDC_GPI_List_ID__c = null;
                //this.drugCoverage.Dollar_Amount__c = null;
                //this.drugCoverage.Max_Day_Supply__c = null;
                //this.drugCoverage.Dosage_Form__c = null;
                //this.drugCoverage.Refill_Limits__c = null;
                //this.drugCoverage.DESI__c = null;
                //this.drugCoverage.OTC__c = null;
                //this.drugCoverage.Maintenance_Form__c = null;
                //this.drugCoverage.Brand_Generic__c = null;
                //this.drugCoverage.Packaging_Exceptions__c = null;
                //this.drugCoverage.X3rd_Party_Exceptions__c = null;
                //this.drugCoverage.FDA_Therapeutic_Equivalent__c = null;
                //this.drugCoverage.DEA__c = null;
                //this.drugCoverage.FDA_Therapeutic_Category__c = null;
                //this.drugCoverage.DUR__c = null;
                //this.drugCoverage.DUR_Message_Type__c = null;
            }
            isCopiedRecord = true;
        }
        return null;
    }

    /*****************************************************************************
    Method: addDrugClassRecords()
    Purpose: This function will check two field 
             (i) Exception Group Class
             (ii) Exception Group List
             if value of above fields is NULL then Query from DC Drug Class 
             and get value of mapped fields.
             Otherwise no action if value is there.
 
    Modified Date: 23 Aug 2012
    ******************************************************************************/
    /*Method Commented By Amit
    public void addDrugClassRecords() {

        //Map<id,DC_Drug_Class__c> mapDrugClasses = new Map<id,DC_Drug_Class__c>([select id,name,Drug_Group__c,Drug_List__c,Drug_Class__c,Inclusion_Exclusion__c from DC_Drug_Class__c where Mandatory__c='Yes']);
        //Modified by Amit Jain for Request 1208 on 27th Nov 2013
        //Added field Bypass_M__c, Bypass_MOOP__c
        List < DC_Drug_Class__c > lstDrugClasses = new List < DC_Drug_Class__c >();
        List < DC_Drug_Class__c > lstDrugClassesMail = new List < DC_Drug_Class__c >();
                
        String state = crd.contract_state__c;  
        String segment = crd.National__c;
        String carrier = crd.Plan_Platform__c;
        if((crd.Standard_or_Custom_Plan__c == 'Creating a HIX plan' || crd.Standard_or_Custom_Plan__c == 'Cloning a HIX plan from existing CRD') && (crd.Standard_or_Custom_Plan__c != NULL)){
        lstDrugClasses = [select id, name,/Carrier__c,Segment__c,contract_state__c, Plan_Effective_Date__c,/Drug_Group__c, Drug_List__c, Drug_Class__c, Inclusion_Exclusion__c, Apply_Limitations__c, Quantity_Over_Time_Quantity__c, Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Start_Age__c, Start_Age_Type__c,Bypass_M__c/HIX__C,HIX_Commercial__c/ from DC_Drug_Class__c where(Mandatory__c = 'Yes' AND For_Retail_Drug_Coverage__c = True /* AND HIX_Commercial__c = 'HIX' AND Contract_state__c = :state AND segment__c = :segment AND /carrier__c = :carrier AND Plan_Effective_Date__c = :crd.Effective_Start_Date__c/)];//Richa : Request 4274 fields commented for UAT Deployment of Post December Release
        lstDrugClassesMail = [select id, name,/Carrier__c,Segment__c,contract_state__c,Plan_Effective_Date__c/ Drug_Group__c, Drug_List__c, Drug_Class__c, Inclusion_Exclusion__c, Apply_Limitations__c, Quantity_Over_Time_Quantity__c, Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Start_Age__c, Start_Age_Type__c,Bypass_M__c/*HIX__C,HIX_Commercial__c/ from DC_Drug_Class__c where(Mandatory__c = 'Yes' AND For_Mail_Drug_Coverage__c = True /*AND HIX_Commercial__c = 'HIX' AND segment__c = :segment AND carrier__c = :carrier AND Plan_Effective_Date__c = :crd.Effective_Start_Date__c/)];//Richa : Request 4274 fields commented for UAT Deployment of Post December Release
}

        else if((crd.Standard_or_Custom_Plan__c == 'Creating a custom plan' || crd.Standard_or_Custom_Plan__c == 'Cloning a custom plan from existing CRD' || crd.Standard_or_Custom_Plan__c == 'Creating a package plan' || crd.Standard_or_Custom_Plan__c == 'Cloning a package plan from existing CRD' || crd.Standard_or_Custom_Plan__c == 'Creating a packaged consumer business plan' || crd.Standard_or_Custom_Plan__c == 'Cloning a packaged consumer business plan from an existing CRD')&& (crd.Standard_or_Custom_Plan__c != NULL)){
        lstDrugClasses = [select id, name,/Carrier__c,Segment__c,contract_state__c, Plan_Effective_Date__c,/Drug_Group__c, Drug_List__c, Drug_Class__c, Inclusion_Exclusion__c, Apply_Limitations__c, Quantity_Over_Time_Quantity__c, Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Start_Age__c, Start_Age_Type__c,Bypass_M__c/HIX__C,HIX_Commercial__c/ from DC_Drug_Class__c where(Mandatory__c = 'Yes' AND For_Retail_Drug_Coverage__c = True /*AND HIX_Commercial__c = 'Commercial' AND segment__c = :segment AND /carrier__c = :carrier AND Plan_Effective_Date__c = :crd.Effective_Start_Date__c/)];

        lstDrugClassesMail = [select id, name,/Carrier__c,Segment__c,contract_state__c, Plan_Effective_Date__c,/Drug_Group__c, Drug_List__c, Drug_Class__c, Inclusion_Exclusion__c, Apply_Limitations__c, Quantity_Over_Time_Quantity__c, Quantity_Over_Time_Time_Period__c, Quantity_Over_Time_Time_Value__c, Start_Age__c, Start_Age_Type__c,Bypass_M__c/HIX__C,HIX_Commercial__c/ from DC_Drug_Class__c where(Mandatory__c = 'Yes' AND For_Mail_Drug_Coverage__c = True /*AND HIX_Commercial__c = 'Commercial' AND segment__c = :segment AND carrier__c = :carrier AND Plan_Effective_Date__c = :crd.Effective_Start_Date__c/)];
       } List < DC_Drug_List_Group__c > lstDruglistGroup = new List < DC_Drug_List_Group__c > ();
    if (userSelectionRecordTypeName.contains('Retail')) {
            if (lstDrugClasses.size() > 0) {
                //we will create DC_Drug_List_Group__c records and insert them in DC_Drug_List_Group__c

                // dcRecord 
                for (DC_Drug_Class__c tempDrugClasses: lstDrugClasses) {
                //if loop added by Sushant for req 04917
                if(crd.Acquisition_Indicator__c == 'Yes' && tempDrugClasses.Drug_Class__c == 'Commercial System List'){
                    continue;
                    }
                
                    DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
                    //set field values.
                    dcRecord.Related_Drug_Coverage__c = drugCoverage.id;
                    dcRecord.Drug_Group__c = tempDrugClasses.Drug_Group__c;
                   // dcRecord.Inclusion_Exclusion_Drug_Class__c = tempDrugClasses.Drug_Class__c;
                    dcRecord.Drug_List__c = tempDrugClasses.Drug_List__c;
                    dcRecord.Inclusion_Exclusion__c = tempDrugClasses.Inclusion_Exclusion__c;
                    dcRecord.Apply_Limitations__c = tempDrugClasses.Apply_Limitations__c;
                    dcRecord.Quantity_Over_Time_Quantity__c = tempDrugClasses.Quantity_Over_Time_Quantity__c;
                    dcRecord.Quantity_Over_Time_Time_Period__c = tempDrugClasses.Quantity_Over_Time_Time_Period__c;
                    dcRecord.Quantity_Over_Time_Time_Value__c = tempDrugClasses.Quantity_Over_Time_Time_Value__c;
                    dcRecord.Start_Age__c = tempDrugClasses.Start_Age__c;
                    dcRecord.Start_Age_Type__c = tempDrugClasses.Start_Age_Type__c;
                    dcRecord.Bypass_MOOP__c = tempDrugClasses.Bypass_M__c;
                    lstDruglistGroup.add(dcRecord);

                }
            }
        } else if (userSelectionRecordTypeName.contains('Mail')) {
            if (lstDrugClassesMail.size() > 0) {
                //we will create DC_Drug_List_Group__c records and insert them in DC_Drug_List_Group__c

                // dcRecord 
                for (DC_Drug_Class__c tempDrugClasses: lstDrugClassesMail) {
                        //if loop added by Sushant for req 04917
                if(crd.Acquisition_Indicator__c == 'Yes' && tempDrugClasses.Drug_Class__c == 'Commercial System List'){
                    continue;
                    }

                    DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
                    //set field values.
                    dcRecord.Related_Drug_Coverage__c = drugCoverage.id;
                    dcRecord.Drug_Group__c = tempDrugClasses.Drug_Group__c;
                   // dcRecord.Inclusion_Exclusion_Drug_Class__c = tempDrugClasses.Drug_Class__c;
                    dcRecord.Drug_List__c = tempDrugClasses.Drug_List__c;
                    dcRecord.Inclusion_Exclusion__c = tempDrugClasses.Inclusion_Exclusion__c;
                    dcRecord.Apply_Limitations__c = tempDrugClasses.Apply_Limitations__c;
                    dcRecord.Quantity_Over_Time_Quantity__c = tempDrugClasses.Quantity_Over_Time_Quantity__c;
                    dcRecord.Quantity_Over_Time_Time_Period__c = tempDrugClasses.Quantity_Over_Time_Time_Period__c;
                    dcRecord.Quantity_Over_Time_Time_Value__c = tempDrugClasses.Quantity_Over_Time_Time_Value__c;
                    dcRecord.Start_Age__c = tempDrugClasses.Start_Age__c;
                    dcRecord.Start_Age_Type__c = tempDrugClasses.Start_Age_Type__c;
                    dcRecord.Bypass_MOOP__c = tempDrugClasses.Bypass_M__c;
                    lstDruglistGroup.add(dcRecord);

                }

            }
        }
        database.insert(lstDruglistGroup);

    }*/
    /* Method for next button functionality for users not in public group */
    Public PageReference redirectToPaperOptions2(){
        try {
         Pagereference pageRef = new Pagereference(WODURL + crdId);
         pageRef.getParameters().put(EDITMODEPARAM,editMode);
         pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
         return pageRef;
         }
        catch(exception e)
        {
            return null;
        } 
    }
    Public PageReference redirectToPaperOptions() {
        //added this function for request 721
        errorMessages.clear();
        try {

           if (checkMandatorFields() == false) {
                errorMessages.add(system.Label.ERR00085);
                return null;
            }
            if (recordTypeValue != 'none') {

                if (checkDuplicate()) {
                    return null;
                }
                drugCoverage.CRD_ID__c = crdId; //this.crd.id;  
                drugCoverage.RecordTypeId = recordTypeValue;
           
                 if ((drugCoverage.Do_you_have_Choose_Generic__c == null)) {
                    drugCoverage.Do_you_have_Choose_Generic__c.addError(system.Label.ERR00207);
                    return null;
                }
                if ((drugCoverage.Maximum_days_supply__c != null && drugCoverage.Maximum_quantity__c != null) && drugCoverage.Rule_for_supply_quantity__c == null) {
                    drugCoverage.Rule_for_supply_quantity__c.addError(system.Label.ERR00054);
                    return null;
                }
                userSelectionRecordTypeName = getRecordTypeNameByid(recordTypeValue);
                if (userSelectionRecordTypeName.contains(MAIL)) {
                    if((MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || NOTAPPLICABLE.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || VOLUNTARY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c))
                        &&(drugCoverage.Generic_Penalty_Type__c != null || drugCoverage.Non_Pref_Brand_Penalty_Type__c != null || drugCoverage.Generic_Penalty_Dollar_Amount__c != null ||
                           drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != null || drugCoverage.Generic_Penalty_Percent__c != null || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != null ||
                            drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c != null ||  drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c != null || drugCoverage.Generic_Penalty_Minimum_Dollar__c != null ||
                            drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null || drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null || drugCoverage.Generic_Penalty_Maximum_Dollar__c !=null ||
                            drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c !=null || drugCoverage.Brand_Penalty_Type__c !=null || drugCoverage.Brand_Penalty_Dollar_Amount__c !=null || drugCoverage.Brand_Penalty_Percent__c !=null ||
                            drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c !=null || drugCoverage.Brand_Penalty_Minimum_Dollar__c !=null ||  drugCoverage.Brand_Penalty_Maximum_Dollar__c !=null ))
                            {
                                errorMessages.add(system.Label.ERR0212);
                                return null;
                            }
                    if (drugCoverage.Formulary_Open_Closed__c == NULL) {                        
                            drugCoverage.Formulary_Open_Closed__c.addError(system.Label.ERR00207);
                            return null;
                        }                                 
                    if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL || drugCoverage.Brand_Penalty_Percent__c != NULL) {
                        if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00158);
                            return null;
                        }
                    }
                    if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL || drugCoverage.Generic_Penalty_Percent__c != NULL) {
                        if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00159);
                            return null;
                        }
                    }
                    
                    if (crd.Retail_to_Mail__c == TRUE) {
                        if ((drugCoverage.Mandatory_Mail_Order_Option__c != NULL && drugCoverage.Mandatory_Mail_Order_Option__c != 'Not Applicable')
                            || (drugCoverage.Maintenance_Choice__c != NULL && drugCoverage.Maintenance_Choice__c != 'Not Applicable')) {
                            errorMessages.add(system.Label.ERR00161);
                            return null;
                        }
                    }

                    if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL && drugCoverage.Generic_Penalty_Percent__c != NULL) {
                        errorMessages.add(system.Label.ERR00162);
                        return null;
                    }
                    if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL && drugCoverage.Brand_Penalty_Percent__c != NULL) {
                        errorMessages.add(system.Label.ERR00163);
                        return null;
                    }
                    if (drugCoverage.Generic_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Generic_Penalty_Minimum_Dollar__c != NULL) {
                        if (drugCoverage.Generic_Penalty_Maximum_Dollar__c <= drugCoverage.Generic_Penalty_Minimum_Dollar__c) {
                            errorMessages.add(system.Label.ERR00165);
                            return null;
                        }
                    }
                    if (drugCoverage.Brand_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Brand_Penalty_Minimum_Dollar__c != NULL) {
                        if (drugCoverage.Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Brand_Penalty_Minimum_Dollar__c) {
                            errorMessages.add(system.Label.ERR00166);
                            return null;
                        }
                    }
                    if (drugCoverage.Maintenance_Choice__c != NULL && INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if (drugCoverage.Generic_Penalty_Type__c != NULL) {
                            if (drugCoverage.Generic_Penalty_Dollar_Amount__c == NULL && drugCoverage.Generic_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Generic_Penalty_Percent__c == NULL && drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                                errorMessages.add(system.Label.ERR00167);
                                return null;
                            }
                        }
                        if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00167);
                            return null;
                        }
                    }
                    if (drugcoverage.Maintenance_Choice__c != NULL && INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if (drugCoverage.Brand_Penalty_Type__c != NULL) {
                            if (drugCoverage.Brand_Penalty_Dollar_Amount__c == NULL && drugCoverage.Brand_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Brand_Penalty_Percent__c == NULL && drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                                errorMessages.add(system.Label.ERR00168);
                                return null;
                            }
                        }
                        if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00168);
                            return null;
                        }
                    }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL) {
                        if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00173);
                            return null;
                        }
                    }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL && drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL) {
                        errorMessages.add(system.Label.ERR00174);
                        return null;
                    }
                    if (INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                        if (drugCoverage.Non_Pref_Brand_Penalty_Type__c != NULL) {
                            if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Percent__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c == NULL) {
                                errorMessages.add(system.Label.ERR00175);
                                return null;
                            }
                        }
                        if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                            errorMessages.add(system.Label.ERR00175);
                            return null;
                        }
                    }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != NULL) {
                        if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c) {
                            errorMessages.add(system.Label.ERR00176);
                            return null;
                        }
                    }
                    // added by Rishabh K Bansal on 11th Mar'13 for req no: 00900
                     // modified by Abhishek on 6th Nov'13 for req no: 01270
                    if ((MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || VOLUNTARY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c))  && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
                        if (drugCoverage.Mandatory_Mail_Order_Option__c == NULL || drugCoverage.Mandatory_Mail_Order_Option__c != NOTAPPLICABLE) {
                            errorMessages.add(system.Label.ERR00177);
                            return null;
                        }
                    }
                    // modified by Abhishek on 6th Nov'13 for req no: 01270
                    if ((MANDATORY.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) || INCENTIVIZED.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c)) && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c) ) {
                        if (drugCoverage.Maintenance_Choice__c == NULL || drugCoverage.Maintenance_Choice__c !=  NOTAPPLICABLE) {
                            errorMessages.add(system.Label.ERR00178);
                            return null;
                        }
                    }
                    
                }
                if (userSelectionRecordTypeName.contains('Retail')) {
                    if (drugCoverage.Formulary_Open_Closed__c == NULL) {                        
                            drugCoverage.Formulary_Open_Closed__c.addError(system.Label.ERR00207);
                            return null;
                        }
                          //ADDED BY SUSHANT - 6452 CRITERIA 4
                        system.debug('&&&&  ' + drugCoverage.Aetna_Specialty_Care_Rx__c);
                        
                    //Formulary__C frm = [select Group__c from Formulary__c where Id=:drugCoverage.Formulary__c];
                     Formulary__C frm = new Formulary__C(); 
                    if(drugCoverage.Formulary__c != Null){ 
                        frm = [select Group__c from Formulary__c where Id=:drugCoverage.Formulary__c limit 1]; 
                    }
                    system.debug('####   ' + frm.Group__c);
                    if (string.isEmpty(drugCoverage.Aetna_Specialty_Care_Rx__c) && !string.isEmpty(frm.Group__c) && frm.Group__c != 'LG Premier Plus' ) {
                            drugCoverage.Aetna_Specialty_Care_Rx__c.addError(system.Label.ERR00304);
                            return null;
                        }
                    /* Commented By Nitish - 06452 Criteria 4
                    if (drugCoverage.Aetna_Specialty_Care_Rx__c == NULL) {                        
                            drugCoverage.Aetna_Specialty_Care_Rx__c.addError(system.Label.ERR00207);
                            return null;
                        }*/
                    if (drugCoverage.Force_to_Specialty__c == NULL && !string.isEmpty(frm.Group__c) && frm.Group__c != 'LG Premier Plus') {                        
                            drugCoverage.Force_to_Specialty__c.addError(system.Label.ERR00207);
                            return null;
                        }
                    if (drugCoverage.Aetna_Specialty_Care_Rx__c == 'Custom' && drugCoverage.Speciality_Drug_List__c == NULL) {                       
                            errorMessages.add(system.Label.ERR00208);
                            return null;
                        }
                   if (drugCoverage.Force_to_Specialty__c == 'Yes' && drugCoverage.of_fills_before_force_to_specialty__c == NULL) {                       
                            errorMessages.add(system.Label.ERR00209);
                            return null;
                        }
                    if (drugCoverage.Force_to_Specialty__c == 'No' && drugCoverage.of_fills_before_force_to_specialty__c != NULL) {                       
                            errorMessages.add(system.Label.ERR00210);
                            return null;
                        } 
                        /* commented by JR to implement 4712
                     //Added for Request 4592 by Amit Jain on 27 Feb '14
                    if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RRA'){
                        drugCoverage.RRA_Drug_List__c = System.label.DCSRT23;
                    } 
                    if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RSO with Fertility'){
                        drugCoverage.RSO_Drug_List__c = System.label.DCSRT24;
                    }
                    if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RSO without Fertility'){
                        drugCoverage.RSO_Drug_List__c = System.label.DCSRT25;
                    }
                    //4592 ends ***
                    */
                     //Added by JR to implement 4712
                    
                    if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == null && (drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c != NULL || drugCoverage.Secondary_Force_to_Specialty__c!=Null || drugCoverage.Secondary_Speciality_Drug_List__c!=Null || drugCoverage.Secondary_of_fills_before_force_to_SPN__c!=Null)) {                        
                            system.debug('@@@@ ' + drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c);
                            drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c.addError(system.Label.ERR00250);
                            return null;
                        }
                    
                     if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c =='RRA' && drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c == NULL) {                        
                            drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c.addError(system.Label.ERR00245);
                            return null;
                        } 
                   
                    if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c != NULL && drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c !='RRA' && drugCoverage.Secondary_Force_to_Specialty__c == NULL) {                        
                            drugCoverage.Secondary_Force_to_Specialty__c.addError(system.Label.ERR00245);
                            return null;
                        }
                    if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'Custom' && drugCoverage.Secondary_Speciality_Drug_List__c == NULL) {                       
                            drugCoverage.Secondary_Speciality_Drug_List__c.addError(system.Label.ERR00246);
                            return null;
                        }
                   if (drugCoverage.Secondary_Force_to_Specialty__c == 'Yes' && drugCoverage.Secondary_of_fills_before_force_to_SPN__c == NULL) {                       
                            drugCoverage.Secondary_of_fills_before_force_to_SPN__c.addError(system.Label.ERR00247);
                            return null;
                        }
                    if (drugCoverage.Secondary_Force_to_Specialty__c == 'No' && drugCoverage.Secondary_of_fills_before_force_to_SPN__c != NULL) {                       
                            drugCoverage.Secondary_of_fills_before_force_to_SPN__c.addError(system.Label.ERR00248);
                            return null;
                        } 
                    
                }
                    
                    
                   
                
                if (drugCoverage.Mandatory_Mail_Order_Option__c != null && NOTAPPLICABLE.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c)) {
                    drugCoverage.Use_Medispan_Indicator__c = null;
                }
                //Richa added on 19/8 for Req 4692
                /*
                if(DrugCoverage.Formulary__c == null && DrugCoverage.Formulary_Open_Closed__c != null){
                    errorMessages.add(system.Label.ERR0261);
                            return null;    
                }*/
                 //Added By Nitish - 06452 Criteria 5
                if(String.isEmpty(drugCoverage.Aetna_Specialty_Care_Rx__c) || drugCoverage.Aetna_Specialty_Care_Rx__c.equals(NONE1)){
                    drugCoverage.Do_you_have_Specialty__c = NO;
                }
                else{
                    drugCoverage.Do_you_have_Specialty__c = YES;
                }
                if(DrugCoverage.Formulary__c != null){
                    String DCfield; 
                    List<Formulary__c> lstFRM = new List<Formulary__c>([Select Formulary_Open_Closed__c from Formulary__c where Id = :DrugCoverage.Formulary__c AND Formulary_Open_Closed__c != null LIMIT 1]);
                    if(!lstFRM.isempty()){
                         DCfield =  lstFRM[0].Formulary_Open_Closed__c;
                       /* if(DrugCoverage.Formulary_Open_Closed__c == null){
                            errorMessages.add(system.Label.ERR0261);
                            return null;
                        }else */if(!DCfield.contains(DrugCoverage.Formulary_Open_Closed__c)){
                            errorMessages.add(system.Label.ERR0261);
                            return null;
                        }
                    }else{
                       errorMessages.add(system.Label.ERR0262);
                       return null;
                    }
                }
                //Added By Nitish - 06452 Criteria 5
                if(String.isEmpty(drugCoverage.Aetna_Specialty_Care_Rx__c) || drugCoverage.Aetna_Specialty_Care_Rx__c.equals(NONE1)){
                    drugCoverage.Do_you_have_Specialty__c = NO;
                }
                else{
                    drugCoverage.Do_you_have_Specialty__c = YES;
                }
                database.insert(drugCoverage);
                /*if (drugCoverage.Exception_Drug_Group__c == null && drugCoverage.Exception_Drug_List__c == null) {
                    addDrugClassRecords();
                }*/

                this.drugCoverage = new Drug_Coverage__c();

            }
            database.update(crd);
        } catch (exception e) {
               ApexPages.addMessages(e);
            return null;
        }
        //modified by abhay for issue: 1293
        Pagereference pageRef = new Pagereference(WODURL + crdId);
         pageRef.getParameters().put(EDITMODEPARAM,editMode);
         pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }


    Public PageReference saveAndAdd() {
        isDeletionCheckboxSelected = true;
        errorMessages.clear();
        Savepoint sp = Database.setSavepoint();
        try {
            if (NONE1.equalsIgnoreCase(recordTypeValue)) {
                errorMessages.clear();
                errorMessages.add(system.Label.ERR00080);
                return null;
            }
            if (checkDuplicate()) {

                return null;
            }
            drugCoverage.CRD_ID__c = crdId; //this.crd.id;  
            drugCoverage.RecordTypeId = recordTypeValue;
            system.debug('@#@#@# ' + drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c);
            if ((drugCoverage.Do_you_have_Choose_Generic__c == null)) {
                    drugCoverage.Do_you_have_Choose_Generic__c.addError(system.Label.ERR00207);
                    return null;
                }
            if ((drugCoverage.Maximum_days_supply__c != null && drugCoverage.Maximum_quantity__c != null) && drugCoverage.Rule_for_supply_quantity__c == null) {
                drugCoverage.Rule_for_supply_quantity__c.addError(system.Label.ERR00054);
                return null;
            }

            if (userSelectionRecordTypeName.contains(MAIL)) {
            if((MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || NOTAPPLICABLE.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || VOLUNTARY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c))
                        &&(drugCoverage.Generic_Penalty_Type__c != null || drugCoverage.Non_Pref_Brand_Penalty_Type__c != null || drugCoverage.Generic_Penalty_Dollar_Amount__c != null ||
                           drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != null || drugCoverage.Generic_Penalty_Percent__c != null || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != null ||
                            drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c != null ||  drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c != null || drugCoverage.Generic_Penalty_Minimum_Dollar__c != null ||
                            drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null || drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != null || drugCoverage.Generic_Penalty_Maximum_Dollar__c !=null ||
                            drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c !=null || drugCoverage.Brand_Penalty_Type__c !=null || drugCoverage.Brand_Penalty_Dollar_Amount__c !=null || drugCoverage.Brand_Penalty_Percent__c !=null ||
                            drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c !=null || drugCoverage.Brand_Penalty_Minimum_Dollar__c !=null ||  drugCoverage.Brand_Penalty_Maximum_Dollar__c !=null ))
                            {
                                errorMessages.add(system.Label.ERR0212);
                                return null;
                            }
                if (drugCoverage.Formulary_Open_Closed__c == NULL) {                        
                            drugCoverage.Formulary_Open_Closed__c.addError(system.Label.ERR00207);
                            return null;
                        }                         
                if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL || drugCoverage.Brand_Penalty_Percent__c != NULL) {
                    if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00158);
                        return null;
                    }
                }
                if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL || drugCoverage.Generic_Penalty_Percent__c != NULL) {
                    if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00159);
                        return null;
                    }
                }
                if (crd.Retail_to_Mail__c == TRUE) {
                    if ((drugCoverage.Mandatory_Mail_Order_Option__c != NULL && drugCoverage.Mandatory_Mail_Order_Option__c != 'Not Applicable')
                            || (drugCoverage.Maintenance_Choice__c != NULL && drugCoverage.Maintenance_Choice__c != 'Not Applicable')) {
                        errorMessages.add(system.Label.ERR00161);
                        return null;
                    }
                }
                if (drugCoverage.Generic_Penalty_Dollar_Amount__c != NULL && drugCoverage.Generic_Penalty_Percent__c != NULL) {
                    errorMessages.add(system.Label.ERR00162);
                    return null;
                }
                if (drugCoverage.Brand_Penalty_Dollar_Amount__c != NULL && drugCoverage.Brand_Penalty_Percent__c != NULL) {
                    errorMessages.add(system.Label.ERR00163);
                    return null;
                }
                if (drugCoverage.Generic_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Generic_Penalty_Minimum_Dollar__c != NULL) {
                    if (drugCoverage.Generic_Penalty_Maximum_Dollar__c <= drugCoverage.Generic_Penalty_Minimum_Dollar__c) {
                        errorMessages.add(system.Label.ERR00165);
                        return null;
                    }
                }
                if (drugCoverage.Brand_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Brand_Penalty_Minimum_Dollar__c != NULL) {
                    if (drugCoverage.Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Brand_Penalty_Minimum_Dollar__c) {
                        errorMessages.add(system.Label.ERR00166);
                        return null;
                    }
                }
                if (INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                    if (drugCoverage.Generic_Penalty_Type__c != NULL) {
                        if (drugCoverage.Generic_Penalty_Dollar_Amount__c == NULL && drugCoverage.Generic_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Generic_Penalty_Percent__c == NULL && drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                            errorMessages.add(system.Label.ERR00167);
                            return null;
                        }
                    }
                    if (drugCoverage.Generic_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00167);
                        return null;
                    }
                }
                if (INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                    if (drugCoverage.Brand_Penalty_Type__c != NULL) {
                        if (drugCoverage.Brand_Penalty_Dollar_Amount__c == NULL && drugCoverage.Brand_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Brand_Penalty_Percent__c == NULL && drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c == NULL) {
                            errorMessages.add(system.Label.ERR00168);
                            return null;
                        }
                    }
                    if (drugCoverage.Brand_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00168);
                        return null;
                    }
                }
                if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL || drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL) {
                    if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00173);
                        return null;
                    }
                }
                if (drugCoverage.Non_Pref_Brand_Penalty_Percent__c != NULL && drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c != NULL) {
                    errorMessages.add(system.Label.ERR00174);
                    return null;
                }
                if (INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) {
                    if (drugCoverage.Non_Pref_Brand_Penalty_Type__c != NULL) {
                        if (drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Percent__c == NULL && drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c == NULL) {
                            errorMessages.add(system.Label.ERR00175);
                            return null;
                        }
                    }
                    if (drugCoverage.Non_Pref_Brand_Penalty_Type__c == NULL) {
                        errorMessages.add(system.Label.ERR00175);
                        return null;
                    }
                }
                if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c != NULL && drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c != NULL) {
                    if (drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c <= drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c) {
                        errorMessages.add(system.Label.ERR00176);
                        return null;
                    }
                }

                // added by Rishabh K Bansal on 11th Mar'13 for req no: 00900
                // modified by Abhishek on 6th Nov'13 for req no: 01270  
                if ((MANDATORY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || INCENTIVIZED.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c) || VOLUNTARY.equalsIgnoreCase(drugCoverage.Maintenance_Choice__c)) && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
                    if (drugCoverage.Mandatory_Mail_Order_Option__c == NULL || drugCoverage.Mandatory_Mail_Order_Option__c !=  NOTAPPLICABLE) {
                        errorMessages.add(system.Label.ERR00177);
                        return null;
                    }
                }
                // modified by Abhishek on 6th Nov'13 for req no: 01270 
                if ((MANDATORY.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c) || INCENTIVIZED.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c))  && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
                    if (drugCoverage.Maintenance_Choice__c == NULL || drugCoverage.Maintenance_Choice__c !=  NOTAPPLICABLE) {
                        errorMessages.add(system.Label.ERR00178);
                        return null;
                    }
                }
            }

            if (userSelectionRecordTypeName.contains('Retail')) {
                    if (drugCoverage.Formulary_Open_Closed__c == NULL) {                        
                            drugCoverage.Formulary_Open_Closed__c.addError(system.Label.ERR00207);
                            return null;
                        }
                        // ADDED BY SUSHANT - 6452 CRITERIA 4
                     //Formulary__C frm = [select Group__c from Formulary__c where Id=:drugCoverage.Formulary__c];
                     Formulary__C frm = new Formulary__C(); 
                    if(drugCoverage.Formulary__c != Null){ 
                        frm = [select Group__c from Formulary__c where Id=:drugCoverage.Formulary__c limit 1]; 
                    }
                                        
                    if (string.isEmpty(drugCoverage.Aetna_Specialty_Care_Rx__c) && !string.isEmpty(frm.Group__c) && frm.Group__c != 'LG Premier Plus' ) {
                            drugCoverage.Aetna_Specialty_Care_Rx__c.addError(system.Label.ERR00304);
                            return null;
                        }
                    /* Commented By Nitish - 06452 criteria 4
                    if (drugCoverage.Aetna_Specialty_Care_Rx__c == NULL) {                        
                            drugCoverage.Aetna_Specialty_Care_Rx__c.addError(system.Label.ERR00207);
                            return null;
                        }*/
                    if (drugCoverage.Force_to_Specialty__c == NULL && !string.isEmpty(frm.Group__c) && frm.Group__c != 'LG Premier Plus') {                        
                            drugCoverage.Force_to_Specialty__c.addError(system.Label.ERR00207);
                            return null;
                        }
                    if (drugCoverage.Aetna_Specialty_Care_Rx__c == 'Custom' && drugCoverage.Speciality_Drug_List__c == NULL) {                       
                            errorMessages.add(system.Label.ERR00208);
                            return null;
                        }
                   if (drugCoverage.Force_to_Specialty__c == 'Yes' && drugCoverage.of_fills_before_force_to_specialty__c == NULL) {                       
                            errorMessages.add(system.Label.ERR00209);
                            return null;
                        }
                    if (drugCoverage.Force_to_Specialty__c == 'No' && drugCoverage.of_fills_before_force_to_specialty__c != NULL) {                       
                            errorMessages.add(system.Label.ERR00210);
                            return null;
                        } 
                        
                     //Added for Request 4592 by Amit Jain on 27 Feb '14
                    
                    /* commented and modified by JR to implement request 4813
                  if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RRA'){
                        drugCoverage.RRA_Drug_List__c = System.label.DCSRT23;
                    } */
                    if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RSO'){
                        drugCoverage.RSO_Drug_List__c = System.label.DCSRT24;
                    }
                    /*
                    if(drugCoverage.Aetna_Specialty_Care_Rx__c== 'RSO without Fertility'){
                        drugCoverage.RSO_Drug_List__c = System.label.DCSRT25;
                    }*/
                    //4592 ends ***                      
                }
                
            if (drugCoverage.Mandatory_Mail_Order_Option__c != null && NOTAPPLICABLE.equalsIgnoreCase(drugCoverage.Mandatory_Mail_Order_Option__c)) {
                drugCoverage.Use_Medispan_Indicator__c = null;
            }
            //Richa added on 19/8 for Req 4692
          /*  if(DrugCoverage.Formulary__c == null && DrugCoverage.Formulary_Open_Closed__c != null){
                errorMessages.add(system.Label.ERR0261);
                return null;    
            }*/

            if(DrugCoverage.Formulary__c != null){
                    String DCfield; 
                    List<Formulary__c> lstFRM = new List<Formulary__c>([Select Formulary_Open_Closed__c from Formulary__c where Id = :DrugCoverage.Formulary__c AND Formulary_Open_Closed__c != null LIMIT 1]);
                    if(!lstFRM.isempty()){
                         DCfield =  lstFRM[0].Formulary_Open_Closed__c;
                       /* if(DrugCoverage.Formulary_Open_Closed__c == null){
                            errorMessages.add(system.Label.ERR0261);
                            return null;
                        }else*/ if(!DCfield.contains(DrugCoverage.Formulary_Open_Closed__c)){
                            errorMessages.add(system.Label.ERR0261);
                            return null;
                        }
                    }else{
                       errorMessages.add(system.Label.ERR0262);
                       return null;
                    }
            }
            if (drugCoverage.Id != null) {
                Drug_Coverage__c newdrugCoverage = new Drug_Coverage__c();
                newdrugCoverage = drugCoverage.clone(false);
                drugCoverage = newdrugCoverage;
            }
             //Added By Nitish - 06452 Criteria 5
                if(String.isEmpty(drugCoverage.Aetna_Specialty_Care_Rx__c) || drugCoverage.Aetna_Specialty_Care_Rx__c.equals(NONE1)){
                    drugCoverage.Do_you_have_Specialty__c = NO;
                }
                else{
                    drugCoverage.Do_you_have_Specialty__c = YES;
                }
             system.debug('EEEEE ' + drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c);
            database.insert(drugCoverage);
            /*if (drugCoverage.Exception_Drug_Group__c == null && drugCoverage.Exception_Drug_List__c == null) {
                addDrugClassRecords();
            }*/
            database.update(crd);


            //Sourabh 
            lstNewDCDrugList = new List < DC_Drug_List_Group__c > ();
            if (DCListWrapperlist != null && DCListWrapperlist.size() > 0) {
                for (DCListWrapper dlist: DCListWrapperlist) {
                    DC_Drug_List_Group__c dcdlist = new DC_Drug_List_Group__c();
                    dcdlist = dlist.dcDruglist;
                    dcdlist.Related_Drug_Coverage__c = drugCoverage.Id;
                    lstNewDCDrugList.add(dcdlist);
                }

                if (lstNewDCDrugList != null && lstNewDCDrugList.size() > 0) {
                    database.upsert(lstNewDCDrugList);
                }
            }
            this.drugCoverage = new Drug_Coverage__c();
            Pagereference pageRef = new Pagereference(DCURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

    }

    Public PageReference redirectToCopay() {
        database.update(crd);
        if (CRD != null && CRD.Daw_Specific_Stepped_Copay_Count__c != null && CRD.Daw_Specific_Stepped_Copay_Count__c > 0) {
            PageReference pageRef = new PageReference(CRDDAWSPCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else if (CRD.Any_DAW_specific_Mail_copays__c || CRD.Any_DAW_specific_Paper_copays__c || CRD.Any_DAW_specific_Retail_copays__c || CRD.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c) {
            PageReference pageRef = new PageReference(CRDNEWDAWCOPAY + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
                   } else if (CRD.Any_drug_specific_Specialty_copays__c || CRD.Any_drug_specific_Mail_copays__c || CRD.Any_drug_specific_Paper_copays__c || CRD.Any_drug_specific_Retail_copays__c || CRD.Any_drug_specific_Paper_Out_of_Network__c) {
            PageReference pageRef = new PageReference(CRDNEWDRUGSPCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else if (CRD != null && CRD.SteppedCopayCount__c != null && CRD.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference(STEPPERCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {
            PageReference pageRef = new PageReference(CRDNEWCOPAYURL+ crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }

    }

/*Method for back button for users not in the public group */    
    Public PageReference redirectToCopay2() {
        if (CRD != null && CRD.Daw_Specific_Stepped_Copay_Count__c != null && CRD.Daw_Specific_Stepped_Copay_Count__c > 0) {
            PageReference pageRef = new PageReference(CRDDAWSPCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else if (CRD.Any_DAW_specific_Mail_copays__c || CRD.Any_DAW_specific_Paper_copays__c || CRD.Any_DAW_specific_Retail_copays__c || CRD.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c) {
            PageReference pageRef = new PageReference(CRDNEWDAWCOPAY + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
                   } else if (CRD.Any_drug_specific_Specialty_copays__c || CRD.Any_drug_specific_Mail_copays__c || CRD.Any_drug_specific_Paper_copays__c || CRD.Any_drug_specific_Retail_copays__c || CRD.Any_drug_specific_Paper_Out_of_Network__c) {
            PageReference pageRef = new PageReference(CRDNEWDRUGSPCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else if (CRD != null && CRD.SteppedCopayCount__c != null && CRD.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference(STEPPERCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {
            PageReference pageRef = new PageReference(CRDNEWCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }

    }

    public PageReference showCustomRefillField() {
        drugCoverage.Dose_Limit__c =Null;
        if (drugCoverage.Standard_Refill_too_Soon__c != 'Yes') {
            drugCoverage.Custom_Refill_too_Soon__c = null;
        }

                
                //Added by Amit Jain for Request 4611
                if(drugCoverage.Does_Dose_Limit_apply__c  == 'Yes' && userSelectionRecordTypeName != Null){
                        if (userSelectionRecordTypeName.contains('Retail')) {
                                        drugCoverage.Dose_Limit__c =100;
                        }
                        if(userSelectionRecordTypeName.contains(MAIL)){
                                        drugCoverage.Dose_Limit__c =300;
                        }       
                }
                else if(drugCoverage.Does_Dose_Limit_apply__c  != 'Yes'){
                                        drugCoverage.Dose_Limit__c =Null;
                }
                //**ends
        return null;
    }
    
    public Pagereference allowTransitionFill(){
        //Added for Request 4618. The Field Transition Fill Number of Days  is set to null whenever the value in Allow Transition Fill field is changed
        //As per request 4811 Number of fills is set to null whenever the value in Allow Transition Fill field is changed
        drugCoverage.Transition_Fill_Number_of_Days__c = null;  
        drugCoverage.Number_of_fills__c = null;
                //**ends        
                return null;
    }
    public PageReference showMailPanel() {
        try {

            if (recordTypeValue != null) {
                isRecordTypeSpeciality = true;
                userSelectionRecordTypeName = getRecordTypeNameByid(recordTypeValue);
                drugcoverage.recordtypeid= recordTypeValue;  /*  Request 6838  need to have picklist values on CRD Wizard on Drug Coverage Tab  */
                if (userSelectionRecordTypeName.contains('Retail')) {
                    isRecordTypeRetail = true;
                    //change done by anuj on 28 feb(if column)
                    
                } else {
                    isRecordTypeRetail = false;
                    //change done by anuj on 28 feb(3 new lines )
                    
                    drugCoverage.Aetna_Specialty_Care_Rx__c = null;
                    drugCoverage.Speciality_Drug_List__c = null;
                }
                if (userSelectionRecordTypeName.contains('Specialty')) {
                    isRecordTypeSpeciality = true;
                } else {
                    isRecordTypeSpeciality = false;

                }
                if (userSelectionRecordTypeName.contains('Retail')) {
                    
                }
                if (userSelectionRecordTypeName.contains(MAIL)) {
                   isRecordTypeMail = true;
                    drugCoverage.Force_to_Specialty__c = null;
                    drugCoverage.Aetna_Specialty_Care_Rx__c = null;
                    drugCoverage.Force_to_Specialty__c = null;
                    drugCoverage.of_fills_before_force_to_specialty__c = null;
                    drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = null;
                    drugCoverage.Secondary_Force_to_Specialty__c = null;
                    drugCoverage.Secondary_of_fills_before_force_to_SPN__c = null;
                    drugCoverage.Retail_Refill_Allowance_No_of_days__c = null;
                    drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = null;
                    drugCoverage.Mandatory_Mail_Order_Option__c = 'Not Applicable';
                    drugCoverage.Maintenance_Choice__c = 'Not Applicable';

                } else {
                    isRecordTypeMail = false;
                    drugCoverage.Mandatory_Mail_Order_Option__c = null;
                    drugCoverage.fills_before_MMO_option_is_invoked__c = null;
                    drugCoverage.Number_of_Periods__c = null;
                    drugCoverage.Period_Type__c = null;
                    drugCoverage.Maintenance_Choice__c = null;

                }
            } else {
                isRecordTypeMail = false;
                drugCoverage.Mandatory_Mail_Order_Option__c = null;
                drugCoverage.fills_before_MMO_option_is_invoked__c = null;
                drugCoverage.Number_of_Periods__c = null;
                drugCoverage.Period_Type__c = null;
                drugCoverage.Maintenance_Choice__c = null;
                userSelectionRecordTypeName = getRecordTypeNameByid(recordTypeValue);
            }

            if (isRecordTypeRetail || isRecordTypeSpeciality) {
                isMultiIndregient = true;
            } else {
                isMultiIndregient = false;
                //drugCoverage.Multi_Ingredient_Compounds__c = null;
               /* drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c = 'No';
                drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c = 'No';
                drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c = 'No'; */
                drugCoverage.Custom_NDC_GPI_List__c = null;
                //drugCoverage.Copay_Based_On__c = null;
                //drugCoverage.Dollar_Amount__c = null;
                //drugCoverage.Max_Day_Supply__c = null;
                //drugCoverage.Dosage_Form__c = null;
                //drugCoverage.Refill_Limits__c = null;
                //drugCoverage.DESI__c = null;
                //drugCoverage.OTC__c = null;
                //drugCoverage.Maintenance_Form__c = null;
                //drugCoverage.Brand_Generic__c = null;
                //drugCoverage.Packaging_Exceptions__c = null;
                //drugCoverage.X3rd_Party_Exceptions__c = null;
                //drugCoverage.FDA_Therapeutic_Equivalent__c = null;
                //drugCoverage.DEA__c = null;
                //drugCoverage.FDA_Therapeutic_Category__c = null;
            
            }
            
            showCustomRefillField();
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;

    }

    //Method to get the record type Name from schema describe information   
    public String getRecordTypeNameByid(id recordTypeid) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Drug_Coverage__c;
        Map < Id, Schema.RecordTypeInfo > rtMapById = d.getRecordTypeInfosById();
        String strRecordTypename = rtMapById.get(recordTypeid).getName();
        return strRecordTypename;
    }
    //Method to get the record type id from schema describe information 
    public Id getRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Drug_Coverage__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }
    public boolean checkMandatorFields() {
        boolean isCriteriaCompleted;
        isCriteriaCompleted = true;
        list < Drug_Coverage__c > lstDrugCoverage = new list < Drug_Coverage__c > ();
        lstDrugCoverage = [select id, Name, RecordTypeid, RecordType.Name from Drug_Coverage__c where CRD_ID__c = : crd.id LIMIT 100000];
        boolean isMailDrugAvailable;
        boolean isRetailDrugAvailable;
        boolean isSpecialityDrugAvailable;

        isMailDrugAvailable = false;
        isRetailDrugAvailable = false;
        isSpecialityDrugAvailable = false;

        if (lstDrugCoverage != null && lstDrugCoverage.size() > 0) {
            for (Drug_Coverage__c drugCoverage: lstDrugCoverage) {
                if (MAIL.equalsIgnoreCase(drugCoverage.RecordType.Name)) {
                    isMailDrugAvailable = true;
                }
                if (drugCoverage.RecordType.Name == 'Retail') {
                    isRetailDrugAvailable = true;
                }

            }
            if (crd.Plan_Type_Mail__c == true && isMailDrugAvailable == true && MAIL.equalsIgnoreCase(userSelectionRecordTypeName)) {
                isCriteriaCompleted = false;
            }
            if (crd.Plan_Type_Retail__c == true && isRetailDrugAvailable == true && userSelectionRecordTypeName == 'Retail') {
                isCriteriaCompleted = false;
            }

        } else {
            if (crd.Plan_Type_Mail__c == true && MAIL.equalsIgnoreCase(userSelectionRecordTypeName)) {
                isCriteriaCompleted = true;
            }
            if (crd.Plan_Type_Retail__c == true && userSelectionRecordTypeName == 'Retail') {
                isCriteriaCompleted = true;
            }

            if (crd.Plan_Type_Retail__c != true && crd.Plan_Type_Mail__c != true) {
                isCriteriaCompleted = false;
            }

        }

        return isCriteriaCompleted;


    }
    public boolean checkDuplicate() {
        list < Drug_Coverage__c > existingDrugs = new list < Drug_Coverage__c > ();
        boolean isDuplicate = false;
        existingDrugs = crd.Drug_Coverage__r;
        if (existingDrugs != null && existingDrugs.size() > 0) {
            for (Drug_Coverage__c acc: existingDrugs) {
                String existingRecordTypeName = getRecordTypeNameByid(acc.RecordTypeId);

                if (acc.RecordTypeId == recordTypeValue) {
                    errorMessages.clear();
                    errorMessages.add(system.Label.ERR00087);
                    isDuplicate = true;
                    break;
                }
            }
        }
        return isDuplicate;
    }
    //Wrapper Class To Create dynamic list
    public class DrugCoverageWrapper {
        public Drug_Coverage__c drugCoverage {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
        public DrugCoverageWrapper() {
            drugCoverage = new Drug_Coverage__c();
        }

    }
    //Method to remove the selected rows from the web user panel
    public PageReference deleteSelectedDrugCoverage() {
        list < Drug_Coverage__c > listDeletedAccums = new list < Drug_Coverage__c > ();
        list < DrugCoverageWrapper > lstTempWrapper = new list < DrugCoverageWrapper > ();
        if (lstDrugCoverageWrapper != null && lstDrugCoverageWrapper.size() > 0) {
            for (integer i = 0; i < lstDrugCoverageWrapper.size(); i++) {
                if (lstDrugCoverageWrapper[i].isMarkedForDeletion == true) {
                    listDeletedAccums.add(lstDrugCoverageWrapper[i].drugCoverage);
                } else {
                    lstTempWrapper.add(lstDrugCoverageWrapper[i]);
                }
            }
            if (listDeletedAccums == null || listDeletedAccums.size() == 0) {
                isDeletionCheckboxSelected = false;
            } else {
                lstDrugCoverageWrapper.clear();
                lstDrugCoverageWrapper.addAll(lstTempWrapper);
                database.delete(listDeletedAccums);
                isDeletionCheckboxSelected = true;
            }
        }
        PageReference pageRef = new PageReference(DCURL + crdid);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        pageRef.setRedirect(true);
        return pageRef;
    }
    //Method to add a new instance of Wrapper to list of dynamic input sections    
    public PageReference AddNewDCDrugList() {
        DCListWrapper wrap = new DCListWrapper();
        DCListWrapperlist.add(wrap);
        return null;
    }

    public PageReference deleteSelectedDCDrugList() {
        set < Id > deleteDCDrugList = new set < Id > ();
        if (DCListWrapperlist != null && DCListWrapperlist.size() > 0) {
            for (integer i = 0; i < DCListWrapperlist.size(); i++) {
                if (DCListWrapperlist[i].isMarkedForDeletion == true) {
                    deleteDCDrugList.add(DCListWrapperlist[i].dcDruglist.Id);
                    DCListWrapperlist.remove(i);
                }
            }
        }
        // list < CVS_Web_Access_Users__c > lstNewWebuser = new List < CVS_Web_Access_Users__c > (); Commented by Sushant: Req 04937

        lstNewDCDrugList = new List < DC_Drug_List_Group__c > ();
        if (deleteDCDrugList.size() > 0) {
            lstNewDCDrugList = [select id from DC_Drug_List_Group__c Where Id IN: deleteDCDrugList LIMIT 100000];
            database.delete(lstNewDCDrugList);
        }
        return null;
    }
    
    
    
       string fillsValue;    
   //method created by anuj on 28 feb
    
    public void showSpecialityField() {
        if (drugCoverage.Aetna_Specialty_Care_Rx__c != 'Custom') {
            drugCoverage.Speciality_Drug_List__c = null;
        }
        //Added by JR to implement request no 4719      
        drugCoverage.Max_Specialty_Day_Supply__c = 30;
        if(drugCoverage.Aetna_Specialty_Care_Rx__c == null  ||drugCoverage.Aetna_Specialty_Care_Rx__c == 'Does not Apply (Insured/not state filed)'  ){
            drugCoverage.Max_Specialty_Day_Supply__c = null;
        }        
        //commented by JR to implement request no 4813
       /*if (  drugCoverage.Aetna_Specialty_Care_Rx__c == 'RRA'){
             drugCoverage.of_fills_before_force_to_specialty__c = 2;
        }else */ 
        if (  drugCoverage.Aetna_Specialty_Care_Rx__c == 'RSO'){
             drugCoverage.of_fills_before_force_to_specialty__c = 0;                 
        }       
     }  
     
     // Added by JR to implement Request no 4712
     public void showSecSpecialityField() {
        //Added by JR to implement request no 4813
        drugCoverage.Retail_Refill_Allowance_No_of_days__c = null;
        drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = null;
        
        if (drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c != 'Custom') {
            drugCoverage.Secondary_Speciality_Drug_List__c = null;
        }
        // Modified by JR to implement request no 4813
        /*if (  drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'RRA'){
             drugCoverage.Secondary_of_fills_before_force_to_SPN__c = 2;
        }else if (  drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'RSO with Fertility' || drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'RSO without Fertility'){
             drugCoverage.Secondary_of_fills_before_force_to_SPN__c = 0;                 
        } */ 
        
        if (  drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'RRA'){
             drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = 2;
             drugCoverage.Secondary_of_fills_before_force_to_SPN__c = null;
        }else if (  drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c == 'RSO'){
             drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = null;
             drugCoverage.Secondary_of_fills_before_force_to_SPN__c = 0;            
        }
             
     } 
     
     
     
     //Wrapper Class To Create dynamic inputs
    public class DCListWrapper {
        public DC_Drug_List_Group__c dcDruglist {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        } 
        public DCListWrapper() {
            DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
            dcDruglist = dcdl;
        }

    }
 }