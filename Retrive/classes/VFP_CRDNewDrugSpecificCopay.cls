/*Purpose: Apex Class for VFP_CRDNewDrugSpecificCopay Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 08/29/2011       Apex Class for VFP_CRDNewDrugSpecificCopay Page.
======================================================================== 
*/
public with sharing class VFP_CRDNewDrugSpecificCopay {
    public CRD__c crd {
        get;
        set;
    }
    public list < Drug_Specific_Copay__c > lstDrugSpecificCopay {
        get;
        set;
    }
    public boolean isSteppedAvailable = false;
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapRetailItems {
        get;
        set;
    }
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapMailItems {
        get;
        set;
    }
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapSpecialityItems {
        get;
        set;
    }
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapPaperItems {
        get;
        set;
    }
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapOutOfNetworkItems {
        get;
        set;
    }
    public list < DrugSpecificCopayWrapper > lstDrugSpecificCopayWrapSpecialtyOONItems {
        get;
        set;
    }

    integer existingDrugSpecificCopayCount = 0;
    public string groupMember{get;set;}    //Added for next button story
    public String editMode{get;set;}    //Added for next button story

    public Drug_Specific_Copay__c drugSpecificCopay {
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

    /*Constructor of the class*/
    public VFP_CRDNewDrugSpecificCopay(ApexPages.StandardController stdController) {
        errorMessages = new list < String > ();
        editMode=System.currentPagereference().getParameters().get('p1');  //Added for next button story
        groupMember=System.currentPagereference().getParameters().get('p2');    //Added for next button story
        lstDrugSpecificCopayWrapRetailItems = new list < DrugSpecificCopayWrapper > ();
        lstDrugSpecificCopayWrapMailItems = new list < DrugSpecificCopayWrapper > ();
        lstDrugSpecificCopayWrapSpecialityItems = new list < DrugSpecificCopayWrapper > ();
        lstDrugSpecificCopayWrapPaperItems = new list < DrugSpecificCopayWrapper > ();
        lstDrugSpecificCopayWrapOutOfNetworkItems = new list < DrugSpecificCopayWrapper > ();
        lstDrugSpecificCopayWrapSpecialtyOONItems = new list < DrugSpecificCopayWrapper > ();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ([Select Stepped_Copay__c,TierName__c,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc), Minimum_Dollar__c, Maximum_Dollar__c, TierNo__c, Reverse_Copay__c, RecordTypeId, RecordType.Name, Percent__c, Name, Id, Drug_List__c, Drug_Group__c,Drug_List__r.Name,Drug_Group__r.Name, Dollar_Amount__c, Copay_Calculation__c, CRD_ID__c, M__c, N__c, O__c, Y__c From Drug_Specific_Copay__c where CRD_ID__c = : crdId]);
        this.crd = [select id, Y_Schd__c, Any_DAW_specific_Paper_OON_copays__c, Any_drug_specific_Paper_Out_of_Network__c, name, Integrate_with_Medical__c, SteppedCopayCount__c, Insured_Type__c, Durg_Specific_Stepped_Count__c, Drug_Specific_copay_count__c, Any_drug_specific_Specialty_copays__c, Any_drug_specific_Mail_copays__c, Any_drug_specific_Paper_copays__c, Any_drug_specific_Retail_copays__c, Plan_Type_Paper__c, Any_DAW_specific_Retail_copays__c, Any_DAW_specific_Specialty_copays__c, Any_DAW_specific_Paper_copays__c, Any_DAW_specific_Mail_copays__c,
                    Any_DAW_specific_Specialty_OON_copays__c,Any_drug_specific_Specialty_OON_copays__c,Apply_Penalty_to_Specialty_OON__c,Brands_w_DAW_5_take_a_generic_copay_spec__c,Different_Copays_from_Specialty__c,Is_there_Specialty_Out_of_Network__c,Penalty_Amount_Specialty_OON__c,Penalty_Type_Specialty_OON__c,Percentage_Applied_Specialty_OON__c,Plan_Type_Specialty_OON__c,Specialty_OON_Number_of_Tiers__c from CRD__c where id = : crdId];


        for (Drug_Specific_Copay__c drugSpecificItem: lstDrugSpecificCopay) {
            if (drugSpecificItem.RecordType.Name == 'Retail') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapRetailItems.add(wrap);
            }
            if (drugSpecificItem.RecordType.Name == 'Mail') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapMailItems.add(wrap);
            }

            if (drugSpecificItem.RecordType.Name == 'Specialty') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapSpecialityItems.add(wrap);
            }

            if (drugSpecificItem.RecordType.Name == 'Paper') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapPaperItems.add(wrap);
            }

            if (drugSpecificItem.RecordType.Name == 'Paper Out of Network') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapOutOfNetworkItems.add(wrap);
            }
            if (drugSpecificItem.RecordType.Name == 'Specialty OON') {
                DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
                wrap.drugSpecificCopayItem = drugSpecificItem;
                lstDrugSpecificCopayWrapSpecialtyOONItems.add(wrap);
            }

        }

        //We save the size of existing items so that we can fire update or insert operation accordingly
        existingDrugSpecificCopayCount = lstDrugSpecificCopay.size();

    }

    /*Method to populate exisitng items*/
    public void populateExistingItems() {

    }


    /*Method to add retail wrap items */
    public PageReference AddNewDrugSpecificRetailItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Retail');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapRetailItems.add(wrap);
        return null;
    }

    /*Method to add retail wrap items */
    public PageReference AddNewDrugSpecificOutOfNetworkItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Retail');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapOutOfNetworkItems.add(wrap);
        return null;
    }
    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedROutOfNetworkItems() {
        if (lstDrugSpecificCopayWrapOutOfNetworkItems != null && lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapOutOfNetworkItems.size(); i++) {
                if (lstDrugSpecificCopayWrapOutOfNetworkItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapOutOfNetworkItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapOutOfNetworkItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapOutOfNetworkItems[i]);
                    lstDrugSpecificCopayWrapOutOfNetworkItems.remove(i);

                }
            }
            if (tempList.size() > 0) {
                deleteSelectedROutOfNetworkItems();
            }
            tempList.clear();

        }
        return null;
    }


    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedRetailItems() {
        if (lstDrugSpecificCopayWrapRetailItems != null && lstDrugSpecificCopayWrapRetailItems.size() > 0) {
            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapRetailItems.size(); i++) {
                if (lstDrugSpecificCopayWrapRetailItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapRetailItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapRetailItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapRetailItems[i]);
                    lstDrugSpecificCopayWrapRetailItems.remove(i);

                }
            }
            if (tempList.size() > 0) {
                deleteSelectedRetailItems();
            }
            tempList.clear();

        }
        return null;
    }

    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedMailItems() {
        if (lstDrugSpecificCopayWrapMailItems != null && lstDrugSpecificCopayWrapMailItems.size() > 0) {

            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapMailItems.size(); i++) {
                if (lstDrugSpecificCopayWrapMailItems[i].isMarkedForDeletion == true) {

                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapMailItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapMailItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapMailItems[i]);
                    lstDrugSpecificCopayWrapMailItems.remove(i);

                }
            }
            if (tempList != null && tempList.size() > 0) {
                deleteSelectedMailItems();
            }
            tempList.clear();

        }
        return null;
    }

    /*Method to add mail wrap items */
    public PageReference AddNewDrugSpecificMailItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Mail');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapMailItems.add(wrap);
        return null;
    }



    /*Method to add Speciality wrap items */
    public PageReference AddNewDrugSpecificSpecialityItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Specialty');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapSpecialityItems.add(wrap);
        return null;
    }

    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedSpecialityItems() {
        if (lstDrugSpecificCopayWrapSpecialityItems != null && lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapSpecialityItems.size(); i++) {
                if (lstDrugSpecificCopayWrapSpecialityItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapSpecialityItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapSpecialityItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapSpecialityItems[i]);
                    lstDrugSpecificCopayWrapSpecialityItems.remove(i);

                }
            }
            if (tempList != null && tempList.size() > 0) {
                deleteSelectedSpecialityItems();
            }
            tempList.clear();

        }
        return null;
    }

    /*Method to add paper wrap items */
    public PageReference AddNewDrugSpecificPaperItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Paper');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapPaperItems.add(wrap);
        return null;
    }

    /*Method to remove the selected rows from the  panel*/
    public PageReference deleteSelectedPaperItems() {

        if (lstDrugSpecificCopayWrapPaperItems != null && lstDrugSpecificCopayWrapPaperItems.size() > 0) {
            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapPaperItems.size(); i++) {
                if (lstDrugSpecificCopayWrapPaperItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapPaperItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapPaperItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapPaperItems[i]);
                    lstDrugSpecificCopayWrapPaperItems.remove(i);

                }
            }
            if (tempList != null && tempList.size() > 0) {
                deleteSelectedPaperItems();
            }
            tempList.clear();
        }
        return null;
    }
    //Added by Amit Jain for Request 4366
    /*Method to add Specialty OON wrap items */
    public PageReference AddNewDrugSpecificSpecialtyOutOfNetworkItem() {
        DrugSpecificCopayWrapper wrap = new DrugSpecificCopayWrapper();
        wrap.drugSpecificCopayItem.recordTypeId = getRecordType('Specialty OON');
        wrap.drugSpecificCopayItem.M__c = true;
        wrap.drugSpecificCopayItem.N__c = true;
        wrap.drugSpecificCopayItem.O__c = true;
        wrap.drugSpecificCopayItem.Y__c = true;
        lstDrugSpecificCopayWrapSpecialtyOONItems.add(wrap);
        return null;
    }
     /*Method to remove the selected rows from the  panel*/
     public PageReference deleteSelectedSpecialtyOutOfNetworkItems() {
        if (lstDrugSpecificCopayWrapSpecialtyOONItems != null && lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            list < DrugSpecificCopayWrapper > tempList = new list < DrugSpecificCopayWrapper > ();
            for (integer i = 0; i < lstDrugSpecificCopayWrapSpecialtyOONItems.size(); i++) {
                if (lstDrugSpecificCopayWrapSpecialtyOONItems[i].isMarkedForDeletion == true) {
                    //Added by abhay on 12th jan
                    Drug_Specific_Copay__c drugSpecificItemToDelete = new Drug_Specific_Copay__c();
                    if (lstDrugSpecificCopayWrapSpecialtyOONItems[i].drugSpecificCopayItem.id != null) {
                        drugSpecificItemToDelete = [select id from Drug_Specific_Copay__c where id = : lstDrugSpecificCopayWrapSpecialtyOONItems[i].drugSpecificCopayItem.id];
                        delete drugSpecificItemToDelete;
                    }
                    // changes of 12th jan 12 ends
                    tempList.add(lstDrugSpecificCopayWrapSpecialtyOONItems[i]);
                    lstDrugSpecificCopayWrapSpecialtyOONItems.remove(i);

                }
            }
            if (tempList.size() > 0) {
                deleteSelectedROutOfNetworkItems();
            }
            tempList.clear();

        }
        return null;
    }
    //Added by Amit Jain ends
    /*method for saving theDrug Specific Copay  */
    public PageReference Save() {
        integer currentDrugSpecificCopayCount = 0;
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapRetailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapMailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialityItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapPaperItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapOutOfNetworkItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialtyOONItems.size();

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;

        /*validating the Copay Items before save*/
        if (lstDrugSpecificCopayWrapPaperItems != null && lstDrugSpecificCopayWrapPaperItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapPaperItems);

            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapRetailItems != null && lstDrugSpecificCopayWrapRetailItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapRetailItems);
            system.debug('##############retail############' + isValid);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (lstDrugSpecificCopayWrapMailItems != null && lstDrugSpecificCopayWrapMailItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapMailItems);
            system.debug('##############mail############' + isValid);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (lstDrugSpecificCopayWrapSpecialityItems != null && lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapSpecialityItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapOutOfNetworkItems != null && lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapOutOfNetworkItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapSpecialtyOONItems != null && lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapSpecialtyOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentDrugSpecificCopayCount != existingDrugSpecificCopayCount) {
                if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
                    // delete lstDrugSpecificCopay;
                    // lstDrugSpecificCopay.clear();
                }

                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }


            } else {
                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }
            }

        } catch (exception e) {
            // roll everything back in case of error
            throw e;
            Database.rollback(sp);
        }
        update crd;
        if (isSteppedAvailable) {
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugSpecificSteppedCoPay?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        } else {
            if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c) {
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
                pageRef.getParameters().put('p1',editMode);
                pageRef.getParameters().put('p2',groupMember);
                return pageRef;

            }

            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
    }

    /*Method to redirect user to the next page when user is not on public group */
    public PageReference previousStep2() {
        if (crd.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference('/apex/VF_crdNewSteppedCoPay?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference('/apex/VF_CRDNewCoPay?id=' + crdId);
        pageRef.getParameters().put('p1',editMode);
        pageRef.getParameters().put('p2',groupMember);
        return pageRef;

    }
    
    /*Method to save the data saved by the user and redirect user to the next page*/
    public PageReference previousStep() {
        integer currentDrugSpecificCopayCount = 0;
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapRetailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapMailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialityItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapPaperItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapOutOfNetworkItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialtyOONItems.size();

        GC_Validation_Methods validationMethods = new GC_Validation_Methods();
        boolean isValid;

        /*validating the Copay Items before save*/
        if (lstDrugSpecificCopayWrapPaperItems != null && lstDrugSpecificCopayWrapPaperItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapPaperItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapRetailItems != null && lstDrugSpecificCopayWrapRetailItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapRetailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (lstDrugSpecificCopayWrapMailItems != null && lstDrugSpecificCopayWrapMailItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapMailItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        if (lstDrugSpecificCopayWrapSpecialityItems != null && lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapSpecialityItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapOutOfNetworkItems != null && lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapOutOfNetworkItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }
        if (lstDrugSpecificCopayWrapSpecialtyOONItems != null && lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
            isValid = validationMethods.validateDrugSpecificCopay(lstDrugSpecificCopayWrapSpecialtyOONItems);
            if (!isValid) {
                errorMessages.clear();
                errorMessages.addAll(validationMethods.errorMessages);
                return null;
            }
        }

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentDrugSpecificCopayCount != existingDrugSpecificCopayCount) {
                if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
                    delete lstDrugSpecificCopay;
                    lstDrugSpecificCopay.clear();
                }

                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }

            } else {
                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }
            }

        } catch (exception e) {
            // roll everything back in case of error
            throw e;
            Database.rollback(sp);
        }
        update crd;


        if (crd.SteppedCopayCount__c > 0) {
            PageReference pageRef = new PageReference('/apex/VF_crdNewSteppedCoPay?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
        PageReference pageRef = new PageReference('/apex/VF_CRDNewCoPay?id=' + crdId);
        pageRef.getParameters().put('p1',editMode);
        pageRef.getParameters().put('p2',groupMember);
        return pageRef;

    }

    /*Method to save the information from  user screen takes the list of Drug Specific Copay along with recordType name*/
    public void saveWrappedList(List < DrugSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ();
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay2Update = new list < Drug_Specific_Copay__c > ();
        for (DrugSpecificCopayWrapper wrap: wrappedList) {
            Drug_Specific_Copay__c drugSpecificItem;

            if (wrap.drugSpecificCopayItem.id != null) {
                drugSpecificItem = new Drug_Specific_Copay__c(id = wrap.drugSpecificCopayItem.id);
            } else {
                drugSpecificItem = new Drug_Specific_Copay__c();
            }

            drugSpecificItem.Drug_Group__c = wrap.drugSpecificCopayItem.Drug_Group__c;
            drugSpecificItem.Drug_List__c = wrap.drugSpecificCopayItem.Drug_List__c;
            drugSpecificItem.Stepped_Copay__c = wrap.drugSpecificCopayItem.Stepped_Copay__c;
            if (drugSpecificItem.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.Dollar_Amount__c = wrap.drugSpecificCopayItem.Dollar_Amount__c;
            drugSpecificItem.Percent__c = wrap.drugSpecificCopayItem.Percent__c;
            drugSpecificItem.Copay_Calculation__c = wrap.drugSpecificCopayItem.Copay_Calculation__c;
            drugSpecificItem.Reverse_Copay__c = wrap.drugSpecificCopayItem.Reverse_Copay__c;

            drugSpecificItem.Maximum_Dollar__c = wrap.drugSpecificCopayItem.Maximum_Dollar__c;
            drugSpecificItem.Minimum_Dollar__c = wrap.drugSpecificCopayItem.Minimum_Dollar__c;

            drugSpecificItem.RecordTypeId = recordTypeId;
            drugSpecificItem.M__c = wrap.drugSpecificCopayItem.M__c;
            drugSpecificItem.N__c = wrap.drugSpecificCopayItem.N__c;
            drugSpecificItem.O__c = wrap.drugSpecificCopayItem.O__c;
            drugSpecificItem.Y__c = wrap.drugSpecificCopayItem.Y__c;


            if (wrap.drugSpecificCopayItem.id != null) {
                //drugSpecificItem.CRD_ID__c=crdId;
                lstDrugSpecificCopay2Update.add(drugSpecificItem);
            } else {
                drugSpecificItem.CRD_ID__c = crdId;
                lstDrugSpecificCopay.add(drugSpecificItem);
            }

        }

        if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay.size(); i++) {
                lstDrugSpecificCopay[i].TierNo__c = i;
            }
            insert lstDrugSpecificCopay;
        }

        if (lstDrugSpecificCopay2Update != null && lstDrugSpecificCopay2Update.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay2Update.size(); i++) {
                lstDrugSpecificCopay2Update[i].TierNo__c = i;
            }
            update lstDrugSpecificCopay2Update;
        }
    }

    /*Method to update the data of the copays if  user has just update the copay and have not added any new copays*/
    public void updateWrappedList(List < DrugSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ();
        for (DrugSpecificCopayWrapper wrap: wrappedList) {
            Drug_Specific_Copay__c drugSpecificItem = new Drug_Specific_Copay__c(id = wrap.drugSpecificCopayItem.id);
            drugSpecificItem = wrap.drugSpecificCopayItem;
            if (wrap.drugSpecificCopayItem.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.RecordTypeId = recordTypeId;
            lstDrugSpecificCopay.add(drugSpecificItem);
        }
        if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay.size(); i++) {
                lstDrugSpecificCopay[i].TierNo__c = i;
            }
            upsert lstDrugSpecificCopay;
        }
    }

    /*Method to get the record type Name from schema describe information */
    public String getRecordTypeNameByid(id recordTypeid) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Drug_Specific_Copay__c;
        Map < Id, Schema.RecordTypeInfo > rtMapById = d.getRecordTypeInfosById();
        String strRecordTypename = rtMapById.get(recordTypeid).getName();
        return strRecordTypename;
    }
    /*Method to get the record type id from schema describe information */
    public Id getRecordType(String recordTypeName) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Drug_Specific_Copay__c;
        Map < String, Schema.RecordTypeInfo > rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordTypeName);
        return rtByName.getRecordTypeId();
    }

    /*Wrapper Class To Create dynamic inputs*/
    public class DrugSpecificCopayWrapper {
        public Drug_Specific_Copay__c drugSpecificCopayItem {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
        public DrugSpecificCopayWrapper() {
            Drug_Specific_Copay__c item = new Drug_Specific_Copay__c();
            drugSpecificCopayItem = item;
            isMarkedForDeletion = false;
        }

    }
/* New Method for implemeting the next button story */
    public PageReference Save1() {
        
        /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
        /*Start*/
        integer currentDrugSpecificCopayCount = 0;
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapRetailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapMailItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialityItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapPaperItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapOutOfNetworkItems.size();
        currentDrugSpecificCopayCount += lstDrugSpecificCopayWrapSpecialtyOONItems.size();
        Savepoint sp = Database.setSavepoint();
        try {
            if (currentDrugSpecificCopayCount != existingDrugSpecificCopayCount) {
                if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
                    // delete lstDrugSpecificCopay;
                    // lstDrugSpecificCopay.clear();
                }

                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    saveWrappedList1(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }


            } else {
                if (lstDrugSpecificCopayWrapRetailItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapRetailItems, 'Retail');
                }
                if (lstDrugSpecificCopayWrapMailItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapMailItems, 'Mail');
                }
                if (lstDrugSpecificCopayWrapSpecialityItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapSpecialityItems, 'Specialty');
                }
                if (lstDrugSpecificCopayWrapPaperItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapPaperItems, 'Paper');
                }
                if (lstDrugSpecificCopayWrapOutOfNetworkItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapOutOfNetworkItems, 'Paper Out of Network');
                }
                if (lstDrugSpecificCopayWrapSpecialtyOONItems.size() > 0) {
                    updateWrappedList1(lstDrugSpecificCopayWrapSpecialtyOONItems, 'Specialty OON');
                }
            }

        } catch (exception e) {
            // roll everything back in case of error
            throw e;
            Database.rollback(sp);
        }
        /*End*/
        if (isSteppedAvailable) {
            PageReference pageRef = new PageReference('/apex/VF_CRDDrugSpecificSteppedCoPay?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        } else {
            if (crd.Any_DAW_specific_Retail_copays__c || crd.Any_DAW_specific_Mail_copays__c || crd.Any_DAW_specific_Paper_copays__c || crd.Any_DAW_specific_Specialty_copays__c || crd.Any_DAW_specific_Paper_OON_copays__c || crd.Any_DAW_specific_Specialty_OON_copays__c) {
                PageReference pageRef = new PageReference('/apex/VF_CRDNewDAWSpecificCopay?crdid=' + crd.Id);
                pageRef.getParameters().put('p1',editMode);
                pageRef.getParameters().put('p2',groupMember);
                return pageRef;

            }

            PageReference pageRef = new PageReference('/apex/VF_CRDDrugCoverageStep2?crdid=' + crdId);
            pageRef.getParameters().put('p1',editMode);
            pageRef.getParameters().put('p2',groupMember);
            return pageRef;
        }
    }
    
    /*Method to update the data of the copays if  user has just update the copay and have not added any new copays*/
    /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
    public void updateWrappedList1(List < DrugSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ();
        for (DrugSpecificCopayWrapper wrap: wrappedList) {
            Drug_Specific_Copay__c drugSpecificItem = new Drug_Specific_Copay__c(id = wrap.drugSpecificCopayItem.id);
            drugSpecificItem = wrap.drugSpecificCopayItem;
            if (wrap.drugSpecificCopayItem.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.RecordTypeId = recordTypeId;
            lstDrugSpecificCopay.add(drugSpecificItem);
        }
        if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay.size(); i++) {
                lstDrugSpecificCopay[i].TierNo__c = i;
            }
            //upsert lstDrugSpecificCopay;
        }
    }
    
    /*Method to save the information from  user screen takes the list of Drug Specific Copay along with recordType name*/
    /*Added by Shubham for Read only Mode -as per ST1177(Request - 06496)*/
    public void saveWrappedList1(List < DrugSpecificCopayWrapper > wrappedList, String recordTypeName) {

        id recordTypeId;
        recordTypeId = getRecordType(recordTypeName);
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay = new list < Drug_Specific_Copay__c > ();
        list < Drug_Specific_Copay__c > lstDrugSpecificCopay2Update = new list < Drug_Specific_Copay__c > ();
        for (DrugSpecificCopayWrapper wrap: wrappedList) {
            Drug_Specific_Copay__c drugSpecificItem;

            if (wrap.drugSpecificCopayItem.id != null) {
                drugSpecificItem = new Drug_Specific_Copay__c(id = wrap.drugSpecificCopayItem.id);
            } else {
                drugSpecificItem = new Drug_Specific_Copay__c();
            }

            drugSpecificItem.Drug_Group__c = wrap.drugSpecificCopayItem.Drug_Group__c;
            drugSpecificItem.Drug_List__c = wrap.drugSpecificCopayItem.Drug_List__c;
            drugSpecificItem.Stepped_Copay__c = wrap.drugSpecificCopayItem.Stepped_Copay__c;
            if (drugSpecificItem.Stepped_Copay__c) {
                isSteppedAvailable = true;
            }
            drugSpecificItem.Dollar_Amount__c = wrap.drugSpecificCopayItem.Dollar_Amount__c;
            drugSpecificItem.Percent__c = wrap.drugSpecificCopayItem.Percent__c;
            drugSpecificItem.Copay_Calculation__c = wrap.drugSpecificCopayItem.Copay_Calculation__c;
            drugSpecificItem.Reverse_Copay__c = wrap.drugSpecificCopayItem.Reverse_Copay__c;

            drugSpecificItem.Maximum_Dollar__c = wrap.drugSpecificCopayItem.Maximum_Dollar__c;
            drugSpecificItem.Minimum_Dollar__c = wrap.drugSpecificCopayItem.Minimum_Dollar__c;

            drugSpecificItem.RecordTypeId = recordTypeId;
            drugSpecificItem.M__c = wrap.drugSpecificCopayItem.M__c;
            drugSpecificItem.N__c = wrap.drugSpecificCopayItem.N__c;
            drugSpecificItem.O__c = wrap.drugSpecificCopayItem.O__c;
            drugSpecificItem.Y__c = wrap.drugSpecificCopayItem.Y__c;


            if (wrap.drugSpecificCopayItem.id != null) {
                //drugSpecificItem.CRD_ID__c=crdId;
                lstDrugSpecificCopay2Update.add(drugSpecificItem);
            } else {
                drugSpecificItem.CRD_ID__c = crdId;
                lstDrugSpecificCopay.add(drugSpecificItem);
            }

        }

        if (lstDrugSpecificCopay != null && lstDrugSpecificCopay.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay.size(); i++) {
                lstDrugSpecificCopay[i].TierNo__c = i;
            }
            //insert lstDrugSpecificCopay;
        }

        if (lstDrugSpecificCopay2Update != null && lstDrugSpecificCopay2Update.size() > 0) {
            for (integer i = 0; i < lstDrugSpecificCopay2Update.size(); i++) {
                lstDrugSpecificCopay2Update[i].TierNo__c = i;
            }
            //update lstDrugSpecificCopay2Update;
        }
    }

}