/*Purpose: Apex Batch Class to make Callout for AI Request created by batch process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            10/9/2013       Apex Batch Class to make Callout for AI Request created by batch process
======================================================================== */
global class BAC_BCTNotificationCallout implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;

    global BAC_BCTNotificationCallout() {
        query = 'SELECT Id,Benefit__c, Benefits_String_Extn__c, CRD_ID__c,Integration_1__c, Plan_ID__c,Pricing_Schedule__c, Request_Type__c, Risk_Indicator__c,StateList_to_Remove__c, Processed__c,State_Mandates_Apply__c, States_List_for_Mandate__c,Created_by_BCT_Mass_Cloning__c FROM AI_Request__c WHERE Created_by_BCT_Mass_Cloning__c = true and Processed__c=False';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        try {
            for (SOBJECT s: Scope) {
                AI_Request__c CurrentAIInstance = (AI_Request__c) s;
                
                //make callout
                GC_Utils_BCT.callout(CurrentAIInstance);
                CurrentAIInstance.Processed__c = true;
            }
            update scope;
        } catch (exception e) {
            //Exception
        }
    }

    global void finish(Database.BatchableContext BC) {
    	//Email to notify that the cloning process has been completed  
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	String[] toAddresses = new String[] {System.label.CL0000048};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Cloning Process has been Completed.');
		mail.setHtmlBody('Hi, <br/><br/>This is to inform you that the cloning process has been completed.<br/>Please see the BCT Notification CRD records for furhter details.<br/><br/>Thanks');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
		
		
    	
    }
}