@isTest
private class queueController_Test {
         
        
        static testmethod void testqueueController(){
        
            // Create dummy data for test purposes.
            Queue__c sec = new Queue__c(Queue_Name__c= 'Test QueueName');         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
         ApexPages.currentPage().getParameters().put('retURL', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            queueController bsExt = new queueController(controller);                       
            queueController.QueueWrapper wrp = new queueController.QueueWrapper();
            wrp.getQueue();
            wrp.getIndex();
            bsExt.getQList();
            bsExt.qList.add(wrp);
            bsExt.save();
            bsExt.add();
            bsExt.delRecords(); 
            bsExt.clear();
                    
                
         Test.stoptest();
        }  
         static testmethod void testqueueController_Excep(){
           // Create dummy data for test purposes.
            Queue__c sec = new Queue__c(
                Queue_Name__c= 'Test QueueName'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            queueController bsExt = new queueController(controller);                       
            queueController.QueueWrapper wrp = new queueController.QueueWrapper();           
            bsExt.delRecords(); 
   
                    
        }  
        
         static testmethod void testqueueController_ExcepAddFunc(){
           // Create dummy data for test purposes.
            Queue__c sec = new Queue__c(
                Queue_Name__c= 'Test QueueName'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
           Test.setCurrentPageReference(pageRef);
           ApexPages.currentPage().getParameters().put('delRow', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            queueController bsExt = new queueController(controller);                       
            queueController.QueueWrapper wrp = new queueController.QueueWrapper();                                   
            bsExt.qList= null;
            bsExt.add();
        }                     
}