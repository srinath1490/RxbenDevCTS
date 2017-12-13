public class GlobalIssueTriggers {
	
	@TestVisible private boolean isExecuting = false;
	
	public GlobalIssueTriggers(boolean isExecuting, integer size) {
        isExecuting = isExecuting;
        
	}
	
	// *** AFTER INSERT *** Creating Remediation Records for Global Issues, 1 parameter
    public void CreateRemediationRecord (List<Global_Issue_Tracker__c> issues) {
        
        List<Global_Issue_Tracker__c> RemIssues = new List<Global_Issue_Tracker__c>(); 
        List<Remediation__c> RemInsertList=new List<Remediation__c>();

        for (Global_Issue_Tracker__c g : issues) {
                
            if (g.Remediation_Needed__c != 'None' && g.Remediation_Case__c == null) {
                    
                System.debug(logginglevel.FINEST,'adding issues for remediation: ' + g);
                RemIssues.add(g);
             }
        }
        
        if (RemIssues != null && RemIssues.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding Remediation Records: ' + RemIssues);
            
            for (Global_Issue_Tracker__c g : RemIssues) {
                
                Remediation__c rc = new Remediation__c();
                rc.OwnerId = g.OwnerId;
                rc.Subject__c = g.Subject__c;
                rc.Global__c = g.Id;
                rc.Issue_Description_and_Resolution__c = g.Issue_Description_Status__c;
                rc.Status__c = 'Preliminary Impact Report';
                rc.Sub_Status__c = 'Requested';
                RemInsertList.add(rc);
            }

            insert  RemInsertList;
  
        }
    } // End
    
    // *** AFTER UPDATE *** Creating Remediation Records for Issue Cases, 2 parameters
    public void CreateRemediationRecord(Map<Id,Global_Issue_Tracker__c> oldIssuesMap, List<Global_Issue_Tracker__c> newIssues) {
        
        List<Global_Issue_Tracker__c> RemIssues = new List<Global_Issue_Tracker__c>(); 
        List<Remediation__c> RemInsertList = new List<Remediation__c>();

        for (Global_Issue_Tracker__c g : newIssues) {
                
            if (g.Remediation_Needed__c != 'None' && g.Remediation_Case__c == null && oldIssuesMap.get(g.Id).Remediation_Needed__c == 'None') {
                    
                System.debug(logginglevel.FINEST,'adding Issues for remediation: ' + g);
                RemIssues.add(g);
             }
        }
        
        if (RemIssues != null && RemIssues.size() > 0) {
            
            System.debug(logginglevel.FINEST,'Adding Remediation Records: ' + RemIssues);
            
            for (Global_Issue_Tracker__c g : RemIssues) {
                
                if (g.Remediation_Needed__c != 'None' && g.Remediation_Case__c == null) {
                    Remediation__c rc = new Remediation__c();
                rc.OwnerId = g.OwnerId;
                rc.Subject__c = g.Subject__c;
                rc.Global__c = g.Id;
                rc.Issue_Description_and_Resolution__c = g.Issue_Description_Status__c;
                rc.Status__c = 'Preliminary Impact Report';
                rc.Sub_Status__c = 'Requested';
                RemInsertList.add(rc);
                }
            }
            insert  RemInsertList;

        }
    } // End
    
    public boolean IsTriggerContext {
        get { return isExecuting; }
    }
    
    public boolean IsVisualforcePageContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsWebServiceContext {
        get { return !IsTriggerContext; }
    }
    
    public boolean IsExecuteAnonymousContext {
        get { return !IsTriggerContext; }
    }
}