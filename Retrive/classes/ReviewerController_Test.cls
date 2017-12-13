@isTest
private class ReviewerController_Test {
         
        
        static testmethod void testReviewerController(){
        
            // Create dummy data for test purposes.
            Reviewer__c sec = new Reviewer__c();
             //   Name = 'Test Review'
                        
            /*try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }*/
           Test.startTest();
            PageReference pageRef = Page.Reviewer;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReviewerController bsExt = new ReviewerController(controller);                       
            ReviewerController.ReviewerWrapper wrp = new ReviewerController.ReviewerWrapper();
            wrp.getReview();
            wrp.getIndex();
            bsExt.ReviewList.add(wrp);
            bsExt.getReviewList();
            bsExt.saveRecords();
            bsExt.addRecord();
            bsExt.clear();
            bsExt.deleteRow();         
                
         Test.stoptest();
        }  
         static testmethod void testReviewerController_Excep(){
            // Create dummy data for test purposes.
            Reviewer__c sec = new Reviewer__c();
               /* Name = 'Test Review'*/
                  
           /* try{
              /*insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }*/
           Test.startTest();
            PageReference pageRef = Page.Reviewer;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', sec.Id+'Hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReviewerController bsExt = new ReviewerController(controller);                       
            ReviewerController.ReviewerWrapper wrp = new ReviewerController.ReviewerWrapper();
            bsExt.ReviewList.add(wrp);
            bsExt.deleteRow();         
        }                
         static testmethod void testReviewerController_Excep1(){
            // Create dummy data for test purposes.
            Reviewer__c sec = new Reviewer__c();
              /*  Name = 'Test Review'
               );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }*/
           Test.startTest();
            PageReference pageRef = Page.Reviewer;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
          
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReviewerController bsExt = new ReviewerController(controller);                       
            ReviewerController.ReviewerWrapper wrp = new ReviewerController.ReviewerWrapper();
            bsExt.ReviewList.add(wrp);
            bsExt.deleteRow(); 
        }                
}