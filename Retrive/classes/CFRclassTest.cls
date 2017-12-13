@isTest
public class CFRclassTest{
    
    static testmethod void testCFRTestclass(){ 
        
            // Create dummy data for test purposes.
            CustomFields__c sec = new CustomFields__c(
                Field_Name__c= 'Test fiest'
                ); 
                CustomObjects__c cobj = new CustomObjects__c(Enable_History__c = true);        
            try{
              insert sec;
              insert cobj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.CFR;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
         ApexPages.currentPage().getParameters().put('CF00N90000002c5mc_lkid', cobj.Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            CFRclass bsExt = new CFRclass (controller);                       
            CFRclass.Customfieldwrapper wrp = new CFRclass.Customfieldwrapper ();
            wrp.co = cobj;
            wrp.co.Enable_History__c=false;
            bsExt.FieldList.add(wrp);
            wrp.getcustomSetting();
            wrp.getIndex();
             bsExt.FieldList.add(wrp);
            bsExt.getFieldList();
            bsExt.save();
            bsExt.addNewRecord();
            //bsExt.checkHistoryTracking();
             bsExt.deleteRow();
            bsExt.clear();
                    
                
         Test.stoptest();
         }
         
         static testmethod void testCFRTestclass_Excep(){
        
            // Create dummy data for test purposes.
            CustomFields__c obj= new CustomFields__c(
                Field_Name__c= 'Test fiest'
                );         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
         ApexPages.currentPage().getParameters().put('delRow', obj.Id+'Hi');
         ApexPages.currentPage().getParameters().put('retURL', 'hi'); 
          PageReference pageRef = Page.CFR;
         Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            CFRclass bsExt = new CFRclass (controller);                       
            CFRclass.Customfieldwrapper wrp = new CFRclass.Customfieldwrapper ();                   
            bsExt.deleteRow();
    
    
        }           
         static testmethod void testCFRTestclass_ExcepSave(){
         list <CustomFields__c> records =  new list<CustomFields__c>();
            CustomFields__c obj= new CustomFields__c(
                Field_Name__c= 'Test fiest'
                );       
            try{
              records.add(obj);
              records.add(obj);
              insert records;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            

            PageReference pageRef = Page.CFR;
         Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            CFRclass bsExt = new CFRclass (controller);                       
            CFRclass.Customfieldwrapper wrp = new CFRclass.Customfieldwrapper ();                                    
            bsExt.save();
        }        
           
         static testmethod void testCFRTestclass_ExcepAddFunc(){
            CustomFields__c obj= new CustomFields__c(
                Field_Name__c= 'Test fiest'
                );         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.CFR;
         Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            CFRclass bsExt = new CFRclass (controller);                       
            CFRclass.Customfieldwrapper wrp = new CFRclass.Customfieldwrapper ();                          
            bsExt.FieldList= null;
            bsExt.addNewRecord();
        }           
}