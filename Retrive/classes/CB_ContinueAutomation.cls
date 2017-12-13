/*Purpose: Apex Class to implement Continue Automation logic
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      7/18/2014           Implementation of Continue Automation logic
   2.0      Amit Jain       2nd Dec, 2014       Modified for request 5305
   3.0      Amit Jain       07 Sept 2015        Modified for ST# 277, added exceptionMessage condition
   3.1      Richa Gupta     12 Oct 2015         Added Success case field to CBON query for Req 6124
   3.2      Richa Gupta     27 Oct 2015         Added CBON fields in below query for Req 6159
   3.3 -    Abhishek         9/7/ 2016         Added a "Has Custom Network" field in Query against ST1299.
======================================================================== */
global class CB_ContinueAutomation {    
    public CRDBuildOrder__c crdBuilder;
    public boolean canStop {get;set;}
    public string canStopReason {get;set;}
    public boolean waitingForRxPlan {get;set;}
    public String currentProcessName {get;set;}
    public boolean FalloutCaseCreated {get;set;}
    private ContinueAutomationLog__c logger;
    private List<CRD_BuilderFallout__c> triggerFallouts;
    private string currentCaseId;
    public string falloutCaseId;
    public string successCaseId;
    private boolean AIPCGFAILURE{get;set;}
    /* Class for capturing the exceptions if any that occur while running the class */
    public class MyException extends Exception{}
    public boolean firstRun = True;
    public static CB_BuildStep objBuildPreBuild = new CB_BuildStep();
    PRIVATE STATIC FINAL STRING CP = 'Checking process';
    PRIVATE STATIC FINAL STRING TRG = 'Triggered';
    PRIVATE STATIC FINAL STRING RXWAIT = 'Waiting for RXPlan Id ';
    PRIVATE STATIC FINAL STRING BUILDPROCESS = 'Processing Build Step';
    PRIVATE STATIC FINAL STRING VAIDATEPROCESS = 'Processing Validation Step';
    PRIVATE STATIC FINAL STRING CRDA = 'CRDA';
    PRIVATE STATIC FINAL STRING AIREQUESTLABEL = 'Preparing AI Request';
    PRIVATE STATIC FINAL STRING FIFO = 'Processing FIFO';
    PRIVATE STATIC FINAL STRING COMPLETESTEP = ' Processing completion Step';
    PRIVATE STATIC FINAL STRING PDFSTEP = ' Waiting for PDF';
    PRIVATE STATIC FINAL STRING PERSSTEP = ' Processing Pers Step';
    PRIVATE STATIC FINAL STRING XMLSTEP = ' Processing XML Step';
    PRIVATE STATIC FINAL STRING SENDAI = 'Sending AI request';
    PRIVATE STATIC FINAL STRING APEXPAGEERRORMSG = 'Please resolve all pending fallouts before continue automation';
    PRIVATE STATIC FINAL STRING RXPLANIDSTATUS = 'RxPlan Id has been received';
    PRIVATE STATIC FINAL STRING APEXCLASSBUILD = 'CB_ExecuteBuild';
    PRIVATE STATIC FINAL STRING BUILDFAILURE = 'Build stage failure';
    PRIVATE STATIC FINAL STRING APEXCLASSAI = 'CB_AICallout';
    PRIVATE STATIC FINAL STRING AIFAILURE = 'AI Callout stage failure';
    PRIVATE STATIC FINAL STRING APEXCLASSPERS = 'CB_PERSSEED';
    PRIVATE STATIC FINAL STRING CAGFAILURE = 'CAG stage failure';
    PRIVATE STATIC FINAL STRING APEXCLASSCAG = 'CB_CAG';
    PRIVATE STATIC FINAL STRING APEXCLASSXML = 'CB_XML';
    PRIVATE STATIC FINAL STRING XMLFAILURE = 'CAG XML failure';
    PRIVATE STATIC FINAL STRING APEXCLASSVALID = 'CB_Validation';
    PRIVATE STATIC FINAL STRING VALIDFAILURE = 'Validation stage failure';
    PRIVATE STATIC FINAL STRING FALSEVAL = 'false';
    PRIVATE STATIC FINAL STRING AIAPEXMSG = 'This CRD has been processed successfully for Completion Step. Please review CRD details before proceeding it for AI';
    PRIVATE STATIC FINAL STRING COMPLETIONFAILURE = 'Completion stage failure';
    PRIVATE STATIC FINAL STRING CASESTATUSVAL = 'Send for Assignment';
    PRIVATE STATIC FINAL STRING CALOGJUNCTYPE = 'Generated';
    PRIVATE STATIC FINAL STRING CASERECTYPE = 'Internal CRD/GMF Process';
    PRIVATE STATIC FINAL STRING NEWERVAL = 'Newer';
    PRIVATE STATIC FINAL STRING STRMSGVAL = 'record(s) were found. This Case cannot be automated';
    
    /*Method: CB_ContinueAutomation*/
    public CB_ContinueAutomation(CRDBuildOrder__c crdBuilder){
        this.waitingForRxPlan = false;
        this.crdBuilder = crdBuilder;
        this.canStop = false;
        this.currentProcessName = CP;
        this.AIPCGFAILURE = False;
        
    }
    /*Method: createLogger*/
    private boolean createLogger(string falloutReason, string caseId){
        if(! triggerFallouts.isEmpty()){
            
            logger =  new ContinueAutomationLog__c(Triggered_Case_Fallout_reason__c = falloutReason , CaseId__c = caseId);
            logger.Success__c = true;
            database.insert(logger);
            List<CRD_BF_CALog_Junc__c> listJuncnLog = new List<CRD_BF_CALog_Junc__c>();
            CRD_BF_CALog_Junc__c juncnLog = new CRD_BF_CALog_Junc__c();
            for(CRD_BuilderFallout__c fallout : triggerFallouts){
                if(fallout.Resolved__c == false){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, APEXPAGEERRORMSG));  
                    this.canstop = true;
                    return false;
                }else{
                    fallout.ResolvedBy__c = Userinfo.getUserId();
                }
                //Create jucntion log
                juncnLog = new CRD_BF_CALog_Junc__c();
                juncnLog.CA_LogID__c =  logger.id;
                juncnLog.CRD_BID__c = fallout.id;
                juncnLog.Type__c = TRG;
                listJuncnLog.add(juncnLog);
            }
            
            database.update(triggerFallouts);
            database.insert(listJuncnLog);
                        
            //TODO:- create fallout junctions
        }else if(logger == null){
            logger =  new ContinueAutomationLog__c(Triggered_Case_Fallout_reason__c = falloutReason , CaseId__c = caseId);
            logger.Success__c = true;
            database.insert(logger);
        }else { //Do Nothing
        }
        
        return true;
    }
    
    /*Method : executeProcess*/
    public void executeProcess(List<CRD_BuilderFallout__c> fallouts, String falloutReason, String caseId){
      try{
        this.canStop = false;
        this.currentCaseId = caseId;
        this.hasNewerRecord();
        this.triggerFallouts = fallouts;
        this.createLogger(falloutReason, caseId);
        if(! this.canStop){
            //TODO:- Start Next Process
            this.nextProcess();
        }
      }catch(exception e){
         throw e;
       }
    }
    /*Method : chkForRxPlanId*/
    public void chkForRxPlanId(){
      try{
        this.getUpdatedCRDBuilder();
        this.waitingForRxPlan = false;
        
        if(crdBuilder.CRD__r.RxPlanID__c == Null && !AIPCGFAILURE ){
            this.waitingForRxPlan = true;
            this.currentProcessName = RXWAIT;
        }else if(crdBuilder.CRD__r.RxPlanID__c != Null){
            this.currentProcessName = RXPLANIDSTATUS ;
        }else { //Do Nothing
        }
       }catch(exception e){
         throw e;
       }
    }

    /*Method : nextProcess*/
    private void nextProcess(){
        this.getUpdatedCRDBuilder();
        this.waitingForRxPlan = false;
        if(!crdBuilder.Build__c  && !firstRun){
            if(objBuildPreBuild.CrdBuilderFallouts != null &&  objBuildPreBuild.CrdBuilderFallouts.size() > 0){
                this.handleProcessError(APEXCLASSBUILD,objBuildPreBuild.CrdBuilderFallouts,BUILDFAILURE);
            }
        }else if(!crdBuilder.Build__c && !crdBuilder.builtRealTime__c  && firstRun){
            //this.processBuild();
            firstRun = False;
            this.currentProcessName = BUILDPROCESS;
            processBuildFuture(crdBuilder.id);
            
        }else if(!crdBuilder.valid__c  && !crdBuilder.validatedRealTime__c  
        			&& crdBuilder.Build__c  && crdBuilder.crd__c!= Null){
			            this.currentProcessName = VAIDATEPROCESS;
			            this.processValidate();
            
        }else if(!crdBuilder.complete__c  && !crdBuilder.completeChkRealTime__c  
        			&& crdBuilder.Build__c  && crdBuilder.valid__c ){
            this.processComplete();
            
        }else if(!crdBuilder.Aicallout__c  && !crdBuilder.AIRealtime__c
        			 && !crdBuilder.Sent_AI_request__c && crdBuilder.Build__c  
        			 && crdBuilder.valid__c  && crdBuilder.complete__c ){
            this.processAIRequest();
            //this.currentProcessName = 'Sending AI request';
        //}else if(crdBuilder.Sent_AI_request__c == false ){//Make AI Response
            //this.processAICallout();
            //this.currentProcessName = 'Waiting for AI reponse';
            //this.canstop = true; Commented by Amit in 7th May to resolve the issue where case was getting closed in AI Batch
            this.waitingForRxPlan = true;
        }else if(crdBuilder.CRD__r.RxPlanID__c == Null && !AIPCGFAILURE 
        			&& crdBuilder.Build__c  && crdBuilder.valid__c  
        			&& crdBuilder.complete__c ){
            this.currentProcessName = RXWAIT;
            this.canstop = true;
            this.waitingForRxPlan = true;
        }else if(!crdBuilder.CAG__c && crdBuilder.CRD__r.RxPlanID__c != Null){
                this.processCAG();
        }else if(!crdBuilder.PERS__c  && crdBuilder.CRD__r.RxPlanID__c != Null){
                this.processPers();                 
        }else if(!crdBuilder.XML__c  && !crdBuilder.XMLRealtime__c  && crdBuilder.CRD__r.RxPlanID__c != Null){
                 this.processXML();
        }else if(crdBuilder.XML__c /*&& crdBuilder.XMLRealtime__c == true*/ && crdBuilder.CRD__r.RxPlanID__c != Null){   // Added by Ayushi for FIFO Tagging Request 05996
                this.processFIFO();
        }else{
                this.canStop = true;
        }
    }
    
        /*Method : processAIRequest*/
    private void processAIRequest(){
        List<CRD__c>  lstCrds = [select CPE__c,Y_Schd__c, Sub_segment__c,Aicallout__c, Override_Retail_Y_Schedule__c
							        , Retail_Y_Schedule_Override__c, 
							        Query_String_Field__c, Query_String_CRD_2__c, Query_String_Drug_Coverage__c, Override_Standard_Max_Pay__c,  LastSent__c, 
							        Partial_Control_Group__c, id, SAC_Override_Option__c, PSP_Override_Option__c,Rx_Override_Option__c, Mail_Y_Schedule__c, 
							        PSP_Letter_Templates__c, Subsegment__c, High_Value_Client__c, Partner_Server__c, Rating_ERB__c, API_Session_Id__c,  
							        Rx_PP_ID__c,Plan_Type_Specialty__c, Which_system_will_the_plan_be_installed__c, Plan_Type_Retail__c, Plan_Type_Mail__c, 
							        TP_ID__c, Platform_Information__c, Does_the_client_want_to_do_COB__c,Out_of_Network_Cost_Sharing__c
							        , Do_you_want_to_do_Save_A_Copay__c, 
							        Enrolled_in_PA_for_other_condition__c, Do_you_want_to_do_Step_Therapy__c, Client_Effective_Date__c, 
							        Effective_Start_Date__c, Account__c, Are_you_creating_a_Package_Plan__c, Integrate_with_Medical__c
							        , Status__c, Name, Plan_Type_Paper__c,
							        Name_of_Approver_on_SSD__c, Date_of_Approval_on_SSD__c,Customization_Approved__c, Insured_Type__c
							        , Risk_Indicator__c, Full_Control_Group__c, 
							        Full_Control_Group__r.CSAP_Plan_ID__c, Full_Control_Group__r.CSAP_Control_ID__c
							        ,Full_Control_Group__r.CSAP_Suffix_ID__c, control__c, plan__c,
							        Full_Control_Group__r.CSAP_Account_ID__c,Plan_Platform__c,Standard_or_Custom_Plan__c
							        ,OON_Cost_Share_Not_Greater_50_Drug_Cost__c,Account_Name__c,CRD_Automated__c,
							        Predefined__c 
							      from crd__c where id =:crdBuilder.crd__c LIMIT 80000];
        
        CB_MassSend2AI objSendToAI = new CB_MassSend2AI();
        Set<Id>  aiIdSet = objSendToAI.massSend2AI(lstCrds);
        if(objSendToAI.failures.size() > 0){
             this.handleProcessError(APEXCLASSAI,objSendToAI.failures,AIFAILURE);
             this.canstop = true;
             this.AIPCGFAILURE = True;
        }else{
            //crdBuilder.AIRealtime__c = true;
            //crdBuilder.Sent_AI_request__c = true;
            //crdBuilder.Aicallout__c = true;
            //update crdBuilder;
        
            processAICallout(crdBuilder.id);
            this.currentProcessName = SENDAI;
            
            
        }
    }
    
    /*Method : processAICallout*/
    @future(callout = true)
    global static void processAICallout(Id crdBuilderId){
        CRDBuildOrder__c builder = [Select id,case__c,case__r.casenumber,ignored__C,FalloutCase__r.status, crd__c
        							,crd__r.Account__c,crd__r.Effective_Date__c,crd__r.Effective_Start_Date__c 
        							from CRDBuildOrder__c where id=:crdBuilderId LIMIT 80000];
         List<AI_Request__c > aiRequest = new List<AI_Request__c>();
         aiRequest =  [SELECT 
                        Id, Batch_Logger_ID__c,Benefit__c, Benefits_String_Extn__c, CRD_ID__c,
                        Integration_1__c, Plan_ID__c,Pricing_Schedule__c, Request_Type__c, 
                        Risk_Indicator__c,StateList_to_Remove__c, Created_by_Batch_Process__c, 
                        Processed__c,State_Mandates_Apply__c, States_List_for_Mandate__c 
                      FROM 
                        AI_Request__c 
                      WHERE 
                        CRD_ID__c = : builder.crd__c AND Processed__c = false Order by CreatedDate desc Limit 1];           
             CB_MassSend2AIRequest massSendToAi = new CB_MassSend2AIRequest();
             massSendToAi.fromContinueAutomation = TRUE;
             massSendToAi.massSend2AIRequest(aiRequest);
        // builder.Sent_AI_request__c = true;
        // builder.Aicallout__c = true;
        //update builder; 
    }
    
    /*Method : processPers*/
    private void processPers(){        
        CB_SeedPersStep objPers = new CB_SeedPersStep();
        objPers.seedStep(new List<CRDBuildOrder__c >{crdBuilder});
        if(objPers.failures.IsEmpty()){
            crdBuilder.Processed__c = true;            
            crdBuilder.PERS__c = True;
            database.update(crdBuilder);
            this.currentProcessName = XMLSTEP;
        }else{
            this.handleProcessError(APEXCLASSPERS,objPers.failures,CAGFAILURE);
        }
    }
    /*Method : processCAG*/
    private void processCAG(){        
    CB_MultidayProcessHandler objCag = new CB_MultidayProcessHandler();             
      CRDBuildOrder__c builder = [SELECT Account_Name__c,Age__c,crd__r.name,Aicallout__c,AIRealtime__c,Audit_UI_Link__c
      							  	,Build__c,builtRealTime__c,CAGRealtime__c,CAG__c,Carrier_ID__c,Case__c,completeChkRealTime__c,complete__c
      							  	,Conga_Solution_URL__c,CRD__r.Effective_Date__c,crd__r.PERS_timestamp__c,CRD__r.Effective_Start_Date__c
      							  	,CRD__r.Account__c,ConnectionReceivedId,ConnectionSentId,ControlPlanEffective__c,Control_Plan_Effective__c
      							  	,Control__c,CRD_RxPlan_ID__c,CRD_Salesforce_ID__c,CRD__c,CreatedById,CreatedDate,CurrentStatusCRD__c
      							  	,CVS__c,Daysforcompletion__c,Description__c,DirectSuccess__c,Effective_date__c,ExistingRxplan__c,FalloutCase__c
      							  	,Id,Ignored__c,Invalid__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate
      							  	,Name,OwnerId,PDFRealtime__c,PDF__c,PERSTimeStamp__c,Pers_Full__c,Pers_Key__c,PERS_timestamp__c
      							  	,PERS__c,Plan__c,Processed__c,Ready_to_Archive__c,Sent_AI_request__c,Sent_to_CVS_Date__c,Status__c
      							  	,Subsegment__c,Success_Case__c,SystemModstamp,validatedRealTime__c,valid__c,What_is_the_carrier__c
      							  	,XMLRealtime__c,XML__c,CRD__r.Partial_Control_Group__c,CRD__r.Full_Control_Group__c
      							  	,crd__r.RxPlanID__c,Success_Case__r.Status,FalloutCase__r.status,FalloutCase__r.Reason
      							  	,FalloutCase__r.Review_Notes__c,CRD__r.Ignored__c,CRD__r.Plan__c,CRD__r.Control__c
                                  FROM 
                                      CRDBuildOrder__c 
                                  where id=:crdBuilder.Id LIMIT 80000];
        objCag.ProcessCBONs(new List<CRDBuildOrder__c >{builder});
        //Modified for ST# 277 by Amit Jain on 07 Sept, 2015, added exceptionMessage condition
        if(objCag.failureRecords.IsEmpty()){
            crdBuilder.Processed__c = true;            
            crdBuilder.CAGRealtime__c = true;
            crdBuilder.CAG__C = true;
            database.update(crdBuilder);
            this.currentProcessName = PERSSTEP;
        }else{
            this.handleProcessError(APEXCLASSCAG,objCag.failureRecords,CAGFAILURE);
        }
    }
    /*Method : processXML*/
    public void processXML(){
      try{
        CB_XmlGenerator objXml = new CB_XmlGenerator ();
        objXml.xmlGenerator(new List<CRDBuildOrder__c >{crdBuilder});
        if(objXml.failures.IsEmpty()){
            this.getUpdatedCRDBuilder();
            crdBuilder.XMLRealtime__c = true;
            database.update(crdBuilder);
            this.currentProcessName = FIFO;  //Updated by Ayushi for FIFO Tagging Request 05996
            //Commented by Ayushi for FIFO Tagging Request 05996
            //this.canStop = true;
        }else{
            this.handleProcessError(APEXCLASSXML,objXml.failures,XMLFAILURE);
        }
       }catch(exception e){
         throw e;
       }
    }
    
    //Added by Ayushi for FIFO Tagging Request 05996
    /*Method : processFIFO*/
    public void processFIFO(){
      try{
        CB_FIFO_Tag objFIFO = new CB_FIFO_Tag();
        objFIFO.FIFO_Flag_Execute(new List<CRDBuildOrder__c >{crdBuilder});
        this.currentProcessName = PDFSTEP;
        this.canStop = true;
       }catch(exception e){
         throw e;
       }    
    }
    /*Method : processValidate*/
    private void processValidate(){
        CB_ValidationsHandler validationHandler = new CB_ValidationsHandler();
        validationHandler.executeValidation(new List<CRDBuildOrder__c>{crdBuilder});
        if(validationHandler.lstBuilderFallout.isEmpty()){
            crdBuilder.Processed__c = true;
            crdBuilder.validatedRealTime__c=true;           
            database.update(crdBuilder);
            this.currentProcessName = COMPLETESTEP;
        }else{
            this.handleProcessError(APEXCLASSVALID,validationHandler.lstBuilderFallout,VALIDFAILURE);
        }
    }
    /*Method : processComplete*/
    private void processComplete(){
        CB_Completion objCompletion = new CB_Completion();        
        objCompletion.execute(new List<CRDBuildOrder__c>{crdBuilder});
        if(objCompletion.failures.IsEmpty()){
            crdBuilder.Processed__c = true;
            crdBuilder.completeChkRealTime__c = true;            
            //Added by Sushant to update CaseAutomationReason field on Case : Req 5230
            successCaseId = crdbuilder.Success_Case__c;
            if(successCaseId!= Null){
                list<case> successCase = new List<case>([Select id from case where id =: successCaseId LIMIT 80000]);
                successCase[0].CaseAutomationReason__c = CRDA;
                database.update(successCase);
            }
            database.update(crdBuilder);
            if(currentCaseId == crdBuilder.FalloutCase__c  && FALSEVAL.equalsIgnoreCase(system.label.CRDBuilder_fullAuto)){
                this.canStop = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, AIAPEXMSG));  
            }else{
                this.currentProcessName = AIREQUESTLABEL;
            }   
        }else{
            this.handleProcessError(APEXCLASSVALID,objCompletion.failures,COMPLETIONFAILURE);
        }
    }
    /*Method : getUpdatedCRDBuilder*/
    private void getUpdatedCRDBuilder(){
        for(CRDBuildOrder__c obj : [select 
                                         Name, id,FalloutCase__c,Processed__c ,PERS_timestamp__c,validatedRealTime__c,Success_Case__c,CRD__r.Name,
                                            CRD__r.CRD_Automated__c,CRD__r.PERS_timestamp__c,valid__c,builtRealTime__c ,Control_Plan_Effective__c,
                                            completeChkRealTime__c ,complete__c,AIRealtime__c ,CRD__r.ControlPlanEffective__c, CRD__r.Control__c,               
                                            CAGRealtime__c,Aicallout__c,XML__c,XMLRealtime__c,PDF__c,PDFRealtime__c  , Success_Case__r.Fallout_Reason__c
                                            , FalloutCase__r.Fallout_Reason__c, Build__c,    PERS__c, CAG__c,Sent_AI_request__c,Plan__c
                                            ,Subsegment__c,Success_Case__r.Membership_Count__c,FalloutCase__r.Membership_Count__c,
                                            CRD__r.Plan__c,CRD__r.Effective_Date__c,crd__r.Effective_Start_Date__c,CRD__r.RxPlanID__c
                                            ,CRD__r.Y_Schd__c,ControlPlanEffective__c
                                            ,CRD__r.Account_Name__c,CRD__r.Account__c,case__c,case__r.casenumber,FalloutCase__r.CaseNumber
                                            , CVS__c,Success_Case__r.FIFO_Tag__c
                                            ,crd__c,FalloutCase__r.status,PERStimestamp__c,Success_Case__r.status,Ready_to_Archive__c
                                            ,Success_Case__r.FIFO_record_name__c,Success_Case__r.Transaction_Type__c
                                            ,FalloutCase__r.FIFO_record_name__c,Control__c,Effective_date__c,FalloutCase__r.FIFO_Tag__c,Case__r.FIFO_Tag__c
                                            ,CRD__r.National__c,Case__r.FIFO_record_name__c,FalloutCase__r.Transaction_Type__c
                                            ,Case__r.Transaction_Type__c,Case__r.Has_Custom_Network__c  
                                            //Added by Ayushi for request 05996

                                from 
                                    CRDBuildOrder__c 
                                where 
                                    id =: crdBuilder.id LIMIT 80000]){
                        
            crdBuilder = obj;
                        
        }
    }
    /* Commented by Amit on 3/31/2016 and replaced by Future method as part of issue for Req 6329
    private void processBuild(){
       CB_BuildStep objBuild = new CB_BuildStep();
       objBuild.execute(new List<CRDBuildOrder__c>{crdBuilder});       
        this.getUpdatedCRDBuilder();                     
        if(objBuild.CrdBuilderFallouts != null &&  objBuild.CrdBuilderFallouts.size() > 0){
             this.handleProcessError(APEXCLASSBUILD,objBuild.CrdBuilderFallouts,BUILDFAILURE);
        }else{
            crdBuilder.builtRealTime__c = true;
            crdBuilder.Processed__c = true;
            update crdBuilder;
            this.currentProcessName = 'Processing Validation Step';
        }
    }
    */
     //Added by Amit on 3/30/2016
     /*Method : processBuildFuture*/
    @future
    public static void processBuildFuture(Id cbonID){
     try{
        CRDBuildOrder__c crdBuilderRecord = new CRDBuildOrder__c();
        for(CRDBuildOrder__c obj : [select 
                                         Name, id,FalloutCase__c,Processed__c ,PERS_timestamp__c,validatedRealTime__c,Success_Case__c,CRD__r.Name,
                                            CRD__r.CRD_Automated__c,CRD__r.PERS_timestamp__c,valid__c,builtRealTime__c ,Control_Plan_Effective__c,
                                            completeChkRealTime__c ,complete__c,AIRealtime__c ,CRD__r.ControlPlanEffective__c, CRD__r.Control__c,               
                                            CAGRealtime__c,Aicallout__c,XML__c,XMLRealtime__c,PDF__c,PDFRealtime__c  , Success_Case__r.Fallout_Reason__c
                                            , FalloutCase__r.Fallout_Reason__c, Build__c,    PERS__c, CAG__c,Sent_AI_request__c,Plan__c
                                            ,Subsegment__c,Success_Case__r.Membership_Count__c,FalloutCase__r.Membership_Count__c,
                                            CRD__r.Plan__c,CRD__r.Effective_Date__c,crd__r.Effective_Start_Date__c,CRD__r.RxPlanID__c
                                            ,CRD__r.Y_Schd__c,ControlPlanEffective__c
                                            ,CRD__r.Account_Name__c,CRD__r.Account__c,case__c,case__r.casenumber,FalloutCase__r.CaseNumber
                                            , CVS__c,Success_Case__r.FIFO_Tag__c
                                            ,crd__c,FalloutCase__r.status,PERStimestamp__c,Success_Case__r.status,Ready_to_Archive__c
                                            ,Success_Case__r.FIFO_record_name__c,Success_Case__r.Transaction_Type__c
                                            ,FalloutCase__r.FIFO_record_name__c,Control__c,Effective_date__c,FalloutCase__r.FIFO_Tag__c
                                            ,Case__r.FIFO_Tag__c,CRD__r.National__c,Case__r.FIFO_record_name__c
                                            ,FalloutCase__r.Transaction_Type__c,Case__r.Transaction_Type__c,Case__r.Has_Custom_Network__c  
                                            //Added by Ayushi for request 05996
                                from 
                                    CRDBuildOrder__c 
                                where 
                                    id =: cbonID LIMIT 80000]){
                        
            crdBuilderRecord = obj;
                        
        }
        CB_BuildStep.passPreBuildFallout = True;
        objBuildPreBuild.execute(new List<CRDBuildOrder__c>{crdBuilderRecord});        
         if((objBuildPreBuild.CrdBuilderFallouts != null &&  objBuildPreBuild.CrdBuilderFallouts.size() > 0) 
         		|| objBuildPreBuild.hasBuilderFallout){
             //Do nothing, Error handling will be done outside of this future method
        }else{
            crdBuilderRecord.build__c = true;
            crdBuilderRecord.builtRealTime__c = true;
            crdBuilderRecord.Processed__c = true;
            database.update(crdBuilderRecord);
        }
      }catch(exception e){
        throw e;
      }
    }
    // Added by Amit Ends
    /*Method : handleProcessError*/
    private void handleProcessError(String procesName, List<CRD_BuilderFallout__c> fallouts, String errorMessage){
     //update CaseAutomationReason for each FalloutCase : Req 5230
        falloutCaseId = fallouts[0].caseid__c;
        list<case> caseList = new list<case>([Select id,status from Case where id =: falloutCaseId LIMIT 80000]);
        caselist[0].CaseAutomationReason__c = CRDA;
        caselist[0].status = CASESTATUSVAL; // Added by Amit for request 5305
        database.update(caselist);
        //handle errors and stop the process
        this.canStop = true;
        //TODO:- AMIT create falloutjunction        
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));  
        logger.Errored__c = true;
        logger.Success__c = false;
        //logger.       
        database.update(logger);
        
        List<CRD_BF_CALog_Junc__c> listJuncnLog = new List<CRD_BF_CALog_Junc__c>();
        CRD_BF_CALog_Junc__c juncnLog = new CRD_BF_CALog_Junc__c();
        for(CRD_BuilderFallout__c fallout : triggerFallouts){
            juncnLog = new CRD_BF_CALog_Junc__c();
            juncnLog.CA_LogID__c =  logger.id;
            juncnLog.CRD_BID__c = fallout.id;
            juncnLog.Type__c = CALOGJUNCTYPE;
            listJuncnLog.add(juncnLog);
        }
        database.insert(listJuncnLog);
        this.canStopReason = errorMessage;//Richa added for Req 5083
    }
    
    /*Method : hasNewerRecord*/
    private void hasNewerRecord(){
        Integer machingCases = [ Select 
                                    Id,casenumber
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
                                    AND PERStimestamp__c >: crdBuilder.PERS_timestamp__c  limit 1].size();  
        
        if( machingCases > 0 || machingCrds > 0 || machingPers > 0){
             String message = NEWERVAL 
                                +  (machingCases > 0 ? ' Case ' : '')
                                +  (machingCrds > 0 ? ', CRD ' : '')
                                +  (machingPers > 0 ? ', PERS ' : '')
                                + STRMSGVAL;
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));  
             //this.canStop = true;         
        }
        
    }

}