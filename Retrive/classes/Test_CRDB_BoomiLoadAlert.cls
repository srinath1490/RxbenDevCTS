@isTest
public class Test_CRDB_BoomiLoadAlert {
    static testMethod void simpletest(){
      CRDB_BoomiLoadAlert alerter=new CRDB_BoomiLoadAlert();
      alerter.verifyLoad();
    }   
    static testMethod void simpletest2(){
      insert new CRDBuildOrder__c();
      CRDB_BoomiLoadAlert alerter=new CRDB_BoomiLoadAlert();
      alerter.verifyLoad();
    }  
    
    static testmethod void crontest() {
             String CRON_EXP = '0 0 0 3 9 ? 2022';

       Test.startTest();
          // Schedule the test job
    
          String jobId = System.schedule(	'CRDB_BoomiLoadAlert',
          									CRON_EXP, 
             								new CRDB_BoomiLoadAlert()
                                        );
    
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
    
          // Verify the expressions are the same
          System.assertEquals(CRON_EXP, 
             ct.CronExpression);
    
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered);
    
          // Verify the next time the job will run
          System.assertEquals('2022-09-03 00:00:00', 
             String.valueOf(ct.NextFireTime));
 
    
       Test.stopTest();
   }
}