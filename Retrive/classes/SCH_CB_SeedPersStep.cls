/*Purpose: Apex Class to schedule BAC_CB_SeedPersStep class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            27 Oct 2014          Apex Class to schedule BAC_CB_SeedPersStep class 

======================================================================== */
global class SCH_CB_SeedPersStep implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executeBatch(new BAC_CB_SeedPersStep(), 200);
    }
}