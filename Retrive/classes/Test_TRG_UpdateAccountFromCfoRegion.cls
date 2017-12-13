@isTest
private class Test_TRG_UpdateAccountFromCfoRegion{


 static testMethod void testUpdateAccountFromCfoRegion()
 {
  
     Account acc=new Account();
     
               acc.name='Aetna National Sales';
                acc.CFO_CD__c = '234';
                acc.Market_Region__c = 'NE';
                acc.APM_CFO__c = 'New York';
                acc.Region__c = 'Northeast';
                insert(acc);
               
               CFO_Region__c cfoRegion = new  CFO_Region__c();
    
                cfoRegion.CFO__c = '123';
                cfoRegion.Market_Region__c = 'NR';
                cfoRegion.APM_CFO__c = 'SFDC Testing 13';
                cfoRegion.Region__c = 'Northeast';
                 insert cfoRegion;
     
     
    
      Account a=[Select id from Account where name='Aetna National Sales' limit 1];
      acc.id=a.id;        
      acc.CFO_CD__c=cfoRegion.CFO__c;
      acc.APM_CFO__c=cfoRegion.APM_CFO__c;
      acc.Market_Region__c=cfoRegion.Market_Region__c;
      acc.Region__c=cfoRegion.Region__c;
      update acc;
        
 
 }
 
}