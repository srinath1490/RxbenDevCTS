/*Purpose: Apex Class to schedule class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                       DATE                DETAIL                                 
   1.0 -   Richa Gupta          30/06/2014         Apex Class to schedule  class 

======================================================================== */
global class SCH_Batch_CRDBuildStep1 implements Schedulable {
    /* 
     * Method :- execute
     * Description :- This Method is a batch schedulde method
     */   
    global void execute(SchedulableContext sc){
        ID batchprocessid = database.executeBatch(new Batch_CRDBuildStep1(),1);
    }
}