public with sharing class PERSAuditRequestTriggers {
	
	public static void AutoRelateAccount (List<PERS_Audit__c> persaudits, Map<String, String> AcctIDs){
        //Called in TRG_PERS_Audits_Before_Insert Trigger
        for (PERS_Audit__c p : persaudits){
            if((p.PERSAUDIT_Plan_Sponsor_Unique_ID__c != null)&&(p.Plan_Sponsor_Name_2__c == null)){
                p.Plan_Sponsor_Name_2__c = AcctIds.get(p.PERSAUDIT_Plan_Sponsor_Unique_ID__c);
            }
        }
    }
    
    public static void NewBusinessImplementations (List<PERS_Audit__c> persaudits, Map<String,String> AcctTeams){
    	
    	QueueSobject BCRQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Benefit Compare Review' LIMIT 1];
    	
    	for(PERS_Audit__c p: persaudits){
            if(((p.Plan_Sponsor_Name_2__r.Subsegment__c=='NA')||(p.Plan_Sponsor_Name_2__r.Subsegment__c=='NAG'))&&(p.Plan_Sponsor_Name_2__r.NB_Implementation__c==true)&& (AcctTeams.containsKey(p.Plan_Sponsor_Name_2__c)))
            {p.OwnerID = AcctTeams.get(p.Plan_Sponsor_Name_2__c);}
            else{
            	p.OwnerID = BCRQueue.QueueId;
            }   
        }
    }

}