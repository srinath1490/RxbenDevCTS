/**
 * Class Name: VFP_SaftyEditProgramsController
 * Author: Accenture
 * Date: 28-Oct-2012
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <ACE2011>
 */
/*Purpose: Controller class of page VF_SafetyEditPrograms                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                 10/28/2012       Controller class of page VF_SafetyEditPrograms
   1.1 -    SOURABH               02/13/2013       Fix to display the new Drug Groups
   1.2 -    RAHUL                 08/28/2013       Fix Issue# 01113
   1.3      Amit                  10/03/2013       Modified for request 1193
   2.0      Amit                  24 Feb 2014      Added Comments
   2.1      Joognu Rao            07/04/2014       Implemented request 4678
   2.2      Richa                 07/30/2014       Commented all Hypertension and Hyperlipidemia fields for Req4558  
   2.3      Ankur                 04/14/2015       Request number -05486  
  ======================================================================== */
/**
  * This is a VF page sharing class
  **/
public with sharing class VFP_SaftyEditProgramsController {
    public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    set < Id > wrapperId = new set < Id > ();
    public Attachment waverForm {
        get;
        set;
    }
    public list < CRD_Standard_Safety_Edit_Junction__c > lstStandardSaftyJunctionRecords {
        get;
        set;
    }
    public list < CRD_Standard_Safety_Edit_Junction__c > lstExistingSaftyJunctionRecords {
        get;
        set;
    }
    public List < Attachment > waverFormAttachments {
        get;
        set;
    }
    public list < saftyEditWrapper > lstWrapperItems {
        get;
        set;
    }
    public list < saftyEditWrapper > lstDrugGroupForSFE {
        get;
        set;
    }
    public string groupMember{get;set;}
    public String editMode{get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING FI = 'Fully Insured';
    PRIVATE STATIC FINAL STRING SF = 'Split Funded';
    PRIVATE STATIC FINAL STRING SI = 'Self Insured';
    PRIVATE STATIC FINAL STRING AGB = 'Aetna Global Benefits';
    PRIVATE STATIC FINAL STRING YES = 'Yes';
    PRIVATE STATIC FINAL STRING NO = 'No';
    PRIVATE STATIC FINAL STRING QLPAGE = '/apex/VF_CRDQuantityLimits?crdid=';
    PRIVATE STATIC FINAL STRING SACPAGE = '/apex/VF_CRDSaveACopayJunction?crdid=';
    PRIVATE STATIC FINAL STRING SEPAGE = '/apex/VF_SaftyEditPrograms?crdid=';
    PRIVATE STATIC FINAL STRING V1 = '_';
       
    /**
    * Method :- Constructor: VFP_SaftyEditProgramsController(ApexPages.StandardController controller)
    * Description :- The constructor fetches the CRD Record and CRD Standard Safety Edit JUnction Record and add them in a wrapper
    **/    
    public VFP_SaftyEditProgramsController(ApexPages.StandardController controller) {

        lstStandardSaftyJunctionRecords = new list < CRD_Standard_Safety_Edit_Junction__c > ();
        lstWrapperItems = new list < saftyEditWrapper > ();
        lstDrugGroupForSFE = new list < saftyEditWrapper > ();
        waverForm = new Attachment();
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        this.crd = [Select Name, Y_Schd__c, Custom_Safety_Edits__c, Opt_out_of_Safety_Edits__c, Integrate_with_Medical__c, RxPlan_ID_Status__c,  
        Pharmacy_Advisor__c, Disease_Vendor__c, End_Date__c, Custom_call_center_phone_number__c,  PSP_Letter_Templates__c, 
        Enrolled_in_PA_for_other_condition__c, Implementation_Type__c, Participate_in_CVS_mail_pharmacy_service__c, Disease_Management_Referral_Messaging__c,
         Disease_Management_Messaging_for__c, Is_DM_vendor_the_same_for_each_condition__c, Co_Brand_Initial_Program_Welcome_Mailing__c, Value_Generic__c,
          Aetna_Healthy_Actions__c, Tier_1_Copay_Reduction__c, Tier_2_Copay_Reduction__c, Tier_3_Copay_Reduction__c, Extra_Care_Health_Card__c, Plan_Platform__c, 
          Plan_Type_Paper__c, Insured_Type__c, Tier_5_Copay_Reduction__c, Tier_4_Copay_Reduction__c, Offering_Type__c, Tier_1_Rx_Reduction__c, 
          Tier_2_Rx_Reduction__c, Tier_3_Rx_Reduction__c, Tier_4_Rx_Reduction__c, Tier_5_Rx_Reduction__c, Asthma_Inhaled_Steroids__c, Asthma_Anti_Inflammatory_Agents__c,
          Diabetes_Anti_Diabetic_Agents__c, Diabetes_Anti_Diabetic_Agent_Supplies__c, Heart_Failure_Beta_Blockers__c, /*Hyperlipidemia_Statins__c, 
          Hyperlipidemia_Lipid_Lowering_Agents__c, Hypertension_ACE_Inhibitors_ARBs__c, Hypertension_All_Anti_Hypertensives__c,*/ ARH_Offering_Type__c, 
          Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/ Diabetes_Preventive__c, 
          Asthma_Preventive__c, Aetna_Autofill__c From CRD__c Where ID = : crdId LIMIT 80000];
        waverFormAttachments = [Select Id, Name From Attachment where ParentId = : crdId AND Name Like '%Waver Form%' LIMIT 80000];
    }
    /* Method to display Drug Groups based on business conditions*/
    public void displayDrugGroups() {
        try{
        //Richa : added for Req 4678
        Database.Delete([Select id from CRD_Standard_Safety_Edit_Junction__c where Drug_Group__r.Funding__c !='Self Insured' and CRDID__c = : this.crd.id and CRDID__r.Plan_Platform__c =: AGB LIMIT 80000]);
        
        lstExistingSaftyJunctionRecords = new list < CRD_Standard_Safety_Edit_Junction__c > ([select id, Drug_Group__c, Drug_Group_Description__c, Drug_Group_ID__c, Drug_Group_Name__c, Drug_List__c, Drug_List_Description__c, Drug_List_ID__c, Drug_List_Name__c, Select__c, CRDID__c from CRD_Standard_Safety_Edit_Junction__c where CRDID__c = : this.crd.id LIMIT 80000]);
        if (lstExistingSaftyJunctionRecords != null && lstExistingSaftyJunctionRecords.size() > 0) {
            set < Id > drugGroupId = new set < Id > ();
            for (CRD_Standard_Safety_Edit_Junction__c saftyEditRecord: lstExistingSaftyJunctionRecords) {
                if (saftyEditRecord.Drug_Group__c != null && saftyEditRecord.CRDID__c != null) {
                    saftyEditWrapper wrap = new saftyEditWrapper();
                    Drug_Group__c drugGroup = new Drug_Group__c(id = saftyEditRecord.Drug_Group__c, Drug_Group_Name__c = saftyEditRecord.Drug_Group_Name__c, Description__c = saftyEditRecord.Drug_Group_Description__c);
                    wrap.SaftyEditDGItem = drugGroup;
                    wrap.selected = saftyEditRecord.Select__c;
                    wrap.className = saftyEditRecord.Drug_Group_ID__c;
                    wrap.classDescription = saftyEditRecord.Drug_Group_Description__c;
                    lstDrugGroupForSFE.add(wrap);
                    drugGroupId.add(drugGroup.Id);
                }
                if (saftyEditRecord.Drug_List__c != null) {
                    saftyEditWrapper wrap = new saftyEditWrapper();
                    wrap.SaftyEditItem = saftyEditRecord;
                    wrap.selected = saftyEditRecord.Select__c;
                    wrap.className = saftyEditRecord.Drug_List_Name__c;
                    wrap.classDescription = saftyEditRecord.Drug_List_Description__c;
                    lstWrapperItems.add(wrap);
                }
            }
            // 02-13-2013 :Sourabh : To display the New Drug Group created after the safety edit junction records are created.
            
            // modified by JR (Request 4678)
            String query = 'select id,Name,Drug_Group_Name__c,Description__c ,Platform__c,Standard__c,Special_Use__c,Funding__c from Drug_Group__c where Special_Use__c=\'Safety Edit\' and Standard__c=true';  
            
            if(crd.Plan_Platform__c != AGB){    //27-02-2014 : Richa added for Request 04545
                if (FI.equalsIgnoreCase(crd.Insured_Type__c) || SF.equalsIgnoreCase(crd.Insured_Type__c)) {
                    query = query + ' and (Funding__c=\'Fully Insured\' OR Funding__c=\'Split Funded\') ';
                }
                if (SI.equalsIgnoreCase(crd.Insured_Type__c)) {
                    query = query + ' and Funding__c=\'Self Insured\' ';
                }
            }else if(AGB.equalsIgnoreCase(crd.Plan_Platform__c)){
                    query = query + ' AND Funding__c=\'Self Insured\' ';
            }    
            query = query + ' AND id NOT IN: drugGroupId ';
            
            for (Drug_Group__c dg: Database.query(query)) {
                saftyEditWrapper wrap = new saftyEditWrapper();
                wrap.SaftyEditDGItem = dg;
                lstDrugGroupForSFE.add(wrap);
            }
            //02-13-2013 :Sourabh
            
            // modified by JR (Request 4678)
        } else {
            String query = 'select id,Name,Drug_Group_Name__c,Description__c ,Platform__c,Standard__c,Special_Use__c,Funding__c from Drug_Group__c where Special_Use__c=\'Safety Edit\' and Standard__c=true';
            if(crd.Plan_Platform__c != AGB){    
                if (FI.equalsIgnoreCase(crd.Insured_Type__c) || SF.equalsIgnoreCase(crd.Insured_Type__c)) {
                    query = query + ' and (Funding__c=\'Fully Insured\' OR Funding__c=\'Split Funded\')';
                }
                if (SI.equalsIgnoreCase(crd.Insured_Type__c)) {
                    query = query + ' and Funding__c=\'Self Insured\' ';
                }
            }else if(AGB.equalsIgnoreCase(crd.Plan_Platform__c)){
                    query = query + ' AND Funding__c=\'Self Insured\' ';
            }  
            query = query + ' limit 20';
            for (Drug_Group__c dg: Database.query(query)) {
                saftyEditWrapper wrap = new saftyEditWrapper();
                wrap.SaftyEditDGItem = dg;
                lstDrugGroupForSFE.add(wrap);
            }

        }

    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }

    /**
    * Method :- validateOptOutEdits
    * Description :- The method validates the Opt Out of Safety Edits
    **/ 
    public boolean validateOptOutEdits() {
        try{
        boolean isValid = true;
        integer counter = 0;
        if (crd.Opt_out_of_Safety_Edits__c != null && NO.equalsIgnoreCase(crd.Opt_out_of_Safety_Edits__c)) {
            if (lstWrapperItems != null && lstWrapperItems.size() > 0) {
                counter = counter + 1;
            }

            if (counter == 0) {
                for (saftyEditWrapper wrap: lstDrugGroupForSFE) {
                    if (wrap.selected) {
                        counter = counter + 1;
                    }
                }
            }

            if (counter > 0) {
                isValid = true;
            } else {
                isValid = false;
            }
        }
        return isValid;
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }

    /**
    * Method :- validateNonOptEdits
    * Description :- The method validates the Non Opt Out of Safety Edits
    **/ 
    public boolean validateNonOptEdits() {
        try{
        boolean isValid = true;
        integer counter = 0;
        if (crd.Opt_out_of_Safety_Edits__c != null && YES.equalsIgnoreCase(crd.Opt_out_of_Safety_Edits__c)) {
            if (lstWrapperItems != null && lstWrapperItems.size() > 0) {
                isValid = false;
            }

            for (saftyEditWrapper wrap: lstDrugGroupForSFE) {
                if (wrap.selected) {
                    counter = counter + 1;
                }
            }
        }
        if (crd.Opt_out_of_Safety_Edits__c != null && YES.equalsIgnoreCase(crd.Opt_out_of_Safety_Edits__c) && counter == 0) {
            isValid = true;
        } else {
            isValid = false;
        }
       
        if (crd.Opt_out_of_Safety_Edits__c == null && (counter > 0 || lstWrapperItems.size() > 0)) {
            isValid = false;
        }

        return isValid;
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /**
    * Method :- backbutton2()
    * Description :- The method upsert the safety edit junction records, update the crd and redirect to page VF_CRDQuantityLimits for ReadOnly Mode
    **/ 
    public pagereference backbutton2(){
        try{
            Pagereference pageRef = new Pagereference(QLPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
}
    /**
    * Method :- backbutton()
    * Description :- The method upsert the safety edit junction records, update the crd and redirect to page VF_CRDQuantityLimits
    **/ 
    public Pagereference backbutton() {
        try{
            list < CRD_Standard_Safety_Edit_Junction__c > lstExistingSaftyJunctionDLRecords = new list < CRD_Standard_Safety_Edit_Junction__c > ([select id, Drug_Group__c, 
        Drug_Group_Description__c, Drug_Group_ID__c, Drug_Group_Name__c, Drug_List__c, Drug_List_Description__c, Drug_List_ID__c, Drug_List_Name__c, 
        Select__c, CRDID__c from CRD_Standard_Safety_Edit_Junction__c where CRDID__c = : this.crd.id LIMIT 80000]);
        if (lstExistingSaftyJunctionDLRecords != null && lstExistingSaftyJunctionDLRecords.size() > 0) {
            DATABASE.delete(lstExistingSaftyJunctionDLRecords);
        }
        
        if (crd.Opt_out_of_Safety_Edits__c != null && YES.equalsIgnoreCase(crd.Opt_out_of_Safety_Edits__c) && !validateNonOptEdits()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00141);
            ApexPages.addMessage(myMsg);
            return null;
            //If the field 'Opt out of Safety Edits' equals NO then the user must select a Safety Edit Drug Group record.
        }
        // } 
        for (saftyEditWrapper wrap: lstDrugGroupForSFE) {
            if (wrap.SaftyEditDGItem != null) {
                CRD_Standard_Safety_Edit_Junction__c juntionRecord = new CRD_Standard_Safety_Edit_Junction__c();
                
                juntionRecord.Drug_Group__c = wrap.SaftyEditDGItem.id;
                juntionRecord.Select__c = wrap.selected;
                juntionRecord.CRDID__c = this.crd.id;
                if(juntionRecord.Select__c)                         //Richa : added for Req 4678
                {
                    lstStandardSaftyJunctionRecords.add(juntionRecord);
                }
            }
        }
        for (saftyEditWrapper wrap: lstWrapperItems) {
            if (wrap.SaftyEditItem.Drug_List__c != null) {
                CRD_Standard_Safety_Edit_Junction__c juntionRecord = new CRD_Standard_Safety_Edit_Junction__c();
                juntionRecord.Drug_List__c = wrap.SaftyEditItem.Drug_List__c;
                juntionRecord.Select__c = wrap.selected;
                juntionRecord.CRDID__c = this.crd.id;
                lstStandardSaftyJunctionRecords.add(juntionRecord);
            }
        }
        if (lstStandardSaftyJunctionRecords != null && lstStandardSaftyJunctionRecords.size() > 0) {
            DATABASE.upsert(lstStandardSaftyJunctionRecords);
        }
        DATABASE.update(crd);
        Pagereference pageRef = new Pagereference(QLPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
}
    /**
    * Method :- nextbutton2()
    * Description :- The method upsert the safety edit junction records, update the crd and redirect to page VF_CRDQuantityLimits for ReadOnly Mode
    **/
    public Pagereference nextbutton2(){
        try{
            Pagereference pageRef = new Pagereference(SACPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /**
    * Method :- nextbutton()
    * Description :- The method upsert the safety edit junction records, update the crd and redirect to page VF_CRDQuantityLimits
    **/
    public Pagereference nextbutton() {
        try{
        list < CRD_Standard_Safety_Edit_Junction__c > lstExistingSaftyJunctionDLRecords = new list < CRD_Standard_Safety_Edit_Junction__c > ([select id, Drug_Group__c, 
        Drug_Group_Description__c, Drug_Group_ID__c, Drug_Group_Name__c, Drug_List__c, Drug_List_Description__c, Drug_List_ID__c, Drug_List_Name__c, Select__c, 
        CRDID__c from CRD_Standard_Safety_Edit_Junction__c where CRDID__c = : this.crd.id LIMIT 80000]);
        if (lstExistingSaftyJunctionDLRecords != null && lstExistingSaftyJunctionDLRecords.size() > 0) {
            DATABASE.delete(lstExistingSaftyJunctionDLRecords);
        }
        
        if (crd.Opt_out_of_Safety_Edits__c != null && YES.equalsIgnoreCase(crd.Opt_out_of_Safety_Edits__c) && !validateNonOptEdits()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00141);
            ApexPages.addMessage(myMsg);
            return null;
            //If the field 'Opt out of Safety Edits' equals NO then the user must select a Safety Edit Drug Group record.
        }
         
        for (saftyEditWrapper wrap: lstDrugGroupForSFE) {
            if (wrap.SaftyEditDGItem != null) {
                CRD_Standard_Safety_Edit_Junction__c juntionRecord = new CRD_Standard_Safety_Edit_Junction__c();
                juntionRecord.Drug_Group__c = wrap.SaftyEditDGItem.id;
                juntionRecord.Select__c = wrap.selected;
                juntionRecord.CRDID__c = this.crd.id;
                if(juntionRecord.Select__c)                         //Richa : added for Req 4678
                {
                    lstStandardSaftyJunctionRecords.add(juntionRecord);
                }
            }
        }
        for (saftyEditWrapper wrap: lstWrapperItems) {
            if (wrap.SaftyEditItem.Drug_List__c != null) {
                CRD_Standard_Safety_Edit_Junction__c juntionRecord = new CRD_Standard_Safety_Edit_Junction__c();
                juntionRecord.Drug_List__c = wrap.SaftyEditItem.Drug_List__c;
                juntionRecord.Select__c = wrap.selected;
                juntionRecord.CRDID__c = this.crd.id;
                lstStandardSaftyJunctionRecords.add(juntionRecord);
            }
        }
        if (lstStandardSaftyJunctionRecords != null && lstStandardSaftyJunctionRecords.size() > 0) {
            DATABASE.upsert(lstStandardSaftyJunctionRecords);
        }
        DATABASE.update(crd);
    //Updated by ankur - 05486
        Pagereference pageRef = new Pagereference(SACPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }

    /**
    * Method :- addNewItem()
    * Description :- The method add a new row
    **/
    public void addNewItem() {
        try{
        lstWrapperItems.add(new saftyEditWrapper());   
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    /**
     * Wrapper Class
     **/
    public class saftyEditWrapper {
        public CRD_Standard_Safety_Edit_Junction__c SaftyEditItem {
            get;
            set;
        }
        public Drug_Group__c SaftyEditDGItem {
            get;
            set;
        }
        public boolean selected {
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
        /* Method to load safety edit records in wrapper*/
        public saftyEditWrapper() {
            selected = false;
            SaftyEditItem = new CRD_Standard_Safety_Edit_Junction__c();
        }
    }

    /**
    * Method :- populateDrugListData()
    * Description :- The method populate druglist data
    **/    
    public void populateDrugListData() {
        
        try
        {
            //collection to hold the drug ids
        Set < Id > drugsIds = new Set < Id > ();

        //loop through the drug list data
        for (saftyEditWrapper wInstance: lstWrapperItems) {
            if (wInstance.SaftyEditItem.Drug_List__c != null)
            {
                 drugsIds.add(wInstance.SaftyEditItem.Drug_List__c);
            }
        }

        //get the drugs data
        Map < Id, Drug_List__c > mapDrugList = new Map < Id, Drug_List__c > ([Select Drug_List_Name__c, Description__c from Drug_List__c
        where Id in : drugsIds LIMIT 80000]);

        //loop through the drug list data
        for (saftyEditWrapper wInstance: lstWrapperItems) {
            if (wInstance.SaftyEditItem.Drug_List__c != null) {
                wInstance.className = mapDrugList.get(wInstance.SaftyEditItem.Drug_List__c).Drug_List_Name__c;
                wInstance.classDescription = mapDrugList.get(wInstance.SaftyEditItem.Drug_List__c).Description__c;
            }
        }
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            }
    }
    

    /**
    * Method :- deleteJunctionObjetRecords()
    * Description :- The method to delete rows
    **/     
    public void deleteJunctionObjetRecords() {
        try{
        //add a new record in the junction object record list on click on button "Add Step Therapy Class"
        List < saftyEditWrapper > newList = new List < saftyEditWrapper > ();
        //loop through the records and removed the records from the list
        for (saftyEditWrapper wInstance: lstWrapperItems) {
            if (!wInstance.selected) {
                newList.add(wInstance);
            } else {
                wrapperId.add(wInstance.SaftyEditItem.Id);

            }
        }
        lstWrapperItems.clear();
        //remove the selected records from the list
        lstWrapperItems = newList;
        // remove the record from data base
    }catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }

    /**
    * Method :- upload(Attachment attachment, string namePrefix)
    * Description :- The Method to upload the file to the CRD
    **/     
    public void upload(Attachment attachment, string namePrefix) {
        attachment.Name = system.today() + V1 + namePrefix + V1 + attachment.Name;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = crd.id; // the record the file is attached to
        attachment.IsPrivate = true;

        try {
            DATABASE.insert(attachment);
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.ERR00082));
        }
    }
    
    /**
    * Method :- uploadWaverForm()
    * Description :- The Method to upload the waver form to crd
    **/    
    public pagereference uploadWaverForm() {
        try {
            if (waverForm != null) {
                upload(waverForm, 'Waver Form');
            }
            Pagereference pageRef = new Pagereference('/apex/VF_SaftyEditPrograms?crdid=' + crd.Id);
            pageRef.setredirect(True);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
}