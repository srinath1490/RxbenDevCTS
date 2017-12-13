@isTest
private class TEST_ActualLOEAfterUpdate {
  //Test method for the crd cloning functionality
     static testMethod void testActualLOE() {
        Request__c testRequest = new Request__c();
            testRequest.Request_Type__c ='Build';
            testRequest.Request_Title__c='Test Request';
            testRequest.Request_Description__c = 'Test Description';
            testRequest.Status__c ='New';
            //testRequest.Name_of_the_Requester__c = userinfo.getuserid();
            insert testRequest;
            
        IDC_Task__c testTask = new IDC_Task__c();
            testTask.Request__c = testRequest.id;
            testTask.Assigned_To__c = Userinfo.getUserid();
            testTask.Assigned_Date__c= System.today();
            testTask.Priority__c ='Medium';
            testTask.Status__c= 'Not Started';
            testTask.Task_Type__c='Design';
            testTask.Task_Description__c='Test';
            testTask.Comments__c='Test';
            insert testTask;
        
        Actual_Level_of_Effort__c testALOE = new Actual_Level_of_Effort__c();
            testALOE.Task_ID__c= testTask.id;
            testALOE.Requirement__c=testRequest.id;
            testALOE.Name__c=Userinfo.getUserid();
            testALOE.Role__c='Development Resource';
            testALOE.Week__c=System.today();
            testALOE.Plan__c = 5;
            testALOE.Build__c= 6;
            testALOE.Test__c=2;
            testALOE.UAT__c=2;
            testALOE.Deploy__c=2;
            testALOE.Adapt_Ongoing_Support__c=2;
            testALOE.Design__c=2;
            insert testALOE;
        
        Actual_Level_of_Effort__c testALOE1 = new Actual_Level_of_Effort__c();
            testALOE1.Task_ID__c= testTask.id;
            testALOE1.Requirement__c=testRequest.id;
            testALOE1.Name__c=Userinfo.getUserid();
            testALOE1.Role__c='Development Resource';
            testALOE1.Week__c=System.today();
            testALOE1.Plan__c = 5;
            testALOE1.Build__c= 6;
            testALOE1.Test__c=2;
            testALOE1.UAT__c=2;
            testALOE1.Deploy__c=2;
            testALOE1.Adapt_Ongoing_Support__c=2;
            testALOE1.Design__c=2;
            insert testALOE1; 
         
            testALOE1.Design__c=5;
            update testALOE1;
        
     }     
}