/*Purpose: Apex Batch Class for Sending the Cloned CRD to AI
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
1.1 -    Abhishek       Abhishek        27 nov'14           #Request 05322 Create option for orchestration of selected module in system
======================================================================== */
global class BAC_CB_MassSend2AI implements Database.Batchable < sObject > , Database.AllowsCallouts,Database.Stateful{
    global String crdId;
    public set<id> tempCbon;
    global set<Id> setAiId;     
    public string query {get;private set;}
    public set<Id > cbonId;
    public void setQuery(string s){
        if(s!=null && s!=''){
            query = s;
        }
        
    }
   public void setCbonId(set<id> id){
        if(id!=null && id.size()>0){
            cbonId = id;
        }
        
    }  
    public static void execute(){
      //  system.debug('inside');
      //  string queryPassed = '';
      //  string cbonids = ''; 
        
        
        //String queryPassed = 'Select Y_Schd__c, Sub_segment__c,Aicallout__c, Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c, Query_String_Field__c, Query_String_CRD_2__c, Query_String_Drug_Coverage__c, Override_Standard_Max_Pay__c,LastSent__c, Partial_Control_Group__c, id, SAC_Override_Option__c, PSP_Override_Option__c,Rx_Override_Option__c, Mail_Y_Schedule__c, PSP_Letter_Templates__c, Subsegment__c, High_Value_Client__c, Partner_Server__c, Rating_ERB__c, API_Session_Id__c,  Rx_PP_ID__c,Plan_Type_Specialty__c, Which_system_will_the_plan_be_installed__c, Plan_Type_Retail__c, Plan_Type_Mail__c, TP_ID__c, Platform_Information__c, Does_the_client_want_to_do_COB__c,Out_of_Network_Cost_Sharing__c, Do_you_want_to_do_Save_A_Copay__c, Enrolled_in_PA_for_other_condition__c, Do_you_want_to_do_Step_Therapy__c, Implementations_Date__c, Client_Effective_Date__c, Effective_Start_Date__c, Account__c, Are_you_creating_a_Package_Plan__c, Integrate_with_Medical__c, Status__c, Name, Plan_Type_Paper__c, Name_of_Approver_on_SSD__c, Date_of_Approval_on_SSD__c,Customization_Approved__c, Insured_Type__c, Risk_Indicator__c, Full_Control_Group__c, Full_Control_Group__r.CSAP_Plan_ID__c, Full_Control_Group__r.CSAP_Control_ID__c,Full_Control_Group__r.CSAP_Suffix_ID__c, Full_Control_Group__r.CSAP_Account_ID__c,Plan_Platform__c,Standard_or_Custom_Plan__c,OON_Cost_Share_Not_Greater_50_Drug_Cost__c, Predefined__c From CRD__c Where valid__c=true and complete__c = true and Aicallout__c = false';
       /*if(cbonId== null || cbonId.size() == 0){
           queryPassed = 'select id, CRD__c  ' 
                            + ' from CRDBuildOrder__c '
                            + ' where valid__c = true and Build__c = True and Complete__c = true AND Aicallout__c = false AND createdDate = today AND CRD__c <> null AND FalloutCase__c = null ' ;
       }
       else{
                for(ID tempcbonid: cbonId){
                   cbonids = cbonids  + '\'' +tempcbonid +'\',';
                }
                cbonids = cbonids.Substring(0,cbonids.length()-1);
                queryPassed= 'select id, CRD__c from CRDBuildOrder__c where id IN (' +cbonids +') and  valid__c = true and Build__c = True and Complete__c = true AND Aicallout__c = false AND CRD__c <> null ';
        }
        system.debug('queryPassed'+queryPassed);*/
        
        //Database.executeBatch(new BAC_CB_MassSend2AI(query),1);
    }
    global BAC_CB_MassSend2AI() {
        query = '';
        setAiId = new Set<Id>();
        system.debug('queryPassed1'+query);
    }    
    /*
* Method :- start
* Description :- This method indicates the beignning of a batch
*/  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        setAiId = new Set<Id>();
        system.debug('queryPassed1'+query);
        return Database.getQueryLocator(query);
    }
    /* 
* Method :- execute
* Description :- This method  gets current looged in user info  and generate AiRequest 
*/  
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List<CRD__c> crdsToProcess = new List<CRD__c>();
        Set<Id> crdIds = new Set<Id>();
        for(CRDBuildOrder__c builder :(List<CRDBuildOrder__c>)scope){
            crdIds.add(builder.crd__c);
        }
        crdsToProcess = [Select 
                             Y_Schd__c, Sub_segment__c,Aicallout__c, Override_Retail_Y_Schedule__c, Retail_Y_Schedule_Override__c
                            , Query_String_Field__c, Query_String_CRD_2__c, Query_String_Drug_Coverage__c, Override_Standard_Max_Pay__c
                            ,LastSent__c, Partial_Control_Group__c, id, SAC_Override_Option__c, PSP_Override_Option__c,Rx_Override_Option__c
                            , Mail_Y_Schedule__c, PSP_Letter_Templates__c, Subsegment__c, High_Value_Client__c, Partner_Server__c, Rating_ERB__c
                            , API_Session_Id__c,  Rx_PP_ID__c,Plan_Type_Specialty__c, Which_system_will_the_plan_be_installed__c, Plan_Type_Retail__c
                            , Plan_Type_Mail__c, TP_ID__c, Platform_Information__c, Does_the_client_want_to_do_COB__c,Out_of_Network_Cost_Sharing__c, Do_you_want_to_do_Save_A_Copay__c
                            , Enrolled_in_PA_for_other_condition__c, Do_you_want_to_do_Step_Therapy__c, Client_Effective_Date__c
                            , Effective_Start_Date__c, Account__c, Are_you_creating_a_Package_Plan__c, Integrate_with_Medical__c, Status__c, Name, Plan_Type_Paper__c
                            , Name_of_Approver_on_SSD__c, Date_of_Approval_on_SSD__c,Customization_Approved__c, Insured_Type__c, Risk_Indicator__c
                            , Full_Control_Group__c, Full_Control_Group__r.CSAP_Plan_ID__c, Full_Control_Group__r.CSAP_Control_ID__c
                            ,Full_Control_Group__r.CSAP_Suffix_ID__c, Full_Control_Group__r.CSAP_Account_ID__c,Plan_Platform__c,Standard_or_Custom_Plan__c
                            ,OON_Cost_Share_Not_Greater_50_Drug_Cost__c, Predefined__c,CRD_Automated__c,Control__c,Plan__c 
                        From 
                            CRD__c 
                        Where 
                            id in:crdIds];
        CB_MassSend2AI objSendToAi = new CB_MassSend2AI();
        setAiId.addAll(objSendToAi.massSend2AI(crdsToProcess));

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }  
    
    /* 
* Method :- finish
* Description :- This method indicates all batches are processed and also schedulde the next job
*/ 
    global void finish(Database.BatchableContext BC) {

    // code for CRDB Monitoring starts - Sandeep Saklani
        CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    
        System.debug('########Step1' +setAiId);
        tempCbon = cbonId;
        if(setAiId.size() > 0){
            Database.executeBatch(new BAC_CB_MassSend2AIRequest(setAiId,tempCbon),1);
        }
       
    }
}