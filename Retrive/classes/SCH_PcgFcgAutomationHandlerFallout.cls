/*Purpose: Apex Class to schedule BAC_PcgFcgAutomationHandlerFallout class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Abhishek            10/27/2014           Apex Class to schedule BAC_PcgFcgAutomationHandlerFallout class 

======================================================================== */
global class SCH_PcgFcgAutomationHandlerFallout implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executeBatch(new BAC_PcgFcgAutomationHandlerFallout ());
    }
}