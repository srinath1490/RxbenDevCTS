/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Jenna Vuong		05-13-15			PopulateRxAcctMgr() - Auto-populate Rx Account Manager on Custom Network Notification object
======================================================================== */

public class CustomNetworkNotificationClass {
    
    private boolean isExecuting = false;
    private integer BatchSize = 0;

	public CustomNetworkNotificationClass(boolean isExecuting, integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void PopulateRxAcctMgr(List<Custom_Network_Notification__c> newNotifs) {
        
        Set<Id> acctIds = new Set<Id>();
        List<AccountTeamMember> rxAcctMgrs = new List<AccountTeamMember>();
        Map<Id,Id> atmMap = new Map<Id,Id>();
        
        // get all account ids
        if (newNotifs != null && newNotifs.size() > 0) {
            
            for (Custom_Network_Notification__c n : newNotifs) {
                
                if (n.Account_Name__c != null)
                    acctIds.add(n.Account_Name__c);
            } 
        }
            
		// look for all Pharmacy Account Managers w same acct id
        rxAcctMgrs = [ Select AccountId, TeamMemberRole, UserId From AccountTeamMember Where TeamMemberRole = 'Pharmacy Account Manager' and AccountId In :acctIds LIMIT 1 ];
        
        // populate atm map
        if (rxAcctMgrs != null && rxAcctMgrs.size() > 0) {
            
            for (AccountTeamMember a : rxAcctMgrs) {
                atmMap.put(a.AccountId,a.UserId);
            }
        }
        
        if (newNotifs != null && newNotifs.size() > 0) {
            
            for (Custom_Network_Notification__c n : newNotifs) {
                
                n.RX_Account_Manager__c = atmMap.get(n.Account_Name__c);
            }     
        }
    }
}