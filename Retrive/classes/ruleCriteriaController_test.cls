@isTest
private class ruleCriteriaController_test {
         
        
        static testmethod void testruleCriteria(){
        
            // Create dummy data for test purposes.
            Rule_Criteria__c sec = new Rule_Criteria__c(
                operator__c= 'Test Rule'
                );         
            try{
            	insert sec;
            }catch(Exception ex){
            	system.debug('Exception --'+ex);
            }
            Test.startTest();
            PageReference pageRef = Page.RuleCriteriaPage;
   			Test.setCurrentPageReference(pageRef);
   			ApexPages.currentPage().getParameters().put('delRow', '1');
   			ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ruleCriteriaController bsExt = new ruleCriteriaController(controller);                       
            ruleCriteriaController.ruleCriteriaWrapper wrp = new ruleCriteriaController.ruleCriteriaWrapper();
            wrp.getruleCriteriaObj();
            wrp.getIndex();
            bsExt.ttList.add(wrp);
           bsExt.save();
           bsExt.add();
           bsExt.clearRecord();
           bsExt.ttList.add(wrp);
           bsExt.delRecords();
                
    		Test.stoptest();
        }  
         static testmethod void testruleCriteria_Excep(){
        
            // Create dummy data for test purposes.
            Rule_Criteria__c sec = new Rule_Criteria__c(
                operator__c= 'Test Rule'
                );         
            try{
            	insert sec;
            }catch(Exception ex){
            	system.debug('Exception --'+ex);
            }
            Test.startTest();
            PageReference pageRef = Page.RuleCriteriaPage;
   			Test.setCurrentPageReference(pageRef);
   			ApexPages.currentPage().getParameters().put('delRow', sec.Id+'Hi');
   			ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ruleCriteriaController bsExt = new ruleCriteriaController(controller);                       
             ruleCriteriaController.ruleCriteriaWrapper wrp = new ruleCriteriaController.ruleCriteriaWrapper();
           bsExt.ttList.add(wrp);
           bsExt.getttList();
           bsExt.delRecords();
                
    		Test.stoptest();
    		 bsExt.ttList.clear();
    		 bsExt.save();
        }                
}