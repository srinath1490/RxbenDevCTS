/*Purpose: Apex Class for VFP_CRDClinicalProgPriorAuth1 page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay Arora                  10/22/2011       Apex Class for VFP_CRDClinicalProgPriorAuth1 page.
     1.1 -   Rahul Nasa                   08/28/2013       Request 1121.
     1.3 -   Amit Jain                    10/03/2013       Request 1193
     2.0     Sushant Sethi                02/25/2014       Added Comments
     2.1     Joognu Rao                   03/25/2014        Request 4288
     2.2     Joognu Rao                   04/11/2014        Request 4676
     2.3     Abhishek Goel                02/12/2015        Request 05558
     3.0     Amit Jain                    18 May 2015       Addedlogic for Formulary Plus extension, request 5755
     3.1     Richa Gupta                  18th Dec 2015     Added field PR_Safety_Edits_Drug_List__c in CRD query
     3.2     Raj Prasad                   26th Oct 2016     Request 6729
======================================================================== 
*/
public with sharing class VFP_CRDClinicalProgPriorAuth1Controller {

    Public CRD__c crd {
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
    public list < String > errorMessages {
        get;
        set;
    }
    public list < webPriorAuthWrapper > webPriorAuthUsers {
        get;
        set;
    }
    public boolean isRdsPanelSelected {
        get;
        set;
    }
    public boolean isCustomPresetClassesSelected {
        get;
        set;
    }
    public Drug_List__c drugList {get;set;}

    set < Id > wrapperId = new set < Id > ();
    list < CRD_PriorAuth_Junction__c > lstPriorAuthUser;
    public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';    
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING ARSPAGE = '/apex/VF_AetnaRxStepJunction?crdid=';
    PRIVATE STATIC FINAL STRING STPAGE = '/apex/VF_CRDStepTherepy?crdid=';
    PRIVATE STATIC FINAL STRING PAPAGE = '/apex/VF_CRDClinicalProgPriorAuth2?id=';
    PRIVATE STATIC FINAL STRING CURRENTPAGE = 'currentPageName';
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING NO = 'No';
    PRIVATE STATIC FINAL STRING SI = 'Self Insured';
    PRIVATE STATIC FINAL STRING V2 = 'PA Drug List(s)';
    PRIVATE STATIC FINAL STRING V1 = 'PA Drug Group';  
    private static final string LGPREMIERPLUS = 'LG Premier Plus'; 
    set<string> lstToAvoidSamePC = new set<string>();
    set<string> DLinDatabase = new set<string>();
    private static final string LGPREMIER = 'LG Premier';
    private static final string PRECERTTOCDL = 'DL-0076037';
    BOOLEAN hasChanged = false;
    public List<CRD_PriorAuth_Junction__c> PrioAuthList{get;set;} //Added by Raj for Request 6729
/**
* Method :- VFP_CRDClinicalProgPriorAuth1Controller
* Description :- Fetch CRDID for VFP_CRDClinicalProgPriorAuth1 page.
**/
    public VFP_CRDClinicalProgPriorAuth1Controller(ApexPages.StandardController controller) {
        this.crd = (CRD__c) controller.getRecord();
        /********** Start***************
        added by abhishek date on 02/12/2015 for request 05558***/      
        crd = [Select c.Name,c.Contract_State__c ,Do_you_want_to_do_Step_Therapy__c, c.Integrate_with_Medical__c, c.Insured_Type__c, c.Do_you_want_to_do_Precert__c,c.Is_there_split_fill__c, c.Y_Schd__c, c.Plan_Type_Paper__c, c.Standard_Precert_List_or_Select_Classes__c, c.Precert_TOC_days__c, c.Standard_Precert_Program__c, c.Custom_Precert_Classes__c, c.Approved_from_CustFormulary_Committee_PA__c, c.Custom_Precert_Date_Approved__c, c.Opt_out_of_Safety_Edits__c
        From CRD__c c
        Where c.ID = : this.crd.id LIMIT 1];
        /**********END***************
        added by abhishek date on 02/12/2015 for request 05558***/      

        crdId = crd.id;
        //Added by raj for Request 6729 Start
        PrioAuthList = [select id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories 
                                   where Field NOT IN('created') order by Createddate desc), 
                        Precert_Class__c,Precert_Class__r.name, Precert_Class__r.Drug_List_Name__c, Precert_Class__r.Description__c
                        from CRD_PriorAuth_Junction__c where CRD_ID__c != null AND CRD_ID__c = : crd.Id limit 1000];
        //Added by raj for Request 6729 End
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        webPriorAuthUsers = new list < webPriorAuthWrapper > ();
        errorMessages = new list < String > ();
        lstPriorAuthUser = new list < CRD_PriorAuth_Junction__c > ();
        lstPriorAuthUser = [Select Id, IsAutoPopulated__c,CRD_ID__c, Precert_Class__c,Precert_Class__r.name, Precert_Class__r.Drug_List_Name__c, Precert_Class__r.Description__c
        From CRD_PriorAuth_Junction__c
        Where CRD_ID__c = : this.crd.id LIMIT 80000];
 /*       List <ST_PA_QL_Auto_Populate__c> stpaqllist;
        if(crd.Contract_State__c!='TX'){
            stpaqllist= new List<ST_PA_QL_Auto_Populate__c>([Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c from ST_PA_QL_Auto_Populate__c where  Record_Type__c='Precert' and What_is_the_Funding_Type__c includes (:crd.Insured_Type__c) and (AllStates__c=true OR ExcludeTexas__c=true)]);
        }else{
            stpaqllist= new List<ST_PA_QL_Auto_Populate__c>([Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c from ST_PA_QL_Auto_Populate__c where Record_Type__c='Precert' and What_is_the_Funding_Type__c includes (:crd.Insured_Type__c) and(Contract_State__c includes ('TX') OR AllStates__c=true)]);
        }
         for(ST_PA_QL_Auto_Populate__c masterDataItem: stpaqllist){
             string str = masterDataItem.What_is_the_Funding_Type__c;  
                string[] strFundingType = str.split(';');               
                boolean isSelfInsured=false;
                boolean isFullyInsured=false;
                boolean isSplitFunded=false;
                           CRD_PriorAuth_Junction__c paJunctionRecord= new CRD_PriorAuth_Junction__c();
                    paJunctionRecord.Precert_Class__c=masterDataItem.Drug_List__c;
                    webPriorAuthWrapper wrap = new webPriorAuthWrapper();
                    wrap.PriorAuth = paJunctionRecord;
                    webPriorAuthUsers.add(wrap);            
         }
*/
        for (CRD_PriorAuth_Junction__c usr: lstPriorAuthUser) {
            webPriorAuthWrapper wrap = new webPriorAuthWrapper();
            wrap.PriorAuth = usr;
            webPriorAuthUsers.add(wrap);
            lstToAvoidSamePC.add(usr.Precert_Class__r.name);            
        }
        /**-----------------start------------------------------
        added by abhishek date on 02/12/2015 for request 05558*/
        searchSplitFillDrugListID();
        /**---------------END
        added by abhishek date on 02/12/2015 for request 05558---*/
    }
    /**
    * Start:- added by abhishek date on 02/12/2015 for request 05558
    * Method :- searchSplitFillDrugListID
    * Description :- To fetch the drug list id.
    **/
    Public void searchSplitFillDrugListID() {
         String splitFillDrugValue = System.Label.DCSRT49;
        if (YES.equalsIgnoreCase(crd.Is_there_split_fill__c)) {
            if(splitFillDrugValue!='' && splitFillDrugValue!=null){
                drugList = [select Name, Drug_List_Name__c,Description__c from Drug_List__c where id =: splitFillDrugValue LIMIT 80000];
            }
            
        }

    }
   /****************End***********************
   added by abhishek date on 02/12/2015 for request 05558*/
 /**
* Method :- redirectToStepTherepy2
* Description :- Redirect to StepTherepy page for ReadOnly Mode
**/  
  Public PageReference redirectToStepTherepy2(){
      try{
      if(SI.equalsIgnoreCase(crd.Insured_Type__c) && NO.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c)){ // modified by JR to implement request 4676
                    Pagereference pageRef = new Pagereference(ARSPAGE + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                }else{
                    Pagereference pageRef = new Pagereference(STPAGE + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                } 
  } catch(exception e){return null;}
    }
/**
* Method :- redirectToStepTherepy
* Description :- Redirect to StepTherepy page.
**/
    Public PageReference redirectToStepTherepy() {
        try{
        //Richa added on 12/8 for Req 5036
        if (crd.Do_you_want_to_do_Precert__c != YES) {
            //Added and commented by JR on 18/11/2014
            //crd.Precert_TOC_days__c = null;
            crd.Precert_TOC_days__c = 0;
        }
        database.update(crd);
        errorMessages.clear();
        list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
        listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
            if(!listDC.isempty()){
                if(crd.Precert_TOC_days__c != null && crd.Precert_TOC_days__c != 0){
                    errormessages.add(System.Label.ERR0256);
                    return null;    
                }
            }//till here
       // Pagereference pageRef = new Pagereference(STPAGE + crdId);
       // return pageRef;
       // modified by JR for request no 4288
         if(SI.equalsIgnoreCase(crd.Insured_Type__c) && NO.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c)){ // modified by JR to implement request 4676
                    Pagereference pageRef = new Pagereference(ARSPAGE + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                }else{
                    Pagereference pageRef = new Pagereference(STPAGE + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                } 
    }catch(exception e){return null;}
    }
/**
* Method :- redirectToClinicalProgPriorAuth22
* Description :- Redirect to redirectToClinicalProgPriorAuth2 page for ReadOnly Mode
**/
    Public PageReference redirectToClinicalProgPriorAuth22(){
        try{
        Pagereference pageRef = new Pagereference(PAPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
/**
* Method :- redirectToClinicalProgPriorAuth2
* Description :- Redirect to redirectToClinicalProgPriorAuth2 page.
**/
    Public PageReference redirectToClinicalProgPriorAuth2() {
      errorMessages.clear();
        try {

             //else{
            //  crd.Precert_TOC_days__c=null;
            // elear extra data on change of picklist value
            if (crd.Do_you_want_to_do_Precert__c != YES) {
                //crd.Standard_Precert_List_or_Select_Classes__c = null;Richa commented for Req 6345
               //Added and commented by JR on 18/11/2014
                //crd.Precert_TOC_days__c = null;
                crd.Precert_TOC_days__c = 0;
                crd.Standard_Precert_Program__c = null;
                
                /*webPriorAuthUsers = Null;
                webPriorAuthUsers = new List < webPriorAuthWrapper > ();
                List < CRD_PriorAuth_Junction__c > precertJunction = new List < CRD_PriorAuth_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_PriorAuth_Junction__c where CRD_ID__c = : crd.Id LIMIT 80000]);
                database.delete(precertJunction);*/
            } else {
                if (crd.Standard_Precert_List_or_Select_Classes__c != V2) {
                   
                    webPriorAuthUsers = Null;
                    webPriorAuthUsers = new List < webPriorAuthWrapper > ();
                    List < CRD_PriorAuth_Junction__c > precertJunction = new List < CRD_PriorAuth_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_PriorAuth_Junction__c where CRD_ID__c = : crd.Id LIMIT 80000]);
                    database.delete(precertJunction);
                }
                if (crd.Standard_Precert_List_or_Select_Classes__c != V1) {
                    crd.Standard_Precert_Program__c = Null;
                   
                }
            }
            database.update(crd);
            //Richa added on 12/8 for Req 5036
            list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
            listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
            if(!listDC.isempty()){
                if(crd.Precert_TOC_days__c != null && crd.Precert_TOC_days__c != 0){
                    errormessages.add(System.Label.ERR0256);
                    return null;    
                }
            }//till here
            list < CRD_PriorAuth_Junction__c > lstNewWebuser = new List < CRD_PriorAuth_Junction__c > ();
            if(hasChanged){
                lstNewWebuser = [Select Id From CRD_PriorAuth_Junction__c Where CRD_ID__c = : this.crd.id LIMIT 80000]; 
                if(lstNewWebuser.size()>0){
                    Database.delete (lstNewWebuser,false);
                }
            }lstNewWebuser.clear();
            if (webPriorAuthUsers != null && webPriorAuthUsers.size() > 0) {
                for (webPriorAuthWrapper usr: webPriorAuthUsers) {
                   if(usr.PriorAuth.Precert_Class__c != null){                
                    CRD_PriorAuth_Junction__c pauser = new CRD_PriorAuth_Junction__c(id = usr.PriorAuth.id);
                    pauser.isAutopopulated__c= usr.PriorAuth.isAutopopulated__c;
                    pauser.Precert_Class__c = usr.PriorAuth.Precert_Class__c;
                    pauser.CRD_ID__c = crdId;
                    lstNewWebuser.add(pauser);
                    }else if(usr.PriorAuth.Precert_Class__c == null){
                      errormessages.add(System.Label.ERR00229);
                      return null;

                     }                   
                }

                if (lstNewWebuser != null && lstNewWebuser.size() > 0) {
                    database.upsert(lstNewWebuser);
                }
            }
            //Deleting the existing data based on user selection
            if (wrapperId.size() > 0) {
                List < CRD_PriorAuth_Junction__c > deleteJunction = new List < CRD_PriorAuth_Junction__c > ([Select Id, IsAutoPopulated__c,Name from CRD_PriorAuth_Junction__c where id In: wrapperId LIMIT 80000]);
                database.delete(DeleteJunction);
            }

        } catch (exception e) {

            return null;
        }

        Pagereference pageRef = new Pagereference(PAPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }

/**
* Method :- isPrecertNeeded
* Description :- Method on is precert needed field
**/
    public pageReference isPrecertNeeded() {
        try{
        hasChanged = true;
        Boolean ProcessCommercialFormulary = true;
        //if(crd.Do_you_want_to_do_Precert__c!=YES){
           //crd.Standard_Precert_List_or_Select_Classes__c = null;Richa commented for Req 6345
           webPriorAuthUsers = Null;
            webPriorAuthUsers = new List < webPriorAuthWrapper > ();
            lstToAvoidSamePC.clear();
        //}else{
        //ProcessCommercialFormulary = True;
        if(crd.Do_you_want_to_do_Precert__c==YES){
            crd.Precert_TOC_days__c = 90;}else {crd.Precert_TOC_days__c = 0;}
        crd.Standard_Precert_Program__c = null;
        if(webPriorAuthUsers.size()!=0){
            webPriorAuthUsers = new list<webPriorAuthWrapper>();
        }
        set<ID> formularyID = new set<ID>();
            Set<String> dlPrecert = new Set<String>();
            Set<String> prSafetyEdit = new Set<String>();
            String formularyGroup;
            for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name, Formulary_Group__c from Drug_Coverage__c where CRD_ID__c = : crd.Id LIMIT 80000]){
                formularyID.add(dcRecord.Formulary__c);
                formularyGroup = dcRecord.Formulary_Group__c;
            }
            for(FormularyXCustomDL_ERD__c formulayCustom: [Select Id, name,Aetna_Specialty_Care_Rx__c, Formulary__c, Override_Refill_Too_Soon__c, Precert__c
                                                                    , Quantity_Limit__c,Secondary_of_fills_before_Force_to_SPN__c, Secondary_Aetna_Specialty_Care_Rx__c 
                                                                    , Secondary_Specialty_Drug_List__c,Specialty_Drug_List__c, Step_Therapy__c,Secondary_Specialty_Drug_List_ID__c
                                                                    , NPL_List__c, PR_Safety_Edits__r.name, QL_Safety_Edits__r.name
                                                           From 
                                                                FormularyXCustomDL_ERD__c
                                                           Where 
                                                               Formulary__c In: formularyID LIMIT 80000]){
                    ProcessCommercialFormulary = False;
                    if(LGPREMIER.equalsIgnoreCase(formularyGroup) && crd.Precert_TOC_days__c > 1 ){            
                        if(!lstToAvoidSamePC.contains(PRECERTTOCDL)){
                            dlPrecert.add(PRECERTTOCDL);
                            lstToAvoidSamePC.add(PRECERTTOCDL);
                        }
                    }
                    if(formulayCustom.Precert__c != Null && !(LGPREMIERPLUS.equalsIgnoreCase(formularyGroup ) && YES.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c)) && (!LGPREMIERPLUS.equalsIgnoreCase(formularyGroup ) && YES.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c))){
                      String[] precertDrugLists = formulayCustom.Precert__c.split(';');
                      for(String drugListprecert : precertDrugLists){
                            if(!lstToAvoidSamePC.contains(drugListprecert)){
                                dlPrecert.add(drugListprecert);
                                lstToAvoidSamePC.add(drugListprecert);
                            }
                        }
                    }
                    if(formulayCustom.PR_Safety_Edits__r.name != Null && (lstToAvoidSamePC.size() == 0 || !lstToAvoidSamePC.contains(formulayCustom.PR_Safety_Edits__r.name)) ){
                        prSafetyEdit.add(formulayCustom.PR_Safety_Edits__r.name);
                        lstToAvoidSamePC.add(formulayCustom.PR_Safety_Edits__r.name);
                    }
             CRD_PriorAuth_Junction__c paJunctionRecord;
             for(Drug_List__c dlrecord: [Select Id,Name from Drug_List__c where Name =:prSafetyEdit LIMIT 80000]){
                    paJunctionRecord= new CRD_PriorAuth_Junction__c();
                    paJunctionRecord.IsAutoPopulated__c = True;
                    paJunctionRecord.Precert_Class__c = dlrecord.id;
                    webPriorAuthWrapper wrap = new webPriorAuthWrapper();
                    wrap.PriorAuth = paJunctionRecord;
                    webPriorAuthUsers.add(wrap);
                    lstToAvoidSamePC.add(dlrecord.name);
             }
             if(!dlPrecert.isEmpty() && !LGPREMIERPLUS.equalsIgnoreCase(formularyGroup)){
                for(Drug_List__c dlrecord: [Select Id,Name from Drug_List__c where  Name =: dlPrecert LIMIT 80000]){
                    paJunctionRecord= new CRD_PriorAuth_Junction__c();
                    paJunctionRecord.Precert_Class__c=dlrecord.id;
                    paJunctionRecord.IsAutoPopulated__c= True;
                    webPriorAuthWrapper wrap = new webPriorAuthWrapper();
                    wrap.PriorAuth = paJunctionRecord;
                    webPriorAuthUsers.add(wrap); 
                    lstToAvoidSamePC.add(dlrecord.name);
                }    
             }
        }
         if(ProcessCommercialFormulary && crd.Do_you_want_to_do_Precert__c==YES){     
            List <ST_PA_QL_Auto_Populate__c> stpaqllist;
           CRD_PriorAuth_Junction__c paJunctionRecord;
       
            stpaqllist= new List<ST_PA_QL_Auto_Populate__c>([Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c from ST_PA_QL_Auto_Populate__c where  Record_Type__c='Precert' and What_is_the_Funding_Type__c includes (:crd.Insured_Type__c) and contract_state__c includes (:crd.contract_state__c) LIMIT 80000]);
            for(ST_PA_QL_Auto_Populate__c masterDataItem: stpaqllist){
                string str = masterDataItem.What_is_the_Funding_Type__c;  
                string[] strFundingType = str.split(';');               
                boolean isSelfInsured=false;
                boolean isFullyInsured=false;
                boolean isSplitFunded=false;
                paJunctionRecord= new CRD_PriorAuth_Junction__c();
                paJunctionRecord.Precert_Class__c=masterDataItem.Drug_List__c;
                paJunctionRecord.IsAutoPopulated__c= True;
                webPriorAuthWrapper wrap = new webPriorAuthWrapper();
                wrap.PriorAuth = paJunctionRecord;
                webPriorAuthUsers.add(wrap);            
            }
                   
        }if((ProcessCommercialFormulary ||crd.Standard_Precert_List_or_Select_Classes__c =='PA Drug Group')&& crd.Do_you_want_to_do_Precert__c!=YES){
            List < CRD_PriorAuth_Junction__c > precertJunction = new List < CRD_PriorAuth_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_PriorAuth_Junction__c where CRD_ID__c = : crd.Id LIMIT 80000]);
            database.delete(precertJunction);
            webPriorAuthUsers.clear();
            crd.Precert_TOC_days__c = 0;
            crd.Standard_Precert_List_or_Select_Classes__c = null;
        }
     
      //}  
      return null;
    }
    catch(exception e){return null;}
    }

/**
* Method :- AddNewUser
* Description :- Method to add a new instance of Wrapper to list of dynamic input sections
**/        
    public PageReference addNewUser() {
        try{
        webPriorAuthWrapper wrap = new webPriorAuthWrapper();
        webPriorAuthUsers.add(wrap);
        return null;
    }catch(exception e){return null;}
    }

/**
* Method :- deleteSelectedUser
* Description :- Method to remove the selected rows from the web user panel
**/
    public PageReference deleteSelectedUser() {
    try{
     list < webPriorAuthWrapper > tempPriorAuthUsers = new list < webPriorAuthWrapper > ();

        if (webPriorAuthUsers != null && webPriorAuthUsers.size() > 0) {
            for (integer i = 0; i < webPriorAuthUsers.size(); i++) {

                if (webPriorAuthUsers[i].isMarkedForDeletion == true) {
                    wrapperId.add(webPriorAuthUsers[i].PriorAuth.Id);
                } else {
                    tempPriorAuthUsers.add(webPriorAuthUsers[i]);
                }
            }
            webPriorAuthUsers = tempPriorAuthUsers;
        }
        return null;
    }catch(exception e){return null;}
    }

/**
* Class :- webPriorAuthWrapper
* Description :-  Wrapper Class To Create dynamic inputs
**/   
    public class WebPriorAuthWrapper {
        public CRD_PriorAuth_Junction__c PriorAuth {
            get;
            set;
        }
        public boolean isMarkedForDeletion {
            get;
            set;
        }
/**
* Method :- webPriorAuthWrapper
* Description :-  Method To Create dynamic inputs
**/
        public webPriorAuthWrapper() {
            CRD_PriorAuth_Junction__c usr = new CRD_PriorAuth_Junction__c();
            PriorAuth = usr;
        }

    }
/**
* Method :- updateFields
* Description :-  Method To Create dynamic inputs
**/
    Public void updateFields() {
        if (V1.equalsIgnoreCase(crd.Standard_Precert_List_or_Select_Classes__c)) {
            database.delete(lstPriorAuthUser);
            webPriorAuthUsers.clear();
        } else if (V2.equalsIgnoreCase(crd.Standard_Precert_List_or_Select_Classes__C)) {
            crd.Standard_Precert_Program__c = null;
        }
    }

}