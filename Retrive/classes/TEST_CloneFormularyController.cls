/*Purpose: Apex Class for Cloning the Formulary                                        
========================================================================
History                                                            
-------                                                           
 VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Formulary
======================================================================== 
*/
@isTest
 private class TEST_CloneFormularyController{
   static testMethod void testCloneFormularyController(){ 
     GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();   
   
        //Test data
        Option_Code__c oc = testdata.newoptionCode();
        insert oc;
        Formulary__c f1 = testdata.newFormulary();
            f1.Standard__c = true; 
        insert f1;
        Formulary_List__c fl = testdata.newFormularyList(oc.id);          
        insert fl;
        Formulary_Junction__c fj = testdata.createFormularyJunction(fl.id,f1.id);
        insert fj;

       // Instanciate  the VF page    
        PageReference  VFPage= Page.VF_CloneFomulary;    
             Test.setCurrentPage(VFPage);       
       //instanciate Apex Controller            
        ApexPages.StandardController s = new ApexPages.standardController(f1);     
        VFP_CloneFormularyController controllerClass = new VFP_CloneFormularyController(s);  
             controllerClass.redirect();     
             controllerClass.previouspage();    
   }
 }