/*Purpose: Apex Class for VFP_CRDClinicalProgPriorAuth2 Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Sourabh                 10/22/2011       Apex Class for VFP_CRDClinicalProgPriorAuth2 Page.
     2.0     Sushant Sethi           02/25/2014       Added Comments 
     3.0 -   Sushant Sethi           08/20/2014       Removed Attachment section. Edited screen as per request 04872 
     4.0 -   Amit Jain               6th May 2014     Updated logic for Default Drug List display to show only 1 DL   
     5.0 -   Nitish Verma            13 July 2015     Request Number 05812
     5.1 -   Richa                   09 Oct 2015      Request Number 06118
     6.0 -   Ayushi                  28 Jan 2016      Request Number 06320 (ST# 677)
======================================================================== 
*/
public with sharing class VFP_CRDClinicalProgPriorAuth2Controller {
    public CRD__c crd {
        get;
        set;
    }
    public Drug_List__c druglistname {
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
    public string groupMember{get;set;}
    public String editMode{get;set;}
    public list<CRD_NPL_Junction__c> lstStandardCrdNplJunctionRecords{get;set;}
    public list<CRD_NPL_Junction__c> lstExistingCrdNplJunctionRecords{get;set;}
    public set<ID> wrapperID = new set<ID>();
    public set<ID> duplicateIDset = new set<ID>();
    public list <nplWrapper> lstWrapperItems{get;set;}
    public list <nplWrapper> lstDrugListForNPL{get;set;} 
    public list<Drug_Coverage__c> lstdrugcover {get;set;}
    public boolean NPLreRender;
    public boolean StandardSectionRerender{get;set;}
    public FormularyXCustomDL_ERD__c xErdTable {get;set;}
    private static final string BACKPAGE = '/apex/VF_CRDClinicalProgPriorAuth1?id=';
    private static final string NEXTPAGE = '/apex/VF_CRDQuantityLimits?crdid=';
    private static final string YES = 'Yes';
    private static final string NO = 'No';
    private static final string SELFINSURED = 'Self Insured';
    private static final string FULLYINSURED = 'Fully Insured';
    private static final string SPLITFUNDED = 'Split Funded';
    private static final string DRUGLIST1 = ' Name =\'DL-0060714\'';
    private static final string DRUGLIST2 = ' Name =\'DL-0060715\'';
    private static final string QUERYPART1 = 'SELECT id,name,Description__c,Drug_List_Name__c,Special_Use__c,Standard__c,Platform__c,Funding__c from Drug_List__c where';
    private static final string QUERYPART3 = ' AND id NOT IN: drugListId ';
    private static final string CURRENTPAGENAME = 'currentPageName';
    private static final string NULLLABEL = '';
    private static final string IDLABEL = 'id';
    private static final string ERRORMSG1 = 'If "NPL Applies? " equals "No" then "Opt of NPL" should be checked';
    private static final string ERRORMSG2 = 'If "NPL Applies? " equals "Yes" then "Opt of NPL" should not be checked';
    private static final string ERRORMSG3 = 'If "NPL Applies? " equals "No" then "NPL Drug List" should not be selected';
    private static final string NPLLABEL = 'NPL';
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    private static final string NPLV = 'NPL';
    private static final string ASHDL = 'DL-0104862';// Added by Nitish for 6837
/**
* Method :- VFP_CRDClinicalProgPriorAuth2Controller
* Description :-  Method for VFP_CRDClinicalProgPriorAuth2 Page.
**/
    public VFP_CRDClinicalProgPriorAuth2Controller(ApexPages.StandardController controller) {
        lstStandardCrdNplJunctionRecords = new list<CRD_NPL_Junction__c>();
        lstWrapperItems = new list<nplWrapper>();
        lstDrugListForNPL = new list<nplWrapper>();        
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(IDLABEL); 
    editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);  
        crd = [Select Name, Plan_platform__c,Integrate_with_Medical__c, Plan_Type_Paper__c, Insured_Type__c, RxPlan_ID_Status__c, Opt_out_of_Safety_Edits__c, Retail_to_Mail__c,NPL_Applies__c,npl_drug_list__c,npl_drug_list__r.id,npl_drug_list__r.name,custom_NPL__c, Opt_out_of_Rx_OTC_Edit__c, Y_Schd__c From CRD__c Where ID = : crdId LIMIT 1];
        if(crd.NPL_Applies__c == null || crd.NPL_Applies__c == NULLLABEL){
           crd.NPL_Applies__c = YES; 
        }
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGENAME);
        }
/** 
* Method:- displayDrugList()
* Description :- This method displays the Drug Lists
**/
    public void displayDrugList(){
        try{
            lstExistingCrdNplJunctionRecords = new list<CRD_NPL_Junction__c>([SELECT CRD_ID__c,Drug_List__c,drug_list__r.name,drug_list__r.standard__c,drug_list__r.special_use__c,Drug_List_Description__c,Drug_List_Name__c,IsStandard__c,Select__c 
                                                                             FROM CRD_NPL_Junction__c where crd_id__c = : this.crd.id LIMIT 10000]); 
            set<ID> drugListID = new set<ID>();  
            if(lstExistingCrdNplJunctionRecords != NULL & lstExistingCrdNplJunctionRecords.size()>0){
                Drug_list__c druglist;
                nplWrapper wrap;
                for(CRD_NPL_Junction__c crdnplRecord : lstExistingCrdNplJunctionRecords){
                    if(crdnplRecord.drug_list__c != NULL && crdnplRecord.crd_id__c != NULL && crdnplrecord.drug_list__r.standard__c && crdnplrecord.IsStandard__c){
                        wrap = new nplWrapper();
                        druglist = new drug_list__c (id= crdnplRecord.drug_list__c,drug_list_name__c = crdnplRecord.drug_list_name__c,description__c = crdnplRecord.drug_list_description__c,standard__c = crdnplRecord.drug_list__r.standard__c,special_use__c = crdnplrecord.drug_list__r.special_use__c);
                        wrap.crdnplDLItem = druglist;
                        wrap.selected = crdnplRecord.select__c;
                        wrap.classname = crdnplRecord.drug_list__r.name;
                        wrap.classdescription = crdnplRecord.drug_list_description__c;
                        wrap.specialuse = crdnplRecord.drug_list__r.special_use__c;
                        wrap.standard = crdnplRecord.drug_list__r.standard__c;
                        lstDrugListForNPL.add(wrap);
                        druglistID.add(druglist.id);                      
                    }     
                    if(crdnplRecord.drug_list__c != NULL && !crdnplrecord.drug_list__r.standard__c && !crdnplrecord.IsStandard__c){
                        wrap = new nplWrapper();
                        wrap.crdnplJunctionItem = crdnplRecord;                             
                        wrap.selected = crdnplRecord.select__c;
                        wrap.classname = crdnplRecord.drug_list__r.name;
                        wrap.specialuse = crdnplRecord.drug_list__r.special_use__c;
                        wrap.standard = crdnplRecord.drug_list__r.standard__c;
                        wrap.classdescription = crdnplRecord.drug_list_description__c; 
                        lstWrapperItems.add(wrap);  
                    } 
                    //Below if block added for Req 6118 by Richa
                    if(crdnplRecord.drug_list__c != NULL && crdnplrecord.drug_list__r.standard__c && !crdnplrecord.IsStandard__c){
                        wrap = new nplWrapper();
                        wrap.crdnplJunctionItem = crdnplRecord;                             
                        wrap.selected = crdnplRecord.select__c;
                        wrap.classname = crdnplRecord.drug_list__r.name;
                        wrap.specialuse = crdnplRecord.drug_list__r.special_use__c;
                        wrap.standard = crdnplRecord.IsStandard__c;
                        wrap.classdescription = crdnplRecord.drug_list_description__c; 
                        lstWrapperItems.add(wrap);  
                    }  
                    
                    
                }   
                
                if(crd.Insured_Type__c!= Null){
                    string queryForStandardDrugList = QUERYPART1; 
                    //Modified by Amit for request 5728
                    if (FULLYINSURED.equalsIgnoreCase(crd.Insured_Type__c) || SPLITFUNDED.equalsIgnoreCase(crd.Insured_Type__c)){
                        queryForStandardDrugList = queryForStandardDrugList + DRUGLIST1;
                    } 
                    if (SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
                        queryForStandardDrugList = queryForStandardDrugList + DRUGLIST2;
                    }
                    //Ends
                    queryForStandardDrugList = queryForStandardDrugList + QUERYPART3;
                    for(drug_list__c dl : Database.query(queryForStandardDrugList )){
                        wrap = new nplWrapper();
                        wrap.crdnplDLItem = dl;
                        lstDrugListForNPL.add(wrap);                          
                    }  
                }                  
            }
            else {
                if(crd.Insured_Type__c!= Null){
                                        
                    string queryForStandardDrugList = QUERYPART1; 
                     //Modified by Amit for request 5728
                    if (FULLYINSURED.equalsIgnoreCase(crd.Insured_Type__c) || SPLITFUNDED.equalsIgnoreCase(crd.Insured_Type__c)){
                        queryForStandardDrugList = queryForStandardDrugList + DRUGLIST1;
                    } 
                    if (SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c)) {
                        queryForStandardDrugList = queryForStandardDrugList + DRUGLIST2;
                    }                            
                    //Ends
                    queryForStandardDrugList = queryForStandardDrugList + QUERYPART3; 
                    list<drug_list__c> drugListRecords = Database.query(queryForStandardDrugList );
                    nplWrapper wrap;
                    for(drug_list__c dl : drugListRecords){
                       wrap = new nplWrapper();
                       wrap.crdnplDLItem = dl;
                       lstDrugListForNPL.add(wrap);                          
                    }                                                
                }
            }
            populateDrugListData();   //Added as part of Req 6118   
        }catch(exception ex){}
    }  
                  
/**
* Method :- getNPLreRender
* Detail :- This method was written to rerender the NPL drug list field on screen based on the type of formulary DC is having.
   Request No - 05812
**/
    public boolean getNPLreRender(){
        try{
            lstdrugcover = [Select id,Formulary_Group__c,CRD_ID__c,Formulary__c from Drug_Coverage__c where CRD_ID__c=:crdId LIMIT 2];
            if(lstdrugcover.size()>0){
                for(drug_coverage__c dr :  lstdrugcover) {
                    system.debug('#####+++ ' +string.isBlank(dr.Formulary_Group__c));
                    if(string.isBlank(dr.Formulary_Group__c)){
                           NPLreRender = false;
                           StandardSectionRerender = true;
                    } else {
                        system.debug('lstdrugcover[0]+++ ' + lstdrugcover[0]);
                        if(lstdrugcover[0].Formulary__c != null){//Updates for ST# 677 start
                        NPLreRender = true;
                        StandardSectionRerender = false;
                        if(crd.NPL_Drug_List__c == null) {
                        xErdTable = [Select id,Formulary__c,NPL_List__c from FormularyXCustomDL_ERD__c where Formulary__c =:lstdrugcover[0].Formulary__c LIMIT 1];
                        if(xErdTable != null && xErdTable.NPL_List__c != null){
                            crd.NPL_Drug_List__c = xErdTable.NPL_List__c;
                            
                        }
                        } //Updates for ST# 677 end
                        if(crd.NPL_Drug_List__c != null){
                            druglistname = [Select id,Name,Drug_List_Name__c,Description__c from Drug_List__c where id=: crd.NPL_Drug_List__c LIMIT 1];
                        }        
                        }
                     }
                }
            }
            return NPLreRender;
        }catch(exception ex){return false;}
    }
/**
* Method :- setNPLreRender
* Detail :- This method was written to rerender the NPL drug list field on screen based on the type of formulary DC is having.
   Request No - 05812
**/
    public boolean setNPLreRender(){
    try{
        return null;
    } catch(exception e){return null;}
    } 
/**
* Method :- validateNonOptEdits
* Description :- The method validates the Non Opt Out of NPL
**/ 
    public boolean validateNonOptEdits() {
        try{
            boolean isValid = true;
            integer counter = 0;
            if (crd.Opt_out_of_Rx_OTC_Edit__c != null && crd.Opt_out_of_Rx_OTC_Edit__c) {
                if (lstWrapperItems != null && lstWrapperItems.size() > 0) {
                    isValid = false;
                }
                for (nplwrapper wrap: lstDrugListForNPL) {
                    if (wrap.selected) {
                        counter = counter + 1;
                    }
                }
            }
            if (crd.Opt_out_of_Rx_OTC_Edit__c != null && crd.Opt_out_of_Rx_OTC_Edit__c && counter == 0) {
                isValid = true;
            } else {
                isValid = false;
            }
            if (crd.Opt_out_of_Rx_OTC_Edit__c == null && (counter > 0 || lstWrapperItems.size() > 0)) {
                isValid = false;
            }
            return isValid;
        }catch(exception ex){return false;}
    }
/**
* Method :- nextButton
* Description :-  Method for redirection to Pharmacy Network Page for ReadOnly Mode
**/
Public Pagereference nextButton2(){
    try{
    Pagereference pageRef = new Pagereference(NEXTPAGE + crdId);
    pageRef.getParameters().put(EDITMODEPARAM,editMode);
    PageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
    return pageRef;
}catch(exception e){return null;}
    }
/**
* Method :- nextButton
* Description :-  Method for redirection to Pharmacy Network Page.
**/
    Public PageReference nextButton() {
        try{
            duplicateIDset.clear();
            lstStandardCrdNplJunctionRecords.clear();
            Map<Id,CRD_NPL_Junction__c> mapNPL = new Map<Id,CRD_NPL_Junction__c>();
            list <nplWrapper> allWrappers;
            set <id> addedDLs = new set<id>{crd.NPL_Drug_List__r.id};
            /*list<CRD_NPL_Junction__c> lstExistingCRDNPLJunctionRecords = new list<CRD_NPL_Junction__c>([SELECT CRD_ID__c,Drug_List__c,drug_list__r.id,drug_list__r.special_use__c,Drug_List_Description__c,Drug_List_Name__c,
                                                                                                                     IsStandard__c,Select__c 
                                                                                                                     FROM CRD_NPL_Junction__c where crd_id__c = : this.crd.id LIMIT 10000]);*/

            for(CRD_NPL_Junction__c npl : [SELECT CRD_ID__c,Drug_List__c,drug_list__r.id,drug_list__r.special_use__c,Drug_List_Description__c,Drug_List_Name__c,
                                                                                                                     IsStandard__c,Select__c 
                                                                                                                     FROM CRD_NPL_Junction__c where crd_id__c = : this.crd.id LIMIT 10000]){
                mapNPL.put(npl.Drug_List__r.id,npl);   
            }
            if (crd.Opt_out_of_Rx_OTC_Edit__c != null && crd.Opt_out_of_Rx_OTC_Edit__c && !validateNonOptEdits()) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00251);
                ApexPages.addMessage(myMsg);
                return null;
            }
            if (NO.equalsIgnoreCase(crd.NPL_Applies__c) && !crd.Opt_out_of_Rx_OTC_Edit__c) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, ERRORMSG1);
                ApexPages.addMessage(myMsg);
                return null;
            } 
            if (YES.equalsIgnoreCase(crd.NPL_Applies__c) && crd.Opt_out_of_Rx_OTC_Edit__c) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, ERRORMSG2);
                ApexPages.addMessage(myMsg);
                return null;
            }
            if (NO.equalsIgnoreCase(crd.NPL_Applies__c) && crd.NPL_Drug_List__c != null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, ERRORMSG3);
                ApexPages.addMessage(myMsg);
                return null;
            }                 
            list<CRD_NPL_Junction__c> deleteNPL = new list<CRD_NPL_Junction__c>();  
            CRD_NPL_Junction__c crdnplJunctionRecord;           
            for(nplwrapper wrap:lstDrugListForNPL){
                if(wrap.crdnplDLItem != null){
                    crdnplJunctionRecord = new CRD_NPL_Junction__c();
                    crdnplJunctionRecord.drug_list__c = wrap.crdnplDLItem.id;
                    crdnplJunctionRecord.select__c = wrap.selected;
                    crdnplJunctionRecord.crd_ID__c = this.crd.id;
                    crdnplJunctionRecord.isstandard__c = wrap.crdnplDLItem.standard__c;  
                    if(crdnplJunctionRecord.select__c){ 
                        lstStandardCrdNplJunctionRecords.add(crdnplJunctionRecord);
                        addedDLs.add(wrap.crdnplDLItem.id);
                    } else {
                        if(mapNPL.containsKey(crdnplJunctionRecord.drug_list__c)){
                            deleteNPL.add(mapNPL.get(crdnplJunctionRecord.drug_list__c));
                        }
                      }                     
                }          
            }
            allWrappers = lstDrugListForNPL;  
            ApexPages.Message myMsg;  
            //CRD_NPL_Junction__c crdnplJunctionRecord ;
            for(nplwrapper wrap:lstWrapperItems){
                if(wrap.crdnplJunctionItem != null){
                    crdnplJunctionRecord = new CRD_NPL_Junction__c();
                    crdnplJunctionRecord.drug_list__c = wrap.crdnplJunctionItem.drug_list__c;
                    crdnplJunctionRecord.select__c = wrap.selected;
                    crdnplJunctionRecord.crd_ID__c = this.crd.id;
                    crdnplJunctionRecord.isstandard__c = wrap.crdnplDLItem.standard__c;  
                    if(crdnplJunctionRecord.select__c){
                        if(NPLLABEL.equalsIgnoreCase(wrap.specialuse) && !addedDLs.contains(wrap.crdnplJunctionItem.drug_list__c)/* && wrap.standard == FALSE*/){//Standard condition commented for Req 6118
                            if(crdnplJunctionRecord.select__c && crdnplJunctionRecord.drug_list__C !=NULL){
                                if(duplicateIDset.contains(wrap.crdnplJunctionItem.drug_list__c)){
                                    myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00253);
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                } else {
                                    lstStandardCrdNplJunctionRecords.add(crdnplJunctionRecord);
                                    duplicateIDset.add(wrap.crdnplJunctionItem.drug_list__c);
                                  }
                            }
                        } else {
                                myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00252);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }
                    } else {
                        if(mapNPL.containsKey(crdnplJunctionRecord.drug_list__c )){
                            deleteNPL.add(mapNPL.get(crdnplJunctionRecord.drug_list__c ));
                        }
                       }
                }
                
            } 
            allWrappers.addAll(lstWrapperItems);  
            list<CRD_NPL_Junction__c> insertNPL = new list<CRD_NPL_Junction__c>(); 
            if(lstStandardCrdNplJunctionRecords != NULL && lstStandardCrdNplJunctionRecords.size()>0){
                for(CRD_NPL_Junction__c temprec : lstStandardCrdNplJunctionRecords){
                    if(!mapNPL.containsKey(temprec.drug_list__c)){
                        insertNPL.add(temprec);
                    }
                }
            }
            Database.insert (insertNPL,false);  
            Database.delete (deleteNPL,false);
            Database.update (crd);
            Pagereference pageRef = new Pagereference(NEXTPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
            PageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;   
        }catch(exception ex){return null;}
    }
/**
* Method :- backButton
* Description :-  Method for redirection to ClinicalProgPriorAuth1 Page.// Back Button // For ReadOnly Mode
**/
Public Pagereference backButton2(){
    try{
    Pagereference pageRef = new Pagereference(BACKPAGE + crdId);
    pageRef.getParameters().put(EDITMODEPARAM,editMode);
    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
    return pageRef;
}catch(exception e){return null;}
    }
/**
* Method :- backButton
* Description :-  Method for redirection to ClinicalProgPriorAuth1 Page.// Back Button
**/
    Public PageReference backButton() {
        try{
            duplicateIDset.clear();
            lstStandardCrdNplJunctionRecords.clear();
            Map<Id,CRD_NPL_Junction__c> mapNPL = new Map<Id,CRD_NPL_Junction__c>();
            list <nplWrapper> allWrappers;
            set <id> addedDLs = new set<id>{crd.NPL_Drug_List__r.id};
            /*list<CRD_NPL_Junction__c> lstExistingCRDNPLJunctionRecords = new list<CRD_NPL_Junction__c>([SELECT CRD_ID__c,Drug_List__c,drug_list__r.id,drug_list__r.special_use__c,Drug_List_Description__c,Drug_List_Name__c,
                                                                                                                     IsStandard__c,Select__c 
                                                                                                                     FROM CRD_NPL_Junction__c where crd_id__c = : this.crd.id LIMIT 10000]);*/

            for(CRD_NPL_Junction__c npl : [SELECT CRD_ID__c,Drug_List__c,drug_list__r.id,drug_list__r.special_use__c,Drug_List_Description__c,Drug_List_Name__c,
                                                                                                                     IsStandard__c,Select__c 
                                                                                                                     FROM CRD_NPL_Junction__c where crd_id__c = : this.crd.id LIMIT 10000]){
                mapNPL.put(npl.Drug_List__r.id,npl);    
            }
            if (crd.Opt_out_of_Rx_OTC_Edit__c != null && crd.Opt_out_of_Rx_OTC_Edit__c && !validateNonOptEdits()) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00251);
                ApexPages.addMessage(myMsg);
                return null;
            }
            list<CRD_NPL_Junction__c> deleteNPL = new list<CRD_NPL_Junction__c>();   
            CRD_NPL_Junction__c crdnplJunctionRecord ;
            for(nplwrapper wrap:lstDrugListForNPL){
                if(wrap.crdnplDLItem != null){
                    crdnplJunctionRecord = new CRD_NPL_Junction__c();
                    crdnplJunctionRecord.drug_list__c = wrap.crdnplDLItem.id;
                    crdnplJunctionRecord.select__c = wrap.selected;
                    crdnplJunctionRecord.crd_ID__c = this.crd.id;
                    crdnplJunctionRecord.isstandard__c = wrap.crdnplDLItem.standard__c;  
                    if(crdnplJunctionRecord.select__c){ 
                        lstStandardCrdNplJunctionRecords.add(crdnplJunctionRecord);
                        addedDLs.add(wrap.crdnplDLItem.id);
                    } else {
                        if(mapNPL.containsKey(crdnplJunctionRecord.drug_list__c)){
                            deleteNPL.add(mapNPL.get(crdnplJunctionRecord.drug_list__c));
                        }
                      }                     
                }          
                
            }
            allWrappers = lstDrugListForNPL;  
            ApexPages.Message myMsg;  
            //CRD_NPL_Junction__c crdnplJunctionRecord ;
            for(nplwrapper wrap:lstWrapperItems){
                if(wrap.crdnplJunctionItem != NULL){
                    crdnplJunctionRecord = new CRD_NPL_Junction__c();
                    crdnplJunctionRecord.drug_list__c = wrap.crdnplJunctionItem.drug_list__c;
                    crdnplJunctionRecord.select__c = wrap.selected;
                    crdnplJunctionRecord.crd_ID__c = this.crd.id;
                    crdnplJunctionRecord.isstandard__c = wrap.crdnplDLItem.standard__c;  
                    if(crdnplJunctionRecord.select__c){
                        if(NPLLABEL.equalsIgnoreCase(wrap.specialuse) && !addedDLs.contains(wrap.crdnplJunctionItem.drug_list__c)/* && wrap.standard == FALSE*/){//Standard condition commented for Req 6118
                            if(crdnplJunctionRecord.select__c && crdnplJunctionRecord.drug_list__C !=NULL){
                                if(duplicateIDset.contains(wrap.crdnplJunctionItem.drug_list__c)){
                                    myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00253);
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }
                            } else {
                                    lstStandardCrdNplJunctionRecords.add(crdnplJunctionRecord);
                                    duplicateIDset.add(wrap.crdnplJunctionItem.drug_list__c);
                                }
                        } else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00252);
                            ApexPages.addMessage(myMsg);
                            return null;
                          }
                    } else {
                            if(mapNPL.containsKey(crdnplJunctionRecord.drug_list__c )){
                                deleteNPL.add(mapNPL.get(crdnplJunctionRecord.drug_list__c ));
                            }
                        }
                }
                
            } 
            allWrappers.addAll(lstWrapperItems);  
            list<CRD_NPL_Junction__c> insertNPL = new list<CRD_NPL_Junction__c>();           
            if(lstStandardCrdNplJunctionRecords != NULL && lstStandardCrdNplJunctionRecords.size()>0){
                for(CRD_NPL_Junction__c temprec : lstStandardCrdNplJunctionRecords){
                    if(!mapNPL.containsKey(temprec.drug_list__c)){
                        insertNPL.add(temprec);
                    }
                }
            }
            Database.insert (insertNPL,false);  
            Database.delete (deleteNPL,false);
            Database.update (crd);
            Pagereference pageRef = new Pagereference(BACKPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        PageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;  
        }catch (exception ex) {return null;}
    }
/**
* Method :- addnewItem
* Description :- this method adds new row
**/    
    public void addNewItem() {
        try{
            lstWrapperItems.add(new nplWrapper()); 
        }catch(exception ex){}
    } 
/**
* Method :- populateDrugListData()
* Description :- The method populate druglist data
**/
    public void populateDrugListData(){
        try{    
            Set < Id > drugsIds = new Set < Id > ();
            for(nplWrapper wInstance: lstWrapperItems) {
                if(wInstance.crdnplJunctionItem.Drug_list__c != NULL) {          
                    drugsIds.add(wInstance.crdnplJunctionItem.Drug_list__c);
                }
            }
            Map<ID,Drug_list__c> mapDrugList = new map<Id,Drug_list__c>([Select Drug_List_Name__c, Description__c,special_use__c,standard__c from Drug_List__c where Id in : drugsIds LIMIT 10000]);      
            for(nplWrapper wInstance: lstWrapperItems) {
                if(wInstance.crdnplJunctionItem.Drug_list__c != NULL){
                    wInstance.classname = mapDrugList.get(wInstance.crdnplJunctionItem.Drug_list__c).Drug_List_Name__c;
                    wInstance.classDescription = mapDrugList.get(wInstance.crdnplJunctionItem.Drug_List__c).Description__c;
                    wInstance.specialuse = mapDrugList.get(wInstance.crdnplJunctionItem.Drug_List__c).Special_Use__c;
                    wInstance.standard = mapDrugList.get(wInstance.crdnplJunctionItem.Drug_List__c).Standard__c;
                }            
            } 
        }catch(exception ex){}
    }
/**
* Method :- deleteJunctionObjetRecords()
* Description :- The method to delete rows
**/
    public void deleteJunctionObjetRecords() {
        try{
            list<nplwrapper> newList= new list<nplwrapper>();
            for(nplWrapper wInstance: lstWrapperItems) {
                if (!wInstance.selected) {
                    newList.add(wInstance);
                } else {
                        wrapperId.add(wInstance.crdnplJunctionItem.Id);
                    }
            } 
            lstWrapperItems.clear();
            lstWrapperItems = newList;  
        }catch(exception ex){}
    }       
/**
*Wrapper Class
**/
    public with sharing class nplWrapper{
        public CRD_NPL_Junction__c crdnplJunctionItem{get;set;}
        public drug_list__c crdnplDLItem{get;set;}
        public Boolean selected{get;set;}
        public string className{get;set;}
        public string classDescription{get;set;}
        public string specialuse{get;set;}
        public boolean standard{get;set;}
/**
*Constructor of Wrapper Class
**/     
        public nplWrapper(){
            selected = false;
            crdnplJunctionItem = new CRD_NPL_Junction__c();  
            crdnpldlitem = new drug_list__c();
        } 
    }      
}