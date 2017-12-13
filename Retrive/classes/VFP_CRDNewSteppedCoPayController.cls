/*Purpose: Apex Class for VFP_CRDNewSteppedCoPay Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 7/5/2011       Apex Class for VFP_CRDNewSteppedCoPay Page .
======================================================================== 
*/
public with sharing class VFP_CRDNewSteppedCoPayController {
     //Added by ankur for stepped co
    public lisT<steppedcopay__C> steppedcopays{
        set;
        get;
    }
    /*Flags to maintain Sections based on available Tiers*/
    public boolean isSteppedMail {
        set;
        get;
    }
    public boolean isSteppedRetail {
        set;
        get;
    }
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    public boolean isSteppedPaper {
        set;
        get;
    }
    public boolean isSteppedSpeciality {
        set;
        get;
    }
    public boolean isSteppedOOn {
        set;
        get;
    }
    //added by JR
    public boolean isSteppedSpecialityOOn {
        set;
        get;
    }
    public boolean isSteppedCopaDataAvailable {
        set;
        get;
    }
    public string retailTier2Copy {
        get;
        set;
    }
    public boolean isRetailtoPaper {
        get;
        set;
    }
    public boolean isRetailtoSpeciality {
        get;
        set;
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
    public string specialityOONParentId {
        get;
        set {
            specialityOONParentId = value;
        }
    }


    public set<id> steppedcopayId = new set<id>();
    public map<id,Copay_Tier__c> steppedCopayTierMap {get;set;}

    /*variable for count of tiers to maintain the wizard flow*/
    public integer currentTierCount;
    public integer systemTierCount;

    public static final List < Schema.PicklistEntry > P1 = SteppedCopay__c.Stepped_CoPay_Types__c.getDescribe().getPicklistValues();

    /*list of Wrapper Class to maintain the Copay Tiers */
    public List < steppedCopayWrapper > steppedMailCopayWrapper {
        set;
        get;
    }
    public List < steppedCopayWrapper > steppedRetailCopayWrapper {
        set;
        get;
    }
    public List < steppedCopayWrapper > steppedPaperCopayWrapper {
        set;
        get;
    }
    public List < steppedCopayWrapper > steppedSpecialityCopayWrapper {
        set;
        get;
    }
    public List < steppedCopayWrapper > steppedOOnCopayWrapper {
        set;
        get;
    }
    //added by JR
    public List < steppedCopayWrapper > steppedSpecialityOOnCopayWrapper {
        set;
        get;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public list < SteppedCopay__c > tempList = new list < SteppedCopay__c > ();

    public String CopayId {
        get;
        set;
    }
    public String CopayName {
        get;
        set;
    }
    public CRD__c crd {
        get;
        set;
    }
    public List < Copay_Tier__c > copayTierList = new list < Copay_Tier__c > ();

    private final SteppedCopay__c steppedCopay;
    public string crdId {
        set;
        get;
    }
    PUBLIC List <SteppedCopay__C> steppedCopayList {get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING PAPER = 'Paper';
    PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
    PRIVATE STATIC FINAL STRING SPECIALITY = 'Specialty';
    PRIVATE STATIC FINAL STRING PAPEROON  = 'Paper Out of Network';
    PRIVATE STATIC FINAL STRING SPECIALITYOON = 'Specialty OON';
    PRIVATE STATIC FINAL STRING DCURL = '/apex/VF_CRDDrugCoverageStep2?crdid=';
    PRIVATE STATIC FINAL STRING COPAYURL ='/apex/VF_CRDNewCoPay?id='; 
    PRIVATE STATIC FINAL STRING DRUGCOPAYURL = '/apex/VF_CRDNewDrugSpecificCoPay?crdid=';
    PRIVATE STATIC FINAL STRING DAWCOPAYURL = '/apex/VF_CRDNewDAWSpecificCopay?crdid=';

/* Method to get the value of Type of Step Copay */    
    public List < SelectOption > getTypeOfStepCopay() {
        List < SelectOption > options = new List < SelectOption > ();
        for (Schema.PicklistEntry P: P1)
        options.add(new Selectoption(p.getValue(), p.getLabel()));
        return options;
    }

    /*Constructor of class to initialize the various flags and variables*/
    public VFP_CRDNewSteppedCoPayController(ApexPages.StandardController stdController) {
        retailParentId = null;
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        steppedCopay = (SteppedCopay__c) stdController.getRecord();
        steppedMailCopayWrapper = new List < steppedCopayWrapper > ();
        steppedRetailCopayWrapper = new List < steppedCopayWrapper > ();
        steppedPaperCopayWrapper = new List < steppedCopayWrapper > ();
        steppedSpecialityCopayWrapper = new List < steppedCopayWrapper > ();
        steppedOOnCopayWrapper = new List < steppedCopayWrapper > ();
        steppedCopayTierMap = new map<id,Copay_Tier__c>();
        //added by JR
        steppedSpecialityOOnCopayWrapper = new List < steppedCopayWrapper > ();
        errorMessages = new list < String > ();
        if (ApexPages.CurrentPage().getParameters().get(CRDID1) != '') {
            crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
            crd = [select id, Y_Schd__c, Any_DAW_specific_Paper_OON_copays__c, Any_drug_specific_Paper_Out_of_Network__c, Integrate_with_Medical__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c, Insured_Type__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, name, Plan_Type_Paper__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Mail_copays__c,
                    Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c from CRD__c where id = : crdId LIMIT 100000];
        }

        if (crdId != null) {
            copayTierList = [select id, RecordType.Name, Tier_Type__c, CRD__r.Name, Dollar_Amount__c, Days_Per_Fill__c, SteppedCopayCount__c, Tier_Name__c, name, (Select Copay_Tier__c, Min_Range__c, Max_Range__c, Percent_Amount__c, Min_Dollar__c, Max_Dollar__c, Stepped_CoPay_Types__c, Copay_Calc__c, Number_of_Ranges__c, Dollar_Amount__c, Reverse__c  From SteppedCopays__r ORDER BY Number_of_Ranges__c) from Copay_Tier__c where Stepped_Copay__c = true and CRD__c = : crdId order by Tier__c LIMIT 100000];
                        //Added By Nitish - 6726
            steppedcopays = [select  id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Copay_Tier__r.RecordType.Name,Copay_Tier__r.Tier_Type__C,steppedcopay__c.Number_of_Ranges__c,Copay_Tier__r.Tier_Name__c,Tier_Type__c from Steppedcopay__C where copay_tier__R.crd__c = :crdId ORDER BY Copay_Tier__r.RecordType.Name,Copay_Tier__r.Tier_Type__C,steppedcopay__c.Number_of_Ranges__c];
            steppedCopayList = [select id,Copay_Tier__r.RecordType.Name,Copay_Tier__r.Tier_Type__C,steppedcopay__c.Number_of_Ranges__c,Copay_Tier__r.Tier_Name__c,Tier_Type__c
                                from 
                                steppedCopay__C where Copay_Tier__r.CRD__c =:crdId  ORDER BY Copay_Tier__r.RecordType.Name,Copay_Tier__r.Tier_Type__C,steppedcopay__c.Number_of_Ranges__c];
                                
                               
                               for(Copay_Tier__c cpyTiObj: copayTierList){
                               
                                   List<steppedCopay__C> StpCopayList = cpyTiObj.SteppedCopays__r;
                                   for(steppedCopay__C str : StpCopayList){
                                        steppedcopayId.add(str.id);
                                        steppedCopayTierMap.put(str.id,cpyTiObj);
                                   }
            
                                }
        }
        checkSteppedCopayStatus();


        if (copayTierList != null && copayTierList.size() > 0) {
            isSteppedCopaDataAvailable = true;
            for (Copay_Tier__c ctl: copayTierList) {
                if (ctl.RecordType.Name.equalsIgnoreCase(MAIL)) {
                    isSteppedMail = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedMailCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name.equalsIgnoreCase(PAPER)) {
                    isSteppedPaper = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedPaperCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name.equalsIgnoreCase(RETAIL)) {
                    isSteppedRetail = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedRetailCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name.equalsIgnoreCase(SPECIALITY)) {
                    isSteppedSpeciality = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedSpecialityCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name.equalsIgnoreCase(PAPEROON) ) {
                    isSteppedOOn = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedOOnCopayWrapper.add(sw);
                }
                //added by JR
                if (ctl.RecordType.Name.equalsIgnoreCase(SPECIALITYOON)) {
                    isSteppedSpecialityOOn = true;
                    steppedCopayWrapper sw = new steppedCopayWrapper();
                    sw.steppedCopayItemList = ctl.SteppedCopays__r;
                    sw.parentTierName = ctl.Tier_Name__c;
                    sw.parentTierType = ctl.Tier_Type__c;
                    if (ctl.SteppedCopays__r != null && ctl.SteppedCopays__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.SteppedCopays__r[0].Stepped_CoPay_Types__c;
                    }
                    sw.copayTierId = ctl.id;
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedSpecialityOOnCopayWrapper.add(sw);
                }

            }
        }
    }
    /*Method Redirects the user to accumulation if we dont have any copay list */
    public PageReference checkSteppedCopayStatus() {
       try{
        if (copayTierList == null && copayTierList.size() == 0) {
            PageReference pageRef = new PageReference(DCURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {

            return null;
        }
       }
       catch(exception e)
       {
          return null;
       }   
    }
    
    /* Method to get the list of items selected*/
    public list < SelectOption > getItems() {
       try{
        List < SelectOption > options = new List < SelectOption > ();
        for (integer i = 0; i < = integer.valueOf(System.Label.CL0000018); i++)
        options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        return options;
       }
      catch(exception e)
      {
        return null;
      }    
    }

    /*Method called from the action function when user selects the  number of steps */
    public void sortOOnlist() {
       try{
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedOOnCopayWrapper.size(); i++) {
            if (steppedOOnCopayWrapper.get(i).copayTierId == oonParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : oonParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }
                steppedOOnCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedOOnCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedOOnCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedOOnCopayWrapper.get(i).steppedCopayItemList.add(d);

                }
            }
        }
       }
       catch(exception e)
       {
            throw e;
       }    
    }
    //added by JR
     /*Method called from the action function when user selects the  number of steps */
    public void sortSpecialityOOnlist() {
       try{
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedSpecialityOOnCopayWrapper.size(); i++) {
            if (steppedSpecialityOOnCopayWrapper.get(i).copayTierId == specialityOONParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : specialityOONParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }
                steppedSpecialityOOnCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialityOOnCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedSpecialityOOnCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedSpecialityOOnCopayWrapper.get(i).steppedCopayItemList.add(d);

                }
            }
        }
       }
      catch(exception e)
      {
         throw e;
      }    
    }


    /*Method called from the action function when user selects the  number of steps */
    public void sortMaillist() {
        try{
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedMailCopayWrapper.size(); i++) {
            if (steppedMailCopayWrapper.get(i).copayTierId == mailParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : mailParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }
                steppedMailCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedMailCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedMailCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedMailCopayWrapper.get(i).steppedCopayItemList.add(d);

                }
            }
        }
       }
       catch(exception e)
       {
            throw e;
       }   
    }

    /*Method called from the action function when user selects the  number of steps */
    public void sortRetaillist() {
        try{
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedRetailCopayWrapper.size(); i++) {
            if (steppedRetailCopayWrapper.get(i).copayTierId == retailParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : retailParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }
                steppedRetailCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedRetailCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedRetailCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedRetailCopayWrapper.get(i).steppedCopayItemList.add(d);
                }
            }
        }
        }
        catch(exception e)
       {
            throw e;
       } 
    }

    /*Method called from the action function when user selects the  number of steps */
    public void sortPaperlist() {
        try {
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedPaperCopayWrapper.size(); i++) {
            if (steppedPaperCopayWrapper.get(i).copayTierId == paperParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : paperParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedPaperCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedPaperCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedPaperCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedPaperCopayWrapper.get(i).steppedCopayItemList.add(d);

                }
            }
        }
       }
       catch(exception e)
       {
            throw e;
       }  
    }

    /*Method called from the action function when user selects the  number of steps */
    public void sortSpecialitylist() {
       try{
        list < SteppedCopay__c > lstStepped2ReplaceCopay = new list < SteppedCopay__c > ();
        for (Integer i = 0; i < steppedSpecialityCopayWrapper.size(); i++) {
            if (steppedSpecialityCopayWrapper.get(i).copayTierId == specialityParentId) {
                lstStepped2ReplaceCopay = [select id from SteppedCopay__c where Copay_Tier__c = : specialityParentId LIMIT 100000];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    database.delete(lstStepped2ReplaceCopay);
                }

                steppedSpecialityCopayWrapper.get(i).steppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialityCopayWrapper.get(i).noOfSteps; j++) {
                    SteppedCopay__c d = new SteppedCopay__c();
                    d.Number_of_Ranges__c = String.valueOf(steppedSpecialityCopayWrapper.get(i).steppedCopayItemList.size() + 1);
                    steppedSpecialityCopayWrapper.get(i).steppedCopayItemList.add(d);

                }
            }
        }
       }
       catch(exception e)
       {
            throw e;
       }  
    }


    /*Method to save the data entered by user and move to previous page*/
    public PageReference previousStep() {
        set < Copay_Tier__c > setOldCopayTier = new set < Copay_Tier__c > ([select id from Copay_Tier__c where Stepped_Copay__c = true and CRD__c = : crdId LIMIT 100000]);
        list < SteppedCopay__c > lstSteppedCopay = new list < SteppedCopay__c > ([select id, Dollar_Amount__c from SteppedCopay__c where Copay_Tier__c in : setOldCopayTier LIMIT 100000]);
        currentTierCount = lstSteppedCopay.size();
        /*get the count of current selected tiers */
        systemTierCount = 0;
        /*We Process things if there is a change in the count of the previous teirs*/
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        try {
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {

                isValid = validationMethods.validateSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOOnCopayWrapper != null && steppedOOnCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedOOnCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedOOnCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOOnCopayWrapper);
            }
            //added by JR
             if (steppedSpecialityOOnCopayWrapper != null && steppedSpecialityOOnCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedSpecialityOOnCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedSpecialityOOnCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityOOnCopayWrapper);
            }

        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);

            return null;
        }
        PageReference pageRef = new PageReference(COPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
    
    /*Method for the back button for user not in public group */
    public PageReference previousStep2() {
        PageReference pageRef = new PageReference(COPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

    /*Method to save the data entered by user and move to Next page*/
    public PageReference Save() {
        set < Copay_Tier__c > setOldCopayTier = new set < Copay_Tier__c > ([select id from Copay_Tier__c where Stepped_Copay__c = true and CRD__c = : crdId LIMIT 100000]);
        list < SteppedCopay__c > lstSteppedCopay = new list < SteppedCopay__c > ([select id, Dollar_Amount__c from SteppedCopay__c where Copay_Tier__c in : setOldCopayTier LIMIT 100000]);
        currentTierCount = lstSteppedCopay.size();
        /*get the count of current selected tiers */
        systemTierCount = 0;
        /*We Process things if there is a change in the count of the previous teirs*/

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        try {
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {

                isValid = validationMethods.validateSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOOnCopayWrapper != null && steppedOOnCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedOOnCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedOOnCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOOnCopayWrapper);
            }
            //added by JR
            if (steppedSpecialityOOnCopayWrapper != null && steppedSpecialityOOnCopayWrapper.size() > 0) {
                isValid = validationMethods.validateSteppedCopay(steppedSpecialityOOnCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (steppedCopayWrapper wrap: steppedSpecialityOOnCopayWrapper) {
                    if (wrap.steppedCopayItemList == null || wrap.steppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityOOnCopayWrapper);
            }

        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);

            return null;
        }
        // } 
        if (crd.Any_drug_specific_Specialty_copays__c || crd.Any_drug_specific_Mail_copays__c || crd.Any_drug_specific_Paper_copays__c || crd.Any_drug_specific_Retail_copays__c || crd.Any_drug_specific_Paper_Out_of_Network__c ||crd.Any_drug_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference(DRUGCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {

            if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_drug_specific_Specialty_OON_copays__c) {
                PageReference pageRef = new PageReference(DAWCOPAYURL + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            }
            PageReference pageRef = new PageReference(DCURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }



    }


    /*Method for the next button for user not in public group */
    public PageReference Save2() {
        if (crd.Any_drug_specific_Specialty_copays__c || crd.Any_drug_specific_Mail_copays__c || crd.Any_drug_specific_Paper_copays__c || crd.Any_drug_specific_Retail_copays__c || crd.Any_drug_specific_Paper_Out_of_Network__c ||crd.Any_drug_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference(DRUGCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {

            if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_drug_specific_Specialty_OON_copays__c) {
                PageReference pageRef = new PageReference(DAWCOPAYURL + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            }
            PageReference pageRef = new PageReference(DCURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }

    }

    /*Method to save the Tier information from  user screen takes the list of Tier along with recordType name*/
    public void saveWrappedList(List < steppedCopayWrapper > wrappedList) {
        list < SteppedCopay__c > tempList = new list < SteppedCopay__c > ();
        for (steppedCopayWrapper wrap: wrappedList) {
            if (wrap.steppedCopayItemList != null && wrap.steppedCopayItemList.size() > 0) {
                for (SteppedCopay__c ct: wrap.steppedCopayItemList) {
                    SteppedCopay__c tempCopay = new SteppedCopay__c();
                    tempCopay = ct;
                    if (tempCopay.Copay_Tier__c == null) {
                        tempCopay.Copay_Tier__c = wrap.copayTierId;
                    }
                    tempCopay.Stepped_CoPay_Types__c = wrap.TypeOfStepCopay;
                    tempCopay.Copay_Calc__c = ct.Copay_Calc__c;
                    tempCopay.Min_Range__c = ct.Min_Range__c;

                    tempCopay.Max_Range__c = ct.Max_Range__c;
                    tempCopay.Dollar_Amount__c = ct.Dollar_Amount__c;
                    tempCopay.Max_Dollar__c = ct.Max_Dollar__c;
                    tempCopay.Min_Dollar__c = ct.Min_Dollar__c;
                    tempCopay.Percent_Amount__c = ct.Percent_Amount__c;
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
    public class steppedCopayWrapper {
        public Id copayTierId {
            get;
            set;
        }
        public boolean isRetailtoPaper {
            get;
            set;
        }
        public boolean isRetailtoSpeciality {
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
        public String parentTierName {
            get;
            set;
        }
        public String parentTierType {
            get;
            set;
        }
        public list < SteppedCopay__c > steppedCopayItemList {
            get;
            set;
        }
        /* Constructor for the wrapper class */
        public steppedCopayWrapper() {
            steppedCopayItemList = new List < SteppedCopay__c > ();
            noOfSteps = 0;
        }
    }


}