@isTest
private class SECURITYclass_Test {
         
        
        static testmethod void testSecurity(){
        
            // Create dummy data for test purposes.
            Security__c sec = new Security__c(
                group_name__c= 'Test Security'
                );         
            try{
            	insert sec;
            }catch(Exception ex){
            	system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.security;
   			Test.setCurrentPageReference(pageRef);
   			ApexPages.currentPage().getParameters().put('delRow', '1');
   			ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            SECURITYclass bsExt = new SECURITYclass(controller);
            SECURITYclass.Securitywrapper wrp = new SECURITYclass.Securitywrapper();
            bsExt.Securitylist.add(wrp);
            wrp.getsecuritySetting();
            wrp.getIndex();
            bsExt.getSecuritylist();
    		bsExt.save();
    		bsExt.clear();
    		bsExt.Securitylist.add(wrp);    		
    		bsExt.deleteRow();
    		bsExt.addNewRecord();           
    
        } 
        static testmethod void testSecurity_Excep(){
        
            // Create dummy data for test purposes.
            Security__c sec = new Security__c(
                group_name__c= 'Test Security'
                );         
            try{
            	insert sec;
            }catch(Exception ex){
            	system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.security;
   			Test.setCurrentPageReference(pageRef);
   			ApexPages.currentPage().getParameters().put('delRow', sec.Id+'Hi');
   			ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            SECURITYclass bsExt = new SECURITYclass(controller);
            SECURITYclass.Securitywrapper wrp = new SECURITYclass.Securitywrapper();
            bsExt.Securitylist.add(wrp);             		
    		bsExt.deleteRow();
    		        
    
        } 
         static testmethod void testReportController_ExcepAddNewFunc(){
         Security__c sec = new Security__c(group_name__c = 'Test Report');
         Test.startTest();
            PageReference pageRef = Page.security;
   			Test.setCurrentPageReference(pageRef);
   			ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            SECURITYclass bsExt = new SECURITYclass(controller);
            SECURITYclass.Securitywrapper wrp = new SECURITYclass.Securitywrapper();
            bsExt.Securitylist = null;            
            bsExt.addNewRecord();        }            
}