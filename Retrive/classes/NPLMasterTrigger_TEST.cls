@isTest(seeAllData=true)
public class NPLMasterTrigger_TEST {
	    static testMethod void Test_BusinessTimeCalc(){
            Controlling_State__c  c=[select id from Controlling_State__c limit 1][0]; //cannot insert controllling state, don't have testdata.
            insert new NPL_PA_Tracker__c(Controlling_State_LU__c=c.Id,Task_ID__c='90089',Fax_Received_Date_Time__c='09/07/2017 04:04:04',Request_type__c='new',Funding_Type__c='fully Insured',Does_Member_have_Pharmacy_Benefit__c='yes',is_this_a_Buy_and_Bill__c='no',Control__c='1234567',Existing_SOE__c= 'YES',Existing_SOEx__c='2');
        }

}