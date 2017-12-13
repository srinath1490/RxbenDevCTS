/*Purpose: Apex Class to implement Continue Automation logic
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      7/18/2014           Implementation of Continue Automation logic
   2.0      Amit Jain       2nd Dec, 2014       Modified for request 5305. Modified the method setBuilderCases()
   2.1      Nitish Verma    28th Dec, 2015      Modified for Req 5473, added Manually Applied checkbox
   2.2      Richa Gupta     23rd Feb, 2015      Modified for Req 5556 
   2.3      Sushant Sethi   31st Mar, 2015      Modified for Req 5633 
   3.3 -    Abhishek        9/7/ 2016           Added a "Has Custom Network" field in Query against ST1299.
   3.4      Abhishek        9/30/2016           Implemented a Request#06695 to apply the sorting on persfullreport
   3.5      Bhaskar         10/30/2016          Implemented a Request 06697 136711: ST#1383-Restrict User to click on Continue automation when Red message displays 
======================================================================== */
global class CBAuditUIExtension {
    public Case caseObj {get;set;}
    public CRDBuildOrder__c crdBuilder {get;set;}
    public String message {get;set;}
    public boolean hasSimiliarRecords {get;set;}
    public List<Mapping_Values__c> mvalues{get;set;}
    public string provNumber{get;set;}
    public string lineNumber {get;set;}
    public List<Pers_Full_Report__c> persFullReports {get;set;}
    public List<ContinueAutomationLog__c> CrdAutomationLog{get;set;}
    public List<FalloutRecordModal> fallouttypeList {get;set;}
    public boolean hideButton{get;set;}
    public boolean btnContinueAutomation{get;set;}
    public List<Case> crdExternalCase {get;set;}
    public String isRxPlanid{get;set;}
    public CB_ContinueAutomation processHandler {get;set;}
    public String processedPersList {get;set;}
    public Id mapping {get;set;}
    public String CBONstage {get;set;}
    public boolean FalloutCaseCreate {get;set;}
    public boolean noexternalcase{get;set;}
    public Pers_Full_Report__c persFReport{get;set;}
    public boolean hasUnresolvedFallouts = False;
    public boolean atchmntAbsent{get;set;}
    public String contentAsText {get;set;}
    public boolean setVal = False;
    private static final string CSAPRECORDID = '01250000000UI14';
    public list<Pers_Full_Report__c> wrappers {get;set;}
    public List<Attachment> attchs {get;set;} 
    PRIVATE STATIC FINAL STRING BLANKVAL = '';
    PRIVATE STATIC FINAL STRING ARCHIVEPFRMSG = 'ArchivedPFRs';
    PRIVATE STATIC FINAL STRING OWNERADMINQUEUE = 'CB_AdminQ';
    PRIVATE STATIC FINAL STRING CASEMSG = 'Case Transfered To Admin Team';
    PRIVATE STATIC FINAL STRING PROFILESYSADMIN = 'System Administrator';
    PRIVATE STATIC FINAL STRING PROFILESYSADMINPRI = 'System Administrator Primary';
    PRIVATE STATIC FINAL STRING PROFILEBCTMNGMT = 'BCT Management';
    PRIVATE STATIC FINAL STRING CONFLICTSTYPE = 'conflicts';
    PRIVATE STATIC FINAL STRING APEXERRMSG = 'No CRD build order record found, use browser back button to go back';
    PRIVATE STATIC FINAL STRING CVSCHECKEDVAL = 'CVS checked';
    PRIVATE STATIC FINAL STRING PDFCHECKEDVAL = 'PDF checked';
    PRIVATE STATIC FINAL STRING XMLCHECKEDVAL = 'XML checked';
    PRIVATE STATIC FINAL STRING CAGCHECKEDVAL = 'CAG checked';
    PRIVATE STATIC FINAL STRING PERSCHECKEDVAL = 'PERS checked';
    PRIVATE STATIC FINAL STRING AIRESCHECKVAL = 'AI response received';
    PRIVATE STATIC FINAL STRING AICALLOUTVAL = 'Aicallout checked';
    PRIVATE STATIC FINAL STRING COMPCHECKEDVAL = 'Complete checked';
    PRIVATE STATIC FINAL STRING VALIDCHECKEDVAL = 'Valid checked';
    PRIVATE STATIC FINAL STRING BUILDCHECKEDVAL = 'Build checked';  
    PRIVATE STATIC FINAL STRING NOTSTARTEDVAL = 'Not Started';
    PRIVATE STATIC FINAL STRING PROVVAL = 'P';
    PRIVATE STATIC FINAL STRING LINEVAL = 'L';
    PRIVATE STATIC FINAL STRING CASERECTYPE = 'Internal CRD/GMF Process';
    PRIVATE STATIC FINAL STRING NEWERVAL = 'Newer';
    PRIVATE STATIC FINAL STRING CASESTR = ' Case ';
    PRIVATE STATIC FINAL STRING CRDSTR = ', CRD ';
    PRIVATE STATIC FINAL STRING PERSSTR = ', PERS ';
    PRIVATE STATIC FINAL STRING STRGMSGLONG = 'record(s) were found. This Case cannot be automated';
    PRIVATE STATIC FINAL STRING STATUSMSGVAL = 'Status:OK- No newer cases or PERS report records found';
    PRIVATE STATIC FINAL STRING CASECLOSEDSTAT = 'Closed';
    PRIVATE STATIC FINAL STRING STATUSMSGLONG = 'status-Error: Case is closed and cannot be automated, Please evaluate if case status needs to change'; 
    PRIVATE STATIC FINAL STRING COMMAVAL = ',';
    PRIVATE STATIC FINAL STRING BUILDFAILURE = 'Build stage failure';
    PRIVATE STATIC FINAL STRING VALIDFAILURE = 'Validation stage failure';
    PRIVATE STATIC FINAL STRING COMPLETIONFAILURE = 'Completion stage failure';
    PRIVATE STATIC FINAL STRING CASESTATUSVAL2 = 'Send for Assignment';
    PRIVATE STATIC FINAL STRING CASESTATUSVAL3 = 'Sent to CVS';
    PRIVATE STATIC FINAL STRING CASESTATUSVAL4 = 'Pending PDF and CVS';
    PRIVATE STATIC FINAL STRING RXPLANISMSG1 = 'RxplanId has been received.';
    PRIVATE STATIC FINAL STRING RXPLANISMSG2 = 'RxPlanId is not available.';
    PRIVATE STATIC FINAL STRING URLPART1 = '/_ui/search/ui/UnifiedSearchResults?asPhrase=0&initialViewMode=summary&saveOptions=1&searchOwner=0&searchType=2&sen=a1e&str=';
    PRIVATE STATIC FINAL STRING URLPART2 = '#!/searchAll=true&initialViewMode=summary&str='; 
    PRIVATE STATIC FINAL STRING BACKSLASHVAL = '/';
    public String query{get;set;}
    private String sortDirection= 'DESC';
    private String sortExp = 'WS_PROV_NUM__c';
    /*Request 06697 136711: ST#1383-Restrict User to click on Continue automation when Red message displays   */
    public string ContinueAutomationMessage{get;set;}
    public string ContinueAutomationMessage2{get;set;}
    PRIVATE STATIC FINAL STRING ContinueAutomationMessageIF = 'A newer CRD has been received for this CPE.';  
    PRIVATE STATIC FINAL STRING ContinueAutomationMessageIF2 ='Do you want to continue automation? ';
    PRIVATE STATIC FINAL STRING ContinueAutomationMessageELSE ='Are you sure ?';
    PRIVATE STATIC FINAL STRING ContinueAutomationMessageELSE2 ='Continue Processing Plan? ';
    /* Contructor for the class CBAuditUIExtension*/
    public CBAuditUIExtension(ApexPages.StandardController stdCon) {
        processedPersList = BLANKVAL;
        persFReport = new Pers_Full_Report__c();
        crdExternalCase = new List<Case>();
        mvalues = new List<Mapping_Values__c>();
        CrdAutomationLog = new List<ContinueAutomationLog__c>();
        caseObj = [select 
                        id,CaseNumber,crd_ID__r.name,crd_ID__r.CPE__c,Fallout_Reason__c,ControlPlanEffective__c
                        ,PERS_timestamp__c,ControlEffective__c,ownerId,Owner.name,Status 
                    from 
                        case 
                    where 
                        id=: stdCon.getId() LIMIT 80000];
        //Getting CRDBuilder Record             
        for(CRDBuildOrder__c builder : [Select
                                           id,FalloutCase__c,Case__c ,Case__r.casenumber,name,Processed__c ,PERS_timestamp__c,validatedRealTime__c,Success_Case__c,CRD__r.Name,
                                            CRD__r.CRD_Automated__c,CRD__r.Account_Name__c,CRD__r.Account__c,CRD__r.PERS_timestamp__c,valid__c,builtRealTime__c ,Control_Plan_Effective__c,
                                            completeChkRealTime__c ,complete__c,AIRealtime__c ,CRD__r.ControlPlanEffective__c, CRD__r.Control__c,FalloutCase__r.status,               
                                            CAGRealtime__c,Aicallout__c,XML__c,XMLRealtime__c,PDF__c,PDFRealtime__c  , Success_Case__r.Fallout_Reason__c
                                            , FalloutCase__r.Fallout_Reason__c, Build__c,PERS__c, CAG__c,Sent_AI_request__c,ControlPlanEffective__c,Ready_to_Archive__c,
                                            CRD__r.Plan__c,CRD__r.Effective_Date__c,CRD__r.RxPlanID__c,CRD__r.Y_Schd__c,CVS__c,FalloutCase__r.CaseNumber,Success_Case__r.casenumber,Success_Case__r.status
                                            ,CRD__r.Partial_Control_Group__c,CRD__r.Full_Control_Group__c,Case__r.Has_Custom_Network__c
                                        From
                                            CRDBuildOrder__c 
                                        Where
                                            Success_Case__c =:caseObj.id OR FalloutCase__c =:caseObj.id LIMIT 80000]){
            crdBuilder = builder;
        }
        attchs = new list<Attachment>([Select Id, Body from Attachment where ParentId =: crdBuilder.Id AND Description =: ARCHIVEPFRMSG ORDER BY CreatedDate DESC LIMIT 1]);
        if(attchs.isempty()){
           atchmntAbsent = true;
        } else {
              atchmntAbsent = false;
          } 
        if(crdBuilder!=null){
            processHandler = new CB_ContinueAutomation(crdBuilder); 
                     
            this.setDisplayMessage();   
            this.loadAutomationLogs();
            this.loadPersReport();
            this.laodFalloutRecords();
            this.loadExternalCases();
            this.setProcessStatus();
            //Added by JR
            List<CRD_BuilderFallout__c> lstFallouts = new List<CRD_BuilderFallout__c>();
            for(FalloutRecordModal modal : fallouttypeList){
                lstFallouts.addall(modal.falloutRecords);
            }
            
            if(OWNERADMINQUEUE.equalsIgnoreCase(caseObj.Owner.name)) {//Getting Current OwnerName
                message = CASEMSG;
            }
            //Richa added for Req 5124    
            String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId() LIMIT 1].Profile.Name;
            if (usrProfileName != PROFILESYSADMIN && usrProfileName != PROFILESYSADMINPRI  && usrProfileName != PROFILEBCTMNGMT ){
                hideButton = true;
            }else if(OWNERADMINQUEUE.equalsIgnoreCase(caseObj.Owner.name)) {
                hideButton = true;
                } else {
                    hideButton = false;
                }   
            
            //Added by JR
            for(CRD_BuilderFallout__c objFallout : lstFallouts){
                if(CONFLICTSTYPE.equalsIgnoreCase(objFallout.Type__c)){
                    //btnContinueAutomation = true;
                }else{
                    btnContinueAutomation = false;
                }
            }    
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, APEXERRMSG)); 
        }
    }
    
    /* Method to set the process status */
    private void setProcessStatus(){
         //Richa added for Req - 5083
            if(crdBuilder.CVS__c){
                CBONstage = CVSCHECKEDVAL;
            }else if (crdBuilder.PDF__c){
                CBONstage = PDFCHECKEDVAL; 
            }else if (crdBuilder.XML__c || crdBuilder.XMLRealtime__c){  
                CBONstage = XMLCHECKEDVAL; 
            }else if (crdBuilder.CAG__c || crdBuilder.CAGRealtime__c){ 
                CBONstage = CAGCHECKEDVAL;
            }else if (crdBuilder.PERS__c){
                CBONstage = PERSCHECKEDVAL;
            }else if (crdBuilder.Sent_AI_request__c){//isRxPlanid == 'RxplanId has been received.'){
                CBONstage = AIRESCHECKVAL;
            }else if (crdBuilder.Aicallout__c){  
                CBONstage = AICALLOUTVAL;
            }else if (crdBuilder.complete__c || crdBuilder.completeChkRealTime__c){  
                CBONstage = COMPCHECKEDVAL;
            }else if (crdBuilder.valid__c || crdBuilder.validatedRealTime__c){  
                CBONstage = VALIDCHECKEDVAL;
            }else if (crdBuilder.Build__c || crdBuilder.builtRealTime__c){  
                CBONstage = BUILDCHECKEDVAL;  
            }else{
               CBONstage = NOTSTARTEDVAL;
            }    
            
    }
    
    /* Method to create an external case*/
    private void loadExternalCases(){
        //query automation log based on builder
        crdExternalCase = new List<Case>();
        if(crdBuilder.crd__c!= null){
           crdExternalCase = [select 
                                id,casenumber,crd_ID__r.name,crd_ID__r.CPE__c,Fallout_Reason__c,ControlPlanEffective__c,RecordType.name
                                ,PERS_timestamp__c,ControlEffective__c,ownerId,Owner.name,Status,CreatedDate,Account.name, Account.Id
                              from 
                                case 
                          where 
                            crd_Id__c =: crdBuilder.crd__c LIMIT 80000];
        }// and (RecordType.Name != 'Internal Migration CRD/GMF Process' or RecordType.name != 'Internal GMF Case' or Recordtype.name != 'Internal CRD/GMF Process')];                    
    }
    /** Start here
     * Story:- 06695
     * Description - Create a Method to sort the valeus based on the given button.
     */ 
    public string sortingByQuery(string sQuery){
        String crdBuilderID = crdBuilder.id;
        String inClause = String.format( '\'\'{0}\'\'', 
                                 new List<String> {crdBuilderID, '\',\''});
        String Queryhead = 'Select ';
        String fields = '';
        fields = 'Id, CRD_Build_Order__c,Case__c,ControlPlanEffective__c,WS_PROV_NUM__c,Manually_Applied__c,WS_PROV_LNG_NM__c,WS_LV_NO__c,WS_LV_TXT__c,Processed__c,WS_BNFT_RMRK__c,Case__r.casenumber,WS_PSUID__c,WS_RISK_IND__c,WS_CUST_SUBSEG__c,WS_MLR_CONTRACT_SITUS_ST__c,WS_SITUS_ST__c,WS_COB_CD__c,WS_COB_RMRK__c,Carrier_ID__c,What_is_the_carrier__c,WS_CNTRCT_ST__c';
        Queryhead = Queryhead + fields + ' From Pers_Full_Report__c ';
        String whereClause = '';
        whereClause += 'CRD_Build_Order__c=' + inClause;
        Queryhead += ' Where ' + whereClause;
        if(sQuery!=null && sQuery!=''){
                 Queryhead += ' order by '+ sQuery + ' Limit 100';
        }
        else{
            Queryhead += ' order by WS_PROV_NUM__c desc, WS_LV_NO__c desc Limit 100 ';
        }
       
        system.debug('query'+Queryhead);
        return Queryhead;
    }
    
       public String sortExpression
       {
         get
         {
            return sortExp;
         }
         set
         {
           //if the button is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'DESC')? 'ASC' : 'DESC';
           else
             sortDirection = 'DESC';
             sortExp = value;
         }
       }

     public String getSortDirection()
     {
        
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }

     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
   /** End Here * #06695*/
    public void loadPersReport(){
        //persFullReports = new List<Pers_Full_Report__c>();
        //query pers reprot based on builder
        //Code added for Req 5556 by Richa
        //build the full sort expression
        //Below line code is written for #06695
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        query = sortingByQuery(sortFullExp);
        system.debug('query'+query);
        if(!crdBuilder.Ready_to_Archive__c && atchmntAbsent){
        persFullReports = Database.query(query);
        }if (crdBuilder.Ready_to_Archive__c && !atchmntAbsent){
                     for(Attachment atts : attchs){
                        contentAsText = atts.Body.toString();
                        persFullReports = (List<Pers_Full_Report__c>)JSON.deserialize(contentAsText, List<Pers_Full_Report__c>.class);
                        }   
              }                      
         if(persFullReports != null && !persFullReports.isempty()){
            persFReport = persFullReports[0];
          }                        
    }
    
    /* Method to load the automation logs */
    private void loadAutomationLogs(){
        //query automation log based on builder
        CrdAutomationLog = new List<ContinueAutomationLog__c>();
        CrdAutomationLog = [Select
                                Id, name,CaseId__c,Errored__c,Success__c,createddate,createdById
                            From
                                ContinueAutomationLog__c 
                            Where
                                CaseId__c =:caseObj.id LIMIT 90000000];
    }
    
    /* Method to load the mapping files */
    public void loadMappingFiles(){ 
        //TODO:- display mapping based on provnumber and line number
      try{  
        mvalues = new List<Mapping_Values__c>();
        mvalues = [Select
                                Id, Provision__c,Line_value__c,ParentMappingValue__c,MappingColumnID__r.Tab_Label__c, MappingColumnID__r.Field_Label__c, FieldValue__c
                            From
                                Mapping_Values__c 
                            Where
                                Provision__c =:Integer.valueof(provNumber) AND Line_value__c =:Integer.valueof(lineNumber)
                            Order By MappingColumnID__r.Tab_Label__c asc Nulls last,ParentMappingValue__c desc LIMIT 90000000];
      }catch(exception e){ 
         throw e;
      }
    }
    
     /* Method redirectToLV() to redirect to Line Value record based on provnumber and line number */
    public PageReference redirectToLV(){
        //TODO:- redirect to Line Value record based on provnumber and line number
      try{  
        PageReference pageRef;
        String lVname = PROVVAL + Integer.valueof(provNumber) + LINEVAL + Integer.valueof(lineNumber);
        list<LineValue__c> lvList = new list <LineValue__c>([Select Id
                            From
                                LineValue__c 
                            Where
                                Name =:lVname LIMIT 1]);
                                
        if(!lvList.isempty()){
            mapping = lvList[0].Id;
            pageRef = new PageReference(BACKSLASHVAL + mapping);                     
            pageRef.setRedirect(true);
        } else {
            pageRef = new PageReference(URLPART1+lVname+URLPART2+lVname);                     
            pageRef.setRedirect(true);
        }
        return pageRef;        
      }catch(exception e){ 
         throw e;
      }
    }   
     
    /*
     * Method :- getMappingValues
     * Description :- It's used to assing case to Queue. 
     */
    public PageReference assignToIT(){
      try{
        QueueSobject sQObject = [Select Id,queueId,Queue.Name from QueueSobject where Queue.Name =: OWNERADMINQUEUE LIMIT 80000];
        
        caseObj.OwnerID = sQObject.queueId;
        database.update(caseObj);
        hideButton();
        return null;
      }catch(exception e){ 
         throw e;
      }
    }
     /*
     * Method :- hideButton
     * Description :- It's used to diabled button on the UI Page. 
     */
    public void hideButton(){
      try{  
        if(OWNERADMINQUEUE.equalsIgnoreCase(caseObj.Owner.name))
        {
             hasSimiliarRecords  = false;
             message = CASEMSG;
             hideButton = true;
        }
      }catch(exception e){ 
         throw e;
      }
    }
    
    /* Method to set the display message */
    private void setDisplayMessage(){
        hasSimiliarRecords  = false;
        Integer machingCases = [ Select 
                                    Id,casenumber,status
                                 From
                                      Case
                                 Where
                                    RecordType.name =: CASERECTYPE 
                                    AND Id <> : crdBuilder.Success_Case__c
                                    AND ID <> : crdBuilder.FalloutCase__c
                                    AND ControlPlanEffective__c =: crdBuilder.Control_Plan_Effective__c 
                                    AND PERS_timestamp__c >: crdBuilder.PERS_timestamp__c limit 1].size();
        
        Integer machingCrds = [ Select 
                                    Id
                                 From
                                      CRD__c
                                 Where
                                    Id <> : crdBuilder.CRD__c
                                    AND ControlPlanEffective__c =: crdBuilder.Control_Plan_Effective__c 
                                    AND PERS_timestamp__c >: crdBuilder.PERS_timestamp__c limit 1].size(); 
                                    
        Integer machingPers = [ Select 
                                    Id
                                 From
                                      Pers_Full_Report__c
                                 Where
                                    CRD_Build_Order__c <> : crdBuilder.id
                                    AND ControlPlanEffective__c =: crdBuilder.Control_Plan_Effective__c 
                                    AND PERStimestamp__c >=: crdBuilder.PERS_timestamp__c  limit 1].size();  
        
        if( machingCases > 0 || machingCrds > 0 || machingPers > 0){
            hasSimiliarRecords  = true;
            message = NEWERVAL 
                +  (machingCases > 0 ? CASESTR : BLANKVAL)
                +  (machingCrds > 0 ? CRDSTR : BLANKVAL)
                +  (machingPers > 0 ? PERSSTR : BLANKVAL)
                + STRGMSGLONG;
            /*Request 06697 136711: ST#1383-Restrict User to click on Continue automation when Red message displays   */           
            ContinueAutomationMessage=ContinueAutomationMessageIF;
            ContinueAutomationMessage2=ContinueAutomationMessageIF2;
        }
        else{
            message = STATUSMSGVAL;
            /*Request 06697 136711: ST#1383-Restrict User to click on Continue automation when Red message displays   */
            ContinueAutomationMessage=ContinueAutomationMessageELSE;
            ContinueAutomationMessage2=ContinueAutomationMessageELSE2;
        }
        //hasSimiliarRecords  = false;
    }
    
    /* Method to load the Fallout Records of the CBON */
    private void laodFalloutRecords(){
        fallouttypeList = new List<FalloutRecordModal>();
        Map<String,FalloutRecordModal> mapFalloutRecords = new Map<String,FalloutRecordModal>();
        
        for(Schema.PicklistEntry pe : CRD_BuilderFallout__c.Type__c.getDescribe().getPicklistValues()){
                        mapFalloutRecords.put(pe.getValue(), new FalloutRecordModal(pe.getValue()));
                }
                
        
        //Do Query on fallout record and populate Map
        for(CRD_BuilderFallout__c fallout : [Select
                                                Id, name,CaseId__c,Conflicts__c,CRD_Id__c,Resolved__c,Error_Description__c,
                                                ResolvedBy__c,Type__c,Provision__c,LineValue__c,Field__c, Error_Code__c ,CreatedById ,CreatedDate
                                                , Conflict_Provision_Lines__c
                                            From
                                                CRD_BuilderFallout__c 
                                            Where
                                                CaseId__c =:caseObj.id
                                            Order By
                                                Resolved__c asc, CreatedDate desc LIMIT 800000]){
                                                    
            //mapFalloutRecords.put(fallout.Type__c,new FalloutRecordModal(fallout.Type__c));
            if(! mapFalloutRecords.containsKey(fallout.Type__c)){
                mapFalloutRecords.put(fallout.Type__c, new FalloutRecordModal(fallout.Type__c));
            }
            mapFalloutRecords.get(fallout.Type__c).falloutRecords.add(fallout);
        
        }
        
        fallouttypeList.addall(mapFalloutRecords.values());
    }
    //Request 06264 - Multiday by Nitish
    /** Method :- continueAutomationRestrictMultiday()
        Description :- This method check if CRD under continue automation has more than one PCG or not. In case it has more than one PCG an error is thrown
     **/
    public boolean continueAutomationRestrictMultiday(){
      try{
      if(crdBuilder.Sent_AI_request__c && !crdBuilder.CAG__c && crdBuilder.crd__c != null){          
        set<id> pcg = new set<id>();
        for(CSAP_CGLP_Junction__c csap : [select id,name,CRD__c,Partial_Control_Group__c from CSAP_CGLP_Junction__c where CRD__c =:crdBuilder.crd__c AND RecordTypeId =:CSAPRECORDID AND Partial_Control_Group__c!=null LIMIT 80000]){
           if(!pcg.contains(csap.Partial_Control_Group__c)){
                pcg.add(csap.Partial_Control_Group__c);
            }
        }
            if(pcg.size()>1){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.MULTIDAYERR001)); 
               processHandler.canStop = TRUE;
               setVal = True;
             }
            else{
              setVal = False;
            }
          }
          return setVal;
       }catch(exception e){ 
         throw e;
       }        
      }
      
    /* Method to for performing continue automation */  
    public Pagereference continueAutomation(){
        Pagereference pg;
        
        continueAutomationRestrictMultiday();
        
        if(!setVal){
        if(CASECLOSEDSTAT.equalsIgnoreCase(caseObj.status))
        {     
            message = STATUSMSGLONG;  
            processHandler.canStop = true;
        }else{
        try{
                
                Set<String> persReportIds = new Set<String>();
                for(String s : processedPersList.split(COMMAVAL)){
                    if(! String.isBlank(s)){
                        persReportIds.add(s);   
                    }
                } 
                List<Pers_Full_Report__c> persReports = new List<Pers_Full_Report__c>();
                for(Pers_Full_Report__c pers : [Select 
                                                    id,case__c
                                                From
                                                    Pers_Full_Report__c
                                                Where 
                                                    id in:persReportIds LIMIT 80000]){
                    pers.processed__c = true;
                    pers.Manually_Applied__c = true;
                    persReports.add(pers);                                      
                }   
                database.update(persReports);
                //Update Applied
                //update persFullReports;
                List<CRD_BuilderFallout__c> fallouts = new List<CRD_BuilderFallout__c>();
                fallouts = new List<CRD_BuilderFallout__c>();
                for(FalloutRecordModal modal : fallouttypeList){
                    fallouts.addall(modal.falloutRecords);
                }
                List<CRD_BuilderFallout__c> triggeredFallout = new List<CRD_BuilderFallout__c>();
                for(CRD_BuilderFallout__c fallout : fallouts){
                    if(fallout.ResolvedBy__c == null){
                        triggeredFallout.add(fallout);
                    }
                }
                //update fallouts;
                if(crdBuilder.FalloutCase__c == null)
                {processHandler.executeProcess(triggeredFallout, caseObj.Fallout_Reason__c, caseObj.id);}
                else
                    processHandler.executeProcess(triggeredFallout, caseObj.Fallout_Reason__c, crdBuilder.FalloutCase__c);                            
                crdBuilder = processHandler.crdBuilder;
                
                if(processHandler.canStop){
                     caseObj = [select 
                            id,crd_ID__r.name,crd_ID__r.CPE__c,Fallout_Reason__c,ControlPlanEffective__c
                            ,PERS_timestamp__c,ControlEffective__c,ownerId,Owner.name,Status,casenumber 
                        from 
                            case 
                        where 
                            id=: caseObj.Id LIMIT 80000];
                     if(processHandler.canStopReason != BLANKVAL && processHandler.canStopReason != null && processHandler.canStopReason != BUILDFAILURE && processHandler.canStopReason != VALIDFAILURE && processHandler.canStopReason != COMPLETIONFAILURE){//Richa added for Req 5083
                        FalloutCaseCreate = true;   
                     }
                     
                }
                //pg = new Pagereference('/apex/CB_AuditUClone?id=' + caseObj.id);
        
           }catch(Exception ex){
            //throw ex;
                Apexpages.addMessages(ex);
                processHandler.canStop = true;
                
            }
        this.setDisplayMessage();   
        this.loadAutomationLogs();
        this.loadPersReport();
        this.laodFalloutRecords();
        this.loadExternalCases();
        this.setProcessStatus();
        processedPersList = BLANKVAL;
        this.setBuilderCases();
        }
    }
        return pg;
    }
    
    /* Method to set the CBON Fallout and Success cases */
    public void setBuilderCases(){
      try{  
        List<Case> lstBuilderCases = new List<Case>();
        string successCaseStatus=BLANKVAL;
        for(CRD_BuilderFallout__c falloutrecords : [Select
                                                Id, name,CaseId__c,Conflicts__c,CRD_Id__c,Resolved__c,Error_Description__c,
                                                ResolvedBy__c,Type__c,Provision__c,LineValue__c,Field__c, Error_Code__c ,CreatedById ,CreatedDate
                                                , Conflict_Provision_Lines__c,CaseId__r.status
                                            From
                                                CRD_BuilderFallout__c 
                                            Where
                                                CaseId__c!= Null AND (CaseId__c =: crdBuilder.Success_Case__c or CaseId__c =: CrdBuilder.FalloutCase__c)
                                            Order By
                                                Resolved__c asc, CreatedDate desc LIMIT 80000]){
           if(falloutrecords.Resolved__c == False){
                hasUnresolvedFallouts = True;
           }                                   
         }
        if(crdBuilder.FalloutCase__c != null && hasUnresolvedFallouts){
            lstBuilderCases.add( new Case(Id = crdBuilder.FalloutCase__c, Status = CASESTATUSVAL2));
        }else if(crdBuilder.FalloutCase__c != null && !hasUnresolvedFallouts){
            lstBuilderCases.add( new Case(Id = crdBuilder.FalloutCase__c, Status = CASECLOSEDSTAT));
        }else{ //Do Nothing
        }
        if(crdBuilder.Success_Case__c != null && crdBuilder.Success_Case__c == caseObj.id && (crdBuilder.Success_Case__r.status != CASESTATUSVAL3 && crdBuilder.Success_Case__r.status !=CASESTATUSVAL4)){
            lstBuilderCases.add( new Case(Id = crdBuilder.Success_Case__c, Status = CASECLOSEDSTAT));
        }
        database.update(lstBuilderCases);
      }catch(exception e){ 
         throw e;
      }
    }
    
    /* Class for Fallout record and its attributes*/
    public class FalloutRecordModal {
        public String falloutType {get;set;}
        public List<CRD_BuilderFallout__c> falloutRecords {get;set;}
        
        /* Contructor for the FalloutRecordModal class*/
        public FalloutRecordModal(String falloutType){
            this.falloutType = falloutType;
            this.falloutRecords = new List<CRD_BuilderFallout__c>();
        }
        
    }
    
    /* Method to check the RxPlan Id on the CRD*/
    public void checkRxPlanId(){
      try{  
        for(CRD__c currentRec : [Select id,Name,RxPlanID__c from CRD__c where id =: crdBuilder.crd__c LIMIT 80000]){
            if(currentRec.RxPlanID__c != Null && currentRec.RxPlanID__c!=BLANKVAL){
                isRxPlanid = RXPLANISMSG1;
            }else{
                isRxPlanid = RXPLANISMSG2;
            }
        }
      }catch(exception e){ 
         throw e;
      }
    }
}