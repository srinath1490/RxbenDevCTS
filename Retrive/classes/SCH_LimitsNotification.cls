/*Purpose: Apex Class to schedule class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                       DATE                DETAIL                                 
   1.0 -   Sandeep Saklani            28/09/2016         Apex Class to schedule  class 

======================================================================== */
global class SCH_LimitsNotification implements Schedulable {
    /* 
     * Method :- execute
     * Description :- This Method is a batch schedulde method
     */   
    global void execute(SchedulableContext sc){
        
        DataStorage_FetchOrgLimits.StorageDetails();
    }
}