/*Purpose: Apex Test Class for VFP_FormularyListController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/9/2011       Apex Test Class for VFP_FormularyListController.
======================================================================== 
*/
@isTest
Private class TEST_FormularyListController{
    static testmethod void testNewFormularyList(){
         GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
         Option_Code__c optionCode = testdata.newoptionCode();
          insert optionCode;
           // Instanciate  New Formulary List Page
         PageReference newFormularyList = Page.VF_FormularyListCreation  ;        
         Test.setCurrentPage(newFormularyList);                                     
         
         //Instanciate Controller                 
         ApexPages.StandardController s = new ApexPages.standardController(new Formulary_List__c());        
         VFP_FormularyListController controller = new VFP_FormularyListController(s);
         
         controller.addrow();
         controller.deleteRow();
         controller.addrow();
         Integer count=controller.junctionList.size()-1;
         System.debug('List::::::::::::::::::::'+controller.junctionList);
         controller.junctionList[count].check = true;
         System.debug('List::::::::::::::::::::'+controller.junctionList);

         controller.deleteRow();
         System.debug('In DELETE:::::::::::::::::::::');
         controller.addrow();

         controller.redirectToSearch();
         controller.formularyList=  testdata.newFormularyList(optionCode.Id);
         controller.junctionList[0].listEntry.GPI__c ='1234*';
         controller.junctionList[0].listEntry.NDC__c ='12345*';
         controller.saveFormularyList();
         controller.junctionList[0].listEntry.MS_Code_M__c =false;
         controller.junctionList[0].listEntry.MS_Code_N__c= false;
         controller.junctionList[0].listEntry.MS_Code_O__c= false;
         controller.junctionList[0].listEntry.MS_Code_Y__c= false;
         controller.saveFormularyList();
         
         ApexPages.StandardController s1 = new ApexPages.standardController(new Formulary_List__c());        
         VFP_FormularyListController controller1 = new VFP_FormularyListController(s1);
         controller1.formularyList=  testdata.newFormularyList(optionCode.Id);
         controller1.junctionList[0].listEntry.GPI__c ='1234';
         controller1.junctionList[0].listEntry.NDC__c ='123';
         controller1.addrow();
         controller1.junctionList[1].listEntry.GPI__c ='123';
         controller1.junctionList[1].listEntry.NDC__c ='123456';
         controller1.addrow();
         
         controller1.junctionList[2].listEntry.GPI__c ='12345';
         controller1.junctionList[2].listEntry.NDC__c ='1234567890';  
         controller1.addrow();
         controller1.junctionList[3].listEntry.GPI__c ='1234567';
         controller1.junctionList[3].listEntry.NDC__c ='1234567890*';   
         controller1.addrow();
         controller1.junctionList[4].listEntry.GPI__c ='123456789';
         controller1.junctionList[4].listEntry.NDC__c ='12345678a*';
         controller1.addrow();
         controller1.junctionList[5].listEntry.GPI__c ='12345678901';
         controller1.junctionList[5].listEntry.NDC__c ='123456789*';
         controller1.addrow();
         controller1.junctionList[6].listEntry.GPI__c ='1234567890123';
         controller1.junctionList[6].listEntry.NDC__c ='123456789*'; 
         controller1.addrow();
         controller1.junctionList[7].listEntry.GPI__c ='1234567890123*';
         controller1.junctionList[7].listEntry.NDC__c ='123456789*';
         controller1.addrow();
         controller1.junctionList[8].listEntry.GPI__c ='12345678901a*';
         controller1.junctionList[8].listEntry.NDC__c ='123456789*'; 
         controller1.junctionList[8].listEntry.Action__c ='Message Only';                 
         controller1.saveFormularyList();
             }   
             
        static testmethod void testNewFormularyListtrigger(){
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
        Option_Code__c optionCode1 = testdata.newoptionCode();
          insert optionCode1;
            Formulary_List__c testformulary1 = testdata.newFormularyList(optionCode1.Id);
            insert testformulary1;
            testformulary1.inactive__c=true;
            update testformulary1;
        }
}