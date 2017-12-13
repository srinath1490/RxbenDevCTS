@isTest
public class AssignmentClassTest{
static testmethod void AssignmentTestClass(){
Assignment_Rule__c obj= new Assignment_Rule__c ();      
  //calling the methods
  // Create dummy data for test purposes.
            Assignment_Rule__c sec = new Assignment_Rule__c(
                    Rule_Name__c = 'Test Assignment'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception 1--'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Assignment_Page;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
         ApexPages.currentPage().getParameters().put('retURL', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            AssignmentClass obj1= new AssignmentClass (controller);                       
            AssignmentClass.AssignmentWrapper wrp = new AssignmentClass.AssignmentWrapper();
            obj1.AssignmentList.add(wrp);
        obj1.getAssignmentList();
        obj1.save();
        obj1.addNewRecord();
        obj1.deleteRow();
        obj1.clear();       
        wrp.getIndex();
        wrp.getAssignmentRule();
   }
    static testmethod void testObjectPermissionClass_ExcepAddFunc(){
           // Create dummy data for test purposes.
            Assignment_Rule__c sec = new Assignment_Rule__c(
                    Rule_Name__c= 'Test Assignment'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Assignment_Page;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            AssignmentClass obj1= new AssignmentClass (controller);                       
            AssignmentClass.AssignmentWrapper wrp = new AssignmentClass.AssignmentWrapper();                       
            obj1.AssignmentList= null;
            obj1.addNewRecord();
        }    
     static testmethod void testObjectPermissionClass_ExcepDeleteFunc(){
           // Create dummy data for test purposes.
            Assignment_Rule__c sec = new Assignment_Rule__c(
                    Rule_Name__c= 'Test Assignment'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.Assignment_Page;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            AssignmentClass obj1= new AssignmentClass (controller);                       
            AssignmentClass.AssignmentWrapper wrp = new AssignmentClass.AssignmentWrapper();                       
            obj1.deleteRow();
        }
        
        static testMethod void myAssignProfileIdTabSettingTest(){
            Profile__c testrec = new Profile__c(Profile_Name__c = 'testtprofile');    
            insert testrec;            
            list<Profile__c> customobjs=new list<Profile__c>([Select Id, Profile_Name__c from Profile__c limit 1]);
            TabSetting__c tabSetting = new TabSetting__c();
            tabSetting.ProfileName__c = customobjs.get(0).id;
            tabSetting.Profile__c=customobjs.get(0).id;
            tabSetting.Name__c='test@123';
            insert tabSetting; 
            
        }                     
}