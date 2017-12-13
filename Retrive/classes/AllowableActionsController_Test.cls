@isTest

/*
 This is test class for AllowableActionController
 */
private class AllowableActionsController_Test
{
/*
*
*/
 static testMethod void getPiclistValuesTest()
 {
   
   List<String> str1=new List<String>{'Inclusion','Exclusion','Prior Auth','Drug Specific Copay','Waiver of Deductible','Drug Specific Accum','Apply limitations on CRD','Allow Rule to be overridden'};
   System.debug('-------------'+str1);
   List<String> str=AllowableActionsController.getPicklistValues('Drug_Group__c','Allowable_Actions__c');
   System.debug('-------------'+str);
   
   System.assertEquals(str,str);
   
 
 }

}