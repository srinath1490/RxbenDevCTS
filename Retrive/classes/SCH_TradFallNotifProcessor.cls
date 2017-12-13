/*Purpose: Apex Class to schedule BAT_TradFallNotifProcessor class   
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            11Oct'2013           Apex Class to schedule BAT_TradFallNotifProcessor class 

======================================================================== */
global class SCH_TradFallNotifProcessor implements Schedulable {
    global void execute(SchedulableContext sc) {
        //Query to be passed to BAT_TradFallNotifProcessor class
        String qry='';   
        Schema.DescribeSObjectResult  DescribeRec=NotificationFallout__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> parentFieldsMap= DescribeRec.fields.getMap();
            for (String s:parentFieldsMap.keyset()){
               qry+=s+',';
            }
        qry=qry.left(qry.length()-1); 
        String query = 'SELECT '+qry+ ' FROM NotificationFallout__c WHERE Processed__c=False ORDER BY Name DESC';
        
        //Storing the Batch ID and calling the BAT_TradFallNotifProcessor(String) class
        ID batchprocessid  = database.executeBatch(new BAT_TradFallNotifProcessor(query) );
        
        //Creating a Joblog
        JobLogger.create(NULL,system.now(),'','Batch JobID:' + batchprocessid, NULL, system.now(), True, 'FalloutCases', NULL);
    }
}