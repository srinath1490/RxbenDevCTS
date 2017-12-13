/*Purpose: Apex Class to schedule BAC_Callout class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            10/9/2013           Apex Class to schedule BAC_BCTNotificationCallout class 

======================================================================== */
global class SCH_BCTNotificationCallout implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executeBatch(new BAC_BCTNotificationCallout(), 1);
    }
}