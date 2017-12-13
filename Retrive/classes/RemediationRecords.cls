public with sharing class RemediationRecords {
	
	//auto-sharing the remediation records with CVS
	public static void RemRecordsSharedwithCVS (List<Remediation__c> remeds){
    	//called in TRG_Remediation_Records_After_Insert Trigger
    	
    	List<PartnerNetworkConnection> connmap = new List<PartnerNetworkConnection>([Select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = 'Accepted' LIMIT 1]);
    	List<PartnerNetworkRecordConnection> connectioninsertlist = new List<PartnerNetworkRecordConnection>();
    	
    	for (Remediation__c r : remeds) {
    		if(r.Remediation_Type__c == 'Automated R&R') {
    		for(PartnerNetworkConnection network: connmap){
    		PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
    		
    		newrecord.ConnectionId = network.Id;
    		newrecord.LocalRecordId = remeds[0].Id;
    		newrecord.SendClosedTasks = true;
    		newrecord.SendOpenTasks = true;
    		newrecord.SendEmails = true;
    		newrecord.RelatedRecords = 'Case, Attachment';
    		connectioninsertlist.add(newrecord);
    		
    	}
    	}
    	}
    		insert connectioninsertlist;
    }
    
    //auto-populating issue case with remediation record ID
    public static void AutoRelateIssueCase (List<Remediation__c> remeds){
    	//called in TRG_Remediation_Records_After_Insert Trigger
		//Chetan -07/11, Adding filter for Issue_Case__c != null to ensure that it will not throw  null pointer exception error at line 34
        List<Remediation__c> remrecs=[select Id,Issue_Case__c, Issue_Case__r.Remediation_Case__c from Remediation__c where Id IN :remeds AND Issue_Case__c != null];
        
        for(Remediation__c r: remrecs) {
        	r.Issue_Case__r.Remediation_Case__c=r.Id;
        	update r.Issue_Case__r;
        }
    }
    
    //auto-populating global case with remediation record ID
    public static void AutoRelateGlobal (List<Remediation__c> remeds){
    	//called in TRG_Remediation_Records_After_Insert Trigger
    	
        List<Remediation__c> remrecs=[select Id,Global__c, Global__r.Remediation_Case__c from Remediation__c where Id IN :remeds AND Global__c != null];
        
        for(Remediation__c r: remrecs) {
        	r.Global__r.Remediation_Case__c=r.Id;
        	update r.Global__r;
        }
    }
    
    /*public static void RemediationRecordsToAMs (List<Remediation__c> remrecs, Map<String,String> AcctTeams){
        //called in TRG_Remediation_Records_After_Update Trigger
        
        for(Remediation__c r : remrecs){
            if((AcctTeams.containsKey(r.Account_Name__c))&&(r.Status__c=='Awaiting Mailing'))
                {r.OwnerID = AcctTeams.get(r.Account_Name__c);}
                else {
                    if((r.Status__c=='Awaiting Mailing'))
                    {r.ownerID='00550000001ncs3AAA';}
                }   
        }
    }*/

}