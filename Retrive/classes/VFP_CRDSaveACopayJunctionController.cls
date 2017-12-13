/*Purpose: Apex Class for VFP_CRDSaveACopayJunction 
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Anuj                 9/19/2011       Apex Class for VFP_CRDSaveACopayJunction
     1.1 -    Joognu Rao            02/21/2014     request no 4288
     1.2     Chetan Garg            05/08/2014     #04786, Valdiation rule for Override Option
     1.3     Richa Gupta           29/01/2015      Req 5461 - show override option for SI plans
     1.4     Richa Gupta           18/02/2015      Req 5554 - Added condition of Funding = 'Any' 
     1.5     Richa Gupta           31/03/2015      Req 5628 - Add an additional validation for SAC (CRDW)
     1.6     Toshi D                11/09/2016     Req no 6733, adding history rec on VF page
======================================================================== 
*/
public without sharing class VFP_CRDSaveACopayJunctionController {
    Public CRD__c crd {
        get;
        set;
    }
    Public string crdId {
        get;
        set;
    }
    Public string pageName {
        get;
        set;
    }
    private List < Clinical_Program__c > clinicalPrograme;
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    Public List < Save_A_Copay_Junction__c > saveACopayList {
        get;
        set;
    }
    Public List < Clinical_Program_Group_Junction__c > saveACopayGroup {
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
    Public Boolean isUpdated {
        get;
        set;
    }
    private Boolean noError;
    private String fundingType;
    private static final String FULLYINSURED = 'Fully Insured';
    private static final String SELFINSURED = 'Self Insured'; 
    private static final String SAVEACOPAY = 'Save-A-Copay'; 
    private static final String CRDIDLABEL = 'crdid';
    private static final String YES = 'yes';
    private static final String NOVALUE = 'no';
    private static final String VALUE = 'Value';
    private static final String PREMIER = 'Premier'; 
    private static final String PROGRAMS ='Programs';
    private static final String ANYLABEL = 'Any';
    private static final String BACKBUTTON = '/apex/VF_SafetyEditPrograms?crdid=';
    private static final String NEXTBUTTON = '/apex/VF_CRDPrograme3?crdid=';
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING BLANKVAL = '';
    

/*Method: VFP_CRDSaveACopayJunctionController()
  Purpose: This constructor sets the value on page loading 
*/    
    public VFP_CRDSaveACopayJunctionController(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        isChanged = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDIDLABEL);
        crd = [Select Id, Y_Schd__c, Name,  Integrate_with_Medical__c, Insured_Type__c, SAC_Override_Option__c
                    , Do_you_want_to_do_Save_A_Copay__c, Effective_Start_Date__c, 
                    PSP_Letter_Templates__c, Plan_Platform__c, Plan_Type_Paper__c, Save_A_Copay_Custom_Letter__c 
                        From 
                           CRD__c 
                       Where
                 ID = : crdId LIMIT 1];
        if(crd.Insured_Type__c == SELFINSURED) {
            fundingType = SELFINSURED;
        } else {
                fundingType = FULLYINSURED;
            }
        
        pageName = PROGRAMS;
        if (crd.Do_you_want_to_do_Save_A_Copay__c == YES) {
            showfields = true;      //variable to display the list 
            showCheckBox = true;    //variable to display the override option checkbox 
        } else {
            showCheckBox = false;
            showfields = false;
        }
        //fetch the existing records in Save A Copay Junction object
        saveACopayList = new List < Save_A_Copay_Junction__c > ([Select Id, Save_A_Copay_Drug_Class__c, Selected__c 
                                                                from 
                                                                    Save_A_Copay_Junction__c 
                                                                where CRD_ID__c = : crdid LIMIT 100]); 
        //fetch the existing records in Clinical Program Group Junction object 
        // Inner query added by Toshi for ST# 6733 
        saveACopayGroup = new List < Clinical_Program_Group_Junction__c > ([Select Id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Name, CRD_ID__c, Record_Type__c, Selected__c
                                                                                    , Clinical_Program_Group_Name__c 
                                                                                    from 
                                                                            Clinical_Program_Group_Junction__c 
                                                                                    where 
                                                                            CRD_ID__c = : crdid 
                                                                                        and 
                                                                                            Record_Type__c = :SAVEACOPAY LIMIT 100]);
        isChanged = false;
    }
/*Method: searchSaveACopay()
  Purpose: This method fetches values from different objects as and when the fields on the screen changes
*/
    public void searchSaveACopay() {
       try { 
        isChanged = true;
        saveACopayList = null;
        saveACopayGroup = null;
        saveACopayGroup = new List < Clinical_Program_Group_Junction__c > ();
        saveACopayList = new List < Save_A_Copay_Junction__c > ();
        if (crd.SAC_Override_Option__c == YES) { // if Override Option = Yes display list from Clinical Program object
            Id saveACopayRtId = null;
            List < Schema.RecordTypeInfo > rtInfo = Clinical_Program__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: rtInfo) {
                if (thisInfo.Name == SAVEACOPAY) {
                    saveACopayRtId = thisInfo.getRecordTypeId();
                }
            }
            date today = system.today();
            clinicalPrograme = new List < Clinical_Program__c > ([Select Id, Name
                                                                    , Funding__c, Available_to_be_Picked__c, Clinical_Programs_Name__c 
                                                                        from 
                                                                  Clinical_Program__c 
                                                                       where
                                                                 (Funding__c = :fundingType OR Funding__c = NULL) 
                                                                                 and 
                                                                          RecordTypeId = : saveACopayRtId and Inactive__c = false 
                                                                                 and 
                                                                                    Available_to_be_Picked__c = true 
                                                                                 and 
                                                                             Available_Date__c != Null and((Available_Date__c < : today and Expiration_Date__c > : today) 
                                                                             or(Available_Date__c < : today and Expiration_Date__c = Null)) LIMIT 100]);

            if (clinicalPrograme.size() != 0) {
                Save_A_Copay_Junction__c savaACopay = null;
                for (Clinical_Program__c programe: clinicalPrograme) {
                    savaACopay = new Save_A_Copay_Junction__c();
                    savaACopay.Save_A_Copay_ID__c = programe.id;
                    savaACopay.Save_A_Copay_Drug_Class__c = programe.Clinical_Programs_Name__c;
                    savaACopay.CRD_ID__c = crdId;
                    saveACopayList.add(savaACopay);
                }
            } else {
                       //No Action Required
                   } 
        } else if (crd.SAC_Override_Option__c == NOVALUE) {    // if Override Option = No display list from Clinical Program Group object
            Id saveACopayGroupRtId = null;
            List < Schema.RecordTypeInfo > rtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
            for (Schema.Recordtypeinfo thisInfo: rtInfos) {
                if (thisInfo.Name == SAVEACOPAY) {
                    saveACopayGroupRtId = thisInfo.getRecordTypeId();
                }
            }
            //Added by Amit for request 5755
                List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c >();
                String formularyGroup=BLANKVAL;
                String formularyID = Null;
                for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name,Formulary__r.Group__c 
                                                from 
                                                    Drug_Coverage__c 
                                                where CRD_ID__c = : crd.Id limit 10000]){
                    if(dcRecord.Formulary__r.Group__c!= Null && dcRecord.Formulary__r.Group__c!= BLANKVAL){
                        formularyGroup = dcRecord.Formulary__r.Group__c;
                        formularyID = dcRecord.Formulary__c;
                    }
                }
                if(formularyGroup!= BLANKVAL && formularyGroup!= Null){
                    List<String> cgSaveACopay = new List<String>();
                    List<Clinical_Program_Group_Junction__c> sacJuncDel = new  List<Clinical_Program_Group_Junction__c>();
                    Map<ID,String> mapCGName2Id = new map<ID,String>();
                    List<Clinical_Program_Group_Junction__c> createSACRecords = new List<Clinical_Program_Group_Junction__c>();
                    //Clinical_Program_Group_Junction__c newClinicalProgramGroupRecord;
                    Map<string,crd__c> mapStringSACtoCRD = new Map<string,crd__c>();
                    
                    
                    for(FormularyXCustomDL_ERD__c formularyCustom: [Select Id, name, Formulary__c,Save_A_Copay__c
                                                                        
                                                                   From 
                                                                        FormularyXCustomDL_ERD__c
                                                                   Where 
                                                                        Formulary__c =: formularyID Limit 1000]){
                        
                            if(formularyCustom.Save_A_Copay__c != Null){
                                String sacClinicalGroup = formularyCustom.Save_A_Copay__c;
                                cgSaveACopay.add(sacClinicalGroup);
                            }
                     clinicalProgrameGroup =[Select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c 
                                                                                                                        from
                                                                                                                    Clinical_Program_Group__c 
                                                                                                                        where
                                                                                                                    Clinical_Program_Group_Name__c IN: cgSaveACopay AND RecordTypeName__c =:SAVEACOPAY  AND Inactive__c=false 
                                                                                                                        AND (Funding__c = :SELFINSURED OR Funding__c =:ANYLABEL OR Funding__c =:FULLYINSURED) Limit 1000];  
                    }
                    
                }else {
                     clinicalProgrameGroup = [Select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c 
                                                                                                                        from
                                                                                                                    Clinical_Program_Group__c 
                                                                                                                        where
                                                                                                                    RecordTypeId = : saveACopayGroupRtId and Inactive__c = false 
                                                                                                                                and
                                                                                                                                  (Funding__c = :fundingType OR Funding__c = :ANYLABEL) LIMIT 100];//Richa added condition of Funding = 'Any' for Req 5554
                    
                }
                //Ends           
            if (clinicalProgrameGroup.size() != 0) {
                Clinical_Program_Group_Junction__c cpGroupJunction = null;
                for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                    cpGroupJunction = new Clinical_Program_Group_Junction__c();
                    cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                    cpGroupJunction.CRD_ID__c = crdId;
                    cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                    cpGroupJunction.Record_Type__c = SAVEACOPAY;
                    saveACopayGroup.add(cpGroupJunction);
                }
            }
        } else {
            //No Action Required
            }
      }catch (exception e) {
                ApexPages.addMessages(e);
            }  
    }
/*Method: showDrugClass()
  Purpose: This method displays values on the page when fields are set 
*/
    public void showDrugClass() {
        try {
            isChanged = true;
            saveACopayList = null;
            saveACopayGroup = null;
            saveACopayGroup = new List < Clinical_Program_Group_Junction__c > ();
            saveACopayList = new List < Save_A_Copay_Junction__c > ();
            
            if (crd.Do_you_want_to_do_Save_A_Copay__c == YES) {
                showfields = true;
                showCheckBox = true;
                crd.SAC_Override_Option__c = NOVALUE; //default the value of Override Option to No when Enroll In Save-A-Copay is Yes
                
                Id saveACopayGroupRtId = null;
                List < Schema.RecordTypeInfo > rtInfos = Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
                for (Schema.Recordtypeinfo thisInfo: rtInfos) {
                    if (thisInfo.Name == SAVEACOPAY) {
                        saveACopayGroupRtId = thisInfo.getRecordTypeId();
                    }
                }
                
                //Added by Amit for request 5755
                List < Clinical_Program_Group__c > clinicalProgrameGroup = new List < Clinical_Program_Group__c >();
                String formularyGroup= BLANKVAL;
                String formularyID = Null;
                for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name,Formulary__r.Group__c 
                                                from 
                                                    Drug_Coverage__c 
                                                where 
                                                    CRD_ID__c = : crd.Id Limit 100]){
                    if(dcRecord.Formulary__r.Group__c!= Null && dcRecord.Formulary__r.Group__c!= BLANKVAL){
                        formularyGroup = dcRecord.Formulary__r.Group__c;
                        formularyID = dcRecord.Formulary__c;
                    }
                }
                // Modified as a part of Request 06488
                List<String> cgSaveACopay = new List<String>();
                set<id> setOfFormularyID = new set<id>();
                    if(formularyID!=null){
                        for(FormularyXCustomDL_ERD__c formularyCustom: [Select Id, name, Formulary__c,Save_A_Copay__c
                                                                            
                                                                       From 
                                                                            FormularyXCustomDL_ERD__c
                                                                       Where 
                                                                            Formulary__c =: formularyID limit 10000]){
                            
                                if(formularyCustom.Save_A_Copay__c != Null){
                                    String sacClinicalGroup = formularyCustom.Save_A_Copay__c;
                                    cgSaveACopay.add(sacClinicalGroup);
                                }
                                
                                setOfFormularyID.add(formularyCustom.Formulary__c);
                        }
                    }
                    // Added a condition setOfFormularyID for Request 6488
                if(formularyGroup!= BLANKVAL && formularyGroup!= Null && setOfFormularyID.contains(formularyID)){
                    
                    List<Clinical_Program_Group_Junction__c> sacJuncDel = new  List<Clinical_Program_Group_Junction__c>();
                    Map<ID,String> mapCGName2Id = new map<ID,String>();
                    List<Clinical_Program_Group_Junction__c> createSACRecords = new List<Clinical_Program_Group_Junction__c>();
                    //Clinical_Program_Group_Junction__c newClinicalProgramGroupRecord;
                    Map<string,crd__c> mapStringSACtoCRD = new Map<string,crd__c>();
                    
                     clinicalProgrameGroup =[Select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c 
                                                                                                                        from
                                                                                                                    Clinical_Program_Group__c 
                                                                                                                        where
                                                                                                                    Clinical_Program_Group_Name__c IN: cgSaveACopay AND RecordTypeName__c =: SAVEACOPAY AND Inactive__c=false 
                                                                                                                        AND (Funding__c = :SELFINSURED OR Funding__c =:ANYLABEL OR Funding__c =:FULLYINSURED) Limit 1000];  
                    
                    
                }else {
                     clinicalProgrameGroup = [Select Id, Name, Funding__c, Clinical_Program_Group_Name__c, Inactive__c 
                                                                                                                        from
                                                                                                                    Clinical_Program_Group__c 
                                                                                                                        where
                                                                                                                    RecordTypeId = : saveACopayGroupRtId and Inactive__c = false 
                                                                                                                                and
                                                                                                                                  (Funding__c = :fundingType OR Funding__c = :ANYLABEL) LIMIT 100];//Richa added condition of Funding = 'Any' for Req 5554
                    
                    
                }
                //Ends
                
                if (clinicalProgrameGroup.size() != 0) {
                    Clinical_Program_Group_Junction__c cpGroupJunction = null;
                    for (Clinical_Program_Group__c cpGroup: clinicalProgrameGroup) {
                        cpGroupJunction = new Clinical_Program_Group_Junction__c();
                        cpGroupJunction.Clinical_Program_Group_ID__c = cpGroup.Id;
                        cpGroupJunction.CRD_ID__c = crdId;
                        cpGroupJunction.Clinical_Program_Group_Name__c = cpGroup.Clinical_Program_Group_Name__c;
                        cpGroupJunction.Record_Type__c = SAVEACOPAY;
                        saveACopayGroup.add(cpGroupJunction);
                    }
                }
            } else {
                showfields = false;
                showCheckBox = false;
                crd.Copay_Dollar_Amount__c = null;
                crd.SAC_Override_Option__c = null;
            }
        } catch (exception e) {
                ApexPages.addMessages(e);
            }    
     }
/*Method: saveRecord()
  Purpose: This method checks for all the validations before saving the records
*/
    public boolean saveRecord() {
        try {
            noError = true;
            Integer selected = 0;
            Integer drugclass = 0; 
            String sacGroup = null;
            String formGroup = null;
            //#04786, Chetan - 05/08/2014 - When "Enroll in Save-A-Copay" equals ""No"" then the user should not be able to select any option for "Override option?". The field Override Option should not be visible.
            if( showCheckBox  && string.isEmpty(crd.SAC_Override_Option__c)){
                crd.SAC_Override_Option__c.addError(System.label.ERR00024);
                noError = false;
            }
            
            if (saveACopayGroup.size() != 0) {
                for (Clinical_Program_Group_Junction__c clinicalGroup: saveACopayGroup) {
                    if (clinicalGroup.Selected__c) {
                        selected = selected + 1;
                        sacGroup = clinicalGroup.Clinical_Program_Group_Name__c;
                    }
                }
            }
            
            if (saveACopayList.size() != 0) {
                for (Save_A_Copay_Junction__c savAcopay: saveACopayList) {
                    if (savAcopay.Selected__c) {
                        drugclass = drugclass + 1;
                    }
                }
            }
            if (crd.SAC_Override_Option__c == NOVALUE){  
                if (selected != 1){                //It is mandatory to select atleast one and only one record from Clinical Program Group object
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00113);
                    ApexPages.addMessage(myMsg);
                    noError = false;
                } else {                           //Validating that the Save-a-Copay group selected is valid for the formulary selected
                    list <Drug_Coverage__c> lstDC = new list <Drug_Coverage__c> ([Select id,CRD_ID__c,Formulary__c, Formulary_Group__c 
                                                                                        from 
                                                                                  Drug_Coverage__c 
                                                                                        where 
                                                                                  CRD_ID__c = :crdId AND Formulary_Group__c != null LIMIT 1]);
                    if(!lstDC.isempty() && lstDC.size() > 0){
                        if(lstDC[0].Formulary_Group__c.contains(VALUE)){
                            formGroup = VALUE;
                        } else if (lstDC[0].Formulary_Group__c.contains(PREMIER)){
                            formGroup = PREMIER;
                            }
                            else { //do Nothing
                           }
                        if (!sacGroup.contains(formGroup)) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR0291);
                            ApexPages.addMessage(myMsg);
                            noError = false;
                        }
                    } 
                 } 
            } else if (crd.SAC_Override_Option__c == YES && drugclass < 1){   //It is mandatory to select atleast one record from Clinical Program object
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00114);
                ApexPages.addMessage(myMsg);
                noError = false;
            } else { //Do Nothing
            }if (noError && (selected == 1 || drugclass >= 1 || crd.Do_you_want_to_do_Save_A_Copay__c != YES) ) {
                if (isChanged) {
                    List < Save_A_Copay_Junction__c > deleteSaveACopayList = new List < Save_A_Copay_Junction__c > ([Select Id
                                                                                                                        , Save_A_Copay_Drug_Class__c, Selected__c 
                                                                                                                        from 
                                                                                                                     Save_A_Copay_Junction__c 
                                                                                                                         where
                                                                                                                     CRD_ID__c = : crdid LIMIT 100]);
                    List < Clinical_Program_Group_Junction__c > deleteSaveACopayGroup = new List < Clinical_Program_Group_Junction__c > ([Select 
                                                                                                                                            Id, Selected__c 
                                                                                                                                                from 
                                                                                                                                          Clinical_Program_Group_Junction__c 
                                                                                                                                                where 
                                                                                                                                          CRD_ID__c = : crdid and Record_Type__c = :SAVEACOPAY LIMIT 100]);
                    if (deleteSaveACopayList.size() != 0) {
                        database.delete (deleteSaveACopayList);         //if any change is made, delete the existing records from Save-A-Copay Juntion object
                    }       
                    if (deleteSaveACopayGroup.size() != 0) {
                        database.delete (deleteSaveACopayGroup);       //if any change is made, delete the existing records from Clinical Program Group Junction object
                    }
                }
                if (saveACopayList.size() != 0) {
                    database.upsert (saveACopayList);              //Insert all the listed records from Clinical Program object to Save-A-Copay Juntion object with their respective 'Selected' option 
                }
                if (saveACopayGroup.size() != 0) {
                    database.upsert (saveACopayGroup);             //Insert all the listed records from Clinical Group Program object to Clinical Program Group Juntion object with their respective 'Selected' option 
                }  
            } else {
             //No Action required
             }        
            return noError;
        }  catch (exception e) {
                ApexPages.addMessages(e);
                return noError;
            }
    }
/*Method: redirectToPrograme1()
  Purpose: This method is called on the click of Back Button and redirects the user to NPL screen
*/  
    public Pagereference redirectToPrograme1() {
        try {
            if(!saveRecord()){
                    return null;    //Shows the validation error on screen if any and doesn't allow navigation
                } else {
                        Database.update (crd);
                        Pagereference pageRef = new Pagereference(BACKBUTTON + crdId);
                        pageRef.getParameters().put(EDITMODEPARAM,editMode);
                        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                        return pageRef;
                       } 
            } catch (exception e) {
                ApexPages.addMessages(e);
                return null;
             }   
    }

/*Method: redirectToPrograme12()
  Purpose: This method is called on the click of Back Button and redirects the user to NPL screen and saves changes for user in the public group
*/  
    public Pagereference redirectToPrograme12() {
        
        try {
                Database.update (crd);
                Pagereference pageRef = new Pagereference(BACKBUTTON + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            } catch (exception e) {
                ApexPages.addMessages(e);
                return null;
             } 
               
    }    
    
/*Method: redirectToRxCheck()
  Purpose: Purpose: This method is called on the click of Save and Next Button and redirects the user to PSP screen
*/  
    public Pagereference redirectToRxCheck() {
        try {
            if(!saveRecord()){
                return null;        //Shows the validation error on screen if any and doesn't allow navigation
            } else {
                    Database.update (crd);
                    //Modified by Amit Jain for Request 1125
                    Pagereference pageRef = new Pagereference(NEXTBUTTON + crdId);
                    pageRef.getParameters().put(EDITMODEPARAM,editMode);
                    pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                    return pageRef;
                   }
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
         }
    }
    
    /*Method: redirectToRxCheck2()
  Purpose: This method is called on the click of Next Button and redirects the user to PSP screen
*/  
    public Pagereference redirectToRxCheck2() {
        try {
            Pagereference pageRef = new Pagereference(NEXTBUTTON + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } catch (exception e) {
            ApexPages.addMessages(e);
            return null;
         }
    } 
    
}