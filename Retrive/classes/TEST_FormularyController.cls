/*Purpose:Apex Test Class for VFP_FormularyController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/8/2011       Apex Test Class for VFP_FormularyController.
======================================================================== 
*/
@isTest
Private class TEST_FormularyController{
    static testmethod void testNewFormulary(){
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
          Option_Code__c optionCode = testdata.newoptionCode();
          insert optionCode;
          Formulary_List__c formularyList = testdata.newFormularyList(optionCode.Id);
          insert formularyList;
        // Instanciate  New Formulary Page
        PageReference newFormulary = Page.VF_FormularyCreation  ;
        Test.setCurrentPage(newFormulary);             
                
        //Instanciate Controller         
        ApexPages.StandardController s = new ApexPages.standardController(new Formulary_Junction__c());
        VFP_FormularyController controller = new VFP_FormularyController(s);
        controller.addRow();
        controller.delRow();
         controller.CustomSave();
         controller.redirectToSearch();
         controller.formulary=testdata.newFormulary();
         controller.junctionList[0].formJunction.Formulary_List__c =formularyList.Id;
         controller.addRow();
         controller.junctionList[1].check = true;
         controller.delRow();
         controller.CustomSave();
         controller.junctionList[0].check = true;
         controller.delRow();
         controller.CustomSave();
         Formulary_Junction__c  fj =  new Formulary_Junction__c();
         Formulary__c testFormulary =testdata.newFormulary();
         insert testFormulary;
         fj.Formulary_List__c = formularyList.Id;
         fj.Formulary__c = testFormulary.Id;
         fj.Priority__c = 1.0;
         fj.Effective_Date__c =system.today();
         fj.Termination_Date__c = system.today() +7;
         insert fj;
         fj.Termination_Date__c = system.today() +10;
         update fj;
     
    }
}