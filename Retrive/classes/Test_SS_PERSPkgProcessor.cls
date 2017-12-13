/**
Secondary test class for PERS Package Processor batch class.
 */
@isTest
private class Test_SS_PERSPkgProcessor {

    static testMethod void fullTest() {
        prepareTest();
         //including an existing provline for the same value
        Id caseId=[select Id from case where rxplanid1__c='312456789' AND caseAutomationReason__c='AIPkgNewRxplanid'][0].Id;
         
        datetime myDate = datetime.newInstance(1960, 2, 17);
       // insert (new Provisional_Lines__c(controlplaneffective__c='1234567AA2013-11-02',Case__c=caseId,NEW_PROV_NUM__c=2,NEW_LINE_VAL_NO__c=134,Persreporttimestamp__c=myDate,BNFT_STATUS_CD__c='SS',Key__c=caseId+'2'+'134'));
        
        Test.startTest();
            invokeBatch();
        Test.stopTest();
        
        //dataviews
        system.debug(logginglevel.error,'PERSreports:'+[select Id,CA_ControlPlan__c,ROWID__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Pers_report__c]);
        system.debug(logginglevel.error,'ProvLines:'+[select Key__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c,case__c,BNFT_STATUS_CD__c from Provisional_Lines__c]);
        system.debug(logginglevel.error,'Error records:'+[select Id,subject__c,Error_Description__c from Error_Log__c]);
        
        //assertions
        
        //for this case there have to be 3 provlines. Dec release changed it from 2 to 3
               system.debug(logginglevel.error,'CaseId:'+CaseId);

                system.debug(logginglevel.error,'PERSreportsforCase:'+[select Case__c,ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:caseId]);

        system.assert([select ControlPlanEffective__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:caseId].size()==3);
        system.assert([select ControlPlanEffective__c,BNFT_STATUS_CD__c,NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:caseId AND NEW_PROV_NUM__c=2 AND NEW_LINE_VAL_NO__c=134 ][0].BNFT_STATUS_CD__c=='BB');//BB is the newest one. For package= we only case about NEW_PROV_NUM to find dupes so even if plansummary is different we will only get one record.
        //system.assert([select Id from Error_Log__c].isEmpty());
        
        //Feb release. Prov and line values are now unique by CaseId+ProvLine only. E.g dedupe records based on caseId+ProvLine and then upsert based on the timestamps.
        system.assert([select NEW_LINE_VAL_NO__c from Provisional_Lines__c where Case__c=:caseId AND ControlPlanEffective__c='1234567AA2015-11-02'][0].NEW_LINE_VAL_NO__c==114);// 144 LV should have replaced LV 113. Since it's orderd by Name.
    }
    
    private static void prepareTest(){
        
        insert Test_DataGen_CaseAutomation.CaseGenerator();
        insert Test_DataGen_CaseAutomation.PERSreportGen();
        insert Test_DataGen_CaseAutomation.caseCtlrPlanGen();   
        
        //december release
        //inserting a pers record that will have the same controlplan but different effectivedates.
        insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2014-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2014-11-02'))); //this record will overwrite the previous one so shall not increase the count of records
        insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2015-11-02',NEW_PROV_NUM__c=9,NEW_LINE_VAL_NO__c=113,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2015-11-02'))); //this record will match the case, but because prov and lv are diff-creates a new record.
        
        //Feb release
        insert (new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2015-11-02',NEW_PROV_NUM__c=9,NEW_LINE_VAL_NO__c=114,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2015-11-02'))); //this record will match the case, but because prov and lv are diff- tries to create a new record, but finds the one created above. Updates it's line value.
    }
    
    private static Id invokeBatch(){
           Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
            //get all field names
            Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
            String qry='';
            for(String s:FieldsMap.keyset()){
               qry+=s+',';
            }
            qry=qry.left(qry.length()-1); //removing the extra comma
                    
            String s='SELECT '+qry+' FROM PERS_report__c where  NEW_TPID_VAL__c!=NULL AND Processed__c=False ORDER BY Name DESC';//This may change
            BAT_PERSPkgProcessor bch=new BAT_PERSPkgProcessor(s);
            ID batchprocessid= Database.executeBatch(bch,200);
            return batchprocessid;
  
    }
}