/*Purpose: Apex Batch Class for Fetching the Non Package Plan Records   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Abhay           3/13/2013           Apex Batch Class for Fetching the Non Package Plan Records 
   1.1      rakesh          4/5/2013            Replaced direct insert of 'lstBatchLogger' with Database.insert()
======================================================================== */
global class BAC_FetchNPPCRD implements Database.Batchable < sObject > {
    global String query;

    global BAC_FetchNPPCRD() {
        query = 'select id,name,CSAP_REF__c,ConfigID__c,TPID__c from Pers_Data_Storage__c where ((ConfigID__c=null and TPID__c=null) or (ConfigID__c=\'0000000000\' and TPID__c=\'00000000000\') or State_Code__c=\'0\') and Processed__c=false';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        set < String > setCSAPRef = new set < String > ();
        set < ID > setUniqueCRD = new set < ID > ();
        list < CSAP_CGLP_Junction__c > lstCRD4CSAP = new list < CSAP_CGLP_Junction__c > ();
        list < Batch_Logger__c > lstBatchLogger = new list < Batch_Logger__c > ();
        map < String, Pers_Data_Storage__c > mapCSAP2PersDatarecord = new map < String, Pers_Data_Storage__c > ();
        map < String, CSAP_CGLP_Junction__c > mapCRD2CSAPRecord = new map < String, CSAP_CGLP_Junction__c > ();
        map < id, Pers_Data_Storage__c > mapPersData2Update = new map < id, Pers_Data_Storage__c > ();
        map < String, CSAP_CGLP_Junction__c > mapCSAPKey2CSAPRecord = new map < String, CSAP_CGLP_Junction__c > ();

        for (SOBJECT s: Scope) {
            Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
            if (CurrentPersInstance.CSAP_REF__c != null) {
                setCSAPRef.add(CurrentPersInstance.CSAP_REF__c);
                mapCSAP2PersDatarecord.put(CurrentPersInstance.CSAP_REF__c, CurrentPersInstance);
            }
        }

        if (setCSAPRef != null && setCSAPRef.size() > 0) {
            //Query implemented as per confirmation from onshore that only 5000 records will be passed at max
            lstCRD4CSAP = [select id, name,RecordType.Name, CRD__c, CSAP_Detail__c from CSAP_CGLP_Junction__c where CSAP_Detail__c in : setCSAPRef and RecordType.Name ='CRD to Partial CG' and CRD__c!=''];
        }
        if (lstCRD4CSAP != null && lstCRD4CSAP.size() > 0) {
            for (CSAP_CGLP_Junction__c csapJunctionRecord: lstCRD4CSAP) {
                mapCRD2CSAPRecord.put(csapJunctionRecord.CRD__c, csapJunctionRecord);
                setUniqueCRD.add(csapJunctionRecord.CRD__c);
                mapCSAPKey2CSAPRecord.put(csapJunctionRecord.CSAP_Detail__c, csapJunctionRecord);
            }
        }
        try {
            for (SOBJECT s: Scope) {
                Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
                    if (mapCSAPKey2CSAPRecord.get(CurrentPersInstance.CSAP_REF__c) != null && mapCSAPKey2CSAPRecord.get(CurrentPersInstance.CSAP_REF__c).CRD__c == null) {                
                        CurrentPersInstance.NoCRDForNPP__c = true;                       
                    } else if(mapCSAPKey2CSAPRecord.get(CurrentPersInstance.CSAP_REF__c) == null){
                        CurrentPersInstance.CSAPNotFound__c = True;
                    }
                    CurrentPersInstance.Processed__c = true;
            }
            update scope;

            for (String crdid: setUniqueCRD) {
                Batch_Logger__c loggerrecord = new Batch_Logger__c();
                loggerrecord.CRD__c = mapCRD2CSAPRecord.get(crdid).CRD__c;
                loggerrecord.CSAP_CGLP__c = mapCRD2CSAPRecord.get(crdid).CSAP_Detail__c;
                loggerrecord.For_NPP__c = True;
                loggerrecord.Pers_Data_Storage__c = mapCSAP2PersDatarecord.get(mapCRD2CSAPRecord.get(crdid).CSAP_Detail__c).id;
                lstBatchLogger.add(loggerrecord);
            }

            /* rakesh - 4/5 - replacing direct 'insert' with Database.insert() */
            List < Database.Saveresult > srList = Database.insert(lstBatchLogger, false);
            GC_Utils_Method.logSaveresult(lstBatchLogger, srList);

        } catch (exception e) {
            System.debug('%%%% Exception in BAC_FetchNPPCRD : ' + e);
        }

        //Save list of CRD in crd ref object or save list of Csap in logger to get report
        lstBatchLogger.clear();
        setUniqueCRD.clear();
        mapCRD2CSAPRecord.clear();
        mapCSAP2PersDatarecord.clear();
        mapCSAPKey2CSAPRecord.clear();
        mapPersData2Update.clear();
        setCSAPRef.clear();
        lstCRD4CSAP.clear();
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.WARN, 'Batch Process 1 Finished');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        /*Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year() + '-2023';
        system.debug(chron_exp);*/
        String query = 'select Id,CRD__c from Batch_Logger__c where Pers_Data_Storage__c!=null And Processed__c=false And For_NPP__c=True And EffectiveDate_Greater_Than_CRD__c=\'true\'';
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('SCH_CloneNPPCRD' + sysTime.getTime(), chron_exp, new SCH_CloneNPPCRD(query));
        Database.executeBatch(new BAC_CloneNPPCRD(query,true), 1); 
    }
}