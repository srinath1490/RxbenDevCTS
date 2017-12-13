/*Purpose: Apex Batch Class to archive PFRs  
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           17 Feb 2015       Apex Batch Class to archive PFRs for Req 5555
   1.2 -    Richa           4  Mar 2015       Added field WS_BNFT_RMRK__c in query for Req 5593
   1.3 -    Vikram          13 Jan 2016       ST#889 - Increase the Archive batch limit from 1000 to 5000
=================================================================================================*/ 
global class BAC_CB_archivePFRs implements Database.Batchable <sObject>{
    public String query;
    public Integer lmt = 0;

    /**
    * Method :- BAC_CB_archivePFRs 
    * Description :- This method acts as an constuctor to form the query where all unprocessed CBONs need to be fetched
    **/    
    global BAC_CB_archivePFRs(){
        lmt = Integer.valueof(System.Label.ArchivePFR_Batch_Limit);
        query = 'Select id, Name, Status__c, Ready_to_Archive__c, crd__r.id, crd__r.Archived__c, crd__r.BPLV_String__c, Ignored__c, ExistingRxplan__c,Description__c,(Select Carrier_ID__c,crd__r.Rating_ERB__c,ControlPlanEffective__c,WS_CNTRCT_ST__c,WS_RISK_IND__c,WS_CUST_SUBSEG__c,WS_PSUID__c,WS_SITUS_ST__c,WS_COB_CD__c,WS_PROV_NUM__c,WS_PROV_LNG_NM__c,WS_LV_NO__c,WS_LV_TXT__c,Processed__c,Manually_Applied__c,WS_BNFT_RMRK__c from Pers_Full_Report__r ORDER BY WS_PROV_NUM__c ASC),(Select id from Attachments where Description = \'ArchivedPFRs\' ORDER BY CreatedDate DESC LIMIT 1) from CRDBuildOrder__c where Ready_to_Archive__c = false and (Status__c = \'Finished\' OR Ignored__c = true OR Status__c = \'ExistingRxplan\') and crd__c != null LIMIT: lmt';
    }
    /**
    * Method :- start 
    * Description :- This method passes the query and fetches the CBONs accordingly
    **/
    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    /**
    * Method :- execute 
    * Description :- This method calls the CB_archivePFR class to process the selected CBONs
    **/
    global void execute (Database.BatchableContext BC, list<CRDBuildOrder__c> scope){
        CB_archivePFR.onAfterUpdate(scope);    
    // code for CRDB Monitoring starts - Sandeep Saklani
       // CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
    
     /**
    * Method :- finish 
    * Description :- We don't need to perform any finish task
    **/
    global void finish (Database.BatchableContext BC){
        if(Boolean.valueOf(System.Label.ArchivePFRcontrolSwitch)){
            database.executeBatch(new BAC_CB_archivePFRs(),1);
        }
    // code for CRDB Monitoring starts - Sandeep Saklani
        //CB_CRDBMonitor.CalculateStatus(BC.getJobId());
    // code for CRDB Monitoring ends - Sandeep Saklani
    }
}