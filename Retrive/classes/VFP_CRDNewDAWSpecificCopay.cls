/*Purpose: Apex Class for DAW Specific Copay Screen on CRD Wizard.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Sourabh                01/09/2012       Apex Class for DAW Specific Copay Screen on CRD Wizard.
======================================================================== */

public with sharing class VFP_CRDNewDAWSpecificCopay {

    public CRD__c crd {
        get;
        set;
    }
    public list < DAW_Specific_Copay__c > lstDAWSpecificCopay {
        get;
        set;
    }
    public boolean isSteppedAvailable = false;
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';   
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING PAPER = 'Paper';
    PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
    PRIVATE STATIC FINAL STRING SPECIALITY = 'Specialty';
    PRIVATE STATIC FINAL STRING PAPEROON = 'Paper Out of Network';
    PRIVATE STATIC FINAL STRING SPECIALITYOON = 'Specialty OON';
    PRIVATE STATIC FINAL STRING CRDNEWSTEPPEDCOPAYURL = '/apex/VF_crdNewSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING DRUGCOPAYURL = '/apex/VF_CRDNewDrugSpecificCoPay?crdid=';
    PRIVATE STATIC FINAL STRING CRDDRUGSPSTEPPEDCOPAYURL='/apex/VF_CRDDrugSpecificSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING COPAYURL ='/apex/VF_CRDNewCoPay?id='; 
    PRIVATE STATIC FINAL STRING CRDDAWSPSTEPPEDCOPAY = '/apex/VF_CRDDAWSpecificSteppedCoPay?crdid=';
    PRIVATE STATIC FINAL STRING DCURL = '/apex/VF_CRDDrugCoverageStep2?crdid=';
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapRetailItems {
        get;
        set;
    }
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapMailItems {
        get;
        set;
    }
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapSpecialityItems {
        get;
        set;
    }
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapPaperItems {
        get;
        set;
    }
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapOONItems {
        get;
        set;
    }
    public list < DAWSpecificCopayWrapper > lstDAWSpecificCopayWrapSpecialtyOONItems {
        get;
        set;
    }

    integer existingdawSpecificCopayCount = 0;

    public DAW_Specific_Copay__c dawSpecificCopay {
        get;
        set;
    }
    public String crdId {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }

    public VFP_CRDNewdawSpecificCopay(ApexPages.StandardController stdController) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        errorMessages = new list < String > ();
        lstdawSpecificCopayWrapRetailItems = new list < dawSpecificCopayWrapper > ();
        lstdawSpecificCopayWrapMailItems = new list < dawSpecificCopayWrapper > ();
        lstdawSpecificCopayWrapSpecialityItems = new list < dawSpecificCopayWrapper > ();
        lstdawSpecificCopayWrapPaperItems = new list < dawSpecificCopayWrapper > ();
        lstDAWSpecificCopayWrapOONItems = new list < dawSpecificCopayWrapper > ();
        lstDAWSpecificCopayWrapSpecialtyOONItems = new list < dawSpecificCopayWrapper > ();

        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        lstdawSpecificCopay = new list < DAW_Specific_Copay__c > ([SELECT Copay_Calculation__c, CRD_ID__c, DAW_Code__c, Dollar_Amount__c, Id, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Name, Percent__c, RecordTypeId, RecordType.Name, Reverse__c, Stepped__c FROM DAW_Specific_Copay__c where CRD_ID__c = : crdId LIMIT 100000]);
        this.crd = [select id, Y_Schd__c, Any_drug_specific_Paper_Out_of_Network__c, Any_DAW_specific_Paper_OON_copays__c, Durg_Specific_Stepped_Count__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, name, Integrate_with_Medical__c, Insured_Type__c, SteppedCopayCount__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Mail_copays__c, Plan_Type_Paper__c,
                    Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c from CRD__c where id = : crdId LIMIT 100000];

        for (DAW_Specific_Copay__c dawSpecificItem: lstdawSpecificCopay) {
            if (RETAIL.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstdawSpecificCopayWrapRetailItems.add(wrap);
            }
            if (MAIL.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstdawSpecificCopayWrapMailItems.add(wrap);
            }

            if (SPECIALITY.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstdawSpecificCopayWrapSpecialityItems.add(wrap);
            }

            if (PAPER.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstdawSpecificCopayWrapPaperItems.add(wrap);
            }
            if (PAPEROON.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstDAWSpecificCopayWrapOONItems.add(wrap);
            }
            if (SPECIALITYOON.equalsIgnoreCase(dawSpecificItem.RecordType.Name)) {
                dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
                wrap.dawSpecificCopayItem = dawSpecificItem;
                lstDAWSpecificCopayWrapSpecialtyOONItems.add(wrap);
            }


        }
        //We save the size of existing items so that we can fire update or insert operation accordingly
        existingdawSpecificCopayCount = lstdawSpecificCopay.size();
    }

    /*Method to populate exisitng items*/
    public void populateExistingItems() {

    }

    /*Method to add retail wrap items */
    public PageReference AddNewDAWSpecificRetailItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(RETAIL);
        lstdawSpecificCopayWrapRetailItems.add(wrap);
        return null;
    }

    /*Method to add retail wrap items */
    public PageReference AddNewDAWSpecificOONItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(PAPEROON);
        lstDAWSpecificCopayWrapOONItems.add(wrap);
        return null;
    }
    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedOONItems() {
        if (lstDAWSpecificCopayWrapOONItems != null && lstDAWSpecificCopayWrapOONItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDAWSpecificCopayWrapOONItems.size(); i++) {
                if (lstDAWSpecificCopayWrapOONItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstDAWSpecificCopayWrapOONItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstDAWSpecificCopayWrapOONItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends              
                    tempList.add(lstDAWSpecificCopayWrapOONItems[i]);
                    lstDAWSpecificCopayWrapOONItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedRetailItems();
            }
            tempList.clear();
        }
        return null;
    }
    //Added by Amit Jain for request 4366
    /*Method to add retail wrap items */
    public PageReference AddNewDAWSpecificSpecialtyOONItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(SPECIALITYOON);
        lstDAWSpecificCopayWrapSpecialtyOONItems.add(wrap);
        return null;
    }
    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedSpecialtyOONItems() {
        if (lstDAWSpecificCopayWrapSpecialtyOONItems != null && lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDAWSpecificCopayWrapSpecialtyOONItems.size(); i++) {
                if (lstDAWSpecificCopayWrapSpecialtyOONItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstDAWSpecificCopayWrapSpecialtyOONItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstDAWSpecificCopayWrapSpecialtyOONItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends              
                    tempList.add(lstDAWSpecificCopayWrapSpecialtyOONItems[i]);
                    lstDAWSpecificCopayWrapSpecialtyOONItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedRetailItems();
            }
            tempList.clear();
        }
        return null;
    }
    //ends
    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedRetailItems() {
        if (lstdawSpecificCopayWrapRetailItems != null && lstdawSpecificCopayWrapRetailItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstdawSpecificCopayWrapRetailItems.size(); i++) {
                if (lstdawSpecificCopayWrapRetailItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstdawSpecificCopayWrapRetailItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstdawSpecificCopayWrapRetailItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends              
                    tempList.add(lstdawSpecificCopayWrapRetailItems[i]);
                    lstdawSpecificCopayWrapRetailItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedRetailItems();
            }
            tempList.clear();
        }
        return null;
    }

    /*Method to add mail wrap items */
    public PageReference AddNewDAWSpecificMailItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(MAIL);
        lstdawSpecificCopayWrapMailItems.add(wrap);
        return null;
    }

    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedMailItems() {
        if (lstdawSpecificCopayWrapMailItems != null && lstdawSpecificCopayWrapMailItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstdawSpecificCopayWrapMailItems.size(); i++) {
                if (lstdawSpecificCopayWrapMailItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstdawSpecificCopayWrapMailItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstdawSpecificCopayWrapMailItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends  
                    tempList.add(lstdawSpecificCopayWrapMailItems[i]);
                    lstdawSpecificCopayWrapMailItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedMailItems();
            }
            tempList.clear();
        }
        return null;
    }

    /*Method to add Speciality wrap items */
    public PageReference AddNewDAWSpecificSpecialityItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(SPECIALITY);
        lstdawSpecificCopayWrapSpecialityItems.add(wrap);
        return null;
    }

    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedSpecialityItems() {
        if (lstdawSpecificCopayWrapSpecialityItems != null && lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstdawSpecificCopayWrapSpecialityItems.size(); i++) {
                if (lstdawSpecificCopayWrapSpecialityItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstdawSpecificCopayWrapSpecialityItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstdawSpecificCopayWrapSpecialityItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends                  
                    tempList.add(lstdawSpecificCopayWrapSpecialityItems[i]);
                    lstdawSpecificCopayWrapSpecialityItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedSpecialityItems();
            }
            tempList.clear();
        }
        return null;
    }

    /*Method to add paper wrap items */
    public PageReference AddNewDAWSpecificPaperItem() {
        dawSpecificCopayWrapper wrap = new dawSpecificCopayWrapper();
        wrap.dawSpecificCopayItem.recordTypeId = getRecordType(PAPER);
        lstdawSpecificCopayWrapPaperItems.add(wrap);
        return null;
    }


    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedPaperItems() {
        if (lstdawSpecificCopayWrapPaperItems != null && lstdawSpecificCopayWrapPaperItems.size() > 0) {
            list < dawSpecificCopayWrapper > tempList = new list < dawSpecificCopayWrapper > ();
            for (integer i = 0; i < lstdawSpecificCopayWrapPaperItems.size(); i++) {
                if (lstdawSpecificCopayWrapPaperItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    DAW_Specific_Copay__c drugSpecificItemToDelete = new DAW_Specific_Copay__c();
                    if (lstdawSpecificCopayWrapPaperItems[i].dawSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from DAW_Specific_Copay__c where id = : lstdawSpecificCopayWrapPaperItems[i].dawSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends                      
                    tempList.add(lstdawSpecificCopayWrapPaperItems[i]);
                    lstdawSpecificCopayWrapPaperItems.remove(i);
                }
            }
            if (tempList.size() > 0) {
                deleteSelectedPaperItems();
            }
            tempList.clear();
        }
        return null;
    }

    /*method for saving theDrug Specific Copay  */
    public PageReference Save() {
        integer currentdawSpecificCopayCount = 0;
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapRetailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapMailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapSpecialityItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapPaperItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapOONItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapSpecialtyOONItems.size();
        
        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;

        /*validating the Copay Items before save*/
        if (lstdawSpecificCopayWrapPaperItems != null && lstdawSpecificCopayWrapPaperItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapPaperItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapRetailItems != null && lstdawSpecificCopayWrapRetailItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapRetailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapMailItems != null && lstdawSpecificCopayWrapMailItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapMailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapSpecialityItems != null && lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapSpecialityItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDAWSpecificCopayWrapOONItems != null && lstDAWSpecificCopayWrapOONItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstDAWSpecificCopayWrapOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDAWSpecificCopayWrapSpecialtyOONItems != null && lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstDAWSpecificCopayWrapSpecialtyOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentdawSpecificCopayCount != existingdawSpecificCopayCount) {
                if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
                    //   delete lstdawSpecificCopay;
                    //   lstdawSpecificCopay.clear();
                }
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    saveWrappedList(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            } else {
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    updateWrappedList(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            }
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
        }
        database.update(crd);
        if (isSteppedAvailable) {
            PageReference pageRef = new PageReference(CRDDAWSPSTEPPEDCOPAY + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference(DCURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

    /*method for next button for user who is not part of the public group */
    public PageReference Save2() {
        
        /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
        /*Start*/
        integer currentdawSpecificCopayCount = 0;
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapRetailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapMailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapSpecialityItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapPaperItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapOONItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapSpecialtyOONItems.size();
        
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentdawSpecificCopayCount != existingdawSpecificCopayCount) {
                if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
                    //   delete lstdawSpecificCopay;
                    //   lstdawSpecificCopay.clear();
                }
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList1(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList1(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList1(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList1(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    saveWrappedList1(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList1(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            } else {
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList1(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList1(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList1(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList1(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    updateWrappedList1(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList1(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            }
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
        }
        /*End*/
        if (isSteppedAvailable) {
            PageReference pageRef = new PageReference(CRDDAWSPSTEPPEDCOPAY + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference(DCURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

    public PageReference previousStep() {
        integer currentdawSpecificCopayCount = 0;
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapRetailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapMailItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapSpecialityItems.size();
        currentdawSpecificCopayCount += lstdawSpecificCopayWrapPaperItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapOONItems.size();
        currentdawSpecificCopayCount += lstDAWSpecificCopayWrapSpecialtyOONItems.size();

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;

        /*validating the Copay Items before save*/
        if (lstdawSpecificCopayWrapPaperItems != null && lstdawSpecificCopayWrapPaperItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapPaperItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapRetailItems != null && lstdawSpecificCopayWrapRetailItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapRetailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapMailItems != null && lstdawSpecificCopayWrapMailItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapMailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstdawSpecificCopayWrapSpecialityItems != null && lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstdawSpecificCopayWrapSpecialityItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDAWSpecificCopayWrapOONItems != null && lstDAWSpecificCopayWrapOONItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstDAWSpecificCopayWrapOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDAWSpecificCopayWrapSpecialtyOONItems != null && lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            isValid = validationMethods.validatedawSpecificCopay(lstDAWSpecificCopayWrapSpecialtyOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentdawSpecificCopayCount != existingdawSpecificCopayCount) {
                if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
                    //   delete lstdawSpecificCopay;
                    //   lstdawSpecificCopay.clear();
                }
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    saveWrappedList(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            } else {
                if (lstdawSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapRetailItems, RETAIL);
                }
                if (lstdawSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapMailItems, MAIL);
                }
                if (lstdawSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapSpecialityItems, SPECIALITY);
                }
                if (lstdawSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList(lstdawSpecificCopayWrapPaperItems, PAPER);
                }
                if (lstDAWSpecificCopayWrapOONItems.size() > 0) {
                    updateWrappedList(lstDAWSpecificCopayWrapOONItems, PAPEROON);
                }
                if (lstDAWSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList(lstDAWSpecificCopayWrapSpecialtyOONItems, SPECIALITYOON);
                }
            }
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
        }
        database.update(crd);

        if (CRD.Durg_Specific_Stepped_Count__c > 0) {
            PageReference pageRef = new PageReference(CRDDRUGSPSTEPPEDCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        if (CRD.Any_drug_specific_Specialty_copays__c || CRD.Any_drug_specific_Mail_copays__c || CRD.Any_drug_specific_Paper_copays__c || CRD.Any_drug_specific_Retail_copays__c || CRD.Any_drug_specific_Paper_Out_of_Network__c ||CRD.Any_drug_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference(DRUGCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;

        }
        if (crd.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference(CRDNEWSTEPPEDCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference(COPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;

    }
    
    /* Method for back button for users not in the public group */
    public PageReference previousStep2() {

        if (CRD.Durg_Specific_Stepped_Count__c > 0) {
            PageReference pageRef = new PageReference(CRDDRUGSPSTEPPEDCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        if (CRD.Any_drug_specific_Specialty_copays__c || CRD.Any_drug_specific_Mail_copays__c || CRD.Any_drug_specific_Paper_copays__c || CRD.Any_drug_specific_Retail_copays__c || CRD.Any_drug_specific_Paper_Out_of_Network__c ||CRD.Any_drug_specific_Specialty_OON_copays__c) {
            PageReference pageRef = new PageReference(DRUGCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;

        }
        if (crd.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference(CRDNEWSTEPPEDCOPAYURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference(COPAYURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;

    }

    /*Method to save the information from  user screen takes the list of Drug Specific Copay along with recordType name*/
    public void saveWrappedList(List < dawSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < DAW_Specific_Copay__c > lstdawSpecificCopay = new list < DAW_Specific_Copay__c > ();
        list < DAW_Specific_Copay__c > lstdawSpecificCopay2Update = new list < DAW_Specific_Copay__c > ();

        for (dawSpecificCopayWrapper wrap: wrappedList) {
            DAW_Specific_Copay__c dawSpecificItem;

            if (wrap.dawSpecificCopayItem.id != null) {
                dawSpecificItem = new DAW_Specific_Copay__c(id = wrap.dawSpecificCopayItem.id);
            } else {
                dawSpecificItem = new DAW_Specific_Copay__c();
            }

            //DAW_Specific_Copay__c dawSpecificItem=new DAW_Specific_Copay__c();
            dawSpecificItem.DAW_Code__c = wrap.dawSpecificCopayItem.DAW_Code__c;
            dawSpecificItem.MS_Code_M__c = wrap.dawSpecificCopayItem.MS_Code_M__c;
            dawSpecificItem.MS_Code_N__c = wrap.dawSpecificCopayItem.MS_Code_N__c;
            dawSpecificItem.MS_Code_O__c = wrap.dawSpecificCopayItem.MS_Code_O__c;
            dawSpecificItem.MS_Code_Y__c = wrap.dawSpecificCopayItem.MS_Code_Y__c;
            dawSpecificItem.Stepped__c = wrap.dawSpecificCopayItem.Stepped__c;
            if (dawSpecificItem.Stepped__c) {
                isSteppedAvailable = true;
            }
            dawSpecificItem.Dollar_Amount__c = wrap.dawSpecificCopayItem.Dollar_Amount__c;
            dawSpecificItem.Percent__c = wrap.dawSpecificCopayItem.Percent__c;
            dawSpecificItem.Copay_Calculation__c = wrap.dawSpecificCopayItem.Copay_Calculation__c;
            dawSpecificItem.Reverse__c = wrap.dawSpecificCopayItem.Reverse__c;
            dawSpecificItem.Maximum_Dollar__c = wrap.dawSpecificCopayItem.Maximum_Dollar__c;
            dawSpecificItem.Minimum_Dollar__c = wrap.dawSpecificCopayItem.Minimum_Dollar__c;
            dawSpecificItem.RecordTypeId = recordTypeId;
            //dawSpecificItem.CRD_ID__c=crdId;
            if (wrap.dawSpecificCopayItem.id != null) {
                //drugSpecificItem.CRD_ID__c=crdId;
                lstdawSpecificCopay2Update.add(dawSpecificItem);
            } else {
                dawSpecificItem.CRD_ID__c = crdId;
                lstdawSpecificCopay.add(dawSpecificItem);
            }
            // lstdawSpecificCopay.add(dawSpecificItem); 
        }
        if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstdawSpecificCopay.size(); i++) {
                //lstdawSpecificCopay[i].TierNo__c=i;
            }
            database.insert(lstdawSpecificCopay);
        }

        if (lstdawSpecificCopay2Update != null && lstdawSpecificCopay2Update.size() > 0) {
            //for(integer i=0;i<lstdawSpecificCopay2Update.size();i++){
            // lstdawSpecificCopay2Update[i].TierNo__c=i;
            //}   
            database.update(lstdawSpecificCopay2Update);
        }

    }

    public void updateWrappedList(List < dawSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < DAW_Specific_Copay__c > lstdawSpecificCopay = new list < DAW_Specific_Copay__c > ();
        for (dawSpecificCopayWrapper wrap: wrappedList) {
            DAW_Specific_Copay__c drugSpecificItem = new DAW_Specific_Copay__c(id = wrap.dawSpecificCopayItem.id);
            drugSpecificItem = wrap.dawSpecificCopayItem;
            if (wrap.dawSpecificCopayItem.Stepped__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.RecordTypeId = recordTypeId;
            lstdawSpecificCopay.add(drugSpecificItem);
        }
        if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
            /* for(integer i=0;i<lstdawSpecificCopay.size();i++){
              lstdawSpecificCopay[i].TierNo__c=i;
          }*/
            database.upsert(lstdawSpecificCopay);
        }
    }

    /*Method to get the record type Name from schema describe information */
    public String getRecordTypeNameByid(id recordTypeid) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.DAW_Specific_Copay__c;
        Map < Id, Schema.RecordTypeInfo > rtMapById = d.getRecordTypeInfosById();
        String strRecordTypename = rtMapById.get(recordTypeid).getName();
        return strRecordTypename;
    }
    /*Method to get the record type id from schema describe information */
    public Id getRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.DAW_Specific_Copay__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }
    /*Wrapper Class To Create dynamic inputs*/
    public class dawSpecificCopayWrapper {
        public DAW_Specific_Copay__c dawSpecificCopayItem {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
        public dawSpecificCopayWrapper() {
            DAW_Specific_Copay__c item = new DAW_Specific_Copay__c();
            dawSpecificCopayItem = item;
            isMarkedForDeletion = false;
        }

    }
    /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
    public void updateWrappedList1(List < dawSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < DAW_Specific_Copay__c > lstdawSpecificCopay = new list < DAW_Specific_Copay__c > ();
        for (dawSpecificCopayWrapper wrap: wrappedList) {
            DAW_Specific_Copay__c drugSpecificItem = new DAW_Specific_Copay__c(id = wrap.dawSpecificCopayItem.id);
            drugSpecificItem = wrap.dawSpecificCopayItem;
            if (wrap.dawSpecificCopayItem.Stepped__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.RecordTypeId = recordTypeId;
            lstdawSpecificCopay.add(drugSpecificItem);
        }
        if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
            /* for(integer i=0;i<lstdawSpecificCopay.size();i++){
              lstdawSpecificCopay[i].TierNo__c=i;
          }*/
            //database.upsert(lstdawSpecificCopay);
        }
    }
    /*Method to save the information from  user screen takes the list of Drug Specific Copay along with recordType name*/
    /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
    public void saveWrappedList1(List < dawSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < DAW_Specific_Copay__c > lstdawSpecificCopay = new list < DAW_Specific_Copay__c > ();
        list < DAW_Specific_Copay__c > lstdawSpecificCopay2Update = new list < DAW_Specific_Copay__c > ();

        for (dawSpecificCopayWrapper wrap: wrappedList) {
            DAW_Specific_Copay__c dawSpecificItem;

            if (wrap.dawSpecificCopayItem.id != null) {
                dawSpecificItem = new DAW_Specific_Copay__c(id = wrap.dawSpecificCopayItem.id);
            } else {
                dawSpecificItem = new DAW_Specific_Copay__c();
            }

            //DAW_Specific_Copay__c dawSpecificItem=new DAW_Specific_Copay__c();
            dawSpecificItem.DAW_Code__c = wrap.dawSpecificCopayItem.DAW_Code__c;
            dawSpecificItem.MS_Code_M__c = wrap.dawSpecificCopayItem.MS_Code_M__c;
            dawSpecificItem.MS_Code_N__c = wrap.dawSpecificCopayItem.MS_Code_N__c;
            dawSpecificItem.MS_Code_O__c = wrap.dawSpecificCopayItem.MS_Code_O__c;
            dawSpecificItem.MS_Code_Y__c = wrap.dawSpecificCopayItem.MS_Code_Y__c;
            dawSpecificItem.Stepped__c = wrap.dawSpecificCopayItem.Stepped__c;
            if (dawSpecificItem.Stepped__c) {
                isSteppedAvailable = true;
            }
            dawSpecificItem.Dollar_Amount__c = wrap.dawSpecificCopayItem.Dollar_Amount__c;
            dawSpecificItem.Percent__c = wrap.dawSpecificCopayItem.Percent__c;
            dawSpecificItem.Copay_Calculation__c = wrap.dawSpecificCopayItem.Copay_Calculation__c;
            dawSpecificItem.Reverse__c = wrap.dawSpecificCopayItem.Reverse__c;
            dawSpecificItem.Maximum_Dollar__c = wrap.dawSpecificCopayItem.Maximum_Dollar__c;
            dawSpecificItem.Minimum_Dollar__c = wrap.dawSpecificCopayItem.Minimum_Dollar__c;
            dawSpecificItem.RecordTypeId = recordTypeId;
            //dawSpecificItem.CRD_ID__c=crdId;
            if (wrap.dawSpecificCopayItem.id != null) {
                //drugSpecificItem.CRD_ID__c=crdId;
                lstdawSpecificCopay2Update.add(dawSpecificItem);
            } else {
                dawSpecificItem.CRD_ID__c = crdId;
                lstdawSpecificCopay.add(dawSpecificItem);
            }
            // lstdawSpecificCopay.add(dawSpecificItem); 
        }
        if (lstdawSpecificCopay != null && lstdawSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstdawSpecificCopay.size(); i++) {
                //lstdawSpecificCopay[i].TierNo__c=i;
            }
            //database.insert(lstdawSpecificCopay);
        }

        if (lstdawSpecificCopay2Update != null && lstdawSpecificCopay2Update.size() > 0) {
            //for(integer i=0;i<lstdawSpecificCopay2Update.size();i++){
            // lstdawSpecificCopay2Update[i].TierNo__c=i;
            //}   
            //database.update(lstdawSpecificCopay2Update);
        }

    }

}