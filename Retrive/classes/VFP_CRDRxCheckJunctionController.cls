/*Purpose: Apex Class for VFP_CRDRxCheckJunction Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Anuj                 8/29/2011       Apex Class for VFP_CRDRxCheckJunction Page.
     2.0      Amit                 8/23/2013       Modofied for request 01125
     3.0     Toshi                 11/09/2016      Modified for ST#6733.
======================================================================== 
*/
public class VFP_CRDRxCheckJunctionController {
    public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    public List < RxCheck_Junction__c > RxcheckJunctionList {
        get;
        set;
    }
    public List < Clinical_Program__c > clinicalPrograme;
    public List < Clinical_Program_Group_Junction__c > RxcheckGroup {
        get;
        set;
    }
    public boolean planTypeUpdate;
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    private static final string YES = 'Yes';
    private static final string NO = 'No';
    private static final string RXC = 'Rxcheck';
    private static final string SI = 'Self Insured';
    private static final string FI = 'Fully Insured';
    private static final string EDITMODEPARAM = 'p1';
    private static final string GROUPMEMBERPARAM = 'p2';
    private static final string AHAPAGE = '/apex/VF_AhaPrograms?crdid=';
    private static final string PAGEURL = '/apex/VF_CRDPrograme3?crdid=';
    public string managementUser {get;set;}
    
    public Boolean showfields {
        get;
        set;
    }
    public Boolean isChanged;
    public Boolean showcheckBox {
        get;
        set;
    }
    Id RxCheckRtId;
    /*Constructor for VFP_CRDRxCheckJunctionController*/
    public VFP_CRDRxCheckJunctionController(ApexPages.StandardController controller) {
        
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;
        
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        crd = [Select Id, Y_Schd__c, Name, Integrate_with_Medical__c, Rx_Will_you_be_Picking_Drug_Classes__c, Rx_Override_Option__c, Insured_Type__c, Plan_Platform__c, Plan_Type_Paper__c, Enroll_in_RxCheck__c From CRD__c Where ID = : crdId LIMIT 80000];
        pageName = RXC;

        if (YES.equalsIgnoreCase(crd.Enroll_in_RxCheck__c) && SI.equalsIgnoreCase(crd.Insured_Type__c)) {
            showfields = true;
            showcheckBox = false;
        } else if (YES.equalsIgnoreCase(crd.Enroll_in_RxCheck__c) && crd.Insured_Type__c != SI) {
            showcheckBox = true;
            showfields = false;
        } else {
            showfields = false;
            showcheckBox = false;
        }
        RxcheckJunctionList = new List < RxCheck_Junction__c > ([Select RxCheck__c, RxCheck_Clinical_Programe__c, Selected__c, CRD__c from RxCheck_Junction__c
        where CRD__c = : crdId LIMIT 80000]);
        // Added inner query for history, ST # 6733
        RxcheckGroup = new List < Clinical_Program_Group_Junction__c > ([select Id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Name, CRD_ID__c, Record_Type__c, Selected__c, Clinical_Program_Group_Name__c from
        Clinical_Program_Group_Junction__c where CRD_ID__c = : crdid and Record_Type__c =: RXC LIMIT 80000]);
        isChanged = false;
    }
    /* Method searchRxCheck() */
    Public Void searchRxCheck() {
        isChanged = true;
        RxcheckJunctionList = null;
        RxcheckGroup = null;

        RxcheckJunctionList = new List < RxCheck_Junction__c > ();
        RxcheckGroup = new List < Clinical_Program_Group_Junction__c > ();
        List < Clinical_Program__c > clinicalPrograme = new List < Clinical_Program__c > ();

        if (YES.equalsIgnoreCase(crd.Rx_Will_you_be_Picking_Drug_Classes__c) || YES.equalsIgnoreCase(crd.Rx_Override_Option__c)) {
            List < Schema.RecordTypeInfo > RtInfo = Clinical_Program__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfo) {
                if (RXC.equalsIgnoreCase(thisInfo.Name)) {
                    RxCheckRtId = thisInfo.getRecordTypeId();
                }
            }
            date today = system.today();
            clinicalPrograme = [select Id, Name, RecordTypeId, Clinical_Programs_Name__c, Available_to_be_Picked__c from Clinical_Program__c where RecordTypeId = : RxCheckRtId
            and Inactive__c = false and Available_to_be_Picked__c = true and Available_Date__c != Null and Available_Date__c <= today and(RxCheck_Termination_Date__c = Null or RxCheck_Termination_Date__c >= today) LIMIT 80000];

            if (clinicalPrograme.size() != 0) {
                for (Clinical_Program__c RxCheckClinicalPragrame: clinicalPrograme) {
                    RxCheck_Junction__c RxcheckJunction = new RxCheck_Junction__c();
                    RxcheckJunction.RxCheck__c = RxCheckClinicalPragrame.Id;
                    RxcheckJunction.CRD__c = crd.Id;
                    RxcheckJunction.RxCheck_Clinical_Programe__c = RxCheckClinicalPragrame.Clinical_Programs_Name__c;
                    RxcheckJunction.Selected__c = False;
                    RxcheckJunctionList.add(RxcheckJunction);
                }
            }
        } else if (NO.equalsIgnoreCase(crd.Rx_Will_you_be_Picking_Drug_Classes__c)) {
            Id RxCheckGroupRtId;
            List < Schema.RecordTypeInfo > RtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfos) {
                if (RXC.equalsIgnoreCase(thisInfo.Name)) {
                    RxCheckGroupRtId = thisInfo.getRecordTypeId();
                }
            }
            List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c > ([select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c from Clinical_Program_Group__c where RecordTypeId = : RxCheckGroupRtId and Inactive__c = false and Funding__c =: SI LIMIT 80000]);
            if (clinicalProgrameGroup.size() != 0) {
                for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                    Clinical_Program_Group_Junction__c cpGroupJunction = new Clinical_Program_Group_Junction__c();
                    cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                    cpGroupJunction.CRD_ID__c = crdId;
                    cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                    cpGroupJunction.Record_Type__c = RXC;
                    RxcheckGroup.add(cpGroupJunction);
                }
            }
        } else if (NO.equalsIgnoreCase(crd.Rx_Override_Option__c)) {
            Id RxCheckGroupRtId;
            List < Schema.RecordTypeInfo > RtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: RtInfos) {
                if (RXC.equalsIgnoreCase(thisInfo.Name)) {
                    RxCheckGroupRtId = thisInfo.getRecordTypeId();
                }
            }
            List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c > ([select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c from Clinical_Program_Group__c where RecordTypeId = : RxCheckGroupRtId and Inactive__c = false and Funding__c =: FI LIMIT 80000]);
            if (clinicalProgrameGroup.size() != 0) {
                for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                    Clinical_Program_Group_Junction__c cpGroupJunction = new Clinical_Program_Group_Junction__c();
                    cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                    cpGroupJunction.CRD_ID__c = crdId;
                    cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                    cpGroupJunction.Record_Type__c = RXC;
                    RxcheckGroup.add(cpGroupJunction);
                }
            }
        }
    }
    /*Mehtod to conditionally render fields*/
    Public Void displayField() {
        isChanged = true;
        RxcheckJunctionList = null;
        RxcheckGroup = null;
        RxcheckGroup = new List < Clinical_Program_Group_Junction__c > ();
        RxcheckJunctionList = new List < RxCheck_Junction__c > ();
        if (YES.equalsIgnoreCase(crd.Enroll_in_RxCheck__c) && SI.equalsIgnoreCase(crd.Insured_Type__c)) {
            showfields = true;
            showCheckBox = false;
            crd.Rx_Override_Option__c = null;
        } else if (YES.equalsIgnoreCase(crd.Enroll_in_RxCheck__c) && crd.Insured_Type__c != SI) {
            showfields = false;
            showCheckBox = true;
            crd.Rx_Will_you_be_Picking_Drug_Classes__c = null;
        } else {
            showfields = false;
            showCheckBox = false;
            crd.Rx_Will_you_be_Picking_Drug_Classes__c = null;
            crd.Rx_Override_Option__c = null;
        }
    }
    /*Method to redirect to Programs page*/
    Public PageReference redirectToProgram() {
        Integer selected = 0;
        Integer drugClass = 0;
        try {
            if (RxcheckGroup.size() != 0) {
                for (Clinical_Program_Group_Junction__c clinicalGroup: RxcheckGroup) {
                    if (clinicalGroup.Selected__c) {selected = selected + 1;}
                }
            }
            if (RxcheckJunctionList.size() != 0) {
                for (RxCheck_Junction__c clinicalGroup: RxcheckJunctionList) {
                    if (clinicalGroup.Selected__c) {drugClass = drugClass + 1;}
                }
            }
            if (selected == 1 || drugClass >= 1 || crd.Enroll_in_RxCheck__c != YES) {
                database.update(crd);
                if (isChanged) {
                    List < RxCheck_Junction__c > deleteJunctionList = new List < RxCheck_Junction__c > ([Select Id, RxCheck__c, RxCheck_Clinical_Programe__c, Selected__c, CRD__c from RxCheck_Junction__c where CRD__c = : crdId LIMIT 80000]);
                    List < Clinical_Program_Group_Junction__c > deleteRxcheckGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name, Selected__c, CRD_ID__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdId and Record_Type__c =: RXC LIMIT 80000]);
                    if (deleteJunctionList.size() != 0) delete deleteJunctionList;
                    if (deleteRxcheckGroup.size() != 0) delete deleteRxcheckGroup;
                }
                if (RxcheckJunctionList.size() != 0) {database.upsert(RxcheckJunctionList);}
                if (RxcheckGroup.size() != 0) {database.upsert(RxcheckGroup);}
            } else if (selected != 1) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00111);
                ApexPages.addMessage(myMsg);
                return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00112);
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (exception e) {
            return null;
        }
         //Modified by Amit Jain for request 01125
             Pagereference pageRef = new Pagereference(PAGEURL + crdId);
             pageRef.getParameters().put(EDITMODEPARAM,editMode);
             pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                database.update(crd);
                return pageRef;
         //##Ends       
    }
    
    /* Method for back button for users not in public group*/
    Public PageReference redirectToProgram2() {
        try{
     Pagereference pageRef = new Pagereference(PAGEURL + crdId);
     pageRef.getParameters().put(EDITMODEPARAM,editMode);
     pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
     return pageRef;      
    }   catch(exception e){return null;}
    }
    /*Method to Redirect to POS Screen*/
    Public PageReference redirectToPOSRebate() {
        Integer selected = 0;
        Integer drugClass = 0;
        try {
            if (RxcheckGroup.size() != 0) {
                for (Clinical_Program_Group_Junction__c clinicalGroup: RxcheckGroup) {
                    if (clinicalGroup.Selected__c) {selected = selected + 1;}
                }
            }
            if (RxcheckJunctionList.size() != 0) {
                for (RxCheck_Junction__c clinicalGroup: RxcheckJunctionList) {
                    if (clinicalGroup.Selected__c) {drugClass = drugClass + 1;}
                }
            }
            if (selected == 1 || drugClass >= 1 || crd.Enroll_in_RxCheck__c != YES) {
                database.update(crd);
                if (isChanged) {
                    List < RxCheck_Junction__c > deleteJunctionList = new List < RxCheck_Junction__c > ([Select Id, RxCheck__c, RxCheck_Clinical_Programe__c, Selected__c, CRD__c from RxCheck_Junction__c where CRD__c = : crdId LIMIT 80000]);
                    List < Clinical_Program_Group_Junction__c > deleteRxcheckGroup = new List < Clinical_Program_Group_Junction__c > ([select Id, Name, Selected__c, CRD_ID__c from Clinical_Program_Group_Junction__c where CRD_ID__c = : crdId and Record_Type__c =: RXC LIMIT 80000]);
                    if (deleteJunctionList.size() != 0) delete deleteJunctionList;
                    if (deleteRxcheckGroup.size() != 0) delete deleteRxcheckGroup;
                }
                if (RxcheckJunctionList.size() != 0) {database.upsert(RxcheckJunctionList);}
            if (RxcheckGroup.size() != 0) {database.upsert(RxcheckGroup);}
            } else if (selected != 1) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00111);
                ApexPages.addMessage(myMsg);
                return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'Please select atleast one RxCheck');
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (exception e) {
            return null;
        }
        //Modified by Amit Jain for request 01125 on 8/23/2013
           Pagereference pageRef = new Pagereference(AHAPAGE + crdId);
           pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        //##Ends      
    }
    
/* Method for next button for users not in public group*/
Public PageReference redirectToPOSRebate2() {
    try{
           Pagereference pageRef = new Pagereference(AHAPAGE + crdId);
           pageRef.getParameters().put(EDITMODEPARAM,editMode);
           pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;  
    }   catch(exception e){return null;}
    }    
}