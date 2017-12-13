/*Class: CB_BatchOrchestration*/
public without sharing class CB_BatchOrchestration{
    PRIVATE integer bATCHSIZE; 
    PRIVATE Integer bATCHSIZEDefault;
    PRIVATE Integer bATCHSIZEBuild;
    PRIVATE Integer bATCHSIZEValidation;
    PRIVATE Integer bATCHSIZEcompletion;
    PRIVATE Integer bATCHSIZEDAIlogs;
    PRIVATE Integer bATCHSIZEaisend;
    PRIVATE Integer bATCHSIZExml;
    PRIVATE Integer bATCHSIZEpdf;
    PRIVATE Integer bATCHSIZEDcvs;
    PRIVATE STATIC FINAL STRING BLANK = '';
    PRIVATE STATIC FINAL STRING BUILD = 'Batch_CRDBuildStep';
    PRIVATE STATIC FINAL STRING VALIDATE = 'Batch_ValidateStep';
    PRIVATE STATIC FINAL STRING COMPLETE = 'Batch_CompleteStep';
    PRIVATE STATIC FINAL STRING AILOGS = 'Batch_AIlogs';
    PRIVATE STATIC FINAL STRING SEEDS = 'Batch_Seeds';
    PRIVATE STATIC FINAL STRING CAG = 'Batch_CAG' ;
    PRIVATE STATIC FINAL STRING XML = 'Batch_XML';
    PRIVATE STATIC FINAL STRING FIFO = 'Batch_FIFO';
    PRIVATE STATIC FINAL STRING TRUELABEL = 'true';
    PRIVATE STATIC FINAL STRING SELECTLABEL = 'Select ';
    PRIVATE STATIC FINAL STRING QUERY1 = 'id,Subsegment__c,createddate,aicallout__c,control__c,Plan__c,Effective_date__c,Success_Case__r.FIFO_Tag__c,Success_Case__r.FIFO_record_name__c,Success_Case__r.Membership_Count__c,Success_Case__r.Transaction_Type__c,FalloutCase__r.FIFO_Tag__c,FalloutCase__r.Membership_Count__c,Case__r.FIFO_Tag__c,CRD__r.National__c,FalloutCase__r.FIFO_record_name__c,Case__r.FIFO_record_name__c,FalloutCase__r.Transaction_Type__c,Case__r.Transaction_Type__c,builtrealtime__c,cag__c,case__c,complete__c,completechkrealtime__c,controlplaneffective__c,currentstatuscrd__c,cvs__c,existingrxplan__c,falloutcase__c,pdf__c,pdfrealtime__c,pers__c,pers_full__c,pers_timestamp__c,processed__c,success_case__c,valid__c,validatedrealtime__c,xml__c,xmlrealtime__c,crd__r.pers_timestamp__c,crd__r.controlplaneffective__c,CRD__r.Y_Schd__c,crd__r.account__c,crd__r.name,crd__r.effective_date__c,control_plan_effective__c,name,crd__r.control__c,crd__r.plan__c,crd__r.effective_start_date__c,crd__r.rxplanid__c,perstimestamp__c,crd__r.status__c,crd__r.lastsent__c,crd__r.xmldate_time_stamp__c,Account_Name__c,Age__c,AIRealtime__c,Audit_UI_Link__c,Build__c,CAGRealtime__c,Carrier_ID__c,Conga_Solution_URL__c,ConnectionReceivedId,ConnectionSentId,CRD_RxPlan_ID__c,CRD__r.Partial_Control_Group__c,CRD_Salesforce_ID__c,CRD__c,CreatedById,Daysforcompletion__c,Description__c,DirectSuccess__c,Ignored__c,Invalid__c,IsDeleted,LastModifiedById,LastModifiedDate,OwnerId,Pers_Key__c,Ready_to_Archive__c,Sent_AI_request__c,Sent_to_CVS_Date__c,Status__c,Success_Case__r.Status,SystemModstamp,What_is_the_carrier__c,Case__r.Has_Custom_Network__c';
    PRIVATE STATIC FINAL STRING LABEL1 = ' From crdbuildorder__c ';
    PRIVATE STATIC FINAL STRING LABEL2 = ' Build__c = false and Carrier_ID__c!= Null';
    PRIVATE STATIC FINAL STRING LABEL3 = ' valid__c = False  AND Build__c = True';
    PRIVATE STATIC FINAL STRING LABEL4 = ' valid__c = true and Build__c = True and Complete__c = false  AND CRD__c <> null';
    PRIVATE STATIC FINAL STRING LABEL5 = ' valid__c = true and Build__c = True and Complete__c = true AND Aicallout__c = false AND CRD__c <> null ';
    PRIVATE STATIC FINAL STRING LABEL6 = ' valid__c = true and Build__c = True and Complete__c = True and PERS__c = False and CAG__c = TRUE and  CRD__r.RxPlanID__c != Null and AICAllout__c = True';
    PRIVATE STATIC FINAL STRING LABEL7 = '  valid__c = true and Build__c = True and Complete__c = True AND CAG__c = False  AND  CRD__r.RxPlanID__c != Null';
    PRIVATE STATIC FINAL STRING LABEL8 = ' valid__c = true and Build__c = True and Complete__c = True and PERS__c = True AND CAG__c = TRUE AND XML__c = FALSE AND  CRD__r.RxPlanID__c != Null';
    PRIVATE STATIC FINAL STRING LABEL9 = ' Build__c = True';
    PRIVATE STATIC FINAL STRING LABEL10 = ' and id in ';
    PRIVATE STATIC FINAL STRING LABEL11 = ' ORDER BY PERSTimeStamp__c desc , createddate desc';
    PRIVATE STATIC FINAL STRING LABEL12 = '  and Processed__c = false';
    PRIVATE STATIC FINAL STRING LABEL13 = ' and createddate = Today';
    PRIVATE STATIC FINAL STRING LABEL14 = ' and createddate = Today and FalloutCase__c = null';
    PRIVATE STATIC FINAL STRING LABEL15 = ' and FalloutCase__c = null';
    PRIVATE STATIC FINAL STRING LABEL16 = ' and CRD__c != NULL AND XML__c = False AND PDF__c = False AND CVS__c = False';
    PRIVATE STATIC FINAL STRING LABEL17 = ' Where ';
    PRIVATE STATIC FINAL STRING LABEL18 = 'CRDBuilder';
    PRIVATE STATIC FINAL STRING LABEL19 = 'Starting Batch_CRDBuildStep1 Batch';
    PRIVATE STATIC FINAL STRING LABEL20 = 'CRD Builder Batch_CRDBuildStep';
    PRIVATE STATIC FINAL STRING LABEL21 = 'Completed Batch_CRDBuildStep1.';
    PRIVATE STATIC FINAL STRING LABEL22 = 'Starting BAC_CB_Validations Batch';
    PRIVATE STATIC FINAL STRING LABEL23 = 'CRD Builder BAC_CB_Validations';
    PRIVATE STATIC FINAL STRING LABEL24 = 'Completed BAC_CB_Validations.';
    PRIVATE STATIC FINAL STRING LABEL25 = 'Starting BAC_CB_Completion Batch';
    PRIVATE STATIC FINAL STRING LABEL26 = 'CRD Builder BAC_CB_Completion';
    PRIVATE STATIC FINAL STRING LABEL27 = 'Completed BAC_CB_Completion.';
    PRIVATE STATIC FINAL STRING LABEL28 = 'Starting BAC_CB_SeedPersStep';
    PRIVATE STATIC FINAL STRING LABEL29 = 'CRD Builder BAC_CB_SeedPersStep';
    PRIVATE STATIC FINAL STRING LABEL30 = 'Completed BAC_CB_SeedPersStep.';
    PRIVATE STATIC FINAL STRING LABEL31 = 'Starting BAC_CB_Completion Batch';
    PRIVATE STATIC FINAL STRING LABEL32 = 'CRD Builder BAC_CB_Completion';
    PRIVATE STATIC FINAL STRING LABEL33 = 'Completed BAC_CB_Completion.';
    PRIVATE STATIC FINAL STRING LABEL34 = 'Starting Batch_CRDXMLStep Batch';
    PRIVATE STATIC FINAL STRING LABEL35 = 'CRD Builder Batch_CRDXMLStep';
    PRIVATE STATIC FINAL STRING LABEL36 = 'Completed Batch_CRDXMLStep.';
    PRIVATE STATIC FINAL STRING LABEL37 = 'Starting Batch_CRDFIFOStep Batch';
    PRIVATE STATIC FINAL STRING LABEL38 = 'CRD Builder Batch_CRDFIFOStep' ;
    PRIVATE STATIC FINAL STRING LABEL39 = 'Completed Batch_CRDFIFOStep.';
    
    Public set<Id> cBONID{get;set;}
    public string query{get;set;}
    /*Method: querymaker*/
     public string querymaker(string cname){
        String queryhead = SELECTLABEL;
        //cBONID = new set<id>();
        String fields = BLANK;

         fields = QUERY1;
        
        queryhead = queryhead + fields + LABEL1;
        
        String whereClause = BLANK;
        if(BUILD.equalsIgnoreCase(cname)){
                whereClause = LABEL2;
        }
        else if(VALIDATE.equalsIgnoreCase(cname)){
            whereClause = LABEL3;
        }
        else if(COMPLETE.equalsIgnoreCase(cname)){
            whereClause = LABEL4;
        }
        else if(AILOGS.equalsIgnoreCase(cname)){ 
            whereClause = LABEL5;
        }else if(SEEDS.equalsIgnoreCase(cname)){ 
            whereClause = LABEL6;
        }else if(CAG.equalsIgnoreCase(cname)){
            whereClause = LABEL7;
        }else if(XML.equalsIgnoreCase(cname)){
            whereClause = LABEL8;
        }else if(FIFO.equalsIgnoreCase(cname)){  
            //whereClause = ' valid__c = true and Build__c = True and Complete__c = True and PERS__c = True AND CAG__c = TRUE AND XML__c = True AND  CRD__r.RxPlanID__c != Null';
            whereClause = LABEL9;//Modified by Amit for ST# 965 on 1 Feb, 2016
        }    //Added by Ayushi for FIFO Tagging Request 05996           
         if(cBONID != null && cBONID.size() > 0){
            String inClause = String.format( '(\'\'{0}\'\')', 
                         new List<String> { String.join( new List<Id>(cbonid) , '\',\'') });
           
                 whereClause += LABEL10 +  inClause ;
             if(CAG.equalsIgnoreCase(cname)){
             whereClause += LABEL11;
             }
        }
        else{
            if(VALIDATE.equalsIgnoreCase(cname)  || BUILD.equalsIgnoreCase(cname) || CAG.equalsIgnoreCase(cname))
            {whereClause += LABEL12;}
            //Modified By Amit for ST# 965
            if(FIFO.equalsIgnoreCase(cname))
            {whereClause += LABEL13;} 
                
            else if(!FIFO.equalsIgnoreCase(cname) && !XML.equalsIgnoreCase(cname))    
            {whereClause += LABEL14;                   }
            else
            {whereClause += LABEL15;}
            //Ends    
            if(SEEDS.equalsIgnoreCase(cname)){
                whereClause += LABEL16;
            }       
        }
        queryhead += LABEL17 + whereClause;
        return queryhead;
    }
    /*Method: CB_BatchOrchestration*/
    public CB_BatchOrchestration(){
        bATCHSIZEDefault=Integer.valueOf(system.label.CRDBuilder_DefaultBatchsize);
        bATCHSIZEBuild=Integer.valueOf(system.label.CRDBuilder_BuildBatchsize);
        bATCHSIZEValidation=Integer.valueOf(system.label.CRDBuilder_ValidationBatchsize);
        bATCHSIZEcompletion=Integer.valueOf(system.label.CRDBuilder_CompleteBatchsize);
        bATCHSIZEDAIlogs=Integer.valueOf(system.label.CRDBuilder_AIlogsBatchsize);
        bATCHSIZEaisend=Integer.valueOf(system.label.CRDBuilder_AIcallBatchsize);
        bATCHSIZExml=Integer.valueOf(system.label.CRDBuilder_XMLBatchsize);
        bATCHSIZEpdf=Integer.valueOf(system.label.CRDBuilder_PDFBatchsize);
        bATCHSIZEDcvs=Integer.valueOf(system.label.CRDBuilder_CVSBatchsize);       
    }
    /*Method: callNext*/
    public void callNext(string callerName){
        Boolean crdAutoLink = !Boolean.valueOf(System.Label.BypassCRDAutoLinking);
        Boolean isStandardBatchMode = true;
        if(cBONID!=null && cBONID.size()>0)
        {isStandardBatchMode = false;   }
        if(callerName!=NULL&&callerName!=BLANK && (isStandardBatchMode || crdAutoLink) ){ //  !System.Label.BypassCRDAutoLinking.equalsIgnoreCase(TRUELABEL)){
                 string cname=callerName.trim();
                 query = querymaker(cname);
                  if(BUILD.equalsIgnoreCase(cname)){
                        callBatch_CRDBuildStep();
                 }
                 else if(VALIDATE.equalsIgnoreCase(cname)){
                        callBatch_customValidation();
                 }
                 else if(COMPLETE.equalsIgnoreCase(cname)){//&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase(TRUELABEL)){ //else BCT will send ALL crds to AI.
                        callBatch_CompletionStep();
                 }
                 else if(AILOGS.equalsIgnoreCase(cname) && system.label.CRDBuilder_fullAuto.equalsIgnoreCase(TRUELABEL)){ //else BCT will send ALL crds to AI.
                        callBatch_sendtoAI();
                 }
                 else if(CAG.equalsIgnoreCase(cname)){//&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase(TRUELABEL)){ //else BCT will send ALL crds to AI.
                        callBatch_CAGRestructure();
                 }
                 else if(SEEDS.equalsIgnoreCase(cname)){//&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase(TRUELABEL)){ //else BCT will send ALL crds to AI.
                        callBatch_SeedPERSstep();
                 }
                 else if(XML.equalsIgnoreCase(cname)){//&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase(TRUELABEL)){ //else BCT will send ALL crds to AI.
                        callBatch_CRDXMLStep();
                 }else if(FIFO.equalsIgnoreCase(cname)){ //Added by Ayushi for FIFO Tagging Request 05996
                        callBatch_CRDFIFOStep();
                 }
        }
   }
    //Execute the First Batch in CRD Builder Process i.e. CRDBuildStep. 
    //From the finish method of batch class call the orchestration class in order to start executing the second batch i.e. Custom Validation
    /*Method: callBatch_CRDBuildStep*/
    public Id callBatch_CRDBuildStep(){
        JobLogger.startBatch(NULL, LABEL19, userinfo.getUserId(), system.now(), true, LABEL20);
        Batch_CRDBuildStep1 bch=new Batch_CRDBuildStep1();
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setcbonId(cBONID);
        }
        bch.setquery(query);
        ID batchprocessID = Database.executeBatch(bch,1);
        JobLogger.endBatch(System.now(),NULL,LABEL21,Userinfo.getUserId(),true, LABEL18);
        return batchprocessid;
   }
   /*Method: callBatch_customValidation*/
   public Id callBatch_customValidation(){
        JobLogger.startBatch(NULL, LABEL22, userinfo.getUserId(), system.now(), true, LABEL23);
        BAC_CB_Validations bch=new BAC_CB_Validations();
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);            
        }
        bch.setquery(query);
        ID batchprocessID = Database.executeBatch(bch,1);
        JobLogger.endBatch(System.now(),NULL,LABEL24,Userinfo.getUserId(),true,LABEL18);
        return batchprocessid;
   }
    /*Method: callBatch_CompletionStep*/
   public Id callBatch_CompletionStep(){
        JobLogger.startBatch(NULL, LABEL25, userinfo.getUserId(), system.now(), true, LABEL26);
        BAC_CB_Completion bch=new BAC_CB_Completion();
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);
        }
        bch.setquery(query);
        ID batchprocessID = Database.executeBatch(bch,200);
        JobLogger.endBatch(System.now(),NULL,LABEL27,Userinfo.getUserId(),true,LABEL18);
        return batchprocessid;
   }
/*Method: callBatch_sendtoAI*/
   public Id callBatch_sendtoAI(){
        BAC_CB_MassSend2AI bch = new BAC_CB_MassSend2AI();
        if(cBONID!=null && cBONID.size()>0)
        {
           bch .setCbonId(cBONID);
        }
        bch .setquery(query);
        ID batchprocessID = Database.executeBatch(bch,1);
        
        return null;//batchprocessid;
   }
   
/*Method: callBatch_SeedPERSstep*/
   public Id callBatch_SeedPERSstep(){//Richa added on 1/7/2014 for Req - 4927
        JobLogger.startBatch(NULL, LABEL28, userinfo.getUserId(), system.now(), true, LABEL29);
        
        
        JobLogger.endBatch(System.now(),NULL,LABEL30,Userinfo.getUserId(),true,LABEL18);
          //select CRD use schema classes to build query. where validate, complete,automated=true and aicallout=false and CalloutDone=false
        BAC_CB_SeedPersStep bch=new BAC_CB_SeedPersStep();//query string);
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);
        }
        bch.setquery(query);
        ID batchprocessid = Database.executeBatch(bch,200);
        //also create a joblog using joblogger class
        
        return batchprocessid;
   }
  /*Method: callBatch_CAGRestructure*/ 
   public Id callBatch_CAGRestructure(){
     JobLogger.startBatch(NULL, LABEL31, userinfo.getUserId(), system.now(), true, LABEL32);
        BAC_CB_CAGRestructure bch=new BAC_CB_CAGRestructure();
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);
        }
        bch.setquery(query);
        ID batchprocessID = Database.executeBatch(bch,200);
        JobLogger.endBatch(System.now(),NULL,LABEL33,Userinfo.getUserId(),true,LABEL18);
        return batchprocessid;
   }
/*Method: callBatch_CRDXMLStep*/
   public Id callBatch_CRDXMLStep(){
        JobLogger.startBatch(NULL, LABEL34, userinfo.getUserId(), system.now(), true, LABEL35);
        BAC_CB_CRDXMLStep bch=new BAC_CB_CRDXMLStep();
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);
        }
        bch.setquery(query);
        ID batchprocessID = Database.executeBatch(bch,1);
        JobLogger.endBatch(System.now(),NULL,LABEL36,Userinfo.getUserId(),true,LABEL18);
        return batchprocessid;
   }
   
   //Added by Ayushi for FIFO Tagging Request 05996
   /*Method: callBatch_CRDFIFOStep*/
   public Id callBatch_CRDFIFOStep(){
        JobLogger.startBatch(NULL, LABEL37, userinfo.getUserId(), system.now(), true, LABEL38);
        BAC_FIFOTagging bch=new BAC_FIFOTagging();
         //Added by Amit
        if(cBONID!=null && cBONID.size()>0)
        {
            bch.setCbonId(cBONID);
        }
        bch.setquery(query);
        //Ends
        ID batchprocessID = Database.executeBatch(bch,200);
        JobLogger.endBatch(System.now(),NULL,LABEL39,Userinfo.getUserId(),true,LABEL18);
        return batchprocessid;
   }
   /*Method: callBatch_CRDPDFStep*/
   public Id callBatch_CRDPDFStep(){
    ID batchprocessid;
          /*select CRD use schema classes to build query. where validate, complete,automated=true and aicallout=false and CalloutDone=false
        Batch_AIlogs bch=new Batch_AIlogs(query string);
        ID batchprocessid = Database.executeBatch(bch,bATCHSIZEDAIlogs);
        also create a joblog using joblogger class
        */
        return batchprocessid;
   }
   /*Method: callBatch_CRDCVSStep*/
   public Id callBatch_CRDCVSStep(){
    ID batchprocessid;
          /*select CRD use schema classes to build query. where validate, complete,automated=true and aicallout=false and CalloutDone=false
        Batch_AIlogs bch=new Batch_AIlogs(query string);
        ID batchprocessid = Database.executeBatch(bch,bATCHSIZEDAIlogs);
        also create a joblog using joblogger class
        */
        // Database.executebatch(new BAC_ShareCases(), 200);
        return batchprocessid;
   }          
}