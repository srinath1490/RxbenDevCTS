/*Purpose: Apex Batch Class for Sending the Cloned CRD to AI
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Abhay           3/13/2013       Apex Batch Class for Sending the Cloned CRD to AI
   1.1      rakesh          4/5/2013        Performed exception handling
======================================================================== */
global class BAC_MassSend2AI implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;

    global BAC_MassSend2AI(String PassedQuery) {
        query = PassedQuery;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        //do http Callouts here      
        List < Batch_Logger__c > errBatchLoggerList = new List < Batch_Logger__c > ();

        for (SOBJECT s: Scope) {
            Id CrdRecordId;
            Id currentuser = UserInfo.getUserId();
            Batch_Logger__c CurrentLoggerInstance = (Batch_Logger__c) s;

            try {
                if (CurrentLoggerInstance.For_NPP__c == True && CurrentLoggerInstance.Cloned_CRD_ID__c != Null) {
                    CrdRecordId = CurrentLoggerInstance.Cloned_CRD_ID__c;
                } else if (CurrentLoggerInstance.For_In_State__c == True && CurrentLoggerInstance.Dummy_crd__c != Null) {
                    CrdRecordId = CurrentLoggerInstance.Dummy_crd__c;
                } else if (CurrentLoggerInstance.For_In_State__c == True && CurrentLoggerInstance.Cloned_CRD_ID__c != Null) {
                    CrdRecordId = CurrentLoggerInstance.Cloned_CRD_ID__c;
                } else if (CurrentLoggerInstance.For_Out_State__c == True && CurrentLoggerInstance.Cloned_CRD_ID__c != Null) {
                    CrdRecordId = CurrentLoggerInstance.Cloned_CRD_ID__c;
                }

                CRD__c crdRecord;
                if (CrdRecordId != null) {
                    crdRecord = [select id,IsDummyCRD__c, name, Are_you_creating_a_Package_Plan__c, Partial_Control_Group__c, Full_Control_Group__c, Insured_Type__c, Integrating_User__c, Which_system_will_the_plan_be_installed__c, Account__c, Y_Schd__c, Rating_ERB__c, High_Value_Client__c, Pricing_Schedule__c, Subsegment__c, Platform_Information__c, TP_ID__c, Rx_PP_ID__c, Integration_Status__c, Risk_Indicator__c, Integration_1__c, RxPlanData__c, Sub_segment__c
                    from CRD__c where id = : CrdRecordId limit 1];
                }

                //generate AiRequest CurrentCrdInstance
                GC_Utils_Method AIrequest = new GC_Utils_Method();
                AIrequest.sendToAi1(crdRecord, currentuser, CurrentLoggerInstance);
            } catch (Exception ex) {
                errBatchLoggerList.add(GC_Utils_Method.logBatchLoggerError(CurrentLoggerInstance, ex));
            }
        }

        if (errBatchLoggerList != null && errBatchLoggerList.size() > 0) upsert errBatchLoggerList;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('SCH_Callout' + sysTime.getTime(), chron_exp, new SCH_Callout());
         //Database.executeBatch(new BAC_Callout(), 1);
    }
}