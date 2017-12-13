/*Purpose: Apex Class for VFP_CRDDrugSpecificSteppedCoPay Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 08/30/2011       Apex Class for VFP_CRDDrugSpecificSteppedCoPay Page.
     1.1      Bhaskar               12/19/2016       Adding History Tracking request : 06800
======================================================================== 
*/
public with sharing class VFP_CRDDrugSpecificSteppedCoPay {
    public list < Drug_Specific_Stepped_Copay__c > historyDrugSSC{get;set;} // Request 06800
    /*list of Wrapper Class to maintain the Copay Tiers */
    public List < drugSpecificCopayWrapper > steppedMailCopayWrapper {
        set;
        get;
    }
    public List < drugSpecificCopayWrapper > steppedRetailCopayWrapper {
        set;
        get;
    }
    public List < drugSpecificCopayWrapper > steppedPaperCopayWrapper {
        set;
        get;
    }
    public List < drugSpecificCopayWrapper > steppedSpecialityCopayWrapper {
        set;
        get;
    }
    public List < drugSpecificCopayWrapper > steppedOutOfnetworkCopayWrapper {
        set;
        get;
    }
    public List < drugSpecificCopayWrapper > steppedSpecialtyOONCopayWrapper {
        set;
        get;
    }

    public list < String > errorMessages {
        get;
        set;
    }

    public List < Drug_Specific_Copay__c > lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ();
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story

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
    public boolean isSteppedCopaDataAvailable {
        set;
        get;
    }
    public boolean isSteppedOutOfNetwork {
        set;
        get;
    }
    public boolean isSteppedSpecialtyOutOfNetwork {
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
    public string outOfnetworkParentId {
        get;
        set {
            outOfnetworkParentId = value;

        }
    }
    public string SpecialtyoutOfnetworkParentId {
        get;
        set {
            SpecialtyoutOfnetworkParentId = value;

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

    /*Constructot of the class*/
    public VFP_CRDDrugSpecificSteppedCoPay(ApexPages.StandardController controller) {
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        editMode=System.currentPagereference().getParameters().get('p1');        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get('p2');    //Added by Ayushi for next button story
        crd = [select id, Y_Schd__c, Any_DAW_specific_Paper_OON_copays__c, Integrate_with_Medical__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, name, Plan_Type_Paper__c, Insured_Type__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Mail_copays__c,Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c from CRD__c where id = : crdId];
        lstDrugSpecificCopay = [Select SteppedCopayCount__c, Drug_Group__r.Name, Drug_List__r.Name, Stepped_Copay__c, RecordTypeId, RecordType.Name, (Select Name, Drug_Specific_Copay_ID__c, Stepped_CoPay_Type__c, Number_of_Steps__c, Beginning_Range__c, End_Range__c, Dollar_Amount__c, Percent__c, Copay_Calculation__c, Maximum_Dollar__c, Minimum_Dollar__c, Reverse__c From Drug_Specific_Stepped_Copay_s__r order by Name) From Drug_Specific_Copay__c where Stepped_Copay__c = true and CRD_ID__c = : crdId];
		
        /* Start Adding History Tracking request : 06800 along with order of records tracking  */
        historyDrugSSC = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCRetail = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCMail = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCPaper = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCPaperOut = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCSpecialty = new List<Drug_Specific_Stepped_Copay__c>();
        List<Drug_Specific_Stepped_Copay__c> historyDrugSSCSpecialtyOON = new List<Drug_Specific_Stepped_Copay__c>();
        
        for(Drug_Specific_Stepped_Copay__c DSC : [select id,Drug_Specific_Copay_ID__r.recordtype.name,Drug_Specific_Copay_ID__r.M__c,Drug_Specific_Copay_ID__r.N__c,Drug_Specific_Copay_ID__r.O__c,
                                                  Drug_Specific_Copay_ID__r.Y__c,Stepped_CoPay_Type__c,Number_of_Steps__c,Drug_Specific_Copay_ID__c,Drug_Specific_Copay_ID__r.Drug_List__r.Name,Drug_Specific_Copay_ID__r.Drug_Group__r.Name,
                                                  (select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc)  from Drug_Specific_Stepped_Copay__c  
                                                  where Drug_Specific_Copay_ID__r.CRD_ID__c = : crdId  ])
        {	
            //historyDrugSSC.add(DSC);
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Retail' ){
                historyDrugSSCRetail.add(DSC);
            }
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Mail' ){
                historyDrugSSCMail.add(DSC);
            }
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Specialty' ){
                historyDrugSSCSpecialty.add(DSC);
            }
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Specialty OON' ){
                historyDrugSSCSpecialtyOON.add(DSC);
            }
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Paper' ){
                historyDrugSSCPaper.add(DSC);
            }
            if(DSC.Drug_Specific_Copay_ID__r.recordtype.name == 'Paper Out of Network' ){
                historyDrugSSCPaperOut.add(DSC);
            }
            
        }
        historyDrugSSC.addAll(historyDrugSSCRetail);
        historyDrugSSC.addAll(historyDrugSSCMail);
        historyDrugSSC.addAll(historyDrugSSCSpecialty);
        historyDrugSSC.addAll(historyDrugSSCSpecialtyOON);
        historyDrugSSC.addAll(historyDrugSSCPaper);
        historyDrugSSC.addAll(historyDrugSSCPaperOut);
        
        /* End  */
        errorMessages = new list < String > ();
        steppedMailCopayWrapper = new List < drugSpecificCopayWrapper > ();
        steppedRetailCopayWrapper = new List < drugSpecificCopayWrapper > ();
        steppedPaperCopayWrapper = new List < drugSpecificCopayWrapper > ();
        steppedSpecialityCopayWrapper = new List < drugSpecificCopayWrapper > ();
        steppedOutOfnetworkCopayWrapper = new List < drugSpecificCopayWrapper > ();
        steppedSpecialtyOONCopayWrapper = new List < drugSpecificCopayWrapper > ();

        if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
            isSteppedCopaDataAvailable = true;
            for (Drug_Specific_Copay__c ctl: lstDrugSpecificCopay) {
                if (ctl.RecordType.Name == 'Mail') {
                    isSteppedMail = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }

                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Mail - ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Mail - ' + ctl.Drug_List__r.Name;
                    }

                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedMailCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name == 'Paper') {
                    isSteppedPaper = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }
                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Paper - ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Paper - ' + ctl.Drug_List__r.Name;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);

                    steppedPaperCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name == 'Retail') {
                    isSteppedRetail = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }

                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Retail - ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Retail - ' + ctl.Drug_List__r.Name;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedRetailCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name == 'Specialty') {
                    isSteppedSpeciality = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }

                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Specialty - ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Specialty - ' + ctl.Drug_List__r.Name;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedSpecialityCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name == 'Paper Out of Network') {
                    isSteppedOutOfNetwork = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }

                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Paper Out of Network- ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Paper Out of Network- ' + ctl.Drug_List__r.Name;
                    }
                    sw.noOfSteps = Integer.valueOf(ctl.SteppedCopayCount__c);
                    steppedOutOfnetworkCopayWrapper.add(sw);
                }
                if (ctl.RecordType.Name == 'Specialty OON') {
                    isSteppedSpecialtyOutOfNetwork = true;
                    drugSpecificCopayWrapper sw = new drugSpecificCopayWrapper();
                    sw.drugSpecificSteppedCopayItemList = ctl.Drug_Specific_Stepped_Copay_s__r;
                    sw.copayTierId = ctl.id;
                    if (ctl.Drug_Specific_Stepped_Copay_s__r != null && ctl.Drug_Specific_Stepped_Copay_s__r.size() > 0) {
                        sw.TypeOfStepCopay = ctl.Drug_Specific_Stepped_Copay_s__r.get(0).Stepped_CoPay_Type__c;
                    }

                    sw.relatedDrugName = 'Drug';
                    if (ctl.Drug_Group__c != null) {
                        sw.relatedDrugName = 'Specialty OON- ' + ctl.Drug_Group__r.Name;
                    } else {
                        sw.relatedDrugName = 'Specialty OON- ' + ctl.Drug_List__r.Name;
                    }
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
    public void sortRetaillist() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedRetailCopayWrapper.size(); i++) {
            if (steppedRetailCopayWrapper.get(i).copayTierId == retailParentId) {

                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : retailParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }

                steppedRetailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedRetailCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedRetailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedRetailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }

    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortMailList() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();


        for (Integer i = 0; i < steppedMailCopayWrapper.size(); i++) {
            if (steppedMailCopayWrapper.get(i).copayTierId == mailParentId) {

                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : mailParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }


                steppedMailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedMailCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedMailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedMailCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }

    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortPaperList() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();



        for (Integer i = 0; i < steppedPaperCopayWrapper.size(); i++) {
            if (steppedPaperCopayWrapper.get(i).copayTierId == paperParentId) {
                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : paperParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }
                steppedPaperCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedPaperCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedPaperCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedPaperCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }

    /*This method creates the dynamic input for the retail panel on the basis of no of steps selected by user*/
    public void SortSpecialityList() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();

        for (Integer i = 0; i < steppedSpecialityCopayWrapper.size(); i++) {
            if (steppedSpecialityCopayWrapper.get(i).copayTierId == specialityParentId) {

                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : specialityParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }

                steppedSpecialityCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialityCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedSpecialityCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedSpecialityCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }

    public void SortOutofNetworkList() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedOutOfnetworkCopayWrapper.size(); i++) {
            if (steppedOutOfnetworkCopayWrapper.get(i).copayTierId == outOfnetworkParentId) {

                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : outOfnetworkParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }

                steppedOutOfnetworkCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedOutOfnetworkCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedOutOfnetworkCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedOutOfnetworkCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }
    //Added by Amit Jain for request 4366
     public void SortSpecialtyOutofNetworkList() {
        list < Drug_Specific_Stepped_Copay__c > lstStepped2ReplaceCopay = new list < Drug_Specific_Stepped_Copay__c > ();
        for (Integer i = 0; i < steppedSpecialtyOONCopayWrapper.size(); i++) {
            if (steppedSpecialtyOONCopayWrapper.get(i).copayTierId == SpecialtyoutOfnetworkParentId) {

                lstStepped2ReplaceCopay = [select id from Drug_Specific_Stepped_Copay__c where Drug_Specific_Copay_ID__c = : SpecialtyoutOfnetworkParentId];
                if (lstStepped2ReplaceCopay != null && lstStepped2ReplaceCopay.size() > 0) {
                    delete lstStepped2ReplaceCopay;
                }

                steppedSpecialtyOONCopayWrapper.get(i).drugSpecificSteppedCopayItemList.clear();
                for (integer j = 0; j < steppedSpecialtyOONCopayWrapper.get(i).noOfSteps; j++) {
                    Drug_Specific_Stepped_Copay__c d = new Drug_Specific_Stepped_Copay__c();
                    d.Number_of_Steps__c = String.valueOf(steppedSpecialtyOONCopayWrapper.get(i).drugSpecificSteppedCopayItemList.size() + 1);

                    steppedSpecialtyOONCopayWrapper.get(i).drugSpecificSteppedCopayItemList.add(d);

                }
            }
        }
    }
    //Added by Amit Jain ends



    public static final List < Schema.PicklistEntry > PickValue = Drug_Specific_Stepped_Copay__c.Stepped_CoPay_Type__c.getDescribe().getPicklistValues();
    public List < SelectOption > getTypeOfStepCopay() {
        List < SelectOption > options = new List < SelectOption > ();
        for (Schema.PicklistEntry P: PickValue)
        options.add(new Selectoption(p.getValue(), p.getLabel()));

        return options;
    }

    /* Mehod to save the data enterd by the user and redirect user to the previous page on the wizard*/
    public PageReference previousStep() {

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOutOfnetworkCopayWrapper != null && steppedOutOfnetworkCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedOutOfnetworkCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedOutOfnetworkCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedOutOfnetworkCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOutOfnetworkCopayWrapper);
            }
            //Added by Amit Jain for request 4366
            if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedSpecialtyOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
            //Added by Amit Jain ends    
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedSpecialtyOONCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedSpecialtyOONCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialtyOONCopayWrapper);
            }
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        PageReference pageRef = new PageReference('/apex/VF_CRDNewDrugSpecificCoPay?crdid=' + crdId);
        pageRef.getParameters().put('p1',editMode);
        pageRef.getParameters().put('p2',groupMember);
        return pageRef;
    }
    
    /* Mehod to redirect user to the previous page on the wizard when user is not in the public group*/
    public PageReference previousStep2() {
        PageReference pageRef = new PageReference('/apex/VF_CRDNewDrugSpecificCoPay?crdid=' + crdId);
        pageRef.getParameters().put('p1',editMode);
        pageRef.getParameters().put('p2',groupMember);
        return pageRef;
    }

    /* Mehod to save the data enterd by the user and redirect user to the next page on the wizard*/
    public PageReference Next() {

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (steppedMailCopayWrapper != null && steppedMailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedMailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedMailCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedMailCopayWrapper);
            }
            if (steppedRetailCopayWrapper != null && steppedRetailCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedRetailCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedRetailCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedRetailCopayWrapper);
            }
            if (steppedPaperCopayWrapper != null && steppedPaperCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedPaperCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedPaperCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedPaperCopayWrapper);
            }

            if (steppedSpecialityCopayWrapper != null && steppedSpecialityCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedSpecialityCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedSpecialityCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialityCopayWrapper);
            }
            if (steppedOutOfnetworkCopayWrapper != null && steppedOutOfnetworkCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedOutOfnetworkCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                //Code added for request 273
                for (drugSpecificCopayWrapper wrap: steppedOutOfnetworkCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedOutOfnetworkCopayWrapper);
            }
            //Added by Amit Jain for request 4366
            if (steppedSpecialtyOONCopayWrapper != null && steppedSpecialtyOONCopayWrapper.size() > 0) {
                isValid = validationMethods.validateDrugSpecificSteppedCopay(steppedSpecialtyOONCopayWrapper);
                if (!isValid) {
                    errorMessages.clear();
                    errorMessages.addAll(validationMethods.errorMessages);
                    return null;
                }
                
                for (drugSpecificCopayWrapper wrap: steppedSpecialtyOONCopayWrapper) {
                    if (wrap.drugSpecificSteppedCopayItemList == null || wrap.drugSpecificSteppedCopayItemList.size() == 0) {
                        errorMessages.add(system.label.ERR00126);
                        return null;
                    }
                }
                saveWrappedList(steppedSpecialtyOONCopayWrapper);
            }
            //Added by Amit Jain ends
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;

        } else {
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
    }

/* Mehod to redirect user to the next page on the wizard when user is not in the public group*/
    public PageReference Next2() {
        if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;

        } else {
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
    }

    /*Method to save the Tier information from  user screen takes the list of Tier along with recordType name*/
    public void saveWrappedList(List < drugSpecificCopayWrapper > wrappedList) {
        list < Drug_Specific_Stepped_Copay__c > tempList = new list < Drug_Specific_Stepped_Copay__c > ();
        for (drugSpecificCopayWrapper wrap: wrappedList) {
            if (wrap.drugSpecificSteppedCopayItemList != null && wrap.drugSpecificSteppedCopayItemList.size() > 0) {
                for (Drug_Specific_Stepped_Copay__c ct: wrap.drugSpecificSteppedCopayItemList) {
                    Drug_Specific_Stepped_Copay__c tempCopay = new Drug_Specific_Stepped_Copay__c();
                    tempCopay = ct;
                    if (tempCopay.Drug_Specific_Copay_ID__c == null) {
                        tempCopay.Drug_Specific_Copay_ID__c = wrap.copayTierId;
                    }
                    tempCopay.Stepped_CoPay_Type__c = wrap.TypeOfStepCopay;
                    tempCopay.Copay_Calculation__c = ct.Copay_Calculation__c;
                    tempCopay.Beginning_Range__c = ct.Beginning_Range__c;
                    tempCopay.End_Range__c = ct.End_Range__c;
                    tempCopay.Related_Drug_Group_List__c = wrap.relatedDrugName;

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
            upsert tempList;
            tempList.clear();
        }

    }

    /* Wrapper class to maintain Steps for each copay Tier */
    public class drugSpecificCopayWrapper {
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
        public list < Drug_Specific_Stepped_Copay__c > drugSpecificSteppedCopayItemList {
            get;
            set;
        }
        public drugSpecificCopayWrapper() {
            drugSpecificSteppedCopayItemList = new List < Drug_Specific_Stepped_Copay__c > ();
            noOfSteps = 0;
        }
    }
}