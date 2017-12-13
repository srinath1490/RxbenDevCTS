/*Purpose: Apex Batch Class for Cloning the CRD records for NPP   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Amit            3/14/2013           Apex Batch Class for Cloning the CRD records for NPP
   1.1      rakesh          4/5/2013            Replaced update of 'lstLog2Update' with Database.update()
======================================================================== */
global class BAC_CloneNPPCRD implements Database.Batchable < sObject >{
    global String query;
    private final boolean forNPP;
    global BAC_CloneNPPCRD(String Passedquery,boolean forNPP) {
        query = Passedquery;
        this.forNPP=forNPP;
        System.debug('######forNPP1' +forNPP);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        list < Batch_Logger__c > lstLog2Update = new list < Batch_Logger__c > ();
        for (SOBJECT s: Scope) {
            Batch_Logger__c loggerRecord = (Batch_Logger__c) s;
            try {
                String selectedCrdId = loggerRecord.Crd__c;
                Crd__c newcrd = new Crd__c();
                //Values for Testing if Integration log is created
                newcrd.Platform_Information__c = 'H';
                newcrd.TP_ID__c = null;
                newcrd.Rx_PP_ID__c = null;
                newcrd.Y_Schd__c = 'Y4';
                insert newcrd;
                VFP_CloneCRD clonecrd = new VFP_CloneCRD();
                //If successful update Batch Logger
                loggerRecord.Cloned_CRD_ID__c = newcrd.Id;
                loggerRecord.Processed__c = True;
                loggerRecord.TimeStamp__c = datetime.now();
                loggerRecord.Description__c = 'Successfully Cloned CRD';
                loggerRecord.Ready_For_AI__c = True;                
                clonecrd.cloneCrdWithItems(selectedCrdId, newcrd, True);


            } catch (exception e) {
                //If Failed update Batch Logger
                loggerRecord.Has_Error__c = true;
                loggerRecord.TimeStamp__c = datetime.now();
                loggerRecord.Processed__c = True;
                loggerRecord.Description__c = 'Message: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString();
            }
            lstLog2Update.add(loggerRecord);
        }
        
        try {
            // update lstLog2Update;
            /* rakesh - 4/4 - updating to Database.update() from simple 'update' */
            List<Database.Saveresult> srList = Database.update(lstLog2Update, false);
            GC_Utils_Method.logSaveresult(lstLog2Update, srList);
        } catch (Exception e) {
            System.debug('%%%% Exception in BAC_CloneNPPCRD : ' + e);
        }
    }


    global void finish(Database.BatchableContext BC) {
        //Database.executeBatch(new BAC_MassSend2AI('select id,name from opportunity'), 1); 
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');
         String BusinessRuleCondition;  
         System.debug('######forNPP' +forNPP);
         if(forNPP){
            BusinessRuleCondition='For_NPP__c=true';
         }else{
            BusinessRuleCondition='For_In_State__c=true';
         }
         String query = 'select CRD__c,For_In_State__c,For_NPP__c,For_Out_State__c,EffectiveDate_Greater_Than_CRD__c,Cloned_CRD_ID__c from Batch_Logger__c where Processed__c = true and '+BusinessRuleCondition;
         Database.executeBatch(new BAC_ApplyBusinessRule(query,BusinessRuleCondition), 1);
    }
}