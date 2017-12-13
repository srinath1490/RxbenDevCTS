/*Purpose: Apex Class to schedule class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                       DATE                DETAIL                                 
   1.0 -   Richa Gupta          25/08/2014         Apex Class to schedule class BAC_UpdateCIF

======================================================================== */
global class SCH_BAC_UpdateCIF implements Schedulable {  
    global void execute(SchedulableContext sc){
    	/*SCH_BAC_UpdateCIF schUpdateCIF = new SCH_BAC_UpdateCIF();
		String sch = '0 0 20 * * ?';
		System.schedule('Schedule Update CIF', sch, schUpdateCIF);*/
        ID batchprocessid = database.executeBatch(new BAC_UpdateCIF(),200);
    }

}