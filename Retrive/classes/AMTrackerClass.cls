public with sharing class AMTrackerClass {
	
	public static void AssignTracker(List<Account_Manager_Trackers__c> trackers, Map<String,String> AcctTeams) {
		
		QueueSobject AMqueue;
        AMQueue=[Select QueueId from QueueSobject WHERE Queue.Name='AM Tracker Supervisor Queue' LIMIT 1];
        
		for(Account_Manager_Trackers__c a: trackers){
			if((a.OwnerId==AMQueue.QueueID)&&(AcctTeams.containsKey(a.Plan_Sponsor_Name__c))) {
				a.OwnerId=AcctTeams.get(a.Plan_Sponsor_Name__c);
			}
		}

	}
	
}