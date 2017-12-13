/*Purpose: Apex Batch Class for PCG/FCG Automation
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      10/20/2014           Revised Apex Batch Class for PCG/FCG Automation (Notification Standard)
======================================================================== */
global class BAC_PcgFcgAutomationHandlerStandard implements Database.Batchable < sObject > {
    private String query;
    
    public void setSquery(String tempQuery){
          query = tempQuery;
    }
    /**
* Method :- BAC_PcgFcgAutomationHandlerStandard()
* Description :- Contructor method to start the Batch Process
**/
    global BAC_PcgFcgAutomationHandlerStandard() {
        query = 'select id,traditionalControlNumberPlanSummaryDetai__c,suffix__c,AccountName__c,erb__C,Control__c,PSUID__c,Subsegment__c,effectiveDate__c,CarrierId__c,FundingType__c,OrgId__c,Plan__c,OrgType__c,OrgArrangementId__c,TermDate__c,createddate,CFO__c,MarketSegment__c ,Trad_AccountId__c from NotificationStandard__c where Account_CAG_Processed__c=false AND PSUID__c <> null AND Control__c <> null  AND suffix__c<> null AND Trad_AccountId__c <>null Order by  CreatedDate desc';
    }
    
    /**
* Method :- start(Database.BatchableContext BC)
* Description :- Start Method for the Batch process
**/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query); 
    }
    
    /**
* Method :- execute(Database.BatchableContext BC, List < sObject > scope)
* Description :- Execute method where the records are processed and code logic is performed.
*                It is calling executeAutomation Method from RevisedPcgFcgAutomation Class where further processing is done.
**/
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
       CB_PcgFcgAutomationUtil classcagInstance = new CB_PcgFcgAutomationUtil();
        classcagInstance.executeAutomation(scope);
    }
    
    /**
* Method :- finish(Database.BatchableContext BC)
* Description :- Finish Method for the batch Process
**/
    global void finish(Database.BatchableContext BC) {
       
    }
}