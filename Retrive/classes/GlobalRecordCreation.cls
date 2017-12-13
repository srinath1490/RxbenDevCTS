public with sharing class GlobalRecordCreation{
    
    case caseRecord;
    Id parentId;
    
    public GlobalRecordCreation(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        caseRecord=[Select c.ID, c.Member_ID__c, c.Subject, c.Description, c.Summary_of_SR_Investigation__c, c.Requester_Email__c, c.Requester_Name__c From Case c where id=:parentId];
    }  
    public PageReference CreateGlobal() {
        
        Global_Issue_Tracker__c g= new Global_Issue_Tracker__c();
        QueueSobject Globalqueue;
        GlobalQueue=[Select QueueId from QueueSobject WHERE Queue.Name='Global Issue Intake' LIMIT 1];
		g.OwnerID = GlobalQueue.QueueId;
		g.Requester_s_Email__c = caseRecord.Requester_Email__c;
		g.Requester_s_Name__c = caseRecord.Requester_Name__c;
		g.Summary_of_Issue__c = caseRecord.Summary_of_SR_Investigation__c;
		g.Issue_Description_Status__c = caseRecord.Description;
		g.Subject__c = caseRecord.Subject;
		g.Member_ID__c = caseRecord.Member_ID__c;
        insert g;
        
        caseRecord.Global__c=g.ID;
        update caseRecord;
        
        PageReference pageref = new PageReference('/' + parentId);
        pageref.setRedirect(true);
        return pageref;
    }
            
}