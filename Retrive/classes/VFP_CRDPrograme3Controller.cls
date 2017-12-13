/*Purpose: Apex Class for VFP_CRDPrograme3 Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 09/21/2011       Apex Class for VFP_CRDPrograme3 Page.
     2.0     Amit                 8/23/2013        Modified for request 01125
     3.0     Toshi                11/09/2016
======================================================================== 
*/
public class VFP_CRDPrograme3Controller {
    public CRD__c crd {
        get;
        set;
    }
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    public string crdId {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    Public List < Clinical_Program__c > clinicalPrograme;
    Public List < Clinical_Program_Group_Junction__c > PSPGroup {
        get;
        set;
    }
    Public List < PSP_Junction__c > PSPList {
        get;
        set;
    }
    Public boolean showfields {
        get;
        set;
    }
    Public boolean showCheckBox {
        get;
        set;
    }
    Public Boolean isChanged {
        get;
        set;
    }
    public static final List < Schema.PicklistEntry > P1 = CRD__c.Insured_Type__c.getDescribe().getPicklistValues();
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';   
    PRIVATE STATIC FINAL STRING PROGRAMSPAGE = 'Programs';
    PRIVATE STATIC FINAL STRING OPTYES = 'yes';
    PRIVATE STATIC FINAL STRING SELFINSURED = 'Self Insured';
    PRIVATE STATIC FINAL STRING PSPRECORDTYPE ='Prescription Savings Program';
    PRIVATE STATIC FINAL STRING YESOPTION = 'Yes';
    PRIVATE STATIC FINAL STRING OPTNO = 'No';
    PRIVATE STATIC FINAL STRING FULLYINSURED = 'Fully Insured';
    PRIVATE STATIC FINAL STRING SAVEACOPAYURL = '/apex/VF_CRDSaveACopayJunction?crdid=';
    PRIVATE STATIC FINAL STRING RXCHECKJUNCURL = '/apex/VF_CRDRxCheckJunction?crdid=';
    Id saveACopayRtId;
    /*Constructor for the controller class */
    public VFP_CRDPrograme3Controller(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        isChanged = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        crd = [Select Id, Name, Y_Schd__c, Plan_Type_Paper__c, Integrate_with_Medical__c, Insured_Type__c, PSP_Override_Option__c, Effective_Start_Date__c, Do_Prescription_Savings_Program__c,PSP_Letter_Templates__c, Plan_Platform__c From CRD__c Where ID = : crdId LIMIT 100000];
        pageName = PROGRAMSPAGE;
        if (OPTYES.equalsIgnoreCase(crd.Do_Prescription_Savings_Program__c) && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
            showfields = true;
            showCheckBox = false;
        } else if (OPTYES.equalsIgnoreCase(crd.Do_Prescription_Savings_Program__c) && crd.Insured_Type__c != SELFINSURED) {
            showfields = false;
            showCheckBox = true;
        } else {
            showfields = false;
            showCheckBox = false;
        }
        PSPList = new List < PSP_Junction__c > ([Select Id, Name, Prescription_Savings_Program_Drug_Class__c, CRD_ID__c, Selected__c from PSP_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
        //Added inner query for story no 6733
        PSPGroup = new List < Clinical_Program_Group_Junction__c > ([select Id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Name, CRD_ID__c, Record_Type__c, Selected__c, Clinical_Program_Group_Name__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdid and Record_Type__c =: PSPRECORDTYPE LIMIT 100000]);
        isChanged = false;
    }
    /* Method to look for the PSP record */
    Public Void searchPrescription() {
       try { 
        isChanged = true;
        PSPGroup = null;
        PSPList = null;
        PSPGroup = new List < Clinical_Program_Group_Junction__c > ();
        PSPList = new List < PSP_Junction__c > ();
        if (YESOPTION.equalsIgnoreCase(crd.PSP_Override_Option__c)) {
            Id PSPRtId;
            List < Schema.RecordTypeInfo > RtInfo = Clinical_Program__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfo) {
                if (PSPRECORDTYPE.equalsIgnoreCase(thisInfo.Name)) {
                    PSPRtId = thisInfo.getRecordTypeId();
                }
            }
            date today = system.today();
            clinicalPrograme = new List < Clinical_Program__c > ([select Id, Name, Funding__c, Available_to_be_Picked__c, Clinical_Programs_Name__c from Clinical_Program__c where RecordTypeId = : PSPRtId and Inactive__c = false and Available_to_be_Picked__c = true and Available_Date__c != Null and Available_Date__c <= today and(PSP_Expiration_Date__c = Null or PSP_Expiration_Date__c >= today) LIMIT 100000]);
            if (clinicalPrograme.size() != 0) {
                for (Clinical_Program__c programe: clinicalPrograme) {
                    PSP_Junction__c PSPJunction = new PSP_Junction__c();
                    PSPJunction.PSP_ID__c = programe.id;
                    PSPJunction.Prescription_Savings_Program_Drug_Class__c = programe.Clinical_Programs_Name__c;
                    PSPJunction.CRD_ID__c = crdId;
                    PSPList.add(PSPJunction);
                }
            }
        } else if (OPTNO.equalsIgnoreCase(crd.PSP_Override_Option__c)) {
            Id PSPGroupRtId;
            List < Schema.RecordTypeInfo > RtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfos) {
                if (PSPRECORDTYPE.equalsIgnoreCase(thisInfo.Name)) {
                    PSPGroupRtId = thisInfo.getRecordTypeId();
                }
            }
            List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c > ([select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c from Clinical_Program_Group__c where RecordTypeId = : PSPGroupRtId and Inactive__c = false and Funding__c =: FULLYINSURED LIMIT 100000]);
            if (clinicalProgrameGroup.size() != 0) {
                for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                    Clinical_Program_Group_Junction__c cpGroupJunction = new Clinical_Program_Group_Junction__c();
                    cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                    cpGroupJunction.CRD_ID__c = crdId;
                    cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                    cpGroupJunction.Record_Type__c = PSPRECORDTYPE;
                    PSPGroup.add(cpGroupJunction);
                }
            }

        }
        else { //Do Nothing
        }
       }
       catch (exception e)
       {
           throw e;
       } 
    }
    /* Method showDrugClass */
    Public void showDrugClass() {
       try { 
        isChanged = true;
        PSPGroup = null;
        PSPList = null;
        PSPGroup = new List < Clinical_Program_Group_Junction__c > ();
        PSPList = new List < PSP_Junction__c > ();
        if (OPTYES.equalsIgnoreCase(crd.Do_Prescription_Savings_Program__c) && SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
            showfields = true;
            showCheckBox = false;
            crd.PSP_Override_Option__c = null;
            Id PSPRtId;
            List < Schema.RecordTypeInfo > RtInfo = Clinical_Program__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfo) {
                if (PSPRECORDTYPE.equalsIgnoreCase(thisInfo.Name)) {
                    PSPRtId = thisInfo.getRecordTypeId();
                }
            }
            date today = system.today();
            clinicalPrograme = new List < Clinical_Program__c > ([select Id, Name, Funding__c, Available_to_be_Picked__c, Clinical_Programs_Name__c from Clinical_Program__c where RecordTypeId = : PSPRtId and Inactive__c = false and Available_to_be_Picked__c = true and Available_Date__c != Null and Available_Date__c <= today and(PSP_Expiration_Date__c = Null or PSP_Expiration_Date__c >= today) LIMIT 100000]);
            if (clinicalPrograme.size() != 0) {
                for (Clinical_Program__c programe: clinicalPrograme) {
                    PSP_Junction__c PSPJunction = new PSP_Junction__c();
                    PSPJunction.PSP_ID__c = programe.id;
                    PSPJunction.Prescription_Savings_Program_Drug_Class__c = programe.Clinical_Programs_Name__c;
                    PSPJunction.CRD_ID__c = crdId;
                    PSPList.add(PSPJunction);
                }
            }
        } else if (OPTYES.equalsIgnoreCase(crd.Do_Prescription_Savings_Program__c) && crd.Insured_Type__c != SELFINSURED) {
            showfields = false;
            showCheckBox = true;
            crd.PSP_Letter_Templates__c = null;


        } else {
            showfields = false;
            showCheckBox = false;
            crd.PSP_Letter_Templates__c = null;
            crd.PSP_Override_Option__c = null;
        }
      }
      catch (exception e)
       {
           throw e;
       } 
    }
    /* Method redirectToPrograme2 for back button*/
    Public Pagereference redirectToPrograme2() {
        Integer selected = 0;
        Integer drugClass = 0;
        try {
            if (PSPGroup.size() != 0) {
                for (Clinical_Program_Group_Junction__c clinicalGroup: PSPGroup) {
                    if (clinicalGroup.Selected__c) selected = selected + 1;
                }
            }
            if (PSPList.SIZE() != 0) {
                for (PSP_Junction__c psp: PSPList) {
                    if (psp.Selected__c) drugClass = drugClass + 1;
                }
            }

            if (selected == 1 || drugClass >= 1 || crd.Do_Prescription_Savings_Program__c != YESOPTION) {
                database.update(crd);
                if (isChanged) {
                    List < PSP_Junction__c > DeletePSPList = new List < PSP_Junction__c > ([Select Id, Prescription_Savings_Program_Drug_Class__c, Selected__c from PSP_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                    List < Clinical_Program_Group_Junction__c > DeletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([Select Id, Selected__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdid and Record_Type__c =: PSPRECORDTYPE LIMIT 100000]);
                    if (DeletePSPList.size() != 0) database.delete(DeletePSPList);
                    if (DeletePSPGroup.size() != 0) database.delete(DeletePSPGroup);
                }
                if (PSPList.size() != 0) database.upsert(PSPList);
                if (PSPGroup.size() != 0) database.upsert(PSPGroup);
                // Modified by Amit Jain for request 01125
                    Pagereference pageRef = new Pagereference(SAVEACOPAYURL + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                //##Ends    
            } else if (selected != 1) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00108);
                ApexPages.addMessage(myMsg);
                return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00109);
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (exception e) {

            return null;
        }
    }
    
/* Method for back button for users not in public group */
Public Pagereference redirectToPrograme22() {
  try {      
    Pagereference pageRef = new Pagereference(SAVEACOPAYURL + crdId);
    pageRef.getParameters().put(EDITMODEPARAM,editMode);
    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
    return pageRef;
   }
   catch (exception e)
   {
       return null;
   }             
}    
    /* Method for the next button */
    Public Pagereference redirectToRxCheck() {
        Integer selected = 0;
        Integer drugClass = 0;
        try {
            if (PSPGroup.size() != 0) {
                for (Clinical_Program_Group_Junction__c clinicalGroup: PSPGroup) {
                    if (clinicalGroup.Selected__c) selected = selected + 1;
                }
            }
            if (PSPList.SIZE() != 0) {
                for (PSP_Junction__c psp: PSPList) {
                    if (psp.Selected__c) drugClass = drugClass + 1;
                }
            }

            if (selected == 1 || drugClass >= 1 || crd.Do_Prescription_Savings_Program__c != YESOPTION) {
                database.update(crd);
                if (isChanged) {
                    List < PSP_Junction__c > DeletePSPList = new List < PSP_Junction__c > ([Select Id, Prescription_Savings_Program_Drug_Class__c, Selected__c from PSP_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                    List < Clinical_Program_Group_Junction__c > DeletePSPGroup = new List < Clinical_Program_Group_Junction__c > ([Select Id, Selected__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdid and Record_Type__c =: PSPRECORDTYPE LIMIT 100000]);
                    if (DeletePSPList.size() != 0) database.delete(DeletePSPList);
                    if (DeletePSPGroup.size() != 0) database.delete(DeletePSPGroup);
                }
                if (PSPList.size() != 0) database.upsert(PSPList);
                if (PSPGroup.size() != 0) database.upsert(PSPGroup);

                Pagereference pageRef = new Pagereference(RXCHECKJUNCURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            } else if (selected != 1) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00108);
                ApexPages.addMessage(myMsg);
                return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00109);
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (exception e) {
            return null;
        }
    }

/* Method for next button for users not in public group */
 Public Pagereference redirectToRxCheck2() {
     try {
        Pagereference pageRef = new Pagereference(RXCHECKJUNCURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
       }
       catch (exception e){
           return null;
       } 
    }    
}