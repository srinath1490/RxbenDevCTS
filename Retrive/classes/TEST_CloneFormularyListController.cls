/*Purpose: Apex Class for Cloning the Formulary List
========================================================================
History                                                           
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Formulary List
======================================================================== 
*/            
 @isTest            
 private class TEST_CloneFormularyListController{
    static testMethod void testCloneFormularyList(){ 
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
  
          //Test data
          Option_Code__c oc = testdata.newoptionCode();
          insert oc;
          Formulary_List__c fl = testdata.newFormularyList(oc.Id);      
          insert fl;
          Formulary_List_Entry__c fle = testdata.newFormularyListEntry(5,fl.id);
          fle.GPI__c = '12*';  
          insert fle;
          Forms__c testform = testdata.CriteriaForm();
          testform.recordtypeid='01250000000UIHn';
          insert testform;
          Form_Junction__c fjunc = new Form_Junction__c();
          fjunc.Form_ID__c=testform.id;
          fjunc.Formulary_List_Entry_ID__c=fle.id;
          insert fjunc;
          
          // Instanciate  the VF page    
          PageReference  VFPage= Page.VF_CloneFormularyList;  
             Test.setCurrentPage(VFPage); 
                        
          //instanciate Apex Controller           
          ApexPages.StandardController s = new ApexPages.standardController(fl);   
          VFP_CloneFormularyListController controllerClass = new VFP_CloneFormularyListController(s);     
               controllerClass.redirect();    
               controllerClass.previouspage();     
    }
 }