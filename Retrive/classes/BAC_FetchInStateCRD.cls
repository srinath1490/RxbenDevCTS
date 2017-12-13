/*Purpose: Apex Batch Class for Fetching the In State and Out State Package Plan Records   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR              DATE                DETAIL                                 
   1.0 -    Amit                3/20/2013           Apex Batch Class for Fetching the In State and Out StatePackage Plan Records
   1.1      Abhay arora         3/25/2013           Updated the code for duplicate tpid and optimized for query
   1.2      rakesh              4/4/2013            removed redundant lists and maps
                                                    updated insert of Batch_Logger to do Database.insert()
======================================================================== */
global class BAC_FetchInStateCRD implements Database.Batchable < sObject > {
    global String query;
    private Savepoint sp;
    global BAC_FetchInStateCRD() {
      query = 'select id,name,State_Code__c,CSAP_REF__c,ConfigID__c,TPID__c from Pers_Data_Storage__c where (State_Code__c=\'14\' or State_Code__c=\'15\' or State_Code__c=\'16\' or State_Code__c=\'55\' or State_Code__c=\'56\' or State_Code__c=\'59\') and Processed__c=false';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        list < CRD__c > lstCRDrecords = new list < CRD__C > ();
        list < Batch_Logger__c > lstloggerrecords = new list < Batch_Logger__c > ();       
        map < String, Pers_Data_Storage__c > mapTPID2PERSInState = new map < String, Pers_Data_Storage__c > ();

        for (SOBJECT s: Scope) {
            Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
            mapTPID2PERSInState.put(CurrentPersInstance.TPID__c, CurrentPersInstance);
        }
        
        //In State Block
        try {
            if (mapTPID2PERSInState != null && mapTPID2PERSInState.size() > 0) {
                sp = Database.setSavepoint();

                for (Pers_Data_Storage__c persInstance: mapTPID2PERSInState.values()) {
                    //Create Dummy CRD Record
                    CRD__C dummyCRD = new CRD__c();
                    //Assign TPID to Dummy CRD
                    dummyCRD.TP_ID__c = persInstance.TPID__c;
                    dummyCRD.IsDummyCRD__c = true;
                    dummyCRD.Platform_Information__c = 'H';
                    dummyCRD.Y_Schd__c = 'Y4';
                    dummyCRD.Risk_Indicator__c = 'R';
                    //###############Data for Testing######
                    dummyCRD.Rx_PP_ID__c = null;
                    //#####################################
                    lstCRDrecords.add(dummyCRD);
                }
                
                List<Database.Saveresult> srList = Database.insert(lstCRDrecords);
                GC_Utils_Method.logSaveresult(lstCRDrecords, mapTPID2PERSInState, srList);

                for (CRD__c currentCRD: lstCRDrecords) {
                    Batch_Logger__c loggerrecord = new Batch_Logger__c();
                    loggerrecord.Dummy_CRD__c = currentCRD.id;
                    loggerrecord.Pers_Data_Storage__c = mapTPID2PERSInState.get(currentCRD.TP_ID__c).id;
                    loggerrecord.Ready_for_AI__c = True;
                    lstloggerrecords.add(loggerrecord);
                }

                //rakesh - 4/4 - updating to Database.insert() from simple 'insert'
                List<Database.Saveresult> saveresultList = Database.insert(lstloggerrecords, false);
                GC_Utils_Method.logSaveresult(lstloggerrecords, saveresultList);

                if (scope != null && scope.size() > 0) {
                    for (SObject s : scope) {
                        //Update Processed PERS records
                        Pers_Data_Storage__c persInstance = (Pers_Data_Storage__c) s;
                        persInstance.Processed__c = True;
                    }
                    update scope;
                }
            }
        } catch (exception e) {
            System.debug('%%%% Exception in BAC_FetchInStateCRD : ' + e);
            Database.rollback(sp);
        }
    }

    global void finish(Database.BatchableContext BC) {
        //Schedule the next job, and give it the system time so name is unique
        String query = 'select id,PERS_Effective_Date_of_New_Benefits__c,Successfully_Sent_To_AI__c,Has_AI_Error__c,Crd__c, For_NPP__c,For_Out_State__c,TPID_From_PERS__c,For_In_State__c,Cloned_CRD_ID__c,Dummy_crd__c, name from Batch_Logger__c where Has_Error__c= false and Ready_For_AI__c=True and For_In_state__c=true';
        Database.executeBatch(new BAC_MassSend2AI(query), 1);
    }
}