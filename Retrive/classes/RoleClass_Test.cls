@isTest
private class RoleClass_Test {
         
        
        static testmethod void testruleCriteria(){
        
            // Create dummy data for test purposes.
            Role_Heirarchy__c sec = new Role_Heirarchy__c(
                role__c= 'Test Role'
                );         
            try{
                insert sec;
            }catch(Exception ex){
                system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Role_Page;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            RoleClass bsExt = new RoleClass(controller);                       
            RoleClass.RoleWrapper wrp = new RoleClass.RoleWrapper();
            RoleClass.RoleWrapper wrp1 = new RoleClass.RoleWrapper();
            wrp.getRole();
            wrp.getIndex();
            bsExt.RoleList.add(wrp);
            bsExt.RoleList.add(wrp1);
            bsExt.getRoleList();
            bsExt.save();
            bsExt.addNewRecord();
            bsExt.deleteRow();
            bsExt.clear();
                     
                
           Test.stoptest();
        } 
        static testmethod void testruleCriteria_Save(){
        
            // Create dummy data for test purposes.
            Role_Heirarchy__c sec = new Role_Heirarchy__c(
                role__c= 'Test Role'
                );         
            try{
                insert sec;
            }catch(Exception ex){
                system.debug('Exception --'+ex);
            }
            List<Role_Heirarchy__c> tempList1 = new List<Role_Heirarchy__c>();
         Role_Heirarchy__c sec1 = new Role_Heirarchy__c(name__c = 'Test Report');
         try{
         	tempList1.add(sec1);
         	tempList1.add(sec1);
              insert sec1;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
         
           Test.startTest();
            PageReference pageRef = Page.Role_Page;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            RoleClass bsExt = new RoleClass(controller);                       
            RoleClass.RoleWrapper wrp = new RoleClass.RoleWrapper();           
            bsExt.save();                 
                
            Test.stoptest();
        }   
         static testmethod void testruleCriteria_Excep(){
        
            // Create dummy data for test purposes.
            Role_Heirarchy__c sec = new Role_Heirarchy__c(
                role__c= 'Test Role'
                );         
            try{
                insert sec;
            }catch(Exception ex){
                system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Role_Page;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delRow',sec.Id+'Hi');
            ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            RoleClass bsExt = new RoleClass(controller);                       
            RoleClass.RoleWrapper wrp = new RoleClass.RoleWrapper();            
            bsExt.RoleList.add(wrp);            
            bsExt.deleteRow();         
                
           Test.stoptest();
        }                         
        static testmethod void testruleCriteria_Excep1(){
        
            // Create dummy data for test purposes.
            Role_Heirarchy__c sec = new Role_Heirarchy__c(
                role__c= 'Test Role'
                );         
            try{
                insert sec;
            }catch(Exception ex){
                system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Role_Page;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delRow',sec.Id+'Hi');
            ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            RoleClass bsExt = new RoleClass(controller);                       
            RoleClass.RoleWrapper wrp = new RoleClass.RoleWrapper();
            bsExt.addNewRecord();            
            bsExt.RoleList.add(wrp);            
            Test.stoptest();
        }   
         static testmethod void testReportController_ExcepAddNewFunc(){
         Role_Heirarchy__c sec = new Role_Heirarchy__c(
                role__c= 'Test Role'
                );         
            try{
                insert sec;
            }catch(Exception ex){
                system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Role_Page;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delRow',sec.Id+'Hi');
            ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            RoleClass bsExt = new RoleClass(controller);                       
            RoleClass.RoleWrapper wrp = new RoleClass.RoleWrapper();
            bsExt.RoleList.add(wrp);
             bsExt.deleteRow();
            bsExt.RoleList = null;            
            bsExt.addNewRecord();        
            }                    
}