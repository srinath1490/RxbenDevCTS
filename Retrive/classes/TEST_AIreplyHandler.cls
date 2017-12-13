@isTest
public class TEST_AIreplyHandler{
 
 static testmethod void runTest(){
   AIreplyHandler handle=new AIreplyHandler();
   MAP<String,String> s=new MAP<String,String>();
   CRD__c sourceCRD=new CRD__c();
   sourceCRD.OwnerId=UserInfo.getUserId();
   insert sourceCRD;
   s.put('RxPlan_ID_Status__c','New');
   s.put('Effective_Date__c','1987-10-10 00:00:00');
   handle.BCTnotification('1234',s,true,sourceCRD.OwnerId);
   handle.BCTnotification('1234567891011',s,true,sourceCRD.OwnerId);
   handle.BCTnotification('1234',s,true,NULL);
   handle.BCTnotification('1234',s,false,sourceCRD.OwnerId);
   s.remove('Effective_Date__c');
   handle.Rxreply('1234','12',s,sourceCRD);
   handle.Rxreply('DCN','1234567891011',s,sourceCRD);
   handle.Rxreply('DCN','1234567891011',s,NULL);
   handle.errorHandler('sampleerror','Sample Description');
   handle.errorHandler('sampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerrorsampleerror','Sample Description');
   handle.errorHandler('sample error','sample description',sourceCRD);
   handle.errorHandler('sample error','sample description',NULL);
     
 }


}