/*Purpose: Apex Class for VFP_CRDQuantityLimits Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 10/22/2011       Apex Class for VFP_CRDQuantityLimits Page.
     1.2 -   Rahul                 28/08/2013       Request No. 1122
     2.0     Amit jain             18 May 2015      Added logic for Formulary plus Extension, request 5755
     2.1 -   Richa Gupta           18th Dec 2015    Added field QL_Safety_Edits_Drug_List__c in CRD query for Req 6257
     2.2     Bhaskar Arora         04/11/2016       Added as per request 06730
======================================================================== 
*/
public with sharing class VFP_CRDQuantityLimitsController {
     Private Id tempStandardPrecertProgram;
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
    set < Id > wrapperId = new set < Id > ();
    public boolean isCustomPresetClassesSelected {
        get;
        set;
    }
    public list < quantityLimitWrapper > lstQuantityLimitsJunction {
        get;
        set;
    }
    public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CURRENTPAGE = 'currentPageName';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING NO = 'No';
    PRIVATE STATIC FINAL STRING PAPAGE = '/apex/VF_CRDClinicalProgPriorAuth2?id=';
    PRIVATE STATIC FINAL STRING SEPAGE = '/apex/VF_SafetyEditPrograms?crdid=';
    PRIVATE STATIC FINAL STRING QLDG = 'QL Drug Group';
    PRIVATE STATIC FINAL STRING QLDL = 'QL Drug List(s)';
    private static final string LGPREMIERPLUS = 'LG Premier Plus';
    private static final string YESLABEL = 'Yes';
    boolean hasChanged = false;
    public List<CRD_Quantity_Limit_Junction__c> quantityLimitJunctionList{get;set;}
    
    /*Constructor for CRD QL Page Screen*/
    public VFP_CRDQuantityLimitsController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        crd = [Select Name,Contract_state__c,Standard_Precert_Program__c, Aetna_Rx_Healthy_Outcomes__c, Precert_TOC_days__c, Quantity_Limit_TOC_of_Days__c, Approved_from_CustFormulary_Committee_QL__c, Custom_Step_Therapy_Date_Approved_QL__c, Custom_Quantity_Limits_Classes__c, Standard_QL_Program__c, Standard_QL_List_or_Select_Classes__c, Are_there_Quantity_Limits__c, Integrate_with_Medical__c, Plan_Type_Paper__c, Insured_Type__c, Y_Schd__c,Do_you_want_to_do_Precert__c From CRD__c Where ID = : crdId LIMIT 80000];
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        lstQuantityLimitsJunction = new list < quantityLimitWrapper > ();
        quantityLimitJunctionList=[Select Id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories 
                                              where Field NOT IN('created') order by Createddate desc),  IsAutoPopulated__c,CRD_ID__c, QL_Class__c,QL_Class__r.Name, QL_Class__r.Drug_List_Name__c, QL_Class__r.Description__c
                                   From CRD_Quantity_Limit_Junction__c
                                   Where CRD_ID__c = : this.crd.id LIMIT 1000];
        list < CRD_Quantity_Limit_Junction__c > lstQlJunction = new list < CRD_Quantity_Limit_Junction__c > ();
        lstQlJunction = [Select Id, IsAutoPopulated__c,CRD_ID__c, QL_Class__c, QL_Class__r.Drug_List_Name__c, QL_Class__r.Description__c
        From CRD_Quantity_Limit_Junction__c
        Where CRD_ID__c = : this.crd.id LIMIT 8000];
        for (CRD_Quantity_Limit_Junction__c ql: lstQlJunction) {
            quantityLimitWrapper wrap = new quantityLimitWrapper();
            wrap.QLJUNCTION = ql;
            lstQuantityLimitsJunction.add(wrap);
        }
        errorMessages = new list < String > ();
        tempStandardPrecertProgram=crd.Standard_Precert_Program__c;
    }
    /*Method to handle QL Junction records*/
    public pageReference areQuantityLimitsNeeded() {
      try{
          hasChanged = true;
          set<CRD_Quantity_Limit_Junction__c> alreadyAddedQL = new set<CRD_Quantity_Limit_Junction__c>([Select Id,QL_Class__r.name from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
          set<string> dupQL = new set <string>();
        Boolean processCommercialFormulary = false;
        if(crd.Are_there_Quantity_Limits__c!=YES){
           //crd.Standard_QL_List_or_Select_Classes__c = null;Richa commented for Req 6345
           lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
           for(CRD_Quantity_Limit_Junction__c temp : alreadyAddedQL){
                wrapperId.add(temp.id);
            }
        }else{ 
           processCommercialFormulary = True;                    
           crd.Standard_Precert_Program__c = tempStandardPrecertProgram;
           crd.Standard_QL_Program__c = null;
           for(CRD_Quantity_Limit_Junction__c temp : alreadyAddedQL){
                dupQL.add(temp.QL_Class__r.name);
            }
         }
          if(lstQuantityLimitsJunction!=null && lstQuantityLimitsJunction.size() > 0)  
              lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
          //if(lstQuantityLimitsJunction.size()==0){
            set<ID> formularyID = new set<ID>();
            Set<String> dlQuantityLimit = new Set<String>();
            Set<String> qlSafetyEdit = new Set<String>();
            String formularyGroup;
            for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name,Formulary_Group__c from Drug_Coverage__c where CRD_ID__c = : crd.Id]){
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
                                                               Formulary__c In: formularyID]){
                    ProcessCommercialFormulary = False;                                             
                    if(formulayCustom.Quantity_Limit__c != Null && YESLABEL.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c)){
                        String[] qlDrugLists = formulayCustom.Quantity_Limit__c.split(';');
                        for(String drugListQL : qlDrugLists){
                            if(!dupQL.contains(drugListQL)){
                                dlQuantityLimit.add(drugListQL);
                                dupQL.add(drugListQL);
                            }
                        }
                    }
                    if(formulayCustom.QL_Safety_Edits__r.name != Null && !dupQL.contains(formulayCustom.QL_Safety_Edits__r.name)){
                        qlSafetyEdit.add(formulayCustom.QL_Safety_Edits__r.name);
                        dupQL.add(formulayCustom.QL_Safety_Edits__r.name);
                    }
             }
             //CRD_Quantity_Limit_Junction__c newQuantityLimitRecord ;
             if(!(LGPREMIERPLUS.equalsIgnoreCase(formularyGroup) && YESLABEL.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c))){
                for(Drug_List__c dlrecord : [Select Id,Name from Drug_List__c where  Name =: qlSafetyEdit]){
                    CRD_Quantity_Limit_Junction__c qlJunctionRecord= new CRD_Quantity_Limit_Junction__c ();
                    qlJunctionRecord.QL_Class__c=dlrecord.id;
                    qlJunctionRecord.IsAutoPopulated__c = True;
                    quantityLimitWrapper wrap = new quantityLimitWrapper ();
                    wrap.QLJUNCTION = qlJunctionRecord;
                    lstQuantityLimitsJunction.add(wrap);
                }
             }
             if(!dlQuantityLimit.isEmpty() && YESLABEL.equalsIgnoreCase(crd.Do_you_want_to_do_Precert__c) && !LGPREMIERPLUS.equalsIgnoreCase(formularyGroup)){
                for(Drug_List__c dlrecord: [Select Id,Name from Drug_List__c where  Name =: dlQuantityLimit ]){
                    CRD_Quantity_Limit_Junction__c qlJunctionRecord= new CRD_Quantity_Limit_Junction__c ();
                    qlJunctionRecord.QL_Class__c=dlrecord.id;
                    qlJunctionRecord.IsAutoPopulated__c = True;
                    quantityLimitWrapper wrap = new quantityLimitWrapper ();
                    wrap.QLJUNCTION = qlJunctionRecord;
                    lstQuantityLimitsJunction.add(wrap);
                }    
             }else if(ProcessCommercialFormulary){   
            //Added by Sushant Req 1155 /* Start */
         List <ST_PA_QL_Auto_Populate__c> stpaqllist;
            stpaqllist= new List<ST_PA_QL_Auto_Populate__c>([Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c from ST_PA_QL_Auto_Populate__c where  Record_Type__c='Quantity Limit' and What_is_the_Funding_Type__c includes (:crd.Insured_Type__c) and contract_state__c includes(:crd.contract_state__c)]);
        
         for(ST_PA_QL_Auto_Populate__c masterDataItem: stpaqllist){
             string str = masterDataItem.What_is_the_Funding_Type__c;  
             string[] strFundingType = str.split(';');               
             boolean isSelfInsured=false;
             boolean isFullyInsured=false;
             boolean isSplitFunded=false;
             CRD_Quantity_Limit_Junction__c qlJunctionRecord= new CRD_Quantity_Limit_Junction__c ();
             qlJunctionRecord.QL_Class__c=masterDataItem.Drug_List__c;
             qlJunctionRecord.IsAutoPopulated__c = True;
             quantityLimitWrapper wrap = new quantityLimitWrapper ();
             wrap.QLJUNCTION = qlJunctionRecord;
             lstQuantityLimitsJunction.add(wrap);
         }  
             }
        /* End */
      //}
        return null;
    }catch (Exception e) {
            return null;
        }
    }
    /*Method to add new QL*/
    public PageReference addNewQl() {
        try
        {
            quantityLimitWrapper wrap = new quantityLimitWrapper();
        lstQuantityLimitsJunction.add(wrap);
        return null;
        }catch (Exception e) {
            return null;
        }
    }
    /*Method to redirect to CRD PA Screen for next button story*/
    public PageReference returnToCrdPriorAuth2(){
        try{
            Pagereference pageRef = new Pagereference(PAPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }catch (Exception e) {
            return null;
        }
    }
    /*Method to redirect to CRD PA Screen*/
    public PageReference returnToCrdPriorAuth() {
        errorMessages.clear();
        try {
            if(hasChanged){
            if (crd.Are_there_Quantity_Limits__c != YES) {
                
                crd.Standard_QL_Program__c = null;
                //crd.Standard_QL_List_or_Select_Classes__c = null;Richa commented for Req 6345
               //Added and commented by JR on 18/11/2014
                //crd.Quantity_Limit_TOC_of_Days__c = null;
                crd.Quantity_Limit_TOC_of_Days__c = 0;
                /*lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
                List < CRD_Quantity_Limit_Junction__c > qlJunction = new List < CRD_Quantity_Limit_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
                database.delete(qlJunction);*/
            }
            if (crd.Standard_QL_List_or_Select_Classes__c != null && crd.Standard_QL_List_or_Select_Classes__c != QLDG) {
                crd.Standard_QL_Program__c = null;
            }

            if (crd.Standard_QL_List_or_Select_Classes__c != null && crd.Standard_QL_List_or_Select_Classes__c != QLDL) {
                lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
                List < CRD_Quantity_Limit_Junction__c > qlJunction = new List < CRD_Quantity_Limit_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
                database.delete(qlJunction);
            }
           Database.Update(crd);
           //Richa added on 12/8 for Req 5036
            list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
            listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
            if(!listDC.isempty()){
                if(crd.Quantity_Limit_TOC_of_Days__c != null && crd.Quantity_Limit_TOC_of_Days__c != 0){
                    errormessages.add(System.Label.ERR0257);
                    return null;    
                }
            }//till here
            list < CRD_Quantity_Limit_Junction__c > lstNewQl = new List < CRD_Quantity_Limit_Junction__c > ();

            List < CRD_Quantity_Limit_Junction__c > qlJunction = new List < CRD_Quantity_Limit_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
            if (qlJunction != null && qlJunction.size() > 0) {
                database.delete(qlJunction);
            }
            if (lstQuantityLimitsJunction != null && lstQuantityLimitsJunction.size() > 0) {
                for (quantityLimitWrapper ql: lstQuantityLimitsJunction) {
                    CRD_Quantity_Limit_Junction__c newQl = new CRD_Quantity_Limit_Junction__c();
                    newQl.QL_Class__c = ql.QLJUNCTION.QL_Class__c;
                    newQl.IsAutoPopulated__c = ql.QLJUNCTION.IsAutoPopulated__c;
                    newQl.CRD_ID__c = crdId;
                    lstNewQl.add(newQl);
                }

                if (lstNewQl != null && lstNewQl.size() > 0) {
                    database.insert(lstNewQl);
                }
            }
            }
        } catch (Exception e) {
            return null;
        }
        Pagereference pageRef = new Pagereference(PAPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
    /*QL Wrapper to hold QL Junction Records*/
    public class QuantityLimitWrapper {
        public CRD_Quantity_Limit_Junction__c qLJUNCTION {
            get;
            set;
        }

        public boolean isMarkedForDeletion {
            get;
            set;
        }
        /*Method to hold QL Records*/
        public quantityLimitWrapper() {
            CRD_Quantity_Limit_Junction__c qL = new CRD_Quantity_Limit_Junction__c();
            QLJUNCTION = qL;
        }

    }

    /*Method to delete QL records selected*/
    public PageReference deleteSelectedQl() {
        try{
            list < quantityLimitWrapper > tempQlJunction = new list < quantityLimitWrapper > ();

        if (lstQuantityLimitsJunction != null && lstQuantityLimitsJunction.size() > 0) {
            for (integer i = 0; i < lstQuantityLimitsJunction.size(); i++) {
                if (lstQuantityLimitsJunction[i].isMarkedForDeletion != true) {
                    tempQlJunction.add(lstQuantityLimitsJunction[i]);
                } else {
                    wrapperId.add(lstQuantityLimitsJunction[i].QLJUNCTION.Id);
                }
            }
            lstQuantityLimitsJunction = tempQlJunction;
        }
        return null;
    }catch (Exception e) {
            return null;
        }
    }
    /*Method to redirect to QL Screen for Next Button Story*/
    public pageReference saveQuantityLimits2(){
        try{
            Pagereference pageRef = new Pagereference(SEPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch (Exception e) {
            return null;
        }
    }
    /*Method to redirect to QL Screen*/
    public pagereference saveQuantityLimits() {
       errorMessages.clear();    
        try {

            if (crd.Are_there_Quantity_Limits__c != YES) {
               
                crd.Standard_QL_Program__c = null;
                //crd.Standard_QL_List_or_Select_Classes__c = null;Richa commented for Req 6345
                //Added and commented by JR on 18/11/2014
                //crd.Quantity_Limit_TOC_of_Days__c = null;
                crd.Quantity_Limit_TOC_of_Days__c = 0;
                /*lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
                List < CRD_Quantity_Limit_Junction__c > qlJunction = new List < CRD_Quantity_Limit_Junction__c > ([select Id,IsAutoPopulated__c, Name, CRD_ID__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
                database.delete(qlJunction);*/
            }
            
            if (crd.Standard_QL_List_or_Select_Classes__c != null && crd.Standard_QL_List_or_Select_Classes__c != QLDG) {
                crd.Standard_QL_Program__c = null;
            }

            if (crd.Standard_QL_List_or_Select_Classes__c != null && crd.Standard_QL_List_or_Select_Classes__c != QLDL) {
                lstQuantityLimitsJunction = new List < quantityLimitWrapper > ();
                List < CRD_Quantity_Limit_Junction__c > qlJunction = new List < CRD_Quantity_Limit_Junction__c > ([select Id, IsAutoPopulated__c,Name, CRD_ID__c from CRD_Quantity_Limit_Junction__c where CRD_ID__c = : crd.Id]);
                database.delete(qlJunction);
            }
            //Richa added on 12/8 for Req 5036
            list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
            listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
            if(!listDC.isempty()){
                if(crd.Quantity_Limit_TOC_of_Days__c != null && crd.Quantity_Limit_TOC_of_Days__c != 0){
                    errormessages.add(System.Label.ERR0257);
                    return null;    
                }
            }//till here
            if (crd.Are_there_Quantity_Limits__c != null && crd.Are_there_Quantity_Limits__c != NO && crd.Quantity_Limit_TOC_of_Days__c != crd.Precert_TOC_days__c) {
                crd.Quantity_Limit_TOC_of_Days__c.addError(system.Label.ERR00142 + ' ' + crd.Precert_TOC_days__c + '. ' + system.Label.ERR00143);
                return null;
            }
            Database.Update(crd);
            list < CRD_Quantity_Limit_Junction__c > lstNewQl = new List < CRD_Quantity_Limit_Junction__c > ();


            if (lstQuantityLimitsJunction != null && lstQuantityLimitsJunction.size() > 0) {
                for (quantityLimitWrapper ql: lstQuantityLimitsJunction) {
                    if(ql.QLJUNCTION.QL_Class__c != null){ 
                    CRD_Quantity_Limit_Junction__c newQl = new CRD_Quantity_Limit_Junction__c(id = ql.QLJUNCTION.id);
                    newQl.QL_Class__c = ql.QLJUNCTION.QL_Class__c;
                    newQl.IsAutoPopulated__c = ql.QLJUNCTION.IsAutoPopulated__c;
                    newQl.CRD_ID__c = crdId;
                    lstNewQl.add(newQl);
                    }else if(ql.QLJUNCTION.QL_Class__c == null){
                      errormessages.add(System.Label.ERR00230);
                      return null;
                    }
                }


                if (lstNewQl != null && lstNewQl.size() > 0) {
                    database.upsert(lstNewQl);
                }

            }

            //Deleting the existing data based on user selection
            if (wrapperId.size() > 0) {
                List < CRD_Quantity_Limit_Junction__c > deleteJunction = new List < CRD_Quantity_Limit_Junction__c > ([Select Id, IsAutoPopulated__c,Name from CRD_Quantity_Limit_Junction__c where id In: wrapperId]);
                database.delete(DeleteJunction);
            }
        } catch (Exception e) {
            return null;
        }

        Pagereference pageRef = new Pagereference(SEPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }
   /*Method to render fields based on QL Fields*/
       public PageReference showLowerPanel() {
              try{
                     if (YES.equalsIgnoreCase(crd.Are_there_Quantity_Limits__c)) {
        }
        return null;
    }catch (Exception e) {
            return null;
        }
    }
}