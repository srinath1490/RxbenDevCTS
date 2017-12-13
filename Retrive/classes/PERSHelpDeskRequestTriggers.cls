public with sharing class PERSHelpDeskRequestTriggers {
	
	public static void AutoRelateAccount (List<Help_Desk_Requests__c> helpreqs, Map<String, String> AcctIDs){
        //Called in TRG_PERS_Help_Desk_Request_Before_Insert Trigger
        for (Help_Desk_Requests__c h : helpreqs){
            if((h.PS_Unique_ID__c != null)&&(h.Help_Desk_Plan_Sponsor_Name__c == null)){
                h.Help_Desk_Plan_Sponsor_Name__c = AcctIds.get(h.PS_Unique_ID__c);
            }
        }
    }

}