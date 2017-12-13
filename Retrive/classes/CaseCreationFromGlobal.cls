public with sharing class CaseCreationFromGlobal{
    
    Global_Issue_Tracker__c g;
    Id parentId;
    
    public CaseCreationFromGlobal(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        g=[Select g.ID, g.OwnerID, g.Member_ID__c, g.Subject__c, g.Issue_Description_Status__c, g.Summary_of_Issue__c, g.Requester_s_Email__c, g.Requester_s_Name__c From Global_Issue_Tracker__c g where id=:parentId];
    }  
    public PageReference CreateCase() {
        
        Case c= new Case();
		c.OwnerID = g.OwnerId;
		RecordType RT;
        RT=[Select r.Id, r.DeveloperName From RecordType r WHERE r.DeveloperName='Plan_Sponsor_Questions_or_Issues' LIMIT 1];
        c.RecordTypeID = RT.Id;
		c.Requester_Email__c = g.Requester_s_Email__c;
		c.Requester_Name__c = g.Requester_s_Name__c;
		c.Aetna_Case_Type__c = 'Account Manager Case';
		c.Summary_of_SR_Investigation__c = g.Summary_of_Issue__c;
		c.Description = g.Issue_Description_Status__c;
		c.Subject = g.Subject__c;
		c.Member_ID__c = g.Member_ID__c;
		c.Global__c=g.ID;
        insert c;
        
        PageReference pageref = new PageReference('/' + String.valueOf(c.Id));
        pageref.setRedirect(true);
        return pageref;
    }
            
}