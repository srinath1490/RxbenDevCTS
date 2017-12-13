@isTest
Global class testBIT_CRD_Coding_Cloning_Button {
static testmethod void validateStandardController(){
BIT_CRD_Coding_Instructions__c  testrec = new BIT_CRD_Coding_Instructions__c ();
insert testrec;
ApexPages.StandardController sc = new ApexPages.StandardController(testrec );
        BIT_CRD_Coding_Cloning_Button testAccPlan = new BIT_CRD_Coding_Cloning_Button (sc);
testAccPlan.CreateClone();

}
}