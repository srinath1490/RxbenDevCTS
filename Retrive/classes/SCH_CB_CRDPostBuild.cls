/*Purpose: Apex Class to schedule BAC_Callout class 
  ========================================================================
  History
  -------                                                        
   VERSION    RequestNumber    AUTHOR          DATE                DETAIL                                   
    1.0 -      04742                Nitish          24/4/2014           Apex Class to schedule BAC_Callout class
  ======================================================================== */
global class SCH_CB_CRDPostBuild implements Schedulable{
	  /*      
	   * Method :- execute    
	   * Description :- This Method is a batch schedulde method     
	   */   
      global void execute (SchedulableContext SC){
         Database.executeBatch(new BAC_CB_SeedPersStep(), 200);
	}
}