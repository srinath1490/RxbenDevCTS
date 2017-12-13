/*Purpose: Apex Class to schedule BAC_Callout class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            4/9/2013           Apex Class to schedule BAC_Callout class 

======================================================================== */
global class SCH_Callout implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executeBatch(new BAC_Callout(), 1);
    }
}