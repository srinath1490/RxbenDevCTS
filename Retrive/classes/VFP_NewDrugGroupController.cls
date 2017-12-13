/*Purpose: Apex Class for VFP_NewDrugGroup Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 07/11/2011       Apex Class for VFP_NewDrugGroup Page.
======================================================================== 
*/

public with sharing class VFP_NewDrugGroupController {

    Public integer sequence {
        get;
        set;
    }
    public string groupListName {
        get;
        set;
    }
    public List < GroupWrapper > wrapperlist {
        get;
        set;
    }
    Public boolean messageFlag {
        get;
        set;
    }
    Public Drug_Group__c drugGroup {
        get;
        set;
    }
    Public List < Drug_List_Junction__c > insertList = new List < Drug_List_Junction__c > ();
    Map < Id, String > drugGroupMap = new Map < Id, String > ();


    public VFP_NewDrugGroupController(ApexPages.StandardController controller) {
        sequence = 1;
        drugGroup = new Drug_Group__c();
        wrapperlist = new List < GroupWrapper > ();
        sortList();
    }

    public List < SelectOption > getRecordType() {
        List < Schema.RecordTypeInfo > drugGroupRtInfo = Drug_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new Selectoption('', 'None'));
        for (Schema.RecordTypeInfo RtInfo: drugGroupRtInfo)
        if (RtInfo.Name != 'Master') {
            options.add(new Selectoption(RtInfo.getRecordTypeId(), RtInfo.Name));
            drugGroupMap.put(RtInfo.getRecordTypeId(), RtInfo.Name);
        }
        return options;
    }

    Public Pagereference CustomSave() {
        GC_Validation_Methods objValidationCls = new GC_Validation_Methods();
        //   Boolean isValid = true;
        Boolean ValidJunction = true;
        string recordTypeName = drugGroupMap.get(drugGroup.RecordTypeId);
        ValidJunction = objValidationCls.validateDrugListJunction(wrapperlist);
        //    isValid = objValidationCls.validateDrugGroup(wrapperlist,recordTypeName);
        if (ValidJunction) {
            database.insert(drugGroup);
            for (GroupWrapper druglistjunc: wrapperlist) {
                druglistjunc.JunctionWrapper.Parent_Drug_Group__c = drugGroup.Id;
                insertList.add(druglistjunc.JunctionWrapper);
            }
            if (insertList.size() > 0) {
                insert insertList;
            }
            Pagereference pageRef = new Pagereference('/' + drugGroup.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        /* else if(!isValid){ 
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00121);
                ApexPages.addMessage(myMsg);
               return null;  
           } */
        else if (!ValidJunction) {
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00122);
            ApexPages.addMessage(myMsg1);
            /*  ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.info,system.label.ERR00123);
                ApexPages.addMessage(myMsg2);   */
            return null;
        } else {
            return null;
        }
    }

    Public void AddMore() {
        sequence = sequence + 1;
        sortList();
    }

    Public Pagereference delRow() {
        Integer deletecount = 0;
        if (wrapperlist.size() > 0) {
            for (integer i = 0; i < wrapperlist.size(); i++) {
                if (wrapperlist[i].check == true) {
                    wrapperlist.remove(i);
                    deletecount = deletecount + 1;
                }
            }
        }
        if (deletecount == 0) messageFlag = true;
        return null;
    }

    Public void sortList() {
        GroupWrapper tempWrapper = new GroupWrapper();
        tempWrapper.check = false;
        tempWrapper.JunctionWrapper.Priority__c = sequence;
        wrapperlist.add(tempWrapper);
    }

    Public Pagereference redirectToSearch() {
        return Page.VF_DrugGroupSearch;
    }

    Public Class GroupWrapper {
        Public Drug_List_Junction__c JunctionWrapper {
            get;
            set;
        }
        Public boolean check {
            get;
            set;
        }
        Public GroupWrapper() {
            JunctionWrapper = new Drug_List_Junction__c();
        }
    }
}