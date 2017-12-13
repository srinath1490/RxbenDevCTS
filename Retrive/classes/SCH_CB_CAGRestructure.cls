/*Purpose: Apex Class to schedule BAC_CB_CAGRestructure class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Nitish         10 JUne 2016          Apex Class to schedule BAC_CB_CAGRestructure class 

======================================================================== */
global class SCH_CB_CAGRestructure implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executeBatch(new BAC_CB_CAGRestructure(), 50);
    }
}