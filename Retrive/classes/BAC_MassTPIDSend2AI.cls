/*Purpose: Apex Batch Class to make Callout for AI Request created by batch process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
1.0      Abhishek goel    5/2/2014       Apex Batch Class to make Callout for AI Request created by batch process
======================================================================== */
global class BAC_MassTPIDSend2AI implements Database.Batchable < sObject > , Database.AllowsCallouts,Database.Stateful {
    global String query;
    global Blob attachm;
    global string Errormsg;
    Public List<crd__c> ids;
    public set<id> aiSet = new set<id>();
    public Id idset;
    Public List<AI_Request__c> aiRequestList = new List<AI_Request__c>();
    Public list<AI_Request__c> aiList = new list<AI_Request__c>();
    global AsyncApexJob asyncJob = new AsyncApexJob();
    public list < String > errorMessages {get;set;}
    /*
    * Constructor of class BAC_MassSend2AI  
    */ 
    global BAC_MassTPIDSend2AI(Id idSetinput,List<crd__c> crdid,Blob attch) {
        ids = crdid;
        attachm = attch;
        system.debug('file'+attachm);
        idset = idSetinput;
        query =  'SELECT Id, Batch_Logger_ID__c,AI_Failed__c,Benefit__c,Job_Logger__c, Benefits_String_Extn__c, CRD_ID__c,Integration_1__c, Plan_ID__c,Pricing_Schedule__c, Request_Type__c, Risk_Indicator__c,StateList_to_Remove__c, Created_by_Batch_Process__c, Processed__c,State_Mandates_Apply__c, States_List_for_Mandate__c FROM AI_Request__c WHERE Job_Logger__c =: idSet';        
        system.debug('query'+query);
    }
    /*
    * Method :- start
    * Description :- This method indicates the beignning of a batch
    */  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    /* 
    * Method :- execute
    * Description :- This method  gets current looged in user info  and generate AiRequest 
    */  
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        aiList.clear();
        aiRequestList.clear();
        for (sObject s: Scope) {
            aiRequestList.add((AI_Request__c)s);  
        }
        system.debug('size'+aiRequestList.size());
        if(aiRequestList.size()>0){
            for (AI_Request__c aiRequest : aiRequestList){
                 aiSet.add(aiRequest.id);
                try {
                    system.debug('inside callout');
                    WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
                    WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();
                    crdDetail.requestId = aiRequest.Id;
                    crdDetail.crdId = 'a0Z000000000000000';
                    crdDetail.requestType = aiRequest.Request_Type__c;
                    if (aiRequest.Plan_ID__c != null) {
                        crdDetail.planId = aiRequest.Plan_ID__c;
                    }
                    if (aiRequest.Pricing_Schedule__c != null) {
                        crdDetail.pricingSchedule = aiRequest.Pricing_Schedule__c;
                    }
                    if (aiRequest.Risk_Indicator__c != null) {
                        crdDetail.riskIndicator = aiRequest.Risk_Indicator__c;
                    }
                    system.debug('hello'+crdDetail);
                    integrationClass.SessionId = Userinfo.getsessionId();
                    integrationClass.CRDDetails = crdDetail;                    
                    WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();                    
                    sendData.endpoint_x = system.label.CL0000034;                    
                    system.debug('**integrationClass**' + integrationClass);                    
                    Boolean result = sendData.createRxPlan(integrationClass);
                                       
                    system.debug(result);                    
                }
                catch (exception e) {
                   system.debug('cathcerror'+e);
                   Errormsg = string.valueof(e);
                   AI_Request__c ai = new AI_Request__c();
                   ai.id = aiRequest.Id;
                   ai.AI_Failed__c = true;
                   ai.Job_Logger__c = idset;
                   ai.Error_Msg__c = Errormsg;
                   aiList.add(ai);
               }
            }
            update aiList;
            system.debug('update list>>'+aiList);
        }else {
            //errorMessages.add(system.label.ERR00128);
            //return null;
        }
    }
    /* 
* Method :- finish
* Description :- This method indicates all batches are processed and also schedulde the next job
*/ 
    global void finish(Database.BatchableContext BC) {
         asyncJob = [SELECT 
                                ApexClass.name,CompletedDate,CreatedDate
                                ,ExtendedStatus,Id, NumberOfErrors
                                ,ParentJobId,Status, TotalJobItems 
                            FROM 
                                AsyncApexJob 
                            where 
                                ApexClass.Name =:'BAC_MassTPIDSend2AI' 
                            Order By 
                                CompletedDate DESC NULLS First 
                            LIMIT 1] ;
        Joblog__c jLog = new Joblog__c();
           jLog.id = idset;
           jLog.Task__c = 'pre - built package plan';
           jLog.Start_time__c = asyncJob.CreatedDate;
           jLog.Notes__c = asyncJob.Status;
           jLog.Success__c = true;
           if(Errormsg != ''){
             jLog.Error__c  = Errormsg;
           }
           if(asyncJob.ExtendedStatus!=null){
             jLog.Error__c = asyncJob.ExtendedStatus;
           }
           update jLog;
        List<SObject> queryResults = Database.query('SELECT Plan_ID__c, Error_Msg__c FROM AI_Request__c WHERE AI_Failed__c = true AND  Job_Logger__c =: idSet');
        system.debug('attach==>'+queryResults);
        List<String> queryFields = new List<String> {'Plan_ID__c','Error_Msg__c'};
        String csvFileString = ''; 
        for(String fieldName : queryFields)
        {
            csvFileString = csvFileString + ',' + fieldName.replace(',','');
            
        } 
        csvFileString = csvFileString.replaceFirst(',','') + '\n';
        String fileRow = '';
        String fieldValue = '';
        for(SObject obj : queryResults)
        {
            fileRow = '';
            System.debug('===>' + obj); 

            for(String fieldName : queryFields)
            {
                fieldValue = '' + obj.get(fieldName);
                fieldValue = fieldValue.replace(',','');
                fileRow = fileRow + ',' + fieldValue;
            }
            fileRow = fileRow.replaceFirst(',','');
            csvFileString = csvFileString + fileRow + '\n';
        }
        Blob csvBlob = Blob.valueOf(csvFileString);
        if(queryResults.size()>0){
            Attachment AttachmentObj = new Attachment(Body = csvBlob,
                                          Name = 'Error_Joblog' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv',
                                          parentId = idset);
            insert AttachmentObj; 
            system.debug('AttachmentObj==>'+AttachmentObj);
        } 
        if(attachm!=NULL){
             Attachment att=new Attachment();
             att.Body=attachm;
             att.Name='Attached_Joblog' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.csv';
             att.parentId=idset;
             insert att; 
             system.debug('attac==>'+att);
         } 
        if(!ids.isEmpty()) 
        {        
            Delete ids ;
            system.debug('delete'+ids);
        }
    }
}