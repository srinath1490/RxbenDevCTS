/*Purpose: Apex Class to schedule AIandCVS batch Classes    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Joognu Rao      20/6/2014           Apex Class to schedule AIandCVS batch Classes

======================================================================== */
global class SCH_CB_SendAIandCVS implements Schedulable {
    global void execute(SchedulableContext sc) {
        
            Database.executebatch(new BAC_CB_CRDXMLStep (), 1);
        
            BAC_CB_MassSend2AI.execute();
        
            Database.executebatch(new BAC_CB_ShareCases(), 200);

    }
}