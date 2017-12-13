/*Purpose: Apex Class for VFP_CRDStepTherepy Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 10/22/2011       Apex Class for VFP_CRDStepTherepy Page.
     1.1 -    Rahul                 08/28/2013       Fix Issue # 1120
     1.2 -    Joognu Rao            03/25/2014       Request no 4288
     1.3 -    Joognu Rao            04/11/2014       Request no 4676
     2.0      Amit Jain             18 may 2015      Added logic for formulary plus extension, request 5755
     2.1      Bhaskar Arora         03/11/2016       Added logic to display History of object CRD_Step_Therapy_Junction__c , Request 06731
======================================================================== 
*/
public with sharing class VFP_CRDStepTherepyController {

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
    public list < String > errorMessages {
        get;
        set;
    }
    public boolean setMandatoryFields {
        get;
        set;
    }
    set < Id > wrapperId = new set < Id > ();
    //variable to hold the CRD PriorAuth Junction records
    public List < WrapperJunctionObjetRecord > listWrapperJunctionObjetRecord {
        get;
        set;
    }
public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING CURRENTPAGE = 'currentPageName';
    PRIVATE STATIC FINAL STRING CPPAGE = '/apex/VF_CRDClinicalProgStep1?crdid=';
    PRIVATE STATIC FINAL STRING ARSPAGE = '/apex/VF_AetnaRxStepJunction?crdid=';
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING NO = 'No';
    PRIVATE STATIC FINAL STRING PAPAGE = '/apex/VF_CRDClinicalProgPriorAuth1?id=';
    PRIVATE STATIC FINAL STRING COLON = ';';
    PRIVATE STATIC FINAL STRING SI = 'self insured';
    public List<CRD_Step_Therapy_Junction__c> stepTherapyJunctionList{get;set;}
    /*CONSTRUCTOR FOR VFP_CRDStepTherepyController*/

    
    public VFP_CRDStepTherepyController(ApexPages.StandardController controller) {
        crd = (CRD__c) controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        crd = [Select Name,Contract_State__c, Y_Schd__c, Integrate_with_Medical__c, Custom_Step_Therapy_Date_Approved_ST__c, Plan_Type_Paper__c, Insured_Type__c, Approved_from_CustFormulary_Committee_ST__c, Do_you_want_to_do_Step_Therapy__c, Standard_Program_or_Select_Classes__c, Step_Therapy_TOC_days__c, Standard_Step_Therapy_Program__c, Custom_Step_Therapy_Classes__c, Approved_from_CustFormulary_Committee_QL__c, Custom_Step_Therapy_Date_Approved_QL__c From CRD__c Where ID = : crdId LIMIT 80000];
        stepTherapyJunctionList = [select id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories 
                                              where Field NOT IN('created') order by Createddate desc), 
                                   Step_Therapy_DrugList_Class__c,Step_Therapy_DrugList_Class__r.name, Step_Therapy_DrugList_Class__r.Drug_List_Name__c, Step_Therapy_DrugList_Class__r.Description__c
                                   from CRD_Step_Therapy_Junction__c where CRD_ID__c != null AND CRD_ID__c = : crd.Id limit 1000];
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGE);
        errorMessages = new list < String > ();     
        inIt();
    }

    /* in it method to initialize the properties*/
   public void inIt() {

        //initialize the junction records list
        listWrapperJunctionObjetRecord = new List < WrapperJunctionObjetRecord > ();

        //fetch all the related junction record
        for (CRD_Step_Therapy_Junction__c junctionRecord: [Select Id, Step_Therapy_DrugList_Class__c, Step_Therapy_DrugList_Class__r.Drug_List_Name__c, Step_Therapy_DrugList_Class__r.Description__c
        from CRD_Step_Therapy_Junction__c where CRD_ID__c != null AND CRD_ID__c = : crd.Id]) {

            WrapperJunctionObjetRecord wrapperObj = new WrapperJunctionObjetRecord(false, junctionRecord);
            wrapperObj.className = junctionRecord.Step_Therapy_DrugList_Class__r.Drug_List_Name__c;
            wrapperObj.classDescription = junctionRecord.Step_Therapy_DrugList_Class__r.Description__c;
            listWrapperJunctionObjetRecord.add(wrapperObj);
        }
    }

    /*method to add a row in junction records list*/
    public void addJunctionObjetRecord() {

        //add a new record in the junction object record list on click on button "Add Step Therapy Class"
        listWrapperJunctionObjetRecord.add(new WrapperJunctionObjetRecord(false, new CRD_Step_Therapy_Junction__c()));
    }

    /*method to delete rows*/
    public void deleteJunctionObjetRecords() {
        //add a new record in the junction object record list on click on button "Add Step Therapy Class"
        List < WrapperJunctionObjetRecord > newList = new List < WrapperJunctionObjetRecord > ();

        //loop through the records and removed the records from the list
        for (WrapperJunctionObjetRecord wInstance: listWrapperJunctionObjetRecord) {
            if (!wInstance.selected) {
                newList.add(wInstance);
            } else {
                wrapperId.add(wInstance.crdAuthJunction.Id);

            }
        }

        //remove the selected records from the list
        listWrapperJunctionObjetRecord = newList;
        // remove the record from data base
    }

    //wrapper class to hold the junction object information'
    public class WrapperJunctionObjetRecord {
        public boolean selected {
            get;
            set;
        }
        public CRD_Step_Therapy_Junction__c crdAuthJunction {
            get;
            set;
        }
        public String className {
            get;
            set;
        }
        public String classDescription {
            get;
            set;
        }

        public WrapperJunctionObjetRecord(Boolean selected, CRD_Step_Therapy_Junction__c crdAuthJunction) {
            this.selected = selected;
            this.crdAuthJunction = crdAuthJunction;
        }
        
         public WrapperJunctionObjetRecord(){
         
         }
    }

    //populate druglist data
    public void populateDrugListData() {

        //collection to hold the drug ids
        Set < Id > drugsIds = new Set < Id > ();

        //loop through the drug list data
        for (WrapperJunctionObjetRecord wInstance: listWrapperJunctionObjetRecord) {
            if (wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c != null) drugsIds.add(wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c);
        }

        //get the drugs data
        Map < Id, Drug_List__c > mapDrugList = new Map < Id, Drug_List__c > ([Select Drug_List_Name__c, Description__c from Drug_List__c
        where Id in : drugsIds LIMIT 80000]);

        //loop through the drug list data
        for (WrapperJunctionObjetRecord wInstance: listWrapperJunctionObjetRecord) {
            if (wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c != null) {
                wInstance.className = mapDrugList.get(wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c).Drug_List_Name__c;
                wInstance.classDescription = mapDrugList.get(wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c).Description__c;
            }
        }
    }
    /* Method to handle FormularyXCustom Logic*/
    public pageReference isStepTherapyNeeded() {
    if(crd.Do_you_want_to_do_Step_Therapy__c!=YES){
           crd.Standard_Precert_List_or_Select_Classes__c = null;
        }else{
        Boolean ProcessCommercialFormulary = True;
        crd.Step_Therapy_TOC_days__c = 90;
        crd.Standard_Step_Therapy_Program__c = null;
        if(listWrapperJunctionObjetRecord.size()==0){
            set<ID> formularyID = new set<ID>();
            Set<String> dlStepTherapy = new Set<String>();
            for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name from Drug_Coverage__c where CRD_ID__c = : crd.Id LIMIT 80000]){
                formularyID.add(dcRecord.Formulary__c);
            }
            for(FormularyXCustomDL_ERD__c formulayCustom: [Select Id, name,Aetna_Specialty_Care_Rx__c, Formulary__c, Override_Refill_Too_Soon__c, Precert__c
                                                                    , Quantity_Limit__c,Secondary_of_fills_before_Force_to_SPN__c, Secondary_Aetna_Specialty_Care_Rx__c 
                                                                    , Secondary_Specialty_Drug_List__c,Specialty_Drug_List__c, Step_Therapy__c,Secondary_Specialty_Drug_List_ID__c
                                                                    , NPL_List__c
                                                           From 
                                                                FormularyXCustomDL_ERD__c
                                                           Where 
                                                               Formulary__c In: formularyID LIMIT 80000]){
                   ProcessCommercialFormulary = False;
                   if(formulayCustom.Step_Therapy__c != Null){
                    String[] stDrugLists = formulayCustom.Step_Therapy__c.split(COLON);
                    for(String drugListST : stDrugLists){
                        dlStepTherapy.add(drugListST);
                    }
                }
             }
             if(!dlStepTherapy.isEmpty()){
                for(Drug_List__c dlrecord: [Select Id,Name from Drug_List__c where  Name =: dlStepTherapy LIMIT 80000]){
                   CRD_Step_Therapy_Junction__c paJunctionRecord= new CRD_Step_Therapy_Junction__c ();
                        paJunctionRecord.Step_Therapy_DrugList_Class__c=dlrecord.Id;
                        paJunctionRecord.IsAutoPopulated__c= True;
                        WrapperJunctionObjetRecord wrap = new WrapperJunctionObjetRecord ();
                        wrap.crdAuthJunction = paJunctionRecord;
                        listWrapperJunctionObjetRecord.add(wrap);
                }    
             }else if(ProcessCommercialFormulary) {                                              
                                                               
        //Added by Sushant Req 1155 /* Start */
         List <ST_PA_QL_Auto_Populate__c> stpaqllist;
           stpaqllist= new List<ST_PA_QL_Auto_Populate__c>([Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,Record_Type__c,What_is_the_Funding_Type__c from ST_PA_QL_Auto_Populate__c where  Record_Type__c='Step Therapy' and What_is_the_Funding_Type__c includes (:crd.Insured_Type__c) and Contract_State__c includes (:crd.Contract_State__c)]);
       
        for(ST_PA_QL_Auto_Populate__c masterDataItem: stpaqllist){
             string str = masterDataItem.What_is_the_Funding_Type__c;  
                string[] strFundingType = str.split(COLON);              
                boolean isSelfInsured=false;
                boolean isFullyInsured=false;
                boolean isSplitFunded=false;
          CRD_Step_Therapy_Junction__c paJunctionRecord= new CRD_Step_Therapy_Junction__c ();
                    paJunctionRecord.Step_Therapy_DrugList_Class__c=masterDataItem.Drug_List__c;
                    paJunctionRecord.IsAutoPopulated__c= True;
                    WrapperJunctionObjetRecord wrap = new WrapperJunctionObjetRecord ();
                    wrap.crdAuthJunction = paJunctionRecord;
                    listWrapperJunctionObjetRecord.add(wrap);
                    }  
        }
        }
        }
        /* End */
        
        return null;
    }
    /*Method to redirect to CP Page for next button story*/
    public PageReference redirectToClinicalProg2(){
        try{
        Pagereference pageRef = new Pagereference(CPPAGE + crd.Id);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to redirect to CP Page*/
    public PageReference redirectToClinicalProg() {
        try{
        //Richa added on 12/8 for Req 5036
        errorMessages.clear();
        if (crd.Do_you_want_to_do_Step_Therapy__c != YES) {
            //Added and commented by JR on 18/11/2014
            //crd.Step_Therapy_TOC_days__c = null;
            crd.Step_Therapy_TOC_days__c = 0;
        }
        database.update(crd);
        list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
        listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
        if(!listDC.isempty()){
            if(crd.Step_Therapy_TOC_days__c != null && crd.Step_Therapy_TOC_days__c != 0){
                errormessages.add(System.Label.ERR0255);
                return null;    
            }
        }//till here
        Pagereference pageRef = new Pagereference(CPPAGE + crd.Id);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to redirect to ARS Page FOR next button story*/
    public Pagereference saveDetails2(){
        try{
        if(SI.equalsIgnoreCase(crd.Insured_Type__c) && NO.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c)){ // modified by JR to implement request 4676
                Pagereference pageRef = new Pagereference(ARSPAGE + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }else{
                Pagereference pageRef = new Pagereference(PAPAGE + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
                }
        
    }catch(exception e){return null;}
    }
    
    /*Method to redirect to ARS Page*/
    public PageReference saveDetails() {
        try{
        errorMessages.clear();   
        //create a savepoit to roll back the transaction in case of exception
        SavePoint sp = database.setSavePoint();
        if (YES.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c)) {
        }
        if (crd.Do_you_want_to_do_Step_Therapy__c != YES) {
            crd.Standard_Program_or_Select_Classes__c = null;
            //Added and commented by JR on 18/11/2014
            //crd.Step_Therapy_TOC_days__c = null;
            crd.Step_Therapy_TOC_days__c = 0;
            
            crd.Standard_Step_Therapy_Program__c = Null;
            listWrapperJunctionObjetRecord = Null;
            listWrapperJunctionObjetRecord = new List < WrapperJunctionObjetRecord > ();
            List < CRD_Step_Therapy_Junction__c > stepTherapyJunction = new List < CRD_Step_Therapy_Junction__c > ([select Id, Name, CRD_ID__c from CRD_Step_Therapy_Junction__c where CRD_ID__c = : crd.Id LIMIT 80000]);
            database.delete(stepTherapyJunction);
        } else {
            if (crd.Standard_Program_or_Select_Classes__c != 'ST Drug List(s)') {
                
                listWrapperJunctionObjetRecord = Null;
                listWrapperJunctionObjetRecord = new List < WrapperJunctionObjetRecord > ();
                List < CRD_Step_Therapy_Junction__c > stepTherapyJunction = new List < CRD_Step_Therapy_Junction__c > ([select Id, Name, CRD_ID__c from CRD_Step_Therapy_Junction__c where CRD_ID__c = : crd.Id LIMIT 80000]);
                database.delete(stepTherapyJunction);
            }
            if (crd.Standard_Program_or_Select_Classes__c != 'ST Drug Group') {
                crd.Standard_Step_Therapy_Program__c = Null;
                
            }
        }
        try {

            //upsert the CRD record
            database.upsert(crd);
            //Richa added on 12/8 for Req 5036
            list<Drug_Coverage__c> listDC = new list<Drug_Coverage__c>();
            listDC = [Select Allow_Transition_Fill__c from Drug_Coverage__c where CRD_ID__c = :crd.Id AND Allow_Transition_Fill__c =: YES LIMIT 1];
            if(!listDC.isempty()){
                if(crd.Step_Therapy_TOC_days__c != null && crd.Step_Therapy_TOC_days__c != 0){
                    errormessages.add(System.Label.ERR0255);
                    return null;        
                }
            }//till here
            //Create a new list to upsert the CRD_PriorAuth_Junction__c records
            List < CRD_Step_Therapy_Junction__c > junctionRecords = new List < CRD_Step_Therapy_Junction__c > ();

            //loop through the wrapper object list and upsert the junction records
            for (WrapperJunctionObjetRecord wInstance: listWrapperJunctionObjetRecord) {
                if (wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c != null) {
                    wInstance.crdAuthJunction.CRD_ID__c = crd.Id;
                    junctionRecords.add(wInstance.crdAuthJunction);
                }
                else if (wInstance.crdAuthJunction.Step_Therapy_DrugList_Class__c == null){
                      errormessages.add(System.Label.ERR00228);
                      return null;
                   }              
            }
            //upsert the list
            database.upsert(junctionRecords);
            if (wrapperId.size() > 0) {
                List < CRD_Step_Therapy_Junction__c > deleteJunction = new List < CRD_Step_Therapy_Junction__c > ([Select Id, Name from CRD_Step_Therapy_Junction__c where id In: wrapperId LIMIT 80000]);
                database.delete(DeleteJunction);
            }

           // Pagereference pageRef = new Pagereference(PAPAGE + crd.Id);
           // return pageRef;
            
            // modified by JR for request no 4288

            if(SI.equalsIgnoreCase(crd.Insured_Type__c) && NO.equalsIgnoreCase(crd.Do_you_want_to_do_Step_Therapy__c)){ // modified by JR to implement request 4676
                Pagereference pageRef = new Pagereference(ARSPAGE + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }else{
                Pagereference pageRef = new Pagereference(PAPAGE + crd.Id);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }

        } catch (Exception e) {
            //roll back the transaction
            database.rollback(sp);

            //add error on page
            ApexPages.addMessages(e);
        }
        return null;

    }catch(exception e){return null;}
    }
    
}