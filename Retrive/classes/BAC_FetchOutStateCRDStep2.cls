/*Purpose: Apex Batch Class for Fetching the Out State Package Plan Records   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Amit                   4/2/2013            Apex Batch Class for Fetching the Out State Package Plan Records
   
======================================================================== */
global class BAC_FetchOutStateCRDStep2 implements Database.Batchable < sObject > {
    global String query;
    private Savepoint sp;

    global BAC_FetchOutStateCRDStep2() {
        query = 'select id,name,Rxplan_id__c,State_Code__c,Full_CSAP__c,CSAP_REF__c,ConfigID__c,TPID__c from Pers_Data_Storage__c where (State_Code__c=\'17\' or State_Code__c=\'18\' or State_Code__c=\'19\' or State_Code__c=\'57\' or State_Code__c=\'58\' or (ConfigID__c!=\'\' and ConfigId__c!=null and ConfigId__c!=\'0000000000\' )) and (Case__c !=null OR Migration_run_file__c!=null)';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List < Crd__c > crdRecord = new List < CRD__c > ();
        list < Batch_Logger__c > lstloggerrecords = new list < Batch_Logger__c > ();
        map < string, CRD__c > mapRxplanid2CRD = new map < string, CRD__c > ();
        map < string, Pers_Data_Storage__c > mapRxplanid2PERS = new map < string, Pers_Data_Storage__c > ();
        try {
            for (SOBJECT s: Scope) {
                Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
                mapRxplanid2PERS.put(CurrentPersInstance.Rxplan_id__c, CurrentPersInstance);
            }

            if (mapRxplanid2PERS != null && mapRxplanid2PERS.size() > 0) {
                crdRecord = [Select id, RxPlanID__c from crd__c where RxPlanID__c = : mapRxplanid2PERS.keyset()];
            }
            for (crd__c currentcrd: crdRecord) {
                mapRxplanid2CRD.put(currentcrd.RxPlanID__c, currentcrd);
            }

            if (crdRecord != null && crdRecord.size() > 0) {
                for (CRD__c currentCRD: mapRxplanid2CRD.values()) {
                    Batch_Logger__c loggerrecord = new Batch_Logger__c();
                    loggerrecord.CRD__c = currentCRD.id;
                    loggerrecord.Ready_for_AI__c = True;
                    loggerrecord.For_out_state__c = True;
                    loggerrecord.Pers_Data_Storage__c = mapRxplanid2PERS.get(currentCRD.RxPlanID__c).id;
                    lstloggerrecords.add(loggerrecord);
                }   
                List < Database.Saveresult > srList = Database.insert(lstloggerrecords, false);
                GC_Utils_Method.logSaveresult(lstloggerrecords, srList);
            }
             for (SOBJECT s: Scope) {
               Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
                   if(mapRxplanid2CRD.get(CurrentPersInstance.Rxplan_id__c)==null){
                      CurrentPersInstance.NoCRDforOutStatePP__c = True;
                   }
             }
             update scope;
        } catch (exception e) {
            System.debug('%%%% Exception in BAC_FetchOutStateCRDStep2  : ' + e);
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        /*Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);*/
        //Schedule the next job, and give it the system time so name is unique
        String query = 'select Id,CRD__c from Batch_Logger__c where Processed__c=false And For_Out_State__c=True';
        //System.schedule('SCH_CloneNPPCRD' + sysTime.getTime(), chron_exp, new SCH_CloneNPPCRD(query));
         Database.executeBatch(new BAC_CloneOutStateCRD(query), 1);
    }
}