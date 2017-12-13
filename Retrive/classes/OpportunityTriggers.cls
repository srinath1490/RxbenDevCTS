/*
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
1.1	-  		Jenna Vuong     03-25-15    		removed code creating new case when Opportunity of 'Rx Clinical Program' rt is closed won. We
												only need to create new case when Rx_Clinical_Program_Opp__c is closed won.
======================================================================== */

public class OpportunityTriggers {
	
    /* 3/25/14 - JV - removed code, no longer need to create new case when opportunity of Rx Clinical Program rt is closed won
	public static void SaleofClinicalProgramNewCase (List <Opportunity> Opps, Map<String,String> AcctTeams, Map<String,String> RecordTypes, Map<String,String> CaseUsers){
		//called in TRG_Opps_After_Insert and Update Triggers
		List<Case> CaseInsertList=new List<Case>();
		
		for(Opportunity opp : opps){
			if(opp.RecordTypeId==RecordTypes.get('Rx Clinical Programs')&&(opp.StageName=='Closed Won')) {
				
			Case c = new Case ();
			c.RecordTypeId=RecordTypes.get('Plan Sponsor Questions or Issues');
			c.Opportunity__c=opp.id;
			c.Subject='New Rx Clinical Program Sold - '+ opp.Name;
			c.Aetna_Case_Type__c='Account Manager Case';
			c.AccountId=opp.AccountId;
			c.Description='Please review the related opportunity and reach out to the field to verify that the required paperwork has been completed and submitted.  Once you have all the relevant information and have determined if an update to a CRD is needed, please work with the BCT Team to ensure the applicable CRDs are updated.';
			c.OwnerId=AcctTeams.get('Pharmacy Account Manager');
			CaseInsertList.add(c);
			}
		}
		insert CaseInsertList;
	} */
	
	public static void CreateSoldCaseWorksheet(List<Opportunity> Opps, Map<String,String> AcctTeams, Map<String,String> RecordTypes) {
	//called in TRG_Opps_After_Insert and Update Triggers
        List<Sold_Case_Worksheet__c> SCWInsertList=new List<Sold_Case_Worksheet__c>();

        for(Opportunity opp : opps){
            if((opp.RecordTypeId==RecordTypes.get('Pharmacy Record'))&& (opp.Stage_Value__c=='Closed Won')&&((opp.Sales_Activity_Type__c=='New Business')||(opp.Sales_Activity_Type__c=='Cross Sale')||(opp.Sales_Activity_Type__c=='Growth'))){
                Sold_Case_Worksheet__c scw = new Sold_Case_Worksheet__c ();
                scw.Account__c=opp.AccountId;
                scw.OwnerId=opp.OwnerId;
                scw.Opportunity__c=opp.Id;
                scw.Rx_AM_Name__c=AcctTeams.get('Pharmacy Account Manager');
                scw.SAE_Name__c=AcctTeams.get('Strategic Account Executive');
                scw.VPCM_Name__c=opp.OwnerId;
                scw.Membership__c=opp.Total_Membership_Opportunity__c;
                scw.Region__c=opp.Account_Segment__c;
                scw.Region__c=opp.Account_Region__c;
                scw.Effective_Date__c=opp.APM_Membership_EffectiveDate__c;
                scw.Segment__c=opp.Account_Segment__c;
                scw.Funding__c=opp.Funding__c;
                scw.Prior_Carrier__c=opp.Current_PBM__c;
                scw.Consultant_Name__c =opp.APM_Consultant__c;
                scw.Aetna_Medical_Contact__c=opp.Aetna_Medical_Contact__c;
                SCWInsertList.add(scw);
                //insert scw;
            }
        }
        insert  SCWInsertList;

  }

}