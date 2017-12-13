/*Purpose: Apex Batch Class for Fetching the Out State Package Plan Records   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Amit                   4/2/2013            Apex Batch Class for Fetching the Out State Package Plan Records
   
======================================================================== */
global class BAC_FetchOutStateCRDStep1 implements Database.Batchable < sObject > {
    global String query;
    private Savepoint sp;

    global BAC_FetchOutStateCRDStep1() {
        query = 'select id,name,State_Code__c,Full_CSAP__c,CSAP_REF__c,ConfigID__c,TPID__c from Pers_Data_Storage__c where (State_Code__c=\'17\' or State_Code__c=\'18\' or State_Code__c=\'19\' or State_Code__c=\'57\' or State_Code__c=\'58\' or (ConfigID__c!=\'\' and ConfigId__c!=null and ConfigId__c!=\'0000000000\' )) and Processed__c=false';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        list < Case > caserecords = new list < Case > ();
        list < Migration_run_file__c > lstMigrationRF = new list < Migration_run_file__c > ();
        map < String, Pers_Data_Storage__c > mapFullcsap2Pers = new map < String, Pers_Data_Storage__c > ();

        try {
            sp = Database.setSavepoint();
            for (SOBJECT s: Scope) {
                Pers_Data_Storage__c CurrentPersInstance = (Pers_Data_Storage__c) s;
                mapFullcsap2Pers.put(CurrentPersInstance.Full_CSAP__c, CurrentPersInstance);
                CurrentPersInstance.Processed__c = True;
            }
              
            if (mapFullcsap2Pers != null && mapFullcsap2Pers.size() > 0) {
                caserecords = [Select RxPlan_ID__c, Full_CSAP__c from Case where Full_CSAP__c in : mapFullcsap2Pers.keyset() and (RxPlan_ID__c!=null OR RxPlan_ID__c!='')];
                lstMigrationRF = [Select Rxplanid__c, GroupID__c from Migration_run_file__c where GroupID__c in : mapFullcsap2Pers.keyset() and (Rxplanid__c!=null OR Rxplanid__c!='')];
            }
                        
            if (caserecords != null && caserecords.size() > 0) {
                for (Case caseinstance: caserecords) {
                    mapFullcsap2Pers.get(caseinstance.Full_CSAP__c).RxPlan_ID__c = caseinstance.Rxplan_id__c;
                    mapFullcsap2Pers.get(caseinstance.Full_CSAP__c).Case__c = caseinstance.id;
                }
            }

            if (lstMigrationRF != null && lstMigrationRF.size() > 0) {
                for (Migration_run_file__c mmrfinstance: lstMigrationRF ) {
                    mapFullcsap2Pers.get(mmrfinstance.GroupID__c).RxPlan_ID__c = mmrfinstance.Rxplanid__c;
                    mapFullcsap2Pers.get(mmrfinstance.GroupID__c).Migration_Run_File__c = mmrfinstance.id;
                }
            }
            Update Scope;
           
        } catch (exception e) {
            Database.rollback(sp);
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');               
        Database.executeBatch(new BAC_FetchOutStateCRDStep2());
    }
}