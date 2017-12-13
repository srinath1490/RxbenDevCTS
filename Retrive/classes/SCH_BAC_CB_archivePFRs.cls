/*Purpose: Apex Class to schedule class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                       DATE                DETAIL                                 
   1.0 -   Richa Gupta          23/02/2015         Apex Class to schedule class BAC_CB_archivePFRs

======================================================================== */
global class SCH_BAC_CB_archivePFRs implements Schedulable {  
    global void execute(SchedulableContext sc){
        ID batchprocessid = database.executeBatch(new BAC_CB_archivePFRs(),1);
    }

}