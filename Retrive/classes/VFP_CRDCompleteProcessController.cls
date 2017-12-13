/*
Purpose: Apex  Controller Class for VF_CRDCompleteProcess
===============================================================================
History                                                            
-------------------------------------------------------------------------------
VERSION     AUTHOR                 DATE             DETAIL                                 
4.3         rakesh              03/29/2013          Request 00483: update Y-Schedule calculation
4.4         rakesh              04/18/2013          Request 00483: update Y-Schedule calculation based on flow-chart
4.5         rakesh              05/10/2013          Request 00483: removed validation 'All Custom Plans require an FCG'
4.6         Becca               05/21/2013          Request 01015: updated Conga parameters to allow for background processing
5.0         Sushant             02/24/2014          Added Comments.
6.0         Amit Jain           11 April'14         Modified for CVH Request 4702
6.1         Joognu Rao          16 June 2014        Implemented request no 4900
6.2         Joognu Rao          17 June 2014        Implemented request no 4868
6.3         Joognu Rao          21 Jan 2015         Implemented request no 5475
6.4         Joognu Rao          29 July 2015        Implemented request no 5964
6.5         Richa Gupta         25 Feb 2016         Implemented Req 6325
7.1         Bhaskar Arora       24 Nov 2016         Implemented Req 6773 
===============================================================================
*/
public class VFP_CRDCompleteProcessController {

    public boolean predefinedchk{
        get;
        set;
    }
    public boolean showXMLpopup{
        get;
        set;
    }
    Public CRD__c crd {
        get;
        set;
    }
    public user currentLoggedInUser {
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
    public string sessionId {
        get;
        set;
    }
    
    Public AI_Request__c aiRequest;
    private string subSegmentValue;
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING QUEUE = 'Queue';
    PRIVATE STATIC FINAL STRING CRDAPPREJ = 'CRD_Approval_Rejection';
    PRIVATE STATIC FINAL STRING AICVS = 'AIandCVSqueue';
    PRIVATE STATIC FINAL STRING CRDTEMP01 = 'CRD Template';
    PRIVATE STATIC FINAL STRING CRDHT = 'CRD - History Tracking';
    PRIVATE STATIC FINAL STRING CRDRT = 'CRD - New Record Tracking';
    PRIVATE STATIC FINAL STRING CRDTEMP1 = 'CRD Template 1';
    PRIVATE STATIC FINAL STRING CRDTEMP2 = 'CRD Template 2' ;
    PRIVATE STATIC FINAL STRING CRDEXCELTEMP = 'CRD Excel Template' ;
    PRIVATE STATIC FINAL STRING RXWAYSURL = '/apex/VF_AetnaRxWaysToSave?crdid=';
    PRIVATE STATIC FINAL STRING YESOPT = 'Yes';
    PRIVATE STATIC FINAL STRING NOOPT = 'No';
    PRIVATE STATIC FINAL STRING BCTPROFILE = 'BCT Consultant';
    PRIVATE STATIC FINAL STRING CONSUMERBUSINESSPLAN = 'Creating a packaged consumer business plan';
    PRIVATE STATIC FINAL STRING CLONINGCONSUMERPLAN = 'Cloning a packaged consumer business plan from an existing CRD';
    PRIVATE STATIC FINAL STRING OPTIONYES = 'YES';
    PRIVATE STATIC FINAL STRING SPLITFUNDED = 'Split Funded';
    PRIVATE STATIC FINAL STRING FULLYINSURED = 'Fully Insured';
    PRIVATE STATIC FINAL STRING RXPLANIDGENERATED = 'RxPlanId Generated';
    PRIVATE STATIC FINAL STRING CURRENTPAGENAME1 = 'currentPageName';
    PRIVATE STATIC FINAL STRING CBPARAM = 'CB';
    PRIVATE STATIC FINAL STRING ZERO = '0';
    PRIVATE STATIC FINAL STRING QUERYIDURL = '&QueryId=';
    PRIVATE STATIC FINAL STRING STRINGT = 'T';
    PRIVATE STATIC FINAL STRING STRINGZ = 'Z';
    PRIVATE STATIC FINAL STRING STRINGH = 'H';
    PRIVATE STATIC FINAL STRING STRINGR = 'R';
    PRIVATE STATIC FINAL STRING CTRQURLPARAMETER = '[CTRQ]';
    PRIVATE STATIC FINAL STRING GMFXMLURL = '/apex/GMF_xml_CRD?id=';
    PRIVATE STATIC FINAL STRING MEDICAL_PLATFORM = 'Traditional';
    PRIVATE STATIC FINAL STRING CLONE_CUSTOMPLAN = 'Cloning a custom plan from existing CRD';
    PRIVATE STATIC FINAL STRING CREATE_CUSTOMPLAN = 'Creating a custom plan';
    PRIVATE STATIC FINAL STRING CBSUCCESS = 'CB_Success';
    PRIVATE STATIC FINAL STRING COMMA = ',';
    PRIVATE STATIC FINAL STRING NEWRECORD = ' New Record';
    PRIVATE STATIC FINAL STRING AICOMMENT = 'Submitted for approval. Please approve.';
    PRIVATE STATIC FINAL STRING APPROVECRDCOMMENT = 'Approving request.';
    PRIVATE STATIC FINAL STRING APPROVECRDSECTION = 'Approve';
    PRIVATE STATIC FINAL STRING REJECTCRDCOMMENT = 'Rejecting request.';
    PRIVATE STATIC FINAL STRING REJECTCRDSECTION = 'Reject';
    PRIVATE STATIC FINAL STRING Y4 = 'Y4';
    PRIVATE STATIC FINAL STRING Y6 = 'Y6';
    PRIVATE STATIC FINAL STRING BLANKVAL = '';
    PRIVATE STATIC FINAL STRING SENDTOAIVAR = 'Send to AI';
    PRIVATE STATIC FINAL STRING MDYYYY = 'M/d/yyyy';
    PRIVATE STATIC FINAL STRING CREATEDBYID = 'CreatedById';
    PRIVATE STATIC FINAL STRING CREATEDDATE = 'CreatedDate';
    PRIVATE STATIC FINAL STRING STEP = '-Step ';
    PRIVATE STATIC FINAL STRING NUMBEROFSTEPS = 'Number_of_Steps__c';
    PRIVATE STATIC FINAL STRING Y = 'Y';
    PRIVATE STATIC FINAL STRING M = 'M';
    PRIVATE STATIC FINAL STRING N = 'N';
    PRIVATE STATIC FINAL STRING O = 'O';
    PRIVATE STATIC FINAL STRING HYPHEN = '-';
    PRIVATE STATIC FINAL STRING DSC = 'Drug_Specific_Copay_ID__c';
    PRIVATE STATIC FINAL STRING DSCOBJECT = 'Drug_Specific_Copay__c';
    PRIVATE STATIC FINAL STRING DSSC = 'Drug_Specific_Stepped_Copay__c';
    PRIVATE STATIC FINAL STRING YFIELD = 'Y__c';
    PRIVATE STATIC FINAL STRING MFIELD = 'M__c';
    PRIVATE STATIC FINAL STRING NFIELD = 'N__c';
    PRIVATE STATIC FINAL STRING OFIELD = 'O__c';
    PRIVATE STATIC FINAL STRING HYPHENWITHSPACE = ' - ';
    PRIVATE STATIC FINAL STRING DL = 'Drug_List__c';
    PRIVATE STATIC FINAL STRING DG = 'Drug_Group__c';
    PRIVATE STATIC FINAL STRING RECORDTYPEID = 'RecordTypeId';
    PRIVATE STATIC FINAL STRING SPACE = ' ';
    PRIVATE STATIC FINAL STRING DELIVERYSYSTEM = 'Delivery_System__c';
    PRIVATE STATIC FINAL STRING CUSTOM = 'Custom- ';
    PRIVATE STATIC FINAL STRING STANDARD = 'Standard__c';
    PRIVATE STATIC FINAL STRING STANDARDHYPHEN = 'Standard- ';
    PRIVATE STATIC FINAL STRING DC = 'Drug_Class__c';
    PRIVATE STATIC FINAL STRING WOD = 'Waiver_Of_Deductible__c';
    PRIVATE STATIC FINAL STRING HYPHENAPPLYLIMITATION = '- Apply Limitations:';
    PRIVATE STATIC FINAL STRING APPLYLIMITATION = 'Apply_Limitations__c';
    PRIVATE STATIC FINAL STRING INCLUSIONEXCLUSION = 'Inclusion_Exclusion__c';
    PRIVATE STATIC FINAL STRING RELATEDDC = 'Related_Drug_Coverage__c';
    PRIVATE STATIC FINAL STRING DCDL = 'DC_Drug_List_Group__c';
    PRIVATE STATIC FINAL STRING STDLC = 'Step_Therapy_DrugList_Class__c';
    PRIVATE STATIC FINAL STRING CRDSTJ = 'CRD_Step_Therapy_Junction__c';
    PRIVATE STATIC FINAL STRING QLCLASS = 'QL_Class__c';
    PRIVATE STATIC FINAL STRING CRDQLJ = 'CRD_Quantity_Limit_Junction__c';
    PRIVATE STATIC FINAL STRING PRECERTCLASS = 'Precert_Class__c';
    PRIVATE STATIC FINAL STRING CRDPRIORAUTHJUNCTION = 'CRD_PriorAuth_Junction__c';
    PRIVATE STATIC FINAL STRING DLID = 'Drug_List_ID__c';
    PRIVATE STATIC FINAL STRING AHAJUNCTION = 'AHA_Junction__c';
    PRIVATE STATIC FINAL STRING STCOPAY = 'SteppedCopay__c';
    PRIVATE STATIC FINAL STRING COPAYTIER = 'Copay_Tier__c';
    PRIVATE STATIC FINAL STRING SACJ = 'Save_A_Copay_Junction__c';
    PRIVATE STATIC FINAL STRING SAVEACOPAY = 'Save-A-Copay';
    PRIVATE STATIC FINAL STRING SACIDFIELD = 'Save_A_Copay_ID__c';
    public boolean popup{get;set;}
    //Added by JR to store recordtype id(CRD to PCG) of CSAP junction to implement request 5475
    private string recordTypeIdCSAP = system.label.CSAPrecordTypeId;
    
    
    GC_Utils_Method gcUtilsMethod = new GC_Utils_Method();    
    public list < String > errorMessages {
        get;
        set;
    }
    public list < ProcessInstanceWorkitem > lstWorkItemDetails {
        get;
        set;
    }
    
    public list < GroupMember  > lstQueueUsers {
        get;
        set;
    }
    public list < GroupMember  > listQueueUsers {
        get;
        set;
    }
    
    public Boolean showHideApproveReject {
        get;
        set;    
    }
    
    public Boolean showHideSendToAIandCVS {
        get;
        set;    
    }
     public TRANSIENT Map<id,string> copayTierRTMap;
     public TRANSIENT Map<string,user> createdBYNameMap {get;set;}
     public TRANSIENT List<List<wrapClassListObject>> wrapObjectListofList {get;set;}
     public TRANSIENT List<wrapClassListObject> wrapObjectList;
     public TRANSIENT Map<string,Drug_List__c> drugListMap;
     public TRANSIENT Map<String,Drug_Group__c> drugGroupMap;
     public TRANSIENT Map<id,Drug_Specific_Copay__c> dscMap;
     private Map < String, String > congaQ = new Map < String, String > ();
     public String templateId {get;set;}
     public String historyTemplateId {get;set;}
     public String newRecordTemplateId {get;set;}
     public String template1Id {get;set;}
     public String template2Id {get;set;}
     public String templateExlId {get;set;}
     public boolean bNonPkg{get;set;}
     public TRANSIENT Map<id,string> dcRecordTypeMap ;
     public TRANSIENT Map<string,string> recordTypeMap;
     public TRANSIENT Map<id,id> sacjCPIDMAP;
     public TRANSIENT Map<id,id> cpjCPGIDMAP;
     public TRANSIENT Map<id,Clinical_Program_Group__c> cpgCPGMAP;
/**
* Method :- VFP_CRDCompleteProcessController
* Description :- Method for VF_CRDCompleteProcessController Page
**/
    public VFP_CRDCompleteProcessController(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        lstQueueUsers = new list< GroupMember>();
        listQueueUsers = new list< GroupMember>();
        errorMessages = new list < String > ();
        wrapObjectListofList = new List<List<wrapClassListObject>>();
        wrapObjectList = new List<wrapClassListObject>();
        createdBYNameMap = new Map<string,user>([select id,Name from User limit 10000]);
        drugListMap = new Map<String,Drug_List__c>([select id,Name,Description__c  from Drug_List__c Limit 49000]);
        drugGroupMap = new Map<String,Drug_Group__c>([select id,Name from Drug_Group__c Limit 49000]);
        dcRecordTypeMap = new Map<id,string>();
        copayTierRTMap = new Map<id,string>();
        recordTypeMap = new Map<string,string>();
        dscMap = new Map<id,Drug_Specific_Copay__c>();
        sacjCPIDMAP = new Map<id,id>();
        cpjCPGIDMAP = new Map<id,id>();
        cpgCPGMAP = new Map<id,Clinical_Program_Group__c>();
        bNonPkg = false;
        popup = false;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        this.crd = [Select Y_Schd__c,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories 
                              where Field NOT IN('created') order by Createddate desc), Sub_segment__c,Effective_Date__c,ControlPlanEffective__c,Integration_1__c,Force_sent_to_AI__c,Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c,valid__c,complete__c, Query_String_Field__c,
                           Query_String_CRD_2__c, Query_String_Drug_Coverage__c, Override_Standard_Max_Pay__c,Account__r.Predefined__c,
                           LastSent__c, Partial_Control_Group__c, id, SAC_Override_Option__c, PSP_Override_Option__c,
                           Rx_Override_Option__c, Mail_Y_Schedule__c, PSP_Letter_Templates__c, Subsegment__c, High_Value_Client__c,
                           Partner_Server__c, Rating_ERB__c, API_Session_Id__c,  Rx_PP_ID__c,
                           Plan_Type_Specialty__c, Which_system_will_the_plan_be_installed__c, Plan_Type_Retail__c,
                           Plan_Type_Mail__c, TP_ID__c, Platform_Information__c, Does_the_client_want_to_do_COB__c,
                           Out_of_Network_Cost_Sharing__c, Do_you_want_to_do_Save_A_Copay__c, Enrolled_in_PA_for_other_condition__c,
                           Do_you_want_to_do_Step_Therapy__c, Client_Effective_Date__c,/*CA_50_Cost_Share_Applies__c,*/
                           Effective_Start_Date__c, Account__c, Are_you_creating_a_Package_Plan__c, Integrate_with_Medical__c,
                           Status__c, Name, Plan_Type_Paper__c, Name_of_Approver_on_SSD__c, Date_of_Approval_on_SSD__c,
                           Customization_Approved__c, Insured_Type__c, Risk_Indicator__c, Full_Control_Group__c,
                           Full_Control_Group__r.CSAP_Plan_ID__c, Full_Control_Group__r.CSAP_Control_ID__c,
                           Full_Control_Group__r.CSAP_Suffix_ID__c, Full_Control_Group__r.CSAP_Account_ID__c,Plan_Platform__c,Standard_or_Custom_Plan__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c,
                           Predefined__c,CRD_Automated__c,Non_Packaged_Plans__c,Archived__c,PERS_timestamp__c,RxPlanID__c,(Select id, controlplansummary__c, Related_External_Case__c, Fallout_Reason__c, PERS_timestamp__c, ControlPlanEffective__c from Cases__r where RecordType.name = 'Internal CRD/GMF Process' and status != 'Closed' ORDER BY createdDate DESC LIMIT 1)
                    From CRD__c
                    Where ID = : crdId LIMIT 100000];
        
        predefinedchk = crd.Predefined__c;
        
        // Request 6785
      
        for(Save_A_Copay_Junction__c sac :[select Save_A_Copay_ID__c from Save_A_Copay_Junction__c where CRD_ID__c = :crdId limit 1000]){
            sacjCPIDMAP.put(sac.id,sac.Save_A_Copay_ID__c);
        }
        
        for(Clinical_Program_Junction__c cpj:[select Clinical_Program__c,Clinical_Program_Group__c from Clinical_Program_Junction__c where Clinical_Program__c IN : sacjCPIDMAP.values()]){
                cpjCPGIDMAP.put(cpj.Clinical_Program__c,cpj.Clinical_Program_Group__c);
        }
        for(Clinical_Program_Group__c cpg : [select Clinical_Program_Group_Name__c from Clinical_Program_Group__c where id IN:cpjCPGIDMAP.values()]){
            cpgCPGMAP.put(cpg.id,cpg);
        }
        for(Drug_Specific_copay__c dscRec : [select RecordType.Name, M__c,N__c,O__c,Y__c,Drug_Group__r.Name,Drug_List__r.Name from Drug_Specific_Copay__c where CRD_ID__c=:crdId limit 10000]){
            dscMap.put(dscRec.id,dscRec);
        }
        
        for(Drug_Coverage__c dcRec:[select recordType.Name from Drug_Coverage__C where CRD_ID__c = :crdId limit 100]){
           dcRecordTypeMap.put(dcRec.id,dcRec.RecordType.Name);
        }
        for(copay_tier__c ct : [select Tier_Name__c from copay_tier__c where CRD__c = :crdId limit 100]){
            copayTierRTMap.put(ct.id,ct.Tier_Name__c );
        }
        Map<string,CRDChildInsertObject__c> customSetMap = CRDChildInsertObject__c.getAll();
        set<string> objectAPI = new set<string>();
        for(CRDChildInsertObject__c cusChild1 : customSetMap.values()){
            objectAPI.add(cusChild1.ObjectAPI__c);
        }
        Map<string,RecordType> objectRecordType = new Map<string,RecordType>([select Name from RecordType where sObjectType IN : objectAPI]);
        for(CRDChildInsertObject__c cusChild : customSetMap.values()){
            String subquery = '(select CreatedById,CreatedDate,parent.name from Histories where Field IN(' + '\''+ 'created' + '\'' + ') order by Createddate desc)';
            string crdIdTrim = crdId.substring(0,crdId.length()-3);
            String query = 'Select ' + cusChild.Field_API__c + ','+subquery+ ' FROM ' + cusChild.ObjectAPI__c + ' WHERE ' + cusChild.CRD_API__c + ' =' +  '\''+crdIdTrim+'\'' +' Order by Createddate desc';
            system.debug('$$$$$$ ' +query );
              if(cusChild.RecordTypeIDName__c != null){
                for(string idString: cusChild.RecordTypeIDName__c.split(';')){
                    if(objectRecordType.get(idString) != null){
                        recordTypeMap.put(idString,objectRecordType.get(idString).Name);
                    }
                }
            }
            
            List<sObject> sObjectRecord = Database.query(query);
           
            wrapObjectList = recordUniqueNameMethod(cusChild.Field_API__c,sObjectRecord,cusChild);
            wrapObjectListofList.add(wrapObjectList);
            
        }
     
        //Added by JR to implement request no 5475          
        if((CLONE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CREATE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && crd.Which_system_will_the_plan_be_installed__c!=null && MEDICAL_PLATFORM.equalsIgnoreCase(crd.Which_system_will_the_plan_be_installed__c)){
                    bNonPkg = true;
        }           
        else{
        }            
        //BCT Consultant
        currentLoggedInUser = [select id, profile.name from user where id = : UserInfo.getUserId()];
        pageName = ApexPages.CurrentPage().getParameters().get(CURRENTPAGENAME1);
        lstWorkItemDetails = new list < ProcessInstanceWorkitem > ();
        lstWorkItemDetails = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.OriginalActorId, p.Id, p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = : crd.id LIMIT 100000];
        for (APXT_CMQR__Conga_Merge_Query__c cq: [Select a.Id, a.APXT_CMQR__Name__c From APXT_CMQR__Conga_Merge_Query__c a WHERE a.APXT_CMQR__Name__c like 'CRD %' LIMIT 100000]) {
            congaQ.put(cq.APXT_CMQR__Name__c, substringVal(String.valueOf(cq.Id), 15));
        }
                        lstQueueUsers =[select id from GroupMember where UserOrGroupId = :UserInfo.getUserId() and groupid in (select id from Group where type=:QUEUE and developerName=:CRDAPPREJ ) LIMIT 100000];
                        if(lstQueueUsers != null && lstQueueUsers.size() >0){
                                showHideApproveReject = True;
                        }
                        else{
                                showHideApproveReject = False;
                        }    
                        
        //Added by JR to implement request no 4900
        
        listQueueUsers =[select id from GroupMember where UserOrGroupId = :UserInfo.getUserId() and groupid in (select id from Group where type=:QUEUE and developerName=:AICVS ) LIMIT 100000];
                        if(listQueueUsers != null && listQueueUsers.size() >0){
                                showHideSendToAIandCVS = True;
                        }
                        else{
                                showHideSendToAIandCVS = False;
                        } 
                        
        //Load Templates
        for(APXTConga4__Conga_Template__c template : [SELECT Id, APXTConga4__Name__c  from APXTConga4__Conga_Template__c 
                WHERE APXTConga4__Name__c in ('CRD Template', 'CRD - History Tracking', 'CRD - New Record Tracking', 'CRD Template 1', 'CRD Template 2', 'CRD Excel Template') LIMIT 100000]){
            if(CRDTEMP01.equalsIgnoreCase(template.APXTConga4__Name__c)){
                templateId = template.id;
            }else if(CRDHT.equalsIgnoreCase(template.APXTConga4__Name__c)){
                historyTemplateId = template.id;
            }else if(CRDRT.equalsIgnoreCase(template.APXTConga4__Name__c)){
                newRecordTemplateId = template.id;
            }else if(CRDTEMP1.equalsIgnoreCase(template.APXTConga4__Name__c)){
                template1Id = template.id;
            }else if(CRDTEMP2.equalsIgnoreCase(template.APXTConga4__Name__c)){
                template2Id = template.id;
            }else if(CRDEXCELTEMP.equalsIgnoreCase(template.APXTConga4__Name__c)){
                templateExlId = template.id;
            }
            else{
            //Do nothing
            } 
      }                   
    }
/**
* Method :- redirectToReporting
* Description :- Method for redirection to VF_AetnaRxWaysToSave Page
**/
    Public PageReference redirectToReporting() {
        try {
            database.update(crd);
            Pagereference pageRef = new Pagereference(RXWAYSURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } catch (exception e) {
            return Null;
        }
    }
    
/**
* Method :- redirectToReporting2
* Description :- Method for redirection to VF_AetnaRxWaysToSave Page
**/
    Public PageReference redirectToReporting2() {
        try {
            Pagereference pageRef = new Pagereference(RXWAYSURL + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        } catch (exception e) {
            return Null;
        }
    }  
   /**
    * Method : - predefinedupdate()
    * Description - This method update crd if predefined is changed
    **/
    public void predefinedupdate(){
        
            update crd;
         }
       
    
/**
* Method :- approveCRD
* Description :- Method for CRD Approval process
**/
    public PageReference approveCRD() {
        try {           
            if (lstWorkItemDetails.size() > 0) {
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments(APPROVECRDCOMMENT);
                req2.setAction(APPROVECRDSECTION);
                req2.setWorkitemId(lstWorkItemDetails.get(0).id);
                Approval.ProcessResult result2 = Approval.process(req2);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00097 + result2.isSuccess());
                ApexPages.addMessage(myMsg);
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00098 + result2.getInstanceStatus());
                ApexPages.addMessage(myMsg1);
            }
            Pagereference pageRef = new Pagereference(system.label.CL0000021);
            pageRef.setRedirect(true);
            return pageRef;

        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);

        }
        Pagereference pageRef = new Pagereference(system.label.CL0000021);
        pageRef.setRedirect(true);
        return pageRef;
    }

/**
* Method :- rejectCRD
* Description :- Method for CRD completion process
**/
    public PageReference rejectCRD() {
        try {
            if (lstWorkItemDetails.size() > 0) {
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments(REJECTCRDCOMMENT);
                req2.setAction(REJECTCRDSECTION);
                req2.setWorkitemId(lstWorkItemDetails.get(0).id);
                Approval.ProcessResult result2 = Approval.process(req2);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00099 + result2.isSuccess());
                ApexPages.addMessage(myMsg);
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00098 + result2.getInstanceStatus());
                ApexPages.addMessage(myMsg1);
            }

        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);

        }
        Pagereference pageRef = new Pagereference(system.label.CL0000021);
        pageRef.setRedirect(true);
        return pageRef;
    }
/**
* Method :- saveAndCompleteLater
* Description :- Method for CRD completion process
**/
    public PageReference saveAndCompleteLater() {
        try {
            overrideSubSegmentValue();
            
            Boolean hasError = false;
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && YESOPT.equalsIgnoreCase(crd.Are_you_creating_a_Package_Plan__c)  && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }



            overrideSubSegmentValue();
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);

            if (yScheduleList != null) {
                crd.Y_Schd__c = yScheduleList[0];
                crd.Pricing_Schedule__c = yScheduleList[0];
                crd.Mail_Y_Schedule__c = yScheduleList[1];
            } else {

            }
            overideYscheduleValues(); 
            try {
                string truncIntegration1;
                truncIntegration1 = IntegrationCtrlPlanExtractor.getString(crdId);
                crd.Integration_1__c = gcUtilsMethod.truncateString(truncIntegration1,5000);
                database.update(crd);
            } catch (exception e) {
                errorMessages.add(e.getMessage());
            }
            
            database.update(crd);
            Pagereference pageRef = new Pagereference(system.label.CL0000021);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (exception e) {
            return Null;
        }

    }
//Added by JR to implement request no 4900  
    /**
* Method :- sendToAIandCVS
* Description :- Method to send plan to AI and CVS
**/
    public PageReference sendToAIandCVS() {
        try {
        
            crd.valid__c =true;
            crd.complete__c = true;
            crd.CRD_Automated__c = true;
            crd.Aicallout__c  = false;
            database.update(crd);
            
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            
        }
        return null;

    }
    
    
    
/**
* Method :- completeAndSend
* Description :- Method for CRD completion process
**/
    public PageReference completeAndSend() {
        try {
            database.update(crd);
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(AICOMMENT);
            req.setObjectId(crd.id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            Pagereference pageRef = new Pagereference(system.label.CL0000021);
            pageRef.setRedirect(true);
            return pageRef;


        } catch (exception e) {

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;

        }

    }
/**
* Method :- generateRxPlanID
* Description :- Method for RxplanId Generation
**/    
    public void generateRxPlanID()
    {
        
            Integer min_size = 8;

            List<ConsumerBusiness__c> cB = [select id, name from ConsumerBusiness__c LIMIT 100000 FOR UPDATE ];//ConsumerBusiness__c.getAll().values();
           
            crd__c newInstance = [select id,Old_RxPlan_ID__c,RxPlanID__c from crd__c where id =: crdId LIMIT 100000];//new crd__c(id = crd.id);
            if(newInstance.RxPlanID__c!=null){
                newInstance.Old_RxPlan_ID__c = newInstance.RxPlanID__c;
            }
            newInstance.RxPlanID__c = CBPARAM + cB[0].name;
            
            
            database.update(newInstance);
            
            //update custom setting
            Integer cb_no = Integer.valueof(cB[0].name) + 1;
            
            List<ConsumerBusiness__c> c = [select id, name from ConsumerBusiness__c LIMIT 100000 FOR UPDATE ];//ConsumerBusiness__c.getAll().values();            
            database.delete(c);
            
            ConsumerBusiness__c newCB = new ConsumerBusiness__c();
            
                string cbNum = string.valueof(cb_no);
                for (Integer i = cbNum.length(); i < min_size; i++) {
                    cbNum = ZERO + cbNum;
                }
            
            newCB.name = cbNum;
            database.insert(newCB);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,RXPLANIDGENERATED);
            ApexPages.addMessage(myMsg);
            popup = false;
            //return null;
        
    }
   public void RXchk(){
    crd__c crdTemp = [Select RxPlanID__c from crd__c where id = :crd.id LIMIT 100000];
    
    if(crdTemp.RxPlanID__c==null){
        generateRxPlanID();
    }else{
        popup = true;
    }
   }

/**
* Method :- generateXML
* Description :- Method for XML Generation
**/
    Public Pagereference generateXML() {
        Pagereference pageRef = new Pagereference(GMFXMLURL + crdId);
        return pageref;
    }
/**
* Method :- getcongaComposerHistory
* Description :- Method for History tracking button
**/
    Public string getcongaComposerHistory() {

        string uRL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + crd.Id + '&QueryStringField=' + 'Query_String_Field_History_Tracking__c'
        //OFN added by Rishabh for request 302
        +
        '&templateId=' + historyTemplateId + /*'&
        =13' +*/ '&FP0=1' + '&OFN=' + crd.Name + ' Field History';
        return URL;
    }
/**
* Method :- getcongaComposerNewRecord
* Description :- Method for New Record tracking button
**/
    Public string getcongaComposerNewRecord() {
        string lastSentDateTime = String.ValueOfGMT(crd.LastSent__c);

        if (lastSentDateTime != null && !string.isblank(lastSentDateTime)) {
            lastSentDateTime = lastSentDateTime.substring(0, 10) + STRINGT + lastSentDateTime.substring(11) + STRINGZ;

            string uRL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + substringVal(crd.Id, 15) + '&QueryId=';

            if (congaQ.containsKey('CRD New Network Junction')) { // CMQ - 0000
                URL += '[NWJQ]' + congaQ.get('CRD New Network Junction') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ','; //Network Junction
            }

            if (congaQ.containsKey('CRD New Copays Tier')) { // CMQ - 0001
                URL += '[CTRQ]' + congaQ.get('CRD New Copays Tier') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ','; //Copay Tier
            }

            if (congaQ.containsKey('CRD New Stepped Copay')) { // CMQ - 0002
                URL += '[RSQ]' + congaQ.get('CRD New Stepped Copay') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ','; //Stepped Copay
            }

            if (congaQ.containsKey('CRD New Drug Specific Copay')) { // CMQ - 0003
                URL += '[RDSQ]' + congaQ.get('CRD New Drug Specific Copay') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ','; //Retail Drug Specific Copay
            }

            if (congaQ.containsKey('CRD New Drug Specific Stepped Copays')) { // CMQ - 0004
                URL += '[RDSSQ]' + congaQ.get('CRD New Drug Specific Stepped Copays') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ','; //Drug Specific Stepped Copay
            }

            if (congaQ.containsKey('CRD New DAW Specific Copay')) { //
                URL += '[DAWFR]' + congaQ.get('CRD New DAW Specific Copay') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            if (congaQ.containsKey('CRD New DAW Specific Stepped Copay')) { //
                URL += '[DAWSFR]' + congaQ.get('CRD New DAW Specific Stepped Copay') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            if (congaQ.containsKey('CRD New Drug Coverage')) { // CMQ - 0005
                URL += '[DCRQ]' + congaQ.get('CRD New Drug Coverage') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            if (congaQ.containsKey('CRD New DC Drug List/Group')) {
                URL += '[DCDLG]' + congaQ.get('CRD New DC Drug List/Group') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            //Added by Richa for Req-4731
            if (congaQ.containsKey('CRD Waiver Of Deductible - New Record')) { // CMQ - 1198
                URL += '[WOD]' + congaQ.get('CRD Waiver Of Deductible - New Record') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            if (congaQ.containsKey('CRD New Accumulations')) { // CMQ - 0006
                URL += '[AQ]' + congaQ.get('CRD New Accumulations') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            if (congaQ.containsKey('CRD New Accumulations Specific Drug')) { // CMQ - 0007
                URL += '[ADSQ]' + congaQ.get('CRD New Accumulations Specific Drug') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }

            //if (congaQ.containsKey('CRD New CVS Web Access Users')) { // CMQ - 0015
            //    URL += '[CWAQ]' + congaQ.get('CRD New CVS Web Access Users') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            //} Commented By Sushant: Req 04937            
            if (congaQ.containsKey('CRD New CSAP/CGLP Junction')) { // CMQ - 0015
                URL += '[FULLCSAPCGLP]' + congaQ.get('CRD New CSAP/CGLP Junction') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=CRD+to+Full+CG' + '~pv2=' + lastSentDateTime + ',';
            }
            /*if (congaQ.containsKey('CRD DC Copay - New record')) {
                URL += '[DCC]' + congaQ.get('CRD DC Copay - New record') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            if (congaQ.containsKey('CRD DC Stepped Copay - New Record')) {
                URL += '[DCSC]' + congaQ.get('CRD DC Stepped Copay - New Record') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }*/
            if (congaQ.containsKey('CRD New Accumulations Change Copay')) {
                URL += '[ACC]' + congaQ.get('CRD New Accumulations Change Copay') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            if (congaQ.containsKey('CRD New Accumulations Change Copay Stepped')) {
                URL += '[ACCS]' + congaQ.get('CRD New Accumulations Change Copay Stepped') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            if (congaQ.containsKey('CRD AHO Junction')) {
                URL += '[AHO]' + congaQ.get('CRD AHO Junction') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            // if (congaQ.containsKey('CRD MOOP Bypass New Record Tracker')){
            //     URL += '[MBP]' + congaQ.get('CRD MOOP Bypass New Record Tracker') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            // } Commented By Sushant: Req 04937
            if (congaQ.containsKey('CRD RxStep Junction New Record Tracker')){
                URL += '[ARJRT]' + congaQ.get('CRD RxStep Junction New Record Tracker') + '?pv0=' + substringVal(crd.Id, 15) + '~pv1=' + lastSentDateTime + ',';
            }
            if (null != newRecordTemplateId) { // template reference
                URL += '&TemplateId=' + newRecordTemplateId + /*'&DS7=13'*/ + '&FP0=1' + '&OFN=' + crd.Name + ' New Record';

            }
            return URL;
        } else {return null;}
    }
/**
* Method :- getcongaComposer
* Description :- Method for Conga Composer button
**/
    Public string getcongaComposer() {

        string query = crd.Query_String_Field__c + crd.Query_String_Drug_Coverage__c;
        string uRL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + crd.Id
        //+'&QueryStringField='+'Query_String_Field__c'
        +
        '&QueryStringField=' + Query + '&PDFDateTimeStamp=' + System.now()
        //OFN added by Rishabh for request 302
        +
        '&OFN=' + crd.Name + ' Full CRD';
        return URL;
    }

    private String substringVal(String textValue, Integer length) {
        if (null == textValue) {
            textValue = BLANKVAL;
        }

        if (textValue.length() > length) {
            textValue = textValue.substring(0, length);
        }

        return textValue;
    }
/**
* Method :- checkMandatoryFields
* Description :- Method for mandatory field check
**/
    public boolean checkMandatoryFields() {

        boolean isCriteriaCompleted;
        isCriteriaCompleted = true;
        if (crd.Are_you_creating_a_Package_Plan__c == null || crd.Account__c == null || crd.Effective_Start_Date__c == null || crd.Client_Effective_Date__c == null /*|| crd.Implementations_Date__c == null*/ || crd.Do_you_want_to_do_Step_Therapy__c == null || crd.Enrolled_in_PA_for_other_condition__c == null || crd.Do_you_want_to_do_Save_A_Copay__c == null || crd.Out_of_Network_Cost_Sharing__c == null || crd.Does_the_client_want_to_do_COB__c == null) {
            isCriteriaCompleted = false;
        }
        return isCriteriaCompleted;
    }
/**
* Method :- getHideForBCTC
* Description :- Method for BCT Team field check
**/
    Public boolean getHideForBCTC() {
        boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId() LIMIT 100000].Profile.Name;
        if ((BCTPROFILE.equalsIgnoreCase(usrProfileName)) || (CONSUMERBUSINESSPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONINGCONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c))) {
            check = false;
        } else if((crd.Standard_or_Custom_Plan__c != CONSUMERBUSINESSPLAN || crd.Standard_or_Custom_Plan__c !=CLONINGCONSUMERPLAN)){
            check = true;
        }
        else{ //Do nothing    
        }
        return check;
    }
    
/**
* Method :- getHideConsumerPlan
* Description :- Method for BCT Team field check
**/
    Public boolean getHideConsumerPlan() {
        boolean check = false;
        if((CONSUMERBUSINESSPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONINGCONSUMERPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && (OPTIONYES.equalsIgnoreCase(system.label.Consumer_Platform))){
            
            check = true;
        }
        return check;
    }
    
/**
* Method :- getcongaCRDAuditComposer
* Description :- Method for CRD Audit Tracking
**/ 
    Public string getcongaCRDAuditComposer() {

        string uRL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + substringVal(crd.Id, 15) + '&QueryStringField=' + 'Query_String_CRD_Audit__c'
        //OFN added by Rishabh for request 302
        //   +'&OFN='+crd.Name;
        +
        '&OFN=' + crd.Name + system.now();


        return URL;
    }
/**
* Method :- overideYscheduleValues
* Description :- Method for overide Yschedule Values
**/ 

    public void overideYscheduleValues() {
        if (crd.Override_Retail_Y_Schedule__c != null && YESOPT.equalsIgnoreCase(crd.Override_Retail_Y_Schedule__c)) {
            crd.Y_Schd__c = crd.Retail_Y_Schedule_Override__c;
            crd.Pricing_Schedule__c = crd.Retail_Y_Schedule_Override__c;
        }
    }
/**
* Method :- sendToAi1
* Description :- Method for sendToAi button
**/
    public void sendToAi1() {
        errorMessages.clear();
        /* Commented By Nitsh ST#669
        // Chetan - 4/22/2014- Set Predefined PCG/FCG if CRd.P
        if(crd.Predefined__c == true){
            crd.Partial_Control_Group__c = LABEL.CL0000052;
            crd.Full_Control_Group__c = LABEL.CL0000051;
        }
      */
        Boolean isValidAccum = True;
        GC_Validation_Methods checkAccum = new GC_Validation_Methods();
        if (!checkAccum.checkChangeCopay(crd.id)) {
            isValidAccum = False;
            errorMessages.add(system.Label.ERR00147);
        }
        overrideSubSegmentValue();
        if (crd.Are_you_creating_a_Package_Plan__c != null && NOOPT.equalsIgnoreCase(crd.Are_you_creating_a_Package_Plan__c) && crd.Full_Control_Group__c == null) {
            errorMessages.add(system.label.ERR00134);
        } else if ((SPLITFUNDED.equalsIgnoreCase(crd.Insured_Type__c) || FULLYINSURED.equalsIgnoreCase(crd.Insured_Type__c)) && crd.Are_you_creating_a_Package_Plan__c != null && YESOPT.equalsIgnoreCase(crd.Are_you_creating_a_Package_Plan__c) && crd.Full_Control_Group__c != null) {
            errorMessages.add(system.label.ERR00135);
        } else {
            VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
            crd.Integrating_User__c = currentLoggedInUser.Id;

            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = STRINGH;
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = STRINGT;
            }
            else { //Do nothing
            }            
            overrideSubSegmentValue();
            
            Boolean hasError = false;
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && YESOPT.equalsIgnoreCase(crd.Are_you_creating_a_Package_Plan__c) && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }

            overrideSubSegmentValue();
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);
            //Modified by Amit for Request 4702, 11th April '14****
            //Set the Retail Y-schedule, Pricing Schedule, Mail Y-schedule to dafault values when Prdefined checkbox is selected
            If(crd.Predefined__c == True){
                    crd.Y_Schd__c = Y4;
                    crd.Pricing_Schedule__c = Y4;
                    crd.Mail_Y_Schedule__c = Y6;  
            } 
            else {
                        if (yScheduleList != null) {
                            crd.Y_Schd__c = yScheduleList[0];
                            crd.Pricing_Schedule__c = yScheduleList[0];
                            crd.Mail_Y_Schedule__c = yScheduleList[1];
                        } else {
            
                        }
            }     
               overideYscheduleValues();  
            //**ends Request 4702
            try {
                string truncIntegration1;
                truncIntegration1 = IntegrationCtrlPlanExtractor.getString(crdId);
                //Modified by Amit for Request 4702, 11th April '14****
                //Set the Integration 1 field to dafault value when Prdefined checkbox is selected
                If(crd.Predefined__c == True){
                    crd.Integration_1__c = system.label.CL0000050;
                }
                else{
                    crd.Integration_1__c = gcUtilsMethod.truncateString(truncIntegration1,5000);
                }
                //**Ends Request 4702
                database.update(crd);
            } catch (exception e) {
                errorMessages.add(e.getMessage());
            }
            
            

            boolean isCriteriaSet;
            isCriteriaSet = true;
            if (isCriteriaSet == false) {

                errorMessages.add(system.label.ERR00100);
            }
            else if (crd.Platform_Information__c != Null && !(string.isblank(crd.Platform_Information__c)) && crd.TP_ID__c == Null && crd.Rx_PP_ID__c == Null && !string.isblank(crd.Y_Schd__c) && isValidAccum) {
                aiRequest = new AI_Request__c();
                aiRequest.CRD_ID__c = crd.Id;
                //Modified by Amit for Request 4702, 11th April '14****
                //Set the Request Type as and Risk Indicator as STRINGR when Prdefined checkbox is selected
                If(crd.Predefined__c == True){
                    aiRequest.Request_Type__c = system.label.CL0000049;
                    aiRequest.Risk_Indicator__c = STRINGR;
                }
                else{
                    aiRequest.Request_Type__c = system.label.CL0000033;
                    aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;    
                }
                //**Ends Request 4702   
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;               
                aiRequest.Integration_1__c = crd.Integration_1__c;

                List < string > RxPlanData = new list< string >() ;
                RxPlanData = sendToAI.SendToAI(crdId);
                system.debug(RxPlanData[0] + RxPlanData.size());
                crd.RxPlanData__c = RxPlanData[0];
                if (RxPlanData.size() > 1) {
                    crd.RxPlanDataExp__c = RxPlanData[1].trim();
                    aiRequest.Benefits_String_Extn__c = RxPlanData[1].trim();
                }
                crd.Integration_Status__c = SENDTOAIVAR;
                aiRequest.Benefit__c = RxPlanData[0];

                crd.CRD_Automated__c = false;//Richa added for Req - 4868 : added the field in query above
                crd.Force_sent_to_AI__c = true;//added by JR for Req - 4868 : added the field in query above               
                database.update(crd);
                database.insert(aiRequest);
            } else if (crd.TP_ID__c != Null || crd.Rx_PP_ID__c != Null) {
                errorMessages.add(system.label.ERR00101);
            } else {
                errorMessages.add(system.label.ERR00102);
            }
        }
    }

/**
* Method :- getcongaComposerPDF1
* Description :- Testing for 2 pdf approach : Added by Sourabh
**/    
    Public string getcongaComposerPDF1() {

        string URL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + crd.Id + '&QueryStringField=' + 'Query_String_CRD__c' + '&PDFDateTimeStamp=' + System.now() + '&templateId=' + template1Id + '&DS7=13' + '&FP0=1' +'&OFN=' + crd.Name + ' Full CRD - 1';
        return URL;
    }
/**
* Method :- getcongaComposerPDF2
* Description :- Testing for 2 pdf approach : Added by Sourabh
**/
    Public string getcongaComposerPDF2() {

        string URL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + crd.Id + '&QueryStringField=' + 'Query_String_CRD_2__c' + '&PDFDateTimeStamp=' + System.now() + '&templateId=' + template2Id + '&DS7=13' + '&FP0=1' + '&OFN=' + crd.Name + ' Full CRD - 2';
        return URL;
    }
    // Ended Sourabh
     /**
* Method :- getcongaComposerCombo
* Description :- Testing for 1 excel approach : Added by Becca
**/    
    Public string getcongaComposerCombo() {

        string URL = 'https://composer.congamerge.com' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd.Partner_Server__c, 'UTF-8') + '&id=' + crd.Id + '&QueryStringField='+ 'Query_String_Combo__c' + '&PDFDateTimeStamp=' + System.now() + '&templateId=' + templateExlId + /*'&DS7=13' +*/ '&OFN=' + crd.Name + ' Full CRD';
        return URL;
    }
/**
* Method :- callout
* Description :- Callout method
**/
    Public Pagereference callout() {

        WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
        WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();
        if (aiRequest != null) {
            try {
                crdDetail.requestId = aiRequest.Id;
                crdDetail.crdId = aiRequest.CRD_ID__c;
                crdDetail.requestType = aiRequest.Request_Type__c;
                if (aiRequest.Plan_ID__c != null) {
                    crdDetail.planId = aiRequest.Plan_ID__c;
                }
                if (aiRequest.Benefit__c != null) {
                    crdDetail.benefitsString = aiRequest.Benefit__c;
                }
                if (aiRequest.Benefits_String_Extn__c != null) {
                    crdDetail.benefitsStringExtension = aiRequest.Benefits_String_Extn__c;
                }
                if (aiRequest.Integration_1__c != null) {
                    crdDetail.traditionalControlNumberPlanSummaryDetails = aiRequest.Integration_1__c;
                }
                if (aiRequest.Pricing_Schedule__c != null) {
                    crdDetail.pricingSchedule = aiRequest.Pricing_Schedule__c;
                }
                if (aiRequest.Risk_Indicator__c != null) {
                    crdDetail.riskIndicator = aiRequest.Risk_Indicator__c;
                }
                if (aiRequest.StateList_to_Remove__c != null) {
                    crdDetail.listOfStatesToRemoveFromPlan = aiRequest.StateList_to_Remove__c;
                }
                if (aiRequest.Request_Type__c.contains(system.label.CL0000035)) {
                    crdDetail.benefitsApplyToAllStates = string.valueof(aiRequest.State_Mandates_Apply__c);
                    crdDetail.benefitsStateList = aiRequest.States_List_for_Mandate__c;
                }

                integrationClass.SessionId = Userinfo.getsessionId();
                integrationClass.CRDDetails = crdDetail;
                WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();
                sendData.endpoint_x = system.label.CL0000034;

                Boolean result = sendData.createRxPlan(integrationClass);

                if (result) {
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00106));
                    Pagereference pageRef = new Pagereference(system.label.CL0000021);
                    pageRef.setRedirect(true);
                    return pageRef;
                } else {
                    errorMessages.add(system.label.ERR00127);
                    return Null;
                }
            } catch (exception e) {
                errorMessages.add(system.label.ERR00127);
                return null;
            }
        } else {
            errorMessages.add(system.label.ERR00128);
            return null;
        }

    }
    public void updateOnHoldStatus() {
        crd.Status__c = 'Holding - Interim State';
        database.update(crd);
    }
   
    //Added by JR to implement request no 05475 on 21/01/2015
    //Commented Auto complete process
        /**
    * Method :- autoCompleteProcess
    * Description :- method to include manually created plans into post build process.
                    When user clicks on 'Auto Complete' button,it checks if the plan is already processed,
                    archived, a non-package plan or automated and throws appropriate error
    
   public void autoCompleteProcess() {
       if(crd.AutoCompleteProcess__c){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRAlreadyProcessed);
        ApexPages.addMessage(myMsgs);
       }if(crd.RxPlanID__c==null){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRRxplanidmissing);
        ApexPages.addMessage(myMsgs);
       }if(crd.Archived__c){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRArchivedCRD);
        ApexPages.addMessage(myMsgs);
       }if(!((CLONE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CREATE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && MEDICAL_PLATFORM.equalsIgnoreCase(crd.Which_system_will_the_plan_be_installed__c))){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRpackageplan);
        ApexPages.addMessage(myMsgs);
       }if(crd.PERS_timestamp__c==null){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRPERStimestamp);
        ApexPages.addMessage(myMsgs);
       }if(crd.Cases__r.size()==0 || crd.Cases__r.isempty()){
        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ERRAutoCompleteValidation);
        ApexPages.addMessage(myMsgs);   
       }if(!crd.AutoCompleteProcess__c && crd.RxPlanID__c!=null && !crd.Archived__c && ((CLONE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CREATE_CUSTOMPLAN.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c)) && MEDICAL_PLATFORM.equalsIgnoreCase(crd.Which_system_will_the_plan_be_installed__c)) && crd.PERS_timestamp__c!=null && crd.Cases__r.size()!=0)
           {            
            List<CSAP_CGLP_Junction__c>lstCSAPjunc = [select id,CRD__c from CSAP_CGLP_Junction__c where recordtypeid =:recordTypeIdCSAP and CRD__c=:crd.id LIMIT 100000];
            if(lstCSAPjunc.size()>1){
                ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ErrPCG);
                ApexPages.addMessage(myMsgs);
            }else{
                crd.AutoCompleteProcess__c = true; 
                // Check if CBON already exists
                List<CRDBuildOrder__c> lstcbuild =[select id,PostBuildOnly__c,CRD__c,Control__c,Plan__c,Control_Plan_Effective__c,PERS_timestamp__c from CRDBuildOrder__c where CRD__c =:crd.id LIMIT 100000]; 
                if(lstcbuild.isempty()||lstcbuild.size()==0){  
                    CRDBuildOrder__c cbon = new CRDBuildOrder__c();
                    cbon.Build__c = true;
                    cbon.valid__c = true;
                    cbon.Aicallout__c = true;
                    cbon.complete__c = true;
                    cbon.Sent_AI_request__c = true;
                    cbon.PostBuildOnly__c=true   ;
                    cbon.PERS_timestamp__c = crd.PERS_timestamp__c;
                    if(crd.Integration_1__c!=null){
                        
                        crd.Plan__c = (((crd.Integration_1__c).substringAfter(COMMA)).substringBefore(COMMA)).trim();
                        crd.Control__c = (((crd.Integration_1__c).substringBefore(COMMA)));
                        cbon.Control__c = integer.valueof(crd.Control__c);
                        cbon.Plan__c =  crd.Plan__c;
                        
                    }
                    cbon.Effective_date__c = crd.Effective_Start_Date__c;
                    crd.Effective_Date__c = crd.Effective_Start_Date__c;
                    // added by abhishek for observation 38
                    String effectiveDate = DateTime.newInstance(crd.Effective_Start_Date__c,Time.newInstance(0,0,0,0)).format(MDYYYY);
                    cbon.Control_Plan_Effective__c = (((crd.Integration_1__c).substringBefore(COMMA)))+(((crd.Integration_1__c).substringAfter(COMMA)).substringBefore(COMMA)).trim()+effectiveDate;
                    cbon.CRD__c = crd.id;
                    cbon.What_is_the_carrier__c = crd.Plan_Platform__c;
                    cbon.Subsegment__c = crd.Subsegment__c;
                    for (Case cs : crd.Cases__r){//Richa added Internal Case as Success Case on CBON
                        cbon.Success_Case__c = cs.id;
                        cs.controlplansummary__c = cbon.Control__c + '_' + cbon.Plan__c;
                        cs.Related_External_Case__c = null;
                        cs.Fallout_Reason__c = CBSUCCESS;
                        cs.PERS_timestamp__c = cbon.PERS_timestamp__c;
                        cs.ControlPlanEffective__c = cbon.Control_Plan_Effective__c;
                        database.update(cs); //Update will execute only once
                    }
                    database.update(crd);            
                    database.insert(cbon);
                    
                }else if(!lstcbuild.isempty()||lstcbuild.size()>0){
                    if(lstcbuild[0].PostBuildOnly__c==true){
                        ApexPages.Message myMsgs = new ApexPages.Message(ApexPages.Severity.error, system.label.ErrCBONexists);
                        ApexPages.addMessage(myMsgs);
                    }else{
                        List<CRDBuildOrder__c>lstCbonsToUpdate = new List<CRDBuildOrder__c>();
                        for(CRDBuildOrder__c objCBON : lstcbuild){
                            objCBON.Build__c = true;
                            objCBON.valid__c = true;
                            objCBON.Aicallout__c = true;
                            objCBON.complete__c = true;
                            objCBON.Sent_AI_request__c = true;
                            objCBON.CRD__c = crd.id;
                            objCBON.PostBuildOnly__c=true   ;
                            objCBON.PERS__c= false;
                            objCBON.CAG__c= false;
                            objCBON.XML__c= false;
                            objCBON.Ready_to_Archive__c= false;
                            objCBON.PDF__c= false;
                            objCBON.CVS__c= false;
                            objCBON.ExistingRxplan__c= false;
                            objCBON.Ignored__c = false;
                            objCBON.Case__c= null;
                            objCBON.FalloutCase__c= null;
                            for (Case cs : crd.Cases__r){//Richa added Internal Case as Success Case on CBON
                                objCBON.Success_Case__c = cs.id;
                                cs.controlplansummary__c = objcbon.Control__c + '_' + objcbon.Plan__c;
                                cs.Related_External_Case__c = null;
                                cs.Fallout_Reason__c = CBSUCCESS;
                                cs.PERS_timestamp__c = objcbon.PERS_timestamp__c;
                                cs.ControlPlanEffective__c = objcbon.Control_Plan_Effective__c;
                                database.update(cs); //Update will execute only once
                            }
                            lstCbonsToUpdate.add(objCBON);
                        }
                        database.update(lstCbonsToUpdate);
                        database.update(crd);
                    }
                }
                else { //Do nothing
                }
            }
        }
    }
**/
/**
* Method :- chkExtCase
* Description :- method to check if this external case has already been shared to CVS for Req 6325
**/ 
    public PageReference chkExtCase() {
    system.debug('@@@@'+showXMLpopup );
        //showXMLpopup = false;
        CVSRxPlanId__c existingRxPlan;
        if (crd.RxPlanID__c != null ) {
            list<CVSRxPlanId__c> test = new list<CVSRxPlanId__c>([Select id from CVSRxPlanId__c where RxPlanId__c = :crd.RxPlanID__c LIMIT 1]);
          if(test.size() > 0)
                existingRxPlan = test[0];
                if(!crd.CRD_Automated__c && existingRxPlan == null){
                    CVSRxPlanId__c createCVSRxPlan = new CVSRxPlanId__c();
                    createCVSRxPlan.RxPlanId__c = crd.RxPlanID__c;
                    createCVSRxPlan.CRD_Name__c = crd.name;
                    showXMLpopup = false;
                    Database.insert (createCVSRxPlan) ;
                } else if(!crd.CRD_Automated__c && existingRxPlan != null){
                        showXMLpopup = true;
                    } else if (crd.CRD_Automated__c){
                                CRDBuildOrder__c cbon =[Select id,Case__c,ExistingRxplan__c from CRDBuildOrder__c where CRD__c =:crd.id LIMIT 1];
                                if(cbon != null && cbon.ExistingRxplan__c){
                                    showXMLpopup = true;
                                } else if(cbon != null && !cbon.ExistingRxplan__c && cbon.case__c != null ){
                                        showXMLpopup = true;
                                    } else if (cbon != null && !cbon.ExistingRxplan__c && cbon.case__c == null && existingRxPlan == null){
                                            CVSRxPlanId__c createCVSRxPlan = new CVSRxPlanId__c();
                                            createCVSRxPlan.RxPlanId__c = crd.RxPlanID__c;
                                            createCVSRxPlan.CRD_Name__c = crd.name;
                                            showXMLpopup = false;
                                            Database.insert (createCVSRxPlan) ;
                                        }
                                }
        }  else {
                    showXMLpopup = false;    
                }
                
                    return null;//remoteaction 
    }
/**
* Method :- updateCRDstatus
* Description :- method to update CRD status to 'Existing RxPlanID' for Req 6325
**/ 
    public void updateCRDstatus() {
      list<CVSRxPlanId__c> test = new list<CVSRxPlanId__c>([Select id,CRD_Name__c from CVSRxPlanId__c where RxPlanId__c = :crd.RxPlanID__c LIMIT 1]);
      if(test[0].CRD_Name__c != crd.name && crd.Status__c != 'Existing RxPlanID'){
        crd.Status__c = 'Existing RxPlanID';  
        Database.update(crd,false); 
    } 
}
/**
* Method :- overrideSubSegmentValue
* Description :- method to override values provided by user
**/ 
    public void overrideSubSegmentValue() {
        if (crd.Sub_segment__c != null) {
            subSegmentValue = crd.Sub_segment__c;
        } else {
            subSegmentValue = crd.Subsegment__c;
        }
    }
    /** 
    Request - 06785 
    Wrapper class to hold list of child objects of CRD 
    **/
   public class wrapClassListObject{
        
        public id createdBy {get;set;}
        public string recordUniqueName {get;set;}
        public string createdOn {get;set;}
        public string HeaderName {get;set;}
       
        public wrapClassListObject(id createdBy,String recordUniqueName,string createdOn,string HeaderName ){
            
            this.createdBy = createdBy;
            this.recordUniqueName = recordUniqueName;
            this.createdOn = createdOn;
            this.HeaderName = HeaderName ;
        }
    }
    
    /**
     * Request - 06785
     * Method - recordUniqueNameMethod()
     * Description - This method load wrapper object to display list of created object history on vf page
    **/
    public List<wrapClassListObject> recordUniqueNameMethod(string fieldAPI , List<sObject> sObjectRecordList , CRDChildInsertObject__c customSetRec){
        
        List<wrapClassListObject> wrapperListInstance = new List<wrapClassListObject>();
        for(sObject objRec : sObjectRecordList){
               string recordUniqueString = BLANKVAL;
               if(string.valueof(objRec.getsObjectType()) != WOD && string.valueof(objRec.getsObjectType()) != DSCOBJECT && string.valueof(objRec.getsObjectType()) != DSSC){ 
                    if(string.valueof(objRec.getsObjectType()) == AHAJUNCTION){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                                if(fieldName == DLID && objRec.get(fieldName) != null){
                                    String drugListDesc = drugListMap.get((string)objRec.get(fieldName)).Description__c;
                                    recordUniqueString = recordUniqueString + drugListDesc;
                                }
                            }
                        }
                    }
                    else  if(string.valueof(objRec.getsObjectType()) == CRDPRIORAUTHJUNCTION){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                                if(fieldName == PRECERTCLASS && objRec.get(fieldName) != null){
                                    String drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                                    recordUniqueString = recordUniqueString + drugListName;
                                }
                            }
                        }
                    }
                    else  if(string.valueof(objRec.getsObjectType()) == CRDQLJ){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                                if(fieldName == QLCLASS && objRec.get(fieldName) != null){
                                    String drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                                    recordUniqueString = recordUniqueString + drugListName;
                                }
                            }
                        }
                    }
                    else  if(string.valueof(objRec.getsObjectType()) == CRDSTJ){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                                if(fieldName == STDLC && objRec.get(fieldName) != null){
                                    String drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                                    recordUniqueString = recordUniqueString + drugListName;
                                }
                            }
                        }
                    }
                    
                     else  if(string.valueof(objRec.getsObjectType()) == SACJ){
                               for(string fieldName : fieldAPI.split(COMMA)){
                                   system.debug('sacjCPIDMAP+++ ' + sacjCPIDMAP);
                                   system.debug('cpjCPGIDMAP+++ ' + cpjCPGIDMAP);
                                   system.debug('cpgCPGMAP++++ ' +cpgCPGMAP);
                                    if(fieldName == SACIDFIELD){
                                    if(sacjCPIDMAP.size()>0 && cpjCPGIDMAP.containskey(sacjCPIDMAP.get((id)objRec.id)) && cpjCPGIDMAP.size()>0 && cpgCPGMAP.size()>0){
                                        recordUniqueString =  cpgCPGMAP.get(cpjCPGIDMAP.get(sacjCPIDMAP.get((id)objRec.id))).Clinical_Program_Group_Name__c;
                                    }
                                  }
                           }
                     }
                     
                    else  if(string.valueof(objRec.getsObjectType()) == DCDL){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName == RELATEDDC && objRec.get(fieldName) != null){
                                    recordUniqueString = recordUniqueString + dcRecordTypeMap.get((id)objRec.get(fieldName));
                                }
                            else if(fieldName == DG && objRec.get(fieldName) != null){
                                string drugGroupName = drugGroupMap.get((string)objRec.get(fieldName)).Name;
                                recordUniqueString = recordUniqueString +HYPHEN + drugGroupName ;
                            }
                              else if(fieldName == DL && objRec.get(fieldName) != null){
                                string drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                                recordUniqueString = recordUniqueString +HYPHEN+ drugListName ;
                            }
                            else if(fieldName == INCLUSIONEXCLUSION && objRec.get(fieldName) != null){
                                recordUniqueString = recordUniqueString +HYPHEN + objRec.get(fieldName);
                            }
                            else if(fieldName == APPLYLIMITATION && objRec.get(fieldName) != null){
                                recordUniqueString = recordUniqueString +HYPHENAPPLYLIMITATION + objRec.get(fieldName);
                            }
                        }
                    }
                    else  if(string.valueof(objRec.getsObjectType()) == STCOPAY){
                        for(string fieldName : fieldAPI.split(COMMA)){
                            if(fieldName == COPAYTIER){
                                recordUniqueString = recordUniqueString + SPACE + copayTierRTMap.get((id)objRec.get(fieldName)) +HYPHEN ;
                            }
                            if(fieldName != CREATEDBYID && fieldName != CREATEDDATE && fieldName != COPAYTIER){
                                        SObjectType objToken = Schema.getGlobalDescribe().get(customSetRec.ObjectAPI__c);
                                        DescribeSObjectResult objDef = objToken.getDescribe();
                                        Map<String, SObjectField> fields = objDef.fields.getMap();
                                        if(fieldName == 'Number_of_Ranges__c'){
                                            recordUniqueString = recordUniqueString + SPACE + 'Step' +  objRec.get(fieldName);
                                        }
                                        else{
                                            recordUniqueString = recordUniqueString +SPACE + objRec.get(fieldName);
                                        }
                                  }
                        }
                    }
                else{
                    integer i =0;
                    for(string fieldName : fieldAPI.split(COMMA)){
                        if(fieldName == RECORDTYPEID || fieldName.contains(RECORDTYPEID) ){
                            recordUniqueString = recordUniqueString +SPACE + recordTypeMap.get((string)objRec.get(fieldName));
                          }
                        else if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                            if(customSetRec.ObjectAPI__c != COPAYTIER){
                                SObjectType objToken = Schema.getGlobalDescribe().get(customSetRec.ObjectAPI__c);
                                DescribeSObjectResult objDef = objToken.getDescribe();
                                Map<String, SObjectField> fields = objDef.fields.getMap();
                                if(fields.containskey(fieldName)){
                                    recordUniqueString = recordUniqueString +SPACE + objRec.get(fieldName);
                                }
                            }
                            else{
                                SObjectType objToken = Schema.getGlobalDescribe().get(customSetRec.ObjectAPI__c);
                                DescribeSObjectResult objDef = objToken.getDescribe();
                                Map<String, SObjectField> fields = objDef.fields.getMap();
                                if(fields.containskey(fieldName) && i ==0){
                                    recordUniqueString =  recordUniqueString +SPACE + objRec.get(fieldName);
                                    i++;
                                }
                                else{
                                    recordUniqueString = recordUniqueString +HYPHEN+ objRec.get(fieldName);
                                }
                            }
                        }
                    }
                }
        }
           
           else if(string.valueof(objRec.getsObjectType()) == WOD){
                boolean trimUniqueName = false;
                boolean deliverysystemchk = false;
                for(string fieldName : fieldAPI.split(COMMA)){
                    if(fieldName != CREATEDBYID && fieldName != CREATEDDATE){
                        if(fieldName == DC && (boolean)objRec.get(STANDARD)){
                            recordUniqueString = STANDARDHYPHEN+ objRec.get(fieldName);
                        }
                        else {
                            if(!(boolean)objRec.get(STANDARD) && fieldName != STANDARD && fieldName !=MFIELD && fieldName !=NFIELD && fieldName !=OFIELD && fieldName !=YFIELD){
                                if(fieldName == DG && objRec.get(fieldName) != null){
                                    string drugGroupName = drugGroupMap.get((string)objRec.get(fieldName)).Name;
                                    recordUniqueString = recordUniqueString +CUSTOM+ drugGroupName+HYPHEN ;
                                }
                                if(fieldName == DL && objRec.get(fieldName) != null){
                                    string drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                                    recordUniqueString = recordUniqueString +CUSTOM+ drugListName +HYPHEN;
                                }
                                if(fieldName == DELIVERYSYSTEM && objRec.get(fieldName) != null){
                                    recordUniqueString = recordUniqueString + objRec.get(fieldName)+HYPHEN;
                                    deliverysystemchk = true;
                                }
                          
                            }
                            if(fieldName ==MFIELD && (boolean)objRec.get(fieldName) && !(boolean)objRec.get(STANDARD)){
                                recordUniqueString = recordUniqueString + M;
                                trimUniqueName = true;
                            }
                            if(fieldName ==NFIELD && (boolean)objRec.get(fieldName) && !(boolean)objRec.get(STANDARD)){
                                recordUniqueString = recordUniqueString + N;
                                trimUniqueName =  true;
                            }
                            if(fieldName ==OFIELD && (boolean)objRec.get(fieldName) && !(boolean)objRec.get(STANDARD)){
                                recordUniqueString = recordUniqueString + O;
                                trimUniqueName = true;
                            }
                            if(fieldName ==YFIELD && (boolean)objRec.get(fieldName) && !(boolean)objRec.get(STANDARD)){
                                recordUniqueString = recordUniqueString + Y;
                                trimUniqueName  = true;
                            }
                    
                        }
                    }
                }
                    if(!trimUniqueName && deliverysystemchk){
                       recordUniqueString = recordUniqueString.removeEnd(HYPHEN);
                    }
            }
           else if(string.valueof(objRec.getsObjectType()) == DSCOBJECT ){
                for(string fieldName : fieldAPI.split(COMMA)){
                    if(fieldName != CREATEDBYID && fieldName != CREATEDDATE && fieldName !=MFIELD && fieldName !=NFIELD && fieldName !=OFIELD && fieldName !=YFIELD){
                        if(fieldName == RECORDTYPEID && objRec.get(fieldName)!= null){
                            recordUniqueString = recordUniqueString +SPACE + recordTypeMap.get((string)objRec.get(fieldName));
                        }
                        if(fieldName == DG && objRec.get(fieldName) != null){
                            string drugGroupName = drugGroupMap.get((string)objRec.get(fieldName)).Name;
                            recordUniqueString = recordUniqueString +HYPHENWITHSPACE + drugGroupName +HYPHENWITHSPACE ;
                        }
                        if(fieldName == DL && objRec.get(fieldName) != null){
                            string drugListName = drugListMap.get((string)objRec.get(fieldName)).Name;
                            recordUniqueString = recordUniqueString +HYPHENWITHSPACE+ drugListName +HYPHENWITHSPACE;
                        }
                    }
                    if(fieldName == MFIELD && (boolean)objRec.get(fieldName)){
                        recordUniqueString = recordUniqueString + M;
                    }
                     if(fieldName == NFIELD && (boolean)objRec.get(fieldName)){
                        recordUniqueString = recordUniqueString  + N;
                    }
                     if(fieldName == OFIELD && (boolean)objRec.get(fieldName)){
                        recordUniqueString = recordUniqueString + O;
                    }
                     if(fieldName ==YFIELD && (boolean)objRec.get(fieldName)){
                        recordUniqueString = recordUniqueString + Y;
                    }
            
                }
           }
           
             else if(string.valueof(objRec.getsObjectType()) == DSSC){
                   for(string fieldName : fieldAPI.split(COMMA)){
                        if(fieldName == DSC ){
                            
                            
                            string recorTypeName = dscMap.get((id)objRec.get(fieldName)).RecordType.Name;
                            if(dscMap.get((id)objRec.get(fieldName)).Drug_Group__c!= null){
                                recordUniqueString = recordUniqueString +recorTypeName +HYPHEN+dscMap.get((id)objRec.get(fieldName)).Drug_Group__r.Name+HYPHEN;
                            }
                            if(dscMap.get((id)objRec.get(fieldName)).Drug_List__c!= null){
                                recordUniqueString = recordUniqueString +recorTypeName +HYPHEN+dscMap.get((id)objRec.get(fieldName)).Drug_List__r.Name +HYPHEN;
                            }
                            if((boolean)dscMap.get((id)objRec.get(fieldName)).M__c){
                                recordUniqueString = recordUniqueString + M;
                            }
                            if((boolean)dscMap.get((id)objRec.get(fieldName)).N__c){
                                recordUniqueString = recordUniqueString + N;
                            }
                            if((boolean)dscMap.get((id)objRec.get(fieldName)).O__c){
                                recordUniqueString = recordUniqueString + O;
                            }
                            if((boolean)dscMap.get((id)objRec.get(fieldName)).Y__c){
                                recordUniqueString = recordUniqueString + Y;
                            }
                        }
                        else if(fieldName == NUMBEROFSTEPS  && objRec.get(fieldName)!=null){
                            recordUniqueString = recordUniqueString +STEP+objRec.get(fieldName);
              
                        }
                    }
                }
            wrapperListInstance.add(new wrapClassListObject((Id)objRec.get(CREATEDBYID),recordUniqueString,string.valueof(objRec.get(CREATEDDATE)),customSetRec.Name));
        }
        return wrapperListInstance;
            
        
        
    }
}