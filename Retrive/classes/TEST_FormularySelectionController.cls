/*Purpose: Apex Test Class for VFP_FormularySelectionController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Sourabh                 1/11/2012       Apex Test Class for VFP_FormularySelectionController.
======================================================================== 
*/
@isTest
private class TEST_FormularySelectionController {

    static testMethod void myUnitTest() {
          list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
          CRD__c testCrd = new CRD__c();
          testCrd.crd_automated__c=True;
          insert testCrd;
          
          Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
          drugCoverateItem.CRD_ID__c = testCrd.id;
          drugCoverateItem.RecordTypeId=rt.get(0).id;
          drugCoverateItem.Do_you_have_Choose_Generic__c='No';
          //drugCoverateItem.Mandatory_Generic_Copay_Diff_Exclusion__c = ; 
          
          drugCoverateItem.Formulary_Open_Closed__c='Open';       
          insert drugCoverateItem;
          
          PageReference customFormularyLookup = Page.VF_CRDFormularyLookup;
          customFormularyLookup.getParameters().put('crdid',testCrd.id);    
          customFormularyLookup.getParameters().put('closeOpenValue',testCrd.id);
          customFormularyLookup.getParameters().put('recordTypeName',testCrd.id);
          Test.setCurrentPage(customFormularyLookup); 
          ApexPages.StandardController stCon = new ApexPages.standardController(testCrd);
          VFP_FormularySelectionController controller = new VFP_FormularySelectionController(stCon);
                   
    }
}