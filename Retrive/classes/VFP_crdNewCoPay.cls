/*Purpose: Apex Class for VFP_crdNewCoPay Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 7/4/2011       Apex Class for VFP_crdNewCoPay Page .
     1.1 -   Joognu Rao            15/4/2014      implemented request no 04675
     1.2 -   Vikram                01/11/2016     Implemented request 06294 - ST 774 : DSC logic Change for out of network
======================================================================== 
*/

public with sharing class VFP_crdNewCoPay {
    public integer picklistselectedvalue {
        set;
        get;
    }
    public integer picklistselectedvalue1 {
        set;
        get;
    }
    public integer picklistselectedvalue2 {
        set;
        get;
    }
    public integer picklistselectedvalue3 {
        set;
        get;
    }
    public integer paperOutOfNetworkTierCount {
        set;
        get;
    }
    //added by JR
    public integer specialityTierCount{
        set;
        get;
    }
   
    public integer maxTierRange {
        set;
        get;
    }
    public boolean isCopied {
        get;
        set;
    }
    public integer actualTierCount;
    public integer modifiedTierCount;
    public boolean isSteppedAvailable = false;
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    public List < Copay_Tier__c > mailWrapList {
        set;
        get;
    }
    public List < Copay_Tier__c > retailWrapList {
        set;
        get;
    }
    public List < Copay_Tier__c > paperWrapList {
        set;
        get;
    }
    public List < Copay_Tier__c > specialityWrapList {
        set;
        get;
    }
    public List < Copay_Tier__c > outOfNetworkWrapList {
        set;
        get;
    }
    public List < Copay_Tier__c > specialtyOONWrapList {
        set;
        get;
    }

    public integer currentTierCount = 0;
    public CRD__c crd {
        get;
        set;
    }
    public String crdId {
        get;
        set;
    }
    public String pageName {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public List < Copay_Tier__c > copayTierList {get;set;}
    public list < Copay_Tier__c > tempList = new list < Copay_Tier__c > ();
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING PAPER = 'Paper';
    PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
    PRIVATE STATIC FINAL STRING SPECIALITY = 'Specialty';
    PRIVATE STATIC FINAL STRING PAPEROON = 'Paper Out of Network';
    PRIVATE STATIC FINAL STRING SPECIALITYOON = 'Specialty OON';
    PRIVATE STATIC FINAL STRING O1 =  '--None--';
    PRIVATE STATIC FINAL STRING O2 =  'Brand (SSB & MSB)';
    PRIVATE STATIC FINAL STRING O3 =  'Single Source Brand (SSB)';
    PRIVATE STATIC FINAL STRING O4 =  'Multi Source Brand (MSB)';
    PRIVATE STATIC FINAL STRING O5 =  'Generic (SSG & MSG)';
    PRIVATE STATIC FINAL STRING O6 =  'Single Source Generic (SSG)';
    PRIVATE STATIC FINAL STRING O7 =  'Multi Source Generic (MSG)';
    PRIVATE STATIC FINAL STRING O8 =  'Specialty (Preferred & Non-Preferred)';
    PRIVATE STATIC FINAL STRING O9 =  'Preferred Specialty';
    PRIVATE STATIC FINAL STRING O10 =  'Non-Preferred Specialty';
    PRIVATE STATIC FINAL STRING O11 =  'Preferred Brand';
    PRIVATE STATIC FINAL STRING O12 =  'Non-preferred Brand';
    PRIVATE STATIC FINAL STRING O13 =  'Non-Preferred Generics';
    PRIVATE STATIC FINAL STRING O14 =  'All Drugs';
    PRIVATE STATIC FINAL STRING O15 =  'Non-preferred brand and Non-preferred generics';
    PRIVATE STATIC FINAL STRING O16 =  'Preferred Generics';
    PRIVATE STATIC FINAL STRING O17 =  'Non-Preferred Generic, Brand and Specialty';
    PRIVATE STATIC FINAL STRING O18 =  'Preferred Brand Specialty';
    PRIVATE STATIC FINAL STRING O19 =  'Preferred Generic Specialty';
    PRIVATE STATIC FINAL STRING O20 =  'Specialty (Preferred Brand & Preferred Generic)';
    public id recordTypeId {
        get;
        set;
    }
    public set < id > setCopay2Delete = new set < id > ();

    public boolean isRetailtoPaper {
        get;
        set;
    }
    public boolean isRetailtoSpeciality {
        get;
        set;
    }


    /*Constructor of the class*/
    public VFP_crdNewCoPay(ApexPages.StandardController stdController) {
        
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        this.crd = (CRD__c) stdController.getRecord();
        crdId = crd.id;
        mailWrapList = new List < Copay_Tier__c > ();
        retailWrapList = new List < Copay_Tier__c > ();
        paperWrapList = new List < Copay_Tier__c > ();
        specialityWrapList = new List < Copay_Tier__c > ();
        outOfNetworkWrapList = new List < Copay_Tier__c > ();
        specialtyOONWrapList = new List< Copay_Tier__c >();
        pageName = ApexPages.CurrentPage().getParameters().get('currentPageName');
        copayTierList = [select id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc), RecordType.Name,Number_Of_Steps__c, Tier_Type__c, Days_Per_Fill__c, (Select Copay_Tier__c, Min_Range__c, Max_Range__c, Percent_Amount__c, Stepped_CoPay_Types__c, Copay_Calc__c, Number_of_Ranges__c From SteppedCopays__r), Reverse_Copay__c, Stepped_Copay__c, Tier__c, Dollar_Amount__c, Copay_Calc__c, Percent__c, Tier_Name__c, name, Min_Dollar__c, Max_Dollar__c, CRD__c from Copay_Tier__c where CRD__c = : this.crd.id order by Recordtype.name,tier__C];
        crd = [Select Name,National__c,Y_Schd__c, Integrate_with_Medical__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c,Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, Brands_DAW_5_take_a_gen_copay_Retail__c, Brands_DAW_5_take_a_gen_copay_Mail__c, Brands_DAW_5_take_a_gen_copay_Speciality__c, Brands_DAW_5_take_a_gen_copay_Paper__c, Specialty_Number_of_Tiers__c, RxPlan_ID_Status__c, Plan_Type_Specialty__c, Plan_Type_Paper__c, SteppedCopayCount__c, Retail_Number_of_Tiers__c, Paper_Number_of_Tiers__c, Mail_Number_of_Tiers__c, Plan_Type_Retail__c, Plan_Type_Mail__c, Insured_Type__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Mail_copays__c, Is_there_Paper_Out_of_Network__c, Different_copays_from_Paper_In_Network__c, Apply_Penalty__c, Penalty_Type__c, Penalty_Amount__c, Percentage_Applied__c, Any_drug_specific_Paper_Out_of_Network__c, Brands_w_DAW_5_take_a_generic_copay__c, Paper_Out_of_Network_Number_of_Tiers__c, Plan_Type_Paper_Out_of_Network__c, Any_DAW_specific_Paper_OON_copays__c,Any_DAW_specific_Specialty_OON_copays__c,
        Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c  From CRD__c where Id = : crdId];

        actualTierCount = copayTierList.size();
        picklistselectedvalue = 0;
        picklistselectedvalue1 = 0;
        picklistselectedvalue2 = 0;
        picklistselectedvalue3 = 0;
        paperOutOfNetworkTierCount = 0;
        specialityTierCount = 0;
        isCopied = false;
        //for issue 1480
        crd.Brands_DAW_5_take_a_gen_copay_Retail__c = crd.Plan_Type_Retail__c;
        crd.Brands_DAW_5_take_a_gen_copay_Mail__c = crd.Plan_Type_Mail__c;
        crd.Brands_DAW_5_take_a_gen_copay_Speciality__c = crd.Plan_Type_Specialty__c;
        crd.Brands_DAW_5_take_a_gen_copay_Paper__c = crd.Plan_Type_Paper__c;
        crd.Brands_w_DAW_5_take_a_generic_copay__c = crd.Plan_Type_Paper_Out_of_Network__c;
        crd.Brands_w_DAW_5_take_a_generic_copay_spec__c = crd.Plan_Type_Specialty_OON__c;

        if (copayTierList != null && copayTierList.size() > 0) {
            for (Copay_Tier__c tier: copayTierList) {
                    if (crd.Plan_Type_Mail__c && MAIL.equalsIgnoreCase(tier.RecordType.Name)) {
                    mailWrapList.add(tier);

                }
                if (crd.Plan_Type_Paper__c && PAPER.equalsIgnoreCase(tier.RecordType.Name) ) {
                    paperWrapList.add(tier);

                }
                if (crd.Plan_Type_Retail__c && RETAIL.equalsIgnoreCase(tier.RecordType.Name) ) {
                    retailWrapList.add(tier);

                }
                if (crd.Plan_Type_Specialty__c && SPECIALITY.equalsIgnoreCase(tier.RecordType.Name)) {
                    specialityWrapList.add(tier);

                }
                if (crd.Plan_Type_Paper_Out_of_Network__c && PAPEROON.equalsIgnoreCase(tier.RecordType.Name)) {
                    outOfNetworkWrapList.add(tier);

                }
                //added by JR
                 if (crd.Plan_Type_Specialty_OON__c && SPECIALITYOON.equalsIgnoreCase(tier.RecordType.Name)) {
                    specialtyOONWrapList.add(tier);

                }

            }
        }
        if (mailWrapList != null) {
            picklistselectedvalue = mailWrapList.size(); //Integer.valueOf(crd.Mail_Number_of_Tiers__c); 
        }
        if (retailWrapList != null) {
            picklistselectedvalue1 = retailWrapList.size(); //Integer.valueOf(crd.Retail_Number_of_Tiers__c); 
        }

        if (paperWrapList != null) {
            picklistselectedvalue2 = paperWrapList.size(); //Integer.valueOf(crd.Paper_Number_of_Tiers__c); 
        }
        if (specialityWrapList != null) {
            picklistselectedvalue3 = specialityWrapList.size(); //Integer.valueOf(crd.Specialty_Number_of_Tiers__c);
        }
        if (outOfNetworkWrapList != null) {
            paperOutOfNetworkTierCount = outOfNetworkWrapList.size(); //Integer.valueOf(crd.Specialty_Number_of_Tiers__c);
        }
        //added by JR
         if (specialtyOONWrapList != null) {
            specialityTierCount = specialtyOONWrapList.size(); //Integer.valueOf(crd.Specialty_OON_Number_of_Tiers__c);
        }
        errorMessages = new list < string > ();


    }

    /*method for saving the Tier Information and Data of the crd */
    public PageReference Save() {
        errorMessages.clear();
        if (mailWrapList != null) {
            crd.Mail_Number_of_Tiers__c = String.valueOf(mailWrapList.size());
        }

        if (retailWrapList != null) {
            crd.Retail_Number_of_Tiers__c = String.valueOf(retailWrapList.size()); // String.valueOf(picklistselectedvalue1);
        }

        if (paperWrapList != null) {
            crd.Paper_Number_of_Tiers__c = String.valueOf(paperWrapList.size());
        }

        if (specialityWrapList != null) {
            crd.Specialty_Number_of_Tiers__c = String.valueOf(specialityWrapList.size());
        }
        if (outOfNetworkWrapList != null) {
            crd.Paper_Out_of_Network_Number_of_Tiers__c = String.valueOf(outOfNetworkWrapList.size());
        }
        //added by JR
        if (specialtyOONWrapList != null) {
            crd.Specialty_OON_Number_of_Tiers__c = String.valueOf(specialtyOONWrapList.size());
        }


        modifiedTierCount = picklistselectedvalue + picklistselectedvalue1 + picklistselectedvalue2 + picklistselectedvalue3 +specialityTierCount+ paperOutOfNetworkTierCount;
        list < Copay_Tier__c > lstOldCopayTier = new list < Copay_Tier__c > ([select id from Copay_Tier__c where CRD__c = : crd.id]);
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        
        //added by JR to implement request no 04675
        if (crd.Plan_Type_Specialty_OON__c == true && crd.Plan_Type_Paper_Out_of_Network__c==false) {
                errorMessages.add(System.Label.ERR0244);
                return null;
            }
        
        if (crd.Plan_Type_Mail__c && mailWrapList != null && mailWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(mailWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }

        }


        if (crd.Plan_Type_Paper_Out_of_Network__c) {
            isValid = validationMethods.validatePaperOutOfNetworkCopay(crd);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (crd.Plan_Type_Paper_Out_of_Network__c && outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(outOfNetworkWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        //added by JR
         if (crd.Plan_Type_Specialty_OON__c && specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(specialtyOONWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (crd.Plan_Type_Retail__c && retailWrapList != null && retailWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(retailWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }

        }

        if (crd.Plan_Type_Paper__c && paperWrapList != null && paperWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(paperWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }

        }

        if (crd.Plan_Type_Specialty__c && specialityWrapList != null && specialityWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(specialityWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {


            boolean isNewData = checkChangedData();
            if ((isNewData == false) || isCopied) {
                // setCopay2Delete
                if (mailWrapList != null && mailWrapList.size() > 0) {
                    for (Copay_Tier__c ct: mailWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    for (Copay_Tier__c ct: retailWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }


                if (paperWrapList != null && paperWrapList.size() > 0) {
                    for (Copay_Tier__c ct: paperWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    for (Copay_Tier__c ct: specialityWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    for (Copay_Tier__c ct: outOfNetworkWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    for (Copay_Tier__c ct: specialtyOONWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                list < Copay_Tier__c > lstCopay2Delete = new list < Copay_Tier__c > ();
                if (setCopay2Delete != null && setCopay2Delete.size() > 0) {
                    lstCopay2Delete = [select id from Copay_Tier__c where id not in : setCopay2Delete and CRD__c = : crd.id];
                }

                if (lstCopay2Delete != null && lstCopay2Delete.size() > 0) {
                    database.delete(lstCopay2Delete);
                    lstCopay2Delete.clear();
                }

                if (mailWrapList != null && mailWrapList.size() > 0) {
                    saveWrappedList(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    saveWrappedList(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    saveWrappedList(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    saveWrappedList(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    saveWrappedList(outOfNetworkWrapList, PAPEROON);
                }
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    saveWrappedList(specialtyOONWrapList, SPECIALITYOON);
                }

            } else {
                if (mailWrapList != null && mailWrapList.size() > 0) {
                    updateWrappedList(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    updateWrappedList(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    updateWrappedList(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    updateWrappedList(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    updateWrappedList(outOfNetworkWrapList, PAPEROON);
                } 
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    updateWrappedList(specialtyOONWrapList, SPECIALITYOON);
                }
            }
            database.update(crd);
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }


        if (!crd.Plan_Type_Mail__c && !crd.Plan_Type_Retail__c &&!crd.Plan_Type_Specialty_OON__c  &&!crd.Plan_Type_Paper__c && !crd.Plan_Type_Specialty__c && !crd.Plan_Type_Paper_Out_of_Network__c) {
            lstOldCopayTier = new list < Copay_Tier__c > ([select id from Copay_Tier__c where CRD__c = : crd.id]);
            if (lstOldCopayTier != null && lstOldCopayTier.size() > 0) {
                database.delete(lstOldCopayTier);
                lstOldCopayTier.clear();
            }
            callMacAtMailApplies();
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crd.Id);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        if (isSteppedAvailable) {
            callMacAtMailApplies();
            PageReference pageRef = new PageReference('/apex/VF_crdNewSteppedCoPay?crdid=' + crd.id);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {
            if (crd.Any_drug_specific_Specialty_copays__c || crd.Any_drug_specific_Mail_copays__c || crd.Any_drug_specific_Paper_copays__c || crd.Any_drug_specific_Retail_copays__c || crd.Any_drug_specific_Specialty_OON_copays__c || crd.Any_drug_specific_Paper_Out_of_Network__c) {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDrugSpecificCoPay?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            } else if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c ||crd.Any_DAW_specific_Paper_OON_copays__c) {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            } else {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            }

        }
    }


    //Method to save the Tier information from  user screen takes the list of Tier along with recordType name
    public void saveWrappedList(List < Copay_Tier__c > wrappedList, String recordTypeName) {
        list < Copay_Tier__c > lstCopay = new list < Copay_Tier__c > ();
        list < Copay_Tier__c > lstCopay2Update = new list < Copay_Tier__c > ();

        recordTypeId = getRecordType(recordTypeName);
        for (Copay_Tier__c ct: wrappedList) {
            Copay_Tier__c tempCopay;

            if (ct.id != null) {
                tempCopay = new Copay_Tier__c(id = ct.id);
            } else {
                tempCopay = new Copay_Tier__c();
            }
            //Copay_Tier__c tempCopay = new Copay_Tier__c();
            tempCopay.Reverse_Copay__c = ct.Reverse_Copay__c;
            tempCopay.Stepped_Copay__c = ct.Stepped_Copay__c;
            tempCopay.Max_Dollar__c = ct.Max_Dollar__c;
            tempCopay.Min_Dollar__c = ct.Min_Dollar__c;
            tempCopay.Tier_Type__c = ct.Tier_Type__c;
            tempCopay.Days_Per_Fill__c = ct.Days_Per_Fill__c;
            tempCopay.Dollar_Amount__c = ct.Dollar_Amount__c;
            tempCopay.Copay_Calc__c = ct.Copay_Calc__c;
            tempCopay.Percent__c = ct.Percent__c;
            tempCopay.Tier__c = ct.Tier__c;
            tempCopay.RecordTypeId = recordTypeId;
            if (ct.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            if (ct.id != null) {
                lstCopay2Update.add(tempCopay);
            } else {
                tempCopay.CRD__c = crd.id;
                lstCopay.add(tempCopay);
            }               
        }
        if (lstCopay2Update != null && lstCopay2Update.size() > 0) {
            database.update(lstCopay2Update);
            lstCopay2Update.clear();
        }
        if (lstCopay != null && lstCopay.size() > 0) {
            database.insert(lstCopay);
            lstCopay.clear();
        }



    }


    /*Method to update the Tier information from  user screen takes the list of Tier along with recordType name*/
    /* Trigger deletes the redundant record after this function call */
    public void updateWrappedList(List < Copay_Tier__c > wrappedList, String recordTypeName) {
        recordTypeId = getRecordType(recordTypeName);
        for (Copay_Tier__c ct: wrappedList) {
            Copay_Tier__c tempCopay = new Copay_Tier__c(id = ct.id);
            tempCopay = ct;
            if (tempCopay.CRD__c == null) {
                tempCopay.CRD__c = crd.id;
            }
            // 
            tempCopay.RecordTypeId = recordTypeId;
            if (ct.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            tempList.add(tempCopay);
        }
        if (tempList != null && tempList.size() > 0) {
            database.upsert(tempList);
            tempList.clear();
        }
    }


    public list < SelectOption > getItems() {
        maxTierRange = 5; //integer.ValueOf(system.label.CL0000001);
        List < SelectOption > options = new List < SelectOption > ();
        for (integer i = 0; i <= maxTierRange; i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
    public List<SelectOption> getspecialtyPicklistOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption(O1,O1));
        countryOptions.add(new SelectOption(O2,O2));
        countryOptions.add(new SelectOption(O3,O3));
        countryOptions.add(new SelectOption(O4,O4));
        countryOptions.add(new SelectOption(O5,O5));
        countryOptions.add(new SelectOption(O6,O6));
        countryOptions.add(new SelectOption(O7,O7));
        countryOptions.add(new SelectOption(O8,O8));
        countryOptions.add(new SelectOption(O9,O9));
        countryOptions.add(new SelectOption(O10,O10));
        countryOptions.add(new SelectOption(O11,O11));
        countryOptions.add(new SelectOption(O12,O12));
        countryOptions.add(new SelectOption(O13,O13));
        countryOptions.add(new SelectOption(O14,O14));
        countryOptions.add(new SelectOption(O15,O15));
        countryOptions.add(new SelectOption(O16,O16));
        countryOptions.add(new SelectOption(O17,O17));
        countryOptions.add(new SelectOption(O18,O18));
        countryOptions.add(new SelectOption(O19,O19));
        countryOptions.add(new SelectOption(O20,O20)); 
        return countryOptions;
    }


    public list < Copay_Tier__c > getRetaildata() {
        return retailWrapList;
    }

    public list < Copay_Tier__c > getMaildata() {
        return mailWrapList;
    }

    public list < Copay_Tier__c > getPaperdata() {
        return paperWrapList;
    }

    public list < Copay_Tier__c > getSpecialitydata() {
        return specialityWrapList;
    }

    public list < Copay_Tier__c > getPaperOutOfNetworkdata() {
        return outOfNetworkWrapList;
    }
    
    //added by JR
     public list < Copay_Tier__c > getSpecialityOutOfNetworkdata() {
        return specialtyOONWrapList;
    }
    
    
    /*Method to populate dynamic input row as per user selection on  Number of Tiers picklist */
    public void sortPaperlist() {
        paperWrapList.clear();
        if (paperWrapList != null) {
            currentTierCount = paperWrapList.size();
        }
        for (integer i = currentTierCount; i < picklistselectedvalue2; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(paperWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;


            paperWrapList.add(d);
        }
    }

    public void sortPaperOutOfNetworkList() {
        outOfNetworkWrapList.clear();
        if (outOfNetworkWrapList != null) {
            currentTierCount = outOfNetworkWrapList.size();
        }
        for (integer i = currentTierCount; i < paperOutOfNetworkTierCount; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(outOfNetworkWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;


            outOfNetworkWrapList.add(d);
        }
    }
    //added by JR
    public void sortSpecialityOutOfNetworkList() {
        specialtyOONWrapList.clear();
        if (specialtyOONWrapList != null) {
            currentTierCount = specialtyOONWrapList.size();
        }
        for (integer i = currentTierCount; i < specialityTierCount; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(specialtyOONWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;


            specialtyOONWrapList.add(d);
        }
    }

    /*Method to populate dynamic input row as per user selection on  Number of Tiers picklist */
    public void sortReaillist() {
        retailWrapList.clear();

        if (retailWrapList != null) {
            currentTierCount = retailWrapList.size();
        }
        for (integer i = currentTierCount; i < picklistselectedvalue1; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(retailWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;
            retailWrapList.add(d);
        }
    }

    /*Method to populate dynamic input row as per user selection on  Number of Tiers picklist */
    public void sortSpecialitylist() {
        specialityWrapList.clear();
        if (specialityWrapList != null) {
            currentTierCount = specialityWrapList.size();
        }
        for (integer i = currentTierCount; i < picklistselectedvalue3; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(specialityWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;
            specialityWrapList.add(d);
        }
    }

    /*Method to populate dynamic input row as per user selection on  Number of Tiers picklist */
    public void sortMaillist() {
        mailWrapList.clear();
        if (mailWrapList != null) {
            currentTierCount = mailWrapList.size();
        }
        for (integer i = currentTierCount; i < picklistselectedvalue; i++) {
            Copay_Tier__c d = new Copay_Tier__c();
            d.Tier__c = String.valueOf(mailWrapList.size() + 1);
            d.Stepped_Copay__c = false;
            d.Reverse_Copay__c = false;
            mailWrapList.add(d);
        }
    }

    public pageReference showOONLowerPanel() {
        crd.Any_drug_specific_Paper_Out_of_Network__c = false;
        crd.Any_DAW_specific_Paper_OON_copays__c = false;
        paperOutOfNetworkTierCount = 0;
        outOfNetworkWrapList.clear();
        return null;

    }
    // For request 06294
    public pageReference showOONLowerPanelForNo() {
        crd.Any_drug_specific_Paper_Out_of_Network__c = false;
        crd.Any_DAW_specific_Paper_OON_copays__c = false;
        outOfNetworkWrapList.clear();
        return null;

    }
    // 06294 ends
    public pageReference showSpecialityOONLowerPanelforNo(){
        crd.Any_drug_specific_Specialty_OON_copays__c = false;
        crd.Any_DAW_specific_Specialty_OON_copays__c = false;
        specialtyOONWrapList.clear();
        return null;
    }
    public PageReference showpaperOOnPanel() {
        if (crd.Plan_Type_Paper_Out_of_Network__c == false) {
            crd.Any_drug_specific_Paper_Out_of_Network__c = false;
            crd.Any_DAW_specific_Paper_OON_copays__c = false;
            crd.Brands_w_DAW_5_take_a_generic_copay__c = false;
        } else {
            crd.Brands_w_DAW_5_take_a_generic_copay__c = crd.Plan_Type_Paper_Out_of_Network__c;
        }
        return null;
    }
    public PageReference showSpecialityOONPanel() {
        if (crd.Plan_Type_Specialty_OON__c == false) {
            crd.Any_drug_specific_Specialty_OON_copays__c = false;
            crd.Any_DAW_specific_Specialty_OON_copays__c = false;
            crd.Brands_w_DAW_5_take_a_generic_copay_spec__c = false;
        } else {
            crd.Brands_w_DAW_5_take_a_generic_copay_spec__c = crd.Plan_Type_Specialty_OON__c;
        }
        return null;
    }
    public pageReference showSpecialityOONLowerPanel() {
        crd.Any_drug_specific_Specialty_OON_copays__c = false;
        crd.Any_DAW_specific_Specialty_OON_copays__c = false;
        specialityTierCount = 0;
        specialtyOONWrapList.clear();
        return null;

    }

    public PageReference showMailPanel() {
        if (crd.Plan_Type_Mail__c == false) {
            crd.Any_drug_specific_Mail_copays__c = false;
            crd.Any_DAW_specific_Mail_copays__c = false;
            crd.Brands_DAW_5_take_a_gen_copay_Mail__c = false;
        } else {
            crd.Brands_DAW_5_take_a_gen_copay_Mail__c = crd.Plan_Type_Mail__c;
        }
        return null;
    }
    public PageReference showRetailPanel() {
        if (crd.Plan_Type_Retail__c == false) {
            crd.Any_drug_specific_Retail_copays__c = false;
            crd.Any_DAW_specific_Retail_copays__c = false;
            crd.Brands_DAW_5_take_a_gen_copay_Retail__c = false;
        } else {
            crd.Brands_DAW_5_take_a_gen_copay_Retail__c = crd.Plan_Type_Retail__c;

        }
        return null;
    }
    public PageReference showSpecialityPanel() {
        if (crd.Plan_Type_Specialty__c == false) {
            crd.Any_drug_specific_Specialty_copays__c = false;
            crd.Any_DAW_specific_Specialty_copays__c = false;
            crd.Brands_DAW_5_take_a_gen_copay_Speciality__c = false;
        } else {
            crd.Brands_DAW_5_take_a_gen_copay_Speciality__c = crd.Plan_Type_Specialty__c;
        }
        return null;
    }
    public PageReference showPaperPanel() {
        if (crd.Plan_Type_Paper__c == false) {
            crd.Any_drug_specific_Paper_copays__c = false;
            crd.Any_DAW_specific_Paper_copays__c = false;
            crd.Brands_DAW_5_take_a_gen_copay_Paper__c = false;
        } else {
            crd.Brands_DAW_5_take_a_gen_copay_Paper__c = crd.Plan_Type_Paper__c;
        }
        return null;
    }

    public PageReference showPanel() {
        return null;
    }

    /*Method to get the record type id from schema describe information */
    public Id getRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Copay_Tier__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }
    
    Public PageReference previousStep() {
        errorMessages.clear();
        if (mailWrapList != null) {
            crd.Mail_Number_of_Tiers__c = String.valueOf(mailWrapList.size());
        }

        if (retailWrapList != null) {
            crd.Retail_Number_of_Tiers__c = String.valueOf(retailWrapList.size()); // String.valueOf(picklistselectedvalue1);
        }

        if (paperWrapList != null) {
            crd.Paper_Number_of_Tiers__c = String.valueOf(paperWrapList.size());
        }

        if (specialityWrapList != null) {
            crd.Specialty_Number_of_Tiers__c = String.valueOf(specialityWrapList.size());
        }

        modifiedTierCount = picklistselectedvalue + picklistselectedvalue1 + picklistselectedvalue2 + picklistselectedvalue3;
        list < Copay_Tier__c > lstOldCopayTier = new list < Copay_Tier__c > ([select id from Copay_Tier__c where CRD__c = : crd.id]);
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;
        if (crd.Plan_Type_Mail__c && mailWrapList != null && mailWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(mailWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (crd.Plan_Type_Paper_Out_of_Network__c && outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
            isValid = validationMethods.validatePaperOutOfNetworkCopay(crd);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }

        }
        //added by JR
        if (crd.Plan_Type_Specialty_OON__c && specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
            isValid = validationMethods.validatePaperOutOfNetworkCopay(crd);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }

        }
        if (crd.Plan_Type_Retail__c && retailWrapList != null && retailWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(retailWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (crd.Plan_Type_Paper__c && paperWrapList != null && paperWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(paperWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (crd.Plan_Type_Specialty__c && specialityWrapList != null && specialityWrapList.size() > 0) {
            isValid = validationMethods.validateCopay(specialityWrapList);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {


            boolean isNewData = checkChangedData();
            if ((isNewData == false) || isCopied) {


                if (lstOldCopayTier != null && lstOldCopayTier.size() > 0) {
                    database.delete(lstOldCopayTier);
                    lstOldCopayTier.clear();
                }


                if (mailWrapList != null && mailWrapList.size() > 0) {
                    saveWrappedList(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    saveWrappedList(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    saveWrappedList(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    saveWrappedList(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    saveWrappedList(outOfNetworkWrapList, PAPEROON);
                }
                //added by JR
                 if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    saveWrappedList(specialtyOONWrapList, SPECIALITYOON);
                }

            } else {
                if (mailWrapList != null && mailWrapList.size() > 0) {
                    updateWrappedList(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    updateWrappedList(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    updateWrappedList(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    updateWrappedList(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    updateWrappedList(outOfNetworkWrapList, PAPEROON);
                } 
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    updateWrappedList(specialtyOONWrapList, SPECIALITYOON);
                }
            }
            database.update(crd);
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }

        /*   Commented By Sushant : Req 04937
       if(crd.Insured_Type__c=='Self Insured' &&(crd.National__c=='Key' || crd.National__c=='National')){
            Pagereference pageRef = new Pagereference('/apex/VF_CRDCVSWebAccessUsers?id=' + crdId);
            return pageRef;
        }else{ 
       } */
           callMacAtMailApplies();       
           Pagereference pageRef = new Pagereference('/apex/VF_RetailVaccineProgramScreen?crdid=' + crd.Id);//Richa modified the redirection as per Req 4890
           pageRef.getParameters().put(EDITMODEPARAM,editMode);
           pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        
   /*Method used to go to previous screen for users not in public group */        
     Public PageReference previousStep2() {
           Pagereference pageRef = new Pagereference('/apex/VF_RetailVaccineProgramScreen?crdid=' + crd.Id);
           pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }   
    
    /*Method used to copy data from a retail copay to others */
    public void copyFromRetail() {
        isCopied = true;
        if (isRetailtoPaper && crd.Plan_Type_Paper__c) {
            paperWrapList.clear();
            for (Copay_Tier__c ct: retailWrapList) {
                Copay_Tier__c tempCopay = new Copay_Tier__c();
                tempCopay.Reverse_Copay__c = ct.Reverse_Copay__c;
                tempCopay.Stepped_Copay__c = ct.Stepped_Copay__c;
                tempCopay.Max_Dollar__c = ct.Max_Dollar__c;
                tempCopay.Min_Dollar__c = ct.Min_Dollar__c;
                tempCopay.Dollar_Amount__c = ct.Dollar_Amount__c;
                tempCopay.Tier_Type__c = ct.Tier_Type__c;
                tempCopay.Copay_Calc__c = ct.Copay_Calc__c;
                tempCopay.Percent__c = ct.Percent__c;
                tempCopay.CRD__c = crd.id;
                tempCopay.Tier__c = ct.Tier__c;
                tempCopay.Days_Per_Fill__c = ct.Days_Per_Fill__c;
                tempCopay.RecordTypeId = ct.recordTypeId;
                paperWrapList.add(tempCopay);
            }   
            picklistselectedvalue2 = paperWrapList.size();

        }

        if (isRetailtoSpeciality && crd.Plan_Type_Specialty__c) {
            specialityWrapList.clear();
            for (Copay_Tier__c ct: retailWrapList) {
                Copay_Tier__c tempCopay = new Copay_Tier__c();
                tempCopay.Reverse_Copay__c = ct.Reverse_Copay__c;
                tempCopay.Stepped_Copay__c = ct.Stepped_Copay__c;
                tempCopay.Max_Dollar__c = ct.Max_Dollar__c;
                tempCopay.Min_Dollar__c = ct.Min_Dollar__c;
                tempCopay.Tier_Type__c = ct.Tier_Type__c;
                tempCopay.Dollar_Amount__c = ct.Dollar_Amount__c;
                tempCopay.Copay_Calc__c = ct.Copay_Calc__c;
                tempCopay.Percent__c = ct.Percent__c;
                tempCopay.CRD__c = crd.id;
                tempCopay.Tier__c = ct.Tier__c;
                tempCopay.Days_Per_Fill__c = ct.Days_Per_Fill__c;
                tempCopay.RecordTypeId = ct.recordTypeId;
                specialityWrapList.add(tempCopay);
            }    
            picklistselectedvalue3 = specialityWrapList.size();

        }      
    }
    /*Method to check if there is a change in existing data on Copay*/
    public boolean checkChangedData() {
        list < Copay_Tier__c > lstCopay = new list < Copay_Tier__c > ();
        boolean isNewDataAvailable;
        integer mailCopaySize = 0;
        integer retailCopaySize = 0;
        integer specialityCopaySize = 0;
        integer paperCopaySize = 0;
        integer paperOutOfNetworkCopaySize = 0;
        integer specialityOONSize =0;
        lstCopay = [select id, Name, RecordTypeid, RecordType.Name from Copay_Tier__c where CRD__c = : crdId];
        if (lstCopay != null && lstCopay.size() > 0) {
            for (Copay_Tier__c copay: lstCopay) {
                if (MAIL.equalsIgnoreCase(copay.RecordType.Name)) {
                    mailCopaySize = mailCopaySize + 1;
                }

                if (RETAIL.equalsIgnoreCase(copay.RecordType.Name)) {
                    retailCopaySize = retailCopaySize + 1;
                }
                if (PAPER.equalsIgnoreCase(copay.RecordType.Name)) {
                    specialityCopaySize = specialityCopaySize + 1;
                }

                if (SPECIALITY.equalsIgnoreCase(copay.RecordType.Name)) {
                    paperCopaySize = paperCopaySize + 1;
                }
                if (PAPEROON.equalsIgnoreCase(copay.RecordType.Name)) {
                    paperOutOfNetworkCopaySize = paperOutOfNetworkCopaySize + 1;
                }
                //added by JR
                if (SPECIALITYOON.equalsIgnoreCase(copay.RecordType.Name)) {
                    specialityOONSize = specialityOONSize + 1;
                }
            }
            if (mailCopaySize != picklistselectedvalue || retailCopaySize != picklistselectedvalue1 || specialityCopaySize != picklistselectedvalue2 || paperCopaySize != picklistselectedvalue3 ||specialityOONSize !=specialityTierCount || paperOutOfNetworkCopaySize != paperOutOfNetworkTierCount) {
                isNewDataAvailable = false;
            }
        } else {
            isNewDataAvailable = true;
        }
        return isNewDataAvailable;

    }
    //Richa added method to call setMACatMailApplies method of GC_Utils_Method for Req-5003
    public void callMacAtMailApplies(){
        list<Copay_Tier__c> copayTier = new list<Copay_Tier__c>();
        list<Accumulations__c>acumltn = new list<Accumulations__c>();
        copayTier = [Select Tier__c, Percent__c, Dollar_Amount__c, Tier_Type__c, Tier_Name__c from Copay_Tier__c where Tier_Name__c LIKE '%Mail%' AND crd__c = : crdId]; 
        acumltn = [Select Deductible_Amount__c, What_is_the_In_Network_Deductible_Amount__c, What_is_the_OON_Deductible_Amount__c from Accumulations__c where CRD_ID__c = : crdId];
        GC_Utils_Method utilinstance = new GC_Utils_Method();
        utilinstance.setMACatMailApplies(crd, copayTier, acumltn);
    }
    
/*method for next button story implementation */
    public PageReference Save1() {
                errorMessages.clear();
        if (mailWrapList != null) {
            crd.Mail_Number_of_Tiers__c = String.valueOf(mailWrapList.size());
        }

        if (retailWrapList != null) {
            crd.Retail_Number_of_Tiers__c = String.valueOf(retailWrapList.size()); // String.valueOf(picklistselectedvalue1);
        }

        if (paperWrapList != null) {
            crd.Paper_Number_of_Tiers__c = String.valueOf(paperWrapList.size());
        }

        if (specialityWrapList != null) {
            crd.Specialty_Number_of_Tiers__c = String.valueOf(specialityWrapList.size());
        }
        if (outOfNetworkWrapList != null) {
            crd.Paper_Out_of_Network_Number_of_Tiers__c = String.valueOf(outOfNetworkWrapList.size());
        }
        //added by JR
        if (specialtyOONWrapList != null) {
            crd.Specialty_OON_Number_of_Tiers__c = String.valueOf(specialtyOONWrapList.size());
        }


        modifiedTierCount = picklistselectedvalue + picklistselectedvalue1 + picklistselectedvalue2 + picklistselectedvalue3 +specialityTierCount+ paperOutOfNetworkTierCount;
        list < Copay_Tier__c > lstOldCopayTier = new list < Copay_Tier__c > ([select id from Copay_Tier__c where CRD__c = : crd.id]);
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            boolean isNewData = checkChangedData();
            if ((isNewData == false) || isCopied) {
                // setCopay2Delete
                if (mailWrapList != null && mailWrapList.size() > 0) {
                    for (Copay_Tier__c ct: mailWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    for (Copay_Tier__c ct: retailWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }


                if (paperWrapList != null && paperWrapList.size() > 0) {
                    for (Copay_Tier__c ct: paperWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    for (Copay_Tier__c ct: specialityWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    for (Copay_Tier__c ct: outOfNetworkWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    for (Copay_Tier__c ct: specialtyOONWrapList) {
                        setCopay2Delete.add(ct.id);
                    }
                }

                list < Copay_Tier__c > lstCopay2Delete = new list < Copay_Tier__c > ();
                if (setCopay2Delete != null && setCopay2Delete.size() > 0) {
                    lstCopay2Delete = [select id from Copay_Tier__c where id not in : setCopay2Delete and CRD__c = : crd.id];
                }

                if (lstCopay2Delete != null && lstCopay2Delete.size() > 0) {
                    lstCopay2Delete.clear();
                }

                if (mailWrapList != null && mailWrapList.size() > 0) {
                    saveWrappedList1(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    saveWrappedList1(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    saveWrappedList1(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    saveWrappedList1(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    saveWrappedList1(outOfNetworkWrapList, PAPEROON);
                }
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    saveWrappedList1(specialtyOONWrapList, SPECIALITYOON);
                }

            } else {
                if (mailWrapList != null && mailWrapList.size() > 0) {
                    updateWrappedList1(mailWrapList, MAIL);
                }

                if (retailWrapList != null && retailWrapList.size() > 0) {
                    updateWrappedList1(retailWrapList, RETAIL);
                }

                if (paperWrapList != null && paperWrapList.size() > 0) {
                    updateWrappedList1(paperWrapList, PAPER);
                }

                if (specialityWrapList != null && specialityWrapList.size() > 0) {
                    updateWrappedList1(specialityWrapList, SPECIALITY);
                }
                if (outOfNetworkWrapList != null && outOfNetworkWrapList.size() > 0) {
                    updateWrappedList1(outOfNetworkWrapList, PAPEROON);
                } 
                //added by JR
                if (specialtyOONWrapList != null && specialtyOONWrapList.size() > 0) {
                    updateWrappedList1(specialtyOONWrapList, SPECIALITYOON);
                }
            }
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }


        if (!crd.Plan_Type_Mail__c && !crd.Plan_Type_Retail__c &&!crd.Plan_Type_Specialty_OON__c  &&!crd.Plan_Type_Paper__c && !crd.Plan_Type_Specialty__c && !crd.Plan_Type_Paper_Out_of_Network__c) {
            callMacAtMailApplies();
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crd.Id);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        if (isSteppedAvailable) {
            callMacAtMailApplies();
            PageReference pageRef = new PageReference('/apex/VF_crdNewSteppedCoPay?crdid=' + crd.id);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } else {
            if (crd.Any_drug_specific_Specialty_copays__c || crd.Any_drug_specific_Mail_copays__c || crd.Any_drug_specific_Paper_copays__c || crd.Any_drug_specific_Retail_copays__c || crd.Any_drug_specific_Specialty_OON_copays__c || crd.Any_drug_specific_Paper_Out_of_Network__c) {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDrugSpecificCoPay?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            } else if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c ||crd.Any_DAW_specific_Paper_OON_copays__c) {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            } else {
                callMacAtMailApplies();
                PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;

            }

        }   
}

//Method to save the Tier information from  user screen takes the list of Tier along with recordType name- Alternate function for Next Button Story
    public void saveWrappedList1(List < Copay_Tier__c > wrappedList, String recordTypeName) {
        list < Copay_Tier__c > lstCopay = new list < Copay_Tier__c > ();
        list < Copay_Tier__c > lstCopay2Update = new list < Copay_Tier__c > ();

        recordTypeId = getRecordType(recordTypeName);
        for (Copay_Tier__c ct: wrappedList) {
            
            if (ct.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
                          
        }

    }
    
/*Method to update the Tier information from  user screen takes the list of Tier along with recordType name : Alternate function for Next button story*/
    /* Trigger deletes the redundant record after this function call */
    public void updateWrappedList1(List < Copay_Tier__c > wrappedList, String recordTypeName) {
        recordTypeId = getRecordType(recordTypeName);
        for (Copay_Tier__c ct: wrappedList) {
            if (ct.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            
        }
        
    }   

}