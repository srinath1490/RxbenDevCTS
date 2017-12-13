public with sharing class CRDAuditTrackerTriggers {
	
	public static void ErrorCountComplete (List<CRD_Audit_Tracker__c> cats, Map<String,String> RecordTypes){

    	for (CRD_Audit_Tracker__c c : cats){
    		if(c.RecordTypeId==RecordTypes.get('Complete Audit')&& c.Errors_Complete__c != null && c.Errors_Complete__c.length() > 0) {
					List<String> cerrors = c.Errors_Complete__c.split(';');
					c.Error_Count_Complete__c = cerrors.size();
			}
    	}
    }
    
    public static void ErrorCountPartial (List<CRD_Audit_Tracker__c> cats, Map<String,String> RecordTypes){

    	for (CRD_Audit_Tracker__c c : cats){
    		if(c.RecordTypeId==RecordTypes.get('Partial Audit')&& c.Errors_Partial__c != null && c.Errors_Partial__c.length() > 0) {
					List<String> perrors = c.Errors_Partial__c.split(';');
					c.Error_Count_Partial__c = perrors.size();
			}
    	}
    }
    
    public static void ChangesCount (List<CRD_Audit_Tracker__c> cats){

    	for (CRD_Audit_Tracker__c c : cats){
    		if(c.Changes__c != null && c.Changes__c.length() > 0) {
					List<String> changes = c.Changes__c.split(';');
					c.Changes_Count__c = changes.size();
			} else{
				c.Changes_Count__c = 0;}
    	}
    }
    
}