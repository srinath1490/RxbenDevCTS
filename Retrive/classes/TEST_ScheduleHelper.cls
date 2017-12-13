/*Purpose: Apex Test Class for VFP_ScheduleHelper.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/24/2011       Apex Test Class for VFP_ScheduleHelper.
======================================================================== 
*/
@isTest
private class TEST_ScheduleHelper
{
    static testmethod void testScheduleHelper()
    {
        ScheduleHelper schhelp=new ScheduleHelper();
        ScheduleHelper.fetchRetailYScheduleValue('AAM','Self Insured','Y4',true);
        ScheduleHelper.fetchMailYScheduleValue('AAM','Fully Insured','Y4',true);
        ScheduleHelper.fetchMailYScheduleValue('AAM','Self Insured','Y4',false);
        ScheduleHelper.fetchRetailYScheduleValue('AAM','Fully Insured','Y4',false);

    }
}