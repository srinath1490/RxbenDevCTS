@isTest(seeAllData=true)
private class TEST_CB_CRDBuildOrderTriggerHandler{   
    
    Static testMethod void cboTest(){
        crdbuildorder__c  obj = new crdbuildorder__c ();
        case c = new case();
        insert c;
        
        obj.PDF__c  = false;        
        obj.XML__c  = true;
        obj.CVS__c  = false;
        obj.Case__c=c.id;      
        insert obj;
        
        obj.PDF__c  = true;
        update obj;
        
        List<PartnerNetworkConnection> connMap=[select 
                                                   Id, ConnectionStatus, ConnectionName 
                                                from
                                                   PartnerNetworkConnection 
                                                where 
                                                   ConnectionName =:Label.CB_Partner_Network_Connection AND ConnectionStatus = 'Active'];

  List<PartnerNetworkRecordConnection> lstShareRecords= new List<PartnerNetworkRecordConnection>(); 

   for(PartnerNetworkConnection network : connMap)

    { 
        PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
        newrecord.ConnectionId = network.Id;
        newrecord.LocalRecordId = obj.Case__c;
        newrecord.SendClosedTasks =false;
        newrecord.SendOpenTasks = false;
        newrecord.SendEmails = false;     
        lstShareRecords.add(newrecord);

    }
        insert lstshareRecords;
         CB_CRDBuildOrder_TriggerHandler.partnerConnectionCreated(connMap,obj);  
  }   
                                                          
}